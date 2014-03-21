require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

helpers do
  def total(cards)
    arr = cards.map {|x| x[1]}
    session[:total] = 0
  
    arr.each do |x|
      if x == 'Ace'
        session[:total] += 11
      elsif x.to_i == 0  
        session[:total] += 10
      else
        session[:total] += x.to_i
      end    
    end
  
    arr.select {|x| x == 'Ace' }.count.times do
      session[:total] -= 10 if session[:total] > 21
    end
  
    session[:total]
  end
  
  def card_image(card)
   
    suit = case card[0]
      when 'C' then 'clubs'  
      when 'D' then 'diamonds'
      when 'H' then 'hearts'
      when 'S' then 'spades' 
    end
      
    value = card[1]
    
    if['A', 'K', 'Q', 'J'].include?(value)
      value = case card[1]
        when 'A' then 'ace'
        when 'K' then 'king'
        when 'Q' then 'queen'
        when 'J' then 'jack'           
      end        
    end          
              
    "<img src='/images/cards/#{suit}_#{value}.jpg' class='card_space'>"
  end
  
  def who_wins?
    if @dealer_button == false
      if total(session[:dealer_cards]) > 21
        @success = "Awesome, dealer went bust. You win!"
        @buttons = false
        @play_again = true
      elsif total(session[:dealer_cards]) > total(session[:player_cards])
        @error = "Sorry, it looks like you lost. Dealer total is #{total(session[:dealer_cards])}. Your total is #{total(session[:player_cards])} "
        @buttons = false
        @play_again = true
      elsif total(session[:player_cards]) > total(session[:dealer_cards])
        @success = "Awesome, you win! Dealer total is #{total(session[:dealer_cards])}. Your total is #{total(session[:player_cards])}!"
        @buttons = false
        @play_again = true   
      else
        @success = "A tie"
        @buttons = false 
        @play_again = true 
      end  
    end
  end
end

before do
  @buttons = true
  @nohit = true
  @play_again = false
  @dealer_button = false
end  

get '/' do
  erb :set_name
end

post '/set_name' do
  if params[:player_name].empty?
    @error = "Name field is requred"  
    halt erb(:set_name)
  end  
  
  session[:player_name] = params[:player_name] 
 
  erb :click_to_cont
end

get '/game' do
  suits = ['H', 'D', 'C', 'S']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
  session[:deck] = suits.product(values).shuffle!
  session[:player_cards] = []
  session[:dealer_cards] = []
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  erb :game 
  
end

post '/game/player/hit' do
  @nohit = false
  session[:player_cards] << session[:deck].pop
  total(session[:player_cards])
  if total(session[:player_cards]) > 21
    @error = "Yikes! You went bust."
    @buttons = false
    @play_again = true
  end
  if total(session[:player_cards]) == 21 
    #@success = "Blackjack!"
    @buttons = false
    @play_again = false 
  end  
  erb :game
end

get '/game/player/stay' do
  erb :show_cards
end

post '/game/player/stay' do 
  @buttons = false
  @nohit = false
  
  if total(session[:dealer_cards]) < 17  
    @dealer_button = true  
  end
  
  who_wins?
      
  erb :show_cards
end  

post '/game/dealer/hit' do
  @buttons = false
  @nohit = false
  @dealer_button = true
  
  if total(session[:dealer_cards]) < 17  
    @dealer_button = true  
  end
  
  
  session[:dealer_cards] << session[:deck].pop
  total(session[:dealer_cards])
  
  if total(session[:dealer_cards]) >= 17
    @dealer_button = false  
  end

  who_wins?
     
  erb :show_cards
end  

get '/show_cards' do
  erb :show_cards
end






