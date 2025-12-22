#define VERSION "2.1"
#define RELEASE "1"
#define DATE " 27 january 2001"

#include "defs.h"
#include "protos.h"


/* Entries for the localized strings */
enum indices {
    TEXTE_RECHERCHE = 0, TEXTE_GTLAYOUT, TEXTE_AREXX_PORT, TEXTE_TOOLTYPE, TEXTE_PATTERN,
    TEXTE_REMOVE, TEXTE_VERSION, TEXTE_OK, TEXTE_REFERENCE, TEXTE_FIND_PATTERN, TEXTE_FETCHREF,
    TEXTE_LISTE, TEXTE_CANCEL, TEXTE_GUIDE, TEXTE_AMIGAGUIDE, TEXTE_NOREF, TEXTE_ABORT
};


/* Error value passed to CloseAll() when a Fault() message in not enough */
#define ERROR_CUSTOM	    1	/* A custom text is passed as second argument	    */
#define ERROR_RUNTWICE	    2	/* Detected other running FetchRefs and quit it     */
#define ERROR_SPECIALMAX    2	/* To know the border */


/* A few personal structs */
struct FileEntry {
    struct Node node;
    struct List RefsList;
    UBYTE Name[0];
};


struct RefsEntry {
    struct Node node;
    LONG Offset;
    LONG Length;
    WORD Goto;
    UBYTE Name[0];
};

/* Global variables */
extern struct List FileList;
extern struct MsgPort *CxPort, * rexxPort;

extern struct WBStartup *_WBMsg;

/* Give each of the ARexx commands we can receive an ID.
 * FR_DUMMY is for illegal commands... */
enum ARexxID { FR_DUMMY, FR_QUIT, FR_GET, FR_CLEAR, FR_NEW, FR_ADD, FR_FILE, FR_REQ };

/* FindRef() related */
struct FindRefOptions {
    STRPTR  Reference;
    STRPTR  DestFile;
    STRPTR  PubScreen;
    long    function;
    BOOL    FileRef;
    BOOL    Case;
};

struct FindRefReturnStruct {
    LONG Result;    /* The result of FindRef() [see below] */
    LONG Number;    /* 2nd return code; line to go to or DOS fault code */
};
enum FindRefResults { RET_OKAY, RET_MATCH, RET_NO_MATCH, RET_ABORT, RET_FAULT };
