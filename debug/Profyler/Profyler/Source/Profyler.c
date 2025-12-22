
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.1 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Main Module									Last modified 26-Feb-22	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 The Profyler Main module contains the master startup and shutdown code (in-
 cluding the opening and closing of system libraries and devices and the
 startup and shutdown of MUI), the program's main loop, localization func-
 tionality (including the default English language strings), and various
 utility functions that are too small/simple to rate modules of their own.

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

/***************************************************************************
*																		   *
* Setup																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Includes ===

#define __NOLIBBASE__				// we want to manage libraries ourself
#define __NOGLOBALIFACE__			// same for interfaces

#include <exec/types.h>
#include <exec/libraries.h>
#include <workbench/startup.h>
#include <workbench/workbench.h>
#include <devices/timer.h>
#include <libraries/asl.h>
#include <libraries/mui.h>

#include "Profyler.h"
#include "ProfIPC.h"
#include "ProfDB.h"
#include "ProfGUI.h"

#include <stdlib.h>
#include <string.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/locale.h>
#include <proto/intuition.h>
#include <proto/icon.h>
#include <clib/alib_protos.h>
#include <proto/muimaster.h>

// -------------------------------------------------------------------------
// === Prototypes ===

static void CloseLibraries(void);
static BOOL OpenLibraries(void);
static void DestroyMUIApp(Object *App);
static Object *CreateMUIApp(struct DiskObject *Icon);

// -------------------------------------------------------------------------
// === Macros ===


/***************************************************************************
*																		   *
* Data																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Defines ===


// -------------------------------------------------------------------------
// === Locals ===

// We depend on some of these variables being NULL on startup; the startup
// code ensures this (BSS is zeroed).

// The AmigaOS version string. For development, we want the date to be that
// of the build. At release, we want the date fixed to the release date. This
// is only updated when this module is compiled.
#if RELEASE
	static CONST_STRPTR VerStrg USED_VAR =
		"$VER: "PROG_NAME" "PROG_VERS" "RELEASE_DATE;
#else
	static CONST_STRPTR VerStrg USED_VAR =
		"$VER: "PROG_NAME" "PROG_VERS" "__AMIGADATE__;
#endif

// The minimum stack size 'cookie'.
static CONST_STRPTR StackStrg USED_VAR = "$STACK:65536";

// The main module's local data. It's small, so we put it in BSS to avoid the
// need to allocate it.
static struct
{
	// A pointer to the program catalog associated with the user's selected
	// langguage, if any.	
	struct Catalog *ProgCatalog;

	// The MUI Application object.
	Object *MUIApp;

	// The program's icon, loaded into memory.
	struct DiskObject *ProgIcon;

	// A lock on the program's current directory at startup.
	BPTR StartupDir;

	// A context for the ASL file requester. Lives here, as it may be used by
	// any module.
	struct FileRequester *FileReq;
} Envmt;

// A generic EasyStruct that is used for all error and other messages to the
// user from this module (we can't use MUI's requesters, as it may not be
// running yet). The body and gadget text is set to the appropriate localized
// string before the requester is brought up.
static struct EasyStruct UserMsg =
{
	sizeof (struct EasyStruct),		// size
	0,								// flags
	PROG_NAME,						// req. window name
	NULL,							// body text localized before use
	NULL,							// gadget text localized before use
};

// Names of the external MUI classes used by the program.
static CONST_STRPTR MUIClasses[] =
{
	"Aboutbox.mcc",
	NULL
};

// -------------------------------------------------------------------------
// === Globals ===

// We depend on some of these variables being NULL on startup; the startup
// code ensures this (BSS is zeroed).

// Base pointers for the libraries (and their interfaces) opened by the pro-
// gram.
struct Library *SysBase;
struct ExecIFace *IExec;
struct DebugIFace *IDebug;
struct Library *DOSBase;
struct DOSIFace *IDOS;
struct Library *LocaleBase;
struct LocaleIFace *ILocale;
struct Library *IntuitionBase;
struct IntuitionIFace *IIntuition;
struct Library *IconBase;
struct IconIFace *IIcon;
struct Library *MUIMasterBase;
struct MUIMasterIFace *IMUIMaster;
struct MsgPort *TimerPort;
struct TimeRequest *TimerLibIO;
struct Library *TimerBase;			// allows library calls to timer device
struct TimerIFace *ITimer;			// allows library calls to timer device

// Pointers to the localized text strings used by the program. By default
// these point to the built-in English strings. When a catalog for a differ-
// ent language is loaded, the pointers are set to the corresponding strings
// from the catalog. Note carefully the commas after the strings; some lines
// do not have commas, making the string part of the string below it.
STRPTR Msgs[] =
{
	// Main module
	"Software performance profiler for OS4",		// MSG_AppDescription
	"Sorry, %s requires OS\n%s or newer!",			// MSG_OSTooOld
	"Sorry, %s requires \nMUI %s or newer!",		// MSG_MUITooOld
	"Okay",											// MSG_Okay

	// GUI module
	"Distributed without warranty under the\n"		// MSG_GUI_LicenseNotice
	"terms of the GNU General Public License.\n",
	"_Okay",										// MSG_GUI_Okay
	"No Targets",									// MSG_GUI_NoTargets
	"No profiled programs available for display.",	// MSG_GUI_NoTargetsHelp
	"Profyler",										// MSG_GUI_ProfylerMenu
	"About...",										// MSG_GUI_About
	"?",											// MSG_GUI_AboutShortcut
	"About MUI...",									// MSG_GUI_AboutMUI
	"MUI Settings...",								// MSG_GUI_MUISettings
	"Quit",											// MSG_GUI_Quit
	"Contact",										// MSG_GUI_ContactMenu
	"Scan For Targets",								// MSG_GUI_Scan
	"S",											// MSG_GUI_ScanShortcut
	"Target",										// MSG_GUI_TargetMenu
	"Update",										// MSG_GUI_Update
	"U",											// MSG_GUI_UpdateShortcut
	"Save As Text...",								// MSG_GUI_SaveText
	"T",											// MSG_GUI_TextShortcut
	"Save As CSV...",								// MSG_GUI_SaveCSV
	"C",											// MSG_GUI_CSVShortcut
	"Save Profile As Text",							// MSG_GUI_SaveTextTitle
	"Save Profile As CSV",							// MSG_GUI_SaveCSVTitle
	"Save",											// MSG_GUI_SaveOkay
	"Cancel",										// MSG_GUI_SaveCancel
	"A file with that name already\n"				// MSG_GUI_FileExists
	"exists. Okay to overwrite it?",
	"_Overwrite|_Cancel",							// MSG_GUI_OverwriteOrCancel
	"Unable to save the text file-\n%s",			// MSG_GUI_SaveTextError
	"Unable to save the CSV file-\n%s",				// MSG_GUI_SaveCSVError
	"there was an error in accessing it.",			// MSG_GUI_CantAccess
	"there was an error in writing it. A\n"			// MSG_GUI_WriteError
	"partial file may have been created.",
	"\033cFunction",								// MSG_GUI_Col1Title
	"\033cLocation",								// MSG_GUI_Col2Title
	"\033cCalls",									// MSG_GUI_Col3Title
	"\033cInclusive",								// MSG_GUI_Col4Title
	"\033c% Incl.",									// MSG_GUI_Col5Title
	"\033cAvg. Incl.",								// MSG_GUI_Col6Title
	"\033cExclusive",								// MSG_GUI_Col7Title
	"\033c% Excl.",									// MSG_GUI_Col8Title
	"\033cAvg. Excl.",								// MSG_GUI_Col9Title
	"Function Details",								// MSG_GUI_FuncInfoTitle
	"\033bFunction name:\033n %s\n"					// MSG_GUI_FunctionInfo
	"\033bSource location:\033n %s\n"
	"\033bNumber of times called:\033n %s\n\n"
	"\033iInclusive of functions called\033n\n"
	"\033bTotal execution time:\033n %s\n"
	"\033bPercent of run time:\033n %s\n"
	"\033bAverage time per call:\033n %s\n\n"
	"\033iExclusive of functions called\033n\n"
	"\033bTotal execution time:\033n %s\n"
	"\033bPercent of run time:\033n %s\n"
	"\033bAverage time per call:\033n %s",
	"Profile Data for ",							// MSG_GUI_FileHeader
	"Function,Location,Calls,"						// MSG_GUI_CSVHeader
	"Incl. ns,Incl. %*10,Incl. Avg. ns,"
	"Excl. ns,Excl. %*10,Excl. Avg. ns\r\n",
	"Function Name",								// MSG_GUI_TextHeader
	"Source Code Location",							// MSG_GUI_TextHeader2
	"# of Calls",									// MSG_GUI_TextHeader3
	"Incl. Time",									// MSG_GUI_TextHeader4
	"Incl. %",										// MSG_GUI_TextHeader5
	"Incl. Avg.",									// MSG_GUI_TextHeader6
	"Excl. Time",									// MSG_GUI_TextHeader7
	"Excl. %",										// MSG_GUI_TextHeader8
	"Excl. Avg.",									// MSG_GUI_TextHeader9
};

/***************************************************************************
*																		   *
* Code																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Private code ===

/***************************************************************************

 CloseLibraries()

 Close all of the libraries opened by the program. No harm comes if any or
 all of the libraries are not open.

 Does not close Exec and DOS libraries, which are opened by the C startup
 code- the C shutdown code will do that.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void CloseLibraries(void)
{
	// Drop the library interfaces and close any libraries that were opened.
	// No harm comes if any of the pointers are NULL.
	ILocale->CloseCatalog(Envmt.ProgCatalog);
	IExec->DropInterface((struct Interface *)ILocale);
	IExec->CloseLibrary(LocaleBase);

	IExec->DropInterface((struct Interface *)IIntuition);
	IExec->CloseLibrary(IntuitionBase);

	IExec->DropInterface((struct Interface *)IDebug);

	IExec->DropInterface((struct Interface *)IIcon);
	IExec->CloseLibrary(IconBase);

	// Close the unit of the timer device that we opened in order to get
	// its library base.
	IExec->DropInterface((struct Interface *)ITimer);
	if(TimerBase) IExec->CloseDevice((struct IORequest *)TimerLibIO);
	if(TimerLibIO) IExec->FreeSysObject(ASOT_IOREQUEST, (APTR)TimerLibIO);
	if(TimerPort) IExec->FreeSysObject(ASOT_PORT, (APTR)TimerPort);

	IExec->DropInterface((struct Interface *)IMUIMaster);
	IExec->CloseLibrary(MUIMasterBase);
}

/***************************************************************************

 Success = OpenLibraries()

 Open any libraries used by the program. Load the catalog (if available) per
 the system default language, and set the localized string pointers accord-
 ingly. Verify that the Exec version is sufficient, and inform the user via
 a requester if it isn't. Also inform the user if any of the non-system lib-
 raries (such as MUI) are not present, or are too old. 

 Abort if unable to open any of the necessary libraries. Don't bother in-
 forming the user if any system libraries can't be opened. If the catalog
 can't be opened, just use the built-in English strings.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Success = TRUE if all of the required libraries were successfully opened, or
	FALSE if not.

***************************************************************************/

