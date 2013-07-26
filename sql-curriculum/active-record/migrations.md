# Migrations

## Overview

We've discussed SQL databases, so we know that programs can store and
pull out data from them. This data can then be used to populate the
attributes of Ruby objects.

As a program is written, the structure of the database will evolve. We
would like some way to track the evolution of the database schema, so
that this is tracked along with our code in our git repository.

Additionally, because we often develop on our own machine, with our
own local development database, but later deploy our application to a
server running a production database, we need a way to record the
transformations we've made locally, so that they may be "played back"
and performed on the server database when we deploy our code.

Database *migrations* are a solution to these problems. A migration is
a file containing Ruby code that describes a set of changes applied to
the database; it may create or drop tables, and add or remove
columns from a table. Each new set of changes is written inside a new
migration file, which is checked into the repository. Active record
will take responsibility for performing the necessary migrations when
you ask it.

In this chapter, we will teach you

* How to generate a migration
* The common methods that you will use when writing migrations
* How to perform migrations
* How migrations relate to `schema.rb`

## Basics

Let's show a first migration. A migration is a Ruby class that extends
`ActiveRecord::Migration`. The parent class takes care of the
behind-the-scenes work, we are responsible only for describing our
change in the `up/down` methods.

```ruby
class CreateProducts < ActiveRecord::Migration
  def up
    create_table :products do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def down
    drop_table :products
  end
end
```

This migration adds a table called `products` with a string column
called `name` and a text column called `description`. A primary key
column called `id` will also be added, however since this is the
default we do not need to explicitly specify it. The timestamp columns
`created_at` and `updated_at` which Active Record populates
automatically will also be added. We also define how to undo the
migration in `down`: we drop the table.

Migrations are not limited to changing the schema. We can run arbitrary
code in our migration. This is helpful to fix bad data in the
database or populate new fields.

```ruby
class AddReceiveNewsletterToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.boolean :receive_newsletter, :default => false
    end
    User.each do |user|
      user.receive_newsletter = true
      user.save!
    end
  end

  def down
    remove_column :users, :receive_newsletter
  end
end
```

This migration adds a `receive_newsletter` column to the `users`
table. We want it to default to `false` for new users, but existing
users are considered to have already opted in, so we use the User
model to set the flag to `true` for existing users.

### Using the change method

It is often tedious to write the `down` method; the opposite of adding
a column is always to drop the column; the opposite of creating a
table is to drop the table.

Rails 3.1 makes migrations smarter by providing a new `change` method.
This method is preferred for writing constructive migrations (i.e. when adding columns or
tables). The migration knows how to migrate your database and reverse it when
the migration is rolled back without the need to write a separate `down` method.

```ruby
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
```

We can run `up/down` as before, and `ActiveRecord::Migration` will do
the right thing based on the `change` method.

This won't help for migrations which remove a column:

```ruby
class CreateProducts < ActiveRecord::Migration
  def change
    remove_column :products, :description
  end
end
```

We can still run `up`, but running `down`, the migration won't know
how to add back the `description` column; it hasn't recorded the type
of this column, so it doesn't know what kind of column to restore.

## Generating migrations

To create a new migration named `AddPartNumberToProducts` you run the
command:

    $ rails generate migration AddPartNumberToProducts

This will create an empty but appropriately named migration:

```ruby
class AddPartNumberToProducts < ActiveRecord::Migration
  def change
  end
end
```

Migrations are stored as files in the `db/migrate` directory, one for
each migration class. The name of the file is of the form
`YYYYMMDDHHMMSS_create_products.rb`, that is to say a UTC timestamp
identifying the migration followed by an underscore followed by the
name of the migration. The name of the migration class (CamelCased
version) should match the latter part of the file name; otherwise
ActiveRecord will be confused. For example
`20080906120000_create_products.rb` should define class
`CreateProducts` and `20080906120001_add_details_to_products.rb`
should define `AddDetailsToProducts`.

Now that we've created our migration, we will be able to edit it and
add code that actually performs the actions we desire.

## Writing a migration

Inside your `up/down` or `change` methods, you may call methods of the
parent class `ActiveRecord::Base`. Here we go through some of the most
common.

### Creating tables

Migration method `create_table` will be one of your workhorses. A
typical use would be

```ruby
create_table :products do |t|
  t.string :name
end
```

which creates a `products` table with a column called `name` (and as
discussed below, an implicit `id` column).

