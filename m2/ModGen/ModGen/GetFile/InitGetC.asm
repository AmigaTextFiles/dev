;
;   Program	    :	InitGetC.s
;   Copyright	    :	© Copyright 1992 Jaba Development
;   Author	    :	Jan van den Baard
;   Creation Date   :	21-Jan-92
;   Current version :	1.1m
;   Translator	    :	A68k
;
;   REVISION HISTORY
;
;   Date	Version	  Comment
;   ---------	-------	  ------------------------------------------
;   21-Jan-92	1.0	  "GetFile" boopsi image.
;   17-Apr-95	1.1m	  [Frank Lömker] boopsi image sizeable
;

omNEW		EQU	$101
imDraw		EQU	$202
idsSelected	EQU	1

MakeClass	EQU	-678
SetAPen		EQU	-342
RectFill	EQU	-306
Move		EQU	-240
PolyDraw	EQU	-336
DrawBevelBoxA	EQU	-120
GetTagData	EQU	-36

h_Entry		EQU	8	; Hook

AreaPtrn	EQU	8	; RastPort
AreaPtSz	EQU	29

cl_Super	EQU	24	; IClass
cl_UserData	EQU	36

Width		EQU	4	; Image
Height		EQU	6
ImageData	EQU	10

dri_Pens	EQU	4	; DrawInfo

ops_AttrList	EQU	4	; opSet

imp_RPort	EQU	4	; impDraw
imp_OffsetX	EQU	8
imp_OffsetY	EQU	10
imp_State	EQU	12
imp_DrInfo	EQU	16

TAG_USER	EQU	$80000000
TAG_DONE	EQU	0
GT_TagBase	EQU	TAG_USER+$80000
GT_VisualInfo	EQU	GT_TagBase+52
GTBB_Recessed	EQU	GT_TagBase+51
IMAGE_ATTRIBUTES EQU	(TAG_USER+$20000)
IA_Width	EQU	(IMAGE_ATTRIBUTES+$0003)
IA_Height	EQU	(IMAGE_ATTRIBUTES+$0004)
TEXTPEN		EQU	2
FILLPEN		EQU	5
FILLTEXTPEN	EQU	6
BACKGROUNDPEN	EQU	7

		SECTION "InitGet",CODE

		NEAR

		XREF	_IntuitionBase
		XREF	_GfxBase
		XREF	_UtilityBase
		XREF	_GadToolsBase

		XDEF	_InitGet

; --- Initialize our private class. It set's up a class
; --- with "imageclass" as superclass.

_InitGet:	MOVEM.L	    A2/A6,-(SP)		; save registers
		MOVE.L	    _IntuitionBase(A4),A6
		SUBA.L	    A0,A0		; class ID
		LEA.L	    IClassName,A1	; points to "imageclass"
		SUBA.L	    A2,A2		; no superclass pointer
		MOVEQ	    #0,D0		; no instance data
		MOVEQ	    #0,D1		; no flags
		JSR	    MakeClass(A6)	; make the class
		MOVE.L	    D0,A0		; put class in a0
		TST.L	    D0
		BEQ.S	    noClass		; failed!!!
		LEA.L	    dispatchGet(PC),A1	; pointer to dispatcher
		MOVE.L	    A1,h_Entry(A0)	; set our dispatcher
		MOVE.L	    A4,cl_UserData(A0)
noClass:	MOVEM.L	    (SP)+,A2/A6		; restore registers
		RTS

