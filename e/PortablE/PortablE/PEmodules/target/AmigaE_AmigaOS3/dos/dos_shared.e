OPT NATIVE
MODULE 'target/exec/types'

->NATIVE {datestamp} DEF, PROC, OBJECT
NATIVE {datestamp} OBJECT datestamp
   {days}	days	:VALUE	      /* Number of days since Jan. 1, 1978 */
   {minute}	minute	:VALUE	      /* Number of minutes past midnight */
   {tick}	tick	:VALUE	      /* Number of ticks past minute */
ENDOBJECT /* DateStamp */

->NATIVE {fileinfoblock} DEF, PROC, OBJECT
NATIVE {fileinfoblock} OBJECT fileinfoblock
   {diskkey}	diskkey	:VALUE
   {direntrytype}	direntrytype	:VALUE  /* Type of Directory. If < 0, then a plain file.
										        * If > 0 a directory */
   {filename}	filename[108]	:ARRAY OF CHAR /* Null terminated. Max 30 chars used for now */
   {protection}	protection	:VALUE    /* bit mask of protection, rwxd are 3-0.	   */
   {entrytype}	entrytype	:VALUE
   {size}		size	:VALUE	     /* Number of bytes in file */
   {numblocks}	numblocks	:VALUE     /* Number of blocks in file */
   {datestamp}		datestamp	:datestamp/* Date file last changed */
   {comment}	comment[80]	:ARRAY OF CHAR  /* Null terminated comment associated with file */

   {owneruid}	owneruid	:UINT		/* owner's UID */
   {ownergid}	ownergid	:UINT		/* owner's GID */

   {reserved}	reserved[32]	:ARRAY OF CHAR
ENDOBJECT /* FileInfoBlock */
