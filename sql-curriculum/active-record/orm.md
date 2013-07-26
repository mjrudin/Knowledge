# Object Relational Mapping

## Motivation

We've discussed how to manage changes to a SQL database through
migrations. Now we'd like to start using the records stored in that
database.

We've previously worked directly with a database by writing SQL. One
downside was that this embedded SQL code is in our Ruby code; though this
works, it would be nice to work, as much as possible, only in Ruby syntax.

Also, when we fetched data from our SQL database, the data was
returned in generic `Hash` objects. For instance, if our database was
setup like this:

    > CREATE TABLE cars (make VARCHAR(255), model VARCHAR(255), year INTEGER);
    > INSERT INTO cars (model, make, year)
        ("Toyota", "Camry", 1997),
        ("Toyota", "Land Cruiser", 1989),
        ("Citroen", "DS", 1969);

And we wrote the following ruby code to fetch the data:

```ruby
require 'sqlite3'
db = SQLite3::Database.new("cars.db")
db.results_as_hash = true
db.type_translation = true
  
cars = db.execute("SELECT * FROM cars")
# => [
  {"make" => "Toyota", "model" => "Camry", "year" => 1997},
  {"make" => "Toyota", "model" => "Land Cruiser", "year" => 1989},
  {"make" => "Citroen", "model" => "DS", "year" => 1969}
]
```

That works nicely, but what if we wanted to store and load objects of
a `Car` class? Instead of retrieving generic `Hash` objects, we want
to get back instances of our `Car` class. Then we could call `Car`
methods like `go` and `vroom`. How would we translate between the
world of Ruby classes and rows in our database?

## What is an ORM?

The *object relational mapping* is the system that translates between
SQL records and Ruby objects; an ORM translates rows from your SQL
tables into Ruby objects on fetch, and translates your Ruby objects
back to rows on save. The ORM also empowers your Ruby classes with
convenient methods to perform common SQL operations: for instance, if
the table `physicians` contains a foreign key referring to `offices`,
ActiveRecord will give your `Physician` class a method, `#office`
which will fetch the associated record. Using ORM, the properties and
relationships of the objects in an application can be easily stored
and retrieved from a database without writing SQL statements directly
and with less overall database access code.

Note: ORM is when you map data from some data store into an object.
ActiveRecord is an example of ORM where we are mapping rows from a 
relational database into objects. Rails's ActiveRecord is named after
the [*active record design pattern*][ar-pattern-wiki]. The active 
record pattern is an implementation of ORM where we are simply mapping 
rows from a relational database into objects.
[ar-pattern-wiki]:https://en.wikipedia.org/wiki/Active_record_pattern

## `ActiveRecord::Base`

Each table has an associated *model* class; a model represents some
entity or part of the problem you're working with: for instance, a
`Physician` or an `Office`. Model instances have associated data (like
a name or an address) which is stored (or *persisted*) in the
database.

So, if we had a table named `physicians`, we would create a model
class like so:

```ruby
class Physician < ActiveRecord::Base
end
```

By convention, we define this class in `app/models/physician.rb`. The
`app/models` directory is where Rails looks for models.

The `ActiveRecord::Base` class has lots of magic within it. For one,
the name of the class is important; ActiveRecord is able to infer from
the class name `Physician` that the associated table is
`physicians`. It also adds basic methods to fetch records from the
database:

```ruby
# return an array of Physician objects, one for each row in the
# physicians table
Physician.all

# lookup the Physician with primary key (id) 101
Physician.find(101)
```

Once you have your hands on a `Physician` instance,
`ActiveRecord::Base` will also add accessors for each of the columns,
so for free you get `#name`, `#college`, `#home_city` methods on
`Physician`.

```ruby
# create a new Physician object
p = Physician.new

# set some fields
p.name = "Jonas Salk"
p.college = "City College"
p.home_city = "La Jolla"

# save the record to the database
p.save
```

The `::new` method will create a new model instance; it will not yet
be inserted into the database. You may then set fields, and finally
`#save` the object, at which point ActiveRecord will insert a new row
into the `physicians` table.

To save a step of `#save`, we can use `#create` to create a new record
and immediately save it to the db:

```ruby
# Wow, DHH has a lame title...
user = User.create(:name => "David", :occupation => "Code Artist")
```

Finally, we can destroy a record and remove it from the table through
`#destroy`:

```ruby
user.destroy
```

### Mass assignment

