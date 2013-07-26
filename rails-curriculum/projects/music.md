# Music app

We're going to build an inventory system for record labels. This app
will let them track their `Band`s, `Album`s and `Track`s.

## Phase I: Band/Album/Track

Build the relevant models:

* A `Band` records many `Album`s.
* An `Album` contains many `Track`s.
* A `Track` is a recording on an `Album`.

After setting up the schema. Generate controllers and write the
seven actions for each:

* index
* show
* new
* create
* edit
* update
* destroy

Instructions on new/edit:

* A form to create a `Band`.
* A form to create an `Album`.
    * You'll need a drop down to select the `Band` that recorded it.
    * Add the ability to select whether the album is a live or studio album.
* A form to create a `Track`.
    * You'll need a drop down to select the `Album` it was recorded
      for.
    * Add the ability to select whether the `Track` is a bonus or
      regular track.
    * Use a textarea to upload some lyrics.
* Put your forms in a partial so they can be reused in both the new
  and edit pages.

Instructions on show:

* Your `Band`, `Album`, and `Track` show pages should be rich and list
  related objects.
    * E.g., `BandsController#show` should link to `Album`s and
      `Track`s.
    * E.g., `AlbumsController#show` should link to the `Band` and its
      `Track`s.
    * E.g., `TracksController#show` should link to the `Album` and
      `Band`.
* Tack on a `button_to` to destroy an object.
* Make sure to set up dependent destroy relationships.

## Phase II: Notes

* Add a `Note` model. Users can take a `Note` on any `Track`.
* On the `Track` show page, display the `Note`s.
* Use a `notes/_note.html.erb` partial.
* Also, put a `Note` form on the show page. On submit of a new `Note`,
  redirect back to the `Track`.
* Add destroy buttons for notes, too.

## Phase III: Users and Authentication

* Setup `User` authentication.
    * Use email instead of username.
* On signup, send the user an email (via ActionMailer).
    * Email should contain a link to "activate" the account. Account
      starts out deactivated until activation.
    * In addition to password/session token, add an activation token
      column.
    * Add a route for an action like `UsersController#activate`.
    * In the email, send a URL to `/users/activate?token=...`, where
      this is the activation token.
    * The controller should verify the token, and if accurate,
      activate the account.
* Only `admin` users should be allowed to destroy objects.
    * Except your own notes, which you can always destroy.
    * Of course, start tracking the author of notes.

## Phase IV: Helpers

In a fit of poor judgment, you have decided to display your lyrics
like this, with a music note before every line:

```
♫ And I was like baby, baby, baby, oh
♫ Like baby, baby, baby, no
♫ Like baby, baby, baby, oh
♫ I thought you'd always be mine, mine
```

Write and use a helper `ugly_lyrics(lyrics)` that will:

* break up the lyrics on newlines
* insert a ♫ at the start of each line (the html entity that will render as a
  music note is `&#9835;`)
* properly escape the user input
* wrap the lyrics in a `pre` tag so that the newlines are respected
* mark the produced HTML as safe for insertion (otherwise your `<pre>` tag will
  get escaped when you insert it into the template)
