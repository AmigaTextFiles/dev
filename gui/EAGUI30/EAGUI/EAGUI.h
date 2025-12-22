/*
 * $RCSfile: EAGUI.h,v $
 *
 * $Author: marcel $
 *
 * $Revision: 3.1 $
 *
 * $Date: 1994/11/15 22:52:19 $
 *
 * $Locker: marcel $
 *
 * $State: Exp $
 */

#ifndef EAGUI_H
#define EAGUI_H

/* header files */
#include <exec/types.h>
#include <exec/lists.h>
#include <exec/nodes.h>
#include <utility/hooks.h>
#include "EAGUI_protos.h"

/* library name and version */
#define EAGUILIBRARYNAME      "EAGUI.library"
#define EAGUILIBRARYVERSION   3L

/* ea_Object.type definitions */
#define EA_TYPE_HGROUP        1
#define EA_TYPE_VGROUP        2
#define EA_TYPE_GTGADGET      3
#define EA_TYPE_BOOPSIGADGET  4
#define EA_TYPE_CUSTOMIMAGE   5
#define EA_TYPE_BOOPSIIMAGE   6

/* various LONG attributes can have an unknown value at some point */
#define EA_UNKNOWN            -1

/* error return codes */
#define EA_ERROR_OK                     0
#define EA_ERROR_OUT_OF_MEMORY          100
#define EA_ERROR_BAD_OBJECT             101

/* flags for standard methods */
#define EASM_NONE                       0x00000000
#define EASM_MINSIZE                    0x00000001
#define EASM_BORDER                     0x00000002

/* tags */
#define EA_TAGBASE                      (TAG_USER)

/* These tags can be used under different circumstances. The characters in the comments
 * behind the tags indicate the allowed use:
 *
 * I = Initialize: ea_NewObjectA()
 * S = Set:        ea_SetAttrsA()
 * G = Get:        ea_GetAttrsA()
 *
 * Most functions ignore tags they don't recognize, but don't count on that,
 * or side effects may occur in future versions.
 */
#define EA_Parent                       (EA_TAGBASE + 1)    /* I.G */
#define EA_Type                         (EA_TAGBASE + 2)    /* ..G */
#define EA_Disabled                     (EA_TAGBASE + 3)    /* ISG */
#define EA_ID                           (EA_TAGBASE + 4)    /* ISG */
#define EA_MinWidth                     (EA_TAGBASE + 5)    /* ISG */
#define EA_MinHeight                    (EA_TAGBASE + 6)    /* ISG */
#define EA_BorderLeft                   (EA_TAGBASE + 7)    /* ISG */
#define EA_BorderRight                  (EA_TAGBASE + 8)    /* ISG */
#define EA_BorderTop                    (EA_TAGBASE + 9)    /* ISG */
#define EA_BorderBottom                 (EA_TAGBASE + 10)   /* ISG */
#define EA_Left                         (EA_TAGBASE + 11)   /* .SG */
#define EA_Top                          (EA_TAGBASE + 12)   /* .SG */
#define EA_Width                        (EA_TAGBASE + 13)   /* ISG */
#define EA_Height                       (EA_TAGBASE + 14)   /* ISG */
#define EA_Weight                       (EA_TAGBASE + 15)   /* ISG */
#define EA_Instance                     (EA_TAGBASE + 17)   /* ..G */
#define EA_InstanceAddress              (EA_TAGBASE + 18)   /* ISG */

#define EA_MinSizeMethod                (EA_TAGBASE + 19)   /* ISG */
#define EA_BorderMethod                 (EA_TAGBASE + 20)   /* ISG */
#define EA_RenderMethod                 (EA_TAGBASE + 21)   /* ISG */
#define EA_GetStateMethod               (EA_TAGBASE + 22)   /* ISG */
#define EA_SetStateMethod               (EA_TAGBASE + 23)   /* ISG */

#define EA_Object                       (EA_TAGBASE + 24)   /* I.. */

