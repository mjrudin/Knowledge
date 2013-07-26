# Joins in Active Record

I refer heavily to the [JoinsDemo][joins-demo]. You should clone that
repository and play with that project.

[joins-demo]: https://github.com/appacademy-demos/JoinsDemo

## Schema overview:

```ruby
# db/schema.rb
ActiveRecord::Schema.define(:version => 20130126200858) do
  create_table "comments", :force => true do |t|
    # :force => true drops the table before creating it.
    t.text     "body"
    t.integer  "author_id"
    t.integer  "post_id"
    t.integer  "parent_comment_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    # :null => false means this field must be filled.
  end

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end
end
```

## The N+1 selects problem

Let's write some code to get the number of comments per `Post` by a
`User`:

```ruby
# app/models/user.rb
class User
  # ...

  def n_plus_one_post_comment_counts
    posts = user.posts
    # SELECT *
    #   FROM posts
    #  WHERE posts.author_id = #{self.id}
  
    post_comment_counts = {}
    posts.each do |post|
      # doesn't fire a query, since already prefetched the association
      # way better than N+1
      #
      # NB: if we write `post.comments.count` ActiveRecord will try to
      # be super-smart and run a `SELECT COUNT(*) FROM comments WHERE
      # comments.post_id = ?` query. This is because ActiveRecord
      # understands `#count`. But we already fetched the comments and
      # don't want to go back to the DB, so we can avoid this behavior
      # by calling `Array#length`.
      post_comment_counts[post] = post.comments.length
    end
  
    post_comment_counts
  end
end
```

This code looks fine at the first sight. But the problem lies within
the total number of queries executed. The above code executes 1 query
(to find the user posts) + "N" queries (one per each post to find the
queries) for N+1 queries in total.

This is inefficient: each query to the database has overhead
associated with it, so we want to avoid extra queries. In particular,
consider if some articles had 10,000 comments...

**Solution to N+1 queries problem**

The solution to this problem is that when we get the `Post`s, we can
at the same time get all the associated `Comment`s.

Active Record lets you specify in advance associations to *prefetch*; when
you use these assocations, the data will already have been fetched and won't
need to be queried for. To do this, we use the `includes` method. If you use
`includes` to prefetch data (e.g., `posts = user.posts.includes(:comments)`),
a subsequent call to access the association (e.g., `posts[0].comments`) won't
fire another DB query; it'll use the prefetched data.

Revisiting the above case, we could rewrite `post_comment_counts` to
use eager loading:

```ruby
# app/model/user.rb
class User
  # ...

  def includes_post_comment_counts
    # `includes` *prefetches the association* `comments`, so it doesn't
    # need to be queried for later. `includes` does not change the
    # type of the object returned (in this example, `Post`s); it only
    # prefetches extra data.
    posts = self.posts.includes(:comments)
    # Makes two queries:
    # SELECT *
    #   FROM posts
    #  WHERE post.id = #{self.id}
    # ...and...
    # SELECT *
    #   FROM comments
    #  WHERE comments.post_id IN (...fetched post ids go here...)
  
    post_comment_counts = {}
    posts.each do |post|
      # doesn't fire a query, since already prefetched the association
      # way better than N+1
      post_comment_counts[post] = post.comments.length
    end
  end
end
```

The above code will execute just **2** queries, as opposed to **N+1**
queries in the previous case:

### Complex includes

You can eagerly load as many associations as you like:

```ruby
comments = user.comments.includes(:post, :parent_comment)
```

Then both the `post` and `parent_comment` associations are eagerly
loaded. Neither `comment[0].post` nor `comment[0].parent_comment` will
hit the DB; they've been prefetched.

We can also do "nested" prefetches:

```ruby
posts = user.posts.includes(:comments => [:author, :parent_comment])
first_post = posts[0]
```

This not only prefetches `first_post.comments`, it also will prefetch
`first_post.comments[0]` and even `first_post.comments[0].author` and
`first_post.comments[0].parent_comment`.

## Joining Tables

To perform a SQL `JOIN`, use `joins`. Like `includes`, it takes a name
of an association.

`joins` by default performs an `INNER JOIN`, so they are frequently
used to filter out records that don't have an associated record. For
instance, let's filter `User`s who don't have `Comment`s:

```ruby
# app/models/user.rb
class User
  # ...

  def self.users_with_comments
    # `joins` can be surprising to SQL users. When we perform a SQL
    # join, we expect to get "wider" rows (with the columns of both
    # tables). But `joins` does not automatically return a wider row;
    # User.joins(:comments) still just returns a User.
    #
    # In this sense, `joins` does the opposite of `includes`:
    # `includes` fetches the entries and the associated entries
    # both. `User.joins(:comments)` returns no `Comment` data, just
    # the `User` columns. For this reason, `joins` is used less
    # commonly than `includes`.
  
    User.joins(:comments)
    # SELECT users.* -- note that only the user fields are selected!
    #   FROM users
    #   JOIN comments
    #     ON comments.author_id = users.id
  
    # `User.joins(:comments)` returns an array of `User` objects; each
    # `User` appears once for each `Comment` they've made. A `User`
    # without a `Comment` will not appear (`joins` defaults to INNER
    # JOIN). We could write `User.joins(:comments).uniq` to return a
    # `User` exactly once if he had made any comment.
  end
