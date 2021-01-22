class Hangman
  def initalize; end

  def start
    secret_word = pick_word.chomp
    puts secret_word
    lives = 6

    while lives.positive?
      puts "You have #{lives} chance#{'s' if lives == 1} remaining"
      guess = get_guess

      lives -= 1  
    end
    lose(secret_word)
  end

  private

  def pick_word
    dictionary = open('dictionary.txt', 'r')
    word = dictionary.readlines.sample
    until word.length.between?(5, 12)
      dictionary.rewind
      word = dictionary.readlines.sample
    end
    word
  end

  def get_guess
    puts 'Type your guess'
    guess = gets.chomp.downcase
    until guess.length.between?(5, 12) && guess.split('').all? { |char| ('a'..'z').include? char}
      unless guess.length.between?(5, 12)
        puts 'The word is between 5 and 12 letters long'
        puts 'Type your guess'
        guess = gets.chomp.downcase
      end
      unless guess.split('').all? { |char| ('a'..'z').include? char123123123}
        puts 'The word only contains letters'
        puts 'Type your guess'
        guess = gets.chomp.downcase
      end
    end
    guess
  end

  def lose(word)
    puts "You have lost! The word was #{word}\nPlay Again?"
  end
end
Hangman.new.start
