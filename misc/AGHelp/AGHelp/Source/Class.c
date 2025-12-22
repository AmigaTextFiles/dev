/* AmigaGuide Help class */

#define __USE_SYSBASE
#include <intuition/classes.h>
#include <proto/exec.h>
#include <proto/amigaguide.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <string.h>
#include "/include/classes/aghelp.h"
#include "classbase.h"
#include "macros.h"
#include "rev.h"


/******************** AGuide class ********************/


struct AGData
{
	struct Library		*AGuideBase;	/* Library base */
	AMIGAGUIDECONTEXT 	AGuide;		/* AmigaGuide Help Context */
	struct Hook		*ErrHook;	/* Hook to call for any errors */
	ULONG			*WaitMask;	/* Pointer to waitmask long */
	ULONG			HelpID;		/* Current help id */
	struct NewAmigaGuide	NewAGuide;	/* For OpenAmigaGuideAsync() */
	BOOL			Continous;	/* If we should try to update help node on OM_SET of AGHELP_HelpID */
}; /* struct FTData */


typedef struct AGData	Data;


#define AmigaGuideBase	data->AGuideBase


/******************** Private functions for methods ********************/


/* Call the error hook */
PRIVATE VOID
ErrorHook( const Class *class, const Object *object, const LONG err, const LONG htErr )
{
	ClassBase	*classBase;
	Data		*data;

	classBase = BASE();
	data      = DATA();

	if( data->ErrHook )
	{
		struct aghError	msg;

		/* Build the message */
		msg.agh_Version = AGH_ERROR_VERSION;
		msg.agh_Error = err;
		msg.agh_HTError = htErr;
		msg.agh_HTErrorString = NULL;

		if( htErr )
		{
			msg.agh_HTErrorString = GetAmigaGuideString( htErr );
		} /* if */

		CallHookPkt( data->ErrHook, object, &msg );
	} /* if */
} /* ErrorHook */


/* Call the error hook for an AmigaGuide error */
PRIVATE VOID
HTError( const Class *class, const Object *object, const LONG htErr )
{
	ErrorHook( class, object, AGHERR_HTERR, htErr );
} /* HTError */


/* Call the error hook for an AGHelp error */
PRIVATE VOID
PrivateError( const Class *class, const Object *object, const LONG err )
{
	ErrorHook( class, object, err, 0 );
} /* PrivateError */


/* Returns TRUE if we have all the required attributes */
PRIVATE BOOL
ValidateData( const Data *data )
{
	if( data->NewAGuide.nag_Context && data->NewAGuide.nag_Name && data->WaitMask )
	{
		return( TRUE );
	} /* if */

	return( FALSE );
} /* ValidateData */


/* Updates the wait mask long */
PRIVATE VOID
SetWaitMask( const Data *data )
{
	if( data->WaitMask )
	{
		ULONG	mask = 0;

		if( data->AGuide )
		{
			mask = AmigaGuideSignal( data->AGuide );
		} /* if */

		*( data->WaitMask ) = mask;
	} /* if */
} /* SetWaitMask */


/******************** Methods ********************/


METHOD( Help, struct opHelp * )
{
	ClassBase	*classBase;
	Data		*data;
	ULONG	id, rc = FALSE, error = 0;

	classBase = BASE();
	data = DATA();
	id = message->oph_HelpID;

	/* Get current ID if needed. If not, update current ID */
	if( id == AGH_CURRENTID )
	{
		id = data->HelpID;
	}
	else
	{
		data->HelpID = id;
	} /* if */

	/* Make sure we have amigaguide.library loaded */
	if( !data->AGuideBase )
	{
		data->AGuideBase = OpenLibrary( "amigaguide.library", 34L );
	} /* if */

	if( data->AGuideBase )
	{
		if( data->AGuide )
		{
			/* AmigaGuide context already open */

			/* Set the context to use */
			SetAmigaGuideContextA( data->AGuide, id, NULL );

			/* Tell AmigaGuide about it */
			SendAmigaGuideContextA( data->AGuide, NULL );

			rc = TRUE;
		}
		else if( ValidateData( data ) )
		{
			/* Required tags present (hopefully ;).
			 * Start the ASync process.
			 */
			if( data->AGuide = OpenAmigaGuideAsyncA( &data->NewAGuide, NULL ) )
			{
				/* Retrive signal mask for AGuide communication */
				SetWaitMask( data );

				/* And init the context id. When AmigaGuide is up and
				 * running, we will actually tell AmigaGuide about it
				 */
				SetAmigaGuideContextA( data->AGuide, id, NULL );

				/* All ok */
				rc = TRUE;
			}
			else
			{
				error = AGHERR_NO_CONTEXT;
			} /* if */
		}
		else
		{
			error = AGHERR_NO_ATTRS;
		} /* if */
	}
	else
	{
		error = AGHERR_NO_LIBRARY;
	} /* if */

	/* An error occured because an error occured. Well, not quite. ;) */
	if( error )
	{
		PrivateError( class, object, error );
	} /* if */

	return( rc );
} /* METHOD Help */


