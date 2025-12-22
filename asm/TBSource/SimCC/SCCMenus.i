
;Menus

Menu1:		dc.l	Menu2			;NEXT MENU
		dc.w	0,1			;LEFT+TOP EDGE
		dc.w	90,8			;WIDTH+HEIGHT
		dc.w	$0001			;FLAGS
		dc.l	Menu1Name		;NAME
		dc.l	Menu1Item2		;ITEMS
		dc.w	0,0			;Some Jazz-music here...		
		dc.w	0,0,0			;(with a good beat)

Menu1Name:	dc.b	"Project",0
		ds.l	0

Menu1Item2:	dc.l	Menu1Item3		;NEXT ITEM
		dc.w	1,0			;LEFT+TOP EDGE
		dc.w	110,9			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I2			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"C",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu1I2:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu1I2Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I2Text:	dc.b	"CHEAT!...",0
		ds.l	0

Menu1Item3:	dc.l	Menu1Item4		;NEXT ITEM
		dc.w	1,11			;LEFT+TOP EDGE
		dc.w	110,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I3			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"H",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu1I3:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu1I3Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I3Text:	dc.b	"Help...",0
		ds.l	0

Menu1Item4:	dc.l	Menu1Item5		;NEXT ITEM
		dc.w	1,21			;LEFT+TOP EDGE
		dc.w	110,8			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I4			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"A",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu1I4:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu1I4Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu1I4Text:	dc.b	"About...",0
		ds.l	0

