(*------------------------------------------

  :Module.      EasyRexx.mod
  :Author.      Volker Stolz  [vs]
  :Address.     Kückstr. 54 , D-52499 Baesweiler
  :EMail.       Vok@TinDrum.tng.oche.de
  :Phone.       +49 2401 53164
  :Fax.         +49 2401 88869
  :Date.        03-Nov-1995
  :Copyright.   Volker Stolz, 1995
  :Copyright.   It may be distributed freely as long as it remains unchanged.

  :Language.    Oberon-2
  :Translator.  Oberon 3.11 05-Dec-93
  :Contents.    Interface to Ketil Hunn`s easyrexx.library

  :Remarks.     Please report any bugs & suggestions to
  :Remarks.     <Vok@TinDrum.tng.oche.de> (Volker Stolz) or to
  :Remarks.     <Ketil.Hunn@hiMolde.no> (Ketil Hunn).

  :Remarks.     I had to change the name of the ARexxCommandShell-function
  :Remarks.     to OpenARexxCommandShell because of naming-conflicts.

  :Remarks.     Remember to check "base # NIL" and library-version !
  :Remarks.     Private data is not exported.

  :History.     .0     [vs] 03-Nov-1995 : Created

--------------------------------------------*)
MODULE EasyRexx;

IMPORT
  Dos,
  E   : Exec,
  I   : Intuition,
  G   : Graphics,
  U   : Utility,
  sys : SYSTEM,
  R   : Rexx;

CONST
  easyRexxName    *= "easyrexx.library";
  easyRexxVersion *= 3;

TYPE
  ARexxCommandTable *= STRUCT
                         id          *: LONGINT;
                         command*,
                         cmdTemplate *: E.STRPTR;
                         userData    *: E.APTR;
                       END;

(* This one is for accesing the CommandTable easily: *)
  ARexxCommandArrayPtr *= UNTRACED POINTER TO ARRAY MAX(INTEGER)-1 OF ARexxCommandTable;

  ARexxCommandShell *= STRUCT
                         commandWindow : I.WindowPtr;
                         readPort,
                         writePort     : E.MsgPortPtr;
                         readReq,
                         writeReq      : E.IOStdReqPtr;
                         prompt        : E.LSTRPTR;
                         buffer        : ARRAY 256 OF CHAR;
                         iBuf,inBuffer : E.UBYTE;
                         cursor        : E.BYTE;
                         font          : G.TextFontPtr;
                       END;
  ARexxCommandShellPtr *= UNTRACED POINTER TO ARexxCommandShell;

  ARexxContext *= STRUCT
                    port    -: E.MsgPortPtr;
                    table   -: ARexxCommandArrayPtr;
                    argCopy,
                    portName-: E.STRPTR;
                    maxArgs  : E.UBYTE;
                    rdArgs   : Dos.RDArgsPtr;
                    msg      : R.RexxMsgPtr;
                    flags    : E.ULONG;
                    id      -: LONGINT;
                    argv     : UNTRACED POINTER TO ARRAY MAX(INTEGER)-1 OF LONGINT;
                    queue    : E.ULONG;
                    author,
                    copyright,
                    version,
                    lastError: E.STRPTR;
                    reservedCommands : ARexxCommandArrayPtr;
                    shell    : ARexxCommandShellPtr;
                    signals  : LONGSET;
                    result1,
                    result2  : E.APTR;
                    asynchPort : E.MsgPortPtr;
                  END;

ARexxContextPtr *= UNTRACED POINTER TO ARexxContext;

ARexxMacroData *= STRUCT
                    list *: E.ListPtr;
                  END;
ARexxMacro *= UNTRACED POINTER TO ARexxMacroData;

CONST
  TagBase      *= U.user;
  PortName     *= TagBase+1;
  CommandTable *= TagBase+2;
  ReturnCode   *= TagBase+3;
  Result       *= ReturnCode;
  Result1      *= ReturnCode;
  Result2      *= TagBase+4;
  Port         *= TagBase+5;
  ResultString *= TagBase+6;
  ResultLong   *= TagBase+7;

(* EasyRexx V2 Tags *)

  Asynch       *= TagBase+8;
  Context      *= TagBase+9;
  Author       *= TagBase+10;
  Copyright    *= TagBase+11;
  Version      *= TagBase+12;
  Prompt       *= TagBase+13;
  Close        *= TagBase+14;
  ErrorMessage *= TagBase+15;
  Flags        *= TagBase+16;
  Font         *= TagBase+17;

(* EasyREXX V3 Tags *)

  Macro        *= TagBase+18;
  MacroFile    *= TagBase+19;
  Record       *= TagBase+20;
  File         *= TagBase+21;
  String       *= TagBase+22;
  Command      *= TagBase+23;
  Arguments    *= TagBase+24;
  Argument     *= Arguments;
  ArgumentsLength *= TagBase+25;
  ArgumentLength  *= ArgumentsLength;

TYPE
  RecordPointerType *= ARRAY 38 OF E.WORD;

(* Sorry, not ported yet !*)

VAR
  base -: E.LibraryPtr;

PROCEDURE FreeARexxContext* {base,-78} (context{8} : ARexxContextPtr);
PROCEDURE AllocARexxContextA* {base,-84} (tagList{8} : ARRAY OF U.TagItem) : ARexxContextPtr;
PROCEDURE AllocARexxContext*  {base,-84} (tag1{8}.. : U.Tag) : ARexxContextPtr;
PROCEDURE GetARexxMsg* {base,-90} (context{8} : ARexxContextPtr) : BOOLEAN;
PROCEDURE SendARexxCommandA* {base,-96} (command{9} : E.STRPTR; tagList{8} : ARRAY OF U.TagItem) : LONGINT;
PROCEDURE SendARexxCommand* {base,-96} (command{9} : E.STRPTR; tag1{8}.. : U.Tag) : LONGINT;
PROCEDURE ReplyARexxMsgA* {base,-102} (context{9} : ARexxContextPtr; tagList{8} : ARRAY OF U.TagItem);
PROCEDURE ReplyARexxMsg* {base,-102} (context{9} : ARexxContextPtr; tag1{8}.. : U.Tag);

(* Prototypes V2.0 *)
PROCEDURE OpenARexxCommandShellA* {base,-108} (context{9} : ARexxContextPtr; tagList{8} : ARRAY OF U.TagItem) : BOOLEAN;
PROCEDURE OpenARexxCommandShell* {base,-108} (context{9} : ARexxContextPtr; tag1{8}.. : U.Tag) : BOOLEAN;

(* Prototypes V3.0 *)
PROCEDURE AllocARexxMacroA* {base,-114} (tagList{8} : ARRAY OF U.TagItem) : ARexxMacro;
PROCEDURE AllocARexxMacro* {base,-114} (tag1{8}.. : U.Tag) : ARexxMacro;
PROCEDURE IsARexxMacroEmpty* {base,-120} (macro{8} : ARexxMacro) : BOOLEAN;
PROCEDURE ClearARexxMacro* {base,-126} (macro{8} : ARexxMacro);
PROCEDURE FreeARexxMacro* {base,-132} (macro{8} : ARexxMacro);
PROCEDURE AddARexxMacroCommandA* {base,-138} (macro{9} : ARexxMacro; tagList{8} : ARRAY OF U.TagItem);
PROCEDURE AddARexxMacroCommand* {base,-138} (macro{9} : ARexxMacro; tag1{8}.. : U.Tag);
PROCEDURE WriteARexxMacroA* {base,-144} (context{8} : ARexxContextPtr; macro{10} : ARexxMacro; macroName{11} : E.UBYTE; tagList{8} : ARRAY OF U.TagItem) : E.BYTE;
PROCEDURE WriteARexxMacro* {base,-144} (context{8} : ARexxContextPtr; macro{10} : ARexxMacro; macroName{11} : E.UBYTE; tagList{8}.. : U.Tag) : E.BYTE;
PROCEDURE RunARexxMacroA* {base,-150} (context{9} : ARexxContextPtr; tagList{8} : ARRAY OF U.TagItem) : E.UBYTE;
PROCEDURE RunARexxMacro* {base,-150} (context{9} : ARexxContextPtr; tag1{8}.. : U.Tag) : E.UBYTE;
PROCEDURE CreateARexxStemA* {base,-156} (context{9} : ARexxContextPtr; stemName{10} : E.UBYTE; vars{8} : ARRAY OF E.STRPTR ) : E.BYTE;
PROCEDURE CreateARexxStem* {base,-156} (context{9} : ARexxContextPtr; stemName{10} : E.UBYTE; vars{8}.. : E.STRPTR) : E.BYTE;

(* C-Macro-like Functions [vs] *)

PROCEDURE SafeToQuit*(c : ARexxContextPtr) : BOOLEAN;
BEGIN
  RETURN c.queue = 0;
END SafeToQuit;

PROCEDURE Arg*(c : ARexxContextPtr; i : INTEGER) : LONGINT;
BEGIN
  RETURN c.argv^[i];
END Arg;

PROCEDURE ArgNumber*(c : ARexxContextPtr; i : INTEGER) : LONGINT;
BEGIN
  RETURN c.argv^[i];
END ArgNumber;

PROCEDURE ArgString*(c : ARexxContextPtr; i : INTEGER) : E.STRPTR;
BEGIN
  RETURN sys.VAL(E.STRPTR,c.argv^[i]);
END ArgString;

PROCEDURE ArgBool*(c : ARexxContextPtr; i : INTEGER) : BOOLEAN;
BEGIN
  RETURN c.argv^[i] # NIL;
END ArgBool;

(* Signals *)

PROCEDURE ShellSignals* (c : ARexxContextPtr) : LONGSET;
BEGIN
  IF c.shell # NIL THEN
    RETURN LONGSET{c.shell.readPort.sigBit,c.shell.commandWindow.userPort.sigBit};
  ELSE
    RETURN LONGSET{};
  END;
END ShellSignals;

PROCEDURE SignalDummy* (c : ARexxContextPtr) : LONGSET;
BEGIN
  RETURN LONGSET{c.port.sigBit,c.asynchPort.sigBit}+ShellSignals(c);
END SignalDummy;

PROCEDURE Signal*(c : ARexxContextPtr) : LONGSET;
BEGIN
  IF c # NIL THEN
    RETURN SignalDummy(c);
  ELSE
    RETURN LONGSET{};
  END;
END Signal;

PROCEDURE SetSignals*(c : ARexxContextPtr; s : LONGSET);
BEGIN
  c.signals:=s;
END SetSignals;

(* Results *)

PROCEDURE GetRC*(c : ARexxContextPtr) : E.APTR;
BEGIN
  IF c # NIL THEN
    RETURN c.result1;
  ELSE
    RETURN NIL;
  END;
END GetRC;

PROCEDURE GetResult1*(c : ARexxContextPtr) : E.APTR;
BEGIN
  RETURN GetRC(c);
END GetResult1;

PROCEDURE GetResult2*(c : ARexxContextPtr) : E.APTR;
BEGIN
  IF c # NIL THEN
    RETURN c.result2;
  ELSE
    RETURN NIL;
  END;
END GetResult2;

(* Misc *)

PROCEDURE IsShellOpen*(c : ARexxContextPtr) : BOOLEAN;
BEGIN
  RETURN (c.shell # NIL);
END IsShellOpen;

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

(* Remember : YOU are to check "base # NIL" and library-version !!! *)

BEGIN
  base:=E.OpenLibrary(easyRexxName,0);
CLOSE
  IF base # NIL THEN E.CloseLibrary(base); END;
END EasyRexx.
