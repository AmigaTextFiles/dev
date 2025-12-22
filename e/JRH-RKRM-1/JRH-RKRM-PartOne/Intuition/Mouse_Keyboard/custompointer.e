-> custompointer.c - Show the use of a custom busy pointer, as well as using a
-> requester to block input to a window.

OPT OSVERSION=37  -> E-Note: silently require V37

MODULE 'exec/memory',
       'intuition/intuition'

ENUM ERR_NONE, ERR_WIN

RAISE ERR_WIN IF OpenWindowTagList()=NIL

PROC main() HANDLE
  DEF win=NIL, null_request:requester, waitPointer

  -> The window is opened as active (WA_ACTIVATE) so that the busy pointer will
  -> be visible.  If the window was not active, the user would have to activate
  -> it to see the change in the pointer.
  win:=OpenWindowTagList(NIL, [WA_ACTIVATE, TRUE, NIL])

  -> E-Note: the data is really a lot of LONGs (and in Chip memory!)
  waitPointer:=copyListToChip([$00000000,   -> Reserved, must be NIL
                               $040007C0,  $000007C0,  $01000380,  $000007E0,
                               $07C01FF8,  $1FF03FEC,  $3FF87FDE,  $3FF87FBE,
                               $7FFCFF7F,  $7EFCFFFF,  $7FFCFFFF,  $3FF87FFE,
                               $3FF87FFE,  $1FF03FFC,  $07C01FF8,  $000007E0,
                               $00000000    -> Reserved, must be NIL
                              ])

  -> A NULL requester can be used to block input in a window without any
  -> imagery provided.
  InitRequester(null_request)

  Delay(50)  -> Simulate activity in the program

  -> Put up the requester to block user input in the window, and set the
  -> pointer to the busy pointer.
  IF Request(null_request, win)
    SetPointer(win, waitPointer, 16, 16, -6, 0)

    Delay(100)  -> Simulate activity in the program

    -> Clear the pointer (which resets the window to the default pointer) and
    -> remove the requester.
    ClearPointer(win)
    EndRequest(null_request, win)
  ENDIF

  Delay(100)  -> Simulate activity in the program

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
