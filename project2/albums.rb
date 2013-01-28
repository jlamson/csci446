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
		page = get_page("list.html")
		order = "rank"
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

end

Signal.trap('INT') {
  Rack::Handler::WEBrick.shutdown
}
Rack::Handler::WEBrick.run HelloWorld.new, :Port => 8080