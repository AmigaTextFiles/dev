OPT MODULE
SET PAD,LEFT,FIELD

EXPORT PROC stringf(str:PTR TO CHAR, format:PTR TO CHAR,
		    dataptr=NIL:PTR TO LONG)
DEF tempstr[80]:ARRAY, left, right,
    ch:REG, flag:REG, i:REG, j:REG, templen:REG

  MOVEM.L A2/A4/A6,-(A7)
  MOVEA.L str,A4
  MOVEA.L format,A6
j20:   /* REPEAT */
  MOVE.B (A6),(A4)+ /*   str[]++ := format[] */
nextformat:
  MOVEQ #0,flag
  MOVE.L flag,i
  MOVE.L i,right
  MOVE.L i,left
  MOVE.B (A6),ch     /*   ch:=format[]   */
  CMPI.B #"%",ch     /*  IF ch="%" */
  BNE.S endloop
nextch:
    ADDQ.W #1,i
    MOVEA.L A6,A0    /*     ch:=format[i]   */
    ADDA.W i,A0
    MOVE.B (A0),ch
    /*	SELECT	ch  */
    CMPI.B #"l",ch   /* CASE "l" */
    BNE.S j30
      BRA gotlong
    j30: CMPI.B #"s",ch   /* CASE "s" */
    BNE.S j31
      BRA.S gotstring
    j31: CMPI.B #"-",ch    /* CASE "-" */
    BNE.S j32
      ORI.B #LEFT,flag	/*  flag:=flag OR LEFT	*/
      BRA.S nextch
    j32: CMPI.B #"0",ch    /* CASE "0" */
    BNE.S j29
      ORI.B #PAD,flag	/*   flag:=flag OR PAD	*/
      BRA.S nextch
    j29:  /* DEFAULT */
    CMPI.B #"0",ch   /*  IF (ch>"0") AND (ch<="9") */
    BLE.S j21
    CMPI.B #"9",ch
    BGT.S j21
      ORI.B #FIELD,flag    /*	flag:=flag OR FIELD;  */
      BRA field
    j21:   /*  ELSE  */
      MOVE.B (A6)+,(A4)+     /*  str[]++ := format[]++;  */
      BRA.S nextformat
    /*	ENDIF  */
  /* ENDSELECT */
endloop:   /*  ENDIF */
  ADDQ.W #1,A6	/*  format++  */
  MOVE.B -1(A4),j     /*  UNTIL str[-1]=0  */
  BNE.S j20
  MOVE.L A4,D1
  SUB.L str,D1
  SUBQ.L #1,D1	 /* string length  */
  MOVEA.L str,A0
  CMP.W -4(A0),D1
  BHI.S toolong
  MOVE.W D1,-2(A0)
toolong:
  MOVE.L A0,D0
  MOVEM.L (A7)+,A2/A4/A6
  BRA endstringf

gotstring:
  ADDA.W i,A6	 /*  format:=format+i  */
  SUBQ.W #1,A4	 /* str-- */
  MOVEA.L dataptr,A0	 /* streamstring:=dataptr[]++ */
  MOVEA.L (A0),A3
  ADDQ.L #4,dataptr
  BTST #2,flag /* IF flag AND  FIELD */
  BEQ.S j15
    MOVEA.L tempstr,A2	     /*  savetempstr:=tempstr  */
    MOVEQ #0,templen
    j17:   /* REPEAT */
    MOVE.B (A3)+,(A2)+ /* savetempstr[]++ := streamstring[]++ */
    ADDQ.L #1,templen  /* templen++  */
    MOVEQ #0,j
    MOVE.B -1(A3),j   /*  UNTIL streamstring[-1]=0  */
    BNE.S j17	 /*  UNTIL j=0 */
    MOVEA.L tempstr,A2 /*  savetempstr:=tempstr  */
    SUBQ.L #1,templen
    CMP.L right,templen  /*   IF templen>right THEN templen:=right  */
    BLE.S j18
    MOVE.L right,templen
    j18:  BSR dopad
    BRA.S j16

  j15:	/*  ELSE  */
    j19:    /* REPEAT */
      MOVE.B (A3)+,(A4)+  /* str[]++ := streamstring[]++ */
      MOVE.B -1(A3),j   /* UNTIL streamstring[-1]=0 */
      BNE.S j19   /* UNTIL j=0	*/
      SUBQ.L #1,A4  /* str-- */
  j16:	      /* ENDIF */
  BRA.S endloop

