class Hangman
  def initalize; end

  def start
    game_data = clean_save_data(prompt_load)
    lives = game_data[0]
    secret_word = game_data[1]
    blanks = game_data[2]
    wrong_guesses = game_data[3]

    turn = 1
    while lives.positive?
      draw_gallows(lives)
      puts "You have #{lives} chance#{'s' if lives > 1} remaining"
      puts "\n#{blanks.split('').join(' ')}\n "
      guess = get_guess(turn, lives, secret_word, blanks, wrong_guesses)
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
      end
      turn += 1
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
    [blanks, wrong_guesses]
  end

  def get_guess(turn, lives, secret_word, blanks, wrong_guesses)
    puts "Incorrect guesses: #{wrong_guesses.split('').join(' ')}" unless wrong_guesses.empty?
    puts "Guess a letter#{" - Type \"save\" to save and exit" if turn > 1}"
    guess = gets.chomp.downcase
    save_data(lives, secret_word, blanks, wrong_guesses) if guess == 'save'
    until guess.length == 1 && ('a'..'z').include?(guess) && !wrong_guesses.include?(guess)
      require_valid_word(guess, wrong_guesses)
      guess = gets.chomp.downcase
    end
    guess
  end

  def draw_gallows(lives)
    head, torso, left_arm, right_arm, left_leg, right_leg = [' '] * 6
    head = 'O' if lives < 6
    torso = '|' if lives < 5
    left_arm = '/' if lives < 4
    right_arm = '\\' if lives < 3
    left_leg = '/' if lives < 2
    right_leg = '\\' if lives < 1
    display_gallows(head, torso, left_arm, right_arm, left_leg, right_leg)
  end
  
  def display_gallows(head, torso, left_arm, right_arm, left_leg, right_leg)
    puts ' __________'
    puts ' |  /  |'
    puts " | /   #{head}"
    puts " |/   #{left_arm}#{torso}#{right_arm}"
    puts " |   #{left_arm} #{torso} #{right_arm}"
    puts " |     #{torso}"
    puts " |    #{left_leg} #{right_leg}"
    puts " |   #{left_leg}   #{right_leg}"
    puts ' |'
    puts ' |'
  end

  def require_valid_word(guess, wrong_guesses)
    puts 'Guess a letter' unless guess.length == 1
    puts 'The word only contains letters' unless guess.split('').all? { |char| ('a'..'z').include? char }
    puts "You already guessed #{guess} incorrectly" if wrong_guesses.include?(guess) && !guess.empty?
  end

  def compare_words(secret_word, guess, blanks, wrong_guesses)
    modified_blanks = blanks
    blanks.split('').each_with_index do |_, blanks_index|
      secret_word.split('').each_with_index do |secret_char, secret_index|
        if secret_char == guess && blanks_index == secret_index 
          modified_blanks = modified_blanks.split('').map.with_index do |modify_char, modify_index|
            modify_index == secret_index ? guess : modify_char
          end
          modified_blanks = modified_blanks.join('')
        end
      end
    end
    [modified_blanks, wrong_guesses]
  end

  def end_game(outcome, lives, word)
    draw_gallows(lives)
    if outcome == 'won'
      if lives == 1
        puts "You have won with 1 life left\nPlay again? y/n"
      else
        puts "You have won with #{lives} lives left\nPlay again? y/n"
      end
    else
      puts "You are out of chances! The word was #{word}\nPlay Again? y/n"
    end
    play_again = gets.chomp.downcase
    until %w[y n].include?(play_again)
      puts 'Play again? y/n'
      play_again = gets.chomp.downcase
    end
    play_again == 'y' ? Hangman.new.start : exit
  end

  def save_data(lives, secret_word, blanks, wrong_guesses)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    name = get_save_name
    name = check_duplicate_name(name)
    File.open("saves/#{name}", 'w') do |file|
      file.puts [lives, secret_word, blanks, wrong_guesses]
    end
    exit
  end

  def get_save_name
    puts 'What would you like to call this save?'
    name = gets.chomp
    until name.split('').all? { |char| ('a'..'z').include?(char) || ('A'..'Z').include?(char) || char == ' '}
      puts name == '' ? 'The name can not be empty' : 'The name can not contain any special characters'
      name = gets.chomp
    end
    name
  end

  def check_duplicate_name(name)
    overwrite = ''
    until overwrite == 'y' || !File.exist?("saves/#{name}")
      puts "#{name} already exists. Do you want to overwrite this save? y/n"
      overwrite = gets.chomp.downcase
      if overwrite == 'n'
        puts 'What would you like to call this save?'
        name = get_save_name
      end
    end
    name
  end

  def prompt_load
    puts 'Would you like to load a save? y/n'
    load_save = gets.chomp.downcase
    until %w[y n].include?(load_save)
      puts 'Would you like to load a save? y/n'
      load_save = gets.chomp.downcase
    end
    load_save
  end

  def load_file
    puts 'Which save would you like to load?'
    puts Dir.each_child('saves') { |file| puts file}
    load_file = gets.chomp
    until Dir.entries('saves').include?(load_file)
      puts "#{load_file} does not exist" unless load_file.empty?
      puts 'The filename can not be empty' if load_file.empty?
      load_file = gets.chomp
    end
    File.open("saves/#{load_file}", 'r')
  end

  def clean_save_data(load_data)
    if load_data == 'y'
      saved_data = load_file
      lives = saved_data.readline.chomp.to_i
      secret_word = saved_data.readline.chomp
      blanks = saved_data.readline.chomp
      wrong_guesses = saved_data.readline.chomp
    else
      secret_word = pick_word.chomp
      lives = 6
      blanks = '_' * secret_word.length
      wrong_guesses = ''
    end
    [lives, secret_word, blanks, wrong_guesses]
  end
end
Hangman.new.start
