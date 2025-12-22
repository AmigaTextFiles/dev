*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Object oriented support include file
* $Id: OO.i 0.9 1998/01/03 17:36:01 MORB Exp MORB $
*

***** Class structure *****
         rsreset
Class              rs.b      0
ci_ClassObj        rs.l      1         ; Initialized by InitClass()
ci_SuperClass      rs.l      1         ; Address of superclass
ci_InstanceSize    rs.l      1         ; Size of an instance (set by
                                       ; InitClass)
ci_BaseOffset      rs.l      1         ; Offset of the base address from
                                       ; the beginning of the instance
                                       ; (Init-ed by InitClass)
ci_JumpTable_Size  rs.l      1         ; Length of the jumptable (idem)
ci_Data_Size       rs.l      1         ; Length of all the data blocks
ci_Generation      rs.l      1         ; Generation number of the class
                                       ; (ie. number of classes successively
                                       ; herited by this one)
ci_DataLength      rs.l      1         ; Length of instance data
ci_FuncTable       rs.l      1         ; Pointer to the functions table
ci_Datas           rs.l      1         ; Pointer to defaults data values
ci_ClassData       rs.l      1         ; A pointer that is passed to the
                                       ; functions for their own use
ci_InitCode        rs.l      1         ; Optional init routine
ci_SizeOf          rs.b      0

***** Objects *********************************************************
*
* The objects are stored in memory as follows :
* They are referenced by a base address. The base address points to a
* node structure used to link many objects together, followed by the
* class address and the data table.
* The data table contains the address of the data block of each herited
* class. The data blocks are stored immediately after the data table.
* Before the base address lies the function table. It is similar to the
* data table, except that it is stored in reverse order, in order to be
* accessed with negative offsets. It is preceded by the jump table.
*
* Each data field in an object is referenced by a longword. It is
* splitted in two words : the lower word contains the offset in the
* data table to the adress of the block where the data lies, while
* the upper word is the offset of the data into the data block.
*
* Methods are referenced same way as datas : the lower word is a
* negative offset to the beginning of the jumptable where the method
* lies, while the upper word is the negative offset of this method
* in the jumptable.
*
***********************************************************************


***** Macros **********************************************************

**** Class definition macros ****
CLASS    macro     ; Name,SuperClassName
\1_ID              EQU       \2_ID+4
CLASS_ID           SET       \1_ID
METHOD_OFST        SET       0
DATA_OFST          SET       0
         endm

METHOD   macro     ; Name
\1                 EQU       METHOD_OFST<<16|(-CLASS_ID & $ffff)
METHOD_OFST        SET       METHOD_OFST-6
         endm

DATA_BYTE macro    ; Prefix,Name,Num
\1_\2              EQU       DATA_OFST
\2                 EQU       DATA_OFST<<16|CLASS_ID
DATA_OFST          SET       DATA_OFST+\3
         endm

DATA_WORD macro    ; Prefix,Name,Num
\1_\2              EQU       DATA_OFST
\2                 EQU       DATA_OFST<<16|CLASS_ID
DATA_OFST          SET       DATA_OFST+2*\3
         endm

DATA_LONG macro    ; Prefix,Name,Num
\1_\2              EQU       DATA_OFST
\2                 EQU       DATA_OFST<<16|CLASS_ID
DATA_OFST          SET       DATA_OFST+4*\3
         endm

DATA_SIZE macro    ; Name
\1                 EQU       DATA_OFST
         endm

**** Method invoking macros ****
DOMTD    macro     ; Method ID (Dn),Object (An)  Note : trashes a0 & a1
         IFNC      "\2","a0"
         move.l    \2,a0
         ENDC

         move.l    -4(a0,\1.w),a1
         swap      \1
         jsr       (a1,\1.w)
         endm

DOMTDJ   macro
         IFNC      "\2","a0"
         move.l    \2,a0
         ENDC

         move.l    -4(a0,\1.w),a1
         swap      \1
         jmp       (a1,\1.w)
         endm

DOMTDI   macro     ; #Method ID,Object (An)  Note : trashes a0 & a1
         IFNC      "\2","a0"
         move.l    \2,a0
         ENDC

         move.l    -4+(\1<<16>>16)(a0),a1
         jsr       (\1>>16)(a1)
         endm

DOMTDJI  macro     ; #Method ID,Object (An)  Note : trashes a0 & a1
         IFNC      "\2","a0"
         move.l    \2,a0
         ENDC

         move.l    -4+(\1<<16>>16)(a0),a1
         jmp       (\1>>16)(a1)
         endm


**** Data access macros ****
LBLOCKEA macro     ; Data or class ID (Dn),Object (An),Dest (Rn)
         move.l    12(\2,\1.w),\3
         endm

