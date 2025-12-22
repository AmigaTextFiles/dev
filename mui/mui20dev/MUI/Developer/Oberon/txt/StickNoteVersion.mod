(*------------------------------------------
  :Program.     StickNote
  :Version.     V0.0
  :CharRev.     v!
  :InternalVer. 0.0
  :Date.        22-Aug-1993
  :Language.    Oberon-2
  :Translator.  Amiga Oberon 3.00d
--------------------------------------------*)

MODULE StickNoteVersion;

IMPORT SYSTEM;

CONST outVer   *= 0;
      outRev   *= 0;
      intVer   *= 0;
      intRev   *= 0;
      charRev  *= "\x20";
      date     *= "22-Aug-1993";
      name     *= "StickNote";
      nameVer  *= "StickNote V0.0";
      nameFull *= "StickNote V0.0 22-Aug-1993";
      ver      *= "$VER: StickNote 0.0 (22.08.93) by Albert Weinert";
BEGIN
 SYSTEM.SETREG(0,SYSTEM.ADR(ver))
END StickNoteVersion.

