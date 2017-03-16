mongo
add: aDictionary named: aString ifFailed: errorBlock
	| rmap meta grrm commandline atoms |
	(aDictionary includesKey: 'grrm')
		ifFalse: [ ^ errorBlock cull: 'Missing "grrm" entry' ].
	meta := Dictionary new.
	meta at: 'name' put: aString.
	grrm := (aDictionary at: 'grrm') lines readStream.
	commandline := grrm next substrings: '/'.
	commandline size >= 1
		ifTrue: [ meta at: 'command1' ifAbsentPut: [ commandline first copyWithoutFirst trim ] ].
	commandline size >= 2
		ifTrue: [ meta at: 'command2' ifAbsentPut: [ commandline second ] ].
	commandline size >= 3
		ifTrue: [ meta at: 'command3' ifAbsentPut: [ commandline third ] ].
	grrm next.
	grrm next.
	atoms := Dictionary new.
	[ grrm peek trim = 'OPTIONS' ]
		whileFalse: [ 
			| element |
			element := (grrm next copyFrom: 1 to: 2) trim.
			atoms at: element put: (atoms at: element ifAbsent: [ 0 ]) + 1 ].
	meta at: 'atoms' ifAbsentPut: [ atoms ].
	grrm next.
	[ grrm atEnd ]
		whileFalse: [ 
			| pair |
			pair := grrm next substrings: '='.
			pair size > 1
				ifTrue: [ meta at: pair first ifAbsentPut: [ pair second ] ]
				ifFalse: [ meta at: pair first put: true ] ].
	rmap := aDictionary copy.
	rmap at: 'meta' put: meta.
	(rmap at: 'vertices') size + (rmap at: 'edges') size > 100
		ifTrue: [ 
			rmap at: 'vertices' put: (self addExtrasAll: (rmap at: 'vertices')).
			rmap at: 'edges' put: (self addExtrasAll: (rmap at: 'edges')) ].
	self mongo: [ :collection | collection add: rmap ]