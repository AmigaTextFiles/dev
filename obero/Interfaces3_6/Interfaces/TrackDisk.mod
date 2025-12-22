(*
(*
**  Amiga Oberon Interface Module:
**  $VER: TrackDisk.mod 40.15 (12.1.95) Oberon 3.6
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE TrackDisk;   (* $Implementation- *)

IMPORT e * := Exec;


(*
 *--------------------------------------------------------------------
 *
 * Physical drive constants
 *
 *--------------------------------------------------------------------
 *)

(* OBSOLETE -- use the TD_GETNUMTRACKS command! *)
(*#define       NUMCYLS 80*)            (*  normal # of cylinders *)
(*#define       MAXCYLS (NUMCYLS+20)*)  (* max # cyls to look for during cal *)
(*#define       NUMHEADS 2*)
(*#define       NUMTRACKS (NUMCYLS*NUMHEADS)*)

CONST

  numSecs * = 11;
  numUnits * = 4;


(*
 *--------------------------------------------------------------------
 *
 * Useful constants
 *
 *--------------------------------------------------------------------
 *)

(*-- sizes before mfm encoding *)
  sector * = 512;
  secShift * = 9;    (* log TD_SECTOR *)

(*
 *--------------------------------------------------------------------
 *
 * Driver Specific Commands
 *
 *--------------------------------------------------------------------
 *)

(*
 *-- TD_NAME is a generic macro to get the name of the driver.  This
 *-- way if the name is ever changed you will pick up the change
 *-- automatically.
 *--
 *-- Normal usage would be:
 *--
 *-- char internalName[] = TD_NAME;
 *--
 *)

  name * = "trackdisk.device";

  extCom * = 8000U;                (* for internal use only! *)


  motor        * = e.nonstd+0;  (* control the disk's motor *)
  seek         * = e.nonstd+1;  (* explicit seek (for testing) *)
  format       * = e.nonstd+2;  (* format disk *)
  remove       * = e.nonstd+3;  (* notify when disk changes *)
  changeNum    * = e.nonstd+4;  (* number of disk changes *)
  changeState  * = e.nonstd+5;  (* is there a disk in the drive? *)
  protStatus   * = e.nonstd+6;  (* is the disk write protected? *)
  rawRead      * = e.nonstd+7;  (* read raw bits from the disk *)
  rawWrite     * = e.nonstd+8;  (* write raw bits to the disk *)
  getDriveType * = e.nonstd+9;  (* get the type of the disk drive *)
  getNumTracks * = e.nonstd+10; (* # of tracks for this type drive *)
  addChangeInt * = e.nonstd+11; (* TD_REMOVE done right *)
  remChangeInt * = e.nonstd+12; (* remove softint set by ADDCHANGEINT *)
  getGeometry  * = e.nonstd+13; (* gets the disk geometry table *)
  eject        * = e.nonstd+14; (* for those drives that support it *)
  lastcomm     * = e.nonstd+15;

(*
 *
 * The disk driver has an "extended command" facility.  These commands
 * take a superset of the normal IO Request block.
 *
 *)

  extWrite       * = e.write  + extCom;
  extRead        * = e.read   + extCom;
  extMotor       * = motor    + extCom;
  extSeek        * = seek     + extCom;
  extFormat      * = format   + extCom;
  extUpdate      * = e.update + extCom;
  extClear       * = e.clear  + extCom;
  extRawRead     * = rawRead  + extCom;
  extRawWrite    * = rawWrite + extCom;

TYPE

(*
 *
 * extended IO has a larger than normal io request block.
 *
 *)

  IOExtTDPtr * = UNTRACED POINTER TO IOExtTD;
  IOExtTD * = STRUCT (req * : e.IOStdReq)
    count * : LONGINT;
    secLabel * : LONGINT;
  END;

(*
 *  This is the structure returned by TD_DRIVEGEOMETRY
 *  Note that the layout can be defined three ways:
 *
 *  1. TotalSectors
 *  2. Cylinders and CylSectors
 *  3. Cylinders, Heads, and TrackSectors.
 *
 *  #1 is most accurate, #2 is less so, and #3 is least accurate.  All
 *  are usable, though #2 and #3 may waste some portion of the available
 *  space on some drives.
 *)

  DriveGeometryPtr * = UNTRACED POINTER TO DriveGeometry;
  DriveGeometry * = STRUCT
    sectorSize * : LONGINT;          (* in bytes *)
    totalSectors * : LONGINT;        (* total # of sectors on drive *)
    cylinders * : LONGINT;           (* number of cylinders *)
    cylSectors * : LONGINT;          (* number of sectors/cylinder *)
    heads * : LONGINT;               (* number of surfaces *)
    trackSectors * : LONGINT;        (* number of sectors/track *)
    bufMemType * : LONGINT;          (* preferred buffer memory type *)
                            (* (usually MEMF_PUBLIC) *)
    deviceType * : SHORTINT;          (* codes as defined in the SCSI-2 spec*)
    flags * : SHORTSET;               (* flags, including removable *)
    reserved * : INTEGER;
  END;

CONST

(* device types *)
  directAccess     * = 0;
  sequentialAccess * = 1;
  printer          * = 2;
  processor        * = 3;
  worm             * = 4;
  cdRom            * = 5;
  scanner          * = 6;
  opticalDisk      * = 7;
  mediumChanger    * = 8;
  communication    * = 9;
  unknown          * = 31;

(* flags *)
  removable        * = 0;

(*
** raw read and write can be synced with the index pulse.  This flag
** in io request's IO_FLAGS field tells the driver that you want this.
*)

  indexSync        * = 4;

(*
** raw read and write can be synced with a 04489H sync pattern.  This flag
** in io request's IO_FLAGS field tells the driver that you want this.
*)
  wordSync         * = 5;


(* labels are TD_LABELSIZE bytes per sector *)

  labelSize        * = 16;

(*
** This is a bit in the FLAGS field of OpenDevice.  If it is set, then
** the driver will allow you to open all the disks that the trackdisk
** driver understands.  Otherwise only 3.5" disks will succeed.
*)

  allowNon35       * = 0;

(*
**  If you set the TDB_ALLOW_NON_3_5 bit in OpenDevice, then you don't
**  know what type of disk you really got.  These defines are for the
**  TD_GETDRIVETYPE command.  In addition, you can find out how many
**  tracks are supported via the TD_GETNUMTRACKS command.
*)

  drive35          * = 1;
  drive525         * = 2;
  drive35150rpm    * = 3;

(*
 *--------------------------------------------------------------------
 *
 * Driver error defines
 *
 *--------------------------------------------------------------------
 *)

  notSpecified      * = 20;      (* general catchall *)
  noSecHdr          * = 21;      (* couldn't even find a sector *)
  badSecPreamble    * = 22;      (* sector looked wrong *)
  badSecID          * = 23;      (* ditto *)
  badHdrSum         * = 24;      (* header had incorrect checksum *)
  badSecSum         * = 25;      (* data had incorrect checksum *)
  tooFewSecs        * = 26;      (* couldn't find enough sectors *)
  badSecHdr         * = 27;      (* another "sector looked wrong" *)
  writeProt         * = 28;      (* can't write to a protected disk *)
  diskChanged       * = 29;      (* no disk in the drive *)
  seekError         * = 30;      (* couldn't find track 0 *)
  noMem             * = 31;      (* ran out of memory *)
  badUnitNum        * = 32;      (* asked for a unit > NUMUNITS *)
  badDriveType      * = 33;      (* not a drive that trackdisk groks *)
  driveInUse        * = 34;      (* someone else allocated the drive *)
  postReset         * = 35;      (* user hit reset; awaiting doom *)

TYPE

(*
 *--------------------------------------------------------------------
 *
 * public portion of the unit structure
 *
 *--------------------------------------------------------------------
 *)

  PublicUnitPtr * = UNTRACED POINTER TO PublicUnit;
  PublicUnit * = STRUCT (unit * : e.Unit)          (* base message port *)
    comp01Track * : INTEGER;        (* track for first precomp *)
    comp10Track * : INTEGER;        (* track for second precomp *)
    comp11Track * : INTEGER;        (* track for third precomp *)
    stepDelay * : LONGINT;          (* time to wait after stepping *)
    settleDelay * : LONGINT;        (* time to wait after seeking *)
    retryCnt * : SHORTINT;          (* # of times to retry *)
    pubFlags * : SHORTSET;          (* public flags, see below *)
    currTrk * : INTEGER;            (* track the heads are over... *)
                                    (* ONLY ACCESS WHILE UNIT IS STOPPED! *)
    calibrateDelay * : LONGINT;     (* time to wait after stepping *)
                                    (* during a recalibrate *)
    counter * : LONGINT;            (* counter for disk changes... *)
                                    (* ONLY ACCESS WHILE UNIT IS STOPPED! *)
  END;

CONST

(* flags for tdu_PubFlags *)
  noClick          * = 0;

END TrackDisk.

