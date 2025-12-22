#ifndef RECALL_LOCALE_H
#define RECALL_LOCALE_H


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

#define MSG_DESCRIPTION 0
#define MSG_NOTIFF 1
#define MSG_IFFERROR 2
#define MSG_FILENOTFOUND 3
#define MSG_STILLACTIVE 4
#define MSG_ALERTCONFIRM 5
#define MSG_EXECUTEEVENT 6
#define MSG_SENDAREXXCOMMAND 7
#define MSG_GENERATEINPUT 8
#define MSG_OK 9
#define MSG_POSTPONE 10
#define MSG_CANCEL 11
#define MSG_YES 12
#define MSG_NO 13
#define MSG_OUTOFMEMORY 14

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_DESCRIPTION_STR "The ultimate reminder program!"
#define MSG_NOTIFF_STR "Not a Recall IFF file!"
#define MSG_IFFERROR_STR "IFFfile scan aborted: File is corrupt!"
#define MSG_FILENOTFOUND_STR "'%s'\nnot found!"
#define MSG_STILLACTIVE_STR "Can't quit now,\n%ld Workbench tools running."
#define MSG_ALERTCONFIRM_STR "\n\nLeft mousebutton=OK                         Right mousebutton=Cancel"
#define MSG_EXECUTEEVENT_STR "Execute event?\n%s"
#define MSG_SENDAREXXCOMMAND_STR "Send AREXX command?\n%s"
#define MSG_GENERATEINPUT_STR "Generate input?\n%s"
#define MSG_OK_STR "OK"
#define MSG_POSTPONE_STR "|Postpone"
#define MSG_CANCEL_STR "|Cancel"
#define MSG_YES_STR "Yes"
#define MSG_NO_STR "|No"
#define MSG_OUTOFMEMORY_STR "Out of memory!"

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
    {MSG_DESCRIPTION,(STRPTR)MSG_DESCRIPTION_STR},
    {MSG_NOTIFF,(STRPTR)MSG_NOTIFF_STR},
    {MSG_IFFERROR,(STRPTR)MSG_IFFERROR_STR},
    {MSG_FILENOTFOUND,(STRPTR)MSG_FILENOTFOUND_STR},
    {MSG_STILLACTIVE,(STRPTR)MSG_STILLACTIVE_STR},
    {MSG_ALERTCONFIRM,(STRPTR)MSG_ALERTCONFIRM_STR},
    {MSG_EXECUTEEVENT,(STRPTR)MSG_EXECUTEEVENT_STR},
    {MSG_SENDAREXXCOMMAND,(STRPTR)MSG_SENDAREXXCOMMAND_STR},
    {MSG_GENERATEINPUT,(STRPTR)MSG_GENERATEINPUT_STR},
    {MSG_OK,(STRPTR)MSG_OK_STR},
    {MSG_POSTPONE,(STRPTR)MSG_POSTPONE_STR},
    {MSG_CANCEL,(STRPTR)MSG_CANCEL_STR},
    {MSG_YES,(STRPTR)MSG_YES_STR},
    {MSG_NO,(STRPTR)MSG_NO_STR},
    {MSG_OUTOFMEMORY,(STRPTR)MSG_OUTOFMEMORY_STR},
};

#endif /* CATCOMP_ARRAY */


/****************************************************************************/


#ifdef CATCOMP_BLOCK

static const char CatCompBlock[] =
{
    "\x00\x00\x00\x00\x00\x20"
    MSG_DESCRIPTION_STR "\x00\x00"
    "\x00\x00\x00\x01\x00\x18"
    MSG_NOTIFF_STR "\x00\x00"
    "\x00\x00\x00\x02\x00\x28"
    MSG_IFFERROR_STR "\x00\x00"
    "\x00\x00\x00\x03\x00\x10"
    MSG_FILENOTFOUND_STR "\x00"
    "\x00\x00\x00\x04\x00\x2E"
    MSG_STILLACTIVE_STR "\x00\x00"
    "\x00\x00\x00\x05\x00\x48"
    MSG_ALERTCONFIRM_STR "\x00\x00"
    "\x00\x00\x00\x06\x00\x12"
    MSG_EXECUTEEVENT_STR "\x00"
    "\x00\x00\x00\x07\x00\x18"
    MSG_SENDAREXXCOMMAND_STR "\x00\x00"
    "\x00\x00\x00\x08\x00\x14"
    MSG_GENERATEINPUT_STR "\x00\x00"
    "\x00\x00\x00\x09\x00\x04"
    MSG_OK_STR "\x00\x00"
    "\x00\x00\x00\x0A\x00\x0A"
    MSG_POSTPONE_STR "\x00"
    "\x00\x00\x00\x0B\x00\x08"
    MSG_CANCEL_STR "\x00"
    "\x00\x00\x00\x0C\x00\x04"
    MSG_YES_STR "\x00"
    "\x00\x00\x00\x0D\x00\x04"
    MSG_NO_STR "\x00"
    "\x00\x00\x00\x0E\x00\x10"
    MSG_OUTOFMEMORY_STR "\x00\x00"
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


#endif /* RECALL_LOCALE_H */
