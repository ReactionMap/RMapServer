api
openWithSpecLayout: aSpec
	| w |
	w := super openWithSpecLayout: aSpec.
	self updateProcess.
	^ w