(* ------------------------------------------------------------------------
  :Program.       GetFile
  :Contents.      interface to JaBa's GetFile-BOOPSI-Object
  :Author.        Kai Bolay [kai]
  :Address.       Snail Mail:              EMail:
  :Address.       Hoffmannstraﬂe 168       UUCP: kai@amokle.stgt.sub.org
  :Address.       D-71229 Leonberg         FIDO: 2:2407/106.3
  :History.       v1.0 [kai] 09-Apr-93 (started written history)
  :Copyright.     © 1993 by Kai Bolay and Jaba Development
  :Language.      Oberon
  :Translator.    AMIGA OBERON v3.01d
------------------------------------------------------------------------ *)
(* $JOIN boopsi.o $JOIN bases.o *)
MODULE GetFile;

IMPORT
  Intuition, Graphics, Utility, GadTools, Exec;

PROCEDURE InitGet {"initGet"} (): Intuition.IClassPtr;

VAR
  IntuitionBase ["_IntuitionBase"], GfxBase ["_GfxBase"],
  UtilityBase ["_UtilityBase"], GadToolsBase ["_GadToolsBase"]: Exec.LibraryPtr;

  GetFileClass*: Intuition.IClassPtr;

BEGIN
  IntuitionBase := Intuition.base;
  GfxBase       := Graphics.base;
  UtilityBase   := Utility.base;
  GadToolsBase  := GadTools.base;

  GetFileClass := InitGet ();
CLOSE
  IF GetFileClass # NIL THEN
    IF Intuition.FreeClass (GetFileClass) THEN END;
    GetFileClass := NIL;
  END;
END GetFile.
