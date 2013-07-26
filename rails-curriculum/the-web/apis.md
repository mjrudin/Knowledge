# APIs

## Goals
* Know what an API is.
* Know how to use RestClient to make the four standard HTTP requests.
  * Know how to send a payload.
* Know how to use addressable/uri to format URLS.

## What is an API?
Skillcrush has a good [description][skillcrush] of what an API
is. When humans use a browser to visit a website, the browser submits
an HTTP request, and the server replies with HTML which represents the
structure of the page to be displayed. The web browser then *renders*
the HTML: it turns the HTML code into the graphics that are displayed
on your screen. Users then interact with the page by clicking links or
hitting buttons, making new HTTP requests which continue the cycle.

A [Web API][wiki-api] (Application Programming Interface) is a
different way of interacting with a web application that makes it easy
for another computer program (a *client*) to interact with the
application. For instance, maybe you're writing a command line program
to check your tweets on Twitter. A program like this doesn't need all
the extra layout information that is contained in HTML; you just want
the raw tweet data, which you will decide how to present to the user
in the terminal.

Because the page layout information encoded in HTML is unnecessary and
only the data matters, the client and server typically communicate by
passing around a simpler, data-oriented format like [JSON][wiki-JSON] or [XML][wiki-XML].

Because no HTML is returned, there are no links to click. How do you
know what requests to make to the server? For instance, how would we know
how to GET a tweet from Twitter?

The answer is that API providers publish documentation describing how
to use the API. For example, see Twitter's [docs][twitter-doc]. These
documents describe the HTTP requests you can make to the server, how
to use them, and what they do.

By using APIs your program can interact with the outside world. It
could read tweets from Twitter, it could make posts to Reddit, etc.

[skillcrush]: http://www.skillcrush.com/terms/api.html
[twitter-doc]: https://dev.twitter.com/docs/api/1.1/get/statuses/show/%3Aid
[wiki-JSON]: http://en.wikipedia.org/wiki/JSON
[wiki-XML]: http://en.wikipedia.org/wiki/Xml

## RestClient
We've talked a lot about HTTP requests. But we haven't seen how to
write programs that issue requests yet. In Ruby, we'll use the
RestClient gem to do this.

Here's how to issue a GET request with RestClient:

```ruby
> require 'rest-client'
> puts RestClient.get("http://graph.facebook.com/kush.patel2")
#=> {"id":"2906705","name":"Kush Patel","first_name":"Kush","last_name":"Patel","username":"kush.patel2","gender":"male","locale":"en_US"}
```

RestClient has made the GET request, and it returns the contents as a
string. Because the response is in JSON format, we can parse the JSON
object and create a Ruby Hash out of it:

```ruby
> require 'json'
> response = RestClient.get("http://graph.facebook.com/kush.patel2"))
> kush = JSON.parse(response)
> kush.class
#=> Hash
> kush["name"]
#=> "Kush Patel"
```

Now the response from Facebook has been fully interpreted and
translated into a Ruby object.

We can also make a POST request like so:

```ruby
> endpoint = "http://www.reddit.com/api/submit"
> params = {
    :title => "Cats! Cash! Cats!", # post title
    :url => "http://cashcats.biz", # post url
    :sr => "cats",                 # subredit
    :kind => "link",               # kind of post
    :uh => "f0f0f0f0"              # don't worry about this one yet
  }
> RestClient.post(endpoint, params)
```

This POSTs the link submission parameters to the *endpoint*; endpoint
is another name for a resource used by an API.

Here we're POSTing a cashcats submission to Reddit.

Likewise there are `RestClient.put` and `RestClient.delete`
methods. They operate similarly.

Learn more about [RESTful][Restful-so] web development:
[Restful-so]: http://stackoverflow.com/questions/671118/what-exactly-is-restful-programming

## Formatting URLs
It can be a pain to hard-code long URL strings into your code. This is
particularly annoying if you need to update the values, or if you have
query strings. In general, don't store encoded data like that: get
Ruby to do the work for you.

Install the `addressable` gem, then you can use:

```ruby
 > require 'addressable/uri'
 > Addressable::URI.new(
   :scheme => "http",
   :host => "www.bing.com",
   :path => "search",
   :query_values => {:q => "test"}
 ).to_s
 => "http://www.bing.com/search?q=test"
```

The advantage to this is especially felt when updating query values;
you won't have to futz with converting to URL encoding yourself.


## SDK

We've been talking about how your programs can make HTTP requests to a
web service. Sometimes it is nice to deal with a higher level of
abstraction that handles making those requests for us. For instance,
there are gems like [Koala][koala-github] for Facebook or
[twitter][twitter-github] that provide a Ruby interface to interact
with those services. By using a library like this (often called a
*software developer kit*) you can rely on someone else mastering the
details of the API for you and instead interact with a clean Ruby
interface.

[wiki-api]: http://en.wikipedia.org/wiki/API#Web_APIs
[koala-github]: https://github.com/arsduo/koala
[twitter-github]: https://github.com/sferik/twitter

