/**************************************************************************
	AWlib.c

	A set of C routines to be turned into a library called "AW.library".
	We use LibTool to make our lib startup asm code (-m option) to be linked
	with this module. This creates a library. We also use LibTool to create
	glue code for a C application which expects to call C library functions (-c
	option). Note that this module should NOT be compiled with small code/data
	because we do not bother setting up and restoring a4 (which is what you
	would have to do at the start and end of each callable function).

	You may wish to make the C header file at this time, as well. Use the
	LibTool option -cmho.

Manx 5.0d

LibTool -cmo glue.asm AWlib.fd		;C function code, create lib startup code
as -cd -o LibStart.o AWlib.src		;large code and data
cc -mcd0b -ff AWlib.c					;large code, large data, no .begin, ffp
ln -o libs:AW.library LibStart.o AWlib.o -lmfl -lcl	;large, 32 bit lib 

***************************************************************************/

#include "exec/types.h"
#include "exec/tasks.h"
#include "exec/memory.h"
#include "libraries/dos.h"
#include "libraries/dosextens.h"

#include "math.h"

#define TO_DEGREES(x) (57.29577951*(x))
#define TO_RADIANS(x) (0.0174532925*(x))

extern struct LibBase; /* this library's base */

/**************************************************************************
	These are the functions which perform rectangular / polar conversions.
	Angle arguments / returns are specified in degrees.
***************************************************************************/

double Mag( double real, double imaj )
{
	return( sqrt( real*real + imaj*imaj ) );
}

double Ang( double real, double imaj )
{
	return( TO_DEGREES( atan( imaj / real ) ) );
}

double Real( double mag, double ang )
{
	return( mag * cos( TO_RADIANS( ang ) ) );
}

double Imaj( double mag, double ang )
{
	return( mag * sin( TO_RADIANS( ang ) ) );
}


/*************************************************************************
	Here are the special initialization and expunge routines.
***************************************************************************/

struct MathTransBase *MathTransBase = 0L;
struct MathBase *MathBase = 0L;

/**************************************************************************
 This is called only once when the lib is first loaded. It just opens
 mathffp.library and mathtrans.library for us. If they aren't opened, we'll
 say hello to Mr. GURU. This is the Init vector function (i.e. ##init in the
 fd file).
***************************************************************************/

BOOL myInit()
{
	if( (MathBase = (struct MathBase *)OpenLibrary("mathffp.library", 0L )) == 0 )	
		return( FALSE );

	if( (MathTransBase = (struct MathTransBase *)OpenLibrary("mathtrans.library", 0L )) == 0 )
	{
		CloseLibrary( MathBase );
		MathBase = 0L;
		return( FALSE );
	}

	return( TRUE );
}

/**************************************************************************
 This is called when the lib is expunged. It just closes the mathffp.library
 and mathtrans.library for us. This is the Expu vector function (i.e. ##expu
 in the fd file).
***************************************************************************/

VOID myFree()
{
	if( MathBase ) 		CloseLibrary( MathBase );
	if( MathTransBase )	CloseLibrary( MathTransBase );
	MathBase = 0L;
	MathTransBase = 0L;
}
