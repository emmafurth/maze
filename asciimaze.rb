require './maze'
require './mazerunner'

class ASCIIMaze < Maze 
	def initialize(base, height, start = 0, finish = -1)
		super base, height, start, finish
		#@base, @height, @mazeWalls, @pathStack = base, height, mazeWalls, pathStack
		@gridBase = 2*@base+1
		@gridHeight = 2*@height+1
		getSolution
	end
	def x
        @loc % @gridBase
    end
    def y
        @loc / @gridBase
    end
	def grid withSoln = false
		gridStr = "";
		wallLoc = 0
		cellLoc = 0
		@gridHeight.times do |j|
			@gridBase.times do |i|
				if (j == 0 || j == @gridHeight-1)
					if (i % 2 == 0)
						gridStr += '+'
					else
						gridStr += '-'
					end
				elsif (j % 2 == 0)
					if (i % 2 == 0)
						gridStr += '+'
					else
						gridStr += @mazeWalls[wallLoc] ? '-' : ' '
						wallLoc += 1
					end
				else
					if (i == 0 || i == @gridBase-1)
						gridStr += '|'
					elsif (i % 2 == 0)
						gridStr += @mazeWalls[wallLoc] ? '|' : ' '
						wallLoc += 1
					else
						gridStr += (withSoln and @solutionStack.member? cellLoc) ? '*' : ' '
						cellLoc += 1
					end
				end
			end
			gridStr += "\n"
		end
		gridStr
	end	
	def display withSoln = false
		print grid withSoln
	end
	
	
	
	class << self
		def run
			puts "Welcome to Emma's ASCII Maze!"
			print "Type command: "
			args = gets.chomp.split " "
			command = args.shift
			while command != "quit"
				case command
					when "help"
						print help
					when "new"
						case args.length 
							when 2
								base = args[0].to_i
								height = args[1].to_i
								maze = self.new base, height
								maze.display
							when 4
								base = args[0].to_i
								height = args[1].to_i
								start = args[2].to_i
								finish = args[4].to_i
								maze = self.new base, height
								maze.display
							else
								puts "Improper number of arguments (must be 2 or 4)"
						end
					when "solve"
						if maze.nil?
							puts "You must create a maze first"
						else
							if args.length == 2
								maze.start = args[0].to_i
								maze.finish = args[1].to_i
								maze.getSolution
							end
							maze.display true
						end
					when "display"
						if maze.nil?
							puts "You must create a maze first"
						else
							maze.display
						end
					else 
						puts "I don't understand"
				end
				print "Type command: "
				args = gets.chomp.split " "
				command = args.shift
			end
			puts "Goodbye!"
		end
		
		private
		def help
			<<-eos
	display
		displays maze, sans solution
	
	new <base> <height> [<start> <finish>]
		creates new maze
		
		base: width of maze
		height: height of maze
		start (optional): start location of maze
		finish (optional): finish location of maze
	
	quit
		ends program
	
	solve [<start> <finish>]
		displays maze plus solution
		
		start (optional): start location of maze
		finish (optional): finish location of maze
			eos
		end 
				
				 
	end
	
end

ASCIIMaze.run