dispatchGet:	MOVEM.L	    D2-D7/A2-A6,-(SP)	; save registers
		MOVE.L	    A0,A5		; class to a5
		MOVE.L	    cl_UserData(A5),A4
		MOVE.L	    A1,A3		; msg to a3

		CMPI.L	    #omNEW,(A3)		; user want a new object ?
		BNE.S	    noNew		; no!

		MOVE.L	    A5,A0		; class to a0
		MOVE.L	    A3,A1		; msg to a1
		BSR	    callSuper		; call the superclass
		MOVE.L	    D0,A2		; put object in a2
		BEQ.S	    newError		; failed!!!

		MOVE.L	    _UtilityBase(A4),A6
		MOVE.L	    #GT_VisualInfo,D0	; tag VisualInfo
		MOVEQ	    #0,D1		; default = NULL
		MOVE.L	    ops_AttrList(A3),A0 ; tags to a0
		JSR	    GetTagData(A6)
		MOVE.L	    D0,ImageData(A2)	; set visualInfo
		BEQ.S	    newError		; tag found ?

		MOVE.L	    #IA_Width,D0	; tag Width
		MOVEQ	    #20,D1		; default = 20
		MOVE.L	    ops_AttrList(A3),A0 ; tags to a0
		JSR	    GetTagData(A6)
		MOVE.W	    D0,Width(A2)	; set width

		MOVE.L	    #IA_Height,D0	; tag Height
		MOVEQ	    #14,D1		; default = 14
		MOVE.L	    ops_AttrList(A3),A0 ; tags to a0
		JSR	    GetTagData(A6)
		MOVE.W	    D0,Height(A2)	; set width

		MOVE.L	    A2,D0		; return Object
		BRA	    Done
newError:	MOVEQ	    #0,D0		; 0 for error
		BRA	    Done

noNew:		CMPI.L	    #imDraw,(A3)	; must we draw	?
		BNE	    default		; no!

draw:		MOVEQ	    #0,D4		; left = 0
		MOVEQ	    #0,D5		; top = 0
		MOVEQ	    #0,D6		; width = 0
		MOVEQ	    #0,D7		; height = 0

		MOVE.W	    imp_OffsetX(A3),D4	; left = x offset
		MOVE.W	    imp_OffsetY(A3),D5	; top = y offset
		MOVE.W	    Width(A2),D6	; width
		MOVE.W	    Height(A2),D7	; height

		MOVE.L	    _GfxBase(A4),A6
		MOVE.L	    imp_RPort(A3),A5	; rport to a5
		MOVE.L	    ImageData(A2),-(SP)	; visualinfo on stack

		MOVE.L	    imp_DrInfo(A3),A2	; drawinfo to a2
		MOVE.L	    dri_Pens(A2),A2	; drawinfo pens to a2

		CLR.L	    AreaPtrn(A5)	; clear area pattern
		CLR.B	    AreaPtSz(A5)

		MOVE.L	    A5,A1		; rport to a1

		CMPI.L	    #idsSelected,imp_State(A3) ; draw selected ?
		BNE.S	    noSel		; no!
		MOVE.W	    FILLPEN*2(A2),D0	; FILLPEN color
		BRA.S	    penDone
noSel:		MOVE.W	    BACKGROUNDPEN*2(A2),D0 ; BACKGROUNDPEN color
penDone:	JSR	    SetAPen(A6)		; set the pen

		MOVE.L	    A5,A1		; rport to a1
		MOVE.W	    D4,D0		; left to d0
		MOVE.W	    D5,D1		; top to d1
		MOVE.W	    D4,D2
		ADD.W	    D6,D2
		SUBQ.W	    #1,D2		; left + width - 1 to d2
		MOVE.W	    D5,D3
		ADD.W	    D7,D3
		SUBQ.W	    #1,D3		; top + height - 1 to d3
		JSR	    RectFill(A6)

		MOVE.L	    _GadToolsBase(A4),A6
		MOVE.L	    A5,A0		; rport to a0
		MOVE.L	    D4,D0		; left to d0
		MOVE.L	    D5,D1		; top to d1
		MOVE.L	    D6,D2		; width to d2
		MOVE.L	    D7,D3		; height to d3
		PEA	    TAG_DONE
		MOVE.L	    4(SP),-(SP)		; VisualInfo
		PEA	    GT_VisualInfo
		CMPI.L	    #idsSelected,imp_State(A3) ; draw recessed ?
		BNE.S	    normal
		PEA	    1			; recessed
		PEA	    GTBB_Recessed
normal:		MOVE.L	    SP,A1
		JSR	    DrawBevelBoxA(A6)	; draw the bevel box
		LEA.L	    16(SP),SP		; restore stack ptr
		CMPI.L	    #idsSelected,imp_State(A3)
		BNE.S	    ok
		ADDQ.W	    #8,SP		; restore stack a little more
