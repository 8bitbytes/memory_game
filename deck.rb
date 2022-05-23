require './card'

class Deck
    attr_accessor :cards, :playeroneTotalMatches, :playertwoTotalMatches

  
    def initialize(deck_size = 12)

        if deck_size > 12
            raise "Max size for deck is 12"
        end 

        #@cardValues = ["🦊","🦔","🦄","🦧","🐁","🐄"]
        @cardValues = ["🦊","🦔","🦄","🦥","🦦","🐄"]
        #@cardValues = ["☢","🦔","🦄","😈","🐧","🐄"]
        @faceValueDown = "💎"
        @playeroneMatchPositions =[]
        @playertwoMatchPositions =[]
        @playeroneTotalMatches =0
        @playertwoTotalMatches =0

        i = 0;
        iterations = deck_size / 2
        @cards = Array.new

        until i >= iterations do
            @cards.append(Card.new(@cardValues[i - 1],@faceValueDown))
            @cards.append(Card.new(@cardValues[i - 1],@faceValueDown))
            i += 1
        end
        cards.shuffle!
    end
    
    def assignMatchToPlayer(card1Pos, card2Pos, playerNum)
        if playerNum == 1
            @playeroneMatchPositions.append(card1Pos)
            @playeroneMatchPositions.append(card2Pos)
            @playeroneTotalMatches +=1
        else
            @playertwoMatchPositions.append(card1Pos)
            @playertwoMatchPositions.append(card2Pos)
            @playertwoTotalMatches +=1
        end
    end

    def whichPlayerHasMostMatches()
        if playeroneTotalMatches == playertwoTotalMatches
            return 3
        end    
        
        playeroneTotalMatches > playertwoTotalMatches ? 1 : 2
    end    

    def display(rows = 4, cols = 3 )
        gridSpace = "   "
        i = 0
        outText = ""
        row_start = 0
        rCount = rows - 1

        for z in 0...cols do
            for i in 0...rows
                print @cards[row_start + i].cardTop + gridSpace
            end

            print "\n"

            for i in 0...rows
                print @cards[row_start + i].cardFillLine + gridSpace
            end

            print "\n"


            for i in 0...rows
                print @cards[row_start + i].currentCardFace + gridSpace
            end

            print "\n"


            for i in 0...rows
                print @cards[row_start + i].cardFillLine + gridSpace
            end

            print "\n"


            for i in 0...rows
                print @cards[row_start + i].cardBottom + gridSpace
            end

            print "\n"
            
            for i in 0...rows
                card_number = row_start + i + 1
                print card_number.to_s + "         "
            end

            print "\n"

            row_start = row_start + rows
        end
    end   

    def all_flipped
        retval = true

        cardLength = @cards.length - 1
        for i in 0..cardLength
            if !@cards[i].faceUp
                retval = false;
                break
            end     
        end    
      return retval
    end            

end
