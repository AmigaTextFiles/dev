/* GMS-example
 * Name:    RamboWorm.e
 * Type:    Blitter example (converted from RamboWorm.c)
 * Version: 1.0
 * Author:  G. W. Thomassen (0000272e@lts.mil.no)
 */

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures','gms/files/files',
       'gms/screens','gms/system/register','gms/system/modules','gms/input/joydata',
       'gms/graphics/screens','gms/blitter','gms/graphics/blitter'

ENUM NONE,ERR_LIB,ERR_SMOD,ERR_BMOD,ERR_JOY,ERR_SCR,
     ERR_LOAD,ERR_RESTORE,ERR_BOB

DEF scr    :PTR TO screen,
    joy    :PTR TO joydata,
    rstore :PTR TO restore,
    scrmod :PTR TO module,
    bltmod :PTR TO module,
    worm   :PTR TO bob,
    back   :PTR TO picture,
    backfile   :PTR TO filename,
    bobfile    :PTR TO filename,
    wormframes :PTR TO framelist

PROC init_all()
  backfile := [ ID_FILENAME,'GMS:demos/data/PIC.Green' ]:filename
  bobfile  := [ ID_FILENAME,'GMS:demos/data/PIC.Rambo' ]:filename

  wormframes:=[0,0, 32,0, 64,0, 96,0, 128,0, 160,0, 192,0, 224,0,
               256,0, 288,0, 0,48, 32,48, 64,48, -1,-1]:framelist

  IF (dpkbase:=OpenLibrary('GMS:libs/dpkernel.library',0))=NIL THEN Raise(ERR_LIB)

  IF (scrmod:=Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_SCREENS,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_SMOD)
      scrbase:=scrmod.modbase

  IF (bltmod:=Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_BLITTER,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_BMOD)
      bltbase:=bltmod.modbase

  IF (joy:=Init(Get(ID_JOYDATA),NIL))=NIL THEN Raise(ERR_JOY)

  IF (back:=Load(backfile,ID_PICTURE))=NIL THEN Raise(ERR_LOAD)

  IF (scr:=Get(ID_SCREEN))=NIL THEN Raise(ERR_SCR)
ENDPROC

PROC main() HANDLE
  init_all()

  CopyStructure(back,scr)
  scr.attrib := SCR_DBLBUFFER

  IF (Init(scr,NIL))=NIL THEN Raise(ERR_SCR)

  Copy(back.bitmap,scr.bitmap)

  CopyBuffer(scr,BUFFER2,BUFFER1)

  IF (rstore:=Init([TAGS_RESTORE,NIL,
                    RSA_Entries,1,
                    TAGEND],scr))=NIL THEN Raise(ERR_RESTORE)

  IF (worm:=Init([TAGS_BOB,NIL,
                  BBA_GfxCoords,wormframes,
                  BBA_Width, 32,
                  BBA_Height,24,
                  BBA_XCoord,150,
                  BBA_YCoord,150,
                  BBA_Attrib, BBF_RESTORE OR BBF_GENMASKS OR BBF_CLIP,
                    BBA_SourceTags, ID_PICTURE,
                    PCA_Source,     bobfile,
                      PCA_BitmapTags, NIL,
                      BMA_MemType,    MEM_BLIT,
                      TAGEND,NIL,
                    TAGEND,NIL,
                  TAGEND],scr))=NIL THEN Raise(ERR_BOB)

  Show(scr)

  demo()

  Raise(NONE)
EXCEPT DO
  IF joy THEN Free(joy)
  IF worm THEN Free(worm)
  IF rstore THEN Free(rstore)
  IF scr THEN Free(scr)
  IF back THEN Free(back)
  IF bltmod THEN Free(bltmod)
  IF scrmod THEN Free(scrmod)
  CloseDPK()
  SELECT exception
  CASE ERR_LIB; WriteF('Error: Opening dpkernel.library\n')
  CASE ERR_SMOD; WriteF('Error: Init() (Screen-module)\n')
  CASE ERR_BMOD; WriteF('Error: Init() (Blitter-module)\n')
  CASE ERR_JOY; WriteF('Error: Init() (JoyData-object)\n')
  CASE ERR_SCR; WriteF('Error: Opening screen\n')
  CASE ERR_LOAD; WriteF('Error: Loading background-picture\n')
  CASE ERR_RESTORE; WriteF('Error: Init() (Restore-object)\n')
  CASE ERR_BOB; WriteF('Error: Init() (Blitter Object)\n')
  ENDSELECT
  CleanUp(0)
ENDPROC

PROC demo()
  DEF anim=0,fire=FALSE,frame,
      x1,x2,y1,y2,ax1,ax2,ay1,ay2

  REPEAT
    Activate(rstore)
    DrawBob(worm)
    WaitAVBL()
    SwapBuffers(scr)

    INC anim  
    IF (fire=FALSE)
      IF (anim>5)
        anim:=0
        
        frame:=worm.frame
        INC frame
        worm.frame:=frame

        IF (worm.frame>9) THEN worm.frame:=0
      ENDIF
    ELSEIF (anim>1)
      IF (worm.frame<10) THEN worm.frame:=9

      frame:=worm.frame
      INC frame
      worm.frame:=frame
      IF (worm.frame>12)
        IF (joy.buttons AND JD_LMB)
          worm.frame:=11
        ELSE
          worm.frame:=0
          fire:=FALSE
        ENDIF
      ENDIF
    ENDIF
    Query(joy)
    worm.xcoord:=worm.xcoord+joy.xchange
    worm.ycoord:=worm.ycoord+joy.ychange
    wrap(worm)

    IF (joy.buttons AND JD_LMB) THEN fire:=TRUE
  UNTIL (joy.buttons AND JD_RMB)

  /* Screenwipe effect.. (sometimes ;^) )*/

  IF (FastRandom(5)=4)
    ax1:=x1:=(scr.width-scr.height)/2
    ay1:=y1:=NIL

    ax2:=x2:=scr.width-((scr.width-scr.height)/2)
    ay2:=y2:=scr.height

    REPEAT
      DrawLine(scr.bitmap,x1,y1,x2,y2,0,$ffffffff)
      DrawLine(scr.bitmap,ax1,ay1,ax2,ay2,0,$ffffffff)
      DrawLine(scr.bitmap,x1+1,y1,x2+1,y2,0,$ffffffff)
      DrawLine(scr.bitmap,ax1+1,ay1,ax2+1,ay2,0,$ffffffff)
      WaitAVBL()
      SwapBuffers(scr)
      
      DrawLine(scr.bitmap,x1,y1,x2,y2,0,$ffffffff)
      DrawLine(scr.bitmap,ax1,ay1,ax2,ay2,0,$ffffffff)
      DrawLine(scr.bitmap,x1+1,y1,x2+1,y2,0,$ffffffff)
      DrawLine(scr.bitmap,ax1+1,ay1,ax2+1,ay2,0,$ffffffff)
      WaitAVBL()
      SwapBuffers(scr)

      x1:=x1+2; x2:=x2+2
      ax1:=ax1-2; ax2:=ax2-2
    UNTIL (x1>=scr.width)
  ENDIF
ENDPROC

PROC wrap(bb:PTR TO bob)
  IF (bb.xcoord < (bb.width*-1))        THEN bb.xcoord:=bb.destbitmap.width
  IF (bb.xcoord > bb.destbitmap.width)  THEN bb.xcoord:=-bb.width
  IF (bb.ycoord < (bb.height*-1))       THEN bb.ycoord:=bb.destbitmap.height
  IF (bb.ycoord > bb.destbitmap.height) THEN bb.ycoord:=-bb.height
ENDPROC
