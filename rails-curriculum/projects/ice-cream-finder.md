# Ice Cream Finder
Estimated time: 1.5hrs.

Write a script that takes your current location and finds nearby ice
cream shops. It should provide directions to walk there.

You may want to use a number of Google APIs:

* [Places API][places-api]: given a search string and a
  latitude-longitude, finds and describes nearby matching locations.
* [Geocoding API][geocoding-api]: given a text description of the current
  location, returns a latitude and longitude.
* [Directions API][directions-api]: given two addresses or lat/lngs,
  returns a series of directions between the two places.

**Use Addressable::URI**, described in the APIs chapter. Do not build query
strings by hand! That is ugly and error-prone!

You may wish to use [Nokogiri][nokogiri] to strip out the HTML tags
from Google Directions instructions. Nokogiri parses HTML into Ruby
objects that you can call methods on.

```ruby
require 'nokogiri'
parsed_html = Nokogiri::HTML("This is <b>bold</b> text!")
parsed_html.text
# => "This is bold text!"
```

[places-api]: https://developers.google.com/places/documentation/search
[geocoding-api]: https://developers.google.com/maps/documentation/geocoding/
[directions-api]: https://developers.google.com/maps/documentation/directions/

[nokogiri]: http://nokogiri.org/
