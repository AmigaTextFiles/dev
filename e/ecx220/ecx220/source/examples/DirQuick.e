
/* nice directory command in E ! */

MODULE 'dos/dos'

PROC main()
  DEF info:fileinfoblock,lock,c=0
  IF lock:=Lock(arg,-2)
    IF Examine(lock,info)
      IF info.direntrytype>0
        WriteF('Directory of: \s\n',info.filename)
        WHILE ExNext(lock,info)
          WriteF(IF info.direntrytype>0 THEN '\l\s[25]' ELSE '\l\s[17] \r\d[7]',
            info.filename,info.size)
          WriteF(IF c++=2 THEN (c:=0) BUT '\n' ELSE ' ')
        ENDWHILE
        IF c THEN WriteF('\n')
      ELSE
        WriteF('No Dir!\n')
      ENDIF
    ENDIF
    UnLock(lock)
  ELSE
    WriteF('What ?!?\n')
  ENDIF
ENDPROC
