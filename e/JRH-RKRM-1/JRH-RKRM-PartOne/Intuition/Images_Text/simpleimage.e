-> simpleimage.e - Program to show the use of a simple Intuition Image.

OPT OSVERSION=37  -> E-Note: silently require V37

MODULE 'exec/memory',
       'intuition/intuition'

ENUM ERR_NONE, ERR_WIN

RAISE ERR_WIN IF OpenWindowTagList()=NIL

CONST MYIMAGE_LEFT=0, MYIMAGE_TOP=0,
      MYIMAGE_WIDTH=24, MYIMAGE_HEIGHT=10,
      MYIMAGE_DEPTH=1

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
  DEF win=NIL:PTR TO window, myImage:image
  win:=OpenWindowTagList(NIL, [WA_WIDTH,   200,
                               WA_HEIGHT,  100,
                               WA_RMBTRAP, TRUE,
                               NIL])

  -> This contains the image data.  It is a one bit-plane open rectangle which
  -> is 24 pixels wide and 10 high.  Make sure it's in CHIP memory by allocating
  -> a block of chip memory with a call like this: NewM(data_size,MEMF_CHIP),
  -> and then copy the data to that block.
  myImage:=[MYIMAGE_LEFT, MYIMAGE_TOP, MYIMAGE_WIDTH,
            MYIMAGE_HEIGHT, MYIMAGE_DEPTH,
            copyListToChip([$FFFFFF00, $C0000300, $C0000300, $C0000300,
                            $C0000300, $C0000300, $C0000300, $C0000300,
                            $C0000300, $FFFFFF00]),
            1, 0, NIL]:image  -> Use first bit-plane, clear unused planes

  -> Draw the 1 bit-plane image into the first bit-plane (colour 1)
  DrawImage(win.rport, myImage, 10, 10)

  -> Draw the same image at a new location
  DrawImage(win.rport, myImage, 100, 10)

  -> Wait a bit, then quit.
  -> In a real application, this would be an event loop, like the one described
  -> in the Intuition Input and Output Methods chapter.
  Delay(200)

EXCEPT DO
  IF win THEN CloseWindow(win)
  SELECT exception
  CASE ERR_WIN; WriteF('Error: Failed to open window.\n')
  CASE "MEM";   WriteF('Error: Ran out of (chip) memory.\n')
  ENDSELECT
ENDPROC
