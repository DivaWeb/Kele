require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)

    @email = email
    @password = password

    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: { "email": @email, "password": @password})
    @auth_token = response[ "auth_token" ]

    if @auth_token.nil? || response.nil?
      raise Error, "Unable to access user. Please try again with valid user information."
    end
  end

  def get_me
    response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorizatio" => @user_auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)

    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authroization" => @user_auth_token })
    JSON.parse(response.body)
  end

  def get_messages(page_number=0)
    if page_number == 0
      url = "/message_threads"
      response = self.class.get(url, headers: { "authorization" => @auth_token })
    else
      url = "/message_threads?page=#{page_number}"
      response = self.class.get(url, headers: { "authorization" => @auth_token }, body: { page: page_number })
    end

    if response.success?
      JSON.parse(response.body)
    else
      raise response.response
    end
  end

  def create_message(subject, text, recipient=@mentor_id)
    response = self.class.post("/messages", headers: { "authorization" => @auth_token }, body: {
      "sender" => @email,
      "recipient_id" => recipient,
      "subject" => subject,
      "stripped-text" => text
    }) 

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions", headers: { "authorization": @auth_token },
      body: {
        "checkpoint_id": checkpoint_id,
        "assignment_branch": assignment_branch,
        "assignment_commit_link": assignment_commit_link,
        "comment": comment,
        "enrollment_id": enrollment_id
        })
  end
end
