# RailsGuides Readings

## Routing

[RailsGuides: Routing][rails-guides-routing]

* Skip 2.6 Controller Namespaces and Routing.
* Read 2.7 Nested Resources, but we'll talk more about this in a
  few days.
* In 3 Non-Resourceful Routes, remember to never use `match`.
* Also, never use `:controller/:action`; always use `=>
  "controller#action".
* Ignore 3.8 Segment Constraints, 3.9 Request-Based Constraints, and
  3.10 Advanced Constraints.
* Ignore 3.11 Route Globbing.
* Ignore 3.13 Routing to Rack Applications.
* Ignore all of 4 Customizing Resourceful Routes except:
    * 4.6 Restricting the Routes Created
* Ignore 5.2 Testing Routes.

## Action Controller

[RailsGuides: Action Controller][rails-guides-action-controller]

* Skip 3.4 default_url_options
* In 4 Session, ignore setting different session stores
* Skip 10 HTTP Authentications
* Skip 11.2 RESTful Downloads

## Layouts and Rendering

[RailsGuides: Layouts and Rendering][rails-guides-layouts]

* Skip 2.2.4 Rendering an Arbitrary File
* Skip 2.2.6 Using render with :inline
* Skip 2.2.9 Rendering XML through 2.2.12 Finding Layouts
* Skip 2.4 Using head To Build Header-Only Responses
* Skip 3.1 Asset Tag Helpers
* Skip 3.5 Using Nested Layouts

[rails-guides-routing]: http://guides.rubyonrails.org/v3.2.13/routing.html
[rails-guides-action-controller]: http://guides.rubyonrails.org/v3.2.13/action_controller_overview.html
[rails-guides-layouts]: http://guides.rubyonrails.org/v3.2.13/layouts_and_rendering.html
