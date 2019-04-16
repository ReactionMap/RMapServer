Class {
	#name : #RMapDirectoryServer,
	#superclass : #RMapServer,
	#instVars : [
		'rmaps',
		'updateProcess'
	],
	#classVars : [
		'RepositoryPath'
	],
	#category : 'ReactionMapServer'
}

{ #category : #defaults }
RMapDirectoryServer class >> defaultRepositoryPath [
	^ (FileLocator localDirectory / 'ReactionMapRepository') asFileReference
]

{ #category : #accessing }
RMapDirectoryServer class >> repositoryPath [
	^ RepositoryPath ifNil: [ self defaultRepositoryPath ]
]

{ #category : #accessing }
RMapDirectoryServer class >> repositoryPath: aString [
	RepositoryPath := aString
]

{ #category : #repository }
RMapDirectoryServer >> at: id [
	| rmap rmapRef |
	((rmapRef := self repositoryPath / (id , '.rmap')) isFile and: [ rmaps includesKey: id ])
		ifFalse: [ ^ Dictionary new ].
	rmap := Dictionary new.
	(NeoJSONReader on: rmapRef readStream) next
		keysAndValuesDo: [ :key :value | rmap at: key put: value ].
	(rmaps at: id) first keysAndValuesDo: [ :key :value | rmap at: key put: value ].
	^ rmap
]

{ #category : #private }
RMapDirectoryServer >> delete [
	super delete.
	self updateProcess
]

{ #category : #repository }
RMapDirectoryServer >> jsonMatch: aDictionary1 to: aDictionary2 [
	aDictionary1
		keysAndValuesDo: [ :keys :value | 
			| current |
			current := aDictionary2.
			(keys substrings: '.') do: [ :key | current := current at: key ifAbsent: [ ^ false ] ].
			current = value
				ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #api }
RMapDirectoryServer >> openDialogWithSpecLayout: aSpec [
	| w |
	w := super openDialogWithSpecLayout: aSpec.
	self updateProcess.
	^ w
]

{ #category : #api }
RMapDirectoryServer >> openWithSpecLayout: aSpec [
	| w |
	w := super openWithSpecLayout: aSpec.
	self updateProcess.
	^ w
]

{ #category : #api }
RMapDirectoryServer >> openWorldWithSpecLayout: aSpec [
	| w |
	w := super openWorldWithSpecLayout: aSpec.
	self updateProcess.
	^ w
]

{ #category : #repository }
RMapDirectoryServer >> readFile: aFileReference [
	aFileReference copyTo: self repositoryPath / aFileReference basename
]

{ #category : #repository }
RMapDirectoryServer >> removeAt: id [
	self repositoryPath / (id , '.rmap')
		in: [ :ref | 
			ref isFile
				ifTrue: [ ref delete ] ].
	self rmaps removeKey: id ifAbsent: [  ]
]

{ #category : #repository }
RMapDirectoryServer >> repositoryPath [
	^ self class repositoryPath asFileReference
]

{ #category : #accessing }
RMapDirectoryServer >> rmaps [
	^ rmaps ifNil: [ rmaps := Dictionary new ]
]

{ #category : #repository }
RMapDirectoryServer >> selectMeta: aDictionary [
	^ Array
		streamContents: [ :result | 
			self rmaps
				valuesDo: [ :pair | 
					pair first
						in: [ :meta | 
							(self jsonMatch: aDictionary to: meta)
								ifTrue: [ result nextPut: meta ] ] ] ]
]

{ #category : #teapot }
RMapDirectoryServer >> start [
	super start.
	self updateProcess
]

{ #category : #teapot }
RMapDirectoryServer >> stop [
	super stop.
	self updateProcess
]

{ #category : #repository }
RMapDirectoryServer >> updateFromRepository [
	| changed |
	changed := false.
	self repositoryPath
		in: [ :repo | 
			repo isDirectory
				ifFalse: [ repo createDirectory ].
			(repo filesMatching: '*.rmap')
				do: [ :rmapRef | 
					| name |
					name := rmapRef basenameWithoutExtension: 'rmap'.
					((self rmaps includesKey: name)
						and: [ rmapRef modificationTime < (self rmaps at: name) second ])
						ifFalse: [ | json rmap |
							json := (NeoJSONReader on: rmapRef readStream) next.
							json at: 'grrm' ifAbsent: [self createGrrm: json].
							rmap := Dictionary new
								at: '_id' put: name;
								at: 'grrm' put: (json at: 'grrm');
								at: 'meta' put: (self createMetaNamed: name from: json);
								yourself.
							self rmaps
								at: name
								put:
									{rmap.
									DateAndTime now}.
							changed := true ] ].
			self rmaps keys asArray
				do: [ :name | 
					(repo / (name , '.rmap')) isFile
						ifFalse: [ self rmaps removeKey: name ifAbsent: [  ].
							changed := true ] ] ].
	^ changed
]

{ #category : #private }
RMapDirectoryServer >> updateProcess [
	(self isDisplayed or: [ self isRunning ])
		ifTrue: [ updateProcess
				ifNil: [ updateProcess := [ [ (self isDisplayed or: [ self isRunning ])
						ifFalse: [ | p |
							p := updateProcess.
							updateProcess := nil.
							p terminate ].
					self updateRMapList.
					10 seconds wait ] repeat ] forkAt: Processor userBackgroundPriority ] ]
		ifFalse: [ updateProcess
				ifNotNil: [ updateProcess terminate.
					updateProcess := nil ] ].
	^ updateProcess
]

{ #category : #private }
RMapDirectoryServer >> updateRMapList [
	self updateFromRepository.
	super updateRMapList
]
