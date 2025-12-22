;  Record:   $1A             program uses a linked list of these
;            word  name
;            int   visits    2
;            int   hi1      $6
;            int   lo1      $A   
;            int   elo      $E
;            int   ehi      $12
;            APTR  *next    $16

        OPT ALINK

    XDEF   _Ctime,_Cend,_Creport
    XREF   _printf,_stdout

_Cinit
     LEA     dosname,A1
     MOVE.L  4,A6
     JSR     -408(A6)
     MOVE.L  d0,DOSBase
     BNE.B   ffp
     BSR.W   clear
     MOVE.L  #1,clobber 
     BRA.W   ret
ffp
     LEA     mathname,A1
     JSR     -408(A6)
     MOVE.L  D0,MathieeeSingBasBase
     BNE.B   tio
     BSR.W   clear
     MOVE.L  #1,clobber 
     BRA.W   ret
tio
     MOVE.L  #$28,D0
     MOVE.L  #$10001,D1
     JSR     -198(A6)
     MOVE.L  D0,timerio
     BNE.B   clock
     BSR.W   clear
     MOVE.L  #1,clobber 
     BRA.W   ret
clock
     MOVE.L  #$1A,D0
     MOVE.L  #$10001,D1
     JSR     -198(A6)
     MOVE.L  D0,first         allocate memory for first record
     BNE.B   device
     BSR.W   clear
     MOVE.L  #1,clobber 
     BRA.W   ret
device
     LEA     timername,A0
     MOVEQ.L #2,D0
     MOVE.L  timerio,A1
     MOVEQ.L #0,D1
     JSR     -444(A6)         open Eclock
     TST.L   D0
     BEQ.B   tbase
     BSR.W   clear
     MOVE.L  #1,clobber 
     BRA.B   ret
tbase
     MOVE.L  timerio,A0
     MOVE.L  $14(A0),TimerBase

     TST.L   _stdout
     BEQ.B   nooutput
     MOVE.L  _stdout,outputfile
     BRA.B   ret
nooutput
     MOVE.L  DOSBase,A6
     JSR     -60(A6)
     MOVE.L  D0,outputfile
     BNE.B   ret
     BSR.W   clear
     MOVE.L  #1,clobber
ret
     RTS


_Ctime   
       MOVEM.L   A2/A6,-(A7)
       TST.L     primo
       BNE.B     next
       BSR.W     _Cinit
       MOVE.L    #1,primo 
next
       TST.L     clobber
       BNE.W     ret2 
       MOVE.L    first,A2
loop
       MOVE.W    (A2),D0
       CMP.W     $E(A7),D0
       BEQ.B     found
       TST.L     $16(A2)
       BEQ.B     new_record
       MOVE.L    $16(A2),A2
       BRA.B     loop

new_record 
       MOVE.L    #$1A,D0
       MOVE.L    #$10001,D1
       MOVE.L    4,A6
       JSR       -198(A6)
       MOVE.L    D0,$16(A2)
       BNE.B     OK1
       BSR.W     clear
       MOVE.B    #1,clobber
       BRA.B     ret2
OK1
       MOVE.L    D0,A2
       MOVE.W    $E(A7),(A2)
found
       ADD.L     #1,2(A2)       visits
       LEA       6(A2),A0
       MOVE.L    TimerBase,A6
       JSR       -60(A6)        read E-Time
ret2
       MOVEM.L   (A7)+,A2/A6
       RTS
       
_Cend
       MOVEM.L   a6,-(A7)
       TST.L     clobber
       BNE.W     quit
       LEA       temp,A0
       MOVE.L    TimerBase,A6
       JSR       -60(A6)        read E-time
       MOVE.L    D0,freq        used for PAL/NTSC correction
       MOVE.W    $A(A7),D1
       MOVE.L    first,A1
loop2
       MOVE.W    (A1),D0
       CMP.W     D1,D0
       BEQ.B     found2
       TST.L     $16(A1)
       BEQ.B     quit
       MOVE.L    $16(A1),A1 
       BRA.B     loop2
found2
       MOVE.L    $A(A1),D0
       MOVE.L    4(A0),D1
       SUB.L     D0,D1
       ADD.L     D1,$E(A1)
quit
       MOVEM.L   (A7)+,a6
       RTS
       
