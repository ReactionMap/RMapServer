mongo
at: id
	^ self
		mongo: [ :collection | 
			(collection detect: {('_id' -> (OID value: id value asInteger))} asDictionary)
				in: [ :result | 
					result
						ifNotNil: [ 
							((result at: 'vertices') notEmpty and: [ (result at: 'vertices') first isDictionary not ])
								ifTrue: [ result at: 'vertices' put: (self selectExtrasAll: (result at: 'vertices')) ].
							((result at: 'edges') notEmpty and: [ (result at: 'edges') first isDictionary not ])
								ifTrue: [ result at: 'edges' put: (self selectExtrasAll: (result at: 'edges')) ].
							result
								at: '_id' put: (result at: '_id') value printString;
								yourself ] ] ]