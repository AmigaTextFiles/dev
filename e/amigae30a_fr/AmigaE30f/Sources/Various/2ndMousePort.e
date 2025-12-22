-> inverse les ports souris

OPT OSVERSION=37

MODULE 'devices/input', 'exec/io'

PROC main()
  DEF request=NIL:PTR TO iostd,port=NIL
  IF port:=CreateMsgPort()
    IF request:=CreateIORequest(port,SIZEOF iostd)
      IF OpenDevice('input.device',0,request,0)=0
        request.command:=IND_SETMPORT
        request.data:=[1]:CHAR          -> 0 pour le port original , 1 pour le port joystick
        request.length:=1
        DoIO(request)
        CloseDevice(request)
      ELSE
        PutStr('Ne peut pas ouvrir l'Input device\n')
      ENDIF
      DeleteIORequest(request)
    ELSE
      PutStr('Ne peutpas créer iorequest\n')
    ENDIF
    DeleteMsgPort(port)
  ELSE
    PutStr('Ne peut pas ouvrir le port\n')
  ENDIF
ENDPROC
