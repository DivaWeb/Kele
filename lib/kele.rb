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

  def get_messages(page = 0)
    if page > 0
      meassage_url = "/message_threads?page=#{page}"
    else
      message_url = "/message_threads"
    end
    response = self.class.get(message_url, headers: { "authorization" => @user_auth_token }, body: {
        sender: sender,
        reciepient_id: recipient_id,
        token: token,
        subject: subject,
        stripped_text: stripped_text
      })
      response.success? puts "You're message has been sent, yippe!"
    end
end
