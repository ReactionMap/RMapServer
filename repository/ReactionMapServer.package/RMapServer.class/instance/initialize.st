initialization
initialize
	super initialize.
	random := Random new.
	self updateRMapList.
	self initializeTeapot