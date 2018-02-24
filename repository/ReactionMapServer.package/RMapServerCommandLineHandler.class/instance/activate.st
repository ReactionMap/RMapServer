activation
activate
	self arguments
		ifNotEmpty: [ :args | 
			args first asLowercase = 'mongo'
				ifTrue: [ RMapServer useMongo ].
			args first asLowercase = 'directory'
				ifTrue: [ RMapServer useDirectory: (args at: 2 ifAbsent: [  ]) ] ].
	RMapServer start.
	Smalltalk isInteractive
		ifTrue: [ RMapServer open ]