_Creport
	LINK	A5,#-$18
	MOVEM.L	A1-A6,-(A7)
        TST.L   clobber
        BNE.W   ret3
        MOVE.L  first,A4
loop3
      	CMP.L	#0,A4
	BEQ.W	end             
        MOVE.L  #1000000,D0
        MOVE.L  MathieeeSingBasBase,A6
        JSR     -$24(A6)         SPflt
        MOVE.L  D0,D1
        MOVE.L  freq,D0
        JSR     -$24(A6)         SPflt
        JSR     -$54(A6)         Div
        MOVE.L  D0,D1

        MOVE.L  $E(A4),D0
        JSR     -$24(A6) 
        JSR     -$54(A6) 
        JSR     -$1E(A6)         fix

        MOVE.L  #$3E8,D2
        BSR.W   div
        MOVE.W  D1,D3 
        EXT.L   D3               Micros
        BSR.W   div
        MOVE.W  D1,D4
        EXT.L   D4               Msecs
        MOVE.L  D0,D5            secs  

        LEA     format,A0
        LEA     datastore,A1
        MOVE.W  0(A4),D0
        EXT.L   D0
        MOVE.L  D0,(A1)
        MOVE.L  2(A4),4(A1)
        MOVE.L  D5,8(A1)
        MOVE.L  D4,$C(A1)
        MOVE.L  D3,$10(A1)
        LEA     code,A2
        LEA     output,A3
        MOVE.L  4,A6
        JSR     -522(A6)         DoRawFmt     
   
        MOVE.L  A3,A2
next2
        TST.B   (A2)+
        BNE.B   next2
        SUBQ.L  #1,A2
        SUBA.L  A3,A2
 
        MOVE.L  outputfile,D1
        MOVE.L  A3,D2
        MOVE.L  A2,D3
        MOVE.L  DOSBase,A6
        JSR     -48(A6)          write
        MOVEA.L A4,A1
        MOVEA.L	$16(A4),A4       next record

	BRA	loop3
end
        BSR.W   clear
ret3
	MOVEM.L	(A7)+,A1-A6
	UNLK	A5
	RTS

clear
	LINK	A5,#-$18
	MOVEM.L	A1-A6,-(A7)
        TST.L   first
        BEQ.B   math
        MOVE.L  first,A1
loop4
        MOVE.L  $16(A1),A2
        MOVE.L  #$1A,D0
        MOVE.L  4,A6
        JSR     -210(A6)
        MOVEA.L A2,A1
        CMP.L   #0,A1
        BNE.B   loop4

        TST.L   timerio
        BEQ.B   math
        MOVE.L  timerio,A1
        MOVE.L  4,A6
        JSR     -450(A6)

        MOVE.L  timerio,A1
        MOVE.L  #$28,D0
        JSR     -210(A6)
math
        TST.L   MathieeeSingBasBase
        BEQ.B   realclear
        MOVE.L  MathieeeSingBasBase,A1
        JSR     -414(A6)
realclear  
	MOVEM.L	(A7)+,A1-A6
	UNLK	A5
	RTS

code
        MOVE.B  D0,(A3)+
        RTS

div           ;time in d0  divisor in D2
        TST.L   D0
        BPL     div2
        NEG     D0
        BSR.B   div2
        NEG     D0
        NEG     D1
        RTS
div2
        SWAP    D0
        MOVEQ.L #0,D1
        MOVE.W  D0,D1
        BEQ.W   cont
        DIVU    D2,D1
        MOVE.W  D1,D0
cont
        SWAP    D0
        MOVE.W  D0,D1
        DIVU    D2,D1
        MOVE.W  D1,D0     result(LONG) in D1
        SWAP    D1        rdr
        RTS 

datastore dc.l  0,0,0,0,0,0
output    dc.l  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              
format    dc.b  'Function %ld: Visits %ld  secs %ld  msecs %ld  micros %ld',10,0
       EVEN

dosname   dc.b 'dos.library',0
  EVEN 
mathname  dc.b 'mathieeesingbas.library',0
  EVEN 
timername dc.b 'timer.device',0
  EVEN
server    dc.b 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
count     dc.l 0
DOSBase   dc.l 0
MathieeeSingBasBase  dc.l 0
TimerBase dc.l 0
primo     dc.l 0
first     dc.l 0 
temp      dc.l 0,0
timerio   dc.l 0
outputfile dc.l 0 
freq      dc.l 0
clobber   dc.l 0



