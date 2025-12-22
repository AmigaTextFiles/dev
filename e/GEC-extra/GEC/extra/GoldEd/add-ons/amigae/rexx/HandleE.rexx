/* $VER: HandleE.ged v1.2a (13.06.99)
   © 1998-1999 by Grio
*/


OPTIONS RESULTS

IF (LEFT(ADDRESS(), 6) ~= "GOLDED") THEN ADDRESS 'GOLDED.1'
'LOCK CURRENT RELEASE=4'

IF rc THEN EXIT

SIGNAL ON SYNTAX

'QUERY DOC VAR FILEPATH'
IF (UPPER(RIGHT(filepath,2))~='.E') THEN
  'REQUEST STATUS="Source has no .e extension."'
ELSE DO
  PARSE VAR filepath nosuffix '.e'
  gadgets = ' _Nothing | _Move | _Delete | _RunExe'
  module = 2
  IF EXISTS(nosuffix) THEN
     module = 0
  ELSE DO
     IF ~EXISTS(nosuffix'.m') THEN
    'REQUEST STATUS="Hey! You need executable or module!"'
     ELSE DO
    gadgets = ' _Nothing | _Move | _Delete | _Nothing '
    module = 1
    nosuffix = nosuffix'.m'
     END
  END
  IF ~(module==2) THEN DO
    actionrun = 1
    'REQUEST TITLE="HandExeE Request" BODY="Choose option" BUTTON "' gadgets '" VAR ACTIONRUN'
    IF (actionrun==0) THEN DO
       actionrun=1
       IF (module==0) THEN DO
      fileargs=''
      'REQUEST TITLE="HandExeE Request" BODY="  Enter arguments  " STRING VAR FILEARGS'
      IF ~(rc==5) THEN DO
         'REQUEST STATUS="Exe runed ..."'
         'RUN ASYNC CMD' nosuffix fileargs
      END
       END
    END
    IF (actionrun==2) THEN DO
       'REQUEST FILE SAVE TITLE="Move file..." VAR DESTFILE PATH=' || nosuffix
       IF (rc==5) THEN
      actionrun=1
       ELSE DO
      IF (destfile~=nosuffix) THEN DO
         'REQUEST STATUS="File moved ..."'
         ADDRESS COMMAND 'C:Copy' nosuffix destfile
      END
       END
    END
    IF (actionrun==3) THEN
       'REQUEST STATUS="Exe deleted ..."'
    IF (actionrun~=1) THEN
       'FILE DELETE FORCE NAME=' || nosuffix
  END
END

SYNTAX:
'UNLOCK'
EXIT

