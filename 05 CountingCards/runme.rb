class Object
  
  # Traps errors for non-clonable items.
  # Why would I want to get an error on an
  # immutable object? I just want a "copy."
  alias :__clone__ :clone
  def clone
    begin
      self.__clone__
    rescue
      self
    end
  end

  # Make a copy that won't affect the
  # source if the copy is changed.
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end
end
  
  
class CardSharp  
  
  # Convenience method to run a game and output the results in one go
  def self.run_game(game_file="INPUT.txt", solution_file="solution.txt")
    CardSharp.new(game_file, solution_file)
  end

  def initialize(game_file, solution_file)
    lines = File.readlines(game_file)
    lils_hands = play_round(lines)
    File.open(solution_file, "w"){|file| lils_hands.each {|a| file.puts(a.join(" "))}}
  end
  
  private

  # split a move into its component parts
  def parse_move(move)
    [move[0]].concat(move[1..-1].split(":"))
  end

  # plays just one move of a player's turn
  def play_move(type, card, player, target, hands, lils_play_cache)
    
    unless card == "??"
      if target 
        hands[target] ||= []
        if type == "+"
          # player received a card
          
          # Can't ever get a card from the discard pile
          throw :badplay if hands['discard'].include? card
          
          # Swap unknown received cards for their "know" values
          if player == "Lil" and (lookup = hands['Lil'].index("+??:#{target}"))
            hands['Lil'][lookup] = card
          else  

            # Swap the cards from target to the player
            hands[player] << card unless hands[player].include? card
            hands[target].delete card
          end
        else
          # player gave a card

          # We always know Rocky's hand so a give from him has to be in his hand
          if player == "Rocky"
            throw :badplay unless hands["Rocky"].include? card
          end

          # The other two players can't give a card that's in Lil or Rocky's hand
          if ["Shady", "Danny"].include? player
            throw :badplay if hands["Rocky"].include?(card) or hands["Lil"].include?(card)
          end

          # Swap the cards from the player to the target
          hands[target] << card unless hands[target].include? card
          hands[player].delete card
        end
      else
        # player drew a card
        
        # draws can't already be in someone's hand
        throw :badplay if hands.collect {|owner, hand| hand.include?(card) }.include? true
        
        # Replace Lil's unknown draws with the draw from the signal
        if player == "Lil" and (lookup = hands['Lil'].index("+??"))
          hands['Lil'][lookup] = card
        else  
          hands[player] << card
        end
      end
    else
      # unkown card
      if target 
        if type == "+"
          # player receives an unknown card from another player
          # don't need to cache this because we catch it in the give
        else
          # player received an unkown card
          
          # remember the position of an unknown card in Lil's hand, position maters
          hands['Lil'] << "+??:#{player}" if target == 'Lil'
        end
      else
        # remember the position of an unknown card in Lil's hand, position maters
        hands['Lil'] << "+??" if target == 'Lil'
      end
    end

    # Cache gives and draws for Lil so we can test them against the signals
    if target == "Lil"
      lils_play_cache << [type: type, card: card, player: player]
    elsif player == "Lil" and !target
      lils_play_cache << [type: type, card: card, player: nil]
    end

  end

  # plays all moves in a player's turn
  def play_turn(player, moves, hands, lils_play_cache)
    hands[player] ||= []
    moves.each do |move|
      type = move[0]
      card, target = move[1..-1].split(":")
      play_move(type, card, player, target, hands, lils_play_cache)
    end
  end

  # processes all players turns in a round
  # called recursively to test signals branches
  def play_round(lines, hands_parent={}, lils_hands_parent=[])
    # Clone to protect previous state
    lils_hands  = lils_hands_parent.deep_clone
    hands       = hands_parent.deep_clone
  
    # lets us know if we got through a round without any hints
    # if so then we had a data only hand so we need to add the
    # draw only hand to the set of lil's hands.
    loop_count = 0

    # remember moves involving Lil so we can test for them later
    lils_play_cache = []
    
    # cache lil's last move to use with a set of hints
    lils_last_move = nil
    
    # flag to let us know if we've gotten through
    # a set of signals without finding any that worked
    started_testing = false
    
    while line = lines.shift
      
      parts   = line.split
      player  = parts[0]
      moves   = parts[1..-1]

      if player == "*" 
        started_testing = true
        # Parse lil's play (checks to see signal and hand formats match)
        if lils_parsed_play = parse_lils_turn(lils_last_move, moves) 
          # check for a mismatch in the number of moves in the signal
          if moves.empty?
            # check as much as we can up to this point
            if valid_signal? lils_parsed_play, hands, lils_play_cache

              # Create a new copy so we don't affect the state of parallel signals
              test_hands = hands.deep_clone
              test_lils_play_cache = lils_play_cache.deep_clone
              play_turn("Lil", lils_parsed_play, test_hands, test_lils_play_cache) 

              # save Lil's current hand to the set of her hands
              # we assume it's right till it's proven not to be
              test_lils_hands = lils_hands.deep_clone
              test_lils_hands << test_hands['Lil']
          
              # drop any remaining signals so they aren't processed in the recursion
              test_lines = lines.drop_while {|line| line[0] == "*"}
          
              # play the next round(s) but catch any problems down the line
              future_hands = catch(:badplay) do
                play_round(test_lines, test_hands, test_lils_hands)
              end
            
              # all the down stream hands worked (yay!) so bubble up the solution 
              return future_hands if future_hands

            end
          end
        end
      else
        # none of the signals worked because of a previously bad signal
        return if started_testing 
      
        if player == "Lil"
          # if there're no ??'s then it's raw data
          unless line.include? "??"
            play_turn('Lil', moves, hands, lils_play_cache)
          end
      
          # test for inconsistent setup methodologies
          if loop_count == 2 and lils_hands.empty? 
            # We need to save the START move not the current move
            lils_hands = [lils_last_move.collect{|card| card.delete("+")}]
          end
      
          # remember Lil's hand so it can be figured out using the signals
          lils_last_move = moves
        else
          loop_count += 1 if player == "Shady"
          play_turn(player, moves, hands, lils_play_cache)
        end
      end

    end
    # none of the signals could work because of a previous bad state
    return if started_testing 

    # Everything worked, bubble up
    lils_hands
  end

  # replace unkown's in lil's turn with a signal set
  def parse_lils_turn(lils_hand, signals)
    lils = lils_hand.deep_clone
    lils.each_with_index do |move, index|
      # look for the unknowns and replace them
      if move.include? "??" 
        signal = signals.shift

        # exit if there is a mismatch between the signal 
        # and what we know is the structure of the hand.
        move, card, player = parse_move(move)
        signal_move, signal_card, signal_player = parse_move(signal)
        return unless move == signal_move and player == signal_player

        lils[index] = signal
      end
    end
    lils
  end

  # checks to see if Lil's hand is possible given what we know so far
  def valid_signal?(lils_play, hands, lils_play_cache)
    hand_test = hands.deep_clone
    play_cache = lils_play_cache.deep_clone
    
    lils_play.each do |move|
      type, card, target = parse_move(move)
    
      # Handle draws and 
      if target
        # Lil received a card
        if type == "+"

          # If there was a mystery "get" then the card can't already be in Lil's hand
          if play_cache.include?( [type: "-", card: "??", player: target])
            return false if found = hand_test["Lil"].include?(card)
          end
        
          # if Rocky gave it then it must be in Rocky's hand
          # (no way of testing unknown values in other's hands so can only be sure of Rocky)
          if target == "Rocky"
            unless play_cache.include? [type: "-", card: card, player: "Rocky"]
              return false if found = hand_test[""].include?( card )
            end
          end
          
          #checks passed so play the 
          play_move(type, card, "Lil", target, hand_test, play_cache)
        else
          # Lil gave a card
          
          # must be in hand
          unless play_cache.include? [type: "-", card: "??", player: "Shady"] or play_cache.include? [type: "-", card: "??", player: "Danny"]
            found = hand_test["Lil"].include? card 
            return false unless found
          end
          play_move(type, card, "Lil", target, hand_test, play_cache)
        end
      else
        # Lil drawn a card
        
        # unless it's in play cache as a draw it can't be in hand
        unless play_cache.include? [type: "+", card: "??", player: nil] or play_cache.include? [type: "+", card: card, player: nil]
          found = hand_test["Lil"].include? card
          return false if found
        end

        # can't be in anyone else's hands including discard
        found = hand_test.collect {|owner, hand| (owner != "Lil" and hand.include?(card)) ? owner : nil}.compact
        return false unless found.empty?
        play_move(type, card, "Lil", target, hand_test, play_cache)
      end
    end
    true
  end

end

CardSharp.run_game *ARGV

