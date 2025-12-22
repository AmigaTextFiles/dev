/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>                 // exec
#include <exec/lists.h>
#include <exec/nodes.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
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


/// WriteLocale
void WriteLocale( struct GenFiles *Files, struct IE_Data *IE )
{
    UWORD               cnt;
    struct ArrayNode   *ar;

    FPuts( Files->XDef, "extern void SetupLocale( void );\n"
			"extern void LocalizeArray( UBYTE ** );\n"
			"extern void LocalizeTags( ULONG *, UWORD );\n"
			"extern void LocalizeList( struct MinList * );\n"
			"extern void LocalizeGadgets( struct NewGadget *, ULONG *, UWORD *, UWORD );\n"
			"extern void LocalizeMenus( struct NewMenu * );\n"
			"extern void LocalizeITexts( struct IntuiText *, UWORD );\n"
			"extern UBYTE GetActivationKey( STRPTR );\n" );

    FPrintf( Files->Std, "\nvoid SetupLocale( void )\n"
			 "{\n"
			 "\tUWORD\tcnt;\n\n"
			 "\tif( LocaleBase ) {\n"
			 "\t\tif( Catalog = OpenCatalog( NULL, \"%s.catalog\", OC_BuiltInLanguage, \"%s\", OC_Version, %ld, TAG_DONE )) {\n"
			 "\t\t\tfor( cnt = 0; cnt < ( sizeof( CatCompArray ) / sizeof( struct CatCompArrayType )); cnt++ )\n"
			 "\t\t\t\tCatCompArray[ cnt ].cca_Str = GetCatalogStr( Catalog, cnt, CatCompArray[ cnt ].cca_Str );\n"
			 "\t\t}\n"
			 "\t}\n",
	     IE->Locale->Catalog, IE->Locale->BuiltIn, IE->Locale->Version );

    for( cnt = 0, ar = IE->Locale->Arrays.mlh_Head; ar->Next; ar = ar->Next, cnt++ )
	FPrintf( Files->Std, "\n\tLocalizeArray( &%s[0] );", ar->Label );

    FPuts( Files->Std, "\n}\n"
		       "\n"
		       "void LocalizeArray( UBYTE **Array )\n"
		       "{\n"
		       "\twhile( *Array ) {\n"
		       "\t\t*Array = (UBYTE *)CatCompArray[ (ULONG)*Array ].cca_Str;\n"
		       "\t\t*Array++;\n"
		       "\t}\n"
		       "}\n"
		       "\n"
		       "void LocalizeTags( ULONG *Tags, UWORD Kind )\n"
		       "{\n"
		       "\tULONG\ttag;\n\t"
		       "\tswitch( Kind ) {\n"
		       "\t\tcase\tSTRING_KIND:\n"
		       "\t\t\t\ttag = GTST_String;\n"
		       "\t\t\t\tbreak;\n"
		       "\t\tcase\tTEXT_KIND:\n"
		       "\t\t\t\ttag = GTTX_Text;\n"
		       "\t\t\t\tbreak;\n"
		       "\t\tcase\tNUMBER_KIND:\n"
		       "\t\t\t\ttag = GTNM_Format;\n"
		       "\t\t\t\tbreak;\n"
		       "\t\tcase\tSLIDER_KIND:\n"
		       "\t\t\t\ttag = GTSL_LevelFormat;\n"
		       "\t\t\t\tbreak;\n"
		       "\t\tdefault:\n"
		       "\t\t\t\treturn;\n"
		       "\t\t\t\tbreak;\n"
		       "\t}\n"
		       "\twhile(( *Tags != tag ) && ( *Tags ))\n"
		       "\t\tTags++;\n"
		       "\tif( *Tags++ )\n"
		       "\t\t*Tags = (ULONG)CatCompArray[ *Tags ].cca_Str;\n\n"
		       "}\n"
		       "\n"
		       "void LocalizeList( struct MinList *List )\n"
		       "{\n"
		       "\tstruct Node\t*node;\n\n"
		       "\tfor( node = (struct Node *)List->mlh_Head; node->ln_Succ; node = node->ln_Succ )\n"
		       "\t\tnode->ln_Name = (char *)CatCompArray[ (ULONG)node->ln_Name ].cca_Str;\n"
		       "}\n"
		       "\n"
		       "void LocalizeGadgets( struct NewGadget *ng, ULONG *tags, UWORD *kinds, UWORD num )\n"
		       "{\n"
		       "\tUWORD\tcnt;\n\n"
		       "\tfor( cnt = 0; cnt < num; cnt++ ) {\n"
		       "\t\tif( ng->ng_GadgetText )\n"
		       "\t\t\tng->ng_GadgetText = CatCompArray[ (ULONG)ng->ng_GadgetText ].cca_Str;\n"
		       "\t\tLocalizeTags( tags, *kinds++ );\n"
		       "\t\twhile( *tags++ );\n"
		       "\t\tng++;\n"
		       "\t}\n"
		       "}\n"
		       "\n"
		       "void LocalizeMenus( struct NewMenu *menu )\n"
		       "{\n"
		       "\twhile( menu->nm_Type != NM_END ) {\n"
		       "\t\tif( menu->nm_Label != NM_BARLABEL )\n"
		       "\t\t\tmenu->nm_Label = (STRPTR)CatCompArray[ (ULONG)menu->nm_Label ].cca_Str;\n"
		       "\t\tif( menu->nm_CommKey )\n"
		       "\t\t\tmenu->nm_CommKey = (STRPTR)CatCompArray[ (ULONG)menu->nm_CommKey ].cca_Str;\n"
		       "\t\tmenu++;\n"
		       "\t}\n"
		       "}\n"
		       "\n"
		       "void LocalizeITexts( struct IntuiText *txt, UWORD cnt )\n"
		       "{\n"
		       "\twhile( cnt-- ) {\n"
		       "\t\ttxt->IText = (UBYTE *)CatCompArray[ (ULONG)txt->IText ].cca_Str;\n"
		       "\t\ttxt++;\n"
		       "\t}\n"
		       "}\n"
		       "\n"
		       "UBYTE GetActivationKey( STRPTR Text )\n"
		       "{\n"
		       "\twhile( *Text++ != '_' )\n"
		       "\t\tif( *Text == '\\0' )\n"
		       "\t\t\treturn( 0 );\n"
		       "\n\treturn( *Text );\n"
		       "}\n" );
}
///

