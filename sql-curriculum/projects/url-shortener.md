# URL Shortener: Part SQL

In this project, we build a tool that will take an input URL and will
shorten it for the user. Subsequent users can then give the
shortened URL back to the application and be directed to the original
URL.

We'll eventually make a web-app version of this, but for now let's
input shortened URLs into a CLI and use the launchy gem to pop open
the original URL in a browser.

## Requirements

* Input long URL into CLI, get back a shortened URL.
    * Use `SecureRandom.urlsafe_base64` to generate a random id.
* Input a shortened URL, look up and pop open the original page.
    * Each user should get their own, personal `ShortURL`. This will
      let them track their own click statistics.
    * A single user should even be able to make several `ShortURL`s
      for the same long url. This might be useful if they want to
      publish different short urls on Facebook and Twitter to see how
      much webtraffic each of the two sites drive to the link.
    * Do not duplicate the `LongURL` for each `ShortURL`. If many
      people create short urls for `https://www.google.com`, do not
      repeat the long URL multiple times in your DB.
    * Of course, you'll need a reference to lookup a `LongURL` from a
      `ShortURL`; use an integer to store the reference. An integer is
      much smaller (8 bytes at most) than the full URL text (up to
      1024 bytes).
    * By breaking `LongURL` out from `ShortURL`, you can store
      additional `LongURL` specific info in that table without it
      being repeated for every single `ShortURL`.
    * This is called *normalization*; keeping duplicated data out of
      the DB.
* Collect statistics on each URL
    * How many `Visits` for the shortened URL
    * How many *uniques*, or distinct users have visited on the URL
      (when a user is using your program, the first thing they will do
      is 'log in' by typing in their username, so you will always have
      a 'current' user and therefore a user to associate with a visit)
    * How many `Visits` to the URL in the past 10min?
* You'll need a concept of a `User`
    * Keep track of the user's email in addition to a username
    * You need a User to dedup visits to get uniques.
* You should be able to look up all `ShortURL`s submitted by any user.
* Users should be able to comment on links; the appropriate comments
  should be displayed before the page opens.
* Users should be able to choose one of a set of predefined
  `TagTopic`s for links (news, sports, music, etc.).
    * You should be able to query for the most popular links in each
      category.
    * NB: the relationship between `TagTopic`s and `URL`s is
      many-to-many. You'll need a join model like `Tagging`s.

## Enter ActiveRecord!

We will use ActiveRecord for this project.

The easiest way to use ActiveRecord is inside of a Rails
project. Setting one up is easy:

    rails new URLShortener

This creates a new Rails project called URLShortner in its own
directory. You now have an `app/models` directory within to hold your
ActiveRecord models, and a `db/migrate` directory for your
migrations. You can run pending migrations with `rake db:migrate`.

To start, write your code to be run in the console (`rails
console`). Later, you'll want to write a script: you may write this in
the `scripts` folder.  You can execute it with `rails runner
[script-name]` (`rails r [script-name]` works, too).

**Write only UI code in your script**. As much functionality as you
can should exist in the model classes; everything except UI. Think
that you may want to write a web version of this program soon (hint,
hint), and stuff in your script can't be reused in the web version,
while UI code in your model isn't reusable outside the script...

Example usage:

```
$ rails console

> require 'lib/url_shortener.rb'
> URLShortener.login("user@appacademy.io")
> URLShortener.shorten('http://www.google.com')
=> "a1b2c3"
> URLShortener.expand('a1b2c3')
=> # Launchy opens http://www.google.com in a browser
```

## Thoughts

* You'll need to track what links users have visited.
* You can't store every visit inside one column.
* Each column should always store *one item of data*. A column
  should never store multiple items of data in a single column,
  like multiple links visited.
* If you need to store multiple items of data, they must be stored
  in separate rows. You will need a table like `visits` which
  records each visit of a user to a site.

## Validations

Make sure to add validations to enforce:

* Uniqueness of a username or email.
* Presence of all important fields.
* Length of URL strings < 1024 (or whatever your varchar length is).
* A custom validation that no more than 5 urls are submitted in the last
  minute by one user.
