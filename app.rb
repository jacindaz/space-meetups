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

get '/:id' do
  meetup_id = params[:id]
  @meetup = Meetup.find(meetup_id)
  erb :show
end

get '/meetup/new' do
  erb :create
end

post '/meetup/new' do
  @create_meetup = Meetup.create(name: params[:meetup_name], location: params[:location], description: params[:description])
  redirect "/#{@create_meetup.id}"
end


get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
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
