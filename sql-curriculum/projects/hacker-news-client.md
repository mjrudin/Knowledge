# Hacker News Client

**TODO**: pick a better website; HN is hard to scrape because of
ancient templated design, no CSS tags.
**TODO**: precede this with links to W3C's CSS selectors.

Today we're going to build a CLI interface to Hacker News. We will
start by using RestClient and Nokogiri to pull down and parse the HN
page.

## Fetching the data: classes

The first thing to do is to be able to fetch data from the HN
site. You should write classes to represent the various *entities* of
HN. Here are the classes you probably want:

* `Story` (`http://news.ycombinator.com/item?id=5103031`)
    * `#link`
    * `#user_name`
        * later, add another method `#user` which looks up the user
          name and returns a `User` object
    * `#points`
    * `#comments`
        * An array of `Comment` objects; only do this after you finish
          all of `Comment`.
* `Comment` (`http://news.ycombinator.com/item?id=5103154`; looks just
  like a story)
    * `#user_name`
        * later, add another method `#user` to return a `User` object
    * `#parent` (return a `Comment` object)
    * `#body`
    * `#subcomments`
        * returns more `Comment` objects in an Array; this should be
          the last part of `Comment` that you complete
* `User` (`http://news.ycombinator.com/user?id=bhousel`)
    * `#karma`
    * `#stories` (do this after all of `Story` and `Comment`)
    * `#comments` (do this after all of `Story` and `Comment`)

For each entity class, make a class method `::fetch_from_web` that
takes either an item id (`Story` and `Comment`) or a screen name
(`User`) and performs an HTTP request to fetch the data required for
the object.

### Query rate

HN will shut us down if we make lots of requests in a loop. Creating
an instance of each object (`Story`, `Comment`, `User`) **should make
only one request to HN** at a time.

In particular, fetching `Story` should not fetch the associated
`User`; it should just store the poster's screen name. When we call
`#user` later on the `Story` object, this should only then trigger a
fetch.

### Top stories

**Parse each of the above entities before tackling the front page.**
The front page parsing should simply look at the various stories on
the front, and then pull down `Story`s for each.

To avoid hammering HN, just pull down ten stories off the main page
(not the full 30). Put a `sleep(.5)` between queries, to slow down the
query rate.

### POST

Hold off on any POST actions like upvoting or submitting stories.

## CSS Selectors and Parsing HTML

The Bastard's Book of Ruby has a [chapter][css-parsing] on using CSS
selectors to parse a page of HTML. Note they use the open-uri gem, but
you should be able to use the rest-client gem which you've used
before.

Here's an [example][nokogiri-demo] of me finding tenderlove's github
repos.

You can see I used CSS selectors to find the repos. The best way to
find the proper CSS selector is to use Chrome's
['inspect element' feature][inspec-element-guide]. There's also more
on [Stack Overflow][inspect-element-so].

[css-parsing]: http://ruby.bastardsbook.com/chapters/html-parsing/#h-2-2
[nokogiri-demo]: nokogiri-demo.rb
[inspect-element-guide]: https://developers.google.com/chrome-developer-tools/docs/elements
[inspect-element-so]: http://superuser.com/questions/4640/what-is-the-inspect-element-feature-in-google-chrome

## Saving to a DB: caching results

Only after you have your various classes working, begin working to
store your fetched objects to a database. Add a method `#save` to each
of your items. It should insert your object into the database, storing
its fields. Saving already saved objects should update the existing
entry.

Likewise, you should add a class method to each entity,
`::fetch_from_db` that will lookup the item in the database and load
it. Finally, you can add a class method `::fetch` which first tries
the db, then looks for a web version, saving this result to the
database.

### Schema

You'll need multiple tables: one for `stories`, one for `comments` and
one for `users`. `stories` should have a foreign key into the `users`
table, and `comments` should have either a foreign key into `stories`
(top-level comment on a story), or into `comments` (comment in reply
to another comment).

### Caching

This is called *caching*; the process of storing a (possibly
out-of-date) copy of the data close at hand and ready for quick use.
This not only helps HN's load, it helps us if we want our app to work
offline.  If you finish early, add a *fetch time* field to your SQL
entities; if the object is >5min old, you may want to refetch. This
way the data you access is never more than 5min out of date.

## Resources

* More on [CSS selectors at W3C][w3c-css].

[w3c-css]: http://www.w3.org/TR/selectors/
