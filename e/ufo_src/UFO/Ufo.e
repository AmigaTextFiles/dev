->* Første forsøk på total bruka av MBob.(32 frames)
->* Startet: 14.april 1998
->* Klokka: 0:49
->* Versjon: 0.12
->* Siste oppdatering: 21.april 1998

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures','gms/files/files',
       'gms/screens','gms/system/register','gms/system/modules','gms/input/joydata',
       'gms/graphics/screens','gms/blitter','gms/graphics/blitter'

ENUM NONE,ERR_LIB,ERR_SMOD,ERR_BMOD,ERR_JOY,ERR_SCR,
     ERR_LOAD,ERR_RESTORE,ERR_BOB,ERR_PIC,ERR_NBE

CONST AMT_IMAGES=10,
      MBE_SIZEOF=SIZEOF mbentry

DEF scr        :PTR TO screen,
    tmpscr     :PTR TO screen,
    joy        :PTR TO joydata,
    rstore     :PTR TO restore,
    scrmod     :PTR TO module,
    bltmod     :PTR TO module,
    ship       :PTR TO mbob,
    back       :PTR TO picture,
    backfile   :PTR TO filename,
    shipfile   :PTR TO filename,
    shipframes :PTR TO framelist,
    shippic    :PTR TO picture,
    simages    :PTR TO mbentry

DEF shield,
    energy,
    xpos,ypos,
    frame=0

PROC init_all()
  backfile := [ID_FILENAME, 'Gfx/PANEL001.Hi' ]:filename
  shipfile := [ID_FILENAME, 'Ships/Ship001/UFO001.Hi' ]:filename

  shipframes:=[  48,0,  1*48,0,  2*48,0,  3*48,0,  4*48,0,  5*48,0,  6*48,0,  7*48,0,  8*48,0,  9*48,0,  10*48,0,  11*48,0,  12*48,0,  13*48,0,
                 48,20, 1*48,20, 2*48,20, 3*48,20, 4*48,20, 5*48,20, 6*48,20, 7*48,20, 8*48,20, 9*48,20, 10*48,20, 11*48,20, 12*48,20, 13*48,20,
                 48,40, 1*48,40, 2*48,40, 3*48,40, -1,-1]:framelist

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

  IF (tmpscr:=scr:=Init([TAGS_SCREEN, NIL,
       GSA_BitmapTags, NIL,
       BMA_AmtColours, 64,
       TAGEND, NIL,
       TAGEND],NIL))=NIL THEN Raise(ERR_SCR)

  IF (joy := Get(ID_JOYDATA))=NIL THEN Raise(ERR_JOY)
  joy.port:= 2
  IF (Init(joy,NIL))=NIL THEN Raise(ERR_JOY)

  IF (back:=Load(backfile,ID_PICTURE))=NIL THEN Raise(ERR_LOAD)
  IF (scr:=Get(ID_SCREEN))=NIL THEN Raise(ERR_SCR)
ENDPROC

PROC main() HANDLE
  WriteF('Loading...')
  init_all()

  CopyStructure(back,scr)
  scr.attrib  := SCR_DBLBUFFER

  IF (Init(scr,NIL))=NIL THEN Raise(ERR_SCR)
  Copy(back.bitmap,scr.bitmap)

  IF tmpscr THEN Free(tmpscr)

  Copy(back.bitmap,scr.bitmap)
  CopyBuffer(scr,BUFFER2,BUFFER1)

  IF (rstore:=Init([TAGS_RESTORE,NIL,
                    RSA_Entries,AMT_IMAGES,
                    RSA_Buffers,2,
                    TAGEND],scr))=NIL THEN Raise(ERR_RESTORE)

  -> MBob-start
  IF (shippic:=Init([TAGS_PICTURE,NIL,
                     PCA_Source,shipfile,
                       PCA_BitmapTags, NIL,
                       BMA_MemType,    MEM_BLIT,
                       TAGEND,         NIL,
                     TAGEND],NIL))=NIL THEN Raise(ERR_PIC)

  IF (simages:=AllocMemBlock(MBE_SIZEOF*AMT_IMAGES,MEM_DATA))=NIL THEN Raise(ERR_NBE)

  IF (ship:=Init([TAGS_MBOB,NIL,
                  MBA_AmtEntries, AMT_IMAGES,
                  MBA_GfxCoords,  shipframes,
                  MBA_Width,      40,
                  MBA_Height,     20,
                  MBA_Attrib,     BBF_RESTORE OR BBF_GENMASKS OR BBF_CLIP,
                  MBA_Source,     shippic,
                  MBA_EntrySize,  MBE_SIZEOF,
                  MBA_EntryList,  simages,
                  TAGEND],scr))=NIL THEN Raise(ERR_BOB)

  Show(scr)

  demo()

  Raise(NONE)
