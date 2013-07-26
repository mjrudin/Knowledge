# Requirements

A classic first project is to build an authentication system. You're
going to build a User model and give it a password.

Today you should build SecretShareApp, but start to lock down the
secrets so that they truly are. Each user should be able to upload
secrets, and also select a single user to share it with. No one but
the sender and recipient should see the secret.

This is a somewhat sophisticated project; **read the instructions
first before beginning**. I don't spell out all the details here; you
should practice looking up how to do bits you don't know.

## Manage `User` passwords

Rails builds in a helpful method for managing passwords:
[`has_secure_password`][has-secure-password]. First add bcrypt-ruby to
your Gemfile; it's required for `has_secure_password`. Next add, a
single line to your `User` model:

```ruby
class User < ActiveRecord::Base
  has_secure_password
end
```

This will add a fake `password` attribute to your model; you can set
the `password`, but it won't be stored to the DB.

Instead, by using `has_secure_password`, assignments to `password`
will set a scrambled ([hashed][hash-wiki]) version of the password in
a `password_digest` column. A good hash won't let you recover the
original from the scrambled version, but when the user comes back with
the right password, you can rescramble (*rehash*) it and compare with
the stored hash. You should write a migration to add a string
`password_digest` column; don't add a `password` column, you never
want to store plaintext passwords.

`has_secure_password` will also add a fake `password_confirmation`
attribute; if present, it will validate that `password =
password_confirmation`. Again, neither will be persisted.

After saving the model, we can call `#authenticate` on the user
object, passing a submitted password. This returns `false` if password
doesn't match, else returns back the user.

### Requirements

* A `/users/new` path should give you a form to create a user.
    * Hint: `password_field_tag` secures the input.
* Validations:
    * Enforce a unique screenname.
    * Validate password length.
    * Validate email format (just rip a regex off the internet).
    * Be careful; even though we validate the password fields, they
      won't be stored. Subsequent updates to the `User` model will
      fail because the password won't validate.
    * We can run the password validations only on first create or
      password update by adding an [`:if` option][validates-if]. In
      particular, changes to other `User` attributes (like the
      `session_token` should not run these validations).
* Flash success on user creation.

[validates-if]: http://stackoverflow.com/questions/8533891/rails-validates-if

## Architecture

### signup/login flow

In short:

* GET to `/users/new` should return a form for a new user
* POST to `/users` should create the user.
* GET to `/session/new` should return form for login
    * Since there is no `Session` model class, you may prefer to use
      `form_tag` to `form_for` (which is typically used only when you
      have a model object).
* POST to `/session` should verify login credentials, issue token (and
  store in cookie+db), and redirect to `/secrets`.
* DELETE to `/session` should log the user out

In long:

How do we login and remember the current user? We should write a
`SessionsController`. There should be a singular resource (the
controller is still plural; not sure why), since a user only has (at
most) one login at a time. We should get a login form by visiting
`/session/new`: on successful `create` of a session, a *session token*
should be issued (more in a sec). On `destroy`, it should destroy the
`User`'s current session.

To track and not forget that the client's loged in user, we need to
put a token in the `User`'s cookie on login. To generate a token,
check out the [SecureRandom][secure-random-docs]. To tie this with a
`User`, we should add a `session_token` column to the `users`
table. This column should be updated on login. Likewise, on logout,
the column should be set to `NULL`. (**Be careful**: if you set the
cookie token to `nil` and the db column to `NULL`, they'll still match
up and it will look like you didn't logout).

This approach (setting `session_token` to `NULL` on logout) ensures
that after logout, the `User` will not be able to use an expired
`session_token` and will have to login again (important security
feature!).

## Flow

I'd like two controllers with content. `UsersController` should not
just manage user creation, its `show` action should display all
secrets shared by a user with the currently logged in user.

I'd also like a `SecretsController`; the `index` action should list
*all* the currently shared secrets, and the `show` should display a
single secret.

Implement a privacy model; try to do a better job than
Facebook. Whenever a privileged request is made (almost any request),
a token should be checked for, and the `User` should be fetched out of
the db by looking up the token in the `session_token` column. Clients
not submitting a token should be assumed logged out.

On protected pages, redirect to login page if not logged in. Use a
`before_filter` in the `ApplicationController` to do this. You'll
probably want to add additional helpers `current_user` and
`logged_in?`. Because all your other controllers extend
`ApplicationController`, these helpers are available in all
controllers. (Be careful: don't redirect when we're trying to access
the login page!)

Add a `logout` button throughout the site (in the application layout
if you know what that is yet). Of course, don't display the `logout`
button if logged in.

## Indices

Throw a unique index on `username` and `session_token` to enforce
uniqueness at the db level; it would be *really bad* (read:
compromised account) if these didn't end up being truly unique. Review
the SQL/AR chapter and read a bit about database race conditions (even
despite Rails validations).

Indices also provide fast lookup; you should add them to any column
you plan to perform lookups on. This will help not only with
`username` and `session_token`, but also any foreign key column.

## Mailing

* Use [ActionMailer][action-mailer-guide] to build an email flow.
    * Use the [letter_opener][letter-opener-github] gem to test emails
      being sent.
* Require user to confirm email address after login.
    * Confirmation should be done by sending a link embedding an
      "email token"; clicking the link should send you to an
      `validate_email` action; a simple GET request to this page
      should "validate" the address.
* Implement password reset
    * Click a button, send link to `UsersController#reset_password`
      (including an email token).

[hash-wiki]: http://en.wikipedia.org/wiki/Hash_function
[has-secure-password]:
https://github.com/rails/rails/blob/3-2-stable/activemodel/lib/active_model/secure_password.rb
[secure-random-docs]: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/securerandom/rdoc/SecureRandom.html
[action-mailer-guide]: ../mailers/mailing-1.md

[letter-opener-github]: https://github.com/ryanb/letter_opener
