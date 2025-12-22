#ifndef SCREENMANAGERALL_H
#define SCREENMANAGERALL_H


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

#define MSG_REQ_54_NAME 1
#define MSG_REQ_54_FORMAT 2
#define MSG_REQ_54_GADGETS 3
#define MSG_REQ_55_NAME 4
#define MSG_REQ_55_FORMAT 5
#define MSG_REQ_55_GADGETS 6
#define MSG_REQ_56_NAME 7
#define MSG_REQ_56_FORMAT 8
#define MSG_REQ_56_GADGETS 9
#define MSG_WIN_1_NAME 10
#define MSG_BUTTON_12_NAME 11
#define MSG_BUTTON_13_NAME 12
#define MSG_BUTTON_14_NAME 13
#define MSG_BUTTON_15_NAME 14
#define MSG_TOGGLE_31_NAME 15
#define MSG_LABEL_30_NAME 16
#define MSG_BUTTON_46_NAME 17
#define MSG_LABEL_24_NAME 18
#define MSG_LABEL_27_NAME 19
#define MSG_MENU_47_NAME 20
#define MSG_ITEM_48_NAME 21
#define MSG_ITEM_50_NAME 22
#define MSG_ITEM_52_NAME 23
#define MSG_ITEM_53_NAME 24
#define MSG_WIN_34_NAME 25
#define MSG_LABEL_58_NAME 26
#define MSG_LABEL_61_NAME 27
#define MSG_LABEL_64_NAME 28
#define MSG_LABEL_76_NAME 29
#define MSG_CYCLE_77_NAME 30
#define MSG_LABEL_73_NAME 31
#define MSG_LABEL_80_NAME 32
#define MSG_LABEL_68_NAME 33
#define MSG_LABEL_83_NAME 34
#define MSG_LABEL_71_NAME 35
#define MSG_LABEL_86_NAME 36
#define MSG_NAME_ID 37
#define MSG_DISPLAYMODE_ID 38
#define MSG_FONT_ID 39
#define MSG_UNKNOWN_ID 40
#define MSG_FONTTEXT_ID 41
#define MSG_OUT_OF_MEMORY_ID 42
#define MSG_UNABLE_TO_READ_ICON_ID 43
#define MSG_UNABLE_TO_WRITE_ICON_ID 44
#define MSG_UNABLE_TO_OPEN_WIZARD_FILE_ID 45
#define MSG_REXXPORT_IN_USE_ID 46
#define MSG_SELECT_SCREEN_MODE_ID 47
#define MSG_SELECT_FONT_ID 48
#define MSG_BROKER_TITLE_ID 49
#define MSG_BROKER_DESCRIP_ID 50
#define MSG_UNABLE_TO_INSTALL_COMMODITY_ID 51
#define MSG_FATAL_ID 52

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_REQ_54_NAME_STR "About..."
#define MSG_REQ_54_FORMAT_STR "StormScreenManager V2.0\n© 1996-1998 HAAGE & PARTNER GmbH"
#define MSG_REQ_54_GADGETS_STR "OK"
#define MSG_REQ_55_NAME_STR "StormScreenManager"
#define MSG_REQ_55_FORMAT_STR "Error: %s."
#define MSG_REQ_55_GADGETS_STR "OK"
#define MSG_REQ_56_NAME_STR "StormScreenManager"
#define MSG_REQ_56_FORMAT_STR "Unable to open screen\n\"%s\""
#define MSG_REQ_56_GADGETS_STR "OK"
#define MSG_WIN_1_NAME_STR "Storm Screen Manager"
#define MSG_BUTTON_12_NAME_STR "_New"
#define MSG_BUTTON_13_NAME_STR "_Delete"
#define MSG_BUTTON_14_NAME_STR "_Mode..."
#define MSG_BUTTON_15_NAME_STR "_Font..."
#define MSG_TOGGLE_31_NAME_STR "_Open..."
#define MSG_LABEL_30_NAME_STR "Open _Behind"
#define MSG_BUTTON_46_NAME_STR "P_roperties..."
#define MSG_LABEL_24_NAME_STR "Shanghai"
#define MSG_LABEL_27_NAME_STR "Auto Popup"
#define MSG_MENU_47_NAME_STR "Project"
#define MSG_ITEM_48_NAME_STR "S\x00Save"
#define MSG_ITEM_50_NAME_STR "\x00About..."
#define MSG_ITEM_52_NAME_STR "H\x00Hide"
#define MSG_ITEM_53_NAME_STR "Q\x00Quit"
#define MSG_WIN_34_NAME_STR "Properties"
#define MSG_LABEL_58_NAME_STR "Colors"
#define MSG_LABEL_61_NAME_STR "Width"
#define MSG_LABEL_64_NAME_STR "Height"
#define MSG_LABEL_76_NAME_STR "_Font"
#define MSG_CYCLE_77_NAME_STR "Custom\nSystem\nWorkbench"
#define MSG_LABEL_73_NAME_STR "_Title"
#define MSG_LABEL_80_NAME_STR "Like _Workbench"
#define MSG_LABEL_68_NAME_STR "_CloseGadget"
#define MSG_LABEL_83_NAME_STR "_Draggable"
#define MSG_LABEL_71_NAME_STR "_Quiet"
#define MSG_LABEL_86_NAME_STR "_Exclusive"
#define MSG_NAME_ID_STR "Name"
#define MSG_DISPLAYMODE_ID_STR "Displaymode"
#define MSG_FONT_ID_STR "Font"
#define MSG_UNKNOWN_ID_STR "«Unknown»"
#define MSG_FONTTEXT_ID_STR "%s/%ld"
#define MSG_OUT_OF_MEMORY_ID_STR "Out of memory"
#define MSG_UNABLE_TO_READ_ICON_ID_STR "Unable to read icon"
#define MSG_UNABLE_TO_WRITE_ICON_ID_STR "Unable to write icon"
#define MSG_UNABLE_TO_OPEN_WIZARD_FILE_ID_STR "Unable to open wizard resource file"
#define MSG_REXXPORT_IN_USE_ID_STR "Rexx port \"StormScreenManager\" already in use"
#define MSG_SELECT_SCREEN_MODE_ID_STR "Select Screen Mode..."
#define MSG_SELECT_FONT_ID_STR "Select Font..."
#define MSG_BROKER_TITLE_ID_STR "StormScreenManager V2 © HAAGE&PARTNER"
#define MSG_BROKER_DESCRIP_ID_STR "A Public Screen Manager"
#define MSG_UNABLE_TO_INSTALL_COMMODITY_ID_STR "Unable to install commodity"
#define MSG_FATAL_ID_STR "Resource allocation failed."

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
    {MSG_REQ_54_NAME,(STRPTR)MSG_REQ_54_NAME_STR},
    {MSG_REQ_54_FORMAT,(STRPTR)MSG_REQ_54_FORMAT_STR},
    {MSG_REQ_54_GADGETS,(STRPTR)MSG_REQ_54_GADGETS_STR},
    {MSG_REQ_55_NAME,(STRPTR)MSG_REQ_55_NAME_STR},
    {MSG_REQ_55_FORMAT,(STRPTR)MSG_REQ_55_FORMAT_STR},
    {MSG_REQ_55_GADGETS,(STRPTR)MSG_REQ_55_GADGETS_STR},
    {MSG_REQ_56_NAME,(STRPTR)MSG_REQ_56_NAME_STR},
    {MSG_REQ_56_FORMAT,(STRPTR)MSG_REQ_56_FORMAT_STR},
    {MSG_REQ_56_GADGETS,(STRPTR)MSG_REQ_56_GADGETS_STR},
    {MSG_WIN_1_NAME,(STRPTR)MSG_WIN_1_NAME_STR},
    {MSG_BUTTON_12_NAME,(STRPTR)MSG_BUTTON_12_NAME_STR},
    {MSG_BUTTON_13_NAME,(STRPTR)MSG_BUTTON_13_NAME_STR},
    {MSG_BUTTON_14_NAME,(STRPTR)MSG_BUTTON_14_NAME_STR},
    {MSG_BUTTON_15_NAME,(STRPTR)MSG_BUTTON_15_NAME_STR},
    {MSG_TOGGLE_31_NAME,(STRPTR)MSG_TOGGLE_31_NAME_STR},
    {MSG_LABEL_30_NAME,(STRPTR)MSG_LABEL_30_NAME_STR},
    {MSG_BUTTON_46_NAME,(STRPTR)MSG_BUTTON_46_NAME_STR},
    {MSG_LABEL_24_NAME,(STRPTR)MSG_LABEL_24_NAME_STR},
    {MSG_LABEL_27_NAME,(STRPTR)MSG_LABEL_27_NAME_STR},
    {MSG_MENU_47_NAME,(STRPTR)MSG_MENU_47_NAME_STR},
    {MSG_ITEM_48_NAME,(STRPTR)MSG_ITEM_48_NAME_STR},
    {MSG_ITEM_50_NAME,(STRPTR)MSG_ITEM_50_NAME_STR},
    {MSG_ITEM_52_NAME,(STRPTR)MSG_ITEM_52_NAME_STR},
    {MSG_ITEM_53_NAME,(STRPTR)MSG_ITEM_53_NAME_STR},
    {MSG_WIN_34_NAME,(STRPTR)MSG_WIN_34_NAME_STR},
    {MSG_LABEL_58_NAME,(STRPTR)MSG_LABEL_58_NAME_STR},
    {MSG_LABEL_61_NAME,(STRPTR)MSG_LABEL_61_NAME_STR},
    {MSG_LABEL_64_NAME,(STRPTR)MSG_LABEL_64_NAME_STR},
    {MSG_LABEL_76_NAME,(STRPTR)MSG_LABEL_76_NAME_STR},
    {MSG_CYCLE_77_NAME,(STRPTR)MSG_CYCLE_77_NAME_STR},
    {MSG_LABEL_73_NAME,(STRPTR)MSG_LABEL_73_NAME_STR},
    {MSG_LABEL_80_NAME,(STRPTR)MSG_LABEL_80_NAME_STR},
    {MSG_LABEL_68_NAME,(STRPTR)MSG_LABEL_68_NAME_STR},
    {MSG_LABEL_83_NAME,(STRPTR)MSG_LABEL_83_NAME_STR},
    {MSG_LABEL_71_NAME,(STRPTR)MSG_LABEL_71_NAME_STR},
    {MSG_LABEL_86_NAME,(STRPTR)MSG_LABEL_86_NAME_STR},
    {MSG_NAME_ID,(STRPTR)MSG_NAME_ID_STR},
    {MSG_DISPLAYMODE_ID,(STRPTR)MSG_DISPLAYMODE_ID_STR},
    {MSG_FONT_ID,(STRPTR)MSG_FONT_ID_STR},
    {MSG_UNKNOWN_ID,(STRPTR)MSG_UNKNOWN_ID_STR},
    {MSG_FONTTEXT_ID,(STRPTR)MSG_FONTTEXT_ID_STR},
    {MSG_OUT_OF_MEMORY_ID,(STRPTR)MSG_OUT_OF_MEMORY_ID_STR},
    {MSG_UNABLE_TO_READ_ICON_ID,(STRPTR)MSG_UNABLE_TO_READ_ICON_ID_STR},
    {MSG_UNABLE_TO_WRITE_ICON_ID,(STRPTR)MSG_UNABLE_TO_WRITE_ICON_ID_STR},
    {MSG_UNABLE_TO_OPEN_WIZARD_FILE_ID,(STRPTR)MSG_UNABLE_TO_OPEN_WIZARD_FILE_ID_STR},
    {MSG_REXXPORT_IN_USE_ID,(STRPTR)MSG_REXXPORT_IN_USE_ID_STR},
    {MSG_SELECT_SCREEN_MODE_ID,(STRPTR)MSG_SELECT_SCREEN_MODE_ID_STR},
    {MSG_SELECT_FONT_ID,(STRPTR)MSG_SELECT_FONT_ID_STR},
    {MSG_BROKER_TITLE_ID,(STRPTR)MSG_BROKER_TITLE_ID_STR},
    {MSG_BROKER_DESCRIP_ID,(STRPTR)MSG_BROKER_DESCRIP_ID_STR},
    {MSG_UNABLE_TO_INSTALL_COMMODITY_ID,(STRPTR)MSG_UNABLE_TO_INSTALL_COMMODITY_ID_STR},
    {MSG_FATAL_ID,(STRPTR)MSG_FATAL_ID_STR},
};

