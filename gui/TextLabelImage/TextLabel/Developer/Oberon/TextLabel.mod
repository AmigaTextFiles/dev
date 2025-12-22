(*
(*  $VER: TextLabel.mod 2.2 (18.7.95)
**
**  Interface definitions for BOOPSI textlabel image objects.
**
**  (c) Copyright 1994, 1995 hartmut Goebel.
*)      All Rights Reserved.
*)

MODULE TextLabel;

IMPORT
  e := Exec,
  I := Intuition,
  u := Utility;

CONST
  textLabelName * = "textlabel.image";

  (* Attributes *)
  tlDummy     = u.user+50;
  aUnderscore * = tlDummy + 1;
        (* [IS...] (CHAR) - Character for determining the shortcut. *)

  aGadget     * = tlDummy + 2;
        (* NEW for V2:
         * [IS...] (Intuition.GadgetPtr) - be a label for this gadget.
         * This is a mighty function, see class documentation for
         * further information.
         * You should at most specify one of TLA_Gadget and TLA_Image *)

  aAdjustment * = tlDummy + 3;
        (* [IS...] (LONGSET) - Adjustment within the frame of
         * IM_DRAWFRAME. Defaults to adjustCenter. *)

  aKey           * = tlDummy + 4;
        (* [..G..] (CHAR) - Shortcut key of this label. *)

  aImage         * = tlDummy + 5;
        (* NEW for V2:
         * [IS...] (Intuition.ImagePtr) - be a label for this image.
         * This is a mighty function, see class documentation for
         * further information.
         * You should at most specify one of TLA_Gadget and TLA_Image
         *)

  aText       * = I.iaData;
        (* [IS...] (Exec.STRPTR) - pointer to a null terminated
         * array of character. *)

  aFont       * = I.iaFont;
        (* [ISG..] (Graphics.TextFontPtr) - Font to be used for
         * rendering the label strings.  Defaults to use
         * DrawInfo.font. *)

  aDrawInfo   * = I.sysiaDrawInfo;
        (* [IS...] (Intuition.DrawInfoPtr) - DrawInfoPtr for
         * target screen. Required if aFont is ommitted. *)

  aMode       * = I.iaMode;
        (* [IS...] (SHORTSET) - Drawing mode to use. *)

  aLeft       * = I.iaLeft;
  aTop        * = I.iaTop;
        (* [ISG..] (INTEGER) - left/top edge of image
         * Specifying aGadget or aImage overwrites this attributes.
         *)

  aWidth      * = I.iaWidth;
  aHeight     * = I.iaHeight;
        (* [..G..] (INTEGER) - dimensions of image
         * filled in by the object *)

  aFGPen      * = I.iaFGPen;
  aBGPen      * = I.iaBGPen;
        (* [IS...] (SHORTINT) - Pen numbers to be used as foreground
         * and background pens. Defaults to Intuition.blockPen and
         * Intuition.backGroundPen. *)


  (* values for aAdjustment *)
  adjustCenter  * = LONGSET{ };

  adjustHCenter * = LONGSET{ };
  adjustHLeft   * = LONGSET{0};
  adjustHRight  * = LONGSET{1};

  adjustVCenter * = LONGSET{ };
  adjustVTop    * = LONGSET{2};
  adjustVBottom * = LONGSET{3};

TYPE
  (* textlabel.image is an external class library.  OpenLibrary() returns
   * a pointer to a struct ClassLibrary, from which you can obtain the class
   * handle to create objects (textlabel.image is not a public class).
   *)
  ClassLibraryPtr  * = UNTRACED POINTER TO ClassLibrary;
  ClassLibrary * = STRUCT (lib *: e.Library) (* Embedded library *)
    pad     :  INTEGER;                      (* Align the structure *)
    class - :  I.IClassPtr;                  (* Class pointer *)
  END;

VAR
  base *: ClassLibraryPtr;

BEGIN
  base := e.OpenLibrary("images/textlabel.image",0);
  IF base = NIL THEN HALT(20) END;

CLOSE
  IF base # NIL THEN e.CloseLibrary(base); END;

END TextLabel.
