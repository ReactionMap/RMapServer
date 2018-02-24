api
openDialogWithSpecLayout: aSpec
	| w |
	w := super openDialogWithSpecLayout: aSpec.
	self updateProcess.
	^ w