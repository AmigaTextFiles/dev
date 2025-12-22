/*
**	$Filename: xpk.h $
**	$Release: 0.9 $
**
**
**
**	(C) Copyright 1991 U. Dominik Mueller, Bryan Ford, Christian Schneider
**	    All Rights Reserved
*/


/*
**  Converted from C include file to E module by
**  Torgil Svenssom (snorq@lysator.liu.se) in 1995
**
**  see the file E.README
**
*/


OPT MODULE
OPT PREPROCESS
OPT EXPORT


-> there are two defines left. this and one at the bottom

#define XPKNAME 'xpkmaster.library'

/*****************************************************************************
 *
 *
 *      The packing/unpacking tags
 *
 */

CONST XPK_TagBase = TAG_USER + "X"*256 + "P"
CONST XTAG        = XPK_TagBase

-> Caller must supply ONE of these to tell Xpk#?ackFile where to get data from

CONST XPK_InName = XTAG+$01,  -> Process an entire named file
      XPK_InFH   = XTAG+$02   -> File handle - start from current position

-> If packing partial file, must also supply InLen

CONST XPK_InBuf  = XTAG+$03,  -> Single unblocked memory buffer, supply InLen
      XPK_InHook = XTAG+$04   -> Call custom Hook to read data

-> If packing, must also supply InLen
-> If unpacking, InLen required only for PPDecrunch

-> Caller must supply ONE of these to tell Xpk#?ackFile where to send data to
CONST XPK_OutName   = XTAG+$10, -> Write (or overwrite) this data file
      XPK_OutFH     = XTAG+$11, -> File handle - write from current pos on
      XPK_OutBuf    = XTAG+$12,	-> Unblocked buf - must also supply OutBufLen
      XPK_GetOutBuf = XTAG+$13,	-> Master alloc. OutBuf tag data pts to buf ptr
      XPK_OutHook   = XTAG+$14  -> Callback Hook to get output buffers

-> Other tags for Pack/Unpack
CONST XPK_InLen        = XTAG+$20,  -> Length of data in input buffer
      XPK_OutBufLen    = XTAG+$21,  -> Length of output buffer
      XPK_GetOutLen    = XTAG+$22,  -> tag data pts to long to receive OutLen
      XPK_GetOutBufLen = XTAG+$23,  -> tag data pts to long to rec. OutBufLen
      XPK_Password     = XTAG+$24,  -> Password for de/encoding
      XPK_GetError     = XTAG+$25,  -> ti_Data points to buf for error message
      XPK_OutMemType   = XTAG+$26,  -> Memory type for output buffer
      XPK_PassThru     = XTAG+$27,  -> Bool: Pass through unrec.formats on unpck
      XPK_StepDown     = XTAG+$28,  -> Bool: Step down pack method if necessary
      XPK_ChunkHook    = XTAG+$29,  -> Call this Hook between chunks
      XPK_PackMethod   = XTAG+$2a,  -> Do a FindMethod before packing
      XPK_ChunkSize    = XTAG+$2b,  -> Chunk size to try to pack with
      XPK_PackMode     = XTAG+$2c,  -> Packing mode for sublib to use
      XPK_NoClobber    = XTAG+$2d,  -> Don't overwrite existing files
      XPK_Ignore       = XTAG+$2e,  -> Skip this tag
      XPK_TaskPri      = XTAG+$2f,  -> Change priority for (un)packing
      XPK_FileName     = XTAG+$30,  -> File name for progress report
      XPK_ShortError   = XTAG+$31,  -> Output short error messages
      XPK_PackersQuery = XTAG+$32,  -> Query available packers
      XPK_PackerQuery  = XTAG+$33,  -> Query properties of a packer
      XPK_ModeQuery    = XTAG+$34,  -> Query properties of packmode
      XPK_LossyOK      = XTAG+$35   -> Lossy packing permitted? def.=no


CONST XPK_FindMethod = XPK_PackMethod, -> Compatibility
      XPK_MARGIN     = 256             -> Safety margin for output buffer




/*****************************************************************************
 *
 *
 *     The hook function interface
 *
 */

-> Message passed to InHook and OutHook as the ParamPacket
OBJECT xpkIOMsg
	type      :LONG   -> (unsigned) Read/Write/Alloc/Free/Abort
	ptr       :LONG   -> (APTR) The mem area to read from/write to
	size      :LONG   -> The size of the read/write
	ioError   :LONG   -> The IoErr() that occurred
	reserved  :LONG   -> Reserved for future use
	private1  :LONG   -> Hook specific, will be set to 0 by
	private2  :LONG   -> master library before first use
	private3  :LONG
	private4  :LONG
