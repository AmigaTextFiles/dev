{ Intuition.i }


{$I   "Include:Exec/Types.i"}
{$I   "Include:Graphics/Gfx.i"}
{$I   "Include:Graphics/Clip.i"}
{$I   "Include:Graphics/View.i"}
{$I   "Include:Graphics/RastPort.i"}
{$I   "Include:Graphics/Layers.i"}
{$I   "Include:Graphics/Text.i"}
{$I   "Include:Exec/Ports.i"}
{$I   "Include:Devices/InputEvent.i"}
{$I   "Include:Utility/TagItem.i"}
{
 * NOTE:  intuition/iobsolete.h is included at the END of this file!
 }

{ ======================================================================== }
{ === IntuiText ========================================================== }
{ ================================= ======================================= }
{ IntuiText is a series of strings that start with a screen location
 *  (always relative to the upper-left corner of something) and then the
 *  text of the string.  The text is null-terminated.
 }
Type
    IntuiText = record
        FrontPen,
        BackPen         : Byte;         { the pen numbers for the rendering }
        DrawMode        : Byte;         { the mode for rendering the text }
        LeftEdge        : Short;        { relative start location for the text }
        TopEdge         : Short;        { relative start location for the text }
        ITextFont       : TextAttrPtr;  { if NULL, you accept the default }
        IText           : String;       { pointer to null-terminated text }
        NextText        : ^IntuiText;   { continuation to TxWrite another text }
    end;
    IntuiTextPtr = ^IntuiText;



{ ======================================================================== }
{ === Border ============================================================= }
{ ======================================================================== }
{ Data type Border, used for drawing a series of lines which is intended for
 *  use as a border drawing, but which may, in fact, be used to render any
 *  arbitrary vector shape.
 *  The routine DrawBorder sets up the RastPort with the appropriate
 *  variables, then does a Move to the first coordinate, then does Draws
 *  to the subsequent coordinates.
 *  After all the Draws are done, if NextBorder is non-zero we call DrawBorder
 *  recursively
 }
Type
    Border = record
        LeftEdge,
        TopEdge         : Short;        { initial offsets from the origin }
        FrontPen,
        BackPen         : Byte;         { pens numbers for rendering }
        DrawMode        : Byte;         { mode for rendering }
        Count           : Byte;         { number of XY pairs }
        XY              : Address;      { vector coordinate pairs rel to LeftTop}
        NextBorder      : ^Border;      { pointer to any other Border too }
    end;
    BorderPtr = ^Border;




Type

{ ======================================================================== }
{ === MenuItem =========================================================== }
{ ======================================================================== }

Type

    MenuItem = record
        NextItem        : ^MenuItem;    { pointer to next in chained list }
        LeftEdge,
        TopEdge         : Short;        { position of the select box }
        Width,
        Height          : Short;        { dimensions of the select box }
        Flags           : Short;        { see the defines below }

        MutualExclude   : Integer;      { set bits mean this item excludes that }

        ItemFill        : Address;      { points to Image, IntuiText, or NULL }

    { when this item is pointed to by the cursor and the items highlight
     *  mode HIGHIMAGE is selected, this alternate image will be displayed
     }

        SelectFill      : Address;      { points to Image, IntuiText, or NULL }

        Command         : Char;         { only if appliprog sets the COMMSEQ flag }

        SubItem         : ^MenuItem;    { if non-zero, DrawMenu shows "->" }

    { The NextSelect field represents the menu number of next selected
     *  item (when user has drag-selected several items)
     }

        NextSelect      : Short;
    end;
    MenuItemPtr = ^MenuItem;


Const

