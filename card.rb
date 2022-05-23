class Card
    attr_accessor :value, :faceUp, :cardTop, :cardBottom, :cardFillLine, :currentCardFace, :cardFaceValue, :gridSpace

   
    def initialize(faceValueUp, faceValueDown)
        @faceUp = false
        
        @card_output = ""
        @cardFaceValue = faceValueUp
        @cardTop =    "╭────╮"
        @cardFillLine="│    │"
        @cardCenterFaceDown = "│ " + faceValueDown + " │"
        @cardCenterFaceUp = "│ " + @cardFaceValue + " │"
        @cardBottom = "╰────╯"
        @currentCardFace = @faceUp ? @cardCenterFaceUp : @cardCenterFaceDown
    end


    def flip
        @faceUp  = !faceUp
        setCardFace
    end

    def setCardFace
        @currentCardFace = @faceUp ? @cardCenterFaceUp : @cardCenterFaceDown
    end
    
    def print_card
       card_print_instructions = Array[
            @cardTop,
            @cardFillLine,
            @currentCardFace,
            @cardFillLine,
            @cardBottom
       ]
    end

    def self.cards_match(original, compare)
        original.faceUp && compare.faceUp && (original.currentCardFace == compare.currentCardFace)
    end    

end

