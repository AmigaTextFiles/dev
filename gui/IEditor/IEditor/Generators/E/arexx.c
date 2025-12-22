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


/// WriteRexxCmds
void WriteRexxCmds( struct GenFiles *Files, struct IE_Data *IE )
{
    struct RexxNode *rx;

    if( IE->NumRexxs ) {

	FPuts( Files->XDef, "extern UWORD\t\t\tRX_Unconfirmed;\n"
			    "extern struct MsgPort\t\t*RexxPort;\n"
			    "extern UBYTE\t\t\tRexxPortName[];\n"
			    "extern BOOL SetupRexxPort( void );\n"
			    "extern void DeleteRexxPort( void );\n"
			    "extern void HandleRexxMsg( void );\n"
			    "extern BOOL SendRexxMsg( char *Host, char *Ext, char *Command, APTR Msg, LONG Flags );\n" );

	if( IE->SrcFlags & AREXX_CMD_LIST ) {
	    FPuts( Files->XDef, "extern struct MinList\t\tRexxCommands;\n"
				"\n"
				"struct CmdNode {\n"
				"\tstruct Node\tNode;\n"
				"\tSTRPTR\tTemplate;\n"
				"\tLONG\t( *Routine )( ULONG *, struct RexxMsg * );\n"
				"};\n" );
	} else
	    FPuts( Files->Std, "\nstatic struct parser { char *command; char *template; LONG (*routine)(ULONG *, struct RexxMsg *); } CmdTable[] = {\n" );

	for( rx = IE->Rexx_List.mlh_Head; rx->rxn_Node.ln_Succ; rx = rx->rxn_Node.ln_Succ ) {

	    FPrintf( Files->XDef, "extern LONG %sRexxed( ULONG *ArgArray, struct RexxMsg *Msg );\n",
		     rx->rxn_Label );

	    if( IE->C_Prefs & GEN_TEMPLATE )
		FPrintf( Files->Temp, "\nLONG %sRexxed( ULONG *ArgArray, struct RexxMsg *Msg )\n"
				      "{\n"
				      "\t/*  Routine for the \"%s\" ARexx command  */\n"
				      "\treturn( 0L );\n"
				      "}\n",
			 rx->rxn_Label, rx->rxn_Name );
	}


	if( IE->SrcFlags & AREXX_CMD_LIST ) {

	    FPuts( Files->Std, "\nstatic struct CmdNode RexxCmds[] = {\n\t" );

	    rx = IE->Rexx_List.mlh_Head;

	    if( IE->NumRexxs == 1 ) {
		FPuts( Files->Std, "(struct CmdNode *)&RexxCommands.mlh_Tail, (struct CmdNode *)&RexxCommands.mlh_Head, 0, 0, " );

		FPrintf( Files->Std, "\"%s\", ", rx->rxn_Name );

		if( rx->rxn_Template[0] )
		    FPrintf( Files->Std, "\"%s\"", rx->rxn_Template );
		else
		    FPuts( Files->Std, Null );

		FPrintf( Files->Std, ", (APTR)%sRexxed\n", rx->rxn_Label );

		FPuts( Files->Std, " };\n" );
	    } else {

		FPuts( Files->Std, "&RexxCmds[1], (struct Node *)&RexxCommands.mlh_Head, 0, 0, " );

		FPrintf( Files->Std, "\"%s\", ", rx->rxn_Name );

		if( rx->rxn_Template[0] )
		    FPrintf( Files->Std, "\"%s\"", rx->rxn_Template );
		else
		    FPuts( Files->Std, Null );

		FPrintf( Files->Std, ", (APTR)%sRexxed,\n", rx->rxn_Label );

		ULONG   cnt;
		for( cnt = 1; cnt < IE->NumRexxs - 1; cnt++ ) {

		    rx = rx->rxn_Node.ln_Succ;

		    FPrintf( Files->Std, "\t&RexxCmds[%ld], &RexxCmds[%ld], 0, 0, ",
			     cnt + 1, cnt - 1 );

		    FPrintf( Files->Std, "\"%s\", ", rx->rxn_Name );

		    if( rx->rxn_Template[0] )
			FPrintf( Files->Std, "\"%s\"", rx->rxn_Template );
		    else
			FPuts( Files->Std, Null );

		    FPrintf( Files->Std, ", (APTR)%sRexxed,\n", rx->rxn_Label );
		}

		rx = rx->rxn_Node.ln_Succ;
		FPrintf( Files->Std, "\t(struct CmdNode *)&RexxCommands.mlh_Tail, &RexxCmds[%ld], 0, 0, ",
			 IE->NumRexxs - 2 );

		FPrintf( Files->Std, "\"%s\", ", rx->rxn_Name );

		if( rx->rxn_Template[0] )
		    FPrintf( Files->Std, "\"%s\"", rx->rxn_Template );
		else
		    FPuts( Files->Std, Null );

		FPrintf( Files->Std, ", (APTR)%sRexxed\n};\n", rx->rxn_Label );
	    }

	    FPrintf( Files->Std, "\nstruct MinList RexxCommands = {\n"
				 "\t(struct MinNode *)&RexxCmds[0], (struct MinNode *)NULL, (struct MinNode *)&RexxCmds[%ld] };\n",
		     IE->NumRexxs - 1 );

	} else {

	    for( rx = IE->Rexx_List.mlh_Head; rx->rxn_Node.ln_Succ; rx = rx->rxn_Node.ln_Succ ) {

		FPrintf( Files->Std, "\t\"%s\", ", rx->rxn_Name );

		if( rx->rxn_Template[0] )
		    FPrintf( Files->Std, "\"%s\"", rx->rxn_Template );
		else
		    FPuts( Files->Std, Null );

		FPrintf( Files->Std, ", (APTR)%sRexxed,\n", rx->rxn_Label );
	    }

	    FPuts( Files->Std, "\tNULL\n};\n" );
	}
    }
}
///

