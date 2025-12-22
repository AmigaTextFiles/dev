IMPLEMENTATION MODULE MuiSupport;

(*$ NilChk- *)
(*$ EntryClear- *)
(*$ Align- *)

(*$ CLEAR Locale *)

(* MuiSupport 2.0
** converted by C.Scholz
**
** HISTORY :
**
** 22.10.1993 : changed fail, it now does not use Terminal anymore.
**              Instead it uses Arts.Requester
**              (inspired by Michael Suelman)
**
**/// "$Log: MuiSupport.mod $
 * Revision 1.3  1996/08/14  01:39:07  olf
 * MUI 3.5
 *
 * Revision 1.2  1995/12/15  16:37:53  olf
 * - applied changes from Stefan Schulz
 * - cleanup of IMPORT section
 *"
# Revision 1.1  1995/09/25  15:32:52  olf
# Initial revision
#
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
**\\\
**
*)

FROM SYSTEM     IMPORT  ASSEMBLE, ADDRESS, ADR;
//FROM Arts       IMPORT  StrPtr, returnVal, Exit, Requester;
FROM ModulaLib   IMPORT  returnVal, Exit, TerminateRequester;
FROM MuiD       IMPORT  APTR ;

IMPORT
  ml : MuiL,
  R:Reg ;

PROCEDURE DoMethod(obj{R.A2} : APTR; msg{R.A1} : APTR);
(*$ EntryExitCode- *)

BEGIN

    ASSEMBLE (  MOVEA.L -4(A2),  A0
                MOVE.L   8(A0),-(A7)
                RTS
                END );

END DoMethod;

PROCEDURE DOMethod(obj{R.A2} : APTR; msg{R.A1} : APTR) : LONGINT;
(*$ EntryExitCode- *)

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
(*$ ELSE *) (*$ CopyDyn- *)
PROCEDURE fail(VAR app : APTR; str : ARRAY OF CHAR);
(*$ ENDIF *)

    VAR
        Result     : BOOLEAN;

    BEGIN
        IF app#NIL THEN ml.mDisposeObject(app); app:=NIL; END;

                (*$ IF Locale *)
        IF str # NIL THEN
                    returnVal:= 20;
                    TerminateRequester(str);
                (*$ ELSE *)
        IF str[0]#0C THEN
                    returnVal:= 20;
                    TerminateRequester(@str);
                (*$ ENDIF *)
                //Exit(20);
           ELSE
                Exit(0);
           END;
    END fail;

END MuiSupport.
