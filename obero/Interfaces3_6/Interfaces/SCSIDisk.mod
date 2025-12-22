(*
(*
**  Amiga Oberon Interface Module:
**  $VER: SCSIDisk.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE SCSIDisk;   (* $Implementation- *)

IMPORT e * := Exec;

(*--------------------------------------------------------------------
 *
 *   SCSI Command
 *      Several Amiga SCSI controller manufacturers are converging on
 *      standard ways to talk to their controllers.  This include
 *      file describes an exec-device command (e.g. for hddisk.device)
 *      that can be used to issue SCSI commands
 *
 *   UNIT NUMBERS
 *      Unit numbers to the OpenDevice call have encoded in them which
 *      SCSI device is being referred to.  The three decimal digits of
 *      the unit number refer to the SCSI Target ID (bus address) in
 *      the 1's digit, the SCSI logical unit (LUN) in the 10's digit,
 *      and the controller board in the 100's digit.
 *
 *      Examples:
 *                0     drive at address 0
 *               12     LUN 1 on multiple drive controller at address 2
 *              104     second controller board, address 4
 *               88     not valid: both logical units and addresses
 *                      range from 0..7.
 *
 *   CAVEATS
 *      Original 2090 code did not support this command.
 *
 *      Commodore 2090/2090A unit numbers are different.  The SCSI
 *      logical unit is the 100's digit, and the SCSI Target ID
 *      is a permuted 1's digit: Target ID 0..6 maps to unit 3..9
 *      (7 is reserved for the controller).
 *
 *          Examples:
 *                3     drive at address 0
 *              109     drive at address 6, logical unit 1
 *                1     not valid: this is not a SCSI unit.  Perhaps
 *                      it's an ST506 unit.
 *
 *      Some controller boards generate a unique name (e.g. 2090A's
 *      iddisk.device) for the second controller board, instead of
 *      implementing the 100's digit.
 *
 *      There are optional restrictions on the alignment, bus
 *      accessability, and size of the data for the data phase.
 *      Be conservative to work with all manufacturer's controllers.
 *
 *------------------------------------------------------------------*)

CONST

  scsiCmd * = 28;               (* issue a SCSI command to the unit *)
                                (* io_Data points to a SCSICmd *)
                                (* io_Length is sizeof(struct SCSICmd) *)
                                (* io_Actual and io_Offset are not used *)

TYPE

  SCSICmdPtr * = UNTRACED POINTER TO SCSICmd;
  SCSICmd * = STRUCT
    data * : e.APTR;          (* word aligned data for SCSI Data Phase *)
                              (* (optional) data need not be byte aligned *)
                              (* (optional) data need not be bus accessable *)
    length * : LONGINT;       (* even length of Data area *)
                              (* (optional) data can have odd length *)
                              (* (optional) data length can be > 2**24 *)
    actual * : LONGINT;       (* actual Data used *)
    command * : e.APTR;       (* SCSI Command (same options as scsi_Data) *)
    cmdLength * : INTEGER;    (* length of Command *)
    cmdActual * : INTEGER;    (* actual Command used *)
    flags * : SHORTSET;       (* includes intended data direction *)
    status * : SHORTINT;      (* SCSI status of command *)
    senseData * : e.APTR;     (* sense data: filled if SCSIF_[OLD]AUTOSENSE *)
                              (* is set and scsi_Status has CHECK CONDITION *)
                              (* (bit 1) set *)
    senseLength * : INTEGER;  (* size of scsi_SenseData, also bytes to *)
                              (* request w/ SCSIF_AUTOSENSE, must be 4..255 *)
    senseActual * : INTEGER;  (* amount actually fetched (0 means no sense) *)
  END;


CONST

(*----- scsi_Flags -----*)
  write         * = SHORTSET{};       (* intended data direction is out *)
  read          * = 0;                (* intended data direction is in *)
  readWrite     * = 0;                (* (the bit to test) *)

  noSense       * = SHORTSET{};       (* no automatic request sense *)
  autoSense     * = 1;                (* do standard extended request sense *)
                                      (* on check condition *)
  oldAutoSense  * = 2;                (* do 4 byte non-extended request *)
                                      (* sense on check condition *)

(*----- SCSI io_Error values -----*)
  selfUnit      * = 40;     (* cannot issue SCSI command to self *)
  dma           * = 41;     (* DMA error *)
  phase         * = 42;     (* illegal or unexpected SCSI phase *)
  parity        * = 43;     (* SCSI parity error *)
  selTimeout    * = 44;     (* Select timed out *)
  badStatus     * = 45;     (* status and/or sense error *)

(*----- OpenDevice io_Error values -----*)
  noBoard       * = 50;     (* Open failed for non-existant board *)

END SCSIDisk.

