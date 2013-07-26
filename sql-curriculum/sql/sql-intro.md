# SQL

## Databases

Most real-world applications require some form of persisted data - that
is, data that is going to be saved over the lifecycle of the application
and not just over the lifecycle of the application's instance in memory
(instance variables, of course, die when the application instance dies).
Applications usually also require rich relationships between pieces of
data - users have many posts and posts have many tags and users may be
following other users and so on.

Relational databases (also sometimes referred to as RDBMS, relational
database management systems) were developed to provide a means of
organizing  data and their relationships, persisting that data, and
querying that data.

## Tables

Relational databases organize data in tables.


*A table of users*:

```
id |   name   |  age
1     John        22
2     James       24
3     Sally       54
4     Bob         48
5     Lucy        33
6     Mary        98

```

Each row is a single entity in the table. Each column houses an
additional piece of data for that entity.

Every row in a database table will have a primary key which will be its
unique identifier in that table row. By convention, the primary key is
simply 'id'. Most relational database systems have an auto-increment
feature to ensure that the primary keys are always unique.

Breaking your domain down into database tables & columns is an important
part of developing any application. Each table will house one type of
resource - think nouns. The columns in that table will house the data
associated with that object.

## Database Schemas

Your database ***schema*** is a description of the organization of your
database into tables and columns.

It is often the first and most important element in the design of an
application because it forces you to ask a basic but essential question:
what data does my application need to function?

When implementing a database schema, you must decide on three things:

* the tables you will have,
* the columns each of those tables will have,
* and the data type of each of those columns.

Schemas are mutable and so the decisions up front are not at all set in
stone.

New to us is the concept of *static typing*. Ruby is dynamically typed -
that is, for example, there is no need to specify in method parameters
or arrays or anything else the *class* of the data coming in. You can
throw in whatever you'd like without worry. SQL is not quite so
flexible; you must specify the type of data that will go into each
column.

Data types vary on various database implementations, but common ones
include:

* CHAR
* VARCHAR
* TEXT
* INT
* REAL
* FLOAT
* DATE
* DATETIME
* TIME
* BOOLEAN
* BLOB

Most are pretty self-explanatory. CHAR is usually a single character,
VARCHAR is a string of up to 255 characters, REAL and FLOAT store
decimal numbers, and BLOB stores binary data.

We'll see how exactly we create tables and specify columns and column
types in just a bit.

## Modeling Relationships

So we have a way to store users and additional bits of data on them, but
how would we store associated entities like posts or comments?

Well, we probably have the sense that they should be in their own tables
since they're not really additional attributes on a user (which would
call for additional columns) nor are they users themselves (which would
call for additional rows). If posts were in their own table, though, how
would we know that they were associated with a particular user?

We model these relationships between entries in separate tables through
***foreign keys***. A foreign key is a value in a database table whose
responsibility is to point to a row in a different table. Check out the
posts table below (and pretend that people were a bit more creative in
their titles and bodies).

*A table of posts*:

```
id |   title   |     body    |  user_id
1     'XXXX'       'xyz...'       3
2     'XXXX'       'xyz...'       5
3     'XXXX'       'xyz...'       7
4     'XXXX'       'xyz...'       10
5     'XXXX'       'xyz...'       2
6     'XXXX'       'xyz...'       5

```

The `user_id` column is a foreign key column. If we wanted to find all
the posts for the user with `id` 5, we'd look in the posts table and
retrieve all the posts where the `user_id` column had a value of 5.

By convention, the foreign key in one table will reference the primary
key in another table. We usually call the column that houses the foreign
key *other_table_name_singularized_*id.

Foreign keys are how we model relationships between pieces of data
across multiple tables. This also allows us to ensure that data is not
duplicated across our database. Posts live in a single place, users in
another, and never the twain shall dirty each other's tables except for
a single, simple foreign key.

*NB: The idea that databases should limit the amount of duplicated data across tables is called* **database normalization**.

## Structured Query Language (SQL)

So, now that we know what these tables look like and generally how
relationships are modeled between them, how do we actually get at the
data?

Enter SQL. SQL is a domain-specific programming language that's designed
to query data out of relational databases.

Here's a sample SQL query (we'll break it down in just a second):

```
SELECT
  name, age, smoker
FROM
  customers
WHERE smoker = true
  AND age > 50;
```

SQL queries are broken down into clauses. Here, there is the `SELECT`
clause, the `FROM` clause, and the `WHERE` clause. `SELECT` takes a list
of comma-separted column names, `FROM` takes a table name, and `WHERE`
takes a list of conditions separated by `AND` or `OR`.

