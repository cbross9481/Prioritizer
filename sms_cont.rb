require 'rubygems'
require 'sinatra'
require_relative 'sms'

get '/' do 
	erb :sms
end 

post '/new' do 
	@name = params[:name]
	@number = params[:number]
	@text = params[:text]

	new_text = Text.new(@name,@number,@text)
	new_text.sms_response
	
	redirect '/'
end 