gotlong:
  ADDA.L i,A6  /*  format:=format+i+1	*/
  ADDQ.L #1,A6
  SUBQ.L #1,A4	/* str-- */
  MOVE.B (A6),ch   /* ch:=format[] */
  /* SELECT ch	*/
  CMPI.B #"d",ch   /*CASE "d" */
  BNE.S j25
  MOVEA.L dataptr,A0  /*   number:=dataptr[]++;  */
  MOVE.L (A0),D0
  ADDQ.L  #4,dataptr
  BTST #2,flag	 /*  IF flag AND FIELD */
  BEQ.S j5
    MOVEA.L tempstr,A2 /*  savetempstr:=tempstr  */
    MOVE.L A2,A0
    BSR decimal
    MOVE.L A0,D0
    SUB.L A2,D0
    MOVE.L D0,templen
    BSR dopad
    BRA.S j6

    /*	  ELSE	 */
    j5:   MOVEA.L A4,A0  /* MOVE.L str,A0 */
    BSR decimal
    MOVEA.L A0,A4  /* MOVE.L A0,str  */
    j6:   /*	 ENDIF	*/
    BRA  j23

    j25:  /* CASE "x" */
    CMPI.B #"x",ch
    BNE.S j26
      MOVEA.L dataptr,A0  /*   number:=dataptr[]++;  */
      MOVE.L (A0),D0
      ADDQ.L  #4,dataptr
      BTST #2,flag  /* IF flag AND FIELD */
      BEQ.S j7
	MOVEA.L tempstr,A2 /*  savetempstr:=tempstr  */
	MOVEA.L A2,A0  /* MOVEA.L savetempstr,A0 */
	BSR hex
	MOVE.L D0,templen
	BSR.S dopad
	BRA.S j8

      j7:  /*  ELSE  */
	MOVEA.L A4,A0  /* MOVEA.L str,A0 */
	BSR hex
	MOVEA.L A0,A4  /*  MOVE.L A0,str  */
      j8:     /*  ENDIF */
      BRA.S j23

    j26:  /* CASE "c" */
    CMPI.B #"c",ch
    BNE.S j27
      MOVEA.L dataptr,A0 /* str[]++:=dataptr[]++ */
      ADDQ.L #4,dataptr
      MOVE.B 3(A0),(A4)+    /* low byte of data  */
      BRA.S j23

    j27:  /* CASE "b"; */
    CMPI.B #"b",ch
    BNE.S j24  /* default */
      MOVEA.L dataptr,A0  /*   number:=dataptr[]++;  */
      ADDQ.L  #4,dataptr
      MOVE.L (A0),D0   /* sets flags for beq.s binzero  below */
      MOVEA.L tempstr,A2
      MOVEA.L A2,A0   /* MOVEA.L savetempstr,A0 */
      BEQ.S binzero
      MOVEQ #31,D1
      next0:
	BTST  D1,D0
	DBNE D1,next0
      nextbit:
	BTST D1,D0
	BEQ.S bit0
	MOVE.B #"1",(A0)+
	BRA.S bit1
      bit0:
	MOVE.B #"0",(A0)+
      bit1:
	DBRA D1,nextbit
	BRA.S endbin
      binzero:
	MOVE.B #"0",(A0)+
      endbin:
	SUBA.L A2,A0  /* SUBA.L savetempstr,A0	*/
	MOVE.L A0,templen
	BSR.S dopad
	BRA.S j23

    j24: /* DEFAULT  */
	/* str[]++ := "%"; str[]++ :="l"; str[]++ := ch  */
	MOVE.W #"%l",(A4)+
	MOVE.B ch,(A4)+
  j23: /*ENDSELECT */
  BRA endloop

dopad:
  CMP.L left,templen	      /*  IF templen>=left   */
  BLT.S j13
    MOVE.L templen,i
    SUBQ.L #1,i
    d1: MOVE.B (A2)+,(A4)+   /*  str[]++ := savetempstr[]++ */
    DBRA i,d1
    BRA.S j14

  j13:	      /* ELSE */
  BTST #0,flag /* j:=IF flag AND PAD THEN "0" ELSE " "   j is pad char  */
  BEQ.S j9
    MOVEQ #"0",j
    BRA.S j10
    j9: MOVEQ #" ",j
    j10:
    BTST #1,flag    /*	 IF flag AND LEFT  */
    BEQ.S j11
      MOVE.L templen,i
      SUBQ.L #1,i
      d2: MOVE.B (A2)+,(A4)+   /*  str[]++ := savetempstr[]++ */
      DBRA i,d2
      MOVE.L left,i
      SUB.L templen,i
      SUBQ.L #1,i
      d3:  MOVE.B j,(A4)+  /*  str[]++:=padch */
	DBRA i,d3
      BRA.S j12

    j11:	 /* ELSE  */
      MOVE.L left,i
      SUB.L templen,i
      SUBQ.L #1,i
      d4:  MOVE.B j,(A4)+  /*  str[]++:=padch */
	DBRA i,d4
      MOVE.L templen,i
      SUBQ.L #1,i
      d5: MOVE.B (A2)+,(A4)+   /*  str[]++ := savetempstr[]++ */
	DBRA i,d5
    j12:	  /* ENDIF */
  j14:	   /* ENDIF */
  RTS

