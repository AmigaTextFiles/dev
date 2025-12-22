MODULE TextField;

(* Oberon Interface for textfield.gadget ©1994 Mark Thomas
** $VER: TextField.mod 1.1 (18.09.94)
**
** Stefan
**
** slbrbbbh@w250zrz.zrz.TU-Berlin.de
**    StElb@IRC
*)

IMPORT Exec, I := Intuition, u := Utility;

(*
 * textfield.h
 *
 * Copyright © 1994 Mark Thomas
 *
 * Defines for the BOOPSI textfield.gadget V1.2.
 *)
CONST

tagBase = u.user + 04000000H;

text         * = tagBase + 1;
insertText   * = tagBase + 2;
textFont     * = tagBase + 3;
delimiters   * = tagBase + 4;
top          * = tagBase + 5;
blockCursor  * = tagBase + 6;
size         * = tagBase + 7;
visible      * = tagBase + 8;
lines        * = tagBase + 9;
noGhost      * = tagBase + 10;
maxSize      * = tagBase + 11;
border       * = tagBase + 12;
textAttr     * = tagBase + 13;
fontStyle    * = tagBase + 14;
up           * = tagBase + 15;
down         * = tagBase + 16;
alignment    * = tagBase + 17;
vCenter      * = tagBase + 18;
ruledPaper   * = tagBase + 19;
paperPen     * = tagBase + 20;
inkPen       * = tagBase + 21;
linePen      * = tagBase + 22;
userAlign    * = tagBase + 23;
spacing      * = tagBase + 24;
clipStream   * = tagBase + 25;
clipStream2  * = tagBase + 26;
blinkRate    * = tagBase + 27;
inverted     * = tagBase + 28;
partial      * = tagBase + 29;
cursorPos    * = tagBase + 30;

(*
 *Border
 *
 * See docs for width and height sizes these borders are
 *)

none              * = 0;
bevel             * = 1;
doubleBevel       * = 2;

(*
 *Alignment
 *)

left             * = 0H;
center           * = 1H;
right            * = 2H;

VAR
  base * : Exec.LibraryPtr;
  textFieldClass * : I.IClassPtr;

PROCEDURE GetClass      *{base,-30}():I.IClassPtr;

BEGIN
(*
 * TextField autoinit and autoterminate functions
 * for SAS/C 6.50 and up.
 *
 * If you just compile and link this into your app
 * then TextFieldBase will automatically get setup
 * before main() is called.  All your app source has
 * to include in order to call TEXTFIELD_GetClass() is the
 * <proto/textfield.h> file.
 *)

base := Exec.OpenLibrary("gadgets/textfield.gadget", 0);
textFieldClass := GetClass();

CLOSE

IF base#NIL THEN Exec.CloseLibrary(base) END;

END TextField.
