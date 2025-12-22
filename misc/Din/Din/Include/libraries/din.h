#ifndef LIBRARIES_DIN_H
#define LIBRARIES_DIN_H 1
/*
**  $Filename: libraries/din.h $
**  $Release: 1.0 revision 3 $
**  $Revision: 3 $
**  $Date: 10 Nov 90 $
**
**	Data INterface specifications
**
**  © Copyright 1990 Jorrit Tyberghein.
**    All Right reserved
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef GRAPHICS_RASTPORT_H
#include <graphics/rastport.h>
#endif

#define DINNAME		"din.library"
#define DINVERSION	36L
#define DINREVISION	3L

/*
 * DinBase. This structure is completely private. Don't depend on
 * anything in this structure.
 * You may read the ObjectList to supply the user with a DinObject
 * directory, but make sure that you use LockDinBase before you
 * start reading.
 */
struct DinBase
  {
    struct Library Library;
    UBYTE Flags,pad0;
    struct List ObjectList;
    struct SignalSemaphore Lock;
    ULONG SegList;
  };


/*
 * The DinObject. ALL fields in this structure are private, unless stated
 * otherwise. Private fields are subject to changes in future versions.
 * Do NOT depend on the size of this structure.
 * It is safer that you ask for a copy of this structure with InfoDinObject
 */
struct DinObject
  {
    struct Node Node;
    UWORD Type;             /* READ ONLY. see below */
    ULONG Flags;            /* READ ONLY. see below */
    APTR PhysObject;        /* READ ONLY. Pointer to physical object */
                            /* corresponding with this DinObject. */
    ULONG Size;             /* READ ONLY. Size of PhysObject */
    struct Task *Owner;     /* READ ONLY. NULL means no owner */
    struct SignalSemaphore Lock;
    struct SignalSemaphore rwLock;
    struct SignalSemaphore delLock;
    struct List LinkList;
  };

/*
 * Copy of the DinObject structure obtained by InfoDinObject.
 * Do NOT depend on the size of this structure, use FreeInfoDinObject to free it.
 */
struct InfoDinObject
  {
    struct Node Node;
    UWORD Type;
    ULONG Flags;
    APTR PhysObject;
    ULONG Size;
    struct Task *Owner;
  };


/*
 * DinObject types.
 */
#define OBJECTDUMMY     0   /* For a dummy object */
#define OBJECTLIST      1   /* Not implemented yet */
#define OBJECTTEXT      2   /* DinObject represents a number of text lines */
#define OBJECTDATA      3   /* Binary data, no interpretation */
#define OBJECTIMAGE     4   /* Graphical object */
#define OBJECTSAMPLE    5   /* Sound sample object, not implemented yet */
#define OBJECTACK       6   /* Acknowledgement object */

/*
 * Flags for DinObject
 */
#define OB_READONLY     1   /* Object is readonly. Only the owner can write */
                            /* on it */
#define OB_DISABLED     2   /* This object is not available for use. All links */
                            /* will fail */
#define OB_READY        4   /* Object is ready to use. All links will succeed */
                            /* and previous waiting links will be activated */
#define OB_DUMMY        8   /* Private */
#define OB_DELETED      16  /* Object is deleted */


/*
 * The Link structure. ALL fields in this structure are private, unless stated
 * otherwise.
 * Do NOT depend on the size of this structure.
 */
struct DinLink
  {
    struct Node Node;
    struct DinObject *Ob;   /* READ ONLY */
    ULONG Flags;            /* READ ONLY. see below */
    struct Task *Task;
    BYTE SigBit;            /* READ ONLY. Use this to wait for notify signals */
    UBYTE pad0;
  };

/*
 * DinLink flags
 */
#define LNK_READY       1   /* Private */
#define LNK_WAITING4OB  2   /* If set the object does not exist yet */
#define LNK_NOTIFYBITS  124
#define LNK_KILLED      4   /* When a signal arrives, you must test this flag */
                            /* to see if the object is removed. */
#define LNK_CHANGE      8   /* When a signal arrives, you can test this flag */
                            /* to see if the object has changed */
#define LNK_NEW         16  /* Our object has just arrived */
#define LNK_ENABLE      32  /* The object is enabled */
#define LNK_DISABLE     64  /* The object is disabled */


/*
 * Physical object for one line of text. This structure is used in ObjectText
 */
struct ObjectLine
  {
    struct ObjectLine *Next;
    char FirstByte;         /* First byte of string, other bytes follow. */
                            /* String is NULL-terminated */
  };

/*
 * The physical text object. This structure is public
 */
struct ObjectText
  {
    ULONG Lines;            /* The number of lines in this object */
    struct ObjectLine *FirstLine;
  };

/*
 * Physical object for simple data.
 */
struct ObjectData
  {
    ULONG Size;             /* Size of data */
    APTR Data;              /* Pointer to data */
  };

/*
 * Physical object for a graphical image. This structure is public
 */
struct ObjectImage
  {
    struct RastPort *rp;    /* RPort for your image */
    struct Rectangle Rect;  /* This rectangle defines a rectangle in the */
                            /* RPort for your image */
  };

#endif