All SQL queries end in a semicolon.

SQL provides powerful filtering with `WHERE`; it supports a wide range
of comparison and equality operators (<, >, >=, <=, `BETWEEN`, etc.) as
well as grouping with parentheses and logical operators (`AND`, `OR`,
`NOT`).

There are 4 main data manipulation operations that SQL provides:

* `SELECT`: retrieve values from one or more rows (and tables)
* `INSERT`: insert a row
* `UPDATE`: update values in one or more existing rows
* `DELETE`: delete one or more rows

Below are brief descriptions of each of the operators syntactical
signatures and a couple simple examples of their use:

`SELECT`

```
Structure
  SELECT one or more columns (or all columns with *)
  FROM one or more tables (joined with JOIN)
  WHERE one or more conditions (joined with AND/OR);


  SELECT
    *
  FROM
    users
  WHERE name = 'Ned';

  SELECT
    account_number, account_type
  FROM
    accounts
  WHERE customer_id = 5
    AND account_type = 'checking';
```

`INSERT`

```
Structure
  INSERT INTO table name (column names)
  VALUES (values);


  INSERT INTO
    users (name, age, height_in_inches)
  VALUES
    ('Santa Claus', 876, 34);

  INSERT INTO
    accounts (account_number, customer_id, account_type)
  VALUES
    (12345, 76, 'savings');
```

`UPDATE`

```
  Structure
    UPDATE table_name
    SET col_names=values
    WHERE conditions


    UPDATE
      users
    SET
      name = 'Eddard Stark', house = 'Winterfell'
    WHERE name = 'Ned Stark';

    UPDATE
      accounts
    SET
      balance = 30
    WHERE id = 6;
```

`DELETE`

```
  Structure
    DELETE FROM table_name
    WHERE conditions


    DELETE FROM
      users
    WHERE name = 'Eddard Stark'
      AND house = 'Winterfell';

    DELETE FROM
      accounts
    WHERE customer_id = 666;
```

## Schema Definitions

Before basic querying can take place though, you need to actually define
your database schema. There are three operators that SQL provides to
manipulate a database schema:

* `CREATE TABLE`
* `ALTER TABLE`
* `DROP TABLE`

Here's an example of creating a users table (we'll break it down
shortly):

```
CREATE TABLE users (
  id INT,
  name VARCHAR(100) NOT NULL,
  gender CHAR(1) CHECK (gender IN ('M','F')),
  birth_date DATE,
  house VARCHAR(20),
  favorite_food VARCHAR(20),
  UNIQUE(favorite_food),
  PRIMARY KEY (id)
);
```

`CREATE TABLE` first specifies the name of the table, and then in
parantheses, the list of column names along with their data types.

Other things you can and will do in these statements is specify
***database constraints***. The above table definition specifies
several. It specifies that the name must not be null (that is, it must
have a name value), that gender must be 'm' or 'f', that favorite_food
must be unique in the table, and that id is the primary key (which will
enforce uniqueness as well as provide an index on that column to enable
faster lookup).

As mentioned before, different database implementations have different
data types. For complete coverage of what each of the databases that
we'll be exposed to in this class offer, see the [SQLite][sqlite-data],
[PostgreSQL][postgres-data], and [MySQL][mysql-data] docs.

[sqlite-data]: http://www.sqlite.org/datatype3.html
[postgres-data]: http://www.postgresql.org/docs/9.2/static/datatype.html
[mysql-data]: http://dev.mysql.com/doc/refman/5.0/en/data-types.html

## Querying across multiple tables (JOIN)

If we've specified a bunch of foreign keys in many tables, at some
point, we'll want to access that rich relational data. So far we've only
seen ways to query a single table. How might we query across tables?

SQL provides a powerful facility to do so: the `JOIN`. A `JOIN` will do
just what you'd expect it to do: it joins together two tables. With
`ON`, you specify how exactly those two tables relate to one another.
This is where the foreign key comes in. Check out the simple join below.

A query to retrieve all the posts written by user #7.

```
SELECT
  posts.*
FROM
  posts
JOIN
  users ON posts.user_id = users.id
WHERE
  users.id = 7
```

`JOIN goes hand in hand with ON. In this case, it specifies that the two
`tables are related to one another through user_id on the posts table
`and id on the users table.

You'll read much more about `JOIN` in the SQL book.
