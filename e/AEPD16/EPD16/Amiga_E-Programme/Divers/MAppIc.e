/*********************************/
/* MAppIc v0.0b (c) 1993 NasGûl  */
/*********************************/

OPT OSVERSION=37
OPT LARGE
ENUM ER_NONE,ER_BADARGS,ER_MEM,ER_UTILLIB,ER_ICONLIB,ER_WBLIB,ER_APPIC,
     ER_INTUILIB,ER_EXECLIB,ER_SIG,ER_REQTOOLSLIB

ENUM ARG_ICON,ARG_COM,ARG_NAME,ARG_QUIT,ARG_TEST,ARG_MULTI,NUMARGS


MODULE 'dos/dosasl','dos/dos','utility','utility/tagitem'
MODULE 'whatis','icon','wb','workbench/workbench','workbench/startup',
       'intuition/intuition','exec/ports','exec/nodes','exec/tasks'
MODULE 'reqtools','libraries/reqtools'

RAISE ER_MEM IF New()=NIL,
      ER_MEM IF String()=NIL,
      ERROR_BREAK IF CtrlC()=TRUE


DEF com,rdargs=NIL,commande[50]:STRING,name[20]:STRING
DEF appmsg:PTR TO appmessage
DEF sig,myport,appicon,res:PTR TO mp,quit=1,de_passage
DEF struc_diskobj:PTR TO diskobject,ic_test,multi,f_lock,base_lock
PROC main() HANDLE /*"Main()"*/
  DEF args[NUMARGS]:LIST,templ,x,wb_args:PTR TO wbarg
  DEF ver[50]:STRING,icone[200]:STRING,final_com[256]:STRING
  DEF task:PTR TO tc,noeud:PTR TO ln,fib:PTR TO fileinfoblock
  /*******************************************************************/
  VOID '$VER:MAppIc v0.0b (c) NasGûl (04-11-93)'
  IF (sig:=AllocSignal(-1))=NIL THEN Raise(ER_SIG)
  task:=FindTask(0)
  noeud:=task.ln
  IF base_lock:=Lock(noeud.name,fib) THEN UnLock(base_lock)
  IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTILLIB)
  IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise(ER_ICONLIB)
  IF (workbenchbase:=OpenLibrary('workbench.library',37))=NIL THEN Raise(ER_WBLIB)
  IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUILIB)
  IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN Raise(ER_REQTOOLSLIB)
  FOR x:=0 TO NUMARGS-1 DO args[x]:=0
  templ:='ICON/A,COM/K,NAME/K,QUIT/S,TEST/S,MULTI/S'
  rdargs:=ReadArgs(templ,args,NIL)
  IF rdargs=NIL THEN Raise(ER_BADARGS)
  StrCopy(icone,args[ARG_ICON],ALL)
  StrCopy(commande,args[ARG_COM],ALL)
  IF args[ARG_NAME] THEN StrCopy(name,args[ARG_NAME],ALL) ELSE StrCopy(name,'        ',ALL)
  de_passage:=args[ARG_QUIT]
  ic_test:=args[ARG_TEST]
  multi:=args[ARG_MULTI]
  IF de_passage=-1 AND multi=-1 THEN Raise(ER_BADARGS)
  IF struc_diskobj:=GetDiskObject(icone)
      IF ic_test=-1
          WriteF('Position En X :\d\n',struc_diskobj.currentx)
          WriteF('Position En Y :\d\n',struc_diskobj.currenty)
          Raise(ER_NONE)
      ENDIF
      WriteF('\h\n',struc_diskobj)
      struc_diskobj.currentx:=Val(FindToolType(struc_diskobj.tooltypes,'POSX'),NIL)
      struc_diskobj.currenty:=Val(FindToolType(struc_diskobj.tooltypes,'POSY'),NIL)
      IF myport:=CreateMsgPort()
          IF (appicon:=AddAppIconA(0,0,name,myport,NIL,struc_diskobj,
                                  [MTYPE_APPICON,TAG_DONE]))=NIL THEN Raise(ER_APPIC)
          REPEAT
              res:=WaitPort(myport)
              IF multi=-1 THEN quit:=RtEZRequestA('(c) 1993 By NasGûl','_Lancer|_Cancel|_Quit',0,0,[RTEZ_REQTITLE,
                                                                       'MAppIc v0.0b',RT_UNDERSCORE,"_", TAG_DONE]:tagitem)
              IF appmsg:=GetMsg(myport)
                  IF (appmsg.numargs>0) AND (multi=0)
                      quit:=0
                  ENDIF
                  IF (quit<>0) AND (multi=0)
                      IF StrCmp(commande,'',ALL)=-1
                          com:=FindToolType(struc_diskobj.tooltypes,'COM')
                      ELSE
                          com:=commande
                      ENDIF
                      Execute(com,0,stdout)
                  ENDIF
                  IF (multi=-1) AND (quit<>2)
                      IF quit<>0
                          IF StrCmp(commande,'',ALL)=-1
                              com:=FindToolType(struc_diskobj.tooltypes,'COM')
                          ELSE
                              com:=commande
                          ENDIF
                          wb_args:=appmsg.arglist
                          FOR x:=0 TO appmsg.numargs-1
                              f_lock:=CurrentDir(wb_args[x].lock)
                              StrCopy(final_com,com,ALL)
                              StrAdd(final_com,' ',ALL)
                              StrAdd(final_com,wb_args[x].name,ALL)
                              Execute(final_com,NIL,stdout)
                          ENDFOR
                          f_lock:=CurrentDir(base_lock)
                      ENDIF
                  ENDIF
                  ReplyMsg(appmsg)
              ENDIF
              IF de_passage=-1 THEN quit:=0
          UNTIL quit=0
          RemoveAppIcon(appicon)
          DeleteMsgPort(myport)
      ENDIF
  ELSE
    WriteF('Erreur structure diskobject.\n')
  ENDIF
  Raise(ER_NONE)
