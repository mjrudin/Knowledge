# Sendgrid

* Sendgrid is free and sends email for you.
* Installation is described at
  https://devcenter.heroku.com/articles/sendgrid
* Install the starter version
    * You do not need to sign-up with sendgrid directly; you sign-up
      through Heroku, which is a reseller of the product
    * You'll have to input your CC information, but starter is free;
      they won't charge you, they just want to tempt you to pay for
      more.
* Simply copy the following into your `config/initializers/mail.rb`:

```ruby
if Rails.env.production?
  # only send emails for real in prod
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'
  }
  ActionMailer::Base.delivery_method ||= :smtp
elsif Rails.env.development?
  # hey, did you hear about letter opener? Install it in your gemfile.
  ActionMailer::Base.delivery_method = :letter_opener
end
```

* Don't paste your username/password into here (you won't have
  selected any in the Sendgrid sign-up process anyway).
* Git add and deploy to heroku.
