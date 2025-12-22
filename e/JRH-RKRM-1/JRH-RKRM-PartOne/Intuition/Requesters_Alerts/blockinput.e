-> blockinput.e -- Program to demonstrate how to block the input from a window
-> using a minimal requester, and how to put up a busy pointer.

OPT OSVERSION=37  -> E-Note: silently require V37

MODULE 'exec/memory',
       'intuition/intuition'

ENUM ERR_NONE, ERR_WIN

RAISE ERR_WIN IF OpenWindowTagList()=NIL

-> Open a window and display a busy-pointer for a short time then wait for the
-> user to hit the close gadget (in processIDCMP()).  Normally, the application
-> would bracket sections of code where it wishes to block window input with
-> the beginWait() and endWait() functions.
PROC main() HANDLE
  DEF win=NIL

  win:=OpenWindowTagList(NIL,
                        [WA_IDCMP,       IDCMP_CLOSEWINDOW OR IDCMP_INTUITICKS,
                         WA_ACTIVATE,    TRUE,
                         WA_WIDTH,       320,
                         WA_HEIGHT,      100,
                         WA_CLOSEGADGET, TRUE,
                         WA_DRAGBAR,     TRUE,
                         WA_DEPTHGADGET, TRUE,
                         WA_SIZEGADGET,  TRUE,
                         WA_MAXWIDTH,    -1,
                         WA_MAXHEIGHT,   -1,
                         NIL])
  processIDCMP(win)

EXCEPT DO
  IF win THEN CloseWindow(win)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_WIN; WriteF('Error: Failed to open window\n')
  CASE "MEM";   WriteF('Error: Ran out of (chip) memory\n')
  ENDSELECT
ENDPROC

-> E-Note: get some Chip memory and copy list (quick, since LONG aligned)
PROC copyListToChip(data)
  DEF size, mem
  size:=ListLen(data)*SIZEOF LONG
  mem:=NewM(size, MEMF_CHIP)
  CopyMemQuick(data, mem, size)
ENDPROC mem

-> Clear the requester with InitRequester.  This makes a requester of
-> width = 0, height = 0, left = 0, top = 0; in fact, everything is zero.  This
-> requester will simply block input to the window until EndRequest is called.
->
-> The pointer is set to a reasonable 4-color busy pointer, with proper offsets.
PROC beginWait(win, waitRequest)
  DEF waitPointer

  -> Data for a busy pointer.
  -> This data must be in chip memory!!!
  -> E-Note: the data is really a lot of LONGs
  waitPointer:=copyListToChip([$00000000,   -> Reserved, must be NIL
                               $040007C0,  $000007C0,  $01000380,  $000007E0,
                               $07C01FF8,  $1FF03FEC,  $3FF87FDE,  $3FF87FBE,
                               $7FFCFF7F,  $7EFCFFFF,  $7FFCFFFF,  $3FF87FFE,
                               $3FF87FFE,  $1FF03FFC,  $07C01FF8,  $000007E0,
                               $00000000    -> Reserved, must be NIL
                              ])

  InitRequester(waitRequest)
  IF Request(waitRequest, win)
    SetPointer(win, waitPointer, 16, 16, -6, 0)
    SetWindowTitles(win, 'Busy - Input Blocked', -1)
    RETURN TRUE
  ELSE
    RETURN FALSE
  ENDIF
ENDPROC

-> Routine to reset the pointer to the system default, and remove the requester
-> installed with beginWait().
PROC endWait(win, waitRequest)
  ClearPointer(win)
  EndRequest(waitRequest, win)
  SetWindowTitles(win, 'Not Busy', -1)
ENDPROC

-> Wait for the user to close the window.
PROC processIDCMP(win)
  DEF class, myreq:requester, tick_count

  -> Put up a requester with no imagery (size zero).
  IF beginWait(win, myreq)
    -> Insert code here for a window to act as the requester.

    -> We'll count down INTUITICKS, which come about ten times a second.  We'll
    -> keep the busy state for about three seconds.
    tick_count:=30
  ENDIF

  REPEAT
    class:=WaitIMessage(win)
    SELECT class
    CASE IDCMP_INTUITICKS
      IF tick_count>0
        DEC tick_count
        IF tick_count=0 THEN endWait(win, myreq)
      ENDIF
    ENDSELECT
  UNTIL class=IDCMP_CLOSEWINDOW
ENDPROC
