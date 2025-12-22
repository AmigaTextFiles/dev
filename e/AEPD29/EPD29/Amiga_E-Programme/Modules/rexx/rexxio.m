++ := streamstring[]++ */
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
      MOVE.B -1(A3),j   /* UNTIL streamstring[