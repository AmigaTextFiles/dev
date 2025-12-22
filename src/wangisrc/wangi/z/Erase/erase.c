/***************************************************************************
 * Erase.c
 *
 * Erase -- Its a helluva lot more dangerous than delete :)
 *
 * August 1995, Lee Kindness
 *
 */

/* All the includes are in this file */
#include "gst.c"

/* Size of the buffer we tack onto the AnchorPath */
#define EXTRABUFLEN 200

/* Size of the buffer for fault display */
#define FAULTBUFLEN 1024

/* Coment that is written to all files */
#define COMMENT ":-) :-| :-( :-| :-) :-| :-( :-| :-) :-| :-( :-| :-) :-| :-( :-| :-) :-| :-( :-| "

/* What to output before the fault text */
#define HEADER "Erase"

/* Argument template */
#define TEMPLATE "FILE/M/A,TIMES/K/N"

/* Version number */
#define VERSION "1.1"

/* Version tag for C:Version to pick up */
char vertag[] = "$VER: Erase "VERSION" "__AMIGADATE__;

/* Global preferences: How many times to overwrite a file */
LONG times;

/* Prototypes */
void EraseError(STRPTR name, LONG code);
void EraseDir(STRPTR name, struct FileInfoBlock *fib, BPTR parent);
void EraseFile(STRPTR name, struct FileInfoBlock *fib, BPTR parent);
void DoPattern(STRPTR pattern);


/***************************************************************************
 * EraseError() -- Report an error to the user 
 */
void EraseError(STRPTR name, LONG code)
{
	STRPTR header, buffer;
	if( buffer = AllocVec(FAULTBUFLEN, MEMF_CLEAR) )
	{
		if( !name )
			header = HEADER;
		else
			header = name;
		if( Fault(code, header, buffer, FAULTBUFLEN) )
			Printf("%s\n", buffer);
		else
			if( name) Printf("Cannot erase %s\n", name);
		FreeVec(buffer);
	}
}


/***************************************************************************
 * EraseDir() -- Erase a directory 
 */
void EraseDir(STRPTR name, struct FileInfoBlock *fib, BPTR parent)
{
	/* Check its not a disk... */
	if( strlen(fib->fib_FileName) ) 
	{
		BPTR olddir;
		struct DateStamp *ds;
		
		olddir = CurrentDir(parent);
		
		/* Clear protection */
		SetProtection(fib->fib_FileName,0);
		
		/* Clear Comment */
		SetComment(fib->fib_FileName, COMMENT);
		
		/* Clear mufs ownership information */
		if( DOSBase->dl_lib.lib_Version >= 39 ) SetOwner(fib->fib_FileName, 0);
		
		/* Clear timestamp */
		if( ds = AllocVec(sizeof(struct DateStamp), MEMF_CLEAR) )
		{
			SetFileDate(fib->fib_FileName, ds);
			FreeVec(ds);
		}
		
		/* Delete the directory */
		if( DeleteFile(fib->fib_FileName) )
			Printf("%s erased\n", name);
		else
			EraseError(name, IoErr());
		
		CurrentDir(olddir);
	}
}


/***************************************************************************
 * EraseFile() -- Erase a file 
 */
void EraseFile(STRPTR name, struct FileInfoBlock *fib, BPTR parent)
{
	BPTR olddir;
	struct DateStamp *ds;
	LONG i, n;
	BPTR file;
	
	olddir = CurrentDir(parent);
	
	/* Clear protection */
	SetProtection(fib->fib_FileName,0);
	
	/* Clear Comment */
	SetComment(fib->fib_FileName, COMMENT);
	
	/* Clear mufs ownership information */
	if( DOSBase->dl_lib.lib_Version >= 39 ) SetOwner(fib->fib_FileName, 0);
	
	/* Clear timestamp */
	if( ds = AllocVec(sizeof(struct DateStamp), MEMF_CLEAR) )
	{
		SetFileDate(fib->fib_FileName, ds);
		FreeVec(ds);
	}
	
	/* Clear file contents 'times' times */
	for(n = 0; n < times; n++) {
		if( file = Open(fib->fib_FileName, MODE_OLDFILE) ) {
			Seek(file, 0, OFFSET_BEGINING);
			for(i = 0; i < fib->fib_Size; i++)
				FPutC(file, n);
			Close(file);
		}
	}
	
	/* Set file size to zero */
	if( file = Open(fib->fib_FileName, MODE_OLDFILE) ) {
		SetFileSize(file, OFFSET_BEGINING, 0);
		Close(file);
	}
	
	/* Delete the file */
	if( DeleteFile(fib->fib_FileName) )
		Printf("%s erased\n", name);
	else
		EraseError(name, IoErr());
	
	CurrentDir(olddir);
}

	
/***************************************************************************
 * DoPattern() -- Parse and traverse the pattern 
 */
void DoPattern(STRPTR pattern)
{
	struct AnchorPath *ap;
	if( ap = AllocVec(sizeof(struct AnchorPath) + EXTRABUFLEN, MEMF_CLEAR) )
	{
		LONG ret;
		ap->ap_BreakBits = SIGBREAKF_CTRL_C;
		ap->ap_Strlen = EXTRABUFLEN;
		ap->ap_Flags = APF_DOWILD;
		
		ret = MatchFirst(pattern, ap);
		while( !ret )
		{
			if( ap->ap_Info.fib_DirEntryType > 0 )
			{
				if( !(ap->ap_Flags & APF_DIDDIR) )
					ap->ap_Flags |= APF_DODIR;
				else
				{
					ap->ap_Flags &= !APF_DIDDIR;
					EraseDir((STRPTR)&ap->ap_Buf, &ap->ap_Info, ap->ap_Current->an_Lock);
				}
			} else
				EraseFile((STRPTR)&ap->ap_Buf, &ap->ap_Info, ap->ap_Current->an_Lock);

			ret = MatchNext(ap);
		}
		MatchEnd(ap);
		ret = IoErr();
		if( ret != ERROR_NO_MORE_ENTRIES )
			EraseError(NULL, ret);
		
		FreeVec(ap);
	}
}


/***************************************************************************
 * main() --
 */
int main(int argc, char **argv)
{
	struct RDArgs *rdargs;
	LONG ret;
	#define OPT_FILE 0
	#define OPT_TIMES 1
	LONG args[2] = {0, 0};
	/* Parse the argument template */
	if (rdargs = ReadArgs(TEMPLATE, (LONG *)&args, NULL)) {
		STRPTR s;
	
		if( args[OPT_TIMES] ) {
			times = *((LONG *)args[OPT_TIMES]);
		} else
			times = 1;
		if( times < 0 )
			times = 1;
		
		s = *((STRPTR *)args[OPT_FILE]);
		while( (s) && (*s) ) 
		{
			/* Act on the pattern */
			DoPattern(s);
			
			/* Get the next string in the array */
			s = strchr(s,'\0');
			s++;
		}
		
		FreeArgs(rdargs);
		ret = 0;
	} else
		ret = 20;
	
	if( ret )
		EraseError(NULL, IoErr());

	return ret;
}