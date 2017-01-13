require 'sinatra'

get '/test' do
  "1+1=#{1+1}"
end
