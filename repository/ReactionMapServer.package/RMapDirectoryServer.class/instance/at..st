repository
at: id
	| rmap rmapRef |
	(rmapRef := (self repositoryPath / (id , '.rmap')) isFile and: [ rmaps includesKey: id ])
		ifFalse: [ ^ Dictionary new ].
	rmap := Dictionary new.
	(NeoJSONReader on: rmapRef readStream) next
		keysAndValuesDo: [ :key :value | rmap at: key put: value ].
	(rmaps at: id) keysAndValuesDo: [ :key :value | rmap at: key put: value ].
	^ rmap