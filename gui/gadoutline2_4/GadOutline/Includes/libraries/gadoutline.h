
#ifndef LIBRARIES_GADOUTLINE_H
#define LIBRARIES_GADOUTLINE_H

#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

/**
 ** Command ID bit definitions.
 **/
typedef unsigned long CMDID;

#define STDID_STARTBIT (0)      // Standard ID code for command / gadget
#define STDID_NUMBITS (10)
#define GRPID_STARTBIT (12)     // Group ID code
#define GRPID_NUMBITS (20)

// Bit allocation:
//
// 3  2    2    2    1    1    0    0    0
// 1  8    4    0    6    2    8    4    0
// GGGG GGGG GGGG GGGG GGGG xxSS SSSS SSSS
//
// G = Group ID bits
// S = Standard ID bits
// x = reserved.  always set to 0.

#define GETSTDID(cmdid) ((ULONG)( ( ((CMDID)(cmdid)) >> STDID_STARTBIT ) \
                                  & ((1<<STDID_NUMBITS)-1) ))
#define GETGRPID(cmdid) ((ULONG)( ( ((CMDID)(cmdid)) >> GRPID_STARTBIT ) \
                                  & ((1<<GRPID_NUMBITS)-1) ))

#define GO_CMDID(grpid,stdid) \
        ((CMDID)( (((ULONG)(grpid)&((1<<GRPID_NUMBITS)-1))<<GRPID_STARTBIT) \
                | (((ULONG)(stdid)&((1<<STDID_NUMBITS)-1))<<STDID_STARTBIT) \
        ))

#define GO_GRPID_A  0x00100
#define GO_GRPID_B  0x00200
#define GO_GRPID_C  0x00400
#define GO_GRPID_D  0x00800
#define GO_GRPID_E  0x01000
#define GO_GRPID_F  0x02000
#define GO_GRPID_G  0x04000
#define GO_GRPID_H  0x08000
#define GO_GRPID_I  0x10000
#define GO_GRPID_J  0x20000
#define GO_GRPID_K  0x40000
#define GO_GRPID_L  0x80000

#define GO_GRPID_MASK 0xFFF00
#define GO_GRPID_CODE 0x000FF

/**
 ** Definition for a standard weight distribution; used below.
 **/
typedef unsigned short WDIST;

#define LEFTDIST_STARTBIT (0)   // All leftover weight that's not used below:
#define LEFTDIST_NUMBITS (2)
#define SPCLDIST_STARTBIT (2)   // Weight of the last [below/right] space.
#define SPCLDIST_NUMBITS (2)
#define TXTLDIST_STARTBIT (4)   // Weight of the last [below/right] text.
#define TXTLDIST_NUMBITS (2)
#define BODYDIST_STARTBIT (6)   // Weight of the body.
#define BODYDIST_NUMBITS (2)
#define TXTFDIST_STARTBIT (8)   // Weight of the first [above/left] text.
#define TXTFDIST_NUMBITS (2)
#define SPCFDIST_STARTBIT (10)  // Weight of the first [above/left] space.
#define SPCFDIST_NUMBITS (2)

// Bit allocation:
//
// 1  1    0    0    0
// 5  2    8    4    0
// xxxx SSTT bbtt ssLL
//
// S = Space above/left weight
// T = Text above/left weight
// B = Body weight
// t = Text below/right weight
// s = Space below/right weight
// L = left over space [all space not used above.]
// x = reserved.  always set to 0.

#define GETLEFTDIST(wdist)  ((UBYTE)( ( ((WDIST)(wdist)) >> LEFTDIST_STARTBIT ) \
                                      & ((1<<LEFTDIST_NUMBITS)-1) ))
#define GETSPCLDIST(wdist)  ((UBYTE)( ( ((WDIST)(wdist)) >> SPCLDIST_STARTBIT ) \
                                      & ((1<<SPCLDIST_NUMBITS)-1) ))
#define GETTXTLDIST(wdist)  ((UBYTE)( ( ((WDIST)(wdist)) >> TXTLDIST_STARTBIT ) \
                                      & ((1<<TXTLDIST_NUMBITS)-1) ))
#define GETBODYDIST(wdist)  ((UBYTE)( ( ((WDIST)(wdist)) >> BODYDIST_STARTBIT ) \
                                      & ((1<<BODYDIST_NUMBITS)-1) ))
#define GETTXTFDIST(wdist)  ((UBYTE)( ( ((WDIST)(wdist)) >> TXTFDIST_STARTBIT ) \
                                      & ((1<<TXTFDIST_NUMBITS)-1) ))
#define GETSPCFDIST(wdist)  ((UBYTE)( ( ((WDIST)(wdist)) >> SPCFDIST_STARTBIT ) \
                                      & ((1<<SPCFDIST_NUMBITS)-1) ))

#define GO_WDIST(spcf,txtf,body,spcl,txtl,left) \
        ((WDIST)( (((UWORD)(spcf)&((1<<SPCFDIST_NUMBITS)-1))<<SPCFDIST_STARTBIT) \
                | (((UWORD)(txtf)&((1<<TXTFDIST_NUMBITS)-1))<<TXTFDIST_STARTBIT) \
                | (((UWORD)(body)&((1<<BODYDIST_NUMBITS)-1))<<BODYDIST_STARTBIT) \
                | (((UWORD)(txtl)&((1<<TXTLDIST_NUMBITS)-1))<<TXTLDIST_STARTBIT) \
                | (((UWORD)(spcl)&((1<<SPCLDIST_NUMBITS)-1))<<SPCLDIST_STARTBIT) \
                | (((UWORD)(left)&((1<<LEFTDIST_NUMBITS)-1))<<LEFTDIST_STARTBIT) \
        ))

/**
 ** Definition for how much weight an object gets in a group.
 **/
typedef unsigned long WEIGHT;

#define BOXWGT_STARTBIT (0)     // Weight of this entire box.
#define BOXWGT_NUMBITS (8)
#define VERWGT_STARTBIT (8)     // Vertical distribution of weight.
#define VERWGT_NUMBITS (12)
#define HORWGT_STARTBIT (20)    // Horizontal distribution of weight.
#define HORWGT_NUMBITS (12)

// Bit allocation:
//
// 3  2    2    2    1    1    0    0    0
// 1  8    4    0    6    2    8    4    0
// HHHH HHHH HHHH VVVV VVVV VVVV BBBB BBBB
//
// H = Horizonal weight distribution within box.  [Type WDIST]
// V = Vertical weight distribution within box.  [Type WDIST]
// B = Weight of entire box within its group.
// x = reserved.  always set to 0.

#define GETBOXWGT(weight)   ((ULONG)( ( ((WEIGHT)(weight)) >> BOXWGT_STARTBIT ) \
                                      & ((1<<BOXWGT_NUMBITS)-1) ))
#define GETVERWGT(weight)   ((WDIST)( ( ((WEIGHT)(weight)) >> VERWGT_STARTBIT ) \
                                      & ((1<<VERWGT_NUMBITS)-1) ))
#define GETHORWGT(weight)   ((WDIST)( ( ((WEIGHT)(weight)) >> HORWGT_STARTBIT ) \
                                      & ((1<<HORWGT_NUMBITS)-1) ))

#define GO_WEIGHT(horiz,vert,box) \
        ((WEIGHT)( (((ULONG)(horiz)&((1<<HORWGT_NUMBITS)-1))<<HORWGT_STARTBIT) \
                 | (((WDIST)(vert)&((1<<VERWGT_NUMBITS)-1))<<VERWGT_STARTBIT) \
                 | (((WDIST)(box)&((1<<BOXWGT_NUMBITS)-1))<<BOXWGT_STARTBIT) \
        ))

/**
 ** Outline command definitions
 **/
typedef unsigned long OUTCMD;

#define CMDSUBC_STARTBIT (0)
#define CMDSUBC_NUMBITS (16)
#define CMDCODE_STARTBIT (16)
#define CMDCODE_NUMBITS (4)
#define CMDKIND_STARTBIT (20)
#define CMDKIND_NUMBITS (4)
#define CMDTAGS_STARTBIT (24)
#define CMDTAGS_NUMBITS (2)
#define CMDPARS_STARTBIT (28)
#define CMDPARS_NUMBITS (3)

// Bit allocation:
//
// 3  2    2    2    1    1    0    0    0
// 1  8    4    0    6    2    8    4    0
// xPPP xxTT KKKK CCCC SSSS SSSS SSSS SSSS
//
// P = Command's number of parameters
// T = Command's number of tag lists
// K = Command's kind bits
// C = Command's code bits
// S = Command's sub-code bits
// x = reserved.  always set to 0.

#define GETCMDPARS(outcmd)  ((ULONG)( ( ((OUTCMD)(outcmd)) >> CMDPARS_STARTBIT ) \
                                      & ((1<<CMDPARS_NUMBITS)-1) ))
#define GETCMDTAGS(outcmd)  ((ULONG)( ( ((OUTCMD)(outcmd)) >> CMDTAGS_STARTBIT ) \
                                      & ((1<<CMDTAGS_NUMBITS)-1) ))
#define GETCMDKIND(outcmd)  ((ULONG)( ( ((OUTCMD)(outcmd)) >> CMDKIND_STARTBIT ) \
                                      & ((1<<CMDKIND_NUMBITS)-1) ))
#define GETCMDCODE(outcmd)  ((ULONG)( ( ((OUTCMD)(outcmd)) >> CMDCODE_STARTBIT ) \
                                      & ((1<<CMDCODE_NUMBITS)-1) ))
#define GETCMDSUBC(outcmd)  ((ULONG)( ( ((OUTCMD)(outcmd)) >> CMDSUBC_STARTBIT ) \
                                      & ((1<<CMDSUBC_NUMBITS)-1) ))

#define GO_OUTCMD(par,tag,kind,code,subc) \
        ((OUTCMD)   ( (((ULONG)(par)&((1<<CMDPARS_NUMBITS)-1))<<CMDPARS_STARTBIT) \
                    | (((ULONG)(tag)&((1<<CMDTAGS_NUMBITS)-1))<<CMDTAGS_STARTBIT) \
                    | (((ULONG)(kind)&((1<<CMDKIND_NUMBITS)-1))<<CMDKIND_STARTBIT) \
                    | (((ULONG)(code)&((1<<CMDCODE_NUMBITS)-1))<<CMDCODE_STARTBIT) \
                    | (((ULONG)(subc)&((1<<CMDSUBC_NUMBITS)-1))<<CMDSUBC_STARTBIT) \
        ))

// Bits describing major kinds.  The command kind determines what ci_CmdData
// points to and the general meaning of the parameters and tag lists.

#define GOK_Illegal     0x0 // Illegal kind
#define GOK_Box         0x1 // This is an actual box on the display.
                            // ci_CmdData points to a BoxAttr structure.
                            // The first two parameters are the same for all
                            // codes; the rest are context sensitive to the
                            // actual kind of object that is being created.
                            // Parameters:
                            //   1: CmdID - ID number; standard ID used in gadget.
                            //   2: BoxWeight - How much extra space box gets.
                            //   3: Text - GadTools text / Boopsi public class
                            //             name / Custom parameter.
                            //   4: Value - GadTools flags / Boopsi private class
                            //              code / Custom parameter.
                            // Tag Lists:
                            //   1: Standard command tags applied to box.
                            //   2: GadTools / Boopsi / Custom / Drawing tags.
#define GOK_Image       0x2 // This is an image drawn on to the display.
                            // ci_CmdData points to a BoxAttr structure.
                            // The first two parameters are the same for all
                            // codes; the rest are context sensitive to the
                            // actual kind of object that is being created.
                            // Parameters:
                            //   1: CmdID - ID number; standard ID used in gadget.
                            //   2: Reserved - Always set to 0.
                            //   3: Text - GadTools text / Boopsi public class
                            //             name / Custom parameter.
                            //   4: Value - GadTools flags / Boopsi private class
                            //              code / Custom parameter.
                            // Tag Lists:
                            //   1: Standard command tags applied to image.
                            //   2: GadTools / Boopsi / Custom / Drawing tags.
#define GOK_Object      0x3 // This is an object that is not a direct part of the
                            // display.  ci_CmdData is currently NULL.
                            // The first two parameters are the same for all
                            // codes; the rest are context sensitive to the
                            // actual kind of object that is being created.
                            // Parameters:
                            //   1: CmdID - ID number; standard ID used in gadget.
                            //   2: Reserved - Always set to 0.
                            //   3: Text - GadTools text / Boopsi public class
                            //             name / Custom parameter.
                            //   4: Value - GadTools flags / Boopsi private class
                            //              code / Custom parameter.
                            // Tag Lists:
                            //   1: Standard command tags applied to image.
                            //   2: GadTools / Boopsi / Custom / Drawing tags.
#define GOK_Group       0x4 // Group control commands.  ci_CmdData points to
                            // a standard BoxAttr structure.
                            // Parameters:
                            //   1: CmdID - ID number.
                            //   2: GrpWeight - How much extra space grp box gets.
                            // Tag Lists:
                            //   1: Standard command tags
                            //   2: (optional) List of drawing commands for group.
#define GOK_Sys         0x5 // System control commands.
                            // Parameters:
                            //   1: CmdID - ID number.  Usually 0.
                            // Tag Lists:
                            //   None.
#define GOK_Global      0x6 // Global settings commands.
                            // Parameters:
                            //   1: CmdID - ID number.
                            // Tag Lists:
                            //   Global tags to change.
#define GOK_User        0x7 // User command.
                            // Parameters:
                            //   1:  CmdID - ID number.
                            //   2-: Anything.
                            // Tag Lists:
                            //   Anything.
#define GOK_LastDef     0x8 // Last outline kind that is defined.

// Bits descibing codes for box/image/object kind - GOK_Box/GOK_Image/GOK_Object.
#define GOKB_Resv       0x0 // Reserved - do not use.
#define GOKB_GadTools   0x1 // This is a standard gadtools gadget.
                            // The 3rd parameter points to the gadget's label
                            // text, the 4th contains the standard NewGadget
                            // flags.  The SubCode field in the command is
                            // the actual GadTools gadget kind to create.
#define GOKB_Boopsi     0x2 // This is a BOOPSI object.
                            // The 3rd parameter is a public class name, the
                            // 4th is the ID for a private class.  These
                            // parameters are directly associated with the
                            // NewObject() call; one of them must be NULL.
                            // See subcode definitions - GOSB_* - below.
#define GOKB_Custom     0x3 // This is a custom object.
                            // Everything after the first 2 parameters and
                            // first tag list are available for whatever the
                            // user wants.
#define GOKB_Empty      0x4 // This is a an empty box.
#define GOKB_Drawing    0x5 // This is a GadOutline drawing.  See subcode
                            // definitions - GOSD_* - below.

// Bits descibing command codes for the group kind - GOK_Group.
#define GOKG_Resvgrp    0x0 // Reserved - do not use.
#define GOKG_Vertical   0x1 // Start a vertical group
#define GOKG_Horizontal 0x2 // Start a horizontal group

// Bits descibing command codes for the system kind - GOK_System.
#define GOKS_Resv       0x0 // Reserved - do not use.
#define GOKS_EndGroup   0x1 // End the current group.
#define GOKS_EndOutline 0x2 // End the entire outline.

// Bits descibing command codes for the global kind - GOK_Global.
#define GOKG_Resvglb    0x0 // Reserved - do not use.
#define GOKG_Outline    0x1 // Set global outline tags.  [ie GOA_*]
#define GOKG_Command    0x2 // Set global command tags.  [ie GOCT_*]
#define GOKG_Object     0x3 // Set global object tags.  [object dependant]
                            // NOT IMPLEMENTED ^^
#define GOKG_Screen     0x4 // Set standard screen tags.  [ie SA_*]
#define GOKG_Window     0x5 // Set standard window tags.  [ie WA_*]

// Bits describing subcode for drawing code.
#define GOSD_Normal     0x1 // Just a normal drawing.
#define GOSD_Button     0x2 // Drawing with a highlight button.
#define GOSD_BoopsiIm   0x3 // Create a BOOPSI image object.
#define GOSD_BoopsiGad  0x4 // Create a full BOOPSI gadget.

// Bits describing subcode for BOOPSI code.
#define GOSB_Object     0x1 // A generic object
#define GOSB_Image      0x2 // A type of image class.
#define GOSB_Gadget     0x3 // A type of gadget class.
#define GOSB_AddGad     0x3 // A type of gadget class, added to go_BoopsiGList.

// ---------------------------------
// Standard box creation commands
// ---------------------------------

#define GO_GTBOX(gadkind,grpid,stdid,weight,name,flags) \
        GO_OUTCMD(4,2,GOK_Box,GOKB_GadTools,gadkind), \
        GO_CMDID(grpid,stdid),weight,name,flags
        // 4 arguents; 2 tag lists

#define GO_DRAWBOX(type,grpid,stdid,weight) \
        GO_OUTCMD(2,2,GOK_Box,GOKB_Drawing,type), \
        GO_CMDID(grpid,stdid),weight
        // 2 arguents; 2 tag lists

