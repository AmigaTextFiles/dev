MODULE FontTest;

FROM DiskFontLibrary IMPORT AvailFont, AvailFontsHeader, AvailFontsHeaderPtr;
FROM FontTools       IMPORT GetAndSortAllFonts, ReturnFontResourcesToSystem,
                            FontBuffer;
FROM InOut           IMPORT WriteCard, WriteString, WriteLn;
FROM Storage         IMPORT DestroyHeap;
FROM Strings         IMPORT String;
FROM Text            IMPORT TextAttr;

TYPE
   StringPtr = POINTER TO String;

VAR
   FontName : StringPtr;


(* $T- disable range checking *)

   PROCEDURE TestFonts;
 
   VAR
      i : CARDINAL;
 
   BEGIN

      IF GetAndSortAllFonts() THEN

         WriteLn;
         FOR i := 0 TO FontBuffer^.afhNumEntries-1 DO
            WITH FontBuffer^.afhAvailFonts[i].afAttr DO
               FontName := taName;
               WriteCard(taYSize,4);   WriteString("    "); 
               WriteString(FontName^); WriteLn;
            END; (* WITH afhAvailFonts[i] *)
         END; (* FOR i *)
         WriteLn; 

         ReturnFontResourcesToSystem();

      ELSE
         WriteString("Couldn't get fonts..."); WriteLn;
      END; (* IF GetAndSortAllFiles *)

   END TestFonts;
 
(* $T+ enable range checking *)


BEGIN

   WriteLn; WriteString("Looking for fonts..."); WriteLn; WriteLn;
    
   TestFonts;

   DestroyHeap;

END FontTest.
