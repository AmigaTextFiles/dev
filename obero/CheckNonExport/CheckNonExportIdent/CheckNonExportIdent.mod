(*(***********************************************************************

:Program.    CheckNonExportIdent.mod
:Contents.   prints out all level 0 idents which are not exported
:Author.     hartmtut Goebel [hG]
:Address.    Aufseßplatz 5, D-90459 Nürnberg
:Address.    UseNet: hartmut@oberon.nbg.sub.org
:Address.    Z-Netz: hartmut@asn.zer   Fido: 2:246/81.1
:Copyright.  Copyright © 1993 by hartmtut Goebel
:Language.   Oberon-2
:Translator. Amiga Oberon 3.0
:Version.    $VER: CheckNonExportIdent.mod 1.4 (22.12.93) Copyright © 1993 by hartmtut Goebel

(* $StackChk- $NilChk- $RangeChk- $CaseChk- $OvflChk- $ReturnChk- $ClearVars- *)
(****i* CheckNonExportIdent/--history-- ***************************************
*
*   1.4  changed module hierarchie: Parser is now own module again, nearly
*        all changes for ChechNonExportIdent are now in the main module
*   1.3  exeption file (se dokumentaion)
*   1.2  supports filname pattern, no more need of module Messages
*   1.1  initial release
*
*********************************************************************)*)*)

MODULE CheckNonExportIdent;

