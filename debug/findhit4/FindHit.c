/*
** $VER: FindHit 37.4 (1.7.93)
**
** Finds the C source line of an Enforcer or Mungwall Hit, given the Slink
** mapfile and object files compiled with at least DEBUG=LINE.
**
** Written by Douglas Keller
**
*/

#include "headers.h"

#define VERSION "37.4 (1.7.93)"

struct GlobalData {
	struct Library *SysBase;
	struct Library *DOSBase;

	ULONG hunk;
	BOOL delete_omdfile;

	UBYTE omdfile[44];	/* keep the mapfilename to delete if delete_omdfile is TRUE */
	
	UBYTE buffer[512];
};
typedef struct GlobalData GLOB;

static const UBYTE *ver= "$VER: FindHit " VERSION "";

/***** prototypes *****/
static LONG find_hit_from_map(GLOB *z, UBYTE *mapfile, UBYTE *offset);
static void find_filename_and_base_column(UBYTE *buffer, UWORD *ofile_column, UWORD *base_column);
static LONG find_offset_from_omd(GLOB *z, UBYTE *ofile, UBYTE *cfile, ULONG base, ULONG hit_offset);
static BOOL diff_time(GLOB *z, UBYTE *file1, UBYTE *file2);
static LONG keyOfFile(GLOB *z, UBYTE *str);
static LONG hexToLong(UBYTE *str);
static void SPrintf(struct Library *SysBase, STRPTR buffer, STRPTR format, ...);

#define TEMPLATE "MAPFILE/A,OFFSET/A/M,HUNK/N,DEL=DELETEOMDFILE/S"
#define OPT_MAPFILE		0
#define OPT_OFFSET		1
#define OPT_HUNK		2
#define OPT_DELETE		3
#define OPT_COUNT		4
LONG StartUpCode(void)
{
  GLOB *z;
  struct Library *SysBase=*((void **)4L);
  struct RDArgs *rdargs;
  UBYTE **str;
  LONG opts[OPT_COUNT];
  LONG retval=RETURN_FAIL;


	if( z=AllocMem(sizeof(GLOB),MEMF_ANY) )
		{
		z->SysBase= SysBase;
#define DOSBase z->DOSBase
#define SysBase z->SysBase
		if( DOSBase=OpenLibrary("dos.library", 37L) )
			{
			memset(opts, 0, sizeof(opts));
			if( rdargs=ReadArgs(TEMPLATE, opts, NULL) )
				{
				
				if( opts[OPT_HUNK] )
					{
					z->hunk= *((LONG *)opts[OPT_HUNK]);
					}
				else
					{
					z->hunk= 0;
					}
				if( opts[OPT_DELETE] )
					{
					z->delete_omdfile=TRUE;
					}
				else
					{
					z->delete_omdfile=FALSE;
					}

				Printf("\2331m_FindHit_\2330m " VERSION " by Douglas Keller\n\n");

				str= (UBYTE **) opts[OPT_OFFSET];
				while( *str )
					{
					if( retval= find_hit_from_map(z, (UBYTE *)opts[OPT_MAPFILE], *str) )
						{
						break;
						}
					str++;
					}

				if( z->delete_omdfile ) DeleteFile(z->omdfile);

				Printf("\n");
				
				FreeArgs(rdargs);
				}
			else
				{
				PrintFault(IoErr(), NULL);
				}

			CloseLibrary(DOSBase);
			}
		FreeMem(z, sizeof(GLOB));
		}
	return( retval );
}

static LONG find_hit_from_map(GLOB *z, UBYTE *mapfile, UBYTE *offset_str)
{
  BPTR fh;
  BPTR lock, old_cd, exists;
  UBYTE *buffer= z->buffer;
  UBYTE *ptr, cfile[256], ofile[256], *lastchar, *cfile_ptr;
  BOOL start=FALSE;
  BOOL hunkfound=FALSE;
  ULONG hit_offset;
  ULONG offset, lastoffset=0;
  LONG retval=RETURN_FAIL;
  UBYTE path[256];
  UWORD ofile_column, base_column;


	hit_offset= hexToLong(offset_str);
	strcpy(path, mapfile);
	*(PathPart(path))= NULL;
	if( lock=Lock(path,SHARED_LOCK) )  /* CD to mapfile dir, so we can find #?.(c|o) files */
		{
		old_cd= CurrentDir(lock);
		}

	if( fh=Open(FilePart(mapfile), MODE_OLDFILE) )
		{
		SetVBuf(fh, NULL, BUF_FULL, 4096);
		while( FGets(fh, buffer, 512) )
			{
			if( !start && buffer[0]==' '&&buffer[1]=='n'&&buffer[2]=='u'&&buffer[3]=='m' )
				{
				find_filename_and_base_column(buffer, &ofile_column, &base_column);
				start=TRUE;
				continue;
				}
			else if( start && buffer[0]==0x0c )
				{
				start=FALSE;
				continue;
				}

			if( start && !hunkfound )
				{
				if( buffer[3] != ' ' )
					{
					buffer[4]= NULL;
					if( z->hunk == hexToLong(buffer) )
						{
						hunkfound=TRUE;
						}
					}
				}
			if( start && hunkfound )
				{
				/* find .o name and base */
				ptr= buffer + ofile_column;
				while( *++ptr != ' ' )
					{
					}
				*ptr=
				buffer[base_column + 8]= NULL;
				ptr= buffer + ofile_column;
				offset= hexToLong(buffer+base_column);

				if( offset > hit_offset )
					{
					cfile_ptr= cfile;
					if( exists=Lock(cfile, SHARED_LOCK) )
						{
						UnLock(exists);
						}
					else
						{
						if( old_cd ) CurrentDir(old_cd);
						if( exists=Lock(FilePart(cfile), SHARED_LOCK) )
							{
							cfile_ptr= FilePart(cfile);
							strcpy(ofile, cfile_ptr);
							lastchar= ofile + strlen(ofile)-1;
							if( *lastchar == 'c' ) *lastchar='o';
							UnLock(exists);
							}
						}
					Printf("Found offset 0x%08lx in \"%s\", ", hit_offset, cfile_ptr);
					Flush(Output());

					retval= find_offset_from_omd(z, ofile, cfile_ptr, lastoffset, hit_offset);

					break;
					}

				strcpy(ofile, ptr);
				strcpy(cfile, ptr);
				lastchar= cfile + strlen(cfile)-1;
				if( *lastchar == 'o' ) *lastchar='c';
				lastoffset= offset;
				}

			}
		Close(fh);		
		}
	else
		{
		Printf("Error: could not open mapfile '%s'\n", mapfile);
		}

	if( lock )
		{
		CurrentDir(old_cd);
		UnLock(lock);
		}

	return( retval );
}

