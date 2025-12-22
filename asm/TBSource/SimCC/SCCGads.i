
AmountGad1:	dc.l	0		;Next Gadget
		dc.w	110		;"hit-box" left edge
Gad1YPos:	dc.w	20		;"hit-box" top  edge
		dc.w	88              ;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	0		;flags
		dc.w	LONGINT+STRINGCENTER		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	GadgetBorder1	;gadget rendering
		dc.l	GadgetBorder1	;select rendering
		dc.l	AmountName	;gadget text
		dc.l	0		;mutual exclude
		dc.l	AmountStrInfo	;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

AmountStrInfo:	dc.l	AmountBuf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	12		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

AmountInt:	dc.l	$00ffffff	;Long int.
		dc.l	0		;AltKeyMap

AmountBuf:	dc.b	"16777215"
		dcb.b	6,0

GadUnBuf:	dcb.b	16,0

AmountName:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	-10,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	Amount1Text		;TEXT
AGadTxt2:	dc.l	Win1Txt1		;NEXTTEXT
	
Amount1Text:	dc.b	"$",0
		ds.l	0
