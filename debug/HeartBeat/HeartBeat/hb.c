
/*****************************************************************************
* HeartBeat 1.0										(C) L. Vanhelsuwé 1992-94
* -------------										-------------------------
*
* Written by Laurence Vanhelsuwé in April 1992
*
* HeartBeat is a generic Amiga system call monitor.
* It allows you to monitor a Task's system calls usage or monitor global
* system call activity.
* This program uses the standard Commodore .FD files for all its information
* on available libraries and system calls. This results in a program which
* isn't locked to a certain revision of the Operating System but one that
* evolves with it.
* Additionally, executable size is kept small by not having system call info
* embedded inside the program.
*
* History
* -------
* 06-APR-92: started coding		(goal: loading and parsing of all .fd files)
* 07-APR-92: had a look at gadtools stuff (done most of register requester)
* 08-APR-92:					(goal: function selection/constant refresh)
* 10-APR-92: modified event loop to more robust global event port system
* 16-APR-92: added new/load/save project options
* 22-APR-92: discovered ASL FileRequest doesn't return full filename! Arghh
* 26-APR-92: added non-ROM vector highlighting (handy for VIRUS detection !)
* 13-JUN-92: added function address printing
* 22-APR-94: Finally cleaned up ASL Filerequester code!
* 
* To Dos:
* -------
* - **!! Ensure monitored libraries don't ever get flushed while we run.
* - Fix currentdir change side-effect
* -
* -
*****************************************************************************/

// **!! REQUIRES 2.0 OS !!	(CHECKED AT RUN-TIME)

		// Include Amiga specific header files
#include	<exec/execbase.h>
#include	<exec/io.h>
#include	<exec/memory.h>
#include	<exec/nodes.h>
#include	<exec/types.h>

#include	<devices/timer.h>

#include	<dos/dosextens.h>

#include	<intuition/intuition.h>
#include	<intuition/intuitionbase.h>
#include	<intuition/gadgetclass.h>

#include	<libraries/asl.h>
#include	<libraries/gadtools.h>

#include	<utility/tagitem.h>


		// Include standard C headers and Lattice specific headers
#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>
#include	<ctype.h>


		// Include function prototype definitions
		// Headers coming out of the PROTO directory include #pragmas to use
		// registerized system call calling.

#include	<clib/exec_protos.h>
#include	<clib/graphics_protos.h>
#include	<clib/dos_protos.h>
#include	<clib/intuition_protos.h>
#include	<clib/utility_protos.h>
#include	<clib/gadtools_protos.h>
#include	<clib/asl_protos.h>

void NewList( struct List *);

		// Include Application private headers
#include	"cload_file.h"

// All system functions which are currently being tracked have a context
// structure associated with them so that patch stubs can use this to store
// function-specific (local, contextual) information.

struct Context {
	ULONG	regvals[16];		// D0..D7, A0..A7
	ULONG	regmasks[16];		// don't care bits for above
	USHORT	freeze;				// freeze on match or just count ?
	USHORT	frozen;				// wedge froze Task TRUE/FALSE
	ULONG	called_cnt;			// each time func gets called this increments
	ULONG	trapped_cnt;		// each time input registers match template
	ULONG	last_called_cnt;	// last value of above (to optimize update)
	ULONG	last_trapped_cnt;	// last value of above (to optimize update)
	APTR	stdvector;			// ptr to normal ROM/RAM routine for this syscall
};

// Every library function found in the .fd files gets a structure as follows:

struct SysCall {
	struct	Node func_node;		// a node so we can link ya all together
	char	*funcname;			// ptr to name of system call (eg "CurrentDir")
	USHORT	namelen;			// length in bytes of name
	SHORT	func_LVO;			// the _LVO for this function	(eg -$C0)
	struct	Library *parent_lib;// this func belongs to library X
	struct  Context	*ctxt;		// ptr to context struct for patch.
};

//-------------------------------------------------------------------------

#define		MAX_LIBS		40		// can't cope with more libraries !
#define		MAX_FUNCS		1500	// can't cope with more functions (total)
#define		MAX_PATCHED		72		// can't cope with more PATCHED functions
#define		MAX_FILENAME 	512		// maximum absolute filename (LONG PATHS on networks!)

#define		POOL_SIZE	(MAX_FUNCS*sizeof(struct SysCall))

#define		LF			10

#define		REFRESH_FREQ	4	// times a second update call counters

// Enumeration type for app_state (application state)

#define		FUNCWINDOW	1		// window with function list active
#define		MONWINDOW	2		// window with tracked functions active
#define		REGSWINDOW	3		// register set requester window active
#define		TASKWINDOW	4		// task requester window active

#define		WINWIDTH	640		// Need interlace Workbench to open !
#define		WINHEIGHT	340
#define		PANE_X		5		// offset to Gimme00 area.
#define		PANE_Y		12

#define		MAX_LABLEN	20		// extra long function names are chopped
#define		MAX_TASKLAB	20		// maximum length of a Task name string in req.

#define		CHAR_WIDTH	8		// pixel dimensions for Topaz 80
#define		CHAR_HEIGHT	8

// Enumeration type for our scan_state variable

#define		NEED_NAME		0	// initial state to grab head like * "dos.library"
#define		NEUTRAL			1	// neutral state to find out what we're looking at.
#define		GET_FUNC		2	// get all other lines
#define		GET_COMMAND		3	// get line with ##cmd

#define		ERR_OK			0	// no error occurred
#define		ERR_BADFILE		1	// incorrect file format
#define		ERR_DOSERR		2	// failed to save file
#define		ERR_NOMEM		3	// running out of memory...

#define		HB_SIGNATURE	">>HeartBeat Session dump (C) LVA 1992\n"
//-------------------------------------------------------------------------

// Function Prototypes
// -------------------

struct	MsgPort *CreateMsgPort	(void);
void	DeleteMsgPort			(struct MsgPort*);

// Local function prototypes
//--------------------------

void	cleanup					(void);
void	exit					(int code);
void	text_to_heap			(struct FileCache *fc);
void	refresh_counters		(void);
void	handle_quit				(void);
void	handle_activation		(void);
void	handle_menuselection	(SHORT menu);
void	handle_keypress			(char key);
void	handle_click			(void);
void	handle_gadgets			(void);
void	append_lib_menus		(void);
void	display_functions		(void);
void	handle_mousemove		(void);
void	unpatch_functions		(void);
void	find_function_info		(void);
void	popup_About_req			(void);
void	reset_counters			(void);
void	kill_taskReq_window		(void);
void	kill_regsReq_window		(void);
void	watch_task				(int index);
void	quick_msg				(char *message, char *exit);
void	strip_lf				(char *str);
void	collect_taskinfo		(struct Node *task);
void	CloseWindowSafely		(struct Window *win);
void	StripIntuiMessages		(struct MsgPort *mp, struct Window *win);
void	init_context			(struct Context *cx);

void	fill_box				(int x, int y, int yoffs, int width, struct RastPort*, int pen);
#define	highlight_box(x,y,w)	fill_box(x,y,0,w,rp,3)
#define	erase_box(x,y,w)		fill_box(x,y,0,w,rp,0)
#define	highlight_monbox(x,y,w)	fill_box(x,y,12,w,monrp,3)
#define	erase_monbox(x,y,w)		fill_box(x,y,12,w,monrp,0)

BOOL	init_program			(void);
BOOL	process_fd_file			(struct FileCache *fc);
BOOL	popup_funcwindow		(void);
BOOL	add_function			(struct SysCall*);
BOOL	ask_register_info		(char *wintitle, struct Context *ctxt);
BOOL	ask_task				(char *wintitle);

int		calc_num_fd_files		(void);
int		load_funclist			(void);
int		save_funclist			(void);

char	*get_filename			(char * windowmsg);

struct SysCall *find_func		(char *libname, char *funcname);

//-------------------------------------------------------------------------
// Global variables
//-----------------
extern struct ExecBase		*SysBase;
extern struct IntuitionBase	*IntuitionBase;
       struct GadToolsBase 	*GadToolsBase;	// not part of lc.lib this one
	   struct AslBase		*AslBase;
extern struct GfxBase		*GfxBase;

extern void WEDGE(void);			// to be copied and patched

struct library {
	struct List		funcslist;		// functions for this lib/dev/resource
	char			*libname;		// name of this library/device/resource
	struct Library	*openhandle;	// ret from OpenLibrary/OpenDevice/OpenResource
	int				numfuncs;		// # of entry points
};

struct library libs[MAX_LIBS];		// an array to store info on all libs
struct library *curlib=NULL;		// curlib points to the current library

struct SysCall *patched_calls[MAX_PATCHED];	// array of ptrs into patched funcs
struct SysCall *selected_syscall;	// -> selected func for register template

struct SysCall *node_pool,*pool_base;
struct Context *ctxt_pool;

struct Task *SNOOP_TASK;			// Task that's being monitored
struct List taskList;				// global list header for LISTVIEW gadget

struct MsgPort *timerport,*IDCMPport;		// our two main IPC ports
struct timerequest timereq;

struct Window	*window, *monwindow, *taskwindow, *regswindow;
struct Screen	*screen;
struct RastPort *rp,*monrp,*regsrp;
struct Menu		*menustrip;
struct TextAttr *TAttr;
struct Gadget	*taskReqGads;		// ptr to gadlist for Task Requester window
struct Gadget	*regsReqGads;		// ptr to gadlist for Regs Requester window
void   *vi;							// global VisualInfo ptr for Workbench Screen

struct FileCache fd_caches[MAX_LIBS];	// bookkeeping for cached .fd files
struct FileCache FdDirCache;			// for .fd directory listing file

int num_fdfiles;					// number of .fd libraries		(Constant)
int numlibs;						// number of accessible libs	(Constant)
int total_funcs;					// total numer that we know of
int libnum;							// index into library array (Variable)
int lowlibs;						// # of libraries in A..I menu
int monitored;						// # of functions monitored (= patched)
int app_state;						// state application finds itself in...

char filename_buf[MAX_FILENAME];	// large buff to construct abs file names

struct RDAres {						// array for ReadArgs()
	ULONG forceopen;				// force Library to be resident
	ULONG verbose;					// print lots of debug info.
} options;

#define	VERBOSE		options.verbose
#define	FORCEOPEN	options.forceopen

