/* SRIOpen for SRI V1.00 and Cygnus Ed Professional 2.xx */

IF ~SHOW('Libraries','rexxsupport.library') THEN
 IF ~addlib('rexxsupport.library',0,-30,0) THEN
  DO
   SAY "Can't open RexxSupport Library !"
   EXIT 20
  END

/* Load CED if not present */

IF ~SHOW('Ports','rexx_ced') THEN
 DO
  ADDRESS 'COMMAND' 'CED -r'
  FoundCED=0
  DO Counter=1 TO 10 WHILE ~FoundCED
   CALL DELAY 50
   FoundCED=SHOW('Ports','rexx_ced')
  END
  IF ~FoundCED THEN
   DO
    SAY "Can't load CED !"
    EXIT 10
   END
 END

/* Check wether we've to open a new view */

ELSE
 IF ~SHOWLIST('W','DormantCygnusEd') THEN
  DO
   ADDRESS 'rexx_ced' 'OPEN NEW'
   ADDRESS 'rexx_ced' 'CEDTOFRONT'
  END

/* Load File into CED */

PARSE ARG Filename
ADDRESS 'rexx_ced' 'OPEN '||Filename
