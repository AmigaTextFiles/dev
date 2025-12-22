
#define SHARABLE    0x0001  /*	shareable			*/
#define GLOBAL	    0x0002  /*	global access			*/
#define NAMED	    0x0004  /*	if shared, can access by name	*/
#define SWAPABLE    0x0008  /*	swap enabled			*/
#define LOCKED	    0x0010  /*	locked into mem 		*/

#define SWAPPED     0x0100  /*	swapped to disk */
#define SLOCKED     0x0200  /*	temporary lock	*/

#define HAVHANDLE   0x0400  /*	have a filehndl */
#define HAVLOCK     0x0800  /*	have a filelock */

#define RESMLNAME   "DRES"  /*  MemList node name   */

