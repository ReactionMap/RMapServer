mongo
readParamsFrom: aStream into: aDictionary
	aStream next.
	[ aStream atEnd ]
		whileFalse: [ | pair |
			pair := aStream next substrings: '='.
			pair size > 1
				ifTrue: [ aDictionary at: pair first ifAbsentPut: [ pair second ] ]
				ifFalse: [ aDictionary at: pair first put: true ] ]