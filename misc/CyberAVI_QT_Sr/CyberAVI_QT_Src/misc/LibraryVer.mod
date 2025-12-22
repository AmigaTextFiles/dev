MODULE  LibraryVer;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

IMPORT  e:=Exec;

(* /// ---------------------- "PROCEDURE CheckVersion()" ----------------------- *)
PROCEDURE CheckVersion * (lib: e.LibraryPtr;
                          ver: LONGINT;
                          rev: LONGINT): BOOLEAN;
BEGIN
  IF lib#NIL THEN
    RETURN (lib.version>ver) OR ((lib.version=ver) & (lib.revision>=rev));
  ELSE
    RETURN FALSE;
  END;
END CheckVersion;
(* \\\ ------------------------------------------------------------------------- *)

END LibraryVer.

