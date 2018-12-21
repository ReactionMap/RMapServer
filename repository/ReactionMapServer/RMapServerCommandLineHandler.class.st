"
Command line handler for starting RMapServer  from the command line

Usage:
rmapserver [--help] mongo 
rmapserver [--help] directory [repositoryDir] 
	--help                        Show this help message
	repositoryDir        the path to the rmap directories to publish
	
Examples:
	# starts RMapServer using a local mongo server
	pharo Pharo.image rmapserver mongo
	
	# starts RMapServer using /usr/local/rmaps as a repository
	pharo Pharo.image rmapserver directory /usr/local/rmaps
	
	# starts RMapServer using the default repository directory uder the pharo's installation directory
	pharo Pharo.image rmapserver directory

"
Class {
	#name : #RMapServerCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : 'ReactionMapServer'
}

{ #category : #accessing }
RMapServerCommandLineHandler class >> commandName [
	^ 'rmapserver'
]

{ #category : #accessing }
RMapServerCommandLineHandler class >> description [
	^ 'starts RMapServer process'
]

{ #category : #activation }
RMapServerCommandLineHandler >> activate [
	self arguments
		ifNotEmpty: [ :args | 
			args first asLowercase = 'mongo'
				ifTrue: [ RMapServer useMongo ].
			args first asLowercase = 'directory'
				ifTrue: [ RMapServer useDirectory: (args at: 2 ifAbsent: [  ]) ] ].
	RMapServer start.
	Smalltalk isInteractive
		ifTrue: [ RMapServer open ]
]
