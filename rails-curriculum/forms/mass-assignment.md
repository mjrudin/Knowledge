# Mass Assignment

## The problem

Mass assignment is when you write `Model.new(:attr1 => :val1, :attr2
=> :val2)`. It is most commonly used with forms:
`Model.new(params[:model])`.

Mass-assignment saves you much work, because you don't have to set
each value individually. Simply pass a hash to the `new` or `create`
methods to set the model's attributes to the values in the hash. The
problem is that it is often used in conjunction with the parameters
(params) hash available in the controller, which may be manipulated by
an attacker. They may do so by POSTing a request like this (easy to do
with RestClient):

```
POST /users
Host: http://www.example.com
user[name]=own3d
user[admin]=1
```

This will set the following parameters in the controller:

```ruby
params[:user] # => { "name" => "own3d", "admin" => 1}
```

So if you then write `User.create(params[:user])`, the user can make
themself an admin (assuming you store this in a `admin` column in your
`users` table). The user has taken advantage of their guess about your
db schema to inject unauthorized data.

## A solution

Rails 3.2 has *mass-assignment protection*, which restricts
mass-assignable attributes to a white list: `attr_accessible :attr1`
in your model class adds an attribute to the whitelist. If you try to
mass-assign an attribute you haven't whitelisted, Rails will toss an
error at you: `ActiveModel::MassAssignmentSecurity::Error: Can't
mass-assign protected attributes`.

Historically, laziness about `attr_accessible` has been a source of
security lapses, including a prominent
[attack on github][attack-on-github] (after this attack, Rails changed
everything to be blacklisted to start).

[attack-on-github]: https://gist.github.com/1978249
