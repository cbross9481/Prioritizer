require 'sqlite3'
require_relative 'db_setup'
require 'bcrypt'
require './helper_method'

class User
include Helper
attr_reader :password

	def initialize(params = {})
		@username = params.fetch(:username, "test")
		@password = params.fetch(:password, "test")
		@phone = params.fetch(:phone, "9738565256")
	end 


	# def password
	# 	p @password ||= BCrypt::Password.new(password_hash)
	# end 

	def password=(new_password)
		@password = BCrypt::Password.create(new_password)
		@db_password = BCrypt::Password.new(@password)
	end 

	def insert_user
		db = SQLite3::Database.open("helper_database")
		db_results_as_hash = true
		db.execute("INSERT INTO users (username, password, phone) VALUES (?,?,?)", [@username, @db_password, @phone])
	end 

	def self.find(user)
    db = SQLite3::Database.open("helper_database")
    db.results_as_hash = true
    db.execute("SELECT * FROM users WHERE username = '#{user}'")
  end 

  def authenticate
  	db = SQLite3::Database.open("helper_database")
    db.results_as_hash = true
     password = db.execute("SELECT password FROM users WHERE username = '#{@username}'")
     password = password[0]["password"]
	  BCrypt::Password.new(password) == @password
  end 

  def id
  	db = SQLite3::Database.open("helper_database")
    db.results_as_hash = true
     id = db.execute("SELECT id FROM users WHERE username = '#{@username}'")
     id = id[0]["id"]
     return id
  end 

end 