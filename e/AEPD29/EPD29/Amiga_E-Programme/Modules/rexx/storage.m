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
    MOV