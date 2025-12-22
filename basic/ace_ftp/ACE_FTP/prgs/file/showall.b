{*
** Recursively shows all files in a 
** directory and its subdirectories.
**
** Author: David J Benn
**   Date: 2nd April 1995
*}

SUB show_dir(SHORTINT n,STRING theDir)
ON BREAK GOTO quit
BREAK ON
  addr& = ALLOC(20)
  IF addr& = 0& THEN 
    PRINT "Memory allocation error!"
    GOTO quit
  ELSE
    '..don't want this to be overwritten
    '..on each call to show_dir!
    STRING tmpfile$ ADDRESS addr&
  END IF
  IF theDir<>"" THEN CHDIR theDir
  tmpfile$="ram:dir_tmp."+MID$(STR$(n),2)
  FILES TO tmpfile$
  ASSEM
    addq #4,sp
  END ASSEM	'..bug workaround :(
  OPEN "I",#n,tmpfile$
  WHILE NOT EOF(n)
    LINE INPUT #n,x$
    PRINT x$
    IF LEFT$(x$,1)="[" THEN
      show_dir(n+1,MID$(x$,2,INSTR(2,x$,"]")-2))
    END IF
  WEND
  CLOSE #n
  KILL tmpfile$
  IF theDir<>"" THEN CHDIR "/"
  EXIT SUB
quit:
  PRINT "***";ARG$(0);" terminating!"
  FOR i=1 TO n
    CLOSE #i
    KILL "ram:dir_tmp."+MID$(STR$(i),2)
  NEXT
  STOP
END SUB

'..main
IF ARGCOUNT = 1 THEN
  show_dir(1,ARG$(1))
ELSE
  PRINT "usage: ";ARG$(0);" directory-path"
END IF
