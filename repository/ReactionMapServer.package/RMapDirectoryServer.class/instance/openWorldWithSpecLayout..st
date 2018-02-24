api
openWorldWithSpecLayout: aSpec
	| w |
	w := super openWorldWithSpecLayout: aSpec.
	self updateProcess.
	^ w