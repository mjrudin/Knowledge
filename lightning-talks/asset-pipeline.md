# Asset Pipeline

## Purpose

So far we've focused on rendering HTML content. But styling rules are
kept in CSS files and JavaScript code meant to be run by the client is
kept in JS source files. These are not (typically) returned directly
inside the HTML response; instead, we add `<script>` and `<link>` tags
in the `<head>` to direct the client to make additional requests to
load these resources.

For purposes of code organization, JS and CSS source is typically
split across many files. However, because web browsers are limited in
the number of requests that they can make in parallel, more files to
request means a slower user experience.

To solve this problem, the asset pipeline *concatenates* asset files
into fewer JS and CSS files. This reduces the number of requests that
a browser must make to render a web page. The asset pipeline also
*minifies* the JS and CSS assets, stripping out whitespace and
applying other optimizations (especially for JS) to reduce file-size.

The asset pipeline can also *pre-compile* higher-level languages like
CoffeeScript (to JavaScript) and Sass (to CSS). These languages can be
nicer to use than JS or CSS.

Starting with version 3.1, Rails defaults to concatenating all
JavaScript files into one master `application.js` file and all CSS
files into one master `application.css` file. As you'll learn later in
this guide, you can customize this strategy to group files any way you
like.

## Writing manifest files

All your CSS and JavaScript sources, and images, should be placed in
the proper `app/assets` subdirectory: `images`, `javascripts`, or
`stylesheets`. Files in these directories will be handled by the asset
pipeline.

One of the key purposes of the asset pipeline is to group up and
concatenate source files. This reduces the number of requests the
client must make to the server. Manifest files describe how to group
source files. For instance, here is the default
`app/assets/javascripts/application.js`:

```javascript
// This is a manifest file that'll be compiled into application.js,
// which will include all the files listed below.
//
// Any JavaScript/Coffee file within this directory,
// lib/assets/javascripts, vendor/assets/javascripts, or
// vendor/assets/javascripts of plugins, if any, can be referenced
// here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll
// appear at the bottom of the the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE
// PROCESSED, ANY BLANK LINE SHOULD GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
```

This says that the compiled `application.js` file should concatenate
the jquery, jquery_ujs sources (provided by the `jquery-rails` gem),
plus also require all the javascript sources in the current tree
(`require_tree .`): `app/assets/javascripts`. Effectively, that means
*all* the javascript in the application.

When writing JS manuscripts, the lines starting `//=` describe
dependencies.

Likewise, you may write CSS manifests like so:

```css
/*
 * This is a manifest file that'll be compiled into application.css,
 * which will include all the files listed below.
 *
 * Any CSS and SCSS file within this directory,
 * lib/assets/stylesheets, vendor/assets/stylesheets, or
 * vendor/assets/stylesheets of plugins, if any, can be referenced
 * here using a relative path.
 *
 *= require_tree .
 */
```

The default is to compile *all* the javascript code and *all* the css
code to two files: `application.js` and `application.css`. This is a
reasonable default, because only two source files ever need to be
loaded across the whole site.

However, if we wanted more control we could change these manifests to
not include all the javascript or css (in particular, the
`require_tree` line). We could write additional manifests that
included selected bits of code, and only the layouts/templates that
needed these bits would load them. You shouldn't do this right now,
but it's good to know about how the system works.

**TODO**: When working with Sass use `@import`, else they are compiled
in separate scopes and variables/mixins can't see each other.

## Compilation

When you deploy your application to a production environment, Rails
will precompile your asset files to `public/assets`. This involves
compiling sources from CoffeeScript/Sass to JavaScript/CSS,
concatenation of manifest files, and final minification of the
results. The asset pipeline does all of this for you.

The precompiled copies are then served by Rails out of the
`public/assets` folder. The original sources in `app/assets` are never
served directly in the production environment.

## Coding Links to Assets

The familiar asset tags will link to the precompiled versions of your
assets. You don't need to do anything special to use the asset
pipeline:

```erb
<%= stylesheet_link_tag "application" %>
<%= javascript_include_tag "application" %>
<%= image_tag "rails.png" %>
```

The `stylesheet_link_tag`/`javascript_include_tag`/`image_tag` helpers
will return links to the precompiled, concatenated, minified versions
in `public/assets` (not the originals in `app/assets`).

You must **never hard-code links** to `public/assets`; the names of
precompiled assets contain an inserted *fingerprint* which is not
predictable. For instance, don't do this:

```html+erb
<head>
  <!-- noooo! -->
  <link href="/assets/application.css" type="text/css">
  <!-- yesss! -->
  <%= stylesheet_link_tag "application" %>
</head>
```

When `app/assets/stylesheets/application.css` is compiled, it is saved
to `public/assets/application-1bf77c05c1043f3a0467723f43f6cd7c.css` or
somesuch. These fingerprints are used for *cache control*, but we
won't discuss that in depth right now. The point is you don't know and
can't hard code the fingerprint.

Just know that the assets pipeline will be able to connect the
precompiled, fingerprinted sources with your HTML tags if you use the
provided helpers. Don't ever hard-code, anyway!

### Asset links within CSS and JavaScript sources

You must always avoid hard-coding links to assets; in view templates
this was easy because you just used the standard asset tag
helpers. Inside CSS/Sass and JavaScript/CoffeeScript, you need to also
be careful to not use hard-coded link to assets.

#### JavaScript/CoffeeScript and ERB

**TODO**: `asset_path` vs `image_path`, `image-url` vs `asset-url`?

The easiest way to avoid hard-coded asset links is to use embedded
ruby with your JS/CoffeeScript sources. If you add an `erb` extension
to a JavaScript asset, making it, for instance, `application.js.erb`,
then you can use the typical helpers in your JavaScript code:

```js
$('#logo').attr(:src => "<%= asset_path('logo.png') %>");
```

When the ERB file is compiled to pure JS, the `asset_path` will be
replaced with a proper link to the `public/assets` directory.

#### CSS and Sass

When using the asset pipeline, paths to assets must use `image-url`
helper (**confusing**: note the hyphen, which is different in Sass
than Ruby) for the following asset classes: image, font, video, audio,
JavaScript and stylesheet. So to set a background image in Sass:

```scss
.body {
  background-image: image-url("rails.png");
}
```

## Compiling the assets

Rails comes bundled with a rake task to compile the asset manifests
and other files in the pipeline to `public/assets`: `rake
assets:precompile`.

You should never need to run this locally (or check-in `public/assets`
to version control). In particular, Heroku will run this task for you
on deployment.

NB: before you deploy to Heroku, you will have to set
`config.assets.initialize_on_precompile = false` in
`config/application.rb`. It's not important to know why right now.

## Server configuration

Eventually you will want to configure your web server to set
the expiration date of your CSS/JavaScript assets for far in the
future so that they are not rerequested by the client on every page
load. Likewise, you will want your server to serve compressed
(gzipped) versions of these files.

Do not worry about this for now. But later, in the back of your head,
remember that it involves configuring the web server, not Rails
itself.

## Resources

* http://railscasts.com/episodes/279-understanding-the-asset-pipeline?view=asciicast

