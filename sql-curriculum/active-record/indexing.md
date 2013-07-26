# Indexing

## Index Foreign Keys

As we learned when we studied SQL, proper indexing is very important
for fast table lookup. If we lookup values without an index, we may
have to read every row.

Consider the following example:

```ruby
class User < ActiveRecord::Base
  has_many :conversations
end
  
class Conversation < ActiveRecord::Base
  belongs_to :user
end   
```

Given a `Conversation`, we can quickly lookup a `User` because
ActiveRecord automatically creates an index on `users`' primary key,
`id`. But what about `user.conversations`?

ActiveRecord won't automatically index `conversations` by the
`user_id` column. So the generated query (`SELECT * FROM conversations
WHERE user_id = ?`) will require a full table scan and look at every
row. With a lot of conversations, that becomes dog slow.

The solution is to ask ActiveRecord to make an index for us:

```ruby
class AddUserIdIndexToConversations < ActiveRecord::Migration
  def change
    add_index :conversations, :user_id
  end
end
```

http://tomafro.net/2009/08/using-indexes-in-rails-index-your-associations

## Uniqueness and race conditions

I want to talk about something a bit advanced. It's good to
understand, but not mission-critical for the small apps you will be
building for a while.

Your Rails application server only processes one web request at a time
(it's *single-threaded*); if requests take a long time to process, or
request volume is high, pages will not be served promptly. The typical
solution is to fire up additional app servers. This is called *scaling
out*, or *horizontal scaling*.

Even when you have multiple app servers, you usually have a single db
server. It can handle many SQL queries simultaneously; the database is
*multi-threaded*. So it is typical to have multiple app servers
talking to one db server.

The concurrent execution of SQL updates can be problematic. An
ActiveRecord uniqueness validation is enforced by performing an SQL
query into the model's table, searching for an existing record with
the same value in that attribute. If no record is found, the app
issues a second SQL query to insert or update the record.

Imagine a potential problem when two Rails application servers try to
insert the same record simultaneously:

1. AppServer1 issues a DB query to see if a `Person` with email
   "ned@appacademy.io" exists yet. The result is no.
2. AppServer2 issues a DB query to see if a `Person` with email
   "ned@appacademy.io" exists yet. The result is no.
3. AppServer1 issues a DB query to insert a `Person` with email
   "ned@appacademy.io".
3. AppServer2 issues a DB query to insert a `Person` with email
   "ned@appacademy.io".
5. Damn.

This is called a race condition; we don't want AppServer2 to begin its
check+insertion until AppServer1's check+insertion is
complete. However, we cannot insure this at the application server
level.

The solution is to enforce this constraint at the DB level. You must
create a unique index in your database. Rails will still think
everything is fine until step 4, when the DB server will report back
that the update failed and Active Record will throw an error (which
your application code may handle).

To have AR create an index enforcing uniqueness, write a migration
like so:

```ruby
def change
  # no two users may share an email address
  add_index :persons, :email_address, :unique => true
end
```

**This will also speed up the enforcement of uniqueness checks, because
they will be indexed.**

### Why worry?

Don't be too scared. A problem like this wouldn't manifest until you
run >1 app server (you need two simultaneous requests to modify the
DB). We mostly wanted to introduce you to the idea that the db server
and app servers run at different layers.

Still, uniqueness constraints are relatively painless to add at the DB
level, they won't break anything, they'll make things faster. And
they'll also solve this race condition problem. :-)
