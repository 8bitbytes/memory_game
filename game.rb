require './card.rb'
require './deck.rb'

class Game

    def initialize
        game_loop
    end
    
    def game_loop
        game_over = false
        tries = 0
        @deck = Deck.new
        system('clear')
        @deck.display

        while !game_over do
            validGuess = false
            while !validGuess do
                puts "guess card"
                tmpGuess = gets.chomp
                system('clear')
                if check_if_int(tmpGuess)
                    guess1 = tmpGuess.to_i
                
                    if guess1 <= @deck.cards.length
                       validGuess = true
                    end
                end
                card1 = @deck.cards[guess1 -1]
                validGuess = !card1.faceUp
                @deck.display
                puts "Invalid selection"
            end            
            
            system('clear')
            
            card1.flip
            @deck.display

            validGuess = false

            while !validGuess do
                puts "guess card"
                tmpGuess = gets.chomp
                system('clear')

                if check_if_int(tmpGuess)
                    guess2 = tmpGuess.to_i
                    if guess2 <= @deck.cards.length
                        validGuess = true
                    end
                end    
                card2 = @deck.cards[guess2 -1]
                validGuess = !card2.faceUp
                @deck.display
                puts "Invalid selection"
            end 

            system('clear')
            card2.flip
            
            @deck.display

            do_match = Card.cards_match(card1,card2)

            if !do_match
                card1.flip
                card2.flip
                puts "no match"
                sleep(1)
                system('clear')
                @deck.display
            else
                puts "match!"
                sleep(1)
                system('clear')
                @deck.display
            end

            game_over = check_win
            tries += 1
        end
        
        puts "You WON!! It only took " + tries.to_s + " tries"
        validSelection = false;
        playAgain = false;

        while !validSelection do
            puts "play again?(y/n)"
            playAgain = gets.chomp.downcase

            case playAgain
            when 'y'
                validSelection = true
                playAgain = true
            when 'n'
              validSelection = true
              playAgain = false
            else
             puts "Invalid selection. Please enter y or n"
            end
        end
        
        if playAgain
            game_loop
        end    
    end
    
    def check_win
        if @deck.all_flipped
            return true
        else
            return false    
        end
    end     
    
    
    private 

    def check_if_int(value)
        true if Integer value rescue false
    end    
 end    

 Game.new