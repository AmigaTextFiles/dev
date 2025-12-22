/*
** LineReq.Library example.
**
** (C)Copyright 1995 By Fabio Rotondo.
**
** Contact me at: fsoft@intercom.it
**
** This is an AmigaE example program. It should be easily ported in other
** languages...
**
*/

MODULE 'libraries/linereq'

PROC main()
  /*
  ** Here we open the library
  */
  IF (linereqbase:=OpenLibrary('linereq.library',0))
    Lr_Alloc()            /* Set things up...     */
    IF Lr_SetScreen(NIL)     /* We will use WBScreen */
        IF Lr_ReqString('String Requester',
                    'Insert A string\nAnd try this wonder!',
                    'Wow! What a great lib!', 'Only good things about the lib, please!', 255)

            WriteF('You Inserted:\s\n', Lr_GetString())
        ELSE
            WriteF('Requester CANCELLED!\n')
        ENDIF

        Lr_SetFont('topaz.font', 11)
        IF Lr_ReqNumber('Number Requester',
                    'Insert how much do you like\nAmiga Computers!\n(percentage)',
                    100, NIL, 3)
          WriteF('You like it \d%!!!\n', Lr_GetValue())
        ELSE
          WriteF('Req CANCELLED!\n')
        ENDIF
    ELSE
      WriteF('Lr_SetScreen failed... no WB?\n')
    ENDIF
    Lr_Dispose()
    CloseLibrary(linereqbase)
  ENDIF
ENDPROC