ENDOBJECT

-> The values for xpkIoMsg.type
CONST XIO_READ    = 1,
      XIO_WRITE   = 2,
      XIO_FREE    = 3,
      XIO_ABORT   = 4,
      XIO_GETBUF  = 5,
      XIO_SEEK    = 6,
      XIO_TOTSIZE = 7





/*****************************************************************************
 *
 *
 *      The progress report interface
 *
 */

-> Passed to ChunkHook as the ParamPacket
OBJECT xpkProgress
  type          :LONG         -> Type of report: start/cont/end/abort
  packerName    :PTR TO CHAR	-> Brief name of packer being used
  packerLongName:PTR TO CHAR  -> Descriptive name of packer being used
  activity      :PTR TO CHAR  -> Packing/unpacking message
  fileName      :PTR TO CHAR  -> Name of file being processed, if available

  ccur          :LONG   -> Amount of packed data already processed
  ucur          :LONG   -> Amount of unpacked data already processed
  ulen          :LONG   -> Amount of unpacked data in file
  cf            :LONG   -> Compression factor so far
  done          :LONG   -> Percentage done already
  speed         :LONG   -> Bytes per second, from beginning of stream
  reserved[8]   :ARRAY  -> For future use
ENDOBJECT

CONST XPKPROG_START = 1,
      XPKPROG_MID   = 2,
      XPKPROG_END   = 3





/*****************************************************************************
 *
 *
 *       The file info block
 *
 */

OBJECT xpkFib
  type  :LONG   -> Unpacked, packed, archive?
  ulen  :LONG   -> Uncompressed length
  dlen  :LONG   -> Compressed length
  nlen  :LONG   -> Next chunk len
  ucur  :LONG   -> Uncompressed bytes so far
  ccur  :LONG		-> Compressed bytes so far
  id    :LONG		-> 4 letter ID of packer

  packer[6]   :ARRAY  -> (unsigned) 4 letter name of packer
  subVersion  :INT    -> Required sublib version
  masVersion  :INT    -> Required masterlib version
  flags       :INT    -> Password?
  head[16]    :ARRAY  -> (unsigned) First 16 bytes of orig. file
  ratio       :LONG   -> Compression ratio

  reserved[8] :ARRAY OF LONG	-> For future use
ENDOBJECT

CONST XPKTYPE_UNPACKED  = 0,  -> Not packed
      XPKTYPE_PACKED    = 1,  -> Packed file
      XPKTYPE_ARCHIVE   = 2   -> Archive

CONST XPKFLAGS_PASSWORD = 1,  -> Password needed
      XPKFLAGS_NOSEEK   = 2,  -> Chunks are dependent
      XPKFLAGS_NONSTD   = 4   -> Nonstandard file format






/*****************************************************************************
 *
 *
 *       The error messages
 *
 */

CONST XPKERR_OK          =   0,
      XPKERR_NOFUNC      =  -1, -> This function not implemented
      XPKERR_NOFILES     =  -2, -> No files allowed for this function
      XPKERR_IOERRIN     =  -3, -> Input error happened, look at Result2
      XPKERR_IOERROUT    =  -4, -> Output error happened,look at Result2
      XPKERR_CHECKSUM    =  -5, -> Check sum test failed
      XPKERR_VERSION     =  -6, -> Packed file's version newer than lib
      XPKERR_NOMEM       =  -7, -> Out of memory
      XPKERR_LIBINUSE    =  -8, -> For not-reentrant libraries
      XPKERR_WRONGFORM   =  -9, -> Was not packed with this library
      XPKERR_SMALLBUF    = -10, -> Output buffer too small
      XPKERR_LARGEBUF    = -11, -> Input buffer too large
      XPKERR_WRONGMODE   = -12, -> This packing mode not supported
      XPKERR_NEEDPASSWD  = -13, -> Password needed for decoding
      XPKERR_CORRUPTPKD  = -14, -> Packed file is corrupt
      XPKERR_MISSINGLIB  = -15, -> Required library is missing
      XPKERR_BADPARAMS   = -16, -> Caller's TagList was screwed up
      XPKERR_EXPANSION   = -17, -> Would have caused data expansion
      XPKERR_NOMETHOD    = -18, -> Can't find requested method
      XPKERR_ABORTED     = -19, -> Operation aborted by user
      XPKERR_TRUNCATED   = -20, -> Input file is truncated
      XPKERR_WRONGCPU    = -21, -> Better CPU required for this library
      XPKERR_PACKED      = -22, -> Data are already XPacked
      XPKERR_NOTPACKED   = -23, -> Data not packed
      XPKERR_FILEEXISTS  = -24, -> File already exists
      XPKERR_OLDMASTLIB  = -25, -> Master library too old
      XPKERR_OLDSUBLIB   = -26, -> Sub library too old
      XPKERR_NOCRYPT     = -27, -> Cannot encrypt
      XPKERR_NOINFO      = -28, -> Can't get info on that packer
      XPKERR_LOSSY       = -29, -> This compression method is lossy
      XPKERR_NOHARDWARE  = -30, -> Compression hardware required
      XPKERR_BADHARDWARE = -31, -> Compression hardware failed
      XPKERR_WRONGPW     = -32  -> Password was wrong


