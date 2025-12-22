(*$L+*)
(*$V-*)
(*$R-*)
(*#############################*)
 IMPLEMENTATION MODULE EasyRexx;      (* 103195 *)
(*#############################*)

FROM SYSTEM   IMPORT ADDRESS, ADR, BYTE, INLINE, SETREG;
FROM Assembly3 IMPORT ADDQ, BEQ, JMP, JSR, LEA, MOVE, MOVEA, MOVEMea, MOVEMreg,
                     MOVEQ, RTS, TST, UNLK,
                     L12, W12, B12, L6,
                     BitPos6, BitPos12, BitPos13,
                     A0, A0b9, A1, A1b9, A2, A2b9, A3, A3b9, A4, A4b9,
                     A5, A5b9, A6, A6b9, A7, A7b9,
                     D0, D0b9, D1, D1b9, D2, D2b9, D3, D3b9, D4, D4b9,
                     D5, D5b9, D6, D6b9, D7, D7b9,
                     ARdir, ARdirb6, ARdisp, ARdispb6, ARind, ARindm,
                     ARindmb6, ARindp;

FROM AmigaDOS2   IMPORT RDArgsPtr;
FROM Intuition   IMPORT WindowPtr;
FROM IODevices   IMPORT IOStdReqPtr;
FROM Lists       IMPORT ListPtr;
FROM Memory      IMPORT AllocMem, FreeMem, MemClear, MemChip, MemReqSet;
FROM Ports       IMPORT MsgPortPtr;
FROM RexxStorage IMPORT RexxMsgPtr;
FROM Tasks       IMPORT SignalSet;
FROM Text        IMPORT TextFontPtr;
FROM Utility     IMPORT TagItemPtr;

TYPE ARexxCommandShellRec = RECORD
                              commandWindow  :WindowPtr;
                              readPort,
                              writePort      :MsgPortPtr;
                              readReq,
                              writeReq       :IOStdReqPtr;
                              prompt         :POINTER TO CHAR;
                              buffer         :ARRAY[0..255] OF CHAR;
                              ibuf,
                              inbuffer       :CHAR;
                              cursor         :BYTE;
                              font           :TextFontPtr;
                            END;
     ARexxCommandShell = POINTER TO ARexxCommandShellRec;

TYPE ARexxContextRec = RECORD

              (*** PRIVATE ****************************)
                       port             :MsgPortPtr;
                       table            :POINTER TO ARRAY[0..99] OF ARexxCommandTable;
                       argcopy,
                       portname         :CharPointer;
                       maxargs          :BYTE;
                       rdargs           :RDArgsPtr;
                       msg              :RexxMsgPtr;
                       flags            :LONGCARD;

              (*** "PUBLIC" ****************************)
                       id               :LONGINT;
                       argv             :POINTER TO ARRAY[0..99] OF ADDRESS;
                       Queue            :LONGCARD;       (* FROM HERE AND DOWN: ONLY AVAILABLE FROM V2 *)

              (*** PRIVATE ***************************)
                       author,
                       copyright,
                       version,
                       lasterror        :CharPointer;
                       reservedcommands :ARexxCommandTablePtr;
                       shell            :ARexxCommandShell;
                       signals          :SignalSet;
                       Result1,
                       Result2          :LONGINT;
                       asynchport       :MsgPortPtr;
                    END;
     ARexxContext = POINTER TO ARexxContextRec;

     ARexxMacroData = RECORD
                        list:ListPtr;
                      END;
     ARexxMacro = POINTER TO ARexxMacroData;

TYPE PointerData = ARRAY[0..18] OF LONGCARD;
VAR  ERRecordPointer :POINTER TO PointerData;

(*** EASYREXXMACROS ***************************************************************)

(*============================================================*)
 PROCEDURE ERShellSignals(context:ARexxContext):SignalSet;
(*============================================================*)
BEGIN WITH context^ DO

IF shell # NIL THEN
   RETURN SignalSet{CARDINAL(shell^.readPort^.mpSigBit),
                    CARDINAL(shell^.commandWindow^.UserPort^.mpSigBit)};
ELSE
   RETURN SignalSet{};
END;

END END ERShellSignals;

(*=======================================================*)
 PROCEDURE ERSignals(context:ARexxContext):SignalSet;
(*=======================================================*)
BEGIN WITH context^ DO

RETURN SignalSet{CARDINAL(port^.mpSigBit), CARDINAL(asynchport^.mpSigBit)} + ERShellSignals(context);

END END ERSignals;

(*==================================================*)
 PROCEDURE ERSignal(context:ARexxContext):SignalSet;
(*==================================================*)
BEGIN

IF context # NIL THEN
   RETURN ERSignals(context);
ELSE
   RETURN SignalSet{};
END;

END ERSignal;

(*========================================================*)
 PROCEDURE ERSafeToQuit(context:ARexxContext):BOOLEAN;
(*========================================================*)
BEGIN

IF context # NIL THEN
   RETURN context^.Queue = 0D;
ELSE
   RETURN FALSE;(*?*)
END;

END ERSafeToQuit;

(*=========================================================*)
 PROCEDURE ERSetSignals(context:ARexxContext; s:SignalSet);
(*=========================================================*)
BEGIN

IF context # NIL THEN
   context^.signals := s;
END;

END ERSetSignals;

(*=========================================================*)
 PROCEDURE ERIsShellOpen(context:ARexxContext):BOOLEAN;
(*=========================================================*)
BEGIN

RETURN context^.shell # NIL;

END ERIsShellOpen;

(*=============================================*)
 PROCEDURE Id(context:ARexxContext):LONGINT;
(*=============================================*)
BEGIN

RETURN context^.id;

END Id;

(*===============================================*)
 PROCEDURE Port(context:ARexxContext):MsgPortPtr;
(*===============================================*)
BEGIN

RETURN context^.port;

END Port;

(*===============================================================*)
 PROCEDURE Portname(context:ARexxContext; VAR nam:ARRAY OF CHAR);
(*===============================================================*)

VAR  cp :CharPointer;
     i  :INTEGER;

BEGIN

i := 0;
cp := context^.portname;
LOOP
   nam[i] := cp^;
   IF cp^ = 0C THEN
      EXIT;
   END;
   INC(i);
   cp := ADDRESS(cp)+1D;
END;

END Portname;

(*========================================================================*)
 PROCEDURE Table(context:ARexxContext; i:INTEGER):ARexxCommandTablePtr;
(*========================================================================*)
BEGIN

RETURN ADR(context^.table^[i]);

END Table;

(*=========================================================*)
 PROCEDURE Arg(context:ARexxContext; i:INTEGER):ADDRESS;
(*=========================================================*)
BEGIN

RETURN context^.argv^[i];

END Arg;

(*===============================================================*)
 PROCEDURE ArgNumber(context:ARexxContext; i:INTEGER):LONGINT;
(*===============================================================*)

TYPE LongIntPtr = POINTER TO LONGINT;
VAR  lip :LongIntPtr;

BEGIN

lip := LongIntPtr(context^.argv^[i]);
RETURN lip^;

END ArgNumber;

(*===================================================================*)
 PROCEDURE ArgString(context:ARexxContext; i:INTEGER):CharPointer;
(*===================================================================*)
BEGIN

RETURN CharPointer(context^.argv^[i]);

END ArgString;

(*=============================================================*)
 PROCEDURE ArgBool(context:ARexxContext; i:INTEGER):BOOLEAN;
(*=============================================================*)
BEGIN

RETURN context^.argv^[i] # NIL;

END ArgBool;

(*================================================*)
 PROCEDURE GetRC(context:ARexxContext):LONGINT;
(*================================================*)
BEGIN

IF context # NIL THEN
   RETURN context^.Result1;
ELSE
   RETURN 0D;
END;

END GetRC;

(*======================================================*)
 PROCEDURE GetResult1(context:ARexxContext):LONGINT;
(*======================================================*)
BEGIN

RETURN GetRC(context);

END GetResult1;

(*======================================================*)
 PROCEDURE GetResult2(context:ARexxContext):LONGINT;
(*======================================================*)
BEGIN

IF context # NIL THEN
   RETURN context^.Result2;
ELSE
   RETURN 0D;
END;

END GetResult2;

(*===============================================*)
 PROCEDURE TableEnd(VAR entry:ARexxCommandTable);
(*===============================================*)
BEGIN WITH entry DO

id := 0D;
command := NIL;
cmdtemplate := NIL;
userdata := NIL;

END END TableEnd;

(*==================================================*)
 PROCEDURE FreeARexxContext(context:ARexxContext);
(*==================================================*)

BEGIN
INLINE(UNLK+A5);

(* FreeARexxContext(context)(a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(4);
INLINE(ADDQ+L6+ 2048 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-004EH);

END FreeARexxContext;

(*================================================================*)
 PROCEDURE AllocARexxContextA(taglist:TagItemPtr):ARexxContext;
(*================================================================*)
BEGIN
INLINE(UNLK+A5);

(* AllocARexxContextA(taglist)(a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(4);
INLINE(ADDQ+L6+ 2048 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-0054H);

END AllocARexxContextA;

(*======================================================*)
 PROCEDURE GetARexxMsg(context:ARexxContext):BYTE;
(*======================================================*)
BEGIN
INLINE(UNLK+A5);

(* GetARexxMsg(context)(a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(4);
INLINE(ADDQ+L6+ 2048 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-005AH);

END GetARexxMsg;

(*===========================================================================*)
 PROCEDURE SendARexxCommandA(command:CharPointer; taglist:TagItemPtr):LONGINT;
(*===========================================================================*)
BEGIN
INLINE(UNLK+A5);

(* SendARexxCommandA(command,taglist)(a1,a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVEA+L12+A1b9+A7+ARdisp);
INLINE(8);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(8);
INLINE(ADDQ+L6+ 0 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-0060H);

END SendARexxCommandA;

(*======================================================================*)
 PROCEDURE ReplyARexxMsgA(context:ARexxContext; taglist:TagItemPtr);
(*======================================================================*)
BEGIN
INLINE(UNLK+A5);

(* ReplyARexxMsgA(context,taglist)(a1,a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVEA+L12+A1b9+A7+ARdisp);
INLINE(8);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(8);
INLINE(ADDQ+L6+ 0 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-0066H);

END ReplyARexxMsgA;

(*=================================================================================*)
 PROCEDURE ARexxCommandShellA(context:ARexxContext; taglist:TagItemPtr):BYTE;
(*=================================================================================*)
BEGIN
INLINE(UNLK+A5);

(* ARexxCommandShellA(context,taglist)(a1,a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVEA+L12+A1b9+A7+ARdisp);
INLINE(8);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(8);
INLINE(ADDQ+L6+ 0 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-006CH);

END ARexxCommandShellA;

(*=========================================*)
 PROCEDURE CreateERRecordPointer():ADDRESS;
(*=========================================*)

VAR  bRes :BOOLEAN;

BEGIN

IF ERRecordPointer = NIL THEN
   ERRecordPointer := AllocMem(SIZE(PointerData), MemReqSet{MemChip, MemClear});
   IF ERRecordPointer # NIL THEN
      ERRecordPointer^[1] :=   3221241856D (*0C0004000H*);  (* arrow *)
      ERRecordPointer^[2] :=   1879093248D (*07000B000H*);
      ERRecordPointer^[3] :=   1006652416D (*03C004C00H*);
      ERRecordPointer^[4] :=   1056981760D (*03F004300H*);
      ERRecordPointer^[5] :=    532684992D (*01FC020C0H*);
      ERRecordPointer^[6] :=    532684800D (*01FC02000H*);
      ERRecordPointer^[7] :=    251662592D (*00F001100H*);
      ERRecordPointer^[8] :=    226497152D (*00D801280H*);
      ERRecordPointer^[9] :=     79694144D (*004C00940H*);
      ERRecordPointer^[10] :=    73402528D (*0046008A0H*);
      ERRecordPointer^[11] :=     2097216D (*000200040H*);

      ERRecordPointer^[13] :=       59288D (*00000E798*);   (* REC *)
      ERRecordPointer^[14] :=       37924D (*000009424*);
      ERRecordPointer^[15] :=       59168D (*00000E720*);
      ERRecordPointer^[16] :=       37924D (*000009424*);
      ERRecordPointer^[17] :=       38808D (*000009798*);
   END;
END;

RETURN ERRecordPointer;

END CreateERRecordPointer;

(*==============================*)
 PROCEDURE FreeERRecordPointer();
(*==============================*)

BEGIN

IF ERRecordPointer # NIL THEN
   FreeMem(ERRecordPointer, SIZE(PointerData));
   ERRecordPointer := NIL;
END;

END FreeERRecordPointer;

(*========================================================*)
 PROCEDURE AllocARexxMacroA(taglist:TagItemPtr):ARexxMacro;
(*========================================================*)
BEGIN
INLINE(UNLK+A5);

(* AllocARexxMacroA(taglist)(a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(4);
INLINE(ADDQ+L6+ 2048 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-0078H);

END AllocARexxMacroA;

(*====================================================*)
 PROCEDURE IsARexxMacroEmpty(macro:ARexxMacro):BYTE;
(*====================================================*)
BEGIN
INLINE(UNLK+A5);

(* IsARexxMacroEmpty(macro)(a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(4);
INLINE(ADDQ+L6+ 2048 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-007EH);

END IsARexxMacroEmpty;

(*==========================================*)
 PROCEDURE ClearARexxMacro(macro:ARexxMacro);
(*==========================================*)
BEGIN
INLINE(UNLK+A5);

(* ClearARexxMacro(macro)(a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(4);
INLINE(ADDQ+L6+ 2048 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-0084H);

END ClearARexxMacro;

(*==========================================*)
 PROCEDURE FreeARexxMacro(macro:ARexxMacro);
(*==========================================*)
BEGIN
INLINE(UNLK+A5);

(* FreeARexxMacro(macro)(a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(4);
INLINE(ADDQ+L6+ 2048 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-008AH);

END FreeARexxMacro;

(*==================================================================+++++==*)
 PROCEDURE AddARexxMacroCommandA(macro:ARexxMacro; taglist:TagItemPtr):BYTE;
(*====================================================================+++++*)
BEGIN
INLINE(UNLK+A5);

(* AddARexxMacroCommandA(macro,taglist)(a1,a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVEA+L12+A1b9+A7+ARdisp);
INLINE(8);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(8);
INLINE(ADDQ+L6+ 0 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-0090H);

END AddARexxMacroCommandA;

(*========================================================================================*)
 PROCEDURE WriteARexxMacroA(context:ARexxContext; macro:ARexxMacro; macroname:CharPointer;
                            taglist:TagItemPtr):BYTE;
(*========================================================================================*)
BEGIN
INLINE(UNLK+A5);

(* WriteARexxMacroA(context,macro,macroname,taglist)(a1,a2,a3,a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVEA+L12+A3b9+A7+ARdisp);
INLINE(8);
INLINE(MOVEA+L12+A2b9+A7+ARdisp);
INLINE(12);
INLINE(MOVEA+L12+A1b9+A7+ARdisp);
INLINE(16);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(16);
INLINE(LEA+A7b9+A7+ARdisp);
INLINE(16);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-0096H);

END WriteARexxMacroA;

(*=========================================================================*)
 PROCEDURE RunARexxMacroA(context:ARexxContext; taglist:TagItemPtr):BYTE;
(*=========================================================================*)
BEGIN
INLINE(UNLK+A5);

(* RunARexxMacroA(context,taglist)(a1,a0) *)

INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(4);
INLINE(MOVEA+L12+A1b9+A7+ARdisp);
INLINE(8);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(8);
INLINE(ADDQ+L6+ 0 +A7+ARdir);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-009CH);

END RunARexxMacroA;

(*=====================================================================*)
 PROCEDURE CreateARexxStemA(context:ARexxContext; stemname:CharPointer;
                            VAR vars:ARRAY OF CharPointer):BYTE;
(*=====================================================================*)
BEGIN
INLINE(UNLK+A5);

(* CreateARexxStemA(context,stemname,vars)(a1,a2,a0,<d0>) *)

(*INLINE(MOVEQ+D0b9);*)
(*INLINE(MOVE+W12+D0b9+A7+ARdisp);*)
(*INLINE(4);*)
INLINE(MOVEA+L12+A0b9+A7+ARdisp);
INLINE(6);
INLINE(MOVEA+L12+A2b9+A7+ARdisp);
INLINE(10);
INLINE(MOVEA+L12+A1b9+A7+ARdisp);
INLINE(14);
INLINE(MOVE+L12 +A7b9+ARdispb6 +A7+ARind);
INLINE(14);
INLINE(LEA+A7b9+A7+ARdisp);
INLINE(14);
SETREG(A6+8, EasyRexxBase);
INLINE(JMP+A6+ARdisp);
INLINE(-00A2H);

END CreateARexxStemA;

(*----------------------*)
 BEGIN (* mod init code *)
(*----------------------*)

EasyRexxBase := NIL;
ERRecordPointer := NIL;

END EasyRexx.
