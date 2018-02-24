private
readAtomsFrom: aStream into: aDictionary
	| atoms |
	aStream next.
	aStream next.
	atoms := Dictionary new.
	[ aStream peek trim = 'OPTIONS' ]
		whileFalse: [ | element |
			element := (aStream next copyFrom: 1 to: 2) trim.
			atoms at: element put: (atoms at: element ifAbsent: [ 0 ]) + 1 ].
	aDictionary at: 'atoms' ifAbsentPut: [ atoms ]