MODULE ;  (* OLK / 24.03.94 *)

IMPORT

  Locales,
  Exec,
  Locale,
  Utility,
  s := SYSTEM;


CONST (* MODULE *)


TYPE (* MODULE *)

  AppString = RECORD
                id : LONGINT;
                sp : Exec.LSTRPTR;
              END;

  AppArray  = ARRAY nrOfStrings OF AppString;

  CatCompLocale * = POINTER TO CatCompLocaleDesc;
  CatCompLocaleDesc * = RECORD (Locales.LocaleDesc) END;


CONST (* appStrings *)


VAR (* MODULE *)

  i          : INTEGER;
  currCat    : Locale.CatalogPtr;
  localeObj *: CatCompLocale;


PROCEDURE GetString * (id: LONGINT): Exec.LSTRPTR;
BEGIN
  FOR i := 0 TO (nrOfStrings - 1) DO
    IF appStrings[i].id = id THEN
      IF currCat # NIL THEN
        RETURN Locale.GetCatalogStr (currCat, appStrings[i].id, appStrings[i].sp^)
      ELSE
        RETURN appStrings[i].sp
      END
    END
  END;
  RETURN NIL
END GetString;

PROCEDURE (l: CatCompLocale) GetString * (id: LONGINT): Exec.LSTRPTR;
BEGIN
  RETURN GetString(id)
END GetString;


BEGIN (* MODULE *)

  NEW(localeObj);

  IF Locale.base # NIL THEN
    currCat := Locale.OpenCatalog (NIL, catName, Utility.end, 0)
  END


CLOSE (* MODULE *)

  IF currCat # NIL THEN
    Locale.CloseCatalog (currCat);
    currCat := NIL
  END


END (* MODULE *) .
