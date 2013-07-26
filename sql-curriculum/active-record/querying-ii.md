# Querying II

## Finding by SQL

We've seen that we can pass `#where` and `#joins` SQL to execute.

If you'd like to use your own SQL to find records in a table you can
use `find_by_sql`. The `find_by_sql` method will return an array of
objects. For example you could run this query:

```ruby
Case.find_by_sql(<<-SQL)
      SELECT cases.*
        FROM cases
        JOIN (
        // the five lawyers with the most clients
          SELECT lawyers.*
            FROM lawyers
            LEFT OUTER JOIN clients
              ON lawyers.id = clients.lawyer_id
           GROUP BY lawyers.id
            SORT BY COUNT(clients.*)
           LIMIT 5
        )
          ON ((cases.prosecutor_id = lawyer.id) OR (cases.defender_id = lawyer.id))
SQL
```

Here we've used a
[heredoc](http://en.wikipedia.org/wiki/Here_document#Ruby). This is
very common when working with embedded SQL.

## Dynamic Finders

We've seen how to use `where` to retrieve an array of AR objects
matching some conditions. Sometimes, you want to find the single
object that matches some criteria; you want to dispense with the array
(which in this case will be either empty, or length 1). We use
*dynamic finders* for this:

    Application.find_by_email_address("ned@appacademy.io")
    Application.find_all_by_current_city("San Francisco")    

For any column `X` a AR model will respond to a message
`find_by_X`/`find_all_by_X`. To do this, AR overrides
`method_missing?`. You can even get crazy:
`find_all_by_X_and_Y_and_Z`, passing three arguments. Wow.

## Ordering

To retrieve records from the database in a specific order, you can use
the `order` method.

For example, if you're getting a set of records and want to order them
in ascending order by the `created_at` field in your table:

```ruby
Client.order("created_at")
```

You could specify `ASC` or `DESC` as well:

```ruby
Client.order("created_at DESC")
# OR
Client.order("created_at ASC")
```

Or ordering by multiple fields:

```ruby
Client.order("orders_count ASC, created_at DESC")
# OR
Client.order("orders_count ASC", "created_at DESC")
```

If you want to call `order` multiple times e.g. in different context,
new order will prepend previous one

```ruby
Client.order("orders_count ASC").order("created_at DESC")
# SELECT * FROM clients ORDER BY created_at DESC, orders_count ASC
```

## Group, Having

You can apply `GROUP BY` and `HAVING` clauses. Since these are
somewhat less common to use, for now, simply remember to consult the
documents if you need this functionality.

## Calculations

This section uses count as an example method in this preamble, but the
options described apply to all sub-sections.

All calculation methods work directly on a model:

```ruby
Client.count
# SELECT count(*) AS count_all FROM clients
```

Or on a relation:

```ruby
Client.where(:first_name => 'Ryan').count
# SELECT count(*) AS count_all FROM clients WHERE (first_name = 'Ryan')
```

You can also use various finder methods on a relation for performing
complex calculations:

```ruby
Client.joins("LEFT OUTER JOIN orders").where(:first_name => 'Ryan', :orders => {:status => 'received'}).count

```

Which will execute:

```sql
SELECT count(DISTINCT clients.id) AS count_all FROM clients
  LEFT OUTER JOIN orders ON orders.client_id = client.id WHERE
  (clients.first_name = 'Ryan' AND orders.status = 'received')
```

Here are the calculations:

### Count

If you want to see how many records are in your model's table you
could call `Client.count` and that will return the number. If you want
to be more specific and find all the clients with their age present in
the database you can use `Client.count(:age)`.

### Average

If you want to see the average of a certain number in one of your
tables you can call the `average` method on the class that relates to
the table. This method call will look something like this:

```ruby
Client.average("orders_count")
```

This will return a number (possibly a floating point number such as
3.14159265) representing the average value in the field.

### Minimum

If you want to find the minimum value of a field in your table you can
call the `minimum` method on the class that relates to the table. This
method call will look something like this:

```ruby
Client.minimum("age")
```

### Maximum

If you want to find the maximum value of a field in your table you can
call the `maximum` method on the class that relates to the table. This
method call will look something like this:

```ruby
Client.maximum("age")
```

### Sum

If you want to find the sum of a field for all records in your table
you can call the `sum` method on the class that relates to the
table. This method call will look something like this:

```ruby
Client.sum("orders_count")
```

## References

* http://guides.rubyonrails.org/active_record_querying.html