SHORT winwidth=WINWIDTH, winheight=WINHEIGHT;
SHORT maxrows;						// # of rows to print functions
SHORT mousex,mousey;
SHORT msgcode;
SHORT oldboxx = -1, oldboxy = -1;
SHORT oldmonboxy = -1;
SHORT task_num;						// "remember" variable for Task Req gadget

APTR IAddr;							// ptr to Intuition object (Gadget,..)

BOOL quit_me;						// IDCMP quit request
BOOL menus_exist = FALSE;			// SetMenuStrip() not yet...

//-------------------------------------------------------------------------
// A NewWindow struct to open application Windows (re-used many times)
// (Initial values are for main function window only)
//-------------------------------------------------------------------------

struct NewWindow nw = {
	0, 16, WINWIDTH, WINHEIGHT,
	255, 255,						/* Default pens */

			// I want to know about following IDCMP Message types
//	IDCMP_CLOSEWINDOW|
//	IDCMP_ACTIVEWINDOW|
//	IDCMP_MENUPICK|
//	IDCMP_MOUSEMOVE|
//	IDCMP_MOUSEBUTTONS|
//	IDCMP_GADGETUP|
//	LISTVIEWIDCMP|

// All windows we open get this set of IDCMP bits attached to them.
// Not all windows can generate all those types of msgs though, but that
// doesn't matter (Jimmy).

#define	IDCMP_SELECTION (IDCMP_CLOSEWINDOW|\
						 IDCMP_MENUPICK|\
						 IDCMP_MOUSEMOVE|\
						 IDCMP_MOUSEBUTTONS|\
						 IDCMP_GADGETUP|\
						 LISTVIEWIDCMP|\
						 IDCMP_ACTIVEWINDOW)

			// BUT we force Intuition to use our own MsgPort so specify 0 here
	0,

			// Standard window flags
	WFLG_ACTIVATE|
	WFLG_CLOSEGADGET|
	WFLG_DEPTHGADGET|
	WFLG_DRAGBAR|
	WFLG_REPORTMOUSE,

	NULL,				// No gadgets in this window
	(struct Image *) NULL,
	"Amiga HeartBeat 1.0 (written by LVA © April 1992)", // Window title
	(struct Screen *) NULL,
	(struct BitMap *) NULL,
	100, 40,				/* Minimum sizes */
	65535, 65535,			/* Maximum sizes */
	WBENCHSCREEN			/* and put it on the workbench */
};

//-------------------------------------------------------------------------
// Menu Layout in compact GadTools format.
//-------------------------------------------------------------------------

#define	PROJECT_MENU	0
#define	OPTIONS_MENU	1
#define	LIBS_1_MENU		2
#define	LIBS_2_MENU		3

#define	 NEW_ITEM		 0
#define	 LOAD_ITEM		 1
#define	 SAVE_ITEM		 2
#define	DUMMY_ITEM0		 3
#define	 ABOUT_ITEM		 4
#define	 QUIT_ITEM		 5

#define	 RESET_ITEM		 0
#define	 GLOBAL_ITEM	 1
#define	 TASK_ITEM		 2

// First empty slot @ offset N
#define	NEWMENU_APPEND	12

struct NewMenu mymenus[MAX_LIBS+NEWMENU_APPEND+2]= {
	{ NM_TITLE,		"Project",	NULL,	0,0,0},
	{ NM_ITEM,		"New",		"N",	0,0,0},	// Kill monitor window
	{ NM_ITEM,		"Load Session...",	"L",	0,0,0},	// Load monitor window selection
	{ NM_ITEM,		"Save Session...",	"S",	0,0,0},	// Save monitor window selection
	{ NM_ITEM, 		NM_BARLABEL,NULL,	0,0,0},
	{ NM_ITEM,		"About...",	NULL,	0,0,0},
	{ NM_ITEM,		"Quit",		"Q",	0,0,0},

	{ NM_TITLE,		"Options",	NULL,	0,0,0},
	{ NM_ITEM,		"Reset counters", "C",0,0,0},
	{ NM_ITEM,		"Watch GLOBAL",	  "G",0,0,0},
	{ NM_ITEM,		"Watch Task.....","T",0,0,0},

	{ NM_TITLE,		"Libraries A-I",NULL,0,0,0} };

//	{ NM_END,		NULL,		NULL,	0,0,0} };

char version[]="$VER: HeartBeat 1.0 ©LVA (19/MAY/94)";

/**************************************************************************
** Here's the main program.
**
** Basically:
**	- load and parse all .fd files from the FD: directory.
**	- bring up main function selection window (generate menustrip)
**	- accumulate function selections in the "monitored functions" window
**	- allow users to switch between global and Task snooping, set argument
**	  register traps, etc...
**
** The main event loop needs some explaining:
** We do a combined Wait() for two sources:
**  1) timer.device timeouts
**  2) Intuition IntuiMessages
** The timer.device is used instead of INTUITICKS because we want the counters
** output window to continue updating when another non-HeartBeat window becomes
** the active one. (INTUITICKS stop when your window is deactivated).
**
** All windows are hooked into the same message port which in turn generates
** (and uses) just one signal. That's why the code uses ModifyIDCMP() and
** messes around with the Window->UserPort field.
**
** When windows other than the main function window (the window listing all
** function in a particular library) are opened, input to other windows is
** not blocked (IDCMP loop still collects from all sources).
****************************************************************************/

void main (void) {

struct RDArgs		*rdargs;
struct IntuiMessage *msg;
ULONG msgtype;
ULONG signals,timeout_signal,Intevent_signal;

	if ( ((struct Library*)SysBase)->lib_Version < 36) {
		printf("[1m[2mHeartBeat[0m needs AmigaDOS 2.0 (V36+)... [3mSorry![0m\n");
		exit(10);
	}

// Check command line options.

	if (! (rdargs = ReadArgs("FORCE/S,VERBOSE/S", (ULONG*) &options, NULL))) {
		printf("Amiga HeartBeat written by Laurence Vanhelsuwé © April 1992\n");
		printf("HeartBeat is a system call monitoring utility.\n");
		printf("Type HART ? for a full syntax template.\n");
		exit(5);
	}
	FreeArgs(rdargs);

// Open libraries, init arrays, memory pools, etc...
	if (!init_program()) exit(50);

// From the standard .fd (function definitions) files, get all the info
// about system calls that we need.
	find_function_info();

// bring up main function selection window with its menus
	if (!popup_funcwindow()) {
		printf("Failed to open main window (need at least %d*%d Workbench)\n",
				WINWIDTH, WINHEIGHT+16);
		cleanup();
	}

	curlib = &libs[0];			// curlib global for further references
	display_functions();		// 1st library is default

// cache the two possible signals that we can receive
	timeout_signal  = 1<<timerport->mp_SigBit;
	Intevent_signal = 1<<IDCMPport->mp_SigBit;

// Send initial timeout request to timer.device
// (provides refresh interrupts)
	timereq.tr_time.tv_secs    = 0;
	timereq.tr_time.tv_micro   = 1000000/REFRESH_FREQ;	// MICRO != MILLI
	timereq.tr_node.io_Command = TR_ADDREQUEST;
	SendIO((struct IORequest *) &timereq);				// asynchronous IO !

	quit_me = FALSE;		// user hasn't clicked on CLOSE gadget yet...

	while (!quit_me) {

	// Wait for an Intuition event or a Timer device timeout (or both simult.)
	    signals = Wait( Intevent_signal | timeout_signal);

		if (signals & timeout_signal) {		// .... ping !
			GetMsg(timerport);				// dequeue msg (is just an ACK)
			timereq.tr_time.tv_secs    = 0;
			timereq.tr_time.tv_micro   = 1000000/REFRESH_FREQ;
			timereq.tr_node.io_Command = TR_ADDREQUEST;
			timereq.tr_node.io_Message.mn_Node.ln_Type = NT_MESSAGE;
			SendIO((struct IORequest *) &timereq);	// ... pong !

			refresh_counters();				// refresh counters window
		}

		// For Intuition Messages use the gadtools GetMsg/ReplyMsg variants
		// so that gadtools can intercept gadget clicks which it (and not we)
		// should process (e.g. for CYCLE_KIND or LISTVIEW_KIND gadgets !).

		if (signals & Intevent_signal) {
			while (msg = GT_GetIMsg(IDCMPport)) {

		  		msgtype	= msg->Class;	// copy Message fields and
				msgcode	= msg->Code;
				mousex	= msg->MouseX;
				mousey	= msg->MouseY;
				IAddr	= msg->IAddress;

				GT_ReplyIMsg(msg);		// reply swiftly

#ifdef	DEBUGX
printf("IDCMP MSGTYPE:%8lx (CODE:%8lx) ", msgtype, msgcode);
				switch (msgtype) {
					case CLOSEWINDOW:	printf("CLOSEWINDOW\n"); break;
					case ACTIVEWINDOW:	printf("ACTIVEWINDOW\n"); break;
					case MENUPICK:		printf("MENUPICK:\n"); break;
					case MOUSEMOVE:		printf("MOUSEMOVE:\n"); break;
					case MOUSEBUTTONS:	printf("MOUSEBUTTONS\n"); break;
					case VANILLAKEY:	printf("VANILLAKEY\n"); break;
					case GADGETUP:		printf("GADGETUP:\n"); break;
					case INTUITICKS:	printf("INTUITICKS\n"); break;
					case REFRESHWINDOW:	printf("REFRESHWINDOW\n"); break;
					default:			printf("-- UNKNOWN --\n");
				}
#endif
				switch (msgtype) {
					case CLOSEWINDOW:	handle_quit();					break;
					case ACTIVEWINDOW:	handle_activation();			break;
					case MENUPICK:		handle_menuselection(msgcode);	break;
					case MOUSEMOVE:		handle_mousemove();				break;
					case MOUSEBUTTONS:	handle_click();					break;
					case VANILLAKEY:	handle_keypress( (char) msgcode); break;
					case GADGETUP:		handle_gadgets();				break;
					case INTUITICKS:	break;
					case REFRESHWINDOW:	GT_BeginRefresh((struct Window*)IAddr);
						    			GT_EndRefresh((struct Window*)IAddr, TRUE);
									    break;
					default:
						printf("Unknown IDCMP MSGTYPE:%x (CODE:%x)\n", msgtype, msgcode);
				}
			}	// WHILE MESSAGES FROM A WINDOW
		}		// IF Intuition event...
	}			// WHILE NOT QUITTING

	// At this stage a timout is ALWAYS outstanding so wait for it to come back.

	WaitPort(timerport); GetMsg(timerport);

	cleanup();		// finally before returning to the CLI...
}

