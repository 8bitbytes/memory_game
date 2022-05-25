require './deck.rb'
class Board

    def initialize
        reset_game
        @left_margin = "    "
    end

    def check_win
        if @deck.all_flipped
            return true
        else
            return false    
        end
    end     
    

    def get_card_for_player(cardFaceValue ="", position = -1)
        if @currentPlayer == 1 || @gameType != 'computer'
            return get_card_user_guessed
        else
            return get_card_computer_guessed(cardFaceValue, position)
        end
    end

    def play_again_prompt
        validSelection = false
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
        return playAgain
    end

    def get_card_user_guessed
        validGuess = false

        while !validGuess do
            print_guess_prompt
            tmpGuess = gets.chomp
        
            if !tmpGuess.strip.empty? && check_if_int(tmpGuess)
                guess = tmpGuess.to_i
                if guess <= @deck.cards.length
                    card = @deck.cards[guess -1]
                   validGuess = !card.faceUp
                end
            end    
            
            refresh_page
            puts "Invalid selection"
        end
        if @gameType == "computer"
            @computer_player.add_seen_card(card.cardFaceValue, guess)
        end    
        return card, guess
    end
    
    def get_card_computer_guessed(showing_face ="", current_position = -1)
        validGuess = false
        while !validGuess do
            guess = -1
            if showing_face != "" && current_position != -1
                puts "checking for card I have seen"
                guess = @computer_player.have_i_seen_this(showing_face, current_position)
                if guess == -1
                    guess = @computer_player.pick_random_card(@deck.cards.length)
                end    
            else
                puts "getting random card"
                guess = @computer_player.pick_random_card(@deck.cards.length)
                puts "Computer guessed " + guess.to_s

            end
            if guess <= @deck.cards.length
                card = @deck.cards[guess -1]
                validGuess = !card.faceUp
            end
            refresh_page
        end
        sleep(1)
        return card, guess
    end            
            
        

    def check_if_int(value)
        true if Integer value rescue false
    end

    def print_scoreboard
        puts "╭────────────────────────────────────╮"
        puts "│                                    │"
        puts "│          "+ pad_name(@player_1_name,11) +": " +@playeroneTotalMatches.to_s + "            │"
        puts "│          "+ pad_name(@player_2_name,11) +": " +@playertwoTotalMatches.to_s + "            │"
        puts "│                                    │"
        puts "╰────────────────────────────────────╯"
    end
    
    def print_guess_prompt
        print @currentPlayer == 1 ? @player_1_name : @player_2_name
        print " guess card\n"
    end    

    def print_winner_prompt()

        if @gameType == "solo"
            puts "You WON!! It only took " + @tries.to_s + " tries"
        else    
            whoWon = whichPlayerHasMostMatches
    
            case whoWon
            when 1
                puts @player_1_name + " WON!"
            when 2
                puts @player_2_name +  " WON!"
            when 3
                puts "The game resulted in a TIE"
            end
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

    def setup_game
        @gameType = ""
    
        validSelection = false

        while !validSelection do
            system('clear')
            print_app_header
            puts "Choose game type"
            puts "----------------"
            puts "1. Solo play"
            puts "2. Against Opponent"
            puts "3. Against Computer"

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
                @computer_player = Computer_Player.new
            else
                puts "Invalid selection"
                sleep(1)
            end
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
        if @gameType != "solo"
          print_scoreboard
        end  
    end

    def assignMatchToPlayer
        if @currentPlayer == 1
            @playeroneTotalMatches +=1
        else
            @playertwoTotalMatches +=1
        end
    end

    def whichPlayerHasMostMatches()
        if @playeroneTotalMatches == @playertwoTotalMatches
            return 3
        end    
        
        @playeroneTotalMatches > @playertwoTotalMatches ? 1 : 2
    end 
    
    def nextPlayer
        if @gameType == "solo"
            @currentPlayer = 1
        else    
            @currentPlayer = @currentPlayer == 1 ? 2 : 1
        end     
    end

    def checkMatch(card1,card2)
        do_match = Card.cards_match(card1,card2)
        @tries += 1
        if !do_match
            card1.flip
            card2.flip
            puts "no match"
            sleep(1)
            refresh_page
            nextPlayer
        else
            puts "match!"
            sleep(1)
            assignMatchToPlayer
            refresh_page
        end
    end
    
    def reset_game
        @deck = Deck.new
        @currentPlayer = 1
        @playeroneTotalMatches =0
        @playertwoTotalMatches =0
        @guess1 = 0
        @guess2 = 0
        @tries = 0
        if @gameType == "computer"
            @computer_player = Computer_Player.new 
        end
    end        

end    