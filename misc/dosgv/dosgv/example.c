/*
 * 5/2018 -=ONIX=-
 * Just an example where I use GV functions of AmigaDOS 1.2/1.3 (based on
 * Tripos for other architectures; does it?).
 * NOTE: It is not recommended to run this unter OS2 or better!!!
 * :ts=4
 *
 * NOTE: g_ioerror, g_examine, g_exnext and g_currentdir do not exist under OS2+
 *		 or later, use there the official AmigaDOS API functions or create a
 *		 local GV with these functions.
 *
 * Because all startup-codes I tested override pr_CIS (exception, that one of
 * MaxonC++/HiSoftC++), which in turn is essential for g_rdargs, I have to work
 * without any startup-code, thus the first code fragment that must be executed
 * is startup()!
 *
 * Note that strings must be layed out so they start at a multiple by four
 * address; the only compiler I know of that ensures this is vbcc. If you are
 * using an other compiler, either define the strings via assembler or copy
 * them within the user stack to a four divisible address.
 */

#include <exec/execbase.h>
#include <exec/libraries.h>
#include <exec/memory.h>

#include <proto/exec.h>
#include <proto/dos.h>

#ifdef APTR_TYPEDEF
  #include <dos/dosextens.h>
#else
  #include <libraries/dosextens.h>
#endif

#include "gvo.h"

#include <string.h>

/* Two globals..., the code itself is reentrant but not the strings and the GV! */
struct ExecBase *SysBase;
struct DosLibrary *DOSBase;

/* DOS file names look like this... */
struct Filename {
	char fn_name[108];	/* Note that max 107 characters in width file names can
						   be handled by the DOS (due to length or NUL byte)
						   but the DOS does support only file names no longer
						   than 30 characters, because the copy routine to copy
						   file names just copies 31 bytes - see function 0x6B */
};

/* Bcause BCPL addresses long words, everywhere you see ">> 2" it means amount
   bytes into analogue amount long words */
#define STACKFRAME_SIZE	(368L >> 2L)		/* Min 364 bytes, see notes on g_rdargs */
#define RESULTARRAY_SIZE (656L >> 2L)		/* For 80 keywords, it is the default,
											   although OS1.2 DOS commands only
											   specified 340, what in turn can lead
											   to a buffer overrun */

struct BCPL_Stack {
	LONG	stack_frame[STACKFRAME_SIZE];
	LONG	result_array[RESULTARRAY_SIZE];
};

#define MIN_OFFSET_STACKFRAME	(12L)	/* Minimum size that guarants that the
										   program flow can be restored and
										   that BCPL (Tripos) functions can be
										   launched; remembered in the very
										   first 3 long words of callee's
										   provided stack frame.
										   It's the default being used for any
										   DosGV() call. */

/*
 * Please ensure that all defined strings start at least at a four divisible
 * address, because BCPL (OS1.2 DOS was written in BCPL) can only address each
 * fourth memory cell. Luckily, vbcc aligns strings to long word boundaries!
 */

/* Due to bugs in BSTR handling in OS2+, we need additional bytes in the C strings */
char WString1[] = "WARNING: You are about to use Global Vector functions\0";
char WString2[] = "for an operating system where the Tripos based\0";
char WString3[] = "Global Vector was replaced by API functions!\0";

char CurrentDrawer[] = "\0";	/* Stunt? AmigaDOS "" - means current dir */

/* Supported place holders: %S(tring), %T(ime) struct, %N(umber), %C(har)
   %I(nteger)[length], %O(ctal)[length], %X(hexadecimal)[length] */
char DrawerStr[] = "%S (dir)\n";
char FileStr[] = "%S";
static char FileLenStr[] = "%I5 %S\n";
char BytesStr[] = "\0";			/* Empty string; string is not displayed  */
char KBytesStr[] = "Kb";
char MBytesStr[] = "Mb";
char PadStr[] = " ";
char EmptyStr[] = "<empty>\n";
char BreakStr[] = "***BREAK\n";

/* The template for g_readarg as C-string */
char TemplateStr[] = "DIR,DIRS/S,FILES/S,ALL/S";