//-------------------------------------------------------------------------
// Here follows the various IntuiMessage handlers.
// The handlers themselves further branch to the required logic depending
// on the "state" of HeartBeat. This state is usually directly related to
// which HeartBeat window is currently active.
//
// The IntuiMessage ACTIVEWINDOW therefore is the main cause of state switching.
//-------------------------------------------------------------------------


//-------------------------------------------------------------------------
// We received a CLOSEWINDOW event. This can come from any of our windows,
// so close requested window only (if main window: signal kill application).
//-------------------------------------------------------------------------

void handle_quit(void) {

	switch (app_state) {

		//-----------------------------------------------------------------
		case FUNCWINDOW:
			if (!monwindow && !taskwindow && !regswindow)
				quit_me = TRUE;
			break;

		//-----------------------------------------------------------------
		case MONWINDOW:
			unpatch_functions();		// unpatch from system !

			CloseWindowSafely(monwindow); monwindow = NULL;

			if (curlib) display_functions();	// refresh func names list

			// app_state = FUNCWINDOW; break;
			ActivateWindow(window);		// this is safer way to achieve same
			break;

		//-----------------------------------------------------------------
		case REGSWINDOW:
			kill_regsReq_window();		// done with window: get rid of it

			//	app_state = FUNCWINDOW;	// revert to neutral state
			ActivateWindow(window);		// this is safer way to achieve same
			break;

		//-----------------------------------------------------------------
		case TASKWINDOW:
			kill_taskReq_window();		// done with window: get rid of it

			//	app_state = FUNCWINDOW;	// revert to neutral state
			ActivateWindow(window);		// this is safer way to achieve same
			break;

		//-----------------------------------------------------------------
		default: printf("QUIT BUG: appi in unknown state %d\n", app_state);
	}
}
//-------------------------------------------------------------------------
// An ACTIVEWINDOW event has arrived at our main IDCMP comms port.
// To aid in determining which Gadgets get clicked or which window receives
// a mouse click, we track which window is currently the actived one.
//-------------------------------------------------------------------------
void handle_activation(void) {

	switch (app_state) {

		case FUNCWINDOW:
		case MONWINDOW:
		case TASKWINDOW:
		case REGSWINDOW:
			if (IAddr == (APTR) window)		{ app_state = FUNCWINDOW;} else
			if (IAddr == (APTR) monwindow)	{ app_state = MONWINDOW; } else
			if (IAddr == (APTR) taskwindow) { app_state = TASKWINDOW;} else
			if (IAddr == (APTR) regswindow) { app_state = REGSWINDOW;}
			break;

		default: printf("ACTIV BUG: appi in unknown state %d\n", app_state);
	}
}
//-------------------------------------------------------------------------
// A MENUPICK event has arrived. Only the main function window can generate
// this, but other windows might also be around so watch out for that.
//-------------------------------------------------------------------------
void handle_menuselection(SHORT menu) {

int library;
int err;

	switch (MENUNUM(menu)) {
		//----------------------------------------------------------------
		case PROJECT_MENU:
			switch (ITEMNUM(menu)) {
				//--------------------------------------------------------
				case NEW_ITEM:
					if (!monwindow) break;		// only if monitor window exists

					unpatch_functions();		// unpatch from system !
					CloseWindowSafely(monwindow); monwindow = NULL;

					break;
				//--------------------------------------------------------
				case LOAD_ITEM:
					err = load_funclist();
					switch (err) {
						case ERR_OK:
							break;
						case ERR_BADFILE:
							quick_msg("Your selected file isn't a HeartBeat file!","Oopps..");
							break;
						case ERR_DOSERR:
							quick_msg("Could not open your file!","Hmmm..");
							break;
						default:
							quick_msg("**!! UNKNOWN ERROR IN LOAD_ITEM","arggh..");
							break;
					}
					break;
				//--------------------------------------------------------
				case SAVE_ITEM:
					if (monwindow) {
						err = save_funclist();
						switch (err) {
							case ERR_OK:
								break;
							case ERR_DOSERR:
								quick_msg("Couldn't save session!","Pitty");
								break;
							default:
								quick_msg("**!! UNKNOWN ERROR IN LOAD_ITEM","arggh..");
								break;
						}
					} else {
						quick_msg("No monitoring session to save!","Sorry..");
					}
					break;
				//--------------------------------------------------------
				case ABOUT_ITEM:
					popup_About_req();
					break;
				//--------------------------------------------------------
				case QUIT_ITEM:
					if (!monwindow && !taskwindow && !regswindow)
						quit_me = TRUE;
					break;
			}
			break;
		//----------------------------------------------------------------
		case OPTIONS_MENU:
			switch (ITEMNUM(menu)) {
				//--------------------------------------------------------
				case GLOBAL_ITEM:
					reset_counters();
					SNOOP_TASK = NULL;
					if (monwindow)
						SetWindowTitles(monwindow,"Monitored functions (GLOBAL)", (char*) -1);
					break;
				//--------------------------------------------------------
				case TASK_ITEM:
					if (!taskwindow) {
						// pop up window with list of Tasks. User selection
						// will come to us via standard gadget clicks, not
						// here !
						ask_task("Please select any Task.");
					} else {
						WindowToFront(taskwindow);
						ActivateWindow(taskwindow);
					}
					break;
				//--------------------------------------------------------
				case RESET_ITEM:
					reset_counters();
					break;
			}
			break;
		//----------------------------------------------------------------
		case LIBS_1_MENU:
			library = ITEMNUM(menu);
			curlib = &libs[library];	// curlib global for further references
			display_functions();
			break;
		//----------------------------------------------------------------
		case LIBS_2_MENU:
			library = ITEMNUM(menu) + lowlibs;
			curlib = &libs[library];
			display_functions();
			break;
	}
}
//-------------------------------------------------------------------------
// If mouse points at a new function, de-highlight old box and highlight new
// one.
// This has the effect of a cursor over the available functions.
//-------------------------------------------------------------------------

void handle_mousemove(void) {
SHORT boxx,boxy,monboxy;

	switch (app_state) {
		//----------------------------------------------------------------
		case MONWINDOW:
			monboxy = (mousey-PANE_Y-1-12)/CHAR_HEIGHT;
			// If mouse moved out of previous box area...
			if (monboxy != oldmonboxy) {

				// restrict legal box movements!

				if ( monboxy >= 0 && monboxy < monitored ) {
					if (oldmonboxy != -1) {
						erase_monbox(0,oldmonboxy,(MAX_LABLEN+25)*CHAR_WIDTH);
					}

					highlight_monbox(0,monboxy,(MAX_LABLEN+25)*CHAR_WIDTH);
					oldmonboxy = monboxy;
				}
			}
			break;
		//----------------------------------------------------------------
		case FUNCWINDOW:

			boxx = (mousex-PANE_X)/(MAX_LABLEN*CHAR_WIDTH);
			boxy = (mousey-PANE_Y-1)/CHAR_HEIGHT;

			// If mouse moved out of previous box area...
			if (boxx != oldboxx || boxy != oldboxy) {

				if (boxx >= 0		&&			// restrict legal box movements!
					boxy >= 0		&&
					boxy < maxrows	&&
					(boxy + maxrows*boxx) < curlib->numfuncs) {

						if (oldboxx != -1) {
							erase_box(oldboxx,oldboxy,(MAX_LABLEN*CHAR_WIDTH)-10);
						}

						highlight_box(boxx,boxy, (MAX_LABLEN*CHAR_WIDTH)-10 );
						oldboxx = boxx;	oldboxy = boxy;
				}
			}
			break;
		//----------------------------------------------------------------
	}
}
//-------------------------------------------------------------------------
// A MOUSEBUTTON event arrived.
//
// If in function window then add selected function to list of traced ones if
// not already being traced.
//
// If in monitored functions window, see comment further down.
//-------------------------------------------------------------------------
void handle_click (void) {

	if (msgcode & 0x80) return;			// don't bother with release clicks

	switch (app_state) {

		//----------------------------------------------------------------
		case FUNCWINDOW:

			if (oldboxx != -1) {		// don't select invalid funcs

			struct SysCall *syscall;	// define some very local variables
			int funcnum;

				funcnum = oldboxy + maxrows * oldboxx;
				syscall = ((struct SysCall *)curlib->funcslist.lh_Head) + funcnum;

				// add function to list of tracked ones
				add_function(syscall);

				// Once at least one function is being traced,
				// the option menu items become available
				OnMenu(window, FULLMENUNUM(OPTIONS_MENU,NOITEM,NOSUB));
			}
			break;

		//----------------------------------------------------------------
		// A click in the monitoring window can mean two things:
		//	a) user wants to define the input registers for a match
		//	b) if the selected function has trapped and frozen its Task
		//		un-freeze task by sending it a Signal()
		//----------------------------------------------------------------

		case MONWINDOW:

			if (oldmonboxy != -1) {		// don't accept invalid funcs

			struct Context *cx;

				cx = patched_calls[oldmonboxy]->ctxt;
				if (SNOOP_TASK && cx->frozen) {

					Signal(SNOOP_TASK, 1<<24);	// de-freeze Task

				} else {

					selected_syscall = patched_calls[oldmonboxy];
					if (!regswindow) {

						// pop up window with all 680x0 registers. User changes
						// will come to us via standard gadget clicks, not here !

						ask_register_info("Define Arg Registers", selected_syscall->ctxt);

					} else {
						WindowToFront(regswindow);
						ActivateWindow(regswindow);
					}
				}
			}
			break;
		//----------------------------------------------------------------
		case TASKWINDOW:
		case REGSWINDOW: break;

		default:
			printf("CLICK BUG: appi in unknown state %d\n", app_state);
	}
}
//-------------------------------------------------------------------------
// **!! At this point HartBeat doesn't use individual key presses.
//-------------------------------------------------------------------------
void handle_keypress(char key) {
	//	printf("Key pressed: %c\n", key);
}
//-------------------------------------------------------------------------
// A GADGETUP event arrived. Meaning any of our Gadgets scattered around
// multiple Windows has been clicked.
//-------------------------------------------------------------------------

#define	TSKLST_LIST		0
#define	TSKLST_USE		1
#define	TSKLST_CANCEL	2

#define	REGLST_CYCLE	32
#define	REGLST_USE		33
#define	REGLST_CANCEL	34

