/* $VER: layout.h 53.21 (29.9.2013) */
OPT NATIVE, POINTER
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass', 'target/intuition/classusr', 'target/images/bevel'
MODULE 'target/exec/types', 'target/intuition/intuition', 'target/utility/tagitem'
{#include <gadgets/layout.h>}
NATIVE {GADGETS_LAYOUT_H} CONST

NATIVE {LayoutLimits} OBJECT layoutlimits
    {MinWidth}	minwidth	:UINT
    {MinHeight}	minheight	:UINT
    {MaxWidth}	maxwidth	:UINT
    {MaxHeight}	maxheight	:UINT
ENDOBJECT

/****************************************************************************/

NATIVE {LM_ADDCHILD} CONST LM_ADDCHILD = ($540001)

NATIVE {lmAddChild} OBJECT lmaddchild
    {MethodID}	methodid	:ULONG
    {lm_Window}	window	:PTR TO window      -> Window pointer (may be NULL)
    {lm_Object}	object	:PTR TO INTUIOBJECT      -> Gadget object
    {lm_ObjectAttrs}	objectattrs	:ARRAY OF tagitem -> CHILD_#? tag list (may be NULL)
ENDOBJECT

/****************************************************************************/

NATIVE {LM_ADDIMAGE} CONST LM_ADDIMAGE = ($540002)

NATIVE {lmAddImage} OBJECT lmaddimage
    {MethodID}	methodid	:ULONG
    {lm_Window}	window	:PTR TO window      -> Window pointer (may be NULL)
    {lm_Object}	object	:PTR TO INTUIOBJECT      -> Image object
    {lm_ObjectAttrs}	objectattrs	:ARRAY OF tagitem -> CHILD_#? tag list (may be NULL)
ENDOBJECT

/****************************************************************************/

NATIVE {LM_REMOVECHILD} CONST LM_REMOVECHILD = ($540003)

NATIVE {lmRemoveChild} OBJECT lmremovechild
    {MethodID}	methodid	:ULONG
    {lm_Window}	window	:PTR TO window   -> Window pointer (may be NULL)
    {lm_Object}	object	:PTR TO INTUIOBJECT   -> Object to remove and dispose
ENDOBJECT

/****************************************************************************/

NATIVE {LM_MODIFYCHILD} CONST LM_MODIFYCHILD = ($540004)

NATIVE {lmModifyChild} OBJECT lmmodifychild
    {MethodID}	methodid	:ULONG
    {lm_Window}	window	:PTR TO window      -> Window pointer (may be NULL)
    {lm_Object}	object	:PTR TO INTUIOBJECT      -> Object to modify
    {lm_ObjectAttrs}	objectattrs	:ARRAY OF tagitem -> CHILD_#? tag list (may be NULL)
ENDOBJECT

/*****************************************************************************/

NATIVE {LAYOUT_Dummy}          CONST LAYOUT_DUMMY          = (REACTION_DUMMY+$7000)

NATIVE {LAYOUT_Orientation}    CONST LAYOUT_ORIENTATION    = (LAYOUT_DUMMY+1)
    /* (ULONG) Orientation of group, LAYOUT_ORIENT_HORIZ or
       LAYOUT_ORIENT_VERT.  Defaults to LAYOUT_ORIENT_HORIZ. */

NATIVE {LAYOUT_FixedHoriz}     CONST LAYOUT_FIXEDHORIZ     = (LAYOUT_DUMMY+2)
NATIVE {LAYOUT_FixedVert}      CONST LAYOUT_FIXEDVERT      = (LAYOUT_DUMMY+3)
    /* (BOOL) TRUE for fixed-size group, false to force that direction to
       its smallest possible size. */

NATIVE {LAYOUT_HorizAlignment} CONST LAYOUT_HORIZALIGNMENT = (LAYOUT_DUMMY+4)
    /* (ULONG) Align to left, right, or center of group space, defaults to
       LAYOUT_ALIGN_LEFT. */

NATIVE {LAYOUT_VertAlignment}  CONST LAYOUT_VERTALIGNMENT  = (LAYOUT_DUMMY+5)
    /* (ULONG) Align to top, bottom, or center of group space, defaults to
       LAYOUT_ALIGN_TOP. */

NATIVE {LAYOUT_ShrinkWrap}     CONST LAYOUT_SHRINKWRAP     = (LAYOUT_DUMMY+6)
    /* (BOOL) Shrink out all extra space between gadgets. Default FALSE. */

NATIVE {LAYOUT_EvenSize}       CONST LAYOUT_EVENSIZE       = (LAYOUT_DUMMY+7)
    /* (BOOL) Use the minimum size of the largest child for all children.
       Default FALSE. */

NATIVE {LAYOUT_InnerSpacing}   CONST LAYOUT_INNERSPACING   = (LAYOUT_DUMMY+9)
    /* (ULONG) Spacing between objects. Defaults to INTERSPACING. */

NATIVE {LAYOUT_HorizSpacing}   CONST LAYOUT_HORIZSPACING   = LAYOUT_INNERSPACING    /* OBSOLETE */
NATIVE {LAYOUT_VertSpacing}    CONST LAYOUT_VERTSPACING    = LAYOUT_INNERSPACING

NATIVE {INTERSPACING}          CONST INTERSPACING          = 4        /* virtual pixels */
NATIVE {INTERSPACE}            CONST INTERSPACE            = INTERSPACING

NATIVE {LAYOUT_TopSpacing}     CONST LAYOUT_TOPSPACING     = (LAYOUT_DUMMY+10)
    /* (ULONG) The minimum space between the top of the group, and the top
       of the objects inside it. */

NATIVE {LAYOUT_BottomSpacing}  CONST LAYOUT_BOTTOMSPACING  = (LAYOUT_DUMMY+11)
    /* (ULONG) The minimum space between the bottom of the group, and the
       bottom of the objects inside it. */

NATIVE {LAYOUT_LeftSpacing}    CONST LAYOUT_LEFTSPACING    = (LAYOUT_DUMMY+12)
    /* (ULONG) The minimum space between the left side of the group, and
       the left side of the objects inside it. */

NATIVE {LAYOUT_RightSpacing}   CONST LAYOUT_RIGHTSPACING   = (LAYOUT_DUMMY+13)
    /* (ULONG) The minimum space between the right side of the group, and
       the right side of the object inside it. */

NATIVE {LAYOUT_BevelState}     CONST LAYOUT_BEVELSTATE     = (LAYOUT_DUMMY+14)
    /* (ULONG) Either IDS_SELECTED for recessed, or IDS_NORMAL for raised. */

NATIVE {LAYOUT_BevelStyle}     CONST LAYOUT_BEVELSTYLE     = (LAYOUT_DUMMY+15)
    /* (ULONG) See images/bevel.h */

NATIVE {LAYOUT_Label}          CONST LAYOUT_LABEL          = (LAYOUT_DUMMY+16)
    /* (UBYTE *) The bevel label, as specified by a text string. */

NATIVE {LAYOUT_LabelImage}     CONST LAYOUT_LABELIMAGE     = (LAYOUT_DUMMY+17)
    /* (struct Image *) The bevel label, as specified by an Image. */

NATIVE {LAYOUT_LabelPlace}     CONST LAYOUT_LABELPLACE     = (LAYOUT_DUMMY+18)
    /* (ULONG) Where to put the label: BVJ_TOP_CENTER, BVJ_TOP_LEFT,
       BVJ_TOP_RIGHT, BVJ_IN_CENTER, BVJ_IN_LEFT, BVJ_IN_RIGHT */

/* The child functions.
 * After one of these functions is called, any CHILD_ tag may be used; it
 * will apply to whichever gadget was the last gadget to be altered by
 * AddGadget/ModifyChild.
 */
NATIVE {LAYOUT_RemoveChild}    CONST LAYOUT_REMOVECHILD    = (LAYOUT_DUMMY+19)
    /* (Object *) The BOOPSI gadget to be removed.  This will destroy the
       object, as well. */

NATIVE {LAYOUT_AddChild}       CONST LAYOUT_ADDCHILD       = (LAYOUT_DUMMY+20)
    /* (Object *) The BOOPSI gadget to be added. */

NATIVE {LAYOUT_AddImage}       CONST LAYOUT_ADDIMAGE       = (LAYOUT_DUMMY+21)
    /* (Object *) like LAYOUT_AddChild, except for images instead of
       gadgets. */

NATIVE {LAYOUT_ModifyChild}    CONST LAYOUT_MODIFYCHILD    = (LAYOUT_DUMMY+22)
    /* (Object *) The BOOPSI gadget to be modified. */

/* The following two tags, together with GA_ID, are sent in a notification
 * message when a gadget informs of a release verify.
 */
NATIVE {LAYOUT_RelVerify}      CONST LAYOUT_RELVERIFY      = (LAYOUT_DUMMY+23)
    /* (BOOL) Gadget release verify notification tag */

NATIVE {LAYOUT_RelCode}        CONST LAYOUT_RELCODE        = (LAYOUT_DUMMY+24)
    /* (UWORD) Copy of the IntuiMessage.Code from the release verify */

NATIVE {LAYOUT_Parent}         CONST LAYOUT_PARENT         = (LAYOUT_DUMMY+25)
    /* (Object *) Set the parent layout of a sublayout. Layout will set this
       automatically for all children (thus any object added to a layout
       hierarchy will receive this tag in OM_SET). */

NATIVE {LAYOUT_DeferLayout}    CONST LAYOUT_DEFERLAYOUT    = (LAYOUT_DUMMY+26)
    /* (BOOL) Setting this tag for a top layout will make it defer GM_LAYOUT
       and GM_RENDER from input.device context and request the application to
       do them. */

NATIVE {LAYOUT_RequestLayout}  CONST LAYOUT_REQUESTLAYOUT  = (LAYOUT_DUMMY+27)
    /* (Object *) When this tag is received in OM_UPDATE or IDCMP_IDCMPUPDATE,
       the layout instance in question should be relayouted with the GM_LAYOUT
       method (or by calling RethinkLayout).  Setting LAYOUT_DeferLayout will
       make these notifications appear. */

NATIVE {LAYOUT_RequestRefresh} CONST LAYOUT_REQUESTREFRESH = (LAYOUT_DUMMY+28)
    /* (Object *) When this tag is received in OM_UPDATE or IDCMP_IDCMPUPDATE,
       the layout instance in question should be refreshed with the GM_RENDER
       method (or by calling RefreshGList).  Setting LAYOUT_DeferLayout will
       make these notifications appear. */

NATIVE {LAYOUT_TextPen}        CONST LAYOUT_TEXTPEN        = (LAYOUT_DUMMY+29)
    /* (WORD) Optional text pen color for group label */

NATIVE {LAYOUT_FillPen}        CONST LAYOUT_FILLPEN        = (LAYOUT_DUMMY+30)
    /* (WORD) Optional backfill pen color */

NATIVE {LAYOUT_FillPattern}    CONST LAYOUT_FILLPATTERN    = (LAYOUT_DUMMY+31)
    /* (UWORD *) Optional backfill pattern */

NATIVE {LAYOUT_PageBackFill}   CONST LAYOUT_PAGEBACKFILL   = (LAYOUT_DUMMY+32)
    /* (struct Hook *) !PRIVATE! backfill hook */

NATIVE {LAYOUT_BackFill}       CONST LAYOUT_BACKFILL       = GA_BACKFILL
    /* (struct Hook *) Optional backfill hook. This supercedes the backfill
       coming from window.class and is only used for this layout instance,
       i.e. it isn't propagated to its children. To change the backfill of
       a whole layout tree, use LAYOUT_LayoutBackFill. You can pass the value
       ~0L to tell the layout to use the window.class backfill again. */

NATIVE {LAYOUT_TabVerify}      CONST LAYOUT_TABVERIFY      = (LAYOUT_DUMMY+33)
    /* (BOOL) TRUE if this release verify was triggered with tabcycling and
       another gadget has been activated */

NATIVE {LAYOUT_LabelColumn}    CONST LAYOUT_LABELCOLUMN    = (LAYOUT_DUMMY+34)
    /* (ULONG) LABELTEXT_LEFT or LABELTEXT_RIGHT, the side where object
       labels are placed in a vertical group. */

NATIVE {LAYOUT_LabelWidth}     CONST LAYOUT_LABELWIDTH     = (LAYOUT_DUMMY+35)
    /* (ULONG) Width of the the gadget label column. This attribute
       can be used to justify several layout groups. */

NATIVE {LAYOUT_AlignLabels}    CONST LAYOUT_ALIGNLABELS    = (LAYOUT_DUMMY+36)
    /* (Object *) Pointer to another layout object this group should
       align labels width. Set a cyclic pointer between all the objects
       and they will automatically make their label columns the same
       width. These tags should be set as soon as possible, preferably
       during OM_NEW (One will have to be set afterwards). */

NATIVE {LAYOUT_SpaceInner}     CONST LAYOUT_SPACEINNER     = (LAYOUT_DUMMY+37)
NATIVE {LAYOUT_SpaceOuter}     CONST LAYOUT_SPACEOUTER     = (LAYOUT_DUMMY+38)
    /* (BOOL) Whether or not this group should have space around/between
       objects. For normal layouts, you should use these tags instead
       of the direct-control LAYOUT_Top/Bottom/Right/Left/InnerSpacing,
       since these can be automatically adjusted to the resolution
       for you. */

NATIVE {LAYOUT_RelAddress}     CONST LAYOUT_RELADDRESS     = (LAYOUT_DUMMY+39)
    /* (struct Gadget *) The address of the gadget that sent a release
       verify. */

NATIVE {LAYOUT_HelpHit}        CONST LAYOUT_HELPHIT        = (LAYOUT_DUMMY+40)
    /* (UWORD) HelpTest return code. */

NATIVE {LAYOUT_HelpGadget}     CONST LAYOUT_HELPGADGET     = (LAYOUT_DUMMY+41)
    /* (struct Gadget *) HelpTest gadget pointer notified with HelpHit! (V44)
       (OM_NOTIFY) */

NATIVE {LAYOUT_DisposeLabels}  CONST LAYOUT_DISPOSELABELS  = (LAYOUT_DUMMY) /* Was +41!! */
    /* (BOOL) Dispose Labels on exit (OBSOLETE!)
       (OM_SET/OM_UPDATE) */

NATIVE {LAYOUT_Inverted}       CONST LAYOUT_INVERTED       = (LAYOUT_DUMMY+42)
    /* (BOOL) Add group children via AddHead() rather than AddTail()
       A very simple means to flip a layout group placement (42.25+)
       Its also highly useful for dynamic layout, inserting the
       child on the head, or tail (left/right, top/bottom). Changing
       this tag only effects children added afterward. */

NATIVE {LAYOUT_WeightBar}      CONST LAYOUT_WEIGHTBAR      = (LAYOUT_DUMMY+43)
    /* (BOOL) Place a user adjustable weighting bar here (ie; balance group
       bar) ClassAct 2.1 - V43.1 */

NATIVE {LAYOUT_NoLayout}       CONST LAYOUT_NOLAYOUT       = (LAYOUT_DUMMY+44) /* V45 */
    /* (BOOL) Do not layout the children. All children must have valid
       coordinates. Don't use weight bars (LAYOUT_WeightBar). */

NATIVE {LAYOUT_LayoutBackFill} CONST LAYOUT_LAYOUTBACKFILL = (LAYOUT_DUMMY+45) /* V50 */
    /* (struct Hook *) Backfill hook which is always propagated to all the
       layout children, and supercedes the backfill coming from window.class.
       This can be useful to change the backfill pattern of an entire
       layout tree at once. If you do this, make sure you set this
       attribute AFTER all children have already been added to the layout
       (usage at OM_NEW time is okay, as long as the tag comes after any
       LAYOUT_AddChild/LAYOUT_AddImage). */

NATIVE {LAYOUT_LayoutMagic}    CONST LAYOUT_LAYOUTMAGIC    = (LAYOUT_DUMMY+46) /* V50 - PRIVATE !!! */

NATIVE {LAYOUT_CharSet}        CONST LAYOUT_CHARSET        = (LAYOUT_DUMMY+47) /* V51 */
    /* (ULONG) The character set the layout group and all its members should
       display their text in, regardless of the particular font used. If zero,
       no character set will be explicitly enforced. Defaults to zero. */

NATIVE {LAYOUT_Immediate}      CONST LAYOUT_IMMEDIATE      = (LAYOUT_DUMMY+48) /* V53.21 */
    /* (BOOL) Gadget down notification tag. */

/* Child tags! */
NATIVE {CHILD_Dummy}           CONST CHILD_DUMMY           = (LAYOUT_DUMMY+$100)

NATIVE {CHILD_MinWidth}        CONST CHILD_MINWIDTH        = (CHILD_DUMMY+1)
    /* (ULONG) The minimum width, in pixels, of the object.  Leave blank if
       you want the minimum size to be calced by the gadget as the smallest
       possible, or use ~0.  Defaults to ~0. */

NATIVE {CHILD_MinHeight}       CONST CHILD_MINHEIGHT       = (CHILD_DUMMY+2)
    /* (ULONG) The minimum height, in pixels, of the object.  Leave blank if
       you want the minimum size to be calced by the gadget as the smallest
       possible, or use ~0.  Defaults to ~0. */

NATIVE {CHILD_NominalSize}     CONST CHILD_NOMINALSIZE     = (CHILD_DUMMY+11)
    /* (BOOL) Use GDOMAIN_NOMINAL instead of GDOMAIN_MINIMUM to request
       minimum size.  Defaults to FALSE. */

NATIVE {CHILD_MaxWidth}        CONST CHILD_MAXWIDTH        = (CHILD_DUMMY+3)
    /* (ULONG) The maximum width, in pixels, of the object.  Leave blank if
       you want the maximum size to be calced by the gadget as the largest
       possible, or use ~0. */

NATIVE {CHILD_MaxHeight}       CONST CHILD_MAXHEIGHT       = (CHILD_DUMMY+4)
    /* (ULONG) The maximum height, in pixels, of the object.  Leave blank if
       you want the maximum size to be calced by the gadget as the smallest
       possible, or use ~0. */

NATIVE {CHILD_WeightedWidth}   CONST CHILD_WEIGHTEDWIDTH   = (CHILD_DUMMY+5)
    /* (ULONG) See CHILD_WeightedHeight. */

NATIVE {CHILD_WeightedHeight}  CONST CHILD_WEIGHTEDHEIGHT  = (CHILD_DUMMY+6)
    /* (ULONG) The weighted width or height is a number between 0 and 100;
       it determines how much space, in relation to the other objects in the
       group, this particular object should be allowed.  When the width/height
       for the group is calculated, the allowable space is divided up between
       the gadgets based on this, and the min/max values.  For instance, if
       you had two objects, one with a weight of 100 and another with a weight
       of 50, and the group was 150 pixels wide, 100 would be offered to the
       first, and 50 to the second; how much space it actually takes depends
       on whether that particular value exceeds the maximum, the minimum, or
       the gadget's internal calculations of its minimum or maximum possible
       width or height.  Both CHILD_WeightedWidth and CHILD_WeightedHeight
       default to 100.  A value of 0 locks it at the CHILD_MinWidth or
       CHILD_MinHeight value, respectively. */

NATIVE {CHILD_ReplaceObject}   CONST CHILD_REPLACEOBJECT   = (CHILD_DUMMY+7)
    /* (Object *) The BOOPSI gadget to replace the object with.  The original
       object is destroyed. */

NATIVE {CHILD_ReplaceImage}    CONST CHILD_REPLACEIMAGE    = (LAYOUT_DUMMY+8)
    /* (Object *) Like CHILD_ReplaceObject, except the replacement object is
       an image, not a gadget. */

NATIVE {CHILD_CacheDomain}     CONST CHILD_CACHEDOMAIN     = (CHILD_DUMMY+9)
    /* (BOOL) Whether GM_DOMAIN results can be cached to improve performance.
       Set this to FALSE if you use weird gadgets that can change size on
       their own. Defaults to TRUE. */

NATIVE {CHILD_WeightMinimum}   CONST CHILD_WEIGHTMINIMUM   = (CHILD_DUMMY+10)
    /* (BOOL) Makes layout set the weighted size to the values returned by
       minimum GM_DOMAIN. */

NATIVE {CHILD_Label}           CONST CHILD_LABEL           = (CHILD_DUMMY+12)
    /* (Object *) A label.image to use as the label for this gadget */

NATIVE {CHILD_NoDispose}       CONST CHILD_NODISPOSE       = (CHILD_DUMMY+13)
    /* (BOOL) Set this to true if you don't want layout to automatically
       dispose the object. */

NATIVE {CHILD_ScaleHeight}     CONST CHILD_SCALEHEIGHT     = (CHILD_DUMMY+14)
    /* (UWORD) Scales min domain size larger by this percentage
       (0 thru 100). */

NATIVE {CHILD_ScaleWidth}      CONST CHILD_SCALEWIDTH      = (CHILD_DUMMY+15)
    /* (UWORD See CHILD_ScaleHeight. */

NATIVE {CHILD_DataType}        CONST CHILD_DATATYPE        = (CHILD_DUMMY+16)
    /* (BOOL) This is a datatype, layout will use DTM_PROCLAYOUT,
       SetDTAttrs and RefreshDTObject so waiting for DTA_Sync is not
       required. (V43 BETA) */

/*****************************************************************************/

/* Special "empty label" value for CHILD_Label */
NATIVE {LCLABEL_NOLABEL}     CONST LCLABEL_NOLABEL     = 1!!VALUE!!PTR TO /*Object*/ ULONG

/* Possible values for LAYOUT_Orientation. */
NATIVE {LAYOUT_HORIZONTAL}   CONST LAYOUT_HORIZONTAL   = 0
NATIVE {LAYOUT_VERTICAL}     CONST LAYOUT_VERTICAL     = 1

NATIVE {LAYOUT_ORIENT_HORIZ} CONST LAYOUT_ORIENT_HORIZ = LAYOUT_HORIZONTAL
NATIVE {LAYOUT_ORIENT_VERT}  CONST LAYOUT_ORIENT_VERT  = LAYOUT_VERTICAL

/* Possible values for LAYOUT_HorizAlignment. */
NATIVE {LALIGN_LEFT}         CONST LALIGN_LEFT         = 0
NATIVE {LALIGN_RIGHT}        CONST LALIGN_RIGHT        = 1
NATIVE {LALIGN_CENTER}       CONST LALIGN_CENTER       = 2
NATIVE {LALIGN_CENTRE}       CONST LALIGN_CENTRE       = LALIGN_CENTER

NATIVE {LAYOUT_ALIGN_LEFT}   CONST LAYOUT_ALIGN_LEFT   = LALIGN_LEFT
NATIVE {LAYOUT_ALIGN_RIGHT}  CONST LAYOUT_ALIGN_RIGHT  = LALIGN_RIGHT
NATIVE {LAYOUT_ALIGN_CENTER} CONST LAYOUT_ALIGN_CENTER = LALIGN_CENTER

/* Possible values for LAYOUT_VertAlignment. */
NATIVE {LALIGN_TOP}          CONST LALIGN_TOP          = 0
NATIVE {LALIGN_BOTTOM}       CONST LALIGN_BOTTOM       = 1
->NATIVE {LALIGN_CENTER}       CONST LALIGN_CENTER       = 2
->NATIVE {LALIGN_CENTRE}       CONST LALIGN_CENTRE       = LALIGN_CENTER

NATIVE {LAYOUT_ALIGN_TOP}    CONST LAYOUT_ALIGN_TOP    = LALIGN_TOP
NATIVE {LAYOUT_ALIGN_BOTTOM} CONST LAYOUT_ALIGN_BOTTOM = LALIGN_BOTTOM
->NATIVE {LAYOUT_ALIGN_CENTER} CONST LAYOUT_ALIGN_CENTER = LALIGN_CENTER

/*****************************************************************************/

/* Page Class tags  */

NATIVE {PAGE_Dummy}       CONST PAGE_DUMMY       = (LAYOUT_DUMMY+$200)

NATIVE {PAGE_Add}         CONST PAGE_ADD         = (PAGE_DUMMY+1)
    /* (Object *) Add a page to the end of a page group */

NATIVE {PAGE_Remove}      CONST PAGE_REMOVE      = (PAGE_DUMMY+2)
    /* (Object *) Remove a page from the page group */

NATIVE {PAGE_Current}     CONST PAGE_CURRENT     = (PAGE_DUMMY+3)
    /* (ULONG) Make the n'th page visible. */

NATIVE {PAGE_FixedVert}   CONST PAGE_FIXEDVERT   = (PAGE_DUMMY+4)
NATIVE {PAGE_FixedHoriz}  CONST PAGE_FIXEDHORIZ  = (PAGE_DUMMY+5)
    /* (BOOL) Like the Layout class tags. */

NATIVE {PAGE_Transparent} CONST PAGE_TRANSPARENT = (PAGE_DUMMY+6)
    /* (BOOL) PRIVATE */
