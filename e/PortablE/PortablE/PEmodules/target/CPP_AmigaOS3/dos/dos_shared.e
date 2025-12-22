OPT NATIVE
MODULE 'target/exec/types'

->NATIVE {DateStamp} DEF, PROC, OBJECT
NATIVE {DateStamp} OBJECT datestamp
   {ds_Days}	days	:VALUE	      /* Number of days since Jan. 1, 1978 */
   {ds_Minute}	minute	:VALUE	      /* Number of minutes past midnight */
   {ds_Tick}	tick	:VALUE	      /* Number of ticks past minute */
ENDOBJECT /* DateStamp */

->NATIVE {FileInfoBlock} DEF, PROC, OBJECT
NATIVE {FileInfoBlock} OBJECT fileinfoblock
   {fib_DiskKey}	diskkey	:VALUE
   {fib_DirEntryType}	direntrytype	:VALUE  /* Type of Directory. If < 0, then a plain file.
										        * If > 0 a directory */
   {fib_FileName}	filename[108]	:ARRAY OF CHAR /* Null terminated. Max 30 chars used for now */
   {fib_Protection}	protection	:VALUE    /* bit mask of protection, rwxd are 3-0.	   */
   {fib_EntryType}	entrytype	:VALUE
   {fib_Size}		size	:VALUE	     /* Number of bytes in file */
   {fib_NumBlocks}	numblocks	:VALUE     /* Number of blocks in file */
   {fib_Date}		datestamp	:datestamp/* Date file last changed */
   {fib_Comment}	comment[80]	:ARRAY OF CHAR  /* Null terminated comment associated with file */

   /* Note: the following fields are not supported by all filesystems.	*/
   /* They should be initialized to 0 sending an ACTION_EXAMINE packet.	*/
   /* When Examine() is called, these are set to 0 for you.		*/
   /* AllocDosObject() also initializes them to 0.			*/
   {fib_OwnerUID}	owneruid	:UINT		/* owner's UID */
   {fib_OwnerGID}	ownergid	:UINT		/* owner's GID */

   {fib_Reserved}	reserved[32]	:ARRAY OF CHAR
ENDOBJECT /* FileInfoBlock */
