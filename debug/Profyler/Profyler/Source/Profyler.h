
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.1 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Main Module Header							Last modified 05-Mar-22	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This file is included by all the other Profyler modules. It enables access
 to functions within the main Profyler module, contains master definitions
 that are used by all the other modules, and provides access to globally-vis-
 ible data such as the localization strings.

============================================================================
***************************************************************************/

/***************************************************************************
============================================================================

 This program is free software; you can redistribute it and/or modify it
 under the terms of the GNU General Public License as published by the Free
 Software Foundation; either version 2 of the License, or (at your option)
 any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 more details.
 
 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

============================================================================
***************************************************************************/

// -------------------------------------------------------------------------
// === Includes ===

#include <exec/types.h>
#include <string.h>
#include <stdio.h>

// -------------------------------------------------------------------------
// === Prototypes ===

struct FileRequester *APP_GetFileReq(void);
void APP_SetDOSErrWind(APTR WindowObj);

// -------------------------------------------------------------------------
// === Macros ===

// Pack four characters into a single 32-bit value, in big-endian order.
#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) \
	((uint32)(a)<<24 | (uint32)(b)<<16 | (uint32)(c)<<8 | (uint32)(d))
#endif

// The C stdlib doesn't have a good length-limited string copy function, so
// we kludge one out of strncat(). Note that the destination buffer must be
// Len + 1 chars long, to allow for the terminating NUL. Note also that
// 'Dest' is evaluated twice, so make sure it has no side effects.
#define STRCPYN(Dest, Src, Len) \
	{*(Dest) = '\0'; strncat((Dest), (Src), (Len));}

// Versions of standard MUI macros that work when not using __USE_INLINE__.
#define Get(obj, attr, store) \
	IIntuition->GetAttr((attr), (obj), (ULONG *)(void *)(store))
#define Set(obj, attr, value) \
	IIntuition->SetAttrs((obj), (attr), (value), TAG_DONE)

// -------------------------------------------------------------------------
// === Defines ===

// Define this to 1 if this is a release version of the program, or to 0 if
// this is a development version.
#define RELEASE			1

// The release date, in $VERS: format. Only used if RELEASE is 1; otherwise
// the build date (via __AMIGADATE__) is used.
#define RELEASE_DATE	"(05.03.22)"

// The copyright year(s), as a string.
#define COPYRT_YEARS	"2022"

// The name, version (in text form) and author of the program. They're used
// many places; this lets us set them all with one edit.
#define PROG_NAME		"Profyler"
#define PROG_NAME_UC	"PROFYLER"
#define PROG_VERS		"1.1"
#define PROG_AUTHOR		"Mike Steed"

// The copyright text, which should not be localized.
#define PROG_COPYRIGHT	"© "COPYRT_YEARS" "PROG_AUTHOR

// The minimum version of Exec (and by extension, the OS) that we will even
// attempt to run on.
#define LIBV_MINIMUM	50			// OS 4.0

// The minimum version and revision of Exec (and by extension, the OS) that
// we officially support. For versions between LIBV_MINIMUM and this we'll
// inform the user before quitting.
#define LIBV_NEEDED		53			// OS 4.1.6 + downloaded updates
#define LIBR_NEEDED		41

// The OS version corresponding to the above, as a string.
#define OS_NEEDED		"4.1.6 (Exec 53.41)"

// The minimum version of MUI that we'll accept. For earlier versions we'll
// inform the user before quitting.
#define MUILIB_NEEDED	21			// MUI 5

// The MUI version corresponding to the above, as a string.
#define MUI_NEEDED		"5"

// The maximum number of targets that Profyler may track at a time. This de-
// fine makes a handy way to reference this number, but it's not intended to
// be changeable.
#define MAX_TARGETS		9

// -------------------------------------------------------------------------
// === Globals ===

// Base pointers for the libraries (and their interfaces) opened by the pro-
// gram.
extern struct Library *SysBase;
extern struct ExecIFace *IExec;
extern struct DebugIFace *IDebug;
extern struct Library *DOSBase;
extern struct DOSIFace *IDOS;
extern struct Library *LocaleBase;
extern struct LocaleIFace *ILocale;
extern struct Library *IntuitionBase;
extern struct IntuitionIFace *IIntuition;
extern struct Library *IconBase;
extern struct IconIFace *IIcon;
extern struct Library *TimerBase;
extern struct TimeRequest *TimerLibIO;
extern struct TimerIFace *ITimer;
extern struct Library *MUIMasterBase;
extern struct MUIMasterIFace *IMUIMaster;

