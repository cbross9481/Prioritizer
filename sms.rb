require 'rubygems'
require 'twilio-ruby'

class Text
	def initialize(first_name, number, text)
		@name = first_name
		@phone = '1' + number
		@text = text
	end 

	def sms_response
	client = Twilio::REST::Client.new('ACd4c321c238fc83dc39adb763d8449121', '58bfb2bc6b07789da05269da03cb181a')
	client.messages.create(
		from: '+12155838025',
		to: @phone,
		body: "New text for #{@name}: #{@text}"
		)
	end 
end 


#If task = due date > 6 months, text message reminder 3 months, 1 month, 3 weeks, 1 week, 2 days "Hey {person's name}, just a reminder your task {xxx} is approaching"

#Threshold (> 6 months):
# -3 months
# -2 months
# -1 month
# -3 weeks
# -1 week
# -2 days

#Threshold (< 6 months):
# -2 months
# -1 month
# -2 weeks
# -1 week
# -3 days


#Pre Work: Sessions and User Authentication

#step1: store client name and phone number in database (can be done in the user authentication section, pass user credentials as params to store in database)
#step2: retrieve client name, phone number, task title and end date from database (varies betewen user authentication)
#step3: loop through each record in database with date conditions (require date formatting usage and thresholds)
	#if end_date - start_date > 6 months (180 days) 
		# if end_date - today_date == 3 months (90 days)
			#send text message reminder 
		#elsif end_date - today_date == 2 months (60 days)
			#send text message reminder
		#elsif end_date - today_date == 1 months (30 days)
			#send text message reminder
	#elsif end_date - start_date < 6 months (180 days)
		#elsif end_date - today_date == 2 months (60 days)
			#send text message reminder
		#elsif end_date - today_date == 1 months (30 days)
			#send text message reminder
		#elsif end_date - today_date == 1 months (30 days)
			#send text message reminder


#step4: configure text message reminder to clients about task on specified end date
#step5: setup automation to run program each morning at 8am
#step6: create a method for text message and pass variables with each if statement