EXCEPT
  IF rdargs THEN FreeArgs(rdargs)
  IF utilitybase THEN CloseLibrary(utilitybase)
  IF iconbase THEN CloseLibrary(iconbase)
  IF workbenchbase THEN CloseLibrary(workbenchbase)
  IF struc_diskobj THEN FreeDiskObject(struc_diskobj)
  IF intuitionbase THEN CloseLibrary(intuitionbase)
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
  IF sig THEN FreeSignal(sig)
  SELECT exception
    CASE ER_BADARGS;            info()
    CASE ER_MEM;                WriteF('No mem!\n')
    CASE ER_UTILLIB;            WriteF('Could not open "utility.library" v37\n')
    CASE ER_ICONLIB;            WriteF('Could not open "icon.library" v37\n')
    CASE ER_WBLIB;              WriteF('Could not open "workbench.library" v37\n')
    CASE ER_INTUILIB;           WriteF('Could not open "intuition.library" v37\n')
    CASE ER_EXECLIB;            WriteF('Could not open "exec.library" v37\n')
    CASE ER_REQTOOLSLIB;        WriteF('Could not open "reqtools.library" v37\n')
    CASE ER_APPIC;              WriteF('could not create AppIcon\n')
    CASE ERROR_BREAK;           WriteF('\n*** BreakC ***\n')
    CASE ERROR_BUFFER_OVERFLOW; WriteF('Internal error\n')
    DEFAULT;                    PrintFault(exception,'Dos Error')
  ENDSELECT
ENDPROC
PROC info() /*"Info()"*/
    WriteF('\n')
    WriteF('\e[32mMAppIc v0.0b \e[;31m(c) \e[;33m1993 \e[;32mNas\e[;33mG\e[0mûl.\n')
    WriteF('Déscription :\n')
    WriteF('\n')
    WriteF(' <ICON>     - Nom del\aicône sans l\aextension .info .\n')
    WriteF(' COM <nom>  - Nom de la commande.Si il y a plusieurs\n')
    WriteF('              paramètres il faut utilisé des " ".\n')
    WriteF(' NAME <nom> - Nom de l\aicône sur le WorkBench.\n')
    WriteF(' QUIT       - Lance la commande une seul fois.\n')
    WriteF(' TEST       - Permet de tester les coordonnées en x\n')
    WriteF('              et en y d\aune icône.\e[;0m\n')
    WriteF(' MULTI      - L\aicône se comporte comme une véritable\n')
    WriteF('              AppIcon,c\aest à dire vous pouvez Shift-\n')
    WriteF('              cliquez sur les fichiers, puis déplacer\n')
    WriteF('              ceux-ci sur vôtre icône.Cette option est\n')
    WriteF('              incompatible avec l\aoption quit.\n')
    WriteF('\n')
    WriteF('Pour quitter MAppIc il suffit de déplacer une\n')
    WriteF('icône sur l\aicône de MAppIc.Sauf en mode multi (requester).\n')
ENDPROC

