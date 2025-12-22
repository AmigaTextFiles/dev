(*
(*  Amiga Oberon Interface Module:
**  $VER: CDDevice.mod 40.15 (28.12.93) Oberon 3.0
**
**      (C) Copyright 1993 Commodore-Amiga, Inc.
**          All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993 by hartmut Goebel
*)          All Rights Reserved
*)

MODULE CDDevice;

IMPORT
  e * := Exec,
  u * := Utility;

TYPE
  TOCEntryPtr      * = UNTRACED POINTER TO TOCEntry;
  TOCSummaryPtr    * = UNTRACED POINTER TO TOCSummary;
  QCodeLSNPtr      * = UNTRACED POINTER TO QCodeLSN;
  QCodeMSFPtr      * = UNTRACED POINTER TO QCodeMSF;
  CDTOCLSNPtr      * = UNTRACED POINTER TO CDTOCLSN;
  CDTOCMSFPtr      * = UNTRACED POINTER TO CDTOCMSF;
  CDTOCPtr         * = UNTRACED POINTER TO CDTOC;
  TOCEntryLSNPtr   * = UNTRACED POINTER TO TOCEntryLSN;
  TOCEntryMSFPtr   * = UNTRACED POINTER TO TOCEntryMSF;
  TOCSummaryLSNPtr * = UNTRACED POINTER TO TOCSummaryLSN;
  TOCSummaryMSFPtr * = UNTRACED POINTER TO TOCSummaryMSF;
  CDXLPtr          * = UNTRACED POINTER TO CDXL;
  RLSNPtr          * = UNTRACED POINTER TO RLSN;
  RMSFPtr          * = UNTRACED POINTER TO RMSF;
  CDInfoPtr        * = UNTRACED POINTER TO CDInfo;


(**************************************************************************
 *                                                                        *
 *   CD Commands                                                          *
 *                                                                        *
 **************************************************************************)
CONST
  reset         * = 1;
  read          * = 2;
  write         * = 3;
  update        * = 4;
  clear         * = 5;
  stop          * = 6;
  start         * = 7;
  flush         * = 8;
  motor         * = 9;
  seek          * = 10;
  format        * = 11;
  remove        * = 12;
  changeNum     * = 13;
  changeState   * = 14;
  protStatus    * = 15;

  getDriveType  * = 18;
  getNumTracks  * = 19;
  addChangeInt  * = 20;
  remChangeInt  * = 21;
  getGeometry   * = 22;
  eject         * = 23;


  info          * = 32;
  config        * = 33;
  tocMSF        * = 34;
  tocLSN        * = 35;

  readXL        * = 36;

  playTrack     * = 37;
  playMSF       * = 38;
  playLSN       * = 39;
  pause         * = 40;
  search        * = 41;

  qCodeMSF      * = 42;
  qCodeLSN      * = 43;
  attenuate     * = 44;

  addFrameInt   * = 45;
  remFrameInt   * = 46;


