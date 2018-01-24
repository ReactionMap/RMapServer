accessing
startStopButtonLabel
	^ self isRunning
		ifTrue: [ 'Running' ]
		ifFalse: [ 'Down' ]