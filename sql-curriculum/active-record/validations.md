# Validations

This guide teaches you how to validate that objects are correctly filled out
before they go into the database. Validations are used to ensure that only
valid data is saved into your database. For example, it may be important to
your application to ensure that every user provides a valid email address and
mailing address. Validations keep garbage data out.

### Versus database constraints

We've seen how to write some database constraints in SQL (`NOT NULL`,
`REFERENCES`, `UNIQUE INDEX`); the database level will enforce these
constraints. These constraints are very strong, because not only will they
keep bugs in our Rails app from putting bad data into the database, they'll
also stop bad data coming from other sources (SQL scripts, the database
console).

We will frequently use simple DB constraints like these. However, for
complicated validations, DB constraints can be tortuous to write in
SQL.

Also, when a DB constraint fails, a generic error is thrown to Rails
(`SQLException`). In general, errors thrown by the DB cannot be handled by
Rails, and the user's request will fail with an ugly 500, internal server
error. DB constraints are good at catching corrupt data from a **serious
software bug**, but they are not appropriate for validating user input. If a
user chooses a previously chosen username, he should not get a 500 page;
Rails should nicely ask him for another name. This is what *model-level
validations* are good at.

Model-level validations live in the Rails world. Because we write them
in Ruby, they are very flexible, database agnostic, and convenient to
test, maintain and reuse. Rails provides built-in helpers for common
validations, making them easy to add. Many things we can validate in
the Rails layer would be very difficult to enforce at the DB layer.

That said, it is good practice to create unique indices and `NOT NULL`
constraints (in addition to Rails validations). This will catch errors from
non-Rails sources, and serve as a last line of defense.

## When does validation happen?

There are two kinds of Active Record objects: those that correspond to
a row inside your database and those that do not. When you create a
fresh object, for example using the `new` method, that object does not
belong to the database yet. Once you call `save` upon that object it
will be saved into the appropriate database table. Active Record uses
the `new_record?` instance method to determine whether an object is
already in the database or not. Consider the following simple Active
Record class:

```ruby
class Person < ActiveRecord::Base
end
```

We can see how it works by looking at some `rails console` output:

```ruby
>> p = Person.new(:name => "John Doe")
=> #<Person id: nil, name: "John Doe", created_at: nil, updated_at: nil>
>> p.new_record?
=> true
>> p.save
=> true
>> p.new_record?
=> false
```

Creating and saving a new record will send an SQL `INSERT` operation
to the database. Updating an existing record will send an SQL `UPDATE`
operation instead. Validations are typically run before these commands
are sent to the database. If any validations fail, the object will be
marked as invalid and Active Record will not perform the `INSERT` or
`UPDATE` operation. This helps to avoid storing an invalid object in
the database. You can choose to have specific validations run when an
object is created, saved, or updated.

Whenever you call `save` (or `save!`), validations will be run on the object.
The object will only be saved if the validations succeed.

To signal success saving the object, `save` will return `true`; otherwise
`false` is returned. `save!` will instead raise an error if the validations
fail.

**Always use `save!` unless you are going to explicitly check if the
validations failed**. Otherwise, you may silently fail to save records.

## `valid?` and `invalid?`

To verify whether or not an object is valid, Rails uses the `valid?`
method. You can also use this method on your own. `valid?` triggers
your validations and returns true if no errors were found in the
object, and false otherwise.

```ruby
class Person < ActiveRecord::Base
  validates :name, :presence => true
end

Person.create(:name => "John Doe").valid? # => true
Person.create(:name => nil).valid? # => false
```

`invalid?` is simply the inverse of `valid?`. It triggers your
validations, returning true if any errors were found in the object,
and false otherwise.

## `errors`

Okay, so we know an object is invalid, but what's wrong with it? We
can get a hash-like object (really `ActiveModel::Errors`). The keys
are attribute names, the values are an array of all the errors for the
attribute. If there are no errors on the specified attribute, an empty
array is returned.

After Active Record has performed validations, any errors found can be
accessed through the `errors` instance method, which returns a
collection of errors. By definition, an object is valid if this
collection is empty after running validations.

