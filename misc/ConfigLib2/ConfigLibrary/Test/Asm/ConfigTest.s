;
; ConfigTest.s
;
; $VER: ConfigTest.s 2.0 (7.9.96)
;
; Copyright (C) 1996, Adam Dawes
;
; Refer to accompanying documentation for further details
;


include		"config.i"


Start:
	move.l	$4,a6			;Get ExecBase

; Initialise -- open libraries

	lea	DosName,a1		;Open dos.library...
	move.l	#36,d0			;Version 36
	jsr	-552(a6)		;OpenLibrary()
	move.l	d0,DosBase		;Store DosBase

	lea	ConfigName,a1		;Open config.library...
	move.l	#2,d0			;Version 2
	jsr	-552(a6)		;OpenLibrary()
	move.l	d0,ConfigBase		;Store ConfigBase

; Write some data to the config file

	move.l	DosBase,a6
	move.l	#WritingText,d1
	jsr	-948(a6)		;Put some text telling the user we're writing to the cfg file

	move.l	ConfigBase,a6
	move.l	#Filename,d0
	move.l	#Section,d1
	move.l	#Item,d2
	move.l	#Data,d3
	jsr	WriteConfig(a6)		;Write some data to the config file


; Read data back to our buffer

	move.l	DosBase,a6
	move.l	#ReadingText,d1
	jsr	-948(a6)		;Put some text telling the user we're reading from the cfg file

	move.l	ConfigBase,a6
	move.l	#Filename,d0
	move.l	#Section,d1
	move.l	#Item,d2
	move.l	#Buffer,d3
	move.l	#255,d4
	move.l	#Default,d5
	jsr	ReadConfig(a6)

	move.l	DosBase,a6
	move.l	#ResultsText,d1
	jsr	-948(a6)		;Show a label for our results

	move.l	#Buffer,d1
	jsr	-948(a6)		;Show what we've read back

	move.l	#CRText,d1
	jsr	-948(a6)		;Print a CR


;Clean up and exit

	move.l	$4,a6
	move.l	ConfigBase,a1
	jsr	-414(a6)		;CloseLibrary()

	move.l	DosBase,a1
	jsr	-414(a6)		;CloseLibrary()

	rts


DosBase:	dc.l	0
DosName:	dc.b	'dos.library',0
even

ConfigBase:	dc.l	0
ConfigName:	dc.b	'config.library',0

Filename:	dc.b	'RAM:Test.cfg',0
Section:	dc.b	'Test',0
Item:		dc.b	'Name',0
Data:		dc.b	'Adam Dawes',0

Buffer:		blk.b	256,0
Default:	dc.b	"<unknown>",0

WritingText:	dc.b	'Writing some text to the config file...',10,0
ReadingText:	dc.b	'Reading data back from file...',10,0
ResultsText:	dc.b	'Name: ',0
CRText:		dc.b	10,0
