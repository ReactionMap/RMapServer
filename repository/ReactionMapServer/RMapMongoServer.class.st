Class {
	#name : #RMapMongoServer,
	#superclass : #RMapServer,
	#instVars : [
		'mongo',
		'collection',
		'db',
		'extra'
	],
	#category : 'ReactionMapServer'
}

{ #category : #'private-mongo' }
RMapMongoServer >> add: aDictionary named: aString ifFailed: errorBlock [
	| rmap |
	(aDictionary includesKey: 'grrm')
		ifFalse: [ ^ errorBlock cull: 'Missing "grrm" entry' ].
	rmap := aDictionary copy.
	rmap at: 'meta' put: (self createMetaNamed: aString from: aDictionary).
	(rmap at: 'vertices') size + (rmap at: 'edges') size > 100
		ifTrue: [ rmap at: 'vertices' put: (self addExtrasAll: (rmap at: 'vertices')).
			rmap at: 'edges' put: (self addExtrasAll: (rmap at: 'edges')) ].
	self mongo: [ :collection | collection add: rmap ]
]

{ #category : #'private-mongo' }
RMapMongoServer >> addExtrasAll: anArrayOfDictionary [
	| oids |
	oids := Array new writeStream.
	self
		mongoExtras: [ :collection | 
			| dictStream |
			dictStream := anArrayOfDictionary readStream.
			[ dictStream atEnd ]
				whileFalse: [ 
					| chunk |
					chunk := Dictionary new.
					chunk at: 'salt' put: Time microsecondClockValue printString.
					chunk at: 'contents' put: (dictStream next: 100).
					collection add: chunk.
					oids nextPut: ((collection detect: chunk) at: '_id') ] ].
	^ oids contents
]

{ #category : #repository }
RMapMongoServer >> at: id [
	^ self
		mongo: [ :collection | 
			(collection detect: {('_id' -> (OID value: id value asInteger))} asDictionary)
				ifNotNil: [ :result | 
					((result at: 'vertices') notEmpty and: [ (result at: 'vertices') first isDictionary not ])
						ifTrue: [ result at: 'vertices' put: (self selectExtrasAll: (result at: 'vertices')) ].
					((result at: 'edges') notEmpty and: [ (result at: 'edges') first isDictionary not ])
						ifTrue: [ result at: 'edges' put: (self selectExtrasAll: (result at: 'edges')) ].
					result
						at: '_id' put: (result at: '_id') value printString;
						yourself ] ]
]

{ #category : #'private-mongo' }
RMapMongoServer >> ensureMongo [
	mongo isNil
		ifTrue: [ mongo := Mongo local ].
	mongo isAvailable
		ifFalse: [ [ mongo open ]
				on: ConnectionTimedOut
				do: [ :ex | 
					UIManager default alert: 'Can not connect to the local mongo server.'.
					Smalltalk exitFailure ].
			db := collection := extra := nil ].
	db ifNil: [ db := mongo databaseNamed: 'rmap' ].
	collection ifNil: [ collection := db getCollection: 'rmapCollection' ].
	extra ifNil: [ extra := db getCollection: 'rmapExtraCollection' ]
]

{ #category : #'private-mongo' }
RMapMongoServer >> mongo [
	self ensureMongo.
	^ mongo
]

{ #category : #'private-mongo' }
RMapMongoServer >> mongo: aBlock [
	self ensureMongo.
	^ aBlock value: collection
]

{ #category : #'private-mongo' }
RMapMongoServer >> mongoExtras: aBlock [
	self ensureMongo.
	^ aBlock value: extra
]

{ #category : #repository }
RMapMongoServer >> readFile: aFileReference [
	aFileReference isFile
		ifFalse: [ ^ self ].
	aFileReference extension ~= 'rmap'
		ifTrue: [ ^ self ].
	aFileReference
		readStreamDo: [ :readStream | 
			self
				add: (NeoJSONReader on: readStream) next
				named: aFileReference basenameWithoutExtension
				ifFailed: [ :msg | self error: msg ] ]
]

{ #category : #repository }
RMapMongoServer >> removeAt: id [
	^ self
		mongo: [ :collection | 
			(collection detect: {('_id' -> (OID value: id value asInteger))} asDictionary)
				ifNotNil: [ :result | 
					((result at: 'vertices') notEmpty and: [ (result at: 'vertices') first isDictionary not ])
						ifTrue: [ self removeExtrasAll: (result at: 'vertices') ].
					((result at: 'edges') notEmpty and: [ (result at: 'edges') first isDictionary not ])
						ifTrue: [ self removeExtrasAll: (result at: 'edges') ] ].
			collection delete: {('_id' -> (OID value: id value asInteger))} asDictionary ]
]

{ #category : #'private-mongo' }
RMapMongoServer >> removeExtrasAll: anArrayOfOID [
	self
		mongoExtras:
			[ :collection | anArrayOfOID do: [ :oid | collection delete: {('_id' -> oid)} asDictionary ] ]
]

{ #category : #'private-mongo' }
RMapMongoServer >> selectExtrasAll: anArrayOfOID [
	^ Array
		new: anArrayOfOID size * 100
		streamContents: [ :stream | 
			self
				mongoExtras: [ :collection | anArrayOfOID do: [ :oid | stream nextPutAll: ((collection detect: {('_id' -> oid)} asDictionary) at: 'contents') ] ] ]
]

{ #category : #repository }
RMapMongoServer >> selectMeta: aDictionary [
	^ (self
		mongo: [ :collection | 
			collection
				query: [ :query | 
					query
						where: aDictionary;
						fields:
								{('meta' -> 1).
									('grrm' -> 1)} asDictionary ] ])
		collect: [ :dict | 
			dict
				at: '_id' put: (dict at: '_id') value printString;
				yourself ]
]
