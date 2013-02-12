class Album
	
	attr_accessor :rank
	attr_accessor :name
	attr_accessor :year

	def initialize(rank, name, year)
		@rank, @name, @year = rank, name, year
	end

end