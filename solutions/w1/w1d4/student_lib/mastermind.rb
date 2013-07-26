class Mastermind

  def initialize
    @pegs = ["R", "G", "B", "Y", "O", "P"].shuffle
    @guess = ""
  end

  def exact_matches
    exact_matches = 0
    guess_arr = @guess.split("")
    guess_arr.each_with_index do |color, i|
      if color == @pegs[i]
        exact_matches += 1
      end
    end

    exact_matches
  end

  def get_guess
    until is_guess_valid?
      puts "Please make your guess, ex. RGYB = Red, Green, Yellow, Blue"
      @guess = gets.chomp.upcase
    end
  end

  def is_guess_valid?
    return false if @guess.length != 4
    true
  end

  def near_matches
    near_matches = 0
    @guess.each_char do |color|
      if @pegs[0..3].include?(color)
        near_matches += 1
      end
    end

    near_matches - exact_matches
  end

  def play
    puts "Valid colors are: R, G, B, Y, O, P"

    10.times do
      get_guess

      if win?
        puts "You win!"
        return
      end

      puts "#{exact_matches} exact matches and #{near_matches} near matches."
      @guess = ""
    end

    puts "Sorry, you lost."
  end

  def win?
    colors = @guess.split("")
    colors == @pegs[0..3]
  end

end

my_match = Mastermind.new

my_match.play