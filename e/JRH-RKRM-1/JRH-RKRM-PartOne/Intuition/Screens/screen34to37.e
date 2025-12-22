-> screen34to37.e
->
-> Simple example to show how to open a custom screen that gives the new look
-> under V37, yet still works with older version of the operating system.
-> Attach the tag SA_PENS and a minimal pen specification to ExtNewScreen, and
-> call the old OpenScreen() function.  The tags will be ignored by V34 and
-> earlier versions of the OS.  In V36 and later the tags are accepted by
-> Intuition.

-> E-Note: you need to be more specific about modules than C does about includes
MODULE 'intuition/screens', -> Screen data structures and tags
       'graphics/view'      -> Screen resolutions

-> Exception values
-> E-Note: exceptions are a much better way of handling errors
ENUM ERR_NONE, ERR_SCRN

-> Automatically raise exceptions
-> E-Note: these take care of a lot of error cases
RAISE ERR_SCRN IF OpenS()=NIL

PROC main() HANDLE
  -> Pointer to our new, custom screen
  DEF my_screen=NIL:PTR TO screen

  -> E-Note: E automatically opens the Intuition library

  -> The screen is opened two bitplanes deep so that the new look will show
  -> up better.
  -> E-Note: automatically error-checked (automatic exception)
  -> E-Note: simplified using OpenS
  my_screen:=OpenS(640,             -> Smaller values here reduce the
                   STDSCREENHEIGHT, -> drawing area and save memory.
                   2,               -> Two planes means 4 colours.
                   V_HIRES,
                   'My Screen',
                   -> Attach the pen specification tags
                   -> E-Note: the tag list can be supplied directly
                   -> E-Note: pens is just an INT-typed list
                  [SA_PENS, [-1]:INT,
                   -> E-Note: these tags replace the missing OpenS parameters
                   SA_DETAILPEN, 0,
                   SA_BLOCKPEN,  1,
                   NIL])

  -> Screen successfully opened

  Delay(200)  -> Normally the program would be here

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF my_screen THEN CloseS(my_screen)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_SCRN; WriteF('Error: Failed to open custom screen\n')
  ENDSELECT
ENDPROC
