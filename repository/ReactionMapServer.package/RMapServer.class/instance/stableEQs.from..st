private-mongo
stableEQs: anInteger from: anArrayOfDictionary
	| eqs |
	eqs := SortedCollection sortBlock: [ :less :more | (less at: 'energy') <= (more at: 'energy') ].
	anArrayOfDictionary
		do: [ :v | 
			((v at: 'label') first = $E and: [ eqs size < anInteger or: [ (v at: 'energy') <= (eqs last at: 'energy') ] ])
				ifTrue: [ eqs add: v.
					[ eqs size > anInteger ] whileTrue: [ eqs removeLast ] ] ].
	^ eqs asArray