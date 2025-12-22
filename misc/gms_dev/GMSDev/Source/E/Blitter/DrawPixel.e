/*
** Name:      DrawPixel
** Author:    Paul Manias
** Copyright: DreamWorld Productions (c) 1998.  All rights reserved.
*/

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures'
MODULE 'gms/files/files','gms/screens','gms/system/register','gms/system/modules'
MODULE 'gms/input/joydata','gms/graphics/screens','gms/graphics/blitter'
MODULE 'gms/blitter'

ENUM NONE,ERR_LIB,ERR_SCR,ERR_SMOD,ERR_BMOD,ERR_JOY,ERR_PIC

PROC main() HANDLE
  DEF scr       = NIL :PTR TO screen,
      joydata   = NIL :PTR TO joydata,
      pic       = NIL :PTR TO picture,
      scrmodule = NIL :PTR TO module,
      bltmodule = NIL :PTR TO module,
      oldx,oldy,oldcolour,xpos,ypos,
      background:filename

  background := [ ID_FILENAME, 'GMS:demos/data/PIC.Green' ]:filename

  IF (dpkbase:=OpenLibrary('GMS:libs/dpkernel.library',0))=NIL THEN Raise(ERR_LIB)

  IF (scrmodule:=Init([TAGS_MODULE,NIL,       ->screen-module
      MODA_NUMBER,    MOD_SCREENS,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_SMOD)
      scrbase:=scrmodule.modbase

  IF (bltmodule:=Init([TAGS_MODULE,NIL,     ->blitter-module
      MODA_NUMBER,    MOD_BLITTER,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))=NIL THEN Raise(ERR_BMOD)
      bltbase := bltmodule.modbase

  IF (pic:=Load(background,ID_PICTURE))=NIL THEN Raise(ERR_PIC)

  IF (scr:=Get(ID_SCREEN))=NIL THEN Raise(ERR_SCR)

  CopyStructure(pic,scr)

  IF (Init(scr,NIL))=NIL THEN Raise(ERR_SCR)

  IF (joydata := Init(Get(ID_JOYDATA),NIL))=NIL THEN Raise(ERR_JOY)

  Copy(pic.bitmap,scr.bitmap)

  Show(scr)

  oldx := xpos := 100
  oldy := ypos := 100

  REPEAT
    IF (oldcolour > -1) THEN DrawPixel(scr.bitmap,oldx,oldy,oldcolour)

    oldcolour := BltReadPixel(scr.bitmap,xpos,ypos)
    oldx := xpos
    oldy := ypos

    DrawPixel(scr.bitmap,xpos,ypos,3)
    WaitAVBL()
    SwapBuffers(scr)
    Query(joydata)
    xpos := xpos + joydata.xchange
    ypos := ypos + joydata.ychange
  UNTIL Mouse()=1

  Raise(NONE)

EXCEPT DO
  IF scr THEN Free(scr)
  IF pic THEN Free(pic)
  IF joydata THEN Free(joydata)
  IF scrmodule THEN Free(scrmodule)
  IF bltmodule THEN Free(bltmodule)
  CloseDPK()

  SELECT exception
    CASE ERR_LIB;  WriteF('Couldn\at open "dpkernel.library"\n')
    CASE ERR_SMOD; WriteF('Couldn\at initialize screen-module\n')
    CASE ERR_SCR;  WriteF('Couldn\at open screen\n')
    CASE ERR_BMOD; WriteF('Couldn\at initialize blitter-module\n')
  ENDSELECT

  CleanUp(0)
ENDPROC
