-> 16:16 fixed point routines

OPT MODULE
OPT EXPORT

PROC fixedtofloat(x) IS x!/65536.0
PROC floattofixed(x) IS !x*65536.0!
PROC fixedtoint(x) IS Shr(x, 16) AND $FFFF	-> swap d0; ext.l d0 ...
PROC inttofixed(x) IS Shl(x AND $FFFF, 16)	-> swap d0; clr.w d0 ...
