/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1992 by Torsten Jürgeleit
 *
 *	Name .....: defines.h
 *	Created ..: Wednesday 12-Feb-92 20:45:56
 *	Revision .: 2
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	14-Sep-92   Torsten Jürgeleit      new entries in global data struct,
 *					   stuff for environment variable, ...
 *	27-Apr-92   Torsten Jürgeleit      introduce global data structure
 *	12-Feb-92   Torsten Jürgeleit      Created this file!
 *
 ****************************************************************************
 *
 *	Defines and structures
 *
 * $Revision Header ********************************************************/

	/* Defines for process */

#define PROCESS_NAME		"FarPrint v2.2"
#define PROCESS_STACK		4096
#define PROCESS_PRIORITY	0
#define PROCESS_BACKGROUND_IO	1

	/* Defines for display */

#define WINDOW_LEFT		0
#define WINDOW_TOP		0
#define WINDOW_WIDTH		400
#define WINDOW_HEIGHT		113
#define WINDOW_DETAIL_PEN	0
#define WINDOW_BLOCK_PEN	1
#define WINDOW_IDCMP		(CLOSEWINDOW | RAWKEY | GADGET_IDCMP_FLAGS_ALL | MENUPICK | NEWSIZE | ACTIVEWINDOW | INACTIVEWINDOW)
#define WINDOW_FLAGS		(WINDOWCLOSE | WINDOWDRAG | WINDOWDEPTH | WINDOWSIZING | SMART_REFRESH | NOCAREREFRESH)
#define WINDOW_TITLE		(UBYTE *)" FarPrint v2.2 "

#define MIN_WINDOW_WIDTH	240
#define MIN_WINDOW_HEIGHT	110

#define RENDER_INFO_FLAGS	RENDER_INFO_FLAG_INNER_WINDOW
#define OPEN_WINDOW_FLAGS	OPEN_WINDOW_FLAG_NO_INNER_WINDOW

	/* Name of harbour port */

#define FARPRINT_PORT_NAME	"FarPort"

	/* Defines for environment variable */

#define FARPRINT_ENV_NAME	"env:FARPRINT"

#define MAX_ARGUMENTS		6

#define ARGUMENT_LEFT_EDGE	0
#define ARGUMENT_TOP_EDGE	1
#define ARGUMENT_WIDTH		2
#define ARGUMENT_HEIGHT		3
#define ARGUMENT_STOPPED	4
#define ARGUMENT_REFRESH	5

	/* Defines for status */

#define STATUS_NORMAL	0
#define STATUS_RESIZE	1
#define STATUS_ERROR	2
#define STATUS_QUIT	3

	/* Defines for error messages */

#define ERROR_NO_ARP			-1
#define ERROR_NO_INTUISUP		-2
#define ERROR_NO_WINDOW			-3
#define ERROR_OUT_OF_MEM		-4
#define ERROR_FARPRINT_ALREADY_STARTED	-5
#define ERROR_NO_SERIAL			-6
#define ERROR_SERIAL_IO_FAILED		-7
#define ERROR_OPEN_FAILED		-8
#define ERROR_WRITE_FAILED		-9

	/* Defines for menu */

#define MENU_TEXT_ATTR	&topaz60_attr

#define MENU_PROJECT		0
#define    ITEM_PROJECT_SERIAL	0
#define    ITEM_PROJECT_FLUSH	1
#define    ITEM_PROJECT_CLEAR	2
#define    ITEM_PROJECT_MARK	3
#define    ITEM_PROJECT_SAVE	4
#define    ITEM_PROJECT_ABOUT	5
#define    ITEM_PROJECT_QUIT	6

	/* Defines for gadgets */

#define MAX_INPUT_LENGTH	256

#define GADGET_LIST		0
#define GADGET_INPUT		1
#define GADGET_STOP		2
#define GADGET_REFRESH		3

	/* Defines for request message */

#define REQ_MSG_TYPE		TEXT_DATA_TYPE_TEXT
#define REQ_MSG_LEFT_EDGE	0
#define REQ_MSG_TOP_EDGE	(fd->fd_Height - 44)
#define REQ_MSG_FLAGS		(TEXT_DATA_FLAG_ABSOLUTE_POS | TEXT_DATA_FLAG_CENTER | TEXT_DATA_FLAG_COLOR2)
#define REQ_MSG_TEXT_ATTR	&topaz80_attr

	/* FarPrint flags */

#define DEFAULT_FARPRINT_FLAGS	FARPRINT_FLAG_REFRESH

#define FARPRINT_FLAG_STOPPED	(1 << 0)
#define FARPRINT_FLAG_REFRESH	(1 << 1)
#define FARPRINT_FLAG_SERIAL	(1 << 2)

	/* External communication commands */

#define FM_ADDTXT	0
#define FM_REQTXT	1
#define FM_REQNUM	2

	/* Custom task <-> task communication message */

struct FarMessage {
	struct Message	fm_ExecMessage;	/* Exec message link */

	USHORT	fm_Command;		/* Perform which action? */
	BYTE	*fm_Identifier;		/* Who calls? */
	BYTE	*fm_Text;		/* Message to display */
};
	/* Maximal retries for allocate FarText structure */

#define MAX_ALLOC_RETRIES	10

#define MARK_LINE_TEXT		"---------------------------------------------------------------------------------------------------"

	/* Structure needed for recording message text */

struct FarText {
	struct Node  ft_Node;
	BYTE	ft_Buffer[1];	/* buffer for text string with EOS termination character */
				/* you MUST add length of string to sizeof(struct FarText) to allocate real structure */
};
	/* Defines for serial device */

#define SERIAL_UNIT		0L
#define SERIAL_OPEN_FLAGS	(SERF_EOFMODE | SERF_7WIRE)
#define SERIAL_SETPARAMS_FLAGS	SERF_EOFMODE
#define SERIAL_TERM0_CHARS	'\n\n\n\n'
#define SERIAL_TERM1_CHARS	'\n\n\n\n'
#define SERIAL_BUFFER_SIZE	512

	/* Defines and structure for global data */

#define PATH_BUFFER_SIZE	(LONG_DSIZE + LONG_FSIZE)

struct FarData {
	struct MsgPort		*fd_FarPort;		/* FarPrint hardbour port */
	struct FarMessage	*fd_InputFarMessage;	/* FarMessage which requested some input */
	struct MinList		fd_FarMessageList;	/* list with received FarMessages */
	struct MsgPort		*fd_SerPort;		/* reply port for serial device */
	struct IOExtSer		*fd_SerReq;		/* io request for serial device */
	struct Window		*fd_Window;		/* ptr to FarPrint window */
	struct FileRequester	*fd_FileRequester;	/* ptr to initialized ARP file requester */
	APTR	fd_RenderInfo;
	APTR	fd_MenuList;
	APTR	fd_GadgetList;
	USHORT	fd_Flags;
	USHORT	fd_Width;		/* current width of FarPrint window */
	USHORT	fd_Height;		/* current height of FarPrint window */
	USHORT	fd_ListViewLines;	/* current num of lines in listview gadget */
	LONG	fd_NumFarMessages;	/* num of FarMessages currently in list */
	LONG	fd_TopFarMessage;	/* ordinal num of FarMessage currently displayed at first in list view */
	BYTE	fd_PathBuffer[PATH_BUFFER_SIZE + 1];
	BYTE	fd_SerBuffer[SERIAL_BUFFER_SIZE + 1];
};
