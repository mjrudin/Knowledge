# I use Ruby's `Set` class for collections I need to call `#include?`
# on; `#include?` is much faster on a `Set` than an `Array`.
require 'set'

=begin
Man is born free, and everywhere he is in chains.
=end
class WordChainer
  def self.adjacent_words(word, candidates)
    # variable name *shadows* (hides) method name; references inside
    # `adjacent_words` to `adjacent_words` will refer to the variable,
    # not the method. This is common, because side-effect free methods
    # are often named after what they return.
    adjacent_words = Set.new

    # NB: I gained a big speedup by checking to see if small
    # modifications to the word were in the dictionary, vs checking
    # every word in the dictionary to see if it was "one away" from
    # the word. Can you think about why?
    word.length.times do |index|
      ("a".."z").each do |letter|
        new_word = word.dup
        new_word[index] = letter

        adjacent_words << new_word if candidates.include?(new_word)
      end
    end

    adjacent_words
  end

  def self.load(dictionary_file_name)
    dictionary = Set.new(
      File.readlines(dictionary_file_name).map(&:chomp)
    )

    self.new(dictionary)
  end

  def initialize(dictionary)
    @dictionary = dictionary
  end

  def find_chain(source, target)
    return nil if source.length != target.length

    # winnow the dictionary to possibly useful words
    candidates = @dictionary.select do |word|
      word.length == source.length
    end

    # words we've reached in the previous round; we'll grow from these each
    # round. Start from the source.
    recent_words = Set.new([source])
    # map each word to the word we found it from; `source` has no
    # parent
    parent_words = { source => nil }
    # do not revisit the source
    candidates = Set.new(candidates) - [source]

    # keep looping until we find the target, or can't find any new
    # words
    until (parent_words.has_key?(target)) || (recent_words.empty?)
      new_parent_words =
        self.class.find_new_words(recent_words, candidates)

      # update parent_words and recent_words
      parent_words.merge!(new_parent_words)
      recent_words = Set.new(new_parent_words.keys)

      # filter candidates of recent_words; we never need to return to a
      # word that we've found previously. In fact, we might enter a
      # loop if we revisted an old word!
      candidates -= recent_words
    end

    self.class.build_chain(parent_words, target)
  end

  private
  def self.find_new_words(recent_words, candidates)
    # note how this method doesn't modify any instance variables; a
    # method like this is easy to reason about, because it
    # communicates with the rest of the class through its return
    # value, which we can track easily
    new_parent_words = {}

    # take each of the recent words and grow it
    recent_words.each do |word|
      adjacent_words = WordChainer.adjacent_words(word, candidates)

      adjacent_words.each do |adjacent_word|
        new_parent_words[adjacent_word] = word
      end
    end

    new_parent_words
  end

  def self.build_chain(parent_words, target)
    return nil unless parent_words.has_key?(target)

    reversed_path = [target]
    # will stop at `source`, which has `nil` parent
    until parent_words[reversed_path.last].nil?
      reversed_path << parent_words[reversed_path.last]
    end

    reversed_path.reverse
  end
end
