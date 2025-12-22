(*******************************************************************************
 : Program.         VilIntuiSupD.mod
 : Author.          Carsten Wartmann (Crazy Video)
 : Address.         Wutzkyallee 83, 12353 Berlin
 : Phone.           030/6614776
 : E-Mail           C.Wartmann@GANDALF.berlinet.de (bevorzugt)
 : E-Mail           Carsten_Wartmann@tfh-berlin.de
 : Version.         1.0
 : Date.            21.08.1995 (16.Nov.1994)
 : Copyright.       Freeware
 : Language.        Modula-2
 : Compiler.        M2Amiga V4.3d
 : Contents.        Macht die VilIntuiSup.library für MODULA-2 (M2Amiga)
 : Contents.        Programmierer nutzbar.
 : Contents.        Enthält die Punktsetzroutinen in Assembler und zwei
 : Contents.        Linienroutinen.
*******************************************************************************)

IMPLEMENTATION MODULE VilIntuiSupD ;
(*
(*$ StackChk:=FALSE *)
(*$ RangeChk:=FALSE *)
(*$ OverflowChk:=FALSE *)
(*$ NilChk:=FALSE *)
(*$ EntryClear:=FALSE *)
(*$ CaseChk:=FALSE *)
(*$ ReturnChk:=FALSE *)
(*$ StackParms:=FALSE *)
*)

(* ToDo : Routinen um Blitten zu vereinfachen, ClearScreen *)


FROM SYSTEM     IMPORT ASSEMBLE,ADDRESS,ADR,SHIFT ;
FROM Arts       IMPORT Assert ;
FROM ExecL      IMPORT Permit,Forbid ;
FROM IntuitionL IMPORT ScreenToFront ;
FROM IntuitionD IMPORT ScreenPtr,Screen ;
FROM UtilityD   IMPORT TagItemPtr ;

FROM MathLib0   IMPORT sin,cos,pi ;

IMPORT DosL ;
IMPORT Vil:VilIntuiSupL ;

IMPORT R ;


CONST Step = pi / 32.0 ;


PROCEDURE ClearScreen(scr : ScreenPtr) ;
VAR  fill  : VilFillRecord ;
     start : ADDRESS ;
     ok    : LONGINT ;

BEGIN
  Forbid() ;
   ScreenToFront(scr) ;
   start := Vil.LockVillageScreen(scr) ;
  Permit() ;

  fill.dstAdr   := start ;
  fill.dstPitch := scr^.width ;
  fill.width    := scr^.width ;
  fill.height   := scr^.height ;
  fill.color    := VilZero ;

  ok := Vil.VillageRectFill(scr,ADR(fill)) ;
  Vil.UnLockVillageScreen(scr) ;

END ClearScreen ;


PROCEDURE ClearBuf(scr : ScreenPtr ; bufadr : ADDRESS) ;
VAR  fill  : VilFillRecord ;
     start : ADDRESS ;
     ok    : LONGINT ;

BEGIN

  fill.dstAdr   := bufadr ;
  fill.dstPitch := scr^.width ;
  fill.width    := scr^.width ;
  fill.height   := SHIFT(scr^.height,-1) ;
  fill.color    := VilZero ;

  ok := Vil.VillageRectFill(scr,ADR(fill)) ;
(*  Vil.WaitVillageBlit ;*)

END ClearBuf ;


(* für 68020er aufwärts *)
PROCEDURE SetPackedPixelO(scr{R.A0} : ScreenPtr ; x{R.D2},y{R.D3},color{R.D4} : CARDINAL) ;

  BEGIN
    ASSEMBLE( MULU     Screen.width(A0),D3
              ADD.L    D2,D3
              MOVE.B   D4,([Screen.bitMap.planes,A0],D3.L)
              END) ;
  END SetPackedPixelO ;


(* für 68000 ca. 2,5 Mal schneller als ein Modula-2 Konstrukt*)
PROCEDURE SetPackedPixel(scr{R.A0} : ScreenPtr ; x{R.D2},y{R.D3},color{R.D4} : CARDINAL) ;

  BEGIN
    (* Für 68000 *)
    ASSEMBLE( MOVE.L   Screen.bitMap.planes(A0),A1
              MULU     Screen.width(A0),D3
              ADD.L    D2,D3
              MOVE.B   D4,(A1,D3.L)
              END) ;
  END SetPackedPixel ;




