(*------------------------------------------

  :Module.      DebugLib.mod
  :Author.      Albert Weinert  [awn]
  :Address.     Adamsstr. 83; 51063 Köln; Germany
  :EMail.       a.weinert@darkness.gun.de
  :Phone.       +49-221-613100
  :Revision.    R.2
  :Date.        17-Sep-1994
  :Copyright.   Albert Weinert
  :Language.    Oberon-2
  :Translator.  AmigaOberon V3.20
  :Contents.    Interface to "debug.lib"
  :Imports.     SmallLib.mod (dummy by [awn])
  :Bugs.        when you use DebugLib.mod and RVI.mod together it may
  :Bugs.        be possible that the linker warns you about double symbols.
  :Bugs.        If this happens the remove the $JOIN rexxvars.o from RVI.mod and
  :Bugs.        add an import for SmallLib.mod in RVI.mod.
  :Remarks.     Needs interfaces 40.15 and "debug.lib"
  :History.     .1     [awn] 03-Jul-1994 : Erstellt
  :History.     .2     [awn] 17-Sep-1994 : Die Möglichkeit geschaffen über eine
  :History.            ENV-Variable die Ausgabe der Debuginformationen Ein- und
  :History.            Auszuschalten.

--------------------------------------------*)
MODULE DebugLib;

IMPORT  Dos, Exec, SmallLib, SYSTEM, OberonLib;

(* $JOIN debug.lib *)

VAR debug : BOOLEAN;

PROCEDURE KCmpStr{"KCmpStr"}( string1{8}, string2{9}: Exec.LSTRPTR );
PROCEDURE KGetChar{"KGetChar"}():CHAR;
PROCEDURE KGetNum{"KGetNum"}():LONGINT;
PROCEDURE KMayGetChar{"KMayGetChar"}():CHAR;
PROCEDURE KPrintF{"KPrintF"}(string{8}: Exec.LSTRPTR; values{9} : SYSTEM.ADDRESS );
PROCEDURE KPutChar{"KPutChar"}(char{0}: CHAR );
PROCEDURE KPutStr{"KPutString"}(string{8}: Exec.LSTRPTR);

PROCEDURE CmpStrA*( string1{8}, string2{9}: Exec.LSTRPTR );
  BEGIN
    (* $IF SmallData *)
    OberonLib.SetA5();
    (* $END *)
    IF debug THEN
      KCmpStr( string1, string2 );
    END;
  END CmpStrA;

PROCEDURE GetCharA*():CHAR;
  BEGIN
    (* $IF SmallData *)
    OberonLib.SetA5();
    (* $END *)
    IF debug THEN
      RETURN KGetChar();
    END;
    RETURN 0X;
  END GetCharA;

PROCEDURE GetNumA*():LONGINT;
  BEGIN
    (* $IF SmallData *)
    OberonLib.SetA5();
    (* $END *)
    IF debug THEN
      RETURN KGetNum();
    END;
    RETURN -1;
  END GetNumA;

PROCEDURE MayGetCharA*():CHAR;
  BEGIN
    (* $IF SmallData *)
    OberonLib.SetA5();
    (* $END *)
    IF debug THEN
      RETURN KMayGetChar();
    END;
    RETURN 0X;
  END MayGetCharA;

PROCEDURE PrintFA*(string{8}: Exec.LSTRPTR; values{9} : SYSTEM.ADDRESS );
  BEGIN
    (* $IF SmallData *)
    OberonLib.SetA5();
    (* $END *)
    IF debug THEN
      KPrintF(string, values );
    END;
  END PrintFA;

PROCEDURE PutCharA*(char{0}: CHAR );
  BEGIN
    (* $IF SmallData *)
    OberonLib.SetA5();
    (* $END *)
    IF debug THEN
      KPutChar( char );
    END;
  END PutCharA;

PROCEDURE PutStrA*(string{8}: Exec.LSTRPTR);
  BEGIN
    (* $IF SmallData *)
    OberonLib.SetA5();
    (* $END *)
    IF debug THEN
      KPutStr( string );
    END;
  END PutStrA;

(* For documentation of these procedures see AutoDoc "DebugLib.doc" *)

PROCEDURE CmpStr*{"DebugLib.CmpStrA"}( string1{8}, string2{9}: ARRAY OF CHAR );
PROCEDURE GetChar*{"DebugLib.GetCharA"}():CHAR;
PROCEDURE GetNum*{"DebugLib.GetNumA"}():LONGINT;
PROCEDURE MayGetChar*{"DebugLib.MayGetCharA"}():CHAR;
PROCEDURE PrintF*{"DebugLib.PrintFA"}(string{8}: ARRAY OF CHAR; values{9}.. : SYSTEM.ADDRESS );
PROCEDURE PutChar*{"DebugLib.PutCharA"}(char{0}: CHAR );
PROCEDURE PutStr*{"DebugLib.PutStrA"}(string{8}: ARRAY OF CHAR);


  PROCEDURE CheckForOutput*( name : ARRAY OF CHAR );
  (*------------------------------------------
    :Input.     name = name of env-variable to check
    :Input.            for exists.
    :Semantic.  Checks if an env-variable exists and then
    :Semantic.  sets the output on or off.
    :Update.    17-Sep-1994 [awn] - erstellt.
  --------------------------------------------*)
    VAR buffer : ARRAY 8 OF CHAR;
    BEGIN
      (* $IF SmallData *)
      OberonLib.SetA5();
      (* $END *)
      debug := Dos.GetVar( name, buffer, SIZE( buffer ), LONGSET{}) # -1;
    END CheckForOutput;

  PROCEDURE SetOutput*( value : BOOLEAN );
  (*------------------------------------------
    :Input.     value = TRUE or FALSE
    :Semantic.  Sets the debug output on or off
    :Update.    17-Sep-1994 [awn] - erstellt.
  --------------------------------------------*)
    BEGIN
      debug := value;
    END SetOutput;

END DebugLib.

