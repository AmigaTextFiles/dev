(*
(*  Amiga Oberon Interface Module:
**  $VER: Bullet.mod 40.15 (28.12.93) Oberon 3.0
**
**      (C) Copyright 1991-1992 Commodore-Amiga, Inc.
**          All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993 by hartmut Goebel
*)          All Rights Reserved
*)
MODULE Bullet;

IMPORT
  e  * := Exec,
  df * := DiskFont,
  u  * := Utility;

CONST
  bulletName * = "bullet.library";

VAR
  base * : e.LibraryPtr;

PROCEDURE OpenEngine     *{base,-01EH}(): df.GlyphEnginePtr;
PROCEDURE CloseEngine    *{base,-024H}(glyphEngine{8} : df.GlyphEnginePtr);
PROCEDURE SetInfoA       *{base,-02AH}(glyphEngine{8} : df.GlyphEnginePtr;
                                       tagList{9}     : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE SetInfo        *{base,-02AH}(glyphEngine{8} : df.GlyphEnginePtr;
                                       tag1{9}..      : u.Tag): BOOLEAN;
PROCEDURE ObtainInfoA    *{base,-030H}(glyphEngine{8} : df.GlyphEnginePtr;
                                       tagList{9}     : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE ObtainInfo     *{base,-030H}(glyphEngine{8} : df.GlyphEnginePtr;
                                       tag1{9}..      : u.Tag): BOOLEAN;
PROCEDURE ReleaseInfoA   *{base,-036H}(glyphEngine{8} : df.GlyphEnginePtr;
                                       tagList{8}     : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE ReleaseInfo    *{base,-036H}(glyphEngine{8} : df.GlyphEnginePtr;
                                       tag1{9}..      : u.Tag): BOOLEAN;

BEGIN
  base := e.OpenLibrary (bulletName, 38);
CLOSE
  IF base # NIL THEN e.CloseLibrary(base) END;

END Bullet.

