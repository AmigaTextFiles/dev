@DATABASE "gg:doc/NDK/Guide/Include/intuition/classusr.h"
@MASTER   "gg:os-include/intuition/classusr.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:52
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "intuition/classusr.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"intuition/classusr.h" LINK File}


@{b}Structures@{ub}

@{"opAddTail" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 116}  @{"opGet" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 107}  @{"opMember" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 123}  @{"opSet" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 77}  @{"opUpdate" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 87}


@{b}Typedefs@{ub}

@{"ClassID" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 21}  @{"Msg" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 29}  @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19}


@{b}#defines@{ub}

@{"BUTTONGCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 48}  @{"FILLRECTCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 44}  @{"FRAMEICLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 42}   @{"FRBUTTONCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 49}  @{"GADGETCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 45}
@{"GROUPGCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 50}   @{"ICCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 51}        @{"IMAGECLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 41}    @{"ITEXTICLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 53}    @{"MODELCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 52}
@{"OM_ADDMEMBER" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 71}  @{"OM_ADDTAIL" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 67}     @{"OM_DISPOSE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 64}    @{"OM_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 62}       @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}
@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}        @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}      @{"OM_REMMEMBER" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 72}  @{"OM_REMOVE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 68}      @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}
@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70}     @{"opAddMember" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 122}    @{"OPUF_INTERIM" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 104}  @{"POINTERCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 54}   @{"PROPGCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 46}
@{"ROOTCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 40}     @{"STRGCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 47}      @{"SYSICLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 43}     

@ENDNODE
@NODE File "intuition/classusr.h"
#ifndef INTUITION_CLASSUSR_H
#define INTUITION_CLASSUSR_H    1
/*
**  $VER: classusr.h 38.2 (14.4.1992)
**  Includes Release 45.1
**
**  For application users of Intuition object classes
**
**  (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
*/


#ifndef UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif

/*** User visible handles on objects, classes, messages ***/
typedef @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   Object;         /* abstract handle */

typedef @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *ClassID;

/* you can use this type to point to a "generic" message,
 * in the object-oriented programming parlance.  Based on
 * the value of 'MethodID', you dispatch to processing
 * for the various message types.  The meaningful parameter
 * packet structure definitions are defined below.
 */
typedef struct
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;
    /* method-specific data follows, some examples below */
}               *Msg;

/*
 * Class id strings for Intuition classes.
 * There's no real reason to use the uppercase constants
 * over the lowercase strings, but this makes a good place
 * to list the names of the built-in classes.
 */
#define ROOTCLASS       "rootclass"             /* classusr.h     */
#define IMAGECLASS      "imageclass"            /* imageclass.h   */
#define FRAMEICLASS     "frameiclass"
#define SYSICLASS       "sysiclass"
#define FILLRECTCLASS   "fillrectclass"
#define GADGETCLASS     "gadgetclass"           /* gadgetclass.h  */
#define PROPGCLASS      "propgclass"
#define STRGCLASS       "strgclass"
#define BUTTONGCLASS    "buttongclass"
#define FRBUTTONCLASS   "frbuttonclass"
#define GROUPGCLASS     "groupgclass"
#define ICCLASS         "icclass"               /* icclass.h      */
#define MODELCLASS      "modelclass"
#define ITEXTICLASS     "itexticlass"
#define POINTERCLASS    "pointerclass"          /* pointerclass.h */

/* Dispatched method ID's
 * NOTE: Applications should use Intuition entry points, not direct
 * @{"DoMethod()" LINK "gg:doc/NDK/Guide/amiga_lib/DoMethod"} calls, for @{"NewObject" LINK "gg:doc/NDK/Guide/intuition/NewObject"}, @{"DisposeObject" LINK "gg:doc/NDK/Guide/intuition/DisposeObject"}, @{"SetAttrs" LINK "gg:doc/NDK/Guide/intuition/SetAttrsA"},
 * @{"SetGadgetAttrs" LINK "gg:doc/NDK/Guide/intuition/SetGadgetAttrsA"}, and @{"GetAttr" LINK "gg:doc/NDK/Guide/intuition/GetAttr"}.
 */

#define OM_Dummy        (0x100)
#define OM_NEW          (0x101) /* 'object' parameter is "true class"   */
#define OM_DISPOSE      (0x102) /* delete self (no parameters)          */
#define OM_SET          (0x103) /* set attributes (in tag list)         */
#define OM_GET          (0x104) /* return single attribute value        */
#define OM_ADDTAIL      (0x105) /* add self to a List (let root do it)  */
#define OM_REMOVE       (0x106) /* remove self from list                */
#define OM_NOTIFY       (0x107) /* send to self: notify dependents      */
#define OM_UPDATE       (0x108) /* notification message from somebody   */
#define OM_ADDMEMBER    (0x109) /* used by various classes with lists   */
#define OM_REMMEMBER    (0x10A) /* used by various classes with lists   */

/* Parameter "Messages" passed to methods       */

/* @{"OM_NEW" LINK File 63} and @{"OM_SET" LINK File 65}    */
struct opSet {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32}      *ops_AttrList;  /* new attributes       */
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *ops_GInfo;     /* always there for gadgets,
                                         * when @{"SetGadgetAttrs()" LINK "gg:doc/NDK/Guide/intuition/SetGadgetAttrsA"} is used,
                                         * but will be @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} for @{"OM_NEW" LINK File 63}
                                         */
};

/* @{"OM_NOTIFY" LINK File 69}, and @{"OM_UPDATE" LINK File 70}     */
struct opUpdate {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32}      *opu_AttrList;  /* new attributes       */
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *opu_GInfo;     /* non-@{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} when @{"SetGadgetAttrs" LINK "gg:doc/NDK/Guide/intuition/SetGadgetAttrsA"} or
                                         * notification resulting from gadget
                                         * input occurs.
                                         */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               opu_Flags;      /* defined below        */
};

/* this flag means that the update message is being issued from
 * something like an active gadget, a la @{"GACT_FOLLOWMOUSE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 408}.  When
 * the gadget goes inactive, it will issue a final update
 * message with this bit cleared.  Examples of use are for
 * @{"GACT_FOLLOWMOUSE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 408} equivalents for propgadclass, and repeat strobes
 * for buttons.
 */
#define OPUF_INTERIM    (1<<0)

/* @{"OM_GET" LINK File 66}       */
struct opGet {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               opg_AttrID;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               *opg_Storage;   /* may be other types, but "int"
                                         * types are all @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}
                                         */
};

/* @{"OM_ADDTAIL" LINK File 67}   */
struct opAddTail {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20}         *opat_List;
};

/* @{"OM_ADDMEMBER" LINK File 71}, @{"OM_REMMEMBER" LINK File 72}   */
#define  opAddMember opMember
struct opMember {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"Object" LINK File 19}              *opam_Object;
};


#endif
@ENDNODE
