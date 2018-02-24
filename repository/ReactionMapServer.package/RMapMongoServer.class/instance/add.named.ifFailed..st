private-mongo
add: aDictionary named: aString ifFailed: errorBlock
	| rmap |
	(aDictionary includesKey: 'grrm')
		ifFalse: [ ^ errorBlock cull: 'Missing "grrm" entry' ].
	rmap := aDictionary copy.
	rmap at: 'meta' put: (self createMetaNamed: aString from: aDictionary).
	(rmap at: 'vertices') size + (rmap at: 'edges') size > 100
		ifTrue: [ rmap at: 'vertices' put: (self addExtrasAll: (rmap at: 'vertices')).
			rmap at: 'edges' put: (self addExtrasAll: (rmap at: 'edges')) ].
	self mongo: [ :collection | collection add: rmap ]