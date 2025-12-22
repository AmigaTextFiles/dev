/*
	Detour.c

	Object file basing on this source-code is for the Maxon, HiSoft and eventually Storm (up to V3)
	compilers.
	When encountering compiler errors about unreferenced symbols it is very likely that the
	function which is unknown stays in a pragma-file and this pragma-file isn't understood
	by the above stated compiler - respectively is for this compiler empty.
	This occurs often when the original source-code was built for the SAS/C or GNU-C compiler.

	Detour does now nothing else than to rename the original NDK pragmas to "..._old" and creates
	a file - with only one line that says that the required file can be found at an other loaction.

	Usage:
	If you don't know what's going on, you can simply call Detour as follow:
		1> detour work:mcpp4.0/amiga/c-inc/pragmas			(as an example)
	Detour will examine this specified directory accordingly for non-compliant pragmas
	(from Maxon, HiSoft compiler point of view) and displays what it would do when calling in real.
	NOTE: No modification will be made at this stage of invoking.

	In order to let the modifications take place, you have to call it like this:
		1> detour work:mcpp4.0/amiga/c-inc/pragmas real
	The "real" statement forces Detour to rename the standard- and to create new pragma-files in this
	directory.

	You can undo the made modifcations by calling Detour so:
		1> detour work:mcpp4.0/amiga/c-inc/pragmas real revert

	In this case (after changes have been applied) all will be put back to original state.


	Detour
	Written 2003 ONIX

	Public Domain

	All use is at your own risk.

	Oh, by the way, Detour requires OS 2
*/

#ifdef __GNUC__
 #define ASM
 #define REG(reg,arg) arg __asm(#reg)
#else
 #if !defined (__MAXON__) 
  #if !defined (__STORM__)
   #define ASM __asm
  #else
   #define ASM
  #endif
 #endif
 #define REG(reg,arg) register __##reg arg
#endif

#ifdef __MAXON__
 extern "C" void GetBaseReg( void);
 #define __saveds
 #define ASM
#endif

#if defined(__MAXON__) || defined(__STORM__)
  #define __inline
  #define __stdargs
#endif


#include <exec/execbase.h>
#include <exec/memory.h>

#include <clib/exec_protos.h>

#include <dos/dosextens.h>
#include <dos/dos.h>

#include <clib/dos_protos.h>

// #include <stdio.h>
// #include <string.h>

#if defined (__MAXON__) || defined (__STORM__)
#include <pragma/exec_lib.h>
#include <pragma/dos_lib.h>
#else
#include <pragmas/exec_pragmas.h>
#include <pragmas/exec_pragmas.h>
#endif

/* The contents of the include file going to be created */
#define Intro (TEXT *) "/*\n\tThis include file redirects the access from file %s\n"\
					"\tto %s\n\n\tThis is only useful for the Maxon/HiSoft compilers!\n*/\n\n"\
					"#include <pragma/%s>\n"

struct ExecBase *SysBase;
struct DosLibrary *DOSBase;

int _cli_parse( unsigned long, register unsigned char *);
int main( int, char **);


int ASM __saveds _start_up( REG(d0,unsigned long parlen), REG(a0,unsigned char *parameter) )
{
	int err;

	#ifdef __MAXON__		// Since MaxonC/C++ does not understand __saveds
	GetBaseReg();
	#endif

	SysBase = *((struct ExecBase **) 4);	// From memory location 4 to exec library

	err = ((struct Process *) FindTask( NULL))->pr_Result2 = _cli_parse( parlen, parameter);

	return err;						// Return code (for CLI), in case detach was a success!
}

int strlen( const char *str)
{
	register unsigned int i = 0;

	while (*str++)
		i++;
	return i;
}

char *strncpy( char *ds, const char *ss, int is)
{
	register char *d, *s;
	register int i;

	d = ds;
	s = (char *) ss;
	i = is;

	while (i)
	{
		*d++ = *s++;
		i--;
	}
	*d = 0;

	return ds;
}

