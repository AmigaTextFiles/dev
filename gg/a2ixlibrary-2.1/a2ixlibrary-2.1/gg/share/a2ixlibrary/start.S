/* definitions for the assembler startup file */

#include "a2ixlibrary.h"

/* Library IDs 0-19 can be freely used for private libraries, IDs 20 and up
   are reserved */

	.globl	___a4_offset
	.equ	___a4_offset, (-4 - 4 * LIBRARY_ID)

/* amazingly works, contains only defines ;-)) */
#include <exec/alerts.h>

#define _LVOOpenLibrary		-0x228
#define _LVOCloseLibrary 	-0x19e
#define _LVOAlert		-0x6c
#define _LVOFreeMem		-0xd2
#define _LVORemove		-0xfc

#define RTC_MATCHWORD	0x4afc
#define RTF_AUTOINIT	(1<<7)

#define LIBF_CHANGED	(1<<1)
#define LIBF_SUMUSED	(1<<2)
/* seems there is an assembler bug in expression evaluation here.. */
#define LIBF_CHANGED_SUMUSED 0x6
#define LIBF_DELEXP	(1<<3)
#define LIBB_DELEXP	3

#define LN_TYPE		8
#define LN_NAME		10
#define NT_LIBRARY	9
#define MP_FLAGS	14
#define PA_IGNORE	2

#define LIST_SIZEOF	14

#define THISTASK	276

#define INITBYTE(field,val)	.word 0xe000; .word (field); .byte (val); .byte 0
#define INITWORD(field,val)	.word 0xd000; .word (field); .word (val)
#define INITLONG(field,val)	.word 0xc000; .word (field); .long (val)

/*
 * our library base.. 
 */

/* struct library */
#define	BASE_NODE		0
#define BASE_FLAGS		14
#define BASE_NEGSIZE		16
#define BASE_POSSIZE		18
#define BASE_VERSION		20
#define BASE_REVISION		22
#define BASE_IDSTRING		24
#define BASE_SUM		28
#define BASE_OPENCNT		32
#define BASE_LIBRARY		34	/* size of library */

/* custom part */
#define BASE_MYFLAGS		(BASE_LIBRARY + 0)
#define BASE_COOKIE		(BASE_MYFLAGS + 2)
#define BASE_SEGLIST		(BASE_MYFLAGS + 6)
#define BASE_LIB_ID		(BASE_MYFLAGS + 10)
#define BASE_SIZEOF		(BASE_MYFLAGS + 14)

#define PRIORITY	0

	.text

   | The first executable location.  This should return an error
   | in case someone tried to run you as a program (instead of
   | loading you as a library).
	.globl	Start		| we use this to force inclusion of start.s
	.globl	_SysBase
	.globl	___restore_a4
Start:
   movel   #-1,d0
   rts

|-----------------------------------------------------------------------
| A romtag structure.  Both "exec" and "ramlib" look for
| this structure to discover magic constants about you
| (such as where to start running you from...).
|-----------------------------------------------------------------------

initDDescrip:
              |STRUCTURE RT,0
     .word    RTC_MATCHWORD      | UWORD RT_MATCHWORD
     .long    initDDescrip       | APTR  RT_MATCHTAG
     .long    EndCode            | APTR  RT_ENDSKIP
     .byte    RTF_AUTOINIT       | UBYTE RT_FLAGS
     .byte    VERSION            | UBYTE RT_VERSION
     .byte    NT_LIBRARY         | UBYTE RT_TYPE
     .byte    PRIORITY           | BYTE  RT_PRI
     .long    Name        	 | APTR  RT_NAME
     .long    idString           | APTR  RT_IDSTRING
     .long    Init               | APTR  RT_INIT
| this is just fool proof, and this library will never make it to ROM
| anyway, so resident tags are not that important ;-)
EndCode:


   | this is the name that the library will have
Name:    	.asciz FULLNAME

   | this is an identifier tag to help in supporting the library
   | format is 'name version.revision (dd.mm.yy),<cr>,<lf>,<null>'
   | without any leading zeros in dd.mm.yy
idString:
	.ascii IDSTRING
	.byte  13
	.byte  10
	.byte  0

   | force word alignment
   .even


   | The romtag specified that we were "RTF_AUTOINIT".  This means
   | that the RT_INIT structure member points to one of these
   | tables below.  If the AUTOINIT bit was not set then RT_INIT
   | would point to a routine to run.

Init:
   .long   BASE_SIZEOF		| size of library base data space
   .long   funcTable		| pointer to function initializers
   .long   dataTable            | pointer to data initializers
   .long   initRoutine	        | routine to run