void handle_gadgets(void) {
USHORT gid;

	gid = ((struct Gadget*)IAddr)->GadgetID;

	switch (app_state) {
		//-----------------------------------------------------------------
		case REGSWINDOW:
			switch (gid) {
				//---------------------------------------------------------
				case REGLST_USE: {
					struct Gadget *gad;
					struct Context *ctxt;
					char *str;
					int regs,val;

					// -> 1st string Gadget (Skip Gadtools "context" gadget)
					gad = regsReqGads->NextGadget; ctxt = selected_syscall->ctxt;
					
					for(regs=0; regs<32; regs++) {

						str = ((struct StringInfo*)gad->SpecialInfo)->Buffer;

						if (*str == '$') {
							if (!sscanf(str+1,"%lx", &val)) val = -1;
						} else {
							if (!sscanf(str,"%ld", &val)) val = -1;
						}

						if (regs&1)							// if gadID is odd,
							ctxt->regmasks[regs>>1] = val;	// it's a mask
						else								// else
							ctxt->regvals[regs>>1] = val;	// it's a register

						gad = gad->NextGadget;			// goto next string gadg

					 }	// end of for
					}	// end of compound statement

						// Fall thru to kill window
				//---------------------------------------------------------
				case REGLST_CANCEL:
					kill_regsReq_window();	// done with window: get rid of it

					//	app_state = FUNCWINDOW;	// revert to neutral state
					ActivateWindow(window);	// this is safer way to achieve same
					break;
				//---------------------------------------------------------
				case REGLST_CYCLE:
					selected_syscall->ctxt->freeze = (msgcode==1) ? -1 : 0 ;
					selected_syscall->ctxt->frozen = FALSE;
					break;
				//---------------------------------------------------------
			}
			break;
		//-----------------------------------------------------------------
		case TASKWINDOW:
			switch ( ((struct Gadget*)IAddr)->GadgetID) {
				//---------------------------------------------------------
				case TSKLST_LIST:
					task_num = msgcode;		// register which Task user selected
					break;
				//---------------------------------------------------------
				case TSKLST_USE:
					watch_task(task_num);	// using previously recorded selection
					SetWindowTitles(monwindow,"Monitored functions (TASK)", (char*) -1);
					reset_counters();		// switch to snoop new Task
						// Fall thru to kill window
				//---------------------------------------------------------
				case TSKLST_CANCEL:
					kill_taskReq_window();	// done with window: get rid of it

					//	app_state = FUNCWINDOW;	// revert to neutral state
					ActivateWindow(window);	// this is safer way to achieve same
					break;
			}
			break;
		//-----------------------------------------------------------------
		case FUNCWINDOW:
		case MONWINDOW:
		default: printf("GADGET BUG: appi in unknown state %d\n", app_state);
	}
}
//-------------------------------------------------------------------------
// List all functions of a selected library in neat columns in the main window.
// Display all functions which don't point to ROM in INVERSE VIDEO.
//-------------------------------------------------------------------------

void display_functions(void) {

int i,len;
struct SysCall *func;
ULONG vector;

	SetDrMd(rp,JAM1);						// normal drawing mode
	SetAPen(rp,0);							// use background pen to wipe
	RectFill(rp, PANE_X, PANE_Y, winwidth-5, winheight-3); // previous functions off

	SetAPen(rp,1);							// use text pen
	maxrows = (winheight-18)/CHAR_HEIGHT;

		// point to first function node
	func = (struct SysCall*) curlib->funcslist.lh_Head;

	i = 0;									// start index from 0
	while (func->func_node.ln_Succ) {
			// limit label length to fit in column
		len = (func->namelen > MAX_LABLEN ? MAX_LABLEN : func->namelen);

		Move(rp, PANE_X +    (i/maxrows)*MAX_LABLEN*CHAR_WIDTH,
				 PANE_Y + 6 +(i%maxrows)*CHAR_HEIGHT);

			// find out where function points to currently.
			// if not the ROM then highlight function name.
		vector = *((ULONG*)(((char*)func->parent_lib) + func->func_LVO +2));
		if (vector < 0xF80000 || vector >0xFFFFFC) {
			SetDrMd(rp,INVERSVID);					// highlight function
			Text(rp, func->funcname, len);
			SetDrMd(rp,JAM1);						// revert to normal mode
		} else {
			Text(rp, func->funcname, len);
		}

		func = (struct SysCall*) func->func_node.ln_Succ;
		i++;
	}

	app_state = FUNCWINDOW;					// functions are now selectable...
	oldboxx = -1;							// invalidate last box
}
//-------------------------------------------------------------------------
// User selected the "About..." option in the Project menu.
// Give him some info.
//-------------------------------------------------------------------------
void popup_About_req(void) {

static struct EasyStruct aboutES = {
	sizeof (struct EasyStruct),
	0,
	"HeartBeat Program Information Broadcast", "\
HeartBeat allows you to snoop on any Amiga system calls.\n\
To select functions to be tracked, first select any Library,\n\
Device or Resource from the Libraries menus and then click\n\
on any function(s) you wish to snoop on.\n\
WARNING: Take it easy with Exec... or be punished !\n\
e.g. SuperVisor(), SumLibrary(), CacheClearU(), ...\n\
\n\
HeartBeat was written by Laurence Vanhelsuwé.\n\
You can contact the author at the following address:\n\
\n\
Christinastraat 105\n\
B-8400 Oostende\n\
Belgium\n\
Europe",

	"Thanks|Great|WILLCO|Yeah|OK",
};

	EasyRequest(window, &aboutES, NULL);
}
//-------------------------------------------------------------------------
// User wants to load a previously saved monitoring session.
//-------------------------------------------------------------------------
#define	BUFLEN	60					// size of line buffer

int load_funclist (void) {

struct SysCall *scall;
char libnamebuf[BUFLEN],funcnamebuf[BUFLEN];
char *fname, *ptr;
FILE *fhandle;
BOOL added;

	// Ask user where to load session information from.

	fname = get_filename("Session filename to LOAD");
	if (!fname) return ERR_NOMEM;

	fhandle = fopen(fname,"r"); if (!fhandle) return ERR_DOSERR;

	// Check that file is a HeartBeat file.
	fgets(libnamebuf, BUFLEN, fhandle);

	if (strcmp(libnamebuf, HB_SIGNATURE)) {
		fclose(fhandle);
		return ERR_BADFILE;
	}

	// Read in session file until EOF is encountered or until func list is full
	do {
		ptr = fgets(libnamebuf ,BUFLEN, fhandle);
		ptr = fgets(funcnamebuf,BUFLEN, fhandle);

		if (ptr) {
			scall = find_func(libnamebuf, funcnamebuf);
			if (scall) {
				added = add_function(scall);
			} else {
//				printf("%s, %s NOT VISISBLE !\n", libnamebuf, funcnamebuf);
			}
		}
	} while (ptr && added);

	fclose(fhandle);

	// Once at least one function is being traced,
	// the option menu items can become available
	OnMenu(window, FULLMENUNUM(OPTIONS_MENU,NOITEM,NOSUB));

	return ERR_OK;
}

//-------------------------------------------------------------------------
// Check whether a function traced in a previous session is again visible.
// If so, return its SysCall struct ptr.
//-------------------------------------------------------------------------
struct SysCall *find_func( char *libname, char *funcname) {

struct SysCall *syscall;

	strip_lf(libname); strip_lf(funcname);

	for (libnum=0; libnum<numlibs; libnum++) {				// chk all lib slots
		if (libs[libnum].openhandle) {						// if loaded..
			if (!strcmp(libs[libnum].libname, libname)) {	// and same as arg
				syscall = (struct SysCall*) libs[libnum].funcslist.lh_Head;
				while (syscall->func_node.ln_Succ) {		// traverse func list

					if (!strcmp (syscall->funcname, funcname))	// if func exists
						return syscall;						// tell caller

					syscall = (struct SysCall*) syscall->func_node.ln_Succ;

				}	// while functions on library function list
			}		// only if same library as argument
		}			// only for loaded libraries
	}				// while libraries

	return NULL;
}
//-------------------------------------------------------------------------
// User wants to save his current monitoring sessions for later.
//-------------------------------------------------------------------------
int save_funclist (void) {

struct SysCall **syscall = patched_calls;	// point to array of SysCall ptrs

char *fname;
int i;
FILE *fhandle;

	// Ask user where to save session information to.

	fname = get_filename("Session filename to SAVE");
	if (!fname) return ERR_NOMEM;

	// Open file and print file header
	fhandle = fopen(fname,"w");
	fprintf(fhandle, HB_SIGNATURE);

	// Dump session information to file
	for(i=1; i <= monitored; i++) {
		fprintf(fhandle, "%s\n", (*syscall)->parent_lib->lib_Node.ln_Name);
		fprintf(fhandle, "%s\n", (*syscall)->funcname);
		syscall++;							// goto next SysCall structure
	}

	fclose(fhandle);

	return ERR_OK;
}

