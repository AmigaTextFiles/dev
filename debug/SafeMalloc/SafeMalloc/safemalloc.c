/*
 * Article 879 of net.sources:
 * Relay-Version: version B 2.10.3 4.3bsd-beta 6/6/85; site unisoft.UUCP
 * Posting-Version: version B 2.10.2 9/18/84; site dataioDataio.UUCP
 * Path: unisoft!lll-lcc!ucdavis!ucbvax!decvax!tektronix!uw-beaver!uw-june!entropy!dataio!bjorn
 * From: bjorn@dataioDataio.UUCP (Bjorn Benson)
 * Newsgroups: net.sources
 * Subject: Solution to "oops, corrupted memory again!"
 * Message-ID: <975@dataioDataio.UUCP>
 * Date: 29 Apr 86 03:04:49 GMT
 * Date-Received: 2 May 86 18:38:02 GMT
 * References: <4495@cbrma.UUCP>
 * Organization: Data I/O Corp., Redmond WA
 * Lines: 268
 * Keywords: malloc free stack tools core memory
 */

/*
 * [This posting refers to an article entitled "oops, corrupted memory
 * again!" in net.lang.c.  I am posting it here because it is source.]
 * 
 * My tool for approaching this problem is to build another level of data 
 * abstraction on top of malloc() and free() that implements some checking.  
 * This does a number of things for you:
 * 	- Checks for overruns and underruns on allocated data
 * 	- Keeps track of where in the program the memory was malloc'ed
 * 	- Reports on pieces of memory that were not free'ed
 * 	- Records some statistics such as maximum memory used
 * 	- Marks newly malloc'ed and newly free'ed memory with special values
 * You can use this scheme to:
 * 	- Find bugs such as overrun, underrun, etc because you know where 
 * 	  a piece of data was malloc'ed and where it was free'ed
 * 	- Find bugs where memory was not free'ed
 * 	- Find bugs where newly malloc'ed memory is used without initializing
 * 	- Find bugs where newly free'ed memory is still used
 * 	- Determine how much memory your program really uses
 * 	- and other things
 */

/*
 * To implement my scheme you must have a C compiler that has __LINE__ and
 * __FILE__ macros.  If your compiler doesn't have these then (a) buy another:
 * compilers that do are available on UNIX 4.2bsd based systems and the PC,
 * and probably on other machines; or (b) change my scheme somehow.  I have
 * recomendations on both these points if you would like them (e-mail please).
 * 
 * There are 3 functions in my package:
 * 	char *NEW( uSize )	Allocate memory of uSize bytes
 * 				(equivalent to malloc())
 * 	FREE( pPtr )		Free memory allocated by NEW
 * 				(equivalent to free())
 * 	TERMINATE()		End system, report errors and stats
 * I personally use two more functions, but have not included them here:
 * 	char *STRSAVE( sPtr )	Save a copy of the string in dynamic memory
 * 	char *RENEW( pPtr, uSize )
 * 				(equivalent to realloc())
 */

#ifdef PUT_THIS_IN_ROUTINE_CALLING_ME
/*
 * Memory sub-system, written by Bjorn Benson
 */
extern char *_mymalloc ();
#define	NEW(SZ)		_mymalloc( SZ, __FILE__, __LINE__ )
#define	FREE(PTR)	_myfree( PTR, __FILE__, __LINE__ )
#endif

/*
 * Memory sub-system, written by Bjorn Benson
 */

#include <stdio.h>

typedef unsigned uns;			/* Shorthand */

struct irem {
    struct remember *_pNext;		/* Linked list of structures	   */
    struct remember *_pPrev;		/* Other link			   */
    char *_sFileName;			/* File in which memory was new'ed */
    uns _uLineNum;			/* Line number in above file	   */
    uns _uDataSize;			/* Size requested		   */
    uns _lSpecialValue;			/* Underrun marker value	   */
};

struct remember {
    struct irem tInt;
    char aData[1];
};

#define	pNext		tInt._pNext
#define	pPrev		tInt._pPrev
#define	sFileName	tInt._sFileName
#define	uLineNum	tInt._uLineNum
#define	uDataSize	tInt._uDataSize
#define	lSpecialValue	tInt._lSpecialValue

