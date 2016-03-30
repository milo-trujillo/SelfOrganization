#!/usr/bin/env jruby

require_relative 'configuration'
require_relative 'util'
require_relative Behavior

=begin
	MAIN FILE

	This file is used to describe how the bugs behave, and do initialization
	for the simulation. Users should only need to change the "step" method
	inside the Bug class to get different behavior. You may also want to
	tweak constants in "configuration.rb" to change simulation parameters.

	The Ruby-Processing-Java mesh is a little clunky, and the result is that
	any processing functions (like drawing, or setting screen dimensions)
	MUST BE DONE IN THIS FILE. Other stuff, like global configuration or
	utility functions, have been split into their own files.
=end

=begin
	BUG LOGIC

	This is where the complexity is. Each bug needs to figure out its movement
	purely based on the positions of its neighbors.
=end
class Bug
	attr_reader :x
	attr_reader :y

	# ALL EMERGENT BEHAVIOR LOGIC OCCURS IN THIS METHOD
	def step()
		(@x, @y, @lastAction) = bugStep(self, @bugs)
	end

	def initialize(bugs)
		@bugs = bugs
		@x = rand(ScreenWidth).to_f
		@y = rand(ScreenHeight).to_f
		@lastAction = "towards"
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
