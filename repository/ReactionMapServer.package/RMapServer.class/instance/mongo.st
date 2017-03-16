mongo
mongo
	mongo isNil
		ifTrue: [ mongo := Mongo default ].
	mongo isAvailable not
		ifTrue: [ mongo open ].
	^ mongo