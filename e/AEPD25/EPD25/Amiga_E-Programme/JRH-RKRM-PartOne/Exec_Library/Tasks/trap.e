-> easyintuition.e  Simple backward-compatible V37 Intuition example
->
-> This example uses extended structures with the pre-V37 OpenScreen() and
-> OpenWindow() functions to compatibly open an Intuition display.  Enhanced
-> V37 options specified via tags are ignored on 1.3 systems.

-> E-Note: you need to be more specific about modules than C does about includes
MODULE 'intuition/intuition',  -> Intuition and window data structures and tags
       'intuition/screens',    -> Screen data structures and tags
       'graphics/view',        -> Screen resolutions
       'dos/dos'               -> Official return codes defined here

-> Position and sizes for our window
CONST WIN_LEFTEDGE=20, WIN_TOPEDGE=20,
      WIN_WIDTH=400,   WIN_MINWIDTH=80,
      WIN_HEIGHT=150,  WIN_MINHEIGHT=20

-> Exception values
-> E-Note: exceptions are a much better way of handling errors
ENUM ERR_NONE, ERR_SCRN, ERR_WIN

-> Automatically raise exceptions
-> E-Note: these take care of a lot of error cases
RAISE ERR_SCRN IF OpenS()=NIL,
      ERR_WIN  IF OpenW()=NIL

PROC main() HANDLE
  -> Declare variables here
  -> E-Note: the signals stuff is handled directly by WaitIMessage
  DEF screen1=NIL:PTR TO screen, window1=NIL:PTR TO window

  -> E-Note: E automatically opens the Intuition library

  -> Open the screen
  -> E-Note: automatically error-checked (automatic except