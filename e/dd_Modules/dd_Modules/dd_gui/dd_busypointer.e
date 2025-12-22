->
-> dd_busypointer.e - window busypointer class
->
-> Copyrights © 1995 by Leon `LikeWise' Woestenberg, Digital Disturbance.
-> All Rights Reserved
->
-> FOLDER opts
OPT MODULE
-> ENDFOLDER
-> FOLDER modules
MODULE 'intuition/intuition'
MODULE 'utility/tagitem'
MODULE 'exec/memory'
-> ENDFOLDER
-> FOLDER classes
EXPORT OBJECT busypointer
  PRIVATE
  window:PTR TO window
ENDOBJECT
-> ENDFOLDER
-> FOLDER defs
DEF busySprite:PTR TO INT,usecount
-> ENDFOLDER

-> FOLDER new
EXPORT PROC new(window=NIL) OF busypointer

  -> Remember window we should act on.
  self.window:=window

  -> A pre v39 system?
  IF (KickVersion(39)=FALSE)

    -> Increase the busycount to allow nested calls.
    usecount:=usecount+1
    -> Only act when this class (not object!) is used for the first time.
    IF usecount=1

      -> If the busySprite is not yet in chip memory, we must take care
      -> of that ourselves.
      IF (TypeOfMem({busySpriteData}) AND MEMF_CHIP)=0

        -> Allocate chip memory for the pointer sprite.
        busySprite:=AllocMem(72,MEMF_CHIP)
        IF busySprite

          -> Copy the busySprite to chip memory. Positions and length
          -> are longword alligned, so we use the CopyMemQuick one.
          CopyMemQuick({busySpriteData},busySprite,72)

        -> We are out of chip memory here. I guess we can't do much here,
        -> the user will have to live without busy pointer functionality.
        ELSE
        ENDIF
      ELSE

        -> The busySprite already is in chip memory.
        busySprite:={busySpriteData}

      ENDIF
    ENDIF
  ENDIF
ENDPROC
-> ENDFOLDER
-> FOLDER end
EXPORT PROC end() OF busypointer

  -> A pre v39 system?
  IF KickVersion(39)=FALSE

    usecount:=usecount-1
    -> We only act if this class (not object!) becomes unused.
    IF usecount=0

      -> Check if we have copied the busy pointer to another location.
      -> If so, we will have to free that copy ourselves.
      IF busySprite<>{busySpriteData}

        -> Free the chip memory involved.
        FreeMem(busySprite,72)

        -> And clear the chip memory pointer.
        busySprite:=NIL

      ENDIF
    ENDIF
  ENDIF

  -> Forget the window we did belong to.
  self.window:=NIL

ENDPROC
-> ENDFOLDER
-> FOLDER busy
EXPORT PROC busy() OF busypointer

  -> window valid?
  IF self.window

    -> v39+ system?
    IF KickVersion(39)

      -> Set window busy pointer using v39+ system function.
      SetWindowPointerA(self.window,[WA_BUSYPOINTER,TRUE,WA_POINTERDELAY,TRUE,TAG_DONE])

    -> This is a pre v39 system. We supply our own busypointer.
    ELSE

      -> Set our busy pointer.
      IF busySprite THEN SetPointer(self.window,busySprite,16,16,-6,0)

    ENDIF
  ENDIF
ENDPROC
-> ENDFOLDER
-> FOLDER unbusy
EXPORT PROC unbusy() OF busypointer

  -> window valid?
  IF self.window
    -> v39+ system?
    IF KickVersion(39)

      -> Clear busy pointer using v39 system function.
      SetWindowPointerA(self.window,NIL)

    -> pre v39 system
    ELSE

      -> Clear the busy pointer from our window.
      ClearPointer(self.window)

    ENDIF
  ENDIF
ENDPROC
-> ENDFOLDER

-> FOLDER busySpriteData

  -> We keep the busypointer data longword alligned. This way we can use
  -> quick memory copy operations.
  LONG "BUSY"

  -> A copy of the actual busypointer sprite.
  busySpriteData:
  INT $0000,$0000,$0400,$07c0
  INT $0000,$07c0,$0100,$0380
  INT $0000,$07e0,$07c0,$1ff8
  INT $1ff0,$3fec,$3ff8,$7fde
  INT $3ff8,$7fbe,$7ffc,$ff7f
  INT $7efc,$ffff,$7ffc,$ffff
  INT $3ff8,$7ffe,$3ff8,$7ffe
  INT $1ff0,$3ffc,$07c0,$1ff8
  INT $0000,$07e0,$0000,$0000
-> ENDFOLDER
