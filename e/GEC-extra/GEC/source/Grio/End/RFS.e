

OPT REG=5
OPT STRMERGE


MODULE 'grio/file'

DEF file,size


PROC main()
  DEF pos,exec=NIL
  IF (arg[]="\0") OR (arg[]="?")
     WriteF('\e[1mRFS (Run From Startup) 1.0 \e[0mby \e[2mGrio\n\t\e[0mUSAGE: <command name>\n')
  ELSE
     file,size:=gReadFile('s:startup-sequence')
     IF file
        IF (pos:=InStri(file,arg))>=0
           IF (exec:=check(file+pos))
              WriteF('Executing from startup-sequence "\s"\n',exec)
              Execute(exec,NIL,NIL)
           ENDIF
        ENDIF
        gFreeFile(file)
     ENDIF
     IF exec=NIL
        file,size:=gReadFile('s:user-startup')
        IF file
           IF (pos:=InStri(file,arg))>=0
              IF (exec:=check(file+pos))
                 WriteF('Executing from user-startup "\s"\n',exec)
                 Execute(exec,NIL,NIL)
              ENDIF
           ENDIF
           gFreeFile(file)
        ENDIF
     ENDIF
     IF exec=NIL THEN
        WriteF('You haven\at "\s" command in startup\n',arg)
  ENDIF
ENDPROC


PROC check(ptr)
  DEF x,y
  FOR x:=0 TO -100 STEP -1
      EXIT ptr[x]="\n"
      EXIT ptr[x]=";"
  ENDFOR
  IF ptr[x]<>"\n" THEN RETURN NIL
  INC x
  FOR y:=0 TO 200
      IF ptr[y]="\n"
         ptr[y]:=0
      ENDIF
      EXIT ptr[y]=0
  ENDFOR
ENDPROC ptr+x



CHAR '$VER: RFS <RunFromStartup> 1.0 (28.01.2002) by Grio',0





