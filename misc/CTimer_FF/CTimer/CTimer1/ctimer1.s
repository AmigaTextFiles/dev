;  Record:   word  name      program uses a linked list of these
;            int   visits    2
;            int   ecount    6
;            int   ehor      $A
;            int   evert     $E
;            int   shor/vert $12
;            int   scount    $16
;            APTR  *next     $1A

        OPT ALINK

    XDEF   _Ctime,_Cend,_Creport
    XREF   _printf,_stdout

_Cinit	
     LEA     server,A3
     MOVE.B  #2,8(A3)
     MOVE.B  #0,9(A3)
     MOVE.L  #count,$E(A3)
     MOVE.L  #name,$A(A3)
     MOVE.L  #VertBServer,$12(A3)       
     MOVEQ.L #5,D0
     MOVE.L  A3,A1 
     MOVE.L  4,A6
     JSR     -168(A6)          AddIntServer

     LEA     dosname,A1
     MOVE.L  4,A6
     JSR     -408(A6)
     MOVE.L  d0,DOSBase
     BNE.W   record
     BSR.W   clear
     MOVE.L  #1,abort
     BRA.W   go
record
     MOVE.L  #$1E,D0
     MOVE.L  #$10001,D1
     MOVE.L  4,A6
     JSR     -198(A6)         Alocate memory for first record    
     MOVE.L  D0,first
     BNE.W   outfh
     BRA.W   clear
     MOVE.L  #1,abort
     BRA.W   go
outfh   
     TST.L   _stdout
     BEQ.B   nooutput
     MOVE.L  _stdout,outputfile
     BRA.B   go
nooutput
     MOVE.L  DOSBase,A6
     JSR     -60(A6)
     MOVE.L  D0,outputfile
     BNE.W   go
     BSR.W   clear
     MOVE.L  #1,abort
go
     RTS

Cclose
     MOVE.L  #5,D0
     LEA     server,A1
     MOVE.L  4,A6
     JSR     -174(A6)          RemIntServer
     RTS


VertBServer:
             movem.l   D1-D3/A6,-(A7)
             move.l    A1,A0
             addq.l    #1,(A0)
             MOVEM.L   (A7)+,D1-D3/A6
             rts

_Ctime   
       LINK      A5,#0
       MOVEM.L   d1-d7/a1-a6,-(A7)
       MOVE.W    10(A5),D3
       TST.L     primo
       BNE.B     next
       BSR.W     _Cinit
       MOVE.L    #1,primo 
next
       TST.L     abort
       BNE.W     quit1
       MOVE.L    first,A2
loop
       MOVE.W    (A2),D0
       CMP.W     D3,D0
       BEQ.B     found
       TST.L     $1A(A2)
       BEQ.B     new_record
       MOVE.L    $1A(A2),A2
       BRA.B     loop

new_record 
       MOVE.L    #$1E,D0
       MOVE.L    #$10001,D1
       MOVE.L    4,A6
       JSR       -198(A6)      alloc next record
       MOVE.L    D0,$1A(A2)
       BNE.B     OK
       BSR.W     clear
       MOVE.L    #1,abort
       BRA.B     quit1
OK
       MOVE.L    D0,A2
       MOVE.W    D3,(A2)
found
       ADD.L     #1,2(A2)           visits
       MOVE.L    $DFF004,$12(A2)    start hor/vert
       MOVE.L    count,$16(A2)      VertB counts 
quit1
       MOVEM.L   (A7)+,d1-d7/a1-a6
       UNLK      A5
       RTS
       
_Cend
       LINK      A5,#0
       MOVEM.L   d1-d7/a1-a6,-(A7)
       TST.L     abort
       BNE.W     quit2
       MOVE.L    $DFF004,D4
       MOVE.L    count,D5           new count
       AND.L     #$0001FFFF,D4      new hor/vert
       MOVE.W    10(A5),D3
       MOVE.L    first,A2
loop2
       MOVE.W    (A2),D2
       CMP.W     D3,D2
       BEQ.B     found2
       TST.L     $1A(A2)
       BEQ.B     quit2
       MOVE.L    $1A(A2),A2
       BRA.B     loop2
found2
       MOVEQ.L   #0,D0
       MOVE.B    D4,D0              new hor
       LSR.L     #8,D4
       MOVEQ.L   #0,D1
       MOVE.W    D4,D1              new vert
       TST.L     D0
       BNE.B     old
       ADDQ.L    #1,D1
