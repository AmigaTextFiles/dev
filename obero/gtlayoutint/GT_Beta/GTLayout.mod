(* ==================================================================== *)

(*
******* GTLayout/--about-- *******
*
*    $RCSfile: GTLayout.mod $
*   $Revision: 1.1 $
*       $Date: 1995/09/06 02:15:26 $
*     $Author: phf $
*
* Description: AmigaOberon interface to gtlayout.library V20.1 which
*              is Copyright © 1993-1995 by Olaf `Olsen' Barthel.
*
*   Copyright: Copyright (c) 1995 by Peter Fröhlich [phf].
*              All rights reserved.
*
*     License: This  file  is  freely distributable as long as no
*              money  is  made by distributing it.  If you modify
*              it   please  let  me  know.   You  may  distribute
*              modified versions as long as my original copyright
*              is  respected  and  your modifications are clearly
*              marked as such.  You may use it in any application
*              you develop; it's royalty-free.
*
*      e-mail: p.froehlich@amc.cube.net
*
*     $Source: Users:Homes/phf/Programming/Development/GTLayout/REPOSITORY/GTLayout.mod $
*
**************
*
**************
*)

(* ==================================================================== *)

MODULE GTLayout;

(* ==================================================================== *)

IMPORT
  E* := Exec, I* := Intuition, U* := Utility, GT* := GadTools,
  G* := Graphics, S := SYSTEM;

(* ==================================================================== *)

(*
******* GTLayout/--background-- *******
*
*   PURPOSE
*
*	AmigaOberon interface to gtlayout.library V20.1 which
*       is Copyright © 1993-1995 by Olaf `Olsen' Barthel.
*
*   NOTES
*
*	Remember to check "base # NIL" before making any calls
*	to the library. Also remember to check for the proper
*	version using "GTLayout.base.lib.version >= needed".
*
*	Some parts of the original gtlayout.h file have not yet
*	been incorporated here, either because they were marked
*	as obsolete or because I just couldn't make out what
*	they do. Obsolete functions have been included in the
*	library interface to remind me that there are functions
*	at these offsets, but they can't be called.
*
*   SEE ALSO
*
*	gtlayout.doc
*
*   REFERENCES
*
*	Aminet: comm/term/term43#?
*
**************
*
**************
*)

(* ==================================================================== *)

CONST
  gtLayoutName* = "gtlayout.library";

(* ==================================================================== *)

CONST (* PlacementTypes *)
  placeLeft  * = 0;
  placeRight * = 1;
  placeAbove * = 2;
  placeIn    * = 3;
  placeBelow * = 4;

CONST (* AlignmentTypes *)
  alignTextLeft     * = 0;
  alignTextCentered * = 1;
  alignTextRight    * = 2;
  alignTextPad      * = 3;

CONST (* TypeDeckButtonTypes *)
  tdbtBackward * = 0;
  tdbtForward  * = 1;
  tdbtPrevious * = 2;
  tdbtNext     * = 3;
  tdbtStop     * = 4;
  tdbtPause    * = 5;
  tdbtRecord   * = 6;
  tdbtRewind   * = 7;
  tdbtEject    * = 8;
  tdbtPlay     * = 9;
  tdbtLast     * = 10; (* no _ in original! *)

