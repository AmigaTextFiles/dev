#ifndef LIBRARIES_ICQSOCKET_H
#define LIBRARIES_ICQSOCKET_H

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#include <libraries/llist.h>

//
// Tags for is_Init()
//

#define ISS_LogFile	(TAG_USER+100)	// (STRPTR) Filename for the message log, default is
					//          S:ICQ<UIN>.msglog
#define ISS_DataFile	(TAG_USER+101)	// (STRPTR) Filename for the database, default is
					//          S:ICQ<UIN>.config

//
// Tags for is_Connect()
//

#define ISS_Host	(TAG_USER+1)	// (STRPTR) Host adress, defaults to icq1.mirabilis.com
#define ISS_Port	(TAG_USER+2)	// (ULONG)  Port, defaults to 4000
#define ISS_Direct	(TAG_USER+3)	// (BOOL)   Accept direct connections
#define ISS_Status	(TAG_USER+4)	// (ULONG)  Status, defaults to online.
#define ISS_Resend	(TAG_USER+5)	// (ULONG)  Number of resends before an error event is generated
#define ISS_Password	(TAG_USER+6)	// (STRPTR) Password

//
// Client to server message types (commands) for is_Send().
//

#define ISC_NewStatus		(100)	// Set new status
					// (ULONG status)
#define ISC_TextMessage		(101)	// Send text message
					// (ULONG recipentUIN, STRPTR message)
#define ISC_URLMessage		(102)	// Send URL message
					// (ULONG recipentUIN, STRPTR URL, STRPTR description)
#define ISC_ContactMessage	(103)	// Send contacts to user
#define ISC_AuthorizeMessage	(104)	// Authorize remote user
					// (ULONG UIN)
#define ISC_UserAddedMessage	(105)	// Tell remote user he/she has been added
					// (ULONG recipentUIN, STRPTR Nick, STRPTR First,
					//  STRPTR Last, STRPTR Email)
#define ISC_RequestAuth		(109)	// Request Authorization
					// (ULONG recipentUIN, STRPTR Nick, STRPTR First,
					//  STRPTR Last, STRPTR Email, STRPTR Reason)
//#define ISC_UINLookup		(110)	// Request user info
					// (ULONG UIN)
//#define ISC_UINLookupExt	(111)	// Request extended user info
					// (ULONG UIN)
//#define ISC_Contacts		(200)	// Send contacts to server
					// (UBYTE num_contacts, ULONG *contarray)
//#define ISC_Visible		(201)	// Visible list
//#define ISC_Invisible		(202)	// Invisible list
//#define ISC_SearchUIN		(300)	// Search for a user (UIN)
//#define ISC_SearchUser		(301)	// Search for a user (name/email)
//#define ISC_ChangePW		(400)	// Change password
//#define ISC_UpdateInfo		(401)	// Update user info
//#define ISC_UpdateInfoExt	(402)	// Update user info (ext)
#define ISC_NewUser		(500)	// Register a new user
					// (STRPTR password)
#define ISC_NewUserInfo		(501)	// Set the 'new user info'
					// (STRPTR nick, first, last, email)
#define ISC_RandSearch		(600)	// Find a random user
					// (UWORD Group)
#define ISC_RandSet		(601)	// Set random info

//
// ICQ's 'datestamp'
//

typedef struct {
	UWORD	Year;
	UBYTE	Month;
	UBYTE	Day;
	UBYTE	Hour;
	UBYTE	Minute;
} ICQTime;

//
// ICQ packet header (server side, for error reporting)
//

typedef struct {
	UWORD	Version;
	UWORD	Command;
	ULONG	SID;
	ULONG	UIN;
	ULONG	Seq;
	UBYTE	*Data;
} ICQHeader;

