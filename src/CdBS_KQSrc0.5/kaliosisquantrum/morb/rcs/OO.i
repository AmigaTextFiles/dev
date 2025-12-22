head	0.9;
access;
symbols;
locks
	MORB:0.9; strict;
comment	@* @;


0.9
date	98.01.03.17.36.01;	author MORB;	state Exp;
branches;
next	0.8;

0.8
date	97.12.31.19.21.57;	author MORB;	state Exp;
branches;
next	0.7;

0.7
date	97.12.15.23.07.17;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	97.12.15.23.05.34;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.12.15.23.02.15;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.12.15.22.57.52;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.12.15.21.40.01;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.12.14.19.54.22;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.12.14.19.49.20;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.12.14.11.34.45;	author MORB;	state Exp;
branches;
next	;


desc
@@


0.9
log
@Ajout de DTA_Parent dans rootclass
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Object oriented support include file
* $Id: OO.i 0.8 1997/12/31 19:21:57 MORB Exp MORB $
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
* The table is constituted of one root object entry, which may contain
* entries for subobjects, and so on.
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
@


0.8
log
@Ajout de plains de trucs bien
@
text
@d4 1
a4 1
* ©1997, CdBS Software (MORB)
d6 1
a6 1
* $Id: OO.i 0.7 1997/12/15 23:07:17 MORB Exp MORB $
d245 1
@


0.7
log
@Correctufiu un immondo bugg laid pabo dans macro une (<-- euh 2 derniers mots swap)
@
text
@d6 1
a6 1
* $Id: OO.i 0.6 1997/12/15 23:05:34 MORB Exp MORB $
d90 4
d95 1
a95 1
DOMETHOD macro     ; Method ID (Dn),Object (An)  Note : trashes a0 & a1
d105 11
a115 1
DOMETHODI macro    ; #Method ID,Object (An)  Note : trashes a0 & a1
d124 10
d236 1
a236 1
NULLClass_ID       = -4      ; Just to fake the CLASS macro
d238 1
a238 1
         CLASS     RootClass,NULLClass
d247 32
@


0.6
log
@Cleaned up more stuff...
@
text
@d6 1
a6 1
* $Id: OO.i 0.5 1997/12/15 23:02:15 MORB Exp MORB $
d64 1
a64 1
DATA_OFST          SET       1
@


0.5
log
@Cleaned up some stuff
@
text
@d6 1
a6 1
* $Id: OO.i 0.4 1997/12/15 22:57:52 MORB Exp MORB $
d35 1
a35 1
* There are referenced by a base address. The base address points to a
d60 1
a60 1
CLASS    macro     ; Name
@


0.4
log
@Implémenation des trucs pour les objets chaînés (RootClass)
@
text
@d6 1
a6 1
* $Id: OO.i 0.3 1997/12/15 21:40:01 MORB Exp MORB $
d9 1
a9 1
***** Class initialization structure *****
@


0.3
log
@Tout débuggu, macros namélioru, macros nimplémentu Hihahiha
@
text
@d6 1
a6 1
* $Id: OO.i 0.2 1997/12/14 19:54:22 MORB Exp MORB $
d73 2
a74 2
\2                 EQU       DATA_OFST
\1_\2              EQU       DATA_OFST<<16|CLASS_ID
d79 2
a80 2
\2                 EQU       DATA_OFST
\1_\2              EQU       DATA_OFST<<16|CLASS_ID
d85 2
a86 2
\2                 EQU       DATA_OFST
\1_\2              EQU       DATA_OFST<<16|CLASS_ID
d217 5
@


0.2
log
@Petit détail de présentation
@
text
@d6 1
a6 1
* $Id: OO.i 0.1 1997/12/14 19:49:20 MORB Exp MORB $
d36 2
a37 1
* longword that will be used by the RPL, followed by the data table.
d61 1
d91 2
a92 2
DOMETHOD macro     ; Method ID (Dn),Object (An)  Note : Trashes a0 & a1
         IFNC      \2,'a0'
d96 1
a96 1
         move.l    (a0,\1.w),a1
d101 2
a102 2
DOMETHODI macro    ; #Method ID,Object (An)  Note : Trashes a0,a1 & d0
         IFNC      \2,'a0'
d106 2
a107 4
         move.l    \1,d0
         move.l    (a0,d0.w),a1
         swap      d0
         jsr       (a1,d0.w)
d110 101
d212 1
a212 1
RootClass_ID       = 4
d214 1
a214 1
         CLASS     RootClass
@


0.1
log
@Implémenation d'un peu tout : structures, macros, et définitions pour le rootclass. Benvlà
@
text
@d6 1
a6 1
* $Id: OO.i 0.0 1997/12/14 11:34:45 MORB Exp MORB $
d110 1
a110 1

@


0.0
log
@Aaaaaaaaaaaleluhia
@
text
@d6 1
a6 1
* $Id$
d8 109
@
