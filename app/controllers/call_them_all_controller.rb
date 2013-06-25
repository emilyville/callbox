require 'rubygems'
require 'twilio-ruby'

#collect numbers by sms
class CallThemAllController < ApplicationController
	def incoming_sms
		#get number from sms
		number = params[:From]
		if (number =~ /[+][0-9]{11}/) == nil
			render :nothing => true and return
		end
		phonenumber = PhoneNumber.new(:number => number)
		phonenumber.save
		response = Twilio::TwiML::Response.new do |r|
  			r.Sms 'hello there', :to => number, :from => '+14155086687'
  		end
  		render :xml => response.text
	end

	def call 
		#get all phone numbers
		phone_numbers = PhoneNumber.all
		#call phone numbers
		client = Twilio::REST::Client.new(ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"])
		client.account.queues.create(:friendly_name => "newqueue")
		phone_numbers.each do |number|
			client.account.calls.create(
				:From => '+14155086687',
				:To => number.number,
				:Url => 'http://twimlets.com/holdmusic?Bucket=com.twilio.music.rock'
				)
		end
		render :nothing => true
	end

	def queue
		client = Twilio::REST::Client.new(ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"])
		newqueue = client.account.queues.list.first
		if (newqueue.current_size > 0)
			#connect to someone in queue
		else
			#add to qeue
		end
	end
end
