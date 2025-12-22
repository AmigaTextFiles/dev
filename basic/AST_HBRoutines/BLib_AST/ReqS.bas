' ---------------------------------------------------------------------------------------

REM ** $VER: ReqS.bas 1.0 (20.02.2010) by AmiSpaTra

REM **
' LIBRARY OPEN "intuition.library",36&

' REM $include intuition.bh
' REM $include exec.bc
 
REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION ReqS&(BYVAL win&, BYVAL trq$, BYVAL brq$, BYVAL butrq$,BYVAL args&)
  LOCAL es$

	trq$   = trq$   + CHR$(0)
	brq$   = brq$   + CHR$(0)
	butrq$ = butrq$ + CHR$(0)

	IF PEEKW(LIBRARY("intuition.library")+lib_Version%) < 36 THEN

		'itt$ = STRING$(IntuiText_sizeof%,CHR$(0))
		'itp$ = STRING$(IntuiText_sizeof%,CHR$(0))
		'itn$ = STRING$(IntuiText_sizeof%,CHR$(0))

		'ReqS& = AutoRequest&(win&,SADD(itt$),SADD(itp$),SADD(itn$),pFlag&,nFlag&,ExtNewScreenwidth&,ExtNewScreenheight&)

		ERROR 5
		
	ELSE

		es$=STRING$(EasyStruct_sizeof%,CHR$(0))

		POKEL SADD(es$),EasyStruct_sizeof%

		IF trq$ <> CHR$(10)+CHR$(0) THEN
			POKEL SADD(es$)+es_Title%,    SADD(trq$)
		END IF	

		POKEL SADD(es$)+es_TextFormat%,   SADD(brq$)
		POKEL SADD(es$)+es_GadgetFormat%, SADD(butrq$)

		ReqS& = EasyRequestArgs&(win&,SADD(es$),0&,args&)

	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
