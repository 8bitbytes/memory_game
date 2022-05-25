require './card.rb'
require './deck.rb'
require './computer_player.rb'
require './board.rb'
class Game

    def initialize
        @board = Board.new
        @board.setup_game
        game_loop
    end

    def game_loop
        game_over = false
        tries = 0
        @board.refresh_page

        while !game_over do
            validGuess = false
            guess1 = -1
            guess2 =-1
            result = @board.get_card_for_player
            card1 = result.first
            guess1 = result[1]
            card1.flip
            @board.refresh_page

            result = @board.get_card_for_player(card1.cardFaceValue, guess1)
            card2 = result.first
            guess2 = result[1]

            card2.flip
            @board.refresh_page
            @board.checkMatch(card1, card2)
            game_over = @board.check_win
            tries += 1
        end
        
        @board.print_winner_prompt
        
        validSelection = false;
        playAgain = false;

       playAgain = @board.play_again_prompt
        if playAgain
            @board.reset_game
            game_loop
        end    
    end
 end    

 Game.new