#define EA_GTType                       (EA_TAGBASE + 25)   /* ISG */
#define EA_GTTagList                    (EA_TAGBASE + 26)   /* ISG */
#define EA_GTText                       (EA_TAGBASE + 27)   /* ISG */
#define EA_GTTextAttr                   (EA_TAGBASE + 28)   /* ISG */
#define EA_GTFlags                      (EA_TAGBASE + 29)   /* ISG */

#define EA_BOOPSIPrivClass              (EA_TAGBASE + 30)   /* ISG */
#define EA_BOOPSIPubClass               (EA_TAGBASE + 31)   /* ISG */
#define EA_BOOPSITagList                (EA_TAGBASE + 32)   /* ISG */

#define EA_Child                        (EA_TAGBASE + 33)   /* I.. */

#define EA_FirstChild                   (EA_TAGBASE + 34)   /* ..G */
#define EA_NextObject                   (EA_TAGBASE + 35)   /* ..G */

#define EA_StandardMethod               (EA_TAGBASE + 36)   /* IS. */
#define EA_UserData                     (EA_TAGBASE + 37)   /* ISG */

#define EA_DefDisabled                  (EA_TAGBASE + 38)   /* .SG */
#define EA_DefWeight                    (EA_TAGBASE + 39)   /* .SG */
#define EA_DefMinSizeMethod             (EA_TAGBASE + 40)   /* .SG */
#define EA_DefBorderMethod              (EA_TAGBASE + 41)   /* .SG */
#define EA_DefRenderMethod              (EA_TAGBASE + 42)   /* .SG */
#define EA_DefGetStateMethod            (EA_TAGBASE + 43)   /* .SG */
#define EA_DefSetStateMethod            (EA_TAGBASE + 44)   /* .SG */
#define EA_DefGTType                    (EA_TAGBASE + 45)   /* .SG */
#define EA_DefGTTagList                 (EA_TAGBASE + 46)   /* .SG */
#define EA_DefGTText                    (EA_TAGBASE + 47)   /* .SG */
#define EA_DefGTTextAttr                (EA_TAGBASE + 48)   /* .SG */
#define EA_DefGTFlags                   (EA_TAGBASE + 49)   /* .SG */
#define EA_DefBOOPSIPrivClass           (EA_TAGBASE + 50)   /* .SG */
#define EA_DefBOOPSIPubClass            (EA_TAGBASE + 51)   /* .SG */
#define EA_DefBOOPSITagList             (EA_TAGBASE + 52)   /* .SG */
#define EA_DefStandardMethod            (EA_TAGBASE + 53)   /* .SG */
#define EA_DefBorderLeft                (EA_TAGBASE + 54)   /* .SG */
#define EA_DefBorderRight               (EA_TAGBASE + 55)   /* .SG */
#define EA_DefBorderTop                 (EA_TAGBASE + 56)   /* .SG */
#define EA_DefBorderBottom              (EA_TAGBASE + 57)   /* .SG */


/* Pointer to an object, which is used as a `handle' by a lot of functions. The actual
 * data structure of the object is hidden from the application programmer.
 */
typedef struct ea_Object *    OPTR;

/* This structure is READ-ONLY! */
typedef struct ea_RelationObject
{
     /* private */
     struct Node              node;                         /* node */

     /* attributes */
     struct ea_Object *       object_ptr;                   /* pointer to the object */
};

/* Message structure as used by the Render hook. A pointer to this structure is passed
 * in the message parameter of the callback hook. For more information on hooks, take
 * a look at amiga.lib/CallHook() or utility.library/CallHookPkt().
 */
typedef struct ea_RenderMessage
{
     struct ea_Object *root_ptr;
     struct RastPort *rastport_ptr;
};

/* Library base name. */
GLOBAL struct Library *EAGUIBase;

#ifndef NOEAGUIMACROS
#include "EAGUI_macros.h"
#endif

#endif /* EAGUI_H */
