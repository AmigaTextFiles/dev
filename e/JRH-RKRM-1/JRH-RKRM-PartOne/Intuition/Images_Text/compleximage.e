-> compleximage.e - Program to show the use of a complex Intuition Image.

OPT OSVERSION=37  -> E-Note: silently require V37

MODULE 'exec/memory',
       'intuition/intuition',
       'intuition/screens'

ENUM ERR_NONE, ERR_SCRN, ERR_WIN

RAISE ERR_SCRN IF OpenScreenTagList()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

CONST MYIMAGE_LEFT=0, MYIMAGE_TOP=0,
      MYIMAGE_WIDTH=24, MYIMAGE_HEIGHT=10,
      MYIMAGE_DEPTH=2

-> E-Note: get some Chip memory and copy list (quick, since LONG aligned)
PROC copyListToChip(data)
  DEF size, mem
  size:=ListLen(data)*SIZEOF LONG
  mem:=NewM(size, MEMF_CHIP)
  CopyMemQuick(data, mem, size)
ENDPROC mem

-> Main routine. Open required window and draw the images.  This routine opens
-> a very simple window with no IDCMP.  See the chapters on "Windows" and
-> "Input and Output Methods" for more info.  Free all resources when done.
PROC main() HANDLE
  DEF scr=NIL, win=NIL:PTR TO window, myImage:image
  scr:=OpenScreenTagList(NIL, [SA_DEPTH, 4, SA_PENS, [-1]:INT, NIL])
  win:=OpenWindowTagList(NIL, [WA_RMBTRAP, TRUE, WA_CUSTOMSCREEN, scr, NIL])

  -> This contains the image data.  It is a two bit-plane open rectangle which
  -> is 24 pixels wide and 10 high.  Make sure it's in CHIP memory by allocating
  -> a block of chip memory with a call like this: NewM(data_size,MEMF_CHIP),
  -> and then copy the data to that block.
  myImage:=[MYIMAGE_LEFT, MYIMAGE_TOP, MYIMAGE_WIDTH,
            MYIMAGE_HEIGHT, MYIMAGE_DEPTH,
            copyListToChip([ -> First bit-plane of data, open rectangle
                            $FFFFFF00, $C0000300, $C0000300, $C0000300,
                            $C0000300, $C0000300, $C0000300, $C0000300,
                            $C0000300, $FFFFFF00,
                             -> Second bit-plane of data, filled rectangle
                            $00000000, $00000000, $00000000, $00FF0000,
                            $00FF0000, $00FF0000, $00FF0000, $00000000,
                            $00000000, $00000000]),
            3, 0, NIL]:image  -> Use first two bit-planes, clear unused planes

  -> Draw the 1 bit-plane image into the first two bit-planes
  DrawImage(win.rport, myImage, 10, 10)

  -> Draw the same image at a new location
  DrawImage(win.rport, myImage, 100, 10)

  -> Change the image to use the second and fourth bitplanes, PlanePick is 1010
  -> binary or $0A, and draw it again at a different location
  myImage.planepick:=$0A
  DrawImage(win.rport, myImage, 10, 50)

  -> Now set all the bits in the first bitplane with PlaneOnOff.  This will
  -> make all the bits set in the second bitplane appear as color 3 (0011
  -> binary), all the bits set in the fourth bitplane appear as color 9 (1001
  -> binary) and all other pixels will be color 1 (0001 binary.  If there were
  -> any points in the image where both bits were set, they would appear as
  -> color 11 (1011 binary).  Draw the image at a different location.
  myImage.planeonoff:=$01
  DrawImage(win.rport, myImage, 100, 50)

  -> Wait a bit, then quit.
  -> In a real application, this would be an event loop, like the one described
  -> in the Intuition Input and Output Methods chapter.
  Delay(200)

EXCEPT DO
  IF win THEN CloseWindow(win)
  IF scr THEN CloseScreen(scr)
  SELECT exception
  CASE ERR_SCRN; WriteF('Error: Failed to open custom screen.\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window.\n')
  CASE "MEM";    WriteF('Error: Ran out of (chip) memory.\n')
  ENDSELECT
ENDPROC