/*
 *	Note: both these refer to the NEW'ed
 *	data only.  They do not include
 *	malloc() roundoff or the extra
 *	space required by the remember
 *	structures.
 */
 
static long lCurMemory = 0;		/* Current memory usage	*/
static long lMaxMemory = 0;		/* Maximum memory usage	*/

static  uns cNewCount = 0;		/* Number of times NEW() was called */

 /* Root of the linked list of remembers	 */
static struct remember *pRememberRoot = NULL;

#define	ALLOC_VAL	0xA5	/* NEW'ed memory is filled with this */
				/* value so that references to it will	 */
				/* end up being very strange.		 */
#define	FREE_VAL	0x8F	/* FREE'ed memory is filled with this */
				/* value so that references to it will	 */
				/* also end up being strange.		 */

#define	MAGICKEY	0x14235296	/* A magic value for underrun key */
#define	MAGICEND0	0x68		/* Magic values for overrun keys  */
#define	MAGICEND1	0x34		/* 		"		  */
#define	MAGICEND2	0x7A		/*              "		  */
#define	MAGICEND3	0x15		/* 		"		  */

 /* Warning: do not change the MAGICEND? values to */
 /* something with the high bit set.  Various C    */
 /* compilers (like the 4.2bsd one) do not do the  */
 /* sign extension right later on in this code and */
 /* you will get erroneous errors.		  */

static void _sanity ();
static void _checkchunk ();

/*
 * char * _mymalloc( uns uSize, char *sFile, uns uLine )
 *	Allocate some memory.
 */

char *_mymalloc (uSize, sFile, uLine)
uns uSize;
char *sFile;
uns uLine;
{
    extern char *malloc ();
    struct remember *pTmp;
    char *pPtr;

    _sanity (sFile, uLine);

    /* Allocate the physical memory */
    pTmp = (struct remember *) malloc (
    		sizeof (struct irem)	/* remember data  */
		+ uSize					/* size requested */
		+ 4					/* overrun mark   */
		);

    /* Check if there isn't anymore memory avaiable */
    if (pTmp == NULL) {
	fprintf (stderr, "Out of memory at line %d, \"%s\"\n", uLine, sFile);
	fprintf (stderr, "\t(memory in use: %ld bytes (%ldk))\n",
		lMaxMemory, (lMaxMemory + 1023L) / 1024L);
	fflush (stderr);
	return ((char *) NULL);
    }

    /* Fill up the structure */
    pTmp -> lSpecialValue = MAGICKEY;
    pTmp -> aData[uSize + 0] = MAGICEND0;
    pTmp -> aData[uSize + 1] = MAGICEND1;
    pTmp -> aData[uSize + 2] = MAGICEND2;
    pTmp -> aData[uSize + 3] = MAGICEND3;
    pTmp -> sFileName = sFile;
    pTmp -> uLineNum = uLine;
    pTmp -> uDataSize = uSize;
    pTmp -> pNext = pRememberRoot;
    pTmp -> pPrev = NULL;

    /* Add this remember structure to the linked list */
    if (pRememberRoot) {
	pRememberRoot -> pPrev = pTmp;
    }
    pRememberRoot = pTmp;

    /* Keep the statistics */
    lCurMemory += uSize;
    if (lCurMemory > lMaxMemory) {
	lMaxMemory = lCurMemory;
    }
    cNewCount++;

    /* Set the memory to the aribtrary wierd value */
    for (pPtr = &pTmp -> aData[uSize]; pPtr > &pTmp -> aData[0];) {
	*(--pPtr) = ALLOC_VAL;
    }
    /* Return a pointer to the real data */
    return (&(pTmp -> aData[0]));
}

/*
 * _myfree( char *pPtr, char *sFile, uns uLine )
 *	Deallocate some memory.
 */

