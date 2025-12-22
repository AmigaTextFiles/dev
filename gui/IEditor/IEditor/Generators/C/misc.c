/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>                 // exec
#include <exec/lists.h>
#include <exec/nodes.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <libraries/reqtools.h>         // libraries
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/reqtools_pragmas.h>

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"
#include "DEV_IE:Generators/C/Protos.h"
///


/// AskFile
BOOL AskFile( UBYTE *File, struct IE_Data *IE )
{
    BOOL    ret = TRUE;
    BPTR    lock;

    if( lock = Lock( File, ACCESS_READ )) {

	UnLock( lock );

	ULONG   tags[] = { RT_ReqPos, REQPOS_CENTERSCR, RT_Underscore, '_',
			   RT_Screen, IE->ScreenData->Screen, TAG_DONE };

	ret = rtEZRequest( "%s alreay exists.\n"
			   "Overwrite?",
			   "_Yes|_No",
			   NULL, (struct TagItem *)tags,
			   FilePart( File )
			 );
    }

    return( ret );
}
///

/// WriteList
void WriteList( struct GenFiles *Files, struct MinList *List, UBYTE *Label, UWORD Num, struct IE_Data *IE )
{
    struct GadgetScelta *gs;
    UWORD                cnt;

    if( Num ) {

	FPrintf( Files->XDef, "extern struct MinList %sList;\n", Label );

	FPrintf( Files->Std, "\nstruct Node %sNodes[] = {\n\t", Label );

	gs = List->mlh_Head;

	if( Num == 1 ) {
	    FPrintf( Files->Std, "(struct Node *)&%sList.mlh_Tail, (struct Node *)&%sList.mlh_Head, 0, 0, ",
		     Label, Label );

	    if( IE->SrcFlags & LOCALIZE )
		FPuts( Files->Std, "(STRPTR)" );

	    if( Prefs.Flags & SMART_STR )
		FPrintf( Files->Std, "%s", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, gs->gs_Testo ))->ID );
	    else
		FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

	    FPuts( Files->Std, " };\n" );
	} else {

	    FPrintf( Files->Std, "&%sNodes[1], (struct Node *)&%sList.mlh_Head, 0, 0, ",
		     Label, Label );

	    if( IE->SrcFlags & LOCALIZE )
		FPuts( Files->Std, "(STRPTR)" );

	    if( Prefs.Flags & SMART_STR )
		FPrintf( Files->Std, "%s", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, gs->gs_Testo ))->ID );
	    else
		FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

	    FPuts( Files->Std, ",\n" );

	    for( cnt = 1; cnt < Num - 1; cnt++ ) {

		gs = gs->gs_Node.ln_Succ;

		FPrintf( Files->Std, "\t&%sNodes[%ld], &%sNodes[%ld], 0, 0, ",
			 Label, cnt + 1, Label, cnt - 1 );

		if( IE->SrcFlags & LOCALIZE )
		    FPuts( Files->Std, "(STRPTR)" );

		if( Prefs.Flags & SMART_STR )
		    FPrintf( Files->Std, "%s", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, gs->gs_Testo ))->ID );
		else
		    FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

		FPuts( Files->Std, ",\n" );
	    }

	    gs = gs->gs_Node.ln_Succ;
	    FPrintf( Files->Std, "\t(struct Node *)&%sList.mlh_Tail, &%sNodes[%ld], 0, 0, ",
		     Label, Label, Num - 2 );

	    if( IE->SrcFlags & LOCALIZE )
		FPuts( Files->Std, "(STRPTR)" );

	    if( Prefs.Flags & SMART_STR )
		FPrintf( Files->Std, "%s", (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, gs->gs_Testo ))->ID );
	    else
		FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

	    FPuts( Files->Std, " };\n" );
	}

	FPrintf( Files->Std, "\nstruct MinList %sList = {\n"
			     "\t(struct MinNode *)&%sNodes[0], (struct MinNode *)NULL, (struct MinNode *)&%sNodes[%ld] };\n",
		 Label, Label, Label, Num - 1 );
    }
}
///

//      Locale stuff
/// WriteLocaleH
void WriteLocaleH( struct GenFiles *Files, struct IE_Data *IE, STRPTR FileName )
{
    BPTR    file;

    if( file = Open( FileName, MODE_NEWFILE )) {
	struct LocaleStr       *str;
	TEXT                    buffer[80];
	UBYTE                  *from, *to;
	ULONG                   num = 0;

	from = FilePart( FileName );
	to   = buffer;

	while( *from ) {
	    UBYTE   b;

	    b = *from++;

	    if( b == '.' )
		*to++ = '_';
	    else
		*to++ = toupper( b );
	}

	*to = '\0';


	FPrintf( file, "#ifndef %s\n#define %s\n\n"
		       "/* This file was generated automatically by IEditor!\n"
		       "   Do NOT edit by hand!\n"
		       " */\n\n"
		       "/*************************************************************************/\n\n"
		       "#ifndef EXEC_TYPES_H\n"
		       "#include <exec/types.h>\n"
		       "#endif\n\n"
		       "#ifdef CATCOMP_ARRAY\n"
		       "#undef CATCOMP_NUMBERS\n"
		       "#define CATCOMP_NUMBERS\n"
		       "#endif\n\n"
		       "struct CatCompArrayType\n"
		       "{\n"
		       "\tLONG\tcca_ID;\n"
		       "\tSTRPTR\tcca_Str;\n"
		       "};\n"
		       "\n"
		       "/*************************************************************************/\n\n"
		       "#ifdef CATCOMP_NUMBERS\n\n",
		       buffer, buffer );


	for( str = IE->Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ )
	    FPrintf( file, "#define %s %ld\n", str->ID, num++ );

	FPuts( file, "\n"
		     "#endif /* CATCOMP_NUMBERS */\n"
		     "\n"
		     "/*************************************************************************/\n\n"
		     "#ifdef CATCOMP_ARRAY\n\n"
		     "struct CatCompArrayType CatCompArray[] =\n"
		     "{\n" );

	for( str = IE->Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ )
	    FPrintf( file, "\t{%s,\"%s\"},\n", str->ID, str->Node.ln_Name );

	FPrintf( file, "};\n\n"
		       "#endif /* CATCOMP_ARRAY */\n"
		       "\n"
		       "#endif /* %s */\n",
		 buffer );

	Close( file );
    }
}
///
