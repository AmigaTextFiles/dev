10 REM Using bwBASIC to read data using PAR: in read mode.
20 REM Works well, but there are a couple of minor flaws.
30 REM Let us see if anyone who tries this out for fun can find them.
40 REM This is Public Domain, and reminds me of Spectrum BASIC.
50 REM -------------------- Setup a simple screen. ----------------------
60 PRINT CHR$(12)
70 PRINT "                 Parallel port access using PAR: and bwBASIC."
80 PRINT
90 PRINT "       This requires PAR_READ.lha from the /hard/hack drawer of AMINET."
100 PRINT
110 PRINT "         Use Ctrl-C to exit or set all parallel port data lines high."
120 PRINT
130 PRINT "                     Parallel port decimal value is:- 0."
140 REM ------------------ Set up the reqired variables. -----------------
150 CLEAR
160 LET mybyte$="B.Walker, G0LCU."
170 LET mybyte=0
180 LET newbyte=0
190 REM --- Open a channel and import the byte from the parallal port. ---
200 OPEN "I", #2, "PAR:", 1
210 LINE INPUT #2, mybyte$
220 CLOSE #2
230 REM ---------------- Close the channel after byte access. ------------
240 LET mybyte=ASC(mybyte$)
250 IF mybyte=-1 OR mybyte=255 THEN GOTO 500
260 IF mybyte<-1 THEN GOSUB 1000
270 PRINT CHR$(11);"                     Parallel port decimal value is:-";mybyte;".    "
280 GOTO 150
500 REM -------------------------- Quit the program. ---------------------
510 PRINT CHR$(7);CHR$(12)
520 PRINT "PAR: read program finished."
530 PRINT
540 END
1000 REM --------------- Remove the negation of the byte value. ----------
1010 LET newbyte=129+mybyte
1020 LET mybyte=127+newbyte
1200 RETURN
