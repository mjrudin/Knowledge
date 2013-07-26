# Polls

In the spirit of enfranchisement, we're going to build a polling app
today!

## Feature requirements

* Supports multiple users.
* Users can create a poll.
* A poll consists of multiple questions.
* At creation, each question has a set of allowed answers.
    * When the question is created, the creator creates a set of
      allowed poll answers.
    * For instance:
        * Question: "What is your favorite state?" Responses: "Georgia", "Tennessee", etc.
        * Question: "What is your favorite color?" Responses: "Red", "Blue", "Green"
* Each question can be responded to at most once by each user.
    * A poll should only be responded to by a non-creator of the poll. You
      will probably need to do a custom validation for this.
* Write a method `Question#results` that returns a hash of choices and
  counts like so:

  ```ruby
  q = Question.first
  q.title
  # => "Who is your favorite cat?"
  q.results
  # => { "Earl" => 3, "Breakfast" => 3, "Maru" => 300 }
  ```

  Your challenge is to do this without using an N+1 query.
* Should also be able to get all the polls/responses for a given user.
* Later, add ability to restrict Polls to only a set of users on a Team.

## Technical details

* Setup appropriate associations throughout
* Use validations throughout
* Don't duplicate data redundantly; if your `choices` table has a
  `question_id`, and your `responses` table has a `choice_id`, don't put a
  `question_id` in responses.
* To enforce that a user only submits a `Response` once per question,
  you will have to do a custom validation.
    * Before saving a `Response`, you need to check for all other
      `Response`s for the same `User` & `Question`.
    * `Response` shouldn't be directly related to `Question`, so you
      need to do a join through `Choice`.
* You may start out by doing "chicken joins" (`Poll.each do |poll|
  poll.responses.each ...`), but eventually you need to use `joins` to
  avoid N+1 queries.
* Make sure to index all foreign keys.
* Allow deletion of questions; clean up all related records with a
  callback.
