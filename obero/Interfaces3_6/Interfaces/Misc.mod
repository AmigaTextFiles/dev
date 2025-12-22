(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Misc.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Misc;

IMPORT e * := Exec;


CONST

(*
 * Unit number definitions.  Ownership of a resource grants low-level
 * bit access to the hardware registers.  You are still obligated to follow
 * the rules for shared access of the interrupt system (see
 * exec.library/SetIntVector or cia.resource as appropriate).
 *)
  serialPort   * = 0; (* Amiga custom chip serial port registers
                         (SERDAT,SERDATR,SERPER,ADKCON, and interrupts) *)
  serialBits   * = 1; (* Serial control bits (DTR,CTS, etc.) *)
  parallelPort * = 2; (* The 8 bit parallel data port
                         (CIAAPRA & CIAADDRA only!) *)
  parallelBits * = 3; (* All other parallel bits & interrupts
                         (BUSY,ACK,etc.) *)

  miscName * = "misc.resource";


VAR

(*
 *  You have to put a pointer to the misc.resource here to use the misc
 *  procedures:
 *)

  base * : e.APTR;


PROCEDURE AllocMiscResource *{base,-  6}(unitNum{0}  : LONGINT;
                                         name{9}     : ARRAY OF CHAR): e.APTR;
PROCEDURE FreeMiscResource  *{base,- 12}(unitNum{0}  : LONGINT);

END Misc.


