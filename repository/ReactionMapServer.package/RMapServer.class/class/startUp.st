snapshotting
startUp
	self
		flushCurrent.
	Smalltalk isInteractive
		ifTrue: [ self open ]