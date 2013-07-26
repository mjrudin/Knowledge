# Associations

## Goals

This guide covers the association features of Active Record. By
referring to this guide, you will be able to:

* Declare associations between Active Record models
* Understand the various types of Active Record associations
* Use the methods added to your models by creating associations

### Questions

* What is the difference between `has_many` and `belongs_to`? Which table
  will hold a foreign key into the other table?
* Practice translating `has_many`, `belongs_to`, and `has_many :through` into
  SQL.

## What are associations

When you create your migrations, you'll set up foreign key references
between entities. For instance,

```ruby
class CreateCoursesAndProfessorsTables < ActiveRecord::Migration
  def change
    create_table :professors do |t|
      t.string :name
      t.string :thesis_title
      
      t.timestamps
    end
    
    create_table :courses do |t|
      t.string :course_name
      t.integer :professor_id
    end
  end
end
```

Each `Course` has a professor teaching the class; we store the
`Professor`'s id in the `Course`'s `professor_id` column.  `courses`'
`professor_id` column contains values that are foreign keys to the
`professors` table.

Given a `Course`, how shall we find the professor? One way is this:

```ruby
Professor.find(course.professor_id)
```

Likewise, to find the courses a professor is teaching:

```ruby
Course.where(:professor_id => prof.id)
```

This is tedious and low-level; we need to pull out the foreign key,
then explicitly look it up in the `professors` table. ActiveRecord
makes this easier through *associations*. Associations tell AR that
there is a connection between the two models. Here we modify the associated
model classes:

```ruby
class Course < ActiveRecord::Base
  belongs_to :professor
end

class Professor < ActiveRecord::Base
  has_many :courses
end
```

This lets us write more simply:

```ruby
course.professor # the professor for a course
prof.courses # an array of the courses a professor teaches
```

Rails will perform the lookups in the associated tables for us.

## The types of associations

In Rails, an _association_ is a connection between two Active Record
models. Associations are implemented using macro-style calls, so that
you can declaratively add features to your models. For example, by
declaring that one model `belongs_to` another, you instruct Rails to
maintain Primary Key–Foreign Key information between instances of the
two models, and you also get a number of utility methods added to your
model. Rails supports six types of associations:

* `belongs_to`
* `has_one`
* `has_many`
* `has_many :through`
* `has_one :through`
* `has_and_belongs_to_many`

We'll concentrate on `belongs_to` and `has_one`/`has_many` first, then
discuss the `:through` versions.

### The `belongs_to` Association

A `belongs_to` association sets up a one-to-one connection with
another model, such that each instance of the declaring model "belongs
to" one instance of the other model. For example, if your application
includes customers and orders, and each order can be assigned to
exactly one customer, you'd declare the order model this way:

```ruby
class Order < ActiveRecord::Base
  belongs_to :customer
end

order.customer
# SELECT *
#   FROM customers
#  WHERE customers.id = #{order.customer_id}
```