static BOOL OpenLibraries(void)
{
	uint32 i;

	// On entry Exec and DOS libraries have already been opened by the
	// startup code, so there's no need to open them here. Start by opening
	// locale library, so we can localize any requesters we need to display.
	// If it won't open we'll just use the built-in English strings.
	LocaleBase = IExec->OpenLibrary("locale.library", LIBV_MINIMUM);
	if(LocaleBase)
	{
		ILocale = (struct LocaleIFace *)IExec->GetInterface(LocaleBase,
			"main", 1, NULL);
		if(ILocale)
		{
			// Load the program's catalog for the default locale. If we
			// can't, we'll just use the built-in English strings. Uncomment
			// the 'OC_Language' line to force a specific catalog to be used
			// for testing purposes,
			Envmt.ProgCatalog = ILocale->OpenCatalog(NULL,
				PROG_NAME".catalog",
				// OC_Language, "english",
				TAG_END);
			if(Envmt.ProgCatalog)
			{
				// Load the localized strings from the catalog if available;
				// otherwise use the built-in defaults.
				for(i = 0; i < NUM_MSGS; i++)
				{
					Msgs[i] = (STRPTR)ILocale->GetCatalogStr(Envmt.ProgCatalog,
						i, Msgs[i]);
				}
			}
		}
	}

	// Next we open Intuition, so we can display requesters. We'll accept any
	// (OS4) version, so we can warn if the Exec version is too old.
	IntuitionBase = IExec->OpenLibrary("intuition.library", LIBV_MINIMUM);
	if(IntuitionBase == NULL) goto Failure;
	IIntuition = (struct IntuitionIFace *)IExec->GetInterface(IntuitionBase,
		"main", 1, NULL);
	if(IIntuition == NULL) goto Failure;

	// Now check to see what version/revision of Exec (and by extension, of
	// the OS) we're running.
	if(!LIB_IS_AT_LEAST(&((struct ExecBase *)SysBase)->LibNode,
		LIBV_NEEDED, LIBR_NEEDED))
	{
		// Oops- we're running under something that's too old. Let the user
		// know that we can't run, then bail out.
		UserMsg.es_TextFormat = MSG_OSTooOld;
		UserMsg.es_GadgetFormat = MSG_Okay;
		IIntuition->EasyRequest(NULL, &UserMsg, NULL, PROG_NAME, OS_NEEDED);
		goto Failure;
	}

	// Open the other required system libraries. Fail silently if these can't
	// be opened, since that shouldn't ever happen.
	IDebug = (struct DebugIFace *)IExec->GetInterface(SysBase, "debug", 1,
		NULL);
	if(IDebug == NULL) goto Failure;

	IconBase = IExec->OpenLibrary("icon.library", LIBV_NEEDED);
	if(IconBase == NULL) goto Failure;
	IIcon = (struct IconIFace *)IExec->GetInterface(IconBase, "main", 1,
		NULL);
	if(IIcon == NULL) goto Failure;

	// Open the timer device for use as a library. First create a reply port.
	// (It's not required when only using the device as a library, but allo-
	// cating the IO request will fail without it.)
	TimerPort = IExec->AllocSysObjectTags(ASOT_PORT, TAG_END);
	if(TimerPort == NULL) goto Failure;

	// Next, allocate an IO request, then use it to open the timer device
	// (which unit doesn't matter, as we're not going to use it).
	TimerLibIO = IExec->AllocSysObjectTags(ASOT_IOREQUEST, ASOIOR_Size,
		sizeof(struct TimeRequest), ASOIOR_ReplyPort, TimerPort, TAG_END);
	if(TimerLibIO == NULL) goto Failure;
	if(IExec->OpenDevice(TIMERNAME, UNIT_VBLANK,
		(struct IORequest *)TimerLibIO, 0)) goto Failure;

	// Finally, extract the timer device's library base, and from that get
	// the interface.
	TimerBase = (struct Library *)TimerLibIO->Request.io_Device;
	ITimer = (struct TimerIFace *)IExec->GetInterface(TimerBase, "main", 1,
		NULL);
	if(ITimer == NULL) goto Failure;

	// Let the user know if we don't have the required version of MUI (per-
	// haps because there's no MUI at all).
	MUIMasterBase = IExec->OpenLibrary(MUIMASTER_NAME, MUILIB_NEEDED);
	if(MUIMasterBase == NULL)
	{
		UserMsg.es_TextFormat = MSG_MUITooOld;
		UserMsg.es_GadgetFormat = MSG_Okay;
		IIntuition->EasyRequest(NULL, &UserMsg, NULL, PROG_NAME, MUI_NEEDED);
		goto Failure;
	}
	IMUIMaster = (struct MUIMasterIFace *)IExec->GetInterface(MUIMasterBase,
		"main", 1, NULL);
	if(IMUIMaster == NULL) goto Failure;

	// All is well. Return success.
	return(TRUE);

	// Come here if any libraries failed to open, or are too old. Return a
	// failure code.
Failure:
	return(FALSE);
}