old
       MOVE.L    $12(A2),D4 
       AND.L     #$0001FFFF,D4      old hor/vert
       MOVEQ.L   #0,D2
       MOVE.B    D4,D2              old hor
       LSR.L     #8,D4 
       MOVEQ.L   #0,D3
       MOVE.W    D4,D3              old vert
       TST.L     D2
       BNE.B     sum
       ADDQ.L    #1,D3
sum
       SUB.L     D2,D0
       ADD.L     D0,$A(A2)          diff hor
       SUB.L     D3,D1
       ADD.L     D1,$E(A2)          diff vert
       SUB.L     $16(A2),D5
       ADD.L     D5,6(A2)           diff count
quit2
       MOVEM.L   (A7)+,d1-d7/a1-a6
       UNLK      A5
       RTS
       
_Creport
	LINK	A5,#-$18
	MOVEM.L	A3/A4/A6,-(A7)
        JSR	Cclose
	TST.L   abort
        BNE.W   go2
        LEA     mathname,A1
        MOVE.L  4,A6
        JSR     -408(A6)
        MOVE.L  d0,MATHBase
        MOVE.L  first,A4
loop3
      	CMP.L	#0,A4
	BEQ.W	exit
	MOVEA.L	MATHBase,A6
        MOVE.L	6(A4),D0
	JSR	-$24(A6)         float
	MOVE.L	#$9C40004F,D1
	JSR	-$4E(A6)         mult
	MOVE.L	D0,-$4(A5)  
	MOVE.L	$E(A4),D0
	JSR	-$24(A6)         float
	MOVE.L	#$82000047,D1
	JSR	-$4E(A6)         mult 
	MOVE.L	-$4(A5),D1
	JSR	-$42(A6)         add
	MOVE.L	D0,-$4(A5)
	MOVE.L	$A(A4),D0
	JSR	-$24(A6)         float
	MOVE.L	#$8F5C293F,D1
	JSR	-$4E(A6)         mult
	MOVE.L	-$4(A5),D1
	JSR	-$42(A6)         add
	JSR     -$1E(A6)         SPfix - convert to hex

        DIVU.   #$3E8,D0
        MOVE.W  D0,D2            msecs
        EXT.L   D2
        SWAP    D0
        MOVE.W  D0,D3            micros 
        EXT.L   D3
        DIVU    #$3E8,D2
        MOVE.W  D2,D4            secs
        EXT.L   D4
        SWAP    D2
        MOVE.W  D2,D5            msecs 
        EXT.L   D5  

        LEA     format,A0
        LEA     datastore,A1
        MOVE.W  0(A4),D0
        EXT.L   D0
        MOVE.L  D0,(A1)
        MOVE.L  2(A4),4(A1)
        MOVE.L  D4,8(A1)
        MOVE.L  D5,$C(A1)
        MOVE.L  D3,$10(A1)
        LEA     code,A2
        LEA     output,A3
        MOVE.L  4,A6
        JSR     -522(A6)         RawDoFmt        
 
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
        JSR     -48(A6)

        MOVEA.L	$1A(A4),A4       next record  
	BRA	loop3
exit
        BSR.B   clear
go2
	MOVEM.L	(A7)+,A3/A4/A6
	UNLK	A5
	RTS

code
        MOVE.B  D0,(A3)+
        RTS

clear
	MOVEM.L	A1-A6,-(A7)

        TST.L   first
        BEQ.B   math
        MOVE.L  first,A1
loop4
        MOVE.L  $1A(A1),A2
        MOVE.L  #$20,D0
        MOVE.L  4,A6
        JSR     -210(A6)
        MOVEA.L A2,A1
        CMP.L   #0,A1
        BNE.B   loop4
math
        TST.L   MATHBase
        BEQ.B   realclear
        MOVE.L  MATHBase,A1
        MOVE.L  4,A6
        JSR     -414(A6)
realclear
	MOVEM.L	(A7)+,A1-A6
	RTS

datastore dc.l  0,0,0,0,0,0
output    dc.l  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              
format    dc.b  'Function %ld: Visits %ld  secs %ld  msecs %ld  micros %ld',10,0
  EVEN

name      dc.b 'VBlank_Count',0
  EVEN
dosname   dc.b 'dos.library',0
  EVEN 
mathname  dc.b 'mathffp.library',0
  EVEN 
server    dc.b 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
count     dc.l 0
DOSBase   dc.l 0
MATHBase  dc.l 0
primo     dc.l 0
first     dc.l 0 
outputfile dc.l 0
abort     dc.l 0









