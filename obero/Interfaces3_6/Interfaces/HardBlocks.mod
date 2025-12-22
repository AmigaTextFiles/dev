(*
(*
**  Amiga Oberon Interface Module:
**  $VER: HardBlocks.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE HardBlocks;

IMPORT e   * := Exec,
       sys * := SYSTEM;

(*--------------------------------------------------------------------
 *
 *      This file describes blocks of data that exist on a hard disk
 *      to describe that disk.  They are not generically accessable to
 *      the user as they do not appear on any DOS drive.  The blocks
 *      are tagged with a unique identifier, checksummed, and linked
 *      together.  The root of these blocks is the RigidDiskBlock.
 *
 *      The RigidDiskBlock must exist on the disk within the first
 *      RDB_LOCATION_LIMIT blocks.  This inhibits the use of the zero
 *      cylinder in an AmigaDOS partition: although it is strictly
 *      possible to store the RigidDiskBlock data in the reserved
 *      area of a partition, this practice is discouraged since the
 *      reserved blocks of a partition are overwritten by "Format",
 *      "Install", "DiskCopy", etc.  The recommended disk layout,
 *      then, is to use the first cylinder(s) to store all the drive
 *      data specified by these blocks: i.e. partition descriptions,
 *      file system load images, drive bad block maps, spare blocks,
 *      etc.
 *
 *      Though only 512 byte blocks are currently supported by the
 *      file system, this proposal tries to be forward-looking by
 *      making the block size explicit, and by using only the first
 *      256 bytes for all blocks but the LoadSeg data.
 *
 *------------------------------------------------------------------*)

TYPE

(*
 *  NOTE
 *      optional block addresses below contain -1 to indicate
 *      a NULL address, as zero is a valid address
 *)

  RigidDiskBlockPtr * = UNTRACED POINTER TO RigidDiskBlock;
  RigidDiskBlock * = STRUCT
    id * : LONGINT;             (* 4 character identifier *)
    summedLongs * : LONGINT;    (* size of this checksummed structure *)
    chkSum * : LONGINT;         (* block checksum (longword sum to zero) *)
    hostID * : LONGINT;         (* SCSI Target ID of host *)
    blockBytes * : LONGINT;     (* size of disk blocks *)
    flags * : LONGSET;          (* see below for defines *)
  (* block list heads *)
    badBlockList * : LONGINT;   (* optional bad block list *)
    partitionList * : LONGINT;  (* optional first partition block *)
    fileSysHeaderList * : LONGINT; (* optional file system header block *)
    driveInit * : LONGINT;      (* optional drive-specific init code *)
                        (* DriveInit(lun,rdb,ior): "C" stk & d0/a0/a1 *)
    reserved1 * : ARRAY 6 OF LONGINT;   (* set to -1 *)
  (* physical drive characteristics *)
    cylinders * : LONGINT;      (* number of drive cylinders *)
    sectors * : LONGINT;        (* sectors per track *)
    heads * : LONGINT;          (* number of drive heads *)
    interleave * : LONGINT;     (* interleave *)
    park * : LONGINT;           (* landing zone cylinder *)
    reserved2 * : ARRAY 3 OF LONGINT;
    writePreComp * : LONGINT;   (* starting cylinder: write precompensation *)
    reducedWrite * : LONGINT;   (* starting cylinder: reduced write current *)
    stepRate * : LONGINT;       (* drive step rate *)
    reserved3 * : ARRAY 5 OF LONGINT;
  (* logical drive characteristics *)
    rdbBlocksLo * : LONGINT;    (* low block of range reserved for hardblocks *)
    rdbBlocksHi * : LONGINT;    (* high block of range for these hardblocks *)
    loCylinder * : LONGINT;     (* low cylinder of partitionable disk area *)
    hiCylinder * : LONGINT;     (* high cylinder of partitionable data area *)
    cylBlocks * : LONGINT;      (* number of blocks available per cylinder *)
    autoParkSeconds * : LONGINT; (* zero for no auto park *)
    reserved4 * : ARRAY 2 OF LONGINT;
  (* drive identification *)
    diskVendor * : ARRAY 8 OF CHAR;
    diskProduct * : ARRAY 16 OF CHAR;
    diskRevision * : ARRAY 4 OF CHAR;
    controllerVendor * : ARRAY 8 OF CHAR;
    controllerProduct * : ARRAY 16 OF CHAR;
    controllerRevision * : ARRAY 4 OF CHAR;
    reserved5 * : ARRAY 10 OF LONGINT;
  END;

CONST

  idNameRigidDisk * = sys.VAL(LONGINT,"RDSK");

  locationLimit * = 16;

  last       * = 0;       (* no disks exist to be configured after *)
                          (*   this one on this controller *)
  lastLun    * = 1;       (* no LUNs exist to be configured greater *)
                          (*   than this one at this SCSI Target ID *)
  lsatTID    * = 2;       (* no Target IDs exist to be configured *)
                          (*   greater than this one on this SCSI bus *)
  noReselect * = 3;       (* don't bother trying to perform reselection *)
                          (*   when talking to this drive *)
  diskID     * = 4;       (* rdb_Disk... identification valid *)
  ctrlrID    * = 5;       (* rdb_Controller... identification valid *)

TYPE

(*------------------------------------------------------------------*)
  BadBlockEntryPtr * = UNTRACED POINTER TO BadBlockEntry;
  BadBlockEntry * = STRUCT
    badBlock * : LONGINT;       (* block number of bad block *)
    goodBlock * : LONGINT;      (* block number of replacement block *)
  END;

  BadBlockBlockPtr * = UNTRACED POINTER TO BadBlockBlock;
  BadBlockBlock * = STRUCT
    id * : LONGINT;             (* 4 character identifier *)
    summedLongs * : LONGINT;    (* size of this checksummed structure *)
    chkSum * : LONGINT;         (* block checksum (longword sum to zero) *)
    hostID * : LONGINT;         (* SCSI Target ID of host *)
    next * : LONGINT;           (* block number of the next BadBlockBlock *)
    reserved * : LONGINT;
    blockPairs * : ARRAY 61 OF BadBlockEntry; (* bad block entry pairs *)
    (* note [61] assumes 512 byte blocks *)
  END;

CONST

  idNameBadBlock * = sys.VAL(LONGINT,"BADB");

TYPE

(*------------------------------------------------------------------*)

  PartitionBlockPtr * = UNTRACED POINTER TO PartitionBlock;
  PartitionBlock * = STRUCT
    id * : LONGINT;                      (* 4 character identifier *)
    summedLongs * : LONGINT;             (* size of this checksummed structure *)
    chkSum * : LONGINT;                  (* block checksum (longword sum to zero) *)
    hostID * : LONGINT;                  (* SCSI Target ID of host *)
    next * : LONGINT;                    (* block number of the next PartitionBlock *)
    flags * : LONGSET;                   (* see below for defines *)
    reserved1 * : ARRAY 2 OF LONGINT;
    devFlags * : LONGINT;                (* preferred flags for OpenDevice *)
    driveName * : ARRAY 32 OF CHAR;      (* preferred DOS device name: BSTR form *)
                                         (* (not used if this name is in use) *)
    reserved2 * : ARRAY 15 OF LONGINT;   (* filler to 32 longwords *)
    environment * : ARRAY 17 OF LONGINT; (* environment vector for this partition *)
    eReserved * : ARRAY 15 OF LONGINT;   (* reserved for future environment vector *)
  END;

CONST

  idNamePartition * = sys.VAL(LONGINT,"PART");

  bootable  * = 0;      (* this partition is intended to be bootable *)
                        (*   (expected directories and files exist) *)
  noMount   * = 1;      (* do not mount this partition (e.g. manually *)
                        (*   mounted, but space reserved here) *)

TYPE

(*------------------------------------------------------------------*)

  FileSysHeaderBlockPtr * = UNTRACED POINTER TO FileSysHeaderBlock;
  FileSysHeaderBlock * = STRUCT
    id * : LONGINT;                     (* 4 character identifier *)
    summedLongs * : LONGINT;            (* size of this checksummed structure *)
    chkSum * : LONGINT;                (* block checksum (longword sum to zero) *)
    hostID * : LONGINT;                 (* SCSI Target ID of host *)
    next * : LONGINT;                   (* block number of next FileSysHeaderBlock *)
    flags * : LONGSET;                  (* see below for defines *)
    reserved1 * : ARRAY 2 OF LONGINT;
    dosType * : LONGINT;                (* file system description: match this with *)
                                        (* partition environment's DE_DOSTYPE entry *)
    version * : LONGINT;                (* release version of this code *)
    patchFlags * : LONGSET;             (* bits set for those of the following that *)
                                        (*   need to be substituted into a standard *)
                                        (*   device node for this file system: e.g. *)
                                        (*   0x180 to substitute SegList & GlobalVec *)
    type * : LONGINT;                   (* device node type: zero *)
    task * : LONGINT;                   (* standard dos "task" field: zero *)
    lock * : LONGINT;                   (* not used for devices: zero *)
    handler * : LONGINT;                (* filename to loadseg: zero placeholder *)
    stackSize * : LONGINT;              (* stacksize to use when starting task *)
    priority * : LONGINT;               (* task priority when starting task *)
    startup * : LONGINT;                (* startup msg: zero placeholder *)
    segListBlocks * : LONGINT;          (* first of linked list of LoadSegBlocks: *)
                                        (*   note that this entry requires some *)
                                        (*   processing before substitution *)
    globalVec * : LONGINT;              (* BCPL global vector when starting task *)
    reserved2 * : ARRAY 23 OF LONGINT;  (* (those reserved by PatchFlags) *)
    reserved3 * : ARRAY 21 OF LONGINT;
  END;

CONST

  idNameFileSysHeader * = sys.VAL(LONGINT,"FSHD");

TYPE

(*------------------------------------------------------------------*)

  LoadSegBlockPtr * = UNTRACED POINTER TO LoadSegBlock;
  LoadSegBlock * = STRUCT
    id * : LONGINT;                     (* 4 character identifier *)
    summedLongs * : LONGINT;            (* size of this checksummed structure *)
    chkSum * : LONGINT;                 (* block checksum (longword sum to zero) *)
    hostID * : LONGINT;                 (* SCSI Target ID of host *)
    next * : LONGINT;                   (* block number of the next LoadSegBlock *)
    loadData * : ARRAY 123 OF LONGINT;  (* data for "loadseg" *)
    (* note [123] assumes 512 byte blocks *)
  END;

CONST

  idNameLoadSeg * = sys.VAL(LONGINT,'LSEG');

END HardBlocks.