#define NESTED_F	(1)		/* ALL was supplied */
#define FILES_F		(2)		/* FILES was supplied */
#define DRAWERS_F	(4)		/* DIRS was supplied */

/* Prototypes */
int main(void);		/* Our main function */
void geta4();		/* Function to set up small data register (A4) */


/* ####################################################################### */
/*
 * ! ! ! ! VERY, VERY IMPORTANT ! ! ! !
 *
 * Must be the first code that the DOS executes!!!
 *
 */
int startup()
{
	/* Important; base register must be fetched before any action takes place! */
	geta4();		/* Set up register A4 */
	return main();	/* Call our main()! */
}
/* Up from here it is now safe to implement own routines */
/* ####################################################################### */



/* Modify a given C string, i.e. remove the trailing byte (NUL-byte) and instead
   set a leading byte representing string's length.
   Because removing a byte and adding a byte results in same string lengths,
   just copy from position zero to position one the entire string, including
   overriding the NUL-byte, and fill the gap (position zero) with the length.
 */
char * MakeBStr( char *str)
{
	unsigned int len = strlen( str);
	char *d, *s;

	/* Descending copy - otherwise we override yet not copied chars */
	for (d = str + len, s = d - 1; s >= str; *d-- = *s--)
		;	/* Copied from s[n] to s[n + 1] */
	*str = (char) len;
	return str;
}

/* Counter part */
char * MakeCStr( BSTR bstr)
{
	char *str = (char *) BADDR( bstr );
	unsigned int len = (unsigned char) *str;	/* Do not sign-extent length! */
	char *s, *d, *stop = str + len;

	for (d = str, s = d + 1; d < stop; *d++ = *s++)
		;
	*d = '\0';	/* Trailing NUL-byte */
	return str;
}

/* Allocate and release memory */
#undef MEMF_CLEAR
#define MEMF_CLEAR (65536L)	/* If an int is 16 bit, compilers cannot handle 1 << 16 correctly; result = 0! */

/* I could use the function to allocate memory provided by OS1.2 DOS, but it
   takes number of long words to allocate and returns a BPTR, hence, for easier
   handling, I am using that one of Exec instead */ 
void * Alloc( ULONG bytesize)
{
	ULONG *ptr;
	ULONG newsize;
	
	newsize = (bytesize + sizeof(ULONG) + 7) & -8;

	ptr = AllocMem( newsize, MEMF_PUBLIC|MEMF_CLEAR);
	if (ptr)
		*ptr++ = newsize;
	return ptr;
}

void Free( void * memory)
{
	ULONG *ptr;

	if (memory)
	{
		ptr = (ULONG *) memory;
		ptr--;
		FreeMem( ptr, *ptr);
	}
}

/*
 * Directory lister
 * Ensure that the lock supplied is bound to a volume or drawer!!!
 * flags: NESTED_F (recursively scan),
 *		  DRAWERS_F (show only drawers),
 *		  FILES_F (show only files)
 */
