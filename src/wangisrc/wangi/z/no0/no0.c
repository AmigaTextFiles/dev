
#include <exec/types.h>
#include <dos/dos.h>
#include <dos/rdargs.h>

/* Amiga prototypes and pragmas */
#include <proto/dos.h>
#include <proto/exec.h>

/***************************************************************************
 * main() --
 */
int main(int argc, char **argv)
{
	struct RDArgs *rdargs;
	LONG ret;
	#define TEMPLATE "OUTBOUND"
	#define OPT_OUTBOUND 0
	STRPTR args[1] = {"OUTBOUND:"};
	/* Parse the argument template */
	if (rdargs = ReadArgs(TEMPLATE, (LONG *)&args, NULL))
	{
		BPTR lock;
		if( lock = Lock(args[OPT_OUTBOUND],ACCESS_READ) )
		{
			struct FileInfoBlock *fib;
			BPTR ocd = CurrentDir(lock);
			if( fib = AllocDosObject(DOS_FIB, NULL) )
			{
				if( Examine(lock, fib) && (fib->fib_DirEntryType > 0) )
				{
					LONG err;
					while( ExNext(lock, fib) )
					{
						if( (fib->fib_DirEntryType < 0) && (fib->fib_Size == 0) )
							if( !DeleteFile(fib->fib_FileName) )
								PrintFault(IoErr(), fib->fib_FileName);
					}
					if( (err = IoErr()) != ERROR_NO_MORE_ENTRIES )
						PrintFault(err, "no0");
				}
				FreeDosObject(DOS_FIB, fib);
			}
			CurrentDir(ocd);
			UnLock(lock);
		}	
		FreeArgs(rdargs);
		ret = RETURN_OK;
	} else
		ret = RETURN_FAIL;
	
	if( ret )
		PrintFault(IoErr(), "no0");

	return ret;
}