/*
**
**    C.generator - Copyright © 1996-1997 Simone Tellini
**                  All Rights Reserved
**
**    This is the standard C generator. You can easily modify this
**    source to adapt it to your own needs.
**
**    You can spread modified copies of this code, provided that you
**    respect these rules:
**    - you MUST leave my name in it; if someone has modified the
**      code before you, you MUST leave his name too
**    - you MUST distribute the new generator in a small archive
**      along with a little doc
**    - the new generator should be FREEWARE, it can NOT be SHAREWARE
**    - you should send me an e-mail telling me what kind of changes
**      you've performed and the name of the archive
**
**
*/

/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/nodes.h>
#include <dos/dos.h>                    // dos
#include <dos/dostags.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/gadgetclass.h>
#include <graphics/text.h>              // graphics
#include <libraries/gadtools.h>         // libraries
#include <libraries/reqtools.h>
#include <clib/exec_protos.h>           // protos
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/reqtools_pragmas.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"
#include "DEV_IE:Generators/C/Protos.h"
///
/// Data
struct CPrefs   Prefs = {
	    INTUIMSG | CLICKED | IDCMP_HANDLER | KEY_HANDLER | TO_LOWER,
	    0,
	    "UWORD __chip",
	    "",
	    "%s __saveds __asm",
	    "register __a%ld stuff"
};

ULONG idcmps[] = {
	    1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200,
	    0x400, 0x800, 0x1000, 0x2000, 0x4000, 0x8000,
	    0x10000, 0x20000, 0x40000, 0x80000, 0x100000,
	    0x200000, 0x400000, 0x800000, 0x1000000,
	    0x2000000, 0x4000000
      };

ULONG wflgs[] = {
	    1, 2, 4, 8, 0x10, 0x20, 0, 0x40, 0x80, 0x100, 0x200,
	    0x400, 0x800, 0x1000, 0x10000, 0x20000, 0x40000,
	    0x200000
      };

UBYTE Header[] =
    "/*\n"
    "    C source code created by Interface Editor\n"
    "    Copyright © 1994-1996 by Simone Tellini\n\n"
    "    Generator:  %s\n"
    "    Copy registered to :  %s\n"
    "    Serial Number      : #%ld\n"
    "*/\n\n";

UBYTE   Null[] = "NULL";

static UBYTE   ARexxHandleArray[] = "\n"
		      "void HandleRexxMsg( void )\n"
		      "{\n"
		      "\tULONG\t\tArgArray[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };\n"
		      "\tWORD\t\tn;\n"
		      "\tstruct RDArgs\t*args = NULL, *rdargs;\n"
		      "\tstruct RexxMsg\t*RxMsg;\n"
		      "\tUBYTE\t\tbuffer[1024], command[256];\n"
		      "\tUBYTE\t\t*arguments;\n"
		      "\tBOOL\t\tfound = FALSE, fail = FALSE;\n"
		      "\n"
		      "\twhile( RxMsg = (struct RexxMsg *)GetMsg( RexxPort )) {\n\n"
		      "\t\tif( RxMsg->rm_Node.mn_Node.ln_Type == NT_REPLYMSG ) {\n\n"
		      "\t\t\tif( RxMsg->rm_Args[15] )\n"
		      "\t\t\t\tReplyMsg(( struct Message * )RxMsg->rm_Args[15] );\n\n"
		      "\t\t\tDeleteArgstring( RxMsg->rm_Args[0] );\n"
		      "\t\t\tDeleteRexxMsg( RxMsg );\n"
		      "\t\t\tRX_Unconfirmed -= 1;\n"
		      "\t\t}\n"
		      "\t\telse {\n\n"
		      "\t\t\tRxMsg->rm_Result1 = NULL;\n"
		      "\t\t\tRxMsg->rm_Result2 = NULL;\n"
		      "\t\t\tstrcpy( buffer, RxMsg->rm_Args[0] );\n"
		      "\n"
		      "\t\t\tn = 0;\n"
		      "\t\t\twhile(( buffer[n] != '\\0' ) && ( buffer[n] != ' ' )) {\n"
		      "\t\t\t\tcommand[n] = buffer[n];\n"
		      "\t\t\t\tn++;\n"
		      "\t\t\t};\n"
		      "\t\t\tcommand[n] = '\\0';\n\n"
		      "\t\t\tn = 0;\n"
		      "\t\t\twhile( CmdTable[n].command ) {\n"
		      "\t\t\t\tif( stricmp( CmdTable[n].command, command ) == 0 ) {\n"
		      "\t\t\t\t\tfound = TRUE;\n"
		      "\t\t\t\t\tbreak;\n"
		      "\t\t\t\t} else\n"
		      "\t\t\t\t\tn++;\n"
		      "\t\t\t};\n\n"
		      "\t\t\tif( found ) {\n"
		      "\t\t\t\tif( CmdTable[n].template ) {\n"
		      "\t\t\t\t\tif( args = AllocDosObject( DOS_RDARGS, NULL )) {\n\n"
		      "\t\t\t\t\t\targuments = buffer + strlen( CmdTable[n].command );\n\n"
		      "\t\t\t\t\t\tstrcat( arguments, \"\\12\" );\n"
		      "\t\t\t\t\t\targs->RDA_Source.CS_Buffer = arguments;\n"
		      "\t\t\t\t\t\targs->RDA_Source.CS_Length = strlen( arguments );\n"
		      "\t\t\t\t\t\targs->RDA_Source.CS_CurChr = 0;\n"
		      "\t\t\t\t\t\targs->RDA_DAList           = NULL;\n"
		      "\t\t\t\t\t\targs->RDA_Buffer           = NULL;\n"
		      "\t\t\t\t\t\targs->RDA_BufSiz           = 0L;\n"
		      "\t\t\t\t\t\targs->RDA_Flags           |= RDAF_NOPROMPT;\n"
		      "\n"
		      "\t\t\t\t\t\tif( rdargs = ReadArgs( CmdTable[n].template, ArgArray, args )) {\n\n"
		      "\t\t\t\t\t\t\tRxMsg->rm_Result1 = (*CmdTable[n].routine)(ArgArray, RxMsg);\n"
		      "\t\t\t\t\t\t\tFreeArgs( rdargs );\n\n"
		      "\t\t\t\t\t\t} else\n"
		      "\t\t\t\t\t\t\tfail = TRUE;\n\n"
		      "\t\t\t\t\t\tFreeDosObject( DOS_RDARGS, args );\n\n"
		      "\t\t\t\t\t} else\n"
		      "\t\t\t\t\t\tfail = TRUE;\n\n"
		      "\t\t\t\t} else\n"
		      "\t\t\t\t\tRxMsg->rm_Result1 = (*CmdTable[n].routine)(ArgArray, RxMsg);\n\n"
		      "\t\t\t} else {\n\n"
		      "\t\t\t\tif(!( SendRexxMsg( \"REXX\", REXX_ext, RxMsg->rm_Args[0], RxMsg, 0 )))\n"
		      "\t\t\t\t\tfail = TRUE;\n\n"
		      "\t\t\t};\n\n"
		      "\t\t\tif( fail )\n"
		      "\t\t\t\tRxMsg->rm_Result1 = RC_FATAL;\n\n"
		      "\t\t\tif( found )\n"
		      "\t\t\t\tReplyMsg(( struct Message * )RxMsg );\n\n"
		      "\t\t}\n"
		      "\t}\n"
		      "}\n";

