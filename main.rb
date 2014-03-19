require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

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

get '/' do
  erb :set_name
end

post '/shit' do
  session[:player_name] = params[:player_name] 
  redirect '/game'
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
  session[:player_cards] << session[:deck].pop
  total(session[:player_cards])
  if total(session[:player_cards]) > 21
    redirect '/bust'
  end  
  erb :game
end

post '/game/player/stay' do
  while total(session[:dealer_cards]) < 17
    session[:dealer_cards] << session[:deck].pop    
  end
  if total(session[:dealer_cards]) > 21
    redirect '/bust_message_d'
  end  
  erb :show_cards 
end  

get '/bust_message_d' do
  erb :bust_message_d
end

get '/bust' do
  erb :bust_message 
end






