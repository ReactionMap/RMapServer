teapot-api
search: aDictionary
	| query |
	query := Dictionary new.
	aDictionary keysAndValuesDo: [ :key :value | query at: 'meta.' , key put: value ].
	^ self selectMeta: query