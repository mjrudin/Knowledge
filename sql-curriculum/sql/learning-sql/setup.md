# Learning SQL Setup

## Installing Postgres

First, download and install [Postgres.app][postgres-app]. This is already
installed on the class Mac minis.

Follow the directions to add the
[command line tools][pg-command-line-tools] to your `$PATH` so that
you may use them in the terminal. This will involve adding
`PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH"` to your
`~/.bashrc` file.

Also, at the same time, add the following line to your `~/.bashrc`:

    export DYLD_LIBRARY_PATH="/Applications/Postgres.app/Contents/MacOS/lib:$DYLD_LIBRARY_PATH"

This will allow programs like Rails to access your Postgres
database.

You will have to rerun `.bashrc` for the `$PATH` to be updated. The
easiest way to do this is to restart the terminal (alternatively run
`source ~/.bashrc` to force `$PATH` to be reloaded). If for some
reason putting it in `.bashrc` didn't help, put it in `.bash_profile`,
that'll work.

[postgres-app]: http://postgresapp.com/
[pg-command-line-tools]: http://postgresapp.com/documentation#toc_1

## Creating the DB

Make sure Postgres.app is running (it's in your Applications).

First, we need to create the database. Postgres can support multiple
users, each of who might be storing different kinds of data. Users
shouldn't have access to each other's databases, even though they are
all managed by a single *database server* (Postgres is a database
server).

Let's create a blank database named `bank`:

```
~$ psql
psql (9.2.2)
Type "help" for help.

ruggeri=# CREATE DATABASE bank;
CREATE DATABASE
ruggeri=# ^D\q
```

We can connect to our bank DB. We call the `psql`, giving it the name
of the DB we want to connect to.

```
~$ psql bank
psql (9.2.2)
Type "help" for help.

bank=# \d
No relations found.
bank=#
```

### Importing the data

There's no data imported yet, so our db is a lonely place (`\d` is a special
Postgres command to list the tables). Let's run the import script (which sets
up the tables and adds the initial records). Download my version of the
[LearningSQLExample.sql][learning-sql-example] script; I've modified it to
work with Postgres.

[learning-sql-example]: https://github.com/appacademy/sql-curriculum/blob/master/projects/learning-sql-example-postgres.sql

The `learning-sql-example-postgres.sql` file contains SQL commands. To run
them we need to "pipe them in" to `psql bank`. This is what the shell's `|`
operation does: `cat learning-sql-example-postgres.sql | psql bank` takes the
*output* of the first command (`cat learning-sql-example-postgres.sql`, which
just outputs the contents of the file) and uses it as the *input* of the
command on the right (`psql bank`, which runs SQL commands).

```
~$ cat learning-sql-example-postgres.sql | psql bank
NOTICE:  CREATE TABLE will create implicit sequence "department_dept_id_seq" for serial column "department.dept_id"
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_department" for table "department"
CREATE TABLE
NOTICE:  CREATE TABLE will create implicit sequence "branch_branch_id_seq" for serial column "branch.branch_id"
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_branch" for table "branch"
CREATE TABLE
NOTICE:  CREATE TABLE will create implicit sequence "employee_emp_id_seq" for serial column "employee.emp_id"
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_employee" for table "employee"
CREATE TABLE
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_product_type" for table "product_type"
CREATE TABLE
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_product" for table "product"
CREATE TABLE
CREATE TYPE
NOTICE:  CREATE TABLE will create implicit sequence "customer_cust_id_seq" for serial column "customer.cust_id"
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_customer" for table "customer"
CREATE TABLE
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_individual" for table "individual"
CREATE TABLE
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_business" for table "business"
CREATE TABLE
NOTICE:  CREATE TABLE will create implicit sequence "officer_officer_id_seq" for serial column "officer.officer_id"
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_officer" for table "officer"
CREATE TABLE
CREATE TYPE
NOTICE:  CREATE TABLE will create implicit sequence "account_account_id_seq" for serial column "account.account_id"
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_account" for table "account"
CREATE TABLE
CREATE TYPE
NOTICE:  CREATE TABLE will create implicit sequence "transaction_txn_id_seq" for serial column "transaction.txn_id"
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "pk_transaction" for table "transaction"
CREATE TABLE
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
SELECT 18
UPDATE 2
UPDATE 1
UPDATE 5
UPDATE 3
UPDATE 2
UPDATE 2
UPDATE 2
DROP TABLE
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 3
INSERT 0 2
INSERT 0 2
INSERT 0 3
INSERT 0 1
INSERT 0 2
INSERT 0 1
INSERT 0 2
INSERT 0 3
INSERT 0 2
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 21
```

## Making your first query

Let's check on the data:

```
~$ psql bank
psql (9.2.2)
Type "help" for help.

bank=# \d
                  List of relations
 Schema |          Name          |   Type   |  Owner
--------+------------------------+----------+---------
 public | account                | table    | ruggeri
 public | account_account_id_seq | sequence | ruggeri
 public | branch                 | table    | ruggeri
 public | branch_branch_id_seq   | sequence | ruggeri
 public | business               | table    | ruggeri
 public | customer               | table    | ruggeri
 public | customer_cust_id_seq   | sequence | ruggeri
 public | department             | table    | ruggeri
 public | department_dept_id_seq | sequence | ruggeri
 public | employee               | table    | ruggeri
 public | employee_emp_id_seq    | sequence | ruggeri
 public | individual             | table    | ruggeri
 public | officer                | table    | ruggeri
 public | officer_officer_id_seq | sequence | ruggeri
 public | product                | table    | ruggeri
 public | product_type           | table    | ruggeri
 public | transaction            | table    | ruggeri
 public | transaction_txn_id_seq | sequence | ruggeri
(18 rows)

bank=# SELECT * FROM customer LIMIT 2;
 cust_id |   fed_id    | cust_type_cd |       address       |   city    | state | postal_code
---------+-------------+--------------+---------------------+-----------+-------+-------------
       1 | 111-11-1111 | I            | 47 Mockingbird Ln   | Lynnfield | MA    | 01940
       2 | 222-22-2222 | I            | 372 Clearwater Blvd | Woburn    | MA    | 01801
(2 rows)
```

Yay! You're good to go!
