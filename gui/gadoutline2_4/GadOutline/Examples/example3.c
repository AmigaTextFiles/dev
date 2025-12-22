
#include <graphics/gfxmacros.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/asl.h>
#include <stdlib.h>
#include <string.h>

#ifndef LINKLIB
    #include "proto/gadoutline.h"
#else
    #include "libraries/gadoutline.h"
    #include "interface.h"
#endif

#ifdef DEBUGMODULE
    
    #include "support/debug.h"

#else

    void __stdargs kprintf(UBYTE *fmt,...);  // Serial debugging...
    void __stdargs dprintf(UBYTE *fmt,...);  // Parallel debugging...

    #ifndef bug
    #define bug Printf
    #endif

    #ifndef DEBTIME
    #define DEBTIME 0
    #endif

    #ifdef DEBUG
    #define D(x) (x); if(DEBTIME>0) Delay(DEBTIME);
    #else
    #define D(x) ;
    #endif

#endif

/*********************************************
 **
 ** Main window outline support data
 **
 *********************************************/

// This is a list of IDs to assign to each command (gadget) in the outline.
// Because almost all references to the outline are made through IDs rather
// than pointers, you will need to assign IDs to most commands, including
// any command that has a hotkey attached.  (Hotkeys are stored internally
// as just the ID number of the command that a hotkey is attached to, so
// if it doesn't have a number the library is unable to find the command
// to send an CHM_HOTKEY message to it.)

// These "standard" ID codes can range from 1 to 4095; the value of 0 means
// "no ID code," and the upper 20 bits of the ID are used for storing
// "group" ID codes.  Every command which is given a non-zero standard ID
// must be the only command in the outline with that ID; the library will
// report an error if it finds more than one command with the same ID.

enum {

    // Top-left list with attached string gadget.
    INFOLIST_ID = 1,
    INFOEDIT_ID,

    // Top-right area demoing the operation of group IDs.
    WHICHGROUP_ID,
    GRPBUT1_ID,
    GRPBUT2_ID,
    GRPBUT3_ID,
    GRPBUT4_ID,
    GRPBUT5_ID,
    GRPBUT6_ID,
    GRPBUT7_ID,

    // Palette ID codes.
    SCRNPALKEY_ID,
    SCRNPAL_ID,
    PALREDKEY_ID,
    PALRED_ID,
    PALGREENKEY_ID,
    PALGREEN_ID,
    PALBLUEKEY_ID,
    PALBLUE_ID,
    PALDEPTH_ID,

    // Font control gadgets.
    SETFONT_ID,
    FONTNAME_ID,
    FONTSIZE_ID,
    MINSIZE_ID,
    
    SCALEFONT_ID,
    SYSFONT_ID,
    ROMFONT_ID,
    DISKFONT_ID,

    CURFNAME_ID,
    CURFSIZE_ID,

    // String gadget to select screen for window.
    PUBSCREEN_ID,

    // Gadget to select the library call to use when resizing.
    REMAKE_ID,

    // Gadgets to demo enabling and disabling the creation of
    // gadgets and whether they are ignored during layout.
    ONOFFALLC_ID,
    ONOFFALLD_ID,
    BOOGRP_ID,

    ONOFF1_ID,
    BOO1_ID,
    HERE1_ID,

    ONOFF2A_ID,
    ONOFF2B_ID,
    BOO2A_ID,
    BOO2B_ID,
    HERE2_ID,

    ONOFF3A_ID,
    ONOFF3B_ID,
    BOO3A_ID,
    BOO3B_ID,
    HERE3_ID
            
};

// These are the group IDs for the group demo gadgets.  A group ID is
// the upper 20 bits of a standard ID, divided itself into two parts.
// The lower 8 bits are a code to assign to the command; unlike the
// standard ID, multiple commands may have the same group code.  The
// other 12 bits are organized as a mask - by setting individual bits
// in the mask, you tell whether the command belongs to the group with
// that bit set.  When refering to a group, a zero in either the mask
// or code means to "match all."  So a group ID of "1" would match
// every command with the group ID code of 1, no matter what its mask
// value is.  An ID of "GO_GRPID_A" would match every commad with its
// GO_GRPID_A bit set, no matter what its code is, and an ID of
// "GO_GRPID_A | 1" would match only those commands with both a mask
// of GO_GRPID_A and a code of 1.

#define DEMOGRP_GID GO_GRPID_A      // The demo group mask.
#define DEMOGRP1_GID 1              // Code 1 for this group mask.
#define DEMOGRP2_GID 2              // Code 2 for this group mask.
#define DEMOGRP3_GID 3              // Code 3 for this group mask.

// Space to allocate for strings.
#define STRING_LEN 100

// These are the string arrays for the cycle and mx gadgets.

UBYTE *PalDepths[] = {
    "2 pen",
    "4 pen",
    "8 pen",
    "16 pen",
    "32 pen",
    "64 pen",
    NULL
};

UBYTE *GroupLabels[] = {
    "All Enabled",
    "Grp1 Enabled",
    "Grp2 Enabled",
    "Grp3 Enabled",
    NULL
};

UBYTE *ResizeTypes[] = {
    "Dimen",
    "Rebuild",
    "Resize",
    NULL
};

// This tag list is located outside of the outline because
// it is fairly long and used by multiple commands.  However,
// when the GadOutline structure is created, space is reserved
// to track these tags just like the tags directly included
// in the outline.

struct TagItem pal_slider_obj_tags[] =
{
    { GA_RelVerify, TRUE },
    { GA_Immediate, TRUE },
    { PGA_FREEDOM, LORIENT_HORIZ },
    { GTSL_Min, 0 },
    { GTSL_Max, 15 },
    { GTSL_Level, 0 },
    { GTSL_LevelFormat, (ULONG)&"%02ld" },
    { GTSL_LevelPlace, PLACETEXT_LEFT },
    { GTSL_MaxLevelLen, 2 },
    { TAG_END, 0 }
};

// This is the data used to make the folder icon.  We first define some
// of the important locations within the icon (which makes it easier to
// design and to later modify), and then create a list of tags which
// describe the drawing operations needed to create it.

#define FL_LEFT 12
#define FL_MIDLEFT 30
#define FL_TOP 12
#define FL_MIDTOP 22
#define FL_BOTTOM 51
#define FL_RIGHT 51
#define FL_BOLDEN 5

#define FL_TABLEFT FL_MIDLEFT+5
#define FL_TABRIGHT FL_RIGHT-5
#define FL_TABBOTTOM FL_MIDTOP+FL_BOLDEN+6

static ULONG FolderDrawing[] = {
    GODT_FillRect, GO_SCLPNT(BACKGROUNDPEN,0,0,63,63),
    GODT_DrawStdFrame, GO_SCLPNT(SHINEPEN,0,0,63,63),
    GODT_FillRect,
        GO_SCLPNT(TEXTPEN,FL_LEFT,FL_MIDTOP,FL_LEFT+FL_BOLDEN,FL_BOTTOM),
    GODT_FillRect,
        GO_SCLPNT(TEXTPEN,FL_LEFT,FL_MIDTOP,FL_MIDLEFT,FL_MIDTOP+FL_BOLDEN),
    GODT_MoveTo,
        GO_SCLPNT(0,FL_MIDLEFT,FL_MIDTOP,0,0),
    GODT_DrawTo2,
        GO_SCLPNT(TEXTPEN,FL_TABLEFT,FL_TOP,FL_TABRIGHT,FL_TOP),
    GODT_DrawTo2,
        GO_SCLPNT(TEXTPEN,FL_RIGHT,FL_MIDTOP,FL_RIGHT,FL_BOTTOM),
    GODT_DrawTo,
        GO_SCLPNT(TEXTPEN,FL_LEFT,FL_BOTTOM,0,0),
    GODT_MoveTo,
        GO_SCLPNT(0,FL_MIDLEFT,FL_MIDTOP+FL_BOLDEN,0,0),
    GODT_DrawTo2,
        GO_SCLPNT(TEXTPEN,FL_TABLEFT,FL_TABBOTTOM,FL_RIGHT,FL_TABBOTTOM),
    TAG_END, 0
};

/*********************************************
 **
 ** Main window gadget outline
 **
 *********************************************/