field:
  ANDI.B #$F,ch     /*	left:=ch-"0" */
  MOVE.L ch,j
  j1: MOVEA.L A6,A3
    ADDA.L i,A3
    CMPI.B #".",1(A3)
    BEQ.S j2
    MOVE.B 1(A3),ch
    ANDI.B #$F,ch
    ADDQ.L #1,i
    MULU #10,j	  /*   left:=10*left+ch-"0"  */
    ADD.L ch,j
    BRA.S j1

  j2: MOVE.L j,left
    ADDQ.L #2,i
    MOVEA.L A6,A3
    ADDA.L i,A3
    MOVE.B (A3),ch
    ANDI.B #$F,ch    /*   right:=ch-"0"    */
    MOVE.B ch,j

  j3: MOVEA.L A6,A3
    ADDA.L i,A3
    CMPI.B #"0",1(A3)
    BLT.S j4
    CMPI.B #"9",1(A3)
    BGT.S j4
      ADDQ.W #1,A6
      MOVEA.L A6,A3
      ADDA.L i,A3
      MOVE.B (A3),ch    /*   right:=10*right+ch-"0"  */
      ANDI.B #$F,ch
      MULU #10,j
      ADD.L ch,j
      BRA.S j3

  j4: MOVE.L j,right
    BRA nextch

decimal:
   SUBA.W  #14,A7
   MOVEA.L A7,A3
   MOVE.L D0,D2
   BGE.S repeatbig
   NEG.L D0
repeatbig:
   CMPI.L #655359,D0
   BHI.S  bignumber
repeat:
   MOVEQ  #10,D1
   CMP.L D1,D0
   BHI.S norm
   BEQ.S is1
   MOVE.L D0,D1
   MOVEQ  #0,D0
   BRA.S cont

norm:
   DIVU  D1,D0
   SWAP  D0
   CLR.L D1
   MOVE.W D0,D1
   CLR.W D0
   SWAP  D0
cont:
   ADDI.B #"0",D1
   MOVE.B D1,(A3)+
   TST.L D0
   BGT.S repeat
   TST.L D2
   BGE.S notneg
   MOVE.B #"-",(A3)+
notneg:
   MOVE.B  -(A3),(A0)+
   CMPA.L  A3,A7
   BLT.S notneg
   ADDA.W #14,A7
   RTS

is1:
   MOVEQ #1,D0
   MOVEQ #0,D1
   BRA.S cont

bignumber:
   MOVEM.L D2/D3,-(A7)
   MOVEQ #10,D1
   MOVE.L D0,D2
   CLR.W D2
   SWAP D2
   DIVU D1,D2
   CLR.L D3
   MOVE.W D2,D3
   SWAP D3
   MOVE.W D0,D2
   DIVU D1,D2
   MOVE.L D2,D1
   CLR.W D1
   SWAP D1
   CLR.L D0
   MOVE.W D2,D0
   ADD.L D3,D0
   ADD.B #"0",D1
   MOVE.B D1,(A3)+
   MOVEM.L (A7)+,D2/D3
   BRA repeatbig

hex:
  MOVEA.L A7,A3
  SUBA.W  #14,A3
  MOVEQ #-1,D2
  nextltr:
    MOVE.B D0,D1
    ANDI.B #$0F,D1
    ADDI.B #48,D1
    CMPI.B #57,D1
    BLE.S around
      ADDQ.B #7,D1
    around:
    MOVE.B D1,(A3)+
    LSR.L #4,D0
    DBEQ D2,nextltr
    NOT.L D2
    MOVE.L D2,D0
    ADDQ.L #1,D0
    loadstr:
      MOVE.B -(A3),(A0)+    /* reverse buffer  */
      DBF D2,loadstr
    RTS

endstringf:
ENDPROC D0

