*******************************************************************
*                                                                 *
*   hotlinks.i - include file for using hotlinks.library          *
*                                                                 *
*                                                                 *
*******************************************************************

 IFND HOTLINKS_HOTLINKS_I
HOTLINKS_HOTLINKS_I equ 1

    INCDIR "include:"
    
    IFND EXEC_TYPES_I
        INCLUDE "exec/types.i"
    ENDC
    
    IFND EXEC_PORTS_I
        INCLUDE "exec/ports.i"
    ENDC

; LVO's
    
_LVOGetPub	equ	-$1e
_LVOPutPub	equ	-$24
_LVOPubInfo	equ	-$2a
_LVOHLSysInfo	equ	-$30
_LVOHLRegister	equ	-$36
_LVOUnRegister	equ	-$3c
_LVOAllocPBlock	equ	-$42
_LVOFreePBlock	equ	-$48
_LVOSetUser	equ	-$4e
_LVOChgPassword	equ	-$54
_LVOFirstPub	equ	-$5a
_LVONextPub	equ	-$60
_LVORemovePub	equ	-$66
_LVONotify	equ	-$6c
_LVOPubStatus	equ	-$72
_LVOGetInfo	equ	-$78
_LVOSetInfo	equ	-$7e
_LVOLockPub	equ	-$84
_LVOOpenPub	equ	-$8a
_LVOReadPub	equ	-$90
_LVOWritePub	equ	-$96
_LVOSeekPub	equ	-$9c
_LVOClosePub	equ	-$a2
_LVOPublish	equ	-$a8
_LVOSubscribe	equ	-$ae
_LVONewPassword equ     -$b4
_LVOUnSubscribe equ     -$ba


;message types (UWORD hm_ID)
HLMSGID_HLSYSINFO       equ     0
HLMSGID_HLREGISTER      equ     1
HLMSGID_UNREGISTER      equ     2
HLMSGID_ALLOCPBLOCK     equ     3
HLMSGID_FREEPBLOCK      equ     4
HLMSGID_SETUSER         equ     5
HLMSGID_CHGPASSWORD     equ     6
HLMSGID_FIRSTPUB        equ     7
HLMSGID_NEXTPUB         equ     8
HLMSGID_REMOVEPUB       equ     9
HLMSGID_NOTIFY          equ     10
HLMSGID_PUBSTATUS       equ     11
HLMSGID_GETINFO         equ     12
HLMSGID_SETINFO         equ     13
HLMSGID_LOCKPUB         equ     14
HLMSGID_OPENPUB         equ     15
HLMSGID_READPUB         equ     16
HLMSGID_WRITEPUB        equ     17
HLMSGID_SEEKPUB         equ     18
HLMSGID_CLOSEPUB        equ     19
HLMSGID_NOTIFYREPLY     equ     20
HLMSGID_DOWN            equ     21
;22-65535 are reserved for future use


;error codes - returned in the Return field of the HLMsg
NOERROR         equ     0
INVPARAM        equ     -1
NOPRIV          equ     -2
NOMEMORY        equ     -3
READLOCKED      equ     -4
WRITELOCKED     equ     -5
UNREGISTERED    equ     -6
INUSE           equ     -7
IOERROR         equ     -8
NOMOREBLOCKS    equ     -9
CHANGED         equ     -10
UNIMPLEMENTED   equ     -11

;types of locks
LOCK_RELEASE    equ     0
LOCK_READ       equ     1       ;shared lock
LOCK_WRITE      equ     2       ;exclusive lock
LOCK_FLAGS      equ     3       ;lock bits used


;types of open
OPEN_READ       equ     1       ;MODE_OLDFILE + LOCK_READ
OPEN_WRITE      equ     2       ;MODE_NEWFILE + LOCK_WRITE
OPEN_MODIFY     equ     3       ;MODE_OLDFILE + LOCK_WRITE
OPEN_FLAGS      equ     3       ;the open mode bits used


;file states
STATE_READLOCKED        equ     1
STATE_WRITELOCKED       equ     2
STATE_OPENEDR           equ     3
STATE_OPENEDW           equ     4


;access codes
ACC_OREAD       equ     1
ACC_OWRITE      equ     2
ACC_GREAD       equ     16
ACC_GWRITE      equ     32
ACC_AREAD       equ     256
ACC_AWRITE      equ     512

