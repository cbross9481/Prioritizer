
configure do
 enable :sessions
 set :session_secret, ENV['SESSION_SECRET'] || 'not available'	
end