ui operations
toggleStartStopServer
	self isRunning
		ifTrue: [ self stop ]
		ifFalse: [ self start ].
	self startStopButton label: self startStopButtonLabel