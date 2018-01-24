ui operations
removeSelectedRMaps
	(UIManager confirm: 'Do you really want to remove all the selected RMaps?')
		ifFalse: [ ^ self ].
	rmapList selectedItems do: [ :item | self removeAt: (item at: '_id') ].
	self updateRMapList