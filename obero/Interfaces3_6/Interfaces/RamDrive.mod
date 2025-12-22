(*
(*
**  Amiga Oberon Interface Module:
**  $VER: RamDrive.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V40.15 by hartmut Goebel
*)
*)

MODULE RamDrive;

IMPORT e * := Exec;

CONST
  ramDriveName * = "ramdrive.device";

VAR
(*  You have to put a pointer to the ramdrive.device here to use the ramdrive
 *  procedures:
 *)

  base * : e.DevicePtr;

(*--- functions in V34 or higher (Release 1.3) ---*)
PROCEDURE KillRAD0 *{base,- 42}(): e.LSTRPTR;

(*--- functions in V36 or higher (Release 2.0) ---*)
PROCEDURE KillRAD  *{base,- 48}(unit{0} : LONGINT): e.LSTRPTR;

END RamDrive.


