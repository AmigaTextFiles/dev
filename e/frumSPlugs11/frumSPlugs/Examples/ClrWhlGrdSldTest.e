/*
**   ((( frumSPlugs )))
** ©1996 Stephen Sinclair
**
** This source may be copied or edited in any
** way you wish.
**
** This file is part of the frumSPlugs package,
** and may only be distributed with it.
*/

/* Test for the CWGS plugin */
-> $VER: Plugins/ClrWhlGrdSldTest.e V1.0 Stephen Sinclair (96.07.18)

OPT OSVERSION=39
MODULE 'Tools/EasyGUI','*/ClrWhlGrdSld','intuition/screens'

DEF cwgs:PTR TO cwgsplugin,scr:PTR TO screen,depth

PROC main() HANDLE
/* Open a 256 colour screen, or 32 colours on non-aga */
  depth:=8
  IF isaga()=FALSE THEN depth:=5
  scr:=OpenScreenTagList(NIL,[SA_WIDTH,IF depth=5 THEN 320 ELSE 640,        -> if not aga, then 320 width, else 640.
                              SA_HEIGHT,400,SA_DEPTH,depth,
                              SA_DISPLAYID,IF depth=5 THEN 4 ELSE 102404,   -> if not aga, then interlaced display, else hires-interlaced
                              SA_TITLE,'ClrWhlGrdSld Test',
                              SA_SHAREPENS,TRUE,
                              NIL,NIL])
  IF scr=NIL THEN Raise(" SCR")
  easygui('ColorWheel & Gradient Slider',
    [ROWS,
      [TEXT,'Edit Colour:',NIL,FALSE,STRLEN],
/* 15 colour palette */
      [PALETTE,{chgcol},NIL,4,5,10],
/* here is the colorwheel and the gradientslider */
      [PLUGIN,0,NEW cwgs.cwgsplugin(0,TRUE,NIL,15,15,256)],
      [EQCOLS,
        [BUTTON,0,'Okay'],
        [BUTTON,{revertproc},'Revert']
      ]
    ],0,scr)
EXCEPT DO
  END cwgs
  IF scr THEN CloseScreen(scr)
  IF exception <> 0 THEN WriteF('\s\n',[exception,0])
ENDPROC

CHAR '$VER: Plugins/ClrWhlGrdSldTest V1.0 Stephen Sinclair (96.07.18)'

PROC revertproc(x) IS cwgs.revert(),x

PROC chgcol(x,v) IS cwgs.changecolour(v),x

/* detect aga chipset - code from AGA doc V2.5 by RANDY of COMAX */
PROC isaga()
	LEA	    $DFF000,A3
	MOVE.W	$7C(A3),D0	          -> DeniseID or LisaID in AGA
	MOVEQ	  #30,D2                -> Check 30 times ( prevents old denise random)
	ANDI.W	#%000000011111111,D0	-> low byte only
denloop:
	MOVE.W	$7C(A3),D1	          -> Denise ID (LisaID on AGA)
	ANDI.W	#%000000011111111,D1	-> low byte only
	CMP.B	  D0,D1                 -> same value?
	BNE.S	  notaga	              -> Not the same value, then OCS Denise!
	DBRA	  D2,denloop	          -> (THANX TO DDT/HBT FOR MULTICHECK HINT)
	ORI.B	  #%11110000,D0         -> MASK AGA REVISION (will work on new aga)
	CMPI.B	#%11111000,D0	        -> BIT 3=AGA (this bit will be=0 in AAA!)
	BNE.S	  notaga		            -> IS THE AGA CHIPSET PRESENT?
  RETURN  TRUE
notaga:				                  -> NOT AGA, BUT IS POSSIBLE AN AAA MACHINE!!
  RETURN  FALSE
ENDPROC
