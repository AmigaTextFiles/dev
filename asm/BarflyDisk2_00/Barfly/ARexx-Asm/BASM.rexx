/************************************************************************
 *
 * BASM.basm	copyright (c) 1992-95, Ralph Schmidt
 *
 * This is an example how to control the arexx port of BASM....
 * If you have further suggestions mail it, because it's my first
 * try with AREXX and so I'm no real expert.
 *
 * Version 1.00:  3.1.1992
 * Version 1.01:  13.4.1992
 * Version 1.02:  07.5.1995
 *
 ************************************************************************/



/* This command allows BASM to pass status variables */

Options FailAt 200

AREXXERROR_OK			=0
AREXXERROR_False		=20            /* Error by the Assembler-Parse!!! */
AREXXERROR_OpenError		=1
AREXXERROR_SourceError		=2
AREXXERROR_ReadError		=3
AREXXERROR_UnknownOption	=4
AREXXERROR_MemoryError		=5
AREXXERROR_NoSourceFile		=6
AREXXERROR_NoNextError		=7
AREXXERROR_NoErrorList		=8
AREXXERROR_NoNextWarning	=9
AREXXERROR_NoWarningList	=10


options results

/* Activate BASM Arexx port */
address 'rexx_BASM'


	SAY '************************** Example 1 ************************'

	basm '-v -O -OG Source/Stop.s'
	if RC=AREXXERROR_OK then SAY 'Message of the day: 'result
        else SAY 'Status:' RC

	SAY '************************** Example 2 ************************'

	basm '-e -es- -iSource Source/Error.s'
	IF RC=AREXXERROR_OpenError THEN SAY 'Open File Error...'
	IF RC=AREXXERROR_SourceError THEN SAY 'No ASCII-Source...'
	IF RC=AREXXERROR_ReadError THEN SAY 'Read File Error...'
	IF RC=AREXXERROR_UnknownError THEN SAY 'Unknown Assembler Option...'
	IF RC=AREXXERROR_MemoryError THEN SAY 'Not enough Memory...'
	IF RC=AREXXERROR_NoSourceFile THEN SAY 'No Source File specified...'
	IF RC=AREXXERROR_False THEN DO
           SAY 'Assembling Error:'
           SAY 'Init Error List Pointer to the first entry...'
           biniterror
           SAY 'Get actual Error description...'
	   ErrorNum=0
           RC=AREXXERROR_OK
           DO UNTIL RC=AREXXERROR_NoNextError
              bgeterror
              IF RC=AREXXERROR_OK THEN DO
                SAY '******************************** Error 'ErrorNum' *********************************'
                SAY result
              END
              ErrorNum=ErrorNum+1
              bnexterror
           END


           SAY 'Init Warning List Pointer to the first entry...'
           binitwarning
           SAY 'Get actual Warning description...'
	   WarningNum=0
           RC=AREXXERROR_OK
           DO UNTIL RC=AREXXERROR_NoNextWarning
              bgetwarning
              IF RC=AREXXERROR_OK THEN DO
                SAY '******************************** Warning 'WarningNum' *********************************'
                SAY result
              END
              WarningNum=WarningNum+1
              bnextWarning
           END

        END


	SAY '************************** Example 3 ************************'
	basm '-c'
	IF RC=AREXXERROR_NoSourceFile then SAY 'It would make sense if you would also specify a File name.'

	SAY 'Now...close BAsm.'
/*	bend*/
exit
