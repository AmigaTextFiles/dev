/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>                 // exec
#include <exec/lists.h>
#include <exec/nodes.h>
#include <dos/dos.h>                    // dos
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"
#include "DEV_IE:Generators/C/Protos.h"
///


/// WriteFontPtrs
void WriteFontPtrs( struct GenFiles *Files, struct IE_Data *IE )
{
    struct TxtAttrNode *fnt;

    if( IE->SrcFlags & OPENDISKFONT ) {
	for( fnt = IE->FntLst.mlh_Head; fnt->txa_Next; fnt = fnt->txa_Next ) {
	    if( fnt->txa_Flags & FPB_DISKFONT ) {
		FPrintf( Files->Std,  "struct TextFont\t\t*%sFont = NULL;\n", fnt->txa_Label );
		FPrintf( Files->XDef, "extern struct TextFont\t\t*%sFont;\n", fnt->txa_Label );
	    }
	}
    }
}
///
/// WriteOpenFonts
void WriteOpenFonts( struct GenFiles *Files, struct IE_Data *IE )
{
    struct TxtAttrNode *fnt;
    BOOL                ok = FALSE;

    if( IE->SrcFlags & OPENDISKFONT ) {

	for( fnt = IE->FntLst.mlh_Head; fnt->txa_Next; fnt = fnt->txa_Next ) {
	    if( fnt->txa_Flags & FPB_DISKFONT )
		ok = TRUE;
	}

	if( ok ) {

	    FPuts( Files->XDef, "extern struct Library\t*DiskfontBase;\n"
				"extern struct Library\t*GfxBase;\n"
				"extern BOOL OpenDiskFonts( void );\n"
				"extern void CloseDiskFonts( void );\n" );

	    FPuts( Files->Std,  "\nBOOL OpenDiskFonts( void )\n"
				"{\n" );

	    for( fnt = IE->FntLst.mlh_Head; fnt->txa_Next; fnt = fnt->txa_Next ) {
		if( fnt->txa_Flags & FPB_DISKFONT )
		    FPrintf( Files->Std, "\tif (!( %sFont = OpenDiskFont( &%s )))\n"
					 "\t\treturn( FALSE );\n",
			     fnt->txa_Label, fnt->txa_Label );
	    }

	    FPuts( Files->Std, "\treturn( TRUE );\n"
			       "}\n\n"
			       "void CloseDiskFonts( void )\n"
			       "{\n" );

	    for( fnt = IE->FntLst.mlh_Head; fnt->txa_Next; fnt = fnt->txa_Next ) {
		if( fnt->txa_Flags & FPB_DISKFONT ) {
		    FPrintf( Files->Std, "\tif ( %sFont ) {\n"
					 "\t\tCloseFont( %sFont );\n"
					 "\t\t%sFont = NULL;\n"
					 "\t}\n",
			     fnt->txa_Label, fnt->txa_Label, fnt->txa_Label );
		}
	    }

	    FPuts( Files->Std, "}\n" );
	}

    }
}
///