static UBYTE   ARexxHandleList[] = "\n"
		      "void HandleRexxMsg( void )\n"
		      "{\n"
		      "\tULONG\t\tArgArray[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };\n"
		      "\tWORD\t\tn;\n"
		      "\tstruct RDArgs\t*args = NULL, *rdargs;\n"
		      "\tstruct RexxMsg\t*RxMsg;\n"
		      "\tUBYTE\t\tbuffer[1024], command[256];\n"
		      "\tUBYTE\t\t*arguments;\n"
		      "\tBOOL\t\tfound = FALSE, fail = FALSE;\n"
		      "\n"
		      "\twhile( RxMsg = (struct RexxMsg *)GetMsg( RexxPort )) {\n\n"
		      "\t\tif( RxMsg->rm_Node.mn_Node.ln_Type == NT_REPLYMSG ) {\n\n"
		      "\t\t\tif( RxMsg->rm_Args[15] )\n"
		      "\t\t\t\tReplyMsg(( struct Message * )RxMsg->rm_Args[15] );\n\n"
		      "\t\t\tDeleteArgstring( RxMsg->rm_Args[0] );\n"
		      "\t\t\tDeleteRexxMsg( RxMsg );\n"
		      "\t\t\tRX_Unconfirmed -= 1;\n"
		      "\t\t}\n"
		      "\t\telse {\n\n"
		      "\t\t\tRxMsg->rm_Result1 = NULL;\n"
		      "\t\t\tRxMsg->rm_Result2 = NULL;\n"
		      "\t\t\tstrcpy( buffer, RxMsg->rm_Args[0] );\n"
		      "\n"
		      "\t\t\tn = 0;\n"
		      "\t\t\twhile(( buffer[n] != '\\0' ) && ( buffer[n] != ' ' )) {\n"
		      "\t\t\t\tcommand[n] = buffer[n];\n"
		      "\t\t\t\tn++;\n"
		      "\t\t\t};\n"
		      "\t\t\tcommand[n] = '\\0';\n\n"
		      "\t\t\tn = 0;\n"
		      "\t\t\tstruct CmdNode *Cmd;\n"
		      "\t\t\tfor( Cmd = RexxCommands.mlh_Head; Cmd->Node.ln_Succ; Cmd = Cmd->Node.ln_Succ ) {\n"
		      "\t\t\t\tif( stricmp( Cmd->Node.ln_Name, command ) == 0 ) {\n"
		      "\t\t\t\t\tfound = TRUE;\n"
		      "\t\t\t\t\tbreak;\n"
		      "\t\t\t\t}"
		      "\t\t\t};\n\n"
		      "\t\t\tif( found ) {\n"
		      "\t\t\t\tif( Cmd->Template ) {\n"
		      "\t\t\t\t\tif( args = AllocDosObject( DOS_RDARGS, NULL )) {\n\n"
		      "\t\t\t\t\t\targuments = buffer + strlen( Cmd->Node.ln_Name );\n\n"
		      "\t\t\t\t\t\tstrcat( arguments, \"\\12\" );\n"
		      "\t\t\t\t\t\targs->RDA_Source.CS_Buffer = arguments;\n"
		      "\t\t\t\t\t\targs->RDA_Source.CS_Length = strlen( arguments );\n"
		      "\t\t\t\t\t\targs->RDA_Source.CS_CurChr = 0;\n"
		      "\t\t\t\t\t\targs->RDA_DAList           = NULL;\n"
		      "\t\t\t\t\t\targs->RDA_Buffer           = NULL;\n"
		      "\t\t\t\t\t\targs->RDA_BufSiz           = 0L;\n"
		      "\t\t\t\t\t\targs->RDA_Flags           |= RDAF_NOPROMPT;\n"
		      "\n"
		      "\t\t\t\t\t\tif( rdargs = ReadArgs( Cmd->Template, ArgArray, args )) {\n\n"
		      "\t\t\t\t\t\t\tRxMsg->rm_Result1 = (*Cmd->Routine)(ArgArray, RxMsg);\n"
		      "\t\t\t\t\t\t\tFreeArgs( rdargs );\n\n"
		      "\t\t\t\t\t\t} else\n"
		      "\t\t\t\t\t\t\tfail = TRUE;\n\n"
		      "\t\t\t\t\t\tFreeDosObject( DOS_RDARGS, args );\n\n"
		      "\t\t\t\t\t} else\n"
		      "\t\t\t\t\t\tfail = TRUE;\n\n"
		      "\t\t\t\t} else\n"
		      "\t\t\t\t\tRxMsg->rm_Result1 = (*Cmd->Routine)(ArgArray, RxMsg);\n\n"
		      "\t\t\t} else {\n\n"
		      "\t\t\t\tif(!( SendRexxMsg( \"REXX\", REXX_ext, RxMsg->rm_Args[0], RxMsg, 0 )))\n"
		      "\t\t\t\t\tfail = TRUE;\n\n"
		      "\t\t\t};\n\n"
		      "\t\t\tif( fail )\n"
		      "\t\t\t\tRxMsg->rm_Result1 = RC_FATAL;\n\n"
		      "\t\t\tif( found )\n"
		      "\t\t\t\tReplyMsg(( struct Message * )RxMsg );\n\n"
		      "\t\t}\n"
		      "\t}\n"
		      "}\n";


