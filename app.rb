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
   
    init_db # start function with connecting to our DB

end

configure do 
    
    init_db 
    @db.execute 'CREATE TABLE IF NOT EXISTS "Posts"
               (
                
	                Id INTEGER PRIMARY KEY AUTOINCREMENT,
	                Created_date DATE,
	     			content TEXT

     			)'

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end 

get '/new' do 

	erb :new
end

post '/new'do

   @content = params[:content]
   if @content.strip.size == 0

	  @error = "Post Message can't be empty!"
      erb :new
   
   else

      erb "Your message: #{@content}, <br/>POST submitted, thank you!"

   end

end