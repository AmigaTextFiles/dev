@DATABASE "gg:doc/NDK/Guide/Include/intuition/classes.h"
@MASTER   "gg:os-include/intuition/classes.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "intuition/classes.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"intuition/classes.h" LINK File}


@{b}Structures@{ub}

@{"_Object" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 79}  @{"ClassLibrary" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 105}  @{"IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36}


@{b}Typedefs@{ub}

@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36}


@{b}#defines@{ub}

@{"_OBJ()" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 89}             @{"_OBJECT()" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 95}  @{"BASEOBJECT()" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 92}  @{"CLF_INLIST" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 53}  @{"INST_DATA()" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 59}  @{"OCLASS()" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 98}
@{"SIZEOF_INSTANCE()" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 64}  

@ENDNODE
@NODE File "intuition/classes.h"
#ifndef INTUITION_CLASSES_H
#define INTUITION_CLASSES_H
/*
**  $VER: classes.h 40.0 (15.2.1994)
**  Includes Release 45.1
**
**  Used only by class implementors
**
**  (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif

#ifndef UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif

#ifndef INTUITION_CLASSUSR_H
#include <@{"intuition/classusr.h" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File"}>
#endif

/*****************************************************************************/
/***************** "White Box" access to @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} ***********************/
/*****************************************************************************/

/* This structure is READ-ONLY, and allocated only by Intuition */
typedef struct IClass
{
    @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28}          cl_Dispatcher;         /* Class dispatcher */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                cl_Reserved;           /* Must be 0  */
    struct IClass       *cl_Super;              /* Pointer to superclass */
    @{"ClassID" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 21}              cl_ID;                 /* Class ID */

    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                cl_InstOffset;         /* Offset of instance data */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                cl_InstSize;           /* Size of instance data */

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                cl_UserData;           /* Class global data */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                cl_SubclassCount;      /* Number of subclasses */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                cl_ObjectCount;        /* Number of objects */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                cl_Flags;

} Class;

#define CLF_INLIST      0x00000001L
    /* class is in public class list */

/*****************************************************************************/

/* add offset for instance data to an object handle */
#define INST_DATA(cl,o)         ((void *)(((@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *)o)+cl->cl_InstOffset))

/*****************************************************************************/

/* sizeof the instance data for a given class */
#define SIZEOF_INSTANCE(cl)     ((cl)->cl_InstOffset + (cl)->cl_InstSize \\
                        + sizeof (@{"struct _Object" LINK File 79}))

/*****************************************************************************/
/***************** "White box" access to @{"struct _Object" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 79} **********************/
/*****************************************************************************/

/* We have this, the instance data of the root class, PRECEDING the "object".
 * This is so that Gadget objects are Gadget pointers, and so on.  If this
 * structure grows, it will always have o_Class at the end, so the macro
 * @{"OCLASS" LINK File 98}(o) will always have the same offset back from the pointer returned
 * from @{"NewObject()" LINK "gg:doc/NDK/Guide/intuition/NewObject"}.
 *
 * This data structure is subject to change.  Do not use the o_Node embedded
 * structure. */
struct _Object
{
    @{"struct MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31}       o_Node;
    @{"struct IClass" LINK File 36}       *o_Class;

};

/*****************************************************************************/

/* convenient typecast  */
#define _OBJ(o)                 ((@{"struct _Object" LINK File 79} *)(o))

/* get "public" handle on baseclass instance from real beginning of obj data */
#define BASEOBJECT(_obj)        ((@{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *)(@{"_OBJ" LINK File 89}(_obj)+1))

/* get back to object data struct from public handle */
#define _OBJECT(o)              (@{"_OBJ" LINK File 89}(o) - 1)

/* get class pointer from an object handle      */
#define OCLASS(o)               ((@{"_OBJECT" LINK File 95}(o))->o_Class)

/*****************************************************************************/

/* BOOPSI class libraries should use this structure as the base for their
 * library data.  This allows developers to obtain the class pointer for
 * performing object-less inquiries. */
struct ClassLibrary
{
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}       cl_Lib;        /* Embedded library */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                cl_Pad;        /* Align the structure */
    @{"Class" LINK File 36}               *cl_Class;      /* Class pointer */

};

/*****************************************************************************/

#endif
@ENDNODE
