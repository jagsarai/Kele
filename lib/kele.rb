require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

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
    @user_email = post_response["user"]["email"]
    @user_enrollment_id = post_response["user"]["id"]
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

  def get_messages(thread_page = nil)

    if thread_page
      get_message = self.class.get(
        "/message_threads",
        query:{
          :page => thread_page
        },
        headers:{
          :content_type => 'application/json',
          :authorization => @auth_token,
        })
    else
      get_message = self.class.get(
        "/message_threads",
        headers:{
          :content_type => 'application/json',
          :authorization => @auth_token
        })
    end

    @messages = JSON.parse(get_message.body)

    if @messages["items"] == []
      print "There are no messages on this page, please try a previous page."
    else
      @messages
    end

  end


  def create_message(sender=@user_email, recipient_id, token, subject, message)
    create_message = self.class.post(
      "/messages",
      body: {
        :sender => sender,
        :recipient_id => recipient_id,
        :subject => subject,
        :token => token,
        :stripped_text => message
      },
      headers:{
        :content_type => 'application/json',
        :authorization => @auth_token
      })

    p create_message
    puts create_message.body
  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment=nil, enrollment_id)
    submission = self.class.post(
    "/checkpoint_submissions",
    body: {
      :assignment_branch => assignment_branch,
      :assignment_commit_link => assignment_commit_link,
      :checkpoint_id => checkpoint_id,
      :comment => comment,
      :enrollment_id => enrollment_id
    },
    headers: {
      :content_type => 'application/json',
      :authorization => @auth_token
    })

    p submission
    puts submission.body
  end

end
