(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Disk.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Disk;

IMPORT e * := Exec;

TYPE

(********************************************************************
*
* Resource structures
*
********************************************************************)

  DiscResourceUnitPtr * = UNTRACED POINTER TO DiscResourceUnit;
  DiscResourceUnit * = STRUCT (message * : e.Message)
    discBlock * : e.Interrupt;
    discSync * : e.Interrupt;
    index * : e.Interrupt;
  END;

  DiscResourcePtr * = UNTRACED POINTER TO DiscResource;
  DiscResource * = STRUCT (library * : e.Library)
    current * : DiscResourceUnitPtr;
    flags * : SHORTSET;
    pad * : e.BYTE;
    sysLib * : e.LibraryPtr;
    ciaResource * : e.LibraryPtr;
    unitID * : ARRAY 4 OF LONGINT;
    waiting * : e.List;
    discBlock * : e.Interrupt;
    discSync * : e.Interrupt;
    index * : e.Interrupt;
    currTask * : e.TaskPtr;
  END;

CONST

(* DiskResource.flags entries *)
  alloc0  * = 0;      (* unit zero is allocated *)
  alloc1  * = 1;      (* unit one is allocated *)
  alloc2  * = 2;      (* unit two is allocated *)
  alloc3  * = 3;      (* unit three is allocated *)
  active  * = 7;      (* is the disc currently busy? *)



(********************************************************************
*
* Hardware Magic
*
********************************************************************)


  dskDMAOff * = 4000H;   (* idle command for dsklen register *)


(********************************************************************
*
* Resource specific commands
*
********************************************************************)

(*
 * DISKNAME is a generic macro to get the name of the resource.
 * This way if the name is ever changed you will pick up the
 *  change automatically.
 *)

  diskName * = "disk.resource";


(********************************************************************
*
* drive types
*
********************************************************************)

  amiga         * = 000000000H;
  drt37422D2S   * = 055555555H;
  empty         * = 0FFFFFFFFH;
  drt150RPM     * = 0AAAAAAAAH;


VAR

(*
 *  You have to put a pointer to the disk.resource here to use the disk
 *  procedures:
 *)

  base * : DiscResourcePtr;

PROCEDURE AllocUnit *{base,- 6}(unitNum{0}     : LONGINT): BOOLEAN;
PROCEDURE FreeUnit  *{base,-12}(unitNum{0}     : LONGINT);
PROCEDURE GetUnit   *{base,-18}(unitPointer{9} : DiscResourceUnitPtr): DiscResourceUnitPtr;
PROCEDURE GiveUnit  *{base,-24}();
PROCEDURE GetUnitID *{base,-30}(unitNum{0}     : LONGINT): LONGINT;
PROCEDURE ReadUnitID*{base,-36}(unitNum{0}     : LONGINT): LONGINT;

END Disk.