TYPE
  (* swapped parameters because of C's different stack conventions *)
  DispFunc* = PROCEDURE (value: INTEGER; gadget: I.GadgetPtr): LONGINT;

CONST (* elements of LONGSET{} passed to lawnAlignWindow tag *)
  alignRight       * = 0;
  alignLeft        * = 1;
  alignTop         * = 2;
  alignBottom      * = 3;
  alignExtraRight  * = 4;
  alignExtraLeft   * = 5;
  alignExtraTop    * = 6;
  alignExtraBottom * = 7;

(* ==================================================================== *)

CONST (* Generic tags, applicable for several object types *)
  laChars        * = U.user+2;
  laLabelPlace   * = U.user+3;
  laExtraSpace   * = U.user+4;
  laNoKey        * = U.user+30;
  laHighLabel    * = U.user+31;
  laLabelText    * = U.user+37;
  laLabelID      * = U.user+38;
  laID           * = U.user+39;
  laType         * = U.user+40;
  laPageSelector * = U.user+79;
  laLabelChars   * = U.user+107;

CONST (* Storage type tags *)
  storeByte     * = U.user+63;
  laByte        * = U.user+63;
  storeUByte    * = U.user+64;
  laUByte       * = U.user+64;
  storeWord     * = U.user+65;
  laWord        * = U.user+65;
  storeBool     * = U.user+65;
  laBool        * = U.user+65;
  storeUWord    * = U.user+66;
  laUWord       * = U.user+66;
  storeLong     * = U.user+67;
  laLong        * = U.user+67;
  storeULong    * = U.user+68;
  laULong       * = U.user+68;
  storeStrPtr   * = U.user+69;
  laStrPtr      * = U.user+69;
  storeFraction * = U.user+68;
  laFraction    * = U.user+68;

CONST (* for use with GetAttributes() only *)
  laLeft      * = U.user+16;
  laTop       * = U.user+17;
  laWidth     * = U.user+18;
  laHeight    * = U.user+19;
  laLabelLeft * = U.user+114;
  laLabelTop  * = U.user+115;

CONST (* textKind *)
  latxPicker    * = U.user+5;
  latxUsePicker * = U.user+5;
  latxLockSize  * = U.user+106;

CONST (* verticalKind, horizontalKind *)
  lagrSpread         * = U.user+6;
  lagrSameSize       * = U.user+8;
  lagrLastAttributes * = U.user+46;
  lagrActivePage     * = U.user+58;
  lagrFrame          * = U.user+104;
  lagrIndentX        * = U.user+130;
  lagrIndentY        * = U.user+134;

CONST (* frameKind *)
  lafrInnerWidth  * = U.user+9;
  lafrInnerHeight * = U.user+10;
  lafrDrawBox     * = U.user+11;
  lafrRefreshHook * = U.user+117;

CONST (* boxKind *)
  labxLabels       * = U.user+12;
  labxLines        * = U.user+13;
  labxRows         * = U.user+1;
  labxIndex        * = U.user+14;
  labxText         * = U.user+15;
  labxAlignText    * = U.user+27;
  labxDrawBox      * = U.user+11;
  labxFirstLabel   * = U.user+44;
  labxLastLabel    * = U.user+45;
  labxReserveSpace * = U.user+72;
  labxLabelTable   * = U.user+98;

CONST (* fractionKind *)
  lafcMaxChars     * = U.user+20;
  lafcNumber       * = U.user+21;
  lafcLastGadget   * = U.user+28;
  lafcMin          * = U.user+23;
  lafcMax          * = U.user+24;
  lafcHistoryLines * = U.user+59;
  lafcHistoryHook  * = U.user+80;

CONST (* sliderKind *)
  laslFullCheck * = U.user+22;

CONST (* listviewKind *)
  lalvExtraLabels    * = U.user+26;
  lalvLabels         * = U.user+33;
  lalvCursorKey      * = U.user+35;
  lalvLines          * = U.user+1;
  lalvLink           * = U.user+7;
  lalvFirstLabel     * = U.user+44;
  lalvLastLabel      * = U.user+45;
  lalvMaxGrowX       * = U.user+77;
  lalvMaxGrowY       * = U.user+78;
  lalvLabelTable     * = U.user+98;
  lalvLockSize       * = U.user+106;
  lalvResizeX        * = U.user+109;
  lalvResizeY        * = U.user+110;
  lalvMinChars       * = U.user+111;
  lalvMinLines       * = U.user+112;
  lalvFlushLabelLeft * = U.user+113;
  lalvTextAttr       * = U.user+138;

CONST (* integerKind *)
  lainLastGadget      * = U.user+28;
  lainMin             * = U.user+23;
  lainMax             * = U.user+24;
  lainUseIncrementers * = U.user+57;
  lainIncrementers    * = U.user+57;
  lainHistoryLines    * = U.user+59;
  lainHistoryHook     * = U.user+80;
  lainIncrementerHook * = U.user+85;

CONST (* stringKind *)
  lastLastGadget     * = U.user+28;
  lastLink           * = U.user+7;
  lastPicker         * = U.user+5;
  lastUsePicker      * = U.user+5;
  lastHistoryLines   * = U.user+59;
  lastHistoryHook    * = U.user+80;
  lastCursorPosition * = U.user+105;

CONST (* passwordKind *)
  lapwString       * = GT.stString;
  lapwLastGadget   * = U.user+28;
  lapwHistoryLines * = U.user+59;
  lapwHistoryHook  * = U.user+80;

CONST (* paletteKind *)
  lapaSmallPalette * = U.user+32;
  lapaLines        * = labxRows;  (* original uses obsolete LA_Lines *)
  lapaUsePicker    * = U.user+137;
  lapaPicker       * = U.user+137;

CONST (* buttonKind *)
  labtReturnKey * = U.user+34;
  labtEscKey    * = U.user+56;
  labtExtraFat  * = U.user+29;
  labtLines     * = U.user+140;
  labtFirstLine * = U.user+44;
  labtLastLine  * = U.user+45;

CONST (* gaugeKind *)
  lagaPercent    * = U.user+36;
  lagaInfoLength * = U.user+70;
  lagaInfoText   * = U.user+71;
  lagaNoTicks    * = U.user+143;
  lagaDiscrete   * = U.user+144;
  lagaTenth      * = U.user+144;

CONST (* cycleKind *)
  lacyFirstLabel * = U.user+44;
  lacyLastLabel  * = U.user+45;
  lacyLabelTable * = U.user+98;
  lacyAutoPageID * = U.user+103;
  lacyTabKey     * = U.user+118;

CONST (* levelKind *)
  lavlMin         * = GT.slMin;
  lavlMax         * = GT.slMax;
  lavlLevel       * = GT.slLevel;
  lavlLevelFormat * = GT.slLevelFormat;
  lavlLevelPlace  * = GT.slLevelPlace;
  lavlDispFunc    * = GT.slDispFunc;
  lavlFullCheck   * = laslFullCheck;

CONST (* mxKind *)
  lamxFirstLabel * = U.user+44;
  lamxLastLabel  * = U.user+45;
  lamxLabelTable * = U.user+98;
  lamxTabKey     * = U.user+118;

CONST (* scrollerKind *)
  lascThin * = U.user+62;

CONST (* xbarKind *)
  laxbFullSize * = U.user+50;

CONST (* tapedeckKind *)
  latdButtonType * = U.user+86;
  latdToggle     * = U.user+87;
  latdPressed    * = U.user+88;
  latdSmaller    * = U.user+89;
  latdTick       * = U.user+139;

CONST (* mxKind *)
  lamxAutoPageID * = U.user+103;

CONST (* boopsiKind *)
  laboTagCurrent       * = U.user+119;
  laboTagTextAttr      * = U.user+120;
  laboTagDrawInfo      * = U.user+121;
  laboTagLink          * = U.user+129;
  laboTagScreen        * = U.user+132;
  laboLink             * = lalvLink;
  laboClassInstance    * = U.user+122;
  laboClassName        * = U.user+123;
  laboClassLibraryName * = U.user+124;
  laboExactWidth       * = U.user+127;
  laboExactHeight      * = U.user+128;
  laboRelFontHeight    * = U.user+131;
  laboObject           * = U.user+133;
  laboFullWidth        * = U.user+135;
  laboFullHeight       * = U.user+136;
  laboActivateHook     * = U.user+141;

CONST (* Applicable for window only *)
  lawnMenu         * = U.user+25;
  lawnUserPort     * = U.user+47;
  lawnLeft         * = U.user+48;
  lawnTop          * = U.user+49;
  lawnZoom         * = U.user+50;
  lawnMaxPen       * = U.user+52;
  lawnBelowMouse   * = U.user+53;
  lawnMoveToWindow * = U.user+54;
  lawnAutoRefresh  * = U.user+55;
  lawnHelpHook     * = U.user+73;
  lawnParent       * = U.user+81;
  lawnBlockParent  * = U.user+82;
  lawnSmartZoom    * = U.user+91;
  lawnTitle        * = U.user+92;
  lawnTitleText    * = U.user+92;
  lawnBounds       * = U.user+93;
  lawnExtraWidth   * = U.user+94;
  lawnExtraHeight  * = U.user+95;
  lawnIDCMP        * = U.user+96;
  lawnAlignWindow  * = U.user+97;
  (* NOTEZ-BIEN: U.user+99 = WA_Dummy and can clash *)
  (*             with Intuition!                    *)
  lawnTitleID      * = U.user+99;
  lawnFlushLeft    * = U.user+14000;
  lawnFlushTop     * = U.user+14001;
  lawnShow         * = U.user+14002;
  lawnMenuTemplate * = U.user+14003;
  lawnMenuTags     * = U.user+14004;

CONST (* Applicable for menus only. *)
  lamnFirstLabel     * = labxFirstLabel;
  lamnLastLabel      * = labxLastLabel;
  lamnLabelTable     * = U.user+98;
  lamnTitleText      * = (U.user + 17000);
  lamnTitleID        * = (U.user + 17001);
  lamnItemText       * = (U.user + 17002);
  lamnItemID         * = (U.user + 17003);
  lamnSubText        * = (U.user + 17004);
  lamnSubID          * = (U.user + 17005);
  lamnKeyText        * = (U.user + 17006);
  lamnKeyID          * = (U.user + 17007);
  lamnCommandText    * = (U.user + 17008);
  lamnCommandID      * = (U.user + 17009);
  lamnMutualExclude  * = (U.user + 17010);
  lamnUserData       * = (U.user + 17011);
  lamnDisabled       * = (U.user + 17012);
  lamnCheckIt        * = (U.user + 17013);
  lamnChecked        * = (U.user + 17014);
  lamnToggle         * = (U.user + 17015);
  lamnCode           * = (U.user + 17016);
  lamnQualifier      * = (U.user + 17017);
  lamnChar           * = (U.user + 17018);
  lamnID             * = (U.user + 17019);
  lamnAmigaGlyph     * = (U.user + 17020);
  lamnCheckmarkGlyph * = (U.user + 17021);
  lamnError          * = (U.user + 17022);
  lamnScreen         * = (U.user + 17023);
  lamnTextAttr       * = (U.user + 17024);
  lamnLayoutHandle   * = (U.user + 17025);
  lamnHandle         * = (U.user + 17025);
  lamnExtraSpace     * = (U.user + 17026);

CONST (* Applicable for layout handle only *)
  lhFont             * = U.user+41;
  lhAutoActivate     * = U.user+42;
  lhLocaleHook       * = U.user+4;
  lhCloningPermitted * = U.user+61;
  lhEditHook         * = U.user+74;
  lhExactClone       * = U.user+75;
  lhMenuGlyphs       * = U.user+76;
  lhParent           * = U.user+83;
  lhBlockParent      * = U.user+84;
  lhSimpleClone      * = U.user+90;
  lhExitFlush        * = U.user+108;
  lhUserData         * = U.user+116;
  lhRawKeyFilter     * = U.user+142;

CONST (* Private tags; do not use, or you'll run into trouble! *)
  laPrivate1 = U.user+100;
  laPrivate2 = U.user+101;

CONST (* Last tag item value used *)
  LASTTAG * = U.user+144;

(* ==================================================================== *)

CONST
  (* Identifies the absence of a link for a listview or a string gadget *)
  nilLink* = -2;

(* ==================================================================== *)

TYPE
  LayoutHandlePtr* = UNTRACED POINTER TO LayoutHandle;
  LayoutHandle* = STRUCT
    screen*     : I.ScreenPtr;
    drawInfo*   : I.DrawInfoPtr;
    window*     : I.WindowPtr;
    visualInfo* : E.APTR;
    amigaGlyph* : I.ImagePtr;
    checkGlyph* : I.ImagePtr;
    (* Requires gtlayout.library v9 *)
    userData*   : E.APTR;
    (* Requires gtlayout.library v13 *)
    menu*       : I.MenuPtr;
    (* private fields follow.... *)
  END;

(* ==================================================================== *)

(* String gadget type history hook support: you will either get
 * the following value passed as the message parameter to your
 * hook function, or a pointer to a null-terminated string you should
 * copy and create a Node from, which you should then add to the tail
 * of your history list. Place a pointer to your history list in the
 * Hook.h_Data entry.
 *)

CONST
  (* Discard oldest entry *)
  historyHookDiscardOldest* = 0;

(* ==================================================================== *)

(* Refresh hook support: you will get the following structure
 * passed as the message and a pointer to the LayoutHandle as
 * the object.
 *)

TYPE
  RefreshMsgPtr* = UNTRACED POINTER TO RefreshMsg;
  RefreshMsg* = STRUCT
    id: LONGINT;
    left, top, width, height: INTEGER;
  END;

(* ==================================================================== *)

(* Incrementer hook support: you will get the current value
 * passed as the object and one of the following values as
 * the message. Return the number to be used.
 *)

CONST
  (* Decrement value *)
  incrementerMsgDecrement * = -1;
  (* Initial value passed upon gadget creation *)
  incrementerMsgInitial   * =  0;
  (* Increment value *)
  incrementerMsgIncrement * =  1;

(* ==================================================================== *)

(* Help key hook support: the hook will be called with a "struct IBox *"
 * as the object and a "struct HelpMsg *". The IBox describes the object
 * the mouse was positioned over, such as a button, a listview, etc.
 * The "ObjectID" will indicate the ID of the object the mouse was
 * positioned over. The ID will be -1 if no object was to be found.
 *)

TYPE
  HelpMsgPtr* = UNTRACED POINTER TO HelpMsg;
  HelpMsg* = STRUCT
    (* Window layout handle *)
    handle* : LayoutHandle;
    (* ID of the object, -1 for full window *)
    objectID* : LONGINT;
  END;

(* ==================================================================== *)

CONST
  (* kinds of objects supported in addition to the normal GadTools kinds *)
  horizontalKind * = 45;
  verticalKind   * = 46;
  endKind        * = 47;
  frameKind      * = 48;
  boxKind        * = 49;
  fractionKind   * = 50;
  xbarKind       * = 51;
  ybarKind       * = 52;
  passwordKind   * = 53;
  gaugeKind      * = 54;
  tapedeckKind   * = 55;
  levelKind      * = 56;
  boopsiKind     * = 57;

(* ==================================================================== *)

(* in support of FRACTION_KIND gadgets *)

TYPE
  FIXED* = LONGINT;

CONST
  fixedUnity* = 10000;

PROCEDURE ToFixed* (l, r: LONGINT): FIXED;
BEGIN
  RETURN fixedUnity*l + r;
END ToFixed;

PROCEDURE FixedLeft* (f: FIXED): LONGINT;
BEGIN
  RETURN (f) DIV fixedUnity;
END FixedLeft;

PROCEDURE FixedRight* (f: FIXED): LONGINT;
BEGIN
  RETURN (f) MOD fixedUnity;
END FixedRight;

(* ==================================================================== *)

VAR
  base-: E.LibraryPtr;

(* ==================================================================== *)

PROCEDURE LevelWidth         * {base,- 30}(handle{8}: LayoutHandlePtr;
                                          levelFormat{9}: E.LSTRPTR;
                                          dispFunc{10}: DispFunc;
                                          min{0}: LONGINT;
                                          max{1}: LONGINT;
                                          VAR maxWidth{11}: LONGINT;
                                          VAR maxLen{13}: LONGINT;
                                          fullCheck{2}: BOOLEAN);

PROCEDURE DeleteHandle       * {base,- 36}(handle{8}: LayoutHandlePtr);


PROCEDURE CreateHandle       * {base,- 42}(screen{8}: I.ScreenPtr;
                                           font{9}: G.TextAttrPtr
                                          ): LayoutHandlePtr;

PROCEDURE CreateHandleTagList* {base,- 48}(screen{8}: I.ScreenPtr;
                                           tagList{9}: ARRAY OF U.TagItem
                                          ): LayoutHandlePtr;

PROCEDURE CreateHandleTags   * {base,- 48}(screen{8}: I.ScreenPtr;
                                           tags{9}..: U.Tag
                                          ): LayoutHandlePtr;

PROCEDURE Rebuild            * {base,- 54}((* OBSOLETE *));

PROCEDURE HandleInput        * {base,- 60}(handle{8}: LayoutHandlePtr;
                                           msgQualifier{0}: LONGINT;
                                           VAR msgClass{9}: LONGINT;
                                           VAR msgCode{10}: INTEGER;
                                     (*?*) VAR msgGadget{11}: I.GadgetPtr);

PROCEDURE BeginRefresh       * {base,- 66}(handle{8}: LayoutHandlePtr);

PROCEDURE EndRefresh         * {base,- 72}(handle{8}: LayoutHandlePtr;
                                           complete{0}: BOOLEAN);

PROCEDURE GetAttributesA     * {base,- 78}(handle{8}: LayoutHandlePtr;
                                           id{0}: LONGINT;
                                           tagList{9}: ARRAY OF U.TagItem
                                          ): LONGINT;


PROCEDURE GetAttributes      * {base,- 78}(handle{8}: LayoutHandlePtr;
                                           id{0}: LONGINT;
                                           tags{9}..: U.Tag
                                          ): LONGINT;

PROCEDURE SetAttributesA     * {base,- 84}(handle{8}: LayoutHandlePtr;
                                           id{0}: LONGINT;
                                           tagList{9}: ARRAY OF U.TagItem
                                          );

PROCEDURE SetAttributes      * {base,- 84}(handle{8}: LayoutHandlePtr;
                                           id{0}: LONGINT;
                                           tags{9}..: U.Tag
                                          );

PROCEDURE AddA               * {base,- 90}((* OBSOLETE *));
PROCEDURE Add                * {base,- 90}((* OBSOLETE *));

PROCEDURE NewA               * {base,- 96}(handle{8}: LayoutHandlePtr;
                                           tagList{9}: ARRAY OF U.TagItem
                                          );

PROCEDURE New                * {base,- 96}(handle{8}: LayoutHandlePtr;
                                           tags{9}..: U.Tag
                                          );

PROCEDURE EndGroup           * {base,-102}(handle{8}: LayoutHandlePtr);

PROCEDURE LayoutA            * {base,-108}((* OBSOLETE *));
PROCEDURE Layout             * {base,-108}((* OBSOLETE *));

PROCEDURE LayoutMenusA       * {base,-114}(handle{8}: LayoutHandlePtr;
                                           menuTemplate{9}: GT.NewMenuPtr;
                                           tagList{10}: ARRAY OF U.TagItem
                                          ): I.MenuPtr;

PROCEDURE LayoutMenus        * {base,-114}(handle{8}: LayoutHandlePtr;
                                           menuTemplate{9}: GT.NewMenuPtr;
                                           tags{9}..: U.Tag
                                          ): I.MenuPtr;

PROCEDURE Fixed2String       * {base,-120}(fixed{0}: FIXED; buffer{1}: E.LSTRPTR);

PROCEDURE String2Fixed       * {base,-126}(buffer{8}: E.LSTRPTR): FIXED;

PROCEDURE FixedMult          * {base,-132}(fixed{0}: FIXED; factor{1}: LONGINT): LONGINT;

PROCEDURE LabelWidth         * {base,-138}(handle{8}: LayoutHandlePtr;
                                           label{9}: E.LSTRPTR
                                          ): LONGINT;

PROCEDURE LabelChars         * {base,-144}(handle{8}: LayoutHandlePtr;
                                           label{9}: E.LSTRPTR
                                          ): LONGINT;

PROCEDURE LockWindow         * {base,-150}(window{8}: I.WindowPtr);

PROCEDURE UnlockWindow       * {base,-156}(window{8}: I.WindowPtr);

PROCEDURE DeleteWindowLock   * {base,-162}(window{8}: I.WindowPtr);

PROCEDURE ShowWindow         * {base,-168}(handle{8}: LayoutHandlePtr;
                                           activate{9}: BOOLEAN
                                          );

PROCEDURE Activate           * {base,-174}(handle{8}: LayoutHandlePtr;
                                           id{0}: LONGINT
                                          );

PROCEDURE PressButton        * {base,-180}(handle{8}: LayoutHandlePtr;
                                           id{0}: LONGINT
                                          );

PROCEDURE GetCode            * {base,-186}(msgQualifier{0}: LONGINT;
                                           VAR msgClass{1}: LONGINT;
                                           VAR msgCode{2}: INTEGER;
                                           VAR msgGadget{8}: I.GadgetPtr
                                          ): INTEGER;

(*--- Added in v1.78 --------------------------------------------------*)

PROCEDURE GetIMsg   * {base,-192}(handle{8}: LayoutHandlePtr): I.IntuiMessagePtr;
PROCEDURE ReplyIMsg * {base,-198}(msg{8}: I.IntuiMessagePtr);

(*--- Added in v3.0 ---------------------------------------------------*)

PROCEDURE BuildA         * {base,-204}(handle{8}: LayoutHandlePtr;
                                       tagList{9}: ARRAY OF U.TagItem
                                      ): I.WindowPtr;

PROCEDURE Build          * {base,-204}(handle{8}: LayoutHandlePtr;
                                       tags{9}..: U.Tag
                                      ): I.WindowPtr;

PROCEDURE RebuildTagList * {base,-210}(handle{8}: LayoutHandlePtr;
                                       clear{0}: BOOLEAN;
                                       tagList{9}: ARRAY OF U.TagItem
                                      ): BOOLEAN;

PROCEDURE RebuildTags    * {base,-210}(handle{8}: LayoutHandlePtr;
                                       clear{0}: BOOLEAN;
                                       tags{9}..: U.Tag
                                      ): BOOLEAN;

(*--- Added in v9.0 ---------------------------------------------------*)

PROCEDURE UpdateStrings * {base,-216}(handle{8}: LayoutHandlePtr);

(*--- Added in v11.0 ---------------------------------------------------*)

PROCEDURE DisposeMenu        * {base,-222}(menu{8}: I.MenuPtr);

PROCEDURE NewMenuTemplate    * {base,-228}(screen{8}: I.ScreenPtr;
                                           textAttr{9}: G.TextAttrPtr;
                                           amigaGlyph{10}: I.ImagePtr;
                                           checkGlyph{11}: I.ImagePtr;
                                           VAR error{0}: LONGINT;
                                           menuTemplate{1}: GT.NewMenuPtr
                                          ): I.MenuPtr;

PROCEDURE NewMenuTagList     * {base,-234}(tagList{0}: ARRAY OF U.TagItem
                                          ): I.MenuPtr;

PROCEDURE NewMenuTags        * {base,-234}(tags{8}..: U.Tag
                                          ): I.MenuPtr;

PROCEDURE MenuControlTagList * {base,-240}(window{8}: I.WindowPtr;
                                           intuitionMenu{9}: I.MenuPtr;
                                           tagList{10}: ARRAY OF U.TagItem
                                          );

PROCEDURE MenuControlTags    * {base,-240}(window{8}: I.WindowPtr;
                                           intuitionMenu{9}: I.MenuPtr;
                                           tags{10}..: U.Tag
                                          );

PROCEDURE GetMenuItem        * {base,-246}(menu{8}: I.MenuPtr;
                                           id{0}: LONGINT
                                          ): I.MenuItemPtr;

PROCEDURE FindMenuCommand    * {base,-252}(menu{8}: I.MenuPtr;
                                           msgCode{0}: INTEGER;
                                           msgQualifier{0}: INTEGER;
                                           msgGadget{9}: I.GadgetPtr
                                          ): I.MenuItemPtr;

(*--- Added in v14.0 ---------------------------------------------------*)

PROCEDURE NewLevelWidth* {base,-258}(handle{8}: LayoutHandlePtr;
                                     levelFormat{9}: E.LSTRPTR;
                                     dispFunc{10}: DispFunc;
                                     min{0}: LONGINT;
                                     max{1}: LONGINT;
                                     VAR maxWidth{11}: LONGINT;
                                     VAR maxLen{3}: LONGINT;
                                     fullCheck{2}: BOOLEAN);

(* ==================================================================== *)

(* Useful macros *)

PROCEDURE GetString* (handle: LayoutHandlePtr;
                      code: LONGINT;
                      VAR string: ARRAY OF CHAR);
BEGIN
  COPY (S.VAL(E.LSTRPTR, GetAttributes(handle, code, U.done))^, string);
END GetString;

(* ==================================================================== *)

BEGIN

  base := E.OpenLibrary (gtLayoutName, 0);

CLOSE

  IF (base # NIL) THEN E.CloseLibrary (base) END;

END GTLayout.

(* ==================================================================== *)

(*
******* GTLayout/--history-- *******
*
* $Log: GTLayout.mod $
* Revision 1.1  1995/09/06  02:15:26  phf
* Initial revision
*
*
**************
*
**************
*)

(* ==================================================================== *)