PROCEDURE SetPPM(scr : ScreenPtr ; x,y : CARDINAL ; color : SHORTCARD) ;
VAR strt   : ADDRESS ;
    offset : LONGCARD ;

  BEGIN
    strt  := scr^.bitMap.planes[0] ;
    offset := LONGCARD(scr^.width) * LONGCARD(y) + x ;
    INC(strt,offset) ;
    strt^ := color ;

  END SetPPM ;




PROCEDURE SetTrueColorPixel(scr{R.A0} : ScreenPtr ; x{R.D2},y{R.D3}         : CARDINAL ;
                                                    r{R.D4},g{R.D5},b{R.D6} : CARDINAL) ;
  BEGIN
    (* Set TC Pix *)
    ASSEMBLE( MOVE.L   Screen.bitMap.planes(A0),A1
              MULU     Screen.width(A0),D3
              ADD.L    D2,D3
              MOVE.L   D3,D2
              ADD.L    D2,D3
              ADD.L    D2,D3
              MOVE.B   D6,(A1,D3.L)       (* evtl. vorher A1+D3 rechnen ?*)
              MOVE.B   D5,1(A1,D3.L)
              MOVE.B   D4,2(A1,D3.L)
              END) ;
  END SetTrueColorPixel ;


PROCEDURE Set15BitPixel(scr{R.A0} : ScreenPtr ; x{R.D2},y{R.D3}         : CARDINAL ;
                                                r{R.D4},g{R.D5},b{R.D6} : CARDINAL) ;
  BEGIN
    (* Set 15Bit Pix *)
    ASSEMBLE( MOVE.L   Screen.bitMap.planes(A0),A1 (* ADR. der Planes holen*)
              MULU     Screen.width(A0),D3         (* Y*Scr.Width*)
              ADD.L    D2,D3   (* + x *)
              MOVE.L   D3,D2   (*evtl. SHIFTEN? Testen wir halt mal..*)
              ADD.L    D2,D3   (* Mal 2 wg. 1 Pixel = 2 BYTE *)
              ADD.L    D3,A1   (* Base + Offset *)

              MOVE.B   D5,D2   (* Ist wohl etwas langsam aber wer *)
              LSL.B    #5,D2   (* benutzt schon Hi-Color ?        *)
              MOVE.B   D6,D3
              ANDI.B   #$1F,D3
              OR.B     D3,D2
              MOVE.B   D2,(A1)+
              MOVE.B   D5,D2
              LSR.B    #3,D2
              MOVE.B   D4,D3
              LSL.B    #2,D3
              ANDI.B   #$7C,D3
              OR.B     D3,D2
              MOVE.B   D2,(A1)
              END) ;
  END Set15BitPixel ;

PROCEDURE Set16BitPixel(scr{R.A0} : ScreenPtr ; x{R.D2},y{R.D3}         : CARDINAL ;
                                                r{R.D4},g{R.D5},b{R.D6} : CARDINAL) ;
  BEGIN
    (* Set 16Bit Pix *)
    ASSEMBLE( MOVE.L   Screen.bitMap.planes(A0),A1 (* ADR. der Planes holen*)
              MULU     Screen.width(A0),D3         (* Y*Scr.Width*)
              ADD.L    D2,D3   (* + x *)
              MOVE.L   D3,D2   (*evtl. SHIFTEN? Testen wir halt mal..*)
              ADD.L    D2,D3   (* Mal 2 wg. 1 Pixel = 2 BYTE *)
              ADD.L    D3,A1   (* Base + Offset *)

              MOVE.B   D5,D2   (* Ist wohl etwas langsam aber wer *)
              LSL.B    #5,D2   (* benutzt schon Hi-Color ?        *)
              MOVE.B   D6,D3
              ANDI.B   #$1F,D3
              OR.B     D3,D2
              MOVE.B   D2,(A1)+
              MOVE.B   D5,D2
              LSR.B    #3,D2
              MOVE.B   D4,D3
              LSL.B    #3,D3
              ANDI.B   #$F8,D3
              OR.B     D3,D2
              MOVE.B   D2,(A1)
              END) ;
  END Set16BitPixel ;



PROCEDURE Get15FromRGB(r{R.D4},g{R.D5},b{R.D6} : CARDINAL) : CARDINAL ;
  BEGIN
    ASSEMBLE( MOVE.W   D5,D0    (* Ist wohl etwas langsam aber wer *)
              LSL.W    #8,D0    (* benutzt schon Hi-Color ?        *)
              LSL.W    #5,D0    (* benutzt schon Hi-Color ?        *)
              MOVE.W   D6,D3
              ANDI.W   #$1F,D3
              LSL.W    #8,D3
              OR.W     D3,D0

              MOVE.B   D4,D2
              LSL.B    #2,D2
              ANDI.B   #$7C,D2
              MOVE.B   D5,D3
              LSR.B    #3,D3
              ANDI.B   #$03,D3
              OR.W     D3,D2
              OR.W     D2,D0
              END) ;
  END Get15FromRGB ;