![belongs_to Association Diagram](http://guides.rubyonrails.org/images/belongs_to.png)

NOTE: `belongs_to` associations _must_ use the singular term. If you
used the pluralized form in the above example for the `customer`
association in the `Order` model, you would be told that there was an
"uninitialized constant Order::Customers". This is because Rails
automatically infers the class name from the association name. If the
association name is wrongly pluralized, then the inferred class will
be wrongly pluralized too.

### The `has_one` Association

A `has_one` association also sets up a one-to-one connection with
another model, but with somewhat different semantics (and
consequences). This association indicates that each instance of a
model contains or possesses one instance of another model. For
example, if each supplier in your application has only one account,
you'd declare the supplier model like this:

```ruby
class Supplier < ActiveRecord::Base
  has_one :account
end

supplier.account
# SELECT *
#   FROM accounts
#  WHERE accounts.supplier_id = #{supplier.id}
```

![has_one Association Diagram](http://guides.rubyonrails.org/images/has_one.png)

### `belongs_to` vs `has_one`

If you want to set up a one-to-one relationship between two models,
you'll need to add `belongs_to` to one, and `has_one` to the
other. How do you know which is which? What's the difference between
`belongs_to` and `has_one`?

You define the `belongs_to` association on the entity that has a
foreign key column referencing the associated object. When using the
`belongs_to` association, ActiveRecord will get the *foreign key* and
look it up in the associated table.

`has_one` is used when one entity is referred to by another; the other
entity holds a foreign key to our object. When using a `has_one`
association, ActiveRecord will get the *primary key* and look up a
record in the associated table which has this value in the foreign key
column.

The foreign key is what makes the distinction, but you should give
some thought to the actual meaning of the data as well. The `has_one`
relationship says that one of something is yours - that is, that
something points back to you. For example, it makes more sense to say
that a supplier owns an account than that an account owns a
supplier.

### The `has_many` Association

`has_one` is somewhat seldom used; one-to-many relations are much more common
than one-to-one relations. For instance, a `Restaurant` may have many
`Reviews`. A `Restaurant` `has_many` `Reviews`, each of which pertains to
(`belongs_to`) a single `Restaurant`.

`has_many` is like `has_one`, but it tells ActiveRecord to anticipate
that there may be several associated records. Using this association
returns an array of associated objects (possibly empty).

A `has_many` association indicates a one-to-many connection with
another model. You'll often find this association on the "other side"
of a `belongs_to` association. This association indicates that each
instance of the model has zero or more instances of another model. For
example, in an application containing customers and orders, the
customer model could be declared like this:

```ruby
class Customer < ActiveRecord::Base
  has_many :orders
end

customer.orders
# SELECT *
#   FROM orders
#  WHERE orders.customer_id = #{customer.id}
```

NOTE: The name of the other model is pluralized when declaring a
`has_many` association.

![has_many Association Diagram](http://guides.rubyonrails.org/images/has_many.png)

### The `has_many :through` Association

we've defined two kinds of associations; `belongs_to` relates an entity
with a foreign key to the associated entity, while
`has_one`/`has_many` associates an entity with one or more entities
that hold a foreign key to it.

What about indirect relations? For instance, consider the following
example:

```ruby
class Physician < ActiveRecord::Base
  has_many :appointments
end

class Appointment < ActiveRecord::Base
  belongs_to :physician
  belongs_to :patient
end

class Patient < ActiveRecord::Base
  has_many :appointments
end
```

Here both a `Physician` and a `Patient` may have many
appointments. But what if we want to know the patients for a given
physician? We might write:

```ruby
patients = physician.appointments.map do |appointment|
  appointment.patient
end
```

Holy multiple lines of code, Batman. Also, note that each call of
`appointment.patient` will fire another DB query; if a `Physician` has 100s
of `Appointment`s, this will fire 100s of DB queries. Each DB request takes a
minimum amount of time to connect to the DB, communicate the query and
response, so 100s of queries will really, really slow down our app.

There has to be a better way.

```ruby
class Physician < ActiveRecord::Base
  has_many :appointments
  has_many :patients, :through => :appointments
end

class Appointment < ActiveRecord::Base
  belongs_to :physician
  belongs_to :patient
end

class Patient < ActiveRecord::Base
  has_many :appointments
  has_many :physicians, :through => :appointments
end
```

A `has_many :through` association is often used to set up a
many-to-many connection with another model. This association indicates
that the declaring model can be matched with zero or more instances of
another model by proceeding *through* a third model.

Here we add a new `has_many` association. Take the example of

```ruby
has_many :physicians, :through => :appointments
```

This says to create an association named `physicians`. When we use the
association, ActiveRecord will first get the associated `appointments`
items. On each of these, it will then lookup the associated
`physicians` and return a list of all these.

For this reason, we can now easily write:

```ruby
physician.patients # array of Patients
# SELECT patients.*
#   FROM patients
#   JOIN appointments
#     ON patients.id = appointments.patient_id
#  WHERE appointments.physician_id = #{physician.id}

patient.physicians # array of Physicians
# SELECT physicians.*
#   FROM physicians
#   JOIN appointments
#     ON physicians.id = appointments.physician_id
#  WHERE appointments.patient_id = #{patient.id}
```

![has_many :through Association Diagram](http://guides.rubyonrails.org/images/has_many_through.png)

As noted, this is particularly useful when dealing with many-to-many
relationships. We previously learned about *join tables*; tables which
exist to allow a many-to-many relation. In our example, `appointments`
is a join table.

### The `has_one :through` Association

This acts the same as `has_many :through`, but tells ActiveRecord that
only one record will be returned, so don't put it in an array.

The distinction between `belongs_to`/`has_one` doesn't apply to
`:through`. There is no `belongs_to :through`.

### The `has_and_belongs_to_many` Association

ActiveRecord has a way of defining a many-to-many association without
referring to the intervening join table: this is the
`has_and_belongs_to_many` association. It is a shortcut to writing
`has_many :through` associations.

This association is sometimes used, but is not advised. Look it up in
the Rails guides as necessary, but don't worry about it at this time.

## Exercises

* What is the difference between `belongs_to` and `has_one`?
* Why would a `belongs_to_many` association not make sense, when a
  `has_many` does?

## References

http://tutorials.jumpstartlab.com/topics/models/relationships.html
