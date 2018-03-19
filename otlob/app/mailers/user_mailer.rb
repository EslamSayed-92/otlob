class UserMailer < ApplicationMailer
default from: 'YallaNotlob@gmail.com'
 
  def welcome(user)
    @user = user
    @url  = 'http://localhost:3000/login'
    p @user.email
    mail(to: @user.email, subject: 'Welcome to My Awesome Site', template_path: '/views/user_mailer', template_name: 'welcome')
  end
end