(****i* CheckNonExportIdent/--Inhalt.Amok-- ***********************
*
*[33mCheckNonExportIdent [3m(Oberon)[m                             [32mhartmut Goebel[31m
*
*  Ein kleines Tool, daß in einem Oberon-2-Programm alle nicht
*  exportierten Identifierer sucht und anzeigt. Module können jetzt
*  als File-Pattern angegeben werden und ein Ausnahmen-File kann
*  verhindern, daß bestimmte Bezeichner angezeigt werden.
*  Version 1.4, ein Update gegenüber V1.0 auf Amok# 98.
*
*********)
(****i* CheckNonExportIdent/--Contents.fnf-- ***********************
*
*CheckNonExportIdent  Small tool to find all identifierd in an
*                     Oberon-2 program that are not exported. Module
*                     names can be passed as file-pattern, an
*                     exeptions-file may disclose idents to be shown.
*                     Version 1.4, includes Source in Oberon.
*                     Author: hartmut Goebel
*
*********)

(****** CheckNonExportIdent/--dokumentation-- ***********************
*
*                      CheckNonExportIdent
*                      ===================
*
*    Usage:
*      CheckNonExportIdent PATTERN/A,EXEPTFILE
*
*    This program checks a Oberon modules for not exported
*    identifiers. If at least one such identifier is found, the
*    module name is printed out and all found identifers. In this
*    case the programm will return error code 5 (WARN) on exit.
*    Return code 0 (OKAY) means all identifiers are exported.
*
*    When specifying a pattern instead of an unique filename,
*    CheckNonExportIdent checks all modules matching the pattern. If
*    at least one ident has not been exported in any of the modules,
*    the programm will return error code 5 (WARN) on exit.
*
*    You can also pass a file containing a list of identifiers to be
*    ignored for the check. See example below.
*
*    Only identifiers on level 0 (this is not nested within a
*    procedure) are testet. Record or struct fields will be displayed
*    in the form <record>.<fieldname>.
*
*    This module is very usefull for checking wether all idents e.g.
*    in an interface module are really exported.
*
*    Exeptions file:
*      For every module with identifiers to be ingnored, create a
*      list like that:
*
*         MODULE io
*         IMPORT: foobar
*         IMPORT: blafasel
*         Semaphore.tag
*         data
*
*      First line hold the keyword 'MODULE' followed by the module
*      name. The following lines contain the identifiers to be
*      ignored, each in a seperate line. Identifiers defined in the
*      IMPORT part of the module are prefixed with 'IMPORT: '.
*      So the file looks nearly like the output of
*      CheckNonExportIdent, exept the 'MODULE' line.
*
*      The exeptions file may contain any number of thus lists.
*
*    Note:
*      The identifiers to be ignored are tested by simple string
*      match, so you must not use spaces within the qualified ident.
*      Empty lines are ignored.
*
*      Due to a restriction in one of the used modules, only the
*      first 80 charakters of each qualified ident is used for
*      testing.
*
*    Enjoy it!
*    +++hartmut
*
*********)

IMPORT
  arg := Arguments,
  ms := MoreStrings, io,
  str := Strings,
  e := Exec,
  d := Dos,
  Parser := CNEIdentParser,
  avl := AVLTrees,
  fs := FileSystem;

CONST
  versionString = "$VER: CheckNonEportIdent 1.4 (22.12.93) Copyright © 1993 by hartmtut Goebel";

TYPE
  ModuleNode = POINTER TO ModuleNodeDesc;
  ModuleNodeDesc = RECORD (avl.SNodeDesc)
    idents: avl.SRoot;
  END;

VAR
  moduleTree: avl.SRoot;


PROCEDURE isExeption * (module, ident: avl.String): BOOLEAN; (* $CopyArrays- *)
VAR
  moduleNode: avl.Node;
BEGIN
  moduleNode := moduleTree.SFind(module);
  RETURN (moduleNode # NIL) & (moduleNode(ModuleNode).idents.SFind(ident) # NIL);
END isExeption;


PROCEDURE ReadExeptionsFile * (filename: ARRAY OF CHAR): BOOLEAN; (* $CopyArrays- *)
CONST
  mODULE = "MODULE ";
  moduleLen = 7;
VAR
  node: avl.SNode;
  idents: avl.SRoot;
  moduleNode: ModuleNode;
  file: fs.File;
  result: BOOLEAN;
BEGIN
  IF ~ fs.Open(file,filename,FALSE) THEN
    RETURN FALSE; END;
  WHILE file.status = fs.ok DO
    IF fs.ReadLongString(file) THEN
      IF ms.StripSpaces(file.string^) = 0 THEN END;
      IF ms.StrCmpN(mODULE,file.string^,moduleLen) = 0 THEN
        str.Delete(file.string^,0,moduleLen);
        str.Delete(file.string^,0,ms.FirstNoSpace(file.string^));
        NEW(moduleNode);
        COPY(file.string^,moduleNode.name);
        moduleTree.Add(moduleNode);

        idents := avl.SCreate();
        IF (idents = NIL) THEN HALT(20); END;
        moduleNode.idents := idents;
      ELSIF file.string^ # "" THEN
        IF idents = NIL THEN HALT(30); END;
        NEW(node);
        COPY(file.string^,node.name);
        idents.Add(node);
      END;
    END;
  END;
  result := file.status = fs.eof;
  IF fs.Close(file) THEN END;
  RETURN result;
END ReadExeptionsFile;

VAR
  foundIdent, modulenameWritten: BOOLEAN;
  filename: e.STRING;
  file: fs.File;

PROCEDURE ReadOneChar();
BEGIN
  IF ~fs.ReadChar(file,Parser.Char) THEN Parser.Char := CHR(0); END;
END ReadOneChar;

PROCEDURE ErrorOut();
BEGIN
  IF ~ modulenameWritten THEN
    modulenameWritten := TRUE;
    io.WriteString(filename);
  END;
  io.WriteString("  ***SyntaxError***"); io.WriteLn; HALT(10);
END ErrorOut;

PROCEDURE AppendPreIdent;
VAR
BEGIN
  str.Append(Parser.PreIdent,Parser.Identifier);
  str.AppendChar(Parser.PreIdent,".");
END AppendPreIdent;

PROCEDURE ShortenPreIdent();
VAR
  pos: LONGINT;
BEGIN
  pos := ms.OccursCharPos(Parser.PreIdent,".",-(str.Length(Parser.PreIdent)-2));
  IF pos >= 0 THEN
    Parser.PreIdent[pos+1] := CHR(0);
  ELSE
    Parser.PreIdent := "";
  END;
END ShortenPreIdent;


PROCEDURE WriteNotExportedIdent();
VAR
  ident: avl.String;
BEGIN
  ident := Parser.PreIdent; str.Append(ident,Parser.Identifier);
  IF (Parser.procLevel = 0) & ~ (isExeption(Parser.moduleName,ident)) THEN
    IF ~ modulenameWritten THEN
      modulenameWritten := TRUE;
      io.WriteString(filename); io.WriteLn;
    END;
    io.WriteString("  "); io.WriteString(Parser.PreIdent);
    io.WriteString(Parser.Identifier); io.WriteLn;
    foundIdent := TRUE;
  END;
END WriteNotExportedIdent;


PROCEDURE DoCheck();
VAR
  result: LONGINT;
  anchor: d.AnchorPathPtr;
  pattern: e.STRING;
BEGIN
  NEW(anchor);
  anchor.strLen := (SIZE(anchor.buf));
  anchor.breakBits := LONGSET{d.ctrlC};
  pattern := versionString;
  IF arg.NumArgs() = 2 THEN
    arg.GetArg(2,pattern);
    IF ~ ReadExeptionsFile(pattern) THEN
      HALT(20); END;
  END;
  arg.GetArg(1,pattern);
  result  := d.MatchFirst(pattern,anchor^);
  WHILE result = 0 DO
    modulenameWritten := FALSE;
    filename := anchor.buf;
    IF fs.Open(file,filename,FALSE) THEN
      Parser.Parse(ReadOneChar,ErrorOut);
      IF fs.Close(file) THEN END;
    ELSE
      io.WriteString("***Error opening file "); io.WriteString(filename); io.WriteLn;
    END;
    result := d.MatchNext(anchor^);
  END;
  d.MatchEnd(anchor^);
  IF foundIdent THEN HALT(5); END;
END DoCheck;


BEGIN
  Parser.AppendPreIdent := AppendPreIdent;
  Parser.ShortenPreIdent := ShortenPreIdent;
  Parser.WriteNotExportedIdent := WriteNotExportedIdent;
  moduleTree := avl.SCreate();
  IF moduleTree = NIL THEN HALT(20); END;
  DoCheck();
END CheckNonExportIdent.

