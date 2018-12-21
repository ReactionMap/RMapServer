Class {
	#name : #BaselineOfRMapServer,
	#superclass : #BaselineOf,
	#category : #BaselineOfRMapServer
}

{ #category : #baseline }
BaselineOfRMapServer >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'MongoTalk' with: [ spec repository: 'github://pharo-nosql/mongotalk/mc' ];
				baseline: 'Teapot' with: [ spec repository: 'github://zeroflag/Teapot/source' ];
				package: 'ReactionMapServer' with: [ spec requires: #('MongoTalk' 'Teapot') ];
				group: 'default' with: #('ReactionMapServer');
				yourself ]
]
