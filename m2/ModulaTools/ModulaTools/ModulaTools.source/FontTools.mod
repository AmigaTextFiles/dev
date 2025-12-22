(******************************************************************************)
(*                                                                            *)
(*  Version 1.00a.002 (Beta) :   March 2, 1988                                *)
(*                                                                            *)
(*    These procedures were originally written under version 1.20 of the TDI  *)
(* Modula-2 compiler. I have rewritten this module to operate under the v2.00 *)
(* compiler. However, should you find any problem or inconsistency with the   *)
(* functionality of this code, please contact me at the following address:    *)
(*                                                                            *)
(*                               Jerry Mack                                   *)
(*                               23 Prospect Hill Ave.                        *)
(*                               Waltham, MA   02154                          *)
(*                                                                            *)
(*    Check the module MenuUtils for TDI's (considerably less powerful) ver-  *)
(* sions of my Menu and IntuitionText procedures. The modules GadgetUtils and *)
(* EasyGadgets should also be of great help.                                  *)
(*                                                                            *)
(******************************************************************************)
(*                                                                            *)
(*    The source code to FontTools is in the public domain. You may do with   *)
(* it as you please.                                                          *)
(*                                                                            *)
(******************************************************************************)

IMPLEMENTATION MODULE FontTools;

FROM DiskFontLibrary IMPORT AvailFont, AvailFonts, AFDisk, AFMemory,
                            AvailFontsHeader, AvailFontsHeaderPtr,
                            DiskFontName, DiskFontBase, OpenDiskFont;
FROM Libraries       IMPORT LibraryPtr, OpenLibrary, CloseLibrary;
FROM Storage         IMPORT ALLOCATE, DEALLOCATE;
FROM Strings         IMPORT String, Compare, Equal, Greater, InitStringModule;
FROM SYSTEM          IMPORT ADDRESS, NULL;
FROM Text            IMPORT TextAttr, CloseFont, RemFont;

TYPE
   StringPtr = POINTER TO String;
 
VAR
   FontName          : StringPtr;
   OpenedDiskFontLib : BOOLEAN;
   FontBufferSize    : LONGCARD;   (* amount of memory to store Font info    *)
   ExtraMemory       : LONGCARD;   (* additional memory needed for Font info *)
   TotalFonts        : CARDINAL;

 
   (* $T- disable range checking: compiler thinks afhAvailFonts has 1 element *)

   PROCEDURE SortFontsByName;

   VAR
      i,j      : CARDINAL;
      tempFont : AvailFont;
      IName    : StringPtr;
      JName    : StringPtr;

   BEGIN
      WITH FontBuffer^ DO

         FOR i := afhNumEntries-1 TO 1 BY -1 DO
            IName := afhAvailFonts[i].afAttr.taName;

            FOR j := 0 TO i-1 DO
               JName := afhAvailFonts[j].afAttr.taName;

               IF (Compare(JName^, IName^) = Greater) THEN
                  tempFont         := afhAvailFonts[i];
                  afhAvailFonts[i] := afhAvailFonts[j];
                  afhAvailFonts[j] := tempFont;
                  IName := afhAvailFonts[i].afAttr.taName;
                  JName := afhAvailFonts[j].afAttr.taName;
               END; (* IF Compare *)

            END; (* FOR j *)

         END; (* FOR i *)

      END; (* WITH FontBuffer^ *)
   END SortFontsByName;
 
 
 
   PROCEDURE SortFontsByPointSize;

   VAR
      TotalFonts   : CARDINAL;
      CurrentFont  : CARDINAL;
      FirstFont    : CARDINAL;
      CurrentName  : StringPtr;
      FirstName    : StringPtr;
 

      PROCEDURE RearrangePointSizes;

      VAR
         tempFont     : AvailFont;
         i,j          : CARDINAL;
         ISize, JSize : CARDINAL;
 
      BEGIN
         WITH FontBuffer^ DO

            FOR i := CurrentFont-1 TO FirstFont+1 BY -1 DO
               ISize := afhAvailFonts[i].afAttr.taYSize;
 
               FOR j := FirstFont TO i-1 DO
                  JSize := afhAvailFonts[j].afAttr.taYSize;
 
                  IF (JSize > ISize) THEN
                     tempFont         := afhAvailFonts[i];
                     afhAvailFonts[i] := afhAvailFonts[j];
                     afhAvailFonts[j] := tempFont;
                     ISize := afhAvailFonts[i].afAttr.taYSize;
                     JSize := afhAvailFonts[j].afAttr.taYSize;
                  END; (* IF JSize *)

               END; (* FOR j *)

            END; (* FOR i *)

         END; (* WITH FontBuffer^ *)
      END RearrangePointSizes;
 
 
   BEGIN
      WITH FontBuffer^ DO

         TotalFonts  := afhNumEntries-1;
         CurrentFont := 1;
         FirstFont   := 0;
         FirstName   := afhAvailFonts[FirstFont].afAttr.taName;

         WHILE CurrentFont <= TotalFonts DO
            CurrentName := afhAvailFonts[CurrentFont].afAttr.taName;

            IF (Compare(FirstName^, CurrentName^) <> Equal) THEN

               RearrangePointSizes;

               FirstFont := CurrentFont;
               FirstName := afhAvailFonts[FirstFont].afAttr.taName;

            END; (* IF Compare *)
            INC(CurrentFont);

         END; (* WHILE FontsLeft *)

         RearrangePointSizes;

      END; (* WHILE FontBuffer^ *)
   END SortFontsByPointSize;
  

(******************************************************************************)
(*                                                                            *)
(*   This procedure finds all of the fonts in the FONTS: directory and sorts  *)
(* them by both name and point-size. Upon exit, FontBuffer will contain a     *)
(* sorted array of TextAttr structures describing the fonts. These are the    *)
(* structures used by the OpenDiskFont procedure and are also used to change  *)
(* the current system font for writing Menus, IntuitionText, etc.             *)
(*                                                                            *)
(******************************************************************************)
 
   PROCEDURE GetAndSortAllFonts () : BOOLEAN;

   BEGIN

      DiskFontBase     := OpenLibrary (DiskFontName, 33);
      UserDiskFontBase := DiskFontBase;        (* give user access to library *)

      IF (DiskFontBase <> NULL) THEN

         OpenedDiskFontLib := TRUE;

         ALLOCATE(FontBuffer, FontBufferSize);
 
         ExtraMemory := AvailFonts(FontBuffer,FontBufferSize,{AFDisk,AFMemory});

         IF (ExtraMemory > 0) THEN
            INC(FontBufferSize, ExtraMemory);
            ExtraMemory := AvailFonts(FontBuffer, FontBufferSize,
                                                 {AFDisk,AFMemory});
         END; (* IF ExtraMemory *)
 
         SortFontsByName;
         SortFontsByPointSize;

      ELSE
         OpenedDiskFontLib := FALSE;
      END; (* IF DiskFontBase *)

      RETURN OpenedDiskFontLib;

   END GetAndSortAllFonts;
 

(******************************************************************************)
(*                                                                            *)
(*   This procedure deallocates the memory used by FontBuffer and closes the  *)
(* DiskFont.library opened in GetAndSortAllFonts.                             *)
(*                                                                            *)
(******************************************************************************)
 
   PROCEDURE ReturnFontResourcesToSystem;
   
   BEGIN
      IF (OpenedDiskFontLib) THEN

         DEALLOCATE(FontBuffer, FontBufferSize);
         CloseLibrary (DiskFontBase);

         UserDiskFontBase  := NULL;
         OpenedDiskFontLib := FALSE;

      END; (* IF OpenedDiskFontLib *)
   END ReturnFontResourcesToSystem;


(******************************************************************************)
(*                                                                            *)
(*   This procedure opens all the fonts in the FONTS: directory, adding them  *)
(* to the system font-list. The fonts are opened in the order in which they   *)
(* are stored in the FontBuffer. The procedure returns the number of fonts    *)
(* which were successfully opened.                                            *)
(*                                                                            *)
(******************************************************************************)
 
   PROCEDURE OpenAllFonts () : CARDINAL;
   
   VAR
      tempFont : FontListNodePtr;
      thisFont : FontListNodePtr;
      i        : CARDINAL;
 
   BEGIN

      IF (GetAndSortAllFonts()) THEN
  
         FOR i := 0 TO FontBuffer^.afhNumEntries-1 DO
 
            NEW(tempFont);
 
            IF (tempFont = NIL) THEN          (* memory-availability problem; *)
               RETURN i;                      (* not i+1, since font is not   *)
            END;                              (* opened yet...                *)
 
            IF (i = 0) THEN
               thisFont := tempFont;
               FontList := thisFont;
            ELSE
               thisFont^.next := tempFont;
               thisFont       := tempFont;
            END; (* IF i *) 

            thisFont^.node := OpenDiskFont(FontBuffer^.afhAvailFonts[i].afAttr);
            thisFont^.next := NIL;
 
         END; (* FOR i *)
 
         RETURN FontBuffer^.afhNumEntries;      (* stored all available fonts *)

       ELSE
         RETURN 0;
      END; (* IF GetAndSortAllFonts *)
   END OpenAllFonts;
 

(******************************************************************************)
(*                                                                            *)
(* This procedure closes all of the fonts in the the global variable FontList.*)
(* If no other process is accessing them, the fonts will be removed from the  *)
(* system-font list. However, if another process is using any of the fonts in *)
(* FontList, then RemFont will return a non-zero value and the font(s) will   *)
(* remain in the system font-list.                                            *)
(*                                                                            *)
(******************************************************************************)
 
(******************************************************************************)
(*                                                                            *)
(*   NOTE: There is a bug with this procedure that causes a machine crash. I  *)
(* did not have time to correct this error, as I sold my Modula-2 compiler.   *)
(* I think the problem has to do with referencing an uninitialized pointer,   *)
(* but that is only a guess. If my guess is correct, then the correction will *)
(* will have to be made in the procedure OpenAllFonts above.                  *)
(*   I apologize for not fixing this error, but Icouldn't afford to spend any *)
(* more time on these tools.                                                  *)
(*                                                                            *)
(******************************************************************************)
 
   PROCEDURE CloseAllFonts;

   VAR
      currentFont : FontListNodePtr;
      nextFont    : FontListNodePtr;
      success     : LONGINT;
 
   BEGIN
      currentFont := FontList;                  (* get root node (first font) *)
 
      WHILE (currentFont <> NIL) DO
 
         CloseFont (currentFont^.node^);
         success := RemFont (currentFont^.node^);
 
         nextFont := currentFont^.next;
         DISPOSE(currentFont);
         currentFont := nextFont;
 
      END; (* WHILE currentFont *)
      ReturnFontResourcesToSystem;              (* empty FontBuffer and close *)
                                                (* DiskFont.lib               *)
      FontList := NIL;
 
   END CloseAllFonts;


(* $T+  enable range checking *)
 
 
BEGIN

   InitStringModule;

   FontBufferSize    := LONGCARD(2048);
   OpenedDiskFontLib := FALSE;
   UserDiskFontBase  := NULL;
   ExtraMemory       := 0;
   FontBuffer        := NULL;
   FontList          := NIL;
 
END FontTools.