//-------------------------------------------------------------------------
// Generic Filename request.
//-------------------------------------------------------------------------
char * get_filename(char * windowmsg) {

struct FileRequester *fr;
char *ptr;
BOOL result;

	fr = AllocAslRequestTags(ASL_FileRequest, NULL);
	if (!fr) return NULL;

// Ask user what filename he wants to use

	result = AslRequestTags(fr,
//			ASLFR_TitleText,windowmsg,	// need a newer INCLUDE file : AARRGH

			ASL_Hail,windowmsg,			// using obsolete version TAG instead **!!

			NULL);

	if (!result) return NULL;

	if (fr->rf_Dir) {		// if there's a directory component..

		ptr = stpcpy(filename_buf, fr->rf_Dir);		// 1st copy path

		if (*(ptr-1) != ':')
			*ptr++ = '/';							// separate path from file

		stpcpy(ptr, fr->rf_File);					// then append filename

	} else {
		strcpy(filename_buf, fr->rf_File);
	}

	FreeAslRequest(fr);

	return filename_buf;
}
//-------------------------------------------------------------------------
// This is a generic routine to bring up small message requesters.
//-------------------------------------------------------------------------
void quick_msg (char *message, char *exit) {

struct EasyStruct quickES;

	quickES.es_StructSize	= sizeof (struct EasyStruct);
	quickES.es_Flags		= 0;
	quickES.es_Title		= "HeartBeat says...";
	quickES.es_TextFormat	= message;
	quickES.es_GadgetFormat	= exit;

	EasyRequest(window, &quickES, NULL);
}
//-------------------------------------------------------------------------
// Most Amiga systems should have a directory full of ".fd" files containing
// Amiga system function definitions.
// Go and find this directory and extract as much possible information from
// these files.
//
// An example of real .FD file follows
/*

* "battclock.resource"
##base _BattClockBase
##bias 6
##public
ResetBattClock()()
ReadBattClock()()
WriteBattClock(time)(d0)
##private
battclockPrivate1()()
battclockPrivate2()()
##end

*/
//-------------------------------------------------------------------------
void find_function_info(void) {

struct FileCache *fc;
char *fname;
int i;

	// Find out how many .fd files in FD: directory
	num_fdfiles = calc_num_fd_files();
	if (VERBOSE) printf("FD: directory contains %d libraries.\n", num_fdfiles);

	if (num_fdfiles > MAX_LIBS) {
		printf("Your FD: Directory contains too many entries for HeartBeat (%d > %d)\n",
			num_fdfiles, MAX_LIBS);
		cleanup();
	}

	// Move to FD: directory so we can use short relative filanemes.
	chdir("FD:");

	fc = fd_caches;						// starting from 1st .fd file
	fname = FdDirCache.filebuf;
	total_funcs = libnum = 0;			// starting from library array slot #0

	for (i=0; i< num_fdfiles; i++) {
		if (!load_file(fname, fc)) {
			if (VERBOSE) printf("Couldn't cache %s !\n", fname);
			cleanup();
		}
		fc->filename = fname;			// store name of cached file

		// parse .FD file and extract all function call information
		if (!process_fd_file(fc)) {
			if (VERBOSE) printf("File %s couldn't be parsed.\n", fc->filename);
		} else {
			libnum++;					// done one more library...
		}

		fc++;							// point to next file cache
		fname += 1+ strlen(fname);		// point to next .fd filename
	}

	if (VERBOSE)
		printf("Counted %d functions in %d libraries\n", total_funcs, libnum);

	// from now on, the remainder of the node pool is used to allocate
	// function contexts. (node_pool is used to reset the ctxt_pool ptr).
	ctxt_pool = (void*) node_pool;


	// set the library array index ceiling
	numlibs = libnum;
}
//-------------------------------------------------------------------------
// Find howmany .fd files there are in the FD: directory.
//-------------------------------------------------------------------------
int calc_num_fd_files( void ) {

int match;
char *matchptr;		// ptr to be filled in by stcpm()
register int lines;
register char * ptr;
BOOL ret;
										// Let "LIST" do all the hard work.
	ret = Execute("C:LIST >T:FDLIST FD:#?.fd nohead quick",0,0);
	if (!ret) {
		printf("Could not 'LIST' your FD: directory.\n");
		cleanup();
	}
										// Let "SORT" do some more hard work.
	ret = Execute("C:SORT T:FDLIST TO T:FDL2",0,0);
	if (!ret) {
		printf("Could not 'SORT' filenames.\n");
		cleanup();
	}

	if (! load_file("T:FDL2", &FdDirCache)) {
		printf("Failed to load LIST output 'T:FDL2'\n");
		cleanup();
	}

	ptr = FdDirCache.filebuf;			// go analyze LIST's output.
	lines = 0;
	while (*ptr) {						// while not EOF
		if (*ptr++ == LF) {				// count lines
			lines++;
		}
	}

	// Turn filename list into list of C-strings
	text_to_heap (&FdDirCache);

	// Now check first line and make sure it contains the substring ".fd"
	// If not, then list probably printed an error message, so we quit.
	// do an unanchored pattern match (Lattice function)

	ptr = FdDirCache.filebuf;
	match = stcpm(ptr, ".fd",&matchptr);

	if (!match) {
		printf("LIST of FD: directory failed.\n");
		cleanup();
	}

	// if LIST went OK then # of lines == # of .fd files
	return lines;
}
//-------------------------------------------------------------------------
// User just clicked the currently highlighted system function name.
// Add this system call to the list of traced ones and stretch Monitoring
// window to hold extra function line.
//
// return FALSE if we can't accept any more functions.
//-------------------------------------------------------------------------

BOOL add_function (struct SysCall *syscall) {

char addr_str[]="$0000FFFF   ";		// output buf for bin2hex conversion
short oldheight;
struct NewWindow *NW;
struct Context *cx;
register USHORT *wedge,*code;
APTR newpatch;
int dy,len;
register int i;

	if (syscall->ctxt) return TRUE;			// don't bother patching same func twice!!

	if (monitored == MAX_PATCHED) return FALSE;	// or exceeding max number

		// If function call is the very first one and Window therefore does
		// not exist yet, create it first.

	if (!monitored) {

		NW = &nw;
		NW->Title	= "Monitored Functions";
		NW->TopEdge = 30; NW->LeftEdge = 640-380;
		NW->Width	= PANE_X+48*CHAR_WIDTH; NW->Height = 27;
		NW->Flags	= WFLG_CLOSEGADGET|
					  WFLG_DEPTHGADGET|
					  WFLG_REPORTMOUSE|
					  WFLG_DRAGBAR;

		monwindow = OpenWindow(NW); if (!monwindow) return FALSE;

		monwindow->UserPort = IDCMPport;		// share global event MsgPort
		ModifyIDCMP(monwindow, IDCMP_SELECTION); // allow events from new window

		monrp = monwindow->RPort;

		Move (monrp, PANE_X, PANE_Y+6);
		SetDrMd(monrp, JAM1); SetAPen(monrp, 1);
		//Text (monrp, "   Called    Matched  Function", 30);
		//			 "$0000FFFF  $0000FFFF  SuperVisor"

		Text (monrp,   " Called Matched   Address  Function", 35);
		//			   "$00FFFF $00FFFF $07FFFFFF  SuperVisor"

		Move (monrp, PANE_X, PANE_Y+8);
		Draw (monrp, PANE_X+35*CHAR_WIDTH , PANE_Y+8);
	}

	oldheight = monwindow->Height;
	SizeWindow(monwindow, 0, CHAR_HEIGHT);
	Delay(7);	// Wait for Intuition to actually do the async sizing

		// Check that window actually stretched correctly.
		// If it didn't (coz window's touching bottom of Workbench) then
		// move window up and try again (If it fails again: quit)

	dy = monwindow->Height - oldheight;
	if (dy != CHAR_HEIGHT) {
		oldheight = monwindow->Height;
		MoveWindow(monwindow, 0, -(CHAR_HEIGHT-dy));
		SizeWindow(monwindow, 0, CHAR_HEIGHT-dy);
		Delay(7);
		if (oldheight != (monwindow->Height -(CHAR_HEIGHT-dy))) return FALSE;
	}

// OK. At this point we can definitely patch this function.
// Print function information in window. (previous Function address printing
// is done lower down after SetFunction() )

	SetDrMd(monrp, JAM1); SetAPen(monrp, 1);
	Move(monrp, PANE_X + (27*CHAR_WIDTH), PANE_Y +10 + (monitored+1) * CHAR_HEIGHT);
	Text(monrp, syscall->funcname, syscall->namelen);

	
	patched_calls[monitored++] = syscall; // track call in array of patched ones

	cx = ctxt_pool++;						// allocate a Context

	if ( ((char*)ctxt_pool) > ((char*)pool_base)+POOL_SIZE-200)
		printf("About to blow pool ! **BUG**\n");

	init_context(cx);						// fill in regs, zero counters
	syscall->ctxt = cx;						// give SysCall struct a Context

	wedge = (USHORT*) ctxt_pool;			// spot for wedge code
	newpatch = (APTR) wedge;				// remember start address

	code = (USHORT*) WEDGE;					// R/O image of wedge code
	i = *(code-1);							// is this many WORDs long
	while (i--) {
		*wedge++ = *code++;					// Copy wedge routine
	}
	ctxt_pool = (struct Context*) wedge;	// update free memory ptr

	// Now patch library and fill in normal func address and counter address
	// in patch.
	
	Disable();

	cx->stdvector = SetFunction(syscall->parent_lib, syscall->func_LVO, newpatch);

#define	patch_wedge(wedge,offs,patch)	\
	*((ULONG*)((wedge)+ *(((UWORD*)WEDGE)-offs))) = (ULONG)patch;

	patch_wedge((UWORD*)newpatch, 2, cx->stdvector);	// JMP CHAIN
	patch_wedge((UWORD*)newpatch, 3, &cx->trapped_cnt);	// MATCH CNT
	patch_wedge((UWORD*)newpatch, 4, &cx->called_cnt);	// NORM CNT
	patch_wedge((UWORD*)newpatch, 5, cx);				// CTXT PTR

	Enable();

	// generate hex string of function code start address
	len = stcl_h(addr_str+1, (long) cx->stdvector);

	Move(monrp, PANE_X + ((24-len)*CHAR_WIDTH), PANE_Y +10 + monitored*CHAR_HEIGHT);
	Text(monrp, addr_str, len+1);

	return TRUE;		// function successfully added to list
}
//-------------------------------------------------------------------------
// Initialize a Context structure.
// Fill registers with a no-match template and clear counters.
//-------------------------------------------------------------------------
void init_context( struct Context *cx) {

register int i;

	// D0 and A7 get special values to get fastest possible "no match"

	cx->regvals[0] = 0xA1B2C3D4;	cx->regvals[15] = 0x00000000;
	cx->regmasks[0]= 0xFFFFFFFF;	cx->regmasks[15]= 0xFFFFFFFF;

	for (i=1; i<15; i++) {					// skipping D0 and A7 itself
		cx->regvals[i] = 0;					// clear interface regs
		cx->regmasks[i] = 0;
	}

	cx->freeze = cx->frozen = FALSE;		// don't freeze on match
	cx->called_cnt = cx->trapped_cnt = 0;	// clear counters
	cx->last_called_cnt = cx->last_trapped_cnt = -1;	// force first update
}
//-------------------------------------------------------------------------
// For all patched system functions, see if their call frequency counters
// have changed since last time and if so re-print them.
//-------------------------------------------------------------------------