The `errors` method is only useful *after* validations have been run,
because it only inspects the errors collection and does not trigger
validations itself. You shouldn't use `errors` before first running
`valid?` to run the valdiations.

```ruby
class Person < ActiveRecord::Base
  validates :name, :presence => true
end

>> p = Person.new
#=> #<Person id: nil, name: nil>
>> p.errors
#=> {}

>> p.valid?
#=> false
>> p.errors
#=> {:name=>["can't be blank"]}

>> p = Person.create
#=> #<Person id: nil, name: nil>
>> p.errors
#=> {:name=>["can't be blank"]}

>> p.save
#=> false

>> p.save!
#=> ActiveRecord::RecordInvalid: Validation failed: Name can't be blank

>> Person.create!
#=> ActiveRecord::RecordInvalid: Validation failed: Name can't be blank
```

### `errors.full_messages`

To get an array of human readable messages, call
`record.errors.full_messages`.

```
>> p = Person.create
#=> #<Person id: nil, name: nil>
>> p.errors.full_messages
#=> ["Name can't be blank"]
```

## Validation helpers

Okay, but how do we actually start telling Active Record what to
validate? Active Record offers many pre-defined validation helpers
that you can use directly inside your class definitions. These helpers
provide common validation rules. Every time a validation fails, an
error message is added to the object's `errors` collection, and this
message is associated with the attribute being validated.

There are many many different validation helpers; we'll focus on the
most common and important. Refer to the Rails guides or documentation
for a totally comprehensive list.

### `presence`

This one is the most common by far: the `presence` helper validates
that the specified attributes are not empty. It uses the `blank?`
method to check if the value is either `nil` or a blank string, that
is, a string that is either empty or consists of whitespace.

```ruby
class Person < ActiveRecord::Base
  # must have name, login, and email
  validates :name, :login, :email, :presence => true
end
```

This demonstrates our first validation: we call the
`ActiveRecord::Base` class method `validates` on our model class,
giving it a list of column names to validate, then the validation type
mapping to `true`.

If you want to be sure that an association is present, you can do that too:

```ruby
class LineItem < ActiveRecord::Base
  belongs_to :order
  
  validates :order, :presence => true
end
```

**Don't check for the presence of the foreign_key (`order_id`); check
the presence of the associated object (`order`).** This will become
useful later when we do nested forms. Until then, just develop good
habits.

The default error message is "_can't be empty_".

### `uniqueness`

This helper validates that the attribute's value:

```ruby
class Account < ActiveRecord::Base
  # no two Accounts with the same email
  validates :email, :uniqueness => true
end
```

There is a very useful `:scope` option that you can use to specify
other attributes that are used to limit the uniqueness check:

```ruby
class Holiday < ActiveRecord::Base
  # no two Holidays with the same name for a single year
  validates :name, :uniqueness => { :scope => :year,
    :message => "should happen once per year" }
end
```

The default error message is "_has already been taken_".

### `format`

This helper validates the attributes' values by testing whether they
match a given regular expression, which is specified using the `:with`
option.

```ruby
class Product < ActiveRecord::Base
  validates :legacy_code, :format => { :with => /\A[a-zA-Z]+\z/,
    :message => "Only letters allowed" }
end
```

The default error message is "_is invalid_".

### `length`

This helper validates the length of the attributes' values. It
provides a variety of options, so you can specify length constraints
in different ways:

```ruby
class Person < ActiveRecord::Base
  validates :name, :length => { :minimum => 2 }
  validates :bio, :length => { :maximum => 500 }
  validates :password, :length => { :in => 6..20 }
  validates :registration_number, :length => { :is => 6 }
end
```

The possible length constraint options are:

* `:minimum` - The attribute cannot have less than the specified
  length.
* `:maximum` - The attribute cannot have more than the specified
  length.
* `:in` (or `:within`) - The attribute length must be included in a
  given interval. The value for this option must be a range.
* `:is` - The attribute length must be equal to the given value.