CONST XPKERRMSGSIZE	= 80	->  Maximum size of an error message






/*****************************************************************************
 *
 *
 *     The XpkQuery() call
 *
 */

OBJECT xpkPackerInfo
  name[24]        :ARRAY  -> Brief name of the packer
  longName[32]    :ARRAY  -> Full name of the packer
  description[80] :ARRAY  -> One line description of packer

  flags     :LONG   -> Defined below
  maxChunk  :LONG   -> Max input chunk size for packing
  defChunk  :LONG   -> Default packing chunk size
  defMode   :INT    -> (unsigned) Default mode on 0..100 scale
ENDOBJECT

-> Defines for Flags
CONST XPKIF_PK_CHUNK    = $00000001, -> Library supplies chunk packing
      XPKIF_PK_STREAM   = $00000002, -> Library supplies stream packing
      XPKIF_PK_ARCHIVE  = $00000004, -> Library supplies archive packing
      XPKIF_UP_CHUNK    = $00000008, -> Library supplies chunk unpacking
      XPKIF_UP_STREAM   = $00000010, -> Library supplies stream unpacking
      XPKIF_UP_ARCHIVE  = $00000020, -> Library supplies archive unpacking
      XPKIF_HOOKIO      = $00000080, -> Uses full Hook I/O
      XPKIF_CHECKING    = $00000400, -> Does its own data checking
      XPKIF_PREREADHDR  = $00000800, -> Unpacker pre-reads the next chunkhdr
      XPKIF_ENCRYPTION  = $00002000, -> Sub library supports encryption
      XPKIF_NEEDPASSWD  = $00004000, -> Sub library requires encryption
      XPKIF_MODES       = $00008000, -> Sub library has different modes
      XPKIF_LOSSY       = $00010000  -> Sub library does lossy compression


OBJECT xpkMode
  next  :PTR TO xpkMode -> Chain to next descriptor for ModeDesc list*/

  upto        :LONG     -> (unsigned) Maximum efficiency handled by this mode
  flags       :LONG     -> (unsigned) Defined below
  packMemory  :LONG     -> (unsigned) Extra memory required during packing
  unpackMemory:LONG     -> (unsigned) Extra memory during unpacking
  packSpeed   :LONG     -> (unsigned) Approx packing speed in K per second
  unpackSpeed :LONG     -> (unsigned) Approx unpacking speed in K per second
  ratio       :INT      -> (unsigned) CF in 0.1% for AmigaVision executable
  chunkSize   :INT      -> (unsigned) Desired chunk size in K (!!) for this mode

  description[10]:ARRAY -> 7 character mode description
ENDOBJECT

-> Defines for XpkMode.Flags
CONST XPKMF_A3000SPEED = $00000001, -> Timings on A3000/25
      XPKMF_PK_NOCPU   = $00000002, -> Packing not heavily CPU dependent
      XPKMF_UP_NOCPU   = $00000004  -> Unpacking... (i.e. hardware modes)

CONST MAXPACKERS = 100
CONST XPK_PACKER_ARRAY_SIZE = MAXPACKERS * 6

OBJECT xpkPackerList
  numPackers                    :LONG   -> (unsigned)
  packer[XPK_PACKER_ARRAY_SIZE] :ARRAY  -> MAXPACKERS items. 6 bytes each
ENDOBJECT




/*****************************************************************************
 *
 *
 *     The XpkOpen() type calls
 *
 */

CONST XPKLEN_ONECHUNK = $7fffffff

#define xpkFH xpkFib

