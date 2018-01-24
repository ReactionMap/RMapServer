ui operations
importRMapFile
	(Smalltalk ui theme
		chooseFullFileNameIn: UIManager default modalMorph
		title: 'Choose an RMap file to import'
		patterns: #('*.rmap')
		path: FileLocator home
		preview: true)
		ifNotNil: [ :fileReference | 
			self readFile: fileReference asFileReference.
			self updateRMapList ]