private-mongo
ensureMongo
	mongo isNil
		ifTrue: [ mongo := Mongo local ].
	mongo isAvailable
		ifFalse: [ mongo open.
			db := collection := extra := nil ].
	db ifNil: [ db := mongo databaseNamed: 'rmap' ].
	collection ifNil: [ collection := db getCollection: 'rmapCollection' ].
	extra ifNil: [ extra := db getCollection: 'rmapExtraCollection' ]