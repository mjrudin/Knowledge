# Intro to Authentication

## Goals
* Know what authentication and authorization are.
* Know how cookies are used to support authorization.

## Authentication and Authorization
How do we make sure that only appropriate users are allowed to take
privileged actions? For instance, only an administrator should be
allowed to delete posts from a web forum, perhaps.

There are two parts of the problem. We use *authentication* (i.e.,
make sure that the user is who he says he is). We then make sure that
the user is *authorized* (i.e, has permission) to make each request
that he/she attempts.

In this section, we will discuss a simple way a user can authenticate.

## Cookie-based authentication
Let's discuss how Reddit does authentication. To authenticate himself
to the server, a user POSTs his credentials to a login endpoint:

```ruby
[11] pry(main)> response = RestClient.post("http://www.reddit.com/api/login/ruggeri", {:api_type => :json, :user => "ruggeri", :passwd => "my_password"})
# => 200 OK | application/json 163 bytes

[22] pry(main)> JSON.parse(response)
=> {"json"=>
  {"errors"=>[],
   "data"=>
    {"modhash"=>"z7kshd3n745f4e0455ae3e4a8ca5b43622839d205b96ad2f26",
     "cookie"=>
      "8891491,2013-01-05T12:09:37,0c8e44dbca7ed59b80aa3ee66db533a710c2df10"}}}
```

(NB: it would have been more conventional if Reddit had used the
endpoint "/api/login" rather than the redundant "api/login/ruggeri";
the user is already in the body of the POST anyway).

So here, the user is uploading his username and password to
Reddit. The server checks the credentials; if they were wrong, it
would have issued us JSON telling us the login failed.

Now that the server has authenticated us, it needs to give us a record
of this authentication, so that we can give this proof to the server
when we subsequently make API requests requiring authorization. The
server will check this *token*; by issuing us a token, we avoid
needing to submit our username and password on every request.

The proof is in the form of a cookie (ignore modhash for now; it's
Reddit specific). The cookie is listed in the body for redundancy; the
part which tells us to save the cookie is found in the headers.

```ruby
[23] pry(main)> response.headers
=> {:content_type=>"application/json; charset=UTF-8",
 :vary=>"Accept-Encoding",
 :set_cookie=>
  ["reddit_first=%7B%22firsttime%22%3A%20%22first%22%7D; Domain=reddit.com; expires=Thu, 31 Dec 2037 23:59:59 GMT; Path=/",
   "reddit_session=8891491%2C2013-01-05T12%3A09%3A37%2C0c8e44dbca7ed59b80aa3ee66db533a710c2df10; Domain=reddit.com; httponly; Path=/"],
 :content_encoding=>"gzip",
 :server=>"'; DROP TABLE servertypes; --",
 :content_length=>"163",
 :date=>"Sat, 05 Jan 2013 20:09:37 GMT",
 :connection=>"keep-alive"}
```

Since web browsers upload all previously stored cookies for a domain
whenever a request to that domain is made, all future requests will
contain the login credential cookie set by this response.

### Modhash
The response body repeats the cookie (redundantly; it's the header
line that really matters to a browser), but also returns what Reddit
calls the "modhash". This parameter is not set as a cookie; the user
must explicitly upload this in the body of future requests (except GET
requests). Reddit uses this modhash to prevent a certain kind of
attack (a cross-site request forgery, or CSRF). We will explain why
this is necessary at a later date.

## Making an authorized request
Let's now make a request requiring authorization. Let's get the
details of the logged in user:

```ruby
> RestClient.get("http://www.reddit.com/api/me.json")
"{}"
```

Huh. That's not much of an error message. Many APIs don't give you a
lot of guidance when you make mistakes, so we have to figure out for
ourselves why this didn't work.

The reason is that RestClient has not uploaded the previously set
cookie. A web browser will automatically upload unexpired cookies that
have been previously set. But because RestClient is lower-level than a
browser, it requires you to explicitly upload cookies yourself:

```ruby
[25] pry(main)> JSON.parse(RestClient.get("http://www.reddit.com/api/me.json", :cookies => response.cookies))
=> {"kind"=>"t2",
 "data"=>
  {"has_mail"=>false,
   "name"=>"ruggeri",
   "is_friend"=>false,
   "created"=>1306483933.0,
   "modhash"=>"134l8xrvireeaee2dba16abe87c7986084fcf9f450086af994",
   "created_utc"=>1306480333.0,
   "link_karma"=>1,
   "comment_karma"=>0,
   "is_gold"=>false,
   "is_mod"=>false,
   "id"=>"5akpv",
   "has_mod_mail"=>false}}
```

Ah; that's better. You can see that because we set the `:cookies`
option, the cookies got uploaded, and the server was able to see who
we were logged in as, and authorize the request for our details.
