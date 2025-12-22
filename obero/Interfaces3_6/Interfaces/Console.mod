(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Console.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Console;

IMPORT e  * := Exec,
       ie * := InputEvent,
       km * := KeyMap,
       u  * := Utility;

CONST

  consoleName * = "console.device";

(****** Console commands ******)
  askKeyMap         * = e.nonstd+0;
  setKeyMap         * = e.nonstd+1;
  askDefaultKeyMap  * = e.nonstd+2;
  setDefaultKeyMap  * = e.nonstd+3;

(****** SGR parameters ******)

  primary     * = 0;
  bold        * = 1;
  italic      * = 3;
  underscore  * = 4;
  negative    * = 7;

  normal        * = 22;      (* default foreground color, not bold *)
  notItalic     * = 23;
  notUnderscore * = 24;
  positive      * = 27;

(* these names refer to the ANSI standard, not the implementation *)
  blank       * = 30;
  red         * = 31;
  green       * = 32;
  yellow      * = 33;
  blue        * = 34;
  magenta     * = 35;
  cyan        * = 36;
  white       * = 37;
  default     * = 39;

  blackBg     * = 40;
  redBg       * = 41;
  greenBg     * = 42;
  yellowBg    * = 43;
  blueBg      * = 44;
  magentaBg   * = 45;
  cyanBg      * = 46;
  whiteBg     * = 47;
  defaultBg   * = 49;

(* these names refer to the implementation, they are the preferred *)
(* names for use with the Amiga console device. *)
  clr0        * = 30;
  clr1        * = 31;
  clr2        * = 32;
  clr3        * = 33;
  clr4        * = 34;
  clr5        * = 35;
  clr6        * = 36;
  clr7        * = 37;

  clr0Bg      * = 40;
  clr1Bg      * = 41;
  clr2Bg      * = 42;
  clr3Bg      * = 43;
  clr4Bg      * = 44;
  clr5Bg      * = 45;
  clr6Bg      * = 46;
  clr7Bg      * = 47;


(****** DSR parameters ******)

  dsrCpr      * = 6;

(****** CTC parameters ******)
  ctcHSetTab     * = 0;
  ctcHClrTab     * = 2;
  ctcHClrTabsAll * = 5;

(****** TBC parameters ******)
  tbcHClrTab     * = 0;
  tbcHClrTabsAll * = 3;

(****** SM and RM parameters ******)
  mLNM   * = 20;      (* linefeed newline mode *)
  mASM   * = ">1";    (* auto scroll mode *)
  mAWM   * = "?7";    (* auto wrap mode *)


VAR
(*
 *  You have to put a pointer to the console.device here to use the input
 *  procedures:
 *)

  base * : e.DevicePtr;


PROCEDURE CDInputHandler*{base,- 42}(events{8}        : ie.InputEventDummyPtr;
                                     consoleDevice{9} : e.LibraryPtr): ie.InputEventDummyPtr;
PROCEDURE RawKeyConvert *{base,- 48}(events{8}        : e.APTR;
                                     VAR buffer{9}    : ARRAY OF e.BYTE;
                                     length{1}        : LONGINT;
                                     keyMap{10}       : km.KeyMapPtr): LONGINT;

(*--- functions in V36 or higher (Release 2.0) ---*)

PROCEDURE GetConSnip    *{base,- 54}(): LONGINT;
PROCEDURE SetConSnip    *{base,- 60}(snip{8}          : LONGINT);
PROCEDURE AddConSnipHook*{base,- 66}(hook{8}          : u.HookPtr);
PROCEDURE RemConSnipHook*{base,- 72}(hook{8}          : u.HookPtr);

END Console.

