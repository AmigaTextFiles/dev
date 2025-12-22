10    rem 3D CUBES Version 1.0 11/9/85
12    rem From Atari version - Compute! Magazine
14    rem Amiga version by R. Grokett20    randomize -1
30    sq%=50
40    screen 0,4,0
50    ?"    3D Cubes -- Version 1.0"
60    ?:?:?:?"Press:"
70    ?
80    ?" (S)ize..........Change cube size"
90    ?" (C)olor.........Change cube color"
100   ?" <RETURN>........Clear screen"
110   ?" <ESC>...........Exit from CUBES"
120   ?:?:?:?:?:?:?:?:?:?:?:?"Press <RETURN> to begin!";
130   getkey key$
140   GOSUB 550
150   scnclr
160   rgb 0,0,0,0
170   rgb 1,0,0,0
180   rgb 2,0,0,0
190   GOSUB 320
200   REM MAIN
210   x%=rnd(1)*320:y%=rnd(1)*200
250   get key$
260   IF KEY$="c" THEN GOSUB 320
270   if key$=chr$(27) then 610
280   if key$="s" then gosub 540
290   if key$=chr$(13) then 150
300   GOSUB 400
310   GOTO 210
320   REM COLOR CHANGE
330   c1%=(rnd(1)*14)+2
340   c2%=(rnd(1)*14)+2
350   c3%=(rnd(1)*14)+2
360   rgb 3,c1%,c2%,c3%
370   rgb 4,c1%-1,c2%-1,c3%-1
380   rgb 5,c1%-2,c2%-2,c3%-2
390   RETURN 
400   rem PLOT
410   pena 3
420   FOR I%=0 TO SQ%
430   DRAW (x%,y%+i% to X%+SQ%,Y%+I%)
440   NEXT I%
450   pena 4
460   FOR I%=1 TO INT(3*SQ%)/5
470   draw (X%+I%,Y%-I% TO X%+I%+SQ%,Y%-I%)
480   NEXT I%
490   pena 5
500   FOR I%=1 TO INT(3*SQ%)/5
510   draw (X%+SQ%+I%,Y%-I% TO X%+SQ%+I%,Y%+SQ%-I%+1)
520   NEXT I%
530   RETURN 
540   REM CUBE SIZE
550   rem
560   sq%=sq%-5
570   IF SQ%<5 then sq%=50
580   RETURN
610   rem EXIT
620   rgb 0,6,9,15
630   rgb 1,0,0,0
640   rgb 2,15,15,15
650   scnclr
660   end
