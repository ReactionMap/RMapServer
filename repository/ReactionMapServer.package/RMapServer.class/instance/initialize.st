initialize-release
initialize
	super initialize.
	random := Random new.
	mongo := Mongo default.
	self initializeTeapot