#define GO_BOOPSIBOX(type,grpid,stdid,weight,classname,classid) \
        GO_OUTCMD(4,2,GOK_Box,GOKB_Boopsi,type), \
        GO_CMDID(grpid,stdid),weight,classname,classid
        // 4 arguents; 2 tag lists

#define GO_CUSTBOX(numparam,numtags,subcode,grpid,stdid,weight) \
        GO_OUTCMD(numparam-2,numtags,GOK_Box,GOKB_Custom,subcode), \
        GO_CMDID(grpid,stdid),weight

#define GO_EMPTYBOX(grpid,stdid,weight) \
        GO_OUTCMD(2,1,GOK_Box,GOKB_Empty,0),GO_CMDID(grpid,stdid),weight
        // 2 arguents; 1 tag list

// ---------------------------------
// Standard image creation commands
// ---------------------------------

#define GO_GTIMAGE(gadkind,grpid,stdid,name,flags) \
        GO_OUTCMD(4,2,GOK_Image,GOKB_GadTools,gadkind), \
        GO_CMDID(grpid,stdid),0,name,flags
        // 4 arguents; 2 tag lists

#define GO_DRAWIMAGE(type,grpid,stdid) \
        GO_OUTCMD(2,2,GOK_Image,GOKB_Drawing,type), \
        GO_CMDID(grpid,stdid),0
        // 2 arguents; 2 tag lists

#define GO_BOOPSIIMAGE(type,grpid,stdid,classname,classid) \
        GO_OUTCMD(4,2,GOK_Image,GOKB_Boopsi,type), \
        GO_CMDID(grpid,stdid),0,classname,classid
        // 4 arguents; 2 tag lists

#define GO_CUSTIMAGE(numparam,numtags,subcode,grpid,stdid) \
        GO_OUTCMD(numparam-2,numtags,GOK_Image,GOKB_Custom,subcode), \
        GO_CMDID(grpid,stdid),0

#define GO_EMPTYIMAGE(grpid,stdid) \
        GO_OUTCMD(2,1,GOK_Image,GOKB_Empty,0),GO_CMDID(grpid,stdid),0
        // 2 arguents; 1 tag list

// ---------------------------------
// Standard object creation commands
// ---------------------------------

#define GO_BOOPSIOBJ(type,grpid,stdid,classname,classid) \
        GO_OUTCMD(3,2,GOK_Object,GOKB_Boopsi,type), \
        GO_CMDID(grpid,stdid),classname,classid
        // 3 arguents; 2 tag lists

// ---------------------------------
// Standard group creation commands
// ---------------------------------

#define GO_HORIZGRP(grpid,stdid,weight) \
        GO_OUTCMD(2,1,GOK_Group,GOKG_Horizontal,0),GO_CMDID(grpid,stdid),weight
        // 2 arguents; 1 tag list

#define GO_VERTGRP(grpid,stdid,weight) \
        GO_OUTCMD(2,1,GOK_Group,GOKG_Vertical,0),GO_CMDID(grpid,stdid),weight
        // 2 arguents; 1 tag list

#define GO_HDRAWGRP(grpid,stdid,weight) \
        GO_OUTCMD(2,2,GOK_Group,GOKG_Horizontal,GOSD_Normal), \
        GO_CMDID(grpid,stdid),weight
        // 2 arguents; 2 tag lists

#define GO_VDRAWGRP(grpid,stdid,weight) \
        GO_OUTCMD(2,2,GOK_Group,GOKG_Vertical,GOSD_Normal), \
        GO_CMDID(grpid,stdid),weight
        // 2 arguents; 2 tag lists

// ---------------------------------
// Standard system commands
// ---------------------------------

#define GO_ENDGRP() GO_OUTCMD(0,0,GOK_Sys,GOKS_EndGroup,0)

#define GO_ENDOUTLINE() GO_OUTCMD(0,0,GOK_Sys,GOKS_EndOutline,0)

// ---------------------------------
// Standard global commands
// ---------------------------------

#define GO_OUTLINETAGS(grpid,stdid) \
        GO_OUTCMD(1,2,GOK_Global,GOKG_Outline,0),GO_CMDID(grpid,stdid)
        // 1 arguent; 2 tag lists

#define GO_COMMANDTAGS(grpid,stdid) \
        GO_OUTCMD(1,2,GOK_Global,GOKG_Command,0),GO_CMDID(grpid,stdid)
        // 1 arguent; 2 tag lists

#define GO_OBJECTTAGS(grpid,stdid) \
        GO_OUTCMD(1,2,GOK_Global,GOKG_Object,0),GO_CMDID(grpid,stdid)
        // 1 arguent; 2 tag lists

#define GO_SCREENTAGS(grpid,stdid) \
        GO_OUTCMD(1,2,GOK_Global,GOKG_Screen,0),GO_CMDID(grpid,stdid)
        // 1 arguent; 2 tag lists

#define GO_WINDOWTAGS(grpid,stdid) \
        GO_OUTCMD(1,2,GOK_Global,GOKG_Window,0),GO_CMDID(grpid,stdid)
        // 1 arguent; 2 tag lists

/**
 ** This is the main structure which is created for every command in the
 ** outline.
 **/
struct CmdInfo {
    struct Node ci_Node;        // Private linking.  DO NOT TOUCH.
    UWORD pad0;                 // LONG-align.  DO NOT TOUCH.
    
    // These fields should only be looked at.
    struct GadOutline *ci_GadOutline;   // Link back to global data.
    OUTCMD ci_Command;          // Actual command code; see outline
                                // command definitions.
    CMDID ci_CmdID;             // Standard and Group ID codes for this command.
                                // Always the first command parameter.

    // These fields should only be looked at by the application and may be
    // looked at and modified by the command's hook.
    void *ci_Object;            // Command's created object.  (ie, a Gadget)
                                // Set to NULL when the object has not
                                // been created yet or failed creation.
    ULONG ci_ObjIDCMP;          // The IDCMP messages this object needs.

    // All of the following fields should only be looked at.
    
    union {                         // More detailed data for specific commands.
        void *ci_CmdData;           // Generic data.
        struct BoxAttr *ci_BoxAttr; // Created by GOK_Box kind.
    };

    union {                     // Parameters copied from outline.

        ULONG ci_Params[7];     // Generic view of parameters.

        struct {                    // GOK_Box
            ULONG ci_BoxWeight;     // Raw weight for extra space box uses
            UBYTE *ci_BoxText;      // Text label / boopsi class name for the box
            ULONG ci_BoxValue;      // GadTools NewGadget flags / boopsi class id
        } ci_BoxParams;

        struct {                    // GOK_Image
            ULONG ci_ImageResv;     // Currently unused.  Always set to 0.
            UBYTE *ci_ImageText;    // Boopsi class name for the image
            ULONG ci_ImageValue;    // Boopsi class id for the image
        } ci_ImageParams;

        struct {                    // GOK_Object
            ULONG ci_ObjectResv;    // Currently unused.  Always set to 0.
            UBYTE *ci_ObjectText;   // Boopsi class name for the object
            ULONG ci_ObjectValue;   // Boopsi class id for the object
        } ci_ObjectParams;

        struct {                    // GOK_Group
            ULONG ci_GrpWeight;     // Raw weight for extra space group uses
        } ci_GroupParams;
    };

    // These tag lists are copied from the outline.  They should only be
    // modified by the command's hook, and only individual elements of
    // the tag array may be modified.

    struct TagItem *ci_CmdTags;         // Command tags supplied in the outline.
    union {
        struct TagItem *ci_Tags[3];     // Generic view of tag lists
        struct TagItem *ci_GadToolsTags;// GadTools standard tags
        struct TagItem *ci_BoopsiTags;  // Boopsi class tags
        struct TagItem *ci_DrawingTags; // Drawing class tags
        struct TagItem *ci_GlobalTags;  // Global tags set with GOK_Global
    };

    void *ci_UserHookData;              // For any use by user hook.
    ULONG ci_UserHookState;             // Likewise.

};  /* There is private data after this structure */

struct BoxAttr {
    struct Node ba_Node;                // Private linking.  DO NOT TOUCH.
    UWORD pad0;                         // LONG-align.  DO NOT TOUCH.

    // The rest of these fields are 100% read-only.
    
    struct CmdInfo *ba_CmdInfo;         // The command that created this box.

    struct BoxPosInfo *ba_BoxPosInfo;   // If requested, the full box dimens.

    WORD ba_BoxLeft,ba_BoxTop;          // Absolute LeftEdge and TopEdge of box.
    WORD ba_BoxWidth,ba_BoxHeight;      // Total Width and Height of box.

    WORD ba_BodyLeft,ba_BodyTop;        // Absolute LeftEdge and TopEdge of body.

    WORD ba_SpaceLeft,ba_TextLeft;      // Final x dimensions of box
    WORD ba_BodyWidth;
    WORD ba_TextRight,ba_SpaceRight;

    WORD ba_SpaceAbove,ba_TextAbove;    // Final y dimensions of box
    WORD ba_BodyHeight;
    WORD ba_TextBelow,ba_SpaceBelow;

};  /* There is private data after this structure */

// The ExecMessage structure within the standard IntuiMessage is
// reserved for use by the library.  Do not touch in any way, shape or form. :)

struct GOIMsg {
    struct IntuiMessage StdIMsg;    // Standard Intuition message.
    UBYTE KeyPress[8];              // Translated RAWKEY event.
    ULONG UserData;                 // For any use by user.
};  /* There is private data after this structure */

/**
 ** These are the messages that can be sent to the command's call back.  Most
 ** of the gadget operations are implemented in the callback, including
 ** all of the code to create and destroy gadgets, change their attributes,
 ** implement hot keys, and keeping track of their state.  The hook is
 ** passed the CmdInfo structure as its object, and a CmdHookMsg structure
 ** as its parameters.  The function should always return 0 unless otherwise
 ** indicated.
 **/

#define CHM_INITIALIZE      TAG_USER+1  // Initalizing object - allocate resources
#define CHM_INITCMDATTR     TAG_USER+2  // Parse initial command attributes
                                        // arg 1 = startup command tag list
#define CHM_INITOBJATTR     TAG_USER+3  // Parse initial object attributes
                                        // arg 1 = startup object tag list
#define CHM_TERMINATE       TAG_USER+4  // Terminating - free resources
#define CHM_GETMINDIMENS    TAG_USER+5  // Ask object its minimum size
                                        // arg 1 = pointer to GODimensInfo
                                        //       which is to be filled in.
#define CHM_CREATEOBJ       TAG_USER+6  // Allocating a new object, restore state
                                        // arg 1 = Initialized NewGadget struct
#define CHM_MADELINK        TAG_USER+7  // A object was just created which
                                        // has a link to this object.
                                        // arg 1 = CmdInfo * to linker.
                                        // arg 2 = tag which points to us.
#define CHM_DESTROYOBJ      TAG_USER+8  // Free current object, save state.  Be
                                        // prepared to recieve this without a
                                        // matching CHM_CREATEOBJ.
#define CHM_HOOKOBJ         TAG_USER+9  // Added object to window.
#define CHM_UNHOOKOBJ       TAG_USER+10 // Removing object from window.  Be
                                        // prepared to recieve this without a
                                        // matching CHM_HOOKOBJ.
#define CHM_PRERESIZE       TAG_USER+11 // Set up to resize object.  For GadTools
                                        // gadgets, this involves setting
                                        // ci_Object to NULL because the library
                                        // will free the gadtools list.  Other
                                        // object may need to deallocate here
                                        // too, if they can't resize.
#define CHM_RESIZEOBJ       TAG_USER+12 // Resizing current object.
                                        // arg 1 = Initialized NewGadget struct
#define CHM_DRAWSELF        TAG_USER+13 // Redraw object imagery.
#define CHM_UPDATESTATE     TAG_USER+14 // Update state from IntuiMessage
                                        // arg 1 = COPY of GOIMsg received
#define CHM_SETCMDATTR      TAG_USER+15 // User changing command attributes
                                        // arg 1 = TagList with new values
#define CHM_GETCMDATTR      TAG_USER+16 // User request for current cmd state
                                        // arg 1 = TagList to fill in
#define CHM_SETOBJATTR      TAG_USER+17 // User changing object attributes
                                        // arg 1 = TagList with new values
#define CHM_GETOBJATTR      TAG_USER+18 // User request for current obj state
                                        // arg 1 = TagList to fill in
#define CHM_HOTKEY          TAG_USER+19 // Perform hotkey operation
                                        // arg 1 = COPY of GOIMsg received

// These are the translation commands.  The default is to just return
// the same code that is sent -- ie, the original code was already an
// actual string address.
// The ULONG code to translate is passed as the first message argument 
// for most of these.

#define CHM_TRANSCMDHOOK    TAG_USER+50 // Translate a hook pointer supplied
                                        // with GOCT_SetUserHook tag.  Should
                                        // return the address of a hook struct.
#define CHM_TRANSEDITHOOK   TAG_USER+51 // Translate a hook pointer supplied
                                        // as a gadget's edit hook.  Should
                                        // return the address of a hook struct.

#define CHM_TRANSTEXTPTR    TAG_USER+52 // Translate a text string code
                                        // supplied in outline.  Should
                                        // return the address of a string.
#define CHM_TRANSTEXTARRAY  TAG_USER+53 // Translate a text array code
                                        // supplied in outline.  Should
                                        // return the address of a NULL
                                        // terminated array of string pointers.
#define CHM_TRANSTEXTFMT    TAG_USER+54 // Translate a text level format code
                                        // supplied in outline.  Should
                                        // return the address of a standard
                                        // C-Style formatting string as used
                                        // in GadTools slides, etc.

#define CHM_TRANSPUBCLASS   TAG_USER+55 // Translate a BOOPSI public class
                                        // name.  Should return a pointer
                                        // to a string with the class's name.
#define CHM_TRANSPRIVCLASS  TAG_USER+56 // Translate a BOOPSI private class
                                        // code.  Should return a pointer
                                        // to a private BOOPSI class.

#define CHM_TRANSHOTKEY     TAG_USER+57 // Translate a hotkey code into the
                                        // actual key event.  You will be
                                        // given a ULONG hotkey code, which
                                        // the builtin translation hook
                                        // interprets as an ASCII character
                                        // in the lower byte and various flags
                                        // in the high bits.  You should return
                                        // an ASCII character for the hotkey;
                                        // the library will continue querrying
                                        // you for hotkeys until you return 0.
                                        // You are free to use the upper word
                                        // of the result for state information,
                                        // however always make sure the lower
                                        // word is an actual ASCII value.
                                        // [Ie, the upper byte is zero.]

// Every number after this is for private use by the caller's custom hook.
#define CHM_USER            (TAG_USER+0x4000)

struct CmdHookMsg {
    ULONG chm_Message;                  // Actual message code; one of above
    ULONG chm_NumArgs;                  // For future expansion.  Always set
                                        // to zero.

    union {                             // Parameters
    
        struct {                            // CHM_GETMINDIMENS
            struct GODimensInfo*chm_MinDim; // to be filled in by the hook
                                            // all values start at zero
        } chm_GetMinDimens;

        struct {                            // CHM_CREATEOBJ
            struct NewGadget*chm_NewGadget; // Filled in NewGadget, ready to go.
        } chm_CreateObj;

        struct {                            // CHM_MADELINK
            struct CmdInfo *chm_LinkCmd;    // Command which contains link
            struct TagItem *chm_LinkTag;    // The tag which points to us.
        } chm_MadeLink;

        struct {                            // CHM_RESIZEOBJ
            struct NewGadget*chm_ResGadget; // Filled in NewGadget, ready to go.
        } chm_ResizeObj;

        struct {                            // CHM_UPDATESTATE
            struct GOIMsg *chm_StateGOIMsg; // message to update from
        } chm_UpdateState;

        struct {                            // CHM_SETCMDATTR/CHM_INITCMDATTR
            struct TagItem *chm_SetCmdTags; // New values for ci_CmdTags
        } chm_SetCmdAttr;

        struct {                            // CHM_GETCMDATTR
            struct TagItem *chm_GetCmdTags; // Tags to fill in ti_Data of
        } chm_GetCmdAttr;

        struct {                            // CHM_SETOBJATTR/CHM_INITOBJATTR
            struct TagItem *chm_SetObjTags; // New values for ci_ObjectTags
        } chm_SetObjAttr;

        struct {                            // CHM_GETOBJATTR
            struct TagItem *chm_GetObjTags; // Tags to fill in ti_Data of
        } chm_GetObjAttr;

        struct {                            // CHM_HOTKEY
            struct GOIMsg *chm_KeyGOIMsg;   // message that triggered call
        } chm_HotKey;

        struct {                            // CHM_TRANS* messages
            ULONG chm_TransCode;            // code to translate
            struct CmdInfo *chm_TransCmd;   // If not NULL, the command
                                            // generating this event.
        } chm_Translate;

        struct {                            // CHM_TRANSHOTKEY message
            ULONG chm_HotKeyCode;           // code to translate
            ULONG chm_PrevHotKey;           // previous value you returned, or
                                            // 0 if this is the first time.
        } chm_TransHotKey;

    };
};