_myfree (pPtr, sFile, uLine)
char *pPtr;
char *sFile;
uns uLine;
{
    struct remember *pRec;
    char *pTmp;

    _sanity (sFile, uLine);
    
    /* Check if we have a non-null pointer */
    if (pPtr == NULL) {
	fprintf (stderr, "Freeing NULL pointer at line %d, \"%s\"\n",
		uLine, sFile);
	fflush (stderr);
	return;
    }

    /* Calculate the address of the remember structure */
    pRec = (struct remember *) (pPtr - (sizeof (struct irem)));

    /* Check to make sure that we have a real remember structure */
    /* Note: this test could fail for four reasons: */
    /*  (1) The memory was already free'ed		 */
    /*  (2) The memory was never new'ed		 */
    /*  (3) There was an underrun			 */
    /*  (4) A stray pointer hit this location	 */
    /* 						 */

    if (pRec -> lSpecialValue != MAGICKEY) {
	fprintf (stderr, "Freeing unallocated data at line %d, \"%s\"\n",
		uLine, sFile);
	fflush (stderr);
	return;
    }

    /* Remove this structure from the linked list */
    if (pRec -> pPrev) {
	pRec -> pPrev -> pNext = pRec -> pNext;
    } else {
	pRememberRoot = pRec -> pNext;
    }
    if (pRec -> pNext) {
	pRec -> pNext -> pPrev = pRec -> pPrev;
    }

    /* Mark this data as free'ed */
    for (pTmp = &pRec -> aData[pRec -> uDataSize]; pTmp > &pRec -> aData[0];){
	*(--pTmp) = FREE_VAL;
    }
    pRec -> lSpecialValue = ~MAGICKEY;

    /* Handle the statistics */
    lCurMemory -= pRec -> uDataSize;
    cNewCount--;

    /* Actually free the memory */
    free ((char *) pRec);
}

/*
 * TERMINATE()
 *	Report on all the memory pieces that have not been
 *	free'ed as well as the statistics.
 */

TERMINATE ()
{
    struct remember *pPtr;

    /* Report the difference between number of calls to	 */
    /* NEW and the number of calls to FREE.  >0 means more	 */
    /* NEWs than FREEs.  <0, etc.				 */

    if (cNewCount) {
	fprintf (stderr, "cNewCount: %d\n", cNewCount);
	fflush (stderr);
    }

    /* Report on all the memory that was allocated with NEW	 */
    /* but not free'ed with FREE.				 */

    if (pRememberRoot != NULL) {
	fprintf (stderr, "Memory that was not free'ed:\n");
	fflush (stderr);
    }
    pPtr = pRememberRoot;
    while (pPtr) {
	fprintf (stderr,
		"\t%5d bytes at 0x%06x, allocated at line %3d in \"%s\"\n",
		pPtr -> uDataSize, &(pPtr -> aData[0]),
		pPtr -> uLineNum, pPtr -> sFileName
	    );
	fflush (stderr);
	pPtr = pPtr -> pNext;
    }

    /* Report the memory usage statistics */
    fprintf (stderr, "Maximum memory usage: %ld bytes (%ldk)\n",
	    lMaxMemory, (lMaxMemory + 1023L) / 1024L);
    fflush (stderr);
}

static void _checkchunk (pRec, sFile, uLine)
register struct remember *pRec;
char *sFile;
uns uLine;
{
    register uns uSize;
    register char *magicp;

    /* Check for a possible underrun */
    if (pRec -> lSpecialValue != MAGICKEY) {
	fprintf (stderr, "Memory allocated at \"%s:%d\" was underrun,",
		pRec -> sFileName, pRec -> uLineNum);
	fprintf (stderr, " discovered at \"%s:%d\"\n", sFile, uLine);
	fflush (stderr);
    }

    /* Check for a possible overrun */
    uSize = pRec -> uDataSize;
    magicp = &(pRec -> aData[uSize]);
    if (*magicp++ != MAGICEND0 ||
    	*magicp++ != MAGICEND1 ||
	*magicp++ != MAGICEND2 ||
	*magicp++ != MAGICEND3)
	{
	fprintf (stderr, "Memory allocated at \"%s:%d\" was overrun,",
		pRec -> sFileName, pRec -> uLineNum);
	fprintf (stderr, " discovered at \"%s:%d\"\n", sFile, uLine);
	fflush (stderr);
    }
}

static void _sanity (sFile, uLine)
char *sFile;
uns uLine;
{
	register struct remember *pTmp;

	for (pTmp = pRememberRoot; pTmp != NULL; pTmp = pTmp -> pNext) {
	    _checkchunk (pTmp, sFile, uLine);
	}
}
