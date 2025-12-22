#ifndef CLASSES_AGHELP_H
#define CLASSES_AGHELP_H

#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif   /* UTILITY_TAGITEM_H */


#define AGM_BASE		0x65000

/* AGHelp custom methods */

	/* Show help for the specified Context entry (AGHELP_Context) */
#define AGHM_HELP		( AGM_BASE + 1 )

	/* Close any open help window, and free all resources (except object ;) */
#define AGHM_CLOSEHELP		( AGM_BASE + 2 )

	/* When the signal found in the AGHELP_WaitMask long is received,
	 * call this method to process any messages.
	 */
#define AGHM_HANDLEINPUT	( AGM_BASE + 3 )


/* AGHelp custom attributes. Many (one might even say most) are simply
 * passed on to amigaguide.library and related structures.
 *
 * (Reserved range: CLASSACT_Dummy + 0x56000 thru 0x56fff)
 */

#define AGHA_TagBase		( TAG_USER + 0x5000000 +0x56000 )

	/* (ISG) Sets the context array for the AGM_HELP function.
	 * This attribute is required.
	 */
#define AGHA_Context		( AGHA_TagBase + 1 )

	/* (ISG) Pointer to ULONG to receive the WaitMask value.
	 * This attribute is required.
	 */
#define AGHA_SigMask		( AGHA_TagBase + 2 )

	/* (ISG) Name of the AmigaGuide database.
	 * This attribute is required.
	 */
#define AGHA_GuideName		( AGHA_TagBase + 3 )

	/* (ISG) Directory where the database resides.
	 * If not specified, or specified as NULL, the path in
	 * AmigaGuide/Path will be serched
	 */
#define AGHA_GuideDirLock	( AGHA_TagBase + 4 )

	/* (ISG) Public screen name where the AmigaGuide window should open.
	 * Default is to open on default public screen.
	 */
#define AGHA_PubScrName		( AGHA_TagBase + 5 )

	/* (ISG) Screen where the AmigaGuide window should open */
#define AGHA_Screen		( AGHA_TagBase + 6 )

	/* (ISG) Name of applications' ARexx port (not used in current AmigaGuide) */
#define AGHA_HostPortName	( AGHA_TagBase + 7 )

	/* (ISG) Base name to use for the databases' ARexx port */
#define AGHA_ClientPortName	( AGHA_TagBase + 8 )

	/* (ISG) Basename of the application */
#define AGHA_BaseName		( AGHA_TagBase + 9 )

	/* (ISG) Misc flags. See <libraries/amigaguide.h> for definitions (HT#?) */
#define AGHA_Flags		( AGHA_TagBase + 10 )

	/* (ISG) Hook to handle any errors encountered */
#define AGHA_ErrorHook		( AGHA_TagBase + 11 )

	/* (G) Query the state of active help. If a window is open is not possible
	 * to say. However, if this returns TRUE, any OM_SETs will only take
	 * effect after an AGM_CLOSEHELP.
	 */
#define AGHA_Active		( AGHA_TagBase + 12 )

	/* (ISGU) Alternate method to pass the help id. If AGHA_Continous is TRUE,
	 * then setting this attribute will also change node in the help window.
	 * Intended for notification and the like.
	 */
#define AGHA_HelpID		( AGHA_TagBase + 13 )

	/* (ISG) If TRUE, then setting AGHA_HelpID will make any open help window
	 * change to the specified node.
	 */
#define AGHA_Continous		( AGHA_TagBase + 14 )


/* Custom method structures */


struct opHelp
{
	ULONG	MethodID;
	ULONG	oph_HelpID;
};

/* If you want to use the context id set via attributes instead */
#define AGH_CURRENTID	( -1L )


/* Error hook */


struct aghError
{
	LONG	agh_Version;		/* Structure version */
	LONG	agh_Error;		/* Class error code. See below */
	LONG	agh_HTError;		/* AmigaGuide (HyperText) error code, if above is AGERR_HTERR */
	STRPTR	agh_HTErrorString;	/* Localized string describing AmigaGuide error code */
};

/* Structure version for struct agError */
#define AGH_ERROR_VERSION	1


/* Class error values */

	/* Couldn't open amigaguide.library version 34 or higher */
#define AGHERR_NO_LIBRARY	1

	/* Couldn't create AmigaGuide context */
#define AGHERR_NO_CONTEXT	2

	/* Vital attributes doesn't have proper values. See required attributes above */
#define AGHERR_NO_ATTRS		3

	/* AmigaGuide returned error in AGM_HANDLEINPUT */
#define AGHERR_HTERR		4


#endif /* CLASSES_AGHELP_H */
