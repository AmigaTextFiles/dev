-> hooks1.e

->>> Header (globals)
MODULE 'utility',
       'utility/hooks',
       'tools/installhook'

ENUM ERR_NONE, ERR_LIB

RAISE ERR_LIB IF OpenLibrary()=NIL
->>>

->>> PROC myFunction(h:PTR TO hook, o, msg)
-> This function only prints out a message indicating that we are inside the
-> callback function.
PROC myFunction(h:PTR TO hook, o, msg)
  -> E-Note: installhook has set-up access to data segment
  WriteF('Inside myFunction()\n')
ENDPROC 1
->>>

->>> PROC main()
PROC main() HANDLE
  DEF h:hook
  -> Open the utility library
  utilitybase:=OpenLibrary('utility.library', 50)
  -> Initialise the callback hook
  -> E-Note: use installhook to do the main stuff (so h.data cannot be used)
  installhook(h, {myFunction})
  -> Use the utility library function to invoke the hook
  CallHookPkt(h, 0, 0)
EXCEPT DO
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_LIB;  WriteF('Error: could not open utility library\n')
  ENDSELECT
ENDPROC
->>>

