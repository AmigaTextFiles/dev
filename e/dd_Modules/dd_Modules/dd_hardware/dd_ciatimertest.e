-> dd_ciatimertest.e - © 1994-1995 by Digital Disturbance. Freeware.
-> Programmed by Leon Woestenberg (Email: leon@stack.urc.tue.nl)

MODULE 'exec/nodes'
MODULE 'exec/interrupts'
MODULE 'utility/tagitem'
MODULE 'hardware/cia'
MODULE 'tools/debug'

MODULE '*dd_ciatimer'
-> MODULE '*dd_ciatimer_v40'

PROC main()
  DEF cia:PTR TO ciatimer,is:is,frequency
  is::ln.succ:=NIL
  is::ln.pred:=NIL
  is::ln.type:=NT_INTERRUPT
  is::ln.pri:=0
  is::ln.name:='dd_ciatimertest'
  is.data:=NIL
  is.code:={hello}

  NEW cia
  IF cia.new([
              DDA_CIA_UseCIAA,TRUE,
              DDA_CIA_UseTimerA,FALSE,
              DDA_CIA_FallBack,TRUE,
              DDA_CIA_Interrupt,is,
              TAG_DONE
             ])

    cia.set([DDA_CIA_MicroSecs,500,TAG_DONE])
    cia.start()
    Delay(100)
    cia.stop()
  ENDIF
  END cia
ENDPROC

hello:
  BCHG.B #CIAB_LED,$bfe001                    /* lighten power LED        */
  kputstr('.')
  RTS



