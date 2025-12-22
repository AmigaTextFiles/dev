/*
 *
 * hotlinks.h - C include file for using the hotlink.library
 *
 *
 */
 
#ifndef HOTLINKS_HOTLINKS_H
#define HOTLINKS_HOTLINKS_H       1

#ifndef EXEC_PORTS_H
#include <exec/ports.h>
#endif EXEC_PORTS_H 

/* the name of the hotlinks library */
#define HOTLINKS_LIBRARY_NAME   "hotlinks.library"

/* define message id types 1-255 */
#define HLMSGID_HLSYSINFO       0
#define HLMSGID_HLREGISTER      1
#define HLMSGID_UNREGISTER      2
#define HLMSGID_ALLOCPBLOCK     3
#define HLMSGID_FREEPBLOCK      4
#define HLMSGID_SETUSER         5
#define HLMSGID_CHGPASSWORD     6
#define HLMSGID_FIRSTPUB        7
#define HLMSGID_NEXTPUB         8
#define HLMSGID_REMOVEPUB       9
#define HLMSGID_NOTIFY          10
#define HLMSGID_PUBSTATUS       11
#define HLMSGID_GETINFO         12
#define HLMSGID_SETINFO         13
#define HLMSGID_LOCKPUB         14
#define HLMSGID_OPENPUB         15
#define HLMSGID_READPUB         16
#define HLMSGID_WRITEPUB        17
#define HLMSGID_SEEKPUB         18
#define HLMSGID_CLOSEPUB        19
#define HLMSGID_NOTIFYREPLY     20
#define HLMSGID_DOWN            21
/* 22-65535 are reserved for future use */

/* error codes - returned in the Return field of the HLMsg  */
#define NOERROR         0
#define INVPARAM        -1
#define NOPRIV          -2
#define NOMEMORY        -3
#define READLOCKED      -4
#define WRITELOCKED     -5
#define UNREGISTERED    -6
#define INUSE           -7
#define IOERROR         -8
#define NOMOREBLOCKS    -9
#define CHANGED         -10
#define UNIMPLEMENTED   -11


/* types of locks */
#define LOCK_RELEASE    0
#define LOCK_READ       1
#define LOCK_WRITE      2
#define LOCK_FLAGS      3


/* types of open */
#define OPEN_READ       1
#define OPEN_WRITE      2
#define OPEN_MODIFY     3
#define OPEN_FLAGS      3


/* file states */
#define STATE_READLOCKED        1
#define STATE_WRITELOCKED       2
#define STATE_OPENEDR           3
#define STATE_OPENEDW           4


/* access codes */
#define ACC_OREAD       1
#define ACC_OWRITE      2
#define ACC_GREAD       16
#define ACC_GWRITE      32
#define ACC_AREAD       256
#define ACC_AWRITE      512

#define ACC_DEFINED     (ACC_OREAD|ACC_OWRITE|ACC_GREAD|ACC_GWRITE|ACC_AREAD|ACC_AWRITE)
#define ACC_DEFAULT     (ACC_OREAD|ACC_OWRITE|ACC_GREAD|ACC_GWRITE)


/* types of notify supported */
#define INFORM          0
#define NOINFORM        1
#define EXINFORM        2


/* returned from user supplied filter proc called by getpub */
#define ACCEPT          0
#define NOACCEPT        1


/* seek modes */
#define SEEK_BEGINNING  -1
#define SEEK_CURRENT     0
#define SEEK_END         1


/* hotlink file types and IFF chunks */
#define CSET (('C'<<24)+('S'<<16)+('E'<<8)+('T')) 
#define DTXT (('D'<<24)+('T'<<16)+('X'<<8)+('T')) 
#define DTAG (('D'<<24)+('T'<<16)+('A'<<8)+('G'))
#define HLID (('H'<<24)+('L'<<16)+('I'<<8)+('D')) 
#ifndef ILBM
#define ILBM (('I'<<24)+('L'<<16)+('B'<<8)+('M'))
#endif


/* hotlink message Class - to aviod IDCMP collision */
#define HLCLASS         3


/* IFF chunk XBMI picture values */
#define ILBM_PAL        0
#define ILBM_GREY       1
#define ILBM_RGB        2
#define ILBM_RGBA       3
#define ILBM_CMYK       4
#define ILBM_CMYKA      5
#define ILBM_BW         6
/* 7-255 are reserved for future expansion */

/* commands imbedded in the TEXT & TAG chunks of a HotLink TEXT file */
#define TEXT_TAB        1
#define TEXT_NEWLINE    2
#define TEXT_EOC        3
#define TEXT_EOP        4
#define TEXT_BCCB       5
#define TEXT_ECCB       6
#define TEXT_BCPB       7
#define TEXT_ECPB       8
#define TEXT_PAGENUM    9
#define TEXT_MARK       10
#define TEXT_BRANGE     11
#define TEXT_ERANGE     12
#define TEXT_FOOTNOTE   13
#define TEXT_RULER      14
#define TEXT_BAKERN     15
#define TEXT_EAKERN     16
#define TEXT_BAHYPHEN   17 
#define TEXT_EAHYPHEN   18
#define TEXT_TRACKRANGE 19
#define TEXT_DROPCAP    20
                
#define TEXT_TAG        30
#define TEXT_FONT       31
#define TEXT_ATTRB      32
#define TEXT_POINT      33
#define TEXT_JUSTIFY    34
#define TEXT_PARAGRAPH  35
#define TEXT_INDENT     36
#define TEXT_LEADING    37
#define TEXT_PARALEAD   38
#define TEXT_TRACKING   39
#define TEXT_BASELINE   40

