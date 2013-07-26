module Mastermind
  class Code
    PEG_COLORS = [
      :blue,
      :green,
      :orange,
      :purple,
      :red,
      :yellow
    ]

    COLOR_MAPPING = {
      "B" => :blue,
      "G" => :green,
      "O" => :orange,
      "P" => :purple,
      "R" => :red,
      "Y" => :yellow
    }

    def self.parse(str)
      # factory method
      pegs = str.split("").map { |letter| COLOR_MAPPING[letter] }

      Code.new(pegs)
    end

    def self.random
      pegs = []
      4.times { pegs << PEG_COLORS.sample }

      Code.new(pegs)
    end

    def initialize(pegs)
      @pegs = pegs
    end

    attr_reader :pegs

    def [](i)
      @pegs[i]
    end

    def color_count
      color_count = Hash.new(0)

      @pegs.each do |color|
        color_count[color] += 1
      end

      color_count
    end

    def exact_matches(other_code)
      exact_matches = 0
      @pegs.each_index do |i|
        exact_matches += 1 if self[i] == other_code[i]
      end

      exact_matches
    end

    def near_matches(other_code)
      color_count1 = self.color_count
      color_count2 = other_code.color_count

      near_matches = 0
      color_count1.keys.each do |color|
        next unless color_count2.has_key?(color)

        near_matches += [color_count1[color], color_count2[color]].min
      end

      near_matches - self.exact_matches(other_code)
    end

    def ==(other_code)
      return false unless other_code.is_a?(Code)

      self.pegs == other_code.pegs
    end
  end

  class Game
    def play
      @secret_code = Code.random
      @guesses_left = 10

      while @guesses_left > 0
        play_turn

        return if @guess == @secret_code
      end

      puts "You aren't very good at this..."
    end

    private

    def get_guess
      puts "Guess the code:"

      Code.parse(gets.chomp)
    end

    def play_turn
      @guess = get_guess

      if @guess == @secret_code
        puts "You're worth it!"
        return
      end

      exact_matches = @guess.exact_matches(@secret_code)
      near_matches = @guess.near_matches(@secret_code)

      puts "You got #{exact_matches} exact matches!"
      puts "You got #{near_matches} near matches!"

      @guesses_left -= 1
    end
  end
end