struct GODimensInfo {
    
    // Bare minimum values we can take.
    WORD gdi_StdSpaceLeft;      // Pixels of space on left
    WORD gdi_StdTextLeft;       // Pixels to left of body
    WORD gdi_StdBodyWidth;      // Pixels for width of body
    WORD gdi_StdTextRight;      // Pixels to right of body
    WORD gdi_StdSpaceRight;     // Pixels of space on right

    WORD gdi_StdSpaceAbove;     // Pixels of space above
    WORD gdi_StdTextAbove;      // Pixels above body
    WORD gdi_StdBodyHeight;     // Pixels for height of body
    WORD gdi_StdTextBelow;      // Pixels below body
    WORD gdi_StdSpaceBelow;     // Pixels of space below

    // Any extra spacing we would prefer to have.
    WORD gdi_PadSpaceLeft;      // Pixels of padding space on left
    WORD gdi_PadTextLeft;       // Pixels to left of body
    WORD gdi_PadBodyWidth;      // Pixels for width of body
    WORD gdi_PadTextRight;      // Pixels to right of body
    WORD gdi_PadSpaceRight;     // Pixels of padding space on left

    UWORD gdi_PadSpaceAbove;    // Pixels of padding space above
    UWORD gdi_PadTextAbove;     // Pixels above body
    UWORD gdi_PadBodyHeight;    // Pixels for height of body
    UWORD gdi_PadTextBelow;     // Pixels below body
    UWORD gdi_PadSpaceBelow;    // Pixels of padding space below
};

struct GadOutline {
    struct Node go_Node;            // Reserved for future use.  DO NOT TOUCH.
    UWORD pad0;                     // LONG-align.  DO NOT TOUCH.
    void *go_OutlineBase;           // Also reserved.  DO NOT TOUCH.

    // The following are read-only.
    
    struct Window *go_Window;       // Window attached to the gadoutline.
    struct Window *go_HookedWin;    // Window objects are attached to; NULL if
                                    // not attached.  Use this and not
                                    // go_Window with SetGadgetAttrs(), etc.
    struct Screen *go_Screen;       // Screen layout is on.
    struct Menu *go_MenuStrip;      // Menu strip to attach to window.
    struct DrawInfo *go_DrI;        // Used to get the screen font, etc.
    struct VisualInfo *go_VI;       // Screen's VisualInfo.
    struct MsgPort *go_MsgPort;     // Our message port, or the current window's

    // Handles on gadget lists.  You should never need to look at these.
    struct Gadget *go_GToolsList;   // The GadTools list of gadgets
    struct Gadget *go_BoopsiList;   // The Boopsi list of gadgets
    struct Gadget *go_BorderList;   // Currently unused.
    
    // Associated with current gadget held down by user.  May be set to
    // NULL by the command's user hook if it really needs to.
    struct CmdInfo *go_ActCmdInfo;  // Current CmdInfo accepting events

    // These may be modified by a user hook to reflect the addition of
    // a new gadget.  They must always point to a valid gadget.
    struct Gadget *go_LastGTools;   // Last GadTools gadget created
    struct Gadget *go_LastBoopsi;   // Last Boopsi gadget created
    struct Gadget *go_LastBorder;   // Currently unused.

    // Layout dimension information.  Read only.
    UWORD go_Width,go_Height;       // Size of window needed
    UWORD go_InnerWidth,            // Size of window inside its frame
          go_InnerHeight;
    UWORD go_MinWidth,              // Minimum window size the outline will fit in
          go_MinHeight;
    UWORD go_MinInnerWidth,         // Minimum size of window inside its frame
          go_MinInnerHeight;

    // Last return code from requester.  May be written by application.
    UWORD go_LastReqReturn;         // Return value from last error report
    UWORD reserved0;

    // Current font information.  Read only.
    struct TextFont *go_TextFont;   // The opened TTextAttr below.
    struct TTextAttr go_TextAttr;   // The actual font that is used by the
                                    // layout.  All of the gadgets use this as
                                    // their TextAttr.
    struct TTextAttr go_TargetTA;   // The desired font requested by the caller.

    // These may be used however you see fit.
    void *go_UserData;              // For any use by user.
    void *go_UserHandler;           // User's IDCMP handler or anything else.
    void *go_TransHookData;         // For any use by user translation hook.

};  /* There is private data after this structure */

// This structure is not created... yet...
struct OutlineBase {
    struct Node ob_Node;            // Private linking.
    UWORD pad0;                     // LONG-align.
    
    UBYTE *ob_ProgBaseName;         // User program's base name.
    struct GadOutline *ob_Primary;  // Primary outline.

};  /* There is private data after this structure */

/**
 ** This structure is used to describe the full positioning information of
 ** a box on the screen.  To be filled in, a pointer to this structure is
 ** passed using the GOCT_BoxPosInfo tag in the relevant box definition in the
 ** outline.  The structure will be updated any time that the layout is
 ** recomputed.
 **/

struct BoxPosInfo {
    WORD bpi_BoxLeftEdge;       // Left side of box; # pixels from left window edge
    WORD bpi_BoxTopEdge;        // Top side of box; # pixels from top window edge
    WORD bpi_BoxRightEdge;      // Right side of box; # pixels from left window edge
    WORD bpi_BoxBottomEdge;     // Bottom side of box; # pixels from top window edge

    WORD bpi_BodyLeftEdge;      // Left side of body; # pixels from left window edge
    WORD bpi_BodyTopEdge;       // Top side of body; # pixels from top window edge
    WORD bpi_BodyRightEdge;     // Right side of body; # pixels from left window edge
    WORD bpi_BodyBottomEdge;    // Bottom side of body; # pixels from top window edge

    WORD bpi_SpaceLeft;         // Number of pixels the left space width is
    WORD bpi_TextLeft;          // Number of pixels the left text width is
    WORD bpi_BodyWidth;         // Number of pixels the body width is
    WORD bpi_TextRight;         // Number of pixels the right text width is
    WORD bpi_SpaceRight;        // Number of pixels the right space width is

    WORD bpi_SpaceAbove;        // Number of pixels space from TopEdge to text
    WORD bpi_TextAbove;         // Number of pixels high the above text is
    WORD bpi_BodyHeight;        // Number of pixels high body is
    WORD bpi_TextBelow;         // Number of pixels high the below text is
    WORD bpi_SpaceBelow;        // Number of pixels space from text to BottomEdge
};

/**
 ** This is the type used by most of the tags that describe some kind of
 ** size (ie line height, body width, etc).  The lower 16 bits tell the
 ** size (as a SIGNED value) and the upper 16 bits tell what this is relative to
 ** (ie, pixels, percent of a character width, etc) and the operation to
 ** perform (ie, add it to previous value).
 **/

typedef unsigned long TYPEDSIZE;

#define SIZE_STARTBIT (0)
#define SIZE_NUMBITS (16)
#define TYPE_STARTBIT (16)
#define TYPE_NUMBITS (8)
#define MODE_STARTBIT (24)
#define MODE_NUMBITS (7)

// Bit allocation:
//
// 3  2    2    2    1    1    0    0    0
// 1  8    4    0    6    2    8    4    0
// 0MMM MMMM TTTT TTTT SSSS SSSS SSSS SSSS
//
// M = Mode bits
// T = Type bits
// S = Size bits
// 0 = must be set to 0
// 1 = must be set to 1
// x = reserved.  always set to 0.

#define GETSIZE(tsize)  (( WORD)( ( ((TYPEDSIZE)(tsize)) >> SIZE_STARTBIT ) \
                                  & ((1<<SIZE_NUMBITS)-1) ))
#define GETTYPE(tsize)  ((ULONG)( ( ((TYPEDSIZE)(tsize)) >> TYPE_STARTBIT ) \
                                  & ((1<<TYPE_NUMBITS)-1) ))
#define GETMODE(tsize)  ((ULONG)( ( ((TYPEDSIZE)(tsize)) >> MODE_STARTBIT ) \
                                  & ((1<<MODE_NUMBITS)-1) ))

#define GO_TSIZE(mode,size,type) \
        ((TYPEDSIZE)( (((ULONG)(mode)&((1<<MODE_NUMBITS)-1))<<MODE_STARTBIT) \
                    | (((UWORD)(size)&((1<<SIZE_NUMBITS)-1))<<SIZE_STARTBIT) \
                    | (((ULONG)(type)&((1<<TYPE_NUMBITS)-1))<<TYPE_STARTBIT) \
        ))

// Bits descibing size modes
#define GOM_Std  0x10   // Bit values describing 'standard' size mode
                        // This is the minimum required size.
#define GOM_Pad  0x20   // Bit values describing 'padding' size mode
                        // This is space to remove if there is not enough room.
#define GOM_Var  0x40   // Bit values describing 'variable' size mode
                        // This is space to add if there is extra room.
#define GOM_Base 0x30   // Bit values describing base size.
                        // This is both the padding and standard sizes.
#define GOM_All  0x70   // Bit values describing all sizes.
                        // This is the combination of all three sizes.
#define GOM_MdMask 0x70 // All bits used to describe size mode

// Bits descibing size functions
#define GOM_Set  0x0    // Bit values for 'set' function
                        // Unconditionally sets the current value to this value.
#define GOM_Max  0x1    // Bit values for 'maximum' function
                        // Sets to the maximum of the current value and this value.
#define GOM_Min  0x2    // Bit values for 'minimum' function
                        // Sets to the minimum of the current value and this value.
#define GOM_Add  0x3    // Bit values for 'add' function
                        // Adds this value to the current value.
#define GOM_Mul  0x4    // Bit values for 'mul' function
                        // Multiplies this value with the current value.
#define GOM_Div  0x5    // Bit values for 'div' function
                        // Divides the current value by this value.
#define GOM_FnMask 0xF  // All bits used to describe size   function

#define GOM_StdSet (GOM_Set|GOM_Std)    // Make the size this value
#define GOM_StdMax (GOM_Max|GOM_Std)    // Final size can't be less than this
#define GOM_StdMin (GOM_Min|GOM_Std)    // Final size can't be greater than this
#define GOM_StdAdd (GOM_Add|GOM_Std)    // Add this value to total size
#define GOM_StdMul (GOM_Mul|GOM_Std)    // Multiply this value with it
#define GOM_StdDiv (GOM_Div|GOM_Std)    // Divide current value by this

#define GOM_PadSet (GOM_Set|GOM_Pad)    // Make the padding size this   value
#define GOM_PadMax (GOM_Max|GOM_Pad)    // Final padding size   can't be < this
#define GOM_PadMin (GOM_Min|GOM_Pad)    // Final size can't be greater than this
#define GOM_PadAdd (GOM_Add|GOM_Pad)    // Add this value to total padding size
#define GOM_PadMul (GOM_Mul|GOM_Pad)    // Multiply this value with it
#define GOM_PadDiv (GOM_Div|GOM_Pad)    // Divide current value by this

#define GOM_VarSet (GOM_Set|GOM_Var)    // Make the variable size this value
#define GOM_VarMax (GOM_Max|GOM_Var)    // Final variable size can't be < this
#define GOM_VarMin (GOM_Min|GOM_Var)    // Final size can't be greater than this
#define GOM_VarAdd (GOM_Add|GOM_Var)    // Add this value to total variable size
#define GOM_VarMul (GOM_Mul|GOM_Var)    // Multiply this value with it
#define GOM_VarDiv (GOM_Div|GOM_Var)    // Divide current value by this

#define GOM_BaseSet (GOM_Set|GOM_Base)  // Make the padding size this value
#define GOM_BaseMax (GOM_Max|GOM_Base)  // Final padding size   can't be < this
#define GOM_BaseMin (GOM_Min|GOM_Base)  // Final size can't be greater than this
#define GOM_BaseAdd (GOM_Add|GOM_Base)  // Add this value to total padding size
#define GOM_BaseMul (GOM_Mul|GOM_Base)  // Multiply this value with it
#define GOM_BaseDiv (GOM_Div|GOM_Base)  // Divide current value by this

#define GOM_AllSet (GOM_Set|GOM_All)    // Make the padding size this value
#define GOM_AllMax (GOM_Max|GOM_All)    // Final padding size can't be < this
#define GOM_AllMin (GOM_Min|GOM_All)    // Final size can't be greater than this
#define GOM_AllAdd (GOM_Add|GOM_All)    // Add this value to total padding size
#define GOM_AllMul (GOM_Mul|GOM_All)    // Multiply this value with it
#define GOM_AllDiv (GOM_Div|GOM_All)    // Divide current value by this

// Types of unit the supplied size is in.

// BASIC UNITS:  Have same value for GOM_Std, GOM_Pad, GOM_Var.

// These are the most basic of the basic units.
#define GOT_Pixels       0  // Absolute # pixels
#define GOT_PercCharW    1  // Percent of 1 character width
#define GOT_PercChar0    2  // Percent of 1 numeric character width
#define GOT_PercCharH    3  // Percent of 1 character height
#define GOT_PercScale    4  // Percent to scale current value

// These are basic units based on the limits on the outline size.
#define GOT_PercMinW     5  // Percentage of the minimum layout width
#define GOT_PercMinH     6  // Percentage of the minimum layout height
#define GOT_PercMaxW     7  // Percentage of the maximum layout width
#define GOT_PercMaxH     8  // Percentage of the maximum layout height

// NUMBERS 9 TO 19 RESERVED HERE

// These are basic units based on the data obtained from a tag that precedes
// this one which contains one or more text strings.
#define GOT_PercTextMinW 20 // Percentage of the smallest computed width
                            // of all the text strings using the current font
#define GOT_PercTextMinH 21 // Percentage of the smallest computed height
                            // of all the text strings using the current font
#define GOT_PercTextMaxW 22 // Percentage of the largest computed width
                            // of all the text strings using the current font
#define GOT_PercTextMaxH 23 // Percentage of the largest computed height
                            // of all the text strings using the current font
#define GOT_PercTextAddW 24 // Percentage of the addition of all the computed
                            // widths of the text strings using the current font
#define GOT_PercTextAddH 25 // Percentage of the addition of all the computed
                            // heights of the text strings using the current font
#define GOT_PercTextMinC 26 // Percentage of smallest number of chars in strs
#define GOT_PercTextMaxC 27 // Percentage of largest number of chars in strs
#define GOT_PercTextAddC 28 // Percentage of addition of number of chars in strs
#define GOT_PercTextAddL 29 // Percentage of total number of lines supplied

// NUMBERS 30 TO 39 RESERVED HERE

// These are basic units based on pixels available to the box from the
// group's minimum size.  (Ie, the difference between the box's minimum sizes
// and the minimum sizes that the box's parent group is using.)
// These are the values that are used to fill in a box's extra space when
// in GOCT_AutoDistExtra mode.  If GOCT_FitToGroup is on, these will always
// be zero.
#define GOT_PercFlSpaceL    40  // Percentage of fill space left
#define GOT_PercFlTextL     41  // Percentage of fill text left
#define GOT_PercFlBodyW     42  // Percentage of fill body width
#define GOT_PercFlTextR     43  // Percentage of fill text right
#define GOT_PercFlSpaceR    44  // Percentage of fill space right
#define GOT_PercFlBoxW      45  // Percentage of total fill width in box

#define GOT_PercFlSpaceA    46  // Percentage of fill space above
#define GOT_PercFlTextA     47  // Percentage of fill text above
#define GOT_PercFlBodyH     48  // Percentage of fill body height
#define GOT_PercFlTextB     49  // Percentage of fill text below
#define GOT_PercFlSpaceB    50  // Percentage of fill space below
#define GOT_PercFlBoxH      51  // Percentage of total fill height in box

// NUMBERS 52 TO 59 RESERVED HERE

// These are basic units based how much extra space has been allocated by
// the layout to the current box.  The individual parts are how the box's
// parent group wants to distribute the space.
#define GOT_PercExSpaceL    60  // Percentage of extra space left
#define GOT_PercExTextL     61  // Percentage of extra text left
#define GOT_PercExBodyW     62  // Percentage of extra body width
#define GOT_PercExTextR     63  // Percentage of extra text right
#define GOT_PercExSpaceR    64  // Percentage of extra space right
#define GOT_PercExBoxW      65  // Percentage of total extra width in box

#define GOT_PercExSpaceA    66  // Percentage of extra space above
#define GOT_PercExTextA     67  // Percentage of extra text above
#define GOT_PercExBodyH     68  // Percentage of extra body height
#define GOT_PercExTextB     69  // Percentage of extra text below
#define GOT_PercExSpaceB    70  // Percentage of extra space below
#define GOT_PercExBoxH      71  // Percentage of total extra height in box

// These are basic units which are the total amount of extra space
// allocated to the box which has not been used yet.
#define GOT_PercUnusedW     72  // Percentage of unused extra width
#define GOT_PercUnusedH     73  // Percentage of unused extra height

// NUMBERS 74 TO 89 RESERVED HERE

