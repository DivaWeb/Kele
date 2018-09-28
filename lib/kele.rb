require 'httparty'
require 'json'

class Kele
  include HTTParty

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
    @mentor_id = 2299042
    response = self.class.get('/mentors/2299042/sturdent_availability', headers: { "authroization" => @user_auth_token })
    JSON.parse(response.body)
  end

end