PROCEDURE Get16FromRGB(r{R.D4},g{R.D5},b{R.D6} : CARDINAL) : CARDINAL ;
  BEGIN
    ASSEMBLE( MOVE.W   D5,D0    (* Ist wohl etwas langsam aber wer *)
              LSL.W    #8,D0    (* benutzt schon Hi-Color ?        *)
              LSL.W    #5,D0    (* benutzt schon Hi-Color ?        *)
              MOVE.W   D6,D3
              ANDI.W   #$1F,D3
              LSL.W    #8,D3
              OR.W     D3,D0

              MOVE.B   D4,D2
              LSL.B    #2,D2
              ANDI.B   #$7C,D2
              MOVE.B   D5,D3
              LSR.B    #3,D3
              ANDI.B   #$03,D3
              OR.W     D3,D2
              OR.W     D2,D0
              END) ;
  END Get16FromRGB ;


PROCEDURE LinePackedM(scr{R.A0} : ScreenPtr ; x1{R.D2},y1{R.D3},x2,y2,color{R.D4} : INTEGER) ;
VAR i,
    s1,s2        : INTEGER ;
    dx,dy        : INTEGER ;
    e            : LONGINT ;
    change       : BOOLEAN ;
    lock{R.A1}   : ADDRESS ;


  BEGIN
    IF (x1>scr^.width) OR (x2>scr^.width)
        OR (y1>scr^.height) OR (y2>scr^.height) THEN
      RETURN
    END ;

    dx := ABS(x2 - x1) ;
    dy := ABS(y2 - y1) ;
    IF dx#0 THEN
      s1 := (x2 - x1) DIV dx ;
    END ;
    IF dy#0 THEN
      s2 := (y2 - y1) DIV dy ;
    END ;

    IF dy>dx THEN
      dy := dx ;
      dx := ABS(y2 - y1) ;
      change := TRUE ;
    ELSE
      change := FALSE ;
    END ;

    e  := 2*dy - dx ;

    lock := Vil.LockVillageScreen(scr) ;

    FOR i:=1 TO dx DO
    ASSEMBLE( MOVEM.L  D2-D3,-(A7)
              MULU     Screen.width(A0),D3
              ADD.L    D2,D3
              MOVE.B   D4,(A1,D3.L)
              MOVEM.L  (A7)+,D2-D3
              END) ;
      WHILE e>=0 DO
        IF change THEN
          INC(x1,s1) ;
        ELSE
          INC(y1,s2)
        END ;
        e:=e-2*dx ;
      END (*WHILE*) ;
      IF change THEN
        INC(y1,s2)
      ELSE
        INC(x1,s1) ;
      END ;
      e:=e+2*dy ;
    END (*FOR i*) ;

  Vil.UnLockVillageScreen(scr) ;

  END LinePackedM ;


(*$EntryExitCode := FALSE *)
PROCEDURE TstL(scr{R.A0} : ScreenPtr ; a{R.D3} : LONGINT) ;
  BEGIN
  ASSEMBLE(		MOVEM.L 	D2-D7/A2-A6,-(A7)
			MOVE.L 		Vil(A4),A6
			JSR		Vil.LockVillageScreen(A6)
			MOVE.L		D0,A1
			MOVE.L		D3,D1
  Loop:			MOVE.B		#1,(A1)+
			DBRA		D1,Loop
			MOVEM.L 	(A7)+,D2-D7/A2-A6
			RTS
			END) ;
  END TstL ;


(*$EntryExitCode := FALSE *)
PROCEDURE LinePacked(scr{R.A0} : ScreenPtr ; x1{R.D5},y1{R.D6},
                                             x2{R.D2},y2{R.D3},color{R.D4} : LONGINT) ;
  BEGIN
