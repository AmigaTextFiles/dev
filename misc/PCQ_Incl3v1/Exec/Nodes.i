
{
		exec/nodes.h $
 }

TYPE

{ *  List Node Structure.  Each member in a list starts with a Node * }

  Node = Record
    ln_Succ,			{ * Pointer to next (successor) * }
    ln_Pred  : ^Node;		{ * Pointer to previous (predecessor) * }
    ln_Type,
    ln_Pri   : Byte;		{ * Priority, for sorting * }
    ln_Name  : String;		{ * ID string, null terminated * }
  End;	{ * Note: word aligned * }
  NodePtr = ^Node;



{ * minimal node -- no type checking possible * }

  MinNode = Record
    mln_Succ,
    mln_Pred  : ^MinNode;
  End;
  MinNodePtr = ^MinNode;



{ *
** Note: Newly initialized IORequests, and software interrupt structures
** used with Cause(), should have type NT_UNKNOWN.  The OS will assign a type
** when they are first used.
* }

{ *----- Node Types for LN_TYPE -----* }

Const

  NT_UNKNOWN	  =  0;
  NT_TASK	  =  1;  { * Exec task * }
  NT_INTERRUPT	  =  2;
  NT_DEVICE	  =  3;
  NT_MSGPORT	  =  4;
  NT_MESSAGE	  =  5;  { * Indicates message currently pending * }
  NT_FREEMSG	  =  6;
  NT_REPLYMSG	  =  7;  { * Message has been replied * }
  NT_RESOURCE	  =  8;
  NT_LIBRARY	  =  9;
  NT_MEMORY	  = 10;
  NT_SOFTINT	  = 11;  { * Internal flag used by SoftInits * }
  NT_FONT	  = 12;
  NT_PROCESS	  = 13;  { * AmigaDOS Process * }
  NT_SEMAPHORE	  = 14;
  NT_SIGNALSEM	  = 15;  { * signal semaphores * }
  NT_BOOTNODE	  = 16;
  NT_KICKMEM	  = 17;
  NT_GRAPHICS	  = 18;
  NT_DEATHMESSAGE = 19;

  NT_USER	  = 254;  { * User node types work down from here * }
  NT_EXTENDED	  = 255;

