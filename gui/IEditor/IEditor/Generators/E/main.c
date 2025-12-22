/*
**
**    E.generator - Copyright © 1996 Simone Tellini
**                  All Rights Reserved
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

#include "Protos.h"
///
/// Data
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
    "    E source code created by Interface Editor\n"
    "    Copyright © 1994-1996 by Simone Tellini\n\n"
    "    The E.generator was wrote with the help of Pietro Altomani\n\n"
    "    Generator:  %s\n"
    "    Copy registered to :  %s\n"
    "    Serial Number      : #%ld\n"
    "*/\n\n";

UBYTE   Null[] = "NIL";

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


/// StrToUpper
void StrToUpper( STRPTR From, STRPTR To )
{
    UBYTE   c;

    while( c = *From++ )
	*To++ = toupper( c );

    *To = '\0';
}
///
/// StrToLower
void StrToLower( STRPTR From, STRPTR To )
{
    UBYTE   c;

    while( c = *From++ )
	*To++ = tolower( c );

    *To = '\0';
}
///

//  ***  Main Routines  ***
/// OpenFiles
struct GenFiles *OpenFiles( __A0 struct IE_Data *IE, __A1 UBYTE *BaseName )
{
    UBYTE               buffer[1024], buffer2[1024];
    UBYTE              *ptr, *ptr2, *ptr3;
    struct GenFiles    *Files;

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
    strcat( buffer2, ".e" );

    if(!( Files->Std = Open( buffer2, MODE_NEWFILE )))
	return( NULL );


    if( IE->C_Prefs & GEN_TEMPLATE ) {

	strcpy( buffer2, buffer );
	strcat( buffer2, "_temp.e" );

	if(!( Files->Temp = Open( buffer2, MODE_NEWFILE )))
	    goto error;

    }

    if( IE->SrcFlags & MAINPROC ) {

	strcpy( buffer2, buffer );
	strcat( buffer2, "Main.e" );

	if( AskFile( buffer2, IE ))
	    if(!( Files->Main = Open( buffer2, MODE_NEWFILE )))
		goto error;
    }

    if( IE->SrcFlags & LOCALIZE ) {

	IE->C_Prefs |= SMART_STR;

	strcpy( buffer2, buffer );  // get the right dir
	*( FilePart( buffer2 )) = '\0';

	strcat( buffer2, IE->Locale->Catalog );
	strcat( buffer2, ".cd" );

	if( AskFile( buffer2, IE ))
	    if(!( (BPTR)Files->User1 = Open( buffer2, MODE_NEWFILE )))
		goto error;

	FPrintf(( BPTR )Files->User1, ";\n"
				      ";    Source code created by Interface Editor\n"
				      ";    Copyright © 1994-1996 by Simone Tellini\n;\n"
				      ";    Generator:  %s;\n"
				      ";    Copy registered to :  %s\n"
				      ";    Serial Number      : #%ld\n"
				      ";\n",
		 LibId, IE->User->Name, IE->User->Number );

	if( IE->Locale->JoinFile[0] ) {

	    BPTR lock;

	    if(!( lock = Lock( IE->Locale->JoinFile, ACCESS_READ ))) {

		ULONG tags[] = { RT_ReqPos, REQPOS_CENTERSCR, RT_Underscore, '_',
				 RT_Screen, IE->ScreenData->Screen, TAG_DONE };

		UBYTE fault[80];

		Fault( ERROR_OBJECT_NOT_FOUND, NULL, fault, 80 );

		rtEZRequest( "%s:\n%s.", "_Oops...",
			     NULL, (struct TagItem *)tags,
			     IE->Locale->JoinFile, fault );
	    } else {
		APTR                    copy;
		BPTR                    join;
		struct FileInfoBlock    fib;

		Examine( lock, &fib );

		UnLock( lock );

		if(!( join = Open( IE->Locale->JoinFile, MODE_OLDFILE )))
		    goto error;

		if(!( copy = AllocMem( fib.fib_Size, 0L )))
		    goto error;

		Read( join, copy, fib.fib_Size );
		Close( join );

		Flush(( BPTR )Files->User1 );
		Write(( BPTR )Files->User1, copy, fib.fib_Size );

		FreeMem( copy, fib.fib_Size );
	    }
	}

	Files->User3 = IE;
    }

