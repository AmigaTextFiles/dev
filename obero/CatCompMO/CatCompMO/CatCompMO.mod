(****** CatCompMO/--AMOK-Header-- *******************************************

:Program.    CatCompMO.mod
:Contents.   calalog compiler that generates M2Amiga and Amiga Oberon source
:Author.     Oliver Knorr
:Copyright.  Public Domain
:Language.   Oberon-2
:Translator. Amiga Oberon v3.11
:History.    v1.7 [olk] 24-Mar-94
:Support.    inspired by the original Commodore CatComp
:Imports.    MoreStrings [hG]
:Imports.    ioSet [olk]
:Remark.     needs Interfaces 40.15 or better to compile
:Version.    $VER: CatCompMO.mod 1.7 (24.3.94)

*****************************************************************************
*
*)

MODULE CatCompMO;

IMPORT

  BasicTypes, NoGuru, ASCII, STRING, Strings, Conversions, FileSystem, io,
  Dos, Exec,
  MoreStrings, ioSet;

TYPE

  Args = STRUCT (as: Dos.ArgsStruct)
           descriptor,
           module,
           catalog     : Dos.ArgString;
           oberon      : Dos.ArgBool;
         END;

  CatPtr = POINTER TO CatNode;
  CatNode = RECORD
              name,
              text  : STRING.STRING;
              id    : LONGINT;
              next  : CatPtr;
            END;


CONST

  template = "DESCRIPTOR/A,MODULE/A,CATALOG/A,OBERON/S\o$VER: CatCompMO 1.7 (24.3.94)";

  InitialLen = 20;
  noOccur = -1;
  first = 0;


VAR

  arguments      : Dos.RDArgsPtr;
  argv           : Args;
  descriptorStr,
  moduleStr,
  catalogStr     : BasicTypes.DynString;

  catalog   : CatPtr;

  number    : LONGINT; (* number of strings *)



