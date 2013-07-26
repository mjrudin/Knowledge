# Callbacks

Callbacks are methods that get called at certain moments of an
object's life cycle. With callbacks it is possible to write code that
will run whenever an Active Record object is created, saved, updated,
deleted, validated, or loaded from the database.

## Relational Callbacks

Suppose an example where a user has many posts. A user's posts should
be destroyed if the user is destroyed; else the posts are said to be
*widowed*. To do this, we pass the `:dependent` option to `has_many`:

```ruby
class User < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
end

class Post < ActiveRecord::Base
  # log destruction of post
  after_destroy :log_destroy_action

  def log_destroy_action
    puts 'Post destroyed'
  end
end

>> user = User.first
=> #<User id: 1>
>> user.posts.create!
=> #<Post id: 1, user_id: 1>
>> user.destroy
Post destroyed
=> #<User id: 1>
```

A somewhat less common option is to use `:dependent => :nullify`;
which instead of destroying the dependent objects will merely set the
foreign key to `NULL`. An even less common option is `:dependent =>
:restrict`, which will cause an exception to be raised if there exists
associated objects; you'd have to destroy the associated objects
yourself. This won't do any deleting or nullifying for you, but at
least you are assured safety from widowed records.

You may add `:dependent => destroy` on a `belongs_to` relationship,
but this is uncommon. Logically, if a `Post` `belongs_to` a `User`,
why should destroying the `Post` destroy the `User`? For this reason
it's seldom the case to add dependent logic to `belongs_to` relations.

### Active Record and Referential Integrity

Validations such as `validates :foreign_key, :uniqueness => true` are
one way in which models can try to enforce data integrity. The
`:dependent` option on associations allows models to automatically
destroy child objects when the parent is destroyed. But like anything
which operates at the application level, these cannot guarantee
referential integrity and so some people augment them with foreign key
constraints in the database.

For instance, we could open up the SQL client and delete the parent
record, and without a foreign key constraint, the db won't stop
us. This could confuse the application, if it assumes that every child
record has a parent.

If we add a foreign key constraint (either manually, or perhaps
through a gem like foreigner), the database itself can enforce
consistency and ensure that updates do not leave widowed objects. On
the other hand, because the error will occur at the db level, it will
be hard to write application code to handle it nicely.

One possibility is to use a Rails plugin like
[foreigner](https://github.com/matthuhiggins/foreigner) which add
foreign key support to Active Record.

Don't worry about this for now. I just want to keep you thinking about
the fact that the db and app servers are separate processes, and the
validations the Rails app performs are not enforced by the db
itself. Just like when we looked at race conditions, this reminds us
of the different layers and the decoupling of our product into db
and app servers.

## Callback Registration

You can also hook into other model lifecycle events. This is less
common than dependent callbacks; registered callbacks are an advanced
feature, somewhat fancy, and a little magical.

You implement callbacks as ordinary methods and use a macro-style
class method to register them as callbacks:

```ruby
class User < ActiveRecord::Base
  validates :random_code, :presence => true
  before_validation :ensure_random_code

  protected
  def ensure_random_code
    # assign a random code
    self.random_code = SecureRandom.hex(8)
  end
end
```

Here we use a callback to make sure to set the `random_code` attribute
(if forgotten) before we perform validations on the object. This helps
the client; he won't be forced to specify the `random_code`
explicitly.

It is considered good practice to declare callback methods as
protected or private. If left public, they can be called from outside
of the model and violate the principle of object encapsulation.

## Available Callbacks

There are many available Active Record callbacks; I've collected the
most commonly hooked-into:

* `before_validation` (handy as a last chance to set forgotten fields)
* `after_create` (handy to do some post-create logic, like send a confirmation email)
* `after_destroy` (handy to perform post-destroy clean-up logic)

You can further specify that the callback should only be called when
performing certain operations:

```
class CreditCard < ActiveRecord::Base
  # Strip everything but digits, so the user can specify "555 234 34" or
  # "5552-3434" or both will mean "55523434"
  before_validation(:on => :create) do
    self.number = number.gsub(%r[^0-9]/, "") if attribute_present?("number")
  end
end
```

This will only perform this callback when creating the object;
validations before subsequent saves will not perform this.
