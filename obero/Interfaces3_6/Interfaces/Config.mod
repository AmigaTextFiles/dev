(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Config.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V40.15 by hartmut Goebel
*)
*)

MODULE Config;  (* $Implementation- *)

IMPORT e * := Exec;

TYPE

(*
** AutoConfig (tm) boards each contain a 32 byte "ExpansionRom" area that is
** read by the system software at configuration time.  Configuration of each
** board starts when the ConfigIn* signal is passed from the previous board
** (or from the system for the first board).  Each board will present it's
** ExpansionRom structure at location 00E80000H to be read by the system.
** This file defines the appearance of the ExpansionRom area.
**
** Expansion boards are actually organized such that only one nybble per
** 16 bit word contains valid information.  The low nybbles of each
** word are combined to fill the structure below. (This table is structured
** as LOGICAL information.  This means that it never corresponds exactly
** with a physical implementation.)
**
** The ExpansionRom space is further split into two regions:  The first 16
** bytes are read-only.  Except for the er_type field, this area is inverted
** by the system software when read in.  The second 16 bytes contain the
** control portion, where all read/write registers are located.
**
** The system builds one "ConfigDev" structure for each board found.  The
** list of boards can be examined using the expansion.library/FindConfigDev
** function.
**
** A special "hacker" Manufacturer ID number is reserved for test use:
** 2011 (7DBH).  When inverted this will look like 0F824H.
*)

  ExpansionRomPtr * = UNTRACED POINTER TO ExpansionRom;
  ExpansionRom * = STRUCT      (* -First 16 bytes of the expansion ROM *)
    type         * : SHORTINT; (* Board type, size and flags *)
    product      * : SHORTINT; (* Product number, assigned by manufacturer *)
    flags        * : SHORTSET; (* Flags *)
    reserved03   * : SHORTINT; (* Must be zero (0FFH inverted) *)
    manufacturer * : INTEGER;  (* Unique ID,ASSIGNED BY COMMODORE-AMIGA! *)
    serialNumber * : LONGINT;  (* Available for use by manufacturer *)
    initDiagVec  * : INTEGER;  (* Offset to optional "DiagArea" structure *)
    reserved0c   * : SHORTINT;
    reserved0d   * : SHORTINT;
    reserved0e   * : SHORTINT;
    reserved0f   * : SHORTINT;
  END;


(*
** Note that use of the ec_BaseAddress register is tricky.  The system
** will actually write twice.  First the low order nybble is written
** to the ec_BaseAddress register+2 (D15-D12).  Then the entire byte is
** written to ec_BaseAddress (D15-D8).  This allows writing of a byte-wide
** address to nybble size registers.
*)

  ExpansionControlPtr * = UNTRACED POINTER TO ExpansionControl;
  ExpansionControl * = STRUCT   (* -Second 16 bytes of the expansion ROM *)
    interrupt  * : SHORTINT; (* Optional interrupt control register *)
    z3HighBase * : SHORTINT; (* Zorro III   : Config address bits 24-31 *)
    baseAddress* : SHORTINT; (* Zorro II/III: Config address bits 16-23 *)
    shutup     * : SHORTINT; (* The system writes here to shut up a board *)
    reserved14 * : SHORTINT;
    reserved15 * : SHORTINT;
    reserved16 * : SHORTINT;
    reserved17 * : SHORTINT;
    reserved18 * : SHORTINT;
    reserved19 * : SHORTINT;
    reserved1a * : SHORTINT;
    reserved1b * : SHORTINT;
    reserved1c * : SHORTINT;
    reserved1d * : SHORTINT;
    reserved1e * : SHORTINT;
    reserved1f * : SHORTINT;
  END;

(*
** many of the constants below consist of a triplet of equivalent
** definitions: xxMASK is a bit mask of those bits that matter.
** xxBIT is the starting bit number of the field.  xxSIZE is the
** number of bits that make up the definition.  This method is
** used when the field is larger than one bit.
**
** If the field is only one bit wide then the xxB_xx and xxF_xx convention
** is used (xxB_xx is the bit number, and xxF_xx is mask of the bit).
*)

CONST

(* manifest constants *)
  slotSize    * = 10000H;
  slotMask    * = 0FFFFH;
  slotShift   * = 16;

