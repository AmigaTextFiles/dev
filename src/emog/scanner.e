/* -- ----------------------------------------------------- -- *
 * -- Name........: scanner.e                               -- *
 * -- Description.: This module takes over the lexical part -- *
 * --               of the conversion process. It uses an   -- *
 * --               external binary generated with "flex".  -- *
 * -- Author......: Daniel Kasmeroglu                       -- *
 * -- E-Mail......: raptor@cs.tu-berlin.de                  -- *
 * --               daniel.kasmeroglu@daimlerchrysler.com   -- *
 * -- Date........: 05-Mar-00                               -- *
 * -- Version.....: 0.1                                     -- *
 * -- ----------------------------------------------------- -- */

/* -- ----------------------------------------------------- -- *
 * --                          Options                      -- *
 * -- ----------------------------------------------------- -- */

OPT MODULE


/* -- ----------------------------------------------------- -- *
 * --                          Modules                      -- *
 * -- ----------------------------------------------------- -- */

MODULE '*tools'


/* -- ----------------------------------------------------- -- *
 * --                         Functions                     -- *
 * -- ----------------------------------------------------- -- */

->> PROC scan()
->
-> SPEC   scan( source, dest )
-> DESC   Scans the sourcefile {source} and stores it under a
->        temporary path. Under {dest} a writable buffer must
->        be supplied, since the temporary destination will be
->        found here.
-> PRE    {source} : Path of the C-Header file
->        {dest}   : A valid buffer for keeping the
->                   path of the temporary file
-> POST   {dest}   : Path of a file containing a list of tokens.
->
EXPORT PROC scan( sca_source, sca_scanned )
DEF sca_command [20] : STRING
DEF sca_input, sca_output, sca_res

  -> Get a temporary file for storing our binary
  -> and write the executable.
  getTempFile( sca_command )
  IF writeFile( sca_command, {binary}, {endofbinary} - {binary} ) = FALSE
    Raise( "SCAN" )
  ENDIF

  -> Get a temporary file for our destination
  getTempFile( sca_scanned )

  -> Open source and destination
  sca_input  := Open( sca_source  , OLDFILE )
  sca_output := Open( sca_scanned , NEWFILE )
  IF (sca_input = NIL) OR (sca_output = NIL)

    -> Damn, something went wrong
    IF sca_input  <> NIL THEN Close( sca_input  )
    IF sca_output <> NIL THEN Close( sca_output )
    DeleteFile( sca_command )
    Raise( "SCAN" )

  ENDIF

  -> Small message
  WriteF( 'Scanning...\n' )

  -> The binary will be executed with proper
  -> input and output
  sca_res := Execute( sca_command, sca_input, sca_output )
  Close( sca_input  )
  Close( sca_output )

  DeleteFile( sca_command )

  IF sca_res = FALSE
    -> Problem occured during scanning, so delete
    -> the destination as it may contain invalid
    -> data.
    DeleteFile( sca_scanned )
    Raise( "SCAN" )
  ENDIF

ENDPROC
-><


/* -- ----------------------------------------------------- -- *
 * --                            Data                       -- *
 * -- ----------------------------------------------------- -- */

binary:
INCBIN 'scanner'
endofbinary:

