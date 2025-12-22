/*
** Example number 1: First Step
**
** DESCRIPTION:
** Open window and show only one bob.
** Bob is moved!
**
*/

-> *** Modules...
MODULE	'*amosbobs',
	'intuition/intuition'

DEF amobjects,i,w:PTR TO window

PROC main()

	-> Load amos objects.
	amobjects:=mLoadIB('amobjects.abk');

	-> is it?
	IF amobjects=NIL
		err('no amobjects.abk\n');
	ENDIF

	w:=OpenW(80,80,400,100,0,WFLG_GIMMEZEROZERO,NIL,0,1,0);

	LOOP
		-> Move bob (RIGHT).
		FOR i:=10 TO 90

			-> Add bob to memory.
			mIB(w.rport,amobjects,1,i,30,1,TRUE);
			    -> if TRUE in 7 argument to object is from window.

			m()

		ENDFOR

		-> Move bob (LEFT).
		FOR i:=90 TO 10 STEP -1

			-> Add bob to memory.
			mIB(w.rport,amobjects,1,i,30,1,TRUE);
			    -> if TRUE in 7 argument to object is from window.

			m()

		ENDFOR

	ENDLOOP
ENDPROC
-> ***

PROC m()
Delay(2)
mDrawIB(w.rport,amobjects)
IF Mouse()=2
	-> flush objects.
	mEraseIB(amobjects); CloseW(w) ; CleanUp();
ENDIF
ENDPROC

PROC err(name)
WriteF(name)
CleanUp(0)
ENDPROC