    NewList(( struct List *)&Files->Strings );
    NewList(( struct List *)&Files->Arrays  );

    if( IE->C_Prefs & SMART_STR )
	if(!( ProcessStrings( IE, Files )))
	    goto error;

    return( Files );


error:

    CloseFiles( Files );

    return( NULL );
}
///
/// CloseFiles
void CloseFiles( __A0 struct GenFiles *Files )
{
    UBYTE   buffer[256];

    if( Files ) {
	if( Files->Std   )  Close( Files->Std   );
	if( Files->Temp  )  Close( Files->Temp  );
	if( Files->Main  )  Close( Files->Main  );

	if( Files->User1 ) {
	    UBYTE  *from, *to, *ptr;
	    UBYTE   command[ 1024 ];

	    strcpy( command, "CatComp \"" );

	    from = Files->XDefName;
	    to = FilePart( Files->XDefName );
	    ptr = buffer;
	    while( from < to )
		*ptr++ = *from++;
	    *ptr = '\0';

	    strcat( command, buffer );
	    strcat( command, ((struct IE_Data *)Files->User3 )->Locale->Catalog );
	    strcat( command, ".cd\" CTFILE \"" );
	    strcat( command, buffer );
	    strcat( command, ((struct IE_Data *)Files->User3 )->Locale->Catalog );
	    strcat( command, ".ct\" CFILE \"" );
	    strcat( command, buffer );

	    ptr = command;
	    while( *ptr++ );
	    ptr -= 1;

	    while( *to != '.' )
		*ptr++ = *to++;
	    *ptr = '\0';

	    strcat( command, "_Locale.h\"" );

	    Close( (BPTR)Files->User1 );

	    SystemTagList( command, NULL );
	}

	FreeStrings( Files );

	FreeMem( Files, sizeof( struct GenFiles ));
    }
}
///

/// WriteHeaders
BOOL WriteHeaders( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    struct WindowInfo  *wnd;
    struct GadgetInfo  *gad;
    ULONG               cnt;

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
	    "*/\n\n" );
    }

    if( Files->Main ) {
	FPrintf( Files->Main, Header, LibId, IE->User->Name, IE->User->Number );
	WriteMain( Files, IE );
    }

    FPuts( Files->Std, "MODULE 'exec/nodes', 'intuition/intuition', 'intuition/gadgetclass.h', 'libraries/gadtools'\n\n" );

    if( IE->SrcFlags & OPENDISKFONT )
	FPuts( Files->Std, "MODULE 'diskfont'\n\n" );

    if( IE->NumRexxs )
	FPuts( Files->Std, "MODULE 'rexx/rxslib', 'rexx/rexxio', 'rexx/errors', 'rexx/storage'\n"
			   "MODULE 'dos/dos', 'dos/rdargs'\n\n" );

    if( IE->SrcFlags & LOCALIZE )
	FPuts( Files->Std, "MODULE 'libraries/locale'\n\n" );


