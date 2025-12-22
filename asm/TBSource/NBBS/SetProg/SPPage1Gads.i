
StopB1Gad:	dc.l	StopB2Gad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	22		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE+SELECTED ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	StopB1GadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	10		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

StopB1GadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	StopB1GadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
StopB1GadText1:	dc.b	"1",0
		ds.l	0

StopB2Gad:	dc.l	DataB7Gad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	34		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	StopB2GadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	11		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

StopB2GadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	StopB2GadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
StopB2GadText1:	dc.b	"2",0
		ds.l	0

DataB7Gad:	dc.l	DataB8Gad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	60		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	DataB7GadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	10		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

DataB7GadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	DataB7GadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
DataB7GadText1:	dc.b	"7",0
		ds.l	0

DataB8Gad:	dc.l	XONXOFFGad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	72		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE+SELECTED ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	DataB8GadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	11		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

DataB8GadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	DataB8GadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
DataB8GadText1:	dc.b	"8",0
		ds.l	0

XONXOFFGad:	dc.l	ParityNGad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	88		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	XONXOFFGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	12		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

XONXOFFGadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	XONXOFFGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
XONXOFFGadText1:	dc.b	"XON/XOFF",0
		ds.l	0

ParityNGad:	dc.l	ParityEGad	;Next Gadget
		dc.w	120		;"hit-box" left edge
		dc.w	22		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE+SELECTED ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	ParityNGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	10		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

ParityNGadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	ParityNGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
ParityNGadText1:	dc.b	"None",0
		ds.l	0

ParityEGad:	dc.l	ParityOGad	;Next Gadget
		dc.w	120		;"hit-box" left edge
		dc.w	34		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	ParityEGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	11		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

ParityEGadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	ParityEGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
ParityEGadText1:	dc.b	"Even",0
		ds.l	0

ParityOGad:	dc.l	ParityMGad	;Next Gadget
		dc.w	120		;"hit-box" left edge
		dc.w	46		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	ParityOGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	11		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

ParityOGadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	ParityOGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
ParityOGadText1:	dc.b	"Odd",0
		ds.l	0

ParityMGad:	dc.l	ParitySGad	;Next Gadget
		dc.w	120		;"hit-box" left edge
		dc.w	58		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	ParityMGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	11		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

ParityMGadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	ParityMGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
ParityMGadText1:	dc.b	"Mark",0
		ds.l	0

ParitySGad:	dc.l	DuplexFGad	;Next Gadget
		dc.w	120		;"hit-box" left edge
		dc.w	70		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE ;+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	ParitySGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	11		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

ParitySGadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	ParitySGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
ParitySGadText1:	dc.b	"Space",0
		ds.l	0

DuplexFGad:	dc.l	DuplexHGad	;Next Gadget
		dc.w	220		;"hit-box" left edge
		dc.w	22		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE+SELECTED+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	DuplexFGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	11		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

DuplexFGadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	DuplexFGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
DuplexFGadText1:	dc.b	"Full",0
		ds.l	0

DuplexHGad:	dc.l	DuplexEGad	;Next Gadget
		dc.w	220		;"hit-box" left edge
		dc.w	34		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	DuplexHGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	11		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

DuplexHGadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	DuplexHGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
DuplexHGadText1:	dc.b	"Half",0
		ds.l	0

DuplexEGad:	dc.l	SerBRKTGad	;Next Gadget
		dc.w	220		;"hit-box" left edge
		dc.w	46		;"hit-box" top  edge
		dc.w	12              ;"hit-box" Width
		dc.w	11		;"hit-box" Height
		dc.w	GADGIMAGE+GADGHIMAGE+GADGDISABLED	;flags
		dc.w	$0102		;activation
		dc.w	$0001		;gadget type
		dc.l	ButtonImage1	;gadget renderingg
		dc.l	ButtonImage2	;select rendering
		dc.l	DuplexEGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	11		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data
		ds.l	0

DuplexEGadTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	17,2			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	DuplexEGadText1		;TEXT
		dc.l    0			;NEXTTEXT
		ds.l	0
DuplexEGadText1:	dc.b	"Echo",0
		ds.l	0

SerBRKTGad:	dc.l	SerRingGad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	112		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	RELVERIFY+STRINGCENTER+LONGINT	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerBRKTGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerBRKTStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerBRKTGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	65,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerBRKTGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerBRKTGadText:	dc.b	"Break length",0

		ds.l	0

SerBRKTStrInfo:	dc.l	SerBRKTGadBuf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

