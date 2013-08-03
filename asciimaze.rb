class ASCIIMazeDisplay
	attr_accessor :loc
	def initialize(base, height, mazeWalls, pathStack = [])
		@base, @height, @mazeWalls, @pathStack = base, height, mazeWalls, pathStack
		@gridBase = 2*@base+1
		@gridHeight = 2*@height+1
	end
	def x
        @loc % @gridBase
    end
    def y
        @loc / @gridBase
    end
	def grid
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
						gridStr += (@pathStack.member? cellLoc) ? '*' : ' '
						cellLoc += 1
					end
				end
			end
			gridStr += "\n"
		end
		gridStr
	end	
	def display
		print grid
	end
end