// -------------------------------------------------------------------------
// === Localization ===

// An array of pointers to the localized text strings used by the program.
extern STRPTR Msgs[];

// Indexes into the localized text string pointer array to the associated
// string. The order of the entries here must match those in the string
// pointer array definition in Profyler.c, and the order of the substitute
// strings in any translation catalog.
enum MessageNumber
{
	// Main module
	MSN_AppDescription,
	MSN_OSTooOld,
	MSN_MUITooOld,
	MSN_Okay,
	// GUI module
	MSN_GUI_LicenseNotice,
	MSN_GUI_Okay,
	MSN_GUI_NoTargets,
	MSN_GUI_NoTargetsHelp,
	MSN_GUI_ProfylerMenu,
	MSN_GUI_About,
	MSN_GUI_AboutShortcut,
	MSN_GUI_AboutMUI,
	MSN_GUI_MUISettings,
	MSN_GUI_Quit,
	MSN_GUI_ContactMenu,
	MSN_GUI_Scan,
	MSN_GUI_ScanShortcut,
	MSN_GUI_TargetMenu,
	MSN_GUI_Update,
	MSN_GUI_UpdateShortcut,
	MSN_GUI_SaveText,
	MSN_GUI_TextShortcut,
	MSN_GUI_SaveCSV,
	MSN_GUI_CSVShortcut,
	MSN_GUI_SaveTextTitle,
	MSN_GUI_SaveCSVTitle,
	MSN_GUI_SaveOkay,
	MSN_GUI_SaveCancel,
	MSN_GUI_FileExists,
	MSN_GUI_OverwriteOrCancel,
	MSN_GUI_SaveTextError,
	MSN_GUI_SaveCSVError,
	MSN_GUI_CantAccess,
	MSN_GUI_WriteError,
	MSN_GUI_Col1Title,
	MSN_GUI_Col2Title,
	MSN_GUI_Col3Title,
	MSN_GUI_Col4Title,
	MSN_GUI_Col5Title,
	MSN_GUI_Col6Title,
	MSN_GUI_Col7Title,
	MSN_GUI_Col8Title,
	MSN_GUI_Col9Title,
	MSN_GUI_FuncInfoTitle,
	MSN_GUI_FunctionInfo,
	MSN_GUI_FileHeader,
	MSN_GUI_CSVHeader,
	MSN_GUI_TextHeader,
	MSN_GUI_TextHeader2,
	MSN_GUI_TextHeader3,
	MSN_GUI_TextHeader4,
	MSN_GUI_TextHeader5,
	MSN_GUI_TextHeader6,
	MSN_GUI_TextHeader7,
	MSN_GUI_TextHeader8,
	MSN_GUI_TextHeader9,

	// Number of localized strings
	NUM_MSGS
};

