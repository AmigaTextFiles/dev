OPT NATIVE, INLINE
MODULE 'icon', 'workbench/startup', 'workbench/workbench'
{MODULE 'amigalib/argarray'}

NATIVE {argArrayInit} PROC
PROC argArrayInit(str=NIL) IS NATIVE {argArrayInit(} str {)} ENDNATIVE !!ARRAY OF /*STRPTR*/ ARRAY OF CHAR
NATIVE {argArrayDone} PROC
PROC argArrayDone( ) IS NATIVE {argArrayDone()} ENDNATIVE
NATIVE {argString} PROC
PROC argString( tt:ARRAY OF /*CONST_STRPTR*/ ARRAY OF CHAR, entry:/*CONST_STRPTR*/ ARRAY OF CHAR, defaultstring:/*CONST_STRPTR*/ ARRAY OF CHAR ) IS NATIVE {argString(} tt {,} entry {,} defaultstring {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {argInt} PROC
PROC argInt( tt:ARRAY OF /*CONST_STRPTR*/ ARRAY OF CHAR, entry:/*CONST_STRPTR*/ ARRAY OF CHAR, defaultval:VALUE ) IS NATIVE {argInt(} tt {,} entry {,} defaultval {)} ENDNATIVE !!VALUE
