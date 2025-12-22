(*
(*
**  Amiga Oberon Interface Module:
**  $VER: BattMem.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE BattMem;

IMPORT e * := Exec;

CONST
  battMemName * = "battmem.resource";


(*
 * Amiga specific bits in the battery-backedup ram.
 *
 *      Bits 0 to 31, inclusive
 *)

(*
 * AMIGA_AMNESIA
 *
 *              The battery-backedup memory has had a memory loss.
 *              This bit is used as a flag that the user should be
 *              notified that all battery-backed bit have been
 *              reset and that some attention is required. Zero
 *              indicates that a memory loss has occured.
 *)

  amigaAmnesiaAddr    * = 0;
  amigaAmnesiaLen     * = 1;

(*
 * SCSI_TIMEOUT
 *
 *              adjusts the timeout value for SCSI device selection.  A
 *              value of 0 will produce short timeouts (128 ms) while a
 *              value of 1 produces long timeouts (2 sec).  This is used
 *              for SeaCrate drives (and some Maxtors apparently) that
 *              don`t respond to selection until they are fully spun up
 *              and intialised.
 *)

  scsiTimeoutAddr     * = 1;
  scsiTimeoutLen      * = 1;

(*
 * SCSI_LUNS
 *
 *              Determines if the controller attempts to access logical
 *              units above 0 at any given SCSI address.  This prevents
 *              problems with drives that respond to ALL LUN addresses
 *              (instead of only 0 like they should).  Default value is
 *              0 meaning don't support LUNs.
 *)

  scsiLunsAddr        * = 2;
  scsiLunsLen         * = 1;

(*
 * Shared bits in the battery-backedup ram.
 *
 *      Bits 64 and above
 *)

(*
 * SHARED_AMNESIA
 *
 *              The battery-backedup memory has had a memory loss.
 *              This bit is used as a flag that the user should be
 *              notified that all battery-backed bit have been
 *              reset and that some attention is required. Zero
 *              indicates that a memory loss has occured.
 *)

  sharedAmnesiaAddr   * = 64;
  sharedAmnesiaLen    * = 1;

(*
 * SCSI_HOST_ID
 *
 *              a 3 bit field (0-7) that is stored in complemented form
 *              (this is so that default value of 0 really means 7)
 *              It's used to set the A3000 controllers SCSI ID (on reset)
 *)

  scsiHostIdAddr      * = 65;
  scsiHostIdLen       * = 3;

(*
 * SCSI_SYNC_XFER
 *
 *              determines if the driver should initiate synchronous
 *              transfer requests or leave it to the drive to send the
 *              first request.  This supports drives that crash or
 *              otherwise get confused when presented with a sync xfer
 *              message.  Default=0=sync xfer not initiated.
 *)

  scsiSyncXferAddr    * = 68;
  scsiSyncXferLen     * = 1;

(*
 *      See Amix documentation for these bit definitions
 *
 *      Bits 32 to 63, inclusive
 *)

(*
 * SCSI_FAST_SYNC
 *
 *              determines if the driver should initiate fast synchronous
 *              transfer requests (>5MB/s) instead of older <=5MB/s requests.
 *              Note that this has no effect if synchronous transfers are not
 *              negotiated by either side.
 *              Default=0=fast sync xfer used.
 *)

  scsiFastSyncAddr * = 69;
  scsiFastSyncLen  * = 1;

(*
 * SCSI_TAG_QUEUES
 *
 *              determines if the driver should use SCSI-2 tagged queuing
 *              which allows the drive to accept and reorder multiple read
 *              and write requests.
 *              Default=0=tagged queuing NOT enabled
 *)

  scsiTagQueuesAddr * = 70;
  scsiTagQueuesLen * = 1;

VAR
(*
 *  You have to put a pointer to the battmem.resource here to use the battmem
 *  procedures:
 *)

  base * : e.APTR;

PROCEDURE ObtainBattSemaphore *{base,-  6}();
PROCEDURE ReleaseBattSemaphore*{base,- 12}();
PROCEDURE ReadBattMem         *{base,- 18}(VAR buffer{8} : ARRAY OF e.BYTE;
                                           offset{0}     : LONGINT;
                                           length{1}     : LONGINT): LONGINT;
PROCEDURE WriteBattMem        *{base,- 24}(buffer{8}     : ARRAY OF e.BYTE;
                                           offset{0}     : LONGINT;
                                           length{1}     : LONGINT): LONGINT;

END BattMem.