#endif /* CATCOMP_ARRAY */


/****************************************************************************/


#ifdef CATCOMP_BLOCK

static const char CatCompBlock[] =
{
    "\x00\x00\x00\x01\x00\x0A"
    MSG_REQ_54_NAME_STR "\x00\x00"
    "\x00\x00\x00\x02\x00\x3A"
    MSG_REQ_54_FORMAT_STR "\x00\x00"
    "\x00\x00\x00\x03\x00\x04"
    MSG_REQ_54_GADGETS_STR "\x00\x00"
    "\x00\x00\x00\x04\x00\x14"
    MSG_REQ_55_NAME_STR "\x00\x00"
    "\x00\x00\x00\x05\x00\x0C"
    MSG_REQ_55_FORMAT_STR "\x00\x00"
    "\x00\x00\x00\x06\x00\x04"
    MSG_REQ_55_GADGETS_STR "\x00\x00"
    "\x00\x00\x00\x07\x00\x14"
    MSG_REQ_56_NAME_STR "\x00\x00"
    "\x00\x00\x00\x08\x00\x1C"
    MSG_REQ_56_FORMAT_STR "\x00\x00"
    "\x00\x00\x00\x09\x00\x04"
    MSG_REQ_56_GADGETS_STR "\x00\x00"
    "\x00\x00\x00\x0A\x00\x16"
    MSG_WIN_1_NAME_STR "\x00\x00"
    "\x00\x00\x00\x0B\x00\x06"
    MSG_BUTTON_12_NAME_STR "\x00\x00"
    "\x00\x00\x00\x0C\x00\x08"
    MSG_BUTTON_13_NAME_STR "\x00"
    "\x00\x00\x00\x0D\x00\x0A"
    MSG_BUTTON_14_NAME_STR "\x00\x00"
    "\x00\x00\x00\x0E\x00\x0A"
    MSG_BUTTON_15_NAME_STR "\x00\x00"
    "\x00\x00\x00\x0F\x00\x0A"
    MSG_TOGGLE_31_NAME_STR "\x00\x00"
    "\x00\x00\x00\x10\x00\x0E"
    MSG_LABEL_30_NAME_STR "\x00\x00"
    "\x00\x00\x00\x11\x00\x10"
    MSG_BUTTON_46_NAME_STR "\x00\x00"
    "\x00\x00\x00\x12\x00\x0A"
    MSG_LABEL_24_NAME_STR "\x00\x00"
    "\x00\x00\x00\x13\x00\x0C"
    MSG_LABEL_27_NAME_STR "\x00\x00"
    "\x00\x00\x00\x14\x00\x08"
    MSG_MENU_47_NAME_STR "\x00"
    "\x00\x00\x00\x15\x00\x08"
    MSG_ITEM_48_NAME_STR "\x00\x00"
    "\x00\x00\x00\x16\x00\x0A"
    MSG_ITEM_50_NAME_STR "\x00"
    "\x00\x00\x00\x17\x00\x08"
    MSG_ITEM_52_NAME_STR "\x00\x00"
    "\x00\x00\x00\x18\x00\x08"
    MSG_ITEM_53_NAME_STR "\x00\x00"
    "\x00\x00\x00\x19\x00\x0C"
    MSG_WIN_34_NAME_STR "\x00\x00"
    "\x00\x00\x00\x1A\x00\x08"
    MSG_LABEL_58_NAME_STR "\x00\x00"
    "\x00\x00\x00\x1B\x00\x06"
    MSG_LABEL_61_NAME_STR "\x00"
    "\x00\x00\x00\x1C\x00\x08"
    MSG_LABEL_64_NAME_STR "\x00\x00"
    "\x00\x00\x00\x1D\x00\x06"
    MSG_LABEL_76_NAME_STR "\x00"
    "\x00\x00\x00\x1E\x00\x18"
    MSG_CYCLE_77_NAME_STR "\x00"
    "\x00\x00\x00\x1F\x00\x08"
    MSG_LABEL_73_NAME_STR "\x00\x00"
    "\x00\x00\x00\x20\x00\x10"
    MSG_LABEL_80_NAME_STR "\x00"
    "\x00\x00\x00\x21\x00\x0E"
    MSG_LABEL_68_NAME_STR "\x00\x00"
    "\x00\x00\x00\x22\x00\x0C"
    MSG_LABEL_83_NAME_STR "\x00\x00"
    "\x00\x00\x00\x23\x00\x08"
    MSG_LABEL_71_NAME_STR "\x00\x00"
    "\x00\x00\x00\x24\x00\x0C"
    MSG_LABEL_86_NAME_STR "\x00\x00"
    "\x00\x00\x00\x25\x00\x06"
    MSG_NAME_ID_STR "\x00\x00"
    "\x00\x00\x00\x26\x00\x0C"
    MSG_DISPLAYMODE_ID_STR "\x00"
    "\x00\x00\x00\x27\x00\x06"
    MSG_FONT_ID_STR "\x00\x00"
    "\x00\x00\x00\x28\x00\x0A"
    MSG_UNKNOWN_ID_STR "\x00"
    "\x00\x00\x00\x29\x00\x08"
    MSG_FONTTEXT_ID_STR "\x00\x00"
    "\x00\x00\x00\x2A\x00\x0E"
    MSG_OUT_OF_MEMORY_ID_STR "\x00"
    "\x00\x00\x00\x2B\x00\x14"
    MSG_UNABLE_TO_READ_ICON_ID_STR "\x00"
    "\x00\x00\x00\x2C\x00\x16"
    MSG_UNABLE_TO_WRITE_ICON_ID_STR "\x00\x00"
    "\x00\x00\x00\x2D\x00\x24"
    MSG_UNABLE_TO_OPEN_WIZARD_FILE_ID_STR "\x00"
    "\x00\x00\x00\x2E\x00\x2E"
    MSG_REXXPORT_IN_USE_ID_STR "\x00"
    "\x00\x00\x00\x2F\x00\x16"
    MSG_SELECT_SCREEN_MODE_ID_STR "\x00"
    "\x00\x00\x00\x30\x00\x10"
    MSG_SELECT_FONT_ID_STR "\x00\x00"
    "\x00\x00\x00\x31\x00\x26"
    MSG_BROKER_TITLE_ID_STR "\x00"
    "\x00\x00\x00\x32\x00\x18"
    MSG_BROKER_DESCRIP_ID_STR "\x00"
    "\x00\x00\x00\x33\x00\x1C"
    MSG_UNABLE_TO_INSTALL_COMMODITY_ID_STR "\x00"
    "\x00\x00\x00\x34\x00\x1C"
    MSG_FATAL_ID_STR "\x00"
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


#endif /* SCREENMANAGERALL_H */