char *strcpy( char *ds, const char *ss)
{
	register char *d, *s;

	d = ds;
	s = (char *) ss;

	while (*s)
		*d++ = *s++;
	*d = 0;

	return ds;
}

char *strcat( char *ds, const char *ss)
{
	register char *d, *s;

	d = ds;
	s = (char *) ss;

	while (*d)
		d++;
	
	while( *s)
		*d++ = *s++;
	*d = 0;

	return ds;
}

char *strncat( char *ds, const char *ss, int is)
{
	register char *d, *s;
	register int i;

	d = ds;
	s = (char *) ss;
	i = is;

	while (*d)
		d++;
	
	while( i)
	{
		*d++ = *s++;
		i--;
	}
	*d = 0;

	return ds;
}

int strncmp( const char *d, const char *s, int i)
{
	while( i)
	{
		if (*d++ != *s++)
			break;
		i--;
	}

	if ( i)
	{
		if ( (unsigned char) *d < (unsigned char) *s)
			i = -1;
		else
			i = 1;
	}

	return i;
}

int stricmp( const char *d, const char *s)
{
	register unsigned char cd, cs;
	int res;

	while(*d && *s)
	{
		cd = (unsigned char) *d++;
		cs = (unsigned char) *s++;

		if (cd >= 'a' && cd <= 'z')
		{
			cd -= 32;	// Upper case
		}
		else
		{
			if (cd >= 224 && cd <= 254)
				cd -= 32;	// Upper case
		}

		if (cs >= 'a' && cs <= 'z')
		{
			cs -= 32;	// Upper case
		}
		else
		{
			if (cs >= 224 && cs <= 254)
				cs -= 32;	// Upper case
		}

		if (cd != cs)
			break;
	}

	if (!*d && !*s)
	{
		res = 0;
	}
	else
	{
		if ( (unsigned char) *d < (unsigned char) *s)
			res = -1;
		else
			res = 1;
	}

	return res;
}

#if defined(__MAXON__)
void funny_code( register __a3 volatile char *buf, register __d0 volatile char c)
{
	*buf++ = c;	// move.b d0,(a3)+
}				// rts
#else
unsigned short funny_code[] =
{
	0x16c0,
	0x4e75
};
#endif

#define FUNC (void (*)()) &funny_code

int sprintf( char *d, const char *f, ...)
{
	char *a;

	(char *) a = (char *) &d;			// Address format string on stack
	a += 8;								// Address 1st additional argument
	RawDoFmt( f, a, FUNC, d);

	return 0;
}

int _cli_parse( unsigned long alen, register unsigned char *aptr)
{
	register unsigned char *cp;
	register struct CommandLineInterface *cli;
	register unsigned char c;
	struct Process *pp;
	unsigned int argc, arg_len, err;
	unsigned char **argv, *arg_lin;

	if ((DOSBase = (struct DosLibrary *) OpenLibrary( "dos.library", 36)) )
	{
		pp = (struct Process *) FindTask( NULL);

		cli = (struct CommandLineInterface *) BADDR( pp->pr_CLI );
		cp = (unsigned char *) BADDR( cli->cli_CommandName );

		arg_len = (unsigned char) cp[0] + alen + 2;

		if ( (arg_lin = (unsigned char *) AllocMem( ((arg_len + 7) & -8), MEMF_CLEAR ) ) == 0)
			return ERROR_NO_FREE_STORE;

		c = cp[0];
		strncpy( arg_lin, cp + 1, c);
		arg_lin[c] = ' ';
		arg_lin[c + 1] = 0;
		strncat( arg_lin, aptr, alen);
		arg_lin[c] = 0;

		for (argc = 1, aptr = cp = arg_lin + c + 1; ; argc++)
		{
			while ( (c = *cp) == ' ' || c == '\t' || c == '\f' || c == '\r' || c == '\n')
				cp++;
			if (*cp < ' ')
				break;
			if (*cp == '"')
			{
				cp++;
				while ( (c = *cp++) )
				{
					*aptr++ = c;
					if (c == '"')
					{
						if (*cp == '"')
						{
							cp++;
						}
						else
						{
							aptr[-1] = 0;
							break;
						}
					}
				}
			}
			else
			{
				while ( (c = *cp++) && c != ' ' && c != '\t' && c != '\f' && c != '\r' && c != '\n')
					*aptr++ = c;
				*aptr++ = 0;
			}
			if (c == 0)
				--cp;
		}

		*aptr = 0;
		if ( (argv = (unsigned char **) AllocMem( (((argc + 1) * 4 + 7) & -8 ), MEMF_CLEAR ) ) == 0 )
		{
			argc = 0;
			return ERROR_NO_FREE_STORE;
		}

		for (c=0, cp=arg_lin; c < argc; c++)
		{
			argv[c] = cp;
			cp += strlen( cp) + 1;
		}

		argv[c] = 0;

		err = main( argc, (char **) argv);
		CloseLibrary( (struct Library *) DOSBase);
		FreeMem( argv, (((argc + 1) * 4 + 7) & -8) );
		FreeMem( arg_lin, ((arg_len + 7) & -8) );

		return err;
	}
	return ERROR_INVALID_RESIDENT_LIBRARY;
}

