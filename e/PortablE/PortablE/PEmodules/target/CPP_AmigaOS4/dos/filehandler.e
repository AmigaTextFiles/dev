/* $VER: filehandler.h 53.29 (10.8.2015) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/ports', 'target/dos/dos', 'target/dos/dosextens'
MODULE 'target/exec/types', 'target/dos/notify', 'target/utility/tagitem'
{
#define NO_VECTORPORT_FUNCTION_PROTOTYPES
#include <dos/filehandler.h>
}
NATIVE {DOS_FILEHANDLER_H} CONST

NATIVE {NO_VECTORPORT_FUNCTION_PROTOTYPES} CONST
#define NO_VECTORPORT_FUNCTION_PROTOTYPES

NATIVE {NT_FILESYSTEM}  CONST NT_FILESYSTEM  = 28

/****************************************************************************
**  The disk "environment" structure was a longword array that describes
**  the disk geometry.  It has traditionally been a variable sized array, 
**  with the number of 32 bit entries that follow de_TableSize in de_TableSize.  
**
**  It was not guaranteed to be the sizeof(struct DosEnvec), so check it.
**
**  New implementations should always allocate the full public structure size
**  regardless of how many fields are actually in use.
**  All unused fields shall be cleared to zero and de_TableSize=DE_BOOTBLOCKS.
**
*/

NATIVE {DosEnvec} OBJECT dosenvec
    {de_TableSize}	tablesize	:ULONG        /* Number of 32 bit entries following this. */
    
    {de_SectorSize}	sizeblock	:ULONG       /* in longwords: Physical disk sector size */
    {de_SecOrg}	secorg	:ULONG           /* not used; must be 0 */
    {de_Surfaces}	surfaces	:ULONG         /* # of heads (surfaces). drive specific */
    {de_SectorPerBlock}	sectorperblock	:ULONG   /* N de_SectorSize sectors per logical block */
    {de_SectorPerTrack}	blockspertrack	:ULONG   /* sectors per track. drive specific */
    {de_Reserved}	reserved	:ULONG         /* DOS reserved blocks at start of partition. */
    {de_PreAlloc}	prealloc	:ULONG         /* DOS reserved blocks at end of partition */
    {de_Interleave}	interleave	:ULONG       /* usually 0 */
    {de_LowCyl}	lowcyl	:ULONG           /* starting cylinder. typically 0 */
    {de_HighCyl}	highcyl	:ULONG          /* max cylinder. drive specific */
    {de_NumBuffers}	numbuffers	:ULONG       /* Initial # DOS of buffers.  */
    {de_BufMemType}	bufmemtype	:ULONG       /* type of mem to allocate for buffers */
    {de_MaxTransfer}	maxtransfer	:ULONG      /* Max number of bytes to transfer at a time */
    {de_Mask}	mask	:ULONG             /* Address Mask to block out certain memory */
    {de_BootPri}	bootpri	:VALUE          /* Boot priority for autoboot */
    {de_DosType}	dostype	:ULONG          /* ASCII (HEX) string showing filesystem type;
                                      0x444F5300 is old filesystem,
                                      0x444F5301 is fast file system */
    {de_Baud}	baud	:ULONG             /* Baud rate for serial handler */
    {de_Control}	control	:ULONG          /* Control word for handler/filesystem */
    {de_BootBlocks}	bootblocks	:ULONG       /* Number of blocks containing boot code */
ENDOBJECT


/* The following are the offsets when DosEnvec was accessed as an array of longwords;
** DE_TABLESIZE is set to the number of fields in the array, minus 1,
** that is, NOT including the DE_TABLESIZE field itself. 
** So if de_DosType was the last valid entry, de_TableSize == DE_DOSTYPE.
*/

NATIVE {DE_TABLESIZE}      CONST DE_TABLESIZE      = 0    /* minimum value is 11 (includes NumBuffers) */
NATIVE {DE_SECSIZE}        CONST DE_SECSIZE        = 1    /* in longwords: standard value is 128 */
NATIVE {DE_SECORG}         CONST DE_SECORG         = 2    /* not used; must be 0 */
NATIVE {DE_NUMHEADS}       CONST DE_NUMHEADS       = 3    /* # of heads (surfaces). drive specific */
NATIVE {DE_SECSPERBLK}     CONST DE_SECSPERBLK     = 4    /* not used; must be 1 */
NATIVE {DE_SECSPERTRACK}   CONST DE_SECSPERTRACK   = 5    /* sectors per track. drive specific */
NATIVE {DE_RESERVEDBLKS}   CONST DE_RESERVEDBLKS   = 6    /* unavailable blocks at start.     usually 2 */
NATIVE {DE_PREFAC}         CONST DE_PREFAC         = 7    /* not used; must be 0 */
NATIVE {DE_INTERLEAVE}     CONST DE_INTERLEAVE     = 8    /* usually 0 */
NATIVE {DE_LOWCYL}         CONST DE_LOWCYL         = 9    /* starting cylinder. typically 0 */
NATIVE {DE_UPPERCYL}      CONST DE_UPPERCYL      = 10    /* max cylinder.  drive specific */
NATIVE {DE_NUMBUFFERS}    CONST DE_NUMBUFFERS    = 11    /* starting # of buffers.  typically 5 */