ok:
		MOVE.L	    _GfxBase(A4),A6
		MOVE.L	    A5,A1		; rport to a1
		CMPI.L	    #idsSelected,imp_State(A3) ; selected text pen?
		BNE.S	    noFPen
		MOVE.W	    FILLTEXTPEN*2(A2),D0 ; FILLTEXTPEN color
		BRA.S	    setPen
noFPen:		MOVE.W	    TEXTPEN*2(A2),D0	; TEXTPEN color
setPen:		JSR	    SetAPen(A6)		; set the pen

		LEA.L	    -52(SP),SP		; create stack space
		MOVEQ	    #12,D0		; 13 XY pairs
		LEA.L	    PolyArray(PC),A1	; pointer to XY array in a1
		LEA.L	    (SP),A0		; stack ptr to a0
loopCnt:	MOVEQ	    #0,D2
		MOVEQ	    #0,D1
		MOVE.W	    (A1)+,D1		; X to d0
		CMP.W	    #(1+4),D1		; 2 lines side by side ?
		BNE.S	    notx
		SUBQ.W	    #1,D1		; yes
		MOVEQ	    #1,D2
notx:		MULU	    D6,D1
		DIVU	    #20,D1
		ADD.W	    D4,D1		; X*width div default + left
		ADD.W	    D2,D1
		MOVE.W	    D1,(A0)+		; X to (a0)+
		MOVEQ	    #0,D2
		MOVEQ	    #0,D1
		MOVE.W	    (A1)+,D1		; Y to d0
		CMP.W	    #(-5+10),D1		; 2 lines side by side ?
		BNE.S	    noty
		SUBQ.W	    #1,D1		; yes
		MOVEQ	    #1,D2
noty:		MULU	    D7,D1
		DIVU	    #14,D1
		ADD.W	    D5,D1		; Y*height div default + top
		ADD.W	    D2,D1
		MOVE.W	    D1,(A0)+		; Y to (a0)+
		DBRA	    D0,loopCnt

		MOVE.L	    A5,A1		; rport to a1
		MOVEQ	    #4,D0
		MULU	    D6,D0
		DIVU	    #20,D0		; offset*width div default
		ADD.W	    D4,D0		; left+offset
		MOVEQ	    #10,D1
		MULU	    D7,D1
		DIVU	    #14,D1		; offset*height div default
		ADD.W	    D5,D1		; top+offset
		JSR	    Move(A6)		; move to this point

		MOVE.L	    A5,A1		; rport to a1
		MOVE.L	    SP,A0		; array pointer in a0
		MOVEQ	    #13,D0		; 13 XY pairs
		JSR	    PolyDraw(A6)	; draw the lines

		LEA.L	    52(SP),SP		; restore original stackptr *)
		MOVEQ	    #1,D0		; return TRUE
		BRA.S	    Done

default:	MOVE.L	    A5,A0		; class to a0
		MOVE.L	    A3,A1		; msg to a1
		BSR	    callSuper		; call superclass
Done:		MOVEM.L	    (SP)+,D2-D7/A2-A6	; restore registers
		RTS

;  --- This routine call's this class it's super class.
;  --- First it get's the class it's super class in a0.
;  --- Then it pushes "ourRet" on the stack which will be
;  --- the return address of the superclass dispatcher.
;  --- Then it pushes the lowlevel entry of the superclass
;  --- dispatcher on the stack and performs an rts which
;  --- causes a jump to the superclass dispatcher. When the
;   --- superclass dispatcher is done it will return to "ourRet".

callSuper:	MOVE.L	    A2,-(SP)		; save a2
		MOVE.L	    cl_Super(A0),A0	; get superclass in a0
		PEA	    ourRet		; push return address
		MOVE.L	    h_Entry(A0),-(SP)	; push superclass dispatcher
		RTS				; jump to super dispatcher
ourRet:		MOVE.L	    (SP)+,A2		; restore a2
		RTS

IClassName:	DC.B	    'imageclass',0	; superclass ID
		EVEN

PolyArray:	DC.W     0+4,-6+10,1+4,-6+10,1+4,0+10,11+4,0+10
		DC.W    11+4,-6+10,9+4,-8+10,6+4,-8+10,4+4,-6+10
		DC.W     1+4,-6+10,1+4,-5+10,5+4,-5+10,6+4,-4+10
		DC.W    11+4,-4+10

		END
