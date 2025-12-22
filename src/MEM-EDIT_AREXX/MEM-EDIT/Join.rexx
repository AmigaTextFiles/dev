
/* A DEMO simple file joining utility to join at least two files together. */
/* Original idea copyright, (C)2009, B.Walker. G0LCU. */
/* Issued as Public Domain and you can do as you please with this code. */

/* To join addresses together start with the highest HEX dump */
/* first and work downwards. */

/* Similarly with textfiles 'Last In First Out'... :) */

/* Pick the last, (address?), file needed from the S: VOLUME... */
/* IMPORTANT!!! DURING THE CURRENT SESION IF 'S:BINARY.BIN' EXISTS THEN */
/* THIS BECOMES THE NEW LAST ADDRESS/FILE!!! */

/* Set up any variables... */
  quitkey = ''

/* Use default window for prompts... */
/* This will loop to generate a manual binary dump... */
  DO FOREVER
    ECHO 'c'x
    ECHO '$VER: Join.rexx_Version_00-00-22_Public_Domain_13-06-2009_B.Walker_G0LCU.'
    ECHO 'Double click on the first file to join...'
    ECHO ''
    ADDRESS COMMAND 'C:Join `C:RequestFile DRAWER S: FILE Startup-Sequence` AS S:TEMPFILE'
    ECHO 'File saved as S:TEMPFILE...'
    ECHO ''
/* Now pick the next lower or earlier, (address?), file from the S: VOLUME... */
    ECHO 'Double click on the next file to join...'
    ADDRESS COMMAND 'C:Join `C:RequestFile DRAWER S: FILE Startup-Sequence` S:TEMPFILE AS S:BINARY.BIN'
    ECHO ''
    ECHO 'File saved as S:BINARY.BIN...'
    ECHO ''
    OPTIONS PROMPT 'Press <RETURN/ENTER> to CONTINUE, or, Q<RETURN/ENTER> to QUIT:- '
    PARSE UPPER PULL quitkey
    IF quitkey = 'Q' THEN CALL getout
  END

getout:
  ECHO 'c'x
/* Copy the file 'S:BINARY.BIN' to the 'T:' VOLUME as 'T:BINARY.BIN'... */
  ADDRESS COMMAND 'C:Copy S:BINARY.BIN TO T:BINARY.BIN'
  ECHO 'Files now joined as T:BINARY.BIN...'
  ECHO ''
  ECHO 'Delete the S:TEMPFILE file...'
/* Delete the temporary file 'S:TEMPFILE'... */
  ADDRESS COMMAND 'C:Delete S:TEMPFILE QUIET'
  ECHO 'Delete the S:BINARY.BIN file...'
/* Delete the temporary file 'S:BINARY.BIN'... */
  ADDRESS COMMAND 'C:Delete S:BINARY.BIN QUIET'
  ECHO ''
  ECHO 'Quitting...'
  ADDRESS COMMAND 'C:Wait 2'
/* Clean exit... */
  EXIT(0)
