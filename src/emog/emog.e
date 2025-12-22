/* -- ----------------------------------------------------- -- *
 * -- Name........: emog.e                                  -- *
 * -- Description.: Main part of the converter.             -- *
 * -- Author......: Daniel Kasmeroglu                       -- *
 * -- E-Mail......: raptor@cs.tu-berlin.de                  -- *
 * --               daniel.kasmeroglu@daimlerchrysler.com   -- *
 * -- Date........: 07-Mar-00                               -- *
 * -- Version.....: 0.1                                     -- *
 * -- ----------------------------------------------------- -- */

/* -- ----------------------------------------------------- -- *
 * --                          Options                      -- *
 * -- ----------------------------------------------------- -- */

OPT LARGE


/* -- ----------------------------------------------------- -- *
 * --                          Modules                      -- *
 * -- ----------------------------------------------------- -- */

MODULE  '*scanner' ,
	'*parser'  ,
	'*egen'


/* -- ----------------------------------------------------- -- *
 * --                            Main                       -- *
 * -- ----------------------------------------------------- -- */

PROC main() HANDLE
DEF ma_tempout [20] : STRING
DEF ma_args         : PTR TO LONG
DEF ma_rdargs, ma_absy, ma_output

  WriteF( 'EMOG - E Module Generator (2000)\n' )
  WriteF( '(c) Written by Daniel Kasmeroglu\n' )

  ma_args   := [ NIL, NIL ]
  ma_rdargs := ReadArgs( 'SOURCE/A,DEST/A', ma_args, NIL )
  IF ma_rdargs = NIL
    WriteF( 'No args !\n' )
  ELSE

    -> Do the scanning stuff and parse the tokens
    scan( ma_args[0], ma_tempout )
    ma_absy   := parse( ma_tempout )

    -> Open the output file and throw the generated code in it.
    ma_output := Open( ma_args[1], NEWFILE )
    IF ma_output <> NIL

      -> Generate E module source.
      -> Here we can introduce alternative generators ;-)
      generateE( ma_absy, ma_args[0], ma_output )

      Close( ma_output )

    ELSE
      WriteF( 'Cannot open destination file !\n' )
    ENDIF

    FreeArgs( ma_rdargs )

  ENDIF

EXCEPT

  SELECT exception
  CASE "SCAN" ; WriteF( 'Error during scanning !\n' )
  CASE "PARS" ; WriteF( 'Error during parsing !\n'  )
  ENDSELECT

ENDPROC


/* -- ----------------------------------------------------- -- *
 * --                           Data                        -- *
 * -- ----------------------------------------------------- -- */

lab_version:
CHAR '$VER: EMOG 0.1 26-Feb-00', 0

