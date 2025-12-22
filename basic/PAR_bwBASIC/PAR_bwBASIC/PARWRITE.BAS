10 REM A simple text write mode to an AMIGA parallel port printer.
20 REM Note:- It uses PAR: NOT PRT: for communication to the printer.
30 REM This is Public Domain for all who want to try bwBASIC.
40 CLEAR
50 LET mystring$="B.Walker, G0LCU."
60 PRINT CHR$(12)
70 INPUT "Enter a string, (EXIT<RETURN> to quit)",mystring$
80 IF mystring$="EXIT" THEN GOTO 130
90 OPEN "O", #2, "PAR:"
100 PRINT #2, mystring$
110 CLOSE #2
120 GOTO 60
130 PRINT
140 PRINT CHR$(7);"Quitting..."
150 PRINT
160 END