/***************************************************************************

 DestroyMUIApp(App)

 Destroy the MUI application object. This will also dispose of any other MUI
 objects attached to the application object.

 In -----------------------------------------------------------------------

 App = A pointer to the MUI application object. No harm comes if App is NULL.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void DestroyMUIApp(Object *App)
{
	// Dispose of the application object and any other MUI objects attached
	// to it. No harm comes if App is NULL.
	IMUIMaster->MUI_DisposeObject(App);
}

/***************************************************************************

 App = CreateMUIApp(Icon)

 Create the MUI application object for the Profyler user interface. All other
 MUI elements will be attached to this object.

 In -----------------------------------------------------------------------

 Icon = A pointer to a DiskObject struct representing the program's icon as
	loaded into memory. May be NULL if the icon could not be located or read.

 Out ----------------------------------------------------------------------

 App = A pointer to the MUI application object if successful, or NULL if the
	application object could not be created.

***************************************************************************/

static Object *CreateMUIApp(struct DiskObject *Icon)
{
	Object *App;

	// Create the MUI application object. It will have no children.
	App = IMUIMaster->ApplicationObject,
		MUIA_Application_Title, PROG_NAME,
		MUIA_Application_Base, PROG_NAME_UC,
		MUIA_Application_Author, PROG_AUTHOR,
		MUIA_Application_Version, VerStrg,
		MUIA_Application_Copyright, PROG_COPYRIGHT,
		MUIA_Application_Description, MSG_AppDescription,
		MUIA_Application_SingleTask, TRUE,
		MUIA_Application_UsedClasses, MUIClasses,
		MUIA_Application_DiskObject, Icon,
	End;

	// Return a pointer to the application object, or NULL if it could not
	// be created.
	return(App);
}

