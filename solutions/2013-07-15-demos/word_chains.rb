require 'set'

class WordChainer
  def self.adjacent_words(dictionary, word)
    adjacent_words = []

    word.length.times do |i|
      ("a".."z").each do |letter|
        next if letter == word[i]

        new_word = word.dup
        new_word[i] = letter

        adjacent_words << new_word if dictionary.include?(new_word)
      end
    end

    adjacent_words
  end

  def self.load(filename)
    dict_array = File.readlines(filename).map { |line| line.chomp }
    WordChainer.new(Set.new(dict_array))
  end

  def initialize(dictionary)
    @dictionary = dictionary
  end

  def find_chain(source, target)
    return nil if source.length != target.length

    @candidates = Set.new(
      @dictionary.select { |word| word.length == source.length }
    )

    @target = target
    @words_to_expand = [source]
    @candidates = @candidates - [source]
    @parents = { source => nil }
    until @words_to_expand.empty?
      if search_farther
        return build_path_back
      end
    end

    nil
  end

  private
  def search_farther
    new_words_to_expand = expand_words

    return true if new_words_to_expand.include?(@target)

    @candidates = @candidates - new_words_to_expand
    @words_to_expand = new_words_to_expand

    false
  end

  def expand_words
    expanded_words = []
    @words_to_expand.each do |word_to_expand|
      adjacent_words = WordChainer.adjacent_words(@candidates, word_to_expand)

      expanded_words += adjacent_words
      adjacent_words.each do |expanded_word|
        @parents[expanded_word] = word_to_expand
      end
    end

    expanded_words
  end

  def build_path_back
    current_word = @target
    path = []

    until current_word.nil?
      path << current_word
      current_word = @parents[current_word]
    end

    path
  end
end