ACC_DEFINED     equ     819
ACC_DEFAULT     equ     51


;types of notify supported
INFORM          equ     0
NOINFORM        equ     1
EXINFORM        equ     2

;returned by the filter proc to getpub
ACCEPT          equ     0
NOACCEPT        equ     1

;seek modes
SEEK_BEGINNING  equ    -1
SEEK_CURRENT    equ     0
SEEK_END        equ     1

;hotlink message class - to avoid IDCMP collision
HLCLASS equ     3

;hotlinks IFF definitions
HLID    equ     'HLID'
CSET    equ     'CSET'
DTAG    equ     'DTAG'
DTXT    equ     'DTXT'
 IFND ILBM
ILBM    equ     'ILBM'
 ENDC ;ILBM
 
;IFF chunk XBMI picture type values
ILBM_PAL        equ     0
ILBM_GREY       equ     1
ILBM_RGB        equ     2
ILBM_RGBA       equ     3
ILBM_CMYK       equ     4
ILBM_CMYKA      equ     5
ILBM_BW         equ     6

;commands imbedded in the TEXT & TAG chunks of a HotLink TEXT file
TEXT_TAB        equ     1
TEXT_NEWLINE    equ     2
TEXT_EOC        equ     3
TEXT_EOP        equ     4
TEXT_BCCB       equ     5
TEXT_ECCB       equ     6
TEXT_BCPB       equ     7
TEXT_ECPB       equ     8
TEXT_PAGENUM    equ     9
TEXT_MARK       equ     10
TEXT_BRANGE     equ     11
TEXT_ERANGE     equ     12
TEXT_FOOTNOTE   equ     13
TEXT_RULER      equ     14
TEXT_BAKERN     equ     15
TEXT_EAKERN     equ     16
TEXT_BAHYPHEN   equ     17 
TEXT_EAHYPHEN   equ     18
TEXT_TRACKRANGE equ     19
TEXT_DROPCAP    equ     20
                
TEXT_TAG        equ     30
TEXT_FONT       equ     31
TEXT_ATTRB      equ     32
TEXT_POINT      equ     33
TEXT_JUSTIFY    equ     34
TEXT_PARAGRAPH  equ     35
TEXT_INDENT     equ     36
TEXT_LEADING    equ     37
TEXT_PARALEAD   equ     38
TEXT_TRACKING   equ     39
TEXT_BASELINE   equ     40

TEXT_MKERN      equ     50
TEXT_AKERN      equ     51
TEXT_MHYPHEN    equ     52
TEXT_AHYPHEN    equ     53

;flags for commands imbedded in the TEXT & TAG chunks of a HotLink TEXT file
TFLAG_NODISP		equ	%00000
TFLAG_NOEDITDISP	equ	%00001
TFLAG_EDITDISP		equ	%00010
TFLAG_UNUSED0		equ	%00011

TFLAG_KEEPLAST		equ	%00000
TFLAG_KEEPNONE		equ	%00100
TFLAG_KEEPALL		equ	%01000
TFLAG_UNUSED1		equ	%01100

TFLAG_NOTWHITESPACE	equ	%00000
TFLAG_WHITESPACE	equ	%10000

TEXT_FLAGS_TAB        equ	TFLAG_KEEPNONE+TFLAG_WHITESPACE
TEXT_FLAGS_NEWLINE    equ	TFLAG_KEEPNONE+TFLAG_WHITESPACE
TEXT_FLAGS_EOC        equ	TFLAG_KEEPNONE+TFLAG_NOTWHITESPACE
TEXT_FLAGS_EOP        equ	TFLAG_KEEPNONE+TFLAG_NOTWHITESPACE
TEXT_FLAGS_BCCB       equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_ECCB       equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_BCPB       equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_ECPB       equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_PAGENUM    equ	TFLAG_KEEPNONE+TFLAG_WHITESPACE
TEXT_FLAGS_MARK       equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_BRANGE     equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_ERANGE     equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_FOOTNOTE   equ	TFLAG_KEEPNONE+TFLAG_WHITESPACE
TEXT_FLAGS_RULER      equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_BAKERN     equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_EAKERN     equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_BAHYPHEN   equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_EAHYPHEN   equ	TFLAG_KEEPALL+TFLAG_NOTWHITESPACE
TEXT_FLAGS_TRACKRANGE equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_DROPCAP    equ	TFLAG_KEEPNONE+TFLAG_WHITESPACE

