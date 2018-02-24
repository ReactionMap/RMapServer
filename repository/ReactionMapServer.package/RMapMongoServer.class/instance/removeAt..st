repository
removeAt: id
	^ self
		mongo: [ :collection | 
			(collection detect: {('_id' -> (OID value: id value asInteger))} asDictionary)
				ifNotNil: [ :result | 
					((result at: 'vertices') notEmpty and: [ (result at: 'vertices') first isDictionary not ])
						ifTrue: [ self removeExtrasAll: (result at: 'vertices') ].
					((result at: 'edges') notEmpty and: [ (result at: 'edges') first isDictionary not ])
						ifTrue: [ self removeExtrasAll: (result at: 'edges') ] ].
			collection delete: {('_id' -> (OID value: id value asInteger))} asDictionary ]