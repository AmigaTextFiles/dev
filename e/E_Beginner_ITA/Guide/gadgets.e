
MODULE 'intuition/intuition'

CONST GADGETBUFSIZE = 4 * GADGETSIZE

PROC main()
  DEF buf[GADGETBUFSIZE]:ARRAY, next, wptr
  next:=Gadget(buf,  NIL, 1, 0, 10, 30, 50, 'Ciao')
  next:=Gadget(next, buf, 2, 3, 70, 30, 50, 'Gente')
  next:=Gadget(next, buf, 3, 1, 10, 50, 50, 'dai')
  next:=Gadget(next, buf, 4, 0, 70, 50, 70, 'gadgets')
  wptr:=OpenW(20,50,200,100, 0, WFLG_ACTIVATE,
              'Gadgets in una window',NIL,1,buf)
  IF wptr         /* Controlla se abbiamo aperto una window */
    Delay(500)    /* Aspetta un po' */
    CloseW(wptr)  /* Chiude la window */
  ELSE
    WriteF('Errore -- non posso aprire la window!')
  ENDIF
ENDPROC
