# HTTP
## Overview

* HTTP is a communication protocol commonly used on
  the internet
* It is a request-response protocol
* It uses four basic methods (GET, POST, PUT, DELETE)
  to issue requests
* The URL encodes multiple pieces of data, mostly to
  route the request properly
* An HTTP request has two main parts: the headers and the body
* An HTTP response has the same (headers and body)
* HTTP status codes specify the result of a response
* Responses usually include HTML or other data in the
  response body

## What is HTTP?
HTTP is the *HyperText Transfer Protocol*. Whenever you visit a
webpage, your browser first issues an HTTP *request* for the page to
the server, which then issues a *response* back to your computer
containing the HTML and content.
HTTP is a request-response protocol.

A *protocol* specifies the format and rules for exchanging
messages. In this case, it's about specifying the rules between
clients (usually a web browser) and servers (a web server hosting
the page).

Let's see an HTTP request get made, and its response. This request is
made from the command line (as opposed to a browser):

![http request cycle](http://upload.wikimedia.org/wikipedia/commons/c/c6/Http_request_telnet_ubuntu.png)

That's a lot, but for now, let's just focus on the structure.
The part in red is the request, and more specifically, the
request headers.

The user specifies a *method* (`GET`), a *resource* (or, in
layman's terms, the "page": /wiki/Main_Page),
the protocol version (http/1.1) and the *host*
(en.wikipedia.org). This request will be routed through the internet
to the host (a server for en.wikipedia.org), which will then fetch the
resource (a GET request fetches a resource), and then send it back to
the requester.

The response from the server is in blue and in green. The green part
is the *body*, or meat of the response. This is the content that was
requested. Here, it's an HTML web page.

The blue part consists of the *headers*; the headers are not part of
the content proper, but they contain valuable information for the
requester. The most important one is the *status code* which tells the
client whether the request was successful. The status code is in the
first line of the headers: "HTTP/1.1 200 OK". 200 is the "OK" status
code; everything worked fine. Other common status codes are for a
missing resource (404 Not Found), a redirection to another resource
(301 Moved Permanently), and an unauthorized request (403 Forbidden).

There are generally many other headers returned, and though they are
sometimes important, usually they are inconsequential for our
purposes.

Let's move on to discuss the protocol methods in a little more detail.

## HTTP methods (verbs)
Each HTTP request that is made asks the server to do something. By far
the most common request is a "GET", which asks the server to fetch a
resource and return it. "POST" is another common request; a POST
request asks the server to accept some uploaded data, and store
it. When you submit a form, you often POST the contents of the form to
the server.

There is also a PUT request, which differs slightly from POST; POST is
used to create new resources (like create a new customer in the
database), while PUT is used to update an existing resource (like
update a customer's address). Like POST, PUT uploads data to the
server.

Finally, there is the DELETE method; this is used to delete an
existing resource; for instance, perhaps we lose a client, and want to
delete the customer from our database.

| Verbs | Use case |
| ----- | -------- |
| GET | Retrieves a resource (*no* side effects, *safe*) |
| POST | Creates a new resource |
| PUT | Modifies a resource |
| DELETE | Deletes a resource |

### Method safety
As we've mentioned, some of these HTTP methods are used to ask a
server to create, modify, or delete data stored in the server's
database. By convention, a `GET` request *should not* result in the
server modifying any data. Writers of web applications *should* ensure
that a `GET` request won't do this, intentionally or otherwise.

A `GET` request is supposed to be "safe"; no harm should be done just
by asking for a representation of a resource. Web crawlers like
googlebot rely on this, because googlebot will follow links (that
result in `GET` requests) but will not make `POST`, `PUT`, or `DELETE`
requests.

In older days, inexperienced devs would not always respect this
convention. For instance, they might create a link to
"posts/1234?delete"; a `GET` request for this resource would delete
the post. But then googlebot came along, crawled all the links on the
page, and deleted all the posts. At the time, Google got a lot of
complaints about this kind of thing.

The solution was to have the googlebots only delete posts when `DELETE` is requested
against "posts/1234" -- with the "?delete" stripped off.  The
method action is expressed by the HTTP verb and not duplicated
within the URL.

Of course, why did they let an unauthenticated user delete posts? :-)

## HTTP and application servers

HTTP requests are processed by web application servers, which are
computer programs that are responsible for generating the
response. The application can respond to the request by doing anything
it wants. It is up to the application to decide that when I make a
`GET` request for `/posts/1234` this means that I want to receive the
HTML for a web page including the content for post #1234.

That would be a reasonable response. But just like we saw with the
delete links, I could respond to this request by deleting a post from
the database, returning a random entry, or just about anything.

The point here is that HTTP is a way to communicate requests and
responses. The methods of HTTP define what the user is requesting of
the server. But it is ultimately the application code on the server
which determines how the requests are processed. In particular: HTTP
doesn't define how the request gets processed; that will be our job
as web developers.

## What's a URL?

[URL][url] is an abbreviation for uniform requests locator, and is commonly known as your everyday web address. By now you've probably seen billions of them, but let's examine the technical parts that make up a URL.

    scheme://host:port/path?query_string#fragment_id

* The **scheme** tells us what protocol we would like to use. The two schemes we are interested in are `http` and `https` ([Https][http-secure] is the secure encrypted version of the http protocol). This is always required.
* The **host** can be either a domain name `www.appacademy.io` or an IP address `107.21.218.20`. This is always required.
* The **port** lets you specify the port of the web server you want to send this request to. This is optional and rarely used. By default `http` will use port 80 and `https` will use port 443. The Rails server you use on your local machine will likely use port 3000, in the form of `http://localhost:3000/`
* The **path** is used to identify different resources on the server. Often it will mimic a directory structure `/users/1/posts/1234`. The path to request the root of a website is `/`.
* The **query string** allows us to send additional information along with our request, in [URL encoded][url-encoding] key-value pairs. The start of the query string is signalled by the question mark `?animal=cat&color=brown`. Key-value pairs are separated by `&` ampersands.
* The **fragment id** is the part after the `#` hash mark. It is used to identify the piece of the web page you want to jump to.

[url]: http://en.wikipedia.org/wiki/Uniform_resource_locator
[http-secure]: http://en.wikipedia.org/wiki/HTTP_Secure
[url-encoding]: http://en.wikipedia.org/wiki/Percent-encoding

## Request body and query string
When we make a POST or PUT request, we can upload content to the
server by embedding it in the request's body. An example that might
create a new Judge entry for [Joe Brown][joe-brown], a TV judge:
[joe-brown]: http://en.wikipedia.org/wiki/Joe_Brown_(judge)

```
POST /judges HTTP/1.1
Host:law.com
Content-type:application/x-http-form-urlencoded

name=Joe+Brown&court=television+court
```

Here the request content is `name=Joe+Brown&court=television+court`,
which is in a format called URL encoding. We specify the content-type
in a request header so that the server knows how to decode the
payload. URL encoding is also often used for request bodies, but other
formats like JSON are supported.

GET requests don't have a body. How can a GET request send data to the
server? For instance, to perform a search, we might make a GET request
to www.bing.com for the `/search` resource. This asks the server to
perform a search, but for what?

We embed our query in the *query string*. The query string is an
optional part of the resource, separated from the rest by a question
mark. For example, in the url

    www.bing.com/search?q=where+in+the+world+is+carmen+sandiego

The resource is "/search", the query string is
"q=where+in+the+world+is+carmen+sandiego". When the Bing server
receives the GET request it will also have access to the query string
embedded in the path. This query string is an URL encoded version of
the hash

```ruby
{ :q => "where in the world is carmen sandiego" }
````

The Bing server will use the query string parameters to build its
response to the GET request: presumably, it will treat the value keyed
by "q" as the *query*. Once the server has generated the search
results and the HTML response, it sends this back to the requester.


## Exercises
Estimated time: .25hrs

### Netcat

`nc` ("netcat") is the simplest, lowest-level program for
communicating with a server. You give `nc` a hostname and port (`nc
www.google.com 80`) and it opens a connection to that server.

You can then start writing an HTTP request in the console. Follow the
format in the image above to make a request to Wikipedia, as well as
another to Google.

The server will know your request is complete when it sees a blank
line. Observe the blank line at the end of the request portion in the
example above; when you add one, the server should begin its response.

Make sure to get the path part of the first request line right: look
carefully at the example (`/wiki/Main_Page`). You always must specify
a path when making a request; the most basic path is `/`.

When you query Google, you should know that it is picky about
requests: it expects "HTTP/1.1" rather than "http/1.1".

Note that you have to repeat the Host both on the command line where
you invoke `nc` and within the request body. This is because `nc` uses
the command line argument to look up the IP address of the machine to
talk to. It can then establish a connection with this machine, but the
machine may host many web services: for instance, the same machines
may host both German and English Wikipedia. That's why we need to also
include the Host within the request.
