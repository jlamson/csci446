require 'sinatra'
require 'data_mapper'
require_relative 'album'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/albums.sqlite3.db")

set :port, 8080

get "/form" do
	erb :form
end

post "/list" do
	@sort_order, @rank = params[:order], params[:rank]
	@albums = Album.all(:order => params[:order].intern.asc)
	erb :list
end