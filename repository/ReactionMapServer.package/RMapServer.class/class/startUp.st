snapshotting
startUp
	self
		flushCurrent;
		current.
	Smalltalk isInteractive
		ifTrue: [ self open ]
		ifFalse: [ self start ]