// This is the main outline structure.  It is simply an array of ULONGs,
// organized as a series of commands.  Each command may have up to 8
// parameters and 3 tag lists, although currently the library only
// does anything with the first two tag lists.  The first tag list
// is always a list of outline commands (GOCT_*) used to control the
// command - see the header file for information on these.  The
// interpretation of the second tag list depends on the command type --
// It may be a list of GadTools tags, Window tags, Screen tags, GOCT_
// tags to add to the command tag list of following commands, etc.

// When the outline is created, all of the supplied parameters and tag
// lists are copied and used to track the state of the gadgets.  Because
// only the state of tags directly supplied to the outline are tracked,
// you will need to make sure you include GTST_String, GTCY_Active,
// GTCY_Labels, etc., even if you do not set them until the gadgets have
// been created.  If these are not included, during a resize and other
// times that the gadgets need to be rebuilt, they will revert to their
// default values.

// NOTE!!!!!  _ALL_ tag lists in the outline MUST end with a TAG_END.
// The library does not consider a TAG_MORE, or anything else, a list
// terminator.  So when you use TAG_MORE, it will look like this:
//
// ..., TAG_MORE, (ULONG)&more_tags, TAG_END, NEW_COMMAND(), ...

static ULONG outline[] = {

// Default GadOutline GOA_ type tags.  These tags are immediately parsed
// when this command is encountered just as if they were passed to
// AllocGadOutline().

GO_OUTLINETAGS(0,0),

    TAG_END,                        // 1st tag list -- no command tags.
    GOA_AutoNewSize,    FALSE,      // 2nd tag list -- new outline tags.
    GOA_FontMinSize,    4,
    GOA_ClearFullWin,   TRUE,       // Because our outside group has a border.
    GOA_BaseName,       (ULONG)&"GadOutline Example3",
    TAG_END,

// Default window tags.  These are supplied as defaults when GO_OpenWindow()
// is called; they will be overridden by any tags passed directly to the
// function call.  Only include this command once.

GO_WINDOWTAGS(0,0),

    TAG_END,                        // 1st tag list -- no command tags.
    WA_IDCMP,           IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW | IDCMP_NEWSIZE,
    WA_Activate,        TRUE,
    WA_CloseGadget,     TRUE,
    WA_DepthGadget,     TRUE,
    WA_DragBar,         TRUE,
    WA_SizeGadget,      TRUE,
    WA_SizeBBottom,     TRUE,
    WA_ReportMouse,     TRUE,
    WA_SimpleRefresh,   TRUE,
    TAG_END,

// Global command tags -- Added to the first tag list (command list)
// of every command which follows this.  Space will be allocated to track
// their state just as if they were directly supplied to the command.

GO_COMMANDTAGS(0,0),

    TAG_END,
    GOCT_SetHotKey, 0,      // Automatically set hot key code
    GOCT_SetUserHook, 1,    // Set user hook to translation 1
                            // (Computed in translation hook below.)
    TAG_END,

// Start the layout.  A layout is organized as a recursive collection
// of "groups."  A group can be either horizontal or vertical, and may
// contain both actual boxes or other groups.

// Initial group.  No GrpID, no StdID, give it all the weight.
// A 'VDraw' group is simply a vertical group with a second tag list
// of standard drawing commands.  We can use them to create a frame
// around the group.
GO_VDRAWGRP(0,0,1),

// Command tags to set the space around the group.  GOM_PadSet means
// to directly set the amount of padding [padding is space that the
// library is allowed to remove to make a layout fit within its bounds.]
// GOT_PercCharH and GOT_PercCharW are the "type" units - in this case,
// we are asking for 100 Percent of a character height and width.

GOCT_SizeSpaceAbove, GO_TSIZE(GOM_PadSet,100,GOT_PercCharH),
GOCT_SizeSpaceBelow, GO_TSIZE(GOM_PadSet,100,GOT_PercCharH),
GOCT_SizeSpaceLeft, GO_TSIZE(GOM_PadSet,100,GOT_PercCharW),
GOCT_SizeSpaceRight, GO_TSIZE(GOM_PadSet,100,GOT_PercCharW),
TAG_END,

// Now the second tag list of drawing commands.  DrawGroups are always
// initialized with their drawing boundaries set to the space frame
// around the group, since this is normally where you will be drawing.
// GO_SCLPNT is a macro that creates the standard data format for
// drawing commands.  Its arguments are a standard pen [0 to 15]
// and two pairs of coordinates, whose values each range from 0 to 63
// and are interpreted as 'x/63 of the current drawing boundaries.'
// Frame boundaries, the default for groups, split this 0 to 63 value
// further into left/top and right/bottom sides; 0 to 31 will place you
// in the left/top part of the frame and 32 to 63 in the right/bottom.
// This command essentially says, "draw a raised frame halfway between
// the beginning and ending of the space area."  Note that to get a
// recessed border, you just specify the SHADOWPEN, which causes the
// placement of the light/dark colors to be inverted.
GODT_DrawStdFrame, GO_SCLPNT(SHINEPEN,16,16,48,48),
TAG_END,

    // Top vertical slice of initial group -- divide into horizontal slices.
    GO_HORIZGRP(0,0,1), TAG_END,

        // Left horizontal slide -- divide into vertical slices.
        GO_VERTGRP(0,0,1),
        GOCT_SizeSpaceRight, GO_TSIZE(GOM_PadSet,50,GOT_PercCharW),
        TAG_END,
        
            // Create a GadTools box.  The parameters are, in order,
            // GadTools Kind, GrpID, StdID, Weight, Label, Flags.
            GO_GTBOX(LISTVIEW_KIND, 0, INFOLIST_ID, 1, (ULONG)&"_Information",
                PLACETEXT_ABOVE|NG_HIGHLABEL),

                // Set the minimum size that the listview's body can be.
                // GOM_StdMax means to set the standard size [the bare
                // minimum size of the box] to the maximum of its current
                // value and the new value being supplied.
                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,700,GOT_PercCharW),
                GOCT_SizeBodyHeight, GO_TSIZE(GOM_StdMax,300,GOT_PercCharH),
                
                // Link this object to another.  This tag tells the library
                // to point the GTLV_ShowSelected tag in this command's
                // second/object/GadTools taglist to the object created
                // by the INFOEDIT_ID command.  This object's creation will
                // be deferred until the object it is linked to has been
                // created; if that object is never created, this one won't
                // be either.
                
                GOCT_AddTagLink, GO_MAKELINK(GTLV_ShowSelected,INFOEDIT_ID),
                
                // Point hotkey events to the INFOEDIT_ID command.  The
                // standard GadTools hook automatically sets the command's
                // hotkey by examining its label text; this allows us to
                // keep that automatic hotkey while making the hotkey
                // actually refer to a different command.
                GOCT_SetHotKeyCmd, INFOEDIT_ID,
                TAG_END,
                
                // Start of the second - GadTools - taglist.  These are the
                // tags which will be tracked by the library.
                GTLV_Selected, ~0,
                GTLV_Labels, NULL,
                GTLV_ShowSelected, NULL,
                GT_Underscore, '_',
                TAG_END,

            // Create a string gadget.  This is the gadget that the
            // previous ListView has a TagLink to.
            GO_GTBOX(STRING_KIND, 0, INFOEDIT_ID, 0, NULL, 0),

                // Tell the library to ignore this box's dimensions
                // when computing both the minimum size of the layout
                // and the final position of all the boxes.
                GOCT_IgnoreMinDimens, TRUE, GOCT_IgnoreFinDimens, TRUE,
                TAG_END,
                
                // Set GadTools tags.  The standard hook looks for
                // GTST_MaxChars and allocates a buffer of that size to track
                // the string gadget's value.  It currently does _NOT_ change
                // the size of this buffer to match a change in this tag,
                // so make sure you leave plenty of room here.
                GTST_MaxChars, STRING_LEN,
                GTST_String, (ULONG)&"",
                TAG_END,

        // End the last vertical group.
        GO_ENDGRP(),

        // Start a new vertical group -- directly to left of last group.
        GO_VERTGRP(0,0,0),
        
        // This tag tells the library to exactly align all of the box's
        // label areas, space areas and bodies.
        GOCT_FitToGroup, TRUE,
        TAG_END,
        
            GO_GTBOX(CYCLE_KIND, 0, WHICHGROUP_ID, 0, (ULONG)&"Gr_oup Demo",
                PLACETEXT_ABOVE|NG_HIGHLABEL),

                /** The CYCLE_KIND minimum dimension hook is now implemented. :)

                // Set up information about the array of strings supplied
                // in the tag "GTCY_Labels" in the second tag list.
                GOCT_TextArrayTag, GTCY_Labels,
                
                // Set user variable 1 to the maximum width of all of these
                // strings.
                GOCT_SizeUser1, GO_TSIZE(GOM_StdSet,100,GOT_PercTextMaxW),
                
                // Add 4 pixels to the value in User1.
                GOCT_SizeUser1, GO_TSIZE(GOM_StdAdd,4,GOT_Pixels),
                
                // Set the body width to the maximum of its current value
                // and the Std value in User1.
                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,100,GOT_PercMdUser1),
                
                // Add 20 pixels for the cycle imagery.  We have now supplied
                // all of the information needed to determine the minimum
                // size of this gadget.  We had to go to all of this work
                // because the library's standard gadtools hook for cycle
                // gadget isn't finished yet...  But this makes a nice
                // example, anyway... ;)
                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdAdd,20,GOT_Pixels),

                **/

                TAG_END,
                GTCY_Labels, (ULONG)&GroupLabels[0],
                GTCY_Active, 0,
                GT_Underscore, '_',
                TAG_END,

            // Create the group demo buttons.
            GO_GTBOX(BUTTON_KIND, DEMOGRP_GID | DEMOGRP1_GID, GRPBUT1_ID, 0,
                (ULONG)&"G1-A", PLACETEXT_LEFT),

                TAG_END,
                
                // We need to track these gadget's disabled state.
                GA_Disabled, FALSE,
                TAG_END,

            GO_GTBOX(BUTTON_KIND, DEMOGRP_GID | DEMOGRP2_GID, GRPBUT2_ID, 0,
                (ULONG)&"G2-A", PLACETEXT_RIGHT),

                TAG_END,
                GA_Disabled, FALSE,
                TAG_END,

            GO_HORIZGRP(0,0,0), TAG_END,
        
                GO_GTBOX(BUTTON_KIND, DEMOGRP_GID | DEMOGRP1_GID, GRPBUT3_ID, 0,
                    (ULONG)&"G1-B", PLACETEXT_ABOVE),

                    TAG_END,
                    GA_Disabled, FALSE,
                    TAG_END,

                GO_GTBOX(BUTTON_KIND, DEMOGRP_GID | DEMOGRP3_GID, GRPBUT4_ID, 0,
                    (ULONG)&"G3-A", PLACETEXT_BELOW),

                    TAG_END,
                    GA_Disabled, FALSE,
                    TAG_END,

            GO_ENDGRP(),
            
            GO_HORIZGRP(0,0,0), TAG_END,
        
                GO_GTBOX(BUTTON_KIND, DEMOGRP_GID | DEMOGRP3_GID, GRPBUT5_ID, 0,
                    (ULONG)&"G3-B", PLACETEXT_LEFT),

                    TAG_END,
                    GA_Disabled, FALSE,
                    TAG_END,

                GO_GTBOX(BUTTON_KIND, DEMOGRP_GID | DEMOGRP2_GID, GRPBUT6_ID, 0,
                    (ULONG)&"G2-B BIG", PLACETEXT_RIGHT),

                    TAG_END,
                    GA_Disabled, FALSE,
                    TAG_END,

            GO_ENDGRP(),

            GO_GTBOX(BUTTON_KIND, DEMOGRP_GID, GRPBUT7_ID, 0,
                (ULONG)&"La Zero", PLACETEXT_IN),

                TAG_END,
                GA_Disabled, FALSE,
                TAG_END,

        GO_ENDGRP(),

    GO_ENDGRP(),

    // Second line of root group.
    GO_HORIZGRP(0,0,1), TAG_END,

        GO_VERTGRP(0,0,1), TAG_END,
        
            GO_GTBOX(TEXT_KIND, 0, SCRNPALKEY_ID, 0,
                (ULONG)&"Flexi-_Palette (TM)",PLACETEXT_IN|NG_HIGHLABEL),

                GOCT_SetHotKeyCmd, SCRNPAL_ID,
                TAG_END,
                GT_Underscore, '_',
                TAG_END,

            GO_HORIZGRP(0,0,1), TAG_END,

                GO_VERTGRP(0,0,1), TAG_END,
                
                    GO_GTBOX(PALETTE_KIND, 0, SCRNPAL_ID, 1, NULL, 0),

                        // Set up an initial value for the indicator.
                        GOCT_CopyFromTSize, GO_TSIZE(GOM_Set,15,GOT_Pixels),
                        GOCT_CopyTSizeToTag, GTPA_IndicatorHeight,
                    
                        // Compute a nice size for the palette's indicator.
                        GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,500,GOT_PercCharW),
                        GOCT_SizeUser1, GO_TSIZE(GOM_VarSet,20,GOT_PercBodyH),
                        GOCT_SizeUser1, GO_TSIZE(GOM_VarMin,250,GOT_PercCharH),
                        GOCT_SizeUser1, GO_TSIZE(GOM_VarMax,6,GOT_Pixels),
                        
                        // Copy value in User1 to GTPA_IndicatorHeight tag.
                        GOCT_CopyUser1ToTag, GTPA_IndicatorHeight,
                        TAG_END,

                        GTPA_IndicatorHeight, 15,
                        GTPA_Color, 0,
                        GTPA_Depth, 2,
                        TAG_END,

                    GO_HORIZGRP(0,0,0), TAG_END,

                        GO_GTBOX(SLIDER_KIND, 0, PALRED_ID, 1, NULL, 0),

                            GOCT_SizeSpaceRight, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                            TAG_END,
                            TAG_MORE, (ULONG)&pal_slider_obj_tags,
                            TAG_END,

                        GO_GTBOX(TEXT_KIND, 0, PALREDKEY_ID, 0, (ULONG)&"_R",
                            PLACETEXT_IN|NG_HIGHLABEL),

                            // No space between this box and one to left.
                            GOCT_SizeSpaceLeft, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),

                            GOCT_SetHotKeyCmd, PALRED_ID,
                            TAG_END,
                            GTTX_Border, TRUE,
                            GT_Underscore, '_',
                            TAG_END,

                    GO_ENDGRP(),

                    GO_HORIZGRP(0,0,0), TAG_END,
            
                        GO_GTBOX(SLIDER_KIND, 0, PALGREEN_ID, 1, NULL, 0),

                            GOCT_SizeSpaceRight, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                            TAG_END,
                            TAG_MORE, (ULONG)&pal_slider_obj_tags,
                            TAG_END,

                        GO_GTBOX(TEXT_KIND, 0, PALGREENKEY_ID, 0, (ULONG)&"_G",
                            PLACETEXT_IN|NG_HIGHLABEL),

                            GOCT_SizeSpaceLeft, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                            GOCT_SetHotKeyCmd, PALGREEN_ID,
                            TAG_END,
                            GTTX_Border, TRUE,
                            GT_Underscore, '_',
                            TAG_END,

                    GO_ENDGRP(),
                    
                    GO_HORIZGRP(0,0,0), TAG_END,
            
                        GO_GTBOX(SLIDER_KIND, 0, PALBLUE_ID, 1, NULL,
                            0),

                            GOCT_SizeSpaceRight, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                            TAG_END,
                            TAG_MORE, (ULONG)&pal_slider_obj_tags,
                            TAG_END,

                        GO_GTBOX(TEXT_KIND, 0, PALBLUEKEY_ID, 0, (ULONG)&"_B",
                            PLACETEXT_IN|NG_HIGHLABEL),

                            GOCT_SizeSpaceLeft, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                            GOCT_SetHotKeyCmd, PALBLUE_ID,
                            TAG_END,
                            GTTX_Border, TRUE,
                            GT_Underscore, '_',
                            TAG_END,

                    GO_ENDGRP(),

                GO_ENDGRP(),

                GO_GTBOX(MX_KIND, 0, PALDEPTH_ID, 0, NULL,
                    PLACETEXT_RIGHT),

                    // Note that the library hook expects an Mx's body to be
                    // the width of both the gadget's labels AND buttons.  It
                    // then figures out the correct values to give GadTools.

                    // Set up an initial value for the spacing.
                    GOCT_CopyFromTSize, GO_TSIZE(GOM_Set,0,GOT_Pixels),
                    GOCT_CopyTSizeToTag, GTMX_Spacing,
                    
                    // This ugly thing puts spacing between the labels
                    // so that the Mx gad's size is close to its actual
                    // body size.  This is probably about as complicated
                    // as you want to get before writing a user hook...
                    // And this will probably be implemented in the hook
                    // at some point... ;)
                    
                    GOCT_TextArrayTag, GTMX_Labels,
                    GOCT_SizeUser1, GO_TSIZE(GOM_VarSet,100,GOT_PercBodyH),
                    GOCT_SizeUser1, GO_TSIZE(GOM_VarAdd,-100,GOT_PercTextAddH),
                    GOCT_SizeUser2, GO_TSIZE(GOM_VarSet,100,GOT_PercTextAddL),
                    GOCT_SizeUser2, GO_TSIZE(GOM_VarAdd,-1,GOT_Pixels),
                    GOCT_SizeUser1, GO_TSIZE(GOM_VarDiv,100,GOT_PercMdUser2),
                    GOCT_SizeUser1, GO_TSIZE(GOM_VarMax,0,GOT_Pixels),
                    GOCT_CopyUser1ToTag, GTMX_Spacing,
                    
                    // Directly set the hotkey.
                    GOCT_SetHotKey, '`',
                    TAG_END,

                    GA_Immediate, TRUE,
                    GTMX_Spacing, 1,
                    GTMX_Labels, (ULONG)&PalDepths[0],
                    GTMX_Active, 1,
                    TAG_END,

            GO_ENDGRP(),
        
        GO_ENDGRP(),
        
        GO_VERTGRP(0,0,1), TAG_END,
        
            // This box has a special weight distribution.  Normally,
            // the library assigns all extra space in a box to its
            // body.  "GO_WEIGHT(0,GO_WDIST(1,0,0,0,0,0),1)" says to
            // use this default for the horizontal spacing, but assign
            // all of the extra vertical space to the box's space above
            // area -- GO_WDIST(spcabv,txtabv,body,txtblw,spcblw,leftover).
            GO_GTBOX(STRING_KIND, 0, FONTNAME_ID,
                GO_WEIGHT(0,GO_WDIST(1,0,0,0,0,0),1),
                (ULONG)&"Selected _Font",PLACETEXT_ABOVE|NG_HIGHLABEL),

                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,500,GOT_PercCharW),
                TAG_END,
                GTST_MaxChars, 100, GTST_String, (ULONG)&"",
                GT_Underscore, '_',
                TAG_END,

            // We turn GOCT_FitToGroup on here so that the drawing box
            // will have the exact same vertical dimensions as the
            // string gadget.
            GO_HORIZGRP(0,0,0), GOCT_FitToGroup, TRUE, TAG_END,
            
                GO_GTBOX(INTEGER_KIND, 0, FONTSIZE_ID, 1, (ULONG)&"_Size",
                    PLACETEXT_LEFT|NG_HIGHLABEL),

                    GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdAdd,300,GOT_PercCharW),
                    TAG_END,
                    GTIN_MaxChars, 3, GTIN_Number, 0,
                    GT_Underscore, '_',
                    TAG_END,

                // Create a folder drawing.  The drawing box has no
                // default dimensions (except the the standard space area
                // around it), so we must explicately tell it
                // how big we want it to be.
                GO_DRAWBOX(GOSD_BoopsiGad,0,SETFONT_ID,0),

                    GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdSet,4,GOT_Pixels),
                    GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdAdd,200,GOT_PercCharW),
                    GOCT_SizeBodyWidth, GO_TSIZE(GOM_PadSet,4,GOT_Pixels),
                    GOCT_SetHotKey, 'e',
                    
                    // Define the drawing.  Here we just set our boundaries
                    // to be the box's body size, and then "execute" the
                    // previously defined folder drawing.  GODT_ExecDrawing
                    // is something like TAG_MORE, except that the tags it
                    // points to are not included in the command's local
                    // tag list to have their state tracks - just the pointer
                    // to our previously defined static tag list is stored.
                    // This removes a lot of possible memory overhead in
                    // allocating all of the tags to track their state.  In
                    // addition, GODT_ExecDrawing does not stop the tag list;
                    // this command may be followed by other commands, even
                    // other GODT_ExecDrawings.
                    TAG_END,
                    GODT_ExecDrawing, (ULONG)&FolderDrawing[0],
                    TAG_END,
            
            GO_ENDGRP(),

            GO_HORIZGRP(0,0,0), TAG_END,
            
                GO_GTBOX(INTEGER_KIND, 0, MINSIZE_ID, 1, (ULONG)&"_Min Size",
                    PLACETEXT_LEFT|NG_HIGHLABEL),

                    GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdAdd,300,GOT_PercCharW),
                    TAG_END,
                    GTIN_MaxChars, 3, GTIN_Number, 4,
                    GT_Underscore, '_',
                    TAG_END,

            GO_ENDGRP(),
    
            GO_HORIZGRP(0,0,0), TAG_END,
            
                GO_GTBOX(TEXT_KIND, 0, 0, 0, (ULONG)&"Font",
                    PLACETEXT_IN|NG_HIGHLABEL),

                    TAG_END,
                    GTTX_Border, FALSE,
                    TAG_END,
                    
                GO_VERTGRP(0,0,0), TAG_END,
                
                    GO_GTBOX(CHECKBOX_KIND, 0, SCALEFONT_ID, 0, (ULONG)&"S_cl",
                        PLACETEXT_RIGHT),

                        TAG_END,
                        GT_Underscore, '_',
                        GTCB_Checked, TRUE,
                        TAG_END,
    
                    GO_GTBOX(CHECKBOX_KIND, 0, SYSFONT_ID, 0, (ULONG)&"S_ys",
                        PLACETEXT_RIGHT),

                        TAG_END,
                        GT_Underscore, '_',
                        GTCB_Checked, FALSE,
                        TAG_END,
    
                GO_ENDGRP(),

                GO_VERTGRP(0,0,0), TAG_END,
                
                    GO_GTBOX(CHECKBOX_KIND, 0, DISKFONT_ID, 0, (ULONG)&"_Dsk",
                        PLACETEXT_RIGHT),

                        TAG_END,
                        GT_Underscore, '_',
                        GTCB_Checked, TRUE,
                        TAG_END,
    
                    GO_GTBOX(CHECKBOX_KIND, 0, ROMFONT_ID, 0, (ULONG)&"ROM",
                        PLACETEXT_RIGHT),

                        TAG_END,
                        GT_Underscore, '_',
                        GTCB_Checked, FALSE,
                        TAG_END,
                        
                GO_ENDGRP(),
    
            GO_ENDGRP(),

            GO_GTBOX(STRING_KIND, 0, PUBSCREEN_ID,
                GO_WEIGHT(0,GO_WDIST(0,0,0,0,1,0),1),
                (ULONG)&"P_ubScreen", PLACETEXT_ABOVE|NG_HIGHLABEL),

                GOCT_SizeSpaceAbove, GO_TSIZE(GOM_PadSet,50,GOT_PercCharH),
                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,500,GOT_PercCharW),
                TAG_END,
                GT_Underscore, '_',
                GTST_MaxChars, 100, GTST_String, (ULONG)&"",
                TAG_END,

        GO_ENDGRP(),

        GO_VERTGRP(0,0,0), TAG_END,
    
            // Another way to get the same effect as the previously
            // discussed weight distribution - put an empty box above
            // that is assigned all of the group's weight.
            GO_EMPTYBOX(0,0,1),

                GOCT_SizeSpaceAbove, GO_TSIZE(GOM_BaseSet,0,GOT_Pixels),
                GOCT_SizeSpaceBelow, GO_TSIZE(GOM_BaseSet,0,GOT_Pixels),
                TAG_END,

            GO_GTBOX(CYCLE_KIND, 0, REMAKE_ID,
                GO_WEIGHT(GO_WDIST(1,0,0,0,1,0),0,0),
                (ULONG)&"Si_ze Mode", PLACETEXT_LEFT|NG_HIGHLABEL),

                GOCT_TextArrayTag, GTCY_Labels,
                GOCT_SizeUser1, GO_TSIZE(GOM_StdSet,100,GOT_PercTextMaxW),
                GOCT_SizeUser1, GO_TSIZE(GOM_StdAdd,4,GOT_Pixels),
                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,100,GOT_PercMdUser1),
                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdAdd,20,GOT_Pixels),
                TAG_END,
                GT_Underscore, '_',
                GTCY_Labels, (ULONG)&ResizeTypes[0],
                GTCY_Active, 0,
                TAG_END,

            GO_GTBOX(TEXT_KIND, 0, CURFNAME_ID, 0, (ULONG)&"Font",
                PLACETEXT_LEFT),

                GOCT_SizeSpaceAbove, GO_TSIZE(GOM_PadSet,50,GOT_PercCharH),
                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,500,GOT_PercCharW),
                TAG_END,
                GTTX_Border, TRUE, GTTX_Text, (ULONG)&"",
                TAG_END,

            GO_GTBOX(NUMBER_KIND, 0, CURFSIZE_ID, 0, (ULONG)&"Curr Size",
                PLACETEXT_LEFT),

                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdAdd,300,GOT_PercCharW),
                TAG_END,
                GTNM_Border, TRUE, GTNM_Number, 0,
                TAG_END,

            GO_EMPTYBOX(0,0,1),

                GOCT_SizeSpaceAbove, GO_TSIZE(GOM_BaseSet,0,GOT_Pixels),
                GOCT_SizeSpaceBelow, GO_TSIZE(GOM_BaseSet,0,GOT_Pixels),
                TAG_END,

            GO_HORIZGRP(0,0,0), TAG_END,
        
                GO_GTBOX(CHECKBOX_KIND, 0, ONOFFALLC_ID,
                    GO_WEIGHT(GO_WDIST(0,0,0,0,1,0),0,1),
                    (ULONG)&"Crea_te", PLACETEXT_RIGHT),
            
                    TAG_END,
                    GT_Underscore, '_',
                    GTCB_Checked, TRUE,
                    TAG_END,

                GO_GTBOX(CHECKBOX_KIND, 0, ONOFFALLD_ID,
                    GO_WEIGHT(GO_WDIST(0,0,0,0,1,0),0,1),
                    (ULONG)&"Dime_n", PLACETEXT_RIGHT),
            
                    TAG_END,
                    GT_Underscore, '_',
                    GTCB_Checked, TRUE,
                    TAG_END,

            GO_ENDGRP(),

            GO_VERTGRP(0,BOOGRP_ID,0),
        
                GOCT_IgnoreFinDimens, FALSE, GOCT_IgnoreCreation, FALSE,
                TAG_END,

                GO_HORIZGRP(0,0,0), TAG_END,
            
                    GO_GTBOX(CHECKBOX_KIND, 0, ONOFF1_ID, 0, NULL, 0),
            
                        GOCT_SetHotKey, '1',
                        TAG_END,
                        GTCB_Checked, TRUE,
                        TAG_END,

                    GO_GTBOX(BUTTON_KIND, 0, BOO1_ID, 1,
                        (ULONG)&"B", PLACETEXT_IN),

                        GOCT_IgnoreCreation, FALSE,
                        TAG_END,
                        TAG_END,

                    GO_GTBOX(BUTTON_KIND, 0, HERE1_ID, 0,
                        (ULONG)&"<", PLACETEXT_IN),

                        TAG_END,
                        TAG_END,

                GO_ENDGRP(),

                GO_HORIZGRP(0,0,0), TAG_END,
            
                    GO_GTBOX(CHECKBOX_KIND, 0, ONOFF2A_ID, 0, NULL, 0),
            
                        GOCT_SetHotKey, '2',
                        TAG_END,
                        GTCB_Checked, TRUE,
                        TAG_END,

                    GO_GTBOX(CHECKBOX_KIND, 0, ONOFF2B_ID, 0, NULL, 0),
            
                        GOCT_SetHotKey, '3',
                        TAG_END,
                        GTCB_Checked, TRUE,
                        TAG_END,

                    GO_GTBOX(BUTTON_KIND, 0, BOO2A_ID, 0,
                        (ULONG)&"B", PLACETEXT_IN),

                        GOCT_IgnoreFinDimens, FALSE, GOCT_IgnoreCreation, FALSE,
                        TAG_END,
                        TAG_END,

                    GO_GTBOX(BUTTON_KIND, 0, BOO2B_ID, 0,
                        (ULONG)&"B", PLACETEXT_IN),

                        GOCT_IgnoreFinDimens, FALSE, GOCT_IgnoreCreation, FALSE,
                        TAG_END,
                        TAG_END,

                    GO_EMPTYBOX(0,0,1),

                        GOCT_SizeSpaceLeft, GO_TSIZE(GOM_BaseSet,0,GOT_Pixels),
                        GOCT_SizeSpaceRight, GO_TSIZE(GOM_BaseSet,0,GOT_Pixels),
                        TAG_END,
    
                    GO_GTBOX(BUTTON_KIND, 0, HERE2_ID, 0,
                        (ULONG)&"<", PLACETEXT_IN),

                        TAG_END,
                        TAG_END,

                GO_ENDGRP(),

                GO_HORIZGRP(0,0,0), TAG_END,
            
                    GO_GTBOX(CHECKBOX_KIND, 0, ONOFF3A_ID, 0, NULL, 0),
            
                        GOCT_SetHotKey, '4',
                        TAG_END,
                        GTCB_Checked, TRUE,
                        TAG_END,

                    GO_GTBOX(CHECKBOX_KIND, 0, ONOFF3B_ID, 0, NULL, 0),
                
                        GOCT_SetHotKey, '5',
                        TAG_END,
                        GTCB_Checked, TRUE,
                        TAG_END,

                    GO_GTBOX(BUTTON_KIND, 0, BOO3A_ID, 1,
                        (ULONG)&"B", PLACETEXT_IN),

                        GOCT_IgnoreFinDimens, FALSE, GOCT_IgnoreCreation, FALSE,
                        TAG_END,
                        TAG_END,

                    GO_GTBOX(BUTTON_KIND, 0, BOO3B_ID, 1,
                        (ULONG)&"B", PLACETEXT_IN),

                        GOCT_IgnoreFinDimens, FALSE, GOCT_IgnoreCreation, FALSE,
                        TAG_END,
                        TAG_END,

                    GO_GTBOX(BUTTON_KIND, 0, HERE3_ID, 1,
                        (ULONG)&"<", PLACETEXT_IN),

                        TAG_END,
                        TAG_END,

                GO_ENDGRP(),

            GO_ENDGRP(),

            GO_EMPTYBOX(0,0,1),

                GOCT_SizeSpaceAbove, GO_TSIZE(GOM_BaseSet,0,GOT_Pixels),
                GOCT_SizeSpaceBelow, GO_TSIZE(GOM_BaseSet,0,GOT_Pixels),
                TAG_END,

        GO_ENDGRP(),
        
    GO_ENDGRP(),
    
