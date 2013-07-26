# ActiveRecord (AR)
+ Migrations
 + generating a migration
 + ActiveRecord::Migration
 * generating a model (`rails g` vs roll your own)
 + Creating a table (rake db:migrate)
  * short aside on rake tasks
 + Modifying a table
 + change vs up/down
 + rolling back
  * resetting/destroying database
 * Squashing migrations
 + Rails schema file
+ ORM/ActiveRecord Pattern
 + ActiveRecord::Base
 + all
 + find
 + Rails console
 + conditions (`where`)
* Associations
 + `belongs_to`
 + `has_one`
 + `belongs_to` vs `has_one`: which goes in which model?
 + `has_many`
 + `has_many :through`
 + join tables
 * assignment to associations
 * make children through parents
  * build vs create; doesn't save
  * Manager.employees.build
  * Employee.build_manager
+ Joins in Active Record
 + includes
 + joins in AR vs SQL
 + where with joins
 + scopes
+ Validations
 + Why use validations?
 + When does validation happen?
  + `valid?`
  + ActiveModel::Errors
 + Validation helpers:
  + presence
  + uniqueness
  + format
  + length
  + numericality
  + inclusion
 + Custom validation logic
  + Validator classes, EachValidator
  + Validation methods
+ Indexing
 + foreign keys
 + uniqueness
* Associations II
 + Tricky associations
  + self join
  + :primary_key
  + :foreign_key
  + :class_name
 + Extra credit: polymorphic associations
+ Callbacks
 + :dependent
  + :destroy
  + :nullify
  + :restrict
 + Registering callbacks
 + Extra credit: Observers
+ Querying Grabbag
 + find_by_sql
 + avoid dynamic finders 
 + ordering
 + merely mention group/having
 + calculations
* Transactions?

# SQL

* ER diagrams
 * database schemas
* sqlite3 setup
* creating tables
* associations + join tables
* SQL datatypes vs Ruby datatypes
* sqlite3 vs pg
