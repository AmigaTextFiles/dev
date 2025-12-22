MODULE  IconSupport;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  c:=Conversions,
        e:=Exec,
        ic:=Icon,
        wb:=Workbench;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE GetTTValueInt()" ---------------------- *)
PROCEDURE GetTTValueInt * (icon: wb.DiskObjectPtr;
                           tt: ARRAY OF CHAR;
                           def: LONGINT): LONGINT; (* $CopyArrays- *)

VAR     dummyInt: LONGINT;
        toolStr: e.LSTRPTR;

BEGIN
  toolStr:=ic.FindToolType(icon.toolTypes,tt);
  IF toolStr#NIL THEN
    IF c.StringToInt(toolStr^,dummyInt) THEN END;
    RETURN dummyInt;
  ELSE
    RETURN def;
  END;
END GetTTValueInt;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE GetTTValueStr()" ---------------------- *)
PROCEDURE GetTTValueStr * (icon: wb.DiskObjectPtr;
                           tt: ARRAY OF CHAR;
                           def: e.STRING): e.STRING; (* $CopyArrays- *)

VAR     dummyStr: e.STRING;
        toolStr: e.LSTRPTR;

BEGIN
  toolStr:=ic.FindToolType(icon.toolTypes,tt);
  IF toolStr#NIL THEN
    COPY(toolStr^,dummyStr);
    RETURN dummyStr;
  ELSE
    RETURN def;
  END;
END GetTTValueStr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE GetTTValueBool()" ---------------------- *)
PROCEDURE GetTTValueBool * (icon: wb.DiskObjectPtr;
                            tt: ARRAY OF CHAR;
                            def: BOOLEAN): BOOLEAN; (* $CopyArrays- *)

VAR     toolStr: e.LSTRPTR;

BEGIN
  toolStr:=ic.FindToolType(icon.toolTypes,tt);
  IF toolStr#NIL THEN
    RETURN (ic.MatchToolValue(toolStr^,"TRUE") OR
            ic.MatchToolValue(toolStr^,"YES") OR
            ic.MatchToolValue(toolStr^,"ON") OR
            ic.MatchToolValue(toolStr^,"1"));
  ELSE
    RETURN def;
  END;
END GetTTValueBool;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE LookupToolType()" ---------------------- *)
PROCEDURE LookupToolType * (icon: wb.DiskObjectPtr;
                            tt: ARRAY OF CHAR): BOOLEAN; (* $CopyArrays- *)
BEGIN
  RETURN (ic.FindToolType(icon.toolTypes,tt)#NIL);
END LookupToolType;
(* \\\ ------------------------------------------------------------------------- *)

END IconSupport.