end
```

### Avoiding N+1 queries without loading lots of records

We've seen how to eagerly load associated objects to dodge the N+1
queries problem. There is another problem we may run into: `includes`
returns lots of data: it returns every `Comment` on every `Post` that
the `User` has written. This may be many, many comments. In the case
of counting comments per post, the `Comment`s themselves are useless,
we just want to count them.

We're doing too much in Ruby: we want to push some of the counting
work to SQL so that the database does it, and we receive just `Post`
objects with associated comment counts. This is another major use of
`joins`:

```ruby
# app/models/user.rb
class User
  # ...

  def joins_post_comment_counts
    # We use `includes` when we need to prefetch an association and
    # use those associated records. If we only want to *aggregate* the
    # associated records somehow, `includes` is wasteful, because all
    # the associated records are pulled down into the app.
    #
    # For instance, if a `User` has posts with many, many comments, we
    # would pull down every single comment. This may be more rows than
    # our Rails app can handle. And we don't actually care about all
    # the individual rows, we just want the count of how many there
    # are.
    #
    # When we want to do an "aggregation" like summing the number of
    # records (and don't care about the individual records), we want
    # to use `joins`.
  
    posts_with_counts = self
      .posts
      .select("posts.*, COUNT(*) AS comments_count") # more in a sec
      .joins(:comments)
      .group("posts.id") # "comments.post_id" would be equivalent
    # in SQL:
    #   SELECT posts.*, COUNT(*) AS comments_count
    #     FROM posts
    #    JOINS comments
    #       ON comments.post_id = posts.id
    #    WHERE posts.author_id = #{self.id}
    # GROUP BY posts.id
  
    # As we've seen before using `joins` does not change the type of
    # object returned: this returns an `Array` of `Post` objects.
    #
    # But we do want some extra data about the `Post`: how many
    # comments were left on it. We can use `select` to pick up some
    # "bonus fields" and give us access to extra data.
    #
    # Here, I would like to have the database count the comments per
    # post, and store this in a column named `comments_count`. The
    # magic is that ActiveRecord will give me access to this column by
    # dynamically adding a new method to the returned `Post` objects;
    # I can call `#comments_count`, and it will access the value of
    # this column:
  
    posts_with_counts.map do |post|
      # `#comments_count` will access the column we `select`ed in the
      # query.
      [post.title, post.comments_count]
    end
  end
end
```

### OUTER JOINs

The default for `joins` is to perform an `INNER JOIN`; we can do an
`OUTER JOIN` by giving `joins` a SQL fragment:

```ruby
posts.joins("LEFT OUTER JOIN comments ON posts.id = comments.post_id")
```

This is a little more verbose because we don't get the benefit of
piggybacking on the association name. We have to specify the primary
and foreign key columns for the join.

### Specifying `where` conditions on joined tables

You can specify conditions on the joined tables as usual. A special
hash syntax is used for specifying conditions for the joined tables:

```ruby
# fetch comments on `Posts` posted in the previous day
time_range = (Time.now.midnight - 1.day)..Time.now.midnight
Comment.joins(:posts).where('posts.created_at' => time_range)
```

As we've seen previously, when performing a `JOIN`, it's typical to
namespace the joined record under the table name; this distinguishes
`posts.created_at` from the `comments.created_at`.

An alternative syntax is to nest the hash conditions:

```ruby
# fetch comments on `Posts` posted in the previous day
time_range = (Date.yesterday)..Date.today
Comment.joins(:posts).where(:posts => { :created_at => time_range })
```

This will again find all comments on `Posts` posted
yesterday, again using a `BETWEEN` SQL expression.

## Scopes

When we have a big long query, it's common to wrap it up in a method:

```ruby
# app/models/user.rb
class User
  # ...

  def most_popular_posts
    user
      .posts
      .select("posts.*, COUNT(*) AS comment_counts")
      .joins(:comments)
      .group("posts.id")
  end
end
```

Now we can write `user.most_popular_posts` and get them.

If we write a query like this as a class method, we'll get additional
powers:

```ruby
class Post
  def self.most_popular_posts
    self
      .select("posts.*, COUNT(*) AS comment_counts")
      .joins(:comments)
      .group("posts.id")
  end
end
```

This is called a `scope`. Of course, we can now write
`Post.most_popular_posts`. Through a bit of Rails magic, we may also write
`user.posts.most_popular_posts`.

This is possible because `user.posts` returns an `Array` that will "mix-in"
the class methods defined in `Post`. Further, the `Array` will not actually
fire the DB query until we try to access the results; by calling
`most_popular_posts` before the results are used, ActiveRecord knows to
modify the query for the `Post`s to only return the most popular ones.

```
1.9.3p194 :011 > gizmos = User.where(:user_name => "gizmo"); nil
 => nil
1.9.3p194 :012 > gizmos
  User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."user_name" = 'gizmo'
 => [#<User id: 1, user_name: "gizmo", first_name: "Gizmo", last_name: "Ruggeri", created_at: "2013-03-31 08:57:01", updated_at: "2013-03-31 08:57:01">]
```

Notice how the query was not fired until we actually tried to access
`gizmos`. I explicitly added `; nil` to the first line to keep irb from
trying to print `gizmos`. Later, when I type `gizmos` alone, irb needed the
results to print, so the fetch was forced. Up until that time, I could have
used a scope to filter my results.

Use scopes to keep your query code DRY: move frequently-used,
complicated queries into a scope. It will also make things much more
readable by giving a convenient name of your choosing to the query.

## References

* http://stackoverflow.com/questions/97197/what-is-the-n1-selects-problem
* http://stackoverflow.com/questions/6246826/how-do-i-avoid-multiple-queries-with-include-in-rails
