/*
 *
 * Boot-Picture-shower...
 *
 */


MODULE 'tools/ilbm', 'tools/ilbmdefs',
	'intuition/intuition', 'amigalib/time'

DEF scr,
	buffer[256]:ARRAY

PROC main()
DEF ilbm

	IF ilbm:=ilbm_New('c:boot.pic',0)
		ilbm_LoadPicture(ilbm,[ILBML_GETSCREEN,{scr},0])
		ilbm_Dispose(ilbm)	-> no longer needed ...

		-> this is only an example!  In a real application, always use IDCMP ports,
		-> and windows

		IF scr			-> only if one was created.

                        timeDelay(0, 10, 0)
			CloseScreen(scr)
		ENDIF
	ENDIF

ENDPROC


