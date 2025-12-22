/****************************************************************************
	This is an example application to test the C "simple.library". Make the
	glue code with LibTool (-c option). (This can be made when the library is
	made by using the LibTool option -cmho).

Manx 5.0d

cc -mcd -ff AWlib_App.c						;large code and data
LibTool -cho glue.asm AWlib.fd		;C function code, create header file
as -cd glue.asm							;large code and data
ln AWlib_App.o glue.o -lmfl -lcl		;large, 32 bit lib

****************************************************************************/

#include "exec/types.h"
#include "math.h"
#include "awlib.h"

ULONG  argcount;  /* Saves argc from main(). if argcount==0, then run from WB. */

VOID exit_program( error_words, error_code )	/* All exits through here. */
char  error_words;
ULONG error_code;
{
	if( argcount && error_words ) puts( error_words );
	CloseAWBase();	/* This is always safe to call */
	exit( error_code );
}


/************************ MAIN ROUTINE *****************************/

VOID main(argc, argv)
LONG argc;
char **argv;
{
	double result;

	argcount = argc;

	/* open AW.library */
	if( !(OpenAWBase()) )
		exit_program("Can't open AW library.\n", 10L);

	result = Mag( 10.0, 20.0 );
	printf("Magnitude of 10 + j20 = %lf\n", result );

	result = Ang( 10.0, 20.0 );
	printf("Angle of 10 + j20 = %lf\n", result );

	result = Real( 10.0, 60.0 );
	printf("Real component of 10 at 60 degrees = %lf\n", result );

	result = Imaj( 10.0, 60.0 );
	printf("Imaginary component of 10 at 60 degrees = %lf\n", result );

	exit_program(0L,0L);
}
