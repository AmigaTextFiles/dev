/* SRIShowError for SRI V1.00 and Cygnus Ed Professional 2.xx */

PARSE ARG Filename Number Message
ADDRESS 'rexx_ced'

/* switch to corrosponding file */

'JUMP TO FILE '||Filename

/* Goto line */

IF Number~=0 THEN 'JUMP TO LINE '||Number

/* Display Error Message */

'OKAY1 '||Message
