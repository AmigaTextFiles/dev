(*(********************************************************************

:Program.     ASL.mod
:Contents.    interface module for asl.library
:Copyright.   © 1992 by Fridtjof Siebert, Nicolas Benezan
:Language.    Oberon-2
:Translator.  Amiga Oberon Compiler V3.00
:History.     V2.0 fridi 02-Nov-92
:History.     V3.0 bene  20-Mar-92 updated to V39 includes
:History.     V3.0b hG   21-May-93 rearranged, removed minor errors
:History.     V3.1  hG   23-May-93 updated to V40 includes (40.5)
:History.     40.15 hG   28-Dec-93 updated for V40.15
:Version.     $VER: ASL.mod 40.15 (28.12.93) Oberon 3.0

********************************************************************)*)

MODULE ASL;

(* !!! IMPORTANT NOTE !!!
 * Before procedures of this module may be used, you have to check
 * ASL.asl#NIL because opening ASL may fail on Amigas with KickStart
 * 1.3 installed!
 *)

IMPORT
  e  * := Exec, u  * := Utility, wb * := Workbench, g  * := Graphics;

(*****************************************************************************)

CONST
  aslName * = "asl.library";
  aslTag  * = u.user + 80000H;


(*****************************************************************************)


(* Types of requesters known to ASL, used as arguments to AllocAslRequest() *)
  fileRequest       * = 0;
  fontRequest       * = 1;
  screenModeRequest * = 2;


(************************************************************************)
CONST
(*
 * common tag arguments
 *)


(* Window control *)
  window         * = aslTag+2;   (* Parent window                    *)
  screen         * = aslTag+40;  (* Screen to open on if no window   *)
  pubScreenName  * = aslTag+41;  (* Name of public screen            *)
  privateIDCMP   * = aslTag+42;  (* Allocate private IDCMP?          *)
  intuiMsgFunc   * = aslTag+70;  (* Function to handle IntuiMessages *)
  sleepWindow    * = aslTag+43;  (* Block input in ASLFO_WindoU?     *)
  userData       * = aslTag+52;  (* What to put in fo_UserData       *)

(* Text display *)
  textAttr       * = aslTag+51;  (* Text font to use for gadget text *)
  locale         * = aslTag+50;  (* Locale ASL should use for text   *)
  titleText      * = aslTag+1;   (* Title of requester               *)
  positiveText   * = aslTag+18;  (* Positive gadget text             *)
  negativeText   * = aslTag+19;  (* Negative gadget text             *)

(* Initial settings *)
  initialLeftEdge * = aslTag+3;   (* Initial requester coordinates    *)
  initialTopEdge  * = aslTag+4;
  initialWidth    * = aslTag+5;   (* Initial requester dimensions     *)
  initialHeight   * = aslTag+6;

(* Filtering *)
  filterFunc     * = aslTag+49;  (* Function to filter fonts         *)
  hookFunc       * = aslTag+7;   (* Combined callback function       *)

TYPE
  ASLRequesterPtr * = UNTRACED POINTER TO ASLRequester;
  ASLRequester * = STRUCT END;

(*****************************************************************************
 *
 * ASL File Requester data structures and constants
 *
 * This structure must only be allocated by asl.library amd is READ-ONLY!
 * Control of the various fields is provided via tags when the requester
 * is created with AllocAslRequest() and when it is displayed via
 * AslRequest()
 *)
  FileRequesterPtr * = UNTRACED POINTER TO FileRequester;
  FileRequester * = STRUCT (dummy *: ASLRequester)
    reserved0 - : ARRAY 4 OF e.UBYTE;
    file      - : e.LSTRPTR; (* Contents of File gadget on exit    *)
    dir       - : e.LSTRPTR; (* Contents of Drawer gadget on exit  *)
    reserved1 - : ARRAY 10 OF e.UBYTE;
    leftEdge  - : INTEGER;   (* Coordinates of requester on exit   *)
    topEdge   - : INTEGER;
    width     - : INTEGER;
    height    - : INTEGER;
    reserved2 - : ARRAY 2 OF e.UBYTE;
    numArgs   - : LONGINT;   (* Number of files selected           *)
    argList   - : wb.WBArgumentsPtr; (* List of files selected     *)
    userData  - : e.APTR;    (* You can store your own data here   *)
    reserved3 - : ARRAY 8 OF e.UBYTE;
    pat       - : e.LSTRPTR; (* Contents of Pattern gadget on exit *)
  END;                       (* note - more reserved fields follow *)

CONST
(* File requester tag values, used by AllocAslRequest() and AslRequest() *)

