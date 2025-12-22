/* An old E example converted to PortablE.
  From Jason R Hulance's "A Beginner's Guide to Amiga E". */

OPT POINTER
MODULE 'intuition/intuition'
MODULE 'intuition', 'dos'

CONST GADGETBUFSIZE = 4 * GADGETSIZE

PROC main()
  DEF buf[GADGETBUFSIZE]:ARRAY OF BYTE, next:ARRAY, wptr:PTR TO window
  next:=Gadget(buf,  NIL, 1, 0, 10, 30, 50, 'Hello')
  next:=Gadget(next, buf, 2, 3, 70, 30, 50, 'World')
  next:=Gadget(next, buf, 3, 1, 10, 50, 50, 'from')
  next:=Gadget(next, buf, 4, 0, 70, 50, 70, 'gadgets')
  wptr:=OpenW(20,50,200,100, 0, WFLG_ACTIVATE,
              'Gadgets in a window',NIL,1,buf !!VALUE!!PTR TO gadget)
  IF wptr         /* Check to see we opened a window */
    Delay(500)    /* Wait a bit */
    CloseW(wptr)  /* Close the window */
  ELSE
    Print('Error -- could not open window!')
  ENDIF
ENDPROC
