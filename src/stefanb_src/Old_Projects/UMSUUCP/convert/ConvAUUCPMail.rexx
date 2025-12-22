/*
 * Convert mail folders from AmigaUUCP to UMS
 */

/* Check parameters */
PARSE ARG cmdline
IF (WORDS(cmdline) < 2) THEN
 DO
  SAY "Usage: ConvAUUCPMail <node> <user>"
  CALL Cleanup
  EXIT 20
 END

/* Get arguments */
PARSE ARG node user .
SAY "Importing mail folder of user '" || user || "' into UMS as user 'uucp." || node || "'"

/* Open mail folder */
IF (OPEN(folder,"UUMAIL:" || user,'R') = 0) THEN
 DO
  SAY "Mail folder for user '" || user || "' not found!"
  CALL Cleanup
  EXIT 20
 END

/* Create UUCP command file */
tmpcmdfile = "T:cmd" || RANDU(TIME('S'))
IF (OPEN(file,tmpcmdfile,'W')) THEN
 DO
  CALL WRITELN(file,"U daemon" node)
  CALL WRITELN(file,"F D")
  CALL WRITELN(file,"C rmail" user)
  CALL CLOSE(file)
 END
ELSE
 DO
  SAY "Couldn't create UUCP command file '" || tmpcmdfile || "'!"
  CALL Cleanup
  EXIT 20
 END

/* Read first line from mail folder */
folderline = READLN(folder);

/* Import mail messages */
DO WHILE (EOF(folder) = 0)

 /* Open data file */
 IF (OPEN(datafile,"UUSPOOL:D",'W') = 0) THEN
  DO
   SAY "Couldn't create UUCP data file 'UUSPOOL:D'!"
   CALL Cleanup(tmpcmdfile)
   EXIT 20
  END

 /* Read next mail from folder and write it into the data file */
 DO WHILE (EOF(folder) = 0)

  /* Write folder line to data file */
  CALL WRITELN(datafile,folderline)

  /* Read next folder line */
  folderline = READLN(folder)

  /* Begin of next mail? */
  IF (LEFT(folderline,5) == "From ") THEN LEAVE /* Yes, process current mail */

 END

 /* The data file does now contain a complete mail */
 CALL CLOSE(datafile)

 /* Import mail */
 ADDRESS COMMAND "Copy" tmpcmdfile "UUSPOOL:X.1"
 ADDRESS COMMAND "uuxqt"
END

/* All mails processed */
CALL Cleanup(tmpcmdfile)
SAY "Finished."
RETURN 0

/* Cleanup */
Cleanup: PROCEDURE
ADDRESS COMMAND "Delete >NIL: UUSPOOL:D UUSPOOL:X.1" ARG(1) "QUIET"
RETURN
