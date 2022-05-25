require './computer_player_seen_card'

class Computer_Player
    def initialize
        @cardsIHaveSeen = Array.new
    end

    def add_seen_card(face_value, position)
        seen = Computer_Player_Seen_Card.new(position, face_value)
        @cardsIHaveSeen.append(seen)
    end
    
    def pick_random_card(deck_size)
       result =  rand(deck_size)
       return result
    end

    def have_i_seen_this(face_value,position_i_am_at)
        for i in 0...@cardsIHaveSeen.length
            if @cardsIHaveSeen[i].card_value == face_value
                if @cardsIHaveSeen[i].position != position_i_am_at
                   return @cardsIHaveSeen[i].position
                end   
            end
        end
        return -1
    end            
end