NATIVE {DE_BUFMEMTYPE}    CONST DE_BUFMEMTYPE    = 12    /* type of mem to allocate for buffers. */
                               /* 1 is public, 3 is chip, 5 is fast */
NATIVE {DE_MAXTRANSFER}   CONST DE_MAXTRANSFER   = 13    /* Max number bytes to transfer at a time */
NATIVE {DE_MASK}          CONST DE_MASK          = 14    /* Address Mask to block out certain memory */
NATIVE {DE_BOOTPRI}       CONST DE_BOOTPRI       = 15    /* Boot priority for autoboot */
NATIVE {DE_DOSTYPE}       CONST DE_DOSTYPE       = 16    /* ASCII (HEX) string showing filesystem type;
                                * 0x444F5300 is old filesystem,
                                * 0x444F5301 is fast file system */
NATIVE {DE_BAUD}          CONST DE_BAUD          = 17    /* Baud rate for serial handler */
NATIVE {DE_CONTROL}       CONST DE_CONTROL       = 18    /* Control word for handler/filesystem */
NATIVE {DE_BOOTBLOCKS}    CONST DE_BOOTBLOCKS    = 19    /* Number of blocks containing boot code */




/****************************************************************************
** The file system startup message is linked into a device node's startup
** field. It contains a pointer to the above environment, plus the
** information needed to do an exec OpenDevice(). 
*/

NATIVE {FileSysStartupMsg} OBJECT filesysstartupmsg
    {fssm_Unit}	unit	:ULONG      /* exec unit number for this device */
    {fssm_Device}	device	:BSTR    /* null terminated bstring to the device name */
    {fssm_Environ}	environ	:BPTR   /* ptr to environment table (see above) */
    {fssm_Flags}	flags	:ULONG     /* flags for OpenDevice() */
ENDOBJECT



/****************************************************************************
** The public portion of the structure used for the new V50 functions; 
** GetDiskFileSystemData() and FreeDiskFileSystemData(). 
** Do not depend on the size of this structure to stay constant. 
*/


NATIVE {FileSystemData} OBJECT filesystemdata
    {fsd_Size}	size	:ULONG           /* the size of this structure   */
    {fsd_FileSystemName}	filesystemname	:/*STRPTR*/ ARRAY OF CHAR
    {fsd_DeviceName}	devicename	:/*STRPTR*/ ARRAY OF CHAR
    {fsd_DeviceUnit}	deviceunit	:ULONG
    {fsd_DeviceFlags}	deviceflags	:ULONG
    {fsd_Environment}	environment	:PTR TO dosenvec    /* WARNING: See (Note 1) below    */
    {fsd_DosPrivate}	dosprivate[4]	:ARRAY OF APTR  /* this really is dos private ! */  
    {fsd_Reserved}	reserved[4]	:ARRAY OF APTR         
ENDOBJECT

/*  Note 1:
**  ======
**  The fsd_Environment is a pointer to variable size array of longword
**  entries that follow the de_TableSize field.  
**  You must not assume it is always sizeof(struct DosEnvec).
**  See struct DosEnvec for more information. (above).
*/








/****************************************************************************
** The new V53 struct FileSystemVectorPort includes follow.
**
** See the autodoc "dos.dospacket.doc"  (initial introductory section) for
** further information on the new style V53 filesystem vector-port calling method.
**
****************************************************************************/

NATIVE {FS_VECTORPORT_VERSION}      CONST FS_VECTORPORT_VERSION      = 53
NATIVE {FSVP}                       CONST   /* shortcut */

/****************************************************************************/

->NATIVE {NotifyRequest} OBJECT notifyrequest
->ENDOBJECT            /* FWD reference */


/****************************************************************************
** For new vector-port filesystems, the following are the maximum lengths  
** that should be supported.  String buffers should also reflect these.
** Older ported filesystem designs may not be able to support these lengths
** due to internal structure limitations, so call IDOS->FileSystemAttr()
** to find out the actual filesystem specific values.
*/


->NATIVE {MAX_VP_FILENAME}   CONST MAX_VP_FILENAME   = 255

->NATIVE {MAX_VP_COMMENT}    CONST MAX_VP_COMMENT    = 255

->NATIVE {MAX_VP_SOFTLINK_TARGET}   CONST MAX_VP_SOFTLINK_TARGET   = 4000


/****************************************************************************
**  This vector initialisation structure is defined as a constant static structure and initialised
**  by the filesystem with all of the mentioned sundry data and function pointers, 
**  a pointer to this structure is then passed as a parameter to IDOS->AllocDosObject() which will
**  copy it to the 'FSV' space of the allocated struct FileSystemVectorPort structure.
**
**  For unimplemented functions, a stub routine that returns 0 and ERROR_ACTION_NOT_KNOWN in result2
**  should be used instead of a NULL pointer, this prevents DOS from falling back and retrying the
**  same action with the equivalent DosPacket. See 'struct FileSystemVectorPort' info below for details.
*/ 

