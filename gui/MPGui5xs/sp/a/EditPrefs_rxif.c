/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <rexx/storage.h>
#include <rexx/rxslib.h>

#ifdef __GNUC__
/* GCC needs all struct defs */
#include <dos/exall.h>
#include <graphics/graphint.h>
#include <intuition/classes.h>
#include <devices/keymap.h>
#include <exec/semaphores.h>
#endif

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/rexxsyslib_protos.h>

#ifndef __NO_PRAGMAS

#ifdef AZTEC_C
#include <pragmas/exec_lib.h>
#include <pragmas/dos_lib.h>
#include <pragmas/rexxsyslib_lib.h>
#endif

#ifdef LATTICE
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>
#endif

#endif /* __NO_PRAGMAS */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#ifdef LATTICE
#undef toupper
#define inline __inline
#endif

#ifdef __GNUC__
#undef toupper
static inline char toupper( char c )
{
	return( islower(c) ? c - 'a' + 'A' : c );
}
#endif

#ifdef AZTEC_C
#define inline
#endif

#include "EditPrefs.h"


extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;
extern struct RxsLib *RexxSysBase;


/* $ARB: I 727904511 */


/* $ARB: B 4 OPEN */
#include <libraries/MPGui.h>
#include <pragmas/MPGui_pragmas.h>
#include <clib/MPGui_protos.h>

extern struct Library *MPGuiBase;

extern ULONG RexxQuitFlag;
void SaveSettings(char *,char *,char *);
void LoadSettings(char *filename);
int MPMorphPrefsOpen( void );
int MPMorphPrefsSaveAs( void );
int MPMorphPrefsQuit( void );
int MPMorphPrefsResetToDefaults( void );
int MPMorphPrefsLastSaved( void );
int MPMorphPrefsRestore( void );
int MPMorphPrefsCreateIcons( void );
#define OPT_DIR			0
#define OPT_SAVEDIR		1
#define OPT_FILE			2
#define OPT_HELP			3
#define OPT_DEFAULT		4
#define OPT_GUI			5
#define OPT_PORTNAME		6

#define OPT_COUNT			7
extern LONG opts[];

extern struct MPGuiHandle *MPGuiHandle;

/****** EditPrefs/--background-- ********************************************
*
*  There is no default portname for EditPrefs. The PORTNAME parameter must
*  be supplied if an ARexx port is required.
*
*  If 'OPTIONS RESULTS' is on then when an error is returned then RC2 will
*  hold a supplementary error (number or text).
*
*  Shortened unique formats of commands can be used.
*
*****************************************************************************
*
*/

