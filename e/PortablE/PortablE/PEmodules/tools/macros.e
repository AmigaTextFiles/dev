/* This modules contains some missing 'macros' implemented as functions
   as E doesn't support macros
*/

OPT MODULE

MODULE 'graphics/rastport', 'exec/types'

/* Some intuition 'macros' */

PROC menunum(x) IS x AND $1F

PROC itemnum(x) IS Shr(x,5) AND $3F

PROC subnum(x) IS Shr(x,11) AND $1F


/* A graphic 'macro' */

PROC setdrpt(rport:PTR TO rastport,no:UINT)
 rport.lineptrn:=no
 rport.flags:=rport.flags OR FRST_DOT
 rport.linpatcnt:=15
ENDPROC