ASSEMBLE(	MOVEM.L 	D2-D7/A6,-(A7)		(* Register retten	 *)
		CMPI.W		#0,D5
		BLT.S		Fail
		CMPI.W		#0,D6
		BLT.S		Fail
		CMPI.W		#0,D2
		BLT.S		Fail
		CMPI.W		#0,D3
		BLT.S		Fail
		CMP.W		Screen.width(A0),D5
		BPL.S		Fail
		CMP.W		Screen.width(A0),D2
		BPL.S		Fail
		CMP.W		Screen.height(A0),D6
		BPL.S		Fail
		CMP.W		Screen.height(A0),D3
		BMI.S		Los
Fail:		BRA		Ende

Los:		EXG.L		D5,D0
		EXG.L		D6,D1

	  	MOVEQ.L		#1,D5			(* xsign := 1		 *)
		MOVEQ.L		#0,D6			(* ysign := 0		 *)
		MOVE.W		Screen.width(A0),D6	(* ysign := width 	 *)
		MOVE.L		D6,D7			(* ysign -> D7 		 *)
		MULU		D1,D7			(* width * y1 		 *)
		ADD.L		D0,D7			(* + x1 	         *)
		CMP.L		D0,D2			(* x1 > x2		 *)
		BGT.S		LPJ1			(* ja, dann LPJ1	 *)
		NEG.L		D5			(* sonst xsign := -1	 *)
		EXG.L		D0,D2			(* SWAP x1,y1		 *)
LPJ1:		CMP.L		D1,D3			(* y1 > y2 ?		 *)
		BGT.S		LPJ2			(* ja, dann LPJ2	 *)
		NEG.L		D6			(* sonst ysign := -ysign *)
		EXG.L		D1,D3			(* SWAP y1,y2		 *)
LPJ2:		SUB.L		D0,D2			(* x1 - x2 -> D2	 *)
		SUB.L		D1,D3			(* y1 - y2 -> D3	 *)
		MOVE.L		A0,A3			(* scrptr nach A3 sichern*)
		MOVE.L 		Vil(A4),A6		(* VilBase nach A6 	 *)
		JSR		Vil.LockVillageScreen(A6)  (* LockScreen	 *)
		ADD.L		D7,D0			(* memstrt + D7	-> D0	 *)
		MOVE.L		D0,A0			(* D0 -> A0 1. Pixel 	 *)
		CMP.L		D2,D3			(* xoff(D2) >= yoff(D3)? *)
		BLT.S		LPStart			(* ja, dann LPStart	 *)
		EXG.L		D5,D6			(* sonst SWAP xsig<->ysig*)
		EXG.L		D2,D3			(* und   SWAP Xoff<->Yoff*)

LPStart:	MOVE.L		D2,D7			(* akku := xoffs	 *)
		NEG.L		D7			(* akku := - akku	 *)
		MOVE.L		D2,D1			(* offset := xoffs	 *)
		ADD.L		D5,D6			(* ysign := ysign + xsign*)
		BRA.S		LPGo			(* wg. Abfrage auf -1	 *)
LPLoop:		ADD.L		D3,D7			(* akku := akku + yoffs	 *)
		TST.L		D7			(* akku < 0 ?		 *)
		BMI.S		LPP			(* ja, dann LPP		 *)
		SUB.L		D2,D7			(* akku:=akku - xoffs	 *)
		ADDA.L		D6,A0			(* scradr := scradr+ysig *)
		BRA.S		LPGo			(* nach LPGo		 *)
LPP:		ADDA.L		D5,A0			(* scradr :=scradr+xsign *)
LPGo:		MOVE.B		D4,(A0)			(* color -> Pixadr	 *)
		DBRA		D1,LPLoop		(* Dec(offset) , LPLoop	 *)

		MOVE.L		A3,A0			(* Screen UnLock	 *)
		MOVE.L 		Vil(A4),A6
		JSR		Vil.UnLockVillageScreen(A6)
Ende:		MOVEM.L 	(A7)+,D2-D7/A6	 	(* Register zurück	 *)
		RTS
   	 END) ;

  END LinePacked ;


(*$EntryExitCode := FALSE *)
PROCEDURE LinePackedO(scr{R.A0} : ScreenPtr ; x1{R.D5},y1{R.D6},
                                              x2{R.D2},y2{R.D3},color{R.D4} : LONGINT) ;
  BEGIN