//
// ID numbers for callback hooks
//
// The hook functions will recieve a pointer to one of the structures
// defined below.
//
// Example:
//
// ULONG __saveds __asm MyICQMsgFunc( register __a0 struct Hook *hook,
//				      register __a1 ICQMessage *msg )
// {
//	/* Handle the message here. The data remains valid only
//	   until the function returns, so you must copy strings
//	   etc.
//	   hook->h_Data is a user data field, and can be used for
//	   whatever you want. */
// }
//
// struct Hook MyICQMsgHook {
//	{ NULL, NULL },
//	&MyICQMsgFunc,
//	NULL,
//	"User data"
// };
//
// To install this hook, use
//
// is_InstallHook( IID_MESSAGE, &MyICQMsgHook );
//
// See below for other hook ID's:
//

enum ICQHookID {
	IID_MESSAGE=1,		// We recieved a message
	IID_USERINFO,		// User Info reply
	IID_STATUS,		// A user changed her status
	IID_USERFOUND,		// A sought user is found
	IID_ERROR,		// Error
	IID_LOGIN,		// Login is completed
	IID_END_OF_SEARCH,	// No more user_found's will be sent
	IID_UPDATE_SUCCESS,	// User Info update succeded
	IID_NEW_UIN,		// A new UIN for a new user
	IID_RAND,		// Random user found
	IID_USER_ADDED,		// An unknown (or random) user has
				// interacted with you, and has been
				// added to the list of unknown users.
	IID_TIMER_EVENT,	// Occurs twice every second after
				// is_Init has been called.
				// This hook is intended for use with
				// flashing symbols, like the Mirabilis'
				// client does. Internally this interval
				// is used for 'keep alive' and resends.

	MAX_HOOKS
};

//
// Message
//

typedef struct {
	ULONG	Size;		// Size of the structure
	ULONG	UIN;
	ICQTime	Time;		// When the msg was sent
	UBYTE	Type;		// See below for definitions
	BOOL	Instant;	// TRUE if the message has been instantly delivered
				// FALSE if the message has waited on the server before delivery
	char	Msg[0];		// Message text, NULL terminated
				// Fields are separated by 0xFE
} ICQMessage;

typedef struct {
	LINK_INFO;
	ICQMessage	im;
} LogMessage;

#define MST_TEXT	0x0001	// Plain text message
#define MST_URL		0x0004	// URL (first description, then URL, separated by 0xFE = 'þ')
#define MST_REQAUTH	0x0006	// Authorization request
#define MST_AUTHORIZE	0x0008	// Authorization recieved
#define MST_USERADDED	0x000C	// A user added us to his/her list
#define MST_CONTACTS	0x0013	// Contact list

//#define MST_MASS_MASK	0x8000	//

//
// User database entry
//

typedef struct {
	struct LinkList ll;	// Contains extendend info (private)
	ULONG		UIN;	// UIN of this user
	ULONG		Status;	// User's status
	ULONG		IP;	// IP adress for TCP
	ULONG		Port;	// Port for TCP
	UWORD		TCPVer;	// TCP message version
	UWORD		Age;	// Age of user
	UWORD		CCode;	// Country code
	UWORD		TZone;	// Time zone
	UBYTE		Sex;	// User's gender
	ULONG		Online;	// Last time seen online
	BOOL		Direct;	// Accepts direct connections
	char		Nick[0]; // User's nickname
} ICQUser;

// Reserved string ID's
#define	ICQC_FIRSTNAME	102
#define	ICQC_LASTNAME	103
#define	ICQC_EMAIL_1	104
#define	ICQC_EMAIL_2	105
#define	ICQC_EMAIL_3	106
#define	ICQC_PHONE_1	107
#define	ICQC_PHONE_2	108
#define	ICQC_WEB	120
#define	ICQC_CITY	125
#define	ICQC_NOTES	500

// User string ID's (1000 - 31500)
#define ICQC_USERSTRING	1000

typedef struct {
	LINK_INFO;
	char Str[0];
} ICQString;

//
// User Info
//

typedef struct {
	ULONG	UIN;

	STRPTR	Nick;
	STRPTR	First;
	STRPTR	Last;
	STRPTR	EMail;

	UWORD	Age;
	UWORD	CountryCode;
	UWORD	TimeZone;
	UBYTE	Sex;		// 'M', 'F' or '?'
	UBYTE	Reserved1;
	STRPTR	City;
	STRPTR	State;
	STRPTR	Phone;
	STRPTR	Home;
	STRPTR	About;
} ICQInfo;

