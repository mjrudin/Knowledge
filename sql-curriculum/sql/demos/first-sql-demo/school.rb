require 'singleton'
require 'sqlite3'

class SchoolDatabase < SQLite3::Database
  # Ruby provides a `Singleton` module that will only let one
  # `SchoolDatabase` object get instantiated. This is useful, because
  # there should only be a single connection to the database; there
  # shouldn't be multiple simultaneous connections. A call to
  # `SchoolDatabase::new` will result in an error. To get access to the
  # *single* SchoolDatabase instance, we call `#instance`.
  #
  # Don't worry too much about `Singleton`; it has nothing
  # intrinsically to do with SQL.
  include Singleton

  def initialize
    # tell the SQLite3::Database the db file to read/write
    super("school.db")

    # otherwise each row is returned as an array of values; we want a
    # hash indexed by column name.
    self.results_as_hash = true

    # otherwise all the data is returned as strings and not parsed
    # into the appropriate type.
    self.type_translation = true
  end
end

def get_departments
  # execute a SELECT; result in an `Array` of `Hash`es, each
  # represents a single row.
  SchoolDatabase.instance.execute("SELECT * FROM departments")
end

def add_department(name)
  # execute an INSERT; the '?' gets replaced with the value name. The
  # '?' lets us separate SQL commands from data, improving
  # readability, and also safety (lookup SQL injection attack on
  # wikipedia).
  SchoolDatabase.instance.execute(
    "INSERT INTO departments (name) VALUES (?)", name)
end

def add_professor(first_name, last_name, department_id)
  # insert a multi-column row; the '?' marks get replaced one by one.
  SchoolDatabase.instance.execute(
    "INSERT INTO professors (first_name, last_name, department_id) VALUES (?, ?, ?)",
    first_name, last_name, department_id
  )
end
