/* $Id: classusr.h 25583 2007-03-26 23:38:53Z dariusb $ */
OPT NATIVE, PREPROCESS
MODULE 'target/utility/hooks', 'target/utility/tagitem'
MODULE 'target/intuition/intuition_shared1', 'target/exec/lists', 'target/exec/types'
{#include <intuition/classusr.h>}
NATIVE {INTUITION_CLASSUSR_H} CONST

TYPE INTUIOBJECT IS NATIVE {Object} VALUE
TYPE CLASSID     IS NATIVE {ClassID} ARRAY


    NATIVE {Object} CONST

    NATIVE {ClassID} CONST

    NATIVE {_struct_Msg} OBJECT msg
        {MethodID}	methodid	:/*STACKULONG*/ ULONG
    ENDOBJECT /**Msg*/
NATIVE {Msg} DEF

NATIVE {ROOTCLASS}     CONST
#define ROOTCLASS rootclass
STATIC rootclass     = 'rootclass'
NATIVE {IMAGECLASS}    CONST
#define IMAGECLASS imageclass
STATIC imageclass    = 'imageclass'
NATIVE {FRAMEICLASS}   CONST
#define FRAMEICLASS frameiclass
STATIC frameiclass   = 'frameiclass'
NATIVE {SYSICLASS}     CONST
#define SYSICLASS sysiclass
STATIC sysiclass     = 'sysiclass'
NATIVE {FILLRECTCLASS} CONST
#define FILLRECTCLASS fillrectclass
STATIC fillrectclass = 'fillrectclass'
NATIVE {GADGETCLASS}   CONST
#define GADGETCLASS gadgetclass
STATIC gadgetclass   = 'gadgetclass'
NATIVE {PROPGCLASS}    CONST
#define PROPGCLASS propgclass
STATIC propgclass    = 'propgclass'
NATIVE {STRGCLASS}     CONST
#define STRGCLASS strgclass
STATIC strgclass     = 'strgclass'
NATIVE {BUTTONGCLASS}  CONST
#define BUTTONGCLASS buttongclass
STATIC buttongclass  = 'buttongclass'
NATIVE {FRBUTTONCLASS} CONST
#define FRBUTTONCLASS frbuttonclass
STATIC frbuttonclass = 'frbuttonclass'
NATIVE {GROUPGCLASS}   CONST
#define GROUPGCLASS groupgclass
STATIC groupgclass   = 'groupgclass'
NATIVE {ICCLASS}       CONST
#define ICCLASS icclass
STATIC icclass       = 'icclass'
NATIVE {MODELCLASS}    CONST
#define MODELCLASS modelclass
STATIC modelclass    = 'modelclass'
NATIVE {ITEXTICLASS}   CONST
#define ITEXTICLASS itexticlass
STATIC itexticlass   = 'itexticlass'
NATIVE {POINTERCLASS}  CONST
#define POINTERCLASS pointerclass
STATIC pointerclass  = 'pointerclass'

/* public classes existing only in AROS but not AmigaOS */
NATIVE {MENUBARLABELCLASS} CONST
#define MENUBARLABELCLASS menubarlabelclass
STATIC menubarlabelclass = 'menubarlabelclass'
NATIVE {WINDECORCLASS}	  CONST
#define WINDECORCLASS windecorclass
STATIC windecorclass	  = 'windecorclass'
NATIVE {SCRDECORCLASS}	  CONST
#define SCRDECORCLASS scrdecorclass
STATIC scrdecorclass	  = 'scrdecorclass'
NATIVE {MENUDECORCLASS}    CONST
#define MENUDECORCLASS menudecorclass
STATIC menudecorclass    = 'menudecorclass'

NATIVE {OM_Dummy}     CONST OM_DUMMY     = $0100
NATIVE {OM_NEW}       CONST OM_NEW       = (OM_DUMMY + 1)
NATIVE {OM_DISPOSE}   CONST OM_DISPOSE   = (OM_DUMMY + 2)
NATIVE {OM_SET}       CONST OM_SET       = (OM_DUMMY + 3)
NATIVE {OM_GET}       CONST OM_GET       = (OM_DUMMY + 4)
NATIVE {OM_ADDTAIL}   CONST OM_ADDTAIL   = (OM_DUMMY + 5)
NATIVE {OM_REMOVE}    CONST OM_REMOVE    = (OM_DUMMY + 6)
NATIVE {OM_NOTIFY}    CONST OM_NOTIFY    = (OM_DUMMY + 7)
NATIVE {OM_UPDATE}    CONST OM_UPDATE    = (OM_DUMMY + 8)
NATIVE {OM_ADDMEMBER} CONST OM_ADDMEMBER = (OM_DUMMY + 9)
NATIVE {OM_REMMEMBER} CONST OM_REMMEMBER = (OM_DUMMY + 10)

NATIVE {opSet} OBJECT opset
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {ops_AttrList}	attrlist	:ARRAY OF tagitem
    {ops_GInfo}	ginfo	:PTR TO gadgetinfo
ENDOBJECT

NATIVE {opGet} OBJECT opget
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {opg_AttrID}	attrid	:TAG
    {opg_Storage}	storage	:PTR TO IPTR
ENDOBJECT

NATIVE {opAddTail} OBJECT opaddtail
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {opat_List}	list	:PTR TO lh
ENDOBJECT

NATIVE {opUpdate} OBJECT opupdate
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {opu_AttrList}	attrlist	:ARRAY OF tagitem
    {opu_GInfo}	ginfo	:PTR TO gadgetinfo
    {opu_Flags}	flags	:/*STACKULONG*/ ULONG    /* see below */
ENDOBJECT

/* opu_Flags */
NATIVE {OPUF_INTERIM} CONST OPUF_INTERIM = $1

NATIVE {opMember} OBJECT opmember
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {opam_Object}	object	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {opAddMember} DEF
