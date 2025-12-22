/*
    This little program assembles file using snma arexx host
    It is quite similar to the Shell interface of SNMA.
    If you want to pass in more argumets enclose them to quotes ("like this").
    Feel free to add more commandline arguments in ASM command to fullfil
    your needs.
*/

if arg() ~= 1 THEN  DO
    say 'Usage: rx addgb.rexx "CMDLINE"'
    exit    5
    end
arg cmd
address SNMA
call Assemble(cmd)
call DisplayErrors
call DisplayWarnings
call DisplayInfo
'FREE'                      /* free source, errors...*/
exit


/*
   Following routine will assemble and display information about it
   This one takes one argument , commandline
*/
Assemble:

  options RESULTS
  arg cmd
  cmd=strip(cmd,B,'"')            /* strip leading and trailing "s */
  mydir=pragma('d')
  mydir=insert('"',mydir,0)
  mydir=insert('"',mydir,length(mydir))
  CHDIR mydir			  /* change the current directory of the snma */
  say "Calling SNMA: ADDGB" cmd
  ADDGB cmd			  /* AddGlobal */
  INFO STAT			  /* get status information */
  say "Err:" STAT.ERRORS "warn:" STAT.WARNINGS
return	/* End of Assemble */

DisplayInfo:

  say 'Result:' STAT.STATUS'.' STAT.LINES 'lines assembled.'

  if STAT.STATUS = 'FAIL' THEN say 'Failure: ' STAT.FAILSTR
     ELSE

      if STAT.ERRORS > 1 THEN say STAT.ERRORS 'Errors'
	  ELSE
	      if STAT.ERRORS = 1 THEN say STAT.ERRORS 'Error'
		  ELSE say 'No errors'

      if STAT.WARNINGS > 1 THEN say STAT.WARNINGS 'Warnings'
	  ELSE
	      if STAT.WARNINGS = 1 THEN say STAT.WARNINGS 'Warning'
		 ELSE say 'No Warnings'

      say STAT.CODE 'code hunks. Total ' STAT.CODESIZE 'bytes'
      say STAT.DATA 'data hunks. Total ' STAT.DATASIZE 'bytes'
      say STAT.BSS  'bss hunks. Total ' STAT.BSSSIZE 'bytes'
return	/* end of displayinfo */


/* following code displays all errors */
DisplayErrors:
enum = 1
if STAT.ERRORS > 0 THEN say "Errors..."
do while enum <= STAT.ERRORS
    GETERR enum STEM UUR
    say '================================================================= '
    say UUR.ERRTXT 'in line' UUR.LINENUM 'of file' UUR.FILENAME
    say UUR.LINETXT
    say insert(' ','^',0,UUR.COLUMN-1)
    enum=enum+1
    end
return /* end of Display Errors */

/* following code displays all warnings */
DisplayWarnings:
enum = 1
if STAT.WARNINGS > 0 THEN say "Warnings..."
do while enum <= STAT.WARNINGS
    GETERR enum STEM UUR WARN
    say '================================================================= '
    say UUR.ERRTXT 'in line' UUR.LINENUM 'of file' UUR.FILENAME
    say UUR.LINETXT
    say insert(' ','^',0,UUR.COLUMN-1)
    enum=enum+1
    end
return /* end of DisplayWarnings */
