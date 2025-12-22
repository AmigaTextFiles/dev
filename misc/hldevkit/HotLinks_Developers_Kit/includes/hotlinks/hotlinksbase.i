***************************************************************
*                                                             *
*   hotlinksbase.i - definition of the hotlink library base   *
*                                                             *
***************************************************************

 IFND HOTLINK_HOTLINKSBASE_I
HOTLINK_HOTLINKSBASE_I equ 1
        
   INCDIR "include:"
        
   IFND EXEC_TYPES_I
        INCLUDE "exec/types.i"
   ENDC
 
   IFND EXEC_LIST_I
        INCLUDE "exec/lists.i"
   ENDC
 
   IFND EXEC_LIBRARIES_I
        INCLUDE "exec/libraries.i"
   ENDC


;library data structure
   STRUCTURE HotLinksBase,LIB_SIZE
        UBYTE   hl_Flags
        UBYTE   hl_Pad
        ULONG   hl_SysLib
        ULONG   hl_DosLib
        ULONG   hl_SegList
        ULONG   hl_ResPort
        LABEL   HotLinksBase_SizeOf

 ENDC ;HOTLINK_HOTLINKSBASE_I
