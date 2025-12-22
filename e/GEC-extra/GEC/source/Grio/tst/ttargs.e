MODULE 'workbench/startup','workbench/workbench','icon','exec/nodes'

PROC main()
DEF name[120]:STRING,dob:PTR TO diskobject,list:PTR TO LONG,x=0,str,y=0
IF wbmessage
   IF (iconbase:=OpenLibrary('icon.library',36))
      StringF(name,'PROGDIR:\s',thistask::ln.name)
      IF (dob:=GetDiskObjectNew(name))
         list:=dob.tooltypes
         WHILE list[y]
             x:=x+StrLen(list[y])+1
             INC y
         ENDWHILE
         INC x,4
         IF (str:=String(x))
            FOR x:=0 TO y
                StrAdd(str,list[x],ALL)
                StrAdd(str,' ',1)
            ENDFOR
         ENDIF
         SetStr(str,EstrLen(str)-1)
         StrAdd(str,'\n')
         WriteF(str)
         FreeDiskObject(dob)
      ENDIF
      CloseLibrary(iconbase)
   ENDIF
ENDIF
ENDPROC