GO_ENDGRP(),

// Every outline must end with this command.
GO_ENDOUTLINE()

};

/*********************************************
 **
 ** Example hooks used in outline
 **
 *********************************************/

// This is an example command hook.  It implements the code for finding
// the minimum dimensions of a checkbox and the code for responding to hotkey
// events.
// Note that this hook is not directly referenced in the outline - instead,
// a code is supplied for it in GOCT_SetUserHook and the translation hook
// converts this code to the actual address.

ULONG __asm __saveds __interrupt
checkbox_code(register __a0 struct Hook *hook,
              register __a2 struct CmdInfo *ci,
              register __a1 struct CmdHookMsg *msg)
{
    struct GadOutline *go;      // Global outline information.
    struct BoxAttr *ba;         // Box which called this hook.
    struct Gadget *gad;         // Gadget of hook, if created.
    ULONG ret;                  // Return code.
    UWORD kind;                 // GadTools kind of this box.

    // ---------------------------------------------------
    // Find some Universally Interesting variables.
    // ---------------------------------------------------

    if(ci) {
        go = ci->ci_GadOutline;             // Extract GadOutline
        kind = GETCMDSUBC(ci->ci_Command);  // GadTools kind
        gad = ci->ci_Object;                // Currently created gadget
        ba = ci->ci_BoxAttr;                // And BoxAttr of caller.
    } else go = NULL;

    // ---------------------------------------------------
    // Sanity checking...
    // ---------------------------------------------------

    if(!hook || !msg || !ci || !go) return 0;

    // ---------------------------------------------------
    // Check if this is correct type of command.
    // ---------------------------------------------------

    if( (ci->ci_Command&GO_OUTCMD(0,0,0xFFFF,0xFFFF,0))
        != GO_OUTCMD(0,0,GOK_Box,GOKB_GadTools,0) ) {
        
        // Continue processing this message.  Note that you must ALWAYS
        // pass along the return value from lower-level hooks if you are
        // not going to set it yourself.
        return GO_ContCmdHookA(ci,msg);
    }

    switch(msg->chm_Message) {

        case CHM_GETMINDIMENS: {

            struct GODimensInfo *gdi;
            WORD height,width;
            
            // The structure to fill in with out dimension information.
            gdi = msg->chm_MinDim;

            // Some example calls, just for the heck of it... :)
            height = GO_InterpretTypedSize(go,0,
                        GO_TSIZE(GOM_Set,100,GOT_PercCharH));
            width = GO_ParseTypedSizeList(go,0,
                        GOCT_TextPtr,ci->ci_BoxText,
                        GOCT_SizeParse,GO_TSIZE(GOM_Set,100,GOT_PercTextMaxW),
                        TAG_END);

            // If this is a checkbox...
            if(kind == CHECKBOX_KIND) {
            
                // Let default hook do what it can.  The library currently
                // knows how to take care of any GadTools labels.  Note that
                // we save the return value, because we have nothing else
                // to say.
                ret = GO_ContCmdHookA(ci,msg);

                // Make sure the checkbox's body is big enough.
                if(gdi->gdi_StdBodyWidth < 26) {
                    if( (gdi->gdi_StdBodyWidth+gdi->gdi_PadBodyWidth) < 26 ) {
                        gdi->gdi_PadBodyWidth = 0;
                    }
                    gdi->gdi_StdBodyWidth = 26;
                }
                if(gdi->gdi_StdBodyHeight < 11) {
                    if( (gdi->gdi_StdBodyHeight+gdi->gdi_PadBodyHeight) < 11 ) {
                        gdi->gdi_PadBodyHeight = 0;
                    }
                    gdi->gdi_StdBodyHeight = 11;
                }

            } else {
            
                // If not a checkbox, just let the system handle it.
                ret = GO_ContCmdHookA(ci,msg);

            }

        } break;
        
        case CHM_HOTKEY: {

            struct TagItem *tg;

            // Only respond to IDCMP_VANILLAKEY events and IDCMP_RAWKEY
            // down events.

            if( (msg->chm_KeyGOIMsg->StdIMsg.Class != IDCMP_VANILLAKEY
                && msg->chm_KeyGOIMsg->StdIMsg.Class != IDCMP_RAWKEY)
                || (msg->chm_KeyGOIMsg->StdIMsg.Class == IDCMP_RAWKEY
                    && (msg->chm_KeyGOIMsg->StdIMsg.Code&0x80) != 0) ) {

                return GO_ContCmdHookA(ci,msg);
            }
            
            // If this is a checkbox and we are tracking its state...
    
            if( kind == CHECKBOX_KIND
                && (tg=FindTagItem(GTCB_Checked,ci->ci_GadToolsTags)) != NULL ) {

                struct TagItem update[] = {
                    { 0, 0 }, { TAG_END, 0 }
                };

                // A REALLY stupid way to do a checkbox hotkey, but it's
                // the basic code for most other types...

                // If shift is pressed, decrement.

                if( (msg->chm_KeyGOIMsg->StdIMsg.Qualifier
                    &( IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT
                        | IEQUALIFIER_CAPSLOCK ) ) != 0 ) {
                        
                    if(tg->ti_Data <= 0)
                        tg->ti_Data = 1;
                    else
                        tg->ti_Data--;
                        
                // Else, increment.

                } else {

                    if(tg->ti_Data >= 1)
                        tg->ti_Data = 0;
                    else
                        tg->ti_Data++;
                }
                        
                // Send a message to command to update its state.

                update[0].ti_Tag = GTCB_Checked;
                update[0].ti_Data = tg->ti_Data;

                GO_CallCmdHook( ci, CHM_SETOBJATTR, 0, &update[0] );
                
                // If an error occured, exit stage left.
                if(go->go_LastReqReturn) return 0;
                
                // If the gadget has been created, turn the GOIMsg
                // into the correct kind of event.  Yes, we are allowed
                // to do this. :)
    
                if(gad) {
                    msg->chm_KeyGOIMsg->StdIMsg.Class = IDCMP_GADGETUP;
                    msg->chm_KeyGOIMsg->StdIMsg.Code = tg->ti_Data;
                    msg->chm_KeyGOIMsg->StdIMsg.IAddress = (APTR)gad;
                }
                
                // We don't continue this message because we basically
                // just ate it.  Chomp chomp...  yummy...
                ret = 0;
            }
        }
        
        default: {

            ret = GO_ContCmdHookA(ci,msg);

        } break;
    }

    return ret;
}