NATIVE {FileSystemVectors} OBJECT filesystemvectors
    {StructSize}	structsize	:ULONG  /* Filesystem must initialise this to; sizeof(struct FileSystemVectors) */
    {Version}	version	:ULONG     /* Filesystem must initialise this to; FS_VECTORPORT_VERSION  */

    {FSPrivate}	fsprivate	:APTR   /* Private field for exclusive use by the filesystem, this is generally */
                                /* used to point to the filesystems private global data structure to    */
                                /* make it accessible from the vector-port functions.                   */
                                /* Optionally, the filesystem may just initialise this to zero and then */
                                /* after the AllocDosObject() call, place your required data in there.  */

    {Reserved}	reserved[3]	:ARRAY OF ULONG /* Filesystems initialise these to 0 - reserved expansion */

    {DOSPrivate}	dosprivate	:APTR  /* Filesystems initialise this  to 0 - private DOS usage */

    {DOSEmulatePacket}	dosemulatepacket	:PTR /*void           (*DOSEmulatePacket)(struct FSVP *vp, struct DosPacket *dp)*/  
                   /* Filesystems shall initialise this to NULL.  */
                   /* AllocDosObject() will insert a function pointer here for the filesystem to use.  */
                   /* This function is to be called from the packet handler process of the filesystem  */
                   /* to provide legacy emulation support for old applications that send Dospackets    */
                   /* directly to the filesystem message port.                                         */
                   /* See; "dos.dospacket.doc" for further details and example source code for this.   */
                

    /***************************************************************************************************/

    {FSLock}	fslock	:PTR /*Lock * (*FSLock)(struct FSVP *vp, int32 *res2, struct Lock *rel_lock, CONST_STRPTR obj, int32 mode)*/
                  /* Equivalent function for ACTION_LOCK.
                   * Always returns a SHARED_LOCK for directories no matter what 'mode' is requested.
                   * The EXCLUSIVE_LOCK mode is for files only.
                   */

    {FSUnLock}	fsunlock	:PTR /*int32         (*FSUnLock)(struct FSVP *vp, int32 *res2, struct Lock *lock)*/
                  /* Equivalent function for ACTION_UNLOCK */

    {FSDupLock}	fsduplock	:PTR /*Lock * (*FSDupLock)(struct FSVP *vp, int32 *res2, struct Lock *lock)*/
                  /* Equivalent function for ACTION_COPY_LOCK */

    {FSCreateDir}	fscreatedir	:PTR /*Lock * (*FSCreateDir)(struct FSVP *vp, int32 *res2, struct Lock *rel_lock, CONST_STRPTR obj)*/
                  /* Equivalent function for ACTION_CREATE_DIR - always returns a SHARED_LOCK */

    {FSParentDir}	fsparentdir	:PTR /*Lock * (*FSParentDir)(struct FSVP *vp, int32 *res2, struct Lock *dirlock)*/
                  /* Equivalent function for ACTION_PARENT - always returns a SHARED_LOCK */


    {FSDupLockFromFH}	fsduplockfromfh	:PTR /*Lock * (*FSDupLockFromFH)(struct FSVP *vp, int32 *res2, struct FileHandle *filehandle)*/
                  /* Equivalent function for ACTION_COPY_LOCK_FH */

    {FSOpenFromLock}	fsopenfromlock	:PTR /*int32         (*FSOpenFromLock)(struct FSVP *vp, int32 *res2, struct FileHandle *file, struct Lock *lock)*/
                  /* Equivalent function for ACTION_FH_FROM_LOCK */

    {FSParentOfFH}	fsparentoffh	:PTR /*Lock * (*FSParentOfFH)(struct FSVP *vp, int32 *res2, struct FileHandle *file)*/
                  /* Equivalent function for ACTION_PARENT_FH   */


    {FSOpen}	fsopen	:PTR /*int32         (*FSOpen)(struct FSVP *vp, int32 *res2, struct FileHandle *fh, struct Lock *rel_dir, CONST_STRPTR obj, int32 mode)*/
                  /* Equivalent function for ACTION_FINDUPDATE, ACTION_FINDINPUT, ACTION_FINDOUTPUT */

    {FSClose}	fsclose	:PTR /*int32         (*FSClose)(struct FSVP *vp, int32 *res2, struct FileHandle *file)*/
                  /* Equivalent function for ACTION_END */

    {FSDelete}	fsdelete	:PTR /*int32         (*FSDelete)(struct FSVP *vp, int32 *res2, struct Lock *rel_dirlock, CONST_STRPTR obj)*/
                  /* Equivalent function for ACTION_DELETE_OBJECT */

    {FSRead}	fsread	:PTR /*int32         (*FSRead)(struct FSVP *vp, int32 *res2, struct FileHandle *file, STRPTR buffer, int32 numbytes)*/
                  /* Equivalent function for ACTION_READ */

    {FSWrite}	fswrite	:PTR /*int32         (*FSWrite)(struct FSVP *vp, int32 *res2, struct FileHandle *file, STRPTR buffer, int32 numbytes)*/
                  /* Equivalent function for ACTION_WRITE */

    {FSFlush}	fsflush	:PTR /*int32         (*FSFlush)(struct FSVP *vp, int32 *res2)*/
                  /* Equivalent function for ACTION_FLUSH  */


    {FSChangeFilePosition}	fschangefileposition	:PTR /*int32         (*FSChangeFilePosition)(struct FSVP *vp, int32 *res2, struct FileHandle *file, int32 mode, int64 position)*/
                  /* Equivalent function for ACTION_CHANGE_FILE_POSITION64  */
 
    {FSChangeFileSize}	fschangefilesize	:PTR /*int32         (*FSChangeFileSize)(struct FSVP *vp, int32 *res2, struct FileHandle *file, int32 mode, int64 size)*/
                  /* Equivalent function for ACTION_CHANGE_FILE_SIZE64 */


    {FSGetFilePosition}	fsgetfileposition	:PTR /*int64         (*FSGetFilePosition)(struct FSVP *vp, int32 *res2, struct FileHandle *file )*/
                  /* Equivalent function for ACTION_GET_FILE_POSITION64 */

    {FSGetFileSize}	fsgetfilesize	:PTR /*int64         (*FSGetFileSize)(struct FSVP *vp, int32 *res2, struct FileHandle *file )*/
                  /* Equivalent function for ACTION_GET_FILE_SIZE64 */


    {FSChangeLockMode}	fschangelockmode	:PTR /*int32         (*FSChangeLockMode)(struct FSVP *vp, int32 *res2, struct Lock *lock, int32 new_lock_mode)*/
                  /* Equivalent function for ACTION_CHANGE_MODE (LOCK) - never changes directories from a SHARED_LOCK */ 

    {FSChangeFileMode}	fschangefilemode	:PTR /*int32         (*FSChangeFileMode)(struct FSVP *vp, int32 *res2, struct FileHandle *fh, int32 new_lock_mode)*/
                  /* Equivalent function for ACTION_CHANGE_MODE (FILE) */


    {FSSetDate}	fssetdate	:PTR /*int32         (*FSSetDate)(struct FSVP *vp, int32 *res2, struct Lock *rel_dirlock, CONST_STRPTR name, const struct DateStamp *ds)*/
                  /* Equivalent function for ACTION_SET_DATE */

    {FSSetProtection}	fssetprotection	:PTR /*int32         (*FSSetProtection)(struct FSVP *vp, int32 *res2, struct Lock *rel_dirlock, CONST_STRPTR name, uint32 mask)*/
                  /* Equivalent function for ACTION_SET_PROTECT */

    {FSSetComment}	fssetcomment	:PTR /*int32         (*FSSetComment)(struct FSVP *vp, int32 *res2, struct Lock *rel_dirlock, CONST_STRPTR name, CONST_STRPTR comment)*/
                  /* Equivalent function for ACTION_SET_COMMENT */

    {FSSetGroup}	fssetgroup	:PTR /*int32         (*FSSetGroup)(struct FSVP *vp, int32 *res2, struct Lock *rel_dirlock, CONST_STRPTR name, uint32 group)*/
                  /* Equivalent function for ACTION_SET_OWNER / ACTION_SET_OWNER_INFO */

    {FSSetOwner}	fssetowner	:PTR /*int32         (*FSSetOwner)(struct FSVP *vp, int32 *res2, struct Lock *rel_dirlock, CONST_STRPTR name, uint32 owner)*/
                  /* Equivalent function for ACTION_SET_OWNER / ACTION_SET_OWNER_INFO */

    {FSRename}	fsrename	:PTR /*int32         (*FSRename)(struct FSVP *vp, int32 *res2, struct Lock *src_rel, CONST_STRPTR src, 
                              struct Lock *dst_rel, CONST_STRPTR dst)*/
                  /* Equivalent function for ACTION_RENAME_OBJECT */


    {FSCreateSoftLink}	fscreatesoftlink	:PTR /*int32         (*FSCreateSoftLink)(struct FSVP *vp, int32 *res2, struct Lock *rel_dirlock, 
                                      CONST_STRPTR linkname, CONST_STRPTR dest_obj)*/
                  /* Equivalent function for ACTION_MAKE_LINK (SOFT) */

    {FSCreateHardLink}	fscreatehardlink	:PTR /*int32         (*FSCreateHardLink)(struct FSVP *vp, int32 *res2, struct Lock *rel_dirlock, 
                                      CONST_STRPTR linkname, struct Lock *dest_obj)*/
                  /* Equivalent function for ACTION_MAKE_LINK (HARD) */

    {FSReadSoftLink}	fsreadsoftlink	:PTR /*int32         (*FSReadSoftLink)(struct FSVP *vp, int32 *res2, struct Lock *rel_dir, 
                                    CONST_STRPTR linkname, STRPTR buf, int32 bufsize)*/
                  /* Equivalent function for ACTION_READ_SOFT_LINK */


    {FSSameLock}	fssamelock	:PTR /*int32         (*FSSameLock)(struct FSVP *vp, int32 *res2, struct Lock *lock1, struct Lock *lock2)*/
                  /* Equivalent function for ACTION_SAME_LOCK */

    {FSSameFile}	fssamefile	:PTR /*int32         (*FSSameFile)(struct FSVP *vp, int32 *res2, struct FileHandle *fh1, struct FileHandle *fh2)*/
                  /* Equivalent function for ACTION_SAME_FH */


    {FSFileSystemAttr}	fsfilesystemattr	:PTR /*int32         (*FSFileSystemAttr)(struct FSVP *vp, int32 *res2, struct TagItem *taglist)*/
                  /* Equivalent function for ACTION_FILESYSTEM_ATTR  */

    {FSVolumeInfoData}	fsvolumeinfodata	:PTR /*int32         (*FSVolumeInfoData)(struct FSVP *vp, int32 *res2, struct InfoData *info)*/
                  /* Equivalent function for ACTION_INFO. */

    {FSDeviceInfoData}	fsdeviceinfodata	:PTR /*int32         (*FSDeviceInfoData)(struct FSVP *vp, int32 *res2, struct InfoData *info)*/
                  /* Equivalent function for ACTION_DISK_INFO. */


    {FSReserved1}	fsreserved1	:PTR /*int32         (*FSReserved1)(struct FSVP *vp, int32 *res2)*/
                  /* Spare function slot, Filesystems initialise this to NULL */

    {FSReserved2}	fsreserved2	:PTR /*int32         (*FSReserved2)(struct FSVP *vp, int32 *res2)*/
                  /* Spare function slot, Filesystems initialise this to NULL */
 

    {FSExamineLock}	fsexaminelock	:PTR /*ExamineData *
                  (*FSExamineLock)(struct FSVP *vp, int32 *res2, struct Lock *lock)*/
                  /* Equivalent function for ACTION_EXAMINEDATA */

    {FSExamineFile}	fsexaminefile	:PTR /*ExamineData *
                  (*FSExamineFile)(struct FSVP *vp, int32 *res2, struct FileHandle *file)*/
                  /* Equivalent function for ACTION_EXAMINEDATA_FH */

    {FSExamineDir}	fsexaminedir	:PTR /*int32         (*FSExamineDir)(struct FSVP *vp, int32 *res2, struct PRIVATE_ExamineDirContext *ctx)*/
                  /* Equivalent function for ACTION_EXAMINEDATA_DIR */



    {FSInhibit}	fsinhibit	:PTR /*int32         (*FSInhibit)(struct FSVP *vp, int32 *res2, int32 inhibit_state)*/
                  /* Equivalent function for ACTION_INHIBIT  */

    {FSWriteProtect}	fswriteprotect	:PTR /*int32         (*FSWriteProtect)(struct FSVP *vp, int32 *res2, int32 wp_state, uint32 passkey)*/
                  /* Equivalent function for ACTION_WRITE_PROTECT */

    {FSFormat}	fsformat	:PTR /*int32         (*FSFormat)(struct FSVP *vp, int32 *res2, CONST_STRPTR new_volname, uint32 dostype)*/
                  /* Equivalent function for ACTION_FORMAT */

    {FSSerialize}	fsserialize	:PTR /*int32         (*FSSerialize)(struct FSVP *vp, int32 *res2)*/
                  /* Equivalent function for ACTION_SERIALIZE_DISK */

    {FSRelabel}	fsrelabel	:PTR /*int32         (*FSRelabel)(struct FSVP *vp, int32 *res2, CONST_STRPTR new_volumename)*/
                  /* Equivalent function for ACTION_RENAME_DISK */


    {FSReserved3}	fsreserved3	:PTR /*int32         (*FSReserved3)(struct FSVP *vp, int32 *res2)*/  
                  /* Spare function slot, Filesystems initialise this to NULL */



   /*************************************************************************
    **  OPTIONAL FUNCTIONS 
    **  ==================
    **  The following two notification functions are optional, the dos.library
    **  provides these functions internally when these functions returns FALSE
    **  and Result2 = ERROR_ACTION_NOT_KNOWN.
    **  These vectors have been provided for remote filesystem implementations.
    */
  
    {FSAddNotify}	fsaddnotify	:PTR /*int32         (*FSAddNotify)(struct FSVP *vp, int32 *res2, struct NotifyRequest *nr)*/
                  /* Equivalent function for ACTION_ADD_NOTIFY */

    {FSRemoveNotify}	fsremovenotify	:PTR /*int32         (*FSRemoveNotify)(struct FSVP *vp, int32 *res2, struct NotifyRequest *nr)*/
                  /* Equivalent function for ACTION_REMOVE_NOTIFY */



  /*************************************************************************
    **  OPTIONAL FUNCTIONS 
    **  ==================
    **  The following two record locking functions are optional, the dos.library
    **  provides these functions internally when these vector functions returns
    **  FALSE and Result2 = ERROR_ACTION_NOT_KNOWN.
    **  These vectors have been provided for remote filesystem implementations.
    */
 
    {FSLockRecord}	fslockrecord	:PTR /*int32         (*FSLockRecord)(struct FSVP *vp, int32 *res2, struct FileHandle *file,
                                  int64 offset, int64 length, uint32 mode, uint32 timeout)*/
                  /* Equivalent function for ACTION_LOCK_RECORD64 */

    {FSUnLockRecord}	fsunlockrecord	:PTR /*int32         (*FSUnLockRecord)(struct FSVP *vp, int32 *res2, struct FileHandle *file,
                                    int64 offset, int64 length)*/
                  /* Equivalent function for ACTION_FREE_RECORD64 */




    /*=== End of V53 vectors, - New V54 vectors to be added after this line ===*/

    {End_Marker}	end_marker	:VALUE  /* This must always be at vector table end, set to -1 */
