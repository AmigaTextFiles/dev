-> appicon.e -- Show use of an AppIcon

OPT OSVERSION=37

MODULE 'icon',
       'wb',
       'workbench/startup',
       'workbench/workbench'

ENUM ERR_NONE, ERR_APPICON, ERR_DOBJ, ERR_LIB, ERR_PORT

RAISE ERR_APPICON IF AddAppIconA()=NIL,
      ERR_DOBJ    IF GetDefDiskObject()=NIL,
      ERR_LIB     IF OpenLibrary()=NIL,
      ERR_PORT    IF CreateMsgPort()=NIL

PROC main() HANDLE
  DEF dobj=NIL:PTR TO diskobject, myport=NIL, appicon=NIL,
      appmsg:PTR TO appmessage, dropcount=0, x
  -> Get the the right version of the Icon Library, initialise iconbase
  iconbase:=OpenLibrary('icon.library', 37)
  -> Get the the right version of the Workbench Library
  workbenchbase:=OpenLibrary('workbench.library', 37)
  -> This is the easy way to get some icon imagery
  -> Real applications should use custom imagery
  dobj:=GetDefDiskObject(WBDISK)
  -> The type must be set to NIL for a WBAPPICON
  dobj.type:=NIL

  -> The CreateMsgPort() function is in Exec version 37 and later only
  myport:=CreateMsgPort()
  -> Put the AppIcon up on the Workbench window
  appicon:=AddAppIconA(0, 0, 'TestAppIcon', myport, NIL, dobj, NIL)
  -> For the sake of this example, we allow the AppIcon to be activated
  -> only five times.
  WriteF('Drop files on the Workbench AppIcon\n')
  WriteF('Example exits after 5 drops\n')

  WHILE dropcount<5
    -> Here's the main event loop where we wait for  messages to show up
    -> from the AppIcon
    WaitPort(myport)

    -> Might be more than one message at the port...
    WHILE appmsg:=GetMsg(myport)
      IF appmsg.numargs=0
        -> If numargs is 0 the AppIcon was activated directly
        WriteF('User activated the AppIcon.\n')
        WriteF('A Help window for the user would be good here\n')
      ELSEIF appmsg.numargs>0
        -> If numargs is >0 the AppIcon was activated by having one or more
        -> icons dropped on top of it
        WriteF('User dropped \d icons on the AppIcon\n', appmsg.numargs)
        FOR x:=0 TO appmsg.numargs-1
          WriteF('#\d name="\s"\n', x+1, appmsg.arglist[x].name)
        ENDFOR
      ENDIF
      -> Let Workbench know we're done with the message
      ReplyMsg(appmsg)
    ENDWHILE
    INC dropcount
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
  SELECT exception
  CASE ERR_APPICON; WriteF('Error: Could not attach AppIcon to Workbench\n')
  CASE ERR_DOBJ;    WriteF('Error: Could not get default icon\n')
  CASE ERR_LIB;     WriteF('Error: Could not open required library\n')
  CASE ERR_PORT;    WriteF('Error: Could not create port\n')
  ENDSELECT
ENDPROC