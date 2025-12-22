	IFND LIBRARIES_DIN_I
LIBRARIES_DIN_I SET 1
**
**  $Filename: libraries/din.i $
**  $Release: 1.0 revision 3 $
**  $Revision: 3 $
**  $Date: 10 Nov 90 $
**
**	Data INterface specifications
**
**  © Copyright 1990 Jorrit Tyberghein.
**    All Right reserved
**

	IFND EXEC_TYPES_I
	INCLUDE "exec/types.i"
	ENDC

	IFND EXEC_NODES_I
	INCLUDE "exec/nodes.i"
	ENDC

	IFND EXEC_LISTS_I
	INCLUDE "exec/lists.i"
	ENDC

	IFND EXEC_SEMAPHORES_I
	INCLUDE "exec/semaphores.i"
	ENDC

	IFND GRAPHICS_GFX_I
	INCLUDE "graphics/gfx.i"
	ENDC


DINNAME 	macro
		dc.b	"din.library",0
		endm
DINVERSION	equ	36
DINREVISION	equ	3

 *
 * DinBase. This structure is completely private. Don't depend on
 * anything in this structure.
 * You may read the ObjectList to supply the user with a DinObject
 * directory, but make sure that you use LockDinBase before you
 * start reading.
 *
  STRUCTURE DinBase,LIB_SIZE
	UBYTE	din_Flags
	UBYTE	din_pad0
	STRUCT	din_ObjectList,LH_SIZE
	STRUCT	din_Lock,SS_SIZE
	ULONG	din_SegList
	LABEL	din_SIZE


 *
 * The DinObject. ALL fields in this structure are private, unless stated
 * otherwise. Private fields are subject to changes in future versions.
 * Do NOT depend on the size of this structure.
 * It is safer that you ask for a copy of this structure with InfoDinObject
 *
  STRUCTURE DinObject,LN_SIZE
	UWORD	do_Type		* READ ONLY. see below
	ULONG	do_Flags	* READ ONLY. see below
	APTR	do_PhysObject	* READ ONLY. Pointer to physical object
				* corresponding with this DinObject.
	ULONG	do_Size		* READ ONLY. Size of PhysObject
	APTR	do_Owner	* READ ONLY. NULL means no owner
	STRUCT	do_Lock,SS_SIZE
	STRUCT	do_rwLock,SS_SIZE
	STRUCT	do_delLock,SS_SIZE
	STRUCT	do_LinkList,LH_SIZE
	LABEL	do_SIZE		* Private !!!

 *
 * Copy of the DinObject structure obtained by InfoDinObject.
 * Do NOT depend on the size of this structure, use FreeInfoDinObject to free it.
 *
  STRUCTURE IDinObject,LN_SIZE
	UWORD	ido_Type
	ULONG	ido_Flags
	APTR	ido_PhysObject
	ULONG	ido_Size
	APTR	ido_Owner
	LABEL	ido_SIZE

 *
 * DinObject types.
 *
OBJECTDUMMY	equ	0	* For a dummy object
OBJECTLIST	equ	1	* Not implemented yet
OBJECTTEXT	equ	2	* DinObject represents a number of text lines
OBJECTDATA	equ	3	* Binary data, no interpretation
OBJECTIMAGE	equ	4	* Graphical object
OBJECTSAMPLE	equ	5	* Sound sample object, not implemented yet
OBJECTACK	equ	6	* Acknowledgement object

 *
 * Flags for DinObject
 *
OB_READONLY	equ	1	* Object is readonly. Only the owner can write
				* on it
OB_DISABLED	equ	2	* This object is not available for use. All links
				* will fail
OB_READY	equ	4	* Object is ready to use. All links will succeed
				* and previous waiting links will be activated
OB_DUMMY	equ	8	* Private
OB_DELETED	equ	16	* Object is deleted


 *
 * The Link structure. ALL fields in this structure are private, unless stated
 * otherwise.
 * Do NOT depend on the size of this structure.
 *
  STRUCTURE DinLink,LN_SIZE
	APTR	dl_Ob		* READ ONLY
	ULONG	dl_Flags	* READ ONLY. see below
	APTR	dl_Task
	BYTE	dl_SigBit	* READ ONLY. Use this to wait for notify signals
	UBYTE	dl_pad0
	LABEL	dl_SIZE		* Private !!!

 *
 * DinLink flags
 *
LNK_READY	equ	1	* Private
LNK_WAITING4OB	equ	2	* If set the object does not exist yet
LNK_NOTIFYBITS	equ	124
LNK_KILLED	equ	4	* When a signal arrives, you must test this flag
				* to see if the object is removed.
LNK_CHANGE	equ	8	* When a signal arrives, you can test this flag
				* to see if the object has changed
LNK_NEW		equ	16	* Our object has just arrived
LNK_ENABLE	equ	32	* The object is enabled
LNK_DISABLE	equ	64	* The object is disabled

 *
 * Physical object for one line of text. This structure is used in ObjectText
 *
  STRUCTURE ObjectLine,0
	APTR	ol_Next		* Pointer to next line
	UBYTE	ol_FirstByte	* First byte of string, other bytes follow.
				* String is NULL-terminated.
	LABEL	ol_SIZE

 *
 * The physical text object. This structure is public
 *
  STRUCTURE ObjectText,0
	ULONG	ot_Lines	* The number of lines in this object
	APTR	ot_FirstLine	* Pointer to the first line of text
	LABEL	ot_SIZE

 *
 * Physical object for simple data.
 *
  STRUCTURE ObjectData,0
	ULONG	od_Size		* Size of data
	APTR	od_Data		* Pointer to data
	LABEL	od_SIZE

 *
 * Physical object for a graphical image. This structure is public
 *
  STRUCTURE ObjectImage,0
	APTR	oi_rp			* RastPort for your image
	STRUCT	oi_Rect,ra_SIZEOF	* This rectangle defines a rectangle in the
					* RastPort for your image
	LABEL	oi_SIZE

	ENDC
