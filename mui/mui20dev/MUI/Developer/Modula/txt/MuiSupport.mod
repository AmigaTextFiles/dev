IMPLEMENTATION MODULE MuiSupport;

(*$ NilChk      := FALSE *)
(*$ EntryClear  := FALSE *)
(*$ LargeVars   := FALSE *)
(*$ StackParms  := FALSE *)

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
FROM Arts       IMPORT StrPtr, returnVal, Exit, Requester;
FROM SYSTEM     IMPORT ASSEMBLE, ADDRESS, ADR;
FROM IntuitionD IMPORT IClassPtr;
FROM UtilityD   IMPORT Hook;


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

PROCEDURE fail(VAR app : APTR; str : ARRAY OF CHAR);

    VAR
        Result     : BOOLEAN;

    BEGIN
        IF app#NIL THEN ML.mDisposeObject(app); app:=NIL; END;

        IF str[0]#0C THEN
                Result:=Requester(ADR("MUI-Request"),ADR(str),NIL,ADR("Oh..."));
                Exit(20);
           ELSE
                Exit(0);
           END;
    END fail;

END MuiSupport.
