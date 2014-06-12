require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  @meetups = Meetup.order('name ASC').all
  #@meetups = Meetup.find(:all, :order => "name DESC")
  #@meetups_alpha = @meetups.sort! { |a,b| a.name <=> b.name }
  erb :index
end

post '/:id' do
  @meetup_id = params[:id]
  @current_meetup = Meetup.find(@meetup_id)
  @add_member = Member.create(meetup_id: @meetup_id, user_id: current_user.id)

  flash[:notice] = "You have now joined #{@current_meetup.name}!"
  redirect "/#{@meetup_id}"
end


get '/:id' do
  meetup_id = params[:id]
  @meetup = Meetup.find(meetup_id)

  @user_ids = []
  (Member.all).each do |one_member|
    if one_member.meetup_id.to_s == meetup_id
      @user_ids << one_member.user_id.to_s
    end
  end

  @members = []
  @user_ids.each do |id|
    (User.all).each do |user|
      if id == user.id.to_s
        @members << user
      end
    end
  end

  erb :show
end

post '/leave_meetup/:id' do
  @meetup_id = params[:id]
  @current_meetup = Meetup.find(@meetup_id)
  @remove_member = Member.find_by_user_id_and_meetup_id(current_user.id, @meetup_id)
  Member.destroy(@remove_member.id)

  #@remove_member = Member.where(meetup_id: @meetup_id).destroy(meetup_id: @meetup_id, user_id: current_user.id)

  flash[:notice] = "Sorry to see you go! You have now left #{@current_meetup.name}."
  redirect "/#{@meetup_id}"
end

get '/meetup/new' do
  erb :create
end

post '/meetup/new' do
  @create_meetup = Meetup.create(name: params[:meetup_name], location: params[:location],
                                  description: params[:description])
  redirect "/#{@create_meetup.id}"
end


get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  #member = Member.create(user_id: , meetup_id: )
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
