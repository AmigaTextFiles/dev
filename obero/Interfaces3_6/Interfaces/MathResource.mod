(*
(*
**  Amiga Oberon Interface Module:
**  $VER: MathResource.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE MathResource;   (* $Implementation- *)

IMPORT e * := Exec;

TYPE

(*
*       The 'Init' entries are only used if the corresponding
*       bit is set in the Flags field.
*
*       So if you are just a 68881, you do not need the Init stuff
*       just make sure you have cleared the Flags field.
*
*       This should allow us to add Extended Precision later.
*
*       For Init users, if you need to be called whenever a task
*       opens this library for use, you need to change the appropriate
*       entries in MathIEEELibrary.
*)

  MathIEEEResourcePtr * = UNTRACED POINTER TO MathIEEEResource;
  MathIEEEResource * = STRUCT (node * : e.Node)
    flags * : SET;
    baseAddr * : e.APTR; (* ptr to 881 if exists *)
    dblBasInit * : e.PROC;
    dblTransInit * : e.PROC;
    sglBasInit * : e.PROC;
    sglTransInit * : e.PROC;
    extBasInit * : e.PROC;
    extTransInit * : e.PROC;
  END;

CONST

(* definations for MathIEEEResource_FLAGS *)
  dblBas     * = 0;
  dblTrans   * = 1;
  sglBas     * = 2;
  sglTrans   * = 3;
  extBas     * = 4;
  extTrans   * = 5;

END MathResource.