//    FPrintf( Files->Std, "MODULE \"%s\"\n\n", FilePart( Files->XDefName ));


    FPuts( Files->XDef, "CONST WT_LEFT=0, WT_TOP=1, WT_WIDTH=2, WT_HEIGHT=3\n\n" );

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	struct GadgetBank  *bank;

	cnt = 0;
	for( gad = wnd->wi_Gadgets.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
	    if( gad->g_Kind < MIN_IEX_ID ) {
		TEXT    Label[60];

		StrToUpper( gad->g_Label, Label );

		FPrintf( Files->XDef, "CONST GD_%s=%ld\n", Label, cnt );
		cnt += 1;
	    }


	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ )
	    for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_Kind < MIN_IEX_ID ) {
		    TEXT    Label[60];

		    StrToUpper( gad->g_Label, Label );

		    FPrintf( Files->XDef, "CONST GD_%s=%ld\n", Label, cnt );
		    cnt += 1;
		}


	if( cnt )
	    FPutC( Files->XDef, 10 );
    }

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	struct GadgetBank  *bank;

	cnt = wnd->wi_NumGads - wnd->wi_NumBools;

	if( cnt ) {
	    TEXT    Label[60];

	    StrToUpper( wnd->wi_Label, Label );

	    FPrintf( Files->XDef, "CONST %s_CNT=%ld\n", Label, cnt );
	}

	for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
	    struct GadgetInfo  *gad;

	    for( cnt = 0, gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		if( gad->g_Kind < BOOLEAN )
		    cnt += 1;

	    if( cnt ) {
		TEXT    Label[60];

		StrToUpper( bank->Label, Label );

		FPrintf( Files->XDef, "CONST %s_CNT=%ld\n", Label, cnt );
	    }
	}
    }

    FPutC( Files->XDef, 10 );

    ( *IE->IEXSrcFun->Headers )( Files );

    return( TRUE );
}
///
/// WriteVars
BOOL WriteVars( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{
    int                 cnt;
    struct WindowInfo  *wnd;

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	if( wnd->wi_NumGBanks ) {

	    FPuts( Files->XDef, "OBJECT windowbanks\n"
				"    banks:PTR TO PTR TO gadget\n"
				"    count:INT\n"
				"ENDOBJECT\n\n" );
	    break;
	}

    FPuts( Files->Std, "DEF visualinfo, yoffset, xoffset, scr=NIL:PTR TO screen\n" );

    if( IE->SrcFlags & FONTSENSITIVE )
	FPuts( Files->Std, "DEF font:PTR TO textattr, attr:textattr, fontx, fonty\n" );

    if(!( IE->flags_2 & GENERASCR )) {
	FPuts( Files->Std,  "DEF pubscreenname=NIL:PTR TO CHAR\n" );
    } else {
	if( IE->ScreenData->ScrAttrs & SC_ERRORCODE ) {
	    FPuts( Files->Std,  "DEF screenerror=NIL\n" );
	}
    }

    if( IE->SrcFlags & LOCALIZE ) {
	FPrintf( Files->Std, "DEF localized[%ld]:ARRAY OF CHAR, catalog=NIL:PTR TO catalog\n",
		 IE->num_win );
    }

    if( IE->NumRexxs ) {
	FPrintf( Files->Std, "DEF rx_unconfirmed, rexxport:PTR TO msgport,\n"
			     "    rexxportname[%ld]:STRING\n"
			     "CONST REXX_EXT='%s'\n",
		 strlen( IE->RexxPortName ) + 4,
		 IE->RexxExt );
    }

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	TEXT    Label[60];

	StrToLower( wnd->wi_Label, Label );

	FPrintf( Files->Std,  "DEF %swnd=NIL:PTR TO window\n", Label );
    }

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumMenus ) {
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );

	    FPrintf( Files->Std,  "DEF %smenus=NIL:PTR TO menu\n", Label );
	}
    }


    //      Gadget Lists

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );

	    FPrintf( Files->Std,  "DEF %sglist=NIL:PTR TO gadget\n", Label );
	}
    }


    //      Gadget Banks

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGBanks ) {
	    struct GadgetBank  *bank;
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );

	    FPrintf( Files->Std,  "DEF %sgbanks[%ld]:ARRAY OF PTR TO gadget,\n"
				  "    %swbanks=[ {%sgbanks}, 0 ]:windowbanks\n",
				  Label, wnd->wi_NumGBanks,
				  Label, Label );

	    for( bank = wnd->wi_GBanks.mlh_Head; bank->Node.ln_Succ; bank = bank->Node.ln_Succ ) {
		struct GadgetInfo  *gad;
		ULONG               count = 0;

		for( gad = bank->Storage.mlh_Head; gad->g_Node.ln_Succ; gad = gad->g_Node.ln_Succ )
		    if( gad->g_Kind < BOOLEAN )
			count += 1;

		if( count ) {
		    TEXT    Label[60];

		    StrToLower( bank->Label, Label );

		    FPrintf( Files->Std,  "DEF %sglist=NIL:PTR TO gadget,\n"
					  "    %sgadgets[%ld]:ARRAY OF PTR TO gadget\n",
					  Label, Label, count );
		}
	    }
	}
    }


    //      IntuiMessages

    if( IE->C_Prefs & INTUIMSG ) {
	for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	    if(!(( IE->SrcFlags & SHARED_PORT ) && ( wnd->wi_Tags & W_SHARED_PORT ))) {
		TEXT    Label[60];

		StrToLower( wnd->wi_Label, Label );
		FPrintf( Files->Std,  "DEF %smsg:intuimessage\n", Label );
	    }
	}
    }



    //      Gadget Pointers Arrays

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	cnt = wnd->wi_NumGads - wnd->wi_NumBools;
	if( cnt ) {
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );
	    FPrintf( Files->Std,  "DEF %sgadgets[%ld]:ARRAY OF PTR TO gadget\n", Label, cnt );
	}
    }


    if( IE->SrcFlags & SHARED_PORT ) {

	Files->User2 = IE->SharedPort[0] ? (APTR)&IE->SharedPort[0] : (APTR)"idcmpport";

	StrToLower( Files->User2, Files->User2 );

	if(!( IE->SharedPort[0] ))
	    FPuts( Files->Std, "DEF idcmpport:PTR TO msgport\n" );

	FPuts( Files->Std, "DEF idcmpmsg:intuimessage\n" );
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

    // Gadget Labels

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ )
	WriteGLabels( Files, IE, &wnd->wi_Gadgets, wnd );


    // Gadget Types

    for( wnd = IE->win_list.mlh_Head; wnd->wi_succ; wnd = wnd->wi_succ ) {
	if( wnd->wi_NumGads - wnd->wi_NumBools ) {
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );

	    FPrintf( Files->Std, "\nDEF %sgtypes = [\n\t", Label );

	    WriteGTypes( Files, IE, &wnd->wi_Gadgets );
	}
    }

    // Fonts

    struct TxtAttrNode *fnt;
    for( fnt = IE->FntLst.mlh_Head; fnt->txa_Next; fnt = fnt->txa_Next ) {
	TEXT    Label[60];

	StrToLower( fnt->txa_Label, Label );

	FPrintf( Files->Std, "\nDEF %s = [ '%s', %ld, $%lx, $%lx ]:textattr\n",
		 Label, fnt->txa_FontName, fnt->txa_Size,
		 fnt->txa_Style, fnt->txa_Flags );
    }


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
	    TEXT    Label[60];

	    StrToLower( wnd->wi_Label, Label );

	    FPrintf( Files->Std, "\nDEF %szoom = [ ", Label );
	    VFPrintf( Files->Std, "%d, %d, %d, %d ]:INT;\n", &wnd->wi_ZLeft );
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
		     IE->ChipString, img->in_Label, words );

	    FPrintf( Files->XDef, "extern %s %sImgData[%ld];\n",
		     IE->ChipString, img->in_Label, words );

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

    if( IE->C_Prefs & IDCMP_HANDLER )
	WriteIDCMPHandler( Files, IE );

    if( IE->C_Prefs & KEY_HANDLER )
	WriteKeyHandler( Files, IE );

    if( IE->C_Prefs & CLICKED )
	WriteClickedPtrs( Files, IE );

    return( TRUE );
}
///
/// WriteStrings
BOOL WriteStrings( __A0 struct GenFiles *Files, __A1 struct IE_Data *IE )
{

    if( Files->User1 ) {
	WriteCD( Files );
    } else {
	if(( IE->C_Prefs & SMART_STR ) && (!( IE->SrcFlags & LOCALIZE ))) {

	    struct StringNode  *str;

	    FPutC( Files->Std, 10 );

	    for( str = Files->Strings.mlh_Head; str->Next; str = str->Next ) {

		FPrintf( Files->Std, "CONST %s = '%s'\n",
			 str->Label, str->String );
	    }
	}
    }

    if( IE->C_Prefs & SMART_STR ) {

	struct ArrayNode   *ar;
	UBYTE             **array;

	for( ar = Files->Arrays.mlh_Head; ar->Next; ar = ar->Next ) {

	    FPrintf( Files->Std, "\nDEF %s = [", ar->Label );

	    array = ar->Array;

	    while( *array ) {
		FPrintf( Files->Std, "\n\t%s,",
			 ( FindString( &Files->Strings, *array ))->Label );
		array++;
	    }

	    FPuts( Files->Std, "\n\tNIL\n]:PTR TO CHAR\n" );
	}
    }

    return( TRUE );
}
///

