#ifndef APP_STRINGS_H
#define APP_STRINGS_H


/****************************************************************************/


/* This file was created automatically by CatComp.
 * Do NOT edit by hand!
 */


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifdef CATCOMP_ARRAY
#undef CATCOMP_NUMBERS
#undef CATCOMP_STRINGS
#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#endif

#ifdef CATCOMP_BLOCK
#undef CATCOMP_STRINGS
#define CATCOMP_STRINGS
#endif


/****************************************************************************/


#ifdef CATCOMP_NUMBERS

#define MSG_OK 0
#define MSG_REQTITLE 1
#define MSG_ERR_LIB 2
#define MSG_ERR_SHELL 3
#define MSG_ERR_WB 4
#define MSG_ERR_RAM 5
#define MSG_ERR_TOOLTYPES 6
#define MSG_ERR_READARGS 7
#define MSG_ERR_OPEN 8
#define MSG_SWAP_DEMO 9

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_OK_STR "OK"
#define MSG_REQTITLE_STR "Problem"
#define MSG_ERR_LIB_STR "Couldn't open %s %ld\n"
#define MSG_ERR_SHELL_STR "Application can't be started from Shell\n"
#define MSG_ERR_WB_STR "Application can't be started from Workbench\n"
#define MSG_ERR_RAM_STR "Couldn't allocate RAM in function %s\n"
#define MSG_ERR_TOOLTYPES_STR "Couldn't read tooltypes\n"
#define MSG_ERR_READARGS_STR "Couldn't read command line arguments\n"
#define MSG_ERR_OPEN_STR "Couldn't open stream %s\n"
#define MSG_SWAP_DEMO_STR "String %s and value %ld\n"

#endif /* CATCOMP_STRINGS */


/****************************************************************************/


#ifdef CATCOMP_ARRAY

struct CatCompArrayType
{
    LONG   cca_ID;
    STRPTR cca_Str;
};

static const struct CatCompArrayType CatCompArray[] =
{
    {MSG_OK,(STRPTR)MSG_OK_STR},
    {MSG_REQTITLE,(STRPTR)MSG_REQTITLE_STR},
    {MSG_ERR_LIB,(STRPTR)MSG_ERR_LIB_STR},
    {MSG_ERR_SHELL,(STRPTR)MSG_ERR_SHELL_STR},
    {MSG_ERR_WB,(STRPTR)MSG_ERR_WB_STR},
    {MSG_ERR_RAM,(STRPTR)MSG_ERR_RAM_STR},
    {MSG_ERR_TOOLTYPES,(STRPTR)MSG_ERR_TOOLTYPES_STR},
    {MSG_ERR_READARGS,(STRPTR)MSG_ERR_READARGS_STR},
    {MSG_ERR_OPEN,(STRPTR)MSG_ERR_OPEN_STR},
    {MSG_SWAP_DEMO,(STRPTR)MSG_SWAP_DEMO_STR},
};

#endif /* CATCOMP_ARRAY */


/****************************************************************************/


#ifdef CATCOMP_BLOCK

static const char CatCompBlock[] =
{
    "\x00\x00\x00\x00\x00\x04"
    MSG_OK_STR "\x00\x00"
    "\x00\x00\x00\x01\x00\x08"
    MSG_REQTITLE_STR "\x00"
    "\x00\x00\x00\x02\x00\x16"
    MSG_ERR_LIB_STR "\x00"
    "\x00\x00\x00\x03\x00\x2A"
    MSG_ERR_SHELL_STR "\x00\x00"
    "\x00\x00\x00\x04\x00\x2E"
    MSG_ERR_WB_STR "\x00\x00"
    "\x00\x00\x00\x05\x00\x26"
    MSG_ERR_RAM_STR "\x00"
    "\x00\x00\x00\x06\x00\x1A"
    MSG_ERR_TOOLTYPES_STR "\x00\x00"
    "\x00\x00\x00\x07\x00\x26"
    MSG_ERR_READARGS_STR "\x00"
    "\x00\x00\x00\x08\x00\x1A"
    MSG_ERR_OPEN_STR "\x00\x00"
    "\x00\x00\x00\x09\x00\x1A"
    MSG_SWAP_DEMO_STR "\x00\x00"
};

#endif /* CATCOMP_BLOCK */


/****************************************************************************/


struct LocaleInfo
{
    APTR li_LocaleBase;
    APTR li_Catalog;
};


#ifdef CATCOMP_CODE

STRPTR GetString(struct LocaleInfo *li, LONG stringNum)
{
LONG   *l;
UWORD  *w;
STRPTR  builtIn;

    l = (LONG *)CatCompBlock;

    while (*l != stringNum)
    {
        w = (UWORD *)((ULONG)l + 4);
        l = (LONG *)((ULONG)l + (ULONG)*w + 6);
    }
    builtIn = (STRPTR)((ULONG)l + 6);

#undef LocaleBase
#define LocaleBase li->li_LocaleBase
    
    if (LocaleBase)
        return(GetCatalogStr(li->li_Catalog,stringNum,builtIn));
#undef LocaleBase

    return(builtIn);
}


#endif /* CATCOMP_CODE */


/****************************************************************************/


#endif /* APP_STRINGS_H */
