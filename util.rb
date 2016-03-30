#!/usr/bin/env jruby

require 'matrix' # For Vectors
require_relative 'configuration'

=begin
	UTILITY FUNCTIONS

	These are mostly vector related math functions to help with movement.
=end

# Use that magical distance formula!
def getDistance(x1, y1, x2, y2)
	return Math.sqrt( ((x2.to_f - x1.to_f) ** 2.0) + ((y2.to_f - y1.to_f) ** 2.0) )
end

# Returns an array of [newX, newY] if you want to step towards another 
# coordinate. Just put in (srcX, srcY, dstX, dstY)
def stepTowards(x1, y1, x2, y2, distance)
	d = (Vector[x2 - x1, y2 - y1].normalize) * distance
	return [x1 + d[0], y1 + d[1]]
end

# Returns an array of [newX, newY] if you want to away from another 
# coordinate. Just put in (srcX, srcY, dstX, dstY)
def stepAway(x1, y1, x2, y2, distance)
	d = (Vector[x2 - x1, y2 - y1].normalize) * distance * -1
	return [x1 + d[0], y1 + d[1]]
end

def stepRand(x, y, distance)
	d = (Vector[rand(ScreenWidth) - x, rand(ScreenHeight) - y].normalize) * distance
	return [x + d[0], y + d[1]]
end

def findClosest(x, y, bugs)
	closest = nil
	closestDistance = 999999999999
	for bug in bugs
		d = getDistance(x, y, bug.x, bug.y)
		if( d < closestDistance && d != 0 )
			closest = bug
			closestDistance = d
		end
	end
	return [closest, closestDistance]
end


