teapot-api
get: aDictionary
	^ self at: (aDictionary at: '_id' ifAbsent: [ 0 ]) asInteger