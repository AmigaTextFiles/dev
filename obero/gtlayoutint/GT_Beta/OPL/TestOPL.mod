(* ==================================================================== *)
(* === OPL - Oberon Portability Library =============================== *)
(* ==================================================================== *)

(*
******* TestOPL/--about-- *******
*
*    $RCSfile: TestOPL.mod $
*   $Revision: 1.1 $
*       $Date: 1995/09/02 04:19:16 $
*     $Author: phf $
*
* Description: Simple test module for the Oberon Portability Library.
*
*   Copyright: Copyright (c) 1995 by Peter Fröhlich [phf].
*              All rights reserved.
*
*     License: This  file  is  freely distributable as long as no
*              money is made by distributing it.  You are allowed
*              (and   actually   encouraged)   to  modify  it  as
*              necessary for your Oberon-2 implementation but you
*              must  tell me about your changes.  Public releases
*              of  modified  versions  may  only  be made with my
*              written and signed (PGP) approval.
*
*      e-mail: p.froehlich@amc.cube.net
*
*     $Source: Users:Homes/phf/Programming/Development/OPL/TXT/REPOSITORY/TestOPL.mod $
*
**************
*
**************
*)

(* ==================================================================== *)

MODULE TestOPL;

(* ==================================================================== *)

IMPORT
  OPLTermination, OPLObjects;

(* ==================================================================== *)

(*
******* TestOPL/--background-- *******
*
*   PURPOSE
*
*	Simple test module for the Oberon Portability Library.
*
*   NOTES
*
*	This module currently just imports all OPL modules for
*	easier recompilation. Real tests might be added in the
*	future.
*
*   ADAPTING TO YOUR OBERON-2 IMPLEMENTATION
*
*   NOTES ON SYSTEM: Amiga, AmigaOberon
*
*   SEE ALSO
*
*   REFERENCES
*
**************
*
**************
*)

(* === Versioning ===================================================== *)

CONST
  rcsId = "$Id: TestOPL.mod 1.1 1995/09/02 04:19:16 phf Exp $";

VAR
  dummy: CHAR; (* Dummy variable to keep optimizer from doing his work. *)

(* ==================================================================== *)
BEGIN
  dummy := rcsId[0];
END TestOPL.
(* ==================================================================== *)

(*
******* TestOPL/--history-- *******
*
* $Log: TestOPL.mod $
* Revision 1.1  1995/09/02  04:19:16  phf
* Initial revision
*
* History before introduction of RCS:
*
*   v0.1 (02-Sep-1995) [phf]
*
*	Editorial changes to the autodocs. Started using RCS so a
*	jump to version 1.1 occurs without technical reasons.
*
*   v0.0 (01-Jun-1995) [phf]
*
*	Created this module from scratch.
*
**************
*
**************
*)

(* ==================================================================== *)
