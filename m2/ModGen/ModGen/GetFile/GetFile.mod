(*---------------------------------------------------------------------------
  :Program.    GetFile.mod
  :Contents.   Interface to the GetFile boopsi image by Jan van den Baard
  :Author.     Frank Lömker
  :Copyright.  FreeWare
  :Language.   Modula-2
  :Translator. Turbo Modula-2 V1.40
  :History.    1.0 [Frank] 17-Apr-95
  :Bugs.       no known
---------------------------------------------------------------------------*)
IMPLEMENTATION MODULE GetFile;

FROM Classes IMPORT FreeClass;
FROM GetFile IMPORT InitGet;

BEGIN
  GetFileClass := InitGet ();
CLOSE
  IF GetFileClass # NIL THEN
    FreeClass (GetFileClass);
    GetFileClass := NIL;
  END;
END GetFile.
