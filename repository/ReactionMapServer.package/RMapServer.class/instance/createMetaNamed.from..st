mongo
createMetaNamed: aString from: aDictionary
	| meta |
	meta := Dictionary new.
	meta at: 'name' put: aString.
	self readGrrmFrom: (aDictionary at: 'grrm') into: meta.
	meta at: 'numEQ' put: ((aDictionary at: 'vertices') select: [ :v | (v at: 'label') first = $E ]) size.
	meta at: 'numTS' put: ((aDictionary at: 'vertices') select: [ :v | (v at: 'label') first = $T ]) size.
	meta at: 'numDC' put: ((aDictionary at: 'vertices') select: [ :v | (v at: 'label') first = $D ]) size.
	meta at: 'stableEQs' put: (self stableEQs: 10 from: (aDictionary at: 'vertices')).
	^ meta