struct Hook checkbox_hook = {
    { 0 },
    (ULONG (*)())checkbox_code,
    NULL,
    NULL
};

// This is an example transalation hook.  This hook is global to the outline
// and allows you to not only localize the outline array, but theoretically
// make it completely independant of any direct references to absolute
// program addresses.

// The actual library only sends the CHM_TRANSCMDHOOK to translate user
// hooks supplied in the outline; all other translation takes place within
// the library's default hook and can be modified using a user hook.
// The standard hook asks for translation of GadTools text pointers and the
// standard GadTools tags which supply strings or arrays of strings.

ULONG __asm __saveds __interrupt
translation_code(register __a0 struct Hook *hook,
                 register __a2 struct GadOutline *go,
                 register __a1 struct CmdHookMsg *msg)
{
    // ---------------------------------------------------
    // Sanity checking...
    // ---------------------------------------------------

    if(!hook || !msg || !go) return 0;

    switch(msg->chm_Message) {

        case CHM_TRANSTEXTPTR: {

            // If I had the developer info, I'd put some code here
            // to call locale.library... :)

            if(msg->chm_TransCode)
                D(bug("String Trans: %ls\n",msg->chm_TransCode));

            return msg->chm_TransCode;
            
        } break;

        case CHM_TRANSCMDHOOK: {

            if(msg->chm_TransCode == 1)
                return (ULONG)&checkbox_hook;
            else return msg->chm_TransCode;
            
        } break;

        default: {

        } break;
    }

    return GO_ContTransHookA(go,msg);
}

