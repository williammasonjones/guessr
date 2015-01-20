require "guessr/version"
require "camping"

Camping.goes :Guessr

module Guessr
  module Models
    class Player < Base
    end

    class Hangman < Base
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