LONG ShowContents( LONG *stackframe,
				   BPTR lockeddir,
				   struct FileInfoBlock *fib,
				   struct Filename *name,
				   LONG flags,
				   LONG *level)
{
	LONG size, error;
	BOOL success;
	BPTR lock, nextlock, parentdir;
	char *ext;
	struct FileInfoBlock *nfib;

	lock = lockeddir;
	error = RETURN_OK;
	*level += 1;

	/* CD into provided directory */
	if (DOSBase->dl_lib.lib_Version > 35)
		parentdir = CurrentDir( lock);
	else
		parentdir = DosGV( stackframe,
						   g_currentdir,
						   lock );

	/* Get information about volume or drawer */
	if (DOSBase->dl_lib.lib_Version > 35)
		success = Examine( lock, fib);
	else
		success = DosGV( stackframe,
						 g_examine,
						 lock,
						 fib );	/* Inconsistent: APTR instead of BPTR */
	if (success)
	{
		if ( !(flags & FILES_F) )
		{
			/* Copy string and convert it into a BCPL string */
			strcpy( name->fn_name, fib->fib_FileName);
			MakeBStr( name->fn_name);

			/* Pad next output to indent with 'level' minus one */
			if (*level > 1)
			{
				DosGV( stackframe,
					   g_writepad,
					   MKBADDR( PadStr ),
					   (*level - 1) << 1 );	/* level * 2 */
			}
			/* Display initial volume/drawer name */
			DosGV( stackframe,
				   g_writef,
				   MKBADDR( DrawerStr ),
				   MKBADDR( name ) );
		}

		/* Next entry, either file or drawer */
		if (DOSBase->dl_lib.lib_Version > 35)
			success = ExNext( lock, fib);
		else
			success = DosGV( stackframe,
							 g_exnext,
							 lock,
							 fib );	/* Inconsistent: APTR instead of BPTR */

		if (!success)	/* g_exnext failed and most likely, it's because of */
		{				/* an empty drawer; I could verify that with g_ioerror */
			if ( !(flags & FILES_F) )	/* but I am too lazy */
			{
				/* Pad next output to indent with 'level' plus one */
				DosGV( stackframe,
					   g_writepad,
					   MKBADDR( PadStr ),
					   (*level + 1) << 1 );	/* level * 2 */

				DosGV( stackframe,
					   g_writes,
					   MKBADDR( EmptyStr ) );
			}
		}

		while (success)
		{
			strcpy( name->fn_name, fib->fib_FileName);
			MakeBStr( name->fn_name);

			/* From C it is more common to use the native Exec function than it
			   Tripos based equivalent
			if (SetSignal( 0, 0) & SIGBREAKF_CTRL_C) instead of: */
			if ( (DosGV( stackframe,
						 g_break,
						 g_flag_break)) )	/* Return if CTRL-C was pressed by user */
			{
				DosGV( stackframe,
					   g_writes,
					   MKBADDR( BreakStr ) );
				error = RETURN_FAIL;	/* 20; 304 (ASL break) wasn't defined back then! */
				break;
			}

			/* File? */
			if (fib->fib_DirEntryType < 0)
			{
				if ( !(flags & DRAWERS_F) )
				{
					/* Depending on the size, use bytes, kbytes, mbytes as extension */
					size = fib->fib_Size;
					if (size < 100000)
					{
						ext = BytesStr;
					}
					else if (size < 1048576)
					{
						size = DosGV( stackframe,
									  g_div,
									  size,
									  (LONG) 1024 );	/* Divisor */
						ext = KBytesStr;
					}
					else
					{
						size = DosGV( stackframe,
									  g_div,
									  size,
									  (LONG) 1048576 ); /* Divisor */
						ext = MBytesStr;
					}

					/* Pad next output to indent file name according to 'level' */
					DosGV( stackframe,
						   g_writepad,
						   MKBADDR( PadStr ),
						   *level << 1 );	/* level * 2 */
					/* Print file name */
					DosGV( stackframe,
						   g_writef,
						   MKBADDR( FileStr ),
						   MKBADDR( name ) );

					/* Here I have to cast the first byte of Filename because
					   it represent the lead-byte, which is unsigned and thus
					   in range from 0 to 255 although it will never exceed
					   the 30 character barrier... */
					if (34L - ((unsigned char) name->fn_name[0]) - (*level << 1) > 0L)
					{
						/* Pad output so sizes are displayed at position 34 */
						DosGV( stackframe,
							   g_writepad,
							   MKBADDR( PadStr ),
							   	/* 34 minus... */
							   34L - ((unsigned char) name->fn_name[0]) - (*level << 1) );
					}
					else	/* Didn't turn out well, column 34 used by file name */
					{
						/* Pad output so values are displayed two chars behind name */
						DosGV( stackframe,
							   g_writepad,
							   MKBADDR( PadStr ),
							   2L );
					}
					/* Print size */
					DosGV( stackframe,
						   g_writef,
						   MKBADDR( FileLenStr ),
						   size,
						   MKBADDR( ext ) );
				}
			}
			else	/* Drawer */
			{
				/* Dive into new directory? */
				if (flags & NESTED_F)
				{
					nextlock = DosGV( stackframe,
									  g_lock,
									  MKBADDR( name ),
									  (LONG) ACCESS_READ );

					if (nextlock != DOSFALSE)
					{
						/* Each new sub drawer requires its own FIB! */
						if ( (nfib = (struct FileInfoBlock *)
							 Alloc( sizeof(struct FileInfoBlock))) )
						{
							/* Watch out: recursive call! - eats stack! */
							error = ShowContents( stackframe, nextlock, nfib,
												  name, flags, level);
							Free( nfib);
						}
						/* Unlock volume/drawer */
						DosGV( stackframe,
							   g_unlock,
							   nextlock );
						if (error != RETURN_OK)
							break;
					}
					else
					{
						error = DosGV( stackframe,
									   g_ioerror );
						DosGV( stackframe,
							   g_res2,
							   g_flag_set,	/* Set error code */
							   error );
						/* Output error as plain text onto console */
						DosGV( stackframe,
							   g_fault,
							   error );
					}
				}
				else	/* Just display drawer name */
				{
					if ( !(flags & FILES_F) )
					{
						/* Pad next output to indent file name according to 'level' */
						DosGV( stackframe,
							   g_writepad,
							   MKBADDR( PadStr ),
							   *level << 1 );	/* level * 2 */
						/* Display drawer name only */
						DosGV( stackframe,
							   g_writef,
							   MKBADDR( DrawerStr ),
							   MKBADDR( name ) );
					}
				}
			}

			/* Next entry, either file or drawer */
			if (DOSBase->dl_lib.lib_Version > 35)
				success = ExNext( lock, fib);
			else
				success = DosGV( stackframe,
								 g_exnext,
								 lock,
								 fib );	/* Inconsistent: APTR instead of BPTR */
		}
	}
	else
	{
		/* Get the last occurred error */
		if (DOSBase->dl_lib.lib_Version > 35)
			error = IoErr();
		else
			error = DosGV( stackframe,
						   g_ioerror );
		/* Output error as plain text onto console */
		DosGV( stackframe,
			   g_fault,
			   error );
	}

	/* CD back to parent directory */
	if (DOSBase->dl_lib.lib_Version > 35)
		CurrentDir( parentdir);
	else
		DosGV( stackframe,
			   g_currentdir,
			   parentdir );

	*level -= 1;

	return error;
}