/***************************************************************************

 Icon = GetProgIcon(argc, argv)

 Determine the name under which we were run (the user may have renamed the
 program), and use that to locate the program's icon (assumed to be in the
 same directory as the program). Load it from disk into memory, and return
 a pointer to the loaded disk object.

 The current directory is assumed to be set to the program's home directory
 (PROGDIR:).

 In -----------------------------------------------------------------------

 argc = Copy of argc as passed to main().

 argv = Copy of argv as passed to main().

 Out ----------------------------------------------------------------------

 DiskIcon = A pointer to a DiskObject structure representing the program's
	icon as loaded into memory. May be NULL if the icon could not be read
	(it may not exist in the expected location, or it may be unreadable for
	some reason).

***************************************************************************/

static struct DiskObject *GetProgIcon(int argc, char **argv)
{
	STRPTR ProgName;
	struct DiskObject *Icon;

	// Finding the icon requires finding the program's name, which varies
	// depending on how we were started.
	if(argc)
	{
		// We were started from a shell. Get the program's name from the
		// command line.
		ProgName = (STRPTR)IDOS->FilePart(argv[0]);
	}
	else
	{
		// We were started from Workbench. Get the program's name from the
		// WB startup message.
		ProgName = ((struct WBStartup *)argv)->sm_ArgList[0].wa_Name;
	}

