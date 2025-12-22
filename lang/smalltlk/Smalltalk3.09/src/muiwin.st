*
* Little Smalltalk, version 3
* Written by Tim Budd, Oregon State University, July 1988
* Modified by David Faught, August 1995
*
*  Methods for the Amiga MUI front end.
*  For now, much of the windowing stuff is rather staticly coded,
*  instead of more general routines.
*
Class EventManager Process responses
Class Window Object
Class	BrowserWindow Window class method
Methods Window 'all'
	open
		" open window number 1, the browser window "
		<160 1>
|	
	close
		" close window number 1"
		<161 1>
]
Methods EventManager 'all'
	new
		responses <- Array new: 14.
		responses at: 1 put: [:w | ].
		responses at: 2 put: [:w | browserWindow selClass: w ].
		responses at: 3 put: [:w | browserWindow selMethod: w ].
		responses at: 4 put: [:w | self command: w ].
		responses at: 5 put: [:w | browserWindow open ].
		responses at: 6 put: [:w | browserWindow editMethod ].
		self moreNew.
|
	moreNew
		responses at: 7 put: [:w | browserWindow fileIn ].
		responses at: 8 put: [:w | browserWindow fileOut ].
		responses at: 9 put: [:w | browserWindow saveImage ].
		responses at: 10 put: [:w | browserWindow addClass ].
		responses at: 11 put: [:w | browserWindow addMethod ].
		responses at: 12 put: [:w | smalltalk echo ].
		responses at: 13 put: [:w | smalltalk bytes ].
		responses at: 14 put: [:w | browserWindow close ].
|
	execute	| event string |
		" process one event "
		event <- <170 (scheduler processCount)>.
		string <- <171 event>.
		string isNil
			ifTrue: [ scheduler quit ]
			ifFalse: [ ( (event >= 2) and: [(event <= 14)] )
				ifTrue: [ (responses at: event) value: string ]
				]
|
	command: aString
		" do a command "
		 (aString size > 0)
			ifTrue: [ 
				echoInput ifTrue:
					[ aString print ].
				[ aString value print ] fork ] ]
]
Methods BrowserWindow 'all'
	open
		super open.
		self refreshClasses.
		self selClass: 'Array'.
		self selMethod: '<'
|
	refreshClasses
		<180 1>.
		classes do: [:a | <181 1 (a name)>].
|
	selClass: aString
		class <- (aString asSymbol) value.
		<182 1>.
		class methods; do: [:a | <183 1 (a name)>].
|
	selMethod: aString
		method <- class methodNamed: (aString asSymbol).
		byteShow ifTrue: [ method showBytes ]
			ifFalse: [ <185 1 (method text)> ].
|
	editMethod
		class editMethod: (method name)
|
	fileOut
		class fileOut
|
	addClass	| aString |
		aString <- <204 'Enter superClass, nameOfClass & var1 ...'
 'superClass addSubClass: #nameOfClass instanceVariableNames: ''var1 var2'' '>.
		eventManager command: aString.
		self refreshClasses.
|
	addMethod
		class addMethod.
|
	fileIn
		File new; fileIn: (smalltalk askFile: 'file name?').
|
	saveImage
		smalltalk saveImage: (smalltalk askNewFile: 'image file?').
]
Methods Method 'all'
	showBytes	| aString |
		aString <- ''.
		bytecodes do: [:x | aString <- aString, (x printString, ' ', (x quo: 16),
		 ' ', (x rem: 16), '') ].
		<185 1 aString>.
]
Methods Class 'all'
	addMethod	| m |
		m <- Method new; text: ''.
		(self doEdit: m)
			ifTrue: [ methods at: m name put: m ]
|
	doEdit: method
		" edit a method until it compiles correctly "
		[ method text: method text edit.
		  (method compileWithClass: self)
			ifTrue: [ ^ true ]
			ifFalse: [ smalltalk inquire: 'edit again?' ]
				] whileTrue.
		^ false
|
	display
		('Class name: ', name asString)  print.
		(superClass notNil)
			ifTrue: [ ('Superclass: ', superClass ) print ].
		'Instance Variables:' print.
		variables isNil
			ifTrue: [ 'no instance variables ' print ]
			ifFalse: [ variables display ].
		'Subclasses: ' print.
		self subClasses display
|
	editMethod: name	| m |
		m <- self methodNamed: name.
		(m notNil)
			ifTrue: [ self doEdit: m ]
			ifFalse: [ superClass notNil
				    ifTrue: [ superClass editMethod: name ]
				    ifFalse: [ 'no such method' print ] ]
|
	readInstanceVariables
		self variables:
			((smalltalk getPrompt: 'Instance Variables? ')
			words: [:x | x isAlphabetic ])
|
	readMethods
		[ smalltalk inquire: 'Add a method?' ]
			whileTrue: [ self addMethod ]
|
	viewMethod: methodName	| m |
		m <- self methodNamed: methodName.
		(m notNil) 
			ifTrue: [ m signature print.  m text print ]
			ifFalse: [ 'no such method' print ]
]
Methods Smalltalk 'all'
	getPrompt: aString
		^ <204 aString ''>
|
	inquire: aString
		^ <202 aString>
|
	askFile: aString
		^ <203 aString>
|
	askNewFile: aString
		^ <204 aString ''>
|
	echo
		" enable - disable echo input "
		echoInput <- echoInput not
|
	bytes
		byteShow <- byteShow not
|
	print: aString
		<200 aString>
]
Methods String 'all'
	edit	| file text |
		file <- File new; 
			scratchFile;
			open: 'w';
			print: self;
			close.
		('memacs ', file name, ' OPT W') dosCommand.
		"OPT W only works with memacs, so original below is commented"
		"(editor, ' ', file name) dosCommand."
		file open: 'r'.
		text <- file asString.
		file close; delete.
		^ text
|
	print
		smalltalk print: self
]
*
* initialization code
* this is executed once, by the initial image maker
*
*
Methods Smalltalk 'doit'
	error: aString
		" print a message, and remove current process "
		<201 aString>.
		scheduler currentProcess; trace; terminate.
]
Methods Scheduler 'get commands'
	initialize
		browserWindow <- BrowserWindow new.
		eventManager <- EventManager new.
		scheduler addProcess: eventManager.
|
	quit
		" all done - really quit "
		" should probably verify first "
		notdone <- false
|
	processCount
		^ processList size
]
Methods UndefinedObject 'initial image'
	createGlobals	| aBlock |
		" create global variables in initial image "
		true <- True new.
		false <- False new.
		smalltalk <- Smalltalk new.
		files <- Array new: 15.
		stdin <- File new; name: 'stdin'; mode: 'r'; open.
		stdout <- File new; name: 'stdout'; mode: 'w'; open.
		stderr <- File new; name: 'stderr'; mode: 'w'; open.
		editor <- 'memacs'.
		" create a dictionary of classes "
		classes <- Dictionary new.
		symbols binaryDo: [:x :y | 
			(y class == Class)
				ifTrue: [ classes at: x put: y ] ].
		scheduler <- Scheduler new.
|
	initialize
		" initialize the initial object image "
		self createGlobals.
		" create the initial system process "
		" note the delayed recursive call "
		aBlock <- [ files do: [:f | f notNil ifTrue: [ f open ]].
				   systemProcess <- aBlock newProcess.
				   echoInput <- false.
				   byteShow <- false.
				   scheduler run ].
		systemProcess <- aBlock newProcess.
		File new;
			name: 'systemImage';
			open: 'w';
			saveImage;
			close.
]
