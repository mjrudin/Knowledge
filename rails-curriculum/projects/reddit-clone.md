# Reddit Clone

## Phase 0: reddit

* If you don't know what reddit is, then you are probably someone with
  a life. You should cast that away now.

## Phase I: `User`, `UsersController` and `SessionsController`

* Sign up, log in, log out. Go.
  *(Use BCrypt, please - we want our fake users to have some peace
  of mind)*

## Phase IIa: `Sub`s

* A `Sub` is a category/group of `Link`s. If this does not make sense,
  visit reddit.com.
* A `Sub` should have a name and a moderator.
* When a `Sub` is created, allow as many as 5 links to be submitted at
  the same time. This is not required on edit.
* Editing a `Sub` should only be allowed by the moderator.

## Phase IIb: `Link`s

* Allow users to share a `Link`
* A `Link` should have a title, an URL, and optionally some text.
* For the `Link` new and edit form, the subs should be
  checkboxs. Let's say a `Link` can belong to multiple subs in our
  clone. You probably want a joins table like 'LinkSub' to keep track
  of the `Subs` a `Link` is in.
* `Link` edit should only be allowed by the `User` who submitted it.

## Phase III: `Comment`s

* Users should be allowed to comment on other links. Users can leave a
  comment on comment, and then leave a comment on a comment's comment,
  and so on. The commenting nesting should have no depth limit.
* In each `Comment`, store both the `parent_comment_id` and the
  `link_id`.
* To avoid N+1 queries, when showing a link, get all the `Comment`s by
  `link_id`.
* Write a method `Link#comments_by_parent` which:
    * Fetches the comments,
    * Builds a hash where the key are `parent_comment_id`s and the
      values are arrays of child comments.
    * Note that the key `nil` consists of top-level comments.
* On the `Link` show page, display all comments.
    * Build a `_comment.html.erb` partial. It should take in two
      locals: (a) the `Comment` to display and (b) the
      `comments_by_parent`.
    * Display not just the text of the comment, but also all the
      children comments. Recursively render your partial.
    * If you use a `ul` tag, nested `ul` tags will be further
      indented.
* When a link is submitted, users should also be allowed to submit a
  `Comment` at the same time (nested form).
* On a `Comment` show page, users should be able to comment on the
  comment.

## Phase IV: Votes

* Allow users to upvote or downvote the `Link`s
* You should have a custom route for upvoting and
  downvoting. Something like /links/1/upvote and /links/1/downvote
  * You should only be allowed to upvote or downvote a `Link`, and not
    both.
  * You can only upvote or downvote a `Link` at most once.
* Since you have votes now, make sure you can get the number of
  upvotes/downvotes from `Link`. Your `Link` index and `Sub` index
  should now order links based on popularity.
* You will probably want a joins table like `UserVote` to keep track of user votes.
* An actual `Vote` model is most likely not required.


## Optional Phase

* On a `Sub` show page, the sub's title and links in the `Sub` should
  be shown. Show no more than 25 links per page. Use kaminari for
  pagination.
* Display your nested comments with proper nesting.
* On a `Link` edit page, displays all the top level comments on the
  link with checkboxes, and allow the submitter to untick the comments
  he/she wishes to delete.
* On a `Sub` edit page, the sub moderator should be able untick the `Link`s he/she wishes to delete.

[NESTED FORM INCEPTION][inception]

[inception]: http://www.youtube.com/watch?v=1khghXRGb6k

## Further reading

* [Rails API: Nested Forms][api-nested-forms]

## Later Functionality

* [Pagination][kaminari]

[kaminari]: https://github.com/amatsuda/kaminari

[api-nested-forms]: http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html
