PROGRAM RemMemory;

{ ** Erzeugt künstliche Speicherknappheit
  **
  ** (C) 1995 by Björn Schotte, FREEWARE
  **
  ** EMail: bjoern@bomber.mayn.de
  **
  ** }
  
USES Exec;

{$opt q;incl "dos.lib"}

TYPE
  targ = RECORD
    bytes	: ^LONG;
	 typ     : STR;
  END;
  
CONST
  _id = "$VER: RemMem V1.00 (24.10.1995)";
  
VAR
  template : STRING;
  arg : ^targ;
  rd : p_RDArgs;
  i,mysize,size,memo : LONG;
  typ : STRING;
  p : PTR;

PROCEDURE Upper(VAR s:STRING);
VAR i : INTEGER;
BEGIN
  FOR i := 1 TO Length(s) DO s[i] := Upcase(s[i]);
END;
  	
BEGIN
  OpenLib(DOSBase, "dos.library", 37);
  IF FromWB THEN EXIT;
  template := "SIZE/N,TYPE";
  arg := AllocVec(SizeOf(targ),MEMF_ANY OR MEMF_CLEAR);
  IF arg = NIL THEN
  BEGIN
	 Writeln("Not enough memory free!");
	 DOSExit(20);
  END;
  rd := ReadArgs(^template,arg,NIL);
  IF rd <> NIL THEN
  BEGIN
	 IF arg^.typ <> "" THEN typ := arg^.typ ELSE typ := "ANY";
	 Upper(typ);
	 if arg^.bytes <> NIL THEN size := arg^.bytes^ ELSE size := 0;
	 FreeArgs(rd);
	 IF size = 0 THEN
	 BEGIN
		FreeVec(arg);
		Writeln("Memory size must be greater than 0!");
		DosExit(20);
	 END;
	 IF typ = "ANY" THEN
	   i := MEMF_ANY
	 ELSE IF typ = "PUBLIC" THEN
	   i := MEMF_PUBLIC
	 ELSE IF typ = "FAST" THEN
	   i := MEMF_FAST
	 ELSE IF typ = "CHIP" THEN
	   i := MEMF_CHIP
	 ELSE BEGIN
		FreeVec(arg);
		Writeln("Wrong memory type!");
		DosExit(20);
    END;
	 memo := AvailMem(i OR MEMF_LARGEST);
	 mysize := memo - size*1024;
	 p := AllocVec(mysize,i);
	 IF p = NIL THEN
	 BEGIN
		Writeln("Couldn't allocate ",size:8," bytes of memory!");
		DosExit(20);
	 END;
	 Writeln("Waiting for ^C...");
	 i := _Wait(SIGBREAKF_CTRL_C);
	 FreeVec(p);
  END;
  FreeVec(arg);
  DOSExit(0);
END.
