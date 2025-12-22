
#ifndef tipwindow_STRINGS_H
#define tipwindow_STRINGS_H

/****************************************************************

   This file was created automatically by `FlexCat 2.4 beta'
   from "Catalogs/tipwindow.cd"

   using CatComp.sd 1.2 (24.09.1999)

   Do NOT edit by hand!

****************************************************************/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifdef  tipwindow_BASIC_CODE
#undef  tipwindow_BASIC
#undef  tipwindow_CODE
#define tipwindow_BASIC
#define tipwindow_CODE
#endif

#ifdef  tipwindow_BASIC
#undef  tipwindow_ARRAY
#undef  tipwindow_BLOCK
#define tipwindow_ARRAY
#define tipwindow_BLOCK
#endif

#ifdef  tipwindow_ARRAY
#undef  tipwindow_NUMBERS
#undef  tipwindow_STRINGS
#define tipwindow_NUMBERS
#define tipwindow_STRINGS
#endif

#ifdef  tipwindow_BLOCK
#undef  tipwindow_STRINGS
#define tipwindow_STRINGS
#endif


#ifdef tipwindow_CODE
#include <proto/locale.h>
extern struct Library *LocaleBase;
#endif

#ifdef tipwindow_NUMBERS

#define MSG_WIN_TITLE 0
#define MSG_DO_YOU_KNOW 1
#define MSG_SHOW_TIPS 2
#define MSG_PREV 3
#define MSG_NEXT 4
#define MSG_BULB_HELP 5
#define MSG_SHOW_HELP 6
#define MSG_PREV_HELP 7
#define MSG_NEXT_HELP 8
#define MSG_RAND_HELP 9

#endif /* tipwindow_NUMBERS */


/****************************************************************************/


#ifdef tipwindow_STRINGS

#define MSG_WIN_TITLE_STR "Tip of the day..."
#define MSG_DO_YOU_KNOW_STR "\033b\0338Do you know..."
#define MSG_SHOW_TIPS_STR "_Show tips on startup"
#define MSG_PREV_STR "\033I[6:31]\033I[6:31] _Previous"
#define MSG_NEXT_STR "_Next \033I[6:30]\033I[6:30]"
#define MSG_BULB_HELP_STR "Click the bulb image to visit\n"\
	"TipOfTheDay class' homepage\n\n"\
	"\033bhttp://amiga.com.pl/mcc/\033n"
#define MSG_SHOW_HELP_STR "When enabled, the Tip Of The Day\n"\
	"will pop up on application startup"
#define MSG_PREV_HELP_STR "Shows previous Tip Of The Day\n"\
	"You can use cursor left key to\n"\
	"to reach same effect."
#define MSG_NEXT_HELP_STR "Shows next Tip Of The Day\n"\
	"You can use cursor right key to\n"\
	"to reach same effect."
#define MSG_RAND_HELP_STR "In fact, this is the button too.\n"\
	"When clicked, it shows randomly\n"\
	"chosen Tip Of The Day..."

#endif /* tipwindow_STRINGS */


/****************************************************************************/


#ifdef tipwindow_ARRAY

struct tipwindow_ArrayType
{
    LONG   cca_ID;
    STRPTR cca_Str;
};

static const struct tipwindow_ArrayType tipwindow_Array[] =
{
    { MSG_WIN_TITLE, (STRPTR)MSG_WIN_TITLE_STR },
    { MSG_DO_YOU_KNOW, (STRPTR)MSG_DO_YOU_KNOW_STR },
    { MSG_SHOW_TIPS, (STRPTR)MSG_SHOW_TIPS_STR },
    { MSG_PREV, (STRPTR)MSG_PREV_STR },
    { MSG_NEXT, (STRPTR)MSG_NEXT_STR },
    { MSG_BULB_HELP, (STRPTR)MSG_BULB_HELP_STR },
    { MSG_SHOW_HELP, (STRPTR)MSG_SHOW_HELP_STR },
    { MSG_PREV_HELP, (STRPTR)MSG_PREV_HELP_STR },
    { MSG_NEXT_HELP, (STRPTR)MSG_NEXT_HELP_STR },
    { MSG_RAND_HELP, (STRPTR)MSG_RAND_HELP_STR },
};


#endif /* tipwindow_ARRAY */


/****************************************************************************/


#ifdef tipwindow_BLOCK

static const char tipwindow_Block[] =
{

     "\x00\x00\x00\x00" "\x00\x12"
    MSG_WIN_TITLE_STR "\x00"
     "\x00\x00\x00\x01" "\x00\x12"
    MSG_DO_YOU_KNOW_STR ""
     "\x00\x00\x00\x02" "\x00\x16"
    MSG_SHOW_TIPS_STR "\x00"
     "\x00\x00\x00\x03" "\x00\x1a"
    MSG_PREV_STR ""
     "\x00\x00\x00\x04" "\x00\x16"
    MSG_NEXT_STR ""
     "\x00\x00\x00\x05" "\x00\x58"
    MSG_BULB_HELP_STR "\x00"
     "\x00\x00\x00\x06" "\x00\x44"
    MSG_SHOW_HELP_STR "\x00"
     "\x00\x00\x00\x07" "\x00\x52"
    MSG_PREV_HELP_STR ""
     "\x00\x00\x00\x08" "\x00\x50"
    MSG_NEXT_HELP_STR "\x00"
     "\x00\x00\x00\x09" "\x00\x5a"
    MSG_RAND_HELP_STR "\x00"

};

#endif /* tipwindow_BLOCK */


/****************************************************************************/


struct tipwindow_LocaleInfo
{
    APTR li_LocaleBase;
    APTR li_Catalog;
};



#ifdef tipwindow_CODE

#ifndef tipwindow_CODE_EXISTS
 #define tipwindow_CODE_EXISTS

 STRPTR GettipwindowString(struct tipwindow_LocaleInfo *li, LONG stringNum)
 {
 LONG   *l;
 UWORD  *w;
 STRPTR  builtIn;

     l = (LONG *)tipwindow_Block;

     while (*l != stringNum)
       {
       w = (UWORD *)((ULONG)l + 4);
       l = (LONG *)((ULONG)l + (ULONG)*w + 6);
       }
     builtIn = (STRPTR)((ULONG)l + 6);

// #define tipwindow_XLocaleBase LocaleBase
// #define LocaleBase li->li_LocaleBase
    
     if(LocaleBase && li)
        return(GetCatalogStr(li->li_Catalog, stringNum, builtIn));

// #undef  LocaleBase
// #define LocaleBase XLocaleBase
// #undef  tipwindow_XLocaleBase

     return(builtIn);
 }

#else

 STRPTR GettipwindowString(struct tipwindow_LocaleInfo *li, LONG stringNum);

#endif /* tipwindow_CODE_EXISTS */

#endif /* tipwindow_CODE */


/****************************************************************************/


#endif /* tipwindow_STRINGS_H */
