require 'rubygems'
require 'sinatra'
require 'sqlite3'
require_relative 'app'
require_relative 'User'
require_relative 'helper_method'
require 'date'
require 'twilio-ruby'

configure do
  enable :sessions
  set :session_secret, "secret"
end

enable :sessions


get '/inspect' do 
	session.inspect
end 
 
get '/' do 
 redirect '/login'
end

get '/login' do 
	# session[:login_count] = 1
 erb :login
end 

post '/login' do 
	@user = User.new(username: params[:username], password: params[:password])
	if @user.authenticate()
		session[:user_id] = params[:username]
		redirect '/index'
	else 
		erb :login
	end 
end 

get '/new_user' do 
	erb :new_user
end 

post '/new_user' do
	if @password == @password_confirm
		new_user = User.new(username: params[:username], phone: params[:phone])
		new_user.password = params[:password]
		new_user.insert_user
		new_user.add_table(params[:username])
		session[:user_id] = params[:username]
		redirect '/index'
	else
		redirect '/new_user'
	end 
end 

get '/index' do 
 p session[:user_id]
 erb :index
end 
		 
get '/new' do
	p session[:user_id]
 erb :new
end 

post '/new' do 
frequency = params[:frequency]

if frequency == "weekly"
	weekly = 'yes'
elsif frequency == "monthly"
	monthly = 'yes'
elsif frequency == "yearly"
	yearly = 'yes'
end 
@task = Task.new(title: params[:title], satisfaction: params[:satisfaction], procrastinate: params[:procrastinate], people: params[:people], travel: params[:travel], strength: params[:strength], socialize: params[:socialize], week_repeat: weekly, month_repeat: monthly, year_repeat: yearly, end_date: params[:end_date],description: params[:description])
 @task.priority_calculation
 @task.insert_task(session[:user_id])
 redirect '/index'
end 

get '/dashboard' do
	p session[:user_id]
	Task.expired_tasks(session[:user_id])
	@todays_date = Date.today.strftime('%Y-%m-%d')
	@priority_box = Task.list_priorities(session[:user_id])
	@date_box = Task.list_dates
	@month_box = Task.list_months
	@year_box = Task.list_year
	@week_box = Task.list_week

	erb :show
end 

get '/task/:id' do 
	@task = Task.find(params["id"], session[:user_id]) 	
	@task = @task[0]			
	erb :show_2 
end 

delete '/task/:id' do 
	@task = Task.find(params[:id],session[:user_id]) 
	p @task = @task[0]
	p @task_id = @task["id"]
	Task.delete(session[:user_id],@task_id)
	
	redirect '/index'
end

put '/task/:id' do 
	frequency = params[:frequency]

	if frequency == "weekly"
		weekly = 'yes'
	elsif frequency == "monthly"
		monthly = 'yes'
	elsif frequency == "yearly"
		yearly = 'yes'
	end 

	Task.update(session[:user_id],params[:id],params[:title],params[:description],params[:satisfaction],params[:people],params[:travel],params[:strength],params[:procrastinate],params[:socialize],weekly,monthly,yearly,params[:end_date])
	id = params[:id]

	redirect "/task/#{id}"
end 

get '/task/:id/edit' do
	@task = Task.find(params[:id],session[:user_id]) 
	@task = @task[0]
	erb :edit
end 

get '/logout' do 
	session.delete(:user_id)
	redirect '/login'
end
# post '/receive_sms' do
# 	content_type 'text/xml'

# 	response = Twilio::TwiML::Response.new do |r|
# 		r.Message 'Hey thanks for messaging me!'
# 	end 

# 	response.to_xml
# end 