// These are basic units based on the total current values of the box.
// Each of these is the current sum of the std, pad and var modes.
#define GOT_PercSpaceL      90  // Percentage of space left width
#define GOT_PercTextL       91  // Percentage of text left width
#define GOT_PercBodyW       92  // Percentage of body width
#define GOT_PercTextR       93  // Percentage of text right width
#define GOT_PercSpaceR      94  // Percentage of space right width
#define GOT_PercSpaceA      95  // Percentage of space above height
#define GOT_PercTextA       96  // Percentage of text above height
#define GOT_PercBodyH       97  // Percentage of body height
#define GOT_PercTextB       98  // Percentage of text below height
#define GOT_PercSpaceB      99  // Percentage of space below height
#define GOT_PercUser1       100 // Percentage of the value in user variable 1
#define GOT_PercUser2       101 // Percentage of the value in user variable 2
// NUMBERS 102 TO 107 RESERVED HERE
#define GOT_PercBoxW        108 // Percentage of total box width
#define GOT_PercBoxH        109 // Percentage of total box width

// These are basic units based on the total current std mode values of the box.
#define GOT_PercStSpaceL    110 // Percentage of space left width
#define GOT_PercStTextL     111 // Percentage of text left width
#define GOT_PercStBodyW     112 // Percentage of body width
#define GOT_PercStTextR     113 // Percentage of text right width
#define GOT_PercStSpaceR    114 // Percentage of space right width
#define GOT_PercStSpaceA    115 // Percentage of space above height
#define GOT_PercStTextA     116 // Percentage of text above height
#define GOT_PercStBodyH     117 // Percentage of body height
#define GOT_PercStTextB     118 // Percentage of text below height
#define GOT_PercStSpaceB    119 // Percentage of space below height
#define GOT_PercStUser1     120 // Percentage of the value in user variable 1
#define GOT_PercStUser2     121 // Percentage of the value in user variable 2
// NUMBERS 122 TO 127 RESERVED HERE
#define GOT_PercStBoxW      128 // Percentage of total box width
#define GOT_PercStBoxH      129 // Percentage of total box width

// These are basic units based on the total current pad mode values of the box.
#define GOT_PercPdSpaceL    130 // Percentage of space left width
#define GOT_PercPdTextL     131 // Percentage of text left width
#define GOT_PercPdBodyW     132 // Percentage of body width
#define GOT_PercPdTextR     133 // Percentage of text right width
#define GOT_PercPdSpaceR    134 // Percentage of space right width
#define GOT_PercPdSpaceA    135 // Percentage of space above height
#define GOT_PercPdTextA     136 // Percentage of text above height
#define GOT_PercPdBodyH     137 // Percentage of body height
#define GOT_PercPdTextB     138 // Percentage of text below height
#define GOT_PercPdSpaceB    139 // Percentage of space below height
#define GOT_PercPdUser1     140 // Percentage of the value in user variable 1
#define GOT_PercPdUser2     141 // Percentage of the value in user variable 2
// NUMBERS 142 TO 147 RESERVED HERE
#define GOT_PercPdBoxW      148 // Percentage of total box width
#define GOT_PercPdBoxH      149 // Percentage of total box width

// These are basic units based on the total current var mode values of the box.
#define GOT_PercVrSpaceL    150 // Percentage of space left width
#define GOT_PercVrTextL     151 // Percentage of text left width
#define GOT_PercVrBodyW     152 // Percentage of body width
#define GOT_PercVrTextR     153 // Percentage of text right width
#define GOT_PercVrSpaceR    154 // Percentage of space right width
#define GOT_PercVrSpaceA    155 // Percentage of space above height
#define GOT_PercVrTextA     156 // Percentage of text above height
#define GOT_PercVrBodyH     157 // Percentage of body height
#define GOT_PercVrTextB     158 // Percentage of text below height
#define GOT_PercVrSpaceB    159 // Percentage of space below height
#define GOT_PercVrUser1     160 // Percentage of the value in user variable 1
#define GOT_PercVrUser2     161 // Percentage of the value in user variable 2
// NUMBERS 162 TO 167 RESERVED HERE
#define GOT_PercVrBoxW      168 // Percentage of total box width
#define GOT_PercVrBoxH      169 // Percentage of total box width

// NUMBERS 170 TO 219 RESERVED HERE

// COMPLEX UNITS:  Have different values for GOM_Std, GOM_Pad, GOM_Var.

// These are complex units based on the current values of the box.
#define GOT_PercMdSpaceL    220 // Percentage of space left width
#define GOT_PercMdTextL     221 // Percentage of text left width
#define GOT_PercMdBodyW     222 // Percentage of body width
#define GOT_PercMdTextR     223 // Percentage of text right width
#define GOT_PercMdSpaceR    224 // Percentage of space right width
#define GOT_PercMdSpaceA    225 // Percentage of space above height
#define GOT_PercMdTextA     226 // Percentage of text above height
#define GOT_PercMdBodyH     227 // Percentage of body height
#define GOT_PercMdTextB     228 // Percentage of text below height
#define GOT_PercMdSpaceB    229 // Percentage of space below height
#define GOT_PercMdUser1     230 // Percentage of the value in user variable 1
#define GOT_PercMdUser2     231 // Percentage of the value in user variable 2
// NUMBERS 232 TO 237 RESERVED HERE
#define GOT_PercMdBoxW      238 // Percentage of total box width
#define GOT_PercMdBoxH      239 // Percentage of total box width

// These are complex units based on the default values for the box.
#define GOT_PercDfSpaceL    240 // Percentage of space left width
#define GOT_PercDfTextL     241 // Percentage of text left width
#define GOT_PercDfBodyW     242 // Percentage of body width
#define GOT_PercDfTextR     243 // Percentage of text right width
#define GOT_PercDfSpaceR    244 // Percentage of space right width

#define GOT_PercDfSpaceA    245 // Percentage of space above height
#define GOT_PercDfTextA     246 // Percentage of text above height
#define GOT_PercDfBodyH     247 // Percentage of body height
#define GOT_PercDfTextB     248 // Percentage of text below height
#define GOT_PercDfSpaceB    249 // Percentage of space below height

// This is a special type which is used to find the size of another
// box.  The 'value' part of the typed size is divided into two parts;
// the lower 12 bits are the StdID of the box to get the size from,
// and the upper 4 bits area one of the following sizes.
// Note that these sizes are not computed until after all of the groups
// and boxes have been sized, so they are not available when setting
// the size of a box or group during layout.
#define GOT_BoxSize 255

// All of these return the actual number of pixels.
#define GOTB_BoxLeft    0x0000          // Get the box's absolute left position.
#define GOTB_BoxTop     0x1000          // Get the box's absolute top position.
#define GOTB_BoxWidth   0x2000          // Get the box's absolute width.
#define GOTB_BoxHeight  0x3000          // Get the box's absolute height.
#define GOTB_BodyLeft   0x4000          // Get the box's absolute body left pos.
#define GOTB_BodyTop    0x5000          // Get the box's absolute body top pos.
#define GOTB_SpaceLeft  0x6000          // Get the box's absolute spc left size.
#define GOTB_TextLeft   0x7000          // Get the box's absolute txt left size.
#define GOTB_BodyWidth  0x8000          // Get the box's absolute body width.
#define GOTB_TextRight  0x9000          // Get the box's absolute txt rgt size.
#define GOTB_SpaceRight 0xA000          // Get the box's absolute spc rgt size.
#define GOTB_SpaceAbove 0xB000          // Get the box's absolute spc abv size.
#define GOTB_TextAbove  0xC000          // Get the box's absolute txt abv size.
#define GOTB_BodyHeight 0xD000          // Get the box's absolute body height.
#define GOTB_TextBelow  0xE000          // Get the box's absolute txt blw size.
#define GOTB_SpaceBelow 0xF000          // Get the box's absolute spc blw size.

#define GO_BSIZE(mode,stdid,which) GO_TSIZE(mode,(which&0xF000)|GETSTDID(stdid),GOT_BoxSize)

/**
 ** Special type for defining a tag which links one gadget to another
 **/
typedef unsigned long TAGLINK;

#define LNKCMD_STARTBIT (0)     // ID of command object to create link to.
#define LNKCMD_NUMBITS (12)
#define LNKTAG_STARTBIT (12)    // Lower 20 bits of link tag.
#define LNKTAG_NUMBITS (20)

// Bit allocation:
//
// 3  2    2    2    1    1    0    0    0
// 1  8    4    0    6    2    8    4    0
// TTTT TTTT TTTT TTTT TTTT CCCC CCCC CCCC
//
// T = Tag ID type bits
// C = Command ID bits
// x = reserved.  always set to 0.

#define GETLNKCMD(tlink) ((ULONG)( ( ((TAGLINK)(tlink)) >> LNKCMD_STARTBIT ) \
                                 & ((1<<LNKCMD_NUMBITS)-1) ))
#define GETLNKTAG(tlink) ((ULONG)( ( ( ((TAGLINK)(tlink)) >> LNKTAG_STARTBIT ) \
                                   & ((1<<LNKTAG_NUMBITS)-1) \
                                  ) | TAG_USER ))

#define GO_MAKELINK(tag,cmd) \
        ((TAGLINK)( (((ULONG)(tag)&((1<<LNKTAG_NUMBITS)-1))<<LNKTAG_STARTBIT) \
                  | (((ULONG)(cmd)&((1<<LNKCMD_NUMBITS)-1))<<LNKCMD_STARTBIT) \
        ))

/***
 *** Tags after this number are free for use by the user to pass data
 *** to custom hook code through the main tag list.
 ***/

#define GOCT_User (TAG_USER+0xC000)

/***
 *** These are the GadgetOutline Command Tags that are used in the
 *** main (first) tag list of an outline command.
 ***/

#define TAG_OUTLINE_CMDBASE (TAG_USER+0x9000)

#define TAG_OUTLINE_TYPEDSIZE (TAG_OUTLINE_CMDBASE+0x100)

// These are the position-dependant typed size command tags.  They are
// sequentially parsed when computing typed sizes.

#define GOCT_TextArray  (TAG_OUTLINE_TYPEDSIZE+1)
     /* UBYTE **
      * Takes the NULL-terminated array of string pointers (as supplied
      * to GadTools' Cycle and MX kinds), examines their width and height
      * in the current font, and sets the GOT_PercText* variables for use
      * in size tags following this one.
      *
      * Default: All values 0
      */

#define GOCT_TextList   (TAG_OUTLINE_TYPEDSIZE+2)
     /* struct List *
      * Takes the list of nodes with ln_Name filled in (as supplied
      * to GadTools' ListView kind), examines their width and height
      * in the current font, and sets the GOT_PercText* variables for use
      * in size tags following this one.
      *
      * Default: 0
      */

#define GOCT_TextPtr    (TAG_OUTLINE_TYPEDSIZE+3)
     /* UBYTE *
      * Takes the text string, examines its width and height in the current
      * font, and sets the GOT_PercText* variables for use in size tags
      * following this one.
      *
      * Default: 0
      */

#define GOCT_MoreTextArray  (TAG_OUTLINE_TYPEDSIZE+4)
     /* UBYTE **
      * Same as GOCT_TextArray, but continues with dimensions from
      * the previous time.
      */

#define GOCT_MoreTextList   (TAG_OUTLINE_TYPEDSIZE+5)
     /* struct List *
      * Same as GOCT_TextList, but continues with dimensions from
      * the previous time.
      */

#define GOCT_MoreTextPtr    (TAG_OUTLINE_TYPEDSIZE+6)
     /* UBYTE *
      * Same as GOCT_TextPtr, but continues with dimensions from
      * the previous time.
      */

#define GOCT_TextArrayTag   (TAG_OUTLINE_TYPEDSIZE+7)
#define GOCT_TextListTag    (TAG_OUTLINE_TYPEDSIZE+8)
#define GOCT_TextPtrTag (TAG_OUTLINE_TYPEDSIZE+9)
#define GOCT_MoreTextArrayTag   (TAG_OUTLINE_TYPEDSIZE+10)
#define GOCT_MoreTextListTag    (TAG_OUTLINE_TYPEDSIZE+11)
#define GOCT_MoreTextPtrTag (TAG_OUTLINE_TYPEDSIZE+12)
     /* Tag
      * These work identically to the previous tags, except they get their
      * pointer to the text/array/list from the specified tag in the
      * object tag list.  Ie, ..., GOCT_TextPtrTag, GTST_String, ...
      * would get the pointer to a string from the first tag of type
      * GTST_String in the GadTools tag list.
      */


#define GOCT_SizeParse  (TAG_OUTLINE_TYPEDSIZE+13)
     /* TYPEDSIZE
      * Special TypedSize tag used in the ParseTypedSizeList() taglist.
      */

// TAG NUMBERS 14 TO 29 RESERVED HERE

#define GOCT_SizeSpaceLeft  (TAG_OUTLINE_TYPEDSIZE+30)
     /* TYPEDSIZE
      * Set the amount of space to put between this box and box to the left.
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfSpaceL)
      */

#define GOCT_SizeTextLeft   (TAG_OUTLINE_TYPEDSIZE+31)
     /* TYPEDSIZE
      * Set the width of the left text area.
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfTextL)
      */

#define GOCT_SizeBodyWidth  (TAG_OUTLINE_TYPEDSIZE+32)
     /* TYPEDSIZE
      * Set the width of the box's body.
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfBodyW)
      */

#define GOCT_SizeTextRight  (TAG_OUTLINE_TYPEDSIZE+33)
     /* TYPEDSIZE
      * Set the width of the right text area.
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfTextR)
      */

#define GOCT_SizeSpaceRight (TAG_OUTLINE_TYPEDSIZE+34)
     /* TYPEDSIZE
      * Set the amount of space to put between this box and box to the right.
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfSpaceR)
      */

#define GOCT_SizeSpaceAbove (TAG_OUTLINE_TYPEDSIZE+35)
     /* TYPEDSIZE
      * Set the amount of space to put between this line and the line above it.
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfSpaceA)
      */

#define GOCT_SizeTextAbove  (TAG_OUTLINE_TYPEDSIZE+36)
     /* TYPEDSIZE
      * Set the height of the top text area.
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfTextA)
      */

#define GOCT_SizeBodyHeight (TAG_OUTLINE_TYPEDSIZE+37)
     /* TYPEDSIZE
      * Set the line's body height
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfBodyH)
      */

#define GOCT_SizeTextBelow  (TAG_OUTLINE_TYPEDSIZE+38)
     /* TYPEDSIZE
      * Set the height of the bottom text area.
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfTextB)
      */

#define GOCT_SizeSpaceBelow (TAG_OUTLINE_TYPEDSIZE+39)
     /* TYPEDSIZE
      * Set the amount of space to put between this line and the line below it.
      *
      * Default: GO_TSIZE(GOM_AllSet,100,GOT_PercDfSpaceB)
      */

#define GOCT_SizeUser1  (TAG_OUTLINE_TYPEDSIZE+40)
#define GOCT_SizeUser2  (TAG_OUTLINE_TYPEDSIZE+41)
     /* TYPEDSIZE
      * Set user size variables for later use.
      *
      * These variables are completely unused by the library, except that
      * the User1 padding is scaled by the amount of total padding width the
      * box is scaled, and User2 is similarily scaled by the box's padding
      * height.
      *
      * Default: GO_TSIZE(GOM_AllSet,0,GOT_Pixels)
      */

// TAG NUMBERS 42 TO 79 RESERVED HERE

#define GOCT_SetBoxLeft     (TAG_OUTLINE_TYPEDSIZE+80)
#define GOCT_SetBoxTop      (TAG_OUTLINE_TYPEDSIZE+81)
#define GOCT_SetBoxWidth    (TAG_OUTLINE_TYPEDSIZE+82)
#define GOCT_SetBoxHeight   (TAG_OUTLINE_TYPEDSIZE+83)
#define GOCT_SetBodyLeft    (TAG_OUTLINE_TYPEDSIZE+84)
#define GOCT_SetBodyTop     (TAG_OUTLINE_TYPEDSIZE+85)
#define GOCT_SetSpaceLeft   (TAG_OUTLINE_TYPEDSIZE+86)
#define GOCT_SetTextLeft    (TAG_OUTLINE_TYPEDSIZE+87)
#define GOCT_SetBodyWidth   (TAG_OUTLINE_TYPEDSIZE+88)
#define GOCT_SetTextRight   (TAG_OUTLINE_TYPEDSIZE+89)
#define GOCT_SetSpaceRight  (TAG_OUTLINE_TYPEDSIZE+90)
#define GOCT_SetSpaceAbove  (TAG_OUTLINE_TYPEDSIZE+91)
#define GOCT_SetTextAbove   (TAG_OUTLINE_TYPEDSIZE+92)
#define GOCT_SetBodyHeight  (TAG_OUTLINE_TYPEDSIZE+93)
#define GOCT_SetTextBelow   (TAG_OUTLINE_TYPEDSIZE+94)
#define GOCT_SetSpaceBelow  (TAG_OUTLINE_TYPEDSIZE+95)
     /* TYPEDSIZE
      * Directly set box's final dimensions.
      *
      * These are used to directly set a box's dimensions as shown in
      * its BoxAttr structure.  They are parsed after the gadgets have
      * been fully layed out, for every command which has a BoxAttr.
      *
      * Note that there is some redundancy in the dimension information
      * between the total box size, the body position and the individual
      * size components.  You may enter "-1" into any of the dimensions
      * that you do not care about; they will then be computed from the
      * other dimension information or default to 0.
      *
      * Default: Boxes and Groups start with everything filled in
      *          correctly from the layout; Images start with everything
      *          set to -1.
      */

