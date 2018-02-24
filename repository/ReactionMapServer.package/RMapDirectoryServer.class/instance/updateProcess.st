private
updateProcess
	(self isDisplayed or: [ self isRunning ])
		ifTrue: [ updateProcess
				ifNil: [ updateProcess := [ [ (self isDisplayed or: [ self isRunning ])
						ifFalse: [ | p |
							p := updateProcess.
							updateProcess := nil.
							p terminate ].
					self updateRMapList.
					10 seconds wait ] repeat ] forkAt: Processor userBackgroundPriority ] ]
		ifFalse: [ updateProcess
				ifNotNil: [ updateProcess terminate.
					updateProcess := nil ] ].
	^ updateProcess