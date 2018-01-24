ui operations
importRMapDirectory
	(UIManager default
		chooseDirectory: 'Choose an RMap file to import'
		from: FileLocator home)
		ifNotNil: [ :directory | 
			| files |
			files := directory allFiles select: [ :file | file extension = 'rmap' ].
			files
				ifEmpty: [ ^ UIManager notify: 'No RMap file in the directory: ' , directory fullName ].
			(ProgressBarMorph from: 0 to: files size)
				in: [ :progress | 
					progress
						position: ActiveHand position - (progress width // 2);
						openInWorld.
					files
						do: [ :file | 
							self readFile: file.
							progress increment.
							Processor yield ].
					progress delete ].
			self updateRMapList ]