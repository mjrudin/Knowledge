# 99cats

This project asks you to clone the dress rental website
99dresses. We'll make it cat oriented.

## Requirements

### Step 1: Cat

* Build a `Cat` model. Attributes should include:
    * age
    * birth date
    * color
        * Require the user choose from a standard set of colors.
        * Add a validation for this.
    * name
    * sex
* Build an `index` page of all `Cat`s.
* Build a `show` page for a single cat.
* Build a `new` form page to create a new `Cat`.
    * You can use the `date` input type to prompt the user to
      pick a birth date. Look this up on MDN.
* Build an `edit` form page. The form should be prefilled with a `Cat`s current details. 

### Step 2: CatRentalRequest

* Make a `CatRentalRequest` model.
    * Tracks `cat_id`, `begin_date`, `end_date`
    * Also `status`: starts out `"undecided"`, but can be switched to
      `approved` or `denied`.
* Add validations that a cat request can't overlap an existing
  approved cat rental.
* Create a controller; setup a resource in your routes file.
* Add a `new` request form to file requests.
* Edit the cat show page to show existing requests (sorted by start
  date).
* Make sure that when a `Cat` is deleted, all of its requests should also be deleted.


### Step 3: Approving/denying requests

* Add a method `#approve` **to the model**. It should:
    * Move request status from undecided to approved
    * Deny all conflicting rental requests.
* On the `Cat` show page, add forms which allow you to approve/deny
  each outstanding request.
* Only show this form if a request is not yet approved.
* Write one form each for approval/denial. Each form should have a
  single, `hidden` input. The name of the input should be
  `cat_rental_request[status]` and the value should be `approved` or
  `denied`.
* Add a submit button to each form. Because the input is hidden, all
  the user will see are the buttons.
* The forms should post to the `CatRentalRequest#update` route.

### Step 4: Users

* Right now, anyone can approve anyone else's requests.
* Build a `User` model. Require a unique username and password.
* Build a `UsersController`. You probably only need the two actions
  needed for signup.
* Build a `SessionsController`. You can make this a singular
  resource. Write a `new` form that has the user input their username
  and password.
* On `create`, the controller verifies the username/password, and
  assigns a randomly generated `session_token` (use
  SecureRandom). Assign this to the session. Store this in the user
  model.

### Step 5: Users own cats

* Add a `user_id` column and association to `cats`.
* When creating a new cat through the application, set the `user_id`
  appropriately.
* In the `update` `CatRentalRequestsController` action, make sure the
  user editing a cat owns the cat.
    * Redirect an unauthorized approval/denial request to the cat's
      show page.
    * Use the flash to show a warning message.
* On the cat show page, don't show the approve/deny buttons unless the
  user owns the cat.
