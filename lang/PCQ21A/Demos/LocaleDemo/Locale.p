Program LocaleDemo;

{ 1994 by Andreas Tetzl }
{ Public Domain }
{ Für OS2.1+ }
{ Zum Übersetzen werden die OS3.1 Includes 
  von der Purity benötigt ! }


{$I "Include:Libraries/Locale.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Utils/StringLib.i"}

CONST DefStrings : Array[0..2] of String = (
                    "LocaleDemo V1.0 1994 by Andreas Tetzl",
                    "This program demonstrates the use of the locale.library.",
                    "This is the default text.");

VAR Loc : LocalePtr;
    Cat : CatalogPtr;
    StrNum : Integer;
    Str : String;

Procedure CleanExit(Why : String; RC : Integer);
Begin
 If cat<>NIL then CloseCatalog(cat);
 If loc<>NIL then CloseLocale(loc);
 If LocaleBase<>NIL then CloseLibrary(LocaleBase);
 If Why<>NIL then Writeln(Why);
 Exit(RC);
end;

Begin
 { Als erstes die locale.library öffnen. }
 LocaleBase := OpenLibrary("locale.library", 38);
 If LocaleBase=NIL then CleanExit("Benötige OS2.1+",10);

 { Zugriff auf die voreingestellte Sprache. }
 { Sollte für dieses Programm Deutsch sein. }
 loc := OpenLocale(NIL);
 If loc=NIL then CleanExit("Keinen Zugriff auf voreingestellte Sprache",10);
 
 cat := OpenCatalogA(loc, "example.catalog", NIL);

 For StrNum:=0 to 2 do
  Begin
   Str := DefStrings[StrNum];
   If cat<>NIL then Str := GetCatalogStr(cat, StrNum, "Catalog fehlerhaft.");
   Writeln(Str);
  end;

 CleanExit(NIL,0);
end.



