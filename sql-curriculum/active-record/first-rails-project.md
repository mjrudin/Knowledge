# Your first rails project

This unit begins our foray into ActiveRecord; a component of Rails
that is a way for your Ruby code to interact with a SQL
database. ActiveRecord is maybe the most important part of Rails;
after you master it, you will find the rest of Rails probably pretty
straightforward.

First, make sure that rails is installed:

    gem install rails --version 3.2.13

Next, generate a new Rails *project*:

    rails new DemoProject

This will create a folder `DemoProject`, with a bunch of Rails
directories in them.

Open up the `Gemfile` file, and add the line:

    gem 'pry-rails'

This will allow us to interact with our Rails project using the 
pry console. Next, make sure you are in the DemoProject directory and run:

    bundle install 

This will look for the Gemfile and then install the *dependencies* listed in it.
