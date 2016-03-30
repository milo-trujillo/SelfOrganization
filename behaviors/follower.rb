#!/usr/bin/env jruby

require_relative "../util"
require_relative "../configuration"

=begin
	EXAMPLE BUG BEHAVIOR

	Followers will follow their closest neighbor unless they get 
	too close or far. They will seek out or run from bugs if needed.
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
	else # Go same way as our friend otherwise
		(new_x, new_y) = stepDirection(x, y, closest.direction, BugStep)
		x = new_x if( new_x > 0 && new_x < ScreenWidth )
		y = new_y if( new_y > 0 && new_y < ScreenHeight )
		color = Purple
	end

	# Try to bounce off screen edges
	if( x != new_x )
		(new_x, _) = stepRand(x, y, BugStep * 3.0)
		x = new_x if( new_x > 0 && new_x < ScreenWidth )
	end
	if( y != new_y )
		(_, new_y) = stepRand(x, y, BugStep * 3.0)
		#puts "Bouncing X #{y} to #{new_y}"
		y = new_y if( new_y > 0 && new_y < ScreenHeight )
	end

	return [x, y, color]
end