// These are mostly position-independant command tags [at least in the sense
// that their position relative to the typed size tags doesn't matter. :)]
// However, all of these tags can be included multiple times and some pairs
// may been to be grouped together, as described for those specific tags.

#define TAG_OUTLINE_MULTITAG (TAG_OUTLINE_CMDBASE+0x200)

#define GOCT_AddTagLink (TAG_OUTLINE_MULTITAG+0)
     /* TAGLINK
      * Add a link from this cmd's secondary tag list to another cmd's object.
      *
      * For every one of these tags in the cmd's tag list, space is reserved
      * in the secondary tag list for a single tag.  At the time that the
      * objects are being created, these links are filled in with the
      * address of the object that the link points to.  If any of the links
      * point to a object that hasn't been created yet, the creation of
      * the current object is delayed.  If it is imposible to resolve
      * all of the links (ie, two object pointing to each other), then
      * neither of the objects will be created.
      *
      * Multiple instances of this tag may occur.
      *
      * Default: No links.
      */

#define GOCT_LinkFromTag (TAG_OUTLINE_MULTITAG+1)
     /* Tag
      * Specify the secondary tag that will point to a object in the outline.
      */
#define GOCT_LinkToStdID (TAG_OUTLINE_MULTITAG+2)
     /* ULONG
      * Specify the standard CmdID the previously specified tag will point to.
      *
      * This pair of tags operates identically to the GOCT_AddTagLink tag,
      * except it allows the full tag value to be specified.
      *
      * This pair of tags is used to create a link between objects.
      * They must come in the exact order:
      *   ..., GOCT_LinkFromTag, TagItem, GOCT_LinkToStdID, StdID, ...
      *
      * Multiple instances of this tag pair may occur.
      *
      * Default: No links.
      */

#define GOCT_CopyFromTSize (TAG_OUTLINE_MULTITAG+3)
     /* TYPEDSIZE
      * Specify a TypedSize value to copy from...
      */
#define GOCT_CopyTSizeToTag (TAG_OUTLINE_MULTITAG+4)
     /* TAG
      * Specify the Tag the previously specified value will be copied to.
      *
      * Multiple instances of this tag pair may occur.  These are used
      * to put a value into a tag in the secondary list before any
      * processing is done on the command to compute its dimensions.
      * These tags are processed immediately before sending the
      * CHM_GETMINDIMENS message to the command's hook.
      *
      * These must come in the exact order:
      *   ..., GOCT_CopyFromTSize, TypedSize, GOCT_CopyTSizeToTag, Tag, ...
      *
      * Default: Nothing copied.
      */

#define GOCT_CopyUser1ToTag (TAG_OUTLINE_MULTITAG+5)
#define GOCT_CopyUser2ToTag (TAG_OUTLINE_MULTITAG+6)
     /* Tag
      * Copy the current value in the User1 variable to the given
      * tag in the secondary tag list.
      *
      * Multiple instances of these tags may occur.  They are always
      * processed after all of the variable-spacing typed size tags
      * have been processed.  [Ie, when the final positions of the
      * objects are finally being computed.]  The value copied is the
      * sum of the std, pad and var components of the user variable.
      *
      * Default: Nothing copied.
      */

// TAG NUMBERS 7 TO 29 RESERVED HERE

#define GOCT_CopyScreen     (TAG_OUTLINE_MULTITAG+30)
#define GOCT_CopyWindow     (TAG_OUTLINE_MULTITAG+31)
#define GOCT_CopyDrawInfo   (TAG_OUTLINE_MULTITAG+32)
#define GOCT_CopyDrawPens   (TAG_OUTLINE_MULTITAG+33)
#define GOCT_CopyVisualInfo (TAG_OUTLINE_MULTITAG+34)
#define GOCT_CopyTextAttr   (TAG_OUTLINE_MULTITAG+35)
#define GOCT_CopyTextFont   (TAG_OUTLINE_MULTITAG+36)
     /* Tag
      * Copy global GadOutline information into a tag.
      *
      * Multiple instances of these tags may occur.  These are processed
      * before the gadgets are first created on a window.  They are
      * used to supply extra information to BOOPSI gadgets about the
      * screen and window they will be rendering into.
      *
      * Default: Nothing copied.
      */

// The rest of the tags can only occur once; if any occur both in the
// GO_COMMANDTAGS() global list and in the command's actual list, the
// command's list takes precedence.

// These are the standard command tags.

#define TAG_OUTLINE_COMMAND (TAG_OUTLINE_CMDBASE+0x800)

#define GOCT_SetUserHook (TAG_OUTLINE_COMMAND+0)
     /* struct Hook *
      * Set the user hook function for this command.
      * If NULL, only use system function.
      *
      * Default: NULL
      */

#define GOCT_SetUserHookData (TAG_OUTLINE_COMMAND+1)
     /* ULONG
      * Set initial value for ci_UserHookData.
      *
      * Default: NULL
      */

#define HOTKEY_NOTRANS  (1<<31)     // Don't translate given character into
                                    // upper- and lower-case versions.
#define HOTKEY_UPONLY   (1<<30)     // Assign only the upper-case version of
                                    // this character to the command.
#define HOTKEY_LOWONLY  (1<<29)     // Assign only the lower-case version of
                                    // this character to the command.
#define HOTKEY_NONE     (HOTKEY_UPONLY | HOTKEY_LOWONLY)
                                    // Don't assign any hotkey.
#define HOTKEY_CHARACTER (0xFF)     // Mask for the actual character.

#define GOCT_SetHotKey (TAG_OUTLINE_COMMAND+2)
     /* ULONG
      * Define a hotkey for this command.
      *
      * Accepts an ASCII code which is to be assigned as this command's
      * hotkey.  Whenever this key is pressed [and, if only RAWKEY
      * events are being reported, when it is released], a CHM_HOTKEY
      * event will be sent to the command.  An ASCII value of 0 is
      * interpreted as 'let the command assign a hotkey for me.'
      * The standard GadTools hook supports this by looking for the
      * underlined character in a label and using that as the key.
      *
      * Default: No hot key.
      */

#define GOCT_SetHotKeyCmd (TAG_OUTLINE_COMMAND+3)
     /* CMDID
      * Define actual command which recieves hotkeys for this command.
      *
      * This tag provides a way for you to 'redirect' hotkeys.  It is
      * primarily intended for you to use a GadTools gadget to render
      * the text describing another gadget - the text gadget is created
      * with an underline for the appropriate hotkey.  This gadget
      * then has the tag GOCT_SetHotKey, 0 so that the hotkey is
      * automatically assigned, and GOCT_SetHotKeyCmd with the CmdID
      * of the actually command which is to recieve these hotkey events.
      *
      * Note that only one level of this indirection is supported.
      *
      * Default: ID of this command
      */

// These are command tags for boxes and groups.  (GOK_Box, GOK_Group)

#define TAG_OUTLINE_BOX (TAG_OUTLINE_CMDBASE+0x900)

#define GOCT_BoxPosInfo (TAG_OUTLINE_BOX+0)
     /* struct BoxPosInfo *
      * Supplies the address to a valid 'BoxPosInfo' structure, which
      * will be filled in with the current size of this box during
      * a Resize.  If the address is ~0, the library will allocate
      * this structure.
      *
      * Default: 0
      */

#define GOCT_IgnoreMinDimens (TAG_OUTLINE_BOX+1)
     /* BOOL
      * If TRUE, ignore this command's dimensions when computing the
      * minimum dimensions needed for the layout.
      *
      * Default: FALSE
      */

#define GOCT_IgnoreFinDimens (TAG_OUTLINE_BOX+2)
     /* BOOL
      * If TRUE, ignore this command's dimensions when computing the
      * final dimensions/spacing of the layout.
      *
      * Default: FALSE
      */

#define GOCT_IgnoreCreation (TAG_OUTLINE_BOX+3)
     /* BOOL
      * If TRUE, do not actually create the object.
      *
      * Default: FALSE
      */

// These are for groups only.

#define TAG_OUTLINE_GROUP (TAG_OUTLINE_CMDBASE+0xA00)

#define GOCT_FrameGroup (TAG_OUTLINE_GROUP+130)
     /* BOOL
      * If TRUE, any minimum dimensions in this group's outside space area
      * (ie, SpaceAbove, SpaceBelow, SpaceLeft and SpaceRight), is reserved
      * only for the group, and any boxes or groups within it are positioned
      * inside of this area.  By default this space is zero, so you will have
      * to use the GOCT_SizeSpaceLeft, etc. tags to make this space show up.
      *
      * Default: TRUE
      */

#define GOCT_AutoDistExtra (TAG_OUTLINE_GROUP+131)
     /* BOOL
      * If TRUE, the extra space created by the difference between the box's
      * dimensions and its parent group's minimum dimensions are distributed
      * in the box to make it match the group.
      *
      * Default: FALSE
      */

#define GOCT_FitToGroup (TAG_OUTLINE_GROUP+132)
     /* BOOL
      * If TRUE, this box's minimum dimensions are stretched to match
      * its parent group's minimum dimensions.
      *
      * Default: FALSE
      */

#define GOCT_EvenDistGroup (TAG_OUTLINE_GROUP+133)
     /* BOOL
      * If TRUE, the boxes within the group will be forced to all have
      * the same size across the group's weight dimension.  [Ie, the
      * vertical component within a vertical group.]
      * In other words, all the boxes within a vertical group will
      * be given the same height, constrained by the largest box.
      *
      * Default: FALSE
      */

/**
 ** ----------------------------------------------------------
 ** GadOutline drawing definitions.
 ** ----------------------------------------------------------
 **/

/**
 ** This is the type used by most of the drawing commands that take
 ** coordinates as arguments.  It contains at most a pen to draw in
 ** plus two coordinate pairs and a mode which controls how the
 ** coordinates are interpreted, although how much of this is actually
 ** used is command-specific.
 **/

typedef unsigned long DRAWPNT;

#define PNTY2_STARTBIT (0)
#define PNTY2_NUMBITS (6)
#define PNTX2_STARTBIT (6)
#define PNTX2_NUMBITS (6)
#define PNTY1_STARTBIT (12)
#define PNTY1_NUMBITS (6)
#define PNTX1_STARTBIT (18)
#define PNTX1_NUMBITS (6)
#define PNTPEN_STARTBIT (24)
#define PNTPEN_NUMBITS (4)
#define PNTMODE_STARTBIT (28)
#define PNTMODE_NUMBITS (4)

// Bit allocation:
//
// 3  2    2    2    1    1    0    0    0
// 1  8    4    0    6    2    8    4    0
// MMMM PPPP xxxx xxyy yyyy XXXX XXYY YYYY
//
// M = Mode bits
// P = Pen bits
// x = x1 coord bits
// y = y1 coord bits
// X = x2 coord bits
// Y = y2 coord bits

#define GETPNTY2(drawpnt)   ((UBYTE)( ( ((DRAWPNT)(drawpnt)) >> PNTY2_STARTBIT ) \
                                  & ((1<<PNTY2_NUMBITS)-1) ))
#define GETPNTX2(drawpnt)   ((UBYTE)( ( ((DRAWPNT)(drawpnt)) >> PNTX2_STARTBIT ) \
                                  & ((1<<PNTX2_NUMBITS)-1) ))
#define GETPNTY1(drawpnt)   ((UBYTE)( ( ((DRAWPNT)(drawpnt)) >> PNTY1_STARTBIT ) \
                                  & ((1<<PNTY1_NUMBITS)-1) ))
#define GETPNTX1(drawpnt)   ((UBYTE)( ( ((DRAWPNT)(drawpnt)) >> PNTX1_STARTBIT ) \
                                  & ((1<<PNTX1_NUMBITS)-1) ))
#define GETPNTPEN(drawpnt)  ((UBYTE)( ( ((DRAWPNT)(drawpnt)) >> PNTPEN_STARTBIT ) \
                                  & ((1<<PNTPEN_NUMBITS)-1) ))
#define GETPNTMODE(drawpnt) ((UBYTE)( ( ((DRAWPNT)(drawpnt)) >> PNTMODE_STARTBIT ) \
                                  & ((1<<PNTMODE_NUMBITS)-1) ))

#define GO_DRAWPNT(mode,pen,x1,y1,x2,y2) \
        ((DRAWPNT)( (((ULONG)(mode)&((1<<PNTMODE_NUMBITS)-1))<<PNTMODE_STARTBIT) \
                  | (((ULONG)(pen)&((1<<PNTPEN_NUMBITS)-1))<<PNTPEN_STARTBIT) \
                  | (((UWORD)(x1)&((1<<PNTX1_NUMBITS)-1))<<PNTX1_STARTBIT) \
                  | (((UWORD)(y1)&((1<<PNTY1_NUMBITS)-1))<<PNTY1_STARTBIT) \
                  | (((UWORD)(x2)&((1<<PNTX2_NUMBITS)-1))<<PNTX2_STARTBIT) \
                  | (((UWORD)(y2)&((1<<PNTY2_NUMBITS)-1))<<PNTY2_STARTBIT) \
        ))

#define SCALE_MODE (0x0)
#define PIXEL_MODE (0x1)

#define GO_SCLPNT(pen,x1,y1,x2,y2) \
        GO_DRAWPNT(SCALE_MODE,pen,x1,y1,x2,y2)

#define PX1(x) (((UWORD)x)&((1<<(PNTX1_NUMBITS-1))-1))
#define PX2(x) ( (((UWORD)x)&((1<<(PNTX1_NUMBITS-1))-1)) | (1<<(PNTX1_NUMBITS-1)) )
#define PY1(y) (((UWORD)y)&((1<<(PNTY1_NUMBITS-1))-1))
#define PY2(y) ( (((UWORD)y)&((1<<(PNTY1_NUMBITS-1))-1)) | (1<<(PNTY1_NUMBITS-1)) )

#define GO_PIXPNT(pen,x1,y1,x2,y2) \
        GO_DRAWPNT(PIXEL_MODE,pen,x1,y1,x2,y2)

#define TAG_OUTLINE_DRAWBASE (TAG_USER+0xA000)

// Commands to control drawing pens.

#define TAG_OUTLINE_PENBASE (TAG_OUTLINE_DRAWBASE+1)

#define GODT_SetPen0        TAG_OUTLINE_PENBASE+0
#define GODT_SetPen1        TAG_OUTLINE_PENBASE+1
#define GODT_SetPen2        TAG_OUTLINE_PENBASE+2
#define GODT_SetPen3        TAG_OUTLINE_PENBASE+3
#define GODT_SetPen4        TAG_OUTLINE_PENBASE+4
#define GODT_SetPen5        TAG_OUTLINE_PENBASE+5
#define GODT_SetPen6        TAG_OUTLINE_PENBASE+6
#define GODT_SetPen7        TAG_OUTLINE_PENBASE+7
#define GODT_SetPen8        TAG_OUTLINE_PENBASE+8
#define GODT_SetPen9        TAG_OUTLINE_PENBASE+9
#define GODT_SetPen10       TAG_OUTLINE_PENBASE+10
#define GODT_SetPen11       TAG_OUTLINE_PENBASE+11
#define GODT_SetPen12       TAG_OUTLINE_PENBASE+12
#define GODT_SetPen13       TAG_OUTLINE_PENBASE+13
#define GODT_SetPen14       TAG_OUTLINE_PENBASE+14
#define GODT_SetPen15       TAG_OUTLINE_PENBASE+15
// Synonyms
#define GODT_SetDetailPen           TAG_OUTLINE_PENBASE+DETAILPEN
#define GODT_SetBlockPen            TAG_OUTLINE_PENBASE+BLOCKPEN
#define GODT_SetTextPen             TAG_OUTLINE_PENBASE+TEXTPEN
#define GODT_SetShinePen            TAG_OUTLINE_PENBASE+SHINEPEN
#define GODT_SetShadowPen           TAG_OUTLINE_PENBASE+SHADOWPEN
#define GODT_SetFillPen             TAG_OUTLINE_PENBASE+FILLPEN
#define GODT_SetFillTextPen         TAG_OUTLINE_PENBASE+FILLTEXTPEN
#define GODT_SetBackgroundPen       TAG_OUTLINE_PENBASE+BACKGROUNDPEN
#define GODT_SetHighlightTextPen    TAG_OUTLINE_PENBASE+HIGHLIGHTTEXTPEN
#define GODT_SetDrI9Pen             TAG_OUTLINE_PENBASE+9
#define GODT_SetDrI10Pen            TAG_OUTLINE_PENBASE+10
#define GODT_SetDrI11Pen            TAG_OUTLINE_PENBASE+11
#define GODT_SetDrI12Pen            TAG_OUTLINE_PENBASE+12
#define GODT_SetDrI13Pen            TAG_OUTLINE_PENBASE+13
#define GODT_SetDrI14Pen            TAG_OUTLINE_PENBASE+14
#define GODT_SetDrI15Pen            TAG_OUTLINE_PENBASE+15
     /* ULONG
      * Set the color of a standard system pen.
      *
      * These pens correspond to the screen's DrawInfo pens, and are
      * initialized to the values there before starting the draw.
      * Pen0 and Pen1 are special in that they coorespond to the RastPort's
      * A and B pens, in that they are the pens used by drawing commands that
      * don't take an explicit pen specification.
      */

