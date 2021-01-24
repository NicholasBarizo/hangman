class Hangman
  def initalize; end

  def start
    secret_word = pick_word.chomp
    puts secret_word
    lives = 6
    blanks = '_' * secret_word.length
    wrong_guesses = ''
    while lives.positive?
      puts "You have #{lives} chance#{'s' if lives > 1} remaining"
      guess = get_guess(wrong_guesses)
      if secret_word.split('').any? { |char| char == guess }
        puts "\n\n#{guess} appears #{secret_word.count(guess)} time#{'s' if secret_word.count(guess) > 1} in the word"
        turn_values = game_turn(secret_word, blanks, guess, wrong_guesses)
        blanks = turn_values[0]
        wrong_guesses = turn_values[1]
        end_game('won', lives, secret_word) if blanks == secret_word
      else
        puts "\n\n#{guess} does not appear in the word"
        lives -= 1
        wrong_guesses += guess
        puts "\n#{blanks.split('').join(' ')}\n "
      end
    end
    end_game('loss', lives, secret_word)
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

  def game_turn(secret_word, blanks, guess, wrong_guesses)
    comparison_outcome = compare_words(secret_word, guess, blanks, wrong_guesses)
    blanks = comparison_outcome[0]
    wrong_guesses = comparison_outcome[1]
    puts "\n#{blanks.split('').join(' ')}\n "
    [blanks, wrong_guesses]
  end

  def get_guess(wrong_guesses)
    puts "Incorrect guesses: #{wrong_guesses.split('').join(' ')}" unless wrong_guesses.empty?
    puts 'Guess a letter'
    guess = gets.chomp.downcase
    until guess.length == 1 && ('a'..'z').include?(guess) && !wrong_guesses.include?(guess)
      require_valid_word(guess, wrong_guesses)
      guess = gets.chomp.downcase
    end
    guess
  end

  def require_valid_word(guess, wrong_guesses)
    puts 'Guess a letter' unless guess.length == 1
    puts 'The word only contains letters' unless guess.split('').all? { |char| ('a'..'z').include? char }
    puts "You already guessed #{guess} incorrectly" unless wrong_guesses.include?(guess)
  end

  def compare_words(secret_word, guess, blanks, wrong_guesses)
    modified_blanks = blanks
    blanks.split('').each_with_index do |_, blanks_index|
      secret_word.split('').each_with_index do |secret_char, secret_index|
        if secret_char == guess && blanks_index == secret_index && !wrong_guesses.include?(guess)
          modified_blanks = modified_blanks.split('').map.with_index do |modify_char, modify_index|
            modify_index == secret_index ? guess : modify_char
          end
          modified_blanks = modified_blanks.join('')
        # elsif secret_word.split('').none? { |char| char == guess }
        #   # blanks_index == secret_index && !wrong_guesses.include?(guess)
        #   puts "#{blanks_index} #{secret_index} "
        #   wrong_guesses += guess
        end
      end
    end
    [modified_blanks, wrong_guesses]
  end

  def end_game(outcome, lives, word)
    if outcome == 'won'
      if lives == 1
        puts "You have won with 1 life left\nPlay again? y/n"
      else
        puts "You have won with #{lives} lives left\nPlay again? y/n"
      end
    else
      puts "You have lost! The word was #{word}\nPlay Again?"
    end
    play_again = gets.chomp.downcase
    until %w[y n].include?(play_again)
      puts 'Play again? y/n'
      play_again = gets.chomp.downcase
    end
    play_again == 'y' ? Hangman.new.start : exit
  end
end
Hangman.new.start