Menu1Item5:	dc.l	0			;NEXT ITEM
		dc.w	1,31			;LEFT+TOP EDGE
		dc.w	110,9			;WIDTH+HEIGHT
		dc.w	$0056			;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu1I5			;ITEMFILL (IMAGE, ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b 	"Q",0			;COMMAND
		dc.l	0			;IF<>0SubItem Shows ->
		dc.w	$ffff			;NextSelect

Menu1I5:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu1I5Text		;TEXT
		dc.l	0			;NEXTTEXT
	
Menu1I5Text:	dc.b	"Quit",0
		ds.l	0

Menu2:		dc.l	0			;NEXT MENU
		dc.w	91,0			;LEFT+TOP EDGE
		dc.w	110,8			;WIDTH+HEIGHT
		dc.w	$0001			;FLAGS
		dc.l	Menu2Name		;NAME
		dc.l	Menu2Item1		;ITEMS
		dc.w	0,0			;Some Jazz-music here...		
		dc.w	0,0,0			;(with a good beat)

Menu2Name:	dc.b	"Games",0
		ds.l	0

Menu2Item1:	dc.l	0 ;Menu1Item2		;NEXT ITEM
		dc.w	1,0			;LEFT+TOP EDGE
		dc.w	110,9			;WIDTH+HEIGHT
		dc.w	HIGHCOMP+ITEMENABLED+ITEMTEXT	;FLAGS
		dc.l	0			;MUTUAL EXCLUDE
		dc.l	Menu2I1			;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	0,0			;COMMAND
		dc.l	Menu2I1Sub1		;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	1,1			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1Text:	dc.b	"Games 1     ",$bb,0
		ds.l	0

Menu2I1Sub1:	dc.l	Menu2I1Sub2		;NEXT ITEM
		dc.w	90,1			;LEFT+TOP EDGE
		dc.w	185,8			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMENABLED+ITEMTEXT+CHECKIT+CHECKED
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%11111110
		dc.l	Menu2I1S1		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"1",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S1:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S1Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S1Text:	dc.b	"SimCity",0
		ds.l	0

Menu2I1Sub2:	dc.l	Menu2I1Sub3		;NEXT ITEM
		dc.w	90,10			;LEFT+TOP EDGE
		dc.w	185,9			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMENABLED+ITEMTEXT+CHECKIT
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%11111101
		dc.l	Menu2I1S2		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"2",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S2:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S2Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S2Text:	dc.b	"Ports of Call #1",0
		ds.l	0

Menu2I1Sub3:	dc.l	Menu2I1Sub4		;NEXT ITEM
		dc.w	90,19			;LEFT+TOP EDGE
		dc.w	185,9			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMTEXT+CHECKIT ;+ITEMENABLED
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%11111011
		dc.l	Menu2I1S3		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"3",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S3:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S3Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S3Text:	dc.b	"Ports of Call #2",0
		ds.l	0

Menu2I1Sub4:	dc.l	Menu2I1Sub5		;NEXT ITEM
		dc.w	90,28			;LEFT+TOP EDGE
		dc.w	185,9			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMTEXT+CHECKIT	;ITEMENABLED+
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%11110111
		dc.l	Menu2I1S4		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"4",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S4:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S4Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S4Text:	dc.b	"Ports of Call #3",0
		ds.l	0

Menu2I1Sub5:	dc.l	Menu2I1Sub6		;NEXT ITEM
		dc.w	90,37			;LEFT+TOP EDGE
		dc.w	185,9			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMTEXT+CHECKIT ;ITEMENABLED+
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%11101111
		dc.l	Menu2I1S5		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"5",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S5:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S5Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S5Text:	dc.b	"Ports of Call #4",0
		ds.l	0

Menu2I1Sub6:	dc.l	Menu2I1Sub7		;NEXT ITEM
		dc.w	90,46			;LEFT+TOP EDGE
		dc.w	185,9			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMENABLED+ITEMTEXT+CHECKIT
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%11011111
		dc.l	Menu2I1S6		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"6",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S6:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S6Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S6Text:	dc.b	"Oil Imperium #1",0
		ds.l	0

Menu2I1Sub7:	dc.l	Menu2I1Sub8		;NEXT ITEM
		dc.w	90,55			;LEFT+TOP EDGE
		dc.w	185,9			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMENABLED+ITEMTEXT+CHECKIT
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%10111111
		dc.l	Menu2I1S7		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"7",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S7:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S7Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S7Text:	dc.b	"Oil Imperium #2",0
		ds.l	0

Menu2I1Sub8:	dc.l	Menu2I1Sub9		;NEXT ITEM
		dc.w	90,64			;LEFT+TOP EDGE
		dc.w	185,9			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMENABLED+ITEMTEXT+CHECKIT
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	$ff
		dc.b	%01111111
		dc.l	Menu2I1S8		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"8",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S8:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S8Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S8Text:	dc.b	"Oil Imperium #3",0
		ds.l	0

Menu2I1Sub9:	dc.l	Menu2I1Sub10		;NEXT ITEM
		dc.w	90,73			;LEFT+TOP EDGE
		dc.w	185,9			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMENABLED+ITEMTEXT+CHECKIT
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	%11111110
		dc.b	$ff
		dc.l	Menu2I1S9		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"9",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S9:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S9Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S9Text:	dc.b	"Oil Imperium #4",0
		ds.l	0

Menu2I1Sub10:	dc.l	0 ;Menu2I1Sub11		;NEXT ITEM
		dc.w	90,82			;LEFT+TOP EDGE
		dc.w	185,9			;WIDTH+HEIGHT
		dc.w	COMMSEQ+HIGHCOMP+ITEMENABLED+ITEMTEXT+CHECKIT
		dc.w	$ffff			;MUTUAL EXCLUDE
		dc.b	%11111101
		dc.b	$ff
		dc.l	Menu2I1S10		;ITEMFILL (IMAGE,ITEXT,GFX)
		dc.l	0			;SELECTFILL
		dc.b	"0",0			;COMMAND
		dc.l	0			;SubItem
		dc.w	$ffff			;NextSelect
		
Menu2I1S10:	dc.b	0,1			;PENS
		dc.w	0			;MODE
		dc.w	20,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Menu2I1S10Text		;TEXT
		dc.l	0			;NEXTTEXT

Menu2I1S10Text:	dc.b	"RailRoad Tycoon",0
		ds.l	0

;			  11111111111111111111111111110111
;			  12345678901234567890123456789012