EXCEPT DO
  IF (joy)     THEN Free(joy)
  IF (ship)    THEN Free(ship)
  IF (simages) THEN FreeMemBlock(simages)
  IF (rstore)  THEN Free(rstore)
  IF (scr)     THEN Free(scr)
  IF (back)    THEN Free(back)
  IF (shippic) THEN Free(shippic)
  IF (bltmod)  THEN Free(bltmod)
  IF (scrmod)  THEN Free(scrmod)
  CloseDPK()

  SELECT exception
    CASE ERR_LIB;     WriteF('\nError: Opening dpkernel.library\n')
    CASE ERR_SMOD;    WriteF('\nError: Init() (Screen-module)\n')
    CASE ERR_BMOD;    WriteF('\nError: Init() (Blitter-module)\n')
    CASE ERR_JOY;     WriteF('\nError: Init() (JoyData-object)\n')
    CASE ERR_SCR;     WriteF('\nError: Opening screen\n')
    CASE ERR_LOAD;    WriteF('\nError: Loading background-picture\n')
    CASE ERR_RESTORE; WriteF('\nError: Init() (Restore-object)\n')
    CASE ERR_BOB;     WriteF('\nError: Init() (Blitter Object)\n')
    CASE NONE;        WriteF('\nUser Exit\n')
  ENDSELECT
  CleanUp(0)
ENDPROC

PROC updatepanel()
  shield:=1
  energy:=1
ENDPROC

PROC demo()
  DEF anim=0,key,
      keystr[2]:STRING,
      speed=0,
      -> compute speed vars
      rangle,step,rframe,xadd,
      yadd,arcconst,arcangle,
      lastframe

  -> NOTE! 360/AntFrames
  step:=11.25

  setup_bobs()
  xpos := simages[0].xcoord!
  ypos := simages[0].ycoord!

  lastframe:=17
  REPEAT
    Activate(rstore)
    DrawBob(ship)
    WaitAVBL()
    SwapBuffers(scr)

    Query(joy)

    IF (joy.xchange < 0) THEN anim := -1
    IF (joy.xchange > 0) THEN anim := 1
    IF (joy.ychange < 0) THEN INC speed
    IF (joy.ychange > 0) THEN speed := 0

    IF (anim <> 0)
      IF (anim  = -1) THEN DEC frame
      IF (anim  = 1)  THEN INC frame
      IF (frame > 31) THEN frame:=0
      IF (frame < 0)  THEN frame:=31
      simages[0].frame := frame
    ENDIF

    anim:=0

    IF (speed > 0)
      IF (lastframe = simages[0].frame) THEN JUMP noframe
      lastframe := simages[0].frame

      rframe := simages[0].frame!
      rangle := !step*rframe
      IF (rangle = 0.0)
        arcangle := 0.0
        JUMP noangle
      ENDIF
      arcconst := !180.00/rangle
      arcangle := !3.14/arcconst

      noangle:
      xadd := Fcos(arcangle)
      yadd := Fsin(arcangle)
      xadd := (xadd*-1.0)*1.0
      yadd := (yadd*-1.0)*1.0
      noframe:
    ENDIF

    xpos:=!xpos+xadd
    ypos:=!ypos+yadd

    IF !xpos < (-ship.width!)  THEN xpos:=scr.width!
    IF !xpos > (scr.width!)    THEN xpos:=(-ship.width!)
    IF !ypos < (-ship.height!) THEN ypos:=scr.height!
    IF !ypos > (scr.height!)   THEN ypos:=(-ship.height!)

    simages[0].xcoord := !xpos!
    simages[0].ycoord := !ypos!

  UNTIL (joy.buttons AND JD_FIRE1)

  updatepanel()
ENDPROC

PROC setup_bobs()
  DEF i

  simages[0].xcoord := 150
  simages[0].ycoord := 150
  simages[0].frame  := 0

  FOR i:=1 TO AMT_IMAGES
    simages[i].xcoord := FastRandom(scr.width)
    simages[i].ycoord := FastRandom(scr.height)
    simages[i].frame  := FastRandom(31)
  ENDFOR
ENDPROC

