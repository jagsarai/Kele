require 'httparty'
require 'json'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response  = self.class.post(
      '/sessions',
      body: {
        :email => email,
        :password => password
      },
      header:{
        :content_type => 'application/json'
        })
    raise "Invalid Email or Password. Try Again." if post_response.code == 404

    @auth_token = post_response["auth_token"]
  end

  def get_me
    get_user = self.class.get(
      '/users/me',
      headers:{
        :content_type =>'application/json',
        :authorization => @auth_token
      })

    @user_data = JSON.parse(get_user.body)
  end

  def get_mentor_availability(mentor_id = nil)

    if mentor_id == nil
      my_mentor_id = @user_data["current_enrollment"]["mentor_id"]
    else
      my_mentor_id = mentor_id
    end

    get_mentor = self.class.get(
      "/mentors/#{my_mentor_id}/student_availability",
      headers:{
        :content_type => 'application/json',
        :authorization => @auth_token
      })

    @mentor_availability = JSON.parse(get_mentor.body)

  end

end
