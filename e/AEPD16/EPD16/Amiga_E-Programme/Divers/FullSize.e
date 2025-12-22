/*============================================
 = FullSize v0.0 © 1994 NasGûl
 ============================================*/
MODULE 'dos/dos'
DEF firstdir[80]:STRING
DEF fullsize=0
DEF numfile=0
DEF numdir=0
PROC main() /*"main()"*/
    StrCopy(firstdir,arg,ALL)
    p_LookDir(firstdir)
    WriteF('\n\e[1m\e[31mNumber of File(s) :\e[33m\d\e[0m\n',numfile)
    WriteF('\e[1m\e[31mNumber of Dir(s)  :\e[33m\d\e[0m\n',numdir)
ENDPROC
PROC p_LookDir(curdir) /*"p_LookDir(curdir)"*/
  DEF info:fileinfoblock,lock
  DEF currentdir[256]:STRING,pv[256]:STRING
  IF lock:=Lock(curdir,-2)
    NameFromLock(lock,currentdir,256)
    AddPart(currentdir,'',256)
    IF Examine(lock,info)
      IF info.direntrytype>0
        WHILE ExNext(lock,info)
            IF info.direntrytype>0
              StringF(pv,'\s\s',currentdir,info.filename)
              INC numdir
              p_LookDir(pv)
            ELSE
              fullsize:=fullsize+info.size
              WriteF('\b\e[1m\e[31mFullSize v0.0 © 1994 NasGûl:\e[1m\e[32m\d \e[1m\e[0mOctets.',fullsize)
              INC numfile
            ENDIF
        ENDWHILE
      ELSE
      ENDIF
    ENDIF
    UnLock(lock)
  ELSE
    WriteF('What ?!?\n')
  ENDIF
ENDPROC