SerBRKTLInt:	dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerRingGad:	dc.l	SerConGad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	132		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerRingGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerRingStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerRingGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	77,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerRingGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerRingGadText:	dc.b	"Ring text",0
		ds.l	0

SerRingStrInfo:	dc.l	SerRingStr	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerConGad:	dc.l	SerCon12Gad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	152		;"hit-box" top  edge
		dc.w	112		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage3	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerConGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerConStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerConGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	8,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerConGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerConGadText:	dc.b	"Connect 300",0
		ds.l	0

SerConStrInfo:	dc.l	SerConn300	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerCon12Gad:	dc.l	SerCon24Gad	;Next Gadget
		dc.w	143		;"hit-box" left edge
		dc.w	152		;"hit-box" top  edge
		dc.w	112		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage3	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerCon12GadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerCon12StrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerCon12GadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	8,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerCon12GadText		;TEXT
		dc.l	0			;NEXTTEXT

SerCon12GadText:
		dc.b	"Connect 1200",0
		ds.l	0

SerCon12StrInfo:
		dc.l	SerConn1200	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerCon24Gad:	dc.l	SerCon48Gad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	172		;"hit-box" top  edge
		dc.w	112		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage3	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerCon24GadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerCon24StrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerCon24GadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	8,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerCon24GadText		;TEXT
		dc.l	0			;NEXTTEXT

SerCon24GadText:
		dc.b	"Connect 2400",0
		ds.l	0

SerCon24StrInfo:
		dc.l	SerConn2400	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerCon48Gad:	dc.l	SerCon96Gad	;Next Gadget
		dc.w	143		;"hit-box" left edge
		dc.w	172		;"hit-box" top  edge
		dc.w	112		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage3	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerCon48GadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerCon48StrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerCon48GadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	8,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerCon48GadText		;TEXT
		dc.l	0			;NEXTTEXT

SerCon48GadText:
		dc.b	"Connect 4800",0
		ds.l	0

SerCon48StrInfo:
		dc.l	SerConn4800	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerCon96Gad:	dc.l	SerCon19Gad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	192		;"hit-box" top  edge
		dc.w	112		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage3	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerCon96GadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerCon96StrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerCon96GadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	8,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerCon96GadText		;TEXT
		dc.l	0			;NEXTTEXT

SerCon96GadText:
		dc.b	"Connect 9600",0
		ds.l	0

SerCon96StrInfo:
		dc.l	SerConn9600	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerCon19Gad:	dc.l	SerCon38Gad	;Next Gadget
		dc.w	143		;"hit-box" left edge
		dc.w	192		;"hit-box" top  edge
		dc.w	112		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage3	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerCon19GadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerCon19StrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerCon19GadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	4,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerCon19GadText		;TEXT
		dc.l	0			;NEXTTEXT

SerCon19GadText:
		dc.b	"Connect 19200",0
		ds.l	0

SerCon19StrInfo:
		dc.l	SerConn19200	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerCon38Gad:	dc.l	SerCon57Gad	;Next Gadget
		dc.w	20		;"hit-box" left edge
		dc.w	212		;"hit-box" top  edge
		dc.w	112		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage3	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerCon38GadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerCon38StrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerCon38GadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	4,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerCon38GadText		;TEXT
		dc.l	0			;NEXTTEXT

SerCon38GadText:
		dc.b	"Connect 38400",0
		ds.l	0

SerCon38StrInfo:
		dc.l	SerConn38400	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerCon57Gad:	dc.l	SerDevGad	;Next Gadget
		dc.w	143		;"hit-box" left edge
		dc.w	212		;"hit-box" top  edge
		dc.w	112		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage3	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerCon57GadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerCon57StrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerCon57GadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	4,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerCon57GadText		;TEXT
		dc.l	0			;NEXTTEXT

SerCon57GadText:
		dc.b	"Connect 57600",0
		ds.l	0

SerCon57StrInfo:
		dc.l	SerConn57600	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerDevGad:	dc.l	SerUnitGad	;Next Gadget
		dc.w	320		;"hit-box" left edge
		dc.w	22		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerDevGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerDevStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerDevGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	65,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerDevGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerDevGadText:	dc.b	"Serial device",0

		ds.l	0

SerDevStrInfo:	dc.l	SerName		;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerUnitGad:	dc.l	FontGad		;Next Gadget
		dc.w	531		;"hit-box" left edge
		dc.w	44		;"hit-box" top  edge
		dc.w	24		;"hit-box" Width
		dc.w	9		;"hit-box" Height
	 	dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	RELVERIFY+STRINGCENTER+LONGINT	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage2	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerUnitGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerUnitStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerUnitGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	-3,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerUnitGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerUnitGadText:	dc.b	"Unit",0
		ds.l	0

