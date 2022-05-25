require './card'

class Deck
    attr_accessor :cards, :playeroneTotalMatches, :playertwoTotalMatches, :deck_size

  
    def initialize(deck_size = 12)

        if deck_size > 12
            raise "Max size for deck is 12"
        end 

        @deck_size = deck_size

        #@cardValues = ["🦊","🦔","🦄","🦧","🐁","🐄"]
        @cardValues = ["🦊","🦔","🦄","🦥","🦦","🐄"]
        #@cardValues = ["☢","🦔","🦄","😈","🐧","🐄"]
        @faceValueDown = "💎"
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

    def display(rows = 4, cols = 3 )
        gridSpace = "   "
        left_margin = "           "
        i = 0
        outText = ""
        row_start = 0
        rCount = rows - 1

        for z in 0...cols do
            for i in 0...rows
                print (i == 0 ? left_margin : "") + @cards[row_start + i].cardTop + gridSpace
            end

            print "\n"

            for i in 0...rows
                print (i == 0 ? left_margin : "") + @cards[row_start + i].cardFillLine + gridSpace
            end

            print "\n"


            for i in 0...rows
                print (i == 0 ? left_margin : "") + @cards[row_start + i].currentCardFace + gridSpace
            end

            print "\n"


            for i in 0...rows
                print (i == 0 ? left_margin : "") + @cards[row_start + i].cardFillLine + gridSpace
            end

            print "\n"


            for i in 0...rows
                print (i == 0 ? left_margin : "") + @cards[row_start + i].cardBottom + gridSpace
            end

            print "\n"
            
            for i in 0...rows
                card_number = row_start + i + 1
                print (i == 0 ? left_margin : "") + card_number.to_s + "         "
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