static UBYTE   ARexxCode[] = "\nBOOL SetupRexxPort( void )\n"
		      "{\n"
		      "\tUWORD\t\tcnt = 0;\n"
		      "\n"
		      "\tForbid();\n"
		      "\n"
		      "\tdo {\n"
		      "\t\tcnt += 1;\n"
		      "\t\tsprintf( RexxPortName, RexxPort_fmt, cnt );\n"
		      "\t} while( FindPort( RexxPortName ));\n"
		      "\n"
		      "\tRexxPort = CreateMsgPort();\n"
		      "\tif (!RexxPort) {\n"
		      "\t\tPermit();\n"
		      "\t\treturn( FALSE );\n"
		      "\t};\n"
		      "\n"
		      "\tRexxPort->mp_Node.ln_Name = RexxPortName;\n"
		      "\tRexxPort->mp_Node.ln_Pri  = 0;\n"
		      "\n"
		      "\tAddPort( RexxPort );\n\n"
		      "\tPermit();\n\n"
		      "\treturn( TRUE );\n"
		      "}\n"
		      "\n"
		      "void DeleteRexxPort( void )\n"
		      "{\n"
		      "\tAPTR\tm;\n\n"
		      "\tif (!RexxPort)\n"
		      "\t\treturn;\n"
		      "\n"
		      "\twhile( RX_Unconfirmed ) {\n"
		      "\t\tWaitPort( RexxPort );\n"
		      "\t\tHandleRexxMsg();\n"
		      "\t};\n"
		      "\n"
		      "\tForbid();\n"
		      "\tRemPort( RexxPort );\n\n"
		      "\twhile( m = GetMsg( RexxPort ))\n"
		      "\t\tReplyMsg( m );\n\n"
		      "\tDeleteMsgPort( RexxPort );\n"
		      "\tRexxPort = NULL;\n"
		      "\tPermit();\n"
		      "}\n"
		      "\n"
		      "BOOL SendRexxMsg( char *Host, char *Ext, char *Command, APTR Msg, LONG Flags )\n"
		      "{\n"
		      "\tAPTR\t\tstring;\n"
		      "\tstruct MsgPort\t*Port;\n"
		      "\tstruct RexxMsg\t*RxMsg;\n\n"
		      "\tif(!( RexxPort ))\n"
		      "\t\treturn( FALSE );\n"
		      "\n"
		      "\tif(!( RxMsg = CreateRexxMsg( RexxPort, Ext, RexxPortName )))\n"
		      "\t\treturn( FALSE );\n"
		      "\n"
		      "\tif(!( string = CreateArgstring( Command, strlen( Command )))) {\n"
		      "\t\tDeleteRexxMsg( RxMsg );\n"
		      "\t\treturn( FALSE );\n"
		      "\t};\n\n"
		      "\tRxMsg->rm_Args[0]  = string;\n"
		      "\tRxMsg->rm_Args[15] = Msg;\n"
		      "\tRxMsg->rm_Action   = Flags | RXCOMM;\n"
		      "\n"
		      "\tForbid();\n"
		      "\tif( Port = FindPort( Host ))\n"
		      "\t\tPutMsg( Port, ( struct Message * )RxMsg );\n"
		      "\tPermit();\n\n"
		      "\tif( Port ) {\n"
		      "\t\tRX_Unconfirmed += 1;\n"
		      "\t\treturn( TRUE );\n"
		      "\t} else {\n"
		      "\t\tDeleteArgstring( string );\n"
		      "\t\tDeleteRexxMsg( RxMsg );\n"
		      "\t\treturn( FALSE );\n"
		      "\t};\n"
		      "}\n";

///