(**************************************************************************
 *                                                                        *
 *   Device Driver Error Codes                                            *
 *                                                                        *
 **************************************************************************)

  errOpenFail       * = -1;    (* device/unit failed to open           *)
  errAborted        * = -2;    (* request terminated early             *)
  errNoCmd          * = -3;    (* command not supported by device      *)
  errBadLength      * = -4;    (* invalid length (IO_LENGTH/IO_OFFSET) *)
  errBadAddress     * = -5;    (* invalid address (IO_DATA misaligned) *)
  errUnitBusy       * = -6;    (* device opens ok, but unit is busy    *)
  errSelftest       * = -7;    (* hardware failed self-test            *)

  errNotSpecified   * = 20;    (* general catchall                     *)
  errNoSecHdr       * = 21;    (* couldn't even find a sector          *)
  errBadSecPreamble * = 22;    (* sector looked wrong                  *)
  errBadSecID       * = 23;    (* ditto                                *)
  errBadHdrSum      * = 24;    (* header had incorrect checksum        *)
  errBadSecSum      * = 25;    (* data had incorrect checksum          *)
  errTooFewSecs     * = 26;    (* couldn't find enough sectors         *)
  errBadSecHdr      * = 27;    (* another "sector looked wrong"        *)
  errWriteProt      * = 28;    (* can't write to a protected disk      *)
  errNoDisk         * = 29;    (* no disk in the drive                 *)
  errSeekError      * = 30;    (* couldn't find track 0                *)
  errNoMem          * = 31;    (* ran out of memory                    *)
  errBadUnitNum     * = 32;    (* asked for a unit > NUMUNITS          *)
  errBadDriveType   * = 33;    (* not a drive cd.device understands    *)
  errDriveInUse     * = 34;    (* someone else allocated the drive     *)
  errPostReset      * = 35;    (* user hit reset; awaiting doom        *)
  errBadDataType    * = 36;    (* data on disk is wrong type           *)
  errInvalidState   * = 37;    (* invalid cmd under current conditions *)

  errPhase          * = 42;    (* illegal or unexpected SCSI phase     *)
  errNoBoard        * = 50;    (* open failed for non-existant board   *)


(**************************************************************************
 *                                                                        *
 * Configuration                                                          *
 *                                                                        *
 *       The drive is configured by TagList items defined as follows:     *
 *                                                                        *
 **************************************************************************)

  playSpeed         * = 00001H;
  readSpeed         * = 00002H;
  readXLSpeed       * = 00003H;
  sectorSize        * = 00004H;
  xlECC             * = 00005H;
  ejectReset        * = 00006H;


(**************************************************************************
 *                                                                        *
 * Information                                                            *
 *                                                                        *
 *      Information/Status structure describes current speed settings     *
 *      for read and play commands, sector size, audio attenuation        *
 *      precision, and drive status.                                      *
 *                                                                        *
 **************************************************************************)
TYPE
  CDInfo * = STRUCT             (*                                Default     *)
    playSpeed      * : INTEGER; (* Audio play speed               (75)        *)
    readSpeed      * : INTEGER; (* Data-rate of CD_READ command   (Max)       *)
    readXLSpeed    * : INTEGER; (* Data-rate of CD_READXL command (75)        *)
    sectorSize     * : INTEGER; (* Number of bytes per sector     (2048)      *)
    xlECC          * : INTEGER; (* CDXL ECC enabled/disabled                  *)
    ejectReset     * : INTEGER; (* Reset on eject enabled/disabled            *)
    reserved1      * : ARRAY 4 OF INTEGER; (* Reserved for future expansion   *)

    maxSpeed       * : INTEGER; (* Maximum speed drive can handle (75, 150)   *)
    audioPrecision * : INTEGER; (* 0 = no attenuator, 1 = mute only,          *)
                                (* other = (# levels - 1)                     *)
    status         * : INTEGER; (* See flags below                            *)
    reserved2      * : ARRAY 4 OF INTEGER; (* Reserved for future expansion   *)
  END;


(* Flags for Status *)
CONST
  stsbClosed        * = 0;   (* Drive door is closed                        *)
  stsbDisk          * = 1;   (* A disk has been detected                    *)
  stsbSpin          * = 2;   (* Disk is spinning (motor is on)              *)
  stsbTOC           * = 3;   (* Table of contents read.  Disk is valid.     *)
  stsbCDRom         * = 4;   (* Track 1 contains CD-ROM data                *)
  stsbPlaying       * = 5;   (* Audio is playing                            *)
  stsbPaused        * = 6;   (* Pause mode (pauses on play command)         *)
  stsbSearch        * = 7;   (* Search mode (Fast Forward/Fast Reverse)     *)
  stsbDirection     * = 8;   (* Search direction (0 = Forward, 1 = Reverse) *)

(* Modes for CD_SEARCH *)

  normal        * = 0;    (* Normal play at current play speed    *)
  fFwd          * = 1;    (* Fast forward play (skip-play forward)*)
  fRev          * = 2;    (* Fast reverse play (skip-play reverse)*)


(**************************************************************************
 *                                                                        *
 * Position Information                                           *
 *                                                                        *
 *      Position information can be described in two forms: MSF and LSN   *
 *      form.  MSF (Minutes, Seconds, Frames) form is a time encoding.    *
 *      LSN (Logical Sector Number) form is frame (sector) count.         *
 *      The desired form is selected using the io_Flags field of the      *
 *      IOStdReq structure.  The flags and the union are described        *
 *      below.                                                            *
 *                                                                        *
 **************************************************************************)
TYPE
  RMSF * = STRUCT          (* Minute, Second, Frame  *)
    reserved * : SHORTINT; (* Reserved (always zero) *)
    minute   * : SHORTINT; (* Minutes (0-72ish)      *)
    second   * : SHORTINT; (* Seconds (0-59)         *)
    frame    * : SHORTINT; (* Frame   (0-74)         *)
  END;

  RLSN * = STRUCT
    lsn * : LONGINT;       (* Logical Sector Number  *)
  END;

(**************************************************************************
 *                                                                        *
 * CD Transfer Lists                                                      *
 *                                                                        *
 *      A CDXL node is a double link node; however only single linkage    *
 *      is used by the device driver.  If you wish to construct a         *
 *      transfer list manually, it is only neccessary to define the       *
 *      mln_Succ pointer of the MinNode.  You may also use the Exec       *
 *      list functions by defining a List or MinList structure and by     *
 *      using the AddHead/AddTail functions to create the list.  This     *
 *      will create a double-linked list.  Although a double-linked       *
 *      list is not required by the device driver, you may wish use it    *
 *      for your own purposes.  Don't forget to initialize the            *
 *      the List/MinList before using it!                                 *
 *                                                                        *
 **************************************************************************)

  CharPtr * = e.APTR;

  CDXL * = STRUCT (node *: e.MinNode) (* double linkage          *)
    buffer  * : CharPtr;      (* data destination (word aligned) *)
    length  * : LONGINT;      (* must be even # bytes            *)
    actual  * : LONGINT;      (* bytes transferred               *)
    intData * : e.APTR;       (* interrupt server data segment   *)
    intCode * : e.PROC;       (* interrupt server code entry     *)
  END;


(**************************************************************************
 *                                                                        *
 * CD Table of Contents                                           *
 *                                                                        *
 *      The CD_TOC command returns an array of CDTOC entries.             *
 *      Entry zero contains summary information describing how many       *
 *      tracks the disk has and the play-time of the disk.                *
 *      Entries 1 through N (N = Number of tracks on disk) contain        *
 *      information about the track.                                      *
 *                                                                        *
 **************************************************************************)

  TOCSummary *= STRUCT END;
  TOCSummaryMSF * = STRUCT (dummy *:TOCSummary)
    firstTrack * : SHORTINT; (* First track on disk (always 1)            *)
    lastTrack  * : SHORTINT; (* Last track on disk                        *)
    leadOut    * : RMSF;     (* Beginning of lead-out track (end of disk) *)
  END;

  TOCSummaryLSN * = STRUCT (dummy *:TOCSummary)
    firstTrack * : SHORTINT; (* First track on disk (always 1)            *)
    lastTrack  * : SHORTINT; (* Last track on disk                        *)
    leadOut    * : RLSN;     (* Beginning of lead-out track (end of disk) *)
  END;


  TOCEntry *= STRUCT END;
  TOCEntryMSF * = STRUCT (dummy *: TOCEntry)
    ctlAdr   * : SHORTINT;   (* Q-Code info                  *)
    track    * : SHORTINT;   (* Track number                 *)
    position * : RMSF;       (* Start position of this track *)
  END;

  TOCEntryLSN * = STRUCT (dummy *: TOCEntry)
    ctlAdr   * : SHORTINT;   (* Q-Code info                  *)
    track    * : SHORTINT;   (* Track number                 *)
    position * : RLSN;       (* Start position of this track *)
  END;


  CDTOC * = STRUCT END;
  CDTOCMSF * = STRUCT (dummy *: CDTOC)
    summary * : TOCSummaryMSF;            (* First entry (0) is summary information *)
    entry   * : ARRAY 256 OF TOCEntryMSF; (* Entries 1-N are track entries          *)
  END;

  CDTOCLSN * = STRUCT (dummy *: CDTOC)
    summary * : TOCSummaryLSN;            (* First entry (0) is summary information *)
    entry   * : ARRAY 256 OF TOCEntryLSN; (* Entries 1-N are track entries          *)
  END;


(**************************************************************************
 *                                                                        *
 * Q-Code Packets                                                         *
 *                                                                        *
 *      Q-Code packets are only returned when audio is playing.   *
 *      Currently, only position packets are returned (ADR_POSITION)      *
 *      The other ADR_ types are almost never encoded on the disk         *
 *      and are of little use anyway.  To avoid making the QCode          *
 *      structure a union, these other ADR_ structures are not defined.   *
 *                                                                        *
 **************************************************************************)

  QCodeMSF * = STRUCT
    ctlAdr        * : SHORTINT; (* Data type / QCode type           *)
    track         * : SHORTINT; (* Track number                     *)
    index         * : SHORTINT; (* Track subindex number            *)
    zero          * : SHORTINT; (* The "Zero" byte of Q-Code packet *)
    trackPosition * : RMSF;     (* Position from start of track     *)
    diskPosition  * : RMSF;     (* Position from start of disk      *)
  END;

  QCodeLSN * = STRUCT
    ctlAdr        * : SHORTINT; (* Data type / QCode type           *)
    track         * : SHORTINT; (* Track number                     *)
    index         * : SHORTINT; (* Track subindex number            *)
    zero          * : SHORTINT; (* The "Zero" byte of Q-Code packet *)
    trackPosition * : RLSN;     (* Position from start of track     *)
    diskPosition  * : RLSN;     (* Position from start of disk      *)
  END;

CONST
  ctlAdrCtlMask     * = 0F0H;   (* Control field *)

  ctlCtlMask        * = 0D0H;   (* To be ANDed with CtlAdr before compared  *)

  ctl2Aud           * = 000H;   (* 2 audio channels without preemphasis     *)
  ctl2AudEmph       * = 010H;   (* 2 audio channels with preemphasis        *)
  ctl4Aud           * = 080H;   (* 4 audio channels without preemphasis     *)
  ctl4AudEmph       * = 090H;   (* 4 audio channels with preemphasis        *)
  ctlData           * = 040H;   (* CD-ROM Data                              *)

  ctlCopyMask       * = 020H;   (* To be ANDed with CtlAdr before compared  *)

  ctlCopy           * = 020H;   (* When true, this audio/data can be copied *)

  ctlAdrAdrMask     * = 00FH;   (* Address field                            *)

  adrPosition       * = 001H;   (* Q-Code is position information           *)
  adrUPC            * = 002H;   (* Q-Code is UPC information (not used)     *)
  adrISRC           * = 003H;   (* Q-Code is ISRC (not used)                *)
  adrHybrid         * = 005H;   (* This disk is a hybrid disk               *)

END CDDevice.

