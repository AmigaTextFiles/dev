(*
(*
**  Amiga Oberon Interface Module:
**  $VER: InputEvent.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE InputEvent; (* $Implementation- *)

IMPORT
  e * := Exec,
  t * := Timer,
  u * := Utility,
  g * := Graphics;

TYPE
  IEDummyPtr         * = UNTRACED POINTER TO IEDummy;
  PointerPixelPtr    * = UNTRACED POINTER TO PointerPixel;
  NewTabletPtr       * = UNTRACED POINTER TO NewTablet;
  PointerTabletPtr   * = UNTRACED POINTER TO PointerTablet;
  InputEventDummyPtr * = UNTRACED POINTER TO InputEventDummy;
  InputEventPtr      * = UNTRACED POINTER TO InputEvent;
  InputEventAdrPtr   * = UNTRACED POINTER TO InputEventAdr;
  InputEventPrevPtr  * = UNTRACED POINTER TO InputEventPrev;

CONST
(*----- constants --------------------------------------------------*)

(*  --- InputEvent.class --- *)
  null           * = 00H; (* A NOP input event                              *)
  rawkey         * = 01H; (* A raw keycode from the keyboard device         *)
  rawmouse       * = 02H; (* The raw mouse report from the game port        *
                           * device                                         *)
  event          * = 03H; (* A private console event                        *)
  pointerpos     * = 04H; (* A Pointer Position report                      *)
  timer          * = 06H; (* A timer event                                  *)
  gadgetdown     * = 07H; (* select button pressed down over a Gadget       *
                           * (address in ie_EventAddress)                   *)
  gadgetup       * = 08H; (* select button released over the same Gadget    *
                           * (address in ie_EventAddress)                   *)
  requester      * = 09H; (* some Requester activity has taken place.  See  *
                           * Codes REQCLEAR and REQSET                      *)
  menulist       * = 0AH; (* this is a Menu Number transmission (Menu       *
                           * number is in ie_Code)                          *)
  closewindow    * = 0BH; (* User has selected the active Window's Close    *
                           * Gadget                                         *)
  sizewindow     * = 0CH; (* this Window has a new size                     *)
  refreshwindow  * = 0DH; (* the Window pointed to by ie_EventAddress needs *
                           * to be refreshed                                *)
  newprefs       * = 0EH; (* new preferences are available                  *)
  diskremoved    * = 0FH; (* the disk has been removed                      *)
  diskinserted   * = 10H; (* the disk has been inserted                     *)
  activewindow   * = 11H; (* the window is about to be been made active     *)
  inactivewindow * = 12H; (* the window is about to be made inactive        *)
  newpointerpos  * = 13H; (* extended-function pointer position report      *
                           * (V36)                                          *)
  menuhelp       * = 14H; (* Help key report during Menu session (V36)      *)
  changewindow   * = 15H; (* the Window has been modified with move, size,  *
                           * zoom, or change (V36)                          *)

  classMax       * = 15H; (* the last class                                 *)


(*  --- InputEvent.subClass --- *)
(*  newpointerpos *)
  compatible   * = 00H;  (* like pointerpos *)
  pixel        * = 01H;  (* InputEvent.eventAddress points to PointerPixel *)
  tablet       * = 02H;  (* InputEvent.eventAddress points to PointerTablet *)
  newTablet    * = 03H;  (* InputEvent.eventAddress points to NewTablet *)

TYPE
  IEDummy * = STRUCT END; (* dummy for InputEvent.eventAddress *)

(* pointed to by InputEvent.eventAddress for newpointerposs,
 * and InputEvent.subClass=pixel.
 *
 * You specify a screen and pixel coordinates in that screen
 * at which you'd like the mouse to be positioned.
 * Intuition will try to oblige, but there will be restrictions
 * to positioning the pointer over offscreen pixels.
 *
 * IEQUALIFIER_RELATIVEMOUSE is supported for IESUBCLASS_PIXEL.
 *)
  PointerPixel * = STRUCT (dummy: IEDummy)
    screen * : e.APTR;                  (* pointer to an open screen *)
    position * : g.Point;               (* pixel coordinates in iepp_Screen *)
  END;

(* pointed to by InputEvent.eventAddress for newpointerpos,
 * and InputEvent.subClass=tablet.
 *
 * You specify a range of values and a value within the range
 * independently for each of X and Y (the minimum value of
 * the ranges is always normalized to 0).
 *
 * Intuition will position the mouse proportionally within its
 * natural mouse position rectangle limits.
 *
 * IEQUALIFIER_RELATIVEMOUSE is not supported for IESUBCLASS_TABLET.
 *)
  PointerTablet * = STRUCT (dummy: IEDummy)
    range * : g.Point;     (* 0 is min, these are max   *)
    value * : g.Point;     (* between 0 and range       *)
    pressure * : INTEGER;  (* -128 to 127 (unused, set to 0)  *)
  END;


(* The ie_EventAddress of an IECLASS_NEWPOINTERPOS event of subclass
 * IESUBCLASS_NEWTABLET points at an IENewTablet structure.
 *
 *
 * IEQUALIFIER_RELATIVEMOUSE is not supported for IESUBCLASS_NEWTABLET.
 *)

  NewTablet * = STRUCT (dummy: IEDummy)

    (* Pointer to a hook you wish to be called back through, in
     * order to handle scaling.  You will be provided with the
     * width and height you are expected to scale your tablet
     * to, perhaps based on some user preferences.
     * If NULL, the tablet's specified range will be mapped directly
     * to that width and height for you, and you will not be
     * called back.
     *)
    callBack        * : u.HookPtr;

    (* Post-scaling coordinates and fractional coordinates.
     * DO NOT FILL THESE IN AT THE TIME THE EVENT IS WRITTEN!
     * Your driver will be called back and provided information
     * about the width and height of the area to scale the
     * tablet into.  It should scale the tablet coordinates
     * (perhaps based on some preferences controlling aspect
     * ratio, etc.) and place the scaled result into these
     * fields.        The ient_ScaledX and ient_ScaledY fields are
     * in screen-pixel resolution, but the origin ( [0,0]-point )
     * is not defined.        The ient_ScaledXFraction and
     * ient_ScaledYFraction fields represent sub-pixel position
     * information, and should be scaled to fill a UWORD fraction.
     *)
    scaledX         * : INTEGER;
    scaledY         * : INTEGER;
    scaledXFraction * : INTEGER;
    scaledYFraction * : INTEGER;

    (* Current tablet coordinates along each axis: *)
    tabletX         * : LONGINT;
    tabletY         * : LONGINT;

    (* Tablet range along each axis.  For example, if ient_TabletX
     * can take values 0-999, ient_RangeX should be 1000.
     *)
    rangeX          * : LONGINT;
    rangeY          * : LONGINT;

    (* Pointer to tag-list of additional tablet attributes.
     * See <intuition/intuition.h> for the tag values.
     *)
    tagList         * : u.TagListPtr;
  END;

CONST

(*  --- InputEvent.ie_Code --- *)
(*  IECLASS_RAWKEY *)
  upPrefix             * = 080H;
  keyCodeFirst         * = 000H;
  keyCodeLast          * = 077H;
  commCodeFirst        * = 078H;
  commCodeLast         * = 07FH;

(*  IECLASS_ANSI *)
  c0First              * = 000H;
  c0Last               * = 01FH;
  asciiFirst           * = 020H;
  asciiLast            * = 07EH;
  asciiDel             * = 07FH;
  c1First              * = 080H;
  c1Last               * = 09FH;
  latin1First          * = 0A0H;
  latin1Last           * = 0FFH;

(*  IECLASS_RAWMOUSE *)
  lButton              * = 068H;  (* also uses IECODE_UP_PREFIX *)
  rButton              * = 069H;
  mButton              * = 06AH;
  noButton             * = 0FFH;

(*  IECLASS_EVENT (V36) *)
  newActive            * = 001H;  (* new active input window *)
  newSize              * = 002H;  (* resize of window *)
  refresh              * = 003H;  (* refresh of window *)

(*  IECLASS_REQUESTER *)
(*      broadcast when the first Requester (not subsequent ones) opens up in *)
(*      the Window *)
  reqSet               * = 001H;
(*      broadcast when the last Requester clears out of the Window *)
  reqClear             * = 000H;


(*  --- InputEvent.qualifier --- *)

  lShift         * = 0;
  rShift         * = 1;
  capsLock       * = 2;
  control        * = 3;
  lAlt           * = 4;
  rAlt           * = 5;
  lCommand       * = 6;
  rCommand       * = 7;
  numericPad     * = 8;
  repeat         * = 9;
  interrupt      * = 10;
  multiBroadCast * = 11;
  midButton      * = 12;
  rightButton    * = 13;
  leftButton     * = 14;
  relativeMouse  * = 15;

TYPE

(*----- InputEvent -------------------------------------------------*)

  InputEventDummy * = STRUCT END;
  InputEvent * = STRUCT (dummy: InputEventDummy)
    nextEvent     * : InputEventDummyPtr; (* the chronologically next event *)
    class         * : SHORTINT;      (* the input event class *)
    subClass      * : SHORTINT;      (* optional subclass of the class *)
    code          * : INTEGER;       (* the input event code *)
    qualifier     * : SET;           (* qualifiers in effect for the event*)
    x             * : INTEGER;       (* the pointer position for the event*)
    y             * : INTEGER;
    timeStamp     * : t.TimeVal;     (* the system tick at the event *)
  END;
  InputEventAdr * = STRUCT (dummy: InputEventDummy)
    nextEvent     * : InputEventDummyPtr;(* the chronologically next event *)
    class         * : SHORTINT;        (* the input event class *)
    subClass      * : SHORTINT;        (* optional subclass of the class *)
    code          * : INTEGER;         (* the input event code *)
    qualifier     * : SET;             (* qualifiers in effect for the event*)
    addr          * : IEDummyPtr;      (* the event address *)
    timeStamp     * : t.TimeVal;       (* the system tick at the event *)
  END;
  InputEventPrev * = STRUCT (dummy: InputEventDummy)
    nextEvent     * : InputEventDummyPtr;(* the chronologically next event *)
    class         * : SHORTINT;         (* the input event class *)
    subClass      * : SHORTINT;         (* optional subclass of the class *)
    code          * : INTEGER;          (* the input event code *)
    qualifier     * : SET;              (* qualifiers in effect for the event*)
    prev1DownCode * : SHORTINT;         (* previous down keys for dead *)
    prev1DownQual * : SHORTSET;         (*   key translation: the ie_Code *)
    prev2DownCode * : SHORTINT;         (*   & low byte of ie_Qualifier for *)
    prev2DownQual * : SHORTSET;         (*   last & second last down keys *)
    timeStamp     * : t.TimeVal;        (* the system tick at the event *)
  END;

END InputEvent.
