require 'httparty'

class Kele
  include HTTParty

  def initialize(email, password)
    
    post_response  = self.class.post(
      base_api_endpoint("sessions"),
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

  private
  def base_api_endpoint(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end

end
