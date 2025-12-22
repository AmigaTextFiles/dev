GOTO s
n:
IF EOF(1) THEN beeper
LINE INPUT# 1,a$
IF LEFT$(a$,1) = " " THEN GOTO d
a$ = RIGHT$(a$,LEN(a$)-8)
t = 39
WHILE t < LEN(a$)
t = t + 1
IF ASC(MID$(a$,t,1)) < 59 THEN GOTO anumber
notnow:
WEND


FOR t = 40 TO LEN(a$)-1
IF (MID$(a$,t,1)) <> "0" THEN GOTO notnow2
IF MID$(a$,t-1,1) <> "$" THEN GOTO notnow2
t3 = t
zeroloop:
IF t3 = LEN(a$)+1 THEN GOTO notnow2
IF (MID$(a$,t3,1)) = "0" THEN t3 = t3 + 1 : GOTO zeroloop
IF (ASC(MID$(a$,t3,1)) > 47 AND ASC(MID$(a$,t3,1)) < 59) OR (ASC(MID$(a$,t3,1)) > 64 AND ASC(MID$(a$,t3,1)) < 71) THEN a$ = LEFT$(a$,t-1) + RIGHT$(a$,LEN(a$)-t3+1) : t = t3 + 1
notnow2:
NEXT
chars$ = ""
t = 1
charloop:
IF MID$(a$,t,1) = " " THEN t = t + 1
IF MID$(a$,t,1) = " " THEN GOTO exitcharloop
FOR tc = 1 TO 2
n = ASC(MID$(a$,t,1))
IF n > 64 AND n < 71 THEN n = 16 * (n - 55) ELSE n = 16 * (n - 48) 
t = t + 1
n2 = ASC(MID$(a$,t,1))
IF n2 > 64 AND n2 < 71 THEN n2 = n2 - 55 ELSE n2 = n2 - 48
n = n + n2
IF n < 32 OR n > 127 or n = 34 or n = 39 or n = 64 or n = 94 THEN n = 126
chars$ = chars$ + CHR$(n)
t = t + 1 
NEXT tc
GOTO charloop
exitcharloop:
a$ = RIGHT$(a$,LEN(a$)-26) + "   " + "; " + LEFT$(a$,25) + CHR$(34) + chars$ + CHR$(34)
i$ = MID$(a$,30,3)
PRINT# 2,a$
IF i$ = "JMP" OR i$ = "RTS" OR i$ = "BRA" THEN PRINT# 2,""
x = x + 1
GOTO n
exitloop:
CLOSE
END
lline:
PRINT #2,a$
GOTO n

d:
IF RIGHT$(a$,4) = "DATA" THEN LINE INPUT #1,a$ : GOTO n
IF RIGHT$(a$,4) = "CODE" THEN LINE INPUT #1,a$ : GOTO n
IF RIGHT$(a$,3) = "BSS" THEN  LINE INPUT #1,a$ :GOTO n
WHILE LEFT$(a$,1) = " "
a$ = RIGHT$(a$,LEN(a$)-1)
WEND
PRINT #2,a$
GOTO n

anumber:
IF ASC(MID$(a$,t,1)) < 48 THEN GOTO notnow
t$ = MID$(a$,t-1,1)
IF INSTR("- #,",t$) = 0 THEN GOTO notnow
t3 = t
thisnum = 0
numloop:
thisnum = thisnum * 10 + VAL(MID$(a$,t3,1))
t3 = t3 + 1
IF t3 > LEN(a$) THEN GOTO fall
IF ASC(MID$(a$,t3,1)) > 47 AND ASC(MID$(a$,t3,1)) < 59 THEN GOTO numloop
fall:
IF thisnum = 0 THEN th$ = "0" ELSE th$ = HEX$(thisnum)
a$ = LEFT$(a$,t-1) + "$" + th$ + RIGHT$(a$,LEN(a$)-t3+1)
t = t3
GOTO notnow

s:

PRINT "This program requires as input, the output from"
PRINT "DISASM V1.005, by MetaComco"
PRINT
INPUT "NAME of INPUT file";infile$
INPUT "Name of output file ";outfile$
OPEN "i",1,infile$,10000
OPEN "o",2,outfile$,10000
IF EOF(1) THEN END
LINE INPUT #1,a$
IF LEFT$(a$,2) = "Di" THEN LINE INPUT #1,a$ : GOTO n
CLOSE 1
OPEN "i",1,infile$,10000
GOTO n

beeper:
CLOSE
a$ = INKEY$
WHILE INKEY$ = ""
BEEP
FOR t = 1 TO 4000
NEXT
WEND
END

' Copyright 1987 by Glen McDiarmid
' Use, modify and distribute freely
' 