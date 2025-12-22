' identify-example 3
' Version : $Id: identify_3.bas V0.9
' Compiler:	HBC 2.0+
' Includes:	3.1
' Author:   steffen@styx.muc.de
' Status:   Freeware

'******************************************************************************

DEFLNG a-z

REM $JUMPS
REM $NOWINDOW
REM $NOLIBRARY
REM $NOSTACK
REM $NOARRAY
REM $NOLINES
REM $NOVARCHECKS
REM $NOAUTODIM
 
REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE utility.bh
REM $INCLUDE identify.bh

LIBRARY OPEN "identify.library"

WINDOW 1,"Identify.library Example 3 [Press ESC to Exit]",,23

'******************************************************************************

DIM tags&(20&)
	
deadb$ = STRING$(IDENTIFYBUFLEN&, 0%)
subsb$ = STRING$(IDENTIFYBUFLEN&, 0%)
gensb$ = STRING$(IDENTIFYBUFLEN&, 0%)
specb$ = STRING$(IDENTIFYBUFLEN&, 0%)
	
TAGLIST VARPTR(tags&(0&)), _
	IDTAG_Localize&,	TRUE&, _
	IDTAG_DeadStr&,		SADD(deadb$), _
	IDTAG_SubsysStr&,	SADD(subsb$), _
	IDTAG_GeneralStr&,	SADD(gensb$), _
	IDTAG_SpecStr&,		SADD(specb$), _
TAG_END&


REPEAT mainloop
   
	PRINT "Alertcode (HEX): &H";
   	
   	WHILE LEN(guru$) <> 8
    	e$ = INPUT$(1)
    	SELECT CASE e$
    		CASE CHR$(8)
    			IF LEN(guru$)
    				PRINT e$;
	    			guru$ = LEFT$(guru$, LEN(guru$) - 1)
	    		END IF
    		CASE CHR$(13)
    			IF guru$ = ""
    				EXIT mainloop
    			END IF
    		CASE CHR$(27)
    			EXIT mainloop
    		CASE "0" TO "9", "A" TO "F"
    			PRINT e$;
    			guru$ = guru$ + e$
    		CASE "a" TO "f"
    			e$ = UCASE$(e$)
    			PRINT e$;
    			guru$ = guru$ + e$
    	END SELECT
    WEND
    	
   	IF IdAlert&(VAL("&H" + guru$), VARPTR(tags&(0&))) = IDERR_OKAY&
      
		PRINT
		PRINT "      AlertType: ";PEEK$(SADD(deadb$))
		PRINT "      Subsystem: ";PEEK$(SADD(subsb$))
		PRINT "        General: ";PEEK$(SADD(gensb$))
		PRINT "       Specific: ";PEEK$(SADD(specb$))
   		PRINT
   		guru$ = ""
   	ELSE
   		PRINT "IdAlert failed."
   		SLEEP
   		SYSTEM RETURN_FAIL&
   	END IF

END REPEAT mainloop

SYSTEM RETURN_OK&

'******************************************************************************

DATA "$VER: identify_3 V0.9 (05-08-98) "