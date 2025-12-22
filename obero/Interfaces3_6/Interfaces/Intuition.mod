(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Intuition.mod 40.15 (12.1.95) Oberon 3.6
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Intuition;

IMPORT
  e  * := Exec,
  g  * := Graphics,
  ie * := InputEvent,
  t  * := Timer,
  u  * := Utility,
  km * := KeyMap,
  y := SYSTEM;

TYPE
  MenuPtr          * = UNTRACED POINTER TO Menu;
  MenuItemPtr      * = UNTRACED POINTER TO MenuItem;
  RequesterPtr     * = UNTRACED POINTER TO Requester;
  GadgetPtr        * = UNTRACED POINTER TO Gadget;
  GadSpecialInfoPtr* = UNTRACED POINTER TO GadSpecialInfo;
  BoolInfoPtr      * = UNTRACED POINTER TO BoolInfo;
  PropInfoPtr      * = UNTRACED POINTER TO PropInfo;
  StringInfoPtr    * = UNTRACED POINTER TO StringInfo;
  IntuiTextPtr     * = UNTRACED POINTER TO IntuiText;
  BorderPtr        * = UNTRACED POINTER TO Border;
  ImagePtr         * = UNTRACED POINTER TO Image;
  IntuiMessagePtr  * = UNTRACED POINTER TO IntuiMessage;
  IBoxPtr          * = UNTRACED POINTER TO IBox;
  WindowPtr        * = UNTRACED POINTER TO Window;
  NewWindowPtr     * = UNTRACED POINTER TO NewWindow;
  ExtNewWindowPtr  * = UNTRACED POINTER TO ExtNewWindow;
  RememberPtr      * = UNTRACED POINTER TO Remember;
  ColorSpecPtr     * = UNTRACED POINTER TO ColorSpec;
  EasyStructPtr    * = UNTRACED POINTER TO EasyStruct;
  GadgetInfoPtr    * = UNTRACED POINTER TO GadgetInfo;
  PGXPtr           * = UNTRACED POINTER TO PGX;
  MsgPtr           * = UNTRACED POINTER TO Msg;
  OpSetPtr         * = UNTRACED POINTER TO OpSet;
  OpUpdatePtr      * = UNTRACED POINTER TO OpUpdate;
  OpGetPtr         * = UNTRACED POINTER TO OpGet;
  OpAddTailPtr     * = UNTRACED POINTER TO OpAddTail;
  OpMemberPtr      * = UNTRACED POINTER TO OpMember;
  IClassPtr        * = UNTRACED POINTER TO IClass;
  ClassPtr         * = IClassPtr;
  ObjectPtr        * = UNTRACED POINTER TO Object;
  HitTestPtr       * = UNTRACED POINTER TO HitTest;
  RenderPtr        * = UNTRACED POINTER TO Render;
  InputPtr         * = UNTRACED POINTER TO Input;
  GoInactivePtr    * = UNTRACED POINTER TO GoInactive;
  FrameBoxPtr      * = UNTRACED POINTER TO FrameBox;
  DrawPtr          * = UNTRACED POINTER TO Draw;
  ErasePtr         * = UNTRACED POINTER TO Erase;
  IMHitTestPtr     * = UNTRACED POINTER TO IMHitTest;
  PreferencesPtr   * = UNTRACED POINTER TO Preferences;
  DrawInfoPtr      * = UNTRACED POINTER TO DrawInfo;
  ScreenPtr        * = UNTRACED POINTER TO Screen;
  NewScreenPtr     * = UNTRACED POINTER TO NewScreen;
  ExtNewScreenPtr  * = UNTRACED POINTER TO ExtNewScreen;
  PubScreenNodePtr * = UNTRACED POINTER TO PubScreenNode;
  StringExtendPtr  * = UNTRACED POINTER TO StringExtend;
  SGWorkPtr        * = UNTRACED POINTER TO SGWork;
  IntuitionBasePtr * = UNTRACED POINTER TO IntuitionBase;
  GadgetDummyPtr   * = UNTRACED POINTER TO GadgetDummy;
  ExtGadgetPtr     * = UNTRACED POINTER TO ExtGadget;
  ExtIntuiMessagePtr * = UNTRACED POINTER TO ExtIntuiMessage;
  TabletDataPtr    * = UNTRACED POINTER TO TabletData;
  TabletHookDataPtr * = UNTRACED POINTER TO TabletHookData;
  LayoutPtr        * = UNTRACED POINTER TO Layout;
  ScreenBufferPtr  * = UNTRACED POINTER TO ScreenBuffer;
  DRIPenArrayPtr   * = UNTRACED POINTER TO DRIPenArray;

CONST
  intuitionName * = "intuition.library";

TYPE
(* ======================================================================== *)
(* === Menu =============================================================== *)
(* ======================================================================== *)
  Menu * = STRUCT
    nextMenu * : MenuPtr;             (* same level *)
    leftEdge * , topEdge * : INTEGER; (* position of the select box *)
    width * , height * : INTEGER;     (* dimensions of the select box *)
    flags * : SET;                    (* see flag definitions below *)
    menuName * : e.LSTRPTR;           (* text for this Menu Header *)
    firstItem * : MenuItemPtr;        (* pointer to first in chain *)

    (* these mysteriously-named variables are for internal use only *)
    jazzX * , jazzY * , beatX * , beatY * : INTEGER;
  END;

CONST

(* FLAGS SET BY BOTH THE APPLIPROG AND INTUITION *)
  menuEnabled * = 0;      (* whether or not this menu is enabled *)

(* FLAGS SET BY INTUITION *)
  miDrawn * = 8;          (* this menu's items are currently drawn *)


TYPE
(* ======================================================================== *)
(* === MenuItem =========================================================== *)
(* ======================================================================== *)
  MenuItem * = STRUCT
    nextItem * : MenuItemPtr;            (* pointer to next in chained list *)
    leftEdge * , topEdge * : INTEGER;    (* position of the select box *)
    width * , height * : INTEGER;        (* dimensions of the select box *)
    flags * : SET;                       (* see the defines below *)

    mutualExclude * : LONGSET;           (* set bits mean this item excludes that *)

    itemFill * : e.APTR;                 (* points to Image, IntuiText, or NULL *)

    (* when this item is pointed to by the cursor and the items highlight
     *  mode HIGHIMAGE is selected, this alternate image will be displayed
     *)
    selectFill * : e.APTR;               (* points to Image, IntuiText, or NULL *)

    command * : CHAR;                    (* only if appliprog sets the COMMSEQ flag *)

    subItem * : MenuItemPtr;             (* if non-zero, points to MenuItem for submenu *)

    (* The NextSelect field represents the menu number of next selected
     *  item (when user has drag-selected several items)
     *)
    nextSelect * : INTEGER;
  END;

CONST

(* FLAGS SET BY THE APPLIPROG *)
  checkIt         * = 0;  (* set to indicate checkmarkable item *)
  itemText        * = 1;  (* set if textual, clear if graphical item *)
  commSeq         * = 2;  (* set if there's an command sequence *)
  menuToggle      * = 3;  (* set for toggling checks (else mut. exclude) *)
  itemEnabled     * = 4;  (* set if this item is enabled *)

(* these are the SPECIAL HIGHLIGHT FLAG state meanings *)
  highFlags       * = {6,7};               (* see definitions below for these bits *)
  highImage       * = {};                  (* use the user's "select image" *)
  highComp        * = 6;                   (* highlight by complementing the selectbox *)
  highBox         * = 7;                   (* highlight by "boxing" the selectbox *)
  highNone        * = {highBox,highComp};  (* don't highlight *)

(* FLAGS SET BY BOTH APPLIPROG AND INTUITION *)
  checked         * = 8;  (* state of the checkmark *)

(* FLAGS SET BY INTUITION *)
  isDrawn         * = 12; (* this item's subs are currently drawn *)
  highItem        * = 13; (* this item is currently highlighted *)
  menuToggled     * = 14; (* this item was already toggled *)


TYPE
(* ======================================================================== *)
(* === Requester ========================================================== *)
(* ======================================================================== *)
  Requester * = STRUCT
    olderRequest * : RequesterPtr;
    leftEdge * , topEdge * : INTEGER;   (* dimensions of the entire box *)
    width * , height * : INTEGER;       (* dimensions of the entire box *)
    relLeft * , relTop * : INTEGER;     (* for Pointer relativity offsets *)

    reqGadget * : GadgetDummyPtr;       (* pointer to a list of Gadgets *)
    reqBorder * : BorderPtr;            (* the box's border *)
    reqText   * : IntuiTextPtr;         (* the box's text *)
    flags * : SET;                      (* see definitions below *)

    (* pen number for back-plane fill before draws *)
    backFill * : SHORTINT;
    (* Layer in place of clip rect      *)
    reqLayer * : g.LayerPtr;

    reqPad1 * : ARRAY 32 OF e.BYTE;

    (* If the BitMap plane pointers are non-zero, this tells the system
     * that the image comes pre-drawn (if the appliprog wants to define
     * its own box, in any shape or size it wants!);  this is OK by
     * Intuition as long as there's a good correspondence between
     * the image and the specified Gadgets
     *)
    imageBMap * : g.BitMapPtr;          (* points to the BitMap of PREDRAWN imagery *)
    rWindow * : WindowPtr;              (* added.  points back to Window *)

    reqImage * : ImagePtr;              (* new for V36: drawn if USEREQIMAGE set *)

    reqPad2 * : ARRAY 32 OF e.BYTE;
  END;


CONST

(* FLAGS SET BY THE APPLIPROG *)
  pointRel        * = 0;
                          (* if POINTREL set, TopLeft is relative to pointer
                           * for DMRequester, relative to window center
                           * for Request().
                           *)
  preDrawn        * = 1;
        (* set if Requester.ImageBMap points to predrawn Requester imagery *)
  noisyReq        * = 2;
        (* if you don't want requester to filter input     *)
  simpleReq       * = 4;
        (* to use SIMPLEREFRESH layer (recommended)     *)

(* New for V36          *)
  useReqImage     * = 5;
        (*  render linked list ReqImage after BackFill
         * but before gadgets and text
         *)
  noReqBackFill   * = 6;
        (* don't bother filling requester with Requester.BackFill pen   *)


(* FLAGS SET BY INTUITION *)
  reqOffWindow    * = 12; (* part of one of the Gadgets was offwindow *)
  reqActive       * = 13; (* this requester is active *)
  sysRequest      * = 14; (* this requester caused by system *)
  deferRefresh    * = 15; (* this Requester stops a Refresh broadcast *)


TYPE
(* ======================================================================== *)
(* === Gadget ============================================================= *)
(* ======================================================================== *)

  GadgetDummy * = STRUCT END;    (* dummy base type for Gadget and ExtGadget *)
  GadSpecialInfo * = STRUCT END; (* dummy base type of all SpecialInfos *)

  Gadget * = STRUCT (dummy *: GadgetDummy)
    nextGadget * : GadgetDummyPtr;    (* next gadget in the list *)

    leftEdge * , topEdge * : INTEGER; (* "hit box" of gadget *)
    width * , height * : INTEGER;     (* "hit box" of gadget *)

    flags * : SET;                    (* see below for list of defines *)

    activation * : SET;               (* see below for list of defines *)

    gadgetType * : INTEGER;           (* see below for defines *)

    (* appliprog can specify that the Gadget be rendered as either as Border
     * or an Image.  This variable points to which (or equals NULL if there's
     * nothing to be rendered about this Gadget)
     *)
    gadgetRender * : e.APTR;

    (* appliprog can specify "highlighted" imagery rather than algorithmic
     * this can point to either Border or Image data
     *)
    selectRender * : e.APTR;

    gadgetText * : IntuiTextPtr;      (* text for this gadget *)

    (* MutualExclude, never implemented, is now declared obsolete.
     * There are published examples of implementing a more general
     * and practical exclusion in your applications.
     *
     * Starting with V36, this field is used to point to a hook
     * for a custom gadget.
     *
     * Programs using this field for their own processing will
     * continue to work, as long as they don't try the
     * trick with custom gadgets.
     *)
    mutualExclude * : LONGSET;        (* obsolete *)

    (* pointer to a structure of special data required by Proportional,
     * String and Integer Gadgets
     *)
    specialInfo * : GadSpecialInfoPtr;

    gadgetID * : INTEGER;             (* user-definable ID field *)
    userData * : e.APTR;              (* ptr to general purpose User data (ignored by In) *)
  END;


TYPE
  ExtGadget * = STRUCT (dummy *: GadgetDummy)
    nextGadget * : GadgetDummyPtr;     (* Matches struct Gadget *)
    leftEdge * , topEdge * : INTEGER;  (* Matches struct Gadget *)
    width * , height * : INTEGER;      (* Matches struct Gadget *)
    flags * : SET;                     (* Matches struct Gadget *)
    activation * : SET;                (* Matches struct Gadget *)
    gadgetType * : INTEGER;            (* Matches struct Gadget *)
    gadgetRender * : e.APTR;           (* Matches struct Gadget *)
    selectRender * : e.APTR;           (* Matches struct Gadget *)
    gadgetText * : IntuiTextPtr;       (* Matches struct Gadget *)
    mutualExclude * : LONGSET;         (* Matches struct Gadget *)
    specialInfo * : GadSpecialInfoPtr; (* Matches struct Gadget *)
    gadgetID * : INTEGER;              (* Matches struct Gadget *)
    userData * : e.APTR;               (* Matches struct Gadget *)

    (* These fields only exist under V39 and only if GFLG_EXTENDED is set *)
    moreFlags      * : LONGSET;        (* see GMORE_ flags below *)
    boundsLeftEdge * : INTEGER;        (* Bounding extent for gadget, valid   *)
    boundsTopEdge  * : INTEGER;        (* only if GMORE_BOUNDS is set.  The   *)
    boundsWidth    * : INTEGER;        (* GFLG_RELxxx flags affect these      *)
    boundsHeight   * : INTEGER;        (* coordinates as well.        *)
  END;

CONST
(* --- Gadget.Flags values      --- *)
(* combinations in these bits describe the highlight technique to be used *)
  gadgHighBits * = {0,1};
  gadgHComp    * = {};    (* Complement the select box *)
  gadgHBox     * = 0;     (* Draw a box around the image *)
  gadgHImage   * = 1;     (* Blast in this alternate image *)
  gadgHNone    * = {0,1}; (* don't highlight *)

  gadgImage    * = 2;  (* set if GadgetRender and SelectRender
                        * point to an Image structure, clear
                        * if they point to Border structures
                        *)

(*  combinations in these next two bits specify to which corner the gadget's
 *  Left & Top coordinates are relative.  If relative to Top/Left,
 *  these are "normal" coordinates (everything is relative to something in
 *  this universe).
 *
 * Gadget positions and dimensions are relative to the window or
 * requester which contains the gadget
 *)
  gRelBottom    * = 3;  (* vert. pos. is relative to bottom edge *)
  gRelRight     * = 4;  (* horiz. pos. is relative to right edge *)
  gRelWidth     * = 5;  (* width is relative to req/window    *)
  gRelHeight    * = 6;  (* height is relative to req/window   *)

(* New for V39: GFLG_RELSPECIAL allows custom gadget implementors to
 * make gadgets whose position and size depend in an arbitrary way
 * on their window's dimensions.  The GM_LAYOUT method will be invoked
 * for such a gadget (or any other GREL_xxx gadget) at suitable times,
 * such as when the window opens or the window's size changes.
 *)
  gRelSpecial * =  14;  (* custom gadget has special relativity.
                         * Gadget box values are absolutes, but
                         * can be changed via the GM_LAYOUT method.
                         *)
  selected     * = 7;  (* you may initialize and look at this        *)

(* the GFLG_DISABLED flag is initialized by you and later set by Intuition
 * according to your calls to On/OffGadget().  It specifies whether or not
 * this Gadget is currently disabled from being selected
 *)
  gadgDisabled * = 8;

(* These flags specify the type of text field that Gadget.GadgetText
 * points to.  In all normal (pre-V36) gadgets which you initialize
 * this field should always be zero.  Some types of gadget objects
 * created from classes will use these fields to keep track of
 * types of labels/contents that different from IntuiText, but are
 * stashed in GadgetText.
 *)

  labelMask    * = {12,13};
  labelIText   * = {}; (* GadgetText points to IntuiText     *)
  labelString  * = 12; (* GadgetText points to STRING        *)
  labelImage   * = 13; (* GadgetText points to Image (object)        *)
(* New for V37: GFLG_TABCYCLE *)
  tabCycle     * =  9; (* (string or custom) gadget participates in
                        * cycling activation with Tab or Shift-Tab
                        *)
(* New for V37: GFLG_STRINGEXTEND.  We discovered that V34 doesn't properly
 * ignore the value we had chosen for the Gadget->Activation flag
 * GACT_STRINGEXTEND.  NEVER SET THAT FLAG WHEN RUNNING UNDER V34.
 * The Gadget->Flags bit GFLG_STRINGEXTEND is provided as a synonym which is
 * safe under V34, and equivalent to GACT_STRINGEXTEND under V37.
 * (Note that the two flags are not numerically equal)
 *)
  stringExtend * = 10; (* this String Gadget has StringExtend        *)

(* New for V39: GFLG_IMAGEDISABLE.  This flag is automatically set if
 * the custom image of this gadget knows how to do disabled rendering
 * (more specifically, if its IA_SupportsDisable attribute is TRUE).
 * Intuition uses this to defer the ghosting to the image-class,
 * instead of doing it itself (the old compatible way).
 * Do not set this flag yourself - Intuition will do it for you.
 *)

  gImagedisable * = 11;  (* Gadget's image knows how to do disabled
                          * rendering
                          *)

(* New for V39:  If set, this bit means that the Gadget is actually
 * a struct ExtGadget, with new fields and flags.  All V39 boopsi
 * gadgets are ExtGadgets.  Never ever attempt to read the extended
 * fields of a gadget if this flag is not set.
 *)
  gExtended     * =  15;  (* Gadget is extended *)


(* ---  Gadget.Activation flag values   --- *)
(* Set GACT_RELVERIFY if you want to verify that the pointer was still over
 * the gadget when the select button was released.  Will cause
 * an IDCMP_GADGETUP message to be sent if so.
 *)
  relVerify    * = 0;

(* the flag GACT_IMMEDIATE, when set, informs the caller that the gadget
 *  was activated when it was activated.  This flag works in conjunction with
 *  the GACT_RELVERIFY flag
 *)
  gadgImmediate* = 1;

(* the flag GACT_ENDGADGET, when set, tells the system that this gadget,
 * when selected, causes the Requester to be ended.  Requesters
 * that are ended are erased and unlinked from the system.
 *)
  endGadget    * = 2;

(* the GACT_FOLLOWMOUSE flag, when set, specifies that you want to receive
 * reports on mouse movements while this gadget is active.
 * You probably want to set the GACT_IMMEDIATE flag when using
 * GACT_FOLLOWMOUSE, since that's the only reasonable way you have of
 * learning why Intuition is suddenly sending you a stream of mouse
 * movement events.  If you don't set GACT_RELVERIFY, you'll get at
 * least one Mouse Position event.
 *)
  followMouse  * = 3;

(* if any of the BORDER flags are set in a Gadget that's included in the
 * Gadget list when a Window is opened, the corresponding Border will
 * be adjusted to make room for the Gadget
 *)
  rightBorder  * = 4;
  leftBorder   * = 5;
  topBorder    * = 6;
  bottomBorder * = 7;
  borderSniff  * = 15;  (* neither set nor rely on this bit   *)

  toggleSelect * = 8;   (* this bit for toggle-select mode *)
  boolExtend   * = 13;  (* this Boolean Gadget has a BoolInfo *)

(* should properly be in StringInfo, but aren't *)
  stringLeft   * = {};  (* NOTE WELL: that this has value zero        *)
  stringCenter * = 9;
  stringRight  * = 10;
  longint      * = 11;  (* this String Gadget is for Long Ints        *)
  altKeyMap    * = 12;  (* this String has an alternate keymap        *)
  actStringExtend * = 13;  (* this String Gadget has StringExtend        *)
                        (* NOTE: NEVER SET GACT_STRINGEXTEND IF YOU
                         * ARE RUNNING ON LESS THAN V36!  SEE
                         * GFLG_STRINGEXTEND (ABOVE) INSTEAD
                         *)


  activeGadget * = 14; (* this gadget is "active".  This flag
                        * is maintained by Intuition, and you
                        * cannot count on its value persisting
                        * while you do something on your program's
                        * task.  It can only be trusted by
                        * people implementing custom gadgets
                        *)

(* note 0x8000 is used above (GACT_BORDERSNIFF);
 * all Activation flags defined *)

(* --- GADGET TYPES ------------------------------------------------------- *)
(* These are the Gadget Type definitions for the variable GadgetType
 * gadget number type MUST start from one.  NO TYPES OF ZERO ALLOWED.
 * first comes the mask for Gadget flags reserved for Gadget typing
 *)
  gadgetType * = 0FC00U;  (* all Gadget Global Type flags (padded) *)
  scrGadget  * = 04000U;  (* 1 = ScreenGadget, 0 = WindowGadget *)
  gzzGadget  * = 02000U;  (* 1 = for WFLG_GIMMEZEROZERO borders *)
  reqGadget  * = 01000U;  (* 1 = this is a Requester Gadget *)

(* GTYP_SYSGADGET means that Intuition ALLOCATED the gadget.
 * GTYP_SYSTYPEMASK is the mask you can apply to tell what type of
 * system-gadget it is.  The possible types follow.
 *)

  sysGadget   * = 08000U;
  sysTypeMask * = 000F0U;

(* These definitions describe system gadgets in V36 and higher: *)
  sizing     * = 00010U;   (* Window sizing gadget *)
  wDragging  * = 00020U;   (* Window drag bar      *)
  sDragging  * = 00030U;   (* Screen drag bar      *)
  wDepth     * = 00040U;   (* Window depth gadget  *)
  sDepth     * = 00050U;   (* Screen depth gadget  *)
  wZoom      * = 00060U;   (* Window zoom gadget   *)
  sUnused    * = 00070U;   (* Unused screen gadget *)
  close      * = 00080U;   (* Window close gadget  *)

(* These definitions describe system gadgets prior to V36: *)
  wUpFront   * = wDepth;   (* Window to-front gadget *)
  sUpFront   * = sDepth;   (* Screen to-front gadget *)
  wDownBack  * = wZoom;    (* Window to-back gadget  *)
  sDownBack  * = sUnused;  (* Screen to-back gadget  *)

  gTypeMask    * = 00007U;

  boolGadget   * = 00001U;
  gadget0002   * = 00002U;
  propGadget   * = 00003U;
  strGadget    * = 00004U;
  customGadget * = 00005U;

(* This bit in GadgetType is reserved for undocumented internal use
 * by the Gadget Toolkit, and cannot be used nor relied on by
 * applications:        0x0100
 *)

(* New for V39.  Gadgets which have the GFLG_EXTENDED flag set are
 * actually ExtGadgets, which have more flags.        The GMORE_xxx
 * identifiers describe those flags.  For GMORE_SCROLLRASTER, see
 * important information in the ScrollWindowRaster() autodoc.
 * NB: GMORE_SCROLLRASTER must be set before the gadget is
 * added to a window.
 *)
  gmoreBounds       * =  0; (* ExtGadget has valid Bounds *)
  gmoreGadgetHelp   * =  1; (* This gadget responds to gadget help *)
  gmoreScrollRaster * =  2; (* This (custom) gadget uses ScrollRaster *)


TYPE
(* ======================================================================== *)
(* === BoolInfo =========================================================== *)
(* ======================================================================== *)
(* This is the special data needed by an Extended Boolean Gadget
 * Typically this structure will be pointed to by the Gadget field SpecialInfo
 *)
  BoolInfo * = STRUCT (dummy *: GadSpecialInfo)
    flags * : SET;        (* defined below *)
    mask * : e.APTR;      (* bit mask for highlighting and selecting
                           * mask must follow the same rules as an Image
                           * plane.  Its width and height are determined
                           * by the width and height of the gadget's
                           * select box. (i.e. Gadget.Width and .Height).
                           *)
    reserved * : LONGINT; (* set to 0     *)
  END;

CONST

(* set BoolInfo.Flags to this flag bit.
 * in the future, additional bits might mean more stuff hanging
 * off of BoolInfo.Reserved.
 *)
  boolMask * = 0;   (* extension is for masked gadget *)


TYPE
(* ======================================================================== *)
(* === PropInfo =========================================================== *)
(* ======================================================================== *)
(* this is the special data required by the proportional Gadget
 * typically, this data will be pointed to by the Gadget variable SpecialInfo
 *)
  PropInfo * = STRUCT (dummy *: GadSpecialInfo)
    flags * : SET;        (* general purpose flag bits (see defines below) *)

    (* You initialize the Pot variables before the Gadget is added to
     * the system.  Then you can look here for the current settings
     * any time, even while User is playing with this Gadget.  To
     * adjust these after the Gadget is added to the System, use
     * ModifyProp();  The Pots are the actual proportional settings,
     * where a value of zero means zero and a value of MAXPOT means
     * that the Gadget is set to its maximum setting.
     *)
    horizPot * : INTEGER; (* 16-bit FixedPoint horizontal quantity percentage *)
    vertPot * : INTEGER;  (* 16-bit FixedPoint vertical quantity percentage *)

    (* the 16-bit FixedPoint Body variables describe what percentage of
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
     *)
    horizBody * : INTEGER;           (* horizontal Body *)
    vertBody * : INTEGER;            (* vertical Body *)

    (* these are the variables that Intuition sets and maintains *)
    cWidth * : INTEGER;      (* Container width (with any relativity absoluted) *)
    cHeight * : INTEGER;     (* Container height (with any relativity absoluted) *)
    hPotRes * , vPotRes * : INTEGER; (* pot increments *)
    leftBorder * : INTEGER;          (* Container borders *)
    topBorder * : INTEGER;           (* Container borders *)
  END;

CONST

(* --- FLAG BITS ---------------------------------------------------------- *)
  autoKnob        * = 0;    (* this flag sez:  gimme that old auto-knob *)
(* NOTE: if you do not use an AUTOKNOB for a proportional gadget,
 * you are currently limited to using a single Image of your own
 * design: Intuition won't handle a linked list of images as
 * a proportional gadget knob.
 *)

  freeHoriz       * = 1;  (* if set, the knob can move horizontally *)
  freeVert        * = 2;  (* if set, the knob can move vertically *)
  propBorderless  * = 3;  (* if set, no border will be rendered *)
  knobHit         * = 8;  (* set when this Knob is hit *)
  propNewLook     * = 4;  (* set this if you want to get the new
                           * V36 look
                           *)

  knobHmin   * = 6;  (* minimum horizontal size of the Knob *)
  knobVmin   * = 4;  (* minimum vertical size of the Knob *)
  maxBody    * = 0FFFFU;  (* maximum body value *)
  maxPot     * = 0FFFFU;  (* maximum pot value *)


TYPE
(* ======================================================================== *)
(* === StringInfo ========================================================= *)
(* ======================================================================== *)
(* this is the special data required by the string Gadget
 * typically, this data will be pointed to by the Gadget variable SpecialInfo
 *)
  StringInfo * = STRUCT (dummy *: GadSpecialInfo)
    (* you initialize these variables, and then Intuition maintains them *)
    buffer * : e.LSTRPTR;     (* the buffer containing the start and final string *)
    undoBuffer * : e.LSTRPTR; (* optional buffer for undoing current entry *)
    bufferPos * : INTEGER;    (* character position in Buffer *)
    maxChars * : INTEGER;     (* max number of chars in Buffer (including NULL) *)
    dispPos * : INTEGER;      (* Buffer position of first displayed character *)

    (* Intuition initializes and maintains these variables for you *)
    undoPos * : INTEGER;      (* character position in the undo buffer *)
    numChars * : INTEGER;     (* number of characters currently in Buffer *)
    dispCount * : INTEGER;    (* number of whole characters visible in Container *)
    cLeft * , cTop * : INTEGER;  (* topleft offset of the container *)

    (* This unused field is changed to allow extended specification
     * of string gadget parameters.  It is ignored unless the flag
     * GACT_STRINGEXTEND is set in the Gadget's Activation field
     * or the GFLG_STRINGEXTEND flag is set in the Gadget Flags field.
     * (See GFLG_STRINGEXTEND for an important note)
     *)
    (* layerPtr * : LayerPtr;  --- obsolete --- *)
    extension * : StringExtendPtr;

    (* you can initialize this variable before the gadget is submitted to
     * Intuition, and then examine it later to discover what integer
     * the user has entered (if the user never plays with the gadget,
     * the value will be unchanged from your initial setting)
     *)
    longInt * : LONGINT;

    (* If you want this Gadget to use your own Console keymapping, you
     * set the GACT_ALTKEYMAP bit in the Activation flags of the Gadget,
     * and then set this variable to point to your keymap.  If you don't
     * set the GACT_ALTKEYMAP, you'll get the standard ASCII keymapping.
     *)
    altKeyMap * : km.KeyMapPtr;
  END;


(* ======================================================================== *)
(* === IntuiText ========================================================== *)
(* ======================================================================== *)
(* IntuiText is a series of strings that start with a location
 *  (always relative to the upper-left corner of something) and then the
 *  text of the string.  The text is null-terminated.
 *)
  IntuiText * = STRUCT
    frontPen * , backPen * : SHORTINT; (* the pen numbers for the rendering *)
    drawMode * : SHORTSET;             (* the mode for rendering the text *)
    leftEdge * : INTEGER;              (* relative start location for the text *)
    topEdge * : INTEGER;               (* relative start location for the text *)
    iTextFont * : g.TextAttrPtr;       (* if NULL, you accept the default *)
    iText * : e.LSTRPTR;               (* pointer to null-terminated text *)
    nextText * : IntuiTextPtr;         (* pointer to another IntuiText to render *)
  END;


(* ======================================================================== *)
(* === Border ============================================================= *)
(* ======================================================================== *)
(* Data type Border, used for drawing a series of lines which is intended for
 *  use as a border drawing, but which may, in fact, be used to render any
 *  arbitrary vector shape.
 *  The routine DrawBorder sets up the RastPort with the appropriate
 *  variables, then does a Move to the first coordinate, then does Draws
 *  to the subsequent coordinates.
 *  After all the Draws are done, if NextBorder is non-zero we call DrawBorder
 *  on NextBorder
 *)
  Border * = STRUCT
    leftEdge * , topEdge * : INTEGER;  (* initial offsets from the origin *)
    frontPen * , backPen * : SHORTINT; (* pens numbers for rendering *)
    drawMode * : SHORTSET;             (* mode for rendering *)
    count * : SHORTINT;                (* number of XY pairs *)
    xy * : e.APTR;                     (* vector coordinate pairs rel to LeftTop*)
    nextBorder * : BorderPtr;          (* pointer to any other Border too *)
  END;


(* ======================================================================== *)
(* === Image ============================================================== *)
(* ======================================================================== *)
(* This is a brief image structure for very simple transfers of
 * image data to a RastPort
 *)
  Image * = STRUCT
    leftEdge * : INTEGER;             (* starting offset relative to some origin *)
    topEdge * : INTEGER;              (* starting offsets relative to some origin *)
    width * : INTEGER;                (* pixel size (though data is word-aligned) *)
    height * : INTEGER;
    depth * : INTEGER;                (* >= 0, for images you create          *)
    imageData * : e.APTR;             (* pointer to the actual word-aligned bits *)

    (* the PlanePick and PlaneOnOff variables work much the same way as the
     * equivalent GELS Bob variables.  It's a space-saving
     * mechanism for image data.  Rather than defining the image data
     * for every plane of the RastPort, you need define data only
     * for the planes that are not entirely zero or one.  As you
     * define your Imagery, you will often find that most of the planes
     * ARE just as color selectors.  For instance, if you're designing
     * a two-color Gadget to use colors one and three, and the Gadget
     * will reside in a five-plane display, bit plane zero of your
     * imagery would be all ones, bit plane one would have data that
     * describes the imagery, and bit planes two through four would be
     * all zeroes.  Using these flags avoids wasting all
     * that memory in this way:  first, you specify which planes you
     * want your data to appear in using the PlanePick variable.  For
     * each bit set in the variable, the next "plane" of your image
     * data is blitted to the display.  For each bit clear in this
     * variable, the corresponding bit in PlaneOnOff is examined.
     * If that bit is clear, a "plane" of zeroes will be used.
     * If the bit is set, ones will go out instead.  So, for our example:
     *   Gadget.PlanePick = 0x02;
     *   Gadget.PlaneOnOff = 0x01;
     * Note that this also allows for generic Gadgets, like the
     * System Gadgets, which will work in any number of bit planes.
     * Note also that if you want an Image that is only a filled
     * rectangle, you can get this by setting PlanePick to zero
     * (pick no planes of data) and set PlaneOnOff to describe the pen
     * color of the rectangle.
     *
     * NOTE:  Intuition relies on PlanePick to know how many planes
     * of data are found in ImageData.  There should be no more
     * '1'-bits in PlanePick than there are planes in ImageData.
     *)
    planePick * , planeOnOff * : SHORTSET;

    (* if the NextImage variable is not NULL, Intuition presumes that
     * it points to another Image structure with another Image to be
     * rendered
     *)
    nextImage * : ImagePtr;
  END;


(* ======================================================================== *)
(* === IntuiMessage ======================================================= *)
(* ======================================================================== *)
  IntuiMessage * = STRUCT (execMessage * : e.Message)

    (* the Class bits correspond directly with the IDCMP Flags, except for the
     * special bit IDCMP_LONELYMESSAGE (defined below)
     *)
    class * : LONGSET;

    (* the Code field is for special values like MENU number *)
    code * : INTEGER;

    (* the Qualifier field is a copy of the current InputEvent's Qualifier *)
    qualifier * : SET;

    (* IAddress contains particular addresses for Intuition functions, like
     * the pointer to the Gadget or the Screen
     *)
    iAddress * : e.APTR;

    (* when getting mouse movement reports, any event you get will have the
     * the mouse coordinates in these variables.  the coordinates are relative
     * to the upper-left corner of your Window (WFLG_GIMMEZEROZERO
     * notwithstanding).  If IDCMP_DELTAMOVE is set, these values will
     * be deltas from the last reported position.
     *)
    mouseX * , mouseY * : INTEGER;

    (* the time values are copies of the current system clock time.  Micros
     * are in units of microseconds, Seconds in seconds.
     *)
    time * : t.TimeVal;

    (* the IDCMPWindow variable will always have the address of the Window of
     * this IDCMP
     *)
    idcmpWindow * : WindowPtr;

    (* system-use variable *)
    specialLink * : IntuiMessagePtr;
  END;

(* New for V39:
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
 *)

  ExtIntuiMessage * = STRUCT (intuiMessage *: IntuiMessage)
    tabletData * : TabletDataPtr;
  END;


CONST
(* --- IDCMP Classes ------------------------------------------------------ *)
(* Please refer to the Autodoc for OpenWindow() and to the Rom Kernel
 * Manual for full details on the IDCMP classes.
 *)
  sizeVerify        * = 0;
  newSize           * = 1;
  refreshWindow     * = 2;
  mouseButtons      * = 3;
  mouseMove         * = 4;
  gadgetDown        * = 5;
  gadgetUp          * = 6;
  reqSet            * = 7;
  menuPick          * = 8;
  closeWindow       * = 9;
  rawKey            * = 10;
  reqVerify         * = 11;
  reqClear          * = 12;
  menuVerify        * = 13;
  newPrefs          * = 14;
  diskInserted      * = 15;
  diskRemoved       * = 16;
  wbenchMessage       = 17;  (*  System use only         *)
  activeWindow      * = 18;
  inactiveWindow    * = 19;
  deltaMove         * = 20;
  vanillaKey        * = 21;
  intuiTicks        * = 22;
(* for notifications from "boopsi" gadgets       *)
  idcmpUpdate       * = 23;  (* new for V36      *)
(* for getting help key report during menu session  *)
  menuHelp          * = 24;  (* new for V36      *)
(* for notification of any move/size/zoom/change window *)
  changeWindow      * = 25;  (* new for V36      *)
  gadgetHelp        * = 26;  (* new for V39      *)

(* NOTEZ-BIEN:          31   is reserved for internal use   *)

(* the IDCMP Flags do not use this special bit, which is cleared when
 * Intuition sends its special message to the Task, and set when Intuition
 * gets its Message back from the Task.  Therefore, I can check here to
 * find out fast whether or not this Message is available for me to send
 *)
  lonelyMessage     * = 31;


(* --- IDCMP Codes -------------------------------------------------------- *)
(* This group of codes is for the IDCMP_CHANGEWINDOW message *)
  cwcodeMoveSize * =  0000H;  (* Window was moved and/or sized *)
  cwcodeDepth    * =  0001H;  (* Window was depth-arranged (new for V39) *)

(* This group of codes is for the IDCMP_MENUVERIFY function *)
  menuHot         * = 0001H;  (* Intui wants verification or MENUCANCEL   *)
  menuCancel      * = 0002H;  (* HOT Reply of this cancels Menu operation *)
  menuWaiting     * = 0003H;  (* Intuition simply wants a ReplyMsg() ASAP *)

(* These are internal tokens to represent state of verification attempts
 * shown here as a clue.
 *)
  okOk            * = menuHot;    (* guy didn't care                      *)
  okAbort         * = 0004H;      (* window rendered question moot        *)
  okCancel        * = menuCancel; (* window sent cancel reply          *)

(* This group of codes is for the IDCMP_WBENCHMESSAGE messages *)
  wbenchOpen      * = 0001H;
  wbenchClose     * = 0002H;


TYPE

(* A data structure common in V36 Intuition processing   *)
  IBox * = STRUCT
    left * : INTEGER;
    top * : INTEGER;
    width * : INTEGER;
    height * : INTEGER;
  END;


(* ======================================================================== *)
(* === Window ============================================================= *)
(* ======================================================================== *)
  Window * = STRUCT
    nextWindow * : WindowPtr;           (* for the linked list in a screen *)

    leftEdge * , topEdge * : INTEGER;   (* screen dimensions of window *)
    width * , height * : INTEGER;       (* screen dimensions of window *)

    mouseY * , mouseX * : INTEGER;      (* relative to upper-left of window *)

    minWidth * , minHeight * : INTEGER; (* minimum sizes *)
    maxWidth * , maxHeight * : INTEGER; (* maximum sizes *)

    flags * : LONGSET;                  (* see below for defines *)

    menuStrip * : MenuPtr;              (* the strip of Menu headers *)

    title * : e.LSTRPTR;                (* the title text for this window *)

    firstRequest * : RequesterPtr;      (* all active Requesters *)

    dmRequest * : RequesterPtr;         (* double-click Requester *)

    reqCount * : INTEGER;               (* count of reqs blocking Window *)

    wScreen * : ScreenPtr;              (* this Window's Screen *)
    rPort * : g.RastPortPtr;            (* this Window's very own RastPort *)

    (* the border variables describe the window border.  If you specify
     * WFLG_GIMMEZEROZERO when you open the window, then the upper-left of
     * the ClipRect for this window will be upper-left of the BitMap (with
     * correct offsets when in SuperBitMap mode; you MUST select
     * WFLG_GIMMEZEROZERO when using SuperBitMap).  If you don't specify
     * ZeroZero, then you save memory (no allocation of RastPort, Layer,
     * ClipRect and associated Bitmaps), but you also must offset all your
     * writes by BorderTop, BorderLeft and do your own mini-clipping to
     * prevent writing over the system gadgets
     *)
    borderLeft * , borderTop * , borderRight * , borderBottom * : SHORTINT;
    borderRPort * : g.RastPortPtr;


    (* You supply a linked-list of Gadgets for your Window.
     * This list DOES NOT include system gadgets.  You get the standard
     * window system gadgets by setting flag-bits in the variable Flags (see
     * the bit definitions below)
     *)
    firstGadget * : GadgetDummyPtr;

    (* these are for opening/closing the windows *)
    parent * , descendant * : WindowPtr;

    (* sprite data information for your own Pointer
     * set these AFTER you Open the Window by calling SetPointer()
     *)
    pointer * : e.APTR;    (* sprite data *)
    ptrHeight * : SHORTINT;     (* sprite height (not including sprite padding) *)
    ptrWidth * : SHORTINT;      (* sprite width (must be less than or equal to 16) *)
    xOffset * , yOffset * : SHORTINT;      (* sprite offsets *)

    (* the IDCMP Flags and User's and Intuition's Message Ports *)
    idcmpFlags * : LONGSET;   (* User-selected flags *)
    userPort * : e.MsgPortPtr;
    windowPort * : e.MsgPortPtr;
    messageKey * : IntuiMessagePtr;

    detailPen * , blockPen * : SHORTINT;  (* for bar/border/gadget rendering *)

    (* the CheckMark is a pointer to the imagery that will be used when
     * rendering MenuItems of this Window that want to be checkmarked
     * if this is equal to NULL, you'll get the default imagery
     *)
    checkMark * : ImagePtr;

    screenTitle * : e.LSTRPTR; (* if non-null, Screen title when Window is active *)

    (* These variables have the mouse coordinates relative to the
     * inner-Window of WFLG_GIMMEZEROZERO Windows.  This is compared with the
     * MouseX and MouseY variables, which contain the mouse coordinates
     * relative to the upper-left corner of the Window, WFLG_GIMMEZEROZERO
     * notwithstanding
     *)
    gzzMouseX * : INTEGER;
    gzzMouseY * : INTEGER;
    (* these variables contain the width and height of the inner-Window of
     * WFLG_GIMMEZEROZERO Windows
     *)
    gzzWidth * : INTEGER;
    gzzHeight * : INTEGER;

    extData * : e.APTR;

    userData * : e.APTR;     (* general-purpose pointer to User data extension *)

    (* 11/18/85: this pointer keeps a duplicate of what
     * Window.RPort->Layer is _supposed_ to be pointing at
     *)
    wLayer * : g.LayerPtr;

    (* NEW 1.2: need to keep track of the font that
     * OpenWindow opened, in case user SetFont's into RastPort
     *)
    iFont * : g.TextFontPtr;

    (* (V36) another flag word (the Flags field is used up).
     * At present, all flag values are system private.
     * Until further notice, you may not change nor use this field.
     *)
    moreFlags   : LONGSET;

    (**** Data beyond this point are Intuition Private.  DO NOT USE ****)
  END;

CONST
(* --- Flags requested at OpenWindow() time by the application --------- *)
  windowSizing   * = 0;      (* include sizing system-gadget? *)
  windowDrag     * = 1;      (* include dragging system-gadget? *)
  windowDepth    * = 2;      (* include depth arrangement gadget? *)
  windowClose    * = 3;      (* include close-box system-gadget? *)

  sizeBRight     * = 4;      (* size gadget uses right border *)
  sizeBBottom    * = 5;      (* size gadget uses bottom border *)

(* --- refresh modes ------------------------------------------------------ *)
(* combinations of the WFLG_REFRESHBITS select the refresh type *)
  refreshBits    * = LONGSET{6,7};
  smartRefresh   * = LONGSET{};
  simpleRefresh  * = 6;
  superBitMap    * = 7;
  otherRefresh   * = LONGSET{6,7};

  backDrop       * = 8;      (* this is a backdrop window *)

  reportMouse    * = 9;      (* to hear about every mouse move *)

  gimmeZeroZero  * = 10;     (* a GimmeZeroZero window       *)

  borderless     * = 11;     (* to get a Window sans border *)

  activate       * = 12;     (* when Window opens, it's Active *)

(* --- Other User Flags --------------------------------------------------- *)
  rmbTrap        * = 16;     (* Catch RMB events for your own *)
  noCareRefresh  * = 17;     (* not to be bothered with REFRESH *)

(* - V36 new Flags which the programmer may specify in NewWindow.Flags  *)
  nwExtended     * = 18;     (* extension data provided      *)

(* - V39 new Flags which the programmer may specify in NewWindow.Flags        *)
  newLookMenus   * = 21;     (* window has NewLook menus     *)


(* These flags are set only by Intuition.  YOU MAY NOT SET THEM YOURSELF! *)
  windowActive   * = 13;     (* this window is the active one *)
  inRequest      * = 14;     (* this window is in request mode *)
  menuState      * = 15;     (* Window is active with Menus on *)
  windowRefresh  * = 24;     (* Window is currently refreshing *)
  wbenchWindow   * = 25;     (* WorkBench tool ONLY Window *)
  windowTicked   * = 26;     (* only one timer tick at a time *)

(* V36 and higher flags to be set only by Intuition: *)
  visitor        * = 27;     (* visitor window               *)
  zoomed         * = 28;     (* identifies "zoom state"      *)
  hasZoom        * = 29;     (* windowhas a zoom gadget      *)

(* --- Other Window Values ---------------------------------------------- *)
  defaultMouseQueue * = 5;        (* no more mouse messages       *)

(* --- see struct IntuiMessage for the IDCMP Flag definitions ------------- *)


TYPE
(* ======================================================================== *)
(* === NewWindow ========================================================== *)
(* ======================================================================== *)
(*
 * Note that the new extension fields have been removed.  Use ExtNewWindow
 * structure below to make use of these fields
 *)
  NewWindow * = STRUCT
    leftEdge * , topEdge * : INTEGER;     (* screen dimensions of window *)
    width * , height * : INTEGER;         (* screen dimensions of window *)

    detailPen * , blockPen * : SHORTINT;  (* for bar/border/gadget rendering *)

    idcmpFlags * : LONGSET;               (* User-selected IDCMP flags *)

    flags * : LONGSET;                    (* see Window struct for defines *)

    (* You supply a linked-list of Gadgets for your Window.
     *  This list DOES NOT include system Gadgets.  You get the standard
     *  system Window Gadgets by setting flag-bits in the variable Flags (see
     *  the bit definitions under the Window structure definition)
     *)
    firstGadget * : GadgetDummyPtr;

    (* the CheckMark is a pointer to the imagery that will be used when
     * rendering MenuItems of this Window that want to be checkmarked
     * if this is equal to NULL, you'll get the default imagery
     *)
    checkMark * : ImagePtr;

    title * : e.LSTRPTR;                  (* the title text for this window *)

    (* the Screen pointer is used only if you've defined a CUSTOMSCREEN and
     * want this Window to open in it.  If so, you pass the address of the
     * Custom Screen structure in this variable.  Otherwise, this variable
     * is ignored and doesn't have to be initialized.
     *)
    screen * : ScreenPtr;

    (* WFLG_SUPER_BITMAP Window?  If so, put the address of your BitMap
     * structure in this variable.  If not, this variable is ignored and
     * doesn't have to be initialized
     *)
    bitMap * : g.BitMapPtr;

    (* the values describe the minimum and maximum sizes of your Windows.
     * these matter only if you've chosen the WFLG_SIZEGADGET option,
     * which means that you want to let the User to change the size of
     * this Window.  You describe the minimum and maximum sizes that the
     * Window can grow by setting these variables.  You can initialize
     * any one these to zero, which will mean that you want to duplicate
     * the setting for that dimension (if MinWidth == 0, MinWidth will be
     * set to the opening Width of the Window).
     * You can change these settings later using SetWindowLimits().
     * If you haven't asked for a SIZING Gadget, you don't have to
     * initialize any of these variables.
     *)
    minWidth * , minHeight * : INTEGER;       (* minimums *)
    maxWidth * , maxHeight * : INTEGER;       (* maximums *)

    (* the type variable describes the Screen in which you want this Window to
     * open.  The type value can either be CUSTOMSCREEN or one of the
     * system standard Screen Types such as WBENCHSCREEN.  See the
     * type definitions under the Screen structure.
     *)
    type * : SET;
  END;

(* The following structure is the future NewWindow.  Compatibility
 * issues require that the size of NewWindow not change.
 * Data in the common part (NewWindow) indicates the the extension
 * fields are being used.
 * NOTE WELL: This structure may be subject to future extension.
 * Writing code depending on its size is not allowed.
 *)
  ExtNewWindow * = STRUCT (nw * : NewWindow)

    (* ------------------------------------------------------- *
     * extensions for V36
     * if the NewWindow Flag value WFLG_NW_EXTENDED is set, then
     * this field is assumed to point to an array ( or chain of arrays)
     * of TagItem structures.  See also ExtNewScreen for another
     * use of TagItems to pass optional data.
     *
     * see below for tag values and the corresponding data.
     *)
    extension * : u.TagListPtr;
  END;

CONST
(*
 * The TagItem ID's (ti_Tag values) for OpenWindowTagList() follow.
 * They are values in a TagItem array passed as extension/replacement
 * values for the data in NewWindow.  OpenWindowTagList() can actually
 * work well with a NULL NewWindow pointer.
 *)

  waDummy            * = u.user + 99;  (* 0x80000063   *)

(* these tags simply override NewWindow parameters *)
  waLeft             * = waDummy + 001H;
  waTop              * = waDummy + 002H;
  waWidth            * = waDummy + 003H;
  waHeight           * = waDummy + 004H;
  waDetailPen        * = waDummy + 005H;
  waBlockPen         * = waDummy + 006H;
  waIDCMP            * = waDummy + 007H;
                  (* "bulk" initialization of NewWindow.Flags *)
  waFlags            * = waDummy + 008H;
  waGadgets          * = waDummy + 009H;
  waCheckmark        * = waDummy + 00AH;
  waTitle            * = waDummy + 00BH;
                  (* means you don't have to call SetWindowTitles
                   * after you open your window
                   *)
  waScreenTitle      * = waDummy + 00CH;
  waCustomScreen     * = waDummy + 00DH;
  waSuperBitMap      * = waDummy + 00EH;
                  (* also implies WFLG_SUPER_BITMAP property      *)
  waMinWidth         * = waDummy + 00FH;
  waMinHeight        * = waDummy + 010H;
  waMaxWidth         * = waDummy + 011H;
  waMaxHeight        * = waDummy + 012H;

(* The following are specifications for new features    *)

  waInnerWidth       * = waDummy + 013H;
  waInnerHeight      * = waDummy + 014H;
                  (* You can specify the dimensions of the interior
                   * region of your window, independent of what
                   * the border widths will be.  You probably want
                   * to also specify WA_AutoAdjust to allow
                   * Intuition to move your window or even
                   * shrink it so that it is completely on screen.
                   *)

  waPubScreenName    * = waDummy + 015H;
                  (* declares that you want the window to open as
                   * a visitor on the public screen whose name is
                   * pointed to by (UBYTE * )  ti_Data
                   *)
  waPubScreen        * = waDummy + 016H;
                  (* open as a visitor window on the public screen
                   * whose address is in (struct Screen * ) ti_Data.
                   * To ensure that this screen remains open, you
                   * should either be the screen's owner, have a
                   * window open on the screen, or use LockPubScreen().
                   *)
  waPubScreenFallBack* = waDummy + 017H;
                  (* A Boolean, specifies whether a visitor window
                   * should "fall back" to the default public screen
                   * (or Workbench) if the named public screen isn't
                   * available
                   *)
  waWindowName       * = waDummy + 018H;
                  (* not implemented      *)
  waColors           * = waDummy + 019H;
                  (* a ColorSpec array for colors to be set
                   * when this window is active.  This is not
                   * implemented, and may not be, since the default
                   * values to restore would be hard to track.
                   * We'd like to at least support per-window colors
                   * for the mouse pointer sprite.
                   *)
  waZoom             * = waDummy + 01AH;
                  (* ti_Data points to an array of four WORD's,
                   * the initial Left/Top/Width/Height values of
                   * the "alternate" zoom position/dimensions.
                   * It also specifies that you want a Zoom gadget
                   * for your window, whether or not you have a
                   * sizing gadget.
                   *)
  waMouseQueue       * = waDummy + 01BH;
                  (* ti_Data contains initial value for the mouse
                   * message backlog limit for this window.
                   *)
  waBackFill         * = waDummy + 01CH;
                  (* provides a "backfill hook" for your window's Layer.
                   * See layers.library/CreateUpfrontHookLayer().
                   *)
  waRptQueue         * = waDummy + 01DH;
                  (* initial value of repeat key backlog limit    *)

  (* These Boolean tag items are alternatives to the NewWindow.Flags
   * boolean flags with similar names.
   *)
  waSizeGadget       * = waDummy + 01EH;
  waDragBar          * = waDummy + 01FH;
  waDepthGadget      * = waDummy + 020H;
  waCloseGadget      * = waDummy + 021H;
  waBackdrop         * = waDummy + 022H;
  waReportMouse      * = waDummy + 023H;
  waNoCareRefresh    * = waDummy + 024H;
  waBorderless       * = waDummy + 025H;
  waActivate         * = waDummy + 026H;
  waRMBTrap          * = waDummy + 027H;
  waWBenchWindow     * = waDummy + 028H;      (* PIVATE!!! *)
  waSimpleRefresh    * = waDummy + 029H;
                  (* only specify if TRUE *)
  waSmartRefresh     * = waDummy + 02AH;
                  (* only specify if TRUE *)
  waSizeBRight       * = waDummy + 02BH;
  waSizeBBottom      * = waDummy + 02CH;

  (* New Boolean properties   *)
  waAutoAdjust       * = waDummy + 02DH;
                  (* shift or squeeze the window's position and
                   * dimensions to fit it on screen.
                   *)

  waGimmeZeroZero    * = waDummy + 02EH;
                  (* equiv. to NewWindow.Flags WFLG_GIMMEZEROZERO *)

(* New for V37: WA_MenuHelp (ignored by V36) *)
  waMenuHelp         * = waDummy + 02FH;
                  (* Enables IDCMP_MENUHELP:  Pressing HELP during menus
                   * will return IDCMP_MENUHELP message.
                   *)
(* New for V39:  (ignored by V37 and earlier) *)
  waNewLookMenus     * = waDummy + 030H;
                      (* Set to TRUE if you want NewLook menus *)
  waAmigaKey         * = waDummy + 031H;
                      (* Pointer to image for Amiga-key equiv in menus *)
  waNotifyDepth      * = waDummy + 032H;
                      (* Requests IDCMP_CHANGEWINDOW message when
                       * window is depth arranged
                       * (imsg->Code = CWCODE_DEPTH)
                       *)

(* WA_Dummy + 033 is obsolete *)

  waPointer          * = waDummy + 034H;
                      (* Allows you to specify a custom pointer
                       * for your window.  ti_Data points to a
                       * pointer object you obtained via
                       * "pointerclass". NULL signifies the
                       * default pointer.
                       * This tag may be passed to OpenWindowTags()
                       * or SetWindowPointer().
                       *)

  waBusyPointer      * = waDummy + 035H;
                      (* ti_Data is boolean.  Set to TRUE to
                       * request the standard busy pointer.
                       * This tag may be passed to OpenWindowTags()
                       * or SetWindowPointer().
                       *)

  waPointerDelay     * = waDummy + 036H;
                      (* ti_Data is boolean.  Set to TRUE to
                       * request that the changing of the
                       * pointer be slightly delayed.  The change
                       * will be called off if you call NewSetPointer()
                       * before the delay expires.  This allows
                       * you to post a busy-pointer even if you think
                       * the busy-time may be very short, without
                       * fear of a flashing pointer.
                       * This tag may be passed to OpenWindowTags()
                       * or SetWindowPointer().
                       *)

  waTabletMessages   * = waDummy + 037H;
                      (* ti_Data is a boolean.  Set to TRUE to
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
                       *)

  waHelpGroup        * = waDummy + 038H;
                      (* When the active window has gadget help enabled,
                       * other windows of the same HelpGroup number
                       * will also get GadgetHelp.  This allows GadgetHelp
                       * to work for multi-windowed applications.
                       * Use GetGroupID() to get an ID number.  Pass
                       * this number as ti_Data to all your windows.
                       * See also the HelpControl() function.
                       *)

  waHelpGroupWindow  * = waDummy + 039H;
                      (* When the active window has gadget help enabled,
                       * other windows of the same HelpGroup will also get
                       * GadgetHelp.  This allows GadgetHelp to work
                       * for multi-windowed applications.  As an alternative
                       * to WA_HelpGroup, you can pass a pointer to any
                       * other window of the same group to join its help
                       * group.  Defaults to NULL, which has no effect.
                       * See also the HelpControl() function.
                       *)


(* HelpControl() flags:
 *
 * HC_GADGETHELP - Set this flag to enable Gadget-Help for one or more
 * windows.
 *)

  hcGadgetHelp * = 1; (* is this flag bit or flag mask? [hG] *)


TYPE
(* ======================================================================== *)
(* === Remember =========================================================== *)
(* ======================================================================== *)
(* this structure is used for remembering what memory has been allocated to
 * date by a given routine, so that a premature abort or systematic exit
 * can deallocate memory cleanly, easily, and completely
 *)
  Remember * = STRUCT
    nextRemember * : RememberPtr;
    rememberSize * : LONGINT;
    memory * : e.APTR;
  END;


(* === Color Spec ====================================================== *)
(* How to tell Intuition about RGB values for a color table entry.
 * NOTE:  The way the structure was defined, the color value was
 * right-justified within each UWORD.  This poses problems for
 * extensibility to more bits-per-gun.        The SA_Colors32 tag to
 * OpenScreenTags() provides an alternate way to specify colors
 * with greater precision.
 *)
  ColorSpec * = STRUCT
    colorIndex * : INTEGER;     (* -1 terminates an array of ColorSpec  *)
    red        * : INTEGER;     (* only _bottom_ 4 bits recognized in V36 *)
    green      * : INTEGER;     (* only _bottom_ 4 bits recognized in V36 *)
    blue       * : INTEGER;     (* only _bottom_ 4 bits recognized in V36 *)
  END;

(* === Easy Requester Specification ======================================= *)
(* see also autodocs for EasyRequest and BuildEasyRequest       *)
(* NOTE: This structure may grow in size in the future          *)
  EasyStruct * = STRUCT
    structSize * : LONGINT;     (* should be sizeof (struct EasyStruct )*)
    flags * : LONGSET;          (* should be 0 for now                  *)
    title * : e.LSTRPTR;        (* title of requester window            *)
    textFormat * : e.LSTRPTR;   (* 'printf' style formatting string     *)
    gadgetFormat * : e.LSTRPTR; (* 'printf' style formatting string   *)
  END;


CONST
(* ======================================================================== *)
(* === Miscellaneous ====================================================== *)
(* ======================================================================== *)

(* = MENU STUFF =========================================================== *)
  noMenu   * = 0001FU;
  noItem   * = 0003FU;
  noSub    * = 0001FU;
  menuNull * = 0FFFFU;


(* these defines are for the COMMSEQ and CHECKIT menu stuff.  If CHECKIT,
 * I'll use a generic Width (for all resolutions) for the CheckMark.
 * If COMMSEQ, likewise I'll use this generic stuff
 *)
  checkWidth     * = 19;
  commWidth      * = 27;
  lowCheckWidth  * = 13;
  lowCommWidth   * = 16;


(* these are the AlertNumber defines.  if you are calling DisplayAlert()
 * the AlertNumber you supply must have the ALERT_TYPE bits set to one
 * of these patterns
 *)
  alertType     * = 80000000H;
  recoveryAlert * = 00000000H;      (* the system can recover from this *)
  deadendAlert  * = 80000000H;      (* no recovery possible, this is it *)


(* When you're defining IntuiText for the Positive and Negative Gadgets
 * created by a call to AutoRequest(), these defines will get you
 * reasonable-looking text.  The only field without a define is the IText
 * field; you decide what text goes with the Gadget
 *)
  autoFrontPen  * = 0;
  autoBackPen   * = 1;
  autoDrawMode  * = g.jam2;
  autoLeftEdge  * = 6;
  autoTopEdge   * = 3;
  autoITextFont * = NIL;
  autoNextText  * = NIL;


(* --- RAWMOUSE Codes and Qualifiers (Console OR IDCMP) ------------------- *)
  selectUp        * = ie.lButton + ie.upPrefix;
  selectDown      * = ie.lButton;
  menuUp          * = ie.rButton + ie.upPrefix;
  menuDown        * = ie.rButton;
  middleUp        * = ie.mButton + ie.upPrefix;
  middleDown      * = ie.mButton;

  altLeft         * = {ie.lAlt};
  altRight        * = {ie.rAlt};
  amigaLeft       * = {ie.lCommand};
  amigaRight      * = {ie.rCommand};
  amigaKeys       * = amigaLeft + amigaRight;

  cursorUp        * = 04CH;
  cursorLeft      * = 04FH;
  cursorRight     * = 04EH;
  cursorDown      * = 04DH;
  keyCodeQ        * = 010H;
  keyCodeZ        * = 031H;
  keyCodeX        * = 032H;
  keyCodeV        * = 034H;
  keyCodeB        * = 035H;
  keyCodeN        * = 036H;
  keyCodeM        * = 037H;
  keyCodeLess     * = 038H;
  keyCodeGreater  * = 039H;

(* New for V39, Intuition supports the IESUBCLASS_NEWTABLET subclass
 * of the IECLASS_NEWPOINTERPOS event.        The ie_EventAddress of such
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
 *    Note: a stylus that supports tilt should use the TABLETA_AngleX
 *    and TABLETA_AngleY attributes.  Tilting the stylus so the tip
 *    points towards increasing or decreasing X is actually a rotation
 *    around the Y-axis.  Thus, if the stylus tip points towards
 *    positive X, then that tilt is represented as a negative
 *    TABLETA_AngleY.  Likewise, if the stylus tip points towards
 *    positive Y, that tilt is represented by positive TABLETA_AngleX.
 *
 * TABLETA_Pressure:  the pressure reading of the stylus.  The pressure
 * should be normalized to fill a signed long integer.        Typical devices
 * won't generate negative pressure, but the possibility is not precluded.
 * The pressure threshold which is considered to cause a button-click is
 * expected to be set in a Preferences program supplied by the tablet
 * vendor.  The tablet driver would send IECODE_LBUTTON-type events as
 * the pressure crossed that threshold.
 *
 * TABLETA_ButtonBits:        ti_Data is a long integer whose bits are to
 * be interpreted at the state of the first 32 buttons of the tablet.
 *
 * TABLETA_InProximity:  ti_Data is a boolean.        For tablets that support
 * proximity, they should send the {TABLETA_InProximity,FALSE} tag item
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
 *)

  tabletaDummy       * = u.user + 03A000H;
  tabletaTabletZ     * = tabletaDummy + 001H;
  tabletaRangeZ      * = tabletaDummy + 002H;
  tabletaAngleX      * = tabletaDummy + 003H;
  tabletaAngleY      * = tabletaDummy + 004H;
  tabletaAngleZ      * = tabletaDummy + 005H;
  tabletaPressure    * = tabletaDummy + 006H;
  tabletaButtonBits  * = tabletaDummy + 007H;
  tabletaInproximitY * = tabletaDummy + 008H;
  tabletaResolutionX * = tabletaDummy + 009H;
  tabletaResolutionY * = tabletaDummy + 00AH;

(* If your window sets WA_TabletMessages to TRUE, then it will receive
 * extended IntuiMessages (struct ExtIntuiMessage) whose eim_TabletData
 * field points at a TabletData structure.  This structure contains
 * additional information about the input event.
 *)

TYPE
  TabletData * = STRUCT
    (* Sub-pixel position of tablet, in screen coordinates,
     * scaled to fill a UWORD fraction:
     *)
    xFraction *, yFraction *: INTEGER;

    (* Current tablet coordinates along each axis: *)
    tabletX *, tabletY *: LONGINT;

    (* Tablet range along each axis.  For example, if td_TabletX
     * can take values 0-999, td_RangeX should be 1000.
     *)
    rangeX *, rangeY * : LONGINT;

    (* Pointer to tag-list of additional tablet attributes.
     * See <intuition/intuition.h> for the tag values.
     *)
    tagList * : u.TagListPtr;
  END;

(* If a tablet driver supplies a hook for td_CallBack, it will be
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
 * The tablet hook must currently return NULL.        This is the only
 * acceptable return-value under V39.
 *)

  TabletHookData * = STRUCT
    (* Pointer to the active screen:
     * Note: if there are no open screens, thd_Screen will be NULL.
     * thd_Width and thd_Height will then describe an NTSC 640x400
     * screen.        Please scale accordingly.
     *)
    screen * : ScreenPtr;

    (* The width and height (measured in pixels of the active screen)
     * that your are to scale to:
     *)
    width  * : LONGINT;
    height * : LONGINT;

    (* Non-zero if the screen or something about the screen
     * changed since the last time you were invoked:
     *)
    screenChanged * : LONGINT;
  END;


(*
 * Package of information passed to custom and 'boopsi'
 * gadget "hook" functions.  This structure is READ ONLY.
 *)
  GadgetInfo * = STRUCT

    screen    - : ScreenPtr;
    window    - : WindowPtr;           (* null for screen gadgets *)
    requester - : RequesterPtr;        (* null if not GTYP_REQGADGET *)

    (* rendering information:
     * don't use these without cloning/locking.
     * Official way is to call ObtainRPort()
     *)
    rastPort - : g.RastPortPtr;
    layer    - : g.LayerPtr;

    (* copy of dimensions of screen/window/g00/req(/group)
     * that gadget resides in.  Left/Top of this box is
     * offset from window mouse coordinates to gadget coordinates
     *          screen gadgets:                 0,0 (from screen coords)
     *  window gadgets (no g00):        0,0
     *  GTYP_GZZGADGETs (borderlayer):          0,0
     *  GZZ innerlayer gadget:          borderleft, bordertop
     *  Requester gadgets:              reqleft, reqtop
     *)
    domain - : IBox;

    (* these are the pens for the window or screen      *)

    pens - : STRUCT
      detailPen - : SHORTINT;
      blockPen - : SHORTINT;
    END;

    (* the Detail and Block pens in gi_DrInfo->dri_Pens[] are
     * for the screen.  Use the above for window-sensitive
     * colors.
     *)
    drInfo - : DrawInfoPtr;

    (* reserved space: this structure is extensible
     * anyway, but using these saves some recompilation
     *)
    reserved - : ARRAY 6 OF LONGINT;
  END;

(*** system private data structure for now ***)
(* prop gadget extra info       *)
  PGX = STRUCT
    container *: IBox;
    newKnob   *: IBox;
  END;


(*** User visible handles on objects, classes, messages ***)
  ObjectUsr * = LONGINT;         (* abstract handle *)

  ClassID   * = e.LSTRPTR;

(* you can use this type to point to a "generic" message,
 * in the object-oriented programming parlance.  Based on
 * the value of 'MethodID', you dispatch to processing
 * for the various message types.  The meaningful parameter
 * packet structure definitions are defined below.
 *)
  Msg * = STRUCT
    methodID * : LONGINT;
    (* method-specific data follows, some examples below *)
  END;


CONST
(*
 * Class id strings for Intuition classes.
 * There's no real reason to use the uppercase constants
 * over the lowercase strings, but this makes a good place
 * to list the names of the built-in classes.
 *)
  rootClass       * = "rootclass";             (* classusr.h   *)
  imageClass      * = "imageclass";            (* imageclass.h *)
  frameIClass     * = "frameiclass";
  sysIClass       * = "sysiclass";
  fillRectClass   * = "fillrectclass";
  gadgetClass     * = "gadgetclass";           (* gadgetclass.h *)
  propGClass      * = "propgclass";
  strGClass       * = "strgclass";
  buttonGClass    * = "buttongclass";
  frButtonClass   * = "frbuttonclass";
  groupGClass     * = "groupgclass";
  icClass         * = "icclass";               (* icclass.h    *)
  modelClass      * = "modelclass";
  itextIClass     * = "itexticlass";
  pointerClass    * = "pointerclass";          (* pointerclass.h *)


(* Dispatched method ID's
 * NOTE: Applications should use Intuition entry points, not direct
 * DoMethod() calls, for NewObject, DisposeObject, SetAttrs,
 * SetGadgetAttrs, and GetAttr.
 *)

  dummy        * = 0100H;
  new          * = 0101H; (* 'object' parameter is "true class"   *)
  dispose      * = 0102H; (* delete self (no parameters)          *)
  set          * = 0103H; (* set attributes (in tag list)         *)
  get          * = 0104H; (* return single attribute value        *)
  addTail      * = 0105H; (* add self to a List (let root do it)  *)
  remove       * = 0106H; (* remove self from list                *)
  notify       * = 0107H; (* send to self: notify dependents      *)
  update       * = 0108H; (* notification message from somebody   *)
  addMember    * = 0109H; (* used by various classes with lists   *)
  remMember    * = 010AH; (* used by various classes with lists   *)

(* Parameter "Messages" passed to methods       *)

TYPE

(* OM_NEW and OM_SET    *)
  OpSet * = STRUCT (msg * : Msg)
    attrList * : u.TagListPtr;  (* new attributes       *)
    gInfo * : GadgetInfoPtr;    (* always there for gadgets,
                                 * when SetGadgetAttrs() is used,
                                 * but will be NULL for OM_NEW
                                 *)
  END;

(* OM_NOTIFY, and OM_UPDATE     *)
  OpUpdate * = STRUCT (msg * : Msg)
    attrList * : u.TagListPtr;  (* new attributes       *)
    gInfo * : GadgetInfoPtr;    (* non-NULL when SetGadgetAttrs or
                                 * notification resulting from gadget
                                 * input occurs.
                                 *)
    flags * : LONGSET;      (* defined below        *)
  END;

CONST

(* this flag means that the update message is being issued from
 * something like an active gadget, a la GACT_FOLLOWMOUSE.  When
 * the gadget goes inactive, it will issue a final update
 * message with this bit cleared.  Examples of use are for
 * GACT_FOLLOWMOUSE equivalents for propgadclass, and repeat strobes
 * for buttons.
 *)
  interim * = 0;

TYPE

(* OM_GET       *)
  OpGet * = STRUCT (msg * : Msg)
    attrID  * : LONGINT;
    storage * : UNTRACED POINTER TO e.ADDRESS;   (* may be other types, but "int"
                                                  * types are all ULONG
                                                  *)
  END;

(* OM_ADDTAIL   *)
  OpAddTail * = STRUCT (msg * : Msg)
    list * : e.ListPtr;
  END;

(* OM_ADDMEMBER, OM_REMMEMBER   *)
  OpMember * = STRUCT (msg * : Msg)
    object * : ObjectPtr;
  END;


(*******************************************)
(*** "White box" access to struct IClass ***)
(*******************************************)

(* This structure is READ-ONLY, and allocated only by Intuition *)
  IClass * = STRUCT (dispatcher - : u.Hook)
    reserved   : LONGINT;            (* must be 0  *)
    super    - : IClassPtr;
    id       - : ClassID;

    (* where within an object is the instance data for this class? *)
    instOffset - : INTEGER;
    instSize   - : INTEGER;

    userData      * : e.APTR;  (* per-class data of your choice *)
    subclassCount - : LONGINT; (* how many direct subclasses?  *)
    objectCount   - : LONGINT; (* how many objects created of this class? *)
    flags         - : LONGSET;
  END;

  Class * = IClass;

CONST
  (* IClass.flags *)
  inList * = 0;        (* class is in public class list *)

TYPE

(**************************************************)
(*** "White box" access to struct _Object       ***)
(**************************************************)

(*
 * We have this, the instance data of the root class, PRECEDING
 * the "object".  This is so that Gadget objects are Gadget pointers,
 * and so on.  If this structure grows, it will always have o_Class
 * at the end, so the macro OCLASS(o) will always have the same
 * offset back from the pointer returned from NewObject().
 *
 * This data structure is subject to change.  Do not use the o_Node
 * embedded structure.
 *)
  Object * = STRUCT (node: e.MinNode)
    class * : IClassPtr;
  END;

CONST
  (* Gadget Class attributes      *)

  gaDummy             * = u.user + 30000H;
  gaLeft              * = gaDummy + 0001H;
  gaRelRight          * = gaDummy + 0002H;
  gaTop               * = gaDummy + 0003H;
  gaRelBottom         * = gaDummy + 0004H;
  gaWidth             * = gaDummy + 0005H;
  gaRelWidth          * = gaDummy + 0006H;
  gaHeight            * = gaDummy + 0007H;
  gaRelHeight         * = gaDummy + 0008H;
  gaText              * = gaDummy + 0009H; (* ti_Data is e.LSTRPTR *)
  gaImage             * = gaDummy + 000AH;
  gaBorder            * = gaDummy + 000BH;
  gaSelectRender      * = gaDummy + 000CH;
  gaHighlight         * = gaDummy + 000DH;
  gaDisabled          * = gaDummy + 000EH;
  gaGZZGadget         * = gaDummy + 000FH;
  gaID                * = gaDummy + 0010H;
  gaUserData          * = gaDummy + 0011H;
  gaSpecialInfo       * = gaDummy + 0012H;
  gaSelected          * = gaDummy + 0013H;
  gaEndGadget         * = gaDummy + 0014H;
  gaImmediate         * = gaDummy + 0015H;
  gaRelVerify         * = gaDummy + 0016H;
  gaFollowMouse       * = gaDummy + 0017H;
  gaRightBorder       * = gaDummy + 0018H;
  gaLeftBorder        * = gaDummy + 0019H;
  gaTopBorder         * = gaDummy + 001AH;
  gaBottomBorder      * = gaDummy + 001BH;
  gaToggleSelect      * = gaDummy + 001CH;

    (* internal use only, until further notice, please *)
  gaSysGadget         * = gaDummy + 001DH;
        (* bool, sets GTYP_SYSGADGET field in type      *)
  gaSysGType          * = gaDummy + 001EH;
        (* e.g., GTYP_WUPFRONT, ...     *)

  gaPrevious          * = gaDummy + 001FH;
        (* previous gadget (or (struct Gadget ** )) in linked list
         * NOTE: This attribute CANNOT be used to link new gadgets
         * into the gadget list of an open window or requester.
         * You must use AddGList().
         *)

  gaNext              * = gaDummy + 0020H;
         (* not implemented *)

  gaDrawInfo          * = gaDummy + 0021H;
        (* some fancy gadgets need to see a DrawInfo
         * when created or for layout
         *)

(* You should use at most ONE of gaText, gaIntuiText, and gaLabelImage *)
  gaIntuiText         * = gaDummy + 0022H;
        (* ti_Data is (struct IntuiText * ) *)

  gaLabelImage        * = gaDummy + 0023H;
        (* ti_Data is an image (object), used in place of
         * GadgetText
         *)

  gaTabCycle          * = gaDummy + 0024H;
       (* New for V37:
        * Boolean indicates that this gadget is to participate in
        * cycling activation with Tab or Shift-Tab.
        *)

  gaGadgetHelp       * = gaDummy + 00025H;
      (* New for V39:
       * Boolean indicates that this gadget sends gadget-help
       *)

  gaBounds           * = gaDummy + 00026H;
      (* New for V39:
       * ti_Data is a pointer to an IBox structure which is
       * to be copied into the extended gadget's bounds.
       *)

  gaRelSpecial       * = gaDummy + 00027H;
      (* New for V39:
       * Boolean indicates that this gadget has the "special relativity"
       * property, which is useful for certain fancy relativity
       * operations through the GM_LAYOUT method.
       *)



(* PROPGCLASS attributes *)

  pgaDummy       * = u.user  + 31000H;
  pgaFreedom     * = pgaDummy + 0001H;
  (* only one of FREEVERT or FREEHORIZ *)
  pgaBorderless  * = pgaDummy + 0002H;
  pgaHorizPot    * = pgaDummy + 0003H;
  pgaHorizBody   * = pgaDummy + 0004H;
  pgaVertPot     * = pgaDummy + 0005H;
  pgaVertBody    * = pgaDummy + 0006H;
  pgaTotal       * = pgaDummy + 0007H;
  pgaVisible     * = pgaDummy + 0008H;
  pgaTop         * = pgaDummy + 0009H;
  pgaNewLook     * = pgaDummy + 000AH;

(* STRGCLASS attributes *)

  stringaDummy           * = u.user + 32000H;
  stringaMaxChars        * = stringaDummy + 0001H;

(* Note:  There is a minor problem with Intuition when using boopsi integer
 * gadgets (which are requested by using STRINGA_LongInt).  Such gadgets
 * must not have a STRINGA_MaxChars to be bigger than 15.  Setting
 * STRINGA_MaxChars for a boopsi integer gadget will cause a mismatched
 * FreeMem() to occur.
 *)

  stringaBuffer          * = stringaDummy + 0002H;
  stringaUndoBuffer      * = stringaDummy + 0003H;
  stringaWorkBuffer      * = stringaDummy + 0004H;
  stringaBufferPos       * = stringaDummy + 0005H;
  stringaDispPos         * = stringaDummy + 0006H;
  stringaAltKeyMap       * = stringaDummy + 0007H;
  stringaFont            * = stringaDummy + 0008H;
  stringaPens            * = stringaDummy + 0009H;
  stringaActivePens      * = stringaDummy + 000AH;
  stringaEditHook        * = stringaDummy + 000BH;
  stringaEditModes       * = stringaDummy + 000CH;

(* booleans *)
  stringaReplaceMode     * = stringaDummy + 000DH;
  stringaFixedFieldMode  * = stringaDummy + 000EH;
  stringaNoFilterMode    * = stringaDummy + 000FH;

  stringaJustification   * = stringaDummy + 0010H;
  (* GACT_STRINGCENTER, GACT_STRINGLEFT, GACT_STRINGRIGHT *)
  stringaLongVal         * = stringaDummy + 0011H;
  stringaTextVal         * = stringaDummy + 0012H;

  stringaExitHelp        * = stringaDummy + 0013H;
        (* STRINGA_ExitHelp is new for V37, and ignored by V36.
         * Set this if you want the gadget to exit when Help is
         * pressed.  Look for a code of 0x5F, the rawkey code for Help
         *)

  sgDefaultMaxChars      * = 128;

(* Gadget Layout related attributes     *)

  layoutaDummy           * = u.user + 38000H;
  layoutaLayoutObj       * = layoutaDummy + 0001H;
  layoutaSpacing         * = layoutaDummy + 0002H;
  layoutaOrientation     * = layoutaDummy + 0003H;

(* orientation values   *)
  lorientNone   * = 0;
  lorientHoriz  * = 1;
  lorientVert   * = 2;


(* Gadget Method ID's   *)

  gmDummy       * = -1;    (* not used for anything                   *)
  gmHitTest     * =  0;    (* return GMR_GADGETHIT if you are clicked on
                            * (whether or not you are disabled).
                            *)
  gmRender      * = 1;     (* draw yourself, in the appropriate state *)
  gmGoActive    * = 2;     (* you are now going to be fed input    *)
  gmHandleInput * = 3;     (* handle that input                    *)
  gmGoInactive  * = 4;     (* whether or not by choice, you are done  *)
  gmHelpTest    * = 5;     (* Will you send gadget help if the mouse is
                            * at the specified coordinates?  See below
                            * for possible GMR_ values.
                            *)
  gmLayout      * = 6;     (* re-evaluate your size based on the GadgetInfo
                            * Domain.  Do NOT re-render yourself yet, you
                            * will be called when it is time...
                            *)

TYPE

(* Parameter "Messages" passed to gadget class methods  *)

(* GM_HITTEST and GM_HELPTEST send this message.
 * For GM_HITTEST, gpht_Mouse are coordinates relative to the gadget
 * select box.        For GM_HELPTEST, the coordinates are relative to
 * the gadget bounding box (which defaults to the select box).
 *)
(* GM_HITTEST   *)
  HitTest * = STRUCT (msg * : Msg)
    gInfo * : GadgetInfoPtr;
    mouse * : g.Point;
  END;


CONST
 (* For GM_HITTEST, return GMR_GADGETHIT if you were indeed hit,
 * otherwise return zero.
 *
 * For GM_HELPTEST, return GMR_NOHELPHIT (zero) if you were not hit.
 * Typically, return GMR_HELPHIT if you were hit.
 * It is possible to pass a UWORD to the application via the Code field
 * of the IDCMP_GADGETHELP message.  Return GMR_HELPCODE or'd with
 * the UWORD-sized result you wish to return.
 *
 * GMR_HELPHIT yields a Code value of ((UWORD) ~0), which should
 * mean "nothing particular" to the application.
 *)

  gadgetHit   * = 000000004;    (* GM_HITTEST hit *)

  noHelpHit   * = 000000000H;   (* GM_HELPTEST didn't hit *)
  helpHit     * = 0FFFFFFFFH;   (* GM_HELPTEST hit, return code = ~0 *)
  helpCode    * = 000010000H;   (* GM_HELPTEST hit, return low word as code *)


TYPE

(* GM_RENDER    *)
  Render * = STRUCT (msg * : Msg)
    gInfo * : GadgetInfoPtr;     (* gadget context               *)
    rPort * : g.RastPortPtr;     (* all ready for use            *)
    redraw * : LONGINT;          (* might be a "highlight pass"  *)
  END;

CONST

(* values of gpr_Redraw *)
  gRedrawUpdate * = 2;    (* incremental update, e.g. prop slider *)
  gRedrawRedraw * = 1;    (* redraw gadget        *)
  gRedrawToggle * = 0;    (* toggle highlight, if applicable      *)

TYPE

(* GM_GOACTIVE, GM_HANDLEINPUT  *)
  Input * = STRUCT (msg * : Msg)
    gInfo * : GadgetInfoPtr;
    iEvent * : ie.InputEventDummyPtr;
    termination * : e.APTR;
    mouse * : g.Point;

    (* (V39) Pointer to TabletData structure, if this event originated
     * from a tablet which sends IESUBCLASS_NEWTABLET events, or NULL if
     * not.
     *
     * DO NOT ATTEMPT TO READ THIS FIELD UNDER INTUITION PRIOR TO V39!
     * IT WILL BE INVALID!
     *)
    tabletData * : TabletDataPtr;
  END;

CONST

(* GM_HANDLEINPUT and GM_GOACTIVE  return code flags    *)
(* return GMR_MEACTIVE (0) alone if you want more input.
 * Otherwise, return ONE of GMR_NOREUSE and GMR_REUSE, and optionally
 * GMR_VERIFY.
 *)
  gmrMeActive    * = 0;
  gmrNoReuse     * = 2;
  gmrReuse       * = 4;
  gmrVerify      * = 8;       (* you MUST set gpi_Termination *)


(* New for V37:
 * You can end activation with one of GMR_NEXTACTIVE and GMR_PREVACTIVE,
 * which instructs Intuition to activate the next or previous gadget
 * that has GFLG_TABCYCLE set.
 *)
  gmrNextActive  * = 16;
  gmrPrevActive  * = 32;

TYPE

  GoInactive * = STRUCT (msg * : Msg)
    gInfo * : GadgetInfoPtr;
    (* V37 field only!        DO NOT attempt to read under V36! *)
    abort * : LONGINT;                (* gpgi_Abort=1 if gadget was aborted
                                       * by Intuition and 0 if gadget went
                                       * inactive at its own request
                                       *)
  END;

(* New for V39: Intuition sends GM_LAYOUT to any GREL_ gadget when
 * the gadget is added to the window (or when the window opens, if
 * the gadget was part of the NewWindow.FirstGadget or the WA_Gadgets
 * list), or when the window is resized.  Your gadget can set the
 * GA_RelSpecial property to get GM_LAYOUT events without Intuition
 * changing the interpretation of your gadget select box.  This
 * allows for completely arbitrary resizing/repositioning based on
 * window size.
 *)
(* GM_LAYOUT *)
  Layout * = STRUCT (msg * : Msg)
    gInfo * : GadgetInfoPtr;
    initial *: LONGINT;    (* non-zero if this method was invoked
                            * during AddGList() or OpenWindow()
                            * time.  zero if this method was invoked
                            * during window resizing.
                            *)
  END;


CONST
 (* ICClass: *)

  icmDummy       * = 00401H;       (* used for nothing             *)
  icmSetLoop     * = 00402H;       (* set/increment loop counter   *)
  icmClearLoop   * = 00403H;       (* clear/decrement loop counter *)
  icmCheckLoop   * = 00404H;       (* set/increment loop           *)

(* no parameters for ICM_SETLOOP, ICM_CLEARLOOP, ICM_CHECKLOOP  *)

(* interconnection attributes used by icclass, modelclass, and gadgetclass *)
  icaDummy       * = u.user + 040000H;
  icaTarget      * = icaDummy + 1;
  (* interconnection target               *)
  icaMap         * = icaDummy + 2;
  (* interconnection map tagitem list     *)
  icSpecialCode  * = icaDummy + 3;
  (* a "pseudo-attribute", see below.     *)

(* Normally, the value for ICA_TARGET is some object pointer,
 * but if you specify the special value ICTARGET_IDCMP, notification
 * will be send as an IDCMP_IDCMPUPDATE message to the appropriate window's
 * IDCMP port.  See the definition of IDCMP_IDCMPUPDATE.
 *
 * When you specify ICTARGET_IDCMP for ICA_TARGET, the map you
 * specify will be applied to derive the attribute list that is
 * sent with the IDCMP_IDCMPUPDATE message.  If you specify a map list
 * which results in the attribute tag id ICSPECIAL_CODE, the
 * lower sixteen bits of the corresponding ti_Data value will
 * be copied into the Code field of the IDCMP_IDCMPUPDATE IntuiMessage.
 *)
  icTargetIDCMP * = -LONGSET{};


(* ImageClass: *)

  customImageDepth * = -1;
(* if image.depth is this, it's a new Image class object *)

(******************************************************)
  iaDummy                * = u.user + 20000H;
  iaLeft                 * = iaDummy + 001H;
  iaTop                  * = iaDummy + 002H;
  iaWidth                * = iaDummy + 003H;
  iaHeight               * = iaDummy + 004H;
  iaFGPen                * = iaDummy + 005H;
              (* iaFGPen also means "PlanePick"  *)
  iaBGPen                * = iaDummy + 006H;
              (* iaBGPen also means "PlaneOnOff" *)
  iaData                 * = iaDummy + 007H;
              (* bitplanes, for classic image,
               * other image classes may use it for other things
               *)
  iaLineWidth            * = iaDummy + 008H;
  iaPens                 * = iaDummy + 00EH;
              (* pointer to UWORD pens[],
               * ala DrawInfo.Pens, MUST be
               * terminated by ~0.  Some classes can
               * choose to have this, or SYSiaDrawInfo,
               * or both.
               *)
  iaResolution           * = iaDummy + 00FH;
              (* packed uwords for x/y resolution into a longword
               * ala DrawInfo.Resolution
               *)

(**** see class documentation to learn which    *****)
(**** classes recognize these                   *****)
  iaAPattern             * = iaDummy + 010H;
  iaAPatSize             * = iaDummy + 011H;
  iaMode                 * = iaDummy + 012H;
  iaFont                 * = iaDummy + 013H;
  iaOutline              * = iaDummy + 014H;
  iaRecessed             * = iaDummy + 015H;
  iaDoubleEmboss         * = iaDummy + 016H;
  iaEdgesOnly            * = iaDummy + 017H;

(**** "sysiclass" attributes                    *****)
  sysiaSize              * = iaDummy + 00BH;
              (* # define's below          *)
  sysiaDepth             * = iaDummy + 00CH;
              (* this is unused by Intuition.  sysiaDrawInfo
               * is used instead for V36
               *)
  sysiaWhich             * = iaDummy + 00DH;
              (* see # define's below      *)
  sysiaDrawInfo          * = iaDummy + 018H;
              (* pass to sysiclass, please *)

(*****  obsolete: don't use these, use iaPens  *****)
  sysiaPens              * = iaPens;
  iaShadowPen            * = iaDummy + 009H;
  iaHighlightPen         * = iaDummy + 00AH;

(* New for V39: *)
  sysiaReferenceFont     * = iaDummy + 019H;
                  (* Font to use as reference for scaling
                   * certain sysiclass images
                   *)
  iaSupportsDisable      * = iaDummy + 01AH;
                  (* By default, Intuition ghosts gadgets itself,
                   * instead of relying on IDS_DISABLED or
                   * IDS_SELECTEDDISABLED.  An imageclass that
                   * supports these states should return this attribute
                   * as TRUE.  You cannot set or clear this attribute,
                   * however.
                   *)

  iaFrameType            * = iaDummy + 01BH;
                  (* Starting with V39, FrameIClass recognizes
                   * several standard types of frame.  Use one
                   * of the FRAME_ specifiers below.  Defaults
                   * to FRAME_DEFAULT.
                   *)

(** next attribute: (iaDummy + 0x1c)   **)
(*************************************************)

(* data values for sysiaSize   *)
  sysisizeMedres * = 0;
  sysisizeLowres * = 1;
  sysisizeHires  * = 2;

(*
 * sysiaWhich tag data values:
 * Specifies which system gadget you want an image for.
 * Some numbers correspond to internal Intuition # defines
 *)
  depthImage  * = 000H; (* Window depth gadget image *)
  zoomImage   * = 001H; (* Window zoom gadget image *)
  sizeImage   * = 002H; (* Window sizing gadget image *)
  closeImage  * = 003H; (* Window close gadget image *)
  sDepthImage * = 005H; (* Screen depth gadget image *)
  leftImage   * = 00AH; (* Left-arrow gadget image *)
  upImage     * = 00BH; (* Up-arrow gadget image *)
  rightImage  * = 00CH; (* Right-arrow gadget image *)
  downImage   * = 00DH; (* Down-arrow gadget image *)
  checkImage  * = 00EH; (* GadTools checkbox image *)
  mxImage     * = 00FH; (* GadTools mutual exclude "button" image *)
(* New for V39: *)
  menucheck   * = 010H; (* Menu checkmark image *)
  amigakey    * = 011H; (* Menu Amiga-key image *)

(* Data values for IA_FrameType (recognized by FrameIClass)
 *
 * FRAME_DEFAULT:  The standard V37-type frame, which has
 *    thin edges.
 * FRAME_BUTTON:  Standard button gadget frames, having thicker
 *    sides and nicely edged corners.
 * FRAME_RIDGE:  A ridge such as used by standard string gadgets.
 *    You can recess the ridge to get a groove image.
 * FRAME_ICONDROPBOX: A broad ridge which is the standard imagery
 *    for areas in AppWindows where icons may be dropped.
 *)

  frameDefault     * =  0;
  frameButton      * =  1;
  frameRidge       * =  2;
  frameIconDropBox * =  3;


(* image message id's   *)
  imDraw       * = 0202H;  (* draw yourself, with "state"          *)
  imHitTest    * = 0203H;  (* return TRUE if click hits image      *)
  imErase      * = 0204H;  (* erase yourself                       *)
  imMove       * = 0205H;  (* draw new and erase old, smoothly     *)

  imDrawFrame  * = 0206H;  (* draw with specified dimensions       *)
  imFrameBox   * = 0207H;  (* get recommended frame around some box*)
  imHitFrame   * = 0208H;  (* hittest with dimensions              *)
  imEraseFrame * = 0209H; (* hittest with dimensions              *)

(* image draw states or styles, for IM_DRAW *)
(* Note that they have no bitwise meanings (unfortunately) *)
  idsNormal           * = 0;
  idsSelected         * = 1;    (* for selected gadgets     *)
  idsDisabled         * = 2;    (* for disabled gadgets     *)
  idsBusy             * = 3;    (* for future functionality *)
  idsIndeterminate    * = 4;    (* for future functionality *)
  idsInactiveNormal   * = 5;    (* normal, in inactive window border *)
  idsInactiveSelected * = 6;    (* selected, in inactive border *)
  idsInactiveDisabled * = 7;    (* disabled, in inactive border *)
  idsSelectedDisabled * = 8;    (* disabled and selected    *)

TYPE

(* IM_FRAMEBOX  *)
  FrameBox * = STRUCT (msg * : Msg)
    contentsBox * : IBoxPtr;       (* input: relative box of contents *)
    frameBox * : IBoxPtr;          (* output: rel. box of encl frame  *)
    drInfo * : DrawInfoPtr;
    frameFlags * : LONGSET;
  END;

CONST

  frameFSpecify * = 0;   (* Make do with the dimensions of FrameBox
                          * provided.
                          *)

TYPE
  Dimensions * = STRUCT  (* used by the following structs *)
    width * : INTEGER;
    height * : INTEGER;
  END;

(* IM_DRAW, IM_DRAWFRAME        *)
  Draw * = STRUCT (msg * : Msg)
    rPort * : g.RastPortPtr;
    offset * : g.Point;
    state * : LONGINT;
    drInfo * : DrawInfoPtr;

    (* these parameters only valid for IM_DRAWFRAME *)
    dimensions * : Dimensions;
  END;

(* IM_ERASE, IM_ERASEFRAME      *)
(* NOTE: This is a subset of impDraw    *)
  Erase * = STRUCT (msg * : Msg)
    rPort * : g.RastPortPtr;
    offset * : g.Point;

    (* these parameters only valid for IM_ERASEFRAME *)
    dimensions * : Dimensions;
  END;

(* IM_HITTEST, IM_HITFRAME      *)
  IMHitTest * = STRUCT (msg * : Msg)
    point * : g.Point;

    (* these parameters only valid for IM_HITFRAME *)
    dimensions * : Dimensions;
  END;

CONST

(* ---- pointer class --------------------------------------------- *)


(* The following tags are recognized at NewObject() time by
 * pointerclass:
 *
 * POINTERA_BitMap (struct BitMap * ) - Pointer to bitmap to
 *      get pointer imagery from.  Bitplane data need not be
 *      in chip RAM.
 * POINTERA_XOffset (LONG) - X-offset of the pointer hotspot.
 * POINTERA_YOffset (LONG) - Y-offset of the pointer hotspot.
 * POINTERA_WordWidth (ULONG) - designed width of the pointer in words
 * POINTERA_XResolution (ULONG) - one of the POINTERXRESN_ flags below
 * POINTERA_YResolution (ULONG) - one of the POINTERYRESN_ flags below
 *
 *)

  pointeraDummy       * =  u.user + 039000H;

  pointeraBitMap      * =  pointeraDummy + 001H;
  pointeraXOffset     * =  pointeraDummy + 002H;
  pointeraYOffset     * =  pointeraDummy + 003H;
  pointeraWordWidth   * =  pointeraDummy + 004H;
  pointeraXResolution * =  pointeraDummy + 005H;
  pointeraYResolution * =  pointeraDummy + 006H;

(* These are the choices for the POINTERA_XResolution attribute which
 * will determine what resolution pixels are used for this pointer.
 *
 * POINTERXRESN_DEFAULT (ECS-compatible pointer width)
 *      = 70 ns if SUPERHIRES-type mode, 140 ns if not
 *
 * POINTERXRESN_SCREENRES
 *      = Same as pixel speed of screen
 *
 * POINTERXRESN_LORES (pointer always in lores-like pixels)
 *      = 140 ns in 15kHz modes, 70 ns in 31kHz modes
 *
 * POINTERXRESN_HIRES (pointer always in hires-like pixels)
 *      = 70 ns in 15kHz modes, 35 ns in 31kHz modes
 *
 * POINTERXRESN_140NS (pointer always in 140 ns pixels)
 *      = 140 ns always
 *
 * POINTERXRESN_70NS (pointer always in 70 ns pixels)
 *      = 70 ns always
 *
 * POINTERXRESN_35NS (pointer always in 35 ns pixels)
 *      = 35 ns always
 *)

  pointerXResnDefault   * = 0;
  pointerXResn140ns     * = 1;
  pointerXResn70ns      * = 2;
  pointerXResn35ns      * = 3;

  pointerXResnScreenRes * = 4;
  pointerXResnLores     * = 5;
  pointerXResnHires     * = 6;

(* These are the choices for the POINTERA_YResolution attribute which
 * will determine what vertical resolution is used for this pointer.
 *
 * POINTERYRESN_DEFAULT
 *      = In 15 kHz modes, the pointer resolution will be the same
 *        as a non-interlaced screen.  In 31 kHz modes, the pointer
 *        will be doubled vertically.  This means there will be about
 *        200-256 pointer lines per screen.
 *
 * POINTERYRESN_HIGH
 * POINTERYRESN_HIGHASPECT
 *      = Where the hardware/software supports it, the pointer resolution
 *        will be high.  This means there will be about 400-480 pointer
 *        lines per screen.  POINTERYRESN_HIGHASPECT also means that
 *        when the pointer comes out double-height due to hardware/software
 *        restrictions, its width would be doubled as well, if possible
 *        (to preserve aspect).
 *
 * POINTERYRESN_SCREENRES
 * POINTERYRESN_SCREENRESASPECT
 *      = Will attempt to match the vertical resolution of the pointer
 *        to the screen's vertical resolution.  POINTERYRESN_SCREENASPECT also
 *        means that when the pointer comes out double-height due to
 *        hardware/software restrictions, its width would be doubled as well,
 *        if possible (to preserve aspect).
 *
 *)

  pointerYResnDefault         * = 0;
  pointerYResnHigh            * = 2;
  pointerYResnHighAspect      * = 3;
  pointerYResnScreenRes       * = 4;
  pointerYResnScreenResAspect * = 5;

(* Compatibility note:
 *
 * The AA chipset supports variable sprite width and resolution, but
 * the setting of width and resolution is global for all sprites.
 * When no other sprites are in use, Intuition controls the sprite
 * width and sprite resolution for correctness based on pointerclass
 * attributes specified by the creator of the pointer.  Intuition
 * controls sprite resolution with the VTAG_DEFSPRITERESN_SET tag
 * to VideoControl().  Applications can override this on a per-viewport
 * basis with the VTAG_SPRITERESN_SET tag to VideoControl().
 *
 * If an application uses a sprite other than the pointer sprite,
 * Intuition will automatically regenerate the pointer sprite's image in
 * a compatible width.  This might involve BitMap scaling of the imagery
 * you supply.
 *
 * If any sprites other than the pointer sprite were obtained with the
 * old GetSprite() call, Intuition assumes that the owner of those
 * sprites is unaware of sprite resolution, hence Intuition will set the
 * default sprite resolution (VTAG_DEFSPRITERESN_SET) to ECS-compatible,
 * instead of as requested by the various pointerclass attributes.
 *
 * No resolution fallback occurs when applications use ExtSprites.
 * Such applications are expected to use VTAG_SPRITERESN_SET tag if
 * necessary.
 *
 * NB:  Under release V39, only sprite width compatibility is implemented.
 * Sprite resolution compatibility was added for V40.
 *)


(* ======================================================================== *)
(* === Preferences ======================================================== *)
(* ======================================================================== *)

(* these are the definitions for the printer configurations *)
  filenameSize * = 30;      (* Filename size *)
  devNameSize  * = 16;      (* Device-name size *)

  pointerSize * = (1 + 16 + 1) * 2;    (* Size of Pointer data buffer *)

(* These defines are for the default font size.  These actually describe the
 * height of the defaults fonts.  The default font type is the topaz
 * font, which is a fixed width font that can be used in either
 * eighty-column or sixty-column mode.  The Preferences structure reflects
 * which is currently selected by the value found in the variable FontSize,
 * which may have either of the values defined below.  These values actually
 * are used to select the height of the default font.  By changing the
 * height, the resolution of the font changes as well.
 *)
  topazEighty * = 8;
  topazSixty * = 9;

TYPE
  Filename * = ARRAY filenameSize OF CHAR;

(* Note:  Starting with V36, and continuing with each new version of
 * Intuition, an increasing number of fields of struct Preferences
 * are ignored by SetPrefs().  (Some fields are obeyed only at the
 * initial SetPrefs(), which comes from the devs:system-configuration
 * file).  Elements are generally superseded as new hardware or software
 * features demand more information than fits in struct Preferences.
 * Parts of struct Preferences must be ignored so that applications
 * calling GetPrefs(), modifying some other part of struct Preferences,
 * then calling SetPrefs(), don't end up truncating the extended
 * data.
 *
 * Consult the autodocs for SetPrefs() for further information as
 * to which fields are not always respected.
 *)

  Preferences * = STRUCT

    (* the default font height *)
    fontHeight  * : SHORTINT;          (* height for system default font  *)

    (* constant describing what's hooked up to the port *)
    printerPort * : SHORTINT;          (* printer port connection         *)

    (* the baud rate of the port *)
    baudRate    * : INTEGER;           (* baud rate for the serial port   *)

    (* various timing rates *)
    keyRptSpeed * : t.TimeVal;         (* repeat speed for keyboard       *)
    keyRptDelay * : t.TimeVal;         (* Delay before keys repeat        *)
    doubleClick * : t.TimeVal;         (* Interval allowed between clicks *)

    (* Intuition Pointer data *)
    pointerMatrix * : ARRAY pointerSize OF INTEGER;  (* Definition of pointer sprite    *)
    xOffset      * : SHORTINT;         (* X-Offset for active 'bit'       *)
    yOffset      * : SHORTINT;         (* Y-Offset for active 'bit'       *)
    color17      * : INTEGER;          (***********************************)
    color18      * : INTEGER;          (* Colours for sprite pointer      *)
    color19      * : INTEGER;          (***********************************)
    pointerTicks * : INTEGER;          (* Sensitivity of the pointer      *)

    (* Workbench Screen colors *)
    color0 * : INTEGER;                (***********************************)
    color1 * : INTEGER;                (*  Standard default colours       *)
    color2 * : INTEGER;                (*   Used in the Workbench         *)
    color3 * : INTEGER;                (***********************************)

    (* positioning data for the Intuition View *)
    viewXOffset  * : SHORTINT;         (* Offset for top lefthand corner  *)
    viewYOffset  * : SHORTINT;         (* X and Y dimensions              *)
    viewInitX    * ,
    viewInitY    * : INTEGER;          (* View initial offset values      *)

    enableCLI    * : SET;              (* CLI availability switch *)

    (* printer configurations *)
    printerType     * : INTEGER;       (* printer type            *)
    printerFilename * : Filename;      (* file for printer        *)

    (* print format and quality configurations *)
    printPitch       * : INTEGER;      (* print pitch                     *)
    printQuality     * : INTEGER;      (* print quality                   *)
    printSpacing     * : INTEGER;      (* number of lines per inch        *)
    printLeftMargin  * : INTEGER;      (* left margin in characters       *)
    printRightMargin * : INTEGER;      (* right margin in characters      *)
    printImage       * : INTEGER;      (* positive or negative            *)
    printAspect      * : INTEGER;      (* horizontal or vertical          *)
    printShade       * : INTEGER;      (* b&w, half-tone, or color        *)
    printThreshold   * : INTEGER;      (* darkness ctrl for b/w dumps     *)

    (* print paper descriptors *)
    paperSize   * : INTEGER;           (* paper size                      *)
    paperLength * : INTEGER;           (* paper length in number of lines *)
    paperType   * : INTEGER;           (* continuous or single sheet      *)

    (* Serial device settings: These are six nibble-fields in three bytes *)
    (* (these look a little strange so the defaults will map out to zero) *)
    serRWBits  * : e.BYTE;              (* upper nibble = (8-number of read bits)   *)
                                       (* lower nibble = (8-number of write bits)   *)
    serStopBuf * : e.BYTE;             (* upper nibble = (number of stop bits - 1)  *)
                                       (* lower nibble = (table value for BufSize)  *)
    serParShk  * : e.BYTE;             (* upper nibble = (value for Parity setting) *)
                                       (* lower nibble = (value for Handshake mode) *)
    laceWB     * : SHORTSET;           (* if workbench is to be interlaced          *)

    pad        *: ARRAY 12 OF e.UBYTE;
    prtDevName *: ARRAY devNameSize OF CHAR; (* device used by printer.device
                                              * (omit the ".device")
                                              *)
    defaultPrtUnit * : SHORTINT;       (* default unit opened by printer.device *)
    defaultSerUnit * : SHORTINT;       (* default serial unit *)

    rowSizeChange    * : SHORTINT;     (* affect NormalDisplayRows/Columns     *)
    columnSizeChange * : SHORTINT;

    printFlags     * : SET;            (* user preference flags *)
    printMaxWidth  * : INTEGER;        (* max width of printed picture in 10ths/in  *)
    printMaxHeight * : INTEGER;        (* max height of printed picture in 10ths/in *)
    printDensity   * : SHORTINT;       (* print density *)
    printXOffset   * : SHORTINT;       (* offset of printed picture in 10ths/inch *)

    width   * : INTEGER;               (* override default workbench width  *)
    height  * : INTEGER;               (* override default workbench height *)
    depth   * : SHORTINT;              (* override default workbench depth  *)

    extSize * : SHORTINT;              (* extension information -- do not touch! *)
                                       (* extension size in blocks of 64 bytes   *)
  END;

CONST

(* Workbench Interlace (use one bit) *)
  laceWB          * = 0;
  lwReserved      * = 1;          (* internal use only *)

(* Enable_CLI   *)
  screenDrag      * = 14;
  mouseAccel      * = 15;

(* PrinterPort *)
  parallelPrinter * = 00H;
  serialPrinter   * = 01H;

(* BaudRate *)
  baud110      * = 000H;
  baud300      * = 001H;
  baud1200     * = 002H;
  baud2400     * = 003H;
  baud4800     * = 004H;
  baud9600     * = 005H;
  baud19200    * = 006H;
  baudMidi     * = 007H;

(* PaperType *)
  fanfold      * = 000H;
  single       * = 080H;

(* PrintPitch *)
  pica         * = 0000H;
  elite        * = 0400H;
  fine         * = 0800H;

(* PrintQuality *)
  draft        * = 0000H;
  letter       * = 0100H;

(* PrintSpacing *)
  sixLPI       * = 0000H;
  eightLPI     * = 0200H;

(* Print Image *)
  imagePositive * = 000H;
  imageNegative * = 001H;

(* PrintAspect *)
  aspectHoriz  * = 000H;
  aspectVert   * = 001H;

(* PrintShade *)
  shadeBW        * = 000H;
  shadeGreyScale * = 001H;
  shadeColor     * = 002H;

(* PaperSize (all paper sizes have a zero in the lowest nybble) *)
  usLetter     * = 000H;
  usLegal      * = 010H;
  nTractor     * = 020H;
  wTractor     * = 030H;
  custom       * = 040H;

(* PrinterType *)
  customName           * = 000H;
  alphaP101            * = 001H;
  brother15XL          * = 002H;
  cbmMps1000           * = 003H;
  diab630              * = 004H;
  diabAdvD25           * = 005H;
  diabC150             * = 006H;
  epson                * = 007H;
  epsonJX80            * = 008H;
  okimate20            * = 009H;
  qumeLP20             * = 00AH;
(* new printer entries, 3 October 1985 *)
  hpLaserjet           * = 00BH;
  hpLaserjetPlus       * = 00CH;

(* Serial Input Buffer Sizes *)
  buf512     * = 000H;
  buf1024    * = 001H;
  buf2048    * = 002H;
  buf4096    * = 003H;
  buf8000    * = 004H;
  buf16000   * = 005H;

(* Serial Bit Masks *)
  readBits    * = 0F0X; (* for SerRWBits   *)
  writeBits   * = 00FX;

  stopBits    * = 0F0X; (* for SerStopBuf  *)
  bufSizeBits * = 00FX;

  parityBits  * = 0F0X; (* for SerParShk   *)
  hShakeBits  * = 00FX;

(* Serial Parity (upper nibble, after being shifted by
 * macro SPARNUM() )
 *)
  parityNone  * = 0;
  parityEven  * = 1;
  parityOdd   * = 2;

(* Serial Handshake Mode (lower nibble, after masking using
 * macro SHANKNUM() )
 *)
  shakeXon   * = 0;
  shakeRts   * = 1;
  shakeNone  * = 2;

(* new defines for PrintFlags *)

  correctRed          * = 0;  (* color correct red shades *)
  correctGreen        * = 1;  (* color correct green shades *)
  correctBlue         * = 2;  (* color correct blue shades *)

  centerImage         * = 3;  (* center image on paper *)

  ignoreDimensions    * = {}; (* ignore max width/height settings *)
  boundedDimensions   * = 4;  (* use max width/height as boundaries *)
  absoluteDimensions  * = 5;  (* use max width/height as absolutes *)
  pixelDimensions     * = 6;  (* use max width/height as prt pixels *)
  multiplyDimensions  * = 7;  (* use max width/height as multipliers *)

  integerScaling      * = 8;  (* force integer scaling *)

  orderedDithering    * = {}; (* ordered dithering *)
  halftoneDithering   * = 9;  (* halftone dithering *)
  floydDithering      * = 10; (* Floyd-Steinberg dithering *)

  antiAlias           * = 11; (* anti-alias image *)
  greyScale2          * = 12; (* for use with hi-res monitor *)

(* masks used for checking bits *)

  correctRGBMask      * = {correctRed,correctGreen,correctBlue};
  dimensionsMask      * = {boundedDimensions,absoluteDimensions,pixelDimensions,multiplyDimensions};
  ditheringMask       * = {halftoneDithering,floydDithering};


(* ======================================================================== *)
(* === DrawInfo ========================================================= *)
(* ======================================================================== *)

(* This is a packet of information for graphics rendering.  It originates
 * with a Screen, and is gotten using GetScreenDrawInfo( screen );
 *)

(* You can use the Intuition version number to tell which fields are
 * present in this structure.
 *
 * DRI_VERSION of 1 corresponds to V37 release.
 * DRI_VERSION of 2 corresponds to V39, and includes three new pens
 *    and the dri_CheckMark and dri_AmigaKey fields.
 *
 * Note that sometimes applications need to create their own DrawInfo
 * structures, in which case the DRI_VERSION won't correspond exactly
 * to the OS version!!!
 *)

  driVersion * = 2;

TYPE
  DrawInfo * = STRUCT
    version * : INTEGER;      (* will be  DRI_VERSION                 *)
    numPens * : INTEGER;      (* guaranteed to be >= 9                *)
    pens * : DRIPenArrayPtr;  (* pointer to pen array                 *)

    font * : g.TextFontPtr;   (* screen default font                  *)
    depth * : INTEGER;        (* (initial) depth of screen bitmap     *)

    resolution * : g.Point;   (* from DisplayInfo database for initial display mode *)

    flags * : LONGSET;        (* defined below                *)
(* New for V39: dri_CheckMark, dri_AmigaKey. *)
    checkMark * : ImagePtr;   (* pointer to scaled checkmark image
                               * Will be NULL if DRI_VERSION < 2
                               *)
    amigaKey *: ImagePtr;      (* pointer to scaled Amiga-key image
                               * Will be NULL if DRI_VERSION < 2
                               *)
    reserved * : ARRAY 5 OF LONGINT;   (* avoid recompilation ;^)      *)
  END;

CONST
  (* DrawInfo.flags *)
  drifNewLook * = 0;    (* specified SA_Pens, full treatment *)

(* rendering pen number indexes into DrawInfo.dri_Pens[]        *)
  detailPen        * = 0000H;       (* compatible Intuition rendering pens  *)
  blockPen         * = 0001H;       (* compatible Intuition rendering pens  *)
  textPen          * = 0002H;       (* text on background                   *)
  shinePen         * = 0003H;       (* bright edge on 3D objects            *)
  shadowPen        * = 0004H;       (* dark edge on 3D objects              *)
  fillPen          * = 0005H;       (* active-window/selected-gadget fill   *)
  fillTextPen      * = 0006H;       (* text over FILLPEN                    *)
  backGroundPen    * = 0007H;       (* always color 0                       *)
  highLightTextPen * = 0008H;       (* special color text, on background    *)

(* New for V39, only present if DRI_VERSION >= 2: *)
  barDetailPen     * = 00009H;      (* text/detail in screen-bar/menus *)
  barBlockPen      * = 0000AH;      (* screen-bar/menus fill *)
  barTrimPen       * = 0000BH;      (* trim under screen-bar *)

  numDRIPens       * = 000CH;


(* New for V39:  It is sometimes useful to specify that a pen value
 * is to be the complement of color zero to three.  The "magic" numbers
 * serve that purpose:
 *)
  penC3 * =  0FEFCH;          (* Complement of color 3 *)
  penC2 * =  0FEFDH;          (* Complement of color 2 *)
  penC1 * =  0FEFEH;          (* Complement of color 1 *)
  penC0 * =  0FEFFH;          (* Complement of color 0 *)

TYPE
  DRIPenArray * = ARRAY numDRIPens OF INTEGER; (* you MUST NOT use an index
                                                * higher than allowed for
                                                * the actual DRI_VERSION
                                                *)

(* ======================================================================== *)
(* === Screen ============================================================= *)
(* ======================================================================== *)

(* VERY IMPORTANT NOTE ABOUT Screen->BitMap.  In the future, bitmaps
 * will need to grow.  The embedded instance of a bitmap in the screen
 * will no longer be large enough to hold the whole description of
 * the bitmap.
 *
 * YOU ARE STRONGLY URGED to use Screen->RastPort.BitMap in place of
 * &Screen->BitMap whenever and whereever possible.
 *)

  Screen * = STRUCT

    nextScreen * : ScreenPtr;           (* linked list of screens *)
    firstWindow * : WindowPtr;          (* linked list Screen's Windows *)

    leftEdge * , topEdge * : INTEGER;   (* parameters of the screen *)
    width * , height * : INTEGER;       (* parameters of the screen *)

    mouseY * , mouseX * : INTEGER;      (* position relative to upper-left *)

    flags * : SET;                      (* see definitions below *)

    title * : e.LSTRPTR;                (* null-terminated Title text *)
    defaultTitle * : e.LSTRPTR;         (* for Windows without ScreenTitle *)

    (* Bar sizes for this Screen and all Window's in this Screen *)
    (* Note that BarHeight is one less than the actual menu bar
     * height.  We're going to keep this in V36 for compatibility,
     * although V36 artwork might use that extra pixel
     *
     * Also, the title bar height of a window is calculated from the
     * screen's WBorTop field, plus the font height, plus one.
     *)
    barHeight * , barVBorder * , barHBorder * ,
    menuVBorder * , menuHBorder * : SHORTINT;
    wBorTop * , wBorLeft * , wBorRight * , wBorBottom * : SHORTINT;

    font * : g.TextAttrPtr;             (* this screen's default font      *)

    (* the display data structures for this Screen *)
    viewPort * : g.ViewPort;            (* describing the Screen's display *)
    rastPort * : g.RastPort;            (* describing Screen rendering     *)
    bitMap * : g.BitMap;                (* SEE WARNING ABOVE!              *)
    layerInfo * : g.LayerInfo;          (* each screen gets a LayerInfo    *)

    (* Only system gadgets may be attached to a screen.
     *  You get the standard system Screen Gadgets automatically
     *)
    firstGadget * : GadgetDummyPtr;

    detailPen * , blockPen * : SHORTINT;    (* for bar/border/gadget rendering *)

    (* the following variable(s) are maintained by Intuition to support the
     * DisplayBeep() color flashing technique
     *)
    saveColor0 * : INTEGER;

    (* This layer is for the Screen and Menu bars *)
    barLayer * : g.LayerPtr;

    extData * : e.APTR;

    userData * : e.APTR;    (* general-purpose pointer to User data extension *)

    (**** Data below this point are SYSTEM PRIVATE ****)

  END;

CONST

(* --- FLAGS SET BY INTUITION --------------------------------------------- *)
(* The SCREENTYPE bits are reserved for describing various Screen types
 * available under Intuition.
 *)
  screenType      * = {0..3};  (* all the screens types available      *)
(* --- the definitions for the Screen Type ------------------------------- *)
  wbenchScreen    * = 0;      (* identifies the Workbench screen      *)
  publicScreen    * = 1;      (* public shared (custom) screen        *)
  customScreen    * = {0..3}; (* original custom screens              *)

  showTitle       * = 4;  (* this gets set by a call to ShowTitle() *)

  beeping           = 5;  (* set when Screen is beeping (private)   *)

  customBitMap    * = 6;  (* if you are supplying your own BitMap   *)

  screenBehind    * = 7;  (* if you want your screen to open behind
                           * already open screens
                           *)
  screenQuiet     * = 8;  (* if you do not want Intuition to render
                           * into your screen (gadgets, title)
                           *)
  screenHires     * = 9;  (* do not use lowres gadgets  (private) *)

  nsExtended      * = 12;         (* ExtNewScreen.Extension is valid      *)
(* V36 applications can use OpenScreenTagList() instead of NS_EXTENDED       *)

  autoScroll      * = 14; (* screen is to autoscoll               *)

(* New for V39: *)
  penshared       * = 10;  (* Screen opener set {SA_SharePens,TRUE} *)



  stdScreenHeight * = -1; (* supply in NewScreen.height           *)
  stdScreenWidth  * = -1; (* supply in NewScreen.width            *)

(*
 * Screen attribute tag ID's.  These are used in the ti_Tag field of
 * TagItem arrays passed to OpenScreenTagList() (or in the
 * ExtNewScreen.Extension field).
 *)

(* Screen attribute tags.  Please use these versions, not those in
 * iobsolete.h.
 *)

  saDummy        * = u.user + 32;
(*
 * these items specify items equivalent to fields in NewScreen
 *)
  saLeft         * = saDummy + 00001H;
  saTop          * = saDummy + 00002H;
  saWidth        * = saDummy + 00003H;
  saHeight       * = saDummy + 00004H; (* traditional screen positions and dimensions  *)
  saDepth        * = saDummy + 00005H; (* screen bitmap depth                          *)
  saDetailPen    * = saDummy + 00006H; (* serves as default for windows, too           *)
  saBlockPen     * = saDummy + 00007H;
  saTitle        * = saDummy + 00008H; (* default screen title                         *)
  saColors       * = saDummy + 00009H;
                  (* ti_Data is an array of struct ColorSpec,
                   * terminated by ColorIndex = -1.  Specifies
                   * initial screen palette colors.
                   * Also see SA_Colors32 for use under V39.
                   *)
  saErrorCode    * = saDummy + 0000AH; (* ti_Data points to LONG error code (values below)*)
  saFont         * = saDummy + 0000BH; (* equiv. to NewScreen.Font                     *)
  saSysFont      * = saDummy + 0000CH;
                  (* Selects one of the preferences system fonts:
                   *      0 - old DefaultFont, fixed-width
                   *      1 - WB Screen preferred font
                   *)
  saType         * = saDummy + 0000DH;
                  (* ti_Data is PUBLICSCREEN or CUSTOMSCREEN.  For other
                   * fields of NewScreen.Type, see individual tags,
                   * eg. SA_Behind, SA_Quiet.
                   *)
  saBitMap       * = saDummy + 0000EH;
                  (* ti_Data is pointer to custom BitMap.  This
                   * implies type of CUSTOMBITMAP
                   *)
  saPubName      * = saDummy + 0000FH;
                  (* presence of this tag means that the screen
                   * is to be a public screen.  Please specify
                   * BEFORE the two tags below
                   *)
  saPubSig       * = saDummy + 00010H;
  saPubTask      * = saDummy + 00011H;
                  (* Task ID and signal for being notified that
                   * the last window has closed on a public screen.
                   *)
  saDisplayID    * = saDummy + 00012H;
                  (* ti_Data is new extended display ID from
                   * <graphics/displayinfo.h> (V37) or from
                   * <graphics/modeid.h> (V39 and up)
                   *)
  saDClip        * = saDummy + 00013H;
                  (* ti_Data points to a rectangle which defines
                   * screen display clip region
                   *)
  saOverscan     * = saDummy + 00014H;
                  (* Set to one of the oScan
                   * specifiers below to get a system standard
                   * overscan region for your display clip,
                   * screen dimensions (unless otherwise specified),
                   * and automatically centered position (partial
                   * support only so far).
                   * If you use this, you shouldn't specify
                   * saDClip.  saOverscan is for "standard"
                   * overscan dimensions, saDClip is for
                   * your custom numeric specifications.
                   *)
  saObsolete1    * = saDummy + 00015H; (* obsolete S_MONITORNAME *)

(** booleans **)
  saShowTitle    * = saDummy + 00016H; (* boolean equivalent to flag SHOWTITLE         *)
  saBehind       * = saDummy + 00017H; (* boolean equivalent to flag SCREENBEHIND      *)
  saQuiet        * = saDummy + 00018H; (* boolean equivalent to flag SCREENQUIET       *)
  saAutoScroll   * = saDummy + 00019H; (* boolean equivalent to flag AUTOSCROLL        *)
  saPens         * = saDummy + 0001AH;
                  (* pointer to ~0 terminated UWORD array, as
                   * found in struct DrawInfo
                   *)
  saFullPalette  * = saDummy + 0001BH;
                  (* boolean: initialize color table to entire
                   *  preferences palette (32 for V36), rather
                   * than compatible pens 0-3, 17-19, with
                   * remaining palette as returned by GetColorMap()
                   *)
  saColorMapEntries * = saDummy + 0001CH;
                      (* New for V39:
                       * Allows you to override the number of entries
                       * in the ColorMap for your screen.  Intuition
                       * normally allocates (1<<depth) or 32, whichever
                       * is more, but you may require even more if you
                       * use certain V39 graphics.library features
                       * (eg. palette-banking).
                       *)

  saParent       * = saDummy + 0001DH;
                      (* New for V39:
                       * ti_Data is a pointer to a "parent" screen to
                       * attach this one to.  Attached screens slide
                       * and depth-arrange together.
                       *)

  saDraggable    * = saDummy + 0001EH;
                      (* New for V39:
                       * Boolean tag allowing non-draggable screens.
                       * Do not use without good reason!
                       * (Defaults to TRUE).
                       *)

  saExclusive    * = saDummy + 0001FH;
                      (* New for V39:
                       * Boolean tag allowing screens that won't share
                       * the display.  Use sparingly!  Starting with 3.01,
                       * attached screens may be SA_Exclusive.  Setting
                       * SA_Exclusive for each screen will produce an
                       * exclusive family.   (Defaults to FALSE).
                       *)

  saSharePens    * = saDummy + 00020H;
                      (* New for V39:
                       * For those pens in the screen's DrawInfo->dri_Pens,
                       * Intuition obtains them in shared mode (see
                       * graphics.library/ObtainPen()).  For compatibility,
                       * Intuition obtains the other pens of a public
                       * screen as PEN_EXCLUSIVE.  Screens that wish to
                       * manage the pens themselves should generally set
                       * this tag to TRUE.  This instructs Intuition to
                       * leave the other pens unallocated.
                       *)

  saBackFill     * = saDummy + 00021H;
                      (* New for V39:
                       * provides a "backfill hook" for your screen's
                       * Layer_Info.
                       * See layers.library/InstallLayerInfoHook()
                       *)

  saInterleaved  * = saDummy + 00022H;
                      (* New for V39:
                       * Boolean tag requesting that the bitmap
                       * allocated for you be interleaved.
                       * (Defaults to FALSE).
                       *)

  saColors32     * = saDummy + 00023H;
                      (* New for V39:
                       * Tag to set the screen's initial palette colors
                       * at 32 bits-per-gun.  ti_Data is a pointer
                       * to a table to be passed to the
                       * graphics.library/LoadRGB32() function.
                       * This format supports both runs of color
                       * registers and sparse registers.  See the
                       * autodoc for that function for full details.
                       * Any color set here has precedence over
                       * the same register set by SA_Colors.
                       *)

  saVideoControl * = saDummy + 00024H;
                      (* New for V39:
                       * ti_Data is a pointer to a taglist that Intuition
                       * will pass to graphics.library/VideoControl(),
                       * upon opening the screen.
                       *)

  saFrontChild   * = saDummy + 00025H;
                      (* New for V39:
                       * ti_Data is a pointer to an already open screen
                       * that is to be the child of the screen being
                       * opened.  The child screen will be moved to the
                       * front of its family.
                       *)

  saBackChild    * = saDummy + 00026H;
                      (* New for V39:
                       * ti_Data is a pointer to an already open screen
                       * that is to be the child of the screen being
                       * opened.  The child screen will be moved to the
                       * back of its family.
                       *)

  saLikeWorkbench * = saDummy + 00027H;
                      (* New for V39:
                       * Set ti_Data to 1 to request a screen which
                       * is just like the Workbench.  This gives
                       * you the same screen mode, depth, size,
                       * colors, etc., as the Workbench screen.
                       *)

  saReserved       = saDummy + 00028H;
                      (* Reserved for private Intuition use *)

  saMinimizeISG * =  saDummy + 00029H;
                        (* New for V40:
                         * For compatibility, Intuition always ensures
                         * that the inter-screen gap is at least three
                         * non-interlaced lines.  If your application
                         * would look best with the smallest possible
                         * inter-screen gap, set ti_Data to TRUE.
                         * If you use the new graphics VideoControl()
                         * VC_NoColorPaletteLoad tag for your screen's
                         * ViewPort, you should also set this tag.
                         *)


(* OpenScreen error codes, which are returned in the (optional) LONG
 * pointed to by ti_Data for the saErrorCode tag item
 *)
  osErrNoMonitor * = 1;     (* named monitor spec not available     *)
  osErrNoChips   * = 2;     (* you need newer custom chips          *)
  osErrNoMem     * = 3;     (* couldn't get normal memory           *)
  osErrNoChipMem * = 4;     (* couldn't get chipmem                 *)
  osErrPubNotUnique * = 5;  (* public screen name already used      *)
  osErrUnknownMode  * = 6;  (* don't recognize mode asked for       *)
  oserrTooDeep      * = 7;  (* Screen deeper than HW supports       *)
  oserrAttachFail   * = 8;  (* Failed to attach screens             *)
  oserrNotAvailable * = 9;  (* Mode not available for other reason  *)


TYPE
(* ======================================================================== *)
(* === NewScreen ========================================================== *)
(* ======================================================================== *)
(* note: to use the Extended field, you must use the
 * new ExtNewScreen structure, below
 *)
  NewScreen * = STRUCT

    leftEdge * , topEdge * , width * , height * , depth * : INTEGER;  (* screen dimensions *)

    detailPen * , blockPen * : SHORTINT; (* for bar/border/gadget rendering      *)

    viewModes * : SET;                   (* the Modes for the ViewPort (and View) *)

    type * : SET;                        (* the Screen type (see defines above)  *)

    font * : g.TextAttrPtr;              (* this Screen's default text attributes *)

    defaultTitle * : e.LSTRPTR;          (* the default title for this Screen    *)

    gadgets * : GadgetDummyPtr;          (* UNUSED:  Leave this NULL             *)

    (* if you are opening a CUSTOMSCREEN and already have a BitMap
     * that you want used for your Screen, you set the flags CUSTOMBITMAP in
     * the Type field and you set this variable to point to your BitMap
     * structure.  The structure will be copied into your Screen structure,
     * after which you may discard your own BitMap if you want
     *)
    customBitMap * : g.BitMapPtr;

  END;

(*
 * For compatibility reasons, we need a new structure for extending
 * NewScreen.  Use this structure is you need to use the new Extension
 * field.
 *
 * NOTE: V36-specific applications should use the
 * OpenScreenTagList( newscreen, tags ) version of OpenScreen().
 * Applications that want to be V34-compatible as well may safely use the
 * ExtNewScreen structure.  Its tags will be ignored by V34 Intuition.
 *
 *)
  ExtNewScreen * = STRUCT (ns * : NewScreen)

    extension * : u.TagListPtr; (* more specification data, scanned if
                                 * NS_EXTENDED is set in NewScreen.Type
                                 *)
  END;

CONST

(* === Overscan Types ===       *)
  oScanText      * = 1;     (* entirely visible     *)
  oScanStandard  * = 2;     (* just past edges      *)
  oScanMax       * = 3;     (* as much as possible  *)
  oScanVideo     * = 4;     (* even more than is possible   *)


TYPE

(* === Public Shared Screen Node ===    *)

(* This is the representative of a public shared screen.
 * This is an internal data structure, but some functions may
 * present a copy of it to the calling application.  In that case,
 * be aware that the screen pointer of the structure can NOT be
 * used safely, since there is no guarantee that the referenced
 * screen will remain open and a valid data structure.
 *
 * Never change one of these.
 *)

  PubScreenNode * = STRUCT (node * : e.Node) (* ln_Name is screen name *)
    screen * : ScreenPtr;
    flags * : SET;            (* see below            *)
    size * : INTEGER;         (* includes name buffer *)
    visitorCount * : INTEGER; (* how many visitor windows *)
    sigTask * : e.TaskPtr;    (* who to signal when visitors gone *)
    sigBit * : SHORTINT;      (* which signal *)
  END;

CONST
  psnfPrivate * = 0;

  maxPubScreenName * = 139;   (* names no longer, please      *)

(* pub screen modes     *)
  shanghai      * = 0;  (* put workbench windows on pub screen *)
  popPubScreen  * = 1;  (* pop pub screen to front when visitor opens *)

(* New for V39:  Intuition has new screen depth-arrangement and movement
 * functions called ScreenDepth() and ScreenPosition() respectively.
 * These functions permit the old behavior of ScreenToFront(),
 * ScreenToBack(), and MoveScreen().  ScreenDepth() also allows
 * independent depth control of attached screens.  ScreenPosition()
 * optionally allows positioning screens even though they were opened
 * {SA_Draggable,FALSE}.
 *)

(* For ScreenDepth(), specify one of SDEPTH_TOFRONT or SDEPTH_TOBACK,
 * and optionally also SDEPTH_INFAMILY.
 *
 * NOTE: ONLY THE OWNER OF THE SCREEN should ever specify
 * SDEPTH_INFAMILY.  Commodities, "input helper" programs,
 * or any other program that did not open a screen should never
 * use that flag.  (Note that this is a style-behavior
 * requirement;  there is no technical requirement that the
 * task calling this function need be the task which opened
 * the screen).
 *)

  sdepthToFront  * = LONGSET{};     (* Bring screen to front *)
  sdepthToBack   * = LONGSET{0};    (* Send screen to back *)
  sdepthInFamily * = LONGSET{1};    (* Move an attached screen with
                             * respect to other screens of its family
                             *)

(* Here's an obsolete name equivalent to SDEPTH_INFAMILY: *)
  sdepthChildOnly * = sdepthInFamily;


(* For ScreenPosition(), specify one of SPOS_RELATIVE, SPOS_ABSOLUTE,
 * or SPOS_MAKEVISIBLE to describe the kind of screen positioning you
 * wish to perform:
 *
 * SPOS_RELATIVE: The x1 and y1 parameters to ScreenPosition() describe
 *    the offset in coordinates you wish to move the screen by.
 * SPOS_ABSOLUTE: The x1 and y1 parameters to ScreenPosition() describe
 *    the absolute coordinates you wish to move the screen to.
 * SPOS_MAKEVISIBLE: (x1,y1)-(x2,y2) describes a rectangle on the
 *    screen which you would like autoscrolled into view.
 *
 * You may additionally set SPOS_FORCEDRAG along with any of the
 * above.  Set this if you wish to reposition an {SA_Draggable,FALSE}
 * screen that you opened.
 *
 * NOTE: ONLY THE OWNER OF THE SCREEN should ever specify
 * SPOS_FORCEDRAG.  Commodities, "input helper" programs,
 * or any other program that did not open a screen should never
 * use that flag.
 *)

  sposRelative   * = LONGSET{};   (* Coordinates are relative *)

  sposAbsolute   * = LONGSET{0};  (* Coordinates are expressed as
                                   * absolutes, not relatives.
                                   *)

  sposMakeVisible * = LONGSET{1}; (* Coordinates describe a box on
                                   * the screen you wish to be
                                   * made visible by autoscrolling
                                   *)

  sposForceDrag  * = LONGSET{2};  (* Move non-draggable screen *)


TYPE
(* New for V39: Intuition supports double-buffering in screens,
 * with friendly interaction with menus and certain gadgets.
 * For each buffer, you need to get one of these structures
 * from the AllocScreenBuffer() call.  Never allocate your
 * own ScreenBuffer structures!
 *
 * The sb_DBufInfo field is for your use.  See the graphics.library
 * AllocDBufInfo() autodoc for details.
 *)
  ScreenBuffer * = STRUCT
     bitMap * : g.BitMapPtr;         (* BitMap of this buffer *)
    dBufInfo *: g.DBufInfoPtr;     (* DBufInfo for this buffer *)
  END;

CONST
(* These are the flags that may be passed to AllocScreenBuffer().
 *)
  sbScreenBitMap * = 0;
  sbCopyBitMap   * = 1;

TYPE

  StringExtend * = STRUCT
    (* display specifications   *)
    font * : g.TextFontPtr;              (* must be an open Font (not TextAttr)  *)
    pens * : ARRAY 2 OF SHORTINT;        (* color of text/background             *)
    activePens * : ARRAY 2 OF SHORTINT;  (* colors when gadget is active         *)

    (* edit specifications      *)
    initialMode * : LONGSET;             (* inital mode flags, below             *)
    editHook * : u.HookPtr;              (* if non-NULL, must supply WorkBuffer  *)
    workBuffer * : e.APTR;               (* must be as large as StringInfo.Buffer*)

    reserved * : ARRAY 4 OF LONGINT;     (* set to 0                             *)
  END;

  SGWork * = STRUCT
    (* set up when gadget is first activated    *)
    gadget * : GadgetDummyPtr;     (* the contestant itself        *)
    stringInfo * : StringInfoPtr;  (* easy access to sinfo         *)
    workBuffer * : e.APTR;         (* intuition's planned result   *)
    prevBuffer * : e.APTR;         (* what was there before        *)
    modes * : LONGSET;             (* current mode                 *)

    (* modified for each input event    *)
    iEvent * : ie.InputEventDummyPtr;(* actual event: do not change*)
    code * : INTEGER;              (* character code, if one byte  *)
    bufferPos * : INTEGER;         (* cursor position              *)
    numChars * : INTEGER;
    actions * : LONGSET;           (* what Intuition will do       *)
    longInt * : LONGINT;           (* temp storage for longint     *)

    gadgetInfo * : GadgetInfoPtr;  (* see cghooks.h                *)
    editOp * : INTEGER;            (* from constants below         *)
  END;

CONST

(* SGWork.editOp -
 * These values indicate what basic type of operation the global
 * editing hook has performed on the string before your gadget's custom
 * editing hook gets called.  You do not have to be concerned with the
 * value your custom hook leaves in the EditOp field, only if you
 * write a global editing hook.
 *
 * For most of these general edit operations, you'll want to compare
 * the BufferPos and NumChars of the StringInfo (before global editing)
 * and SGWork (after global editing).
 *)

  eoNoOp        * = 01H; (* did nothing                                                  *)
  eoDelBackward * = 02H; (* deleted some chars (maybe 0).                                *)
  eoDelForward  * = 03H; (* deleted some characters under and in front of the cursor     *)
  eoMoveCursor  * = 04H; (* moved the cursor                                             *)
  eoEnter       * = 05H; (* "enter" or "return" key, terminate                           *)
  eoReset       * = 06H; (* current Intuition-style undo                                 *)
  eoReplaceChar * = 07H; (* replaced one character and (maybe) advanced cursor           *)
  eoInsertChar  * = 08H; (* inserted one char into string or added one at end            *)
  eoBadFormat   * = 09H; (* didn't like the text data, e.g., Bad LONGINT                 *)
  eoBigChange   * = 0AH; (* complete or major change to the text, e.g. new string        *) (* unused by Intuition  *)
  eoUndo        * = 0BH; (* some other style of undo                                     *) (* unused by Intuition  *)
  eoClear       * = 0CH; (* clear the string                                             *)
  eoSpecial     * = 0DH; (* some operation that doesn't fit into the categories here     *) (* unused by Intuition  *)


(* Mode Flags definitions (ONLY first group allowed as InitialModes)    *)
  sgmReplace     * = 0;          (* replace mode                 *)
(* please initialize StringInfo with in-range value of BufferPos
 * if you are using sgmREPLACE mode.
 *)

  sgmFixedField  * = 1;          (* fixed length buffer          *)
                                 (* always set sgmREPLACE, too  *)
  sgmNoFilter    * = 2;          (* don't filter control chars   *)

(* SGM_EXITHELP is new for V37, and ignored by V36: *)
  sgmExitHelp    * = 7;          (* exit with code = 0x5F if HELP hit *)


(* These Mode Flags are for internal use only                           *)
  sgmNoChange    * = 3;          (* no edit changes yet          *)
  sgmNoWorkB     * = 4;          (* Buffer == PrevBuffer         *)
  sgmControl     * = 5;          (* control char escape mode     *)
  sgmLongint     * = 6;          (* an intuition longint gadget  *)

(* String Gadget Action Flags (put in SGWork.Actions by EditHook)       *)
  sgaUse         * = 0;  (* use contents of SGWork               *)
  sgaEnd         * = 1;  (* terminate gadget, code in Code field *)
  sgaBeep        * = 2;  (* flash the screen for the user        *)
  sgaReuse       * = 3;  (* reuse input event                    *)
  sgaRedisplay   * = 4;  (* gadget visuals changed               *)

(* New for V37: *)
  sgaNextActive  * = 5;  (* Make next possible gadget active.    *)
  sgaPrevActive  * = 6;  (* Make previous possible gadget active.*)

(* function id for only existing custom string gadget edit hook *)

  sghKey         * = 1;  (* process editing keystroke            *)
  sghClick       * = 2;  (* process mouse click cursor position  *)

(* Here's a brief summary of how the custom string gadget edit hook works:
 *    You provide a hook in StringInfo.Extension.EditHook.
 *    The hook is called in the standard way with the 'object'
 *    a pointer to SGWork, and the 'message' a pointer to a command
 *    block, starting either with (longword) sghKEY, sghCLICK,
 *    or something new.
 *
 *    You return 0 if you don't understand the command (sghKEY is
 *    required and assumed).  Return non-zero if you implement the
 *    command.
 *
 * sghKEY:
 *
 *    There are no parameters following the command longword.
 *
 *    Intuition will put its idea of proper values in the SGWork
 *    before calling you, and if you leave sgaUSE set in the
 *    SGWork.Actions field, Intuition will use the values
 *    found in SGWork fields WorkBuffer, NumChars, BufferPos,
 *    and LongInt, copying the WorkBuffer back to the StringInfo
 *    Buffer.
 *
 *    NOTE WELL: You may NOT change other SGWork fields.
 *
 *    If you clear sgaUSE, the string gadget will be unchanged.
 *
 *    If you set sgaEND, Intuition will terminate the activation
 *    of the string gadget.  If you also set sgaREUSE, Intuition
 *    will reuse the input event after it deactivates your gadget.
 *
 *    In this case, Intuition will put the value found in SGWork.Code
 *    into the IntuiMessage.Code field of the IDCMP_GADGETUP message it
 *    sends to the application.
 *
 *    If you set sgaBEEP, Intuition will call DisplayBeep(); use
 *    this if the user has typed in error, or buffer is full.
 *
 *    Set sgaREDISPLAY if the changes to the gadget warrant a
 *    gadget redisplay.  Note: cursor movement requires a redisplay.
 *
 *    Starting in V37, you may set SGA_PREVACTIVE or SGA_NEXTACTIVE
 *    when you set SGA_END.  This tells Intuition that you want
 *    the next or previous gadget with GFLG_TABCYCLE to be activated.
 *
 * sghCLICK:
 *    This hook command is called when Intuition wants to position
 *    the cursor in response to a mouse click in the string gadget.
 *
 *    Again, here are no parameters following the command longword.
 *
 *    This time, Intuition has already calculated the mouse position
 *    character cell and put it in SGWork.BufferPos.  The previous
 *    BufferPos value remains in the SGWork.StringInfo.BufferPos.
 *
 *    Intuition will again use the SGWork fields listed above for
 *    sghKEY.  One restriction is that you are NOT allowed to set
 *    sgaEND or sgaREUSE for this command.  Intuition will not
 *    stand for a gadget which goes inactive when you click in it.
 *
 *    You should always leave the sgaREDISPLAY flag set, since Intuition
 *    uses this processing when activating a string gadget.
 *)

(* IntuitionBase: *)

(* these are the display modes for which we have corresponding parameter
 *  settings in the config arrays
 *)
  dModeCount    * = 2;    (* how many modes there are *)
  hiresPick     * = 0;
  lowresPick    * = 1;

  eventMax * = 10;        (* size of event array *)

(* these are the system Gadget defines *)
  resCount      * = 2;
  hiresGadget   * = 0;
  lowresGadget  * = 1;

  gadgetCount     * = 8;
  upFrontGadget   * = 0;
  downBackGadget  * = 1;
  sizeGadget      * = 2;
  closeGadget     * = 3;
  dragGadget      * = 4;
  sUpFrontGadget  * = 5;
  sDownBackGadget * = 6;
  sDragGadget     * = 7;


(* ======================================================================== *)
(* === IntuitionBase ====================================================== *)
(* ======================================================================== *)
(*
 * Be sure to protect yourself against someone modifying these data as
 * you look at them.  This is done by calling:
 *
 * lock = LockIBase(0), which returns a ULONG.  When done call
 * UnlockIBase(lock) where lock is what LockIBase() returned.
 *)

TYPE

(* This structure is strictly READ ONLY *)
  IntuitionBase * = STRUCT (libNode - : e.Library)

    viewLord - : g.View;

    activeWindow - : WindowPtr;
    activeScreen - : ScreenPtr;

    (* the FirstScreen variable points to the frontmost Screen.  Screens are
     * then maintained in a front to back order using Screen.NextScreen
     *)
    firstScreen - : ScreenPtr; (* for linked list of all screens *)

    flags   : LONGSET;         (* values are all system private *)
    mouseY - , mouseX - : INTEGER;
                               (* note "backwards" order of these              *)

    time - : t.TimeVal         (* timestamp of most current input event *)

    (* I told you this was private.
     * The data beyond this point has changed, is changing, and
     * will continue to change.
     *)

  END;

(* Boolean Parameters must be 4 Bytes long: *)

TYPE
  LONGBOOL * = e.LONGBOOL;

CONST
  LTRUE  * = e.LTRUE;
  LFALSE * = e.LFALSE;


VAR
 int *, base * : IntuitionBasePtr;


PROCEDURE OpenIntuition  *{int,- 30}();
PROCEDURE Intuition      *{int,- 36}(iEvent{8}        : ie.InputEventDummyPtr);
PROCEDURE AddGadget      *{int,- 42}(window{8}        : WindowPtr;
                                     VAR gadget{9}    : Gadget;
                                     position{0}      : LONGINT): INTEGER;
PROCEDURE ClearDMRequest *{int,- 48}(window{8}        : WindowPtr): BOOLEAN;
PROCEDURE ClearMenuStrip *{int,- 54}(window{8}        : WindowPtr);
PROCEDURE ClearPointer   *{int,- 60}(window{8}        : WindowPtr);
PROCEDURE CloseScreen    *{int,- 66}(screen{8}        : ScreenPtr): BOOLEAN;
PROCEDURE OldCloseScreen *{int,- 66}(screen{8}        : ScreenPtr); (* version<36 had no result *)
PROCEDURE CloseWindow    *{int,- 72}(window{8}        : WindowPtr);
PROCEDURE CloseWorkBench *{int,- 78}(): BOOLEAN;
PROCEDURE CurrentTime    *{int,- 84}(VAR seconds{8}   : LONGINT;
                                     VAR micros{9}    : LONGINT);
PROCEDURE DisplayAlert   *{int,- 90}(alertNumber{0}   : LONGINT;
                                     string{8}        : ARRAY OF CHAR;
                                     height{1}        : LONGINT): BOOLEAN;
PROCEDURE DisplayBeep    *{int,- 96}(screen{8}        : ScreenPtr);
PROCEDURE DoubleClick    *{int,-102}(sSeconds{0}      : LONGINT;
                                     sMicros{1}       : LONGINT;
                                     cSeconds{2}      : LONGINT;
                                     cMicros{3}       : LONGINT): BOOLEAN;
PROCEDURE DrawBorder     *{int,-108}(rp{8}            : g.RastPortPtr;
                                     border{9}        : BorderPtr;
                                     leftOffset{0}    : LONGINT;
                                     topOffset{1}     : LONGINT);
PROCEDURE DrawImage      *{int,-114}(rp{8}            : g.RastPortPtr;
                                     image{9}         : Image;
                                     leftOffset{0}    : LONGINT;
                                     topOffset{1}     : LONGINT);
PROCEDURE EndRequest     *{int,-120}(requester{8}     : RequesterPtr;
                                     window{9}        : WindowPtr);
PROCEDURE GetDefPrefs    *{int,-126}(VAR preferences{8} : ARRAY OF e.BYTE;
                                     size{0}          : LONGINT);
PROCEDURE GetPrefs       *{int,-132}(VAR preferences{8} : ARRAY OF e.BYTE;
                                     size{0}          : LONGINT);
PROCEDURE InitRequester  *{int,-138}(VAR requester{8} : Requester);
PROCEDURE ItemAddress    *{int,-144}(menuStrip{8}     : Menu;
                                     menuNumber{0}    : LONGINT):  MenuItemPtr;
PROCEDURE ModifyIDCMP    *{int,-150}(window{8}        : WindowPtr;
                                     flags{0}         : LONGSET): BOOLEAN;
PROCEDURE OldModifyIDCMP *{int,-150}(window{8}        : WindowPtr;
                                     flags{0}         : LONGSET);
PROCEDURE ModifyProp     *{int,-156}(VAR gadget{8}    : Gadget;
                                     window{9}        : WindowPtr;
                                     requester{10}    : RequesterPtr;
                                     flags{0}         : SET;
                                     horizPot{1}      : LONGINT;
                                     vertPot{2}       : LONGINT;
                                     horizBody{3}     : LONGINT;
                                     vertBody{4}      : LONGINT);
PROCEDURE MoveScreen     *{int,-162}(screen{8}        : ScreenPtr;
                                     dx{0}            : LONGINT;
                                     dy{1}            : LONGINT);
PROCEDURE MoveWindow     *{int,-168}(window{8}        : WindowPtr;
                                     dx{0}            : LONGINT;
                                     dy{1}            : LONGINT);
PROCEDURE OffGadget      *{int,-174}(VAR gadget{8}    : Gadget;
                                     window{9}        : WindowPtr;
                                     requester{10}    : RequesterPtr);
PROCEDURE OffMenu        *{int,-180}(window{8}        : WindowPtr;
                                     menuNumber{0}    : LONGINT);
PROCEDURE OnGadget       *{int,-186}(VAR gadget{8}    : Gadget;
                                     window{9}        : WindowPtr;
                                     requester{10}    : RequesterPtr);
PROCEDURE OnMenu         *{int,-192}(window{8}        : WindowPtr;
                                     menuNumber{0}    : LONGINT);
PROCEDURE OpenScreen     *{int,-198}(newScreen{8}     : NewScreen): ScreenPtr;
PROCEDURE OpenWindow     *{int,-204}(newWindow{8}     : NewWindow ): WindowPtr;
PROCEDURE OpenWorkBench  *{int,-210}(): ScreenPtr;
PROCEDURE PrintIText     *{int,-216}(rp{8}            : g.RastPortPtr;
                                     iText{9}         : IntuiText;
                                     left{0}          : LONGINT;
                                     top{1}           : LONGINT);
PROCEDURE RefreshGadgets *{int,-222}(gadgets{8}       : GadgetDummyPtr;
                                     window{9}        : WindowPtr;
                                     requester{10}    : RequesterPtr);
PROCEDURE RemoveGadget   *{int,-228}(window{8}        : WindowPtr;
                                     VAR gadget{9}    : Gadget): INTEGER;
PROCEDURE ReportMouse    *{int,-234}(window{8}        : WindowPtr;
                                     flag{0}          : LONGBOOL);
PROCEDURE Request        *{int,-240}(requester{8}     : RequesterPtr;
                                     window{9}        : WindowPtr ): BOOLEAN;
PROCEDURE ScreenToBack   *{int,-246}(screen{8}        : ScreenPtr);
PROCEDURE ScreenToFront  *{int,-252}(screen{8}        : ScreenPtr);
PROCEDURE SetDMRequest   *{int,-258}(window{8}        : WindowPtr;
                                     requester{9}     : RequesterPtr): BOOLEAN;
PROCEDURE SetMenuStrip   *{int,-264}(window{8}        : WindowPtr;
                                     VAR menu{9}      : Menu): BOOLEAN;
PROCEDURE SetPointer     *{int,-270}(window{8}        : WindowPtr;
                                     pointer{9}       : ARRAY OF e.BYTE;
                                     height{0}        : LONGINT;
                                     width{1}         : LONGINT;
                                     xOffset{2}       : LONGINT;
                                     yOffset{3}       : LONGINT);
PROCEDURE SetWindowTitles*{int,-276}(window{8}        : WindowPtr;
                                     windowTitle{9}   : e.ADDRESS;
                                     screenTitle{10}  : e.ADDRESS);
PROCEDURE SetWindowTitlesStr*{int,-276}(window{8}        : WindowPtr;
                                     windowTitle{9}   : ARRAY OF CHAR;
                                     screenTitle{10}  : ARRAY OF CHAR);
PROCEDURE ShowTitle      *{int,-282}(screen{8}        : ScreenPtr;
                                     showIt{0}        : LONGBOOL);
PROCEDURE SizeWindow     *{int,-288}(window{8}        : WindowPtr;
                                     dx{0}            : LONGINT;
                                     dy{1}            : LONGINT);
PROCEDURE ViewAddress    *{int,-294}(): g.ViewPtr;
PROCEDURE ViewPortAddress*{int,-300}(window{8}        : WindowPtr): g.ViewPortPtr;
PROCEDURE WindowToBack   *{int,-306}(window{8}        : WindowPtr);
PROCEDURE WindowToFront  *{int,-312}(window{8}        : WindowPtr);
PROCEDURE WindowLimits   *{int,-318}(window{8}        : WindowPtr;
                                     widthMin{0}      : LONGINT;
                                     heightMin{1}     : LONGINT;
                                     widthMax{2}      : LONGINT;
                                     heightMax{3}     : LONGINT): BOOLEAN;
(*--- start of next generation of names -------------------------------------*)
PROCEDURE SetPrefs       *{int,-324}(preferences{8}   : ARRAY OF e.BYTE;
                                     size{0}          : LONGINT;
                                     inform{1}        : LONGBOOL);
(*--- start of next next generation of names --------------------------------*)
PROCEDURE IntuiTextLength*{int,-330}(iText{8}         : IntuiText): INTEGER;
PROCEDURE WBenchToBack   *{int,-336}(): BOOLEAN;
PROCEDURE WBenchToFront  *{int,-342}(): BOOLEAN;
(*--- start of next next next generation of names ---------------------------*)
PROCEDURE AutoRequest    *{int,-348}(window{8}        : WindowPtr;
                                     body{9}          : IntuiTextPtr;
                                     posText{10}      : IntuiTextPtr;
                                     negText{11}      : IntuiTextPtr;
                                     pFlag{0}         : LONGSET;
                                     nFlag{1}         : LONGSET;
                                     width{2}         : LONGINT;
                                     height{3}        : LONGINT): BOOLEAN;
PROCEDURE BeginRefresh   *{int,-354}(window{8}        : WindowPtr);
PROCEDURE BuildSysRequest*{int,-360}(window{8}        : WindowPtr;
                                     body{9}          : IntuiTextPtr;
                                     posText{10}      : IntuiTextPtr;
                                     negText{11}      : IntuiTextPtr;
                                     flags{0}         : LONGSET;
                                     width{1}         : LONGINT;
                                     height{2}        : LONGINT): WindowPtr;
PROCEDURE EndRefresh     *{int,-366}(window{8}        : WindowPtr;
                                     complete{0}      : LONGBOOL);
PROCEDURE FreeSysRequest *{int,-372}(window{8}        : WindowPtr);
PROCEDURE OldMakeScreen     *{int,-378}(screen{8}        : ScreenPtr);
PROCEDURE OldRemakeDisplay  *{int,-384}();
PROCEDURE OldRethinkDisplay *{int,-390}();
(* The return codes for MakeScreen(), RemakeDisplay(), and RethinkDisplay() *)
(* are only valid under V39 and greater.  Do not examine them when running *)
(* on pre-V39 systems! *)
PROCEDURE MakeScreen     *{int,-378}(screen{8}        : ScreenPtr): LONGINT;
PROCEDURE RemakeDisplay  *{int,-384}(): LONGINT;
PROCEDURE RethinkDisplay *{int,-390}(): LONGINT;
(*--- start of next next next next generation of names ----------------------*)
PROCEDURE AllocRemember  *{int,-396}(VAR rememberKey{8} : RememberPtr;
                                     size{0}          : LONGINT;
                                     flags{1}         : LONGSET): e.APTR;
PROCEDURE AlohaWorkbench *{int,-402}(wbport{8}        : e.MsgPortPtr);
PROCEDURE FreeRemember   *{int,-408}(VAR rememberKey{8} : RememberPtr;
                                     reallyForget{0}  : LONGBOOL);
(*--- start of 15 Nov 85 names ------------------------*)
PROCEDURE LockIBase      *{int,-414}(dontknow{0}      : LONGINT): LONGINT;
PROCEDURE UnlockIBase    *{int,-420}(ibLock{8}        : LONGINT);
(*--- functions in V33 or higher (Release 1.2) ---*)
PROCEDURE GetScreenData  *{int,-426}(VAR buffer{8}    : Screen;
                                     size{0}          : LONGINT;
                                     type{1}          : SET;
                                     screen{9}        : ScreenPtr): BOOLEAN;
PROCEDURE RefreshGList   *{int,-432}(gadgets{8}       : GadgetDummyPtr;
                                     window{9}        : WindowPtr;
                                     requester{10}    : RequesterPtr;
                                     numGad{0}        : LONGINT);
PROCEDURE AddGList       *{int,-438}(window{8}        : WindowPtr;
                                     gadget{9}        : GadgetDummyPtr;
                                     position{0}      : LONGINT;
                                     numGad{1}        : LONGINT;
                                     requester{10}    : RequesterPtr): INTEGER;
PROCEDURE RemoveGList    *{int,-444}(remPtr{8}        : WindowPtr;
                                     gadget{9}        : GadgetDummyPtr;
                                     numGad{0}        : LONGINT): INTEGER;
PROCEDURE ActivateWindow *{int,-450}(window{8}        : WindowPtr); (* no result, even for V36+ *)
PROCEDURE RefreshWindowFrame*{int,-456}(window{8}     : WindowPtr);
PROCEDURE ActivateGadget *{int,-462}(VAR gadget{8}    : Gadget;
                                     window{9}        : WindowPtr;
                                     requester{10}    : RequesterPtr): BOOLEAN;
PROCEDURE NewModifyProp  *{int,-468}(VAR gadget{8}    : Gadget;
                                     window{9}        : WindowPtr;
                                     requester{10}    : RequesterPtr;
                                     flags{0}         : SET;
                                     horizPot{1}      : LONGINT;
                                     vertPot{2}       : LONGINT;
                                     horizBody{3}     : LONGINT;
                                     vertBody{4}      : LONGINT;
                                     numGad{5}        : LONGINT);
(*--- functions in V36 or higher (Release 2.0) ---*)
(*---     REMEMBER: You are to check int.libNode.version !    ---*)
PROCEDURE QueryOverscan  *{int,-474}(displayID{8}     : LONGINT;
                                     VAR rect{9}      : g.Rectangle;
                                     oScanType{0}     : LONGINT): LONGINT;
PROCEDURE MoveWindowInFrontOf*{int,-480}(window{8}    : WindowPtr;
                                         behindWin{9} : WindowPtr);
PROCEDURE ChangeWindowBox*{int,-486}(window{8}        : WindowPtr;
                                     left{0}          : LONGINT;
                                     top{1}           : LONGINT;
                                     width{2}         : LONGINT;
                                     height{3}        : LONGINT);
PROCEDURE SetEditHook    *{int,-492}(hook{8}          : u.HookPtr): u.HookPtr;
PROCEDURE SetMouseQueue  *{int,-498}(window{8}        : LONGINT;
                                     queueLength{0}   : LONGINT): LONGINT;
PROCEDURE ZipWindow      *{int,-504}(window{8}        : WindowPtr);
(*--- public screens ---*)
PROCEDURE LockPubScreen  *{int,-510}(name{8}          : ARRAY OF CHAR): ScreenPtr;
PROCEDURE UnlockPubScreen*{int,-516}(name{8}          : ARRAY OF CHAR;
                                     screen{9}        : ScreenPtr);
PROCEDURE LockPubScreenList*{int,-522}(): e.ListPtr;
PROCEDURE UnlockPubScreenList*{int,-528}();
PROCEDURE NextPubScreen  *{int,-534}(screen{8}        : ScreenPtr;
                                     VAR name{9}      : ARRAY OF CHAR): e.LSTRPTR;
PROCEDURE SetDefaultPubScreen*{int,-540}(name{8}      : ARRAY OF CHAR);
PROCEDURE SetPubScreenModes*{int,-546}(modes{0}       : SET): SET;
PROCEDURE PubScreenStatus*{int,-552}(screen{8}        : ScreenPtr;
                                     statusFlags{0}   : SET): SET;
(**)
PROCEDURE ObtainGIRPort  *{int,-558}(gInfo{8}         : GadgetInfoPtr): g.RastPortPtr;
PROCEDURE ReleaseGIRPort *{int,-564}(rp{8}            : g.RastPortPtr);
PROCEDURE GadgetMouse    *{int,-570}(VAR gadget{8}    : Gadget;
                                     gInfo{9}         : GadgetInfoPtr;
                                     VAR mousePoint{10} : g.Point);
(* SetIPrefs is system private and not to be used by applications *)
PROCEDURE SetIPrefs       {int,-576}(ptr{8}           : e.APTR;
                                     size{0}          : LONGINT;
                                     type{1}          : LONGINT);
PROCEDURE GetDefaultPubScreen*{int,-582}(VAR nameBuffer{8} : ARRAY OF CHAR);
PROCEDURE EasyRequestArgs*{int,-588}(window{8}        : WindowPtr;
                                     easyStruct{9}    : EasyStructPtr;
                                     idcmpPtr{10}     : e.APTR;
                                     args{11}         : e.APTR): LONGINT;
PROCEDURE EasyRequest    *{int,-588}(window{8}        : WindowPtr;
                                     easyStruct{9}    : EasyStructPtr;
                                     idcmpPtr{10}     : e.APTR;
                                     arg1{11}..       : e.APTR): LONGINT;
PROCEDURE BuildEasyRequestArgs*{int,-594}(window{8}   : WindowPtr;
                                     easyStruct{9}    : EasyStructPtr;
                                     idcmp{0}         : LONGSET;
                                     args{11}         : e.APTR): WindowPtr;
PROCEDURE BuildEasyRequest*{int,-594}(window{8}       : WindowPtr;
                                     easyStruct{9}    : EasyStructPtr;
                                     idcmp{0}         : LONGSET;
                                     arg1{11}..       : e.APTR): WindowPtr;
PROCEDURE SysReqHandler  *{int,-600}(window{8}        : WindowPtr;
                                     idcmpPtr{9}      : e.APTR;
                                     waitInput{0}     : LONGBOOL): LONGINT;
PROCEDURE OpenWindowTagList*{int,-606}(newWindow{8}   : NewWindow;
                                     tagList{9}       : ARRAY OF u.TagItem): WindowPtr;
PROCEDURE OpenWindowTags *{int,-606}(newWindow{8}     : NewWindow;
                                     tag1{9}..        : u.Tag): WindowPtr;
PROCEDURE OpenWindowTagListA*{int,-606}(newWindow{8}  : NewWindowPtr;
                                     tagList{9}       : ARRAY OF u.TagItem): WindowPtr;
PROCEDURE OpenWindowTagsA *{int,-606}(newWindow{8}    : NewWindowPtr;
                                     tag1{9}..        : u.Tag): WindowPtr;
PROCEDURE OpenScreenTagList*{int,-612}(newScreen{8}   : NewScreen;
                                     tagList{9}       : ARRAY OF u.TagItem): ScreenPtr;
PROCEDURE OpenScreenTags *{int,-612}(newScreen{8}     : NewScreen;
                                     tag1{9}..        : u.Tag): ScreenPtr;
PROCEDURE OpenScreenTagListA*{int,-612}(newScreen{8}   : NewScreenPtr;
                                     tagList{9}       : ARRAY OF u.TagItem): ScreenPtr;
PROCEDURE OpenScreenTagsA *{int,-612}(newScreen{8}     : NewScreenPtr;
                                     tag1{9}..        : u.Tag): ScreenPtr;
(**)
(*      new Image functions *)
PROCEDURE DrawImageState *{int,-618}(rp{8}            : g.RastPortPtr;
                                     image{9}         : Image;
                                     leftOffset{0}    : LONGINT;
                                     topOffset{1}     : LONGINT;
                                     state{2}         : LONGINT;
                                     drawInfo{10}     : DrawInfoPtr);
PROCEDURE PointInImageL  *{int,-624}(point{0}         : LONGINT;
                                     image{8}         : Image): BOOLEAN;

PROCEDURE EraseImage     *{int,-630}(rp{8}            : g.RastPortPtr;
                                     image{9}         : Image;
                                     leftOffset{0}    : LONGINT;
                                     topOffset{1}     : LONGINT);
(**)
PROCEDURE NewObjectA     *{int,-636}(class{8}         : IClassPtr;
                                     classID{9}       : ARRAY OF CHAR;
                                     tagList{10}      : ARRAY OF u.TagItem): e.APTR;
PROCEDURE NewObject      *{int,-636}(class{8}         : IClassPtr;
                                     classID{9}       : ARRAY OF CHAR;
                                     tag1{10}..       : u.Tag): e.APTR;
(**)
PROCEDURE DisposeObject  *{int,-642}(object{8}        : e.APTR);
PROCEDURE SetAttrsA      *{int,-648}(object{8}        : e.APTR;
                                     tagList{9}       : ARRAY OF u.TagItem): LONGINT;
PROCEDURE SetAttrs       *{int,-648}(object{8}        : e.APTR;
                                     tag1{9}..        : u.Tag): LONGINT;
(**)
PROCEDURE GetAttr        *{int,-654}(attrID{0}        : LONGINT;
                                     object{8}        : e.APTR;
                                     VAR storage{9}   : ARRAY OF e.BYTE): LONGINT;
(**)
(*      special set attribute call for gadgets *)
PROCEDURE SetGadgetAttrsA*{int,-660}(VAR gadget{8}    : Gadget;
                                     window{9}        : WindowPtr;
                                     requester{10}    : RequesterPtr;
                                     tagList{11}      : ARRAY OF u.TagItem): LONGINT;
PROCEDURE SetGadgetAttrs *{int,-660}(VAR gadget{8}    : Gadget;
                                     window{9}        : WindowPtr;
                                     requester{10}    : RequesterPtr;
                                     tag1{11}..       : u.Tag): LONGINT;
(**)
(*      for class implementors only *)
PROCEDURE NextObject     *{int,-666}(VAR objectPtr{8} : ObjectPtr): e.APTR;
PROCEDURE FindClass      *{int,-672}(classID{8}       : ARRAY OF CHAR): IClassPtr;
PROCEDURE MakeClass      *{int,-678}(classID{8}       : ARRAY OF CHAR;
                                     superClassID{9}  : ARRAY OF CHAR;
                                     superClassPtr{10}: IClassPtr;
                                     instanceSize{0}  : LONGINT;
                                     flags{1}         : LONGSET): IClassPtr;
PROCEDURE AddClass       *{int,-684}(class{8}         : IClassPtr);
(**)
(**)
PROCEDURE GetScreenDrawInfo*{int,-690}(screen{8}      : ScreenPtr): DrawInfoPtr;
PROCEDURE FreeScreenDrawInfo*{int,-696}(screen{8}     : ScreenPtr;
                                     drawInfo{9}      : DrawInfoPtr);
(**)
PROCEDURE ResetMenuStrip *{int,-702}(window{8}        : WindowPtr;
                                     VAR menu{9}      : Menu): BOOLEAN;
PROCEDURE RemoveClass    *{int,-708}(classPtr{8}      : IClassPtr);
PROCEDURE FreeClass      *{int,-714}(classPtr{8}      : IClassPtr): BOOLEAN;

(*--- functions in V39 or higher (Release 3) ---*)
PROCEDURE AllocScreenBuffer *{int,-0300H}(sc{8}       : ScreenPtr;
                                          bm{9}       : g.BitMapPtr;
                                          flags{0}    : LONGSET): ScreenBufferPtr;
PROCEDURE FreeScreenBuffer  *{int,-0306H}(sc{8}       : ScreenPtr;
                                          sb{9}       : ScreenBufferPtr);
PROCEDURE ChangeScreenBuffer*{int,-030CH}(sc{8}       : ScreenPtr;
                                          sb{9}       : ScreenBufferPtr): BOOLEAN;
PROCEDURE ScreenDepth       *{int,-0312H}(screen{8}   : ScreenPtr;
                                          flags{0}    : LONGSET;
                                          reserved{9} : e.APTR);
PROCEDURE ScreenPosition    *{int,-0318H}(screen{8}   : ScreenPtr;
                                          flags{0}    : LONGSET;
                                          x1{1}       : LONGINT;
                                          y1{2}       : LONGINT;
                                          x2{3}       : LONGINT;
                                          y2{4}       : LONGINT);
PROCEDURE ScrollWindowRaster *{int,-031EH}(win{9}     : WindowPtr;
                                          dx{0}       : LONGINT;
                                          dy{1}       : LONGINT;
                                          xMin{2}     : LONGINT;
                                          yMin{3}     : LONGINT;
                                          xMax{4}     : LONGINT;
                                          yMax{5}     : LONGINT);
PROCEDURE LendMenus         *{int,-0324H}(fromWin{8}  : WindowPtr;
                                          toWindow{9} : WindowPtr);
PROCEDURE DoGadgetMethodA   *{int,-032AH}(gad{8}      : GadgetPtr;
                                          win{9}      : WindowPtr;
                                          eq{10}      : RequesterPtr;
                                          message{11} : Msg): LONGINT;
PROCEDURE DoGadgetMethod    *{int,-032AH}(gad{8}      : GadgetPtr;
                                          win{9}      : WindowPtr;
                                          req{10}     : RequesterPtr;
                                          MethodID{11}..: e.ADDRESS): LONGINT;
PROCEDURE SetWindowPointerA *{int,-0330H}(win{8}      : WindowPtr;
                                          taglist{9}  : ARRAY OF u.TagItem);
PROCEDURE SetWindowPointer  *{int,-0330H}(win{8}      : WindowPtr;
                                          tag1{9}..   : u.Tag);
PROCEDURE TimedDisplayAlert *{int,-0336H}(alertNum{0} : LONGINT;
                                          string{8}   : ARRAY OF CHAR;
                                          height{1}   : LONGINT;
                                          time{9}     : LONGINT): BOOLEAN;
PROCEDURE HelpControl       *{int,-033CH}(win{8}      : WindowPtr;
                                          flags{0}    : LONGSET);

(*=========================================================================*)

PROCEDURE PointInImage * (point: g.Point; image: Image): BOOLEAN;
BEGIN RETURN PointInImageL(y.VAL(LONGINT,point),image); END PointInImage;

(* === MACROS ============================================================ *)

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

PROCEDURE MenuNum * (n{0}: INTEGER): INTEGER;
BEGIN RETURN y.VAL(INTEGER,      y.VAL(SET,n)      * {0..4}) END MenuNum;

PROCEDURE ItemNum * (n{0}: INTEGER): INTEGER;
BEGIN RETURN y.VAL(INTEGER,y.LSH(y.VAL(SET,n),- 5) * {0..5}) END ItemNum;

PROCEDURE SubNum  * (n{0}: INTEGER): INTEGER;
BEGIN RETURN y.VAL(INTEGER,y.LSH(y.VAL(SET,n),-11) * {0..4}) END SubNum;


PROCEDURE ShiftMenu * (n{0}: INTEGER): INTEGER;
BEGIN RETURN y.VAL(INTEGER,      y.VAL(SET,n) * {0..4}    ) END ShiftMenu;

PROCEDURE ShiftItem * (n{0}: INTEGER): INTEGER;
BEGIN RETURN y.VAL(INTEGER,y.LSH(y.VAL(SET,n) * {0..5}, 5)) END ShiftItem;

PROCEDURE ShiftSub  * (n{0}: INTEGER): INTEGER;
BEGIN RETURN y.VAL(INTEGER,y.LSH(y.VAL(SET,n) * {0..4},11)) END ShiftSub;

PROCEDURE FullMenuNum * (menu, item, sub: INTEGER): INTEGER;
BEGIN RETURN ShiftMenu(menu) + ShiftItem(item) + ShiftSub(sub) END FullMenuNum;


(* Preferences.ser...: *)

PROCEDURE SRBNum  * (n{0}: e.BYTE): INTEGER; BEGIN RETURN 8 - ORD(n) DIV 16 END SRBNum;
PROCEDURE SWBNum  * (n{0}: e.BYTE): INTEGER; BEGIN RETURN 8 - ORD(n) MOD 16 END SWBNum;
PROCEDURE SSBNum  * (n{0}: e.BYTE): INTEGER; BEGIN RETURN 1 + ORD(n) DIV 16 END SSBNum;
PROCEDURE SPARNum * (n{0}: e.BYTE): INTEGER; BEGIN RETURN     ORD(n) DIV 16 END SPARNum;
PROCEDURE SHAKNum * (n{0}: e.BYTE): INTEGER; BEGIN RETURN     ORD(n) MOD 16 END SHAKNum;


(* this casts MutualExclude for easy assignment of a hook
 * pointer to the unused MutualExclude field of a custom gadget
 *)
PROCEDURE CustomHook * (VAR g{8}: Gadget): u.HookPtr;
BEGIN RETURN y.VAL(u.HookPtr,g.mutualExclude) END CustomHook;


(* some convenient macros and casts *)
PROCEDURE GadgetBox * (VAR g{8}: Gadget): IBoxPtr;  BEGIN RETURN y.ADR(g.leftEdge) END GadgetBox;
PROCEDURE IMBox     * (VAR i{8}: Image ): IBoxPtr;  BEGIN RETURN y.ADR(i.leftEdge) END IMBox;
PROCEDURE FGPen     * (VAR i{8}: Image ): SHORTINT; BEGIN RETURN y.VAL(SHORTINT,i.planePick ) END FGPen;
PROCEDURE BGPen     * (VAR i{8}: Image ): SHORTINT; BEGIN RETURN y.VAL(SHORTINT,i.planeOnOff) END BGPen;

(*------  Special:  ------*)

(* convert BOOLEANs to LONGBOOLs: *)

PROCEDURE BoolToLong*(b{0}: BOOLEAN): LONGBOOL;
BEGIN IF b THEN RETURN LTRUE ELSE RETURN LFALSE END
END BoolToLong;

(* Convert pseudo unsigned integers (like those within PropInfo) to
 * LONGINTs and vice versa:
 *)

PROCEDURE UIntToLong*(i{0}: INTEGER): LONGINT;
BEGIN
  IF i<0 THEN RETURN i+10000H
         ELSE RETURN i        END;
END UIntToLong;


PROCEDURE LongToUInt*(l{0}: LONGINT): INTEGER;
BEGIN
(* $RangeChk- Tricky: just return lower Word *)
  RETURN SHORT(l)
(* $RangeChk= *)
END LongToUInt;


(*-----------------------------------------------------------------------*)
(*
 * The following procedures are implemented for to avoid using SYSTEM within
 * Oberon programs.
 *)

PROCEDURE ScreenToRastPort*(s{8}: ScreenPtr): g.RastPortPtr;
BEGIN RETURN y.ADR(s.rastPort); END ScreenToRastPort;

PROCEDURE ScreenToViewPort*(s{8}: ScreenPtr): g.ViewPortPtr;
BEGIN RETURN y.ADR(s.viewPort); END ScreenToViewPort;

(*-----------------------------------------------------------------------*)

BEGIN
  int :=  e.OpenLibrary(intuitionName,33);
  IF int = NIL THEN HALT(20) END;
  base := int;

CLOSE
  IF int#NIL THEN e.CloseLibrary(int) END;

END Intuition.