struct Hook translation_hook = {
    { 0 },
    (ULONG (*)())translation_code,
    NULL,
    NULL
};

/*********************************************
 **
 ** Program environment
 **
 *********************************************/

static struct Process *me = NULL;
static struct Window *oldwin = NULL;    // what me->pr_WindowPtr previously was

/*********************************************
 **
 ** Current program state
 **
 *********************************************/

static struct GadOutline *gad_outline = NULL;
static struct FontRequester *fr = NULL;
static UBYTE *go_error;                 // Where error results are returned
static struct List info_list;
static UBYTE pub_screen[100] = { 0 };

/*********************************************
 **
 ** All library bases
 **
 *********************************************/

#define MIN_VERSION     37L             // minimum version number for our libs

long __oslibversion = MIN_VERSION;

#ifndef LINKLIB
struct Library *GadOutlineBase = NULL;
#endif

static void quit(UBYTE *err);
static void closedown(void);
static void opendisplay(struct GadOutline *go);
static void handledisplay(struct GadOutline *go);
static void free_list(struct List *list);

/*********************************************
 **
 ** Routines for a clean exit, with optional error display
 **
 *********************************************/

static struct EasyStruct error_es = {
    sizeof(struct EasyStruct), 0,
    "GadOutline Example3 Requester",
    "Problem during startup:\n%ls",
    "Quit"
};

