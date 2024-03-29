# Building ActiveRecordLite

In this project, we build our own lite version of ActiveRecord. The
purpose of this project is for you to understand how ActiveRecord
actually works: how your ActiveRecord world is translated into SQL.

## Setup

Check out the [skeleton git repo][skeleton-repo]. Click to download
the zip file (you don't need the whole repo). It has some basic tests
in the `test/` directory. You can run them by running `ruby -I./lib
test/mass_object_test.rb`.

[skeleton-repo]: https://github.com/appacademy-demos/active_record_lite/tree/active-record-skeleton

You'll need to setup the SQLite3 database. You can do this by running:
`cat test/cats.sql | sqlite3 test/cats.db`. If your db gets bogus data
in it, you can always `rm test/cats.db`, repopulate the db, and start
again.

## Warmup: Reimplement `attr_accessor`

You already know what the standard Ruby method `attr_accessor` does.
What if Ruby didn't provide this convenient method for you? Pretend
this is the case and implement the method `new_attr_accessor`, which
should do exactly the same thing as the real `attr_accessor`. This
should work for all `Object`s.

Hint: this would be an excellent time to investigate and use
`instance_variable_get` and `instance_variable_set`.

Here's an example of how `new_attr_accessor` should behave:

```ruby
class Cat
  new_attr_accessor :name, :color
end

> cat = Cat.new
> cat.name = "Sally"
> cat.color = "brown"

> cat.name # => "Sally"
> cat.color # => "brown"
```

## Phase I: `MassObject`

`MassObject` is a "blank" object that will be the base class for our
`Model` class. The job of `MassObject` is to implement an `initialize`
method that will accept a `hash` of attribute names and values,
assigning the values to instance variables. `MassObject` should also provide
setters and getters for the attributes.

* Write a class method `::set_attrs(*attributes)`. `attrs` should:
    * Iterate through the attributes
    * Create setter/getter methods for each attribute by calling
      `attr_accessor` on the class for each attribute.

```ruby
class MyClass < MassObject
  set_attrs :x, :y
end

my_obj = MyClass.new
my_obj.x = :x_val
my_obj.y = :y_val
```

Okay, that doesn't do anything that `attr_accessor` didn't already
do. Let's add the mass assignment feature.

* Store the array of attributes in a class instance variable,
  `@attributes`.
* Write a class getter method (`MassObject::attributes`) to fetch
  `@attributes`.
* Write a new `MassObject#initialize(params)` method. It should:
    * Iterate through each `attr_name, value` pair in the `params`
      hash
    * Check to see if `attr_name` is in the assigned attributes.
        * To check this, you may be tempted to write
          `MassObject.attributes.include?(attr_name)`. This is close,
          but you shouldn't call `attributes` directly on
          `MassObject`.
        * It's the *subclass* of `MassObject` which will have the
          `attributes`. How do you get the attributes of the subclass
          and not `MassObject` itself?
    * If so, use `send` to call the setter method and pass it the
      desired value.
    * Otherwise, raise an error: "mass assignment to unregistered
      attribute #{attr_name}"

```ruby
class MyClass < MassObject
  set_attrs :x, :y
end

MyClass.new(:x => :x_val, :y => :y_val)
```

## Phase II: SQLObject

Our next job is to write a class, `SQLObject`, that will interact with
the database.

SQLite3 is back in your life. I've given you a helper class
`DBConnection` in `lib/active_record_lite/db_connection.rb`. You use
`execute`, pass it in SQL, as well as values to replace the `?`s in
the SQL.

* `SQLObject` should have a class method `set_table_name`. This should
  let the user specify the table on which to execute queries. It should store the table name in a class instance variable.
* It should likewise have a `table_name` class getter method.
    * As a bonus, you may want to require the
      `active_support/inflector` library to get the
      `String#underscore` method and convert your class name to snake
      case by default for `SQLObject::table_name`.
* It should have a class method named `SQLObject::all`. This should:
    * Query the specified table, selecting all rows and columns.
        * You will have to write a query and interpolate the table
          name into it.
        * Use `?` when interpolating values, but `execute` won't
          interpolate table names for you. You'll need to use the
          standard `#{}` Ruby interpolation.
    * Use the provided `DBConnection` class. Use
      `DBConnection.execute` freely in your `SQLObject` class.
    * For each row, call the `new` method, passing in the row hash.
    * `SQLObject` should inherit from `MassObject` so that we can
      mass-assign from the row hash.
    * When subclassing `SQLObject`, the user will have to call
      `set_attrs` with the name of every column.
    * You may need to adjust your `MassObject#initialize` method
      slightly so that when it checks if a key in the passed params is
      included in the declared attributes, it first calls `#to_sym` on
      the key to turn it into a symbol.
    * This could otherwise be a problem because the SQLite3 gem
      returns strings and not symbols as keys.
* Write a `SQLObject::find` method which takes an id. Write a query
  against the specified table from `set_table_name` for the row with
  the proper id.
* Write a `SQLObject#create` instance method.
    * Execute a query that will create a record with the object's
      attribute values into the db.
    * Format: `INSERT INTO [table name] (comma sep attr names) VALUES
      (question marks)`
    * To get comma separated attribute names, get the array of
      attribute names and join them with `", "`.
    * To get a question marks string, create an array of question
      marks (maybe use something like `['?'] * 10`); join these with
      `", "`.
    * You'll need an array of the attribute values to insert; take the
      attribute names and use `send` to `map` them to the instance's
      values for those attributes.
    * When you execute the query, you need to pass in the SQL, plus
      all the attribute values. Use the "splat" (`*`) operator to do
      this.
    * After you `INSERT`, you need to set the object's `id` attribute
      with the newly issued row id.
* Write a `SQLObject#update` instance method
    * Same idea as `create`, but performs an `UPDATE [table_name] SET
      attr1 = ?, attr2 = ? WHERE id = [id]`
    * To piece this together, generate the "set line"; map the
      attribute names to `"#{attr_name} = ?"` and then join with `",
      "`.
    * Since you will again need an array of attribute values, factor
      out this functionality into a private `attribute_values` method.
* Write an instance method `SQLObject#save` that will call `#create`
  if `id` is `nil`; else it calls `#update`.
    * You can make `update`/`create` private now.

## Phase III: `Searchable`

Let's write a module named `Searchable`, where we'll define
`where`. By using `extend`, we can add the `Searchable` methods as
class methods of our `SQLObject`. At the same time, we can organize
our code by putting all search related methods in `Searchable` and
keep our code clean.

* Write a `Searchable` module.
* Write a `where` method. This should take a hash of column names and
  values.
    * Map the param `keys` to an array of `"{key} = ?"`. Use this as
      the `WHERE` clause of the query.
    * Pass in the values of the hash when executing the query.
* Mix the module into `SQLObject`, importing the methods as class
  methods, by using `extend Searchable` in your SQLObject class.

## Phase IV: `Associatable`: `belongs_to`/`has_many`

* First, add a method `MassObject::parse_all`; this should take an
  array of result hashes, returning an array of parsed objects.
    * This should be convenient for your `where` and `all` methods.

### Part A: `belongs_to`

* Next, begin writing an `Associatable` module; we will `extend`
  `SQLObject` with this mix-in.
* Write a `belongs_to` method. It should take in an association name,
  plus a parameters hash.
* The goal of `belongs_to` is to define a method to fetch the
  associated object.
* `belongs_to` should call `define_method` to add a new method with
  the association name.
* Inside the block/method definition, define the following variables:
    * `other_class_name`: use `params[:class_name]`, or else:
        * Take the association name,
        * Convert it from snake case to camelcase.
    * `primary_key`: use `params[:primary_key]`, or else use `id`.
    * `foreign_key`: use `params[:foreign_key]`, or else use the
      association name with `_id` tacked on the end.
* Once you've pulled out these three fundamental parameters, you can
  calculate:
  * `other_class`: take `other_class_name` and get the class from the
    name by using `constantize`. See `active_support/inflector`.
  * `other_table_name`: call `table_name` on `other_class`.
* Using the defined variables, write a query to fetch the associated
  record.
* Finally, call `parse_all` on the `other_class` to parse the results
  into an array of model objects (there should be at most one element,
  of course).

### Part B: `has_many`

* Write a `has_many(name, params)` class method, it is similar to
  `belongs_to`.
* Inside the block/method definition, define the following variables:
    * `other_class_name`: use `params[:class_name]`, or else:
        * Take the association name,
        * Singularize it (`#singularize`, also from ActiveSupport),
        * Convert it from snake case to camelcase.
    * `primary_key`: use `params[:primary_key]`, or else use `id`.
    * `foreign_key`: use `params[:foreign_key]`, or else:
        * take the current class name,
        * convert it to snake case,
        * tack `_id` on the end.
* Once you've pulled out these three fundamental parameters, define
  `other_class` and `other_table_name` as before.

## Phase V: `has_one_through`

### Part A: `BelongsToAssocParams`, `HasManyAssocParams` helper classes

We want to write some helper classes that will represent the
parameters that define an association. For instance, I want to be able
to write:

```ruby
module Associatable
  # ...
  
  def has_many(name, params = {})
    aps = HasManyAssocParams.new(name, params)

    define_method(name) do
      results = DBConnection.execute(<<-SQL, self.send(aps.primary_key))
        SELECT *
          FROM #{aps.other_table}
         WHERE #{aps.other_table}.#{aps.foreign_key} = ?
      SQL

      aps.other_class.parse_all(results)
    end
  end

  # ...
end
```

`HasManyAssocParams` should do the work of collecting the parameters,
inferring defaults for unsupplied parameters, and providing
convenience methods like `other_table` and `other_class` (which are
simple to write if you store the `class_name`).

Writing helper classes like this help you extract argument parsing
logic from `belongs_to`/`has_many`, so that you can focus on writing
the queries.

### Part B: Storing association parameters

* `has_one_through` will join up two `belongs_to` associations.
* For instance: if `Cat` belongs to `Owner`, and `Owner` belongs
  to `House`, we want to define a `has_one` `Cat#house`
  association.
* To do this, we need to combine the parameters (table names, primary
  key, foreign key) from **two associations** to form a more
  complicated query.
* Since we need the params from the constituent associations, we need
  to store the `belongs_to` params for later use. We will store this
  in a hash of association parameters in a class instance variable.
* First, write a `assoc_params` class getter method. It should fetch
  `@assoc_params`. If that is `nil`, set `@assoc_params = {}` and then
  return the hash. Otherwise, just return the hash.
* Before you `define_method` in `belongs_to`, save the association
  parameters to `assoc_params`: `assoc_params[name] =
  BelongsToAssocParams.new(name, params)`.

### Part C: Writing `has_one_through`
* Get the two sets of parameters.
* Build a join query from both