The object yielded to the block allows you to create columns on the
table. The so called "sexy" migration calls a method like `string` or
`integer` to create a column of that type. You then pass a symbol
which supplies the name. In our example, we create a `string` column
with the name `name`. Supported column types include:

* `:boolean`
* `:date`
* `:datetime`
* `:float`
* `:integer`
* `:primary_key`
* `:string`
* `:text`
* `:time`

### Changing tables

A close cousin of `create_table` is `change_table`, used for changing
existing tables. It is used in a similar fashion to `create_table` but
the object yielded to the block knows more tricks. For example

```ruby
change_table :products do |t|
  t.remove :description, :name
  t.string :part_number
  t.index :part_number
  t.rename :upccode, :upc_code
end
```

removes the `description` and `name` columns, creates a `part_number`
string column and adds an index on it. Finally it renames the
`upccode` column.

`change_table` is sort of the old way of doing things; it is not
reversible, even if inside the `change_table` statement you only do
reversible things like adding or renaming columns.

If you only want do reversible things in a migration, better to use the
following `ActiveRecord::Migration` methods:

* `add_column`
* `add_index`
* `add_timestamps`
* `create_table`
* `remove_timestamps`
* `rename_column`
* `rename_index`
* `rename_table`

For example, to add `user_id` to the `applications` table:

```ruby
def change
  add_column :applications, :user_id, :integer
end
```

ActiveRecord will be able to reverse the addition of this column
automagically.

### Timestamps

Active Record provides some shortcuts for common functionality. It is
for example very common to add both the `created_at` and `updated_at`
columns and so there is a method that does exactly that:

```ruby
create_table :products do |t|
  t.timestamps
end
```

These timestamp columns will be automagically populated when you
create a record, and later whenever that record is updated. This can
help you keep track of the evolution of your data when trying to debug
problems later.

I always add `timestamps` columns; they may well be useful later, and
it would be premature optimization to remove them until necessary.

## Running migrations

To actually perform the migrations you have written but not yet run,
use the command `rake db:migrate`. This will look in the `db/migrate`
directory, find all unexecuted migrations, and run their `up` or
`change` methods in order of creation time. Only when you run the
Rake task is the database actually modified.

### Rolling back migrations

Occasionally you will make a mistake when writing a migration. If you
have already run the migration then you cannot just edit the migration
and run the migration again: Rails thinks it has already run the
migration and so will do nothing when you run `rake db:migrate`. You
must first *rollback* the migration, which reverses the change (by
calling the `down`), if that is possible.

To rollback the most recent migration, run `rake db:rollback`. You may
now edit the migration file and rerun.

### Don't edit old migrations

In general, editing existing migrations is not a good idea. You will
be creating extra work for yourself and your co-workers and cause
major headaches if the existing version of the migration has already
been run on production machines. You'll have to rollback those
machines as well. More generally, because Rails keeps track of the
migration timestamp, and not the contents of the migration, it will
make you manually do all the work of rolling back on any production
and development machine.

Instead, you should write a new migration that performs the changes
you require. Editing a freshly generated migration that has not yet
been committed to source control (or, more generally, which has not
been propagated beyond your development machine) is relatively
harmless.

## The Schema File

Migrations, mighty as they may be, are not the authoritative source
for your database schema. That role falls to `db/schema.rb`, which
Active Record generates by examining the database (it does this, e.g.,
each time migrations are run). This is not designed to be edited, it
just represents the current state of the database.

There is no need (and it is error prone) to initialize a new database
by replaying the entire migration history. It is much simpler and
faster to just load into the database a description of the current
schema. For this reason, the schema file should be checked into source
control and tracked.

Schema files are also useful if you want a quick look at what
attributes an Active Record object has. This information is not in the
model's code and is frequently spread across several migrations, but
the information is nicely summed up in the schema file. The
[annotate_models](https://github.com/ctran/annotate_models) gem
automatically adds and updates comments at the top of each model
summarizing the schema if you desire that functionality.

You shouldn't worry too much about the `schema.rb` file for
quite a while. Just do one thing: check in the changes that result
from running `rake db:migrate` whenever you write a new
migration. That will keep it from cluttering up your git status, and
your repo will always have an up-to-date, authoritative description of
the database schema.

## References

* [Schema statements API][schema-statements]
* [Rails Guides][ror-migrations]
[schema-statements]: http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html
[ror-migrations]: http://guides.rubyonrails.org/migrations.html