static void quit(UBYTE *err)
{
    closedown();

    if(err == NULL) err = go_error;
    if(err != NULL) (void)EasyRequest(NULL,&error_es, NULL, err);

    _exit(0);
}

static void closedown(void)
{
    if(gad_outline) FreeGadOutline(gad_outline);
    free_list(&info_list);
    if(fr) FreeAslRequest(fr);
    if(me) me->pr_WindowPtr = (APTR)oldwin;
    #ifndef LINKLIB
    if(GadOutlineBase) CloseLibrary(GadOutlineBase);
    #endif
}

/*********************************************
 **
 ** Routines for opening the screen, window and gadgets
 **
 *********************************************/

static void create_node(struct List *list,UBYTE *name)
{
    struct Node *nd;
    
    if( nd=AllocVec(sizeof(struct Node)+strlen(name)+5,MEMF_CLEAR) ) {
        nd->ln_Name = (char *)(nd+1);
        strcpy((UBYTE *)(nd+1),name);
        AddTail(list,nd);
    }
}

static void free_list(struct List *list)
{
    struct Node *nd;
    
    while( nd=RemTail(list) ) {
        FreeVec(nd);
    }
}

static void opendisplay(struct GadOutline *go)
{
    //GO_SetObjGrpAttrs(go,0,0,GA_Disabled,FALSE,TAG_END);

    GO_OpenWindow(go,   WA_PubScreenName,   pub_screen,
                        TAG_END );

    if(go->go_LastReqReturn || !go->go_Window) return;

    create_node(&info_list,"I'm");
    create_node(&info_list,"Too");
    create_node(&info_list,"Lazy");
    create_node(&info_list,"To");
    create_node(&info_list,"Put");
    create_node(&info_list,"Anything");
    create_node(&info_list,"Interesting");
    create_node(&info_list,"Here.");
    create_node(&info_list,"");
    create_node(&info_list,":p");

    GO_SetObjAttrs(go,INFOLIST_ID,0,GTLV_Labels,&info_list,TAG_END);

    me->pr_WindowPtr = (APTR)go->go_Window;
}

