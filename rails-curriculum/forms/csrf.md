# Cross-site Request Forgery

You've been learning how to write forms. Here's a tricky form:

```html+erb
<!-- this is a form on my www.appacademy.io -->
<form action="https://www.facebook.com/pages/appacademy/like"
      method="post">
  <input type="submit" value="Click to win a puppy!">
</form>
```

This form on appacademy.io advertises a chance to win a free
puppy. However, when the user clicks the button, it instead issues a
request to facebook.com to like App Academy.

Now, Facebook only processes likes for logged in users: that's how it
enforces that a user can only like a page at most once. If Facebook
didn't require me to be logged in, I'd just repeatedly click the like
button to register as many likes as I could.

Because I can only like a page once, I want to try to trick other
Facebook users to like my page for me. For that reason, I publish a
deceptive form on my site, which then POSTs a like request to
Facebook's site. This is called a *cross-site* (originates on my site
but attacks Facebook) *request forgery* (issues an unintended request
to like my page).

Note that the forgery only succeeds if the target is signed into
Facebook. If they are not, a request to like my page will be not
succeed: Facebook will return an error saying the like request is not
authorized for an anonymous user. However, since many, many browsers
are likely to be logged into Facebook, this attack will work fairly
often.

## CSRF Authenticity Token

Rails, by default, tries to protect your forms from being attacked
like this. Here's how.

On each request, Rails will set an *authenticity token* in your
session. The authenticity token is just a random number; it has no
special meaning. Like everything in the session, it will be available
for each subsequent request.

When you make any non-GET request to Rails (POST, PUT, DELETE), Rails
will expect the client to **also upload the authenticity token in the
params**. If we were Facebook engineers writing Rails, we could do
this:

```html+erb
<!-- this is a form on www.facebook.com -->
<form action="pages/appacademy/like" method="post">
  <input type="hidden"
         name="authenticity_token"
         value="<%= form_authenticity_token %>">

  <input type="submit" value="Like App Academy!">
</form>
```

The `form_authenticity_token` helper just looks at the user session,
takes the authenticity token stored in there, and puts it in the
form. When the form is uploaded, Rails will check that the uploaded
token in the params equals the token stored in the session. If they
are equal, Rails knows that the user submitting the form was the one
who requested it in the first place.

## How The Authenticity Token Check Helps

On any non-GET request, if the authenticity token in the form does not
match the token in the session, **Rails will temporarily blank out the
session**. For this request, the session will look empty. Rails does
this to protect you.

In particular, there will be no session token, which means it will
look like the user is logged out. This helps because Facebook will
then presumably reject the submission because it looks like it has
come from an anonymous user.

A malicious website (like appacademy.io) can direct the user to POST a
form to facebook.com. If the user is logged in, both their session
token and authenticity token stored in the session will be uploaded.

What **won't** be uploaded is the session token in the POST
body. That's because the browser won't let appacademy.io peek at
another website's cookies and add this to the form. The malicious site
has no way to add the token to the form, because it doesn't have
access itself to the cookie.

Because the point of the CSRF attack is to misuse the cookies set by
the target site, temporarily blanking the session stops it. In
partiular, when the target site goes to check the session token, Rails
will pretend as if it wasn't uploaded, and the app will think the user
is not logged in.

## You Need To Use The Authenticity Token

For every form you write, you should make sure to upload the
authenticity token. Otherwise, if the action you are POSTing (or
PUTing, etc.) to requires session data, it will not have access to
it. Some actions may not really require the session anyway, but keep
things simple: just include the little boilerplate above as part of
your form and you will be fine.
