# Serialization and Persistence

## Goals

* Know what serialization and persistence are.
* Know how to transfer between a Ruby object and a [JSON](http://en.wikipedia.org/wiki/JSON) or [YAML](http://en.wikipedia.org/wiki/Yaml)
  representation.
* Know how to save these to a file you might read again later.

## Serialization

Ruby objects live within the context of a Ruby program. You may want
to send your Ruby object to another computer across a
network. Alternatively, you may want to save your Ruby object to the
hard drive, so that when you run your program again later, it might be
reloaded. You cannot do either of these things directly.

To do this you need to first convert the Ruby object into a
representation that can be saved to disk or sent over a network. This
process is called *serialization*.

There are many, many serialization *formats*, or ways of representing
data. Probably the most important in the web world is JSON:

```json
{ "fieldA": "valueA",
  "fieldB": [1, 2, 3] }
```

JSON supports a few primitive forms of data: numbers, strings, arrays
and hashes. It is descended from JavaScript, and is commonly used as
the message format for web APIs. The format is pretty easy to read,
but it's not essential that you be able to write JSON yourself; we'll
see how to get Ruby to do that for us.

You can easily serialize basic Ruby objects to a JSON string:

```ruby
> require 'json'
> { "a" => "always",
    "b" => "be",
    "c" => "closing" }.to_json
=> '{"a":"always","b":"be","c":"closing"}'
> JSON.parse('{"a":"always","b":"be","c":"closing"}')
=> {"a"=>"always", "b"=>"be", "c"=>"closing"}
```

JSON doesn't know how to serialize more complicated classes though:

```ruby
> Cat.new("Breakfast", 8, "San Francisco").to_json
=> '"#<Cat:0x007fb87c81b398>"'
```

You can fix this somewhat by defining a `to_json` method on your
classes, but that involves you writing custom serialization code. It
will also be a pain to do the opposite translation. Note: JSON can
only parse objects that contain arrays and hashes. Strings and numbers
must be converted inside a hash or array structure to be read as JSON
input.

## YAML

YAML is meant to solve the problem of saving custom classes.

```ruby
> require 'yaml'
[12] pry(main)> c = Cat.new("Breakfast", 8, "San Francisco")
=> #<Cat:0x007ff434926690 @age=8, @city="San Francisco", @name="Breakfast">
[13] pry(main)> puts c.to_yaml
--- !ruby/object:Cat
name: Breakfast
age: 8
city: San Francisco
=> nil
[14] pry(main)> serialized_cat = c.to_yaml
=> "--- !ruby/object:Cat\nname: Breakfast\nage: 8\ncity: San Francisco\n"
[15] pry(main)> puts serialized_cat
--- !ruby/object:Cat
name: Breakfast
age: 8
city: San Francisco
=> nil
[16] pry(main)> c2 = YAML::load(serialized_cat)
=> #<Cat:0x007ff4348098e8 @age=8, @city="San Francisco", @name="Breakfast">
```

Notice that YAML has saved the instance variables of the object, as
well as recording the class of object that was saved.

Note that `c` and `c2` are different objects; serialization and
deserialization are sometimes used as a poor man's "clone".

JSON is the dominant serialization technology on the web (XML is a
close second); we'll write Rails apps which we can communicate with by
sending and receiving JSON data.

In the world of client-side Ruby, YAML is the leader because of its
better support for deserializing classes.

## References

* About.com: [YAML](http://ruby.about.com/od/advancedruby/ss/Serialization-In-Ruby-Yaml.htm)
* About.com: [JSON Gem](http://ruby.about.com/od/tasks/a/The-Json-Gem.htm)
* w3schools.com [JSON Tutorial](http://www.w3schools.com/json/default.asp)
