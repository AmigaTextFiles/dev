-> newlookscreen.e - open a screen with the "new look"

-> E-Note: you need to be more specific about modules than C does about includes
MODULE 'intuition/screens' -> Screen data structures and tags

-> Exception values
-> E-Note: exceptions are a much better way of handling errors
ENUM ERR_NONE, ERR_SCRN, ERR_KICK

-> Automatically raise exceptions
-> E-Note: these take care of a lot of error cases
RAISE ERR_SCRN IF OpenScreenTagList()=NIL

-> Simple routine to demonstrate opening a screen with the new look.  Simply
-> supply the tag SA_PENS along with a minimal pen specification, Intuition
-> will fill in all unspecified values with defaults.  Since we are not
-> supplying values, all are Intuition defaults.
PROC main() HANDLE
  DEF my_screen=NIL:PTR TO screen

  -> E-Note: E automatically opens the Intuition library

  -> E-Note: use KickVersion rather than checking library version
  -> E-Note: Raise() exception rather than nesting conditionals
  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)

  -> The screen is opened two bitplanes deep so that the new look will show
  -> up better.
  -> E-Note: automatically error-checked (automatic exception)
  -> E-Note: pens is just a INT-typed list
  my_screen:=OpenScreenTagList(NIL,
                              [SA_PENS, [-1]:INT,
                               SA_DEPTH, 2,
                               NIL])

  -> Screen successfully opened
  Delay(30)  -> Normally the program would be here

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF my_screen THEN CloseScreen(my_screen)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_SCRN; WriteF('Error: Failed to open custom screen\n')
  CASE ERR_KICK; WriteF('Error: Needs Kickstart V37+\n')
  ENDSELECT
ENDPROC
