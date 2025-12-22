IMPLEMENTATION MODULE MuiSupport;

(*$ NilChk      := FALSE *)
(*$ EntryClear  := FALSE *)
(*$ LargeVars   := FALSE *)
(*$ StackParms  := FALSE *)

(*$ DEFINE Locale:=TRUE *)

(* MuiSupport 2.0
** converted by C.Scholz
**
** HISTORY :
**
** 22.10.1993 : changed fail, it now does not use Terminal anymore.
**              Instead it uses Arts.Requester
**              (inspired by Michael Suelman)
**
** $Log: MuiSupport.mod,v $
# Revision 1.6  1994/08/16  20:33:19  Kochtopf
# fail bei +LOCALE berichtigt, so dass der String nicht auf 0C, sondern
# auf NIL getestet wird.
#
# Revision 1.5  1994/08/11  17:00:11  Kochtopf
# *** empty log message ***
#
# Revision 1.4  1994/02/09  14:50:03  Kochtopf
# Versionsnummer in 2.0 geaendert.
#
# Revision 1.3  1994/02/02  09:37:18  Kochtopf
# app bei fail in VAR-Parameter geaendert.
#
# Revision 1.2  1994/02/01  16:49:10  Kochtopf
# kleine Veraenderungen.
#
**
**
*)


IMPORT R;
IMPORT MD:MuiD;
IMPORT ML:MuiL;
FROM Arts       IMPORT returnVal, Exit, Requester;
FROM SYSTEM     IMPORT ASSEMBLE, ADDRESS, ADR;
FROM IntuitionD IMPORT IClassPtr;
FROM UtilityD   IMPORT Hook;
FROM MuiD       IMPORT APTR, StrPtr; (* || this is || *)


PROCEDURE DoMethod(obj{R.A2} : APTR; msg{R.A1} : APTR);
(*$ EntryExitCode:=FALSE *)

BEGIN

    ASSEMBLE (  MOVEA.L -4(A2),  A0
                MOVE.L   8(A0),-(A7)
                RTS
                END );

END DoMethod;

PROCEDURE DOMethod(obj{R.A2} : APTR; msg{R.A1} : APTR) : LONGINT;
(*$ EntryExitCode:=FALSE *)

BEGIN

    ASSEMBLE (  MOVEA.L -4(A2),  A0
                MOVE.L   8(A0),-(A7)
                RTS
                END );

END DOMethod;



(*****************)
(* Fail Function *)
(*****************)

(*$ IF Locale *)
PROCEDURE fail(VAR app : APTR; str : StrPtr);
(*$ ELSE *) (*$ CopyDyn := FALSE *)
PROCEDURE fail(VAR app : APTR; str : ARRAY OF CHAR);
(*$ ENDIF *)

    VAR
        Result     : BOOLEAN;

    BEGIN
        IF app#NIL THEN ML.mDisposeObject(app); app:=NIL; END;

                (*$ IF Locale *)
        IF str # NIL THEN
                    Result:=Requester(ADR("MUI-Request"),str,NIL,ADR("Oh..."));
                (*$ ELSE *)
        IF str[0]#0C THEN
                    Result:=Requester(ADR("MUI-Request"),ADR(str),NIL,ADR("Oh..."));
                (*$ ENDIF *)
                Exit(20);
           ELSE
                Exit(0);
           END;
    END fail;

END MuiSupport.