funcTable:

   |------ standard system routines
   .long   Open
   .long   Close
   .long   Expunge
   .long   Null

   |------ These three functions do all the hard work
   .long   ___LibCloseInstance
   .long   ___LibRelocateInstance
   .long   ___LibSetVarsInstance

   |------ function table end marker
   .long   -1

   | The data table initializes static data structures.
   | The format is specified in exec/InitStruct routines
   | manual pages.  The INITBYTE/INITWORD/INITLONG routines
   | are in the file "exec/initializers.i".  The first argument
   | is the offset from the library base for this byte/word/long.
   | The second argument is the value to put in that cell.
   | The table is null terminated
   | NOTE - LN_TYPE below is a correction - old example had LH_TYPE

dataTable:
	INITBYTE (LN_TYPE, 		NT_LIBRARY)
	INITLONG (LN_NAME, 		Name)
	INITBYTE (BASE_FLAGS,	 	0x6) |LIBF_CHANGED_SUMUSED
	INITWORD (BASE_VERSION, 	VERSION)
	INITWORD (BASE_REVISION, 	REVISION)
	INITLONG (BASE_IDSTRING, 	idString)
	.long   0


   | This routine gets called after the library has been allocated.
   | The library pointer is in D0.  The segment list is in A0.
   | If it returns non-zero then the library will be linked into
   | the library list.
initRoutine:

   |------ get the library pointer into a convenient A register
   movel   a5,sp@-
   movel   d0,a5

   |------ save a pointer to our loaded code
   movel   a0,a5@(BASE_SEGLIST)

   |------ Init the magic cookie and the library id
   movel   #0x4a4a5600,a5@(BASE_COOKIE)		| 'JJV\0' = Jacob Johan Verkuil :-)
   movel   #___a4_offset,a5@(BASE_LIB_ID)

   |------ Init SysBase
   movel   4:w,a1
   movel   a1,_SysBase

   movel   sp@+,a5
   rts

|----------------------------------------------------------------------
|
| here begins the system interface commands.  When the user calls
| OpenLibrary/CloseLibrary/RemoveLibrary, this eventually gets translated
| into a call to the following routines (Open/Close/Expunge).  Exec
| has already put our library pointer in A6 for us.  Exec has turned
| off task switching while in these routines (via Forbid/Permit), so
| we should not take too long in them.
|
|----------------------------------------------------------------------


   | Open returns the library pointer in d0 if the open
   | was successful.  If the open failed then null is returned.
   | It might fail if we allocated memory on each open, or
   | if only open application could have the library open
   | at a time...

Open:      | ( libptr:a6, version:d0 )


   |------ mark us as having another opener
   addqw   #1,a6@(BASE_OPENCNT)

   |------ prevent delayed expunges
   bclr    #LIBB_DELEXP,a6@(BASE_FLAGS)

   |------ do other things in C
   pea	   a6@
   jsr	   _lib_open
   addqw   #4,sp
   |--- lib_open() should return the library base, if all ok

   rts

   | There are two different things that might be returned from
   | the Close routine.  If the library is no longer open and
   | there is a delayed expunge then Close should return the
   | segment list (as given to Init).  Otherwise close should
   | return NULL.

Close:      | ( libptr:a6 )

   |------ mark us as having one fewer openers
   subqw   #1,a6@(BASE_OPENCNT)

   |------ see if there is anyone left with us open
   bne     Null

   |------ see if we have a delayed expunge pending
   btst    #LIBB_DELEXP,a6@(BASE_FLAGS)
   bne     Expunge

   | reserved entry

Null:
   moveq   #0,d0
   rts

   | There are two different things that might be returned from
   | the Expunge routine.  If the library is no longer open
   | then Expunge should return the segment list (as given to
   | Init).  Otherwise Expunge should set the delayed expunge
   | flag and return NULL.
   |
   | One other important note: because Expunge is called from
   | the memory allocator, it may NEVER Wait() or otherwise
   | take long time to complete.

Expunge:   | ( libptr: a6 )
   moveml  a2/a5/a6,sp@-
   movel   a6,a5

   |------ assume we cannot expunge
   subal   a2,a2
   bset    #LIBB_DELEXP,a5@(BASE_FLAGS)

   |------ see if anyone has us open
   tstw    a5@(BASE_OPENCNT)
   bne     L21

   |------ go ahead and get rid of us.  Store our seglist in a2
   movel   a5@(BASE_SEGLIST),a2
   movel   4:w,a6

   |------ unlink from library list
   movel   a5,a1
   jsr	   a6@(_LVORemove)

   |------ free our memory
   movel   a5,a1
   moveq   #0,d0
   movew   a5@(BASE_NEGSIZE),d0
   subl    d0,a1
   addw    a5@(BASE_POSSIZE),d0
   jsr	   a6@(_LVOFreeMem)

L21:       |------ set up our return value
   movel   a2,d0

   moveml  sp@+,a2/a5/a6
   rts

___restore_a4:
   movel   _SysBase,a4
   movel   a4@(0x114),a4
   movel   a4@(0x2e),a4
   movel   a4@(___a4_offset),a4
   rts

.data
_SysBase:
	.long 0
