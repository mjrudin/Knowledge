# Baseball

## Setup

**Instead of all downloading; bug Sean and use his thumbdrive and
sneakernet the files.**

Download MySQL dump from [Baseball Databank][baseball-databank].

Create a new baseball db to hold the baseball tables:

```
~$ mysql -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2634
Server version: 5.5.29 MySQL Community Server (GPL)

Copyright (c) 2000, 2012, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE baseball;
Query OK, 1 row affected (0.00 sec)
```

Then import the data:

```
~$ cat Downloads/BDB-sql-2011-03-28.sql | mysql -u root baseball
```

Create a new rails project, add the `mysql2` gem to the Gemfile (and
run `bundle install`) and setup the db connection as before:

```
development:
  adapter: mysql2
  host: localhost
  port: 3306
  database: baseball
  user: root  
  pool: 5
  timeout: 5000
```

[baseball-databank]: http://www.baseball-databank.org/

## Models

* `Master` represents a person. Name your model `Person` but set the
  table name to `Master`. The primary key in this table is `lahmanID`,
  but to join with `Pitching` and `Batting` use `playerID`. For
  joining with `Managers`, use `managerID`. For Hall of Fame, use
  `hofID`. Yes, that seems nuts.
* `Appearances` list number of games (and position) that player played
  for each team, year. Maybe call this `PlayerStint`.
* Models for `Pitching` and `Batting` would be better named
  `PitchingLine` and `BattingLine`. Run `DESCRIBE Batting` to check
  the composite primary key; note that a *stint* column lets a player
  play for the same team more than once each year (if he was traded
  then traded back).
* `Teams` represents a single team's season; the composite primary key
  is `(yearID, lgID, teamID)`. Not sure why `lgID` was included in the
  key.
    * `teamID` changes when a team moves (`PHA` to `OAK` when
      Athletics moved in 1954).
* `Managers`; probably call this `ManagerStint` or somesuch. `inseason`
  is like `stint`; a manager managed nine teams.  in a year?
  [Wtf?](http://en.wikipedia.org/wiki/El_Tappe)
* `Salaries` is pretty straightforward.
* `HallOfFame` (more accurately, HOF candidacy) has voters (players or
  writers) and votes, plus whether they won the ballot. A vote is
  taken each year; players who don't make it on their first go are
  often voted on again the subsequent year.

## Composite keys

In this exercise, many of the tables have composite primary keys. For
instance, `Team` has a primary key `(teamID, yearID, lgID)`.

Rails wants a primary key so that it can look up rows (either to fetch
them or to update them). Whenever you use `find` or update a record,
AR looks up the value in the pk column:

```ruby
> item = Item.find(101)
# => SELECT * FROM items WHERE id = 101;
> item.attribute = "other value"
> item.save
# => UPDATE items SET attribute = "other value" IN WHERE id = 101;
```

If the conventional `id` pk column does not exist, then you won't be
able to `find` or `save` unless you set the pk explicitly. Rails
doesn't support composite primary keys out of the box, but simply add
the followin line to your gemfile:

    gem 'composite_primary_keys'

and `bundle install`. You may now update `Team` like so:

```ruby
class Team < ActiveRecord::Base
  set_primary_keys(:teamID, :yearID, :lgID)
end
```

We may now write `Team.find("BOS", 1990, "AL")`. We can also update
rows and save them.

Even if we don't want to `find`/`save` records with a composite pk, we
want to be able to setup associations to these records:

```ruby
class ManagerStint
  # to join ManagerStint with Team, need to use the multiple pk.
  belongs_to :team, :foreign_key => [:teamID, :yearID, :lgID]
end
```

## Associations
* `Person` player associations
    * to appearances
    * to teams (through appearances)
    * to batting and pitching stat lines
    * to salaries
* `Person` managemer
    * managerial lines
    * managed teams
* Note that a person has two associations to teams (as player, as
  manager). If you name the two associations `played_teams` and
  `managed_teams`, then Rails will not be able to guess the
  class/table names from the association names. Look into how I used
  the `:class_name` option in URLShortener and JoinsDemo.

## Queries
### Stats
* Find all `Person`s who have a batting average >.300 in at least 100
  at bats.
    * Batting average is hits (H) divided by at bats (AB)
* Find the player with the longest experience.

### Managers
* Find manager who managed the most players.
* Find managers who also had been players.

### Teams
* Find players who played for the most teams in a year.
* Find players who played for exactly one team their whole career.
* Find players who have played for at least `n` years.
* Find players who has played for the most teams in his career.
* Find teams that made the biggest improvement in games won in the
  course of two years.
* Find teams that have moved the most.

### World Series
* Write a `Team` scope to select WS winning teams.
* Write a `Team` scope to select WS losers (they won their league, at
  least, before losing WS).
* Write a query to list the franchises that have won the most World Series.
    * List all teams having won >1 time
* List all players who have won a world series.
* Find players who have won the World Series the most.

### Salary
* For each year, who was highest paid player? For each team?
* Who was paid most over their career?
* Find total salaries of teams; which teams paid the most in a season?

### Hall of Fame
* What teams have the most HOF winners?
* What teams have had the most HOF nominations?
* What players have have had the most HOF votes but not been elected?

## TODO
* **TODO**: didn't know how to setup primary/foreign key relationship
  for `lahmanID`/`playerID`.
    * Also, why even set `lahmanID`?
* **TODO**: SQLPro
* **TODO**: rename tables.
* **TODO**: always be reading the SQL output!

### More tables
* `BattingPost`/`PitchingPost` are just post-season versions.
* `TeamsHalf` just  has W/L at half
* AllstarFull
* AwardsManagers
* AwardsPlayers
* AwardsShareManagers
* AwardsSharePlayers
* Fielding
* FieldingOF
* Schools
* SchoolsPlayers