//  ***  Main Routines  ***
/// GrabOldPrefs
void GrabOldPrefs( struct IE_Data *IE )
{
    if(!( PrefsOK )) {

	Prefs.Flags = IE->C_Prefs;

	strcpy( Prefs.ChipString, IE->ChipString );

	PrefsOK = TRUE;
    }
}
///

/// OpenFiles
struct GenFiles *OpenFiles( __A0 struct IE_Data *IE, __A1 UBYTE *BaseName )
{
    UBYTE               buffer[1024], buffer2[1024];
    UBYTE              *ptr, *ptr2, *ptr3;
    struct GenFiles    *Files;

    GrabOldPrefs( IE );

    if(!( Files = AllocMem( sizeof( struct GenFiles ), MEMF_CLEAR )))
	return( NULL );

    ptr2 = FilePart( BaseName );

    ptr  = BaseName;
    ptr3 = buffer;
    while( ptr != ptr2 )
	*ptr3++ = *ptr++;

    *ptr3 = '\0';

    ptr = buffer2;
    while(( *ptr2 != '.' ) && ( *ptr2 ))
	*ptr++ = *ptr2++;
    *ptr = '\0';

    AddPart( buffer, buffer2, 1024 );

    strcpy( buffer2, buffer );
    strcat( buffer2, ".c" );

    if(!( Files->Std = Open( buffer2, MODE_NEWFILE )))
	return( NULL );

    strcpy( buffer2, buffer );
    strcat( buffer2, ".h" );
    strcpy( Files->XDefName, buffer2 );

    if(!( Files->XDef = Open( buffer2, MODE_NEWFILE )))
	goto error;


    if( Prefs.Flags & GEN_TEMPLATE ) {

	strcpy( buffer2, buffer );
	strcat( buffer2, "_temp.c" );

	if(!( Files->Temp = Open( buffer2, MODE_NEWFILE )))
	    goto error;

    }

    if( IE->SrcFlags & MAINPROC ) {

	strcpy( buffer2, buffer );
	strcat( buffer2, "Main.c" );

	if( AskFile( buffer2, IE ))
	    if(!( Files->Main = Open( buffer2, MODE_NEWFILE )))
		goto error;
    }

    if( IE->SrcFlags & LOCALIZE ) {
	Files->User1 = IE;
	Prefs.Flags |= SMART_STR;
    }

    return( Files );


error:

    CloseFiles( Files );

    return( NULL );
}
///
/// CloseFiles
void CloseFiles( __A0 struct GenFiles *Files )
{
    if( Files ) {
	if( Files->Std   )  Close( Files->Std   );
	if( Files->Temp  )  Close( Files->Temp  );
	if( Files->XDef  )  Close( Files->XDef  );
	if( Files->Main  )  Close( Files->Main  );

	if( Files->User1 ) {
	    UBYTE  *from, *to, *ptr;
	    UBYTE   path[256], locale[256];

	    /* get the path where the files must be created */

	    from = Files->XDefName;
	    to   = FilePart( Files->XDefName );
	    ptr  = path;

	    while( from < to )
		*ptr++ = *from++;

	    *ptr = '\0';

	    /* build the name of the locale file */

	    ptr = locale;

	    while( *to != '.' )
		*ptr++ = *to++;

	    *ptr = '\0';

	    strcat( locale, "_Locale.h" );


	    if( Prefs.MoreFlags & USE_CATCOMP ) {
		UBYTE   command[ 1024 ];

		/* built the command line */

		strcpy( command, "CatComp \"" );
		strcat( command, path );
		strcat( command, ((struct IE_Data *)Files->User3 )->Locale->Catalog );
		strcat( command, ".cd\" CFILE \"" );
		strcat( command, path );
		strcat( command, locale );
		strcat( command, "\"" );

		/* and execute it */

		SystemTagList( command, NULL );

	    } else {
		AddPart( path, locale, 256 );
		WriteLocaleH( Files, (struct IE_Data *)Files->User1, path );
	    }
	}

	FreeMem( Files, sizeof( struct GenFiles ));
    }
}
///

