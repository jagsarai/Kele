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
    get_response = self.class.get(
      '/users/me',
      headers:{
        :content_type =>'application/json',
        :authorization => @auth_token
      })

    @user_data = JSON.parse(get_response.body)
  end

end
