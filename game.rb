require './card.rb'
require './deck.rb'

class Game

    def initialize
        game_type
        if @gameType == "solo"
            game_loop_solo
        else
            game_loop_multiplayer
        end        
    end
    
    def game_type
        
        @gameType = ""

        validSelection = false

        while !validSelection do
            system('clear')
            print_app_header
            puts "Choose game type"
            puts "----------------"
            puts "1. Solo play"
            puts "2. Against Opponent"

            game_selection = gets.chomp

            case game_selection
            when "1"
                @gameType="solo"
                puts "Player 1: Enter your name"
                @player_1_name = gets.chomp
                validSelection = true
            when "2"
                @gameType="human"
                puts "Player 1: Enter your name"
                @player_1_name = gets.chomp
                puts "Player 2: Enter your name"
                @player_2_name = gets.chomp
                validSelection = true
            when "3"
                @gameType="computer"
                puts "Enter your name"
                @player_1_name = gets.chomp
                @player_2_name = "Computer"
                validSelection = true
            else
                puts "Invalid selection"
                sleep(1)
            end
        end                    
    end    

        
    def game_loop_solo
        game_over = false
        @currentPlayer = 1
        tries = 0
        @deck = Deck.new
        system('clear')
        @deck.display

        while !game_over do
            validGuess = false
            while !validGuess do
                puts @player_1_name + " choose a card"
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
                puts @player_1_name + " choose a card"
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
            game_loop_solo
        end    
    end

    ######## MULTIPLAYER ############
    def game_loop_multiplayer
        game_over = false
        tries = 0
        @currentPlayer = 1
        @deck = Deck.new
        refresh_page

        while !game_over do
            validGuess = false
            guess1 = -1
            guess2 =-1
            while !validGuess do
                print_guess_prompt
                tmpGuess = gets.chomp
                #system('clear')

                if check_if_int(tmpGuess)
                    guess1 = tmpGuess.to_i
                
                    if guess1 <= @deck.cards.length
                       validGuess = true
                    end
                end
                card1 = @deck.cards[guess1 -1]
                validGuess = !card1.faceUp
                refresh_page
                puts "Invalid selection"
            end            
                        
            card1.flip
            refresh_page

            validGuess = false

            while !validGuess do
                print_guess_prompt
                tmpGuess = gets.chomp
            
                if check_if_int(tmpGuess)
                    guess2 = tmpGuess.to_i
                    if guess2 <= @deck.cards.length
                        validGuess = true
                    end
                end    
                card2 = @deck.cards[guess2 -1]
                validGuess = !card2.faceUp
                refresh_page
                puts "Invalid selection"
            end 

            card2.flip
            
           refresh_page

            do_match = Card.cards_match(card1,card2)

            if !do_match
                card1.flip
                card2.flip
                puts "no match"
                sleep(1)
                refresh_page
                @currentPlayer = @currentPlayer == 1 ? 2 : 1 
            else
                puts "match!"
                sleep(1)
                @deck.assignMatchToPlayer(guess1, guess2, @currentPlayer)
                refresh_page
            end

            game_over = check_win
            tries += 1

        end
        
        print_winner_prompt
        
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
            game_loop_multiplayer
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

    def print_scoreboard
        puts "╭────────────────────────────────────╮"
        puts "│                                    │"
        puts "│          "+ pad_name(@player_1_name,10) +": " +@deck.playeroneTotalMatches.to_s + "             │"
        puts "│          "+ pad_name(@player_2_name, 10) +": " +@deck.playertwoTotalMatches.to_s + "             │"
        puts "│                                    │"
        puts "╰────────────────────────────────────╯"
    end
    
    def print_guess_prompt
        print @currentPlayer == 1 ? @player_1_name : @player_2_name
        print " guess card\n"
    end    

    def print_winner_prompt
        whoWon = @deck.whichPlayerHasMostMatches

        case whoWon
        when 1
            puts @player_1_name + " WON!"
        when 2
            puts @player_2_name +  " WON!"
        when 3
            puts "The game resulted in a TIE"
        end
    end                

    def pad_name(name, maxLen)
        if name.length > maxLen
            diff = name.length - maxLen
            return name[0, name.length - diff]
        else
            howManySpaces = maxLen - name.length
            for i in 0...howManySpaces
                name += " "
            end
            return name
        end
    end
    
    def print_app_header
        puts "╭────╮ ╭────╮ ╭────╮ ╭────╮ ╭────╮ ╭────╮   ╭────╮ ╭────╮ ╭────╮ ╭────╮"
        puts "│    │ │    │ │    │ │    │ │    │ │    │   │    │ │    │ │    │ │    │"
        puts "│  M │ │  E │ │  M │ │  O │ │  R │ │  Y │   │  G │ │  A │ │  M │ │  E │"
        puts "│    │ │    │ │    │ │    │ │    │ │    │   │    │ │    │ │    │ │    │"
        puts "╰────╯ ╰────╯ ╰────╯ ╰────╯ ╰────╯ ╰────╯   ╰────╯ ╰────╯ ╰────╯ ╰────╯"
        puts
        puts"────────────────────────────────────────────────────────────────────────"
    end

    def refresh_page
        system('clear')
        print_app_header
        @deck.display
        print_scoreboard
    end
 end    

 Game.new