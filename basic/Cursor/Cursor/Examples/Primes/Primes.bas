
' This program prints the prime-numbers from 2 to 1000 to the screen.
' The compiled program needs 16 seconds (12 seconds without PRINT-command),
' with AmigaBASIC it takes about 148 (139) seconds on my Amiga 500

 OPTION NOWINDOW,ALLPCRELATIVE

 DEFINT a-z

 SCREEN 2,640,200,1,2
 WINDOW 2,"prime numbers from 2 to 1000:",,,2

 BeginTime! = TIMER

 FOR a = 2 TO 1000
   FOR b = 3 TO a-1
     IF a MOD b = 0 THEN NotPrim
   NEXT b
   PRINT a
NotPrim:
 NEXT a

 WINDOW 2,"time needed:"+STR$(TIMER-BeginTime!)+" s."

 WHILE INKEY$ = "" : WEND

