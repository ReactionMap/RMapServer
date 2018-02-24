private
readCommandlineFrom: aStream into: aDictionary
	| commandline |
	commandline := aStream next substrings: '/'.
	commandline size >= 1
		ifTrue: [ aDictionary at: 'command1' ifAbsentPut: [ commandline first copyWithoutFirst trim ] ].
	commandline size >= 2
		ifTrue: [ aDictionary at: 'command2' ifAbsentPut: [ commandline second ] ].
	commandline size >= 3
		ifTrue: [ aDictionary at: 'command3' ifAbsentPut: [ commandline third ] ]