{ FLAGS SET BY THE APPLIPROG }
    CHECKIT     = $0001;        { whether to check this item if selected }
    ITEMTEXT    = $0002;        { set if textual, clear if graphical item }
    COMMSEQ     = $0004;        { set if there's an command sequence }
    MENUTOGGLE  = $0008;        { set to toggle the check of a menu item }
    ITEMENABLED = $0010;        { set if this item is enabled }

{ these are the SPECIAL HIGHLIGHT FLAG state meanings }
    HIGHFLAGS   = $00C0;        { see definitions below for these bits }
    HIGHIMAGE   = $0000;        { use the user's "select image" }
    HIGHCOMP    = $0040;        { highlight by complementing the selectbox }
    HIGHBOX     = $0080;        { highlight by "boxing" the selectbox }
    HIGHNONE    = $00C0;        { don't highlight }

{ FLAGS SET BY BOTH APPLIPROG AND INTUITION }
    CHECKED     = $0100;        { if CHECKIT, then set this when selected }

{ FLAGS SET BY INTUITION }
    ISDRAWN     = $1000;        { this item's subs are currently drawn }
    HIGHITEM    = $2000;        { this item is currently highlighted }
    MENUTOGGLED = $4000;        { this item was already toggled }


{ ======================================================================== }
{ === Menu =============================================================== }
{ ======================================================================== }
Type

    Menu = record
        NextMenu        : ^Menu;        { same level }
        LeftEdge,
        TopEdge         : Short;        { position of the select box }
        Width,
        Height          : Short;        { dimensions of the select box }
        Flags           : Short;        { see flag definitions below }
        MenuName        : String;       { text for this Menu Header }
        FirstItem       : MenuItemPtr;  { pointer to first in chain }

    { these mysteriously-named variables are for internal use only }

        JazzX,
        JazzY,
        BeatX,
        BeatY           : Short;
    end;
    MenuPtr = ^Menu;

CONST
{ FLAGS SET BY BOTH THE APPLIPROG AND INTUITION }
    MENUENABLED = $0001;        { whether or not this menu is enabled }

{ FLAGS SET BY INTUITION }
    MIDRAWN     = $0100;        { this menu's items are currently drawn }




{ ======================================================================== }
{ === Gadget ============================================================= }
{ ======================================================================== }

Type

    Gadget = record
        NextGadget      : ^Gadget;      { next gadget in the list }

        LeftEdge,
        TopEdge         : Short;        { "hit box" of gadget }
        Width,
        Height          : Short;        { "hit box" of gadget }

        Flags           : Short;        { see below for list of defines }

        Activation      : Short;        { see below for list of defines }

        GadgetType      : Short;        { see below for defines }

    { appliprog can specify that the Gadget be rendered as either as Border
     * or an Image.  This variable points to which (or equals NULL if there's
     * nothing to be rendered about this Gadget)
     }

        GadgetRender    : Address;

    { appliprog can specify "highlighted" imagery rather than algorithmic
     * this can point to either Border or Image data
     }

        SelectRender    : Address;

        GadgetText      : IntuiTextPtr; { text for this gadget }

    { by using the MutualExclude word, the appliprog can describe
     * which gadgets mutually-exclude which other ones.  The bits
     * in MutualExclude correspond to the gadgets in object containing
     * the gadget list.  If this gadget is selected and a bit is set
     * in this gadget's MutualExclude and the gadget corresponding to
     * that bit is currently selected (e.g. bit 2 set and gadget 2
     * is currently selected) that gadget must be unselected.
     * Intuition does the visual unselecting (with checkmarks) and
     * leaves it up to the program to unselect internally
     }

        MutualExclude   : Integer;      { set bits mean this gadget excludes that gadget }

    { pointer to a structure of special data required by Proportional,
     * String and Integer Gadgets
     }

        SpecialInfo     : Address;

        GadgetID        : Short;        { user-definable ID field }
        UserData        : Address;      { ptr to general purpose User data (ignored by In) }
    end;
    GadgetPtr = ^Gadget;

 ExtGadget = Record
    { The first fields match struct Gadget exactly }
    NextGadget     : ^ExtGadget;  { Matches struct Gadget }
    LeftEdge, TopEdge,            { Matches struct Gadget }
    Width, Height,                { Matches struct Gadget }
    Flags,                        { Matches struct Gadget }
    Activation,                   { Matches struct Gadget }
    GadgetType     : WORD;        { Matches struct Gadget }
    GadgetRender,                 { Matches struct Gadget }
    SelectRender   : Address;     { Matches struct Gadget }
    GadgetText     : IntuiTextPtr;{ Matches struct Gadget }
    MutualExclude  : Integer;     { Matches struct Gadget }
    SpecialInfo    : Address;     { Matches struct Gadget }
    GadgetID       : WORD;        { Matches struct Gadget }
    UserData       : Address;     { Matches struct Gadget }

    { These fields only exist under V39 and only if GFLG_EXTENDED is set }
    MoreFlags      : Integer;   { see GMORE_ flags below }
    BoundsLeftEdge,             { Bounding extent for gadget, valid   }
    BoundsTopEdge,              { only if GMORE_BOUNDS is set.  The   }
    BoundsWidth,                { GFLG_RELxxx flags affect these      }
    BoundsHeight   : WORD;      { coordinates as well.        }
 end;
 ExtGadgetPtr = ^ExtGadget;


CONST
{ --- Gadget.Flags values      --- }
{ combinations in these bits describe the highlight technique to be used }
 GFLG_GADGHIGHBITS  = $0003;
 GFLG_GADGHCOMP     = $0000;  { Complement the select box }
 GFLG_GADGHBOX      = $0001;  { Draw a box around the image }
 GFLG_GADGHIMAGE    = $0002;  { Blast in this alternate image }
 GFLG_GADGHNONE     = $0003;  { don't highlight }

 GFLG_GADGIMAGE     = $0004;  { set IF GadgetRender AND SelectRender
                                   * point to an Image structure, clear
                                   * if they point to Border structures
                                   }

{ combinations in these next two bits specify to which corner the gadget's
 *  Left & Top coordinates are relative.  If relative to Top/Left,
 *  these are "normal" coordinates (everything is relative to something in
 *  this universe).
 *
 * Gadget positions and dimensions are relative to the window or
 * requester which contains the gadget
 }
 GFLG_RELBOTTOM   = $0008;  { vert. pos. is relative to bottom edge }
 GFLG_RELRIGHT    = $0010;  { horiz. pos. is relative to right edge }
 GFLG_RELWIDTH    = $0020;  { width is relative to req/window    }
 GFLG_RELHEIGHT   = $0040;  { height is relative to req/window   }

{ New for V39: GFLG_RELSPECIAL allows custom gadget implementors to
 * make gadgets whose position and size depend in an arbitrary way
 * on their window's dimensions.  The GM_LAYOUT method will be invoked
 * for such a gadget (or any other GREL_xxx gadget) at suitable times,
 * such as when the window opens or the window's size changes.
 }
 GFLG_RELSPECIAL  = $4000;  { custom gadget has special relativity.
                                   * Gadget box values are absolutes, but
                                   * can be changed via the GM_LAYOUT method.
                                   }

 GFLG_SELECTED    = $0080;  { you may initialize AND look at this        }

{ the GFLG_DISABLED flag is initialized by you and later set by Intuition
 * according to your calls to On/OffGadget().  It specifies whether or not
 * this Gadget is currently disabled from being selected
 }
 GFLG_DISABLED    = $0100;

{ These flags specify the type of text field that Gadget.GadgetText
 * points to.  In all normal (pre-V36) gadgets which you initialize
 * this field should always be zero.  Some types of gadget objects
 * created from classes will use these fields to keep track of
 * types of labels/contents that different from IntuiText, but are
 * stashed in GadgetText.
 }

 GFLG_LABELMASK   = $3000;
 GFLG_LABELITEXT  = $0000;  { GadgetText points to IntuiText     }
 GFLG_LABELSTRING = $1000;  { GadgetText points to (UBYTE *)     }
 GFLG_LABELIMAGE  = $2000;  { GadgetText points to Image (object)        }

{ New for V37: GFLG_TABCYCLE }
 GFLG_TABCYCLE    = $0200;  { (string OR custom) gadget participates in
                                   * cycling activation with Tab or Shift-Tab
                                   }
{ New for V37: GFLG_STRINGEXTEND.  We discovered that V34 doesn't properly
 * ignore the value we had chosen for the Gadget->Activation flag
 * GACT_STRINGEXTEND.  NEVER SET THAT FLAG WHEN RUNNING UNDER V34.
 * The Gadget->Flags bit GFLG_STRINGEXTEND is provided as a synonym which is
 * safe under V34, and equivalent to GACT_STRINGEXTEND under V37.
 * (Note that the two flags are not numerically equal)
 }
 GFLG_STRINGEXTEND = $0400;  { this String Gadget has StringExtend        }

{ New for V39: GFLG_IMAGEDISABLE.  This flag is automatically set if
 * the custom image of this gadget knows how to do disabled rendering
 * (more specifically, if its IA_SupportsDisable attribute is TRUE).
 * Intuition uses this to defer the ghosting to the image-class,
 * instead of doing it itself (the old compatible way).
 * Do not set this flag yourself - Intuition will do it for you.
 }

 GFLG_IMAGEDISABLE = $0800;  { Gadget's image knows how to do disabled
                                   * rendering
                                   }

{ New for V39:  If set, this bit means that the Gadget is actually
 * a struct ExtGadget, with new fields and flags.  All V39 boopsi
 * gadgets are ExtGadgets.  Never ever attempt to read the extended
 * fields of a gadget if this flag is not set.
 }
 GFLG_EXTENDED    = $8000;  { Gadget is extended }

{ ---  Gadget.Activation flag values   --- }
{ Set GACT_RELVERIFY if you want to verify that the pointer was still over
 * the gadget when the select button was released.  Will cause
 * an IDCMP_GADGETUP message to be sent if so.
 }
 GACT_RELVERIFY    = $0001;

{ the flag GACT_IMMEDIATE, when set, informs the caller that the gadget
 *  was activated when it was activated.  This flag works in conjunction with
 *  the GACT_RELVERIFY flag
 }
 GACT_IMMEDIATE    = $0002;

{ the flag GACT_ENDGADGET, when set, tells the system that this gadget,
 * when selected, causes the Requester to be ended.  Requesters
 * that are ended are erased and unlinked from the system.
 }
 GACT_ENDGADGET    = $0004;

{ the GACT_FOLLOWMOUSE flag, when set, specifies that you want to receive
 * reports on mouse movements while this gadget is active.
 * You probably want to set the GACT_IMMEDIATE flag when using
 * GACT_FOLLOWMOUSE, since that's the only reasonable way you have of
 * learning why Intuition is suddenly sending you a stream of mouse
 * movement events.  If you don't set GACT_RELVERIFY, you'll get at
 * least one Mouse Position event.
 }
 GACT_FOLLOWMOUSE = $0008;

{ if any of the BORDER flags are set in a Gadget that's included in the
 * Gadget list when a Window is opened, the corresponding Border will
 * be adjusted to make room for the Gadget
 }
 GACT_RIGHTBORDER = $0010;
 GACT_LEFTBORDER  = $0020;
 GACT_TOPBORDER   = $0040;
 GACT_BOTTOMBORDER= $0080;
 GACT_BORDERSNIFF = $8000;  { neither set nor rely on this bit   }

 GACT_TOGGLESELECT= $0100;  { this bit for toggle-select mode }
 GACT_BOOLEXTEND  = $2000;  { this Boolean Gadget has a BoolInfo }

{ should properly be in StringInfo, but aren't }
 GACT_STRINGLEFT  = $0000;  { NOTE WELL: that this has value zero        }
 GACT_STRINGCENTER= $0200;
 GACT_STRINGRIGHT = $0400;
 GACT_LONGINT     = $0800;  { this String Gadget is for Long Ints        }
 GACT_ALTKEYMAP   = $1000;  { this String has an alternate keymap        }
 GACT_STRINGEXTEND= $2000;  { this String Gadget has StringExtend        }
                                  { NOTE: NEVER SET GACT_STRINGEXTEND IF YOU
                                   * ARE RUNNING ON LESS THAN V36!  SEE
                                   * GFLG_STRINGEXTEND (ABOVE) INSTEAD
                                   }

 GACT_ACTIVEGADGET = $4000;  { this gadget is "active".  This flag
                                   * is maintained by Intuition, and you
                                   * cannot count on its value persisting
                                   * while you do something on your program's
                                   * task.  It can only be trusted by
                                   * people implementing custom gadgets
                                   }

{ note $8000 is used above (GACT_BORDERSNIFF);
 * all Activation flags defined }

{ --- GADGET TYPES ------------------------------------------------------- }
{ These are the Gadget Type definitions for the variable GadgetType
 * gadget number type MUST start from one.  NO TYPES OF ZERO ALLOWED.
 * first comes the mask for Gadget flags reserved for Gadget typing
 }
 GTYP_GADGETTYPE = $FC00;  { all Gadget Global Type flags (padded) }
 GTYP_SYSGADGET  = $8000;  { 1 = Allocated by the system, 0 = by app. }
 GTYP_SCRGADGET  = $4000;  { 1 = ScreenGadget, 0 = WindowGadget }
 GTYP_GZZGADGET  = $2000;  { 1 = for WFLG_GIMMEZEROZERO borders }
 GTYP_REQGADGET  = $1000;  { 1 = this is a Requester Gadget }
{ system gadgets }
 GTYP_SIZING     = $0010;
 GTYP_WDRAGGING  = $0020;
 GTYP_SDRAGGING  = $0030;
 GTYP_WUPFRONT   = $0040;
 GTYP_SUPFRONT   = $0050;
 GTYP_WDOWNBACK  = $0060;
 GTYP_SDOWNBACK  = $0070;
 GTYP_CLOSE      = $0080;
{ application gadgets }
 GTYP_BOOLGADGET = $0001;
 GTYP_GADGET0002 = $0002;
 GTYP_PROPGADGET = $0003;
 GTYP_STRGADGET  = $0004;
 GTYP_CUSTOMGADGET    =   $0005;


{* GTYP_GTYPEMASK is a mask you can apply to tell what class
 * of gadget this is.  The possible classes follow.
 *}
 GTYP_GTYPEMASK        =  $0007;

{ This bit in GadgetType is reserved for undocumented internal use
 * by the Gadget Toolkit, and cannot be used nor relied on by
 * applications:        $0100;
 }

{ New for V39.  Gadgets which have the GFLG_EXTENDED flag set are
 * actually ExtGadgets, which have more flags.  The GMORE_xxx
 * identifiers describe those flags.  For GMORE_SCROLLRASTER, see
 * important information in the ScrollWindowRaster() autodoc.
 * NB: GMORE_SCROLLRASTER must be set before the gadget is
 * added to a window.
 }
 GMORE_BOUNDS       = $00000001; { ExtGadget has valid Bounds }
 GMORE_GADGETHELP   = $00000002; { This gadget responds to gadget help }
 GMORE_SCROLLRASTER = $00000004; { This (custom) gadget uses ScrollRaster }

{ ======================================================================== }
{ === BoolInfo======================================================= }
{ ======================================================================== }
{ This is the special data needed by an Extended Boolean Gadget
 * Typically this structure will be pointed to by the Gadget field SpecialInfo
 }
Type
    BoolInfo = record
        Flags   : Short;        { defined below }
        Mask    : Address; { bit mask for highlighting and selecting
                         * mask must follow the same rules as an Image
                         * plane.  It's width and height are determined
                         * by the width and height of the gadget's
                         * select box. (i.e. Gadget.Width and .Height).
                         }
        Reserved : Integer;     { set to 0      }
    end;
    BoolInfoPtr = ^BoolInfo;

Const

{ set BoolInfo.Flags to this flag bit.
 * in the future, additional bits might mean more stuff hanging
 * off of BoolInfo.Reserved.
}
    BOOLMASK    = $0001;        { extension is for masked gadget }

{ ======================================================================== }
{ === PropInfo =========================================================== }
{ ======================================================================== }
{ this is the special data required by the proportional Gadget
 * typically, this data will be pointed to by the Gadget variable SpecialInfo
 }

Type

    PropInfo = record
        Flags   : Short;        { general purpose flag bits (see defines below) }

    { You initialize the Pot variables before the Gadget is added to
     * the system.  Then you can look here for the current settings
     * any time, even while User is playing with this Gadget.  To
     * adjust these after the Gadget is added to the System, use
     * ModifyProp();  The Pots are the actual proportional settings,
     * where a value of zero means zero and a value of MAXPOT means
     * that the Gadget is set to its maximum setting.
     }

        HorizPot        : WORD; { 16-bit FixedPoint horizontal quantity percentage }
        VertPot         : WORD; { 16-bit FixedPoint vertical quantity percentage }

    { the 16-bit FixedPoint Body variables describe what percentage of
     * the entire body of stuff referred to by this Gadget is actually
     * shown at one time.  This is used with the AUTOKNOB routines,
     * to adjust the size of the AUTOKNOB according to how much of
     * the data can be seen.  This is also used to decide how far
     * to advance the Pots when User hits the Container of the Gadget.
     * For instance, if you were controlling the display of a 5-line
     * Window of text with this Gadget, and there was a total of 15
     * lines that could be displayed, you would set the VertBody value to
     *     (MAXBODY / (TotalLines / DisplayLines)) = MAXBODY / 3.
     * Therefore, the AUTOKNOB would fill 1/3 of the container, and
     * if User hits the Cotainer outside of the knob, the pot would
     * advance 1/3 (plus or minus) If there's no body to show, or
     * the total amount of displayable info is less than the display area,
     * set the Body variables to the MAX.  To adjust these after the
     * Gadget is added to the System, use ModifyProp();
     }

        HorizBody       : Short;        { horizontal Body }
        VertBody        : Short;        { vertical Body }

    { these are the variables that Intuition sets and maintains }

        CWidth          : Short;        { Container width (with any relativity absoluted) }
        CHeight         : Short;        { Container height (with any relativity absoluted) }
        HPotRes,
        VPotRes         : Short;        { pot increments }
        LeftBorder      : Short;        { Container borders }
        TopBorder       : Short;        { Container borders }
    end;
    PropInfoPtr = ^PropInfo;

CONST
{ --- FLAG BITS ---------------------------------------------------------- }
 AUTOKNOB     =   $0001;  { this flag sez:  gimme that old auto-knob }
{ NOTE: if you do not use an AUTOKNOB for a proportional gadget,
 * you are currently limited to using a single Image of your own
 * design: Intuition won't handle a linked list of images as
 * a proportional gadget knob.
 }

 FREEHORIZ     =  $0002;  { IF set, the knob can move horizontally }
 FREEVERT      =  $0004;  { IF set, the knob can move vertically }
 PROPBORDERLESS =  $0008;  { IF set, no border will be rendered }
 KNOBHIT       =  $0100;  { set when this Knob is hit }
 PROPNEWLOOK   =  $0010;  { set this IF you want to get the new
                                 * V36 look
                                 }

 KNOBHMIN      =  6;       { minimum horizontal size of the Knob }
 KNOBVMIN      =  4;       { minimum vertical size of the Knob }
 MAXBODY       =  $FFFF;  { maximum body value }
 MAXPOT        =  $FFFF;  { maximum pot value }

{ ======================================================================== }
{ === StringInfo ========================================================= }
{ ======================================================================== }
{ this is the special data required by the string Gadget
 * typically, this data will be pointed to by the Gadget variable SpecialInfo
 }

Type

    StringInfo = record
    { you initialize these variables, and then Intuition maintains them }
        Buffer          : String;       { the buffer containing the start and final string }
        UndoBuffer      : String;       { optional buffer for undoing current entry }
        BufferPos       : Short;        { character position in Buffer }
        MaxChars        : Short;        { max number of chars in Buffer (including NULL) }
        DispPos         : Short;        { Buffer position of first displayed character }

    { Intuition initializes and maintains these variables for you }

        UndoPos         : Short;        { character position in the undo buffer }
        NumChars        : Short;        { number of characters currently in Buffer }
        DispCount       : Short;        { number of whole characters visible in Container }
        CLeft,
        CTop            : Short;        { topleft offset of the container }
        Layer           : LayerPtr;     { the RastPort containing this Gadget }

    { you can initialize this variable before the gadget is submitted to
     * Intuition, and then examine it later to discover what integer
     * the user has entered (if the user never plays with the gadget,
     * the value will be unchanged from your initial setting)
     }

        LongInt         : Integer;

    { If you want this Gadget to use your own Console keymapping, you
     * set the ALTKEYMAP bit in the Activation flags of the Gadget, and then
     * set this variable to point to your keymap.  If you don't set the
     * ALTKEYMAP, you'll get the standard ASCII keymapping.
     }

        AltKeyMap       : Address;
    end;
    StringInfoPtr = ^StringInfo;


{ ======================================================================== }
{ === Requester ========================================================== }
{ ======================================================================== }

Type

    Requester = record
    { the ClipRect and BitMap and used for rendering the requester }
        OlderRequest    : ^Requester;
        LeftEdge,
        TopEdge         : Short;        { dimensions of the entire box }
        Width,
        Height          : Short;        { dimensions of the entire box }
        RelLeft,
        RelTop          : Short;        { for Pointer relativity offsets }

        ReqGadget       : GadgetPtr;    { pointer to a list of Gadgets }
        ReqBorder       : BorderPtr;    { the box's border }
        ReqText         : IntuiTextPtr; { the box's text }
        Flags           : Short;        { see definitions below }

    { pen number for back-plane fill before draws }

        BackFill        : Byte;

    { Layer in place of clip rect       }

        ReqLayer        : LayerPtr;

        ReqPad1         : Array [0..31] of Byte;

    { If the BitMap plane pointers are non-zero, this tells the system
     * that the image comes pre-drawn (if the appliprog wants to define
     * it's own box, in any shape or size it wants!);  this is OK by
     * Intuition as long as there's a good correspondence between
     * the image and the specified Gadgets
     }

        ImageBMap       : BitMapPtr;    { points to the BitMap of PREDRAWN imagery }
        RWindow         : Address;      { added.  points back to Window }
        ReqPad2         : Array [0..35] of Byte;
    end;
    RequesterPtr = ^Requester;


Const

{ FLAGS SET BY THE APPLIPROG }
    POINTREL            = $0001;    { if POINTREL set, TopLeft is relative to pointer}
    PREDRAWN            = $0002;    { if ReqBMap points to predrawn Requester imagery }
    NOISYREQ            = $0004;    { if you don't want requester to filter input          }

    SIMPLEREQ           = $0010;
        { to use SIMPLEREFRESH layer (recommended)     }

    { New for V36          }
    USEREQIMAGE         = $0020;
         {  render linked list ReqImage after BackFill
         * but before gadgets and text
         }
    NOREQBACKFILL       = $0040;
        { don't bother filling requester with Requester.BackFill pen   }


{ FLAGS SET BY INTUITION }
    REQOFFWINDOW        = $1000;        { part of one of the Gadgets was offwindow }
    REQACTIVE           = $2000;        { this requester is active }
    SYSREQUEST          = $4000;        { this requester caused by system }
    DEFERREFRESH        = $8000;        { this Requester stops a Refresh broadcast }




{ ======================================================================== }
{ === Image ============================================================== }
{ ======================================================================== }
{ This is a brief image structure for very simple transfers of
 * image data to a RastPort
 }

Type

    Image = record
        LeftEdge        : Short;        { starting offset relative to some origin }
        TopEdge         : Short;        { starting offsets relative to some origin }
        Width           : Short;        { pixel size (though data is word-aligned) }
        Height,
        Depth           : Short;        { pixel sizes }
        ImageData       : Address;      { pointer to the actual word-aligned bits }

    { the PlanePick and PlaneOnOff variables work much the same way as the
     * equivalent GELS Bob variables.  It's a space-saving
     * mechanism for image data.  Rather than defining the image data
     * for every plane of the RastPort, you need define data only
     * for the planes that are not entirely zero or one.  As you
     * define your Imagery, you will often find that most of the planes
     * ARE just as color selectors.  For instance, if you're designing
     * a two-color Gadget to use colors two and three, and the Gadget
     * will reside in a five-plane display, bit plane zero of your
     * imagery would be all ones, bit plane one would have data that
     * describes the imagery, and bit planes two through four would be
     * all zeroes.  Using these flags allows you to avoid wasting all
     * that memory in this way:  first, you specify which planes you
     * want your data to appear in using the PlanePick variable.  For
     * each bit set in the variable, the next "plane" of your image
     * data is blitted to the display.  For each bit clear in this
     * variable, the corresponding bit in PlaneOnOff is examined.
     * If that bit is clear, a "plane" of zeroes will be used.
     * If the bit is set, ones will go out instead.  So, for our example:
     *   Gadget.PlanePick = $02;
     *   Gadget.PlaneOnOff = $01;
     * Note that this also allows for generic Gadgets, like the
     * System Gadgets, which will work in any number of bit planes.
     * Note also that if you want an Image that is only a filled
     * rectangle, you can get this by setting PlanePick to zero
     * (pick no planes of data) and set PlaneOnOff to describe the pen
     * color of the rectangle.
     }

        PlanePick,
        PlaneOnOff      : Byte;

    { if the NextImage variable is not NULL, Intuition presumes that
     * it points to another Image structure with another Image to be
     * rendered
     }

        NextImage       : ^Image;
    end;
    ImagePtr = ^Image;


{ New for V39, Intuition supports the IESUBCLASS_NEWTABLET subclass
 * of the IECLASS_NEWPOINTERPOS event.  The ie_EventAddress of such
 * an event points to a TabletData structure (see below).
 *
 * The TabletData structure contains certain elements including a taglist.
 * The taglist can be used for special tablet parameters.  A tablet driver
 * should include only those tag-items the tablet supports.  An application
 * can listen for any tag-items that interest it.  Note: an application
 * must set the WA_TabletMessages attribute to TRUE to receive this
 * extended information in its IntuiMessages.
 *
 * The definitions given here MUST be followed.  Pay careful attention
 * to normalization and the interpretation of signs.
 *
 * TABLETA_TabletZ:  the current value of the tablet in the Z direction.
 * This unsigned value should typically be in the natural units of the
 * tablet.  You should also provide TABLETA_RangeZ.
 *
 * TABLETA_RangeZ:  the maximum value of the tablet in the Z direction.
 * Normally specified along with TABLETA_TabletZ, this allows the
 * application to scale the actual Z value across its range.
 *
 * TABLETA_AngleX:  the angle of rotation or tilt about the X-axis.  This
 * number should be normalized to fill a signed long integer.  Positive
 * values imply a clockwise rotation about the X-axis when viewing
 * from +X towards the origin.
 *
 * TABLETA_AngleY:  the angle of rotation or tilt about the Y-axis.  This
 * number should be normalized to fill a signed long integer.  Positive
 * values imply a clockwise rotation about the Y-axis when viewing
 * from +Y towards the origin.
 *
 * TABLETA_AngleZ:  the angle of rotation or tilt about the Z axis.  This
 * number should be normalized to fill a signed long integer.  Positive
 * values imply a clockwise rotation about the Z-axis when viewing
 * from +Z towards the origin.
 *
 *      Note: a stylus that supports tilt should use the TABLETA_AngleX
 *      and TABLETA_AngleY attributes.  Tilting the stylus so the tip
 *      points towards increasing or decreasing X is actually a rotation
 *      around the Y-axis.  Thus, if the stylus tip points towards
 *      positive X, then that tilt is represented as a negative
 *      TABLETA_AngleY.  Likewise, if the stylus tip points towards
 *      positive Y, that tilt is represented by positive TABLETA_AngleX.
 *
 * TABLETA_Pressure:  the pressure reading of the stylus.  The pressure
 * should be normalized to fill a signed long integer.  Typical devices
 * won't generate negative pressure, but the possibility is not precluded.
 * The pressure threshold which is considered to cause a button-click is
 * expected to be set in a Preferences program supplied by the tablet
 * vendor.  The tablet driver would send IECODE_LBUTTON-type events as
 * the pressure crossed that threshold.
 *
 * TABLETA_ButtonBits:  ti_Data is a long integer whose bits are to
 * be interpreted at the state of the first 32 buttons of the tablet.
 *
 * TABLETA_InProximity:  ti_Data is a boolean.  For tablets that support
 * proximity, they should send the (TABLETA_InProximity,FALSE) tag item
 * when the stylus is out of proximity.  One possible use we can forsee
 * is a mouse-blanking commodity which keys off this to blank the
 * mouse.  When this tag is absent, the stylus is assumed to be
 * in proximity.
 *
 * TABLETA_ResolutionX:  ti_Data is an unsigned long integer which
 * is the x-axis resolution in dots per inch.
 *
 * TABLETA_ResolutionY:  ti_Data is an unsigned long integer which
 * is the y-axis resolution in dots per inch.
 }

const
 TABLETA_Dummy          = (TAG_USER + $3A000)  ;
 TABLETA_TabletZ        = (TABLETA_Dummy + $01);
 TABLETA_RangeZ         = (TABLETA_Dummy + $02);
 TABLETA_AngleX         = (TABLETA_Dummy + $03);
 TABLETA_AngleY         = (TABLETA_Dummy + $04);
 TABLETA_AngleZ         = (TABLETA_Dummy + $05);
 TABLETA_Pressure       = (TABLETA_Dummy + $06);
 TABLETA_ButtonBits     = (TABLETA_Dummy + $07);
 TABLETA_InProximity    = (TABLETA_Dummy + $08);
 TABLETA_ResolutionX    = (TABLETA_Dummy + $09);
 TABLETA_ResolutionY    = (TABLETA_Dummy + $0A);

{ If your window sets WA_TabletMessages to TRUE, then it will receive
 * extended IntuiMessages (struct ExtIntuiMessage) whose eim_TabletData
 * field points at a TabletData structure.  This structure contains
 * additional information about the input event.
 }

Type
 TabletData = Record
    { Sub-pixel position of tablet, in screen coordinates,
     * scaled to fill a UWORD fraction:
     }
    td_XFraction, td_YFraction  : WORD;

    { Current tablet coordinates along each axis: }
    td_TabletX, td_TabletY      : Integer;

    { Tablet range along each axis.  For example, if td_TabletX
     * can take values 0-999, td_RangeX should be 1000.
     }
    td_RangeX, td_RangeY        : Integer;

    { Pointer to tag-list of additional tablet attributes.
     * See <intuition/intuition.h> for the tag values.
     }
    td_TagList                  : Address;
 end;
 TabletDataPtr = ^TabletData;

{ If a tablet driver supplies a hook for ient_CallBack, it will be
 * invoked in the standard hook manner.  A0 will point to the Hook
 * itself, A2 will point to the InputEvent that was sent, and
 * A1 will point to a TabletHookData structure.  The InputEvent's
 * ie_EventAddress field points at the IENewTablet structure that
 * the driver supplied.
 *
 * Based on the thd_Screen, thd_Width, and thd_Height fields, the driver
 * should scale the ient_TabletX and ient_TabletY fields and store the
 * result in ient_ScaledX, ient_ScaledY, ient_ScaledXFraction, and
 * ient_ScaledYFraction.
 *
 * The tablet hook must currently return NULL.  This is the only
 * acceptable return-value under V39.
 }

 TabletHookData = Record
    { Pointer to the active screen:
     * Note: if there are no open screens, thd_Screen will be NULL.
     * thd_Width and thd_Height will then describe an NTSC 64$400
     * screen.  Please scale accordingly.
     }
    thd_Screen      : ScreenPtr;

    { The width and height (measured in pixels of the active screen)
     * that your are to scale to:
     }
    thd_Width,
    thd_Height      : Integer;

    { Non-zero if the screen or something about the screen
     * changed since the last time you were invoked:
     }
    thd_ScreenChanged   : Integer;
 end;
 TabletHookDataPtr = ^TabletHookData;


{ ======================================================================== }
{ === IntuiMessage ======================================================= }
{ ======================================================================== }

Type

    IntuiMessage = record
        ExecMessage     : Message;

    { the Class bits correspond directly with the IDCMP Flags, except for the
     * special bit LONELYMESSAGE (defined below)
     }

        Class           : Integer;

    { the Code field is for special values like MENU number }

        Code            : Short;

    { the Qualifier field is a copy of the current InputEvent's Qualifier }

        Qualifier       : Short;

    { IAddress contains particular addresses for Intuition functions, like
     * the pointer to the Gadget or the Screen
     }

        IAddress        : Address;

    { when getting mouse movement reports, any event you get will have the
     * the mouse coordinates in these variables.  the coordinates are relative
     * to the upper-left corner of your Window (GIMMEZEROZERO notwithstanding)
     }

        MouseX,
        MouseY          : Short;

    { the time values are copies of the current system clock time.  Micros
     * are in units of microseconds, Seconds in seconds.
     }

        Seconds,
        Micros          : Integer;

    { the IDCMPWindow variable will always have the address of the Window of
     * this IDCMP
     }

        IDCMPWindow     : Address;

    { system-use variable }

        SpecialLink     : ^IntuiMessage;
    end;
    IntuiMessagePtr = ^IntuiMessage;

{ New for V39:
 * All IntuiMessages are now slightly extended.  The ExtIntuiMessage
 * structure has an additional field for tablet data, which is usually
 * NULL.  If a tablet driver which is sending IESUBCLASS_NEWTABLET
 * events is installed in the system, windows with the WA_TabletMessages
 * property set will find that eim_TabletData points to the TabletData
 * structure.  Applications must first check that this field is non-NULL;
 * it will be NULL for certain kinds of message, including mouse activity
 * generated from other than the tablet (i.e. the keyboard equivalents
 * or the mouse itself).
 *
 * NEVER EVER examine any extended fields when running under pre-V39!
 *
 * NOTE: This structure is subject to grow in the future.  Making
 * assumptions about its size is A BAD IDEA.
 }

 ExtIntuiMessage = Record
    eim_IntuiMessage  : IntuiMessage;
    eim_TabletData    : TabletDataPtr;
 end;
 ExtIntuiMessagePtr = ^ExtIntuiMessage;


CONST

{ --- IDCMP Classes ------------------------------------------------------ }
{ Please refer to the Autodoc for OpenWindow() and to the Rom Kernel
 * Manual for full details on the IDCMP classes.
 }
 IDCMP_SIZEVERIFY      =  $00000001;
 IDCMP_NEWSIZE         =  $00000002;
 IDCMP_REFRESHWINDOW   =  $00000004;
 IDCMP_MOUSEBUTTONS    =  $00000008;
 IDCMP_MOUSEMOVE       =  $00000010;
 IDCMP_GADGETDOWN      =  $00000020;
 IDCMP_GADGETUP        =  $00000040;
 IDCMP_REQSET          =  $00000080;
 IDCMP_MENUPICK        =  $00000100;
 IDCMP_CLOSEWINDOW     =  $00000200;
 IDCMP_RAWKEY          =  $00000400;
 IDCMP_REQVERIFY       =  $00000800;
 IDCMP_REQCLEAR        =  $00001000;
 IDCMP_MENUVERIFY      =  $00002000;
 IDCMP_NEWPREFS        =  $00004000;
 IDCMP_DISKINSERTED    =  $00008000;
 IDCMP_DISKREMOVED     =  $00010000;
 IDCMP_WBENCHMESSAGE   =  $00020000;  {  System use only         }
 IDCMP_ACTIVEWINDOW    =  $00040000;
 IDCMP_INACTIVEWINDOW  =  $00080000;
 IDCMP_DELTAMOVE       =  $00100000;
 IDCMP_VANILLAKEY      =  $00200000;
 IDCMP_INTUITICKS      =  $00400000;
{  for notifications from "boopsi" gadgets               }
 IDCMP_IDCMPUPDATE     =  $00800000;  { new for V36      }
{ for getting help key report during menu session        }
 IDCMP_MENUHELP        =  $01000000;  { new for V36      }
{ for notification of any move/size/zoom/change window   }
 IDCMP_CHANGEWINDOW    =  $02000000;  { new for V36      }
 IDCMP_GADGETHELP      =  $04000000;  { new for V39      }

{ NOTEZ-BIEN:                          $80000000 is reserved for internal use   }

{ the IDCMP Flags do not use this special bit, which is cleared when
 * Intuition sends its special message to the Task, and set when Intuition
 * gets its Message back from the Task.  Therefore, I can check here to
 * find out fast whether or not this Message is available for me to send
 }
 IDCMP_LONELYMESSAGE   =  $80000000;


{ --- IDCMP Codes -------------------------------------------------------- }
{ This group of codes is for the IDCMP_CHANGEWINDOW message }
 CWCODE_MOVESIZE = $0000;  { Window was moved and/or sized }
 CWCODE_DEPTH    = $0001;  { Window was depth-arranged (new for V39) }

{ This group of codes is for the IDCMP_MENUVERIFY function }
 MENUHOT       =  $0001;  { IntuiWants verification OR MENUCANCEL    }
 MENUCANCEL    =  $0002;  { HOT Reply of this cancels Menu operation }
 MENUWAITING   =  $0003;  { Intuition simply wants a ReplyMsg() ASAP }

{ These are internal tokens to represent state of verification attempts
 * shown here as a clue.
 }
 OKOK          =  MENUHOT; { guy didn't care                      }
 OKABORT       =  $0004;  { window rendered question moot        }
 OKCANCEL      =  MENUCANCEL; { window sent cancel reply          }

{ This group of codes is for the IDCMP_WBENCHMESSAGE messages }
 WBENCHOPEN    =  $0001;
 WBENCHCLOSE   =  $0002;


{ A data structure common in V36 Intuition processing  }
Type
   IBox = Record
    Left,
    Top,
    Width,
    Height : Short;
   END;
   IBoxPtr = ^IBox;


{ ======================================================================== }
{ === Window ============================================================= }
{ ======================================================================== }

Type

    Window = record
        NextWindow      : ^Window;      { for the linked list in a screen }

        LeftEdge,
        TopEdge         : Short;        { screen dimensions of window }
        Width,
        Height          : Short;        { screen dimensions of window }

        MouseY,
        MouseX          : Short;        { relative to upper-left of window }

        MinWidth,
        MinHeight       : Short;        { minimum sizes }
        MaxWidth,
        MaxHeight       : Short;        { maximum sizes }

        Flags           : Integer;      { see below for defines }

        MenuStrip       : MenuPtr;      { the strip of Menu headers }

        Title           : String;       { the title text for this window }

        FirstRequest    : RequesterPtr; { all active Requesters }

        DMRequest       : RequesterPtr; { double-click Requester }

        ReqCount        : Short;        { count of reqs blocking Window }

        WScreen         : Address;      { this Window's Screen }
        RPort           : RastPortPtr;  { this Window's very own RastPort }

    { the border variables describe the window border.   If you specify
     * GIMMEZEROZERO when you open the window, then the upper-left of the
     * ClipRect for this window will be upper-left of the BitMap (with correct
     * offsets when in SuperBitMap mode; you MUST select GIMMEZEROZERO when
     * using SuperBitMap).  If you don't specify ZeroZero, then you save
     * memory (no allocation of RastPort, Layer, ClipRect and associated
     * Bitmaps), but you also must offset all your writes by BorderTop,
     * BorderLeft and do your own mini-clipping to prevent writing over the
     * system gadgets
     }

        BorderLeft,
        BorderTop,
        BorderRight,
        BorderBottom    : Byte;
        BorderRPort     : RastPortPtr;


    { You supply a linked-list of Gadgets for your Window.
     * This list DOES NOT include system gadgets.  You get the standard
     * window system gadgets by setting flag-bits in the variable Flags (see
     * the bit definitions below)
     }

        FirstGadget     : GadgetPtr;

    { these are for opening/closing the windows }

        Parent,
        Descendant      : ^Window;

    { sprite data information for your own Pointer
     * set these AFTER you Open the Window by calling SetPointer()
     }

        Pointer         : Address;      { sprite data }
        PtrHeight       : Byte;         { sprite height (not including sprite padding) }
        PtrWidth        : Byte;         { sprite width (must be less than or equal to 16) }
        XOffset,
        YOffset         : Byte;         { sprite offsets }

    { the IDCMP Flags and User's and Intuition's Message Ports }
        IDCMPFlags      : Integer;      { User-selected flags }
        UserPort,
        WindowPort      : MsgPortPtr;
        MessageKey      : IntuiMessagePtr;

        DetailPen,
        BlockPen        : Byte; { for bar/border/gadget rendering }

    { the CheckMark is a pointer to the imagery that will be used when
     * rendering MenuItems of this Window that want to be checkmarked
     * if this is equal to NULL, you'll get the default imagery
     }

        CheckMark       : ImagePtr;

        ScreenTitle     : String; { if non-null, Screen title when Window is active }

    { These variables have the mouse coordinates relative to the
     * inner-Window of GIMMEZEROZERO Windows.  This is compared with the
     * MouseX and MouseY variables, which contain the mouse coordinates
     * relative to the upper-left corner of the Window, GIMMEZEROZERO
     * notwithstanding
     }

        GZZMouseX       : Short;
        GZZMouseY       : Short;

    { these variables contain the width and height of the inner-Window of
     * GIMMEZEROZERO Windows
     }

        GZZWidth        : Short;
        GZZHeight       : Short;

        ExtData         : Address;

        UserData        : Address;      { general-purpose pointer to User data extension }

    {* jimm: NEW: 11/18/85: this pointer keeps a duplicate of what
     * Window.RPort->Layer is _supposed_ to be pointing at
     }

        WLayer          : LayerPtr;

    { jimm: NEW 1.2: need to keep track of the font that
     * OpenWindow opened, in case user SetFont's into RastPort
     }

        IFont           : TextFontPtr;
    {* (V36) another flag word (the Flags field is used up).
     * At present, all flag values are system private.
     * Until further notice, you may not change nor use this field.
     *}
        MoreFlags       : Integer;

    {**** Data beyond this point are Intuition Private.  DO NOT USE ****}

    end;
    WindowPtr = ^Window;

CONST
{ --- Flags requested at OpenWindow() time by the application --------- }
 WFLG_SIZEGADGET   =  $00000001;  { include sizing system-gadget? }
 WFLG_DRAGBAR      =  $00000002;  { include dragging system-gadget? }
 WFLG_DEPTHGADGET  =  $00000004;  { include depth arrangement gadget? }
 WFLG_CLOSEGADGET  =  $00000008;  { include close-box system-gadget? }

 WFLG_SIZEBRIGHT   =  $00000010;  { size gadget uses right border }
 WFLG_SIZEBBOTTOM  =  $00000020;  { size gadget uses bottom border }

{ --- refresh modes ------------------------------------------------------ }
{ combinations of the WFLG_REFRESHBITS select the refresh type }
 WFLG_REFRESHBITS   = $000000C0;
 WFLG_SMART_REFRESH = $00000000;
 WFLG_SIMPLE_REFRESH= $00000040;
 WFLG_SUPER_BITMAP  = $00000080;
 WFLG_OTHER_REFRESH = $000000C0;

 WFLG_BACKDROP      = $00000100;  { this is a backdrop window }

 WFLG_REPORTMOUSE   = $00000200;  { to hear about every mouse move }

 WFLG_GIMMEZEROZERO = $00000400;  { a GimmeZeroZero window       }

 WFLG_BORDERLESS    = $00000800;  { to get a Window sans border }

 WFLG_ACTIVATE      = $00001000;  { when Window opens, it's Active }


{ --- Other User Flags --------------------------------------------------- }
 WFLG_RMBTRAP       = $00010000;  { Catch RMB events for your own }
 WFLG_NOCAREREFRESH = $00020000;  { not to be bothered with REFRESH }

{ - V36 new Flags which the programmer may specify in NewWindow.Flags  }
 WFLG_NW_EXTENDED   = $00040000;  { extension data provided      }
                                        { see struct ExtNewWindow      }

{ - V39 new Flags which the programmer may specify in NewWindow.Flags  }
 WFLG_NEWLOOKMENUS  = $00200000;  { window has NewLook menus     }

{ These flags are set only by Intuition.  YOU MAY NOT SET THEM YOURSELF! }
 WFLG_WINDOWACTIVE  = $00002000;  { this window is the active one }
 WFLG_INREQUEST     = $00004000;  { this window is in request mode }
 WFLG_MENUSTATE     = $00008000;  { Window is active with Menus on }
 WFLG_WINDOWREFRESH = $01000000;  { Window is currently refreshing }
 WFLG_WBENCHWINDOW  = $02000000;  { WorkBench tool ONLY Window }
 WFLG_WINDOWTICKED  = $04000000;  { only one timer tick at a time }

{ --- V36 Flags to be set only by Intuition -------------------------  }
 WFLG_VISITOR       = $08000000;  { visitor window               }
 WFLG_ZOOMED        = $10000000;  { identifies "zoom state"      }
 WFLG_HASZOOM       = $20000000;  { windowhas a zoom gadget      }

{ --- Other Window Values ---------------------------------------------- }
 DEFAULTMOUSEQUEUE  =     (5);     { no more mouse messages       }

{ --- see struct IntuiMessage for the IDCMP Flag definitions ------------- }


{ ======================================================================== }
{ === NewWindow ========================================================== }
{ ======================================================================== }

Type

    NewWindow = record
        LeftEdge,
        TopEdge         : Short;        { screen dimensions of window }
        Width,
        Height          : Short;        { screen dimensions of window }

        DetailPen,
        BlockPen        : Byte;         { for bar/border/gadget rendering }

        IDCMPFlags      : Integer;      { User-selected IDCMP flags }

        Flags           : Integer;      { see Window struct for defines }

    { You supply a linked-list of Gadgets for your Window.
     *  This list DOES NOT include system Gadgets.  You get the standard
     *  system Window Gadgets by setting flag-bits in the variable Flags (see
     *  the bit definitions under the Window structure definition)
     }

        FirstGadget     : GadgetPtr;

    { the CheckMark is a pointer to the imagery that will be used when
     * rendering MenuItems of this Window that want to be checkmarked
     * if this is equal to NULL, you'll get the default imagery
     }

        CheckMark       : ImagePtr;

        Title           : String;  { the title text for this window }

    { the Screen pointer is used only if you've defined a CUSTOMSCREEN and
     * want this Window to open in it.  If so, you pass the address of the
     * Custom Screen structure in this variable.  Otherwise, this variable
     * is ignored and doesn't have to be initialized.
     }

        Screen          : Address;

    { SUPER_BITMAP Window?  If so, put the address of your BitMap structure
     * in this variable.  If not, this variable is ignored and doesn't have
     * to be initialized
     }

        BitMap          : BitMapPtr;

    { the values describe the minimum and maximum sizes of your Windows.
     * these matter only if you've chosen the WINDOWSIZING Gadget option,
     * which means that you want to let the User to change the size of
     * this Window.  You describe the minimum and maximum sizes that the
     * Window can grow by setting these variables.  You can initialize
     * any one these to zero, which will mean that you want to duplicate
     * the setting for that dimension (if MinWidth == 0, MinWidth will be
     * set to the opening Width of the Window).
     * You can change these settings later using SetWindowLimits().
     * If you haven't asked for a SIZING Gadget, you don't have to
     * initialize any of these variables.
     }

        MinWidth,
        MinHeight       : Short;        { minimums }
        MaxWidth,
        MaxHeight       : Short;        { maximums }

    { the type variable describes the Screen in which you want this Window to
     * open.  The type value can either be CUSTOMSCREEN or one of the
     * system standard Screen Types such as WBENCHSCREEN.  See the
     * type definitions under the Screen structure
     }

        WType           : Short;        { is "Type" in C includes }
    end;
    NewWindowPtr = ^NewWindow;


{ The following structure is the future NewWindow.  Compatibility
 * issues require that the size of NewWindow not change.
 * Data in the common part (NewWindow) indicates the the extension
 * fields are being used.
 * NOTE WELL: This structure may be subject to future extension.
 * Writing code depending on its size is not allowed.
 }
   ExtNewWindow = Record
    LeftEdge, TopEdge : Short;
    Width, Height : Short;

    DetailPen, BlockPen : Byte;
    IDCMPFlags    : Integer;
    Flags         : Integer;
    FirstGadget   : GadgetPtr;

    CheckMark     : ImagePtr;

    Title         : String;
    WScreen       : Address;
    WBitMap       : BitMapPtr;

    MinWidth, MinHeight : Short;
    MaxWidth, MaxHeight : Short;

    { the type variable describes the Screen in which you want this Window to
     * open.  The type value can either be CUSTOMSCREEN or one of the
     * system standard Screen Types such as WBENCHSCREEN.  See the
     * type definitions under the Screen structure.
     * A new possible value for this field is PUBLICSCREEN, which
     * defines the window as a 'visitor' window.  See below for
     * additional information provided.
     }
    WType  : Short;

    { ------------------------------------------------------- *
     * extensions for V36
     * if the NewWindow Flag value WFLG_NW_EXTENDED is set, then
     * this field is assumed to point to an array ( or chain of arrays)
     * of TagItem structures.  See also ExtNewScreen for another
     * use of TagItems to pass optional data.
     *
     * see below for tag values and the corresponding data.
     }
    Extension : TagItemPtr;
  END;
  ExtNewWindowPtr = ^ExtNewWindow;

{
 * The TagItem ID's (ti_Tag values) for OpenWindowTagList() follow.
 * They are values in a TagItem array passed as extension/replacement
 * values for the data in NewWindow.  OpenWindowTagList() can actually
 * work well with a NULL NewWindow pointer.
 }
CONST
 WA_Dummy     =   (TAG_USER + 99); { $80000063   }

{ these tags simply override NewWindow parameters }
 WA_Left               =  (WA_Dummy + $01);
 WA_Top                =  (WA_Dummy + $02);
 WA_Width              =  (WA_Dummy + $03);
 WA_Height             =  (WA_Dummy + $04);
 WA_DetailPen          =  (WA_Dummy + $05);
 WA_BlockPen           =  (WA_Dummy + $06);
 WA_IDCMP              =  (WA_Dummy + $07);
                        { "bulk" initialization of NewWindow.Flags }
 WA_Flags              =  (WA_Dummy + $08);
 WA_Gadgets            =  (WA_Dummy + $09);
 WA_Checkmark          =  (WA_Dummy + $0A);
 WA_Title              =  (WA_Dummy + $0B);
                        { means you don't have to call SetWindowTitles
                         * after you open your window
                         }
 WA_ScreenTitle        =  (WA_Dummy + $0C);
 WA_CustomScreen       =  (WA_Dummy + $0D);
 WA_SuperBitMap        =  (WA_Dummy + $0E);
                        { also implies WFLG_SUPER_BITMAP property      }
 WA_MinWidth           =  (WA_Dummy + $0F);
 WA_MinHeight          =  (WA_Dummy + $10);
 WA_MaxWidth           =  (WA_Dummy + $11);
 WA_MaxHeight          =  (WA_Dummy + $12);

{ The following are specifications for new features    }

 WA_InnerWidth         =  (WA_Dummy + $13);
 WA_InnerHeight        =  (WA_Dummy + $14);
                        { You can specify the dimensions of the interior
                         * region of your window, independent of what
                         * the border widths will be.  You probably want
                         * to also specify WA_AutoAdjust to allow
                         * Intuition to move your window or even
                         * shrink it so that it is completely on screen.
                         }

 WA_PubScreenName      =  (WA_Dummy + $15);
                        { declares that you want the window to open as
                         * a visitor on the public screen whose name is
                         * pointed to by (UBYTE *) ti_Data
                         }
 WA_PubScreen          =  (WA_Dummy + $16);
                        { open as a visitor window on the public screen
                         * whose address is in (struct Screen *) ti_Data.
                         * To ensure that this screen remains open, you
                         * should either be the screen's owner, have a
                         * window open on the screen, or use LockPubScreen().
                         }
 WA_PubScreenFallBack  =  (WA_Dummy + $17);
                        { A Boolean, specifies whether a visitor window
                         * should "fall back" to the default public screen
                         * (or Workbench) if the named public screen isn't
                         * available
                         }
 WA_WindowName         =  (WA_Dummy + $18);
                        { not implemented      }
 WA_Colors             =  (WA_Dummy + $19);
                        { a ColorSpec array for colors to be set
                         * when this window is active.  This is not
                         * implemented, and may not be, since the default
                         * values to restore would be hard to track.
                         * We'd like to at least support per-window colors
                         * for the mouse pointer sprite.
                         }
 WA_Zoom       =  (WA_Dummy + $1A);
                        { ti_Data points to an array of four WORD's,
                         * the initial Left/Top/Width/Height values of
                         * the "alternate" zoom position/dimensions.
                         * It also specifies that you want a Zoom gadget
                         * for your window, whether or not you have a
                         * sizing gadget.
                         }
 WA_MouseQueue         =  (WA_Dummy + $1B);
                        { ti_Data contains initial value for the mouse
                         * message backlog limit for this window.
                         }
 WA_BackFill           =  (WA_Dummy + $1C);
                        { unimplemented at present: provides a "backfill
                         * hook" for your window's layer.
                         }
 WA_RptQueue           =  (WA_Dummy + $1D);
                        { initial value of repeat key backlog limit    }

    { These Boolean tag items are alternatives to the NewWindow.Flags
     * boolean flags with similar names.
     }
 WA_SizeGadget         =  (WA_Dummy + $1E);
 WA_DragBar            =  (WA_Dummy + $1F);
 WA_DepthGadget        =  (WA_Dummy + $20);
 WA_CloseGadget        =  (WA_Dummy + $21);
 WA_Backdrop           =  (WA_Dummy + $22);
 WA_ReportMouse        =  (WA_Dummy + $23);
 WA_NoCareRefresh      =  (WA_Dummy + $24);
 WA_Borderless         =  (WA_Dummy + $25);
 WA_Activate           =  (WA_Dummy + $26);
 WA_RMBTrap            =  (WA_Dummy + $27);
 WA_WBenchWindow       =  (WA_Dummy + $28);       { PRIVATE!! }
 WA_SimpleRefresh      =  (WA_Dummy + $29);
                        { only specify if TRUE }
 WA_SmartRefresh       =  (WA_Dummy + $2A);
                        { only specify if TRUE }
 WA_SizeBRight         =  (WA_Dummy + $2B);
 WA_SizeBBottom        =  (WA_Dummy + $2C);

    { New Boolean properties   }
 WA_AutoAdjust         =  (WA_Dummy + $2D);
                        { shift or squeeze the window's position and
                         * dimensions to fit it on screen.
                         }

 WA_GimmeZeroZero      =  (WA_Dummy + $2E);
                        { equiv. to NewWindow.Flags WFLG_GIMMEZEROZERO }

{ New for V37: WA_MenuHelp (ignored by V36) }
 WA_MenuHelp           =  (WA_Dummy + $2F);
                        { Enables IDCMP_MENUHELP:  Pressing HELP during menus
                         * will return IDCMP_MENUHELP message.
                         }

{ New for V39:  (ignored by V37 and earlier) }
 WA_NewLookMenus       =  (WA_Dummy + $30);
                        { Set to TRUE if you want NewLook menus }
 WA_AmigaKey           =  (WA_Dummy + $31);
                        { Pointer to image for Amiga-key equiv in menus }
 WA_NotifyDepth        =  (WA_Dummy + $32);
                        { Requests IDCMP_CHANGEWINDOW message when
                         * window is depth arranged
                         * (imsg->Code = CWCODE_DEPTH)
                         }

{ WA_Dummy + $33 is obsolete }

 WA_Pointer            =  (WA_Dummy + $34);
                        { Allows you to specify a custom pointer
                         * for your window.  ti_Data points to a
                         * pointer object you obtained via
                         * "pointerclass". NULL signifies the
                         * default pointer.
                         * This tag may be passed to OpenWindowTags()
                         * or SetWindowPointer().
                         }

 WA_BusyPointer        =  (WA_Dummy + $35);
                        { ti_Data is boolean.  Set to TRUE to
                         * request the standard busy pointer.
                         * This tag may be passed to OpenWindowTags()
                         * or SetWindowPointer().
                         }

 WA_PointerDelay       =  (WA_Dummy + $36);
                        { ti_Data is boolean.  Set to TRUE to
                         * request that the changing of the
                         * pointer be slightly delayed.  The change
                         * will be called off if you call NewSetPointer()
                         * before the delay expires.  This allows
                         * you to post a busy-pointer even if you think
                         * the busy-time may be very short, without
                         * fear of a flashing pointer.
                         * This tag may be passed to OpenWindowTags()
                         * or SetWindowPointer().
                         }

 WA_TabletMessages     =  (WA_Dummy + $37);
                        { ti_Data is a boolean.  Set to TRUE to
                         * request that tablet information be included
                         * in IntuiMessages sent to your window.
                         * Requires that something (i.e. a tablet driver)
                         * feed IESUBCLASS_NEWTABLET InputEvents into
                         * the system.  For a pointer to the TabletData,
                         * examine the ExtIntuiMessage->eim_TabletData
                         * field.  It is UNSAFE to check this field
                         * when running on pre-V39 systems.  It's always
                         * safe to check this field under V39 and up,
                         * though it may be NULL.
                         }

 WA_HelpGroup          =  (WA_Dummy + $38);
                        { When the active window has gadget help enabled,
                         * other windows of the same HelpGroup number
                         * will also get GadgetHelp.  This allows GadgetHelp
                         * to work for multi-windowed applications.
                         * Use GetGroupID() to get an ID number.  Pass
                         * this number as ti_Data to all your windows.
                         * See also the HelpControl() function.
                         }

 WA_HelpGroupWindow    =  (WA_Dummy + $39);
                        { When the active window has gadget help enabled,
                         * other windows of the same HelpGroup will also get
                         * GadgetHelp.  This allows GadgetHelp to work
                         * for multi-windowed applications.  As an alternative
                         * to WA_HelpGroup, you can pass a pointer to any
                         * other window of the same group to join its help
                         * group.  Defaults to NULL, which has no effect.
                         * See also the HelpControl() function.
                         }


{ HelpControl() flags:
 *
 * HC_GADGETHELP - Set this flag to enable Gadget-Help for one or more
 * windows.
 }

 HC_GADGETHELP  = 1;


{ ======================================================================== }
{ === Remember =========================================================== }
{ ======================================================================== }
{ this structure is used for remembering what memory has been allocated to
 * date by a given routine, so that a premature abort or systematic exit
 * can deallocate memory cleanly, easily, and completely
 }

Type

    Remember = record
        NextRemember    : ^Remember;
        RememberSize    : Integer;
        Memory          : Address;
    end;
    RememberPtr = ^Remember;


{ === Color Spec ====================================================== }
{ How to tell Intuition about RGB values for a color table entry. }

  ColorSpec = Record
    ColorIndex  : Short;     { -1 terminates an array of ColorSpec  }
    Red         : Short;     { only the _bottom_ 4 bits recognized }
    Green       : Short;     { only the _bottom_ 4 bits recognized }
    Blue        : Short;     { only the _bottom_ 4 bits recognized }
  END;
  ColorSpecPtr = ^ColorSpec;

{ === Easy Requester Specification ======================================= }
{ see also autodocs for EasyRequest and BuildEasyRequest       }
{ NOTE: This structure may grow in size in the future          }
   EasyStruct = Record
    es_StructSize   : Integer;  { should be sizeof (struct EasyStruct )}
    es_Flags        : Integer;  { should be 0 for now                  }
    es_Title        : String;   { title of requester window            }
    es_TextFormat   : String;   { 'printf' style formatting string     }
    es_GadgetFormat : String;   { 'printf' style formatting string   }
   END;
   EasyStructPtr = ^EasyStruct;



{ ======================================================================== }
{ === Miscellaneous ====================================================== }
{ ======================================================================== }
CONST
{ = MENU STUFF =========================================================== }
    NOMENU      = $001F;
    NOITEM      = $003F;
    NOSUB       = $001F;
    MENUNULL    = -1;


{ = =RJ='s peculiarities ================================================= }

{ these defines are for the COMMSEQ and CHECKIT menu stuff.  If CHECKIT,
 * I'll use a generic Width (for all resolutions) for the CheckMark.
 * If COMMSEQ, likewise I'll use this generic stuff
 }

    CHECKWIDTH          = 19;
    COMMWIDTH           = 27;
    LOWCHECKWIDTH       = 13;
    LOWCOMMWIDTH        = 16;

{ these are the AlertNumber defines.  if you are calling DisplayAlert()
 * the AlertNumber you supply must have the ALERT_TYPE bits set to one
 * of these patterns
 }

    ALERT_TYPE          = $80000000;
    RECOVERY_ALERT      = $00000000;    { the system can recover from this }
    DEADEND_ALERT       = $80000000;    { no recovery possible, this is it }


{ When you're defining IntuiText for the Positive and Negative Gadgets
 * created by a call to AutoRequest(), these defines will get you
 * reasonable-looking text.  The only field without a define is the IText
 * field; you decide what text goes with the Gadget
 }

    AUTOFRONTPEN        = 0;
    AUTOBACKPEN         = 1;
    AUTODRAWMODE        = JAM2;
    AUTOLEFTEDGE        = 6;
    AUTOTOPEDGE         = 3;
    AUTOITEXTFONT       = Nil;
    AUTONEXTTEXT        = Nil;


{ --- RAWMOUSE Codes and Qualifiers (Console OR IDCMP) ------------------- }

    SELECTUP            = IECODE_LBUTTON + IECODE_UP_PREFIX;
    SELECTDOWN          = IECODE_LBUTTON;
    MENUUP              = IECODE_RBUTTON + IECODE_UP_PREFIX;
    MENUDOWN            = IECODE_RBUTTON;
    ALTLEFT             = IEQUALIFIER_LALT;
    ALTRIGHT            = IEQUALIFIER_RALT;
    AMIGALEFT           = IEQUALIFIER_LCOMMAND;
    AMIGARIGHT          = IEQUALIFIER_RCOMMAND;
    AMIGAKEYS           = AMIGALEFT + AMIGARIGHT;

    CURSORUP            = $4C;
    CURSORLEFT          = $4F;
    CURSORRIGHT         = $4E;
    CURSORDOWN          = $4D;
    KEYCODE_Q           = $10;
    KEYCODE_X           = $32;
    KEYCODE_N           = $36;
    KEYCODE_M           = $37;
    KEYCODE_V           = $34;
    KEYCODE_B           = $35;
    KEYCODE_LESS        = $38;
    KEYCODE_GREATER     = $39;


{$I   "Include:Intuition/cgHooks.i"}
{$I   "Include:Intuition/Classes.i"}
{$I   "Include:Utility/Hooks.i"}

{$I   "Include:Intuition/Preferences.i"}
{$I   "Include:Intuition/Screens.i"}

{ Include obsolete identifiers: }
{$I   "Include:Intuition/iobsolete.i"}

Function ActivateGadget(Gadget : GadgetPtr;
                        Window : WindowPtr;
                        Request : RequesterPtr) : Boolean;
    External;

Procedure ActivateWindow(Window : WindowPtr);
    External;

Function AddGadget(Window : WindowPtr;
                   Gadget : GadgetPtr;
                   Position : Short) : Short;
    External;


Function AddGList(Window : WindowPtr; Gadget : GadgetPtr;
                  Position : Short; Numgad : Short;
                  Requester : RequesterPtr) : Short;
    External;

Function AllocRemember(var RememberKey : RememberPtr;
                       Size, Flags : Integer) : Address;
    External;

Function AutoRequest(Window : WindowPtr;
                     BodyText, PositiveText, NegativeText : IntuiTextPtr;
                     PositiveFlags, NegativeFlags : Integer;
                     Width, Height : Short) : Boolean;
    External;

Procedure BeginRefresh(Window : WindowPtr);
    External;

Function BuildSysRequest(window : WindowPtr;
                        BodyText, PositiveText,NegativeText : IntuiTextPtr;
                        IDCMPFlags : Integer;
                        Width, Height : Short) : WindowPtr;
    External;

Function ClearDMRequest(window : WindowPtr) : Boolean;
    External;

Procedure ClearMenuStrip(window : WindowPtr);
    External;

Procedure ClearPointer(window : WindowPtr);
    External;

Procedure CloseScreen(screen : ScreenPtr);
    External;

Procedure CloseWindow(window : WindowPtr);
    External;

FUNCTION CloseWorkBench : Boolean;
    External;

Procedure CurrentTime(var Seconds, Micros : Integer);
    External;

Function DisplayAlert(AlertNumber : Integer;
                        Str : String; Height : Short) : Boolean;
    External;

Procedure DisplayBeep(screen : ScreenPtr);
    External;

Function DoubleClick(StartSecs, StartMicros,
                        CurrentSecs, CurrentMicros : Integer) : Boolean;
    External;

Procedure DrawBorder(rastport : RastPortPtr; Border : BorderPtr;
                        LeftOffset, TopOffset : Short);
    External;

Procedure DrawImage(rastport : RastPortPtr; Image : ImagePtr;
                        LeftOffset, TopOffset : Short);
    External;

Procedure EndRefresh(window : WindowPtr; Complete : Boolean);
    External;

Procedure EndRequest(requester : RequesterPtr; Window : WindowPtr);
    External;

Procedure FreeRemember(var RememberKey : RememberPtr; ReallyForget : Boolean);
    External;

Procedure FreeSysRequest(window : WindowPtr);
    External;

Function GetDefPrefs(PrefBuffer : PreferencesPtr;
                        Size : Short) : PreferencesPtr;
    External;

Function GetPrefs(PrefBuffer : PreferencesPtr; Size : Short) : PreferencesPtr;
    External;

Function GetScreenData(Buffer : Address; Size, SType : Short;
                        Screen : ScreenPtr) : Boolean;
    External;

Procedure InitRequester(requester : RequesterPtr);
    External;

Function IntuiTextLength(IText : IntuiTextPtr) : Integer;
    External;

Function ItemAddress(MenuStrip : MenuPtr; MenuNumber : Short) : MenuItemPtr;
    External;

Function ItemNum(MenuNumber : Short) : Short;
    External;

Function LockIBase(LockNumber : Integer) : Integer;
    External;

Procedure MakeScreen(Screen : ScreenPtr);
    External;

Function MenuNum(MenuNumber : Short) : Short;
    External;

Function ModifyIDCMP(window : WindowPtr; IDCMPFlags : Integer) : Boolean;
    External;

Procedure ModifyProp(gadget : GadgetPtr; window : WindowPtr;
                        requester : RequesterPtr; Flags : Short;
                        HorizPot, VertPot, HorizBody, VertBody : Short);
    External;

Procedure MoveScreen(screen : ScreenPtr; DeltaX, DeltaY : Short);
    External;

Procedure MoveWindow(window : WindowPtr; DeltaX, DeltaY : Short);
    External;

Procedure NewModifyProp(gadget : GadgetPtr; window : WindowPtr;
                        requester : RequesterPtr; Flags : Short;
                        HorizPot, VertPot, HorizBody, VertBody : Short;
                        NumGad : Integer);
    External;

Procedure OffGadget(gadget : GadgetPtr;
                        window : WindowPtr;
                        requester : RequesterPtr);
    External;

Procedure OffMenu(window : WindowPtr; MenuNumber : Short);
    External;

Procedure OnGadget(gadget : GadgetPtr;
                        window : WindowPtr;
                        requester : RequesterPtr);
    External;

Procedure OnMenu(window : WindowPtr; MenuNumber : Short);
    External;

Function OpenScreen(newscreen : NewScreenPtr) : ScreenPtr;
    External;

Function OpenWindow(newwindow : NewWindowPtr) : WindowPtr;
    External;

Function OpenWorkBench : ScreenPtr;
    External;

Procedure PrintIText(rastport : RastPortPtr; IText : IntuiTextPtr;
                        LeftOffset, TopOffset : Short);
    External;

Procedure RefreshGadgets(gadgets : GadgetPtr;
                        window : WindowPtr;
                        requester : RequesterPtr);
    External;

Procedure RefreshGList(gadgets : GadgetPtr; window : WindowPtr;
                        requester : RequesterPtr; NumGad : Short);
    External;

Procedure RefreshWindowFrame(window : WindowPtr);
    External;

Procedure RemakeDisplay;
    External;

Function RemoveGadget(window : WindowPtr; gadget : GadgetPtr) : Short;
    External;

Function RemoveGList(window : WindowPtr; gadget : GadgetPtr;
                        NumGad : Short) : Short;
    External;

Procedure ReportMouse(window : WindowPtr; DoIt : Boolean);
    External;

Function Request(requester : RequesterPtr; window : WindowPtr) : Boolean;
    External;

Procedure RethinkDisplay;
    External;

Procedure ScreenToBack(screen : ScreenPtr);
    External;

Procedure ScreenToFront(screen : ScreenPtr);
    External;

Procedure SetDMRequest(window : WindowPtr; DMRequester : RequesterPtr);
    External;

Function SetMenuStrip(window : WindowPtr; Menu : MenuPtr) : Boolean;
    External;

Procedure SetPointer(window : WindowPtr; pointer : Address;
                        Height, Width, XOffset, YOffset : Short);
    External;

Function SetPrefs(PrefBuffer : PreferencesPtr; Size : Integer;
                        Inform : Boolean) : PreferencesPtr;
    External;


Procedure SetWindowTitles(window : WindowPtr;
                        WindowTitle, ScreenTitle : String);
    External;

Procedure ShowTitle(screen : ScreenPtr; ShowIt : Boolean);
    External;

Procedure SizeWindow(window : WindowPtr; DeltaX, DeltaY : Short);
    External;

Function SubNum(MenuNumber : Short) : Short;
    External;

Procedure UnlockIBase(Lock : Integer);
    External;

Function ViewAddress : ViewPtr;
    External;

Function ViewPortAddress(window : WindowPtr) : ViewPortPtr;
    External;

Function WBenchToBack : Boolean;
    External;

Function WBenchToFront : Boolean;
    External;

Function WindowLimits(window : WindowPtr; MinWidth, MinHeight,
                        MaxWidth, MaxHeight : Short) : Boolean;
    External;

Procedure WindowToBack(window : WindowPtr);
    External;

Procedure WindowToFront(window : WindowPtr);
    External;



{ --- functions in V36 OR higher (distributed as Release 2.0) ---  }

FUNCTION QueryOverscan(DisplayID : Integer; rect : RectAnglePtr; oScanType : Short) : Integer;
 External;

PROCEDURE MoveWindowInFrontOf(win : WindowPtr; behindWin : WindowPtr);
 External;

PROCEDURE ChangeWindowBox(win : WindowPtr;left,top,width,height : Short);
 External;

FUNCTION SetEditHook(h : HookPtr): HookPtr;
 External;

FUNCTION SetMouseQueue(win : WindowPtr; queueLength : Short) : Integer;
 External;

PROCEDURE ZipWindow(Win : windowPtr);
 External;

FUNCTION LockPubScreen(name : String) : ScreenPtr;
 External;

PROCEDURE UnlockPubScreen(name : String; Scr : screenPtr);
 External;

FUNCTION LockPubScreenList : ListPtr;
 External;

PROCEDURE UnlockPubScreenList;
 External;

FUNCTION NextPubScreen(Scr : screenPtr; VAR namebuf : String) : String;
 External;

PROCEDURE SetDefaultPubScreen(name : String);
 External;

FUNCTION SetPubScreenModes(modes : Short) : Short;
 External;

FUNCTION PubScreenStatus(Scr : screenPtr; statusFlags : Short) : Short;
 External;

FUNCTION ObtainGIRPort(gInfo : GadgetInfoPtr) : RastPortPtr;
 External;

PROCEDURE ReleaseGIRPort(rp : RastPortPtr);
 External;

PROCEDURE GadgetMouse(gad : GadgetPtr;gInfo : GadgetInfoPtr; mousePoint : Short);
 External;

PROCEDURE GetDefaultPubScreen(VAR nameBuffer : String);
 External;

FUNCTION EasyRequestArgs(win : WindowPtr;ES : EasyStructPtr; idcmp : Integer; args: Address) : Integer;
 External;

FUNCTION BuildEasyRequestArgs(Win : WindowPtr;ES : easyStructPtr;idcmp : Integer; args : Address) : WindowPtr;
 External;

FUNCTION SysReqHandler(Win : WindowPtr; idcmp : INTEGER; waitInput : BOOLEAN) : INTEGER;
 External;

FUNCTION OpenWindowTagList(nw : NewWindowPtr; TagList : ADDRESS) : WindowPtr;
 External;

FUNCTION OpenScreenTagList(ns : NewScreenPtr; tagList : ADDRESS) : ScreenPtr;
 External;

PROCEDURE DrawImageState(rp : RastPortPtr; im : ImagePtr; leftOffset,topOffset : Short; state : Integer; di : Address);
 External;                                                                                               { DrawInfoPtr }

FUNCTION PointInImage(p : point; im : ImagePtr) : BOOLEAN;
 External;

PROCEDURE EraseImage(rp : RastPortPtr; im : ImagePtr; leftOffset,topOffset : Short);
 External;

FUNCTION NewObjectA(class : IClassPtr; classID : String; tagList : Address) : Address;
 External;

PROCEDURE DisposeObject(object : Address);
 External;

FUNCTION SetAttrsA(object : Address; tagList : Address) : Integer;
 External;

FUNCTION GetAttr(attrID : Integer; object : Address; storage : Address) : Integer;
 External;

FUNCTION SetGadgetAttrsA(Gad : GadgetPtr; Win : WindowPtr; Req : RequesterPtr; tagList : ADDRESS) : INTEGER;
 External;

FUNCTION NextObject(object : Address) : Address;
 External;

FUNCTION MakeClass(classID : String; superClassID : String; superClass : IClassPtr; instanceSize : Short; flags : Integer) : IClassPtr;
 External;

PROCEDURE AddClass(class : IClassPtr);
 External;

FUNCTION GetScreenDrawInfo(Scr : screenPtr) : Address;
 External;                                    { DrawInfoPtr }

PROCEDURE FreeScreenDrawInfo(Scr : screenPtr; di : Address);
 External;                                         { DrawInfoPtr }

FUNCTION ResetMenuStrip(Win : windowPtr; m : menuPtr) : Boolean;
 External;

PROCEDURE RemoveClass(class : IClassPtr);
 External;

FUNCTION FreeClass(class : IClassPtr) : Boolean;
 External;

{ --- functions in V39 or higher (Release 3) --- }

FUNCTION AllocScreenBuffer(Scr : ScreenPtr; BM : BitMapPtr; 
                           flags : Integer) : ScreenBufferPtr;
    External;

PROCEDURE FreeScreenBuffer(Scr : Screen; sb : ScreenBufferPtr);
    External;

FUNCTION ChangeScreenBuffer(Scr : ScreenPtr; sb : ScreenBufferPtr) : Integer;
    External;

PROCEDURE ScreenDepth(Scr : ScreenPtr; flags : Integer; Reserved : Address);
    External;

PROCEDURE ScreenPosition(Scr : ScreenPtr; flags, x1, y1, x2, y2 : Integer);
    External;

PROCEDURE LendMenus(FromWin, ToWin : WindowPtr);
    External;

FUNCTION DoGadgetMethodA(Gad : GadgetPtr; Win : WindowPtr; Req : RequesterPtr;
                         Messga : tMsgPtr) : Integer;
    External;

PROCEDURE SetWindowPointerA(Win : WindowPtr; TagList : Address);
    External;

FUNCTION TimedDisplayAlert(Alertnumber : Integer; Str : String;
                           height, time : Integer) : Boolean;
    External;

PROCEDURE HelpControl(Win : WindowPtr; flags : Integer);
    External;

{ ------------ Functions missing ---------- }

PROCEDURE ScrollWindowRaster(win : WindowPtr; dx, dy, xMin, yMin,
                             xMax, yMax : Integer);
EXTERNAL;

FUNCTION SHIFTITEM (n: INTEGER): Word;
EXTERNAL;

FUNCTION SHIFTMENU (n: INTEGER): Word;
EXTERNAL;

FUNCTION SHIFTSUB (n: INTEGER): Word;
EXTERNAL;

FUNCTION FULLMENUNUM (menu, item, sub: INTEGER): Word;
EXTERNAL;


{
   This are varargs functions to use with PCQ Pascal vers. 2.0 and above
}

{$C+}
PROCEDURE SetWindowPointer(win : WindowPtr; ...);
EXTERNAL;

FUNCTION DoGadgetMethod(gad : GadgetPtr; win : WindowPtr; req : RequesterPtr; ...): INTEGER;
EXTERNAL;

FUNCTION SetGadgetAttrs(gad : GadgetPtr; win : WindowPtr; req : RequesterPtr; ...): INTEGER;
EXTERNAL;

FUNCTION SetAttrs(object : ADDRESS; ...): INTEGER;
EXTERNAL;

FUNCTION OpenScreenTags(ns : NewScreenPtr; ...): ScreenPtr;
EXTERNAL;

FUNCTION OpenWindowTags(ns : NewWindowPtr; ...): WindowPtr;
EXTERNAL;

FUNCTION NewObject(class : IClassPtr; classID : STRING; ...): ADDRESS;
EXTERNAL;

FUNCTION EasyRequest(win : WindowPtr; es : EasyStructPtr; idcmp : INTEGER; ...): INTEGER;
EXTERNAL;

FUNCTION BuildEasyRequest(win : WindowPtr; es : EasyStructPtr; idcmp : INTEGER; ...): WindowPtr;
EXTERNAL;
{$C-}
                         
