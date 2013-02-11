#
# Project 2, Joshua Lamson
#
require 'rack'
require 'erb'

class HelloWorld
	def call(env)
		request = Rack::Request.new(env)

		case request.path
		when "/form" then generate_form(request)
		when "/list" then generate_list(request)
		else [404, {"Content-Type" => "text/plain"}, ["OH SHIT!\n"]]
		end
	end

	def generate_form(request)
		page = get_page("form.html")
		erb = ERB.new(page).result(binding)
		[200, {"Content-Type" => "text/html"}, [erb]]	
	end

	def generate_list(request)
		order = request.params['order']
		order ||= "rank"
		list = get_sorted_list(order)

		rank = request.params['rank']

		page = get_page("list.html")
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
		file = File.open("top_100_albums.txt", "r")
		list = file.readlines
		
		rank = 0
		list.map! do |line| 
			rank += 1
			Album.new(rank, line.chomp.split(", ")[0], line.chomp.split(", ")[1])
		end

		case order
		when "year" then list.sort { |a, b| a.year <=> b.year }
		when "name" then list.sort { |a, b| a.name <=> b.name }
		else list
		end

	end

	class Album
		
		attr_accessor :rank
		attr_accessor :year
		attr_accessor :name

		def initialize(rank, year, name)
			@rank, @year, @name = rank, year, name
		end

	end

end

Signal.trap('INT') {
  Rack::Handler::WEBrick.shutdown
}
Rack::Handler::WEBrick.run HelloWorld.new, :Port => 8080