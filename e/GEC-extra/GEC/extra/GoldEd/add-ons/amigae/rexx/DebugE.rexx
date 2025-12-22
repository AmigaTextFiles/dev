/* $VER: DebugE.ged v0.5 (01.2.98)
   © 1994 by Leon Woestenberg
   Update 1998 by Grio

   Usage: Call from GoldED with the pathname of EDBG as the argument.
*/

ARG debugger

OPTIONS RESULTS

IF (debugger=='') THEN DO
  SAY 'USAGE: < EDBG full path >'
  EXIT
END

IF (LEFT(ADDRESS(), 6) ~= "GOLDED") THEN ADDRESS 'GOLDED.1'
'LOCK CURRENT RELEASE=4'
IF rc THEN EXIT

SIGNAL ON SYNTAX

'QUERY FILE VAR FILE'
'QUERY PATH VAR PATH'
IF (UPPER(RIGHT(file,2))~='.E') THEN
  'REQUEST STATUS="Source has no .e extension."'
ELSE DO
  PARSE VAR file nosuffix '.e'
  args=''
  'REQUEST STRING TITLE="DebugE Request" BODY="Enter arguments" VAR ARGS'
  'REQUEST STATUS="Debugger invoked."'
  IF (args=='') THEN
     opts=''
  ELSE
     opts='ARG' args
  filedeb = path || nosuffix
  'DIR CURRENT'
  ADDRESS COMMAND debugger filedeb opts
END
SYNTAX:
'UNLOCK'
EXIT