LBLOCKEAI macro    ; #Data or class ID,Object (An),Dest (Rn)
         move.l    12+(\1<<16>>16)(\2),\3
         endm

LDATAEA  macro     ; Data ID (Dn),Object (An),Dest (An)
                   ; Note : swaps Dn
         move.l    12(\2,\1.w),\3
         swap      \1
         add.w     \1,\3
         endm

LDATAEAI macro     ; #Data ID,Object (An),Dest (An)
         move.l    12+(\1<<16>>16)(\2),\3
         add.l     #\1>>16,\3
         endm

LDATAB   macro     ; Data ID (Dn),Object (An),Dest (Rn)
                   ; Note : swaps Dn & trashes a0
         move.l    12(\2,\1.w),a0
         swap      \1
         move.b    (a0,\1.w),\3
         endm

LDATABI  macro     ; #Data ID,Object (An),Dest (Rn)
                   ; Note : trashes a0
         move.l    12+(\1<<16>>16)(\2),a0
         move.b    (\1>>16)(a0),\3
         endm

LDATAW   macro     ; Data ID (Dn),Object (An),Dest (Rn)
                   ; Note : swaps Dn & trashes a0
         move.l    12(\2,\1.w),a0
         swap      \1
         move.w    (a0,\1.w),\3
         endm

LDATAWI  macro     ; #Data ID,Object (An),Dest (Rn)
                   ; Note : trashes a0
         move.l    12+(\1<<16>>16)(\2),a0
         move.w    (\1>>16)(a0),\3
         endm

LDATAL   macro     ; Data ID (Dn),Object (An),Dest (Rn)
                   ; Note : swaps Dn & trashes a0
         move.l    12(\2,\1.w),a0
         swap      \1
         move.l    (a0,\1.w),\3
         endm

LDATALI  macro     ; #Data ID,Object (An),Dest (Rn)
                   ; Note : trashes a0
         move.l    12+(\1<<16>>16)(\2),a0
         move.l    (\1>>16)(a0),\3
         endm


SDATAB   macro     ; Source,Data ID (Dn),Object (An)
                   ; Note : swaps Dn & trashes a0
         move.l    12(\3,\2.w),a0
         swap      \2
         move.b    \1,(a0,\2.w)
         endm

SDATABI  macro     ; Source,Data ID (Dn),Object (An)
                   ; Note : trashes a0
         move.l    12+(\2<<16>>16)(\3),a0
         move.b    \1,(\2>>16)(a0)
         endm

SDATAW   macro     ; Source,Data ID (Dn),Object (An)
                   ; Note : swaps Dn & trashes a0
         move.l    12(\3,\2.w),a0
         swap      \2
         move.w    \1,(a0,\2.w)
         endm

SDATAWI  macro     ; Source,Data ID (Dn),Object (An)
                   ; Note : trashes a0
         move.l    12+(\2<<16>>16)(\3),a0
         move.w    \1,(\2>>16)(a0)
         endm

SDATAL   macro     ; Source,Data ID (Dn),Object (An)
                   ; Note : swaps Dn & trashes a0
         move.l    12(\3,\2.w),a0
         swap      \2
         move.l    \1,(a0,\2.w)
         endm

SDATALI  macro     ; Source,Data ID (Dn),Object (An)
                   ; Note : trashes a0
         move.l    12+(\2<<16>>16)(\3),a0
         move.l    \1,(\2>>16)(a0)
         endm


***** Defs for RootClass **********************************************
DummyClass_ID       = -4     ; Just to fake the CLASS macro

         CLASS     RootClass,DummyClass
         METHOD    MTD_New
         METHOD    MTD_Dispose
         METHOD    MTD_AddMember
         METHOD    MTD_Add
         METHOD    MTD_Remove

         DATA_BYTE root,DTA_List,MLH_SIZE
         DATA_LONG root,DTA_Parent,1
         ;DATA_BYTE root,RCSize,0

***** Objects trees ***************************************************
*
* Objects tree are data tables that describe a complete tree of objects
* and subobjects. It is useful for example to define a gui with groups,
* subgroups, and buttons.
*
* The table is made of one root object entry, which may contain entries
* for subobjects, and so on.
*
* An object entry looks like that :
* L OBJ_Begin
* L Class
* L DataID
* L Data
* L DataID
* L Data
* .
* .
* .
* L OBJ_End
*
* Just before OBJ_END it is possible to insert 1 or more objects
* entries to define sub objects
*
* Instead of OBJ_End, it is possible to use OBJ_Store followed by the
* address of the pointer to store the address of the preceding object
*
***********************************************************************

OBJ_Begin          = 0
OBJ_End            = -1
OBJ_Store          = -2