void update_fontinfo(struct GadOutline *go)
{
    GO_SetObjAttrs(go,FONTNAME_ID,0,
        GTST_String,go->go_TargetTA.tta_Name,TAG_END);
    GO_SetObjAttrs(go,FONTSIZE_ID,0,
        GTIN_Number,go->go_TargetTA.tta_YSize,TAG_END);
    GO_SetObjAttrs(go,CURFNAME_ID,0,
        GTTX_Text,go->go_TextAttr.tta_Name,TAG_END);
    GO_SetObjAttrs(go,CURFSIZE_ID,0,
        GTNM_Number,go->go_TextAttr.tta_YSize,TAG_END);
}

static void print_keys(UBYTE *keys)
{
    UBYTE *pos;
    UBYTE conv_keys[100];
    
    pos = &conv_keys[0];
    while( *keys && (pos < &conv_keys[95]) ) {
        if( (*keys >= ' ' && *keys <= 126) || *keys >= 160 ) {
            *pos = *keys;
            pos++;
            keys++;
        } else {
            *pos = '\\';
            pos++;
            *pos = ( ((*keys)/16) >= 10 ) ? ((*keys)/16)+'A'-10 : ((*keys)/16)+'0';
            pos++;
            *pos = ( ((*keys)&15) >= 10 ) ? ((*keys)&15)+'A'-10 : ((*keys)&15)+'0';
            pos++;
            *pos = 'x';
            pos++;
            keys++;
        }
    }
    *pos = 0;
    D(bug("%ls",&conv_keys[0]));
}