void refresh_counters(void) {

char counter_str[]="$0000FFFF   ";		// output buf for bin2hex conversion
register struct Context *cx;
struct SysCall **syscall;
UBYTE oldmask;
int i;
register int len;

	if (!monwindow) return;				// update monitor window if it exists

	oldmask = monrp->Mask; monrp->Mask = 1;			// write counters in plane 1 only

	SetDrMd(monrp, JAM2); SetAPen(monrp, 1);		// overwrite mode

	syscall = patched_calls;			// point to array of SysCall ptrs
	for(i=1; i <= monitored; i++) {		// for all monitored funcs DO...
		cx = (*syscall)->ctxt;

		if (cx->called_cnt != cx->last_called_cnt) {		// if counter changed
			cx->last_called_cnt = cx->called_cnt;			// old = new
			len = stcl_h(counter_str+1, cx->called_cnt);	// gen hex
			len = len > 6 ? 6 : len;

			Move(monrp, PANE_X + (6-len)*CHAR_WIDTH, PANE_Y+10 + i*CHAR_HEIGHT);
			Text(monrp, counter_str, len+1);				// print counter
		}

		if (cx->trapped_cnt != cx->last_trapped_cnt) {
			cx->last_trapped_cnt = cx->trapped_cnt;
			len = stcl_h(counter_str+1, cx->trapped_cnt);
			len = len > 6 ? 6 : len;

			Move(monrp, PANE_X + ((8+6)-len)*CHAR_WIDTH, PANE_Y+10 + i*CHAR_HEIGHT);
			Text(monrp, counter_str, len+1);				// print counter
		}

		Move(monrp, PANE_X + (26*CHAR_WIDTH), PANE_Y+10 +i*CHAR_HEIGHT);
		if (cx->freeze) {
			if (cx->frozen) {
				Text(monrp, "*", 1);
			} else {
				Text(monrp, "!", 1);
			}
		} else {
			Text(monrp, " ", 1);
		}

		syscall++;						// goto next SysCall structure
	}
	monrp->Mask = oldmask;				// restore normal bitplane writing mask
}
//-------------------------------------------------------------------------
// User has switched call tracking mode (global <-> Task only)
// so reset all call counters to start off with clean statistics
//-------------------------------------------------------------------------

void reset_counters(void) {

struct library *lib;
register struct SysCall *syscall;
UBYTE oldmask;

	if (monitored) {							// clear old counter strings
		
		if (!monwindow) printf("BUG in reset_counters!\n");

		oldmask = monrp->Mask; monrp->Mask = 1;	// Affect 1st bitplane only
		SetAPen(monrp, 0);
		RectFill(monrp, PANE_X, PANE_Y+12,
						PANE_X+ 15*CHAR_WIDTH -1, PANE_Y+12+ monitored * CHAR_HEIGHT);
		monrp->Mask = oldmask;					// restore normal bitplane mask
	}

	for (libnum=0; libnum<numlibs; libnum++) {
		if (libs[libnum].openhandle) {			// only if library valid
			lib = &libs[libnum];
			syscall = (struct SysCall*) lib->funcslist.lh_Head;
			while (syscall->func_node.ln_Succ) {
				if (syscall->ctxt) {	// only patched functions have counters...
					init_context(syscall->ctxt);
				}
				syscall = (struct SysCall*) syscall->func_node.ln_Succ;

			}	// while functions in library
		}		// if valid library
	}			// for all slots in libs array
}
//-------------------------------------------------------------------------
// Highlight a rectangle at BOX coordinates x,y that's width wide.
//-------------------------------------------------------------------------
void fill_box( int x, int y, int yoffs, int width, struct RastPort *rp, int pen) {

int ulx,uly;
UBYTE oldmask;

	ulx = PANE_X + x * MAX_LABLEN*CHAR_WIDTH;
	uly = PANE_Y + yoffs+ y * CHAR_HEIGHT;

	SetDrMd(rp, JAM1); SetAPen(rp, pen);
	oldmask = rp->Mask; rp->Mask = 2;		// Affect 2nd bitplane only

	RectFill(rp, ulx, uly, ulx+width, uly+CHAR_HEIGHT-1);

	rp->Mask = oldmask;						// restore normal bitplane mask
} 
//-------------------------------------------------------------------------
// Analyze a cached .fd file and extract system call information.
// Open the Library/Device/Resource of this file to get a firm grip on object.
//-------------------------------------------------------------------------

BOOL process_fd_file	(struct FileCache *fc) {

struct SysCall *funky;				// a ptr to a new System Call "node"
struct Node *object=NULL;
char *endquote,*endfunc;
char *objtype,*newptr;
register char *ptr;					// .fd file text scanning ptr
BOOL skip_private = FALSE;			// skip functions which are system private
int scan_state = NEED_NAME;			// starting scanning state
int bias = -6;						// default starting LVO

	libs[libnum].numfuncs = 0;		// init # of functions for this library
	NewList (&libs[libnum].funcslist);

	ptr = fc->filebuf;				// starting from beginning of cached .fd file

	while (*ptr) {					// while not EOF
		switch (scan_state) {

			//-----------------------------------------------------------------
			case NEED_NAME:
				if (*ptr++ != '*') return FALSE;
				if (*ptr++ != ' ') return FALSE;
				if (*ptr++ != '"') return FALSE;
				endquote = strchr(ptr, '"');	// find end of quoted str
				if (!endquote) return FALSE;

				*endquote++ = '\0';				// turn quoted string into C-string
				libs[libnum].libname = ptr;
				strlwr(ptr);					// convert name to lower case
				objtype = strchr(ptr,'.');		// find what type of "library"

				if (FORCEOPEN) {
					printf("Forced open option not implemented yet.\n");
//					switch (*(objtype+1)) {
//						case 'l':	object = OpenLibrary(ptr); break;
//	**!!				case 'd':	object = OpenDevice(ptr); break;
//						case 'r':	object = OpenResource(ptr); break;
//					}
//				} else {

				} {
					Forbid();
						switch (*(objtype+1)) {
							case 'l': // LIBRARY
								object = FindName(&SysBase->LibList, ptr); break;
							case 'd': // DEVICE
								object = FindName(&SysBase->DeviceList, ptr); break;
							case 'r': // RESOURCE
								object = FindName(&SysBase->ResourceList, ptr); break;
						}

			// Make referenced object unswappable by bumping its Use counter !


						if (object)	((struct Library*)object)->lib_OpenCnt++;
					Permit();
				}

				if (!object) {
					if (VERBOSE) printf("Object '%s' not available in memory.\n", ptr);
					return FALSE;
				}
				else libs[libnum].openhandle = (struct Library *) object;

				ptr = endquote;					// goto next line;
				scan_state = NEUTRAL;
				break;

			//-----------------------------------------------------------------
			case NEUTRAL:

				if (*(ptr-1) != LF) {			// goto new line if not on bound
					ptr = 1+ strchr(ptr, LF);
				};

				switch (*ptr) {					// determine which line type
					case '#':					// this is and switch state
						scan_state = GET_COMMAND;	// accordingly
						break;

					case '*':
						ptr++;
						scan_state = NEUTRAL; break;

					default:
						scan_state = GET_FUNC; break;
				}
				break;

			//-----------------------------------------------------------------
			case GET_FUNC:


				if (skip_private) {			// don't collect system private
					ptr++;					// calls
					bias += 6;				// keep track of LVO though...
					scan_state = NEUTRAL;
					break;
				}

				endfunc = strchr(ptr, '(');	// find '('
				*endfunc = '\0';			// turn func name into C-string

				funky = node_pool++;		// allocate a new function node

				funky->funcname	= ptr;		// fill in name related info
				funky->namelen	= endfunc - ptr;
				funky->func_LVO	= -bias;	// fill in its _LVO value
				funky->ctxt		= NULL;		// not patched yet...
				funky->parent_lib= libs[libnum].openhandle;	// link func to lib

				AddTail(&libs[libnum].funcslist, (struct Node *)funky);

				libs[libnum].numfuncs++;	// track how many functions on list
				total_funcs++;				// and stored in total

				if (VERBOSE) printf("FUNCTION: %s,\tLVO=-%d\n", ptr, bias);

				ptr = 1 + endfunc;			// point past \0 !
				bias += 6;					// keep track of LVO

				scan_state = NEUTRAL;
				break;

			//-----------------------------------------------------------------
			case GET_COMMAND:
				ptr++;
				if (*ptr++ != '#') return FALSE;

				switch (*ptr++) {
					case 'b':
						if (*ptr == 'i') {			// ##bias
							ptr += 3;
							bias = strtol(ptr, &newptr, 10);	// get new bias
						} else if (*ptr == 'a')	{	// ##base
							// name of library base command is skipped
						}
						break;

					case 'e':						// ##end
						ptr = "";	break;			// end the scanning

					case 'p':
						if (*ptr == 'u') {			// ##public
							ptr += 5;
							skip_private = FALSE;
						} else if (*ptr == 'r')	{	// ##private
							ptr += 6;
							skip_private = TRUE;
						}
						break;
				}
				scan_state = NEUTRAL;
				break;

			//-----------------------------------------------------------------
		}	// switch (scan_state)
	}		// while (*ptr)

	return TRUE;			// Parsed entire .fd file without problems
}
//-------------------------------------------------------------------------
// Open main HeartBeat window (but finish off its menustrip first).
//-------------------------------------------------------------------------

BOOL popup_funcwindow (void) {

	nw.LeftEdge = (screen->Width - nw.Width) /2;	// center window on screen

	if (!(window = OpenWindow(&nw)))		// Open function selection window
		return FALSE;						// WITHOUT IDCMP flags

	window->UserPort = IDCMPport;			// use global Intuition event MsgPort

	rp = window->RPort;						// grab this window's RastPort ptr

	append_lib_menus();						// Construct NewMenu array

	menustrip = CreateMenus(mymenus, TAG_DONE);	// Create MenuStrip
	if (!menustrip) return FALSE;			// if failed to alloc mem for it...

	LayoutMenus(menustrip, vi, TAG_DONE);	// Position Menus & Items

	SetMenuStrip(window, menustrip);		// Attach menu to window
	OffMenu(window, FULLMENUNUM(OPTIONS_MENU,NOITEM,NOSUB));	// disable menu
	menus_exist = TRUE;

	ModifyIDCMP(window, IDCMP_SELECTION);	// tell Intuition to start sending

	return TRUE;
}
//-------------------------------------------------------------------------
// Part of the MenuStrip is dynamically generated at init time from the
// list of .fd files we found in the FD: directory.
// Here we finish off the rest of the array of NewMenu structs.
//
// Since we can have a very long list of libraries we have two menus which
// cope with the two alphabetical groups starting A-I and J-Z.
//-------------------------------------------------------------------------

