MODULE StickNoteLocale;

(****************************************************************
   This file was created automatically by `KitCat V1.1ß'
   Do NOT edit by hand!
****************************************************************)

IMPORT
  lo := Locale, e := Exec, u := Utility, y := SYSTEM;

CONST
  builtinlanguage = "deutsch";
  version = 0;

  msgDescription* = 0;
  msgDescriptionSTR = "Ermöglicht Haftnotizen auf der Workbench";

  frameNotes* = 100;
  frameNotesSTR = "Notizen";

  gadTitle* = 200;
  gadTitleSTR = "_Titel";

  gadShow* = 201;
  gadShowSTR = "_Anzeigen";

  gadContent* = 202;
  gadContentSTR = "_Inhalt";

  gadFirst* = 203;
  gadFirstSTR = "_Erste";

  gadLast* = 204;
  gadLastSTR = "_Letze";

  gadOK* = 205;
  gadOKSTR = "_OK";

  gadNew* = 206;
  gadNewSTR = "_Neue";

  gadRemove* = 207;
  gadRemoveSTR = "Ent_fernen";

  gadShowNotes* = 208;
  gadShowNotesSTR = "_Zeigen ...";

  gadNext* = 209;
  gadNextSTR = "_>";

  gadPrev* = 210;
  gadPrevSTR = "_<";

  errCreateWindow* = 1000;
  errCreateWindowSTR = "Konnte Fenster nicht erstellen.\n";

  errCreateApplication* = 1001;
  errCreateApplicationSTR = "Konnte Application nicht erstellen.\n";

  numStrings * = 15;
  minId *      = 0;
  maxId *      = 1001;

TYPE
  AppString = STRUCT
     id  : LONGINT;
     str : e.STRPTR;
  END;
  AppStringArray = ARRAY numStrings OF AppString;

CONST
  AppStrings = AppStringArray (
    msgDescription, y.ADR (msgDescriptionSTR),
    frameNotes, y.ADR (frameNotesSTR),
    gadTitle, y.ADR (gadTitleSTR),
    gadShow, y.ADR (gadShowSTR),
    gadContent, y.ADR (gadContentSTR),
    gadFirst, y.ADR (gadFirstSTR),
    gadLast, y.ADR (gadLastSTR),
    gadOK, y.ADR (gadOKSTR),
    gadNew, y.ADR (gadNewSTR),
    gadRemove, y.ADR (gadRemoveSTR),
    gadShowNotes, y.ADR (gadShowNotesSTR),
    gadNext, y.ADR (gadNextSTR),
    gadPrev, y.ADR (gadPrevSTR),
    errCreateWindow, y.ADR (errCreateWindowSTR),
    errCreateApplication, y.ADR (errCreateApplicationSTR));

VAR
  catalog : lo.CatalogPtr;

  PROCEDURE CloseCatalog*();
    BEGIN
      IF catalog # NIL THEN lo.CloseCatalog (catalog); catalog:=NIL END;
   END CloseCatalog;

  PROCEDURE OpenCatalog*(loc:lo.LocalePtr; language:ARRAY OF CHAR);
    VAR Tag : u.Tags4;
    BEGIN
      CloseCatalog();
      IF (catalog = NIL) & (lo.base # NIL) THEN
        Tag:= u.Tags4(lo.builtInLanguage, y.ADR(builtinlanguage),
                      u.skip, u.done, lo.version, version, u.done, u.done);
        IF language # "" THEN
          Tag[1].tag:= lo.language; Tag[1].data:= y.ADR(language);
        END;
        catalog := lo.OpenCatalogA (loc, "StickNote.catalog", Tag);
      END;
    END OpenCatalog;

  PROCEDURE GetString* (num: LONGINT): e.STRPTR;
    VAR
      i: LONGINT;
      default: e.STRPTR;
    BEGIN
      i := 0; WHILE (i < numStrings) AND (AppStrings[i].id # num) DO INC (i) END;

      IF i # numStrings THEN
      default := AppStrings[i].str;
      ELSE
        default := NIL;
      END;

      IF catalog # NIL THEN
        RETURN lo.GetCatalogStr (catalog, num, default^);
      ELSE
        RETURN default;
      END;
    END GetString;

CLOSE
  CloseCatalog();
END StickNoteLocale.
