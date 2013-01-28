require 'rack'

class HelloWorld
	def call(env)
		request = Rack::Request.new(env)

		case request.path
		when "/form" then generate_form()
		when "/list" then generate_list()
		else [404, {"Content-Type" => "text/plain"}, ["OH SHIT!\n"]]
		end
	end

	def generate_form()
		[200, {"Content-Type" => "text/plain"}, ["form"]]	
	end

	def generate_list()
		[200, {"Content-Type" => "text/plain"}, ["list"]]
	end
end

Signal.trap('INT') {
  Rack::Handler::WEBrick.shutdown
}
Rack::Handler::WEBrick.run HelloWorld.new, :Port => 8080