MODULE WobbleScreen;

(* Demo BY Robert Ennals
** demonstrates a few graphics AND screens things
** This effect should be available as a screensaver soon.
**
** This looks much nicer on fast machines than slow machines.
**
** Note that this effect can be done much faster using copper tricks
** but that isn't as safe OR nice FOR users WITH gfx cards.
** On a fast machine this routine gives acceptable speed.
*)



FROM IntuitionL         IMPORT OpenScreenTagList, CloseScreen, intuitionBase;
FROM IntuitionD         IMPORT SaTags, ScreenPtr;
FROM DosD               IMPORT ctrlC;
FROM DosL               IMPORT Delay;
FROM ExecL              IMPORT SetSignal;
FROM UtilityD           IMPORT tagEnd;
FROM GraphicsL          IMPORT BltBitMapRastPort, WaitTOF;
FROM InOut              IMPORT WriteCard;
FROM MathIEEEDoubTrans  IMPORT Cos;
FROM MathIEEEDoubBas    IMPORT Fix, Flt;
FROM SYSTEM             IMPORT SHIFT, LONGSET,TAG, ADR;
FROM Break              IMPORT TestBreak, InstallException;


VAR
    scr : ScreenPtr;
    frontscr   : ScreenPtr;
    mint        : CARDINAL;
    cycle       : LONGINT;
    ypos        : LONGINT;
    off         : LONGINT;
    diff        : LONGINT;
    olddiff     : LONGINT;
    pos         : LONGINT;
    oldpos      : LONGINT;
    sintable    : ARRAY[-32..32] OF LONGINT;
    tagBuffer   : ARRAY[0..10] OF LONGINT;


PROCEDURE GenSinTable;
VAR
    i   : LONGINT;
BEGIN
    FOR i:=-32 TO 32 DO
	sintable[i]:=Fix(Cos(Flt(i)*1.57))*32; 
	sintable[i]:=i;
    END;

END GenSinTable;


PROCEDURE NextOffset;
BEGIN
    IF pos>0 THEN
	DEC(diff);
    ELSE
	INC(diff);
    END;

    off:=sintable[pos]; 

    pos:=pos+diff;

END NextOffset;

BEGIN
    GenSinTable;
    InstallException;

    diff:=0;
    pos:=0;

    frontscr:=intuitionBase^.activeScreen;

    scr:=OpenScreenTagList(NIL, TAG(tagBuffer,
	saLikeWorkbench, 1,
	saDepth, frontscr^.rastPort.bitMap^.depth,
	saWidth, frontscr^.width,
	saHeight, frontscr^.height,
	tagEnd));

    oldpos:=-256;

    LOOP
        TestBreak;
	pos:=oldpos;
	diff:=olddiff;
	NextOffset;
	oldpos:=pos;
	olddiff:=diff;
	FOR ypos:=0 TO (scr^.height)-1 DO
	    NextOffset;
	    off:=pos;
	    off:=SHIFT(off, -3);

	    IF off<0 THEN
		BltBitMapRastPort(frontscr^.rastPort.bitMap,
			    0, ypos, ADR(scr^.rastPort), -off, ypos,
			    scr^.width+off, 1, 192);
	    ELSE
		BltBitMapRastPort(frontscr^.rastPort.bitMap,
			    off, ypos, ADR(scr^.rastPort), 0, ypos,
			    scr^.width-off, 1, 192);
	    END;
           TestBreak;
	END;
	WaitTOF;
    END;

CLOSE

    IF scr#NIL THEN CloseScreen(scr); scr:=NIL END;
END WobbleScreen.

