/****h* AmigaTalk/IStructs.h [2.3] ************************************
* 
* NAME
*    IStructs.h  structures for the AList variable.
***********************************************************************
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

# ifndef    LIBRARIES_IFF_IFFPARSE_H
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
#  define     MAX_ARGS       15 // ARexx stuff
#  define     ARG_SIZE       80
# endif


/* Since Commodore didn't supply the following structure that 
** DisplayAlert() expects for the Message String, I guess I'll
** have to make one myself & cast the struct into a UBYTE * that
** DisplayAlert() expects: 
*/

/*
struct AlertString   {

   UWORD    as_X;
   UBYTE    as_Y;
   UBYTE    as_String[ 512 ];
   UBYTE    as_Cont;        // in case the user uses a 512 byte string!
};

struct eAlert      {

   struct AlertString   *AlertString;
   int                  AlertNumber;
   int                  AlertHeight;
};
*/

struct eSerial    {

   struct IOExtSer *SerialPtr;
   struct MsgPort  *SerialMsgPortPtr;
   char            *ReadBuffer;
   char            *WriteBuffer;
   int              ReadBufLen;
   int              WriteBufLen; 
};

struct eTimer     {

   struct MsgPort     *TimeMsgPort;
   struct timerequest *TimerPtr;
   struct EClockVal    EClockValPtr;
};

struct eTrackDisk {

   struct DriveGeometry *etd_DG;
   struct MsgPort       *etd_MsgPort;
   struct IOExtTD       *etd_IO;
   char                 *etd_trkbuff;
   char                 *etd_DiskName;
};

struct eGamePort {

   struct MsgPort         *egp_MsgPort;
   struct IOStdReq        *egp_IO;
   struct InputEvent      *egp_IE;
   struct GamePortTrigger *egp_Gpt;
   BYTE                    egp_PrevType; // Usually GPCT_NOCONTROLLER.
};

# define  MAXCLIPBOARD   256   
# define  MAXGAMEPORTS   8   
# define  MAXSERIAL      8
# define  MAXTIMER       16
# define  MAXDISKS       8  

#endif

/* ---------------- END of IStructs.h file ------------------------- */
