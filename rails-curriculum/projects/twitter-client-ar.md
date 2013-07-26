#Twitter Client

We'll use the [Twitter API][api-docs] and [Active Record][ar-basics]
to build the back-end of a Twitter [CLI][wiki-cli]. Our users have
been clamoring for the ability to:

* Post a status.
* View their timeline.
* View other user's tweets.
* Direct Message other users.

We will use the [OAuth gem][oauth-github]. So you should check out the example at the
end of the [OAuth chapter][oauth-chapter]. Using OAuth will allow our application act
on behalf of our users.

[wiki-cli]:http://en.wikipedia.org/wiki/Command-line_interface
[ar-basics]:http://guides.rubyonrails.org/active_record_basics.html
[api-docs]: https://dev.twitter.com/docs/api/1.1
[oauth-github]: https://github.com/oauth/oauth-ruby
[oauth-chapter]: ../the-web/oauth.md

### Architectural Notes

The application should be object-oriented. To accomplish this, we will
use Active Record to build some models. Please **Don't bother doing
any UI**; we'll leave that to the designers. Just test out your
classes in the Rails Console (`rails c`).

#### `User`

Even though there will be only one "end user" who is using your app at
any given time, there are many Twitter users out there for you to
interact with. For instance, all my friends on Twitter have user
accounts. You will need a user model, have it keep track of a
username.

#### `Follow`

To represent the relationships between users, we will build a `Follow`
model. As follows are one-directional (as opposed to friendships on
Facebook) the model will keep track of the follower and followee
(consider better names).

#### `Status`

Status is Twitter's official term for Tweet. At a minimum, we will
need to keep track of the body and author of the tweet as well as the
created_at timestamp. Note that we may also want the timestamp for
status updates.

### Phase I

* Begin by writing migrations for these models. Make sure to include
space for foreign keys where appropriate. Twitter assigns a unique ID
to tweets and users, so include integer fields for Twitter's own
`status_id` and `user_id` data (you will use them when you are
integrating with the API).
* Set up your associations and test them out in the console. Be sure
to name them clearly. Additionally, I'd like you to explicitly specify
the `foreign_key` and `class_name` options on `has_many` and
`belongs_to` associations (even if what you want is the same as
default). Be sure to specify the `source` option on any `through`
association as well. For example:

```ruby
# inside the User model
class User < ActiveRecord::Base
   has_many :follows, :foreign_key => "followed_user_id",
                      :class_name => "Follow"
   has_many :followers, :through => :follows,
                        :source => :follower
...

end
```

* Here are **some** of the associations to get you started:
  * a `User` should:
    * have many follows and followers
    * have many followings and followed users (perhaps reconsider
      these names)
    * have many statuses, and followed user statuses
  * a `Status` should belong to a user
  * a `Follow` should belong to a follower and followee
* Test out your associations in the console.

### Phase II

#### `TwitterSession`

NOTE: Before starting, set up API access for a new Twitter app and
give it read/write/dm access. Also take a look at the Ruby
Documentation for the URI::Parser for info on converting strings (such
as a tweet) into URL safe text.

Write a `TwitterSession` model class, it should not have a database
table nor inherit from ActiveRecord::Base. It will hold your
`CONSUMER_KEY`, `CONSUMER_SECRET`, and `CONSUMER` tokens in constants.

Add a class method, `TwitterSession::access_token` which will, if the
user has not authorized the app before, will use Launchy to get them
to authorize the app. Store the returned token in a class variable
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

Make sure to include helpers, `TwitterStatus#get` and `#post`, to
communicate with the API using the access token.

Extend your `TwitterSession` class to have a `@@current_user` class
variable. Asking for the `current_user` should either return the user
model or set `@@current_user`.

### Phase III

#### `Status`

* Extend your `Status` model to have a `Status::clean_json(json)`
method, which should parse the JSON response from Twitter's API to
throw out all but the fields in your database. You should be able to
feed this cleaned json right into `Status::new` or
`Status#update_attributes`. So make sure the attributes are all
mass assignable (with attr_accessible).

#### `User`

Like `Status`, extend the `User` model with a `::clean_json(json)`
method.

You should write methods for `User` to sync a user's followers and
followed users. API requests for followers and followed users (Twitter
calls them friends) return an array of user ids. To look up user data
for a list of user ids, use the `GET users/lookup` endpoint. Because
some of your users will already be in the database, you will need to
come up with an algorithm which creates records for the users which
are not in the database. One way you might do this:
0. Make a list of follower ids.
0. Create a list of users models for users already in the database. **i.e.**
   Users `where` their id is in the list.
0. Make an API request to `users/lookup` cleaning the json and either
   creating the users or updating the attributes of the users which
   were already in the database.
0. Set the list of the updated/new users as the `User#followers`.

Like a `User`s friends, you should write a method to sync a one user's
statuses (called a timeline in aggregate). Again, some of these
statuses may already exist in the database, so make sure to account
for duplicates.

#### Enough GETs lets POST

Extend the user class so our `@@current_user` can
tweet. `User#post_status(status_text)` and
`User#direct_message(other_user, text)` make sure to check that the
current user is the one posting making the API call.

### Extra Credit

* Extend your `Status` class to add methods like `mentions` to extract
  mentioned users, or `hashtags` to return a `Hashtag` object.
  * You should be able to write `hashtag.statuses` to pull up statuses
    for a hashtag.
