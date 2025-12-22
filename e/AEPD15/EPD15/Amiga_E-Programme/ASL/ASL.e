/* ASL REQUESTER aufruf mit Anzeige des letzt eingestellten 
*  Directorys und Filenamens
*  In Drawer das Directory und in Filename das File
*  das angezeigt werden soll uebergeben (Global) .
*
*  Als modus wird LOAD oder SAVE (CONST) uebergeben , beeinflusst die Anzeige
*  des Requesters farblich und beim Doppelclick !!
*  titelzeile = Anzeige im ASL_REQUESTER_BALKEN  (STRING)
*  window = das dazu gehoerige Window z.b. (project0wnd)
*  pattern = '#?(.info)'
* (es werden z.b. nur Files mit dem Sufix ".info" angezeigt)
*
*  holefilenamen(LOAD,'Source_Code Einstellen !!',project0wnd,'#?(.e)')
*
*/
 
MODULE 'libraries/asl','asl'
 
DEF drawer[255]:STRING,
    filename[80]:STRING,
    zusammen[255]:STRING
 
ENUM LOAD,SAVE
    /* BEISPIEL */
 
PROC main()
 
DEF count=5  /* Anzahl der Test's */
    WriteF('Es geht los \n\n')
      WHILE (count<>0)
/*
(SAVE) REQUESTER ist nun SCHWARZ und es geht nicht einfach 
mit einem Doppelclick raus , (NIL) wir haben kein Window
'#?(.info)'  es werden nur Files mit diesem Sufix angezeigt
**** Probier mal ein bischen rum !!  ****
*/
        holefilenamen(LOAD,'BEISPIEL',NIL,'#?(.info)')
        WriteF('DRAWER = "\s" , FILENAME = "\s" \n',drawer,filename)
        StringF(zusammen,'\s\s',drawer,filename)
        WriteF('Beide = "\s" \n',zusammen)
        DEC count
      ENDWHILE
ENDPROC
    /********************************************************/
 
PROC holefilenamen(modus,titelzeile,window,pattern)
 
DEF flags=0,c[2]:STRING
 
DEF req:PTR TO filerequester
    IF (modus = SAVE) THEN flags:=FILF_SAVE
      IF aslbase:=OpenLibrary('asl.library',37)
          IF req:=AllocAslRequest(ASL_FILEREQUEST,NIL)
              IF AslRequest(req,[ASL_DIR,drawer,ASL_FILE,filename,ASL_HAIL,titelzeile,ASL_FUNCFLAGS,flags,ASL_WINDOW,window,
                ASL_HEIGHT,200,ASL_PATTERN,pattern,NIL])
                StringF(filename,'\s',req.file)
                StringF(drawer,'\s',req.drawer)
                MidStr(c,drawer,((StrLen(drawer))-1),1)
                  IF (StrCmp(c,':',1)) OR (StrCmp(c,'/',1))
/*      StringF(drawer,'\s',drawer)  letztes Zeichen ist Colum
**      oder Slash drawer bleibt so {diese Zeile ist uebrig :-) }*/
                  ELSE
/*letztes Zeichen war kein Colum oder Slash
, dann fuegen wir ein Slash ein */
                    StringF(drawer,'\s/',drawer)
                  ENDIF
              ENDIF
            FreeAslRequest(req)
          ELSE
            EasyRequestArgs(0,[20,0,0,'Kann Filerequester nicht oeffnen !',' O.K.'],0,0)
          ENDIF
        CloseLibrary(aslbase)
      ELSE
        EasyRequestArgs(0,[20,0,0,'Kann Asl.library nicht oeffnen !',' O.K.'],0,0)
      ENDIF
ENDPROC 
