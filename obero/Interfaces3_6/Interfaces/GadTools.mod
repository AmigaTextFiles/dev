(*
(*
**  Amiga Oberon Interface Module:
**  $VER: GadTools.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE GadTools;

IMPORT
  e   * := Exec,
  u   * := Utility,
  I   * := Intuition,
  g   * := Graphics,
  SYSTEM *;

CONST
  gadtoolsName * = "gadtools.library";


(*------------------------------------------------------------------------*)
CONST

(* The kinds (almost classes) of gadgets that GadTools supports.
 * Use these identifiers when calling CreateGadgetA()
 *)

  genericKind    * = 0;
  buttonKind     * = 1;
  checkBoxKind   * = 2;
  integerKind    * = 3;
  listViewKind   * = 4;
  mxKind         * = 5;
  numberKind     * = 6;
  cycleKind      * = 7;
  paletteKind    * = 8;
  scrollerKind   * = 9;
(* Kind number 10 is reserved *)
  sliderKind     * = 11;
  stringKind     * = 12;
  textKind       * = 13;

  numKinds       * = 14;

(*------------------------------------------------------------------------*)

(*  'Or' the appropriate set together for your Window IDCMPFlags: *)

  arrowIDCMP      * = LONGSET{I.gadgetUp,I.gadgetDown,I.intuiTicks,I.mouseButtons};

  buttonIDCMP     * = LONGSET{I.gadgetUp};
  checkBoxIDCMP   * = LONGSET{I.gadgetUp};
  integerIDCMP    * = LONGSET{I.gadgetUp};
  listViewIDCMP   * = LONGSET{I.gadgetUp,I.gadgetDown,I.mouseMove} + arrowIDCMP;

  mxIDCMP         * = LONGSET{I.gadgetDown};
  numberIDCMP     * = LONGSET{};
  cycleIDCMP      * = LONGSET{I.gadgetUp};
  paletteIDCMP    * = LONGSET{I.gadgetUp};

(*  Use arrowIDCMP + scrollerIDCMP if your scrollers have arrows: *)
  scrollerIDCMP   * = LONGSET{I.gadgetUp,I.gadgetDown,I.mouseMove};
  sliderIDCMP     * = LONGSET{I.gadgetUp,I.gadgetDown,I.mouseMove};
  stringIDCMP     * = LONGSET{I.gadgetUp};

  textIDCMP       * = LONGSET{};

(*------------------------------------------------------------------------*)

TYPE

  VisualInfo * = UNTRACED POINTER TO STRUCT END;   (* returned by GetVisualInfo() *)

(*  Generic NewGadget used by several of the gadget classes: *)

  NewGadgetPtr * = UNTRACED POINTER TO NewGadget;
  NewGadget * = STRUCT
    leftEdge * , topEdge * : INTEGER;       (*  gadget position *)
    width * , height * : INTEGER;           (*  gadget size *)
    gadgetText * : e.LSTRPTR;               (*  gadget label *)
    textAttr * : g.TextAttrPtr;             (*  desired font for gadget label *)
    gadgetID * : INTEGER;                   (*  gadget ID *)
    flags * : LONGSET;                      (*  see below *)
    visualInfo * : VisualInfo;              (*  Set to retval of GetVisualInfo() *)
    userData * : e.APTR;                    (*  gadget UserData *)
  END;

CONST

(* NewGadsget.flags control certain aspects of the gadget.  The first five
 * the placement of the descriptive text.  Each gadget kind has its default,
 * which is usually PLACETEXT_LEFT.  Consult the autodocs for details.
 *)

  placeTextLeft   * = 0;  (* Right-align text on left side *)
  placeTextRight  * = 1;  (* Left-align text on right side *)
  placeTextAbove  * = 2;  (* Center text above *)
  placeTextBelow  * = 3;  (* Center text below *)
  placeTextIn     * = 4;  (* Center text on *)

  highLabel       * = 5;  (* Highlight the label *)

(*------------------------------------------------------------------------*)

TYPE

(* Fill out an array of these and pass that to CreateMenus(): *)

  NewMenuPtr * = UNTRACED POINTER TO NewMenu;
  NewMenu * = STRUCT
    type * : SHORTINT;              (*  See below *)
    label * : e.LSTRPTR;            (*  Menu's label *)
    commKey * : e.LSTRPTR;          (*  MenuItem Command Key Equiv *)
    flags * : SET;                  (*  Menu or MenuItem flags (see note) *)
    mutualExclude * : LONGSET;      (*  MenuItem MutualExclude word *)
    userData * : e.APTR;            (*  For your own use, see note *)
  END;

CONST
(* Needed only by inside IM_ definitions below *)
  menuImage * = -128;

(* nm_Type determines what each NewMenu structure corresponds to.
 * for the NM_TITLE, NM_ITEM, and NM_SUB values, nm_Label should
 * be a text string to use for that menu title, item, or sub-item.
 * For IM_ITEM or IM_SUB, set nm_Label to point at the Image structure
 * you wish to use for this item or sub-item.
 * NOTE: At present, you may only use conventional images.
 * Custom images created from Intuition image-classes do not work.
 *)
  title     * = 1;          (* Menu header *)
  item      * = 2;          (* Textual menu item *)
  sub       * = 3;          (* Textual menu sub-item *)

  imItem    * = item + menuImage;  (* Graphical menu item *)
  imSub     * = sub  + menuImage;  (* Graphical menu sub-item *)

(* The NewMenu array should be terminated with a NewMenu whose
 * nm_Type equals NM_END.
 *)
  end       * = 0;          (* End of NewMenu array *)

(* Starting with V39, GadTools will skip any NewMenu entries whose
 * nm_Type field has the NM_IGNORE bit set.
 *)
  nmIgnore  * = 64;

(* nm_Label should be a text string for textual items, a pointer
 * to an Image structure for graphical menu items, or the special
 * constant NM_BARLABEL, to get a separator bar.
 *)
  barLabel  * = SYSTEM.VAL(e.LSTRPTR,-1);


(* The nm_Flags field is used to fill out either the Menu->Flags or
 * MenuItem->Flags field.  Note that the sense of the MENUENABLED or
 * ITEMENABLED bit is inverted between this use and Intuition's use,
 * in other words, NewMenus are enabled by default.  The following
 * labels are provided to disable them:
 *)
  menuDisabled * = I.menuEnabled;
  itemDisabled * = I.itemEnabled;

(* New for V39:  NM_COMMANDSTRING.  For a textual MenuItem or SubItem,
 * point nm_CommKey at an arbitrary string, and set the NM_COMMANDSTRING
 * flag.
 *)
  commandString * = I.commSeq;

(* The following are pre-cleared (COMMSEQ, ITEMTEXT, and HIGHxxx are set
 * later as appropriate):
 * Under V39, the COMMSEQ flag bit is not cleared, since it now has
 * meaning.
 *)
  flagMask    * = -({I.commSeq,I.itemText}+I.highFlags);
  flagMaskV39 * = -({I.itemText}+I.highFlags);

(* You may choose among CHECKIT, MENUTOGGLE, and CHECKED.
 * Toggle-select menuitems are of type CHECKIT|MENUTOGGLE, along
 * with CHECKED if currently selected.        Mutually exclusive ones
 * are of type CHECKIT, and possibly CHECKED too.  The nm_MutualExclude
 * is a bit-wise representation of the items excluded by this one,
 * so in the simplest case (choose 1 among n), these flags would be
 * ~1, ~2, ~4, ~8, ~16, etc.  See the Intuition Menus chapter.
 *)

(*  These return codes can be obtained through the GTMN_ErrorCode tag *)
  gtMenuTrimmed   * = 000000001H;      (* Too many menus, items, or subitems,
                                        * menu has been trimmed down
                                        *)
  gtMenuInvalide  * = 000000002H;      (* Invalid NewMenu array *)
  gtMenuNoMem     * = 000000003H;      (* Out of memory *)

(*------------------------------------------------------------------------*)

(* Starting with V39, checkboxes and mx gadgets can be scaled to your
 * specified gadget width/height.  Use the new GTCB_Scaled or GTMX_Scaled
 * tags, respectively.        Under V37, and by default in V39, the imagery
 * is of the following fixed size:
 *)

(* MX gadget default dimensions: *)
  mxWidth        * = 17;
  mxHeight       * =  9;

(* Checkbox default dimensions: *)
  checkboxWidth  * = 26;
  checkboxHeight * = 11;


(*------------------------------------------------------------------------*)

(*  Tags for toolkit functions: *)

  tagBase           * = u.user + 80000H;

  viNewWindow       * = tagBase+1;   (* Unused *)
  viNWTags          * = tagBase+2;   (* Unused *)

  Private0            = tagBase+3;   (* (private) *)

  cbChecked         * = tagBase+4;   (* State of checkbox *)

  lvTop             * = tagBase+5;   (* Top visible one in listview *)
  lvLabels          * = tagBase+6;   (* List to display in listview *)

  noList * = SYSTEM.VAL(e.ListPtr,-1); (* for short list locking (see RKMs) *)

  lvReadOnly        * = tagBase+7;   (* TRUE if listview is to be
                                      * read-only
                                      *)
  lvScrollWidth     * = tagBase+8;   (* Width of scrollbar *)

  mxLabels          * = tagBase+9;   (* NULL-terminated array of labels *)
  mxActive          * = tagBase+10;  (* Active one in mx gadget *)

  txText            * = tagBase+11;  (* Text to display *)
  txCopyText        * = tagBase+12;  (* Copy text label instead of referencing it *)

  nmNumber          * = tagBase+13;  (* Number to display *)

  cyLabels          * = tagBase+14;  (* NULL-terminated array of labels *)
  cyActive          * = tagBase+15;  (* The active one in the cycle gad *)

  paDepth           * = tagBase+16;  (* Number of bitplanes in palette *)
  paColor           * = tagBase+17;  (* Palette color *)
  paColorOffset     * = tagBase+18;  (* First color to use in palette *)
  paIndicatorWidth  * = tagBase+19;  (* Width of current-color indicator *)
  paIndicatorHeight * = tagBase+20;  (* Height of current-color indicator *)

  scTop             * = tagBase+21;  (* Top visible in scroller *)
  scTotal           * = tagBase+22;  (* Total in scroller area *)
  scVisible         * = tagBase+23;  (* Number visible in scroller *)
  scOverlap         * = tagBase+24;  (* Unused *)

(*  tagBase+25 through tagBase+37 are reserved *)

  slMin             * = tagBase+38;  (* Slider min value *)
  slMax             * = tagBase+39;  (* Slider max value *)
  slLevel           * = tagBase+40;  (* Slider level *)
  slMaxLevelLen     * = tagBase+41;  (* Max length of printed level *)
  slLevelFormat     * = tagBase+42;  (* Format string for level *)
  slLevelPlace      * = tagBase+43;  (* Where level should be placed *)
  slDispFunc        * = tagBase+44;  (* Callback for number calculation
                                      * before display
                                      *)
  stString          * = tagBase+45;  (* String gadget's displayed string *)
  stMaxChars        * = tagBase+46;  (* Max length of string *)

  inNumber          * = tagBase+47;  (* Number in integer gadget *)
  inMaxChars        * = tagBase+48;  (* Max number of digits *)

  mnTextAttr        * = tagBase+49;  (* MenuItem font TextAttr *)
  mnFrontPen        * = tagBase+50;  (* MenuItem text pen color *)

  bbRecessed        * = tagBase+51;  (* Make BevelBox recessed *)

  visualInfo        * = tagBase+52;  (* result of VisualInfo call *)

  lvShowSelected    * = tagBase+53;  (* show selected entry beneath
         * listview, set tag data = NULL for display-only, or pointer
         * to a string gadget you've created
         *)
  lvSelected        * = tagBase+54;  (* Set ordinal number of selected
                                      * entry in the list
                                      *)
  Reserved1         * = tagBase+56;  (* Reserved for future use *)

  txBorder          * = tagBase+57;  (* Put a border around
                                      * Text-display gadgets
                                      *)
  nmBorder          * = tagBase+58;  (* Put a border around
                                      * Number-display gadgets
                                      *)
  scArrows          * = tagBase+59;  (* Specify size of arrows for
                                      * scroller
                                      *)
  mnMenu            * = tagBase+60;  (* Pointer to Menu for use by
                                      * LayoutMenuItems()
                                      *)
  mxSpacing         * = tagBase+61;  (* Added to font height to
         * figure spacing between mx choices.  Use this instead
         * of LAYOUTA_SPACING for mx gadgets.
         *)

(* New to V37 GadTools.  Ignored by GadTools V36 *)
  fullMenu          * = tagBase+62;  (* Asks CreateMenus() to validate that this
                                      * is a complete menu structure
                                      *)
  secondaryError    * = tagBase+63;  (* ti_Data is a pointer to a ULONG to receive
                                      * error reports from CreateMenus()
                                      *)
  underscore        * = tagBase+64;  (* ti_Data points to the symbol that preceeds
                                      * the character you'd like to underline in a
                                      * gadget label
                                      *)

  stEditHook        * = tagBase+55; (* String EditHook *)
  inEditHook        * = stEditHook; (* Same thing, different name, just to
                                     * round out INTEGER_KIND gadgets
                                     *)

(* New to V39 GadTools.  Ignored by GadTools V36 and V37 *)
  mnCheckMark       * = tagBase+65; (* ti_Data is checkmark img to use *)
  mnAmigaKey        * = tagBase+66; (* ti_Data is Amiga-key img to use *)
  mnNewLookMenus    * = tagBase+67; (* ti_Data is boolean *)

(* New to V39 GadTools.  Ignored by GadTools V36 and V37.
 * Set to TRUE if you want the checkbox or mx image scaled to
 * the gadget width/height you specify.  Defaults to FALSE,
 * for compatibility.
 *)
  cbScaled          * = tagBase+68; (* ti_Data is boolean *)
  mxScaled          * = tagBase+69; (* ti_Data is boolean *)

  paNumColors       * = tagBase+70; (* Number of colors in palette *)

  mxTitlePlace      * = tagBase+71; (* Where to put the title *)

  txFrontPen        * = tagBase+72; (* Text color in TEXT_KIND gad *)
  txBackPen         * = tagBase+73; (* Bgrnd color in TEXT_KIND gad *)
  txJustification   * = tagBase+74; (* See GTJ_#? constants *)

  nmFrontPen        * = tagBase+72; (* Text color in NUMBER_KIND gad *)
  nmBackPen         * = tagBase+73; (* Bgrnd color in NUMBER_KIND gad *)
  nmJustification   * = tagBase+74; (* See GTJ_#? constants *)
  nmFormat          * = tagBase+75; (* Formatting string for number *)
  nmMaxNumberLen    * = tagBase+76; (* Maximum length of number *)

  bbFrameType       * = tagBase+77; (* defines what kind of boxes
                                     * DrawBevelBox() renders. See
                                     * the BBFT_#? constants for
                                     * possible values
                                     *)

  lvMakeVisible     * = tagBase+78; (* Make this item visible *)
  lvItemHeight      * = tagBase+79; (* Height of an individual item *)

  slMaxPixelLen     * = tagBase+80; (* Max pixel size of level display *)
  slJustification   * = tagBase+81; (* how should the level be displayed *)

  paColorTable      * = tagBase+82; (* colors to use in palette *)

  lvCallBack        * = tagBase+83; (* general-purpose listview call back *)
  lvMaxPen          * = tagBase+84; (* maximum pen number used by call back *)

  txClipped         * = tagBase+85; (* make a TEXT_KIND clip text *)
  nmClipped         * = tagBase+85; (* make a NUMBER_KIND clip text *)

(* Old definition, now obsolete: *)
  Reserved0         * = stEditHook;

(*------------------------------------------------------------------------*)

(* Justification types for GTTX_Justification and GTNM_Justification tags *)
  jLeft   * = 0;
  jRight  * = 1;
  jCenter * = 2;

(*------------------------------------------------------------------------*)

(* Bevel box frame types for GTBB_FrameType tag *)
  bbftButton      * = 1;  (* Standard button gadget box *)
  bbftRidge       * = 2;  (* Standard string gadget box *)
  bbftIconDropBox * = 3;  (* Standard icon drop box     *)

(*------------------------------------------------------------------------*)

(* Typical suggested spacing between "elements": *)
  interWidth  * = 8;
  interHeight * = 4;

(*------------------------------------------------------------------------*)

(*  "nWay" is an old synonym for cycle gadgets *)
  nWAYKind     * = cycleKind;
  nWAYIDCMP    * = cycleIDCMP;
  nwLabels     * = cyLabels;
  nwActive     * = cyActive;

(*------------------------------------------------------------------------*)

(* These two definitions are obsolete, but are here for backwards
 * compatibility.  You never need to worry about these:
 *)
  gadToolBit  * = 08000H;

(*------------------------------------------------------------------------*)

(* These definitions are for the GTLV_CallBack tag *)

(* The different types of messages that a listview callback hook can see *)
  lvDraw      * =  0202H;  (* draw yourself, with state *)

(* Possible return values from a callback hook *)
  lvcbOk      * =  0;     (* callback understands this message type    *)
  lvcbUnknown * =  1;     (* callback does not understand this message *)

(* states for LVDrawMsg.lvdm_State *)
  lvrNormal           * = 0; (* the usual                 *)
  lvrSelected         * = 1; (* for selected gadgets      *)
  lvrNormalDisabled   * = 2; (* for disabled gadgets      *)
  lvrSelectedDisabled * = 8; (* disabled and selected     *)

TYPE
(* structure of LV_DRAW messages, object is a (struct Node * ) *)
  LVDrawMsg * = STRUCT (msg *: I.Msg)
    rastPort * : g.RastPortPtr;   (* where to render to        *)
    drawInfo * : I.DrawInfoPtr;   (* useful to have around     *)
    bounds   * : g.Rectangle;     (* limits of where to render *)
    state    * : LONGINT;         (* how to render             *)
  END;

VAR
  base * : e.LibraryPtr;

(*--- functions in V36 or higher (Release 2.0) ---*)
(*
 * Gadget Functions
 *)
PROCEDURE CreateGadgetA   *{base,- 30}(kind{0}        : LONGINT;
                                       gad{8}         : I.GadgetPtr;
                                       VAR ng{9}      : NewGadget;
                                       taglist{10}    : ARRAY OF u.TagItem): I.GadgetPtr;
PROCEDURE CreateGadget    *{base,- 30}(kind{0}        : LONGINT;
                                       gad{8}         : I.GadgetPtr;
                                       VAR ng{9}      : NewGadget;
                                       tag1{10}..     : u.Tag): I.GadgetPtr;
PROCEDURE FreeGadgets     *{base,- 36}(gad{8}         : I.GadgetPtr);
PROCEDURE SetGadgetAttrsA *{base,- 42}(VAR gad{8}     : I.Gadget;
                                       win{9}         : I.WindowPtr;
                                       req{10}        : I.RequesterPtr;
                                       taglist{11}    : ARRAY OF u.TagItem);
PROCEDURE SetGadgetAttrs  *{base,- 42}(VAR gad{8}     : I.Gadget;
                                       win{9}         : I.WindowPtr;
                                       req{10}        : I.RequesterPtr;
                                       tag1{11}..     : u.Tag);
(*
 * Menu functions
 *)
PROCEDURE CreateMenusA    *{base,- 48}(newmenu{8}     : ARRAY OF NewMenu;
                                       taglist{9}     : ARRAY OF u.TagItem): I.MenuPtr;
PROCEDURE CreateMenus     *{base,- 48}(newmenu{8}     : ARRAY OF NewMenu;
                                       tag1{9}..      : u.Tag): I.MenuPtr;
PROCEDURE CreateMenusAB   *{base,- 48}(newmenu{8}     : NewMenuPtr;
                                       taglist{9}     : ARRAY OF u.TagItem): I.MenuPtr;
PROCEDURE CreateMenusB    *{base,- 48}(newmenu{8}     : NewMenuPtr;
                                       tag1{9}..      : u.Tag): I.MenuPtr;
PROCEDURE FreeMenus       *{base,- 54}(menu{8}        : I.MenuPtr);
PROCEDURE LayoutMenuItemsA*{base,- 60}(firstitem{8}   : I.MenuItemPtr;
                                       vi{9}          : VisualInfo;
                                       tagList{10}    : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE LayoutMenuItems *{base,- 60}(firstitem{8}   : I.MenuItemPtr;
                                       vi{9}          : VisualInfo;
                                       tag1{10}..     : u.Tag): BOOLEAN;
PROCEDURE LayoutMenusA    *{base,- 66}(firstmenu{8}   : I.MenuPtr;
                                       vi{9}          : VisualInfo;
                                       taglist{10}    : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE LayoutMenus     *{base,- 66}(firstmenu{8}   : I.MenuPtr;
                                       vi{9}          : VisualInfo;
                                       tag1{10}..     : u.Tag): BOOLEAN;
(*
 * Misc Event-Handling Functions
 *)
PROCEDURE GetIMsg         *{base,- 72}(iport{8}       : e.MsgPortPtr): I.IntuiMessagePtr;
PROCEDURE ReplyIMsg       *{base,- 78}(imsg{9}        : I.IntuiMessagePtr);
PROCEDURE RefreshWindow   *{base,- 84}(win{8}         : I.WindowPtr;
                                       req{9}         : I.RequesterPtr);
PROCEDURE BeginRefresh    *{base,- 90}(win{8}         : I.WindowPtr);
PROCEDURE EndRefresh      *{base,- 96}(win{8}         : I.WindowPtr;
                                       complete{0}    : I.LONGBOOL);
PROCEDURE FilterIMsg      *{base,-102}(imsg{9}        : I.IntuiMessagePtr): I.IntuiMessagePtr;
PROCEDURE PostFilterIMsg  *{base,-108}(imsg{9}        : I.IntuiMessagePtr): I.IntuiMessagePtr;
PROCEDURE CreateContext   *{base,-114}(VAR glist{8}   : I.GadgetPtr): I.GadgetPtr;
(*
 * Rendering Functions
 *)
PROCEDURE DrawBevelBoxA   *{base,-120}(rport{8}       : g.RastPortPtr;
                                       left{0}        : LONGINT;
                                       top{1}         : LONGINT;
                                       width{2}       : LONGINT;
                                       height{3}      : LONGINT;
                                       taglist{9}     : ARRAY OF u.TagItem);
PROCEDURE DrawBevelBox    *{base,-120}(rport{8}       : g.RastPortPtr;
                                       left{0}        : LONGINT;
                                       top{1}         : LONGINT;
                                       width{2}       : LONGINT;
                                       height{3}      : LONGINT;
                                       tag1{9}..      : u.Tag);
(*
 * Visuals Functions
 *)
PROCEDURE GetVisualInfoA  *{base,-126}(screen{8}      : I.ScreenPtr;
                                       taglist{9}     : ARRAY OF u.TagItem): VisualInfo;
PROCEDURE GetVisualInfo   *{base,-126}(screen{8}      : I.ScreenPtr;
                                       tag1{9}..      : u.Tag): VisualInfo;
PROCEDURE FreeVisualInfo  *{base,-132}(vi{8}          : VisualInfo);

(*--- functions in V39 or higher (Release 3) ---*)

PROCEDURE GetGadgetAttrsA *{base,-0AEH}(gad{8}        : I.GadgetPtr;
                                        win{9}        : I.WindowPtr;
                                        req{10}       : I.RequesterPtr;
                                        taglist{11}   : ARRAY OF u.TagItem): LONGINT;
PROCEDURE GetGadgetAttrs  *{base,-0AEH}(gad{8}        : I.GadgetPtr;
                                        win{9}        : I.WindowPtr;
                                        req{10}       : I.RequesterPtr;
                                        tag1{11}..    : u.Tag ): LONGINT;

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

(* A UserData pointer can be associated with each Menu and MenuItem structure.
 * The CreateMenus() call allocates space for a UserData after each
 * Menu or MenuItem (header, item or sub-item).  You should use the
 * GTMENU_USERDATA() or GTMENUITEM_USERDATA() macro to extract it.
 *)

PROCEDURE MenuUserData * (menu{8}: I.MenuPtr): e.APTR;
TYPE UserMenu = STRUCT (menu: I.Menu) userData: e.APTR; END;
BEGIN RETURN menu(UserMenu).userData; END MenuUserData;


PROCEDURE MenuItemUserData * (menuitem{8}: I.MenuItemPtr): e.APTR;
TYPE UserItem = STRUCT (menu: I.MenuItem) userData: e.APTR; END;
BEGIN RETURN menuitem(UserItem).userData; END MenuItemUserData;


BEGIN
  base := e.OpenLibrary(gadtoolsName,37);

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END GadTools.

