#!/usr/bin/env jruby

require_relative "../util"
require_relative "../configuration"

=begin
	EXAMPLE BUG BEHAVIOR

	This behavior makes the bugs find their closest neighbor and cluster in the
	middle of the screen. To make your own bug behavior, make a new file
	in the "behavior" folder with a function called "bugStep" that takes two
	arguments: the current bug, and the list of bugs.

	The function must return the new (x, y) coordinates of the bug, and the
	color you want the bug to display with, indicating which action it is 
	performing.
=end

def bugStep(bug, bugs)
	# Some variables we'll need
	new_x = -1
	new_y = -1
	x = bug.x
	y = bug.y
	color = nil

	(closest, closestDistance) = findClosest(x, y, bugs)
	#puts "Got closest distance #{closestDistance}"
	if( closestDistance > BugMaxDistance ) # Go towards friends if lonely
		(new_x, new_y) = stepTowards(x, y, closest.x, closest.y, BugStep)
		x = new_x if( new_x > 0 && new_x < ScreenWidth )
		y = new_y if( new_y > 0 && new_y < ScreenHeight )
		color = Orange
	elsif( closestDistance <= BugMinDistance ) # Move away if overpopulated
		(new_x, new_y) = stepAway(x, y, closest.x, closest.y, BugStep)
		x = new_x if( new_x > 0 && new_x < ScreenWidth )
		y = new_y if( new_y > 0 && new_y < ScreenHeight )
		color = Blue
	else # Move randomly if nothing else is pressing
		(new_x, new_y) = stepRand(x, y, BugStep)
		x = new_x if( new_x > 0 && new_x < ScreenWidth )
		y = new_y if( new_y > 0 && new_y < ScreenHeight )
		color = Purple
	end

	# Try to bounce off screen edges
	if( x != new_x )
		(new_x, _) = stepTowards(x, y, CenterX, CenterY, BugStep * 3.0)
		#puts "Bouncing X #{x} to #{new_x}"
		x = new_x if( new_x > 0 && new_x < ScreenWidth )
	end
	if( y != new_y )
		(_, new_y) = stepTowards(x, y, CenterX, CenterY, BugStep * 3.0)
		#puts "Bouncing X #{y} to #{new_y}"
		y = new_y if( new_y > 0 && new_y < ScreenHeight )
	end

	return [x, y, color]
end
