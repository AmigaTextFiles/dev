
OPT STRMERGE
OPT OSVERSION=36
OPT REG=5



MODULE 'wbstart','libraries/wbstart',
       'icon','workbench/workbench',
       'utility/tagitem','workbench/startup'

ENUM FILE , STCK , ARGS , NUMARGS

PROC main()

     DEF cd , args[NUMARGS]:ARRAY OF LONG , rdargs
     DEF dobj:PTR TO diskobject , fail=20,wba:PTR TO wbarg
     DEF list:PTR TO LONG , count=0,lock=0,x

     IF (wbstartbase:=OpenLibrary('wbstart.library',WBSTARTVER))

         args[FILE]:=NIL ; args[STCK]:=NIL ; args[ARGS]
        
         cd:=CurrentDir(NIL)
         
         IF (rdargs:=ReadArgs('File/A,Stack/N,Args/K/M',args,NIL))
            IF args[FILE]
              IF args[STCK]
                 args[STCK]:=Long(args[STCK])
              ELSE
                 IF (iconbase:=OpenLibrary('icon.library',36))
                    IF (dobj:=GetDiskObjectNew(args[FILE]))
                       args[STCK]:=dobj.stacksize
                       FreeDiskObject(dobj)
                    ENDIF
                    CloseLibrary(iconbase)
                 ENDIF
              ENDIF

              IF args[STCK]=NIL THEN args[STCK]:=8192

              IF args[ARGS]
                 lock:=DupLock(cd)
                 list:=args[ARGS]
                 WHILE list[count] DO INC count
                 IF (wba:=New(count*SIZEOF wbarg))
                    FOR x:=0 TO count-1
                        wba[x].lock:=lock
                        wba[x].name:=list[x]
                    ENDFOR
                 ELSE
                    count:=0
                 ENDIF
              ENDIF
              
              WbStartTagList([WBSTART_NAME,args[FILE],
                              WBSTART_DIRLOCK,lock,
                              WBSTART_STACK,args[STCK] ,
                              IF count THEN TAG_MORE ELSE TAG_DONE,
                                [WBSTART_ARGUMENTLIST,wba,
                                 WBSTART_ARGUMENTCOUNT,count,
                                 TAG_DONE]
                              ])

              fail:=0
              IF lock THEN UnLock(lock)
           ENDIF
           FreeArgs(rdargs)
         ELSE
           PrintFault(IoErr(),NIL)
         ENDIF
         CurrentDir(cd)
         CloseLibrary(wbstartbase)
     ELSE
        PrintF('can\at open \s v\d!\n','wbstart.library',WBSTARTVER)
     ENDIF 

ENDPROC fail

 CHAR '$VER: WBStart 1.26 (22.12.96) by Grio',0