// Convenient handles to the localized text strings, suitable for use any-
// where a string pointer is required.
// Main module
#define MSG_AppDescription			(Msgs[MSN_AppDescription])
#define MSG_OSTooOld				(Msgs[MSN_OSTooOld])
#define MSG_MUITooOld				(Msgs[MSN_MUITooOld])
#define MSG_Okay					(Msgs[MSN_Okay])
// GUI module
#define	MSG_GUI_LicenseNotice		(Msgs[MSN_GUI_LicenseNotice])
#define MSG_GUI_Okay				(Msgs[MSN_GUI_Okay])
#define MSG_GUI_NoTargets			(Msgs[MSN_GUI_NoTargets])
#define MSG_GUI_NoTargetsHelp		(Msgs[MSN_GUI_NoTargetsHelp])
#define	MSG_GUI_ProfylerMenu		(Msgs[MSN_GUI_ProfylerMenu])
#define	MSG_GUI_About				(Msgs[MSN_GUI_About])
#define	MSG_GUI_AboutShortcut		(Msgs[MSN_GUI_AboutShortcut])
#define	MSG_GUI_AboutMUI			(Msgs[MSN_GUI_AboutMUI])
#define	MSG_GUI_MUISettings			(Msgs[MSN_GUI_MUISettings])
#define	MSG_GUI_Quit				(Msgs[MSN_GUI_Quit])
#define	MSG_GUI_ContactMenu			(Msgs[MSN_GUI_ContactMenu])
#define	MSG_GUI_Scan				(Msgs[MSN_GUI_Scan])
#define	MSG_GUI_ScanShortcut		(Msgs[MSN_GUI_ScanShortcut])
#define	MSG_GUI_TargetMenu			(Msgs[MSN_GUI_TargetMenu])
#define	MSG_GUI_Update				(Msgs[MSN_GUI_Update])
#define	MSG_GUI_UpdateShortcut		(Msgs[MSN_GUI_UpdateShortcut])
#define	MSG_GUI_SaveText			(Msgs[MSN_GUI_SaveText])
#define	MSG_GUI_TextShortcut		(Msgs[MSN_GUI_TextShortcut])
#define	MSG_GUI_SaveCSV				(Msgs[MSN_GUI_SaveCSV])
#define	MSG_GUI_CSVShortcut			(Msgs[MSN_GUI_CSVShortcut])
#define	MSG_GUI_SaveTextTitle		(Msgs[MSN_GUI_SaveTextTitle])
#define	MSG_GUI_SaveCSVTitle		(Msgs[MSN_GUI_SaveCSVTitle])
#define	MSG_GUI_SaveOkay			(Msgs[MSN_GUI_SaveOkay])
#define	MSG_GUI_SaveCancel			(Msgs[MSN_GUI_SaveCancel])
#define	MSG_GUI_FileExists			(Msgs[MSN_GUI_FileExists])
#define	MSG_GUI_OverwriteOrCancel	(Msgs[MSN_GUI_OverwriteOrCancel])
#define	MSG_GUI_SaveTextError		(Msgs[MSN_GUI_SaveTextError])
#define	MSG_GUI_SaveCSVError		(Msgs[MSN_GUI_SaveCSVError])
#define	MSG_GUI_CantAccess			(Msgs[MSN_GUI_CantAccess])
#define	MSG_GUI_WriteError			(Msgs[MSN_GUI_WriteError])
#define MSG_GUI_Col1Title			(Msgs[MSN_GUI_Col1Title])
#define MSG_GUI_Col2Title			(Msgs[MSN_GUI_Col2Title])
#define MSG_GUI_Col3Title			(Msgs[MSN_GUI_Col3Title])
#define MSG_GUI_Col4Title			(Msgs[MSN_GUI_Col4Title])
#define MSG_GUI_Col5Title			(Msgs[MSN_GUI_Col5Title])
#define MSG_GUI_Col6Title			(Msgs[MSN_GUI_Col6Title])
#define MSG_GUI_Col7Title			(Msgs[MSN_GUI_Col7Title])
#define MSG_GUI_Col8Title			(Msgs[MSN_GUI_Col8Title])
#define MSG_GUI_Col9Title			(Msgs[MSN_GUI_Col9Title])
#define MSG_GUI_FuncInfoTitle		(Msgs[MSN_GUI_FuncInfoTitle])
#define MSG_GUI_FunctionInfo		(Msgs[MSN_GUI_FunctionInfo])
#define	MSG_GUI_FileHeader			(Msgs[MSN_GUI_FileHeader])
#define	MSG_GUI_CSVHeader			(Msgs[MSN_GUI_CSVHeader])
#define	MSG_GUI_TextHeader			(Msgs[MSN_GUI_TextHeader])
#define	MSG_GUI_TextHeader2			(Msgs[MSN_GUI_TextHeader2])
#define	MSG_GUI_TextHeader3			(Msgs[MSN_GUI_TextHeader3])
#define	MSG_GUI_TextHeader4			(Msgs[MSN_GUI_TextHeader4])
#define	MSG_GUI_TextHeader5			(Msgs[MSN_GUI_TextHeader5])
#define	MSG_GUI_TextHeader6			(Msgs[MSN_GUI_TextHeader6])
#define	MSG_GUI_TextHeader7			(Msgs[MSN_GUI_TextHeader7])
#define	MSG_GUI_TextHeader8			(Msgs[MSN_GUI_TextHeader8])
#define	MSG_GUI_TextHeader9			(Msgs[MSN_GUI_TextHeader9])