static void handledisplay(struct GadOutline *go)
{
    struct GOIMsg *msg;
    struct Gadget *gadget;
    ULONG class;
    UWORD code;
    UWORD qual;

    if(go == NULL || go->go_Window == NULL) return;

    update_fontinfo(go);

    while (1) {

        if(GO_GetObjAttr(go,REMAKE_ID,0,GTCY_Active,0)==0) {
        
            // Doing a full DimenGadOutline for a resize is extremely
            // abnormal; force the window to be able to go smaller than the
            // outline's minimum size.
            WindowLimits(go->go_Window,30,20,
                         go->go_Window->MaxWidth,go->go_Window->MaxHeight);
        }

        Wait( (1L<<go->go_Window->UserPort->mp_SigBit) );

        while (msg = GO_GetGOIMsg(go)) {

            struct GOIMsg *dupmsg;
            class = msg->StdIMsg.Class;
            code = msg->StdIMsg.Code;
            qual = msg->StdIMsg.Qualifier;
            gadget=msg->StdIMsg.IAddress;

            gadget = (struct Gadget *)msg->StdIMsg.IAddress;
            dupmsg = GO_DupGOIMsg(go,msg);

            GO_ReplyGOIMsg(msg);

            switch (class) {

                case IDCMP_CLOSEWINDOW:
                    return;

                case IDCMP_NEWSIZE:
                    if(GO_GetObjAttr(go,REMAKE_ID,0,GTCY_Active,0)==0) {
                        DimenGadOutline(go,TAG_END);
                    } else if(GO_GetObjAttr(go,REMAKE_ID,0,GTCY_Active,0)==1) {
                        RebuildGadOutline(go,TAG_END);
                    } else {
                        ResizeGadOutline(go,TAG_END);
                    }
                    update_fontinfo(go);
                    break;

                case IDCMP_REFRESHWINDOW:
                    GO_BeginRefresh(go);
                    GO_EndRefresh(go, TRUE);
                    break;

                case IDCMP_GADGETDOWN: {
                    D(bug("A gadget down type: %ld\n",gadget->GadgetID));
                    switch(gadget->GadgetID) {
                    
                        case PALDEPTH_ID: {

                            // Change the depth of the palette gadget.
                            // This requires a rebuild of the layout
                            // to recreate the palette gadget.
                            GO_SetObjAttrs(go,SCRNPAL_ID,0,
                                GTPA_Depth,code+1,TAG_END);
                            RebuildGadOutline(go,TAG_END);
                            update_fontinfo(go);
                        
                        } break;
                    }
                } break;

                case IDCMP_VANILLAKEY: {
                    D(bug("Van key (Code %lx) (Len %ld): '",code,strlen(&dupmsg->KeyPress[0])));
                    print_keys(&dupmsg->KeyPress[0]);
                    D(bug("'\n"));
                } break;
                
                case IDCMP_RAWKEY: {
                    D(bug("Raw key (Code %lx) (Len %ld): '",code,strlen(&dupmsg->KeyPress[0])));
                    print_keys(&dupmsg->KeyPress[0]);
                    D(bug("'\n"));
                    if(code == 0x5F) {
                        struct CmdInfo *ci = NULL;
                        UWORD reqret = GOREQ_CONT;
                        
                        GO_SetError(go,0,NULL,NULL);
                        while( reqret == GOREQ_CONT
                               && (ci = GO_CmdAtPoint(go,dupmsg,ci,TAG_END)) ) {
                            reqret = GO_ShowError(go,GO_MAKEERR(GOTYPE_NOTE,0),ci,
                                "Command covering this point:\n\nStdID: ~ci; GrpID: ~cg\nKind: ~ck; Code: ~cc; Sub: ~cs\nLabel: ~cl");
                        }
                    }
                } break;
                
                case IDCMP_GADGETUP: {
                    D(bug("A gadget up type: %ld\n",gadget->GadgetID));
                    switch(gadget->GadgetID) {

                        case WHICHGROUP_ID: {
                        
                            // Turn off every gadget with our demo group mask.
                            GO_SetObjGrpAttrs(go,GO_CMDID(DEMOGRP_GID,0),0,
                                GA_Disabled,TRUE,TAG_END);
                                
                            // Turn on every gadget with out demo group mask
                            // AND the same group code as the cycle gadget's
                            // current value.
                            GO_SetObjGrpAttrs(go,GO_CMDID(DEMOGRP_GID|code,0),0,
                                GA_Disabled,FALSE,TAG_END);

                        } break;
                        
                        case FONTNAME_ID: {
                        
                            DimenGadOutline(go,
                                GOA_FontName,
                                    GO_GetObjAttr(go,FONTNAME_ID,0,
                                        GTST_String,NULL),
                                TAG_END);
                            update_fontinfo(go);
    
                        } break;
                        
                        case FONTSIZE_ID: {
                        
                            DimenGadOutline(go,
                                GOA_FontSize,
                                    GO_GetObjAttr(go,FONTSIZE_ID,0,
                                        GTIN_Number,0),
                                TAG_END);
                            update_fontinfo(go);
    
                        } break;
                        
                        case MINSIZE_ID: {
                        
                            DimenGadOutline(go,
                                GOA_FontMinSize,
                                    GO_GetObjAttr(go,MINSIZE_ID,0,
                                        GTIN_Number,0),
                                TAG_END);
                            update_fontinfo(go);
    
                        } break;
                        
                        case SCALEFONT_ID: {
                        
                            DimenGadOutline(go,
                                GOA_FontDesigned,
                                    !GO_GetObjAttr(go,SCALEFONT_ID,0,
                                        GTCB_Checked,TRUE),
                                TAG_END);
                            update_fontinfo(go);
    
                        } break;
                        
                        case SYSFONT_ID: {
                        
                            DimenGadOutline(go,
                                GOA_FontSystemOnly,
                                    GO_GetObjAttr(go,SYSFONT_ID,0,
                                        GTCB_Checked,TRUE),
                                TAG_END);
                            update_fontinfo(go);
    
                        } break;
                        
                        case ROMFONT_ID: {
                        
                            DimenGadOutline(go,
                                GOA_FontROMFont,
                                    GO_GetObjAttr(go,ROMFONT_ID,0,
                                        GTCB_Checked,TRUE),
                                TAG_END);
                            update_fontinfo(go);
    
                        } break;
                        
                        case DISKFONT_ID: {
                        
                            DimenGadOutline(go,
                                GOA_FontDiskFont,
                                    GO_GetObjAttr(go,DISKFONT_ID,0,
                                        GTCB_Checked,TRUE),
                                TAG_END);
                            update_fontinfo(go);
    
                        } break;
                        
                        case PUBSCREEN_ID: {
                        
                            UBYTE *name;
                            
                            name = (UBYTE *)GO_GetObjAttr(go,PUBSCREEN_ID,0,
                                                GTST_String,NULL);
                            if(name) {
                                strncpy(pub_screen,name,99);
                            } else {
                                pub_screen[0] = 0;
                            }
                            
                            // This routine automagically closes the previous
                            // window and opens a new window with the gadgets
                            // in the same state.
                            
                            GO_OpenWindow(go,   WA_PubScreenName,   pub_screen,
                                                TAG_END );
                            if(!go->go_Window || go->go_LastReqReturn)
                                quit("Couldn't open window.");
                            update_fontinfo(go);

                        } break;
                        
                        case ONOFFALLC_ID:
                        case ONOFFALLD_ID: {

                            ULONG statec,stated;

                            statec = GO_GetObjAttr(go,ONOFFALLC_ID,0,
                                                    GTCB_Checked,TRUE);
                            stated = GO_GetObjAttr(go,ONOFFALLD_ID,0,
                                                    GTCB_Checked,TRUE);

                            if(gadget->GadgetID == ONOFFALLC_ID) {
                                if(statec && !stated) stated = TRUE;
                                GO_SetObjAttrs(go,ONOFFALLD_ID,0,
                                                GTCB_Checked,TRUE);
                            } else {
                                if(statec && !stated) statec = FALSE;
                                GO_SetObjAttrs(go,ONOFFALLC_ID,0,
                                                GTCB_Checked,FALSE);
                            }

                            // Turn creation and dimensions of group on/off.
                            
                            GO_SetCmdAttrs(go,BOOGRP_ID,0,
                                GOCT_IgnoreCreation, !statec,
                                GOCT_IgnoreFinDimens, !stated,
                                TAG_END);
                            RebuildGadOutline(go,TAG_END);
    
                        } break;
                        
                        case ONOFF1_ID: {
                        
                            GO_SetCmdAttrs(go,BOO1_ID,0,
                                GOCT_IgnoreCreation,
                                !GO_GetObjAttr(go,ONOFF1_ID,0,GTCB_Checked,TRUE),
                                TAG_END);
                            RebuildGadOutline(go,TAG_END);
    
                        } break;
                        
                        case ONOFF2A_ID: {
                        
                            ULONG state;
                            
                            state = GO_GetObjAttr(go,ONOFF2A_ID,0,
                                                GTCB_Checked,TRUE);

                            GO_SetCmdAttrs(go,BOO2A_ID,0,
                                GOCT_IgnoreCreation, !state,
                                GOCT_IgnoreFinDimens, !state,
                                TAG_END);
                            RebuildGadOutline(go,TAG_END);
    
                        } break;
                        
                        case ONOFF2B_ID: {
                        
                            ULONG state;
                            
                            state = GO_GetObjAttr(go,ONOFF2B_ID,0,
                                                GTCB_Checked,TRUE);

                            GO_SetCmdAttrs(go,BOO2B_ID,0,
                                GOCT_IgnoreCreation, !state,
                                GOCT_IgnoreFinDimens, !state,
                                TAG_END);
                            RebuildGadOutline(go,TAG_END);
    
                        } break;
                        
                        case ONOFF3A_ID: {
                        
                            ULONG state;
                            
                            state = GO_GetObjAttr(go,ONOFF3A_ID,0,
                                                GTCB_Checked,TRUE);

                            GO_SetCmdAttrs(go,BOO3A_ID,0,
                                GOCT_IgnoreCreation, !state,
                                GOCT_IgnoreFinDimens, !state,
                                TAG_END);
                            RebuildGadOutline(go,TAG_END);
    
                        } break;
                        
                        case ONOFF3B_ID: {
                        
                            ULONG state;
                            
                            state = GO_GetObjAttr(go,ONOFF3B_ID,0,
                                                GTCB_Checked,TRUE);

                            GO_SetCmdAttrs(go,BOO3B_ID,0,
                                GOCT_IgnoreCreation, !state,
                                GOCT_IgnoreFinDimens, !state,
                                TAG_END);
                            RebuildGadOutline(go,TAG_END);
    
                        } break;
                        
                        case SETFONT_ID: {

                            // Pop up the font requester
                            if (AslRequestTags(fr,

                                // Supply initial values for requester
                                ASL_FontName, (ULONG)go->go_TargetTA.tta_Name,
                                ASL_FontHeight, go->go_TargetTA.tta_YSize,
                                ASL_FontStyles, go->go_TargetTA.tta_Style,
                                ASL_FuncFlags, FONF_STYLES,
                                ASL_Window, go->go_Window,
                                TAG_END)) {

                                DimenGadOutline(go,
                                                 GOA_TextAttr,&fr->fo_Attr,
                                                 TAG_END);
                            }
                            update_fontinfo(go);

                        } break;
                    }
                } break;

            }
            if(dupmsg) GO_UndupGOIMsg(dupmsg);
        }
    }
}

/*********************************************
 **
 ** Program's main entry point
 **
 *********************************************/

void __regargs main(int argc,char **argv)
{
    NewList(&info_list);

    if( !(me = (struct Process *)FindTask(NULL)) ) quit("Can't find	myself!");
    oldwin = (struct Window *)me->pr_WindowPtr;

    if( (fr = (struct FontRequester *)
        AllocAslRequestTags(ASL_FontRequest,TAG_END)) == NULL) {
        quit("Can't allocate font requester!");
    }
            
#ifndef LINKLIB
    GadOutlineBase = OpenLibrary("gadoutline.library", 0);
    if (!GadOutlineBase)
       quit("Can't open gadoutline.library.");
    D(bug("Opened the library.  Creating outline...\n",NULL));
#endif
    
    gad_outline = AllocGadOutline(outline,
           GOA_ErrorText,       &go_error,
           GOA_ScreenName,      pub_screen,
           GOA_OutlineSize,     sizeof(outline),
           GOA_SetTransHook,    &translation_hook,
           TAG_END);
    if(gad_outline == NULL) {
        quit(go_error);
    }

    opendisplay(gad_outline);
    handledisplay(gad_outline);

    quit(NULL);
}