	// Load the program's icon (ProgName.info) into memory.
	Icon = IIcon->GetDiskObject(ProgName);

	// Return a pointer to the loaded icon.
	return(Icon);
}

// -------------------------------------------------------------------------
// === Public code ===

/***************************************************************************

 result = main(argc, argv)

 The entry point to the program, called by the compiler's startup code when
 the program is run. If it don't happen here, it don't happen. When this
 routine exits the program terminates.

 In -----------------------------------------------------------------------

 argc = The number of arguments passed to the program when it was run. Will
	always be at least 1 if run from DOS, as the first argument is the name
	of the program itself. If argc is zero, the program was run from the
	Workbench.

 argv = A pointer to an array of pointers -- the number of which is given by
	argc -- to the program's arguments (all ASCIIZ strings). The first arg-
	ument is the name of the program; the remainder were entered by the user.
	If run from Workbench (argc is zero) argv points to a WBStartup message
	that contains (among other things) the program arguments supplied by the
	Workbench.

 Out ----------------------------------------------------------------------

 result = The return code from the program- an error code if non-zero, or
	zero if there were no errors. Ignored if the program was run from the
	Workbench.

***************************************************************************/

int main(int argc, char **argv)
{
	uint32 Signals, IPCSignal;

	// Assume no errors until we learn otherwise.
	int Error = 0;

	// Open the libraries we need. Abort if we don't get them.
	if(!OpenLibraries()) goto Abort;

	// Allocate the file requester context. Abort if we can't.
	Envmt.FileReq = IMUIMaster->MUI_AllocAslRequestTags(ASL_FileRequest,
		ASLFR_PrivateIDCMP, TRUE, TAG_END);
	if(!Envmt.FileReq) goto Abort;

	// Set the current directory to the program's home directory (PROGDIR:),
	// to make it easier to locate things. Remember the startup directory,
	// so we can switch back to it when exiting.
	Envmt.StartupDir = IDOS->SetCurrentDir(IDOS->GetProgramDir());

	// Get the program's icon (which lives in the home directory).
	Envmt.ProgIcon = GetProgIcon(argc, argv);

	// Create the MUI application object. Abort if we can't.
	Envmt.MUIApp = CreateMUIApp(Envmt.ProgIcon);
	if(!Envmt.MUIApp) goto Abort;

	// Start up all of the program modules. Abort if any fail to initialize.
	if(!DB_Start()) goto Abort;
	if(!IPC_Start()) goto Abort;
	if(!GUI_Start(Envmt.MUIApp)) goto Abort;

	// Get the signal used by the IPC module's public message port. This is
	// assumed to not change while the program is running.
	IPCSignal = IPC_GetSignal();

	// Start out by scanning memory for any programs being profiled and open-
	// ing a GUI tab for any that are found.
	IPC_Scan();

	// Startup was successful. Enter the main loop, where we will remain
	// until the program is terminated by the user.
	Signals = 0;

	// Let MUI process any signals that occurred during the last wait. MUI
	// will let us know if we need to quit; otherwise loop forever.
	while(IIntuition->IDoMethod(Envmt.MUIApp, MUIM_Application_NewInput,
		&Signals) != MUIV_Application_ReturnID_Quit)
	{
		// Only wait if MUI doesn't want to be called again immediately.
		if(Signals)
		{
			// Wait for any signals that are important to MUI, in addition to
			// the IPC port signal and a break signal from the OS.
			Signals = IExec->Wait(Signals | IPCSignal | SIGBREAKF_CTRL_C);

			// A break from the OS quits the program.
			if(Signals & SIGBREAKF_CTRL_C) break;

			// A message has arrived at the IPC port- process it.
			if(Signals & IPCSignal) IPC_Incoming();
		}
	}

	// The program has ended. Clean up and return a success code.
	goto Quit;

	// Come here to quit the program when something goes wrong during start-
	// up. Set the return code to signal an error, and fall into the normal
	// quit code.
Abort:
	Error = 20;

	// Come here to quit the program normally.
Quit:
	// Shut down all of the program modules.
	GUI_Stop();
	IPC_Stop();
	DB_Stop();

	// Restore the startup directory, if we've switched away from it.
	if(Envmt.StartupDir) IDOS->SetCurrentDir(Envmt.StartupDir);

	// Free the MUI application object and all its children.
	if(Envmt.MUIApp) DestroyMUIApp(Envmt.MUIApp);

	// Free the file requester context.
	if(Envmt.FileReq) IMUIMaster->MUI_FreeAslRequest(Envmt.FileReq);

	// Free the in-memory copy of the program's icon.
	if(Envmt.ProgIcon) IIcon->FreeDiskObject(Envmt.ProgIcon);

	// Close the libraries.
	CloseLibraries();

	// Let DOS know how it went.
	return(Error);
}

