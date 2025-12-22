(*
(*  Amiga Oberon Interface Module:
**  $VER: LowLevel.mod 40.15 (12.1.95) Oberon 3.6
**
**      (C) Copyright 1993 Commodore-Amiga, Inc.
**          All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993 by hartmut Goebel
*)          All Rights Reserved
*)

MODULE LowLevel;

IMPORT
  e * := Exec,
  Timer *,
  u * := Utility,
  SYSTEM;

CONST
  lowlevelName * = "lowlevel.library";

TYPE
  KeyQueryPtr * = UNTRACED POINTER TO KeyQuery;


(*****************************************************************************)


(* structure for use with QueryKeys() *)
  KeyQuery * = STRUCT
    keyCode * : INTEGER;
    pressed * : e.BOOL;
  END;


(*****************************************************************************)

CONST
(* bits in the return value of GetKey() *)
  lShift     * = 16;
  rShift     * = 17;
  capsLock   * = 18;
  control    * = 19;
  lAlt       * = 20;
  rAlt       * = 21;
  lAmiga     * = 22;
  rAmiga     * = 23;

(* bits in the return value of GetKey() for use with KeyDescription *)
  kdLShift     * = 0;
  kdRShift     * = 1;
  kdCapsLock   * = 2;
  kdControl    * = 3;
  kdLAlt       * = 4;
  kdRAlt       * = 5;
  kdLAmiga     * = 6;
  kdRAmiga     * = 7;

(*****************************************************************************)


(* Tags for SetJoyPortAttrs() *)
  sjaDummy            * = u.user+0C00100H;
  sjaType             * = sjaDummy+1;      (* force type to mouse, joy, game cntrlr *)
  sjaReinitialize     * = sjaDummy+2;      (* free potgo bits, reset to autosense   *)

(* Controller types for SJA_Type tag *)
  sjyTypeAutosense    * = 0;
  sjaTypeGameCtlr     * = 1;
  sjaTypeMouse        * = 2;
  sjaTypeJoystk       * = 3;


(*****************************************************************************)


(* ReadJoyPort() return value definitions *)

(* Port types *)
  typeNotAvail * = ASH(00,28);     (* port data unavailable    *)
  typeGameCtlr * = ASH(01,28);     (* port has game controller *)
  typeMouse    * = ASH(02,28);     (* port has mouse           *)
  typeJoystk   * = ASH(03,28);     (* port has joystick        *)
  typeUnknown  * = ASH(04,28);     (* port has unknown device  *)
  typeMask     * = ASH(15,28);     (* controller type          *)

(* Button types, valid for all types except JP_TYPE_NOTAVAIL *)
  buttonBlue    * = 23;    (* Blue - Stop; Right Mouse                *)
  buttonRed     * = 22;    (* Red - Select; Left Mouse; Joystick Fire *)
  buttonYellow  * = 21;    (* Yellow - Repeat                         *)
  buttonGreen   * = 20;    (* Green - Shuffle                         *)
  buttonForward * = 19;    (* Charcoal - Forward                      *)
  buttonReverse * = 18;    (* Charcoal - Reverse                      *)
  buttonPlay    * = 17;    (* Grey - Play/Pause; Middle Mouse         *)
  buttonMask    * = LONGSET{buttonBlue,buttonRed,buttonYellow,buttonGreen,
                            buttonForward,buttonReverse,buttonPlay};

(* Direction types, valid for JP_TYPE_GAMECTLR and JP_TYPE_JOYSTK *)
  joyUp         * = 3;
  joyDown       * = 2;
  joyLeft       * = 1;
  joyRight      * = 0;
  directionMask * = LONGSET{joyUp,joyDown,joyLeft,joyRight};

(* Mouse position reports, valid for JP_TYPE_MOUSE *)
  mHorzMask * = ASH(255,0);           (* horizontal position *)
  mVertMask * = ASH(255,8);           (* vertical position   *)
  mouseMask * = mHorzMask + mVertMask;


(*****************************************************************************)


(* Tags for SystemControl() *)
  sconDummy           * = u.user+00C00000H;
  sconTakeoversys     * = sconDummy+0;
  sconKillreq         * = sconDummy+1;
  sconCdreboot        * = sconDummy+2;
  sconStopinput       * = sconDummy+3;
  sconAddcreatekeys   * = sconDummy+4;
  sconRemcreatekeys   * = sconDummy+5;

(* Reboot control values for use with SCON_CDReboot tag *)
  cdRebootOn          * = 1;
  cdRebootOff         * = 0;
  cdRebootDefault     * = 2;


(*****************************************************************************)