(* these define the free regions of Zorro memory space.
** THESE MAY WELL CHANGE FOR FUTURE PRODUCTS!
*)
  eExpansionBase      * = 000E80000H;    (* Zorro II  config address *)
  eZ3ExpansionBase    * = 0FF000000H;    (* Zorro III config address *)

  eExpansionSize      * = 000080000H;    (* Zorro II  I/O type cards *)
  eExpansionSlots     * = 8;

  eMemoryBase         * = 000200000H;    (* Zorro II  8MB space *)
  eMemorySize         * = 000800000H;
  eMemorySlotrs       * = 128;

  eZ3ConfigArea       * = 040000000H;    (* Zorro III space *)
  eZ3ConfigAreaEnd    * = 07FFFFFFFH;    (* Zorro III space *)
  eZ3SizeGranularity  * = 000080000H;    (* 512K increments *)



(**** er_Type definitions (ttldcmmm) ***************************************)

(* er_Type board type bits -- the OS ignores "old style" boards *)
  ertTypeMask         * = -64;   (* Bits 7-6 *)
  ertTypeBit          * = 6;
  ertTypeSize         * = 2;
  ertNewBoard         * = -64;
  ertZorroII          * = ertNewBoard;
  ertZorroIII         * = -128;

(* other bits defined in er_Type *)
  ertbMemList        * = 5;  (* Link RAM into free memory list *)
  ertbDiagValid      * = 4;  (* ROM vector is valid *)
  ertbChainedConfig  * = 3;  (* Next config is part of the same card *)

  ertfMemList        * = 20H;
  ertfDiagValid      * = 10H;
  ertfChainedConfig  * = 08H;

(* er_Type field memory size bits *)
  ertMemMask         * = 07H;  (* Bits 2-0 *)
  ertMemBit          * = 0;
  ertMemSize         * = 3;



