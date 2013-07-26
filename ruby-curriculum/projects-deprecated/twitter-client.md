# Twitter Client

We'll use the [Twitter API][api-docs] to build a command line Twitter
API. Some things we want to be able to do:

* Post a status.
* Get your timeline.
* Get statuses for users.
* Direct message other users.

You will want to use the [OAuth gem][oauth-github]. Look at my example
at the end of the [OAuth chapter][oauth-chapter]. Using OAuth will let
your application act on behalf of a user.

## General architecture

You should make your program Object-oriented. **Don't bother doing any
UI**; we'll play with your classes in IRB.

### `TwitterSession`

Write a `TwitterSession` class that will hold your `CONSUMER_KEY`,
`CONSUMER_SECRET`, and `CONSUMER` tokens in constants.

Add a class method, `TwitterSession::access_token` which will, if the
user has not authorized the app before, will use Launchy to get him to
authorize the app. Store the returned token in a class variable
`@@access_token`. On subsequent methods, return this without requiring
the end user to reauthorize.

```ruby
TwitterSession.access_token # => first time kicks off auth
TwitterSession.access_token # => second time just fetches from @@access_token
```

You may also want to use my trick from the OAuth chapter to first try to
`YAML.load` the credentials from a file. The access key should be
stored in an instance variable.

You'll use `TwitterSession::auth_token` anytime you want to interact
with the API.

### `Status`

* Write a `Status` (Twitter's technical name for a tweet) class; a
  `Status` belongs to a `User`
* You should be able to get the message: `status.text`
* You should be able to get the tweeting `User` by writing
  `status.user`.
* You may want an initalizer `Status#initialize(author, message)` as
  well as a class method `Status::parse(json)` which parses the JSON
  returned from Twitter.

### `User`

Even though there will be only one "end user" who is using your app at
any time, there are many Twitter users out there for you to interact
with. For instance, all my friends on Twitter have user accounts.

* Write a `User` class.
* You should be able to get their statuses by writing `user.timeline`.
* You should be able to get their `#followers` and `#followed_users`.
* To start, the only instance variable your `User` will need to store
  is the username. Everything can be looked up from just a user name.
* As before, it would
* You should be able to create a new `User` object with
  `User.new("my_user_name")`. As with `Status`, you may also want a
  class method `User::parse(json)` which creates a `User` from the
  JSON returned from Twitter.
* API requests for followers and followed users (Twitter calls them
  friends) return an array of user ids.
    * To lookup user data for a list of user ids, use the `GET
      users/lookup` endpoint.
    * You should have a `User::parse_many` to create an array of
      `User`s from an array of ids. This will need to do the lookup
      request.

### `EndUser`

There are many users for you to interact with in the Twitter universe,
but there's only one you! After you login and authorize, for that
session, only you can post new Tweets or send direct messages. Let's
make a class `EndUser` which subclasses `User`, but adds a few methods
that only the "end user" can do.

#### Class methods

* You should write a class `EndUser` which subclasses `User`.
* `EndUser` should have a class method,
  `EndUser::set_user_name(user_name)` to set the end user's user
  name. Use this to create an `EndUser` object and save it in the
  `@@current_user` class variable.
* The `EndUser::me` class method should return `@@current_user`.

#### Instance methods

* Because `EndUser` is a `User`, things like `EndUser.me.followers`,
  `EndUser.me.timeline` should still work.
* You should add some new methods: `EndUser#post_status(status_text)`
  and `EndUSer#direct_message(other_user, text)`.

NOTE: Set your twitter app to have read/write/dm access. You can also 
take a look at the Ruby Documentation for the [URI::Parser][URI::Parser] for info on
converting strings (such as a tweet) into URL safe text.
[URI::Parser]: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/uri/rdoc/URI/Parser.html

## Extra Credit

* Extend your `Status` class to add methods like `mentions` to extract
  mentioned users, or `hashtags` to return a `Hashtag` object.
* You should be able to write `hashtag.statuses` to pull up statuses
  for a hashtag.

Persist your Users and Tweets by saving the objects to a file. Load
from said file everytime you run your script.

[api-docs]: https://dev.twitter.com/docs/api/1.1
[oauth-github]: https://github.com/oauth/oauth-ruby
[oauth-chapter]: ../the-web/oauth.md
