# Restaurants Review

In this project, we build an application that will store information
about restaurants. You will be using your metaprogrammed `Model` base
class in this project.

## Model

You should be able to represent and store the following models in your
database (the creation of the tables and columns will of course still be
in a separate SQL script):

* Chef
  * first_name
  * last_name
  * mentor (chef who trained this one; this is self-referential)
* Restaurant
  * name
  * neighborhood
  * cuisine
* ChefTenure
  * Connects chefs with restaurants (a "join table").
  * Should record start date and end date of tenure.
  * Should record whether the chef was the head chef at that time.
  * Many-to-many, because restaurants have had many chefs; a chef can work at
    many restaurants throughout their career.
* Critic
  * screen_name
* RestaurantReview
  * Records a critic's review of a restaurant.
  * text review
  * score (1-20)
  * date of review

As before, create models classes that will represent rows from these
tables. This time, though, they will inherit from `Model`.

## Queries

In addition to being able to create these objects, you should be able
to perform the following queries:

### Easy

*NB: Some of these should be implemented using some of the macros
you defined in `Model`*

* `Restaurant::restaurants_for_neighborhood(neighborhood)`
* `Critic#reviews`
* `Critic#average_review_score`
* `Restaurant#reviews`
* `Restaurant#average_review_score`
* `Chef#proteges`, `Chef#num_proteges`

### Medium

* `Chef#reviews`
    * Use reviews of restaurants when the chef was head chef there.
* `Restaurant::top_restaurants(n)`
    * Find the top `n` restaurants with the best average review.
* `Restaurant::frequently_reviewed_restaurants(min_reviews)`
    * Returns restaurants that have at least `min_reviews` filed.

### Hard

* `Critic#unreviewed_restaurants`
    * Find restaurants a `Critic` has not yet reviewed.
* `Chef#co_workers`
    * Those chefs who worked with this one at the same restaurant at the same
      time.

## Beware date formats!

This project requires you to store dates with SQLite3. The format that
it expects is `YYYY-MM-DD`; anything else it will treat as a string
for comparison purposes. So be careful and store dates in this
format. You may read more on this [StackOverflow post][so-posts].

```sql
CREATE TABLE birth_dates (
  user_id INTEGER,
  birth_date DATE
);

INSERT INTO birth_dates ('user_id', 'date') VALUES (101, '12/25/2012'); -- Wrong format.
INSERT INTO birth_dates ('user_id', 'date') VALUES (101, 2012-12-15); -- Wrong, inserts 1985.
INSERT INTO birth_dates ('user_id', 'date') VALUES (101, '2012-12-15'); -- Yay!
```

SQLite3 is afraid to displease you, and won't speak of your malformed
input. These repressed feelings will come to the surface later when
you perform queries and get bogus dates back.

[so-posts]: http://stackoverflow.com/questions/8187288/sql-select-between-dates
