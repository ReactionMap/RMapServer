initialization
initialize
	super initialize.
	random := Random new.
	mongo := Mongo default.
	self updateRMapList.
	self initializeTeapot