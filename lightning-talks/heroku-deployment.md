# Deploying your app to heroku

1. https://devcenter.heroku.com/articles/quickstart
2. https://devcenter.heroku.com/articles/rails3
    * Key points are `heroku create`
    * `git push heroku master`
    * Check out your app in the dashboard: https://dashboard.heroku.com/apps
    
## `sqlite3` and `pg`

The directions tell you to change your `gem sqlite3` line to `gem
pg`. Actually, you want to use sqlite3 in development, and postgres in
production. Change your gemfile like so:

```ruby
group :production do
  gem 'pg'
end

group :development do
  gem 'sqlite3'
end
```

## rake and rails tasks

1. You can access your app's Rails console through `heroku run rails c`.
2. You can run your migrations *on the server* through `heroku run
  rake db:migrate`.
3. In general, you just prefix a command with `heroku run`.

## SSH Notes
**TODO** Add potential problems with multiple Heroku accounts
```
You may receive the following error when first logging in:
 !    This key is already in use by another account. Each account must have a unique key.

 This is something that may happen when sharing computers. Heroku wants a unique SSH key per user.

 The best way to solve this is apparently just to use this:

https://github.com/ddollar/heroku-accounts


 /Users/app-academy/.ssh/new_id_rsa

 heroku keys:add /Users/app-academy/.ssh/new_id_rsa.pub

heroku login
Enter your Heroku credentials.
Email: foobar@gmail.com
Password (typing will be hidden):

Authentication successful.

This part actually worked:

Follow instructions here:
https://github.com/ddollar/heroku-accounts
```


