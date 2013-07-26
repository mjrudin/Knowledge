require 'singleton'
require 'sqlite3'

class Database < SQLite3::Database
  include Singleton

  def initialize
    super("restaurants.db")

    self.results_as_hash = true
    self.type_translation = true
  end

  def self.execute(*args)
    self.instance.execute(*args)
  end
end
