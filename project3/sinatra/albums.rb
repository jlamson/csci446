#
# Project 3, Joshua Lamson
#

require 'rack'
require 'erb'
require 'sqlite3'
require_relative 'album'

class RollingStonesAlbumApp

	def call(env)
	
		request = Rack::Request.new(env)

		case request.path
		when "/form" then generate_form(request)
		when "/list" then generate_list(request)
		else [404, {"Content-Type" => "text/plain"}, ["OH SHIT!\n"]]
		end
	
	end

	def generate_form(request)
	
		page = get_page("form.html.erb")
		erb = ERB.new(page).result(binding)
		[200, {"Content-Type" => "text/html"}, [erb]]	
	
	end

	def generate_list(request)
	
		order = request.params['order']
		list = get_sorted_list(order)
		rank = request.params['rank']

		page = get_page("list.html.erb")
		erb = ERB.new(page).result(binding)
		[200, {"Content-Type" => "text/html"}, [erb]]
	
	end

	private
	
	def get_page(path)

		file = File.open(path, "rb")
		page = file.read
		file.close
		page
	
	end

	def get_sorted_list(order)

		db = SQLite3::Database.new("albums.sqlite3.db")
		db.results_as_hash = true

		case order
		when "year" then db.execute("SELECT * FROM albums ORDER BY year").map { |row| Album.new(row["rank"], row["title"], row["year"]) }
		when "name" then db.execute("SELECT * FROM albums ORDER BY title").map { |row| Album.new(row["rank"], row["title"], row["year"]) }
		else db.execute("SELECT * FROM albums ORDER BY rank").map { |row| Album.new(row["rank"], row["title"], row["year"]) }
		end

	end

end

Signal.trap('INT') {
  Rack::Handler::WEBrick.shutdown
}
Rack::Handler::WEBrick.run RollingStonesAlbumApp.new, :Port => 8080

