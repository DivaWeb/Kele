require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response = self.class.post('/sessions', body: {
      email: email,
      password: password
      })
      @user_auth_token = post_response['auth_token']
      raise "Invalid Email or Password. Try again." if @user_auth_token.nil?
  end

  def get_me
    response = self.class.get('/user/me', headers: { "authorizatio" => @user_auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)

    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authroization" => @user_auth_token })
    JSON.parse(response.body)
  end

  def get_messages(page = nil) # optional method parameter
    if page != nil # return specified page
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization": @auth_token }, body: { "page": page })
    else # return first page
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization": @auth_token })
    end
    JSON.parse(response.body)
  end
   def create_message(sender, recipient_id, subject, stripped_text)
    response = self.class.post("https://www.bloc.io/api/v1/messages", headers: { "authorization": @auth_token },
      body: {
        "sender": sender,
        "recipient_id": recipient_id,
        "subject": subject,
        "stripped-text": stripped_text
      })
  end
end