ASSEMBLE(
		MOVEM.L 	D2-D7/A6,-(A7)		(* Register retten	 *)
		EXG.L		D5,D0			(* Ist leider nötig, da  *)
		EXG.L		D6,D1			(* D1,D2 nicht als Par.  *)
	  	MOVEQ.L		#1,D5			(* xsign := 1		 *)
		MOVEQ.L		#0,D6			(* ysign := 0		 *)
		MOVE.W		Screen.width(A0),D6	(* ysign := width 	 *)
		MOVE.L		D6,D7			(* ysign -> D7 		 *)
		MULU		D1,D7			(* width * y1 		 *)
		ADD.L		D0,D7			(* + x1 	         *)
		CMP.L		D0,D2			(* x1 > x2		 *)
		BGT.S		LPJ1			(* ja, dann LPJ1	 *)
		NEG.L		D5			(* sonst xsign := -1	 *)
		EXG.L		D0,D2			(* SWAP x1,y1		 *)
LPJ1:		CMP.L		D1,D3			(* y1 > y2 ?		 *)
		BGT.S		LPJ2			(* ja, dann LPJ2	 *)
		NEG.L		D6			(* sonst ysign := -ysign *)
		EXG.L		D1,D3			(* SWAP y1,y2		 *)
LPJ2:		SUB.L		D0,D2			(* x1 - x2 -> D2	 *)
		SUB.L		D1,D3			(* y1 - y2 -> D3	 *)
		MOVE.L		A0,A1			(* scrptr nach A3 sichern*)
		MOVE.L 		Vil(A4),A6		(* VilBase nach A6 	 *)
		JSR		Vil.LockVillageScreen(A6)  (* LockScreen	 *)
		ADD.L		D7,D0			(* memstrt + D7	-> D0	 *)
		MOVE.L		D0,A0			(* D0 -> A0 1. Pixel 	 *)
		CMP.L		D2,D3			(* xoff(D2) >= yoff(D3)? *)
		BLT.S		LPStart			(* ja, dann LPStart	 *)
		EXG.L		D5,D6			(* sonst SWAP xsig<->ysig*)
		EXG.L		D2,D3			(* und   SWAP Xoff<->Yoff*)

LPStart:	MOVE.L		D2,D7			(* akku := xoffs	 *)
		NEG.L		D7			(* akku := - akku	 *)
		MOVE.L		D2,D1			(* offset := xoffs	 *)
		ADD.L		D5,D6			(* ysign := ysign + xsign*)
		BRA.S		LPGo			(* Wegen Abfrage auf -1  *)
LPLoop:		ADD.L		D3,D7			(* akku := akku + yoffs	 *)
		TST.L		D7			(* akku < 0 ?		 *)
		BMI.S		LPP			(* ja, dann LPP		 *)
		SUB.L		D2,D7			(* akku:=akku - xoffs	 *)
		ADDA.L		D6,A0			(* scradr := scradr+ysig *)
		BRA.S		LPGo			(* nach LPGo		 *)
LPP:		ADDA.L		D5,A0			(* scradr :=scradr+xsign *)
LPGo:		MOVE.B		D4,(A0)			(* color -> Pixadr	 *)
Loop:		DBRA		D1,LPLoop		(* Dec(offset) , LPLoop	 *)

		MOVE.L		A1,A0			(* Screen UnLock	 *)
		MOVE.L 		Vil(A4),A6
		JSR		Vil.UnLockVillageScreen(A6)
		MOVEM.L 	(A7)+,D2-D7/A6	 	(* Register zurück	 *)
		RTS
   	 END) ;

  END LinePackedO ;




PROCEDURE LineTrueColor(scr : ScreenPtr ; x1,y1,x2,y2,r,g,b : INTEGER) ;
VAR i,
    s1,
    s2           : INTEGER ;
    dx,dy        : INTEGER ;
    e            : LONGINT ;
    change       : BOOLEAN ;
    lock         : ADDRESS ;


  BEGIN
    IF (x1>scr^.width) OR (x2>scr^.width)
        OR (y1>scr^.height) OR (y2>scr^.height) THEN
      RETURN
    END ;

    dx := ABS(x2 - x1) ;
    dy := ABS(y2 - y1) ;
    IF dx#0 THEN
      s1 := (x2 - x1) DIV dx ;
    END ;
    IF dy#0 THEN
      s2 := (y2 - y1) DIV dy ;
    END ;

    IF dy>dx THEN
      dy := dx ;
      dx := ABS(y2 - y1) ;
      change := TRUE ;
    ELSE
      change := FALSE ;
    END ;

    e  := 2*dy - dx ;

    lock := Vil.LockVillageScreen(scr) ;

    FOR i:=1 TO dx DO
      SetTrueColorPixel(scr,x1,y1,r,g,b) ;
      WHILE e>=0 DO
        IF change THEN
          x1 := x1 + s1 ;
        ELSE
          y1 := y1 + s2 ;
        END ;
        e:=e-2*dx ;
      END (*WHILE*) ;
      IF change THEN
        y1 := y1 + s2 ;
      ELSE
        x1 := x1 + s1 ;
      END ;
      e:=e+2*dy ;
    END (*FOR i*) ;

  Vil.UnLockVillageScreen(scr) ;

  END LineTrueColor ;


