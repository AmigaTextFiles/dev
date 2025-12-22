/* Change MODULE '*stringf20' to whatever is appropriate for your system. */
OPT OSVERSION=39  /* you won't need this if you do the above.  */
OPT MODULE
MODULE '*stringf20'
EXPORT PROC writef(format,streamptr=NIL:PTR TO LONG)
DEF s[240]:STRING
stringf(s,format,streamptr)
PutStr(s)
ENDPROC D0