/****** EditPrefs/OPEN *************************************************
*
*   NAME   
*  OPEN -- Opens settings from the supplied file.
*
*   SYNOPSIS
*  OPEN( FILENAME/K )
*
*   FUNCTION
*  Opens settings from the supplied filename.
*
*   INPUTS
*  FILENAME - File name to open. If not supplied then requester is displayed
*
*   RESULT
*  None.
*
*   EXAMPLE
*  'OPEN FILENAME=ENV:MPMorph/Morph.prefs'
*
*   NOTES
*
*   BUGS
*  Never returns an error.
*
*   SEE ALSO
*
*****************************************************************************
*
*/
void rx_open( struct RexxHost *host, struct rxd_open **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_open *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			LoadSettings((char *)rd->arg.filename);
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 4 OPEN */

/* $ARB: B 6 QUIT */
/****** EditPrefs/QUIT *************************************************
*
*   NAME   
*  QUIT -- Quits EditPrefs.
*
*   SYNOPSIS
*  QUIT( )
*
*   FUNCTION
*  Quits EditPrefs without saving the settings.
*
*   INPUTS
*  None.
*
*   RESULT
*  None.
*
*   EXAMPLE
*  'QUIT'
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*  SAVE(), USE().
*
*****************************************************************************
*
*/
void rx_quit( struct RexxHost *host, struct rxd_quit **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_quit *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			RexxQuitFlag = 0;
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 6 QUIT */

/* $ARB: B 7 SAVE */
/****** EditPrefs/SAVE *************************************************
*
*   NAME   
*  SAVE -- Save the settings and Quits EditPrefs.
*
*   SYNOPSIS
*  SAVE( )
*
*   FUNCTION
*  Saves the settings to the Save and Use directories and quits EditPrefs.
*
*   INPUTS
*  None.
*
*   RESULT
*  None.
*
*   EXAMPLE
*  'SAVE'
*
*   NOTES
*
*   BUGS
*  Never returns an error.
*
*   SEE ALSO
*  QUIT(), USE(), SAVEAS().
*
*****************************************************************************
*
*/
void rx_save( struct RexxHost *host, struct rxd_save **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_save *rd = *rxd;
	char *res;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			res = MPGuiCurrentAttrs(MPGuiHandle);
			SaveSettings((char *)opts[OPT_SAVEDIR],(char *)opts[OPT_FILE],res);
			SaveSettings((char *)opts[OPT_DIR],(char *)opts[OPT_FILE],res);
			RexxQuitFlag = 0;
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 7 SAVE */

/* $ARB: B 8 SAVEAS */
/****** EditPrefs/SAVEAS *************************************************
*
*   NAME   
*  SAVEAS -- Save the settings to the supplied file.
*
*   SYNOPSIS
*  SAVEAS( NAME/K )
*
*   FUNCTION
*  Saves the settings to the supplied file.
*
*   INPUTS
*  NAME - Name of file. If not supplied then requester is displayed.
*
*   RESULT
*  None.
*
*   EXAMPLE
*  'SAVEAS NAME=Current.prefs'
*
*   NOTES
*
*   BUGS
*  Never returns an error.
*
*   SEE ALSO
*  SAVE().
*
*****************************************************************************
*
*/
void rx_saveas( struct RexxHost *host, struct rxd_saveas **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_saveas *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			SaveSettings("",rd->arg.name,MPGuiCurrentAttrs(MPGuiHandle));
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 8 SAVEAS */

/* $ARB: B 9 DEFAULTS */
/****** EditPrefs/DEFAULTS ************************************************
*
*   NAME   
*  DEFAULTS -- Reverts to the default settings.
*
*   SYNOPSIS
*  DEFAULTS( )
*
*   FUNCTION
*  Reverts to the default settings.
*
*   INPUTS
*  None.
*
*   RESULT
*  None.
*
*   EXAMPLE
*  'DEFAULTS'
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*  RESTORE(), LASTSAVED().
*
*****************************************************************************
*
*/
void rx_defaults( struct RexxHost *host, struct rxd_defaults **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_defaults *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			MPMorphPrefsResetToDefaults();
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 9 DEFAULTS */

/* $ARB: B 10 LASTSAVED */
/****** EditPrefs/LASTSAVED ************************************************
*
*   NAME   
*  LASTSAVED -- Reverts to the last saved settings.
*
*   SYNOPSIS
*  LASTSAVED( )
*
*   FUNCTION
*  Reverts to the LastSaved settings (from the Save directory).
*
*   INPUTS
*  None.
*
*   RESULT
*  None.
*
*   EXAMPLE
*  'LASTSAVED'
*
*   NOTES
*
*   BUGS
*  Never returns an error.
*
*   SEE ALSO
*  DEFAULTS(), RESTORE().
*
*****************************************************************************
*
*/
void rx_lastsaved( struct RexxHost *host, struct rxd_lastsaved **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_lastsaved *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			MPMorphPrefsLastSaved();
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 10 LASTSAVED */

/* $ARB: B 11 RESTORE */
/****** EditPrefs/RESTORE ************************************************
*
*   NAME   
*  RESTORE -- Reverts to the last used settings.
*
*   SYNOPSIS
*  RESTORE( )
*
*   FUNCTION
*  Reverts to the LastUsed settings (from the Use directory).
*
*   INPUTS
*  None.
*
*   RESULT
*  None.
*
*   EXAMPLE
*  'RESTORE'
*
*   NOTES
*
*   BUGS
*  Never returns an error.
*
*   SEE ALSO
*  DEFAULTS(), LASTSAVED().
*
*****************************************************************************
*
*/
void rx_restore( struct RexxHost *host, struct rxd_restore **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_restore *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			MPMorphPrefsRestore();
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 11 RESTORE */

/* $ARB: B 12 USE */
/****** EditPrefs/USE *************************************************
*
*   NAME   
*  USE -- Uses the settings and Quits EditPrefs.
*
*   SYNOPSIS
*  USE( )
*
*   FUNCTION
*  Saves the settings to the Use directory and quits EditPrefs.
*
*   INPUTS
*  None.
*
*   RESULT
*  None.
*
*   EXAMPLE
*  'USE'
*
*   NOTES
*
*   BUGS
*  Never returns an error.
*
*   SEE ALSO
*  QUIT(), SAVE(), SAVEAS().
*
*****************************************************************************
*
*/
void rx_use( struct RexxHost *host, struct rxd_use **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_use *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			SaveSettings((char *)opts[OPT_DIR],(char *)opts[OPT_FILE],MPGuiCurrentAttrs(MPGuiHandle));
			RexxQuitFlag = 0;
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 12 USE */

/* $ARB: B 13 SETATTR */
/****** EditPrefs/SETATTR *************************************************
*
*   NAME   
*  SETATTR -- Sets the atributes of a gadget.
*
*   SYNOPSIS
*  SETATTR( TITLE/A,VALUE/A )
*
*   FUNCTION
*  Sets the value of a gadget.
*
*   INPUTS
*  TITLE - the title of the gadget (including spaces and _s)
*  VALUE - the value to set the gadget to.
*
*   RESULT
*  None.
*
*   EXAMPLE
*  'SETATTR TITLE="_Public Screen" VALUE="Test Screen"'
*
*   NOTES
*  Capitilization of TITLE does matter.
*
*   BUGS
*  Never returns an error.
*
*   SEE ALSO
*
*****************************************************************************
*
*/
void rx_setattr( struct RexxHost *host, struct rxd_setattr **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setattr *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			SetMPGuiGadgetValue(MPGuiHandle,rd->arg.title,rd->arg.value);
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 13 SETATTR */


#ifndef RX_ALIAS_C
char *ExpandRXCommand( struct RexxHost *host, char *command )
{
	/* Insert your ALIAS-HANDLER here */
	return( NULL );
}
#endif