PROCEDURE Line15Bit(scr : ScreenPtr ; x1,y1,x2,y2,r,g,b : INTEGER) ;
VAR i,
    s1,s2        : INTEGER ;
    dx,dy        : INTEGER ;
    e            : LONGINT ;
    change       : BOOLEAN ;
    lock         : ADDRESS ;


  BEGIN
    IF (x1>scr^.width) OR (x2>scr^.width)
        OR (y1>scr^.height) OR (y2>scr^.height) THEN
      RETURN
    END ;

    dx := ABS(x2 - x1) ;
    dy := ABS(y2 - y1) ;
    IF dx#0 THEN
      s1 := (x2 - x1) DIV dx ;
    END ;
    IF dy#0 THEN
      s2 := (y2 - y1) DIV dy ;
    END ;

    IF dy>dx THEN
      dy := dx ;
      dx := ABS(y2 - y1) ;
      change := TRUE ;
    ELSE
      change := FALSE ;
    END ;

    e  := 2*dy - dx ;

    lock := Vil.LockVillageScreen(scr) ;

    FOR i:=1 TO dx DO
      Set15BitPixel(scr,x1,y1,r,g,b) ;
      WHILE e>=0 DO
        IF change THEN
          x1 := x1 + s1 ;
        ELSE
          y1 := y1 + s2 ;
        END ;
        e:=e-2*dx ;
      END (*WHILE*) ;
      IF change THEN
        y1 := y1 + s2 ;
      ELSE
        x1 := x1 + s1 ;
      END ;
      e:=e+2*dy ;
    END (*FOR i*) ;

  Vil.UnLockVillageScreen(scr) ;

  END Line15Bit ;


PROCEDURE Line16Bit(scr : ScreenPtr ; x1,y1,x2,y2,r,g,b : INTEGER) ;
VAR i,
    s1,s2        : INTEGER ;
    dx,dy        : INTEGER ;
    e            : LONGINT ;
    change       : BOOLEAN ;
    lock         : ADDRESS ;


  BEGIN
    IF (x1>scr^.width) OR (x2>scr^.width)
        OR (y1>scr^.height) OR (y2>scr^.height) THEN
      RETURN
    END ;

    dx := ABS(x2 - x1) ;
    dy := ABS(y2 - y1) ;
    IF dx#0 THEN
      s1 := (x2 - x1) DIV dx ;
    END ;
    IF dy#0 THEN
      s2 := (y2 - y1) DIV dy ;
    END ;

    IF dy>dx THEN
      dy := dx ;
      dx := ABS(y2 - y1) ;
      change := TRUE ;
    ELSE
      change := FALSE ;
    END ;

    e  := 2*dy - dx ;

    lock := Vil.LockVillageScreen(scr) ;

    FOR i:=1 TO dx DO
      Set16BitPixel(scr,x1,y1,r,g,b) ;
      WHILE e>=0 DO
        IF change THEN
          x1 := x1 + s1 ;
        ELSE
          y1 := y1 + s2 ;
        END ;
        e:=e-2*dx ;
      END (*WHILE*) ;
      IF change THEN
        y1 := y1 + s2 ;
      ELSE
        x1 := x1 + s1 ;
      END ;
      e:=e+2*dy ;
    END (*FOR i*) ;

  Vil.UnLockVillageScreen(scr) ;

  END Line16Bit ;


PROCEDURE Kreis(scr : ScreenPtr ; x,y,r,col : INTEGER) ;
VAR xx,yy,w : INTEGER ;
    wi      : REAL ;
  BEGIN
    FOR w := 0 TO 360 DO
      wi := wi + Step ;
      xx := INTEGER(sin(wi) * REAL(r)) ;
      yy := INTEGER(cos(wi) * REAL(r)) ;
      SetPackedPixel(scr,x+xx,y+yy,col)
    END
  END Kreis ;


BEGIN

CLOSE
(*
  Assert(FALSE,ADR("Modula-2 Schnittstelle zur PICASSO\nDemo V0.99 ©1994 By Carsten Wartmann")) ;
*)
END VilIntuiSupD.

