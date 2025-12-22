#ifndef STRINGS_H
#define STRINGS_H


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

#define MSG_WindowTitle 100
#define MSG_CantCreateGUI 101
#define MSG_CantCreateApplication 102
#define MSG_Above 200
#define MSG_Centered 201
#define MSG_Left 202
#define MSG_Center 203
#define MSG_Right 204
#define MSG_ScreenFont 205
#define MSG_Font 206
#define MSG_Color 207
#define MSG_Bold 208
#define MSG_Italics 209
#define MSG_3D 210
#define MSG_Alignment 211
#define MSG_Attributes 212
#define MSG_Centering 213
#define MSG_Project 214
#define MSG_Open 215
#define MSG_SaveAs 216
#define MSG_About 217
#define MSG_Quit 218
#define MSG_Edit 219
#define MSG_ResetToDefaults 220
#define MSG_ThisEntry 221
#define MSG_AllEntries 222
#define MSG_LastSaved 223
#define MSG_Restore 224
#define MSG_Options 225
#define MSG_CreateIcons 226

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_WindowTitle_STR "Frame Preferences"
#define MSG_CantCreateGUI_STR "Unable to create GUI"
#define MSG_CantCreateApplication_STR "Unable to create GUIFront application"
#define MSG_Above_STR "_Above"
#define MSG_Centered_STR "C_entered"
#define MSG_Left_STR "_Left"
#define MSG_Center_STR "_Center"
#define MSG_Right_STR "_Right"
#define MSG_ScreenFont_STR "_Screen Font"
#define MSG_Font_STR "_Font"
#define MSG_Color_STR "C_olor"
#define MSG_Bold_STR "_Bold"
#define MSG_Italics_STR "_Italics"
#define MSG_3D_STR "_3D"
#define MSG_Alignment_STR "Alignment"
#define MSG_Attributes_STR "Attributes"
#define MSG_Centering_STR "Centering"
#define MSG_Project_STR "Project"
#define MSG_Open_STR "OOpen..."
#define MSG_SaveAs_STR "ASave As..."
#define MSG_About_STR "?About..."
#define MSG_Quit_STR "QQuit"
#define MSG_Edit_STR "Edit"
#define MSG_ResetToDefaults_STR "Reset to Defaults"
#define MSG_ThisEntry_STR "EThis Entry"
#define MSG_AllEntries_STR "AAll Entries"
#define MSG_LastSaved_STR "LLast Saved"
#define MSG_Restore_STR "RRestore"
#define MSG_Options_STR "Options"
#define MSG_CreateIcons_STR "ICreate Icons?"

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
    {MSG_WindowTitle,(STRPTR)MSG_WindowTitle_STR},
    {MSG_CantCreateGUI,(STRPTR)MSG_CantCreateGUI_STR},
    {MSG_CantCreateApplication,(STRPTR)MSG_CantCreateApplication_STR},
    {MSG_Above,(STRPTR)MSG_Above_STR},
    {MSG_Centered,(STRPTR)MSG_Centered_STR},
    {MSG_Left,(STRPTR)MSG_Left_STR},
    {MSG_Center,(STRPTR)MSG_Center_STR},
    {MSG_Right,(STRPTR)MSG_Right_STR},
    {MSG_ScreenFont,(STRPTR)MSG_ScreenFont_STR},
    {MSG_Font,(STRPTR)MSG_Font_STR},
    {MSG_Color,(STRPTR)MSG_Color_STR},
    {MSG_Bold,(STRPTR)MSG_Bold_STR},
    {MSG_Italics,(STRPTR)MSG_Italics_STR},
    {MSG_3D,(STRPTR)MSG_3D_STR},
    {MSG_Alignment,(STRPTR)MSG_Alignment_STR},
    {MSG_Attributes,(STRPTR)MSG_Attributes_STR},
    {MSG_Centering,(STRPTR)MSG_Centering_STR},
    {MSG_Project,(STRPTR)MSG_Project_STR},
    {MSG_Open,(STRPTR)MSG_Open_STR},
    {MSG_SaveAs,(STRPTR)MSG_SaveAs_STR},
    {MSG_About,(STRPTR)MSG_About_STR},
    {MSG_Quit,(STRPTR)MSG_Quit_STR},
    {MSG_Edit,(STRPTR)MSG_Edit_STR},
    {MSG_ResetToDefaults,(STRPTR)MSG_ResetToDefaults_STR},
    {MSG_ThisEntry,(STRPTR)MSG_ThisEntry_STR},
    {MSG_AllEntries,(STRPTR)MSG_AllEntries_STR},
    {MSG_LastSaved,(STRPTR)MSG_LastSaved_STR},
    {MSG_Restore,(STRPTR)MSG_Restore_STR},
    {MSG_Options,(STRPTR)MSG_Options_STR},
    {MSG_CreateIcons,(STRPTR)MSG_CreateIcons_STR},
};

