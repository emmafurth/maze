class Maze
    attr_accessor :mazeWalls, :cell
    def initialize(base, height)
        @base, @height = base, height
        @mazeWalls = Array.new(@base*(@height-1)+(@base-1)*@height, true)
        createMaze
        displayMaze
        runMaze
    end
    
    def createMaze
    	visitedCells = 1
    	totalCells = @base*@height
    	cellStack = Array.new
        @cell = MazeCell.new rand(totalCells), @base, @height
        while visitedCells < totalCells
        	if intactNeighbors.length > 0
        		nextDir = intactNeighbors.sample
        		knockDownWall nextDir
        		cellStack.push @cell.loc
        		nextCell = @cell.neighbor nextDir 
        		@cell = nextCell
        		visitedCells += 1
        	else
        		@cell.loc = cellStack.pop
        	end
        end
    end    		
 
    def allWallsIntact( cell = @cell )
    	check = true
    	cell.dirs.each do |dir|
    		if !mazeWalls[cell.wallLoc dir]
    			check = false
    		end
    	end
    	check
    end
  		
    def intactNeighbors( cell = @cell )
    	intNeighbors = Array.new
    	cell.neighbors.each do |dir, neighbor|
    		if allWallsIntact neighbor
    			intNeighbors << dir
    		end
    	end
    	intNeighbors
    end
    
    def knockDownWall ( cell = @cell, dir )
    	@mazeWalls[cell.wallLoc dir] = false
    end
=begin
    def displayMaze
    	disp = ASCIIMazeDisplay.new @base, @height, @mazeWalls
    	disp.display
    end
    def runMaze
    	runner = MazeRunner.new @base, @height, @mazeWalls
    end
=end
end

class MazeCell
	attr_accessor :loc
	
	def initialize(loc, base, height)
		@loc, @base, @height = loc, base, height
		@visited = false
	end
	def x
        @loc % @base
    end
    def y
        @loc / @base
    end
    
    def dirs
    	if (x == 0)
    		if (y == 0)
                [:south, :east]
            elsif (y == @height-1)
                [:north, :east]
            else
            	[:north, :south, :east]
            end
        elsif (x == @base-1)
        	if (y == 0)
                [:south, :west]
            elsif (y == @height-1)
                [:north, :west]
            else
                [:north, :south, :west]
            end
        else
            if (y == 0)
                [:south, :east, :west]
            elsif (y == @height-1)
                [:north, :east, :west]
            else
            	[:north, :south, :east, :west]
            end
		end
	end
	
	def neighbor( dir )
		neighborLoc = case dir
			when :north
				y>0 ? @loc-@base : -1
			when :south
				y<(@height-1) ? @loc+@base : -1
			when :west
				x>0 ? @loc-1 : -1
			when :east
				x<(@base-1) ? @loc+1 : -1
			else
				-1
		end
		raise TypeError, "Invalid direction #{dir} at location #{@loc}" if neighborLoc == -1
		MazeCell.new neighborLoc, @base, @height
	end
	
	def neighbors
		n = {}
		dirs.each do |dir|
			n[dir] = neighbor dir
		end
		n
	end
	
	def wallLoc ( dir )
		wall = case dir
			when :north
				y>0 ? y*(@base-1)+(y-1)*@base+x : -1
			when :south
				y<(@height-1) ? (y+1)*(@base-1)+y*@base+x  : -1
			when :west
				x>0 ? y*(2*@base-1)+x-1 : -1
			when :east
				x<(@base-1) ? y*(2*@base-1)+x : -1
				
			else
				-1
		end
		raise TypeError, "Invalid direction #{dir} at location #{@loc}" if wall == -1
		wall
	end
end