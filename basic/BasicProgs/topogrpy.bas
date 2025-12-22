10    REM *****************************
20    REM **** Topography Graphics ****
30    REM ****    By Clay Stuart   ****
40    REM ****    Nat Eastham      ****
50    REM ****    and Ron Daniel   ****
60    REM ****        10/81        ****
64    REM ****    Amiga Version    ****
66    REM ****  By R. Grokett, Jr. ****
68    REM ****        11/85        ****
70    REM *****************************
75    screen 0,3,0
80    DIM ARR(18,36)
90    ?"Topography..."
100   FOR R=1 TO 16
110   FOR C=1 TO 32
120   TERRAIN=0
130   ARR(R,C)=TERRAIN
140   NEXT C
150   NEXT R
160   PEAKS=128*RND(1)
170   rgb 0,0,0,0:rgb 1,0,0,0:rgb 2,0,0,0
200   FOR N=1 TO PEAKS
210   RNR=16*RND(1)+1
220   RNC=32*RND(1)+1
225   H=20*RND(1)
230   HEIGHT=H-2*H*RND(1)
240   ARR(RNR,RNC)=HEIGHT
250   ARR(RNR+1,RNC)=HEIGHT/2
260   ARR(RNR-1,RNC)=HEIGHT/2
270   ARR(RNR,RNC+1)=HEIGHT/2
280   ARR(RNR,RNC-1)=HEIGHT/2
290   NEXT N
300   GOSUB 2000
400   XST=30
410   YST=40
420   FOR R=1 TO 16
430   YPL=YST+5*R
440   draw( XST+5,YPL-ARR(R,1))
450   FOR C=1 TO 32
460   XPL=XST+5*C
470   draw( to XPL,YPL-ARR(R,C))
480   NEXT C
490   XST=XST+5
500   NEXT R
600   XST=30
610   YST=40
620   FOR C=1 TO 32
630   draw( XST+5,YST+5-ARR(1,C))
640   FOR R=1 TO 16
650   XPL=XST+5*R
660   YPL=YST+5*R
670   draw( to XPL,YPL-ARR(R,C))
680   NEXT R
690   XST=XST+5
700   NEXT C
750   rem
800   GOTO 100
2000  scnclr
2010  rgb 3,rnd(1)*13+2,rnd(1)*13+2,rnd(1)*13+2
2020  pena 3
2030  get a$:if a$="" then return
2040  rgb 0,6,9,15:rgb 2,15,15,15
2060  end
