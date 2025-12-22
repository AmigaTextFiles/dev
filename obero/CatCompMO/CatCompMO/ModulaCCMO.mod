IMPLEMENTATION MODULE ;  (* OLK / 24.03.94 *)

IMPORT LocaleD, OptLocaleL, UtilityD;
FROM SYSTEM IMPORT ADR, TAG;

TYPE (* MODULE *)

  AppString = RECORD
                id : LONGINT;
                sp : StrPtr;
              END;

  AppArray  = ARRAY [1..nrOfStrings] OF AppString;


CONST (* MODULE *)


VAR (* MODULE *)

  i          : CARDINAL;
  tagBuffer  : ARRAY [0..8] OF LONGINT;
  currCat    : LocaleD.CatalogPtr;


PROCEDURE GetString (ID: LONGINT): StrPtr;
BEGIN
  FOR i := 1 TO nrOfStrings DO
    WITH appStrings[i] DO
      IF id = ID THEN
        IF currCat # NIL THEN
          RETURN OptLocaleL.GetCatalogStr (currCat, id, sp)
        ELSE
          RETURN sp
        END
      END
    END
  END;
  RETURN NIL
END GetString;


BEGIN (* MODULE *)

  IF OptLocaleL.localeBase # NIL THEN
    currCat := OptLocaleL.OpenCatalogA (NIL, ADR(catName), TAG(tagBuffer, UtilityD.tagEnd))
  END


CLOSE (* MODULE *)

  IF currCat # NIL THEN
    OptLocaleL.CloseCatalog (currCat);
    currCat := NIL
  END


END (* MODULE *) .
