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

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"

#include "Protos.h"
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

	FPrintf( Files->Std, "\nstruct Node %sNodes[] = {\n\t", Label );

	gs = List->mlh_Head;

	if( Num == 1 ) {
	    FPrintf( Files->Std, "(struct Node *)&%sList.mlh_Tail, (struct Node *)&%sList.mlh_Head, 0, 0, ",
		     Label, Label );

	    if( IE->C_Prefs & SMART_STR )
		FPrintf( Files->Std, "%s", (FindString( &Files->Strings, gs->gs_Testo ))->Label );
	    else
		FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

	    FPuts( Files->Std, " };\n" );
	} else {

	    FPrintf( Files->Std, "&%sNodes[1], (struct Node *)&%sList.mlh_Head, 0, 0, ",
		     Label, Label );

	    if( IE->C_Prefs & SMART_STR )
		FPrintf( Files->Std, "%s", (FindString( &Files->Strings, gs->gs_Testo ))->Label );
	    else
		FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

	    FPuts( Files->Std, ",\n" );

	    for( cnt = 1; cnt < Num - 1; cnt++ ) {

		gs = gs->gs_Node.ln_Succ;

		FPrintf( Files->Std, "\t&%sNodes[%ld], &%sNodes[%ld], 0, 0, ",
			 Label, cnt + 1, Label, cnt - 1 );

		if( IE->C_Prefs & SMART_STR )
		    FPrintf( Files->Std, "%s", (FindString( &Files->Strings, gs->gs_Testo ))->Label );
		else
		    FPrintf( Files->Std, "\"%s\"", gs->gs_Testo );

		FPuts( Files->Std, ",\n" );
	    }

	    gs = gs->gs_Node.ln_Succ;
	    FPrintf( Files->Std, "\t(struct Node *)&%sList.mlh_Tail, &%sNodes[%ld], 0, 0, ",
		     Label, Label, Num - 2 );

	    if( IE->C_Prefs & SMART_STR )
		FPrintf( Files->Std, "%s", (FindString( &Files->Strings, gs->gs_Testo ))->Label );
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
/// WriteCD
void WriteCD( struct GenFiles *Files )
{
    struct StringNode  *str;
    UWORD               cnt = 0;

    for( str = Files->Strings.mlh_Head; str->Next; str = str->Next ) {

	FPrintf( (BPTR)Files->User1, "MSG_STRING_%ld (//)\n%s\n;\n",
		 cnt, str->String );

	cnt += 1;
    }
}
///