PROCEDURE FileTest (f: FileSystem.File);
BEGIN
  IF (f.status # FileSystem.ok) & (f.status # FileSystem.eof) THEN
    io.WriteString ("*** ");
    io.WriteString (f.name);
    io.WriteString (": ");
    CASE f.status OF
       FileSystem.readerr   : io.WriteString ("read error")
     | FileSystem.writeerr  : io.WriteString ("write error")
     | FileSystem.onlyread  : io.WriteString ("file is read only")
     | FileSystem.onlywrite : io.WriteString ("file is write only")
     | FileSystem.toofar    : io.WriteString ("jumped too far")
     | FileSystem.outofmem  : io.WriteString ("out of memory")
     | FileSystem.cantopen  : io.WriteString ("can't open")
     | FileSystem.cantlock  : io.WriteString ("can't lock")
    ELSE
      io.WriteString ("file error")
    END;
    io.WriteLn;
    HALT (20)
  END;
END FileTest;


PROCEDURE OpenFail (name: ARRAY OF CHAR);
BEGIN
  io.WriteString ("*** ");
  io.WriteString (name);
  io.WriteString (": can't open");
  io.WriteLn;
  HALT (20)
END OpenFail;


PROCEDURE NoCaseOccurs (s, search: ARRAY OF CHAR): LONGINT;
BEGIN
  Strings.UpperIntl (s);
  Strings.UpperIntl (search);
  RETURN Strings.Occurs (s, search)
END NoCaseOccurs;


PROCEDURE Insert (a: STRING.STRING; s: ARRAY OF CHAR; i: LONGINT);
BEGIN
  a.Enlarge(a.Count()+Strings.Length(s));
  Strings.Insert(a.chars^, i, s)
END Insert;


(****** CatCompMO/StripExtension ********************************************
*
*   NAME
*       StripExtension -- remove an extension at the end of a string
*
*   SYNOPSIS
*       StripExtension (VAR s: ARRAY OF CHAR; ext: ARRAY OF CHAR)
*
*   FUNCTION
*       Removes the extension ext in the string s, if it occurs at
*       the very end of s (case insensitive).
*
*   INPUTS
*       s - string where the extension shall be removed (if present)
*       ext - extension that shall be removed from s
*
*   RESULT
*
*   EXAMPLE
*       s - shortened by the extension ext, if it was found at
*           the end of s; otherwise unchanged
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
*****************************************************************************
*
*)

PROCEDURE StripExtension (VAR s: ARRAY OF CHAR; ext: ARRAY OF CHAR);
  (* $CopyArrays- *)
VAR
  p, o: LONGINT;
BEGIN
  o := NoCaseOccurs (s, ext);
  IF o # noOccur THEN
    p := Strings.Length(s)-Strings.Length(ext);
    IF p = o THEN
      s[o] := ASCII.nul
    END
  END
END StripExtension;


(****** CatCompMO/ReadLine **************************************************
*
*   NAME
*       ReadLine -- read a (chained) line
*
*   SYNOPSIS
*       ReadLine (VAR f: FileSystem.File; VAR line: STRING.STRING)
*
*   FUNCTION
*       Read a line from the file f, that may be splitted into
*       several lines with backslash ("\") at the end as a chaining symbol.
*
*   INPUTS
*       f - open file to read from
*
*   RESULT
*       line - holds the complete line
*
*
*   EXAMPLE
*
*   NOTES
*       If the end of the file is reached, line[0] is ASCII.eof.
*
*   BUGS
*
*   SEE ALSO
*
*****************************************************************************
*
*)

PROCEDURE ReadLine (VAR f: FileSystem.File; VAR line: STRING.STRING);
VAR
  ch: CHAR;

BEGIN

  line := STRING.Create (InitialLen);

  LOOP                       (* chained lines *)

    LOOP                     (* charactes in one line of the chain *)

      IF FileSystem.ReadChar (f, ch) THEN

        line.Extend (ch);

        IF ch = ASCII.eol THEN
          EXIT
        END

      ELSE

        IF f.status = FileSystem.eof THEN
          line.Extend (ASCII.eof);
          EXIT
        ELSE
          FileTest (f)
        END

      END

    END;

    IF line.chars[0] = ASCII.eof THEN         (* reached end of file? *)
      RETURN
    END;

    line.Head (line.Count()-1);               (* delete eof / eol at the end of the line *)

    IF line.Empty() THEN                      (* empty line? *)
      RETURN
    END;

    IF line.chars[line.Count()-1] # "\\" THEN (* line is not chained? *)
      RETURN
    END;

    line.Head (line.Count()-1);               (* forget chaining symbo *)

  END;

END ReadLine;


(* read Catalog-Description file *)

PROCEDURE ReadCD (name: ARRAY OF CHAR;
                  VAR Catalog: CatPtr; VAR Number: LONGINT);

VAR

  f         : FileSystem.File;
  FileName,
  Line,
  nrstr     : STRING.STRING;
  CurrNode,
  PrevNode  : CatPtr;
  idstart,
  idend     : LONGINT;
  CurrID    : LONGINT;


BEGIN

  FileName := STRING.CreateString(name);

  IF ~FileSystem.Exists(FileName.chars^) THEN
    FileName.ExtendString (".cd")
  END;

  IF FileSystem.Open(f, FileName.chars^, FALSE) THEN

    LOOP

      ReadLine (f, Line);

      CASE Line.chars[0] OF

          ASCII.eof : EXIT
        | ";" :
        | "#" :

      ELSE

        NEW(CurrNode);
        INC(Number);

        idstart := Line.IndexOf ("(", 0);

        IF idstart >= 0 THEN

          idend   := Line.IndexOf ("/", idstart+1);

          IF idend > idstart + 1 THEN
            nrstr := Line.Substring (idstart+1, idend-1);
            CASE nrstr.chars[0] OF
                "$" : nrstr.Remove (0);
                      IF Conversions.StrToInt (nrstr.chars^, CurrNode^.id, 16) THEN END
              | "+" : nrstr.Remove (0);
                      CurrNode^.id := nrstr.ToInteger () + CurrID
            ELSE
              CurrNode^.id := nrstr.ToInteger ()
            END;
            CurrID := CurrNode^.id
          ELSE
            CurrNode^.id := CurrID
          END;

          CurrNode^.name := Line.Substring (0, idstart-1);

        ELSE

          CurrNode^.name := Line;
          CurrNode^.id := CurrID

        END;

        INC (CurrID);

        ReadLine (f, CurrNode^.text);

        IF (PrevNode # NIL) THEN
          PrevNode^.next := CurrNode;
          PrevNode := CurrNode
        ELSE
          Catalog := CurrNode;
          PrevNode := CurrNode
        END

      END

    END;

    IF FileSystem.Close (f) THEN
      RETURN
    END

  END;

  FileTest (f)

END ReadCD;


(* write source code for string names *)

PROCEDURE WriteNames (Catalog: CatPtr; Oberon: BOOLEAN);

BEGIN

  WHILE Catalog # NIL DO

    io.WriteString ("  ");
    io.WriteString (Catalog^.name.chars^);
    IF Oberon THEN
      io.WriteString (" *= ")
    ELSE
      io.WriteString (" = ")
    END;
    io.WriteInt (Catalog^.id, 1);
    io.WriteString (";\n");
    Catalog := Catalog^.next

  END;

END WriteNames;


(* write source code for string texts *)

PROCEDURE WriteText (Catalog: CatPtr; Oberon: BOOLEAN);

BEGIN

  IF Oberon THEN
    io.WriteString ("  appStrings = AppArray(\n")
  ELSE
    io.WriteString ("  appStrings := AppArray{\n")
  END;

  WHILE Catalog # NIL DO

    IF Oberon THEN
      io.WriteString ("                  ")
    ELSE
      io.WriteString ("                  AppString{id: ")
    END;

    io.WriteInt (Catalog^.id, 1);


    IF Oberon THEN
      io.WriteString (', s.ADR("')
    ELSE
      io.WriteString (', sp: ADR("')
    END;

    io.WriteString (Catalog^.text.chars^);


    IF Catalog^.text.chars[1] = ASCII.nul THEN
      io.WriteString ("\\o")
    END;

    IF Oberon THEN
      io.WriteString ('")')
    ELSE
      io.WriteString ('")}')
    END;

    Catalog := Catalog^.next;

    IF Catalog # NIL THEN
      io.WriteString (",\n");
    END

  END;

  IF Oberon THEN
    io.WriteString ("\n                );\n")
  ELSE
    io.WriteString ("\n                };\n")
  END

END WriteText;


(* generate Modula-2 .def and .mod files *)

PROCEDURE WriteModula (Catalog: CatPtr; Number: LONGINT;
                       Name, catName: ARRAY OF CHAR);

VAR

  in       : FileSystem.File;
  Line,
  FileName : STRING.STRING;

BEGIN

  StripExtension(catName, ".catalog");
  StripExtension(Name, ".def");
  StripExtension(Name, ".mod");
  FileName := STRING.CreateString (Name);
  FileName.ExtendString (".def");

  IF ioSet.SetOutput (FileName.chars^) THEN

    IF FileSystem.Open (in, "PROGDIR:ModulaCCMO.def", FALSE) THEN

      LOOP

        ReadLine (in, Line);

        IF Line.chars[0] = ASCII.eof THEN
          EXIT
        ELSIF Strings.Occurs (Line.chars^, "DEFINITION MODULE") # noOccur THEN
          Insert (Line, MoreStrings.CopyString(Dos.FilePart(Name)^)^, Strings.Occurs (Line.chars^, "ULE")+4);
          io.WriteString (Line.chars^);
          io.WriteLn
        ELSIF Strings.Occurs (Line.chars^, "CONST (* MODULE *)") # noOccur THEN
          io.WriteString (Line.chars^);
          io.WriteString ("\n\n  nrOfStrings = ");
          io.WriteInt (Number, 1);
          io.WriteString (";\n\n");
          WriteNames (Catalog, FALSE)
        ELSIF Strings.Occurs (Line.chars^, "END (* MODULE *)") # noOccur THEN
          Insert (Line, MoreStrings.CopyString(Dos.FilePart(Name)^)^, Strings.Occurs (Line.chars^, "*)")+3) ;
          io.WriteString (Line.chars^);
          io.WriteLn
        ELSE
          io.WriteString (Line.chars^);
          io.WriteLn
        END

      END;

      IF FileSystem.Close (in) THEN END;
      ioSet.CloseOutput

    END

  ELSE

    OpenFail(FileName.chars^)

  END;

  FileTest (in);

  FileName := STRING.CreateString (Name);
  FileName.ExtendString (".mod");

  IF ioSet.SetOutput (FileName.chars^) THEN

    IF FileSystem.Open (in, "PROGDIR:ModulaCCMO.mod", FALSE) THEN

      LOOP

        ReadLine (in, Line);

        IF Line.chars[0] = ASCII.eof THEN
          EXIT
        ELSIF Strings.Occurs (Line.chars^, "IMPLEMENTATION MODULE") # noOccur THEN
          Insert (Line, MoreStrings.CopyString(Dos.FilePart(Name)^)^, Strings.Occurs (Line.chars^, "MODULE")+7);
          io.WriteString (Line.chars^);
          io.WriteLn
        ELSIF Strings.Occurs (Line.chars^, "CONST (* MODULE *)") # noOccur THEN
          io.WriteString (Line.chars^);
          io.WriteString ('\n\n  catName = "');
          io.WriteString (catName);
          io.WriteString ('.catalog";\n')
        ELSIF Strings.Occurs (Line.chars^, "VAR (* MODULE *)") # noOccur THEN
          io.WriteString (Line.chars^);
          io.WriteString ("\n\n");
          WriteText (Catalog, FALSE)
        ELSIF Strings.Occurs (Line.chars^, "END (* MODULE *)") # noOccur THEN
          Insert (Line, MoreStrings.CopyString(Dos.FilePart(Name)^)^, Strings.Occurs (Line.chars^, "*)")+3);
          io.WriteString (Line.chars^);
          io.WriteLn
        ELSE
          io.WriteString (Line.chars^);
          io.WriteLn
        END

      END;

      IF FileSystem.Close (in) THEN END;
      ioSet.CloseOutput

    END

  ELSE

    OpenFail(FileName.chars^)

  END;

  FileTest (in);

END WriteModula;


(* generate Oberon module *)

PROCEDURE WriteOberon (Catalog: CatPtr; Number: LONGINT; Name, catName: ARRAY OF CHAR);

VAR

  in       : FileSystem.File;
  Line,
  FileName : STRING.STRING;

BEGIN

  StripExtension(catName, ".catalog");
  StripExtension(Name, ".mod");
  FileName := STRING.CreateString (Name);
  FileName.ExtendString (".mod");

  IF ioSet.SetOutput (FileName.chars^) THEN

    IF FileSystem.Open (in, "PROGDIR:OberonCCMO.mod", FALSE) THEN

      LOOP

        ReadLine (in, Line);

        IF Line.chars[0] = ASCII.eof THEN
          EXIT
        ELSIF Strings.Occurs (Line.chars^, "MODULE") = first THEN
          Insert (Line, MoreStrings.CopyString(Dos.FilePart(Name)^)^, Strings.Occurs (Line.chars^, "MODULE")+7);
          io.WriteString (Line.chars^);
          io.WriteLn
        ELSIF Strings.Occurs (Line.chars^, "CONST (* MODULE *)") # noOccur THEN
          io.WriteString (Line.chars^);
          io.WriteString ('\n\n  catName = "');
          io.WriteString (catName);
          io.WriteString ('.catalog";\n\n');
          io.WriteString ("  nrOfStrings = ");
          io.WriteInt (Number, 1);
          io.WriteString (";\n\n");
          WriteNames (Catalog, TRUE)
        ELSIF Strings.Occurs (Line.chars^, "CONST (* appStrings *)") # noOccur THEN
          io.WriteString (Line.chars^);
          io.WriteString ("\n\n");
          WriteText (Catalog, TRUE)
        ELSIF Strings.Occurs (Line.chars^, "END (* MODULE *)") # noOccur THEN
          Insert (Line, MoreStrings.CopyString(Dos.FilePart(Name)^)^, Strings.Occurs (Line.chars^, "*)")+3);
          io.WriteString (Line.chars^);
          io.WriteLn
        ELSE
          io.WriteString (Line.chars^);
          io.WriteLn
        END

      END;

      IF FileSystem.Close (in) THEN END;
      ioSet.CloseOutput

    END

  ELSE

    OpenFail(FileName.chars^)

  END;

  FileTest (in);

END WriteOberon;


BEGIN

  arguments := Dos.ReadArgs (template, argv, NIL);

  IF arguments = NIL THEN
    io.WriteString ("Wrong Arguments\n");
    HALT (5)
  END;

  ReadCD (MoreStrings.CopyString(argv.descriptor^)^, catalog, number);

  IF argv.oberon = Exec.LTRUE THEN
    WriteOberon (catalog, number, MoreStrings.CopyString(argv.module^)^,
                                  MoreStrings.CopyString(argv.catalog^)^)
  ELSE
    WriteModula (catalog, number, MoreStrings.CopyString(argv.module^)^,
                                  MoreStrings.CopyString(argv.catalog^)^)
  END


CLOSE

  IF arguments # NIL THEN Dos.FreeArgs(arguments) END


END CatCompMO.
