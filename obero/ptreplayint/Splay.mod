(* ==================================================================== *)

(*
******* SPlay/--about-- *******
*
*    $RCSfile: Splay.mod $
*   $Revision: 1.1 $
*       $Date: 1995/08/30 06:11:25 $
*     $Author: phf $
*
* Description: Simple module player hack for testing PTReplay.
*
*   Copyright: Copyright (c) 1995 by Peter Fröhlich [phf].
*              All rights reserved.
*
*     License: This  file  is  freely distributable as long as no
*              money  is  made by distributing it.  If you modify
*              it   please  let  me  know.   You  may  distribute
*              modified versions as long as my original copyright
*              is  respected  and  your modifications are clearly
*              marked  as  such.   It  may  only  be used in non-
*              commercial projects.
*
*      e-mail: p.froehlich@amc.cube.net
*
*     $Source: Users:Homes/phf/Programming/Development/PTReplay/REPOSITORY/Splay.mod $
*
**************
*
**************
*)

(*
******* SPlay/--history-- *******
*
* $Log: Splay.mod $
* Revision 1.1  1995/08/30  06:11:25  phf
* Initial revision
*
**************
*
**************
*)

(* ==================================================================== *)

MODULE SPlay;

(* ==================================================================== *)

IMPORT P := PTReplay, D := Dos, E := Exec, I := Intuition, A := ASL,
       U := Utility, NoGuru, S := SYSTEM, Strings;

(* ==================================================================== *)

VAR module: P.ModulePtr; return: LONGINT; requester: A.ASLRequesterPtr;
    name: ARRAY 256 OF CHAR;

(* ==================================================================== *)

BEGIN

  IF P.base = NIL THEN
    D.PrintF ("Can't open ptreplay.library!\n", U.done);
    HALT(20);
  END;

  IF A.base = NIL THEN
    D.PrintF ("Can't open asl.library!\n", U.done);
    HALT(20);
  END;

  requester := A.AllocAslRequestTags (
    A.fileRequest,
    A.titleText, S.ADR ("Select a module..."),
    A.rejectIcons, I.LTRUE,
    U.done
  );
  IF requester = NIL THEN
    D.PrintF ("Can't allocate file requester!\n");
    HALT(20);
  END;

  IF ~A.AslRequestTags (requester, U.done) THEN
    D.PrintF ("No file selected!\n");
    HALT(0);
  END;

(*  D.PrintF ("Drawer: %s File: %s\n", requester(A.FileRequesterPtr).dir, requester(A.FileRequesterPtr).file);*)
  name := "";
  Strings.Append (name, requester(A.FileRequesterPtr).dir^);
  IF Strings.Length (name) > 0 THEN
    Strings.AppendChar (name, "/"); (* HACK: Won't handle weird cases! *)
  END;
  Strings.Append (name, requester(A.FileRequesterPtr).file^);
(*  D.PrintF ("Path: %s\n", S.ADR(name));*)

  module := P.LoadModule (name);
  IF module = NIL THEN
    D.PrintF ("Can't play selected module. Maybe not a ProTracker tune?\n");
    HALT(10);
  END;

  return := P.Play (module);
  D.PrintF ("Playing \"%s\", press CTRL-C to stop.\n", module.modName);

  WHILE E.Wait (LONGSET{D.ctrlC}) # LONGSET{D.ctrlC} DO END;

  return := P.Stop (module);

CLOSE

  IF module # NIL THEN
    P.UnloadModule (module);
  END;

  IF requester # NIL THEN
    A.FreeAslRequest (requester);
  END;

(* ==================================================================== *)
END SPlay.
(* ==================================================================== *)