The default error messages depend on the type of length validation
being performed. You can personalize these messages using the
`:wrong_length`, `:too_long`, and `:too_short` options and `%{count}`
as a placeholder for the number corresponding to the length constraint
being used. You can still use the `:message` option to specify an
error message.

```ruby
class Person < ActiveRecord::Base
  validates :bio, :length => { :maximum => 1000,
    :too_long => "%{count} characters is the maximum allowed" }
end
```

This helper counts characters by default, but you can split the value
in a different way using the `:tokenizer` option:

```ruby
class Essay < ActiveRecord::Base
  validates :content, :length => {
    :minimum   => 300,
    :maximum   => 400,
    :tokenizer => lambda { |str| str.scan(/\w+/) },
    :too_short => "must have at least %{count} words",
    :too_long  => "must have at most %{count} words"
  }
end
```

Note that the default error messages are plural (e.g., "is too short
(minimum is %{count} characters)"). For this reason, when `:minimum`
is 1 you should provide a personalized message or use
`validates_presence_of` instead. When `:in` or `:within` have a lower
limit of 1, you should either provide a personalized message or call
`presence` prior to `length`.

### string columns, varchar, and length

When you run a migration specifying a string field, the database will
create a `VARCHAR` column, a typical maximum length is 255
characters. Remember, there isn't a "string" concept at the DB level;
SQL knows about `VARCHAR`, Ruby knows about `String`. That said, there
won't be any problems translating between the two if the string is
<255 chars.

If you try to insert a value longer than 255 characters, Active Record
won't care until the DB complains; because the error will occur at the
DB level, AR won't have marked your record as `#invalid?`, and you
won't get anything useful in `#errors`. Instead, you get a nasty
exception on `#save`:

```
ActiveRecord::StatementInvalid (PGError: ERROR:  value too long for type character varying(255)
```

For this reason, you'll probably want to add a length validation,
which will catch the problem at the AR level before going to the
DB. Other options are to raise the VARCHAR length, or use a `TEXT`
field with no limit (but worse performance).

```ruby
# some urls get mighty long
t.string :url, :limit => 1024
# some people go on and on...
t.text :comments
```
### `numericality`

This helper validates numeric input. It has a lot of options. Here's
one example:

```ruby
class Student < ActiveRecord::Base
  validates :sat_math, :sat_verbal, :numericality => {
    :allow_nil => true,
    :greater_than_or_equal_to => 200,
    :less_than_or_equal_to => 800,
    :only_integer => true
  }
end
```

This will test that the SAT score is within 200-800, and that only
integers will be accepted. It will allow the scores to be left blank
(`allow_nil`), perhaps if the `Student` hasn't taken the SAT.

There are a number of other options; check the docs to familiarize
yourself with those.

### `inclusion`

This helper validates that the attributes' values are included in a
given set. In fact, this set can be any enumerable object.

```ruby
class Coffee < ActiveRecord::Base
  validates :size, :inclusion => { :in => %w(small medium large),
    :message => "%{value} is not a valid size" }
end
```

The `inclusion` helper has an option `:in` that receives the set of
values that will be accepted. The previous example uses the `:message`
option to show how you can include the attribute's value.

The default error message for this helper is "_is not included in the
list_".

## Common Validation Options

These are a few common validation options which can be applid to most
validation helpers.

### `:allow_nil`/`:allow_blank`

The `:allow_nil` option skips the validation when the value being
validated is `nil`.

```ruby
class Coffee < ActiveRecord::Base
  validates :size, :inclusion => { :in => %w(small medium large),
    :message => "%{value} is not a valid size" }, :allow_nil => true
end
```

The `:allow_blank` option is similar to the `:allow_nil` option. This
option will let validation pass if the attribute's value is `blank?`,
like `nil` or an empty string for example.

```ruby
class Topic < ActiveRecord::Base
  validates :title, :length => { :is => 5 }, :allow_blank => true
end

Topic.create("title" => "").valid?  # => true
Topic.create("title" => nil).valid? # => true
```

TIP: `:allow_nil`/`:allow_blank` is ignored by the presence validator.

### `:message`

As you've already seen, the `:message` option lets you specify the
message that will be added to the `errors` collection when validation
fails. When this option is not used, Active Record will use the
respective default error message for each validation helper.

## Conditional Validation

Sometimes it will make sense to validate an object just when a given
predicate is satisfied. You can do that by using the `:if` and
`:unless` options, which can take a symbol, a string, or a `Proc`. You
may use the `:if` option when you want to specify when the validation
**should** happen. If you want to specify when the validation **should
not** happen, then you may use the `:unless` option.

You can associate the `:if` and `:unless` options with a symbol
corresponding to the name of a method that will get called right
before validation happens. This is the most commonly used option.

```ruby
class Order < ActiveRecord::Base
  validates :card_number, :presence => true, :if => :paid_with_card?

  def paid_with_card?
    payment_type == "card"
  end
end
```

## Writing Custom Validation Logic

When the built-in validation helpers are not enough for your needs,
you can write your own *validator classes* or *validation methods* as
you prefer.

### Custom Validators

Custom validators are classes that extend
`ActiveModel::Validator`. These classes must implement a `validate`
method which takes a record as an argument and performs the validation
on it. The custom validator is called using the `validates_with`
method.

```ruby
# app/validators/my_validator.rb

# app/validators doesn't exist by default, but you can create one in
# the console with `mkdir app; mkdir app/validators`

class MyValidator < ActiveModel::Validator
  def validate(record)
    # validate is passed the `Person` instance to validate through the
    # `record` parameter

    unless record.name.starts_with? 'X'
      record.errors[:name] << 'Need a name starting with X please!'
    end
  end
end

# app/models/person.rb
class Person < ActiveRecord::Base
  validates_with MyValidator
end
```

The validator indicates validation failure by adding to the record's
errors. If your validator doesn't add to the errors, then the
validation is deemed to have passed.

If we want the lovely syntax of the built-in validators, we can extend
`ActiveModel::EachValidator`. This is the preferred way. Your custom
validator class must implement a `validate_each` method which takes
three arguments: the record, the attribute name and its value.

```ruby
class EmailValidator < ActiveModel::EachValidator
  CRAZY_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def validate_each(record, attribute_name, value)
    unless value =~ CRAZY_EMAIL_REGEX
      # we can use `EachValidator#options` to access custom options
      # passed to the valdiator.
      record.errors[attribute_name] << (options[:message] || "is not an email")
    end
  end
end

class Person < ActiveRecord::Base
  # Rails know `:email` means `EmailValidator`.
  validates :email, :presence => true, :email => true
  # not required, but must also be an email
  validates :backup_email, :email => {:message => "isn't even valid"}
end
```

As shown in the example, you can also combine standard validations
with your own custom validators.

Ryan Bates has [more][custom-validators-asciicast] (~6:30 for details about custom validation in the model layer).

[custom-validators-asciicast]: http://railscasts.com/episodes/211-validations-in-rails-3?view=asciicast

### Custom Methods

You can also create methods that verify the state of your models and
add messages to the `errors` collection when they are invalid. You
must then register these methods by using the `validate` class method,
passing in the symbols for the validation methods' names.

You can pass more than one symbol for each class method and the
respective validations will be run in the same order as they were
registered.

```ruby
class Invoice < ActiveRecord::Base
  validate :expiration_date_cannot_be_in_the_past,
    :discount_cannot_be_greater_than_total_value

  def expiration_date_cannot_be_in_the_past
    if !expiration_date.blank? and expiration_date < Date.today
      errors[:expiration_date] << "can't be in the past"
    end
  end

  def discount_cannot_be_greater_than_total_value
    if discount > total_value
      errors[:discount] << "can't be greater than total value"
    end
  end
end
```

### `errors[:base]`

You can add error messages that are related to the object's state as a
whole, instead of being related to a single specific attribute. You
can use this method when you want to say that the object is invalid,
no matter the values of its attributes. Since `errors[:base]` is an
array, you can simply add a string to it and it will be used as an
error message.

```ruby
class Person < ActiveRecord::Base
  def a_method_used_for_validation_purposes
    errors[:base] << "This person is invalid because ..."
  end
end
```

**TODO**: didn't do anything with custom validators