/*
	Detour - to rename the original pragmas file and to store a new one with the contents of above.
	lock - lock to the directory
	fib  - the File Info Block
	dir	 - name of the directory
	flags: 1 = install/create in real, 2 = undo the previously done installation

 NOTE: Although we could access the files only by calling them on their names (changed current dir
	   in main(), we set up their names with leading directory name.
*/

ULONG Detour( BPTR lock, struct FileInfoBlock *fib, STRPTR dir, ULONG flags)
{
	ULONG dirNameLen, len, args[3], *arg, amount, counter, allowed;
	BPTR newlock, handle;
	TEXT *strBuf, *stdname, *newname, *fullname, *renamed;

	// How many files encountered?
	amount = 0;
	// How many files modified?
	counter = 0;
	// How many files allowed to modify?
	allowed = 0;

	/*
		strBuf = 3072 bytes
		stdname = 128 bytes
		newname = 128 bytes
		fullname = 1024 bytes
		renamed = 1024 bytes
	*/
	if ( (strBuf = (TEXT *) AllocVec( 5376, MEMF_CLEAR)) )
	{
		// Compute buffers addresses
		stdname = strBuf + 3072;
		newname = stdname + 128;
		fullname = newname + 128;
		renamed = fullname + 1024;

		// Copy directory name into buffer
		strcpy( fullname, dir);
		// ... and remember position of zero byte (termination)
		dirNameLen = strlen( fullname);

		// Figure out if a trailing has been already set
		if (fullname[dirNameLen - 1] != ':' && fullname[dirNameLen - 1] != '/')
		{
			// No trailing, so add one
			fullname[dirNameLen] = '/';
			dirNameLen ++;
		}

		// Pointer to arguments
		arg = &args[0];
	
		// Continue as long as a file can be modified
		while ( (newlock = ExNext( lock, fib)) )
		{
			// Check if it is a file
			if (fib->fib_DirEntryType < 0)
			{
				// Copy file's name into buffer
				strcpy( stdname, fib->fib_FileName);
				// ...and get name's length
				len = strlen( stdname);

				// Ensure that it is a valid include file "xxx.h"
				if (len > 11 && stdname[len - 1] == 'h' && stdname[len - 2] == '.')
				{
					// Ensure that it is a original pragmas file
					if ( !strncmp( &stdname[len - 9], "pragmas.h", 9))
					{
						// One more file encountered
						amount ++;
						// Restore directory name (without filename)
						fullname[dirNameLen] = 0;
						// Append standard filename (e.g. "icon_pragmas.h")
						strcat(fullname, stdname);

						/* !!! Terminations required due to a bug in these link-library functions !!!
						Copy old name without "pragmas.h" to new location - in order to add
						"lib.h" (e.g. "icon_pragmas.h" -> "icon_" -> "icon_lib.h") */
						strncpy( newname, stdname, len - 9);
						newname[len - 9] = 0;
						strcat( newname, "lib.h");
						newname[len - 4] = 0;

						// Copy directory name inclusive filename into "renamed" buffer
						strcpy(renamed, fullname);
						// ...and append "_old" to this directory & filename
						strcat(renamed, "_old");

						// Set up (create include file)
						sprintf( strBuf, Intro, stdname, newname, newname);


						// Ensure that it is a standard file (file size must be greater than 256 bytes)
						if (fib->fib_Size > 256)
						{
							// flags == 0 (no install for real, no revert last action)
							if ( !(flags & 1) && !(flags & 2))
							{
								// This file allowed to convert...
								allowed ++;

								args[0] = (ULONG) fullname;
								args[1] = (ULONG) renamed;
								VFPrintf( Output(), "Renaming \"%s\" to \"%s\"\n", arg);

								args[0] = (ULONG) &fib->fib_FileName[0];
								VFPrintf( Output(), "Going to create new file: \"%s\"\n", arg);

								args[0] = (ULONG) strBuf;
								VFPrintf( Output(), "Writing this contents:\n%s\n\n", arg);
							}

							// flags == 1 (install for real but do not revert last action)
							if ((flags & 1) && !(flags & 2))
							{
								// This file allowed to convert...
								allowed ++;

								// Rename e.g. "icon_pragmas.h" to "icon_pragmas.h_old"
								if ( (Rename( fullname, renamed)) )
								{
									// Create new file e.g. "icon_pragmas.h"
									if ( (handle = Open( fullname, MODE_NEWFILE)) )
									{
										// Write contents of strBuf to new file
										if ( (Write( handle, strBuf, strlen( strBuf))) == -1)
										{
											// Error: file could not be written
											args[0] = (ULONG) fullname;
											VFPrintf( Output(), "Error while writing file \"%s\"!", arg);
										}
										else
										{
											// Gotcha, one more file diverted from original
											counter ++;
										}
										Close( handle);
									}
								}
							}
						}

						// Ensure that it is not an already converted file (file size must be smaller than 256 bytes)
						if (fib->fib_Size < 256)
						{
							// flags == 2 (no install for real but undo divert)
							if ( !(flags & 1) && (flags & 2))
							{
								// This file allowed to convert...
								allowed ++;

								args[0] = (ULONG) fullname;
								args[1] = (ULONG) renamed;
								args[2] = (ULONG) fullname;
								VFPrintf( Output(), "Deleting \"%s\" and renaming:\n\"%s\" to \"%s\"\n\n", arg);
							}

							// flags == 3 (install for real and undo divert)
							if ((flags & 1) && (flags & 2))
							{
								// This file allowed to convert...
								allowed ++;

								// Delete e.g. "icon_pragmas.h"
								if ( (DeleteFile( fullname)) )
								{
									// Rename e.g. "icon_pragmas.h_old" to "icon_pragmas.h"
									if ( (Rename( renamed, fullname)) )
									{
										// Got luck, could revert it
										counter ++;
									}
									else
									{
										// Bad luck, could not rename original pragmas file
										args[0] = (ULONG) renamed;
										args[1] = (ULONG) fullname;
										VFPrintf( Output(), "Cannot rename pragma-file \"%s\"!", arg);
									}
								}
								else
								{
									// Bad luck, could not delete previously created pragmas file (diverted)
									args[0] = (ULONG) fullname;
									VFPrintf( Output(), "Cannot delete pragma-file \"%s\"!", arg);
								}
							}
						}
					}
				}
			}
		}
	}
	else
	{
		VFPrintf( Output(), "\"%s\": Unable to allocate memory for buffers!\n", arg);
	}

	if (strBuf)
		FreeVec( strBuf);

	// Return amount pragma files, files being able to convert and files converted
	return (amount << 24) | (allowed << 16) | counter;
}

