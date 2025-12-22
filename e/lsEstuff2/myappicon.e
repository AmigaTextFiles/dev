-> appicon.e -- Show use of an AppIcon

-> omgjord 990320 av LS .. myappicon.e
-> funktion : dubbelklick avslutar.
->            information om filer och
->            lådor som släpps på iconen
->            ges som argument till
->


-> 990422 -> snyggar upp och lägger till
-> lite argument... man kan välja diskobject
-> och namn på appiconen. dessutom vilken kommandorad
-> som ska köras med det man 'appar' efter.

->990427 : lade till FOREACH , Added FOREACH


OPT OSVERSION=37

MODULE 'icon', 'dos/var',
       'wb',
       'workbench/startup',
       'workbench/workbench'

ENUM ERR_NONE, ERR_APPICON, ERR_DOBJ, ERR_LIB, ERR_PORT, ERR_ARG

RAISE ERR_APPICON IF AddAppIconA()=NIL,
      ERR_DOBJ    IF GetDefDiskObject()=NIL,
      ERR_LIB     IF OpenLibrary()=NIL,
      ERR_PORT    IF CreateMsgPort()=NIL,
      ERR_ARG     IF ReadArgs()=NIL

  DEF dobj=NIL:PTR TO diskobject, myport=NIL, appicon=NIL,
      appmsg:PTR TO appmessage, alive=TRUE, x,
      ->LS
      nfl[100]:ARRAY OF CHAR,
      argstring[100]:STRING,
      myargs:PTR TO LONG,
      rdargs


PROC main() HANDLE
  myargs:=[0,0,0,0]
  rdargs:=ReadArgs('COMMAND/A,ICON/K,NAME/K,FOREACH/S', myargs, NIL)

  -> Get the the right version of the Icon Library, initialise iconbase
  iconbase:=OpenLibrary('icon.library', 37)
  -> Get the the right version of the Workbench Library
  workbenchbase:=OpenLibrary('workbench.library', 37)
  -> This is the easy way to get some icon imagery
  -> Real applications should use custom imagery
  dobj:=GetDiskObject(
  IF myargs[1] THEN myargs[1] ELSE 'myappicon')
  -> The type must be set to NIL for a WBAPPICON
  dobj.type:=NIL

  -> The CreateMsgPort() function is in Exec version 37 and later only
  myport:=CreateMsgPort()
  -> Put the AppIcon up on the Workbench window
  appicon:=AddAppIconA(0, 0,
  IF myargs[2] THEN myargs[2] ELSE 'MyAppIcon',
  myport, NIL, dobj, NIL)
 
  WHILE alive
    -> Here's the main event loop where we wait for  messages to show up
    -> from the AppIcon
    WaitPort(myport)

    -> Might be more than one message at the port...
    WHILE appmsg:=GetMsg(myport)
      IF appmsg.numargs=0
        -> If numargs is 0 the AppIcon was activated directly
       -> avsluta  *****
       alive:=FALSE
      ELSEIF appmsg.numargs>0
         IF myargs[3] THEN foreach() ELSE oneshot()
      ENDIF
      -> Let Workbench know we're done with the message
      ReplyMsg(appmsg)
    ENDWHILE
  ENDWHILE

EXCEPT DO
  IF appicon THEN RemoveAppIcon(appicon)
  IF myport
    -> Clear away any messages that arrived at the last moment
    WHILE appmsg:=GetMsg(myport) DO ReplyMsg(appmsg)
    DeleteMsgPort(myport)
  ENDIF
  IF dobj THEN FreeDiskObject(dobj)
  IF workbenchbase THEN CloseLibrary(workbenchbase)
  IF iconbase THEN CloseLibrary(iconbase)
  ->IF rdargs THEN FreeArgs(rdargs)
  SELECT exception
  CASE ERR_APPICON; WriteF('Error: Could not attach AppIcon to Workbench\n')
  CASE ERR_DOBJ;    WriteF('Error: Could not get icon\n')
  CASE ERR_LIB;     WriteF('Error: Could not open required library\n')
  CASE ERR_PORT;    WriteF('Error: Could not create port\n')
  CASE ERR_ARG;     WriteF('Error: ReadArgs()\n')
  ENDSELECT
ENDPROC

PROC oneshot()
   StringF(argstring, '\s ', myargs[0])
   FOR x:=0 TO appmsg.numargs-1
      NameFromLock(appmsg.arglist[x].lock, nfl, 99)
      AddPart(nfl, appmsg.arglist[x].name, 100)
      StrAdd(argstring, nfl)
      StrAdd(argstring, ' ')
   ENDFOR
   StrAdd(argstring, '\0')
   SystemTagList(argstring, NIL)
   ->WriteF('\s', argstring)
ENDPROC

PROC foreach()
   FOR x:=0 TO appmsg.numargs-1
      StringF(argstring, '\s ', myargs[0])
      NameFromLock(appmsg.arglist[x].lock, nfl, 99)
      AddPart(nfl, appmsg.arglist[x].name, 100)
      StrAdd(argstring, nfl)
      StrAdd(argstring, '\0')
      SystemTagList(argstring, NIL)
   ENDFOR
ENDPROC