(* Rawkey codes returned when using SCON_AddCreateKeys with SystemControl() *)

  port0ButtonBlue    * = 072H;
  port0ButtonRed     * = 078H;
  port0ButtonYellow  * = 077H;
  port0ButtonGreen   * = 076H;
  port0ButtonForward * = 075H;
  port0ButtonReverse * = 074H;
  port0ButtonPlay    * = 073H;
  port0JoyUp         * = 079H;
  port0JoyDown       * = 07AH;
  port0JoyLeft       * = 07CH;
  port0JoyRight      * = 07BH;

  port1ButtonBlue    * = 0172H;
  port1ButtonRed     * = 0178H;
  port1ButtonYellow  * = 0177H;
  port1ButtonGreen   * = 0176H;
  port1ButtonForward * = 0175H;
  port1ButtonReverse * = 0174H;
  port1ButtonPlay    * = 0173H;
  port1JoyUp         * = 0179H;
  port1JoyDown       * = 017AH;
  port1JoyLeft       * = 017CH;
  port1JoyRight      * = 017BH;

  port2ButtonBlue    * = 0272H;
  port2ButtonRed     * = 0278H;
  port2ButtonYellow  * = 0277H;
  port2ButtonGreen   * = 0276H;
  port2ButtonForward * = 0275H;
  port2ButtonReverse * = 0274H;
  port2ButtonPlay    * = 0273H;
  port2JoyUp         * = 0279H;
  port2JoyDown       * = 027AH;
  port2JoyLeft       * = 027CH;
  port2JoyRight      * = 027BH;

  port3ButtonBlue    * = 0372H;
  port3ButtonRed     * = 0378H;
  port3ButtonYellow  * = 0377H;
  port3ButtonGreen   * = 0376H;
  port3ButtonForward * = 0375H;
  port3ButtonReverse * = 0374H;
  port3ButtonPlay    * = 0373H;
  port3JoyUp         * = 0379H;
  port3JoyDown       * = 037AH;
  port3JoyLeft       * = 037CH;
  port3JoyRight      * = 037BH;


(*****************************************************************************)


(* Return values for GetLanguageSelection() *)
  langUnknown     * = 0;
  american        * = 1;           (* American English *)
  english         * = 2;           (* British English  *)
  german          * = 3;
  french          * = 4;
  spanish         * = 5;
  italian         * = 6;
  portuguese      * = 7;
  danish          * = 8;
  dutch           * = 9;
  norwegian       * = 10;
  finnish         * = 11;
  swedish         * = 12;
  japanese        * = 13;
  chinese         * = 14;
  arabic          * = 15;
  greek           * = 16;
  hebrew          * = 17;
  korean          * = 18;

(*****************************************************************************)

TYPE
  (* some dummys for type security *)
  KBIntHandle     * = UNTRACED POINTER TO STRUCT END;
  TimerIntHandle  * = UNTRACED POINTER TO STRUCT END;
  VBlankIntHandle * = UNTRACED POINTER TO STRUCT END;

  (* easy handling of GetKey() result *)
  KeyDescription * = STRUCT
    qualifier *: SET;
    code      *: INTEGER;
  END;


(* $StackChk- $RangeChk- $NilChk- $OvflChk- $ReturnChk- $CaseChk- *)

VAR
  base *: e.LibraryPtr;

(*--- functions in V40 or higher (Release 3.1) ---*)

(* CONTROLLER HANDLING *)

PROCEDURE ReadJoyPort    *{base,-001EH}(port{0}       : LONGINT): LONGSET;

(* LANGUAGE HANDLING *)

PROCEDURE GetLanguageSelection *{base,-0024H}()       : SHORTINT;

(* KEYBOARD HANDLING *)

PROCEDURE GetKey         *{base,-0030H}()             : KeyDescription;
PROCEDURE QueryKeys      *{base,-0036H}(queryArray{8} : KeyQueryPtr;
                                        arraySize{1}  : LONGINT);
PROCEDURE AddKBInt       *{base,-003CH}(intRoutine{8} : e.PROC;
                                        intData{9}    : e.APTR): KBIntHandle;
PROCEDURE RemKBInt       *{base,-0042H}(intHandle{9}  : KBIntHandle);

(* SYSTEM HANDLING *)

PROCEDURE SystemControlA *{base,-0048H}(tagList{9}    : ARRAY OF u.TagItem): u.TagID;
PROCEDURE SystemControl  *{base,-0048H}(firstTag{9}.. : u.Tag): u.TagID;

(* TIMER HANDLING *)

PROCEDURE AddTimerInt    *{base,-004EH}(intRoutine{8} : e.PROC;
                                        intData{9}    : e.APTR): TimerIntHandle;
PROCEDURE RemTimerInt    *{base,-0054H}(intHandle{9}  : TimerIntHandle);
PROCEDURE StopTimerInt   *{base,-005AH}(intHandle{9}  : TimerIntHandle);
PROCEDURE StartTimerInt  *{base,-0060H}(intHandle{9}  : TimerIntHandle;
                                        timeInterval{0}: LONGINT;
                                        continuous{1} : e.LONGBOOL);
PROCEDURE ElapsedTime    *{base,-0066H}(VAR context{8}: Timer.EClockVal): LONGINT;

(* VBLANK HANDLING *)

PROCEDURE AddVBlankInt   *{base,-006CH}(intRoutine{8} : e.PROC;
                                        intData{9}    : e.APTR): VBlankIntHandle;
PROCEDURE RemVBlankInt   *{base,-0072H}(intHandle{9}  : VBlankIntHandle);

(* MORE CONTROLLER HANDLING *)

PROCEDURE SetJoyPortAttrsA *{base,-0084H}(portNumber{0}: LONGINT;
                                         tagList{9}   : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE SetJoyPortAttrs *{base,-0084H}(portNumber{0}: LONGINT;
                                         firstTag{9}..: u.Tag): BOOLEAN;


(* only a dummy to make sure SIZE(KeyDescriptor) = SIZE(LONGINT) *)
PROCEDURE CheckKeyDescriptorSize(kd: KeyDescription): LONGINT;
BEGIN RETURN SYSTEM.VAL(LONGINT,kd); END CheckKeyDescriptorSize;

BEGIN
  base := e.OpenLibrary(lowlevelName,40);

CLOSE
  IF base # NIL THEN e.CloseLibrary(base); END;

END LowLevel.