void append_lib_menus(void){

int i;
struct NewMenu *newmenu;

	lowlibs = 0;					// count how many are in first menu
	newmenu = mymenus + NEWMENU_APPEND;	// point at the first empty slot

	for (i=0; i<numlibs; i++) {		// if lib name starts with A..I
		if (toupper(libs[i].libname[0]) <= 'I') {	// and .fd file was
			if (libs[i].numfuncs) {					// parsed succesfully
				newmenu->nm_Type	= NM_ITEM;
				newmenu->nm_Label	= libs[i].libname;
				newmenu->nm_CommKey	= NULL;
				newmenu->nm_Flags	= 0;
				newmenu->nm_MutualExclude = 0L;
				newmenu++;
				lowlibs++;
			}
		}
	}

// Now construct the Menu for Libraries J-Z.

	newmenu->nm_Type	= NM_TITLE;	// Insert a MENU TITLE for 2nd Libraries
	newmenu->nm_Label	= "Libraries J-Z";
	newmenu->nm_CommKey	= NULL;
	newmenu->nm_Flags	= 0;
	newmenu->nm_MutualExclude = 0L;

	newmenu++;						// and group all other libraries under 2nd

	for (i=0; i<numlibs; i++) {
		if (toupper(libs[i].libname[0]) >= 'J') {
			if (libs[i].numfuncs) {
				newmenu->nm_Type	= NM_ITEM;
				newmenu->nm_Label	= libs[i].libname;
				newmenu->nm_CommKey	= NULL;
				newmenu->nm_Flags	= 0;
				newmenu->nm_MutualExclude = 0L;
				newmenu++;
			}
		}
	}

// Add final end marker.

	newmenu->nm_Type	= NM_END;	// Terminate NewMenu array with the required
	newmenu->nm_Label	= NULL;		// end marker
	newmenu->nm_CommKey	= NULL;
	newmenu->nm_Flags	= 0;
	newmenu->nm_MutualExclude = 0L;
}

//-------------------------------------------------------------------------
struct taskinfo {			// struct is private to ask_task(), get_task_sel()
	struct Node ti_node;
	struct Task *ti_Task;	// ptr to Task for when we get selection
	char   taskname[8+2+MAX_TASKLAB];	// 8 chars for hex Task ptr and N for name itself
};

//-------------------------------------------------------------------------
// User wants to change which Task he's snooping on.
//
// Traverse system Task lists and construct a local (static) list of Tasks
// with their names and hex TCB addresses for a LISTVIEW gadget to display.
// Open a window with this LISTVIEW and two more "USE", "CANCEL" gadgets.
// Don't wait for an answer here. Return immediately. Main loop will handle
// selection and the closing of this window.
//-------------------------------------------------------------------------

BOOL ask_task (char *wintitle) {

static struct TagItem ListViewTags[] =	{
	GTLV_Labels, NULL,				// filled in with &taskList
	GTLV_Top, 0,
	LAYOUTA_SPACING, 1,
	GTLV_ShowSelected, NULL,		// add read-only label showing selected item
	GTLV_Selected, 0,
	GTLV_ScrollWidth, 16,			// width of scroll bar
	TAG_DONE
};

struct NewGadget ng = {				// Not static coz we want stuff re-initialized
		PANE_X+3,PANE_Y+2,
		32*CHAR_WIDTH, 14*CHAR_HEIGHT,
		"List of Tasks", NULL, NULL,
		PLACETEXT_BELOW,
		NULL, NULL
};

struct Gadget		*lastgad;
struct NewWindow	*nW;

	NewList(&taskList);					// initialize list header

	Forbid();							// freeze view of system lists

	// accumulate Tasks that are WAITing
	collect_taskinfo(SysBase->TaskWait.lh_Head);

	// Also give user access to Tasks which are currently ready to run.
	// This is very useful since Tasks which crash usually use up their
	// entire time quantum and therefore are constantly READY.

	collect_taskinfo(SysBase->TaskReady.lh_Head);

	Permit();

	// Now that we've constructed a list of names suitable for a LISTVIEW,
	// construct gadget and window.

	ng.ng_VisualInfo = vi;
	ng.ng_TextAttr	 = TAttr;
	ng.ng_GadgetID	 = 0;

	taskReqGads = NULL; lastgad = CreateContext( &taskReqGads );

	ListViewTags[0].ti_Data = (ULONG) &taskList;	// pass tasknames to Gadget
	ng.ng_GadgetID	= 0;
	lastgad = CreateGadgetA(LISTVIEW_KIND, lastgad, &ng, (struct TagItem *) ListViewTags);

	// Add "Use" and "Cancel" Gadgets

	ng.ng_GadgetID++; ng.ng_GadgetText = "Use";
	ng.ng_Flags		= PLACETEXT_IN;
	ng.ng_Width		= 7*CHAR_WIDTH;
	ng.ng_LeftEdge  = 60;
	ng.ng_TopEdge  += ng.ng_Height + 8;
	ng.ng_Height	= CHAR_HEIGHT+3;
	lastgad = CreateGadget(BUTTON_KIND, lastgad, &ng, TAG_DONE);

	ng.ng_GadgetID++; ng.ng_GadgetText = "Cancel";
	ng.ng_LeftEdge	= 150;
			  CreateGadget(BUTTON_KIND, lastgad, &ng, TAG_DONE);

	nW = &nw;
	nW->Title		= wintitle;
	nW->TopEdge		= 40;
	nW->LeftEdge	= 100;
	nW->Width		= 274;
	nW->Height		= 150;
	nW->Flags		= WINDOWCLOSE| ACTIVATE| WINDOWDEPTH| WINDOWDRAG;
	nW->IDCMPFlags	= 0;

	taskwindow = OpenWindow(nW);				// open task requester window

	AddGList(taskwindow, taskReqGads, -1, -1, NULL); // append at end, all gadgets
	RefreshGList(taskReqGads, taskwindow, NULL, -1); // display new ones
	GT_RefreshWindow(taskwindow, NULL);

	taskwindow->UserPort = IDCMPport;			// use global event port
	ModifyIDCMP(taskwindow, IDCMP_SELECTION);	// enable transmissions

	app_state = TASKWINDOW; task_num = 0;	// first item is selected by default

	return TRUE;
}
//-------------------------------------------------------------------------
// Traverse Task/Process list and collect name, TCB addr and CLI num info
//-------------------------------------------------------------------------
void collect_taskinfo (struct Node *task) {

struct taskinfo	*node;
int len,cli;

	while (task->ln_Succ) {
		node = (struct taskinfo*) AllocMem(sizeof (struct taskinfo),MEMF_PUBLIC);
		node->ti_Task = (struct Task*) task;
		node->ti_node.ln_Name = node->taskname;

			// make sure both fields aren't separated by a \0
		strcpy(node->taskname, "          ");			// pad with spaces
		len = stcl_h(node->taskname, (int) task);		// print task address

		stccpy(node->taskname+10, task->ln_Name, MAX_TASKLAB);	// and taskname
		*(node->taskname + len) = ' ';					// glue both strings together

		if (task->ln_Type == NT_PROCESS) {	// If a PROCESS also print CLI num
			cli = ((struct Process*)task)->pr_TaskNum;
			if (cli) {						// only non-zero CLI nums valid
				*(node->taskname +8 ) = '0' +cli;
			}
		}

		AddTail(&taskList, (struct Node *) node);
		task = task->ln_Succ;
	}
}
//-------------------------------------------------------------------------
// User clicked on CLOSEWINDOW, USE or CANCEL gadget and we have to release
// our Task information list, gadget memory and window.
//-------------------------------------------------------------------------
void kill_taskReq_window(void) {

struct taskinfo *node,*nodex;

	node = (struct taskinfo*) taskList.lh_Head;
	while (nodex = (struct taskinfo*) node->ti_node.ln_Succ) {
		FreeMem((APTR) node, sizeof (struct taskinfo));
		node = nodex;
	}

	CloseWindowSafely(taskwindow); taskwindow = NULL;

	FreeGadgets(taskReqGads);					// free CreateGadget RAM
}
//-------------------------------------------------------------------------
// Find Task # N in our Task information list and point SNOOP_TASK to it.
//-------------------------------------------------------------------------
void watch_task(int index) {

struct taskinfo *node;

	node = (struct taskinfo*) taskList.lh_Head;

	while(index--) {
			// just follow list and find node number N
		node = (struct taskinfo*) node->ti_node.ln_Succ;
	}

	SNOOP_TASK = node->ti_Task;			// set address of Task to be snooped
}
//-------------------------------------------------------------------------
// Pop up the register match window sprinkled with loads of GadTools Gadgets.
// HeartBeat allows us to monitor functions which get specific arguments.
// This is done by specifying the contents of the data and address registers
// when the system function gets called.
// Masks are used to ignore whole registers or parts of registers.
// When a function is being traced in this "arguments" mode and the arguments
// match the template then HeartBeat will either simply increment a counter
// or FREEZE the calling Task.
//-------------------------------------------------------------------------

