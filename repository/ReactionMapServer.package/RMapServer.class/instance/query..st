private
query: aTeaRequest
	| url query |
	url := aTeaRequest url.
	query := Dictionary new.
	(url hasQuery
		ifTrue: [ url query asDictionary ]
		ifFalse: [ 
			(aTeaRequest entity isKindOf: ZnApplicationFormUrlEncodedEntity)
				ifTrue: [ aTeaRequest entity asDictionary ]
				ifFalse: [ Dictionary new ] ])
		keysAndValuesDo: [ :key :value | 
			(key size > 6 and: [ (key copyFrom: 1 to: 6) = 'atoms.' ])
				ifTrue: [ query at: key put: value asInteger ]
				ifFalse: [ query at: key put: value ] ].
	^ query