METHOD( CloseHelp, Msg )
{
	ClassBase	*classBase;
	Data		*data;

	classBase = BASE();
	data = DATA();

	if( data->AGuide )
	{
		CloseAmigaGuide( data->AGuide );
		data->AGuide = NULL;
	} /* if */

	if( data->WaitMask )
	{
		*( data->WaitMask ) = 0;
	} /* if */

	CloseLibrary( data->AGuideBase );
	data->AGuideBase = NULL;
	return( 1 );
} /* METHOD CloseHelp */


METHOD( HandleInput, Msg )
{
	Data	*data;

	data = DATA();

	if( data->AGuideBase )
	{
		struct AmigaGuideMsg 	*agMsg;
		BOOL	close = FALSE;

		while( agMsg = GetAmigaGuideMsg( data->AGuide ) )
		{
			switch( agMsg->agm_Type )
			{
				/* AmigaGuide is ready for us */
				case ActiveToolID:
					/* Show the first node. We've already called
					 * SetAmigaGuideContextA() with the proper
					 * node to show.
					 */
					SendAmigaGuideContextA( data->AGuide, NULL );
					break;

				/* Shutdown message */
				case ShutdownMsgID:
					close = TRUE;

				/* This is a reply to our cmd */
				case ToolCmdReplyID:

				/* This is a status message */
				case ToolStatusID:
					if( agMsg->agm_Pri_Ret )
					{
						/* Handle any errors. Don't really know if
						 * errors should be reported for all the
						 * above message types. Blame the poor
						 * documentation for that. ;) I think an
						 * AmigaGuide example does this...
						 */
						HTError( class, object, agMsg->agm_Sec_Ret );
					} /* if */

					break;
			} /* switch */

			if( agMsg->agm_Pri_Ret )
			{
				close = TRUE;
			} /* if */

			/* Reply to the message */
			ReplyAmigaGuideMsg( agMsg );
		} /* while */

		if( close )
		{
			DoMethod( object, AGHM_CLOSEHELP );
		} /* if */
	} /* if */

	return( 1 );
} /* METHOD HandleInput */


METHOD( Get, struct opGet * )
{
	Data	*data;
	ULONG	rc = TRUE, haveAttr = TRUE, value;

	data = DATA();

	switch( message->opg_AttrID )
	{
		case AGHA_Context:
			value = ( ULONG ) data->NewAGuide.nag_Context;
			break;

		case AGHA_SigMask:
			value = ( ULONG ) data->WaitMask;
			break;

		case AGHA_GuideName:
			value = ( ULONG ) data->NewAGuide.nag_Name;
			break;

		case AGHA_GuideDirLock:
			value = ( ULONG ) data->NewAGuide.nag_Lock;
			break;

		case AGHA_PubScrName:
			value = ( ULONG ) data->NewAGuide.nag_PubScreen;
			break;

		case AGHA_Screen:
			value = ( ULONG ) data->NewAGuide.nag_Screen;
			break;

		case AGHA_HostPortName:
			value = ( ULONG ) data->NewAGuide.nag_HostPort;
			break;

		case AGHA_ClientPortName:
			value = ( ULONG ) data->NewAGuide.nag_ClientPort;
			break;

		case AGHA_BaseName:
			value = ( ULONG ) data->NewAGuide.nag_BaseName;
			break;

		case AGHA_Flags:
			value = data->NewAGuide.nag_Flags;
			break;

		case AGHA_ErrorHook:
			value = ( ULONG ) data->ErrHook;
			break;

		case AGHA_Active:
			value = data->AGuide ? TRUE : FALSE;
			break;

		case AGHA_HelpID:
			value = data->HelpID;
			break;

		case AGHA_Continous:
			value = ( ULONG ) data->Continous;
			break;

		default:
			haveAttr = FALSE;
			rc = CALLSUPER();
			break;
	} /* switch */

	if( haveAttr )
	{
		*( message->opg_Storage ) = value;
	} /* if */

	return( rc );
} /* METHOD Get */