// TAG NUMBERS 16 TO 29 RESERVED HERE

#define GODT_SetDrawInfo        (TAG_OUTLINE_PENBASE+30)
     /* struct DrawInfo *
      * Supply a custom DrawInfo.
      *
      * Extracts information from the given DrawInfo to be used in
      * the drawing.  Currently all this does is extract the dri_Pens,
      * although more could be done in the future.
      *
      * A NULL will reset from the GadOutline's go_DrI.
      *
      * Default: Use go_DrI
      */

#define GODT_SetDrawPens        (TAG_OUTLINE_PENBASE+31)
     /* UWORD *
      * Set pens from the given pen array.
      *
      * Takes a ~0 terminated pen array and sets the drawing's pens
      * based on it.  If the array ends before all of the pens have
      * been set, the remaining pens will be unchanged.
      *
      * Default: Use go_DrI->dri_DrawPens
      */

// TAG NUMBERS 32 TO 34 RESERVED HERE

#define GODT_SetCompPenMap      (TAG_OUTLINE_PENBASE+35)
     /* UWORD *
      * Set compliment pen mapping from the given array.
      *
      * Takes a ~0 terminated array and sets the drawing's compliment
      * pen map based on it.  If the array ends before all of the pens
      * have been set, the remaining pens will be unchanged.
      *
      * Default Compliment map:
      *           DETAILPEN --> BLOCKPEN
      *            BLOCKPEN --> DETAILPEN
      *             TEXTPEN --> BACKGROUNDPEN
      *            SHINEPEN --> SHADOWPEN
      *           SHADOWPEN --> SHINEPEN
      *             FILLPEN --> FILLTEXTPEN
      *         FILLTEXTPEN --> FILLPEN
      *       BACKGROUNDPEN --> TEXTPEN
      *    HIGHLIGHTTEXTPEN --> BACKGROUNDPEN
      */

#define GODT_SetUserPenMap      (TAG_OUTLINE_PENBASE+36)
     /* UWORD *
      * Set user pen mapping from the given array.
      *
      * Takes a ~0 terminated array and sets the drawing's user
      * pen map based on it.  If the array ends before all of the pens
      * have been set, the remaining pens will be unchanged.
      *
      * Default user map:
      *           DETAILPEN --> DETAILPEN
      *            BLOCKPEN --> BLOCKPEN
      *             TEXTPEN --> TEXTPEN
      *            SHINEPEN --> SHINEPEN
      *           SHADOWPEN --> SHADOWPEN
      *             FILLPEN --> FILLPEN
      *         FILLTEXTPEN --> FILLTEXTPEN
      *       BACKGROUNDPEN --> BACKGROUNDPEN
      *    HIGHLIGHTTEXTPEN --> HIGHLIGHTTEXTPEN
      */

#define GODT_SetHighPenMap      (TAG_OUTLINE_PENBASE+37)
     /* UWORD *
      * Set highlight pen mapping from the given array.
      *
      * Takes a ~0 terminated array and sets the drawing's highlight
      * pen map based on it.  If the array ends before all of the pens
      * have been set, the remaining pens will be unchanged.
      *
      * Default Highlight map:
      *           DETAILPEN --> BLOCKPEN
      *            BLOCKPEN --> DETAILPEN
      *             TEXTPEN --> FILLTEXTPEN
      *            SHINEPEN --> SHADOWPEN
      *           SHADOWPEN --> SHINEPEN
      *             FILLPEN --> BACKGROUNDPEN
      *         FILLTEXTPEN --> TEXTPEN
      *       BACKGROUNDPEN --> FILLPEN
      *    HIGHLIGHTTEXTPEN --> FILLTEXTPEN
      */

#define GODT_SetInactPenMap     (TAG_OUTLINE_PENBASE+38)
     /* UWORD *
      * Set inactive pen mapping from the given array.
      *
      * Takes a ~0 terminated array and sets the drawing's inactive
      * pen map based on it.  If the array ends before all of the pens
      * have been set, the remaining pens will be unchanged.
      *
      * Default Inactive map:
      *           DETAILPEN --> DETAILPEN
      *            BLOCKPEN --> BLOCKPEN
      *             TEXTPEN --> TEXTPEN
      *            SHINEPEN --> BACKGROUNDPEN
      *           SHADOWPEN --> SHADOWPEN
      *             FILLPEN --> BACKGROUNDPEN
      *         FILLTEXTPEN --> TEXTPEN
      *       BACKGROUNDPEN --> BACKGROUNDPEN
      *    HIGHLIGHTTEXTPEN --> TEXTPEN
      */

// TAG NUMBERS 39 TO 42 RESERVED HERE

#define GO_MAPPEN(from,to) ( ((from)<<16) | ((to)&0xFFFF) )

#define GODT_MapCompPen     (TAG_OUTLINE_PENBASE+43)
#define GODT_MapUserPen     (TAG_OUTLINE_PENBASE+44)
#define GODT_MapHighPen     (TAG_OUTLINE_PENBASE+45)
#define GODT_MapInactPen    (TAG_OUTLINE_PENBASE+46)
     /* ULONG
      * Set a single pen map entry.
      *
      * Sets the single pen map entry in the upper 16 bits to the
      * pen in the lower 16.
      * Ex:
      *     ..., GODT_MapUserPen, GO_MAPPEN(DETAILPEN,FILLPEN), ...
      * Would cause the DETAILPEN to be mapped to the FILLPEN when
      * the user map is turned on.
      */

// TAG NUMBERS 45 TO 49 RESERVED HERE

// Standard flag control

#define FLGSET(flg) ( ((ULONG)(flg))<<16 )      // Flag control bit
#define FLGON(flg)  ( FLGSET(flg) | (flg) )     // Set the given flag
#define FLGOFF(flg) ( FLGSET(flg) | 0 )         // Clear the given flag
#define FLGTOG(flg) ( (flg) )                   // Toggle the given flag
#define FLGALL(msk) ( 0xFFFF0000 | (msk) )      // Directly set all flags

#define GODT_SetRastMode            (TAG_OUTLINE_PENBASE+50)
     /* UBYTE
      * Set the rastport drawing mode for all operations.
      *
      * Can be combinations of JAM1, JAM2, COMPLEMENT, INVERSVID
      * as per SetDrMd().  Use FLGON(x) to set each flag and
      * FLGOFF(X) to clear them.  You can directly set every flag
      * using the macro SETALL(x), with x being the desired flag
      * states.
      *
      * Default: JAM1
      */

#define DRWMD_INACTIVE   (0x8000)   // Swap pens to create inactive state.
#define DRWMD_HIGHLIGHT  (0x4000)   // Swap pens to create highlight effect.
#define DRWMD_USERMAP    (0x2000)   // Do user mapping of pens.
#define DRWMD_COMPLIMENT (0x1000)   // Swap pens to get compliment.

#define GODT_SetDrawMode            (TAG_OUTLINE_PENBASE+51)
     /* UBYTE
      * Set the GadOutline drawing mode for all operations.
      *
      * Can be combinations of:
      *     DRWMD_INACTIVE, DRWMD_HIGHLIGHT, DRWMD_USER, DRWMD_COMPLIMENT
      *
      * GOSD_BoopsiIm and GOSD_BoopsiGad drawing objects will automatically
      * set the DRWMD_INACTIVE and DRWMD_HIGHLIGHT flags based on the draw
      * state requested by Intuition.  The pens are mapped in order from
      * DRWMD_INACTIVE to DRWMD_COMPLEMENT; so, if every map is turned on,
      * the pen used will be: dripen[inact[high[user[comp[reqpen]]]]].
      *
      * Use FLGON(x) to set each flag and FLGOFF(X) to clear them.  You can
      * directly set every flag using the macro SETALL(x), with x being the
      * desired flag states.
      *
      * Default: 0
      */

#define GODT_ChooseBPen         (TAG_OUTLINE_PENBASE+52)
     /* UWORD
      * Choose standard pen to be used as 'B Pen' in drawing operations
      * which refer to this pen.
      *
      * Default: BACKGROUNDPEN (7)
      */

#define GODT_SetStdDrawPat          (TAG_OUTLINE_PENBASE+53)
     /* ULONG
      * Set the line drawing pattern for all operations.
      *
      * Accepts an integer which is a standard line pattern.
      * Currently only understand 0, which resets the pattern
      * to 0xFFFF, but in the future other defaults may be defined
      * for real patterns along with pens, draw modes, etc for them.
      *
      * Default: 0
      */

#define GODT_SetCustDrawPat         (TAG_OUTLINE_PENBASE+54)
     /* UWORD
      * Set the line drawing pattern for all operations.
      *
      * Accepts a 16-bit value which is the new pattern to use.
      *
      * Default: 0xFFFF
      */

#define FLPAT_CLEAR     (0) // No pattern.
#define FLPAT_HASH2     (1) // 2 x 2 hash pattern.
#define FLPAT_DISABLED  (2) // 4 x 2 standard intuition disabled pattern.

#define GODT_SetStdFillPat          (TAG_OUTLINE_PENBASE+55)
     /* ULONG
      * Set the area filling pattern for all operations.
      *
      * Accepts an integer which is a standard fill pattern.
      * Currently only understands the three fill patterns
      * defined above.
      *
      * Default: 0
      */

#define GODT_SetCustFillPat2        (TAG_OUTLINE_PENBASE+56)
     /* ULONG
      * Set the area filling pattern for all operations.
      *
      * Accepts a 32-bit value which is the two lines of a new
      * 16 x 2 fill pattern to use.  The upper 16 bits are the
      * first line and the lower 16 are the second.
      *
      * Default: 0xFFFFFFFF
      */

#define GODT_SetCustFillPat4A       (TAG_OUTLINE_PENBASE+57)
#define GODT_SetCustFillPat4B       (TAG_OUTLINE_PENBASE+58)
     /* ULONG
      * Set the area filling pattern for all operations.
      *
      * Accepts a 32-bit value which is one-half of the 4 lines of
      * a new 16 x 4 fill pattern to use.  A assigns the upper two
      * lines, and B assigns the lower two.  The tags MUST be used
      * as a pair; never make assumptions about what an unspecified
      * piece will default to.
      */

// TAG NUMBERS 59 TO 69 RESERVED HERE

#define GO_BOXBOUNDS(x1,y1,x2,y2) \
    ( ((x1&0xF)<<12) | ((y1&0xF)<<8) | ((x2&0xF)<<4) | ((y2&0xF)<<0) )

#define GO_FRMBOUNDS(x1,y1,x2,y2,x3,y3,x4,y4) \
    ( (GO_BOXBOUNDS(x3,y3,x4,y4)<<16) | GO_BOXBOUNDS(x1,y1,x2,y2) )

#define GODT_ResetBounds        (TAG_OUTLINE_PENBASE+70)
     /* ULONG [See GO_BOXBOUNDS and GO_FRMBOUNDS macros.]
      * Set current drawing boundaries to box dimensions.
      *
      * The ULONG is divided into 8 4 bit values; the lower
      * 16 bits specify the corners of a standard boundary box
      * and the upper 16 bits, if not zero, create a frame box.
      * Valid x and y values are from 1 to 5, corresponding
      * to the left/above space, left/above text, width/height,
      * right/below text and right/below space.
      *
      * If the upper 16 bits are zero, The boundaries are reset
      * back to a box based on this environment's BoxAttr.
      * If the upper 16 bits are non-zero, a frame is created;
      * the top/left parts of the frame are specified from the
      * lower 16 bits and the bottom/right is from the upper 16.
      * NO BOUNDARY CHECKING IS DONE ON THESE VALUES!
      *
      * Ex: GO_BOXBOUNDS(3,3,3,3) - set to body area
      *     GO_BOXBOUNDS(1,1,5,5) - set to box area
      *     GO_FRMBOUNDS(1,1,1,1, 5,5,5,5) - set to space area frame.
      *
      * Note that frame boundary types are only partially supported. In
      * particular, when drawing text using frame boundaries, if the
      * cursor is positioned in the right/bottom part of the frame, it
      * will be reset back to (0,0) before drawing the text and the text
      * width/height will only be constrained by the top/left part of the
      * frame.
      */

#define GODT_SetLeftBound       (TAG_OUTLINE_PENBASE+71)
#define GODT_SetTopBound        (TAG_OUTLINE_PENBASE+72)
#define GODT_SetRightBound      (TAG_OUTLINE_PENBASE+73)
#define GODT_SetBottomBound     (TAG_OUTLINE_PENBASE+74)
#define GODT_SetWidthBound      (TAG_OUTLINE_PENBASE+75)
#define GODT_SetHeightBound     (TAG_OUTLINE_PENBASE+76)
     /* TYPEDSIZE
      * Set the specified boundary to an exact amount.
      *
      * The boundary is moved by the number of pixels that the
      * typed size evaluates to.  Note that it is entirely
      * possible for this to move the boundary outside of the
      * current BoxAttr.  Use the typed size mode GOM_Add to
      * move the box boundary relative to its current postion.
      *
      * GODT_SetLeftBound and GODT_SetTopBound will always leave
      * intact the previous Width/Height or Right/Bottom bound that
      * was set.  For example, if you set the right bound and then
      * the left, the width will change to keep the same right bound.
      * However, if you instead set the width and then the left edge,
      * the right bound will change to keep the same width.
      *
      * If the current boundary is a frame, it will be turned
      * into a standard box by this command.
      */

// TAG NUMBERS 77 TO 79 RESERVED HERE

#define GODT_SetCursorX     (TAG_OUTLINE_PENBASE+80)
#define GODT_SetCursorY     (TAG_OUTLINE_PENBASE+81)
     /* TYPEDSIZE
      * Set the cursor position to an exact amount.
      *
      * The cursor is moved by the number of pixels that the
      * typed size evaluates to.  Its position will be limited
      * to the current boundary limits.
      */

// TAG NUMBERS 82 TO 89 RESERVED HERE

#define TXTMD_LEFT      (0x0000)    // Justify left.
#define TXTMD_RIGHT     (0x0001)    // Justify right.
#define TXTMD_CENTER    (0x0002)    // Center text.
#define TXTMD_X         (0x0003)

#define SETMD_X(mode) ( FLGSET(TXTMD_X) | (mode) )

#define TXTMD_ENDRIGHT  (0x0000)    // Finish with cursor at rightmost point
#define TXTMD_ENDLEFT   (0x0004)    // Finish with cursor at leftmost point
#define TXTMD_ENDCENTER (0x0008)    // Finish with cursor at center point
#define TXTMD_END       (0x000C)

#define SETMD_END(mode) ( FLGSET(TXTMD_END) | (mode) )

#define TXTMD_RELCENTER (0x0000)    // Y coordinate is center of text
#define TXTMD_RELTOP    (0x0010)    // Y coordinate is top of text
#define TXTMD_RELBOTTOM (0x0020)    // Y coordinate is bottom of text
#define TXTMD_RELBASE   (0x0030)    // Y coordinate is baseline of text
#define TXTMD_Y         (0x00F0)

#define SETMD_Y(mode) ( FLGSET(TXTMD_Y) | (mode) )

#define TXTMD_CHOPLEFT  (0x0100)    // Chop text on left rather than right
#define TXTMD_REVCOLOR  (0x0200)    // Reverse text A and B colors

#define GODT_SetTextMode        (TAG_OUTLINE_PENBASE+90)
     /* UWORD
      * Set the positioning mode for drawing text.
      *
      * Can be combinations of:
      *     One of TXTMD_LEFT, TXTMD_RIGHT, TXTMD_CENTER;
      *     One of TXTMD_ENDLEFT, TXTMD_ENDRIGHT, TXTMD_ENDCENTER;
      *     One of TXTMD_RELTOP, TXTMD_RELBOTTOM, TXTMD_RELCENTER, TXTMD_RELBASE;
      *     Plus TXTMD_CHOPLEFT and TXTMD_REVCOLOR.
      *
      * Use FLGON(x) to set each flag and FLGOFF(X) to clear them.  You can
      * directly set every flag using the macro SETALL(x), with x being the
      * desired flag states.
      *
      * Default: 0
      */

#define GODT_ChooseTextAPen     (TAG_OUTLINE_PENBASE+91)
     /* UWORD
      * Choose standard pen to be used as 'A Pen' in text drawing operations.
      *
      * Default: TEXTPEN (2)
      */

