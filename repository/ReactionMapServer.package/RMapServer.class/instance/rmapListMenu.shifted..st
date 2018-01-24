menus
rmapListMenu: aMenu shifted: aBoolean
	aMenu
		add: 'Import a file...' target: self selector: #importRMapFile;
		add: 'Import all from a directory...' target: self selector: #importRMapDirectory.
	rmapList selectedIndexes
		ifNotEmpty: [ aMenu
				addLine;
				add: 'Remove selected rmaps' target: self selector: #removeSelectedRMaps ].
	^ aMenu