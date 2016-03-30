#!/usr/bin/env jruby

require_relative 'configuration'
require_relative 'util'
require_relative Behavior

=begin
	MAIN FILE

	This file is used for initialization and defining what attributes each
	bug has. Unless you want to add more variables to the bug and change
	how it calls the "bugStep" function you probably want to leave this file
	alone.

	The Ruby-Processing-Java mesh is a little clunky, and the result is that
	any processing functions (like drawing, or setting screen dimensions)
	MUST BE DONE IN THIS FILE. Other stuff, like global configuration or
	utility functions, or individual bug behaviors, have been split into 
	their own files.
=end

=begin
	BUG CLASS

	Defines each bug, its remotely-viewable variables, and how it initializes
	and draws itself. Bug behavior is defined in another file.
=end
class Bug
	attr_reader :x
	attr_reader :y
	attr_reader :direction

	# ALL EMERGENT BEHAVIOR LOGIC OCCURS IN THIS METHOD
	def step()
		(oldX, oldY) = [@x, @y]
		(@x, @y, @lastAction) = bugStep(self, @bugs)
		direction = getDirection(oldX, oldY, @x, @y)
	end

	def initialize(bugs)
		@bugs = bugs
		@x = rand(ScreenWidth).to_f
		@y = rand(ScreenHeight).to_f
		@lastAction = "towards"
		# Start point in a random direction
		(rX, rY) = stepRand(@x, @y, BugStep)
		direction = getDirection(@x, @y, rX, rY)
	end

	def draw
		fill(0xea, 0xb9, 0x0d) if( @lastAction == "towards" ) # Orange
		fill(0x0d, 0x6b, 0xea) if( @lastAction == "away" )    # Blue
		fill(0xbe, 0x0d, 0xea) if( @lastAction == "rand" )    # Purple
		ellipse @x, @y, BugWidth, BugHeight
	end
end

=begin
	BUG MANAGEMENT INTERFACE

	This bit manages all of our bugs! It's used to issue orders to all our bugs
	at once like "Draw yourselves" and "move!"
=end
module Bugs
	$bugs = []

	# We pass the list of bugs to each bug so that they can find their neighbors
	def self.create(numBugs)
		( 0 .. numBugs - 1 ).each do
			$bugs.push(Bug.new($bugs)) 
		end
	end

	# Makes every bug draw itself
	def self.draw
		for bug in $bugs
			bug.draw
		end
	end

	# Makes every bug move
	def self.run
		for bug in $bugs
			bug.step
		end
	end
end

=begin
	PROCESSING WRAPPER

	Everything after this point is part of the Processing loop.
	It basically just says how to start the simulation, and what actions to
	run every frame.
=end
def setup
	sketch_title Title
end

def draw
	background(BackgroundColor)
	Bugs.draw
	Bugs.run
end

# size, full_screen, pixel_density and smooth should all be moved to settings
def settings
	size ScreenWidth, ScreenHeight
	Bugs.create(NumBugs)
end