(**** er_Flags byte -- for those things that didn't fit into the type byte ****)
(**** the hardware stores this byte in inverted form                       ****)
  erffMemSpace       * = -128;   (* Wants to be in 8 meg space. *)
  erfbMemSpace       * = 7;      (* (NOT IMPLEMENTED) *)

  erffNoShutUp       * = 64;     (* Board can't be shut up *)
  erfbNOShutUP       * = 6;

  erffExtended       * = 32;     (* Zorro III: Use extended size table *)
  erfbExtended       * = 5;      (*            for bits 0-2 of er_Type *)
                                  (* Zorro II : Must be 0 *)

  erffZorroIII       * = 16;     (* Zorro III: must be 1 *)
  erfbZorroIII       * = 4;      (* Zorro II : must be 0 *)

  ertZ3SSMask        * = 0FH;    (* Bits 3-0.  Zorro III Sub-Size.  How *)
  ertZ3SSBit         * = 0;      (* much space the card actually uses   *)
  ertZ3SSSize        * = 4;      (* (regardless of config granularity)  *)
                                 (* Zorro II : must be 0        *)


(* ec_Interrupt register (unused) ********************************************)
  ecibINTENA         * = 1;
  ecibRESET          * = 3;
  ecibINT2PEND       * = 4;
  ecibINT6PEND       * = 5;
  ecibINT7PEND       * = 6;
  ecibINTERRUPTING   * = 7;

  ecifINTENA         * = 2;
  ecifRESET          * = 8;
  ecifINT2PEND       * = 16;
  ecifINT6PEND       * = 32;
  ecifINT7PEND       * = 64;
  ecifINTERRUPTING   * = -128;



(***************************************************************************
**
** these are the specifications for the diagnostic area.  If the Diagnostic
** Address Valid bit is set in the Board Type byte (the first byte in
** expansion space) then the Diag Init vector contains a valid offset.
**
** The Diag Init vector is actually a word offset from the base of the
** board.  The resulting address points to the base of the DiagArea
** structure.  The structure may be physically implemented either four,
** eight, or sixteen bits wide.  The code will be copied out into
** ram first before being called.
**
** The da_Size field, and both code offsets (da_DiagPoint and da_BootPoint)
** are offsets from the diag area AFTER it has been copied into ram, and
** "de-nibbleized" (if needed).  (In other words, the size is the size of
** the actual information, not how much address space is required to
** store it.)
**
** All bits are encoded with uninverted logic (e.g. 5 volts on the bus
** is a logic one).
**
** If your board is to make use of the boot facility then it must leave
** its config area available even after it has been configured.  Your
** boot vector will be called AFTER your board's final address has been
** set.
**
****************************************************************************)

TYPE

  DiagAreaPtr * = UNTRACED POINTER TO DiagArea;
  DiagArea * = STRUCT
    config * : e.BYTE;       (* see below for definitions *)
    flags * : SHORTSET;      (* see below for definitions *)
    size * : INTEGER;        (* the size (in bytes) of the total diag area *)
    diagPoint * : INTEGER;   (* where to start for diagnostics, or zero *)
    bootPoint * : INTEGER;   (* where to start for booting *)
    name * : INTEGER;        (* offset in diag area where a string *)
                             (*   identifier can be found (or zero if no *)
                             (*   identifier is present). *)

    reserved01 * : INTEGER;  (* two words of reserved data.  must be zero. *)
    reserved02 * : INTEGER;
  END;

CONST

(* da_Config definitions *)
(*
** dacBYTEWIDE can be simulated using dacNIBBLEWIDE.
*)
  dacBusWidth    * = 0C0X;    (* two bits for bus width *)
  dacNibbleWide  * = 000X;
  dacByteWide    * = 040X;    (* BUG: Will not work under V34 Kickstart! *)
  dacWordWide    * = 080X;

  dacBootTime    * = 030X;    (* two bits for when to boot *)
  dacNever       * = 000X;    (* obvious *)
  dacConfigTime  * = 010X;    (* call da_BootPoint when first configing *)
                              (*   the device *)
  dacBindTime    * = 020X;    (* run when binding drivers to boards *)

(*
**
** These are the calling conventions for the diagnostic callback
** (from da_DiagPoint):
**
** A7 -- points to at least 2K of stack
** A6 -- ExecBase
** A5 -- ExpansionBase
** A3 -- your board's ConfigDev structure
** A2 -- Base of diag/init area that was copied
** A0 -- Base of your board
**
** Your board must return a value in D0.  If this value is NULL, then
** the diag/init area that was copied in will be returned to the free
** memory pool.
*)


TYPE

(*
** At early system startup time, one ConfigDev structure is created for
** each board found in the system.  Software may seach for ConfigDev
** structures by vendor & product ID number.  For debugging and diagnostic
** use, the entire list can be accessed.  See the expansion.library document
** for more information.
*)

  ConfigDevPtr * = UNTRACED POINTER TO ConfigDev;
  ConfigDev * = STRUCT (node * : e.Node)
    flags     *: SHORTSET;     (* (read/write) *)
    pad       *: SHORTINT;     (* reserved *)
    rom       *: ExpansionRom; (* copy of board's expansion ROM *)
    boardAddr *: e.APTR;       (* where in memory the board was placed *)
    boardSize *: LONGINT;      (* size of board in bytes *)
    slotAddr  -: INTEGER;      (* which slot number (PRIVATE) *)
    slotSize  -: INTEGER;      (* number of slots (PRIVATE) *)
    driver    *: e.APTR;       (* pointer to node of driver *)
    nextCD    *: ConfigDevPtr; (* linked list of drivers to config *)
    unused    *: ARRAY 4 OF LONGINT; (* for whatever the driver wants *)
 END;

CONST

(* cd_Flags *)
  cdshutUp     * = 0;   (* this board has been shut up *)
  cdconfigMe   * = 1;   (* this board needs a driver to claim it *)
  cdBadMemory  * = 2;   (* this board contains bad memory *)

TYPE

(*
** Boards are usually "bound" to software drivers.
** This structure is used by GetCurrentBinding() and SetCurrentBinding()
*)

  CurrentBindingPtr * = UNTRACED POINTER TO CurrentBinding;
  CurrentBinding * = STRUCT
    configDev * : ConfigDevPtr;       (* first configdev in chain *)
    fileName * : e.LSTRPTR;           (* file name of driver *)
    productString * : e.LSTRPTR;      (* product # string *)
    toolTypes * : e.APTR;             (* tooltypes from disk object *)
  END;


END Config.


