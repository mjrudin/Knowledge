# HTML Forms: Basics

## `form` and `submit`

Forms input tags are wrapped in a `form` tag. When the user clicks the
`submit` input, it will send the form data to the server.

```html
<form action="http://99cats.com/cats" method="post">
  <!-- other input elements -->

  <input type="submit" value="Create cat">
</form>
```

The `action` attribute contains the URL to which the form data should be
sent, the `method` attribute describes the HTTP method that should be
used. A typical form will `POST` the data; `GET` forms are only used for
search forms, which will merely request data to be fetched.

## `text` input type

A `text` input tag presents a single line of text input for the user
to submit:

```html
<form action="http://99cats.com/cats" method="post">
  <input type="text" name="cat[first_name]">
  <input type="text" name="cat[last_name]">

  <input type="submit" value="Create cat">
</form>
```

## HTML's `form` and Rails' `params`

When you submit a form to the server, Rails will take the form data and
make them available to your controller through the `params` hash.

The form's input names will be the keys in the hash, while the values
will be the values of the form. So if your form looks like this:

```html
<form action="http://99cats.com/cats" method="post">
  <input type="text" name="first_name">
  <input type="text" name="last_name">

  <input type="submit" value="Create cat">
</form>
```

You'll get a `params` hash like this: `{ "first_name" => "Kiki",
"last_name" => "Beck" }`.

Most of your forms create model objects; you want to build these with
mass-assignment:

```ruby
class CatsController
  def create
    Cat.create!(params[:cat])

    # redirect to cats index
    redirect_to cats_url
  end
end
```

This won't work yet: there is no value `"cat"` in the params hash yet. All
the cat data is in the "top level". To fix this, we rename the form
inputs:

```html
<form action="http://99cats.com/cats" method="post">
  <input type="text" name="cat[first_name]">
  <input type="text" name="cat[last_name]">

  <input type="submit" value="Create cat">
</form>
```

These new names don't mean anything to the browser; they don't change
the HTTP POST request except for the names of the uploaded values.

The difference comes when Rails translates the form data to the
`params` hash. As a convention, it will see the square brackets for
`cat[first_name]` and nest the `first_name` attribute inside an inner
`cat` hash: `{ "cat" => { "first_name" => "Kiki", "last_name" =>
"Beck" } }`.

This will make the previous `CatsController#create` code work.

## `label` input type

Input elements should be labeled so the user knows what they are:

```html
<form action="http://99cats.com/cats" method="post">
  <label for="cat_first_name">First name</label>
  <input type="text" name="cat[first_name]" id="cat_first_name">
  <label for="cat_last_name">Last name</label>
  <input type="text" name="cat[last_name]" id="cat_last_name">

  <input type="submit" value="Create cat">
</form>
```

The `for` attribute of the `label` tag is supposed to match the `id` of
the `input` tag. Note that square brackets are not allowed in the `id`,
which is why it differs from `name`.

## `textarea` input type

The `textarea` tag is a kind of input tag. It renders a multi-line
text box:

```html
<form action="http://99cats.com/cats" method="post">
  <label for="cat_biography">Cat's Life Story</label>
  <textarea name="cat[biography]" id="cat_biography"></textarea>

  <input type="submit" value="Create cat">
</form>
```

## `radio` input type

The `radio` input type lets you choose one option of many. Every radio
button for a group has the same name (here, `cat[sex]`); each one will
have a different `value`. The chosen radio button's `value` will be
uploaded on form submission. If no button is chosen, then nothing for
that key is uploaded.

Note that we can individually label the radio buttons, even though
they all have the same `name` attribute, because the `id` should still
be unique (`cat_sex_male`, `cat_sex_female`):

```html
<form action="http://99cats.com/cats" method="post">
  <input type="radio" name="cat[sex]" id="cat_sex_female" value="f">
  <label for="cat_sex_female">Female</label>
  <input type="radio" name="cat[sex]" id="cat_sex_male" value="m">
  <label for="cat_sex_male">Male</label>

  <input type="submit" value="Create cat">
</form>
```

## `select` tag

A `select` tag presents a drop-down of options to the user.

```html
<form action="http://99cats.com/cats" method="post">
  <label for="cat_coat_color">Coat color</label>
  <!-- dropdown -->
  <select name="cat[coat_color]">
    <!-- `brown`, if selected, is the value that will be submitted to
         the server; user is displayed "Brown" as the choice -->
    <option value="brown">Brown</option>
    <option value="black">Black</option>
    <option value="blue">Blue</option>
  </select>
  <br>

  <input type="submit" value="Create cat">
</form>
```

Notice how the options are nested inside the `select` tag; each `option`
tag is one option in the dropdown. The options have a `value` attribute
(which is sent to the server), as well as a body, which is what is
presented to the user.

## `hidden`

**TODO**

## `check_box`

**TODO**: explain `check_box` and simple associations.

## References

* [Understanding Parameter Naming Conventions][understanding-parameter-naming-conventions]

[understanding-parameter-naming-conventions]: http://guides.rubyonrails.org/form_helpers.html#understanding-parameter-naming-conventions
