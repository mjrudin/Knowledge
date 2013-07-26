# Cookies

## Goals
* Know what "statelessness" means.
* Know how a cookie can store data on the client.

## HTTP is stateless
HTTP is *stateless*; each request that a client makes is independent
of every other request. A stateless protocol is a communications
protocol that treats each request as an independent transaction that
is unrelated to any previous request so that the communication
consists of independent pairs of requests and responses.

What does this mean? It means that HTTP does not build in a way to tie
together multiple requests. For instance, say we want to add an item
to our shopping cart, and then check out. HTTP itself doesn't build in
a way to tie the first request (to add an item) to the second request
(begin the check out). This is the problem that "cookies" were
invented to solve.

Stateless protocols allow server software to be written more simply
and with fewer bugs. They can also make certain intelligent
optimizations that let the web service operator scale up his machines
more easily. These points aren't essential for us to dive into right
now, but you should know that the simplicity of HTTP and other
stateless protocols is part of what makes them so powerful.

## Cookies
Statelessness is a good thing, but it (by definition) doesn't deal
with the problem of "client state". For example, consider a couple
sequences of actions:

```
# sequence #1
POST login credentials to amazon.com
GET Browse around
POST add an item to your wish list
DELETE logout of your session

# sequence #2
POST login again to amazon.com
GET your amazon wishlist
POST a request to purchase a wishlisted item by clicking the buy button
```

Each time you login to amazon, the subsequent interactions you make
with the server are performed in the context of your login. For
instance, if "Joe Brown" logs into amazon, a subsequent request for
the "/wishlist" resource should show *his* wishlisted items, and not
someone elses.

This is the important part: two different people make the same request
for the same resource (/wishlist), but they see different results. How
does that happen? How does Amazon know to do something different in
each case?

Of course, it starts by posting different login credentials in the
initial login. Then we may receive a response from amazon.com like
this:

```
HTTP/1.1 200 OK
Content-type: text/html
Set-Cookie: user=ruggeri
...
```

The "Set-Cookie" line is telling the client (our web browser) to save
some state in the browser: namely, the logged in amazon user. All
subsequent requests to www.amazon.com will upload that information
back to the server:

```
GET /wishlist http/1.1
Host: www.amazon.com
Cookie: user=ruggeri
```

The only way the server can know the request is being made by user
ruggeri is through the cookie. It doesn't have any other way to tie
together the login request and the wishlist request. Without the
cookie, the server would have no way to differentiate this request
from user ruggeri from another request from user patel.

Once a cookie is set, it continues to be uploaded to the server on every
request until it *expires* or is cleared out by the user. It is common to set
the cookie to expire on a date far in the future so that it continues to be
uploaded. This is called a *permanent cookie*. If no expiration date is set the
cookie will be deleted when the web browser closes. This is called a *session
cookie*.

### Shopping carts

Let's consider a second example. Say a logged in user ('ruggeri') is
navigating amazon.com and wants to add items to his shopping
cart. Each shopping cart request might trigger a POST request to the
server; the server would then update its database to reflect that user
'ruggeri' has added another item in his shopping cart. When user
'ruggeri' checks out, the server queries the database to check the
items in his cart, and computes the price.

What about an anonymous marketplace where users don't log in? Maybe
they just add items to their cart, check out once at the end, and
provide their credit card details without every creating an account?

Here the users are anonymous: the server doesn't have a username for
this user. For that reason, it can't record in its database that user
X has added an item to its cart, since there are no usernames.

One solution would be to store the shopping cart in the user's
cookie. Each time the user makes a request, he'll upload the cookie
containing his shopping cart. Whenever he adds an item, the server
will send the shopping cart cookie back, having first appended one more
item to it.

### Advantages and disadvantages

There are a few additional advantages to each approach. The approach
of storing state on the server means that the user can use different
devices (maybe his computer and his phone) to use the service, and
still access his cart across machines. If his cookies get cleared, he
doesn't lose the items in his cart.

The information stored in a cart is very small: probably just the id
numbers of the items. It won't hurt to upload them on every
request. If there were more data to store (for instance, images), then
it would slow down the interaction with the website to upload the
cookie every time. Cookies have reasonable limitations to how much
data they can hold; usually 4kB.

On the other hand, it may be simpler to just have the client store the
cart in cookies. We don't have to store the cart in the database,
remove old carts, etc. Depending on how interactive the site is, we
may not have to set up a database at all.

One last point: any information that must be reliably saved must not
be stored in a cookie. People clear cookies all the time, so you can't
count on the data you save in the cookie being around later.

Likewise, data that the web application may want to query should be
stored in a database. Say we wanted to run a query to ask what items
were stored in people's carts currently. With the cookie-based
architecture, we haven't stored that information on our servers; it
exists in the cookies saved on our users' computers, which we can't
directly query. We only get access to that data when a web request is
made.

## Sessions
Information like what the logged in username or the items in a cart is
called *session data*. Session data is the accumulated prior context
in which future requests are interpreted. For instance, when a client
makes a POST request to submit an order, the context includes the
currently logged in user. The session data, in aggregate, is called
the *session*.

"Session" is a concept; cookies are the way that concept is
implemented. When we start working with Rails, we'll see the word
session more frequently than cookie; that's because Rails is trying to
be flexible about whether it uses cookies or some other means to
implement a session.
