#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db

  @db = SQLite3::Database.new 'Leprosorium.db'
  @db_results_as_hash = true #Results will be returned as HASH and not as ARRAY

end

before  do
   
    init_db 

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end 

get '/new' do 

	erb :new
end

post '/new'do

   @content = params[:content]

   erb "Your message: #{@content}, <br/>POST submitted, thank you!"

end