#define UIT_BASIC	1	// The structure contains basic user info
#define UIT_EXTENDED	2	// The structure contains extended info

#define DB_UNKNOWN	1	// Unknown users
#define DB_RANDOM	2	// Random users
#define DB_CONTACTS	3	// Contact list users

//
// Random user
//

typedef struct {
	BOOL	Found;	// TRUE -> A user was found, details follow. FALSE -> No random user found
	ULONG	UIN;	// Random user's UIN
	ULONG	IP;	// User's IP
	ULONG	Port;	// Port	
	BOOL	Direct;	// TRUE -> Accepts direct connections
	ULONG	Status;	// The user's status
	UWORD	TCPVer;	// TCP version
} ICQRandomUser;

//
// Random chat groups
//

#define GRP_GENERAL	1
#define GRP_ROMANCE	2
#define GRP_GAMES	3
#define GRP_STUDENTS	4
#define GRP_20		6
#define GRP_30		5
#define GRP_40		8
#define GRP_50		9
#define GRP_REQ_WOMEN	10
#define GRP_REQ_MEN	11

//
// Status Update
//

typedef struct {
	ULONG	UIN;
	ULONG	Status;	// User's new status
	UWORD	Type;	// see below

	// The fields below is only valid for SUT_ONLINE!
	ULONG	IP;
	ULONG	Port;	// The port to connect to
	ULONG	RealIP;	// The IP to make connections to
	UWORD	TCP;	// ICQ TCP Version
	BOOL	Direct;	// TRUE -> Client accepts direct connections
} ICQStatusUpdate;

#define SUT_ONLINE	1	// User went online - remember port and ip!
#define SUT_OFFLINE	2	// User went offline
#define SUT_UPDATE	3	// User changed her/his status

//
// User Found
//

typedef struct {
	ULONG	UIN;
	STRPTR	Nick;
	STRPTR	First;
	STRPTR	Last;
	STRPTR	EMail;
	BOOL	Auth;	// Authorization required
	UBYTE	X1;	// Unknown
} ICQUserFound;

//
// End of Search
//

typedef struct {
	BOOL TooMany;	// The search generated too many results
} ICQEndOfSearch;

//
// Error
//

typedef struct {
	ULONG		SokErr;	// bsdsocket.library error code, or NULL
	ULONG		ICQErr;	// ICQSocket error code, or NULL
	ICQHeader	*Hdr;	// Header of unknown messages (ICQERR_UNKNOWN and ICQERR_BAD_VERSION)
} ICQError;

// Protocol errors: (for socket errs see sys/errno.h)

#define ICQERR_BAD_PASS		1	// Bad password
#define ICQERR_GO_AWAY		2	// Server is forcing us to disconnect
#define ICQERR_ERROR		3	// Server tells us something's wrong, and it won't listen to us any more. (disconnect)
#define ICQERR_BUSY		4	// Server is busy, "try in a few seconds".
#define ICQERR_UNKNOWN		5	// Unrecognized msg recieved.
#define ICQERR_SPOOFED		6	// Someone tried to send a spoofed message
#define ICQERR_BAD_VERSION	7	// A packet with unknown version was recieved

#define ICQERR_MEM		100	// Out of memory

//
// Login Successful
//

typedef struct {
	int x;
} ICQLogin;

//
// Return codes for is_Login()
//

#define OK		0
#define ERR_MEM		-1
#define ERR_HOSTNAME	-2
#define ERR_CONNECT	-3
#define ERR_SOCKET	-4
#define ERR_SOCKLIB	-5

struct ICQSocketBase {
	struct Library	is_Library;
	ULONG		is_SegList;
	ULONG		is_Flags;
};

//
// ICQHandle structure
//

#define MAX_DUPCHK	64		// more than enough

