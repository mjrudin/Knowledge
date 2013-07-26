class Hangman


  def initialize
    puts "How many human players?"
    num_players = gets.chomp.to_i
    case num_players
    when 0
      @guesser = ComputerPlayer.new
      @executioner = ComputerPlayer.new
    when 1
      puts "Are you setting the word? y/n"
      if gets.chomp.downcase == "n"
        @guesser = HumanPlayer.new
        @executioner = ComputerPlayer.new
      else
        @guesser = ComputerPlayer.new
        @executioner = HumanPlayer.new
      end
    when 2
      @guesser = HumanPlayer.new
      @executioner = HumanPlayer.new
    end
    nil
  end

  def play
    word_length = @executioner.choose_word
    create_board(word_length)
    until won?
      puts @board
      guess = @guesser.make_guess(@board)
      if guess.nil?
        puts "Im stumped!"
        break
      end
      positions = @executioner.check_guess(guess)
      update_board(positions, guess)
    end
    puts @board
  end

  def board
    @board
  end

  def create_board(word_length)
    @board = "_" * word_length
  end

  def update_board(positions, letter)
    positions.each do |position|
      @board[position] = letter
    end
  end

  def won?
    !@board.include?("_")
  end

  def board_size
    @board.length
  end

end

class HumanPlayer

  def initialize
  end

  def choose_word
    puts "Input the length of chosen word"
    @length = gets.chomp.to_i
  end

  def make_guess(board)
    puts "Guess a letter"
    gets.chomp.downcase
  end

  def check_guess(guess)
    puts "At what indices does the letter #{guess} occur?"
    gets.chomp.split(' ').map(&:to_i)
  end

end

class ComputerPlayer

  def initialize
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @guessed_letters = []
    @candidates = []
  end

  def choose_word
    @word = @dictionary.sample
    @length = @word.length
  end


  def make_guess(board)
    # converting _ to . for use in regex
    test_board = board.dup.gsub('_', '.')

    update_candidates(test_board)

    letter_frequencies = Hash.new(0)

    @candidates.each do |word|
      word.each_char do |letter|
        next if test_board.include?(letter) || @guessed_letters.include?(letter)
        letter_frequencies[letter] += 1
      end
    end

    guess = letter_frequencies.key(letter_frequencies.values.max)
    @guessed_letters << guess
    guess
  end

  def update_candidates(board)
    # the first time limit candidates to words of the correct length
    if @guessed_letters.empty?
      @candidates = @dictionary.select {|word| board.length}
    end

    # reduce candidates to words that share letters with correct word
    @candidates.select! { |word| word =~ /^#{board}$/ }
  end

  def check_guess(guess)
    positions = []
    @word.split("").each_with_index do |letter, index|
      if letter == guess
        positions << index
      end
    end
    positions
  end

end

if __FILE__ == $PROGRAM_NAME
  g = Hangman.new
  g.play
end
