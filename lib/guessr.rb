require "guessr/version"
require "set"
require "camping"

Camping.goes :Guessr

module Guessr
  module Models
    class Player < Base
      validates :name, presence: true, uniqueness: true
      # alternately: validates :name, presence: true
    end

    class Hangman < Base
      validates :answer, presence: true,
        format: { with: /^[a-z]+$/, message: "only lowercase words allowed"}
      serialize :guesses
      before_update :set_finished!

      def finished?
        self.turns.zero? || self.answer.chars.all? { |l| self.guesses.include?(l) }
      end

      def guess_letter(letter)
        self.guesses.add(letter)
        self.turns -= 1 unless self.answer.include?(letter)
      end

      private
      def set_finished!
        self.finished = true if self.finished?
      end
    end

    class BasicSchema < V 1.0
      def self.up
        create_table Player.table_name do |t|
          t.string :name
          t.timestamps
        end

        create_table Hangman.table_name do |t|
          t.integer :turns, :default => 7
          t.string :answer
          t.string :guesses
          t.boolean :finished
          t.timestamps
        end
      end

      def self.down
        drop_table Player.table_name
        drop_table Hangman.table_name
      end
    end
  end
end

def Guessr.create
  Guessr::Models.create_schema
end

def choose_player
  # TODO
end

def new_player
  # TODO
end

def resume_game
  # TODO
end

def new_game
  # TODO
end

def prompt(question, validator, error_msg, clear: nil)
  `clear` if clear
  puts "\n#{question}\n"
  result = gets.chomp
  until result =~ validator
    puts "\n#{error_msg}\n"
    result = gets.chomp
  end
  exit if result == 'QUIT'
  puts
  result
end

def player_screen
  message = "Would you like to (1) pick an existing player, (2) add a new player, or (QUIT)?"
  choice = prompt(message, /^([12]|QUIT)$/, "Please choose 1, 2, 3, or QUIT.", clear: true).to_i
  case choice
  when 1
    choose_player
  when 2
    new_player
  end
end

def game_screen
  message = "Would you like to (1) continue an existing game, (2) start a new game, or (QUIT)?"
  choice = prompt(message, /^([12]|QUIT)$/, "Please choose 1, 2, or QUIT.", clear: true).to_i
  case choice
  when 1
    resume_game
  when 2
    new_game
  end
end

puts "Welcome to Guessr!"
player_screen
game_screen
puts "Thanks for playing!"
