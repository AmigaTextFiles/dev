/*-- AutoRev header do NOT edit!
*
*   Program         :   GetFont.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard.
*   Creation Date   :   06-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   06-Oct-91     1.00            Font requester.
*
*-- REV_END --*/

#include	"defs.h"

extern struct Window    *MainWindow;
extern struct TextAttr   MainFont;
extern UBYTE             MainFontName[80];
extern BOOL              Saved;

struct FontRequester    *gf_Req = 0l;

struct TagItem           gf_Tags[] = {
    ASL_Hail,           (ULONG)"Select Font:",
    ASL_Window,         0l,
    ASL_FontName,       0l,
    ASL_FontHeight,     0l,
    ASL_FontStyles,     0l,
    ASL_FontFlags,      0l,
    TAG_DONE };

void GetFont( void )
{
    if ( gf_Req = AllocAslRequest( ASL_FontRequest, &gf_Tags[7] )) {

        gf_Tags[1].ti_Data  =   (ULONG)MainWindow;
        gf_Tags[2].ti_Data  =   (ULONG)MainFontName;
        gf_Tags[3].ti_Data  =   (ULONG)MainFont.ta_YSize;
        gf_Tags[4].ti_Data  =   (ULONG)MainFont.ta_Style;
        gf_Tags[5].ti_Data  =   (ULONG)MainFont.ta_Flags;

        if ( AslRequest( gf_Req, gf_Tags )) {
            CopyMem(( void * )&gf_Req->fo_Attr, ( void * )&MainFont, (long)sizeof( struct TextAttr ));
            strcpy( MainFontName, gf_Req->fo_Attr.ta_Name );
            MainFont.ta_Name = (STRPTR)&MainFontName[0];
            ReOpenScreen( FALSE );
            Saved = FALSE;
        }
    }

    if ( gf_Req )   FreeAslRequest( gf_Req );

    gf_Req = 0l;
}