/* NOTE: We don't use any provided startup-code because they trash pr_CIS,
   what in turn prevents using g_rdargs.
   The ALIGNLONG macro is essential because we need long word aligned addresses
   for structures and because I am using a version of vbcc that uses per default
   16 bit values, the stack is only word but not long word aligned!
   PLEASE: Keep an eye on the stack usage; we only have about 4 kbytes and
   already using here about 1.4 kb! */
int main( void)
{
	ALIGNLONG( struct BCPL_Stack, bcplstack);	/* 1024 bytes by accident, aligned at LW boundary */
	LONG *stackframe, *resultarray;
	ALIGNLONG( struct FileInfoBlock, fib);
	ALIGNLONG( struct Filename, name);		/* Just 108 bytes more, but just 30 used... */
	LONG error, success, flags, level;
	BPTR lock;

	/* Important, get pointer to Exec library */
	SysBase = *((struct ExecBase **) 4);

	error = ERROR_INVALID_RESIDENT_LIBRARY;

	if ( (DOSBase = (struct DosLibrary *) OpenLibrary( DOSNAME, 33)) )
	{
 		stackframe = (LONG *) bcplstack;			/* BCPL stack frame */
		resultarray = &stackframe[STACKFRAME_SIZE];	/* g_rdargs' result array */
 		lock = DOSFALSE;	/* DOSFALSE = 0 */
 		error = RETURN_OK;	/* RETURN_OK = 0 */
		success = 1;
		level = 0;
		flags = 0;

		/* If OS2+, display requester and ask user if he wishes to continue */
		if (DOSBase->dl_lib.lib_Version > 35)
			success =
			DosGV(  stackframe,
					g_sysrequest,
					MKBADDR( MakeBStr( WString1) ),
					MKBADDR( MakeBStr( WString2) ),
					MKBADDR( MakeBStr( WString3) ) );

		/* Parse arguments provided on the command line (buffered in pr_CIS) */
		if (success)
		{
			/* Note that you don't have to clear the resulting array's long
			   words, if a keyword isn't specified by the user, the associated
			   long word in the resulting array is cleared by g_rdargs */
			success = DosGV( stackframe,
							 g_rdargs,
							 MKBADDR( MakeBStr( TemplateStr) ),
							 MKBADDR( resultarray ),
							 80L );
			if (success == DOSFALSE)	/* Returns BOOL, 0 = error */
			{
				/* Get the last occurred error */
				if (DOSBase->dl_lib.lib_Version > 35)
					error = IoErr();
				else
					error = DosGV( stackframe,
								   g_ioerror );

				/* Print current error as plain text onto console */
				DosGV( stackframe,
					   g_fault,
					   error );
			}
			else
			{
				if (resultarray[1] != DOSFALSE)
					flags |= DRAWERS_F;
				if (resultarray[2] != DOSFALSE)
					flags |= FILES_F;
				if (resultarray[3] != DOSFALSE)
					flags |= NESTED_F;
			}
		}
		else	/* User said quit (OS2+) */
		{
			error = ERROR_INVALID_RESIDENT_LIBRARY;	/* This time, too high number :-) */
		}

		/* If no error, continue */
		if (error == RETURN_OK)
		{
			/* resultarray[0] points to BSTR 'DIR' */
			if (resultarray[0] && !error)
			{
				lock = DosGV( stackframe,
							  g_lock,
							  resultarray[0],
							  (LONG) ACCESS_READ );
			}
			else
			{
				lock = DosGV( stackframe,
							  g_lock,
							  MKBADDR( MakeBStr( CurrentDrawer) ),	/* AmigaDOS "" :-) */
					 		  (LONG) ACCESS_READ );
			}

			/* Check if g_lock failed */
			if (lock != DOSFALSE)	/* Remember, DOSFALSE = 0L */
			{
				/* Convert the C strings into B(CPL) strings */
				MakeBStr( FileStr);
				MakeBStr( FileLenStr);
				MakeBStr( DrawerStr);
				MakeBStr( PadStr);
				MakeBStr( BytesStr);
				MakeBStr( KBytesStr);
				MakeBStr( MBytesStr);
				MakeBStr( EmptyStr);
				MakeBStr( BreakStr);

				/* Get volume/drawer/file information */
				if (DOSBase->dl_lib.lib_Version > 35)
					success = Examine( lock, fib);
				else
					success = DosGV( stackframe,
									 g_examine,
									 lock,
									 fib );	/* Inconsistent: APTR instead of BPTR */

				/* In addition to inaccessible locks, we have to ensure that this
				   lock fits to volumes or drawers only */
				if (success && fib->fib_DirEntryType >= 0)
				{
					error = ShowContents( stackframe, lock, fib, name, flags, &level);
					/* Unlock volume/drawer */
					DosGV( stackframe,
						   g_unlock,
						   lock );
				}
				else	/* Initial lock zero or not a volume/drawer? */
				{
					if (lock == DOSFALSE)
					{
						/* Get the last occurred error */
						if (DOSBase->dl_lib.lib_Version > 35)
							error = IoErr();
						else
							error = DosGV( stackframe,
										   g_ioerror );

						/* Output error as plain text onto console */
						DosGV( stackframe,
							   g_fault,
							   error );
					}
					else
					{
						/* 'lock' there but it isn't a volume/drawer.
						   Unlock file */
						DosGV( stackframe,
							   g_unlock,
							   lock );
						/* Set pr_Result2 */
						error = ERROR_OBJECT_WRONG_TYPE;
						DosGV( stackframe,
							   g_res2,
							   g_flag_set,
							   error );
						/* Output error as plain text onto console */
						DosGV( stackframe,
							   g_fault,
							   error );
					}
				}
			}
			else
			{
				/* Get the last occurred error; lock could not obtained */
				if (DOSBase->dl_lib.lib_Version > 35)
					error = IoErr();
				else
					error = DosGV( stackframe,
								   g_ioerror );
				/* Output error as plain text onto console */
				DosGV( stackframe,
					   g_fault,
					   error );
			}
		}
		CloseLibrary( &DOSBase->dl_lib);
	}

	if (error)
		error = RETURN_FAIL;
	return (int) error;	
}