#define TEXT_MKERN      50
#define TEXT_AKERN      51
#define TEXT_MHYPHEN    52
#define TEXT_AHYPHEN    53

/* flags for commands imbedded in the DTXT & TAG chunks of a HotLinks DTXT file */
#define TFLAG_NODISP		0
#define TFLAG_NOEDITDISP	1
#define TFLAG_EDITDISP		2
#define TFLAG_UNUSED0		3

#define TFLAG_KEEPLAST		0
#define TFLAG_KEEPNONE		4
#define TFLAG_KEEPALL		8
#define TFLAG_UNUSED1		12

#define TFLAG_NOTWHITESPACE	0
#define TFLAG_WHITESPACE	16

#define TEXT_FLAGS_TAB        (TFLAG_KEEPNONE|TFLAG_WHITESPACE)
#define TEXT_FLAGS_NEWLINE    (TFLAG_KEEPNONE|TFLAG_WHITESPACE)
#define TEXT_FLAGS_EOC        (TFLAG_KEEPNONE|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_EOP        (TFLAG_KEEPNONE|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_BCCB       (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_ECCB       (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_BCPB       (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_ECPB       (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_PAGENUM    (TFLAG_KEEPNONE|TFLAG_WHITESPACE)
#define TEXT_FLAGS_MARK       (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_BRANGE     (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_ERANGE     (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_FOOTNOTE   (TFLAG_KEEPNONE|TFLAG_WHITESPACE)
#define TEXT_FLAGS_RULER      (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_BAKERN     (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_EAKERN     (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_BAHYPHEN   (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_EAHYPHEN   (TFLAG_KEEPALL|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_TRACKRANGE (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_DROPCAP    (TFLAG_KEEPNONE|TFLAG_WHITESPACE)

#define TEXT_FLAGS_TAG        (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_FONT       (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_ATTRB      (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_POINT      (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_JUSTIFY    (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_PARAGRAPH  (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_INDENT     (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_LEADING    (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_PARALEAD   (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_TRACKING   (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_BASELINE   (TFLAG_KEEPLAST|TFLAG_NOTWHITESPACE)

#define TEXT_FLAGS_MKERN      (TFLAG_KEEPNONE|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_AKERN      (TFLAG_KEEPNONE|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_MHYPHEN    (TFLAG_KEEPNONE|TFLAG_NOTWHITESPACE)
#define TEXT_FLAGS_AHYPHEN    (TFLAG_KEEPNONE|TFLAG_NOTWHITESPACE)


/* atrributes for the TEXT_ATTRB command */
#define ATTRB_NORMAL    'N'
#define ATTRB_BOLD      'B'
#define ATTRB_LIGHT     'L'
#define ATTRB_ITALIC    'I'
#define ATTRB_SHADOW    'S'
#define ATTRB_OUTLINE   'O'
#define ATTRB_UNDERLINE 'U'
#define ATTRB_WEIGHT    'W'
                
/* justify modes for the TEXT_JUSTIFY command */
#define JUSTIFY_LEFT    1
#define JUSTIFY_CENTER  2
#define JUSTIFY_RIGHT   3
#define JUSTIFY_CHAR    4
#define JUSTIFY_WORD    5
#define JUSTIFY_AUTO    6

/* TAG Types */
#define TAG_TEXT        0
#define TAG_FILL        1
#define TAG_LINE        2
#define TAG_COLOR       3
#define TAG_WITHTEXT    4
#define TAG_TEXTMACRO   5


/* hotlinks message struct */
struct HLMsg
{
    struct Message mess;                /* standard exec style message */
    int HLClass;                        /* message class - like IntuiMessage */
    unsigned short int ID;              /* message id - type of message */
    struct PubBlock *PB;                /* pointer to a publock */
    unsigned int Flags;                 /* flags */
    int Return;                         /* return code */
    unsigned int UserData1;             /* user data slots */
    unsigned int UserData2;
    unsigned int UserData3;
    unsigned int UserData4;
    unsigned int UserData5;
    unsigned int UserData6;
    unsigned int UserData7;
    unsigned int UserData8;
    unsigned int UserData9;
    unsigned int UserData10;
    unsigned int UserData11;
    unsigned int UserData12;
    unsigned int UserData13;
    unsigned int UserData14;
    unsigned int UserData15;
};


/* edition information struct (publication record) */
struct PubRecord
{
        unsigned int ID[2];             /* two part id number */
        unsigned int Type;              /* edition type ILBM or DTXT, etc. */
        unsigned int Version;           /* edition version number */
        unsigned int CDate;             /* creation date */
        unsigned int CTime;             /* creation time */
        unsigned int MDate;             /* last modified data */
        unsigned int MTime;             /* last modified time */
        unsigned int Access;            /* access codes */
        unsigned int Creator;           /* who created this edition */
        char Name[32];                  /* name of the edition file */
        char Desc[256];                 /* description of the edition file */
        char Owner[32];                 /* user that created the edition file */
        char Group[32];                 /* the user's group */
};


/* publication block as returned by AllocPBlock() */
struct PubBlock
{
        struct PubRecord PRec;
                
/* this data is Private and should NOT be changed by an application */
        int State;
        int OFlag;
        int LFlag;
        unsigned int FOffset;
        struct MsgPort *MP;
        struct MsgPort *usermp;
        struct HLMsg *msg;
        struct Screen *screen;
        int curpos;
        char *buffer;
        int remain;
};

#endif HOTLINKS_HOTLINKS_H