typedef struct {
	ULONG		UIN;		// Theese are _READ_ONLY_
	ULONG		SID;		//
	ULONG		Version;	//
	ULONG		Port;		//
	ULONG		IP;		//
	ULONG		Status;		//

#ifdef ICQSOCKET_PRIVATE
	LONG		UDPSocket;		// Socket
	struct Hook	*HookTable[MAX_HOOKS];	// Callback hooks
	fd_set		rd;			//
	struct timerequest	*timer;		// Timer
	struct MsgPort		*tp;		// Timer port
	ULONG		halfsecs;		// 1/2 seconds elapsed since is_Init
	struct LinkList	*Contacts;		// Known contacts
	struct LinkList	*RandomUsers;		// Random contacts
	struct LinkList	*UnknownUsers;		// Unknown contacts
	LONG		MsgLog;			// Message log
	LONG		Console;		// eh?
	struct LinkList	*NotifyList;		// Hooks to call when ack is recieved
	struct LinkList	*AckList;		// Packets waiting for acks
	ULONG		UsedSeqs[MAX_DUPCHK];	// Used seq's for incoming packets
	ULONG		SeqCtr;			// Counter for above
	UWORD		Seq1;			// Sequence numbers (outgoing)
	UWORD		Seq2;			// Sequence numbers (outgoing)
	ICQMessage	*imsg;			// Temp. pointer
	LogMessage	*lmsg;			// Temp. pointer
	struct LinkList	*MsgQueue;		// Queue of incomming messages
	char		CfgFile[180];		// Filename of cfg file
	char		LogFile[180];		// Filename of log file

	struct ICQCfgHdr {
		char		ID[4];		// ISoc
		ULONG		Version;	// 1
		ULONG		Key;		// Encryption key
		char		Pass[64];	// Encrypted password
		UBYTE		Reserved[256];	
	} Config;
#endif

} ICQHandle;

//
// Prototypes
//

ICQHandle *is_InitA(ULONG uin, struct TagItem *tags);
void is_Free(ICQHandle *ih);

// Debug
void is_Debug(LONG fh, LONG flags);

// Connect/disconnect
ULONG is_ConnectA(ICQHandle *, struct TagItem *tags);
ULONG is_Connect(ICQHandle *, ULONG, ...);
void is_Disconnect(ICQHandle *);
ULONG is_NetWait(ICQHandle *, ULONG signals);

// Notification
void is_AddAckNot(ICQHandle *, struct Hook *h, ULONG seq, APTR ud);
void is_RemAckNot(ICQHandle *, ULONG seq);
void is_InstallHook(ICQHandle *, ULONG id, struct Hook *hook);

// Send packets
ULONG is_Send(ICQHandle *, struct Hook *ack, ULONG command, ...);
ULONG is_SendA(ICQHandle *, struct Hook *ack, ULONG *command);

// Database
BOOL is_AddUIN(ICQHandle *, ULONG uin);
BOOL is_AddUINQ(ICQHandle *, ULONG uin);
BOOL is_RemUIN(ICQHandle *, ULONG uin);
ICQUser *is_FindUIN(ICQHandle *, ULONG uin);
BOOL is_OpenDatabase(ICQHandle *, ULONG db);
void is_CloseDatabase(ICQHandle *, ULONG db);
ICQUser *is_GetEntry(ICQHandle *, ULONG db);
STRPTR is_GetString(ICQHandle *, ICQUser *user, UWORD id);
BOOL is_SetString(ICQHandle *, ICQUser *user, UWORD id, STRPTR str);

// Message queue
BOOL is_QueryQueue(ICQHandle *, ULONG uin);
BOOL is_OpenMsgQueue(ICQHandle *);
void is_CloseMsgQueue(ICQHandle *);
ICQMessage *is_GetQueuedMsg(ICQHandle *, ULONG uin);

// Message log
BOOL is_OpenMsgLog(ICQHandle *);
void is_CloseMsgLog(ICQHandle *);
ICQMessage *is_GetLoggedMsg(ICQHandle *, ULONG uin);

#endif