/// WriteHeaders
BOOL WriteHeaders( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    APTR                UserHeaders = NULL;
    struct WindowInfo  *wnd;
    struct GadgetInfo  *gad;
    ULONG               cnt;


    if( Prefs.HeadersFile[0] ) {
	ULONG   size;
	BPTR    file;

	if( file = Open( Prefs.HeadersFile, MODE_OLDFILE )) {

	    Seek( file, 0, OFFSET_END );
	    size = Seek( file, 0, OFFSET_BEGINNING );

	    if( UserHeaders = AllocVec( size, MEMF_ANY )) {

		Read( file, UserHeaders, size );

		( *IE->IEXFun->SplitLines )( UserHeaders ); // VERY important!
	    }

	    Close( file );
	}
    }


    FPrintf( Files->Std,  Header, LibId, IE->User->Name, IE->User->Number );
    FPrintf( Files->XDef, Header, LibId, IE->User->Name, IE->User->Number );

    if( Files->Temp ) {
	FPrintf( Files->Temp, Header, LibId, IE->User->Name, IE->User->Number );

	FPuts( Files->Temp,
	    "/*\n"
	    "   In this file you'll find empty  template  routines\n"
	    "   referenced in the GUI source.  You  can fill these\n"
	    "   routines with your code or use them as a reference\n"
	    "   to create your main program.\n"
	    "*/\n\n"
	    "#include <stdio.h>\n"
	    "#include <exec/types.h>\n\n" );
    }

    if( Files->Main ) {
	FPrintf( Files->Main, Header, LibId, IE->User->Name, IE->User->Number );
	WriteMain( Files, IE );
    }

    if( UserHeaders == NULL ) {

	FPuts( Files->Std, "#include <exec/types.h>\n"
			   "#include <exec/nodes.h>\n"
			   "#include <intuition/intuition.h>\n"
			   "#include <intuition/gadgetclass.h>\n"
			   "#include <graphics/clip.h>\n"
			   "#include <graphics/gfxmacros.h>\n"
			   "#include <libraries/gadtools.h>\n"
			   "#include <clib/exec_protos.h>\n"
			   "#include <clib/intuition_protos.h>\n"
			   "#include <clib/gadtools_protos.h>\n"
			   "#include <clib/graphics_protos.h>\n"
			   "#ifdef PRAGMAS\n"
			   "#include <pragmas/exec_pragmas.h>\n"
			   "#include <pragmas/intuition_pragmas.h>\n"
			   "#include <pragmas/graphics_pragmas.h>\n"
			   "#include <pragmas/gadtools_pragmas.h>\n"
			   "#endif\n"
			   "#include <ctype.h>\n"
			   "#include <string.h>\n\n" );

	FPuts( Files->XDef, "#ifndef EXEC_TYPES_H\n"
			    "#include <exec/types.h>\n"
			    "#endif\n"
			    "#ifndef EXEC_NODES_H\n"
			    "#include <exec/nodes.h>\n"
			    "#endif\n"
			    "#ifndef INTUITION_INTUITION_H\n"
			    "#include <intuition/intuition.h>\n"
			    "#endif\n"
			    "#ifndef INTUITION_GADGETCLASS_H\n"
			    "#include <intuition/gadgetclass.h>\n"
			    "#endif\n"
			    "#ifndef LIBRARIES_GADTOOLS_H\n"
			    "#include <libraries/gadtools.h>\n"
			    "#endif\n"
			    "#ifndef CLIB_EXEC_PROTOS_H\n"
			    "#include <clib/exec_protos.h>\n"
			    "#endif\n"
			    "#ifndef CLIB_INTUITION_PROTOS_H\n"
			    "#include <clib/intuition_protos.h>\n"
			    "#endif\n"
			    "#ifndef CLIB_GADTOOLS_PROTOS_H\n"
			    "#include <clib/gadtools_protos.h>\n"
			    "#endif\n"
			    "#ifndef CLIB_GRAPHICS_PROTOS_H\n"
			    "#include <clib/graphics_protos.h>\n"
			    "#endif\n"
			    "#ifndef CTYPE_H\n"
			    "#include <ctype.h>\n"
			    "#endif\n"
			    "#ifndef STRING_H\n"
			    "#include <string.h>\n"
			    "#endif\n\n" );
    } else {
	STRPTR  inc;

	if( inc = ( *IE->IEXFun->GetFirstLine )( UserHeaders, "STANDARD" )) {

	    FPuts( Files->Std,  inc );
	    FPuts( Files->XDef, inc );
	}
    }


    if( CheckMultiSelect( IE ))
	FPuts( Files->XDef, "#include <utility/hooks.h>\n" );


    if( IE->SrcFlags & OPENDISKFONT ) {
	if( UserHeaders ) {
	    STRPTR  inc;

	    if( inc = ( *IE->IEXFun->GetFirstLine )( UserHeaders, "DISKFONT" ))
		FPuts( Files->Std,  inc );

	} else
	    FPuts( Files->Std, "#include <clib/diskfont_protos.h>\n\n" );
    }

    if( IE->NumRexxs ) {
	if( UserHeaders ) {
	    STRPTR  inc;

	    if( inc = ( *IE->IEXFun->GetFirstLine )( UserHeaders, "AREXX" ))
		FPuts( Files->Std,  inc );

	} else
	    FPuts( Files->Std, "#include <rexx/rxslib.h>\n"
			       "#include <rexx/rexxio.h>\n"
			       "#include <rexx/errors.h>\n"
			       "#include <rexx/storage.h>\n"
			       "#include <dos/dos.h>\n"
			       "#include <dos/rdargs.h>\n"
			       "#include <clib/dos_protos.h>\n"
			       "#include <clib/rexxsyslib_protos.h>\n"
			       "#include <clib/alib_stdio_protos.h>\n"
			       "#ifdef PRAGMAS\n"
			       "#include <pragmas/dos_pragmas.h>\n"
			       "#include <pragmas/rexxsyslib_pragmas.h>\n"
			       "#endif\n\n" );
    }

    if( IE->SrcFlags & LOCALIZE ) {
	if( UserHeaders ) {
	    STRPTR  inc;

	    if( inc = ( *IE->IEXFun->GetFirstLine )( UserHeaders, "LOCALE" ))
		FPuts( Files->Std,  inc );

	} else
	   FPuts( Files->Std, "#include <libraries/locale.h>\n"
			       "#include <clib/locale_protos.h>\n"
			       "#ifdef PRAGMAS\n"
			       "#include <pragmas/locale_pragmas.h>\n"
			       "#endif\n\n" );
    }

    FPrintf( Files->Std, "#include \"%s\"\n\n", FilePart( Files->XDefName ));

    if( IE->SrcFlags & LOCALIZE ) {

	UBYTE   *to, buffer[60];

	strcpy( buffer, FilePart( Files->XDefName ));

	to = strrchr( buffer, '.' );
	*to = '\0';

	strcat( buffer, "_Locale.h" );

	FPrintf( Files->Std, "#define CATCOMP_ARRAY\n"
			     "#include \"%s\"\n\n",
		 buffer );
    }


    FPuts( Files->XDef, "#define GetString( g )\t((( struct StringInfo * )g->SpecialInfo )->Buffer  )\n"
			"#define GetNumber( g )\t((( struct StringInfo * )g->SpecialInfo )->LongInt )\n\n"
			"#define WT_LEFT\t\t\t\t0\n"
			"#define WT_TOP\t\t\t\t1\n"
			"#define WT_WIDTH\t\t\t2\n"
			"#define WT_HEIGHT\t\t\t3\n\n" );

    for( cnt = 0; cnt < 3; cnt++ ) {
	TEXT    buf[32];

	sprintf( buf, Prefs.RegisterDef, cnt );

	FPrintf( Files->XDef, "#define A%ld(stuff) %s\n", cnt, buf );
    }


    if( IE->SrcFlags & LOCALIZE )
	FPuts( Files->XDef, "extern struct CatCompArrayType CatCompArray[];\n"
			    "extern struct Library *LocaleBase;\n\n" );

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	struct GadgetBank  *bank;

	cnt = 0;
	for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
	    if( gad->g_Kind < MIN_IEX_ID ) {
		FPrintf( Files->XDef, "#define GD_%s\t\t\t\t\t%ld\n", gad->g_Label, cnt );
		cnt += 1;
	    }


	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ )
	    for( cnt = 0, gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_Kind < MIN_IEX_ID ) {
		    FPrintf( Files->XDef, "#define GD_%s\t\t\t\t\t%ld\n", gad->g_Label, cnt );
		    cnt += 1;
		}


	if( cnt )
	    FPutC( Files->XDef, 10 );
    }

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	struct GadgetBank  *bank;

	cnt = wnd->wi_NumGads - wnd->wi_NumBools;
	if( cnt )
	    FPrintf( Files->XDef, "#define %s_CNT %ld\n", wnd->wi_Label, cnt );

	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
	    struct GadgetInfo  *gad;

	    for( cnt = 0, gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_Kind < BOOLEAN )
		    cnt += 1;

	    if( cnt )
		FPrintf( Files->XDef, "#define %s_CNT %ld\n", bank->Label, cnt );
	}
    }

    FPutC( Files->XDef, '\n' );

    ( *IE->IEXSrcFun->Headers )( Files );

    return( TRUE );
}
///
/// WriteVars
BOOL WriteVars( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    int                 cnt;
    struct WindowInfo  *wnd;

    FPuts( Files->Std, "APTR\t\t\tVisualInfo;\n"
		       "int\t\t\tYOffset;\n"
		       "UWORD\t\t\tXOffset;\n"
		       "struct Screen\t\t*Scr = NULL;\n" );

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	if( wnd->wi_NumGBanks ) {

	    FPuts( Files->XDef, "struct WindowBanks {\n"
				"\tstruct Gadget **Banks;\n"
				"\tUWORD           Count;\n"
				"};\n\n" );
	    break;
	}


    FPuts( Files->XDef, "extern struct IntuitionBase\t*IntuitionBase;\n"
			"extern struct Library\t\t*GadToolsBase;\n"
			"extern struct Library\t\t*GfxBase;\n"
			"extern struct Screen\t\t*Scr;\n"
			"extern int\t\t\tYOffset;\n"
			"extern UWORD\t\t\tXOffset;\n"
			"extern APTR\t\t\tVisualInfo;\n" );

    if( IE->SrcFlags & FONTSENSITIVE )
	FPuts( Files->Std, "struct TextAttr\t\t*Font, Attr;\n"
			   "UWORD\t\t\tFontX, FontY;\n" );

    if(!( IE->flags_2 & GENERASCR )) {
	FPuts( Files->Std,  "UBYTE\t\t\t*PubScreenName = NULL;\n" );
	FPuts( Files->XDef, "extern UBYTE\t\t\t*PubScreenName;\n" );
    } else {
	if( IE->ScreenData->ScrAttrs & SC_ERRORCODE ) {
	    FPuts( Files->Std,  "ULONG\t\t\tScreenError = NULL;\n" );
	    FPuts( Files->XDef, "extern ULONG\t\t\tScreenError;\n" );
	}
    }

    if( IE->SrcFlags & LOCALIZE ) {
	FPrintf( Files->Std, "UBYTE\t\t\tLocalized[ %ld ];\n"
			     "struct Catalog\t\t*Catalog = NULL;\n",
		 IE->num_win );
	FPuts( Files->XDef, "extern struct Catalog\t\t*Catalog;\n" );
    }

    if( IE->NumRexxs ) {
	FPrintf( Files->Std, "UWORD\t\t\tRX_Unconfirmed;\n"
			     "struct MsgPort\t\t*RexxPort;\n"
			     "UBYTE\t\t\tRexxPortName[%ld];\n"
			     "const char\t\t*RexxPort_fmt = \"%s.%%d\";\n"
			     "const char\t\t*REXX_ext = \"%s\";\n",
		 strlen( IE->RexxPortName ) + 4,
		 IE->RexxPortName, IE->RexxExt );
    }

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	FPrintf( Files->Std,  "struct Window\t\t*%sWnd = NULL;\n", wnd->wi_Label );
	FPrintf( Files->XDef, "extern struct Window\t\t*%sWnd;\n", wnd->wi_Label );
    }

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumMenus ) {
	    FPrintf( Files->Std,  "struct Menu\t\t*%sMenus = NULL;\n", wnd->wi_Label );
	    FPrintf( Files->XDef, "extern struct Menu\t\t*%sMenus;\n", wnd->wi_Label );
	}
    }


    //      Gadget Lists

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {
	    FPrintf( Files->Std,  "struct Gadget\t\t*%sGList = NULL;\n", wnd->wi_Label );
	    FPrintf( Files->XDef, "extern struct Gadget\t\t*%sGList;\n", wnd->wi_Label );
	}
    }


    //      Gadget Banks

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGBanks ) {
	    struct GadgetBank  *bank;

	    FPrintf( Files->Std,  "static struct Gadget\t*%sGBanks[%ld];\n"
				  "struct WindowBanks\t%sWBanks = { &%sGBanks[ 0 ], 0 };\n",
				  wnd->wi_Label, wnd->wi_NumGBanks,
				  wnd->wi_Label, wnd->wi_Label );
	    FPrintf( Files->XDef, "extern struct WindowBanks\t\t%sWBanks;\n", wnd->wi_Label );

	    for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
		struct GadgetInfo  *gad;
		ULONG               count = 0;

		for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		    if( gad->g_Kind < BOOLEAN )
			count += 1;

		if( count ) {
		    FPrintf( Files->Std,  "struct Gadget\t\t*%sGList = NULL;\n"
					  "struct Gadget\t\t*%sGadgets[%ld];\n",
					  bank->Label, bank->Label, count );

		    FPrintf( Files->XDef, "extern struct Gadget\t\t*%sGList;\n"
					  "extern struct Gadget\t\t*%sGadgets[%ld];\n",
					 bank->Label, bank->Label, count );
		}
	    }
	}
    }


    //      IntuiMessages

    if( Prefs.Flags & INTUIMSG ) {
	for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	    if(!(( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT ))) {
		FPrintf( Files->Std,  "struct IntuiMessage\t%sMsg;\n", wnd->wi_Label );
		FPrintf( Files->XDef, "extern struct IntuiMessage\t%sMsg;\n", wnd->wi_Label );
	    }
	}
    }



    //      Gadget Pointers Arrays

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	cnt = wnd->wi_NumGads - wnd->wi_NumBools;
	if( cnt ) {
	    FPrintf( Files->Std,  "struct Gadget\t\t*%sGadgets[%ld];\n", wnd->wi_Label, cnt );
	    FPrintf( Files->XDef, "extern struct Gadget\t\t*%sGadgets[%ld];\n", wnd->wi_Label, cnt );
	}
    }


    if( IE->SrcFlags & SHARED_PORT ) {
	Files->User2 = IE->SharedPort[0] ? (APTR)&IE->SharedPort[0] : (APTR)"IDCMPPort";

	FPrintf( Files->XDef, "extern struct MsgPort\t\t*%s;\n"
			      "extern struct IntuiMessage\tIDCMPMsg;\n"
			      "extern LONG OpenWndShd( struct Gadget *, struct TagItem *, struct Window **, ULONG );\n"
			      "extern void CloseWndShd( struct Window **, struct Gadget **, struct Menu ** );\n"
			      "extern void HandleIDCMPPort( void );\n",
		 Files->User2 );

	if(!( IE->SharedPort[0] ))
	    FPuts( Files->Std, "\nstruct MsgPort\t\t*IDCMPPort;\n" );

	FPuts( Files->Std, "struct IntuiMessage\tIDCMPMsg;\n" );
    }


    // Expanders
    ( *IE->IEXSrcFun->Globals )( Files );

    if( IE->SrcFlags & OPENDISKFONT )
	WriteFontPtrs( Files, IE );

    return( TRUE );
}
///
/// WriteData
BOOL WriteData( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct TxtAttrNode *fnt;

    // Gadget Labels

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	WriteGLabels( Files, IE, &wnd->wi_Gadgets, wnd );


    // Gadget Types

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {

	    FPrintf( Files->XDef, "extern UWORD\t\t\t%sGTypes[];\n", wnd->wi_Label );
	    FPrintf( Files->Std, "\nUWORD %sGTypes[] = {\n\t", wnd->wi_Label );

	    WriteGTypes( Files, IE, &wnd->wi_Gadgets );
	}
    }

    // Fonts

    for( fnt = IE->FntLst.mlh_Head; fnt->txa_Next; fnt = fnt->txa_Next ) {
	FPrintf( Files->XDef, "extern struct TextAttr\t\t%s;\n", fnt->txa_Label );
	FPrintf( Files->Std, "\nstruct TextAttr %s = {\n"
			     "\t(STRPTR)\"%s\", %ld, 0x%lx, 0x%lx };\n",
		 fnt->txa_Label, fnt->txa_FontName, fnt->txa_Size,
		 fnt->txa_Style, fnt->txa_Flags );
    }

    // Gadget Data that should preceed gadget tags
    WriteGadgetExtData( Files, IE );

    // NewGadget structures
    WriteNewGadgets( Files, IE );

    // Gadget Tags
    WriteGadgetTags( Files, IE );

    // Boolean Structures
    WriteBoolStruct( Files, IE );

    // Gadget Banks Data
    WriteGadgetBanks( Files, IE );

    // Expanders
    ( *IE->IEXSrcFun->Data )( Files );

    // Menus
    WriteMenuStruct( Files, IE );

    // IntuiTexts
    WriteITexts( Files, IE );

    // Images (used by the GUI)
    WriteImgStruct( Files, IE );

    // Images (in windows)
    WriteImageStruct( Files, IE );

    // Rexx Commands
    WriteRexxCmds( Files, IE );

    // Windows' Zoom
    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_Tags & W_ZOOM ) {
	    FPrintf( Files->XDef, "extern UWORD\t\t\t%sZoom[];\n", wnd->wi_Label );
	    FPrintf( Files->Std, "\nUWORD %sZoom[] = { ", wnd->wi_Label );
	    VFPrintf( Files->Std, "%d, %d, %d, %d };\n", &wnd->wi_ZLeft );
	}
    }

    // Windows Tags
    WriteWindowTags( Files, IE );

    // Screen Tags
    if( IE->flags_2 & GENERASCR )
	WriteScreenTags( Files, IE );

    return( TRUE );
}
///
/// WriteChipData
BOOL WriteChipData( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    struct ImageNode   *img;
    UWORD               words, num, *ptr;

    for( img = IE->Img_List.mlh_Head; img->in_Node.ln_Succ; img = img->in_Node.ln_Succ ) {
	if( img->in_Size ) {

	    words = img->in_Size >> 1;

	    FPrintf( Files->Std, "\n%s %sImgData[%ld] = {\n\t",
		     Prefs.ChipString, img->in_Label, words );

	    FPrintf( Files->XDef, "extern %s %sImgData[%ld];\n",
		     Prefs.ChipString, img->in_Label, words );

	    ptr = img->in_Data;

	    num = 8;

	    do {

		FPrintf( Files->Std, "0x%04lx", *ptr++ );

		num   -= 1;
		words -= 1;

		if( words ) {

		    FPutC( Files->Std, ',' );

		    if(!( num )) {
			FPuts( Files->Std, "\n\t" );
			num = 8;
		    }
		}

	    } while( words );

	    FPuts( Files->Std, "\n};\n" );

	}
    }

    // Expanders
    ( *IE->IEXSrcFun->ChipData )( Files );

    return( TRUE );
}
///
/// WriteCode
BOOL WriteCode( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{

    // Expanders
    ( *IE->IEXSrcFun->Support )( Files );

    if( IE->SrcFlags & SHARED_PORT )
	WriteOpenWndShd( Files, IE );

    if( IE->SrcFlags & LOCALIZE )
	WriteLocale( Files, IE );

    WriteSetupScr( Files, IE );

    WriteBackFillHook( Files, IE );

    WriteListHook( Files, IE );

    WriteGBanksHandling( Files, IE );

    WriteOpenFonts( Files, IE );

    WriteOpenWnd( Files, IE );

    WriteRender( Files, IE );

    if( IE->NumRexxs ) {
	FPuts( Files->Std, ARexxCode );

	if( IE->SrcFlags & AREXX_CMD_LIST )
	    FPuts( Files->Std, ARexxHandleList );
	else
	    FPuts( Files->Std, ARexxHandleArray );
    }

    if( Prefs.Flags & IDCMP_HANDLER )
	WriteIDCMPHandler( Files, IE );

    if( Prefs.Flags & KEY_HANDLER )
	WriteKeyHandler( Files, IE );

    FPuts( Files->XDef, "\nextern int SetupScreen( void );\n"
			"extern void CloseDownScreen( void );\n"
			"extern struct Gadget *MakeGadgets( struct Gadget **GList, struct Gadget *Gads[],\n"
			"\tstruct NewGadget NGad[], UWORD GTypes[], ULONG GTags[], UWORD CNT );\n"
			"extern LONG OpenWnd( struct Gadget *GList, struct TagItem WTags[], struct Window **Wnd );\n"
			"extern void CloseWnd( struct Window **Wnd, struct Gadget **GList, struct Menu **Mn );\n"
	 );

    if( Prefs.Flags & CLICKED )
	WriteClickedPtrs( Files, IE );

    return( TRUE );
}
///
/// WriteStrings
BOOL WriteStrings( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{

    if(!( IE->SrcFlags & LOCALIZE )) {

	if( Prefs.Flags & SMART_STR ) {
	    struct LocaleStr   *str;

	    FPutC( Files->Std, 10 );

	    for( str = IE->Locale->ExtraStrings.mlh_Head; str->Node.ln_Succ; str = str->Node.ln_Succ )
		if( str->Node.ln_Pri & LOC_GUI )
		    break;

	    for( ; str->Node.ln_Succ; str = str->Node.ln_Succ ) {

		FPrintf( Files->XDef, "extern UBYTE\t\t\t%s[];\n", str->ID );

		FPrintf( Files->Std, "UBYTE %s[] = \"%s\";\n",
			 str->ID, str->Node.ln_Name );
	    }
	}
    }

    if( Prefs.Flags & SMART_STR ) {
	struct ArrayNode   *ar;
	UBYTE             **array;

	for( ar = IE->Locale->Arrays.mlh_Head; ar->Next; ar = ar->Next ) {

	    FPrintf( Files->XDef, "extern UBYTE\t\t\t*%s[];\n", ar->Label );

	    FPrintf( Files->Std, "\nUBYTE *%s[] = {", ar->Label );

	    array = ar->Array;

	    while( *array ) {
		FPrintf( Files->Std, "\n\t(UBYTE *)%s,",
			 (( *IE->Functions->FindString )( &IE->Locale->ExtraStrings, *array ))->ID );
		array++;
	    }

	    FPuts( Files->Std, "\n\tNULL\n};\n" );
	}
    }

    return( TRUE );
}
///