/***************************************************************************

 FileReq = APP_GetFileReq()

 Return a pointer to an ASL FileRequester struct that serves to provide a
 context for any ASL file requesters that need to be opened by the program.
 Using a single such struct for all file requester activity allows common
 settings to be made only once, and allows the requester to remember items
 such as the last directory it accessed.

 Since there is only one such struct, the program needs to ensure that only
 one file requester is ever opened at a time.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 FileReq = A pointer to an ASL FileRequester struct. The pointer is guaran-
	teed to be valid.

***************************************************************************/

struct FileRequester *APP_GetFileReq(void)
{
	// Return a pointer to our initialized FileRequester,
	return(Envmt.FileReq);
}

/***************************************************************************

 APP_SetDOSErrWind(WindowObj)

 Set the pr_WindowPtr field of the program's process to tell DOS where to
 display its user-interactive requesters (such as asking the user to insert
 a disk). Choices include the screen containing a particular window, the de-
 fault public screen (normally Workbench), or to not display the requesters
 at all.

 If set to a particular program window, the value must be cleared before that
 window is closed. Keep in mind that windows may be closed unexpectedly if
 the program is iconified or MUI preferences are adjusted, so it's best to
 set a window only for limited periods when performing activity involving
 DOS.

 In -----------------------------------------------------------------------

 WindowObj = A pointer to a MUI Window object (NOT an Intuition Window), to
	tell DOS to display requesters on that window's screen, or the special
	values NULL (to display requesters on the default public screen) or -1
	(to not display the requesters at all).

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void APP_SetDOSErrWind(APTR WindowObj)
{
	struct Process *Ourself;
	struct Window *Wind;

	// Get a pointer to the program's DOS process.
	Ourself = (struct Process *)IExec->FindTask(NULL);

	// Is the window pointer one of the special values?
	if((WindowObj == NULL) || (WindowObj == (APTR)-1))
	{
		// Yes- set the value as the pr_WindowPtr.
		Ourself->pr_WindowPtr = WindowObj;
	}
	else
	{
		// No- get a pointer to the MUI Window object's associated Intuition
		// window.
		Get((Object *)WindowObj, MUIA_Window_Window, &Wind);

		// And set it as the pr_WindowPtr.
		Ourself->pr_WindowPtr = (APTR)Wind;
	}
}
