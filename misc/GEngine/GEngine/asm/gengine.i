**************
* gengine.i  *
*            *
* Structures *
**************

   IFND  GENGINE_I
GENGINE_I SET 1

   IFND  EXEC_TYPES_I
   INCLUDE  "exec/types.i"
   ENDC

   INCLUDE  "exec/nodes.i"

;-----------
; PenInfo
;-----------

   STRUCTURE PenInfo,0
   UWORD   PI_Version    ;Version
   UWORD   PI_Flags      ;Flags must be zero by now
   UWORD   PI_Pad1
   UWORD   PI_NumPens    ;# of pens
   LONG    PI_PenArray   ;Array of pen #
   LONG    PI_ColorMap   ;ColorMapPtr
   STRUCT  PI_Reserved,32 ;Must be zero
   LABEL   PenInfo_SIZEOF

;--------------------------------------------
;Memory Pool structure for memory management
;--------------------------------------------
   STRUCTURE GE_MemPool,LH_SIZE
   LONG    mp_MemTree    ;for fast searches
   LONG    mp_MemFree    ;Total Free Memory on the pool
   LONG    mp_MemTotal   ;Total size of the pool
   LONG    mp_Size       ;Size of each memory chunk
   LONG    mp_Attr       ;Memory Attributes
   UWORD   mp_FreeChunks ;Number of totally free chunks
   UWORD   mp_ColapseNum ;Maximun number of free chunks allowed
   LABEL   MP_SIZEOF

;---------------------------------
;AVL Node structure for AVL trees
;---------------------------------
   STRUCTURE AVLNode,0
   LONG    an_Key
   LONG    an_Parent
   LONG    an_Left       ;Smaller
   LONG    an_Right      ;Greater
   UWORD   an_Balance
   UWORD   an_pad1       ;Reserved
   LABEL   AN_SIZE

;----------------
; Hook Structure
;----------------
   STRUCTURE Hook,MLN_SIZE
   LONG  h_Entry         ;assembler entry point
   LONG  h_SubEntry      ;often HLL entry point
   LONG  h_Data          ;owner specific
   LABEL H_SIZE

;-------------------
; GEClass structure
;-------------------
 STRUCTURE GECLASS,0
   STRUCT gc_Dispatcher,H_SIZE
   LONG  gc_Reserved		; must be 0

   APTR  gc_Super
   APTR  gc_ID		; pointer to null-terminated string

    ; where within an object is the instance data for this class?
   UWORD gc_InstOffset
   UWORD gc_InstSize

   LONG  gc_UserData		; per-class data of your choice
   LONG  gc_SubclassCount	; how many direct subclasses?
   LONG  gc_ObjectCount	; how many objects created of this class?
   LONG  gc_Flags
   LABEL GC_SIZE

; defined values of gc_Flags
GCB_INLIST EQU 0
GCF_INLIST EQU $00000001	; class in in public class list

; dispatched method ID's

GM_NEW EQU $00000101 ; 'object' parameter is "true class"
GM_DISPOSE EQU $00000102 ; delete self (no parameters)
GM_SET EQU $00000103 ; set attribute (list)
GM_GET EQU $00000104 ; return single attribute value
GM_ADDTAIL EQU $00000105 ; add self to a List
GM_REMOVE EQU $00000106 ; remove self from list (no parameters)
GM_NOTIFY EQU $00000107 ; send to self: notify dependents
GM_UPDATE EQU $00000108 ; notification message from someone
GM_ADDMEMBER EQU $00000109 ; used by various classes with lists
GM_REMMEMBER EQU $0000010A ; used by various classes with lists

;--GObject

    STRUCTURE _GObject,0
       STRUCT go_Node,MLN_SIZE
       APTR   go_Class
    LABEL  _gobject_SIZEOF

;---------------------------------------------------------------------------
; Tags are a general mechanism of extensible data arrays for parameter
; specification and property inquiry. In practice, tags are used in arrays,
; or chain of arrays.

   STRUCTURE TagItem,0
	ULONG	ti_Tag		; identifies the type of the data
	ULONG	ti_Data		; type-specific data
   LABEL ti_SIZEOF

; constants for Tag.ti_Tag, control tag values
TAG_DONE   equ 0  ; terminates array of TagItems. ti_Data unused
TAG_END	   equ 0  ; synonym for TAG_DONE
TAG_IGNORE equ 1  ; ignore this item, not end of array
TAG_MORE   equ 2  ; ti_Data is pointer to another array of TagItems
		  ; note that this tag terminates the current array
TAG_SKIP   equ 3  ; skip this and the next ti_Data items

; differentiates user tags from control tags
TAG_USER   equ $80000000

;------------------
; WinList
;------------------

   STRUCTURE WinList,MLN_SIZE
    UWORD   wl_ObjCount    ;Number of objects (gadgets) attached to window
    LONG    wl_ActiveObj   ;Current object (gadget) the user is playing with
   LABEL wl_SIZEOF

   ENDC