(* Window control *)
  (* see common tags above *)

(* Text display *)
  (* see common tags above *)

(* Initial settings *)
  (* see common tags above *)
  initialFile    * = aslTag+8;   (* Initial contents of File gadget  *)
  initialDrawer  * = aslTag+9;   (* Initial contents of Drawer gadg. *)
  initialPattern * = aslTag+10;  (* Initial contents of Pattern gadg.*)

(* Options *)
  flags1         * = aslTag+20;  (* Option flags                     *)
  flags2         * = aslTag+22;  (* Additional option flags          *)
  doSaveMode     * = aslTag+44;  (* Being used for saving?           *)
  doMultiSelect  * = aslTag+45;  (* Do multi-select?                 *)
  doPatterns     * = aslTag+46;  (* Display a Pattern gadget?        *)

(* Filtering *)
  (* see common tags above *)
  drawersOnly    * = aslTag+47;  (* Don't display files?             *)
  rejectIcons    * = aslTag+60;  (* Display .info files?             *)
  rejectPattern  * = aslTag+61;  (* Don't display files matching pat *)
  acceptPattern  * = aslTag+62;  (* Accept only files matching pat   *)
  filterDrawers  * = aslTag+63;  (* Also filter drawers with patterns*)


(* Flag bits for the ASLFR_Flags1 tag *)
  frFilterFunc    * = 7;
  frIntuiFunc     * = 6;
  frDoSaveMode    * = 5;
  frPrivateIDCMP  * = 4;
  frDoMultiSelect * = 3;
  frDoPatterns    * = 0;

(* Flag bits for the ASLFR_Flags2 tag *)
  frDrawersOnly   * = 0; (* Do not want a file gadget, no files shown      *)
  frFilterDrawers * = 1; (* filter drawers by matching pattern             *)
  frRejectIcons   * = 2;


(*****************************************************************************
 *
 * ASL Font Requester data structures and constants
 *
 * This structure must only be allocated by asl.library amd is READ-ONLY!
 * Control of the various fields is provided via tags when the requester
 * is created with AllocAslRequest() and when it is displayed via
 * AslRequest()
 *)
TYPE
  FontRequesterPtr * = UNTRACED POINTER TO FontRequester;
  FontRequester * = STRUCT (dummy *: ASLRequester)
    reserved0 - : ARRAY 8 OF e.UBYTE;
    attr      - : g.TextAttr;  (* Returned TextAttr                *)
    frontPen  - : SHORTINT;    (* Returned front pen               *)
    backPen   - : SHORTINT;    (* Returned back pen                *)
    drawMode  - : SHORTSET;    (* Returned drawing mode            *)
    reserved1 - : e.UBYTE;
    userData  - : e.APTR;      (* You can store your own data here *)
    leftEdge  - : INTEGER;     (* Coordinates of requester on exit *)
    topEdge   - : INTEGER;
    width     - : INTEGER;
    height    - : INTEGER;
    tAttr     - : g.TTextAttr; (* Returned TTextAttr               *)
  END;

CONST
(* Font requester tag values, used by AllocAslRequest() and AslRequest() *)

(* Window control *)
  (* see common tags above *)

(* Text display *)
  (* see common tags above *)

(* Initial settings *)
  (* see common tags above *)
  initialName     * = aslTag+10;  (* Initial contents of Name gadget  *)
  initialSize     * = aslTag+11;  (* Initial contents of Size gadget  *)
  initialStyle    * = aslTag+12;  (* Initial font style               *)
  initialFlags    * = aslTag+13;  (* Initial font flags for TextAttr  *)
  initialFrontPen * = aslTag+14;  (* Initial front pen                *)
  initialBackPen  * = aslTag+15;  (* Initial back pen                 *)
  initialDrawMode * = aslTag+59;  (* Initial draw mode                *)

(* Options *)
  flags          * = aslTag+20;  (* Option flags                     *)
  doFrontPen     * = aslTag+44;  (* Display Front color selector?    *)
  doBackPen      * = aslTag+45;  (* Display Back color selector?     *)
  doStyle        * = aslTag+46;  (* Display Style checkboxes?        *)
  doDrawMode     * = aslTag+47;  (* Display DrawMode cycle gadget?   *)

(* Filtering *)
  fixedWidthOnly * = aslTag+48;  (* Only allow fixed-width fonts?    *)
  minHeight      * = aslTag+16;  (* Minimum font height to display   *)
  maxHeight      * = aslTag+17;  (* Maximum font height to display   *)
  maxFrontPen    * = aslTag+66;  (* Max # of colors in front palette *)
  maxBackPen     * = aslTag+67;  (* Max # of colors in back palette  *)

(* Custom additions *)
  modeList       * = aslTag+21;  (* Substitute list for drawmodes    *)
  frontPens      * = aslTag+64;  (* Color table for front pen palette*)
  backPens       * = aslTag+65;  (* Color table for back pen palette *)


(* Flag bits for ASLFO_Flags tag *)
  foDoFrontPen     * = 0;
  foDoBackPen      * = 1;
  foDoStyle        * = 2;
  foDoDrawMode     * = 3;
  foFixedWidthOnly * = 4;
  foPrivateIDCMP   * = 5;
  foIntuiFunc      * = 6;
  foFilterFunc     * = 7;

TYPE
(*****************************************************************************
 *
 * ASL Screen Mode Requester data structures and constants
 *
 * This structure must only be allocated by asl.library and is READ-ONLY!
 * Control of the various fields is provided via tags when the requester
 * is created with AllocAslRequest() and when it is displayed via
 * AslRequest()
 *)
  ScreenModeRequesterPtr * = UNTRACED POINTER TO ScreenModeRequester;
  ScreenModeRequester * = STRUCT (dummy *: ASLRequester)
    displayID     - : LONGINT;  (* Display mode ID                  *)
    displayWidth  - : LONGINT;  (* Width of display in pixels       *)
    displayHeight - : LONGINT;  (* Height of display in pixels      *)
    displayDepth  - : INTEGER;  (* Number of bit-planes of display  *)
    overscanType  - : INTEGER;  (* Type of overscan of display      *)
    autoScroll    - : BOOLEAN;  (* Display should auto-scroll?      *)
    pad1            : SHORTINT;

    bitMapWidth   - : LONGINT;  (* Used to create your own BitMap   *)
    bitMapHeight  - : LONGINT;

    leftEdge      - : INTEGER;  (* Coordinates of requester on exit *)
    topEdge       - : INTEGER;
    width         - : INTEGER;
    height        - : INTEGER;

    infoOpened    - : BOOLEAN;  (* Info window opened on exit?      *)
    pad2            : SHORTINT;
    infoLeftEdge  - : INTEGER;  (* Last coordinates of Info window  *)
    infoTopEdge   - : INTEGER;
    infoWidth     - : INTEGER;
    infoHeight    - : INTEGER;

    userData      - : e.APTR;   (* You can store your own data here *)
  END;

(* An Exec list of custom modes can be added to the list of available modes.
 * The DimensionInfo structure must be completely initialized, including the
 * Header. See <graphics/displayinfo.h>. Custom mode ID's must be in the range
 * 0xFFFF0000..0xFFFFFFFF. Regular properties which apply to your custom modes
 * can be added in the dn_PropertyFlags field. Custom properties are not
 * allowed.
 *)

TYPE
  DisplayMode* = STRUCT (node * : e.Node) (* see ln_Name           *)
    dimensionInfo * : g.DimensionInfo;    (* mode description      *)
    propertyFlags * : LONGSET;            (* applicable properties *)
  END;

CONST
(* ScreenMode requester tag values, used by AllocAslRequest() and AslRequest() *)

(* Window control *)
  (* see common tags above *)

(* Text display *)
  (* see common tags above *)

(* Initial settings *)
  (* see common tags above *)
  initialDisplayID    * = aslTag+100; (* Initial display mode id     *)
  initialDisplayWidth * = aslTag+101; (* Initial display width       *)
  initialDisplayHeight* = aslTag+102; (* Initial display height      *)
  initialDisplayDepth * = aslTag+103; (* Initial display depth       *)
  initialOverscanType * = aslTag+104; (* Initial type of overscan    *)
  initialAutoScroll   * = aslTag+105; (* Initial autoscroll setting  *)
  initialInfoOpened   * = aslTag+106; (* Info wndw initially opened? *)
  initialInfoLeftEdge * = aslTag+107; (* Initial Info window coords. *)
  initialInfoTopEdge  * = aslTag+108;

(* Options *)
  doWidth        * = aslTag+109;  (* Display Width gadget?           *)
  doHeight       * = aslTag+110;  (* Display Height gadget?          *)
  doDepth        * = aslTag+111;  (* Display Depth gadget?           *)
  doOverscanType * = aslTag+112;  (* Display Overscan Type gadget?   *)
  doAutoScroll   * = aslTag+113;  (* Display AutoScroll gadget?      *)

(* Filtering *)
  smPropertyFlags* = aslTag+114;  (* Must have these Property flags  *)
  smPropertyMask * = aslTag+115;  (* Only these should be looked at  *)
  smMinWidth     * = aslTag+116;  (* Minimum display width to allow  *)
  smMaxWidth     * = aslTag+117;  (* Maximum display width to allow  *)
  smMinHeight    * = aslTag+118;  (* Minimum display height to allow *)
  smMaxHeight    * = aslTag+119;  (* Maximum display height to allow *)
  smMinDepth     * = aslTag+120;  (* Minimum display depth           *)
  smMaxDepth     * = aslTag+121;  (* Maximum display depth           *)
  smFilterFunc   * = aslTag+122;  (* Function to filter mode id's    *)

(* Custom additions *)
  customSMList   * = aslTag+123;  (* Exec list of struct DisplayMode *)

(***********************************************************************
 *
 * Obsolete ASL definitions, here for source code compatibility only.
 * Please do NOT use in new code.
 *
 *)
  fonFrontColor * = 0;
  fonBackColor  * = 1;
  fonStyles     * = 2;
  fonDrawMode   * = 3;
  fonFixedWidth * = 4;
  fonNewIDCMP   * = 5;
  fonDoMsgFunc  * = 6;
  fonDoWildFunc * = 7;

  doWildFunc   * = frFilterFunc;
  doMsgFunc    * = frIntuiFunc;
  save         * = frDoSaveMode;
  newIDCMP     * = frPrivateIDCMP;
  multiSelect  * = frDoMultiSelect;
  patGad       * = frDoPatterns;
  noFiles      * = frDrawersOnly;

  aslDummy    * = aslTag;

  hail        * = aslDummy+1;    (* Hailing text follows              *)
  leftEdge    * = aslDummy+3;    (* Initialize LeftEdge               *)
  topEdge     * = aslDummy+4;    (* Initialize TopEdge                *)
  width       * = aslDummy+5;
  height      * = aslDummy+6;

(* Tags specific to file request                                             *)
  file        * = aslDummy+8;    (* Initial name of file follows      *)
  dir         * = aslDummy+9;    (* Initial string of filerequest dir *)

(* Tags specific to font request                                             *)
  fontName    * = aslDummy+10;   (* Initial font name                 *)
  fontHeight  * = aslDummy+11;   (* Initial font height               *)
  fontStyles  * = aslDummy+12;   (* Initial font styles               *)
  fontFlags   * = aslDummy+13;   (* Initial font flags for textattr   *)
  frontPen    * = aslDummy+14;   (* Initial frontpen color            *)
  backPen     * = aslDummy+15;   (* Initial backpen color             *)

  okText      * = aslDummy+18;   (* Text displayed in OK gadget       *)
  cancelText  * = aslDummy+19;   (* Text displayed in CANCEL gadget   *)
  funcFlags   * = aslDummy+20;   (* Function flags, depend on request *)

  extFlags1   * = aslDummy+22;   (* For passing extended FIL1F flags   *)

  pattern     * = fontName;      (* File requester pattern string     *)

(******** END of ASL Tag values *****************************************)

VAR
  asl *, base * : e.LibraryPtr; (* synonyms *)

(*--- functions in V36 or higher (Release 2.0) ---*)

(* OBSOLETE -- Please use the generic requester functions instead *)

PROCEDURE AllocFileRequest   *{asl,- 30}(): FileRequesterPtr;
PROCEDURE FreeFileRequest    *{asl,- 36}(fileReq{8} : FileRequesterPtr);
PROCEDURE RequestFile        *{asl,- 42}(fileReq{8} : FileRequesterPtr): BOOLEAN;


PROCEDURE AllocAslRequest    *{asl,- 48}(reqType{0}  : LONGINT;
                                         tagList{8}  : ARRAY OF u.TagItem): ASLRequesterPtr;
PROCEDURE AllocAslRequestTags*{asl,- 48}(reqType{0}  : LONGINT;
                                         tag1{8}..   : u.Tag): ASLRequesterPtr;
PROCEDURE FreeAslRequest     *{asl,- 54}(requester{8}: ASLRequesterPtr);
PROCEDURE AslRequest         *{asl,- 60}(requester{8}: ASLRequesterPtr;
                                         tagList{9}  : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE AslRequestTags     *{asl,- 60}(requester{8}: ASLRequesterPtr;
                                         tag1{9}..   : u.Tag): BOOLEAN;

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  asl :=  e.OpenLibrary (aslName, 37);
  base := asl;

CLOSE
  IF asl # NIL THEN e.CloseLibrary(asl) END;

END ASL.

