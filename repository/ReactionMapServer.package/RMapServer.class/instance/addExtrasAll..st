private
addExtrasAll: anArrayOfDictionary
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