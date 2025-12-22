/* Ces modules contiennent quelques 'macros' manquantes comme fonctions
   comme le E ne supporte pas les macros
*/

OPT MODULE

MODULE 'graphics/rastport'

/* Quelques 'macros' Intuition */

EXPORT PROC menunum(x) IS x AND $1F

EXPORT PROC itemnum(x) IS Shr(x,5) AND $3F

EXPORT PROC subnum(x) IS Shr(x,11) AND $1F


/* A graphic 'macro' */

EXPORT PROC setdrpt(rport:PTR TO rastport,no)
 rport.lineptrn:=no
 rport.flags:=rport.flags OR FRST_DOT
 rport.linpatcnt:=15
ENDPROC
