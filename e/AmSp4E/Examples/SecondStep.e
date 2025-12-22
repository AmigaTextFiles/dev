/*
** Example number 2: Second Step
**
** DESCRIPTION:
** Open window and show three bobs.
** Bobs is move!
**
*/

MODULE	'*amosbobs',
	'intuition/screens'

DEF amobjects,s:PTR TO screen
DEF x1,y1,x2,y2,x3,y3,k1,k2,k3

PROC main()

	-> Open screen.
	IF (s:=OpenS(320,256,3,0,'SecondStep'))=0
		err('No screen\n');
	ENDIF

	-> Load amos objects.
	amobjects:=mLoadIB('amobjects.abk',s);

	-> set palette.
	mGetIBPalette(amobjects,s.viewport)

	-> is it?
	IF amobjects=NIL
		CloseS(s)
		err('no amobjects.abk\n');
	ENDIF

	-> k1,k2,k3
	-> is 1 - left and up.
	-> is 2 - right and up.
	-> is 3 - left and down.
	-> is 4 - right and down.

	-> coords.
	x1:=0; y1:=0; k1:=4	-> 1 bob
	x2:=160; y1:=100; k2:=2	-> 2 bob
	x3:=160; y1:=0; k3:=3	-> 3 bob

	-> simple image
	mPasteQuickIB(s.rastport,amobjects,100,100,7);

	mIBUpdateOff()
	REPEAT
			mClearIB(s.rastport,amobjects)
			-> short procedure for move.
			handlebobs();

			-> wait a moment...
			mDrawIB(s.rastport,amobjects)
			Delay(1)
	UNTIL Mouse()=1

	-> flush objects.
	mEraseIB(amobjects);

	-> and good bye ;).
	CloseS(s); CleanUp();
ENDPROC
-> ***

PROC err(name)
WriteF(name)
CleanUp(0)
ENDPROC

PROC handlebobs()

IF k1=1 ; DEC x1; DEC y1 ; ENDIF
IF k1=2 ; INC x1; DEC y1 ; ENDIF
IF k1=3 ; DEC x1; INC y1 ; ENDIF
IF k1=4 ; INC x1; INC y1 ; ENDIF

IF k2=1 ; DEC x2; DEC y2 ; ENDIF
IF k2=2 ; INC x2; DEC y2 ; ENDIF
IF k2=3 ; DEC x2; INC y2 ; ENDIF
IF k2=4 ; INC x2; INC y2 ; ENDIF

IF k3=1 ; DEC x3; DEC y3 ; ENDIF
IF k3=2 ; INC x3; DEC y3 ; ENDIF
IF k3=3 ; DEC x3; INC y3 ; ENDIF
IF k3=4 ; INC x3; INC y3 ; ENDIF

-> BOB1
IF x1<0
	IF k1=1 THEN k1:=2
	IF k1=3 THEN k1:=4
ENDIF
IF x1>280
	IF k1=2 THEN k1:=1
	IF k1=4 THEN k1:=3
ENDIF
IF y1<0
	IF k1=1 THEN k1:=3
	IF k1=2 THEN k1:=4
ENDIF
IF y1>160
	IF k1=3 THEN k1:=1
	IF k1=4 THEN k1:=2
ENDIF

-> BOB2
IF x2<0
	IF k2=1 THEN k2:=2
	IF k2=3 THEN k2:=4
ENDIF
IF x2>280
	IF k2=2 THEN k2:=1
	IF k2=4 THEN k2:=3
ENDIF
IF y2<0
	IF k2=1 THEN k2:=3
	IF k2=2 THEN k2:=4
ENDIF
IF y2>160
	IF k2=3 THEN k2:=1
	IF k2=4 THEN k2:=2
ENDIF

-> BOB3
IF x3<0
	IF k3=1 THEN k3:=2
	IF k3=3 THEN k3:=4
ENDIF
IF x3>280
	IF k3=2 THEN k3:=1
	IF k3=4 THEN k3:=3
ENDIF
IF y3<0
	IF k3=1 THEN k3:=3
	IF k3=2 THEN k3:=4
ENDIF
IF y3>160
	IF k3=3 THEN k3:=1
	IF k3=4 THEN k3:=2
ENDIF

mIB(s.rastport,amobjects,1,x1,y1,1);
mIB(s.rastport,amobjects,2,x2,y2,1);
mIB(s.rastport,amobjects,3,x3,y3,1);
mIB(s.rastport,amobjects,4,s.mousex,s.mousey,0);

ENDPROC
