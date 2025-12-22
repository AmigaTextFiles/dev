/* $VER: utility.h 39.2 (18.9.1992) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/libraries'
{MODULE 'utility/utility'}

NATIVE {UTILITYNAME} CONST
#define UTILITYNAME utilityname
STATIC utilityname = 'utility.library'


NATIVE {utilitybase} OBJECT utilitybase
    {lib}	lib	:lib
    {language}	language	:UBYTE
    {reserved}	reserved	:UBYTE
ENDOBJECT
