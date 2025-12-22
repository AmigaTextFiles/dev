
;The default preferences for our little program

PREFS_START:
DefPrefs:	dc.b	"QUEP"			;Header

DefColors:	dc.w	$aaa,$000,$fff,$68b	;default colors

DefTalk:	dc.w	0			;Talking
DefTalkSys:	dc.w	1			;Say system messages
DefTalkDes:	dc.w	1			;Say descriptions
DefTalkQue:	dc.w	0			;Say questions
DefTalkAns:	dc.w	0			;Say answers
DefTalkCAns:	dc.w	0			;Say correct answer(s)
DefTalkTimer:	dc.w	0			;Say correct timer(s)
DefTalkHelp:	dc.w	0			;Say correct help(s)
DefIHandler:	dc.w	1			;Use Input-Handler (0=No, 1=Yes)
DefSpeakName:	dc.b	"SPEAK:"
		dcb.b	128-6,0
DefSpeakName2:	dc.b	"SPEAK2:"
		dcb.b	128-6,0
		dc.l	0,0
PREFS_END:
		dc.l	0

