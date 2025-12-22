MultiGad1	dc.l	MultiGad2	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt1	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	1		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt1	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText1		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText1	dc.b	"Gadget 1",0
		ds.l	0

MultiGad2	dc.l	MultiGad3	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+10-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt2	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	2		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt2	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText2		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText2	dc.b	"Gadget 2",0
		ds.l	0

MultiGad3	dc.l	MultiGad4	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+20-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt3	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	3		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt3	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText3		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText3	dc.b	"Gadget 3",0
		ds.l	0

MultiGad4	dc.l	MultiGad5	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+30-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt4	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	4		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt4	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText4		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText4	dc.b	"Gadget 4",0
		ds.l	0

MultiGad5	dc.l	MultiGad6	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+40-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt5	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	5		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt5	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText5		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText5	dc.b	"Gadget 5",0
		ds.l	0

MultiGad6	dc.l	MultiGad7	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+50-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt6	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	6		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt6	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText6		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText6	dc.b	"Gadget 6",0
		ds.l	0

MultiGad7	dc.l	MultiGad8	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+60-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt7	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	7		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt7	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText7		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText7	dc.b	"Gadget 7",0
		ds.l	0

MultiGad8	dc.l	MultiGad9	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+70-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt8	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	8		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt8	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText8		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText8	dc.b	"Gadget 8",0
		ds.l	0

MultiGad9	dc.l	MultiGad10	;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+80-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP ;+GADGIMAGE
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt9	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	9		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt9	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText9		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText9	dc.b	"Gadget 9",0
		ds.l	0

MultiGad10	dc.l	0		;Next Gadget
		dc.w	1		;"hit-box" left edge
		dc.w	MulTop+90-1	;"hit-box" top  edge
		dc.w	638		;"hit-box" Width
		dc.w	10		;"hit-box" Height
		dc.w	GADGHCOMP
		dc.w	RELVERIFY	;activation
		dc.w	BOOLGADGET	;gadget type
		dc.l	0		;gadget rendering
		dc.l	0		;select rendering
		dc.l	MGadTxt10	;gadget text
		dc.l	0		;mutual exclude
		dc.l	0		;special info
		dc.w	10		;gadget ID (user definable)
		dc.l	0		;ptr to general purpose user data

MGadTxt10	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	30,1			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	MGadText10		;TEXT
		dc.l	0			;NEXTTEXT
		ds.l	0
MGadText10	dc.b	"Gadget 10",0
		ds.l	0

