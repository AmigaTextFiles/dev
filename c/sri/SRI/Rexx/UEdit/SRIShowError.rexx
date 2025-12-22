/* LseShowError for LSE V0.92 and UEdit V2.6 */

PARSE ARG Filename Number Message
ADDRESS 'URexx'
/* switch to corrosponding file */

'loadfile'||Filename

/* Goto line */

IF Number~=0 THEN 'gotoline '||Number

/* Display Error Message */

'message'||Message
