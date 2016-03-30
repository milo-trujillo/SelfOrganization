=begin
	GLOBAL CONFIGURATION

	These constants control most of the game settings, and can drastically
	alter its behavior.
=end

# Main window configuration
Title = "Self Organization Simulation"
ScreenWidth = 1024
ScreenHeight = 768
CenterX = ScreenWidth / 2
CenterY = ScreenHeight / 2
BackgroundColor = 0x15a429 # Green

# Project configuration
NumBugs = 30 # Minimum is 2
BugWidth = 20
BugHeight = 20
BugMinDistance = 30 # Don't get closer to other bugs than this!
BugMaxDistance = 100 # If too far from friends, seek them
BugStep = 1 # How far can a bug move in a turn?
Behavior = "behaviors/cluster"

