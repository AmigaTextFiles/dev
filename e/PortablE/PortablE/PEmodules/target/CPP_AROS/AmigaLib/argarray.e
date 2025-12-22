OPT NATIVE, INLINE
/*PUBLIC*/ MODULE 'target/amigalib'
MODULE 'icon', 'workbench/startup', 'workbench/workbench'
MODULE 'exec/types'

PROC argArrayInit(/*str=NIL*/) IS NATIVE {ArgArrayInit( main_argc , (UBYTE**) main_argv )} ENDNATIVE !!ARRAY OF ARRAY OF UBYTE
PROC argArrayDone() IS NATIVE {ArgArrayDone()} ENDNATIVE
PROC argString(tt:ARRAY OF ARRAY OF UBYTE, entry:/*STRPTR*/ ARRAY OF CHAR, defaultstring:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {ArgString(} tt {,} entry {,} defaultstring {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
PROC argInt(tt:ARRAY OF ARRAY OF UBYTE, entry:/*STRPTR*/ ARRAY OF CHAR, defaultVal:VALUE) IS NATIVE {ArgInt(} tt {,} entry {,} defaultVal {)} ENDNATIVE !!VALUE
