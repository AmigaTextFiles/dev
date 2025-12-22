MODULE '*modules/lucyplay','*modules/libraries/lucyplay'

DEF smp:PTR TO lucyplaysample,
		a,
		argz:PTR TO LONG

PROC main()

argz:=[0]

WriteF('lucyplay example in E\nBy Emil Oppeln Bronikowski ( opi@supersonic.plukwa.net )\n')

IF (a:=ReadArgs('NAME/A',argz,NIL))
	IF (lucyplaybase:=OpenLibrary('lucyplay.library',2))
		IF LucAudioInit()
			IF (smp:=LucAudioLoad(argz[0]))
				LucAudioPlay(smp)
				LucAudioWait()
        WriteF('ok :-)\n')
			ELSE
				WriteF('can\at play sample!\n')
			ENDIF
		ELSE
			WriteF('can\at load sample!\n')
		ENDIF
	ELSE
		WriteF('can\at open library lucyplay.library +2\n')
	ENDIF
ELSE
	WriteF('required argument missing\n')
ENDIF

IF lucyplaybase THEN CloseLibrary(lucyplaybase)
IF a THEN FreeArgs(a)

ENDPROC
