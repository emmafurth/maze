class MazeRunner
	attr_accessor :mazeWalls, :mazeCells, :cell
	def initialize(base, height, mazeWalls)
		@base, @height, @mazeWalls = base, height, mazeWalls
		@mazeCells = Array.new @base*@height, false
		runMaze
	end
	
	def runMaze
		@cell = MazeCell.new 0, @base, @height
		cellStack = Array.new
		while @cell.loc < @base*@height-1
			if unvisitedNeighbors.length > 0
				nextCell = unvisitedNeighbors.sample
				cellStack.push @cell.loc
				@mazeCells[@cell.loc] = true
				@cell = nextCell
			else
				@cell.loc = cellStack.pop
			end
			displaySolvedMaze [@cell.loc]
		end
		cellStack.push @base*@height-1	
		displaySolvedMaze cellStack
	end
	def visited (cell = @cell )
		@mazeCells[cell.loc]
	end
	def intactWall ( cell = @cell, dir )
		@mazeWalls[cell.wallLoc dir]
	end
	def availableNeighbors ( cell = @cell )
		n = {}
		cell.neighbors.each do |dir, neighbor|
			if !intactWall dir
				n[dir] = neighbor
			end
		end
		n
	end
	
	def unvisitedNeighbors ( cell = @cell )
		n = Array.new
		cell.neighbors.each do |dir, neighbor|
			if !intactWall dir and !visited neighbor
				n.push neighbor
			end
		end
		n
	end
	
	def displaySolvedMaze pathStack
		disp = ASCIIMazeDisplay.new @base, @height, @mazeWalls, pathStack
		disp.display
	end
end