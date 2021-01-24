class Hangman
  def initalize; end

  def start
    secret_word = pick_word.chomp
    puts secret_word
    lives = 6
    blanks = '_' * secret_word.length
    while lives.positive?
      puts "You have #{lives} chance#{'s' if lives == 1} remaining"
      guess = get_guess
      if secret_word.split('').any? { |char| char == guess }
        blanks = game_turn(secret_word, blanks, guess)
      else
        lives -= 1
      end
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
    word.downcase
  end

  def game_turn(secret_word, blanks, guess)
    blanks = compare_words(secret_word, guess, blanks)
    puts "\n#{blanks.split('').join(' ')}\n "
    blanks
  end
  
  def get_guess()
    puts 'Guess a letter'
    guess = gets.chomp.downcase
    until guess.length == 1 && guess.split('').all? { |char| ('a'..'z').include? char}
      require_valid_word(guess)
      guess = gets.chomp.downcase
    end
    guess
  end

  def require_valid_word(guess)
    puts 'Guess a letter' unless guess.length == 1
    puts 'The word only contains letters' unless guess.split('').all? { |char| ('a'..'z').include? char}
  end

  def compare_words(secret_word, guess, blanks)
    modified_blanks = blanks
    blanks.split('').each_with_index do |_, blanks_index|
      secret_word.split('').each_with_index do |secret_char, secret_index|
        if secret_char == guess && blanks_index == secret_index
          modified_blanks = modified_blanks.split('').map.with_index do |modify_char, modify_index |
            modify_index == secret_index ? guess : modify_char
          end
          modified_blanks = modified_blanks.join('')
        end
      end
    end
    modified_blanks
  end

  def lose(word)
    puts "You have lost! The word was #{word}\nPlay Again?"
  end
end
Hangman.new.start
