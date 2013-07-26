# Heredocs: Formatting SQL Queries in Ruby Code

SQL is very hard to read on one line:

```ruby
db.execute("SELECT * FROM posts JOIN comments ON comments.post_id = posts.id")
```

We can use *heredocs* to write a multi-line string more easily:

```ruby
query = <<-SQL
  SELECT *
    FROM posts
    JOIN comments 
      ON comments.post_id = posts.id
SQL

db.execute(query)
```

This replaces `<<-SQL` with the text on the next line, up to the closing
`SQL`. We could use any string for the start and end of a heredoc; `SQL`
is just the convention when we are embedding SQL code.

A heredoc produces a string just like quotes does, and it will return
into the place where the opening statement is.

For example, this works as well (though we'll prefer the above):

```
db.execute(<<-SQL)
  SELECT *
    FROM posts
    JOIN comments 
      ON comments.post_id = posts.id
SQL
```

Heredocs are another way to produce double-quoted strings so keep in
mind that string interpolation is allowed (i.e. "#{some_var}").

You can read more about heredocs at:

* https://makandracards.com/makandra/1675-using-heredoc-for-prettier-ruby-code
