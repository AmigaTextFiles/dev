-> nsmport.e

/*
nsmport.c by Kjetil S. Matheussen
nsmport.e by Claude Heiland-Allen 1999.05.16

This doesn't fix the bug though (getoctabase() returns
non-NIL if nsmport is started but OSS hasn't been, so
the bug is probably in getoctabase()).

*/

MODULE 'exec/ports', 'amigalib/ports', 'dos/dos'

OBJECT nsmmessage
	msg      : mn
	octaaddr : LONG
ENDOBJECT

PROC main()

	DEF nsmport : PTR TO mp,
	    nsmmsg  : PTR TO nsmmessage,
	    portsig, usersig, signal, abort = FALSE,
	    localoctaaddr = NIL

	IF nsmport := createPort('nsmport', 0)
		portsig := Shl(1, nsmport.sigbit)
		usersig := SIGBREAKF_CTRL_C
		WriteF('nsmport started\n')
		REPEAT
			signal := Wait(portsig OR usersig)
			IF signal AND portsig
				WHILE nsmmsg := GetMsg(nsmport)
					IF nsmmsg.octaaddr = 0
						nsmmsg.octaaddr := localoctaaddr
        			ELSE
        				localoctaaddr := nsmmsg.octaaddr
        			ENDIF
        			ReplyMsg(nsmmsg)
        		ENDWHILE
			ENDIF
			IF signal AND usersig
				WHILE nsmmsg := GetMsg(nsmport) DO ReplyMsg(nsmmsg)
				abort := TRUE
			ENDIF
		UNTIL abort
		deletePort(nsmport)
	ELSE
		WriteF('couldn''t create "nsmport"\n')
	ENDIF

ENDPROC

version: CHAR '$VER: nsmport 1.1 (1999.05.16) Claude Heiland-Allen'
