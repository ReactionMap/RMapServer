baseline
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'RMapServer'
					with: [ spec
						repository: 'github://ReactionMap/RMapServer/repository';
						requires: #('MongoTalk' 'Teapot') ];
				configuration: 'MongoTalk'
					with: [ spec
						versionString: #stable;
						repository: 'github://pharo-nosql/mongotalk/mc' ];
				configuration: 'Teapot'
					with: [ spec
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/zeroflag/Teapot/main/' ];
				group: 'default' with: #('RMapServer');
				yourself ]