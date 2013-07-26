# Movie queries

The purpose of this assignment is for you to become familiar and
comfortable with making ActiveRecord queries, especially using joins
and includes.

By the end of this project you should be comfortable to:

* Make `belongs_to`/`has_one`/`has_many`/`has_many :through`
  associations, and know when to use each.
* Make AR queries that use `joins` and `includes`, plus `group`,
  `order`, and `where`.
* Know how to use scopes to write reusable, chainable queries.

## Setup
### Install MySQL
* Download MySQL here: http://dev.mysql.com/downloads/mirror.php?id=411091
* Run mysql-5.5.29-osx10.6-x86_64.pkg
* Run MySQLStartupItem.pkg
* Run MySQL.prefPane
    * Install for this user only.
    * Start the MySQL server.
* Add the following to `~/.bash_profile`

```
# tells shell where to find `mysql` command line client
export PATH=/usr/local/mysql/bin:$PATH
# tells shell where to load the `mysql` library needed by ActiveRecord
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH
```

Restart the terminal and check that `mysql -u root` works.

### Import the Sakila DB

Properly speaking, MySQL is a *relational database management
system*. Within a RDBMS a *database* is a collection of tables. Many
databases can be managed by the same RDBMS; for instance, a db of
movies and a db of stocks.

SQLite3 was simpler and meant for a single user, and each collection
of tables was stored in a single database file
(`development.sqlite3`). But multi-user databases can manage multiple
databases, each of which is given a unique name.

* Download the Sakila db here:
  http://dev.mysql.com/doc/index-other.html
* Change directory into the `sakila-db` folder and run `mysql -u
  root`. Then:
    * This gives you permission to create and populate a new db.
    * `SOURCE sakila-schema.sql`
    * `SOURCE sakila-data.sql`
    * The data is now imported to mysql; you could even delete the
      `sakila-db` folder if you like.
* Exit out of mysql and then attach to the db in `mysql -u root
  sakila`. This connext to the `sakila` db. Run `SELECT * FROM actor;`
  to make sure all is well.

The two major differences from sqlite3 are that `show tables;` shows
all tables, and `describe tablename;` shows the schema of that table.

### Setup Rails to use MySQL
Create a new SakilaDemo rails project.

Replace the line `gem 'sqlite3'` with `gem 'mysql2'` in your Gemfile
and run `bundle install`. We'll talk about this later, but the Gemfile
includes dependencies, and bundle install installs them. The `mysql2`
gem is a *driver* which lets your ruby code interact with the MySQL db
(just like `sqlite3`).

`bundle install` installs the gem, but we need to update
`config/database.yml` so that ActiveRecord knows to talk to the MySQL
db. To do this we modify `config/database.yml`:

```ruby
development:
  adapter: mysql2  # we're talking to a mysql db
  host: localhost  # mysql is running on the local machine
  port: 3306       # this is the conventional "port" mysql listens for requests on
  database: sakila # we'll use the set of tables in the sakila db
  username: root   # we'd normally give a password, too.
  pool: 5
  timeout: 5000
```

You can delete production and test, which we won't use here.

## Conventions: table name and primary key

**Note that you won't have to setup any migrations to connect
associations.**

The Sakila db doesn't follow Rails conventions for table name and
primary key. That's fine; we can tell AR to handle this.

```ruby
class Actor < ActiveRecord::Base
  # demo table is named with singular
  set_table_name(:actor)
  # primary key is named like foreign key
  set_primary_key(:actor_id)
end
```

### Primary keys in join tables

Rails uses the *primary key* to `find` records. It also, when saving
an updated a record uses the pk to tell the database system which row
to update.

By default, Rails expects `id` as the primary key; above we've
overriden this convention to set another column as the pk. But a
database pk can also be multiple columns: other `sakila` tables have
*composite primary keys*. For instance, look at the join table
`film_actor`:

```
mysql> DESCRIBE film_actor;
+-------------+----------------------+------+-----+-------------------+-----------------------------+
| Field       | Type                 | Null | Key | Default           | Extra                       |
+-------------+----------------------+------+-----+-------------------+-----------------------------+
| actor_id    | smallint(5) unsigned | NO   | PRI | NULL              |                             |
| film_id     | smallint(5) unsigned | NO   | PRI | NULL              |                             |
| last_update | timestamp            | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
+-------------+----------------------+------+-----+-------------------+-----------------------------+
3 rows in set (0.01 sec)
```