If you see an error like "ActiveModel::MassAssignmentSecurity::Error:
Can't mass-assign protected attributes" thrown, then it's because
create needs you to *whitelist* the attributes that can be set through
`create` by using `attr_accessible`:

```ruby
class User
  # allow `create` to set name and occupation
  attr_accessible :name, :occupation
end
```

Any attribute that has not been declared `attr_accessible` cannot be set
through the `new` or `create` methods. We'll talk about why this is necessary
when we talk about untrusted users uploading forms to our database.

Note that `attr_accessible` has nothing to do with `attr_accessor`.

## The Rails console

The `console` command lets you interact with your Rails application from the
command line. `rails console` launches IRB (add `gem pry-rails` to the
Gemfile to use `pry`), so you'll be right at home.

The only big difference between `rails console` and `irb` is that the
console will take care of loading your Rails application so you won't
have to `require` your model classes manually. This is handy, because you can immediately start playing with
your app, rather than first requiring and loading a bunch of
supporting classes.

In particular, `rails console` will establish a connection to the
database, so you can load and save objects from there.

INFO: You can also use the alias "c" to invoke the console: `rails c`.

## `::where` queries

Often we want to look up records by some criteria other than primary
key (for which we can use `::find`). To do this, we use `::where`:

```ruby
# return an array of Physicians based in La Jolla
Physician.where(:home_city => "La Jolla")
# Executes:
#   SELECT *
#     FROM physicians
#    WHERE physicians.home_city = 'La Jolla'
```

We may give multiple criteria:

```ruby
Physician.where(
  :home_city => "La Jolla",
  :college => "City College")
```

We may also embed SQL:

```ruby
Physician.where("(home_city = ?) OR (college = ?)",
    "La Jolla", "City College")
```

We give the SQL fragment; each '?' is filled in with the subsequent
arguments successively. This is superior to using string
interpolation, because ActiveRecord will do the proper escaping (for
instance, won't cause a SQL syntax error if your city contains a
quotation mark).  The use of '?' is also generally a security measure for avoiding SQL injection attacks.

For a short introduction on the full array of SQL injection security risks to keep in mind while using ActiveRecord see [here][presidentbeef].

[presidentbeef]: http://blog.presidentbeef.com/blog/2013/02/08/avoid-sql-injection-in-rails/

You may also search for values in a set, or within a range

```ruby
# physicians at any of these three schools
Physician.where(:college => ["City College", "Columbia", "NYU"])
# physicians with 3-9 years experience
Physician.where(:years_experience => (3..9))
```

## Convention over Configuration in Active Record

When writing applications using other programming languages or
frameworks, it may be necessary to write a lot of configuration
code. This is particularly true for ORM frameworks in
general. However, if you follow the conventions adopted by Rails,
you'll need to write very little configuration (in some case no
configuration at all) when creating Active Record models. The idea is
that if you configure your applications in the very same way most of
the time, then this configuration should be the default way. Explicit
configuration should be needed only in those cases where you can't
follow the convention for some reason or another.

### Naming Conventions

By default, Active Record uses some naming conventions to find out how
the mapping between models and database tables should be
created. Rails will pluralize your class names to find the respective
database table. So, for a class `Book`, you should have a database
table called **books**. The Rails pluralization mechanisms are very
powerful, being able to pluralize (and singularize) both regular
and irregular words. When using class names composed of two or more
words, the model class name should follow the Ruby conventions, using
the CamelCase form, while the table name must contain the words
separated by underscores (snake\_case). Examples:

* Database Table - Plural with underscores separating words (e.g.,
  `book_clubs`)
* Model Class - Singular with the first letter of each word
  capitalized (e.g., `BookClub`)

| Model / Class | Table / Schema |
| ------------- | -------------- |
| `Post`        | `posts`        |
| `LineItem`    | `line_items`   |
| `Deer`        | `deer`         |
| `Mouse`       | `mice`         |
| `Person`      | `people`       |


### Schema Conventions

Active Record uses naming conventions for the columns in database
tables, depending on the purpose of these columns.

* **Foreign keys** - These fields should be named following the
  pattern `singularized_table_name_id` (e.g., `item_id`,
  `order_id`). These are the fields that Active Record will look for
  when you create associations between your models.
* **Primary keys** - By default, Active Record will use an integer
  column named `id` as the table's primary key. When using
  [Rails Migrations](migrations.md) to create your tables, this
  column will be automatically created.
