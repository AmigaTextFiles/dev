/* moves the mouse on screen 'scr' to position (x,y)
** Needs at least intuition V36
*/

OPT MODULE
OPT REG=5

MODULE 'devices/input','devices/inputevent',
       'exec/io','exec/ports','exec/memory'

/* would look much better with exceptions but isn't really
** necessary here and would also make the generated code bigger.
**
** It would also be good to use E's memory pool for allocating the inputevent
** and iepointerpixel memory but FastNew() don't set flags
** MEMF_PUBLIC.
*/
EXPORT PROC moveMousePointer(scr,x,y,rel=FALSE)
DEF inputio:PTR TO iostd,
    inputmp:PTR TO mp,
    fakeevent:PTR TO inputevent,
    neopix:PTR TO iepointerpixel

  IF scr
    IF inputmp:=CreateMsgPort()
      IF fakeevent:=AllocMem(SIZEOF inputevent,MEMF_PUBLIC)
        IF neopix:=AllocMem(SIZEOF iepointerpixel,MEMF_PUBLIC)
          IF inputio:=CreateIORequest(inputmp,SIZEOF iostd)
            IF OpenDevice('input.device',0,inputio,0)=0

              neopix.screen    := scr
              neopix.positionx := x
              neopix.positiony := y

              fakeevent.eventaddress := neopix                                       /* IEPointerPixel */
              fakeevent.nextevent    := NIL
              fakeevent.class        := IECLASS_NEWPOINTERPOS                        /* new pointer pos */
              fakeevent.subclass     := IESUBCLASS_PIXEL
              fakeevent.code         := IECODE_NOBUTTON
              fakeevent.qualifier    := IF rel THEN IEQUALIFIER_RELATIVEMOUSE ELSE 0 /* relative/absolute positioning */

              inputio.data    := fakeevent
              inputio.length  := SIZEOF inputevent
              inputio.command := IND_WRITEEVENT
              DoIO(inputio)

              CloseDevice(inputio)
            ENDIF
            DeleteIORequest(inputio)
          ENDIF
          FreeMem(neopix,SIZEOF iepointerpixel)
        ENDIF
        FreeMem(fakeevent,SIZEOF inputevent)
      ENDIF
      DeleteMsgPort(inputmp)
    ENDIF
  ENDIF

ENDPROC

