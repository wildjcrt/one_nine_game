require 'sinatra'
require './one_nine_game'

get '/' do
  @question = OneNine.new
  erb :index
end