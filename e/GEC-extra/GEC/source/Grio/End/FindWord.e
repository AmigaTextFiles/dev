OPT STRMERGE
OPT REG=5

MODULE 'grio/file','grio/skiparg'
PROC main()
  DEF filebuf,size,file,word,buf[514]:ARRAY,cptr,lines,x=0,nr=0,nocase,k
IF (arg[]=NIL) OR (arg[]="?")
   usage:
   WriteF('USAGE : <file> <word> [lines] [nocase]\n')
ELSE
   file:=arg
   word:=skiparg(file)
   lines:=skiparg(word)
   nocase:=skiparg(lines)
   skiparg(nocase)
   IF nocase=NIL THEN nocase:=''
   IF StriCmp(lines,'NOCASE') OR StriCmp(nocase,'LINES')
      cptr:=lines
      lines:=nocase
      nocase:=cptr
   ENDIF
   lines:=StriCmp(lines,'LINES')
   nocase:=StriCmp(nocase,'NOCASE')
   IF word[]="\0" THEN JUMP usage
   filebuf,size:=gReadFile(file)
   IF filebuf
      cptr:=filebuf
      WHILE cptr
          cptr:=readLine(cptr,buf)
          INC x
          k:=IF nocase THEN InStri(buf,word) ELSE InStr(buf,word)
          IF k>=0
             INC nr
             IF lines
                WriteF('word "\s" found in line \d\n',word,x)
                Delay(2)
             ENDIF
          ENDIF
      ENDWHILE
      gFreeFile(filebuf)
      WriteF(IF nr THEN '--- word "\s" used \d times ---\n' ELSE
             '--- word "\s" not used ---\n',word,nr)
   ELSE
      WriteF('can\at open file "\s"\n',file)
   ENDIF
ENDIF
ENDPROC


PROC readLine(ptr,buf)
    DEF i=0,c
    FOR i:=0 TO 512
        c:=Char(ptr+i)
        EXIT c="\n"
        EXIT c="\0"
        EXIT i=513
        buf[i]:=c
    ENDFOR
    buf[i]:="\0"
    IF c="\0" THEN RETURN NIL
ENDPROC ptr+i+1


CHAR '$VER: FindWord 1.0 (26.12.2000) by Grio',0




