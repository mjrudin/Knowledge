# Learning SQL: Part III

Part III is to read ch13 in
[Learning SQL (2nd edition)][Learning-SQL]; which is about indexes and
constraints.

[Learning-SQL]: http://www.amazon.com/Learning-SQL-Alan-Beaulieu/dp/0596520832/

## Reading Questions

### Ch 13
* 13.1
  * What is a *database index*?
  * Why would you want to create an index?
  * What index is automatically created when you create a table?
  * How do you enforce uniqueness of values in a particular column?
  * Why don't you need to build unique indices on your primary-key
    column(s) ?
  * Why would you use a *multi-column index*?
  * Understand broadly the structure and balancing nature of a *balanced-tree* or *B-tree*.
  * Extra-Credit: 13.1.2.2
  * Play around with the `explain` statement a bit to see how your
    queries get executed
  * Why not index every column?

## References

* [Use the Index Luke][use-the-index]: bonus material on query
  optimization for after the course.

[use-the-index]: http://use-the-index-luke.com/
