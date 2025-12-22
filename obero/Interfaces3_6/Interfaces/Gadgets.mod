(*
(*  Amiga Oberon Interface Module:
**  $VER: Gadgets.mod 40.15 (28.12.93) Oberon 3.0
**
**      (C) Copyright 1991-1992 Commodore-Amiga, Inc.
**          All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993 by hartmut Goebel
*)          All Rights Reserved
*)

MODULE Gadgets;

(* !!! ATTENTION !!!
 * You have to call OpenColorWheel() and check it' result before
 * using any of the colorwheel's procedures. The colorwheel is not
 * opened automatically to save memory.
 *)

IMPORT
  e  * := Exec,
  u  * := Utility;

(*****************************************************************************)
CONST
  colorWheelName * = "colorwheel.gadget";

TYPE

  ColorWheelHSBPtr *= UNTRACED POINTER TO ColorWheelHSB;
  ColorWheelRGBPtr *= UNTRACED POINTER TO ColorWheelRGB;

(* For use with the WHEEL_HSB tag *)
  ColorWheelHSB * = STRUCT
    hue         * : LONGINT;
    saturation  * : LONGINT;
    brightness  * : LONGINT;
  END;

(* For use with the WHEEL_RGB tag *)
  ColorWheelRGB * = STRUCT
    red   * : LONGINT;
    green * : LONGINT;
    blue  * : LONGINT;
  END;


(*****************************************************************************)
CONST

  wheelDummy          * = u.user+04000000H;
  wheelHue            * = wheelDummy+1;   (* set/get Hue               *)
  wheelSaturation     * = wheelDummy+2;   (* set/get Saturation        *)
  wheelBrightness     * = wheelDummy+3;   (* set/get Brightness        *)
  wheelHSB            * = wheelDummy+4;   (* set/get ColorWheelHSB     *)
  wheelRed            * = wheelDummy+5;   (* set/get Red               *)
  wheelGreen          * = wheelDummy+6;   (* set/get Green             *)
  wheelBlue           * = wheelDummy+7;   (* set/get Blue              *)
  wheelRGB            * = wheelDummy+8;   (* set/get ColorWheelRGB     *)
  wheelScreen         * = wheelDummy+9;   (* init screen/enviroment    *)
  wheelAbbrv          * = wheelDummy+10;  (* "GCBMRY" if English       *)
  wheelDonation       * = wheelDummy+11;  (* colors donated by app     *)
  wheelBevelBox       * = wheelDummy+12;  (* inside a bevel box        *)
  wheelGradientSlider * = wheelDummy+13;  (* attached gradient slider  *)
  wheelMaxPens        * = wheelDummy+14;  (* max # of pens to allocate *)


(*****************************************************************************)


  gradDummy      * = u.user+005000000H;
  gradMaxVal     * = gradDummy+1;     (* max value of slider         *)
  gradCurVal     * = gradDummy+2;     (* current value of slider     *)
  gradSkipVal    * = gradDummy+3;     (* "body click" move amount    *)
  gradKnobPixels * = gradDummy+4;     (* size of knob in pixels      *)
  gradPenArray   * = gradDummy+5;     (* pen colors                  *)


(*****************************************************************************)


  tdeckDummy        * = u.user + 05000000H;
  tdeckMode         * = tdeckDummy + 1;
  tdeckPaused       * = tdeckDummy + 2;

  tdeckTape         * = tdeckDummy + 3;
        (* (BOOL) Indicate whether tapedeck or animation controls.  Defaults
         * to FALSE. *)

  tdeckFrames       * = tdeckDummy + 11;
        (* (LONG) Number of frames in animation.  Only valid when using
         * animation controls. *)

  tdeckCurrentFrame  * = tdeckDummy + 12;
        (* (LONG) Current frame.  Only valid when using animation controls. *)

(*****************************************************************************)

(* Possible values for TDECK_Mode *)
  butRewind    * = 0;
  butPlay      * = 1;
  butForward   * = 2;
  butStop      * = 3;
  butPause     * = 4;
  butBegin     * = 5;
  butFrame     * = 6;
  butEnd       * = 7;

(*****************************************************************************)

VAR
  cwBase * : e.LibraryPtr;
  cwOpenCount: LONGINT; (* OpenLib() counter *)

(*--- functions in V39 or higher (Release 3) ---*)

(* Public entries *)

PROCEDURE ConvertHSBToRGB   *{cwBase,-01EH}(hsb{8}    : ColorWheelHSB;
                                            VAR rgb{9}: ColorWheelRGB);
PROCEDURE ConvertRGBToHSB   *{cwBase,-024H}(rgb{8}    : ColorWheelRGB;
                                            VAR hsb{9}: ColorWheelHSB);

PROCEDURE OpenColorWheel * (): BOOLEAN;
BEGIN
  IF cwOpenCount = 0 THEN (* not opened *)
    cwBase := e.OpenLibrary(colorWheelName,39);
  END;
  IF cwBase # NIL THEN
    INC(cwOpenCount);
    RETURN TRUE;
  END;
  RETURN FALSE;
END OpenColorWheel;

PROCEDURE CloseColorWheel * ();
BEGIN
  IF cwOpenCount > 0 THEN
    DEC(cwOpenCount);
    IF cwOpenCount = 0 THEN
      e.CloseLibrary(cwBase); cwBase := NIL;
    END;
  END;
END CloseColorWheel;

BEGIN
  (* cwOpenCount := 0; not needed for AmigaOberon *)

CLOSE
  IF cwBase # NIL THEN e.CloseLibrary(cwBase); END;

END Gadgets.