#define GODT_ChooseTextBPen     (TAG_OUTLINE_PENBASE+92)
     /* UWORD
      * Choose standard pen to be used as 'B Pen' in text drawing operations.
      *
      * Default: BACKGROUNDPEN (7)
      */

// Low-level drawing commands

#define TAG_OUTLINE_LOWDRAWCMD (TAG_OUTLINE_DRAWBASE+0x100)

#define GODT_SetOrigin (TAG_OUTLINE_LOWDRAWCMD+1)
     /* DRAWPNT
      * Sets the origins for later use by PIXEL_MODE draw points.
      *
      * Resets the pixel-mode's origin1 and origin2 to
      * (x1,y1) and (x2,y2), respectively.  [This is the only
      * command that modifies the pixel-mode origin.]
      *
      * pen is ignored - always set to zero.
      */

#define GODT_WritePixel (TAG_OUTLINE_LOWDRAWCMD+2)
     /* DRAWPNT
      * Write a pixel at the location (x1,y1) in the given color.
      * x2 and y2 are ignored - always set to zero.
      */

#define GODT_WritePixel2 (TAG_OUTLINE_LOWDRAWCMD+3)
     /* DRAWPNT
      * Write a pixel at the location (x1,y1) and another pixel at
      * location (x2,y2), both in the given color.
      */

#define GODT_MoveTo (TAG_OUTLINE_LOWDRAWCMD+4)
     /* DRAWPNT
      * Move cursor to location (x1,y1).
      *
      * x2, y2 and pen are ignored - always set to zero.
      */

#define GODT_DrawTo (TAG_OUTLINE_LOWDRAWCMD+5)
     /* DRAWPNT
      * Draw a line from current cursor location to location (x1,y1)
      * in current pen.  Leaves cursor at location(x1,y1).
      * x2 and y2 are ignored - always set to zero.
      */

#define GODT_DrawTo2 (TAG_OUTLINE_LOWDRAWCMD+6)
     /* DRAWPNT
      * Draw a line from current cursor location to location (x1,y1)
      * and then another from there to (x2,y2), all in current pen.
      * Leaves cursor at location (x2,y2).
      */

#define GODT_DrawLine (TAG_OUTLINE_LOWDRAWCMD+7)
     /* DRAWPNT
      * Draw a line from location (x1,y1) to location (x2,y2)
      * in the current pen.
      */

#define GODT_DrawRect (TAG_OUTLINE_LOWDRAWCMD+8)
     /* DRAWPNT
      * Draw an unfilled rectangle with top-left corner at
      * location (x1,y1) and bottom-right corner at (x2,y2),
      * in given pen.
      */

#define GODT_DrawEllipse (TAG_OUTLINE_LOWDRAWCMD+9)
     /* DRAWPNT
      * Draw an unfilled ellipse with top-left corner at
      * location (x1,y1) and bottom-right corner at (x2,y2),
      * in given pen.
      */

// TAG NUMBERS 10 TO 29 RESERVED HERE

#define GODT_FillRect (TAG_OUTLINE_LOWDRAWCMD+30)
     /* DRAWPNT
      * Draw a filled rectangle with top-left corner at
      * location (x1,y1) and bottom-right corner at (x2,y2),
      * in given pen.
      */

#define GODT_EraseRect (TAG_OUTLINE_LOWDRAWCMD+31)
     /* DRAWPNT
      * Clear a rectangle with top-left corner at
      * location (x1,y1) and bottom-right corner at (x2,y2).
      * pen is ignored - always set to zero.
      * You will commonly start your drawing with a:
      *     GODT_ClearRect, GO_DRAWPNT(0,0,0,127,127), ...
      */

#define GODT_FillEllipse (TAG_OUTLINE_LOWDRAWCMD+32)
     /* DRAWPNT
      * Draw a filled ellipse with top-left corner at
      * location (x1,y1) and bottom-right corner at (x2,y2),
      * in given pen.
      */

#define GODT_AreaStart (TAG_OUTLINE_LOWDRAWCMD+33)
     /* DRAWPNT
      * Move to location (x1,y1) to start defining an area.
      * x2 and y2 and pen are ignored - always set to zero.
      */

#define GODT_AreaMoveTo (TAG_OUTLINE_LOWDRAWCMD+34)
     /* DRAWPNT
      * Move the current area position to location (x1,y1) of
      * an area definition that was started with above command.
      * x2 and y2 and pen are ignored - always set to zero.
      */

#define GODT_AreaDrawTo (TAG_OUTLINE_LOWDRAWCMD+35)
     /* DRAWPNT
      * Add a line from current area position to location (x1,y1)
      * into an area definition that was started with above command.
      * x2 and y2 and pen are ignored - always set to zero.
      */

#define GODT_AreaDrawTo2 (TAG_OUTLINE_LOWDRAWCMD+36)
     /* DRAWPNT
      * Add a line from current area position to location (x1,y1)
      * and then from there to (x2,y2) into an area definition that
      * was started with GODT_AreaStart command.
      * pen is ignored - always set to zero.
      */

#define GODT_AreaFill (TAG_OUTLINE_LOWDRAWCMD+37)
     /* DRAWPNT
      * Fill in area defined by previous tags with color pen.
      * x1, y1 and x2, y2 are ignored - always set to zero.
      */

// TAG NUMBERS 38 TO 49 RESERVED HERE

#define GODT_DrawStdFrame (TAG_OUTLINE_LOWDRAWCMD+50)
     /* DRAWPNT
      * Draw a standard 2.0-style 3D frame with corners at
      * (x1,y1) and (x2,y2).  The top-left side is drawn
      * in the given pen color, and the bottom-right in its
      * compliment.  So a pen of SHINEPEN will produce a
      * raised frame and SHADOWPEN a recessed one.
      */

#define GODT_DrawStrFrame (TAG_OUTLINE_LOWDRAWCMD+51)
     /* DRAWPNT
      * Draw a standard 2.0-style 3D string frame.
      */

// TAG NUMBERS 52 TO 59 RESERVED HERE

#define GODT_AdjustBounds       (TAG_OUTLINE_LOWDRAWCMD+60)
     /* DRAWPNT
      * Adjust the current drawing boundaries.
      *
      * The new boundary's top-left corner is at (x1,y1)
      * and bottom-right at (x2,y2) relative to the
      * CURRENT boundaries.  (You can only shrink the
      * boundaries using this command.)
      *
      * If the current boundary is a frame, it will be turned
      * into a standard box by this command.
      */

// Text drawing commands
#define TAG_OUTLINE_TEXTDRAWCMD (TAG_OUTLINE_DRAWBASE+0x200)

#define GODT_DrawText (TAG_OUTLINE_TEXTDRAWCMD+1)
     /* UBYTE *
      * Draw the given text onto the screen, centering and clipping
      * as needed to make it fit within the box's boundaries.
      * Uses current GODT_SetDrawMode, GODT_ChooseTextAPen and
      * GODT_ChooseTextBPen settings.
      */

#define GODT_DrawOldText (TAG_OUTLINE_TEXTDRAWCMD+2)
     /* UBYTE *
      * Same as GODT_DrawText, except pens A and B are the DetailPen
      * and its compliment, respectively.
      */

#define GODT_DrawStdText (TAG_OUTLINE_TEXTDRAWCMD+3)
     /* UBYTE *
      * Same as GODT_DrawText, except pens A and B are the TextPen
      * and its compliment, respectively.
      */

#define GODT_DrawHighText (TAG_OUTLINE_TEXTDRAWCMD+4)
     /* UBYTE *
      * Same as GODT_DrawText, except pens A and B are the
      * and its compliment, respectively.
      */

#define GODT_DrawFillText (TAG_OUTLINE_TEXTDRAWCMD+5)
     /* UBYTE *
      * Same as GODT_DrawText, except pens A and B are the FillTextPen
      * and its compliment, respectively.
      */

#define GODT_DrawTextTag (TAG_OUTLINE_TEXTDRAWCMD+6)
#define GODT_DrawOldTextTag (TAG_OUTLINE_TEXTDRAWCMD+7)
#define GODT_DrawStdTextTag (TAG_OUTLINE_TEXTDRAWCMD+8)
#define GODT_DrawHighTextTag (TAG_OUTLINE_TEXTDRAWCMD+9)
#define GODT_DrawFillTextTag (TAG_OUTLINE_TEXTDRAWCMD+10)
     /* Tag
      * Same as previous tags, except the data is a tag to look for
      * within the command list which contains a text pointer. Ex:
      * ..., GOCT_BorderText, "Hi!", GODT_DrawTextTag, GOCT_BorderText, ...
      * Would print "Hi!" at the current cursor position.
      */

// TAG NUMBERS 11 TO 29 RESERVED HERE

#define GODT_NewLine (TAG_OUTLINE_TEXTDRAWCMD+30)
     /* ULONG
      * Perform a carriage return / new line operation on the cursor.
      *
      * The x position is reset to zero [left side of bounding box]
      * and the y position is incremented by the font height times
      * the given tag's data field.
      */

// TAG NUMBERS 31 TO 89 RESERVED HERE

#define GODT_LeftTextPtr (TAG_OUTLINE_TEXTDRAWCMD+90)
#define GODT_AboveTextPtr (TAG_OUTLINE_TEXTDRAWCMD+91)
#define GODT_BodyTextPtr (TAG_OUTLINE_TEXTDRAWCMD+92)
#define GODT_RightTextPtr (TAG_OUTLINE_TEXTDRAWCMD+93)
#define GODT_BelowTextPtr (TAG_OUTLINE_TEXTDRAWCMD+94)
     /* UBYTE *
      *
      * These are "fake" tags which can be used with the
      * GODT_DrawText*Tag tags above; they are otherwise ignored.
      */

// Drawing environment commands
#define TAG_OUTLINE_DRAWENVCMD (TAG_OUTLINE_DRAWBASE+0x300)

#define GODT_ExecDrawing (TAG_OUTLINE_DRAWENVCMD+1)
     /* struct TagItem *
      * Execute the drawing commands pointed to.
      *
      * This tag causes the drawing tags to which it points to be
      * executed exactly as if they are in this list.  Any changes
      * they make to the current environment will not be restored
      * when they are finished.
      *
      * Note that the commands which take identifiers for tags which
      * occur in the list [ie GODT_DrawTextTag] still search the
      * _original_ command tag list and not the child list.
      */

#define GODT_SpawnDrawing (TAG_OUTLINE_DRAWENVCMD+2)
     /* struct TagItem *
      * Execute the drawing in its own environment.
      *
      * This tag is identical to GODT_ExecuteDrawing except
      * that it creates a new environment before executing the
      * given tag list and restores the old environment after
      * it has finished.  This means that any changes [ie, pen
      * colors, bounds, etc], made by the commands will not
      * effect the caller's environment.
      */

/***
 *** These are the global GadOutline tags which are passed to the
 *** functions AllocGadOutline(), DimenGadOutline(), RebuidldGadOutline(),
 *** ResizeGadOutline(), DestroyGadOutline(), HookGadOutline(),
 *** UnhookGadOutline(), DrawGadOutline().
 ***/

#define TAG_OUTLINE (TAG_USER+0x8000)

#define GOA_BaseName (TAG_OUTLINE+1)
     /* UBYTE *
      * Set program BaseName associated with this GadOutline.
      *
      * Default: NULL  (no base name)
      */

#define GOA_ErrorCode (TAG_OUTLINE+2)
     /* GOERR *
      * Give a memory location to store GadOutline error codes in.
      *
      * Default: NULL  (no errors stored)
      */

#define GOA_ErrorText (TAG_OUTLINE+3)
     /* UBYTE **
      * Give a memory location to store GadOutline error text in.
      *
      * Default: NULL  (no errors stored)
      */

#define GOA_SetUserData (TAG_OUTLINE+4)
     /* void *
      * Set the GadOutline's UserData variable.
      *
      * Default: NULL
      */

#define GOA_SetUserHandler (TAG_OUTLINE+5)
     /* void *
      * Set the GadOutline's UserHandler variable.
      *
      * This is intended to be used as a vector to the user's code which
      * handles IDCMP messages from this window.  However, the library
      * currently does nothing with it and you are free to use this variable
      * in whatever way you want.
      *
      * Default: NULL
      */

#define GOA_SetTransHook (TAG_OUTLINE+6)
     /* struct Hook *
      * Set the GadOutline's user Translation hook.
      *
      * Default: NULL  (no user translation)
      */

#define GOA_SetTransHookData (TAG_OUTLINE+7)
     /* void *
      * Set the GadOutline's TransHookData variable.
      *
      * Default: NULL
      */

// TAG NUMBERS 8 TO 99 RESERVED HERE

#define GOA_DisplayID (TAG_OUTLINE+100)
     /* ULONG
      * Specify a standard graphics.library display ID.
      */
#define GOA_Overscan    (TAG_OUTLINE+101)
     /* ULONG
      * Specify a standard screen overscan mode.
      *
      * If no screen or window set for outline, these tags are used to find
      * some basic values for doing a layout.  This is most often used to find
      * a font that the outline will fit in a screen before opening the screen.
      *
      * These tags will automatically set the minimum layout dimensions
      * to zero and the maximum dimensions to the size of the display mode.
      *
      * GOA_DisplayID default: 0 (generic lores)
      * GOA_Overscan default: OSCAN_TEXT
      */

#define GOA_ScreenAddr (TAG_OUTLINE+102)
     /* struct Screen *
      * Specify the screen to put the outline on.
      */
#define GOA_ScreenName (TAG_OUTLINE+103)
     /* UBYTE *
      * Specify the name of a public screen to put the outline on.
      *
      * If no window is supplied, these tags are used to specify the screen
      * that the outline will be on.  If the outline is already on a window
      * or another screen, that window and/or screen is closed before going
      * onto this screen.  If the screen name is NULL or the named screen
      * can not be opened and GOA_ScreenFallBack is TRUE, the default screen
      * will be used.  When opening on a screen, the screen is automatically
      * locked and will remain locked until the outline is removed from the
      * screen.
      *
      * Note that only one of these tags should be specified.
      * These tags will automatically set the minimum layout dimensions
      * to zero and the maximum dimensions to the size of the screen.
      *
      * GOA_ScreenAddr default: NULL (none)
      * GOA_ScreenName default: NULL (default pub screen)
      */

#define GOA_WindowAddr (TAG_OUTLINE+104)
     /* Struct Window *
      * Specify the window to put the outline on.
      *
      * This tag gives the actual window on which to create the layout
      * and allows the library to create all of its object and link them
      * to the window.  While the window is linked to the outline, it is
      * essentially owned by the library -- all IDCMP messages and
      * refreshing must go through the library routines, and the library
      * owns the window's UserData variable.
      *
      * This tag will automatically set the minimum layout dimensions
      * AND the maximum dimensions to the size of the window.
      *
      * Default: NULL (none)
      */

#define GOA_MaxWidth    (TAG_OUTLINE+105)
#define GOA_MaxHeight (TAG_OUTLINE+106)
     /* ULONG
      * Specify maximum size that the gadoutline layout can be.
      */
#define GOA_MinWidth    (TAG_OUTLINE+107)
#define GOA_MinHeight (TAG_OUTLINE+108)
     /* ULONG
      * Specify minimum size that the gadoutline layout can be.
      *
      * These are used to override the default max/min layout dimensions
      * set up by the library.  They must be included at every call to
      * Remake/Resize/Hook/Unhook/etc or else they will revert to the
      * default dimensions as described above.
      *
      * Default: from window/screen/displayid as above.
      */

#define GOA_TextAttr    (TAG_OUTLINE+109)
     /* struct TextAttr *
      * Specify the prefered font to use for the layout
      *
      * This tag specifies a complete font description to attempt to
      * do the layout in, overriding the default use of the Window or
      * Screen's font.  If the layout will not fit within its maximum
      * dimensions using this font, the library will override it.
      *
      * Default: from window or screen or just boring 'ol Topaz 8.
      */

#define GOA_FontName    (TAG_OUTLINE+110)
     /* UBYTE *
      * Specify the prefered font name, with or without .font suffix.
      */
#define GOA_FontSize    (TAG_OUTLINE+111)
     /* UWORD
      * Specify the prefered font size.
      */
#define GOA_FontStyle (TAG_OUTLINE+112)
     /* UBYTE
      * Specify the prefered font style.
      *
      * These tags can be used instead of GOA_FontAttr, or used to modify
      * the values supplied within the GOA_FontAttr.
      *
      * Default: what GOA_FontAttr specified (or didn't, as the case may be. :)
      */