The primary key is `(actor_id, film_id)`. Neither `actor_id` nor
`film_id` will be unique in `film_actor`, but the combination of the
two is unique. If we had generated this table through Rails
migrations, it would have added an `id` column (which would make it
easier to look up an "appearance" by an actor). But for tables that
are used purely for joining, outside the Rails world it is common to
use a composite key like this.

A Rails model expects to have a single column primary id. With a
composite key like this, we won't be able to use `FilmActor::find`
without telling Rails about the composite key. Likewise Rails won't
know how to tell MySQL to make changes to a row.

We can use a gem like
[`composite_primary_keys`][composite-primary-keys] to get Rails to
play nice with composite keys. Alternatively, we could use
`has_and_belongs_to_many`; that lets us associate `Film` with `Actors`
directly and punt on creating a `FilmActor` model.

In our case, let's ignore the issue and just create the typical
`has_many` and `has_many :through` associations. We won't set the
primary key on `FilmActor`; we won't be able to create new or modify
old `FilmActor` records through AR, but we don't need to do that
today, anyway.

[composite-primary-keys]: https://github.com/drnic/composite_primary_keys

## Schema

You should explore the tables yourself. NB: some of the tables merely
reproduce data in other tables. Here are some of the highlights:

* `actor`: contains basic actor info (like name).
* `film`: contains basic info (title, year, description, length,
  rating, language), also rental price and replacement cost.
* `film_actor` links `actor` and `film`.
* `category`: `film` has multiple `category`s through `film_category`.
* `address`: has a reference to `city`. `city` has a reference to
  `country`.
* `store`: a video store, references `address`
* `inventory`: is a join table between `film` and `store`.
* `customer`: references a `store` and an `address`.
* `rental` represents a video rental, references `inventory` and
  `customer`

## Requirements

Follows is a list of associations to build and queries. Your queries
should be written as a scope so that they can be chained.

**There are a lot of tables, and you don't need to use all of
  them**. Add models, associations, and queries as you go along.

**If an AR query seems hard, try writing the SQL first.**

### Film, actor, category
* Association from actor to all the films he appears in.
* Association from film to all actors in the film.
* Association from film to all the categories it is in.
* Association from category to all the films in that category.
* Association from actor all the categories that he has acted in.
* Association from categories to all the actors who have acted in that
  category.
* Query to find the actors who have been in the most films.
* Query to find films with the largest casts.
* Query to find the most popular categories of films.
* Query to find actors who have had the longest career (time between
  first last and movies). Can do this in one query with `MAX` and
  `MIN`.
    * Note that all movies come from 2006 so everyone has a career of
      1yr long.
    * **TODO**: fix this.

### Inventory
* Association from inventory to film; association from film to inventory.
* Association from inventory to store; association from store to inventory.
* Association from store to films, association from film to stores.
* Query to find the movie in the most stores; another query to find
  film with the most inventory.
* Association between inventory and rental; rental and inventory.
* Association between customer and rental; rental and customer.
* Through association between customer and film.
* Query to find films watched by the most people.
* Query to find customers who have watched the most films.
* Query to find most rented categories.

### Location
* Association between store and country.
* Query to find most popular actor in a country by number of rentals.
* Query to find movie rentals per city.

### Rental price
* **Note**: `Film` already contains the rental price
* Query to calculate gross for movies
* Query to calculate actor who's movies gross the most on average.
* Query to find customers who have spent the most on movies.

## TODO

**TODO**: nobody uindestands how has many through; they still want to
  use a table name.
**TODO**: setting the pager
**TODO**: why is this so hard?:
**TODO**: normalize names to rails style
**TODO**: rake db:schema:dump
**TODO**: give solutions to queries.
* Query to find, for a customer, how many films have they watched
  per category.
    * First create a `Film::category_counts` scope.
    * Then apply it to `customer.films.category_counts`
    **TODO**: 
    * First write a scope on `Film` that returns the number of films
      in each category.
    * You should be able to then write
      `Customer.films.category_counts`
