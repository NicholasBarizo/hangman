# Hangman Project
This is my first project involving the saving/loading of data to and from a file. During this project I continued to practice keeping my methods small and my code readable, but I have yet to reach my expectations. Upon looking through my code I have discovered several ways to clean my methods, but after several rereads I now struggle to find more possibilities.\
Initially, I had trouble determining the best way to save the letters that the user had guessed correctly. I believe I had overcomplicated it as the solution I ended up using was relatively simple. When the secret word is chosen, a string of underscores called "blanks" will be created that equals the length of the secret word. When a player guesses a letter right, the indices of "blanks" will be replaced by the hidden word's counterparts if said counterparts equal the guess.

# From The Odin Project
https://www.theodinproject.com/courses/ruby-programming/lessons/file-i-o-and-serialization-ruby-programming