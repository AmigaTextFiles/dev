(****************************************************************************

$RCSfile: GEClass.mod $

$Revision: 1.3 $
    $Date: 1994/12/16 16:39:53 $

    Oberon-2 interface module for the GUIEnvironment Class Library

    Oberon-A Oberon-2 Compiler V4.17 (Release 1.4 Update 2)

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
MODULE GEClass;

(* $P- Allow non-portable code *)


IMPORT K := Kernel,
       E := Exec,
       U := Utility;

CONST

  Name* = "geclass.library";  (* Library name *)
  Version* = 37;              (* min version / Revision 5 ! *)

(* ======================================================================= *)
(*                       The Get File Image Class                          *)
(* ======================================================================= *)

CONST getFileIClass *= "getfileiclass";

(* Default dimension: *)

  gfiWidth  *= 20;
  gfiHeight *= 14;


(* ======================================================================= *)
(*                       The TextField Gadget Class                        *)
(* ======================================================================= *)

(*
 * TextFieldGadget V2.0
 *
 * Copyright © 1994 Mark Thomas
 *
 *)

CONST textfieldgClass *= "textfieldgclass";

(* ----------------------- Attributes ------------------------------------ *)

CONST
  dummy            = U.tagUser + 04000000H;

  text            *= dummy + 1;    (* V1 *)
  insertText      *= dummy + 2;
  textFont        *= dummy + 3;
  delimiters      *= dummy + 4;
  top             *= dummy + 5;
  blockCursor     *= dummy + 6;
  size            *= dummy + 7;
  visible         *= dummy + 8;
  lines           *= dummy + 9;
  noGhost         *= dummy + 10;
  maxSize         *= dummy + 11;
  border          *= dummy + 12;
  textAttr        *= dummy + 13;
  fontStyle       *= dummy + 14;
  up              *= dummy + 15;
  down            *= dummy + 16;
  alignment       *= dummy + 17;
  vCenter         *= dummy + 18;
  ruledPaper      *= dummy + 19;
  paperPen        *= dummy + 20;
  inkPen          *= dummy + 21;
  linePen         *= dummy + 22;
  userAlign       *= dummy + 23;
  spacing         *= dummy + 24;
  clipStream      *= dummy + 25;
  clipStream2     *= dummy + 26;
  undoStream      *= dummy + 26;
  blinkRate       *= dummy + 27;
  inverted        *= dummy + 28;
  partial         *= dummy + 29;
  cursorPos       *= dummy + 30;

  readOnly        *= dummy + 31;     (* V2 *)
  modified        *= dummy + 32;
  acceptChars     *= dummy + 33;
  rejectChars     *= dummy + 34;
  passCommand     *= dummy + 35;
  lineLength      *= dummy + 36;
  maxSizeBeep     *= dummy + 37;
  deleteText      *= dummy + 38;
  selectSize      *= dummy + 39;
  copy            *= dummy + 40;
  copyAll         *= dummy + 41;
  cut             *= dummy + 42;
  paste           *= dummy + 43;
  erase           *= dummy + 44;
  undo            *= dummy + 45;

(* ----------------------- Border ----------------------------------------- *)

  borderNone          *= 0;
  borderBevel         *= 1;
  borderDoubleBevel   *= 2;

(* ----------------------- Alignment -------------------------------------- *)

  alignLeft           *= 0;
  alignCenter         *= 1;
  alignRight          *= 2;



(* --- Library Base variable -------------------------------------------- *)

TYPE GEClassBase * = E.Library;
     GEClassBasePtr * = CPOINTER TO GEClassBase;

VAR

  base *  : GEClassBasePtr;


(* --- Library Functions ------------------------------------------------ *)

  LIBCALL (base : GEClassBasePtr) GetObjectA *
          (class[8]   : E.APTR;
           classID[9] : ARRAY OF CHAR;
           tagList[10]: ARRAY OF U.TagItem) : E.APTR;       -30;

  LIBCALL (base : GEClassBasePtr) GetObject *
          (class[8]   : E.APTR;
           classID[9] : ARRAY OF CHAR;
           tagList[10].. : U.Tag) : E.APTR;       -30;

  LIBCALL (base : GEClassBasePtr) FreeObject *
          (object[8] : E.APTR);                 -36;


(* $L- Address globals through A4 *)

PROCEDURE* CloseLib (VAR rc : LONGINT);
BEGIN
  IF base # NIL THEN E.base.CloseLibrary (base) END;
END CloseLib;

PROCEDURE OpenLib * (mustOpen : BOOLEAN);
BEGIN
  IF base = NIL THEN
    base := E.base.OpenLibrary (Name, Version);
    IF base # NIL THEN K.SetCleanup(CloseLib)
    ELSIF mustOpen THEN HALT (100)
    END
  END
END OpenLib;


BEGIN (* GEClass *)
  base := NIL;
END GEClass.
