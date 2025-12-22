/* GMS-example
 * Name: Intro.e
 * Type: Screen/Picture/Fade example
 * Version: 1.0
 * Author: G. W. Thomassen (0000272e@lts.mil.no)
 * Note: The file intro.pic is requiered to compile.
 */

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures',
       'gms/files/files','gms/screens','gms/system/register',
       'gms/system/modules','gms/input/joydata','gms/graphics/screens',
       'gms/graphics/blitter'

ENUM NONE,ERR_LIB,ERR_PIC,ERR_SCR,ERR_SCRMOD

PROC main() HANDLE
  DEF fstate=NIL:LONG,
      scr=NIL:PTR TO screen,
      pic=NIL:PTR TO picture,
      scrmodule=NIL:PTR TO module,
      picfile:filename,
      ft[30]:LIST,
      col[30]:LIST,
      up[30]:LIST,
      speed[30]:LIST,i


  -> Set up some colors and speed
  FOR i:=1 TO 30
    col[i]:=Rnd($FFFFFF)
    speed[i]:=Rnd(9)+1
    up[i]:=0
  ENDFOR

  -> Set the picture file
  picfile:=[ID_FILENAME,'GMS:Demos/Data/PIC.Intro']:filename

  -> Open the GMS-library
  IF (dpkbase:=OpenLibrary('GMS:libs/dpkernel.library',0))=NIL THEN Raise(ERR_LIB)

  -> Open (init) the screen-module
  IF (scrmodule:=Init([TAGS_MODULE,NIL,
                   MODA_NUMBER,MOD_SCREENS,
                   MODA_TABLETYPE,JMP_AMIGAE,
                   TAGEND], NIL))=NIL THEN Raise(ERR_SCRMOD)

  scrbase:=scrmodule.modbase


  -> Load the picture
  IF (pic:=Load(picfile, ID_PICTURE))=NIL THEN Raise(ERR_PIC)

  -> Put the picture on the screen

  scr:=Get(ID_SCREEN)
  CopyStructure(pic,scr)

  -> With black palette
  scr.bitmap.palette := NIL
  scr.bitmap.flags   := BMF_BLANKPALETTE

  -> Set up the screen
  IF (scr:=Init(scr,NIL))=NIL THEN Raise(ERR_SCR)

  Copy(pic.bitmap,scr.bitmap)

  -> Display the screen
  Show(scr)

  -> Fade to the picture palette
  REPEAT
    WaitAVBL()
    fstate:=ColourToPalette(scr,fstate,2,0,scr.bitmap.amtcolours-128,pic.bitmap.palette+8,$000000);
  UNTIL (fstate!=NIL)


  -> Do something silly in the main loop
  REPEAT;
    WaitAVBL()
    FOR i:=1 TO 30
      IF up[i]=0 THEN ft[i]:=PaletteToColour(scr,ft[i],speed[i],i+127,1,pic.bitmap.palette+8,col[i])
      IF up[i]=1 THEN ft[i]:=ColourMorph(scr,ft[i],speed[i],i+127,1,col[i],$000000)

      -> Set up new color when the last was reached..
      IF ft[i]=NIL
        IF up[i]=0
          up[i]:=1
        ELSE
          col[i]:=Rnd($FFFFFF)
          speed[i]:=Rnd(9)+1
          up[i]:=0
        ENDIF
      ENDIF
    ENDFOR
    WaitAVBL()
  UNTIL Mouse()=1

  -> fade to black..
  REPEAT
    WaitAVBL()
    fstate:=PaletteToColour(scr,fstate,2,0,scr.bitmap.amtcolours-128,pic.bitmap.palette+8,$000000)
    FOR i:=1 TO 30
      IF ft[i]>NIL THEN ft[i]:=ColourMorph(scr,ft[i],speed[i],i+127,1,col[i],$000000)
    ENDFOR
  UNTIL (fstate!=NIL)

  Raise(NONE)     -> Exit with no error..
-> handle errors
EXCEPT DO
  IF scr THEN Free(scr)
  IF pic THEN Free(pic)
  IF scrmodule THEN Free(scrmodule)
  CloseDPK()
  SELECT exception
  CASE ERR_LIB; WriteF('Couldn''t open library\n')
  CASE ERR_LIB; WriteF('Couldn''t open picturefile\n')
  CASE ERR_LIB; WriteF('Couldn''t open screen\n')
  CASE ERR_LIB; WriteF('Couldn''t initialize screen-module\n')  
  ENDSELECT
  CleanUp(0)
ENDPROC