static void find_filename_and_base_column(UBYTE *buffer, UWORD *ofile_column, UWORD *base_column)
{
  UBYTE *ptr = buffer;

	/* find column of "filename", it is guaranteed to be the first 'f' */
	while( *ptr++ )
		{
		if( *ptr == 'f' )
			{
			*ofile_column = ptr - buffer;
			break;
			}
		}
	/* find column of "base", it is guaranteed to be the first 'b' */
	while( *ptr++ )
		{
		if( *ptr == 'b' )
			{
			*base_column = ptr - buffer - 4; /* -4 since the largest number is 8 chars */
			break;
			}
		}
}

#define SEMICOLON 1
#define VERTBAR   2

static LONG find_offset_from_omd(GLOB *z, UBYTE *ofile, UBYTE *cfile, ULONG base, ULONG hit_offset)
{
  BPTR clock, olock;
  BPTR fh;
  ULONG line_num=0,found_line=0;
  ULONG offset;
  UBYTE *buffer= z->buffer;
  UWORD last=0;
  UBYTE *omdfile=z->omdfile;
  LONG retval=RETURN_FAIL;
  LONG system_retval=0;

	if( clock=Lock(cfile, SHARED_LOCK) )
		{
		if( olock=Lock(ofile, SHARED_LOCK) )
			{
			SPrintf(SysBase, omdfile, "t:fh%lx_%s", keyOfFile(z,cfile), FilePart(cfile));
			strcpy(omdfile+strlen(omdfile)-1, "omd");

			if( diff_time(z, ofile, omdfile) )
				{
				SPrintf(SysBase, buffer, "omd \"%s\" \"%s\" >%s", ofile, cfile, omdfile);
				system_retval=SystemTags(buffer,
									SYS_UserShell, TRUE,
									TAG_DONE);
				if( system_retval )
					{
					DeleteFile(omdfile);
					Printf("Error: error running OMD.\n");
					}
				}

			if( system_retval==0 && (fh=Open(omdfile, MODE_OLDFILE)) )
				{
				SetVBuf(fh, NULL, BUF_FULL, 4096);
				retval= RETURN_WARN;

				while( FGets(fh, buffer, 100) )
					{
					if( buffer[0] == ';' )
						{
						line_num++;
						last= SEMICOLON;
						}
					if( buffer[7] == '|' )
						{
						buffer[13]= NULL;
						offset= hexToLong(buffer+9);

						if( base + offset >= hit_offset )
							{
							Printf("on line %ld\n", found_line);
							retval=RETURN_OK;
							break;
							}

						if( last == SEMICOLON ) found_line= line_num;
						last= VERTBAR;
						}
					}

				if( retval != RETURN_OK ) Printf("line number not found.\n");

				Close(fh);
				}

			UnLock(olock);
			}
		else
			{
			Printf("Error: could not open \"%s\".\n", ofile);
			}
		UnLock(clock);
		}
	else
		{
		Printf("Error: could not open \"%s\".\n", cfile);
		}
	return( retval );
}

static BOOL diff_time(GLOB *z, UBYTE *file1, UBYTE *file2)
{
  BPTR lock1;
  BPTR lock2;
  struct FileInfoBlock __aligned fib1;
  struct FileInfoBlock __aligned fib2;
  BOOL retval=TRUE;

	if( lock1=Lock(file1,SHARED_LOCK) )
		{
		if( lock2=Lock(file2,SHARED_LOCK) )
			{
			if( Examine(lock1,&fib1) && Examine(lock2,&fib2) )
				{
				if( 0 <= CompareDates(&fib1.fib_Date, &fib2.fib_Date) )
					{
					retval=FALSE;
					}
				}
			UnLock(lock2);
			}
		UnLock(lock1);
		}
	return( retval );
}

static LONG hexToLong(UBYTE *str)
{
  LONG num;

	while( *str == ' ' )
		{
		str++;
		}

	stch_l(str, &num);
	return( num );
}

static LONG keyOfFile(GLOB *z, UBYTE *str)
{
  BPTR lock;
  struct FileInfoBlock __aligned fib;
  LONG key=0;

	if( lock=Lock(str, SHARED_LOCK) )
		{
		if( Examine(lock, &fib) )
			{
			key= fib.fib_DiskKey; /* key will be unique even if filenames are the same */
			}
		UnLock(lock);
		}
	return( key );
}

#undef SysBase
static void SPrintf(struct Library *SysBase, STRPTR buffer, STRPTR format, ...)
{

	RawDoFmt( format, (APTR)(&format+1), (void (*))"\x16\xc0\x4e\x75", buffer);
}

