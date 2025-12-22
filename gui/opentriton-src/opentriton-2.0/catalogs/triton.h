#ifndef CATALOGS_TRITON_H
#define CATALOGS_TRITON_H


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

#define MSG_SYSTEMREQUEST_TITLE 0
#define MSG_ERROR_UNKNOWN 1
#define MSG_ERROR_ALLOCMEM 2
#define MSG_ERROR_OPENWINDOW 3
#define MSG_ERROR_WINDOWTOOBIG 4
#define MSG_ERROR_DRAWINFO 5
#define MSG_ERROR_OPENFONT 6
#define MSG_ERROR_CREATEMSGPORT 7
#define MSG_ERROR_INSTALLOBJECT 8
#define MSG_ERROR_CREATECLASS 9
#define MSG_ERROR_NOLOCKPUBSCREEN 10
#define MSG_ERROR_CREATEMENUS 11
#define MSG_ERROR_GADGETCONTEXT 12

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_SYSTEMREQUEST_TITLE_STR "System request"
#define MSG_ERROR_UNKNOWN_STR "Triton failed for unknown reason"
#define MSG_ERROR_ALLOCMEM_STR "Can't allocate memory"
#define MSG_ERROR_OPENWINDOW_STR "Can't open window"
#define MSG_ERROR_WINDOWTOOBIG_STR "The window would become too big (even with fallback)"
#define MSG_ERROR_DRAWINFO_STR "Can't get the screen's DrawInfo"
#define MSG_ERROR_OPENFONT_STR "Can't open font"
#define MSG_ERROR_CREATEMSGPORT_STR "Can't create message port"
#define MSG_ERROR_INSTALLOBJECT_STR "Can't install object"
#define MSG_ERROR_CREATECLASS_STR "Can't create class"
#define MSG_ERROR_NOLOCKPUBSCREEN_STR "Can't lock public screen"
#define MSG_ERROR_CREATEMENUS_STR "Can't create menus"
#define MSG_ERROR_GADGETCONTEXT_STR "Can't create gadget context"

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
    {MSG_SYSTEMREQUEST_TITLE,(STRPTR)MSG_SYSTEMREQUEST_TITLE_STR},
    {MSG_ERROR_UNKNOWN,(STRPTR)MSG_ERROR_UNKNOWN_STR},
    {MSG_ERROR_ALLOCMEM,(STRPTR)MSG_ERROR_ALLOCMEM_STR},
    {MSG_ERROR_OPENWINDOW,(STRPTR)MSG_ERROR_OPENWINDOW_STR},
    {MSG_ERROR_WINDOWTOOBIG,(STRPTR)MSG_ERROR_WINDOWTOOBIG_STR},
    {MSG_ERROR_DRAWINFO,(STRPTR)MSG_ERROR_DRAWINFO_STR},
    {MSG_ERROR_OPENFONT,(STRPTR)MSG_ERROR_OPENFONT_STR},
    {MSG_ERROR_CREATEMSGPORT,(STRPTR)MSG_ERROR_CREATEMSGPORT_STR},
    {MSG_ERROR_INSTALLOBJECT,(STRPTR)MSG_ERROR_INSTALLOBJECT_STR},
    {MSG_ERROR_CREATECLASS,(STRPTR)MSG_ERROR_CREATECLASS_STR},
    {MSG_ERROR_NOLOCKPUBSCREEN,(STRPTR)MSG_ERROR_NOLOCKPUBSCREEN_STR},
    {MSG_ERROR_CREATEMENUS,(STRPTR)MSG_ERROR_CREATEMENUS_STR},
    {MSG_ERROR_GADGETCONTEXT,(STRPTR)MSG_ERROR_GADGETCONTEXT_STR},
};

#endif /* CATCOMP_ARRAY */


/****************************************************************************/


#ifdef CATCOMP_BLOCK

static const char CatCompBlock[] =
{
    "\x00\x00\x00\x00\x00\x10"
    MSG_SYSTEMREQUEST_TITLE_STR "\x00\x00"
    "\x00\x00\x00\x01\x00\x22"
    MSG_ERROR_UNKNOWN_STR "\x00\x00"
    "\x00\x00\x00\x02\x00\x16"
    MSG_ERROR_ALLOCMEM_STR "\x00"
    "\x00\x00\x00\x03\x00\x12"
    MSG_ERROR_OPENWINDOW_STR "\x00"
    "\x00\x00\x00\x04\x00\x36"
    MSG_ERROR_WINDOWTOOBIG_STR "\x00\x00"
    "\x00\x00\x00\x05\x00\x20"
    MSG_ERROR_DRAWINFO_STR "\x00"
    "\x00\x00\x00\x06\x00\x10"
    MSG_ERROR_OPENFONT_STR "\x00"
    "\x00\x00\x00\x07\x00\x1A"
    MSG_ERROR_CREATEMSGPORT_STR "\x00"
    "\x00\x00\x00\x08\x00\x16"
    MSG_ERROR_INSTALLOBJECT_STR "\x00\x00"
    "\x00\x00\x00\x09\x00\x14"
    MSG_ERROR_CREATECLASS_STR "\x00\x00"
    "\x00\x00\x00\x0A\x00\x1A"
    MSG_ERROR_NOLOCKPUBSCREEN_STR "\x00\x00"
    "\x00\x00\x00\x0B\x00\x14"
    MSG_ERROR_CREATEMENUS_STR "\x00\x00"
    "\x00\x00\x00\x0C\x00\x1C"
    MSG_ERROR_GADGETCONTEXT_STR "\x00"
};

#endif /* CATCOMP_BLOCK */


/****************************************************************************/


struct LocaleInfo
{
    APTR li_LocaleBase;
    APTR li_Catalog;
};


#include <dos.h>
STRPTR __asm GetString(register __a0 struct LocaleInfo *li,register __d0 ULONG id);


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

#define XLocaleBase LocaleBase
#define LocaleBase li->li_LocaleBase
    
    if (LocaleBase)
        return(GetCatalogStr(li->li_Catalog,stringNum,builtIn));
#define LocaleBase XLocaleBase
#undef XLocaleBase

    return(builtIn);
}


#endif /* CATCOMP_CODE */


/****************************************************************************/


#endif /* CATALOGS_TRITON_H */
