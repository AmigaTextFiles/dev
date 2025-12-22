#ifndef LOCALE_H
#define LOCALE_H


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

#define MSG_W_TITLE 100
#define MSG_G_PALETTE 200
#define MSG_G_RED 300
#define MSG_G_GREEN 301
#define MSG_G_BLUE 302
#define MSG_G_HUE 303
#define MSG_G_SATURATION 304
#define MSG_G_BRIGHTNESS 305
#define MSG_G_COPY 400
#define MSG_G_SWAP 401
#define MSG_G_SPREAD 402
#define MSG_G_UNDO 403
#define MSG_G_RESET 404
#define MSG_G_OK 500
#define MSG_G_CANCEL 501
#define MSG_M_PROJECT 10000
#define MSG_MI_OPEN 10001
#define MSG_MI_SAVE 10002

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_W_TITLE_STR "Palette Requester"
#define MSG_G_PALETTE_STR "Palette"
#define MSG_G_RED_STR "Red:"
#define MSG_G_GREEN_STR "Green:"
#define MSG_G_BLUE_STR "Blue:"
#define MSG_G_HUE_STR "Hue:"
#define MSG_G_SATURATION_STR "Saturation:"
#define MSG_G_BRIGHTNESS_STR "Brightness:"
#define MSG_G_COPY_STR "Copy"
#define MSG_G_SWAP_STR "Swap"
#define MSG_G_SPREAD_STR "Spread"
#define MSG_G_UNDO_STR "Undo"
#define MSG_G_RESET_STR "Reset"
#define MSG_G_OK_STR "Ok"
#define MSG_G_CANCEL_STR "Cancel"
#define MSG_M_PROJECT_STR "Project"
#define MSG_MI_OPEN_STR "Load..."
#define MSG_MI_SAVE_STR "Save..."

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
    {MSG_W_TITLE,(STRPTR)MSG_W_TITLE_STR},
    {MSG_G_PALETTE,(STRPTR)MSG_G_PALETTE_STR},
    {MSG_G_RED,(STRPTR)MSG_G_RED_STR},
    {MSG_G_GREEN,(STRPTR)MSG_G_GREEN_STR},
    {MSG_G_BLUE,(STRPTR)MSG_G_BLUE_STR},
    {MSG_G_HUE,(STRPTR)MSG_G_HUE_STR},
    {MSG_G_SATURATION,(STRPTR)MSG_G_SATURATION_STR},
    {MSG_G_BRIGHTNESS,(STRPTR)MSG_G_BRIGHTNESS_STR},
    {MSG_G_COPY,(STRPTR)MSG_G_COPY_STR},
    {MSG_G_SWAP,(STRPTR)MSG_G_SWAP_STR},
    {MSG_G_SPREAD,(STRPTR)MSG_G_SPREAD_STR},
    {MSG_G_UNDO,(STRPTR)MSG_G_UNDO_STR},
    {MSG_G_RESET,(STRPTR)MSG_G_RESET_STR},
    {MSG_G_OK,(STRPTR)MSG_G_OK_STR},
    {MSG_G_CANCEL,(STRPTR)MSG_G_CANCEL_STR},
    {MSG_M_PROJECT,(STRPTR)MSG_M_PROJECT_STR},
    {MSG_MI_OPEN,(STRPTR)MSG_MI_OPEN_STR},
    {MSG_MI_SAVE,(STRPTR)MSG_MI_SAVE_STR},
};

#endif /* CATCOMP_ARRAY */


/****************************************************************************/


struct LocaleInfo
{
    APTR li_LocaleBase;
    APTR li_Catalog;
};



#endif /* LOCALE_H */
