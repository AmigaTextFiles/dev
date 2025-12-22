(* ==================================================================== *)

(*
******* TestGTLayout/--about-- *******
*
*    $RCSfile: TestGTLayout.mod $
*   $Revision: 1.1 $
*       $Date: 1995/09/06 02:16:07 $
*     $Author: phf $
*
* Description: Simple test/demo program for the AmigaOberon interface
*              to gtlayout.library.
*
*   Copyright: Copyright (c) 1995 by Peter Fröhlich [phf].
*              All rights reserved.
*
*     License: This  file  is  freely distributable as long as no
*              money  is  made by distributing it.  If you modify
*              it   please  let  me  know.   You  may  distribute
*              modified versions as long as my original copyright
*              is  respected  and  your modifications are clearly
*              marked as such.  You may use it in any application
*              you develop; it's royalty-free.
*
*      e-mail: p.froehlich@amc.cube.net
*
*     $Source: Users:Homes/phf/Programming/Development/GTLayout/TXT/REPOSITORY/TestGTLayout.mod $
*
**************
*
**************
*)

(* ==================================================================== *)

MODULE TestGTLayout;

(* ==================================================================== *)

IMPORT
  E := Exec, I := Intuition, U := Utility, GT := GadTools, D := Dos,
  G := Graphics, LT := GTLayout, S := SYSTEM, T := OPLTermination;

(* ==================================================================== *)

(*
******* TestGTLayout/--background-- *******
*
*   PURPOSE
*
*	Simple test/demo program for the AmigaOberon interface
*	to gtlayout.library.
*
*   NOTES
*
*	This example is a more or less direct conversion of Olaf's
*	demo program from the the documentation just brought a bit
*	up-to-date.
*
*   SEE ALSO
*
*	gtlayout.doc
*
*   REFERENCES
*
*	Aminet: comm/term/term43#?
*
**************
*
**************
*)

(* ==================================================================== *)

VAR
  handle: LT.LayoutHandlePtr;
  window: I.WindowPtr;
  msg: I.IntuiMessagePtr;
  qualifier: SET;
  class: LONGSET;
  code: INTEGER;
  gadget: I.GadgetPtr;
  done: BOOLEAN;

(* ==================================================================== *)

(* termination handler *)
PROCEDURE* Close ();
BEGIN
  IF (handle # NIL) THEN LT.DeleteHandle (handle); END;
END Close;

(* ==================================================================== *)

BEGIN

  (* enure that gtlayout.library is present *)
  T.Assert (LT.base # NIL, "TestGTLayout.BEGIN", "Can't open gtlayout.library.");

  (* clear globals the termination handler depends on *)
  handle := NIL;

  (* install our termination handler *)
  T.Register (Close);

  (* create the handle *)
  handle := LT.CreateHandleTags (NIL, LT.lhAutoActivate, I.LFALSE, U.done);
  T.Assert (handle # NIL, "TestGTLayout.BEGIN", "Can't create handle.");

  (* construct window's layout *)

  LT.New (handle,
    LT.laType, LT.verticalKind,           (* A vertical group. *)
    LT.laLabelText, S.ADR ("Main group"), (* Group title text. *)
    U.done
  );

    LT.New (handle,
      LT.laType, GT.buttonKind,           (* A plain button. *)
      LT.laLabelText, S.ADR ("A button"),
      LT.laID, 11,
      U.done
    );

    LT.New (handle,
      LT.laType, LT.xbarKind, (* A separator bar. *)
      U.done
    );

    LT.New (handle,
      LT.laType, GT.buttonKind,                 (* A plain button. *)
      LT.laLabelText, S.ADR ("Another button"),
      LT.laID, 22,
      U.done
    );

    LT.New(handle,
      LT.laType, LT.endKind, (* This ends the current group. *)
      U.done
    );

  (* open the window *)
  window := LT.Build (handle,
    LT.lawnTitle, S.ADR ("Window Title"),
    LT.lawnIDCMP, LONGSET{I.closeWindow},
    I.waCloseGadget, I.LTRUE,
    U.done
  );
  T.Assert (window # NIL, "TestGTLayout.BEGIN", "Can't open window.");

  (* event loop *)
  done := FALSE;  
  REPEAT

    E.WaitPort (window.userPort);

    REPEAT
      msg := LT.GetIMsg (handle);

      IF msg # NIL THEN

        class     := msg.class;
        code      := msg.code;
        qualifier := msg.qualifier;
        gadget    := msg.iAddress;

        LT.ReplyIMsg (msg);

        IF I.closeWindow IN class THEN
          done := TRUE;
        ELSIF I.gadgetUp IN class THEN
          CASE gadget.gadgetID OF
            11:
              D.PrintF ("Pressed the upper button.\n");
              |
            22:
              D.PrintF ("Pressed the lower button.\n");
          ELSE
            D.PrintF ("Unexpected GadgetID.\n");
          END;
        ELSE
          D.PrintF ("Unexpected IDCMP code!\n");
        END;

      END;

    UNTIL msg = NIL;

  UNTIL done;

  (* everythings fine *)
  T.HALT (T.okay);

END TestGTLayout.

(* ==================================================================== *)

(*
******* TestGTLayout/--history-- *******
*
* $Log: TestGTLayout.mod $
* Revision 1.1  1995/09/06  02:16:07  phf
* Initial revision
*
*
**************
*
**************
*)

(* ==================================================================== *)
