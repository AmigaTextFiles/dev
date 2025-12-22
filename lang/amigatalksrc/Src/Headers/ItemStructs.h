/****h* AmigaTalk/ItemStructs.h [1.6] **********************************
* 
* NAME
*    ItemStructs.h  structures for the AList variable.
*
*
************************************************************************
*
*/

#if      !(ITEM_STRUCTS_H)
# define   ITEM_STRUCTS_H  1

# ifndef  EXEC_EXEC_H
#  include <exec/exec.h>
# endif

# ifndef  INTUITION_INTUITIONBASE_H
#  include <intuition/intuitionbase.h>
# endif

# ifndef  INTUITION_INTUITION_H
#  include <intuition/intuition.h>
# endif

# ifndef	IFF_IFFPARSE_H
#  include <libraries/iffparse.h>
# endif

# include <devices/gameport.h>

# ifndef CONSTANTS_H
#  include "Constants.h"
# endif

# ifndef StrBfPtr
#  define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
# endif

# ifndef      MAX_ARGS
#  define     MAX_ARGS       15
#  define     ARG_SIZE       80
# endif


/* The ln_Name field of the Nodes of the master AmigaTalk
** List struct - AList point to item_struct's:
*/
/*
PUBLIC struct item_struct {

   struct item_struct *is_Next;
   struct item_struct *is_Prev;
   char               *is_Name;
   void               *is_Data;
   LONG                is_Type;
   LONG                is_Pri;
};

typedef struct item_struct ITEM_STRUCT, *IS_Ptr; 


struct list_header {
    
   struct item_struct *Head;
   struct item_struct *Tail;
   LONG                ItemCount;
};

typedef struct list_header LIST_HEADER, *LH_Ptr;
*/   

/* Since Commodore didn't supply the following structure that 
** DisplayAlert() expects for the Message String, I guess I'll
** have to make one myself & cast the struct into a UBYTE * that
** DisplayAlert() expects: 
*/

struct AlertString   {

   UWORD    as_X;
   UBYTE    as_Y;
   UBYTE    as_String[ 256 ];
   UBYTE    as_Cont;        /* in case the user uses a 255 byte string! */
};

struct eAlert      {

   struct AlertString   *AlertString;
   int                  AlertNumber;
   int                  AlertHeight;
};

/*
struct eARexxPort {
   
   struct RexxMsgPort   *ARexxPortPtr;
   struct RexxMsg       *ARexxMsgPtr;
};

struct eSCSI {

   struct IOStdReq *io;
   struct MsgPort  *mp;
   struct SCSICmd   cmd;
   UBYTE            command[12];    
};
*/

/* Some of eIFF might be deleted after all AmigaTalk primitives have
** been debugged:
*/

struct eIFF        {
   
   struct IFFHandle        *IFFHandlePtr;
   struct IFFStreamCmd     *IFFStreamCmdPtr;
   struct ContextNode      *ContextNodePtr;
   struct CollectionItem   *CollectionItemPtr;
   struct LocalContextItem *LocalContextItemPtr;
   struct StoredProperty   *StoredPropertyPtr;
   struct ClipboardHandle  *ClipboardHandlePtr;

   int                      StreamType; /* 0 = DOS, 1 = Clipboard, 2 = Other */
};

struct eSerial    {

   struct IOExtSer   *SerialPtr;
   struct MsgPort    *SerialMsgPortPtr;
   char              *ReadBuffer;
   char              *WriteBuffer;
   int                ReadBufLen;
   int                WriteBufLen; 
};

struct eTimer     {

   struct MsgPort     *TimeMsgPort;
   struct timerequest  TimerPtr;
   struct EClockVal    EClockValPtr;
};

struct eTrackDisk {

   struct DriveGeometry *etd_DG;
   struct MsgPort       *etd_MsgPort;
   struct IOExtTD       *etd_IO;
   char                 *etd_trkbuff;
};

struct eGamePort {

   struct MsgPort         *egp_MsgPort;
   struct IOStdReq        *egp_IO;
   struct InputEvent      *egp_IE;
   struct GamePortTrigger *egp_Gpt;
   BYTE                    egp_PrevType; // Usually GPCT_NOCONTROLLER.
};

# define  MAXCLIPBOARD   16   
# define  MAXCONSOLE     16 
# define  MAXGAMEPORTS   8   
# define  MAXSERIAL      8
# define  MAXTIMER       16
# define  MAXDISKS       8  
# define  MAXFILES       128

#endif

/* ---------------- END of ItemStructs.h file ------------------------- */