METHOD( Set, struct opSet * )
{
	struct TagItem	*tag, *state;
	ClassBase	*classBase;
	Data		*data;

	classBase = BASE();
	data      = DATA();

	/* We may be called from OM_NEW and OM_UPDATE,
	 * in which case super shouldn't be called
	 */
	if( message->MethodID == OM_SET )
	{
		CALLSUPER();
	} /* if */

	/* AttrList is at the same location for all methods we might be called by */
	state = message->ops_AttrList;

	while( tag = NextTagItem( &state ) )
	{
		ULONG	tagData;

		tagData = tag->ti_Data;

		switch( tag->ti_Tag )
		{
			case AGHA_Context:
				data->NewAGuide.nag_Context = ( STRPTR * ) tagData;
				break;

			case AGHA_SigMask:
				data->WaitMask = ( ULONG * ) tagData;
				SetWaitMask( data );
				break;

			case AGHA_GuideName:
				data->NewAGuide.nag_Name = ( STRPTR ) tagData;
				break;

			case AGHA_GuideDirLock:
				data->NewAGuide.nag_Lock = ( BPTR ) tagData;
				break;

			case AGHA_PubScrName:
				data->NewAGuide.nag_PubScreen = ( STRPTR ) tagData;
				break;

			case AGHA_Screen:
				data->NewAGuide.nag_Screen = ( struct Screen * ) tagData;
				break;

			case AGHA_HostPortName:
				data->NewAGuide.nag_HostPort = ( STRPTR ) tagData;
				break;

			case AGHA_ClientPortName:
				data->NewAGuide.nag_ClientPort = ( STRPTR ) tagData;
				break;

			case AGHA_BaseName:
				data->NewAGuide.nag_BaseName = ( STRPTR ) tagData;
				break;

			case AGHA_Flags:
				data->NewAGuide.nag_Flags = tagData;
				break;

			case AGHA_ErrorHook:
				data->ErrHook = ( struct Hook * ) tagData;
				break;

			case AGHA_HelpID:
				data->HelpID = tagData;

				if( data->Continous && data->AGuide )
				{
					SetAmigaGuideContextA( data->AGuide, tagData, NULL );
					SendAmigaGuideContextA( data->AGuide, NULL );
				} /* if */

				break;

			case AGHA_Continous:
				data->Continous = ( BOOL ) tagData;
				break;
		} /* switch */
	} /* while */

	return( 1 );
} /* METHOD Set */


METHOD( Update, struct opUpdate * )
{
	CALLSUPER();

	if( !( message->opu_Flags & OPUF_INTERIM ) )
	{
		/* Only set attributes for final update */
		CALLMETHOD( Set );
	} /* if */

	return( 1 );
} /* METHOD Update */


METHOD_NEW( New, struct opSet * )
{
	/* Create the object */
	if( object = ( Object * ) CALLSUPER() )
	{
		/* And set the attributes. This macro basically behaves like
		 * CoerceMethod() here, but is a tad more efficient (DoMethod()
		 * must not be used here). Ok if you know what you're doing.
		 */
		CALLMETHOD( Set );
	} /* if */

	return( ( ULONG ) object );
} /* METHOD_NEW New */


METHOD( Dispose, Msg )
{
	DoMethod( object, AGHM_CLOSEHELP );
	CALLSUPER();
	return( 0 );
} /* METHOD Dispose */


DISPATCH()
{
	ULONG	rc;

	SWITCHMETHOD()
	{
		CASE( OM_NEW,		New );
		CASE( OM_DISPOSE,	Dispose );
		CASE( OM_GET,		Get );
		CASE( OM_SET,		Set );
		CASE( OM_UPDATE,	Update );
		CASE( AGHM_HELP,	Help );
		CASE( AGHM_CLOSEHELP,	CloseHelp );
		CASE( AGHM_HANDLEINPUT,	HandleInput );
		DEFAULT();
	} /* SWITCHMETHOD */

	return( rc );
} /* DISPATCH */


/******************** Class setup/cleanup ********************/


PRIVATE Class *
InitAGuide( ClassBase *classBase )
{
	if( classBase->cb_Library.cl_Class = MakeClass( NULL, ROOTCLASS, NULL, sizeof( Data ), 0 ) )
	{
		SETDISPATCH( classBase->cb_Library.cl_Class );
		SETBASE( classBase );
		return( classBase->cb_Library.cl_Class );
	} /* if */

	return( NULL );
} /* InitAGuide */


PRIVATE BOOL
FreeAGuide( ClassBase *classBase )
{
	if( !classBase->cb_Library.cl_Class )
	{
		return( TRUE );
	} /* if */

	if( FreeClass( classBase->cb_Library.cl_Class ) )
	{
		classBase->cb_Library.cl_Class = NULL;
		return( TRUE );
	} /* if */

	return( FALSE );
} /* FreeAGuide */


/******************** ClassLibrary stuff ********************/


/* The following functions are needed by ClassBase.c */


VOID
LibraryCleanup( ClassBase *classBase )
{
	FreeAGuide( classBase );

	if( IntuitionBase )
	{
		CloseLibrary( ( struct Library * ) IntuitionBase );
		IntuitionBase = NULL;
	} /* if */

	if( UtilityBase )
	{
		CloseLibrary( UtilityBase );
		UtilityBase = NULL;
	} /* if */
} /* LibraryCleanup */


BOOL
LibrarySetup( ClassBase *classBase )
{
	classBase->cb_IntuitionBase = ( APTR ) OpenLibrary( "intuition.library", 37 );
	classBase->cb_UtilityBase   = OpenLibrary( "utility.library", 37 );

	if( UtilityBase && IntuitionBase && InitAGuide( classBase ) )
	{
		return( TRUE );
	} /* if */

	LibraryCleanup( classBase );
	return( FALSE );
} /* LibrarySetup */


ASM Class *
GetClassBase( A6 struct ClassBase *classBase )
{
	return( classBase->cb_Library.cl_Class );
} /* GetClassBase */
