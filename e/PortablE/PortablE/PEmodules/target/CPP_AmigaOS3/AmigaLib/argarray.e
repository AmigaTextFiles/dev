OPT NATIVE, INLINE
/*PUBLIC*/ MODULE 'target/amigalib'
MODULE 'icon', 'workbench/startup', 'workbench/workbench'

PROC argArrayInit(/*str=NIL*/) IS NATIVE {ArgArrayInit( main_argc , (const char**) main_argv )} ENDNATIVE !!ARRAY OF /*STRPTR*/ ARRAY OF CHAR
PROC argArrayDone( ) IS NATIVE {ArgArrayDone()} ENDNATIVE
PROC argString( tt:ARRAY OF /*CONST_STRPTR*/ ARRAY OF CHAR, entry:/*CONST_STRPTR*/ ARRAY OF CHAR, defaultstring:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ArgString( (const char**)} tt {,} entry {,} defaultstring {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
PROC argInt( tt:ARRAY OF /*CONST_STRPTR*/ ARRAY OF CHAR, entry:/*CONST_STRPTR*/ ARRAY OF CHAR, defaultval:VALUE ) IS NATIVE {ArgInt( (const char**)} tt {,} entry {,} defaultval {)} ENDNATIVE !!VALUE
