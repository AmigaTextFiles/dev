/* une chouette commande de répertoire en E ! */

MODULE 'dos/dos'

PROC main()
  DEF info:fileinfoblock,lock,c=0
  IF lock:=Lock(arg,-2)
    IF Examine(lock,info)
      IF info.direntrytype>0
        WriteF('Répertoire de: \s\n',info.filename)
        WHILE ExNext(lock,info)
          WriteF(IF info.direntrytype>0 THEN
            '\e[1;32m\l\s[25]\e[0;31m' ELSE '\l\s[17] \r\d[7]',
            info.filename,info.size)
          WriteF(IF c++=2 THEN (c:=0) BUT '\n' ELSE ' ')
        ENDWHILE
        IF c THEN WriteF('\n')
      ELSE
        WriteF('Pas de répertoire!\n')
      ENDIF
    ENDIF
    UnLock(lock)
  ELSE
    WriteF('Hein ?!?\n')
  ENDIF
ENDPROC