ENDOBJECT







/****************************************************************************
**
** This is the structure returned from IDOS->AllocDosObject(DOS_FSVECTORPORT,...)
** it is pre-initialised so that it is ready to be called by dos.library.
** 
** The dos.library always validates this structure before every call to any
** of the function vectors with the IDOS->GetFileSystemVectorPort() function, 
** it does this by checking three important criteria;
**
**    1) The MP.mp_Node.ln_Type must have a value of NT_FILESYSTEM.
**    2) The FSV.Version must be 53 (or greater for later additions).
**    3) The actual function vector pointer must not be NULL.
**
** Failure to validate any of these three tests will cause dos.library to 
** fall back to sending a DosPacket to the filesystem message port.
**
*/

NATIVE {FileSystemVectorPort} OBJECT filesystemvectorport
   {MP}	mp	:mp  
   {FSV}	fsv	:filesystemvectors
ENDOBJECT






#ifndef NO_VECTORPORT_FUNCTION_PROTOTYPES

NATIVE {DOSEmulatePacket} PROC
PROC DosEmulatePacket(vp:PTR TO filesystemvectorport, dp:PTR TO dospacket) IS NATIVE {DOSEmulatePacket(} vp {,} dp {)} ENDNATIVE  

NATIVE {FSLock} PROC
PROC FsLock(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_lock:PTR TO filelock, obj:/*CONST_STRPTR*/ ARRAY OF CHAR, mode:VALUE) IS NATIVE {FSLock(} vp {,} res2 {,} rel_lock {,} obj {,} mode {)} ENDNATIVE !!PTR TO filelock
NATIVE {FSUnLock} PROC
PROC FsUnLock(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, lock:PTR TO filelock) IS NATIVE {FSUnLock(} vp {,} res2 {,} lock {)} ENDNATIVE !!VALUE
NATIVE {FSDupLock} PROC
PROC FsDupLock(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, lock:PTR TO filelock) IS NATIVE {FSDupLock(} vp {,} res2 {,} lock {)} ENDNATIVE !!PTR TO filelock
NATIVE {FSCreateDir} PROC
PROC FsCreateDir(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_lock:PTR TO filelock, obj:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FSCreateDir(} vp {,} res2 {,} rel_lock {,} obj {)} ENDNATIVE !!PTR TO filelock
NATIVE {FSParentDir} PROC
PROC FsParentDir(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, dirlock:PTR TO filelock) IS NATIVE {FSParentDir(} vp {,} res2 {,} dirlock {)} ENDNATIVE !!PTR TO filelock
NATIVE {FSDupLockFromFH} PROC
PROC FsDupLockFromFH(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, filehandle:PTR TO filehandle) IS NATIVE {FSDupLockFromFH(} vp {,} res2 {,} filehandle {)} ENDNATIVE !!PTR TO filelock
NATIVE {FSOpenFromLock} PROC
PROC FsOpenFromLock(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle, lock:PTR TO filelock) IS NATIVE {FSOpenFromLock(} vp {,} res2 {,} file {,} lock {)} ENDNATIVE !!VALUE
NATIVE {FSParentOfFH} PROC
PROC FsParentOfFH(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle) IS NATIVE {FSParentOfFH(} vp {,} res2 {,} file {)} ENDNATIVE !!PTR TO filelock
NATIVE {FSOpen} PROC
PROC FsOpen(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, fh:PTR TO filehandle, rel_dir:PTR TO filelock, obj:/*CONST_STRPTR*/ ARRAY OF CHAR, mode:VALUE) IS NATIVE {FSOpen(} vp {,} res2 {,} fh {,} rel_dir {,} obj {,} mode {)} ENDNATIVE !!VALUE
NATIVE {FSClose} PROC
PROC FsClose(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle) IS NATIVE {FSClose(} vp {,} res2 {,} file {)} ENDNATIVE !!VALUE
NATIVE {FSDelete} PROC
PROC FsDelete(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_dirlock:PTR TO filelock, obj:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FSDelete(} vp {,} res2 {,} rel_dirlock {,} obj {)} ENDNATIVE !!VALUE
NATIVE {FSRead} PROC
PROC FsRead(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle, buffer:/*STRPTR*/ ARRAY OF CHAR, numbytes:VALUE) IS NATIVE {FSRead(} vp {,} res2 {,} file {,} buffer {,} numbytes {)} ENDNATIVE !!VALUE
NATIVE {FSWrite} PROC
PROC FsWrite(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle, buffer:/*STRPTR*/ ARRAY OF CHAR, numbytes:VALUE) IS NATIVE {FSWrite(} vp {,} res2 {,} file {,} buffer {,} numbytes {)} ENDNATIVE !!VALUE
NATIVE {FSFlush} PROC
PROC FsFlush(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE) IS NATIVE {FSFlush(} vp {,} res2 {)} ENDNATIVE !!VALUE
NATIVE {FSChangeFilePosition} PROC
PROC FsChangeFilePosition(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle, mode:VALUE, position:BIGVALUE) IS NATIVE {FSChangeFilePosition(} vp {,} res2 {,} file {,} mode {,} position {)} ENDNATIVE !!VALUE
NATIVE {FSChangeFileSize} PROC
PROC FsChangeFileSize(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle, mode:VALUE, size:BIGVALUE) IS NATIVE {FSChangeFileSize(} vp {,} res2 {,} file {,} mode {,} size {)} ENDNATIVE !!VALUE
NATIVE {FSGetFilePosition} PROC
PROC FsGetFilePosition(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle ) IS NATIVE {FSGetFilePosition(} vp {,} res2 {,} file {)} ENDNATIVE !!BIGVALUE
NATIVE {FSGetFileSize} PROC
PROC FsGetFileSize(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle ) IS NATIVE {FSGetFileSize(} vp {,} res2 {,} file {)} ENDNATIVE !!BIGVALUE
NATIVE {FSChangeLockMode} PROC
PROC FsChangeLockMode(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, lock:PTR TO filelock, new_lock_mode:VALUE) IS NATIVE {FSChangeLockMode(} vp {,} res2 {,} lock {,} new_lock_mode {)} ENDNATIVE !!VALUE
NATIVE {FSChangeFileMode} PROC
PROC FsChangeFileMode(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, fh:PTR TO filehandle, new_lock_mode:VALUE) IS NATIVE {FSChangeFileMode(} vp {,} res2 {,} fh {,} new_lock_mode {)} ENDNATIVE !!VALUE
NATIVE {FSSetDate} PROC
PROC FsSetDate(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_dirlock:PTR TO filelock, name:/*CONST_STRPTR*/ ARRAY OF CHAR, ds:PTR TO datestamp) IS NATIVE {FSSetDate(} vp {,} res2 {,} rel_dirlock {,} name {,} ds {)} ENDNATIVE !!VALUE
NATIVE {FSSetProtection} PROC
PROC FsSetProtection(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_dirlock:PTR TO filelock, name:/*CONST_STRPTR*/ ARRAY OF CHAR, mask:ULONG) IS NATIVE {FSSetProtection(} vp {,} res2 {,} rel_dirlock {,} name {,} mask {)} ENDNATIVE !!VALUE
NATIVE {FSSetComment} PROC
PROC FsSetComment(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_dirlock:PTR TO filelock, name:/*CONST_STRPTR*/ ARRAY OF CHAR, comment:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FSSetComment(} vp {,} res2 {,} rel_dirlock {,} name {,} comment {)} ENDNATIVE !!VALUE
NATIVE {FSSetGroup} PROC
PROC FsSetGroup(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_dirlock:PTR TO filelock, name:/*CONST_STRPTR*/ ARRAY OF CHAR, group:ULONG) IS NATIVE {FSSetGroup(} vp {,} res2 {,} rel_dirlock {,} name {,} group {)} ENDNATIVE !!VALUE
NATIVE {FSSetOwner} PROC
PROC FsSetOwner(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_dirlock:PTR TO filelock, name:/*CONST_STRPTR*/ ARRAY OF CHAR, owner:ULONG) IS NATIVE {FSSetOwner(} vp {,} res2 {,} rel_dirlock {,} name {,} owner {)} ENDNATIVE !!VALUE
NATIVE {FSRename} PROC
PROC FsRename(vp:PTR TO filesystemvectorport, r2:ARRAY OF VALUE, srcl:PTR TO filelock, src:/*CONST_STRPTR*/ ARRAY OF CHAR, dstl:PTR TO filelock, dst:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FSRename(} vp {,} r2 {,} srcl {,} src {,} dstl {,} dst {)} ENDNATIVE !!VALUE
NATIVE {FSCreateSoftLink} PROC
PROC FsCreateSoftLink(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_dir:PTR TO filelock, linkname:/*CONST_STRPTR*/ ARRAY OF CHAR, dest_obj:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FSCreateSoftLink(} vp {,} res2 {,} rel_dir {,} linkname {,} dest_obj {)} ENDNATIVE !!VALUE
NATIVE {FSCreateHardLink} PROC
PROC FsCreateHardLink(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_dir:PTR TO filelock, linkname:/*CONST_STRPTR*/ ARRAY OF CHAR, dest_obj:PTR TO filelock) IS NATIVE {FSCreateHardLink(} vp {,} res2 {,} rel_dir {,} linkname {,} dest_obj {)} ENDNATIVE !!VALUE
NATIVE {FSReadSoftLink} PROC
PROC FsReadSoftLink(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, rel_dir:PTR TO filelock, linkname:/*CONST_STRPTR*/ ARRAY OF CHAR, buf:/*STRPTR*/ ARRAY OF CHAR, bufsize:VALUE) IS NATIVE {FSReadSoftLink(} vp {,} res2 {,} rel_dir {,} linkname {,} buf {,} bufsize {)} ENDNATIVE !!VALUE
NATIVE {FSSameLock} PROC
PROC FsSameLock(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, lock1:PTR TO filelock, lock2:PTR TO filelock) IS NATIVE {FSSameLock(} vp {,} res2 {,} lock1 {,} lock2 {)} ENDNATIVE !!VALUE
NATIVE {FSSameFile} PROC
PROC FsSameFile(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, fh1:PTR TO filehandle, fh2:PTR TO filehandle) IS NATIVE {FSSameFile(} vp {,} res2 {,} fh1 {,} fh2 {)} ENDNATIVE !!VALUE
NATIVE {FSFileSystemAttr} PROC
PROC FsFileSystemAttr(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, taglist:ARRAY OF tagitem) IS NATIVE {FSFileSystemAttr(} vp {,} res2 {,} taglist {)} ENDNATIVE !!VALUE
NATIVE {FSVolumeInfoData} PROC
PROC FsVolumeInfoData(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, info:PTR TO infodata) IS NATIVE {FSVolumeInfoData(} vp {,} res2 {,} info {)} ENDNATIVE !!VALUE
NATIVE {FSDeviceInfoData} PROC
PROC FsDeviceInfoData(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, info:PTR TO infodata) IS NATIVE {FSDeviceInfoData(} vp {,} res2 {,} info {)} ENDNATIVE !!VALUE
NATIVE {FSReserved1} PROC
PROC FsReserved1(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE) IS NATIVE {FSReserved1(} vp {,} res2 {)} ENDNATIVE !!VALUE
NATIVE {FSReserved2} PROC
PROC FsReserved2(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE) IS NATIVE {FSReserved2(} vp {,} res2 {)} ENDNATIVE !!VALUE
NATIVE {FSExamineLock} PROC
PROC FsExamineLock(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, lock:PTR TO filelock) IS NATIVE {FSExamineLock(} vp {,} res2 {,} lock {)} ENDNATIVE !!PTR TO examinedata
NATIVE {FSExamineFile} PROC
PROC FsExamineFile(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle) IS NATIVE {FSExamineFile(} vp {,} res2 {,} file {)} ENDNATIVE !!PTR TO examinedata
NATIVE {FSExamineDir} PROC
PROC FsExamineDir(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, ctx:PTR TO private_examinedircontext) IS NATIVE {FSExamineDir(} vp {,} res2 {,} ctx {)} ENDNATIVE !!VALUE
NATIVE {FSInhibit} PROC
PROC FsInhibit(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, inhibit_state:VALUE) IS NATIVE {FSInhibit(} vp {,} res2 {,} inhibit_state {)} ENDNATIVE !!VALUE
NATIVE {FSWriteProtect} PROC
PROC FsWriteProtect(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, wp_state:VALUE, passkey:ULONG) IS NATIVE {FSWriteProtect(} vp {,} res2 {,} wp_state {,} passkey {)} ENDNATIVE !!VALUE
NATIVE {FSFormat} PROC
PROC FsFormat(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, new_volname:/*CONST_STRPTR*/ ARRAY OF CHAR, dostype:ULONG) IS NATIVE {FSFormat(} vp {,} res2 {,} new_volname {,} dostype {)} ENDNATIVE !!VALUE
NATIVE {FSSerialize} PROC
PROC FsSerialize(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE) IS NATIVE {FSSerialize(} vp {,} res2 {)} ENDNATIVE !!VALUE
NATIVE {FSRelabel} PROC
PROC FsRelabel(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, new_volumename:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {FSRelabel(} vp {,} res2 {,} new_volumename {)} ENDNATIVE !!VALUE
NATIVE {FSReserved3} PROC
PROC FsReserved3(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE) IS NATIVE {FSReserved3(} vp {,} res2 {)} ENDNATIVE !!VALUE
NATIVE {FSAddNotify} PROC
PROC FsAddNotify(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, nr:PTR TO notifyrequest) IS NATIVE {FSAddNotify(} vp {,} res2 {,} nr {)} ENDNATIVE !!VALUE
NATIVE {FSRemoveNotify} PROC
PROC FsRemoveNotify(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, nr:PTR TO notifyrequest) IS NATIVE {FSRemoveNotify(} vp {,} res2 {,} nr {)} ENDNATIVE !!VALUE
NATIVE {FSLockRecord} PROC
PROC FsLockRecord(vp:PTR TO filesystemvectorport, r2:ARRAY OF VALUE, f:PTR TO filehandle,oset:BIGVALUE, len:BIGVALUE, m:ULONG, tot:ULONG) IS NATIVE {FSLockRecord(} vp {,} r2 {,} f {,} oset {,} len {,} m {,} tot {)} ENDNATIVE !!VALUE
NATIVE {FSUnLockRecord} PROC
PROC FsUnLockRecord(vp:PTR TO filesystemvectorport, res2:ARRAY OF VALUE, file:PTR TO filehandle, offset:BIGVALUE, length:BIGVALUE) IS NATIVE {FSUnLockRecord(} vp {,} res2 {,} file {,} offset {,} length {)} ENDNATIVE !!VALUE

#endif