SerUnitStrInfo:	dc.l	SerUnitGadBuf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	10		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

SerUnitLInt:	dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

FontGad:	dc.l	FontSizeGad	;Next Gadget
		dc.w	320		;"hit-box" left edge
		dc.w	66		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	FontGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	FontStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

FontGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	100,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	FontGadText		;TEXT
		dc.l	0			;NEXTTEXT

FontGadText:	dc.b	"Font",0

		ds.l	0

FontStrInfo:	dc.l	UserFont	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

FontSizeGad:	dc.l	KeyMapGad	;Next Gadget
		dc.w	531		;"hit-box" left edge
		dc.w	88		;"hit-box" top  edge
		dc.w	24		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE+GADGDISABLED	;flags
		dc.w	RELVERIFY+STRINGCENTER+LONGINT	;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage2	;gadget rendering
		dc.l	0		;select rendering
		dc.l	FontSizeGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	FontSizeStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

FontSizeGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	-3,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	FontSizeGadText		;TEXT
		dc.l	0			;NEXTTEXT

FontSizeGadText:	dc.b	"Size",0
		ds.l	0

FontSizeStrInfo:	dc.l	FontSizeGadBuf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	1		;Pos in Buffer
		dc.w	10		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

UserFontSizeLInt:	dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

KeyMapGad:	dc.l	SerResetGad	;Next Gadget
		dc.w	320		;"hit-box" left edge
		dc.w	112		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	KeyMapGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	KeyMapStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

KeyMapGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	94,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	KeyMapGadText		;TEXT
		dc.l	0			;NEXTTEXT

KeyMapGadText:	dc.b	"Keymap",0

		ds.l	0

KeyMapStrInfo:	dc.l	UserKeyMap	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerResetGad:	dc.l	SerInitGad	;Next Gadget
		dc.w	320		;"hit-box" left edge
		dc.w	132		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerResetGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerResetStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerResetGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	41,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerResetGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerResetGadText:	dc.b	"Modem reset string",0

		ds.l	0

SerResetStrInfo:	dc.l	SerResetStr	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerInitGad:	dc.l	SerDialPreGad	;Next Gadget
		dc.w	320		;"hit-box" left edge
		dc.w	152		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerInitGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerInitStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerInitGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	45,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerInitGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerInitGadText:	dc.b	"Modem init string",0

		ds.l	0

SerInitStrInfo:	dc.l	SerInitStr	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerDialPreGad:	dc.l	SerDialSufGad	;Next Gadget
		dc.w	320		;"hit-box" left edge
		dc.w	172		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerDPreGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerDPreStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerDPreGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	69,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerDPreGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerDPreGadText:	dc.b	"Dial prefix",0

		ds.l	0

SerDPreStrInfo:	dc.l	SerDialPre	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerDialSufGad:	dc.l	SerAnswerGad	;Next Gadget
		dc.w	320		;"hit-box" left edge
		dc.w	192		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerDSufGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerDSufStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerDSufGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	69,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerDSufGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerDSufGadText:	dc.b	"Dial suffix",0

		ds.l	0

SerDSufStrInfo:	dc.l	SerDialSuf	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

SerAnswerGad:	dc.l	0 ;		;Next Gadget
		dc.w	320		;"hit-box" left edge
		dc.w	212		;"hit-box" top  edge
		dc.w	235		;"hit-box" Width
		dc.w	9		;"hit-box" Height
		dc.w	GADGIMAGE ;+GADGDISABLED	;flags
		dc.w	$0201		;activation
		dc.w	STRGADGET	;gadget type
		dc.l	BorderImage1	;gadget rendering
		dc.l	0		;select rendering
		dc.l	SerAnsGadTxt	;gadget text
		dc.l	0		;mutual exclude
		dc.l	SerAnsStrInfo	;special info 
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

SerAnsGadTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	61,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	SerAnsGadText		;TEXT
		dc.l	0			;NEXTTEXT

SerAnsGadText:	dc.b	"Answer string",0
		ds.l	0

SerAnsStrInfo:	dc.l	SerAnswerStr	;Gadget Buffer
		dc.l	GadUnBuf	;Gadget Undo Buffer
		dc.w	0		;Pos in Buffer
		dc.w	30		;Max. Chars in Buffer
		dc.w	1		;Buffer Pos. of 1st disp. char
		
		dc.w	0		;Intuition takes care of these.
		dc.w	0
		dc.w	0
		dc.w	0
		dc.w	0
		dc.l	0

		dc.l	0		;Long int.
		dc.l	0		;AltKeyMap

