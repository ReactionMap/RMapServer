private-mongo
stableEQs: anInteger from: aDictionary
	| eqs |
	eqs := SortedCollection sortBlock: [ :less :more | (less at: 'energy') <= (more at: 'energy') ].
	aDictionary
		do: [ :v | 
			((v at: 'label') first = $E
				and: [ eqs size < anInteger or: [ (v at: 'energy') <= (eqs last at: 'energy') ] ])
				ifTrue: [ eqs add: v ] ].
	^ eqs asArray