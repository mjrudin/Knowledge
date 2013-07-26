# Nested Forms II

**TODO**: removing all checkboxes on an edit: upload empty array with
bumper.

**TODO**: describe how to do `3.times { @user.addresses.build }` for
nested forms.

## Removing Objects

You can allow users to delete associated objects by passing
`allow_destroy => true` to `accepts_nested_attributes_for`

```ruby
class User < ActiveRecord::Base
  attr_accessible :addresses_attributes

  has_many :addresses

  accepts_nested_attributes_for :addresses, :allow_destroy => true
end
```

If the hash of attributes for an object contains the key `_destroy` with
a value of '1' or 'true' then the object will be destroyed. This is
often done with a checkbox ("Delete?") which has a value of '0'/'false'
(unchecked) or '1'/'true' (checked).
