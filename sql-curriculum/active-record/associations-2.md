# Associations II

## `has_many`/`belongs_to` options

In designing a data model, you will sometimes find a model that should
have a relation to itself. For example, you may want to store all
employees in a single database model, but be able to trace
relationships such as between manager and subordinates. This situation
can be modeled with self-joining associations:

```ruby
class Employee < ActiveRecord::Base
  has_many :subordinates, :class_name => "Employee",
    :foreign_key => "manager_id"
  belongs_to :manager, :class_name => "Employee"
end
```

This lets us retrieve `@employee.subordinates` and
`@employee.manager`.

The `class_name` option tells AR what kind of records to find;
otherwise, Rails doesn't know that `subordinates` should return
`Employee` records. The default would be to try to return
`Subordinate` objects; in this case, ActiveRecord's guess would be
wrong.

We also specify the `foreign_key` parameter. AR would otherwise guess
`employee_id` as the foreign key, since these ids are used to lookup
`Employee` objects. In this case, the foreign key is actually named
the much more descriptive `manager_id`.

Let's look at a final example:

```ruby
# emails: id|from_email|to_email|text
#  users: id|email_address

class User < ActiveRecord::Base
  validates :email_address, :uniqueness => true
  has_many :sent_emails, :class_name => "Email", :foreign_key =>
      "from_email", :primary_key => "email_address" # => table: emails
# SELECT *
#   FROM emails
#  WHERE emails.from_email = #{self.email_address}

  has_many :received_emails, :class_name => "Email", :foreign_key =>
      "to_email", :primary_key => "email_address"
end

class Email < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key =>
      "from_email", :primary_key => "email_address"
# SELECT *
#   FROM users
#  WHERE users.email_address = #{self.from_email}

  belongs_to :recipient, :class_name => "User", :foreign_key =>
      "to_email", :primary_key => "email_address"
end
```

Here the `Email` and `User` objects are associated in two ways: sender
and recipient. Additionally, the `Email` record doesn't reference
`User`'s `id` field directly; instead, it refers to an
`email_address`. For that reason, we need to specify the `primary_key`
option; this is by default simply `id`.

Through these two examples, we've seen that we can go beyond the
conventional ActiveRecord guesses in cases where our associations are
a little special.

## The `:source` option

The previous options describe how to change the defaults of `belongs_to` and
`has_many`. This is useful when you are using non-standard names.

Sometimes you want to name your `has_many :through` association with a custom
name. You always name the first association to "traverse" with the `:through`
argument. The second association to traverse is usually inferred from the
name of the `has_many :through` association being defined. However, you can
explicitly set it with `:source`.

```ruby
class Pet
  belongs_to :owner
end

class Owner
  has_many :pets
end

class Veterinarian
  has_many :clients, :class_name => "Owner"
  # (1) Traverse `Veterinarian#clients`
  # (2) Further traverse `Owner#pets` (would normally look for `Owner#patients`)
  has_many :patients, :through => :clients, :source => :pets
end
```