BOOL ask_register_info (char *wintitle, struct Context *ctxt) {

int regs;
char *hexstr="$xxxxyyyy";
static char *actions[] = {	"Count on match",
							"Freeze on match", NULL };

static char *regnames[] = { "D0","D1","D2","D3","D4","D5","D6","D7",
						    "A0","A1","A2","A3","A4","A5","A6","A7" };
struct NewGadget ng = {
	PANE_X, PANE_Y+12,
	12*CHAR_WIDTH, CHAR_HEIGHT+4,
	NULL, NULL, NULL,
	0,
	NULL, NULL };

struct Gadget *lastgad;
struct NewWindow *nW;

	ctxt->freeze = ctxt->frozen = FALSE;	// sync up with what Gadget shows!

	ng.ng_VisualInfo = vi;
	ng.ng_TextAttr	 = TAttr;
	ng.ng_GadgetID	 = 0;

	regsReqGads = NULL; lastgad = CreateContext( &regsReqGads );

	// Create 16 String Gadgets. Two per 680x0 register for value and mask.

	for (regs=0; regs < 16; regs++) {
		sprintf(hexstr, "$%lX", ctxt->regvals[regs]);
		ng.ng_Flags			= PLACETEXT_RIGHT;
		ng.ng_GadgetText	= regnames[regs];
		lastgad = CreateGadget(STRING_KIND, lastgad, &ng, GTST_String, hexstr, TAG_DONE);
		
		sprintf(hexstr, "$%lX", ctxt->regmasks[regs]);
		ng.ng_GadgetID++;
		ng.ng_GadgetText	= NULL;
		ng.ng_Flags			= 0;
		ng.ng_LeftEdge		+= 10*CHAR_WIDTH + 48;
		lastgad = CreateGadget(STRING_KIND, lastgad, &ng, GTST_String, hexstr, TAG_DONE);

		ng.ng_LeftEdge -= 10*CHAR_WIDTH + 48;
		ng.ng_TopEdge  += CHAR_HEIGHT+4 +1;
		ng.ng_GadgetID++;
	}

	// Add Trapping mode (Cycleing) Gadget

	ng.ng_Flags		= PLACETEXT_IN | NG_HIGHLABEL;
	ng.ng_Width		= 20*CHAR_WIDTH;
	ng.ng_LeftEdge  = PANE_X;
	ng.ng_TopEdge  += 10;
	lastgad = CreateGadget(CYCLE_KIND, lastgad, &ng, GTCY_Labels, actions, TAG_DONE);

	// Add "Use" and "Cancel" Gadgets

	ng.ng_Flags		= PLACETEXT_IN;
	ng.ng_GadgetID++; ng.ng_GadgetText = "Use";
	ng.ng_Width		= 7*CHAR_WIDTH;
	ng.ng_LeftEdge  = 44;
	ng.ng_TopEdge  += 20;
	lastgad = CreateGadget(BUTTON_KIND, lastgad, &ng, TAG_DONE);

	ng.ng_GadgetID++; ng.ng_GadgetText = "Cancel";
	ng.ng_LeftEdge	+= 90;
	lastgad = CreateGadget(BUTTON_KIND, lastgad, &ng, TAG_DONE);

	// Open Window for Gadgets to live in

	nW = &nw;
	nW->Title = wintitle;
	nW->TopEdge = 40; nW->LeftEdge = 100;
	nW->Width = 236; nW->Height = 280;
	nW->Flags = WINDOWCLOSE| ACTIVATE| WINDOWDEPTH| WINDOWDRAG;
	nW->IDCMPFlags = 0;

	regswindow = OpenWindow(nW);		//**!! error
	regsrp = regswindow->RPort;

	AddGList(regswindow, regsReqGads, -1, -1, NULL);
	RefreshGList(regsReqGads, regswindow, NULL, -1);
	GT_RefreshWindow(regswindow, NULL);

	Move(regsrp, PANE_X+28, PANE_Y+7);
	SetAPen(regsrp,1);
	Text(regsrp,"Values          Masks",20);

	regswindow->UserPort = IDCMPport;				// use global event port
	ModifyIDCMP(regswindow, IDCMP_SELECTION);		// enable transmissions

	app_state = REGSWINDOW;

	// Add this stage the window sits there with all its Gadgets waiting for
	// input; but this function returns now, so it's the main event loop that
	// picks up the user selections and then eventually kills the window
	// when "Use", "Cancel" or the CLOSEWINDOW Gadget gets selected.

	return TRUE;
}
//-------------------------------------------------------------------------
// User clicked on CLOSEWINDOW, USE or CANCEL gadget and we have to release
// our Window and gadget memory.
//-------------------------------------------------------------------------
void kill_regsReq_window(void) {

	CloseWindowSafely(regswindow); regswindow = NULL;

	FreeGadgets(regsReqGads);					// free CreateGadget RAM
}
//-------------------------------------------------------------------------
// Turn a cached text file into a collection of C-strings (a heap of strings)
//-------------------------------------------------------------------------
void text_to_heap( struct FileCache *fc) {
register int i;
register char * ptr;

	ptr = fc->filebuf;

	for (i=fc->bufsize; i; i--) {
		if (*ptr == LF)				// replace all LF chars by string terminators
			*ptr = '\0';
		ptr++;
	}
}

//-------------------------------------------------------------------------
// Turn a LF-terminated string into a proper C-string.
//-------------------------------------------------------------------------
void strip_lf (char *str) {

	while (*str++ != LF)		// go find terminating LF
		;

	*(str-1) = 0;				// and replace by a \0
}
//-------------------------------------------------------------------------
// Close Window safely (taking care of possible queued messages)
//-------------------------------------------------------------------------
void CloseWindowSafely( struct Window *win ) {
	
	if (win->UserPort) {
		Forbid();	// we forbid here to keep out of race conditions with Intuition

			// return any messages for this window that have not yet been processed
			StripIntuiMessages( win->UserPort, win );

			win->UserPort = NULL;		// clear UserPort so Intuition will not free it
			ModifyIDCMP( win, 0L );		// tell inuition to stop sending more messages

		Permit();						// turn tasking back on
	}

	CloseWindow( win );				// and really close the window
}
//-------------------------------------------------------------------------
// remove and reply to all IntuiMessages on a port that have been sent to a
// particular window (note that we don't rely on the ln_Succ pointer of a
// message after we have replied it)
//-------------------------------------------------------------------------
void StripIntuiMessages(struct MsgPort *mp, struct Window *win ) {

register struct IntuiMessage *msg;
register struct Node *succ;

	msg = (struct IntuiMessage *) mp->mp_MsgList.lh_Head;	// 1st message

	while( succ = msg->ExecMessage.mn_Node.ln_Succ ) {

		if( msg->IDCMPWindow ==  win ) {					// message addressed
															// to us ?
	     // Intuition is about to free this message.
	     // Make sure that we have politely sent it back.
 
			Remove((struct Node*)msg);
			ReplyMsg((struct Message*)msg);
		}
	    
		msg = (struct IntuiMessage *) succ;		// next IntuiMessage on list
	}
}
//-------------------------------------------------------------------------
// Open all libraries, initialize arrays, get private memory pool,
// open two IPC Message Ports (one for timeout messages, one for all Intuition
// messages), open timer.device, set global function tracking mode.
//-------------------------------------------------------------------------

BOOL init_program(void) {
int i;

	if (!(AslBase		= (struct AslBase *)	  OpenLibrary( "asl.library",0L)))
		return FALSE;
	if (!(GadToolsBase  = (struct GadToolsBase *) OpenLibrary( "gadtools.library",0L)))
		return FALSE;
	if (!(IntuitionBase = (struct IntuitionBase*) OpenLibrary("intuition.library",0L)))
		return FALSE;
	if (!(GfxBase		= (struct GfxBase *)	  OpenLibrary( "graphics.library",0L)))
		return FALSE;

	screen	= IntuitionBase->ActiveScreen;	// note host Screen
	TAttr	= screen->Font;					// note Screen default Font
	vi		= GetVisualInfo(screen, TAG_DONE);

	// Mark all file caches as empty
	FdDirCache.bufsize = 0;

	for (i=0; i< MAX_LIBS; i++) {
		fd_caches[i].bufsize = 0;			// all caches are empty
		libs[i].openhandle	 = NULL;		// all libs are unopened
	}

	// Mark all patched system call links as invalid
	monitored = 0;							// no calls monitored yet..
	for (i=0; i< MAX_PATCHED; i++) {		// no patched calls yet...
		patched_calls[i] = NULL;
	}

	// Get a large memory pool to hold System Call information
	pool_base = node_pool = (struct SysCall *) AllocMem(POOL_SIZE, MEMF_PUBLIC|MEMF_CLEAR);

	if (!pool_base) {
		printf("Unable to allocate memory pool.\n");
		return FALSE;
	}

	// Create our event message ports
	if (!(timerport = CreateMsgPort())) return FALSE;
	if (!(IDCMPport = CreateMsgPort())) return FALSE;

	if (OpenDevice(TIMERNAME, UNIT_VBLANK, (struct IORequest*) &timereq, 0)) {
		printf("Failed to open timer.device\n");
		return FALSE;
	}

	timereq.tr_node.io_Message.mn_ReplyPort = timerport;

	SNOOP_TASK = NULL;						// global tracking mode on

	monwindow = taskwindow = regswindow = NULL;	// no special windows up

	return TRUE;
}
//-------------------------------------------------------------------------
// Unpatch any patched functions.
// Unlock resources (Libraries, Devices, Resources)
// Deallocate all file buffers still in use.
//-------------------------------------------------------------------------

void cleanup(void) {
int i,size;

	unpatch_functions();

		// Release all the .FD file caches
	for (i=0; i< MAX_LIBS; i++) {
		size = fd_caches[i].bufsize;
		if (size) {
			FreeMem(fd_caches[i].filebuf, size);
		}
	}

	size = FdDirCache.bufsize;
	if (size)
		 FreeMem(FdDirCache.filebuf, size);

		// Release all the libraries/devices/resources which we locked
	for (libnum=0; libnum<numlibs; libnum++) {
		if (libs[libnum].openhandle)
			libs[libnum].openhandle->lib_OpenCnt--;
	}

		// Free all SysCall structures (pool)
	if (pool_base)
		FreeMem((char*)pool_base, POOL_SIZE);

	if (IntuitionBase) {
		if (window) {
			window->UserPort = NULL;	// Intuition: leave MY port alone!
			if (menus_exist) {
				ClearMenuStrip(window);
				FreeMenus(menustrip);
			}
			CloseWindowSafely(window);
		}
		FreeVisualInfo(vi);
		CloseLibrary( (struct Library *) IntuitionBase);
	}

	if (AslBase) {
		CloseLibrary( (struct Library *) AslBase);
	}

	if (GadToolsBase) {
		CloseLibrary( (struct Library *) GadToolsBase);
	}

	if (GfxBase)	  {
		CloseLibrary( (struct Library *) GfxBase);
	}

	if (timerport) DeleteMsgPort((struct MsgPort*)timerport);
	if (IDCMPport) DeleteMsgPort((struct MsgPort*)IDCMPport);

	CloseDevice((struct IORequest*) &timereq);

	exit(0);
}
//-------------------------------------------------------------------------
// For all functions which we've patched to track their use, undo all.
//-------------------------------------------------------------------------

void unpatch_functions(void) {

int i;
struct SysCall *syscall;

	if (!monitored) return;			// if nothing to unpatch... don't

	// Unpatch all functions which HeartBeat patched.

	for (i=0; i<monitored; i++) {

		syscall = patched_calls[i];
		if (VERBOSE) printf("Unpatching Call %s, %x \n",
						 syscall->funcname, syscall->ctxt->stdvector);

		SetFunction(syscall->parent_lib, syscall->func_LVO, syscall->ctxt->stdvector );
		syscall->ctxt = NULL;
	}

	ctxt_pool = (void*) node_pool;	// reset Contexts pool ptr
	monitored = 0;					// reset # of monitored functions
}
//-------------------------------------------------------------------------
