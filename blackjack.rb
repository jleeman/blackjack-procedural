require 'pry'

# get the player's name, add more validation for this
def get_name
  puts "Welcome to the casino!!! What's your name?"
  name = gets.chomp
end

# set up the deck and shuffle cards, returns a shuffled cards nested array
def init_deck
  deck = []
  suits = ['S', 'C', 'D', 'H']
  values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  # can also use .product for this, but here's logic behind it for future reference
  suits.each do |suit|
    values.each do |value|
      deck << [suit, value]
    end
  end
  # work on own method for shuffling, here's shortcut, remember bang (!) modifies object
  deck.shuffle!
end 

# deal out some cards, can take any number cards as input to deal, returns dealt cards array
def deal_cards (num_cards, deck)
  dealt_cards = []
  num_cards.times {dealt_cards << deck.pop}
  dealt_cards
end

# figure out the total of a hand at any time within a game
def total (hand, current_total)
  # cards are nested arrays format like this: ["H", "9"] and ["S", "9"]
  # can extract out separate array of values only using .map, ignore suits
  string_values = hand.map { |card| card[1] } 

  string_values.each do |value|
    current_total += get_int_value(value, current_total)
  end
  current_total
end

# return correct integer value of a specific card from the string value of a card
# evaluating aces here, maybe not the place to do that?  
def get_int_value (value_string, current_total)
    case value_string
      # reg exp for 2-10, better way to do this? 
      when /[2-9]|[1][0]/ 
        value = value_string.to_i 
      # face cards
      when /[JQK]/
        value = 10
      # aces
      when "A"
        if current_total + 11 <= 21
          value = 11
        else
          value = 1
        end
    end
  value
end

# play as many rounds as player wants, returns the players total
def player_round (player_cards, dealer_cards, player_total, player_name, deck)
  # display the first round of cards, only show dealer's top card
  puts "Welcome, #{player_name}!"
  puts "Dealer has: #{dealer_cards[0]} and #{dealer_cards[1]}"
  puts "You have: #{player_cards[0]} and #{player_cards[1]}"
  player_total = total(player_cards, player_total)
  if blackjack(player_total) != true
    puts "Your total is #{player_total}, would you like to hit or stay? (hit or stay response only allowed)"
    # add validation for this
    hit_stay = gets.chomp.downcase
    while hit_stay == "hit"
      player_cards << deal_cards(1,deck)
      # IMPORTANT: WHY IS EXTRA LAST NECESSARY HERE, EXTRA BLANK ARRAY?
      value_string = player_cards.last.last[1]
      puts "You've been dealt a #{value_string}."
      player_total += get_int_value(value_string, player_total)
      if player_total < 21
        puts "Your total is now #{player_total}, would you like to hit or stay?"
        hit_stay = gets.chomp.downcase
      elsif player_total > 21
        hit_stay = "bust"
      else
        hit_stay = "blackjack"
      end
    end
  end
  player_total
end

# dealer round, no choice but casino logic, returns dealers total
def dealer_round (dealer_cards, dealer_total, deck)
  puts "Now it's the dealer's turn to play..."
  dealer_total = total(dealer_cards, dealer_total)
  while dealer_total <= 17
    puts "Dealing another card..."
    dealer_cards << deal_cards(1,deck)
    value_string = dealer_cards.last.last[1]
    puts "Dealer has been dealt a #{value_string}."
    dealer_total += get_int_value(value_string, dealer_total)
    puts "New dealer total: #{dealer_total}"
  end
  dealer_total
end

# check for blackjack returns boolean
def blackjack (total)
  if total == 21
    return true
  else 
    return false
  end
end

# check for bust returns boolean
def bust (total)
  if total > 21
    return true
  else 
    return false
  end
end

# evaluates and displays who won the game based on totals, returns whether or not to play again
def evaluate (player_total, dealer_total, playing)
  if player_total > 21
    puts "Sorry, you went bust!"
  elsif dealer_total > 21
    puts "Dealer went bust, you won!"
  elsif player_total == 21
    puts "Blackjack!!! You win!"
  elsif dealer_total == 21
    puts "Dealer hit blackjack! You lose."
  elsif player_total > dealer_total
    puts "You've won! Higher score than the dealer."
  elsif player_total < dealer_total
    puts "Sorry, you lost. The dealer's score is higher than yours."
  else player_total == dealer_total
    puts "It's a push! Your hands are tied."
  end
  puts "Would you like to play another game? (yes or no response only)"
  # again need more validation for response here
  playing = gets.chomp.downcase
end

# plays one game, uses recursion to either keep playing or not!
def play_game 
  #initialize variables used for game
  player_name = get_name 
  deck = init_deck
  player_total = 0
  dealer_total = 0
  # deal the initial cards
  player_cards = deal_cards(2, deck)
  dealer_cards = deal_cards(2, deck)
  #player plays round
  player_total = player_round(player_cards, dealer_cards, player_total, player_name, deck)
  puts "Player round finished, player total is #{player_total}."
  # dealer plays round, but only if player didn't hit blackjack or go bust
  if (blackjack(player_total) != true) && (bust(player_total) != true)
    dealer_total = dealer_round(dealer_cards, dealer_total, deck)
    puts "Dealer round finished, dealer total is #{dealer_total} and player total is #{player_total}."
  end
  # evaluate to see who won 
  playing = evaluate(player_total, dealer_total, playing)
  if playing == "yes"
    play_game
  else 
    puts "Bye! Thanks for visiting the casino!"
    exit
  end
end

play_game



