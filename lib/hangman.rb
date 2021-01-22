class Hangman
  def initalize; end

  def start
    secret_word = pick_word
    puts secret_word
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
end
Hangman.new.start
