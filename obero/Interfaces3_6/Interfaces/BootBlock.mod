(*
(*
**  Amiga Oberon Interface Module:
**  $VER: BootBlock.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE BootBlock;   (* $Implementation- *)

IMPORT e   * := Exec,
       sys * := SYSTEM;

TYPE

  BootBlockPtr * = UNTRACED POINTER TO BootBlock;
  BootBlock * = STRUCT
    id * : ARRAY 4 OF CHAR;          (* 4 character identifier *)
    chkSum * : LONGINT;              (* boot block checksum (balance) *)
    dosBlock * : LONGINT;            (* reserved for DOS patch *)
  END;

CONST

  bootSects   * = 2;      (* 1K bootstrap *)

  idDos    * = 'DOS\o';
  idKick   * = 'KICK';

  nameDos  * = sys.VAL(LONGINT,idDos);    (* 'DOS\0' *)
  nameKick * = sys.VAL(LONGINT,idKick);   (* 'KICK' *)

END BootBlock.