TEXT_FLAGS_TAG        equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_FONT       equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_ATTRB      equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_POINT      equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_JUSTIFY    equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_PARAGRAPH  equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_INDENT     equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_LEADING    equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_PARALEAD   equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_TRACKING   equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE
TEXT_FLAGS_BASELINE   equ	TFLAG_KEEPLAST+TFLAG_NOTWHITESPACE

TEXT_FLAGS_MKERN      equ	TFLAG_KEEPNONE+TFLAG_NOTWHITESPACE
TEXT_FLAGS_AKERN      equ	TFLAG_KEEPNONE+TFLAG_NOTWHITESPACE
TEXT_FLAGS_MHYPHEN    equ	TFLAG_KEEPNONE+TFLAG_NOTWHITESPACE
TEXT_FLAGS_AHYPHEN    equ	TFLAG_KEEPNONE+TFLAG_NOTWHITESPACE


;atrributes for the TEXT_ATTRB command
ATTRB_NORMAL    equ     'N'
ATTRB_BOLD      equ     'B'
ATTRB_LIGHT     equ     'L'
ATTRB_ITALIC    equ     'I'
ATTRB_SHADOW    equ     'S'
ATTRB_OUTLINE   equ     'O'
ATTRB_UNDERLINE equ     'U'
ATTRB_WEIGHT    equ     'W'

;justify modes for the TEXT_JUSTIFY command
JUSTIFY_LEFT    equ     1
JUSTIFY_CENTER  equ     2
JUSTIFY_RIGHT   equ     3
JUSTIFY_CHAR    equ     4
JUSTIFY_WORD    equ     5
JUSTIFY_AUTO    equ     6

;Tag types
TAG_TEXT        equ     0
TAG_FILL        equ     1
TAG_LINE        equ     2
TAG_COLOR       equ     3
TAG_WITHTEXT    equ     4
TAG_TEXTMACRO   equ     5


 STRUCTURE HLMsg,MN_SIZE        ;starts with a message structure
        ULONG   hm_HLClass
        UWORD   hm_ID
        ULONG   hm_PB
        ULONG   hm_Flags
        ULONG   hm_Return
        ULONG   hm_UserData1
        ULONG   hm_UserData2
        ULONG   hm_UserData3
        ULONG   hm_UserData4
        ULONG   hm_UserData5
        ULONG   hm_UserData6
        ULONG   hm_UserData7
        ULONG   hm_UserData8
        ULONG   hm_UserData9
        ULONG   hm_UserData10
        ULONG   hm_UserData11
        ULONG   hm_UserData12
        ULONG   hm_UserData13
        ULONG   hm_UserData14
        ULONG   hm_UserData15
        LABEL   HLMsg_SizeOf
        
 STRUCTURE PubRecord,0
        STRUCT  pb_ID,8
        ULONG   pb_Type
        ULONG   pb_Version
        ULONG   pb_CDate
        ULONG   pb_CTime
        ULONG   pb_MDate
        ULONG   pb_MTime
        ULONG   pb_Access
        ULONG   pb_Creator
        STRUCT  pb_Name,32
        STRUCT  pb_Desc,256
        STRUCT  pb_Owner,32
        STRUCT  pb_Group,32
        LABEL   pb_SizeOf

 STRUCTURE PubBlock,pb_SizeOf   ;starts with a PubRecord
;this is PRIVATE data and should not be modified by an application
        ULONG   pr_State
        ULONG   pr_OFlag
        ULONG   pr_LFlag
        ULONG   pr_FOffset
        ULONG   pr_MP
        ULONG   pr_UserMP
        ULONG   pr_Msg
        ULONG   pr_Screen
        ULONG   pr_Curpos
        ULONG   pr_Buffer
        ULONG   pr_Remain
        LABEL   pr_SizeOf
        
 ENDC  ;HOTLINKS_HOTLINKS_I
