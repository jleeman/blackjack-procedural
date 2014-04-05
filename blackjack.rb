# get the player's name, add more validation for this
def name
  puts "Welcome to the casino!!! What's your name?"
  name = gets.chomp
end

# set up the deck and shuffle cards, returns a shuffled cards nested array
def init_deck
  deck = []
  suits = ['S', 'C', 'D', 'H']
  values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  # can also use .product for this, but here's logic behind it as example
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
def total (cards, current_total)
  # cards are nested arrays format like this: ["H", "9"] and ["S", "9"]
  # can extract out separate array of values only using .map, ignore suits
  card_values = cards.map { |card| card[1] } 

  card_values.each do |value|
    case value
    # reg exp for 2-10, better way to do this? 
    when /[2-9]|[1][0]/ 
      current_total += value.to_i
    # face cards
    when /[JQK]/
      current_total += 10
    # aces
    when "A"
      if current_total + 11 <= 21
        current_total += 11
      else
        current_total += 1
      end
    end
  end
  current_total
end

player_name = name 
deck = init_deck

# deal the cards
player_cards = deal_cards(2,deck)
dealer_cards = deal_cards(2,deck)

# display the first round of cards
puts "Dealer has: #{dealer_cards[1]}"
puts "You have: #{player_cards[0]} and #{player_cards[1]}"

# initialize total variables
player_total = 0
dealer_total = 0

# calculate totals
player_total = total(player_cards, player_total)
dealer_total = total(dealer_cards, dealer_total)

# next round
puts "The dealer total is: #{dealer_total}"
puts "#{player_name}, your total is: #{player_total}"
puts "Do you want to hit or stay?"
hit_stay = gets.chomp
if hit_stay == "hit"
  deal_card(player_cards, deck)
  total(player_cards, player_total)
  puts "#{player_name}, now your total is: #{player_total}"
else
  puts "player chose to stay or invalid input"
end



