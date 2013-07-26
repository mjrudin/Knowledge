# Question Pairs

Build an application that will help us handle questions from students.

**Read the entire project description before beginning**.

What we'll be doing is setting up the database and then overlaying
Ruby code to map the data from the database into Ruby objects in
mermory that we can work with. Our database queries (written in SQL)
will live within our Ruby code.

## SQL

We'll first construct a series of tables. Write the table definitions in
a SQL script named `import_db.sql`.

* Add a `users` table.
    * Should track `fname` and `lname` attributes.
* Add a `questions` table.
    * Track the `title`, the `body`, and the associated author
    (a foreign key).
* Add a `question_followers` table.
    * This should support the many-to-many relationship between
    `questions` and `users` (a user can have many questions she
    is following, and a question can have many followers).
    * This is an example of a ***join table***; the rows in
    `question_followers` are used to join `users` to `questions`
    and vice versa.
* Add a `replies` table.
    * Each reply should contain a reference to the subject question.
    * Each reply should have a reference to its parent reply.
    * "Top level" replies don't have any parent, but all replies have a
      subject question.
* Add a `question_likes` table.
    * Users can like a question.
    * Have references to the user and the question in this table

You will probably also want to write some `INSERT` statements at the
bottom of your `import_db.sql` file, so that you have some data to play
with. We call this '*seeding the database*.'

## Ruby

Write a `QuestionsDatabase` class similar to my
[SchoolDatabase][school.rb] in the demo. This class should inherit from
`SQLite3::Database`; you will only need one instance. If you use the
`Singleton` module like I do, this will be available through a
`QuestionsDatabase::instance` method.

[school.rb]: https://github.com/appacademy/sql-curriculum/blob/master/sql/demos/first-sql-demo/school.rb

*NB: A singleton is a general programming pattern that describes a
scenario in which you will only have a single instance of a particular
class. Ruby's [Singleton module][ruby-singleton] helps implement this
pattern - it ensures that only one instance of that class is ever
created (make sure you use the `instance` method.*

[ruby-singleton]: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/singleton/rdoc/Singleton.html

The `QuestionsDatabase` class will handle the connection to the
database, but when we query the database, we get back a hash of data.
That can be a bit ugly to work with, especially when dealing with
multiple tables.

What we'll do to make this easier on ourselves is abstract away the
communication to each of those tables into objects. We'll create a
'model' class for each table that will represent an item from each of
the tables and abstract away the SQL queries. This will give us an
object-oriented way to interact with the database.

*NB: This pattern of abstracting away data storage and manipulation
is a common one and an extremely helpful one.*

* Write one class per table (`questions` table => `Question` class).
* For each class, add a class method `find_by_id` which will lookup an `id`
  in the table, and return an *object* representing that row.
    * We'll add additional query class methods as needed. For instance, you
      may want `User::find_by_name(fname, lname)`.
* Your initialize method should take an options hash of attributes and construct an object "wrapping" that data:
    * E.g., `User.new(:fname => "Ned", :lname => "Ruggeri", :is_instructor =>
      true)` should return a `User` object with those attributes.
    * Since `SQLite3::Database` returns you hashes for rows (column names are
      keys, column values are values), you can easily wrap the results of a
      SQL query in your model objects.
* Add attribute methods to return the values of the various columns.
    * E.g., `User#fname` will return the `fname` of the `users` row it wraps.

## Queries

Each query method should return *objects* of the appropriate type. For
instance, `user.asked_questions` should return an `Array` of `Question`
objects.

### Easy

None of these involve joins.

* `User::find_by_name(fname, lname)`
* `User#authored_questions`
* `User#authored_replies`
* `Question::find_by_author_id`
    * Will want to use this in `User#authored_questions`
* `Question#author`
* `Question#replies`
* `Reply::find_by_question_id`
    * All replies to the question at any depth
    * Use this for `Question#replies`
* `Reply::find_by_user_id`
    * Use this for `User#authored_replies`
* `Reply#author`
* `Reply#question`
* `Reply#parent_reply`
* `Reply#child_replies`
    * Only do child replies one-deep; don't find grandchild comments.

### Medium

All of these involve joins.

* `QuestionFollower::followers_for_question_id`
* `QuestionFollower::followed_questions_for_user_id`
* `User#followed_questions`
    * One-liner calling `QuestionFollower` method.
* `Question#followers`
    * One-liner calling `QuestionFollower` method.

### Hard

These involve `GROUP BY` and `ORDER`. **Use `JOIN`s to solve these, do not
use Ruby iteration methods**.

* `QuestionFollower::most_followed_questions(n)`
    * Fetches the `n` most followed questions.
* `Question::most_followed(n)`
    * Simple call to `QuestionFollower`

Add a `QuestionLike` *join table* to join `User`s with `Question`s that they
have liked. Some easy queries:

* `QuestionLike::likers_for_question_id(question_id)`
* `QuestionLike::num_likes_for_question_id(question_id)`
    * Don't just use `QuestionLike::likers_for_question_id` and count; do a
      SQL query to just do this.
    * This is more efficient, since the SQL DB will return just the number,
      and not the data for each of the likes.
* `QuestionLike::liked_questions_for_user_id(user_id)`

These instance methods are one-liners with the above:

* `Question#likers`
* `Question#num_likes`
* `User#liked_questions`

And some harder queries with likes:

* `QuestionLike::most_liked_questions(n)`
* `Question::most_liked(n)`
    * Fetches `n` most liked questions.
* `User#average_karma`
    * Avg number of likes for a `User`'s questions.
    * This is the hardest question.

### Updating/saving records

So far we haven't created any new records; we've only been parsing data
fetched from the database and performing queries.

Let's see how to create a new object. Let's add a `#save` method to our
models (`User`, `Question` and `Reply` are enough to get the point). If
the model has not been saved (its `id` attribute is `nil`), we should
perform an `INSERT` of the record's fields into the DB. After the
insert, we can use `SQLite3::Database#last_insert_row_id` to get the
newly issued `id` for the inserted row. Save this in an `@id` instance
variable in your object. Future calls to `#save` on this object should
issue an `UPDATE`.

If a model already exists in the DB, it should have a non-nil `id`
attribute. Calls to `#save` should issue an `UPDATE` SQL command for the
row with the object's id. Update all the columns with the current
version of the values in your object.

The user should be able to get and set the attributes on the object you
hand him through reader and writer methods (`attr_accessor`).

*NB: Now that you have an `id` attribute in the model, should you accept
an `id` in the `initialize` options hash or allow the user to set the
`id` of the object through an accessor method? Definitely not. You'd
be giving a user of your objects the power to overwrite arbitrary rows
in the database. You gave the user `Question` with `id` 5, and he
changed the `id` to 10 and hit `#save`. There goes question number
10's data. You have two options to deal with this: the first is to
simply ignore any `id` that is ever passed in by the user. The second
is to throw an exception if the user attempts to pass in an `id`
attribute. The former is simpler and what we'll prefer.*

## Bonus

You may notice that your #save method looks very similar in each model.
Can you refactor your code so that they all share the same #save method?

### Taggings

* Add a `tags` table (names of tags include "html", "css", "ruby", "javascript").
* Add a `question_tags` table; this is a join table between question and tags.
* Add a `Tags::most_popular` which returns the most popular questions for
  each tag.