#endif /* CATCOMP_ARRAY */


/****************************************************************************/


#ifdef CATCOMP_BLOCK

static const char CatCompBlock[] =
{
    "\x00\x00\x00\x64\x00\x12"
    MSG_WindowTitle_STR "\x00"
    "\x00\x00\x00\x65\x00\x16"
    MSG_CantCreateGUI_STR "\x00\x00"
    "\x00\x00\x00\x66\x00\x26"
    MSG_CantCreateApplication_STR "\x00"
    "\x00\x00\x00\xC8\x00\x08"
    MSG_Above_STR "\x00\x00"
    "\x00\x00\x00\xC9\x00\x0A"
    MSG_Centered_STR "\x00"
    "\x00\x00\x00\xCA\x00\x06"
    MSG_Left_STR "\x00"
    "\x00\x00\x00\xCB\x00\x08"
    MSG_Center_STR "\x00"
    "\x00\x00\x00\xCC\x00\x08"
    MSG_Right_STR "\x00\x00"
    "\x00\x00\x00\xCD\x00\x0E"
    MSG_ScreenFont_STR "\x00\x00"
    "\x00\x00\x00\xCE\x00\x06"
    MSG_Font_STR "\x00"
    "\x00\x00\x00\xCF\x00\x08"
    MSG_Color_STR "\x00\x00"
    "\x00\x00\x00\xD0\x00\x06"
    MSG_Bold_STR "\x00"
    "\x00\x00\x00\xD1\x00\x0A"
    MSG_Italics_STR "\x00\x00"
    "\x00\x00\x00\xD2\x00\x04"
    MSG_3D_STR "\x00"
    "\x00\x00\x00\xD3\x00\x0A"
    MSG_Alignment_STR "\x00"
    "\x00\x00\x00\xD4\x00\x0C"
    MSG_Attributes_STR "\x00\x00"
    "\x00\x00\x00\xD5\x00\x0A"
    MSG_Centering_STR "\x00"
    "\x00\x00\x00\xD6\x00\x08"
    MSG_Project_STR "\x00"
    "\x00\x00\x00\xD7\x00\x0A"
    MSG_Open_STR "\x00\x00"
    "\x00\x00\x00\xD8\x00\x0C"
    MSG_SaveAs_STR "\x00"
    "\x00\x00\x00\xD9\x00\x0A"
    MSG_About_STR "\x00"
    "\x00\x00\x00\xDA\x00\x06"
    MSG_Quit_STR "\x00"
    "\x00\x00\x00\xDB\x00\x06"
    MSG_Edit_STR "\x00\x00"
    "\x00\x00\x00\xDC\x00\x12"
    MSG_ResetToDefaults_STR "\x00"
    "\x00\x00\x00\xDD\x00\x0C"
    MSG_ThisEntry_STR "\x00"
    "\x00\x00\x00\xDE\x00\x0E"
    MSG_AllEntries_STR "\x00\x00"
    "\x00\x00\x00\xDF\x00\x0C"
    MSG_LastSaved_STR "\x00"
    "\x00\x00\x00\xE0\x00\x0A"
    MSG_Restore_STR "\x00\x00"
    "\x00\x00\x00\xE1\x00\x08"
    MSG_Options_STR "\x00"
    "\x00\x00\x00\xE2\x00\x10"
    MSG_CreateIcons_STR "\x00\x00"
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


#endif /* STRINGS_H */