#define GOA_ErrorReportLevel (TAG_OUTLINE+113)
     /* UWORD
      * Specify which errors will be reported by displaying a requester.
      *
      * This tag specifies which GOTYPE_ error codes will cause GOA_SetError
      * to fall through to GOA_ShowError.  It is formatted as a bit mask,
      * one bit for each possible error type, with the least significant
      * bit being GOTYPE_NONE.
      *
      * Default:  (1L<<GOTYPE_FINE)  | (1L<<GOTYPE_NOTE)   | (1L<<GOTYPE_WARN)
      *         | (1L<<GOTYPE_ALERT) | (1L<<GOTYPE_ALERT2) | (1L<<GOTYPE_ALERT3)
      *         | (1L<<GOTYPE_FAIL)  | (1L<<GOTYPE_FAIL2)  | (1L<<GOTYPE_FAIL3)
      *
      * A good value to use for debugging is:
      *
      *           (1L<<GOTYPE_FINE)  | (1L<<GOTYPE_FINE2)
      *         | (1L<<GOTYPE_NOTE)  | (1L<<GOTYPE_NOTE2)
      *         | (1L<<GOTYPE_WARN)  | (1L<<GOTYPE_WARN2)
      *         | (1L<<GOTYPE_ALERT) | (1L<<GOTYPE_ALERT2) | (1L<<GOTYPE_ALERT3)
      *         | (1L<<GOTYPE_FAIL)  | (1L<<GOTYPE_FAIL2)  | (1L<<GOTYPE_FAIL3)
      */

#define GOA_ErrorFailLevel (TAG_OUTLINE+114)
     /* UWORD
      * Specify which unreported errors will become failures.
      *
      * This tag specifies which GOTYPE_ error codes, which have been set to
      * be unreported by the previous tag, will result in a failure being
      * reported.  It is formatted identically to the previous tag.
      *
      * Note that this allows you to turn error types that would normally
      * always be a failure or a continuation into something they are not, 
      * which is obviously not a good thing to do. :)
      *
      * Default:  (1L<<GOTYPE_ALERT) | (1L<<GOTYPE_ALERT2) | (1L<<GOTYPE_ALERT3)
      *         | (1L<<GOTYPE_FAIL)  | (1L<<GOTYPE_FAIL2)  | (1L<<GOTYPE_FAIL3)
      */


#define GOA_UserIDCMP (TAG_OUTLINE+115)
     /* struct MsgPort *
      * Specify custom message port for window's IDCMP.
      *
      * This allows you to supply a custom IDCMP port for windows opened
      * using GOA_OpenWindow().  This port will be automatically attached
      * and removed from the window by the library.  A value of ~0 will
      * cause the library to allocate the message port itself and manage
      * it internally.
      *
      * Default: let window make its own.
      */

#define GOA_OutlineSize (TAG_OUTLINE+116)
     /* ULONG
      * Supply bounds checking for parsing the outline array.
      *
      * This is the number of BYTES your full outline is.  If the library
      * goes over this number of bytes while parsing it, a fatal error
      * will occur telling you so.
      *
      * Default: if you messed it up, too bad.
      */

#define GOA_FontMinSize (TAG_OUTLINE+117)
     /* UWORD
      * Set the minimum point size we will scale font back to.
      *
      * Default: 8 points
      */


#define GOA_AllocMenus (TAG_OUTLINE+118)
     /* struct NewMenu *
      * Supplies a GadTools NewMenu array to be automatically allocated
      * and layed-out/attached to a window opened with GOA_OpenWindow().
      *
      * Default: No menus.
      */

#define GOA_GToolsMenus (TAG_OUTLINE+119)
     /* struct Menu *
      * Supplies a menu strip that was allocated by GadTools, to be automatically
      * layed-out and attached to a window opened with GOA_OpenWindow().
      *
      * Default: No menus.
      */

#define GOA_StandardMenus (TAG_OUTLINE+120)
     /* struct Menu *
      * Supplies a menu strip that will be attached to a window opened
      * with GOA_OpenWindow().  No layout or anything else of the menus
      * is performed before it is attached.
      *
      * Default: No menus.
      */

// TAG NUMBERS 121 TO 199 RESERVED HERE

// Flags

#define GOA_FontSystemOnly (TAG_OUTLINE+200)
     /* BOOL
      * Only allow the library to fall back to the default system fonts.
      *
      * If TRUE, the library will not attempt to reduce the point size
      * of the font requested by the caller in order to make it fit
      * within the current constraints, and will instead immediately
      * start trying the system fonts.  The system font order is:
      *   window -> screen -> gfxdefault -> topaz8
      *
      * Default: FALSE
      */

#define GOA_FontROMFont     (TAG_OUTLINE+201)
     /* BOOL
      * Set the ROMFONT flag in the TextAttr used to open fonts
      */
#define GOA_FontDiskFont        (TAG_OUTLINE+202)
     /* BOOL
      * Set the DISKFONT flag in the TextAttr used to open fonts
      */
#define GOA_FontDesigned        (TAG_OUTLINE+203)
     /* BOOL
      * Set the DESIGNED flag in the TextAttr used to open fonts
      *
      * These flags are used set information in the TextAttr before
      * calling the system to open the font.  Their interpretation
      * depends on the OS, except setting GOA_FontDiskFont to TRUE
      * will cause the library to try to open diskfont.library and use
      * OpenDiskFont() instead of OpenFont().
      *
      * GOA_FontROMFont Default: FALSE
      * GOA_FontDiskFont Default: TRUE
      * GOA_FontDesigned Default: TRUE
      */

#define GOA_ScreenFallBack  (TAG_OUTLINE+204)
     /* BOOL
      * Try to open default screen if unable to open a named screen.
      *
      * If TRUE, the library will attempt to open the default public screen
      * if it was unable to open the screen name supplied with GOA_ScreenName.
      *
      * Default: TRUE
      */

#define GOA_AutoSizeVerify  (TAG_OUTLINE+205)
     /* BOOL
      * Specify whether to respond to IDCMP_SIZEVERIFY events.
      *
      * If TRUE, the library will automatically unhook the gadgets from
      * the window before allowing it to be resized.  This keeps the window
      * frame from getting trashed by the old gadgets during a resize and
      * usually means you won't need to refresh the frame.  However, with
      * complex layouts there may be a noticable delay between the user
      * pressing the resize gadget and being allowed to move the window.
      *
      * Default: TRUE
      */

#define GOA_AutoNewSize     (TAG_OUTLINE+206)
     /* BOOL
      * Specify whether to respond to IDCMP_NEWSIZE events.
      *
      * If TRUE, the library will automatically call ResizeGadOutline()
      * whenever the window size changes.
      *
      * Default: TRUE
      */

#define GOA_AddOutlineIDCMP (TAG_OUTLINE+207)
     /* BOOL
      * Automatically add IDCMP events needed by library.
      *
      * If TRUE, the window will be set to report all IDCMP events needed
      * by the library.  This includes IDCMP_NEWSIZE, IDCMP_SIZEVERIFY and
      * IDCMP_RAWKEY, depending on whether the library has been told to
      * respond to these.
      *
      * Default: TRUE
      */

#define GOA_AddObjectIDCMP  (TAG_OUTLINE+208)
     /* BOOL
      * Automatically add IDCMP events needed by objects.
      *
      * If TRUE, the window will be set to report all IDCMP events needed
      * by any objects in the layout.  The exact events which will be
      * set depends on the objects.
      *
      * Default: TRUE
      */

#define GOA_DoHookCallback  (TAG_OUTLINE+209)
     /* BOOL
      * Send objects HOOK/UNHOOK messages.
      *
      * If TRUE, the library will send a CHM_HOOKOBJ when the objects are
      * being hooked to the window and CHM_UNHOOKOBJ when they are being
      * removed from the window.  Normally, these operations simply involve
      * removing all of the gadget lists from the window, and so this flag
      * is set to FALSE.  If your user hook needs to do something special,
      * set this to TRUE.  Please _never_ set this to false, so that the
      * library can change the default condition of this to TRUE at a later
      * time.
      *
      * Default: FALSE
      */

#define GOA_RedrawWinFrame  (TAG_OUTLINE+210)
     /* BOOL
      * Redraw window frame after a window resize.
      *
      * If TRUE, the library will automatically refresh the window's frame
      * after it has been resized.  Normally the library looks for
      * IDCMP_SIZEVERIFY events and removes the gadgets during a resize
      * so this does not usually need to happen.
      *
      * Default: FALSE
      */

#define GOA_SetWindowFont   (TAG_OUTLINE+211)
     /* BOOL
      * Set the window's RastPort font to the outline's final font.
      *
      * If TRUE, the library will automatically set the window's RastPort
      * to the font that it uses for the layout (ie, go_TextFont).  This
      * means that you should not change the window font yourself, or if you
      * do change it you must change it back before calling any gadoutline
      * library functions.
      *
      * Default: TRUE
      */

#define GOA_ClearFullWin        (TAG_OUTLINE+212)
     /* BOOL
      * Clear entire window when remaking objects.
      *
      * If TRUE, the library will erase the entire window after destroying
      * all objects and getting ready to remake them.
      * If FALSE, only the area covered by the layout will be cleared.
      *
      * You will usually need to set this flag if you are drawing in the
      * space area around the root group.  Otherwise, the library leaves
      * this space alone to allow you to reserve it for yourself.
      *
      * Default: FALSE
      */

#define GOA_SaveWinDimens       (TAG_OUTLINE+213)
     /* BOOL
      * Remember the window dimensions on open/close.
      *
      * If TRUE, GOA_CloseWindow() will save the window's dimensions before
      * closing and a subsequent call to GOA_OpenWindow() will try to match
      * those dimensions as closely as possible.
      *
      * Default: TRUE
      */

#define GOA_WindowRelative      (TAG_OUTLINE+214)
     /* BOOL
      * Window position is a relative value.
      *
      * If TRUE, any value supplied in WA_LeftEdge and WA_TopEdge is
      * relative to either the screen's title bar or, if the screen is
      * bigger than the display, the left and top positions of the display
      * on the screen.  [Ie, so that the window appears on the visible
      * portion of the screen.]  In addition, the window's size will be
      * reduced, if possible, to make sure it fits within the display
      * area and WA_InnerWidth and WA_InnerHeight will be relative to the
      * current layout's minimum dimensions.
      *
      * Default: TRUE
      */

#define GOA_WindowResize        (TAG_OUTLINE+215)
     /* BOOL
      * Scale window size if layout doesn't fit on it.
      * NOT IMPLEMENTED.
      *
      * If TRUE, the library will attempt to enlarge the window if
      * its prefered layout dimensions will fit on a bigger window.
      * The window will not be resized if the layout won't fit within
      * the largest window on its screen.  [In other words, the window
      * size will only change when this will guarantee that the layout
      * will fit on it.]
      *
      * Default: TRUE
      */

#define GOA_AutoHotKeys     (TAG_OUTLINE+216)
     /* BOOL
      * Automatically process object hot keys.
      *
      * Default: TRUE
      */

/**
 ** Error code definitions
 **/
typedef unsigned long GOERR;

#define ERRCODE_STARTBIT (0)    // ID describing the error.
#define ERRCODE_NUMBITS (16)
#define ERRTYPE_STARTBIT (24)   // Severity of error.
#define ERRTYPE_NUMBITS (4)

// Bit allocation:
//
// 3  2    2    2    1    1    0    0    0
// 1  8    4    0    6    2    8    4    0
// xxxx TTTT xxxx xxxx CCCC CCCC CCCC CCCC
//
// T = Error type
// C = Error code
// x = reserved.  always set to 0.

#define GETERRCODE(goerr)   ((ULONG)( ( ((GOERR)(goerr)) >> ERRCODE_STARTBIT ) \
                                      & ((1<<ERRCODE_NUMBITS)-1) ))
#define GETERRTYPE(goerr)   ((ULONG)( ( ((GOERR)(goerr)) >> ERRTYPE_STARTBIT ) \
                                      & ((1<<ERRTYPE_NUMBITS)-1) ))

#define GO_MAKEERR(type,code) \
        ((GOERR)( (((ULONG)(type)&((1<<ERRTYPE_NUMBITS)-1))<<ERRTYPE_STARTBIT) \
                  | (((ULONG)(code)&((1<<ERRCODE_NUMBITS)-1))<<ERRCODE_STARTBIT) \
        ))

#define GOCODE_NONE         0   // No problem.  Only use with GOTYPE_NONE.
                                // ErrObj = none.
#define GOCODE_GENERAL      1   // General-purpose error code.
                                // ErrObj = none.
#define GOCODE_MEMORY       2   // Not enough memory.
                                // ErrObj = (ULONG) - Memory size requested.
#define GOCODE_OPENLIB      3   // Unable to open a library.
                                // ErrObj = (UBYTE *) - explantion text.
#define GOCODE_OPENFONT     4   // Unable to open a font.
                                // ErrObj - (struct TextAttr *) - font we tried.
#define GOCODE_INTERR       5   // Internal error occured.
                                // ErrObj - ULONG, use ~em and ~el to get file/line.
#define GOCODE_BADARGS      6   // Function called with bad arguments, but not fatal.
                                // ErrObj - ULONG, use ~em and ~el to get file/line.
#define GOCODE_OUTBOUNDS    7   // Outline parse went out of GOA_OutlineSize bounds.
                                // ErrObj - ULONG, size error was found at.

#define GOCODE_MALFORMED    8   // Error parsing outline structure.
                                // ErrObj = (struct CmdInfo *) - CmdInfo of error.
#define GOCODE_NOBOXGROUP   9   // Box created outside of a group.
                                // ErrObj = (struct CmdInfo *) - CmdInfo of error.
#define GOCODE_UNKNOWNCMD   10  // Encountered an illegal command.
                                // ErrObj = (struct CmdInfo *) - CmdInfo of error.
#define GOCODE_BADENDGRP    11  // Endgroup command found outside of any groups.
                                // ErrObj = (struct CmdInfo *) - CmdInfo of error.
#define GOCODE_NOGROUPS     12  // There are no groups or boxes in the outline.
                                // ErrObj = (struct CmdInfo *) - base CmdInfo.
#define GOCODE_EXTRAROOTGRP 13  // Can only have one root group.
                                // ErrObj = (struct CmdInfo *) - base CmdInfo.
#define GOCODE_BADGROUP     14  // Found a bad command within a group list.
                                // ErrObj = (struct CmdInfo *) - CmdInfo of error.

#define GOCODE_BADHKCMD     15  // Hook doesn't understand this type of CmdInfo.
                                // ErrObj = (struct CmdInfo *) - offending CmdInfo.
#define GOCODE_CREATEOBJ    16  // Object creation error.
                                // ErrObj = (struct CmdInfo *) - object's CmdInfo.

#define GOCODE_BADCMDID     17  // Supplied CmdID out of bounds.
                                // ErrObj = (CMDID) - the bad number.
#define GOCODE_DUPSTDID     18  // Multiple commands have the same StdID number.
                                // ErrObj = (CMDID) - the bad number.
#define GOCODE_NOCMDID      19  // No command associated with the given CmdID.
                                // ErrObj = (CMDID) - the bad number.
#define GOCODE_DUPHOTKEY    20  // Multiple commands have the same hotkey.
                                // ErrObj = (UBYTE) - the hot key.

#define GOCODE_BADTYPEDSIZE 21  // Found an invalid TypedSize.
                                // ErrObj = (TYPEDSIZE) - the bad number.

#define GOCODE_OPENPUBSCRN  22  // Unable to open a named public screen.
                                // ErrObj = (UBYTE *) - name of pub screen.
#define GOCODE_DEFPUBSCRN   23  // Couldn't find the default public screen.
                                // ErrObj = none.
#define GOCODE_VISUALINFO   24  // Unable to allocate screen's VisualInfo.
                                // ErrObj = (struct Screen *) - the screen we tried.
#define GOCODE_DRAWINFO     25  // Unable to find screen's DrawInfo.
                                // ErrObj = (struct Screen *) - the screen we tried.

#define GOCODE_NOFITWINDOW  26  // Unable to fit layout with current font/screen.
                                // ErrObj = none.
#define GOCODE_GTCONTEXT    27  // Unable to create GadTools context.
                                // ErrObj = none.

#define GOCODE_OPENWIN      28  // Unable to open a window.
                                // ErrObj = (struct TagItem *) - window's tags.

#define GOCODE_NUM          29  // Total number of error codes

                            // C = Continue, R = Retry, A = Abort
#define GOTYPE_NONE     0   // ONLY use with GOCODE_NONE.
#define GOTYPE_FINE     1   // Requester with: C
#define GOTYPE_FINE2    2   // Requester with: C
#define GOTYPE_FINE3    3   // Requester with: C
#define GOTYPE_NOTE     4   // Requester with: C/A
#define GOTYPE_NOTE2    5   // Requester with: C/A
#define GOTYPE_NOTE3    6   // Requester with: C/A
#define GOTYPE_WARN     7   // Requester with: C/R/A
#define GOTYPE_WARN2    8   // Requester with: C/R/A
#define GOTYPE_WARN3    9   // Requester with: C/R/A
#define GOTYPE_ALERT    10  // Requester with: R/A
#define GOTYPE_ALERT2   11  // Requester with: R/A
#define GOTYPE_ALERT3   12  // Requester with: R/A
#define GOTYPE_FAIL     13  // Requester with: A
#define GOTYPE_FAIL2    14  // Requester with: A
#define GOTYPE_FAIL3    15  // Requester with: A
#define GOTYPE_NUM      16

// Possible return values for the error requester
#define GOREQ_CONT  0
#define GOREQ_RETRY 1
#define GOREQ_FAIL  2

#endif