int main( int argc, char **argv)
{
	ULONG *arg, flags, args[4];
	BPTR lock, oldDir;
	struct FileInfoBlock *fib;
	int err;

	// Pointer to arguments
	arg = (ULONG *) argv;

	// At least one argument
	if (argc > 1)
	{
		// Try to lock directory
		if ( (lock = Lock( argv[1], ACCESS_READ)) )
		{
			// Allocate File Info Block
			if( (fib = (struct FileInfoBlock *) AllocDosObject( DOS_FIB, TAG_DONE)) )
			{
				// Examine file or dir
				if (Examine( lock, fib))
				{
					// Is it a directory
					if (fib->fib_DirEntryType >= 0)
					{
						// Zero flags
						flags = 0;

						// Try to change directory
						if ( (oldDir = CurrentDir( lock)) != -1)
						{
							// At least two arguments supplied to Detour?
							if (argc > 2)
							{
								if ( !stricmp( argv[2], "real"))
								{
									flags |= 1;
								}
								else
								{
									if ( !stricmp( argv[2], "revert"))
									{
										flags |= 2;
									}
									else
									{
										VFPrintf( Output(), "Warning: Unsupported keyword \"%s\"!\n", &argv[2]);
									}
								}
							}

							// At least three arguments?
							if (argc > 3)
							{
								if ( !stricmp( argv[3], "real"))
								{
									flags |= 1;
								}
								else
								{
									if ( !stricmp( argv[3], "revert"))
									{
										flags |= 2;
									}
									else
									{
										VFPrintf( Output(), "Warning: Unsupported keyword \"%s\"!\n", &argv[3]);
									}
								}
							}


							if ( ((err = Detour( lock, fib, argv[1], flags )) & 0xFFFF) )
							{
								args[0] = (UWORD) (err & 0xFFFF);
								args[1] = (UBYTE) ((err & (0x00FF0000)) >> 16);
								arg = &args[0];
								VFPrintf( Output(), "\nConverted %ld pragma files out of %ld.\n", arg);
								err = 0;
							}
							else
							{
								args[0] = (ULONG) argv[0];
								args[1] = (UBYTE) (err >> 24);
								args[2] = (UBYTE) ((err & (0x00FF0000)) >> 16);
								args[3] = (UWORD) (err & 0xFFFF);

								// No pragma file encountered
								if ( !args[1])
								{
									VFPrintf( Output(), "\n\"%s\": Cannot find any pragma files...\n", arg);
								}
								else
								{
									arg = &args[0];
									if ( !args[2])
										VFPrintf( Output(), "\n\"%s\": Found %ld pragma files but none of them could be converted (wrong format)!\n", arg);
									else
										VFPrintf( Output(), "\n\"%s\": Found %ld pragma files where %ld would be able to convert, but none of them touched!\n", arg);
									arg = (ULONG *) argv;
								}
								err = 5;
							}
							CurrentDir( oldDir);
						}
						else
						{
							err = IoErr();
							VFPrintf( Output(), "\"%s\" fault: Cannot switch to directoy \"%s\"!\n", arg);
						}
					}
					else
					{
						err = IoErr();
						VFPrintf( Output(), "\"%s\" user-fault: \"%s\" is not a directory!\n", arg);
					}
				}
				else
				{
					err = IoErr();
					VFPrintf( Output(), "\"%s\" fault: DOS function examine failed...\n", arg);
				}
				FreeDosObject( DOS_FIB, fib);
			}
			else
			{
				err = IoErr();
				VFPrintf( Output(), "\"%s\": Unable to allocate dos-object!\n", arg);
			}
			UnLock( lock);
		}
		else
		{
			err = IoErr();
			VFPrintf( Output(), "\"%s\": Unable to access file!\n", arg);
		}
	}
	else
	{
		VFPrintf( Output(), "Usage: \"%s\" <c-include directory for pragmas>/A REAL/S REVERT/S\n\n- where \"c-include directory\" is the standard compiler \"pragmas\" directory!\n", arg);
		err = 5;
	}
	
	return err;
}
