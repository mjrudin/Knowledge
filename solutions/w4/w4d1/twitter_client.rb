require 'json'
require 'launchy'
require 'oauth'
require 'yaml'

class TwitterSession
  CONSUMER_KEY = ""
  CONSUMER_SECRET = ""

  CONSUMER = OAuth::Consumer.new(
    CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

  DEFAULT_TOKEN_FILE_NAME = "twitter_token_file"

  # hold onto one default instance
  def self.instance(token_file_name = DEFAULT_TOKEN_FILE_NAME)
    @@session ||= TwitterSession.new(token_file_name)
  end

  def initialize(token_file_name = nil)
    if token_file_name && File.exist?(token_file_name)
      @access_token = File.open(token_file_name) { |f| YAML.load(f) }
    else
      @access_token = request_access_token
      File.open(token_file_name, "w") { |f| YAML.dump(access_token, f) }

      access_token
    end
  end

  attr_reader :access_token

  # helpers to help me get/pos more easily than using the access token
  # directly.
  def get(path, query_values = nil)
    url = path_to_url(path, query_values)
    access_token.get(url)
  end

  def post(path, params = nil)
    url = path_to_url(path)
    access_token.post(path, params)
  end

  # Helper so I don't need to repeat `"https://api.twitter.com/"`
  # everywhere.
  def path_to_url(path, query_values = nil)
    Addressable::URI.new(
      :scheme => "https",
      :host => "api.twitter.com",
      :path => path,
      :query_values => query_values
    ).to_s
  end

  private
  def request_access_token
    # This is the bit that makes the user actually go through the
    # auth flow.

    request_token = CONSUMER.get_request_token

    authorize_url = request_token.authorize_url
    puts "Go to this URL: #{authorize_url}"
    Launchy.open(authorize_url)

    puts "Login, and type your verification code in"
    oauth_verifier = gets.chomp

    request_token.get_access_token(:oauth_verifier => oauth_verifier)
  end
end

class Status
  attr_reader :created_at, :text, :author

  def self.parse(status_datum)
    Status.new(
      status_datum["created_at"],
      status_datum["text"],
      User.parse(status_datum["user"])
    )
  end

  def initialize(author, text, created_at)
    @author, @text, @created_at = author, text, created_at
  end

  def render
    "#{author}: #{text} ((#{created_at}))"
  end
end

class User
  attr_reader :screen_name

  def self.parse(user_datum)
    User.new(user_datum["screen_name"])
  end

  def self.parse_many(ids)
    path = "/1.1/users/lookup.json"

    user_data = JSON.parse(
      TwitterSession.instance.get(
        path,
        { :user_id => ids.join(",") }
      ).body
    )

    user_data.map { |user_datum| User.parse(user_datum) }
  end

  def initialize(screen_name)
    @screen_name = screen_name
  end

  def timeline
    path = "/1.1/statuses/user_timeline.json"

    status_data = JSON.parse(
      TwitterSession.instance.get(
        path,
        { :screen_name => screen_name }
      ).body
    )

    status_data.map { |status_datum| Status.parse(status_datum) }
  end

  def followers
    path = "/1.1/followers/ids.json"

    user_ids = JSON.parse(
      TwitterSession.instance.get(
        path,
        { :screen_name => screen_name }
      ).body
    )["ids"]

    User.parse_many(user_ids)
  end

  def followed_users
    path = "/1.1/friends/ids.json"

    user_ids = JSON.parse(
      TwitterSession.instance.get(
        path,
        { :screen_name => screen_name }
      ).body
    )["ids"]

    User.parse_many(user_ids)
  end
end

class EndUser < User
  def self.set_user_name(user_name)
    @@current_user = EndUser.new(user_name)
  end

  # There's only one you! You're the best!
  def self.me
    @@current_user
  end

  def post_status(text)
    path = "/1.1/statuses/update.json"

    TwitterSession.instance.post(path, { :status => text })
  end

  def direct_message(other_user, text)
    path = "1.1/direct_messages/new.json"

    TwitterSession.instance.post(
      path,
      { :screen_name => other_user.screen_name, :text => text }
    )
  end
end
