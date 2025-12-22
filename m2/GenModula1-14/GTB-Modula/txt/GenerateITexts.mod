IMPLEMENTATION MODULE GenerateITexts;

(*
 * -------------------------------------------------------------------------
 *
 *	:Program.	GenModula
 *	:Contents.	A Modula 2 Sourcecode generator for GadToolsBox
 *
 *	:Author.	Reiner B. Nix
 *	:Address.	Geranienhof 2, 50769 Köln Seeberg
 *	:Address.	rbnix@pool.informatik.rwth-aachen.de
 *	:Copyright.	Reiner B. Nix
 *	:Language.	Modula-2
 *	:Translator.	M2Amiga A-L V4.2d
 *	:Imports.	GadToolsBox, NoFrag  by Jaan van den Baard
 *	:Imports.	InOut, NewArgSupport by Reiner Nix
 *	:History.	this programm is a direct descendend from
 *	:History.	 OG (Oberon Generator) 37.11 by Thomas Igracki, Kai Bolay
 *	:History.	GenModula 1.10 (23.Aug.93)	;M2Amiga 4.0d
 *	:History.	GenModula 1.12 (28.Sep.93)	;M2Amiga 4.2d
 *	:History.	GenModula 1.14 (14.Jan.94)
 *
 * -------------------------------------------------------------------------
 *)

FROM	String			IMPORT	FirstPos,
					Copy, Concat;
FROM	Conversions		IMPORT	ValToStr;
FROM	FileMessage		IMPORT	StrPtr;
FROM	GraphicsD		IMPORT	jam1, jam2,
					DrawModes, DrawModeSet;
FROM	IntuitionD		IMPORT	IntuiTextPtr;
FROM	IntuitionL		IMPORT	IntuiTextLength;
FROM	FileOut			IMPORT	Write, WriteString, WriteLn,
					WriteCard, WriteInt;
FROM	GadToolsBox		IMPORT	maxFontName,
					GTConfigFlags,
					ProjectWindowPtr;
FROM	GeneratorIO		IMPORT	dfile, mfile, args,
					Gui, MainConfig, CConfig, Projects,
					WriteFill, SeekBack, WriteText;


PROCEDURE WriteITextsDefs	(    pw			:ProjectWindowPtr);


  PROCEDURE CountITexts		(    itext		:IntuiTextPtr) :CARDINAL;

  VAR	numTexts		:CARDINAL;

  BEGIN
  numTexts := 0;
  WHILE itext # NIL DO
    INC (numTexts);
    itext := itext^.nextText
    END;

  RETURN numTexts
  END CountITexts;


(* WriteITextDef *)
BEGIN
IF pw^.windowText # NIL THEN
  WriteString (mfile, "\t");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "IText");
  WriteFill   (mfile, pw^.name, 5);
  WriteString (mfile, ":ARRAY [1..");
  WriteCard   (mfile, CountITexts (pw^.windowText), 2);
  WriteString (mfile, "] OF IntuiText;");
  WriteLn (mfile);
  END
END WriteITextsDefs;



PROCEDURE WriteITextsProcs	(    pw			:ProjectWindowPtr);


  PROCEDURE WriteITextsInit	(    pw			:ProjectWindowPtr);

  VAR	text			:IntuiTextPtr;
  	numText,
  	bleft, btop		:CARDINAL;
  	error			:BOOLEAN;
  	i			:INTEGER;
  	AttrSize		:ARRAY [0..5] OF CHAR;
  	AttrName		:ARRAY [0..maxFontName] OF CHAR;



    PROCEDURE WriteDrawMode	(    mode		:DrawModeSet);

    BEGIN
    IF (jam2 * mode) # DrawModeSet {} THEN
      WriteString (mfile, "jam2")
    ELSE
      WriteString (mfile, "jam1")
      END;

    IF (complement IN mode) OR (inversvid IN mode) THEN
      WriteString (mfile, " + DrawModeSet {");
      IF complement IN mode THEN
        WriteString (mfile, "complement, ")
        END;
      IF inversvid IN mode THEN
        WriteString (mfile, "inversvid, ")
        END;
      SeekBack (mfile, 2);
      WriteString (mfile, "}")
      END
    END WriteDrawMode;



  (* WriteITextsInit *)
  BEGIN
  IF pw^.windowText # NIL THEN
    bleft := pw^.leftBorder;
    btop  := pw^.topBorder;

    Copy (AttrName, Gui.fontName);
    i := FirstPos (AttrName, 0, ".");
    IF i # -1 THEN
      AttrName[i] := 0C
      END;
    ValToStr (Gui.font.ySize, FALSE, AttrSize, 10, 1, " ", error);
    Concat (AttrName, AttrSize);


    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE Init");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "ITexts;");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "BEGIN");
    WriteLn (mfile);


    text := pw^.windowText;
    numText := 1;
    WHILE text # NIL DO
      WriteString (mfile, "WITH ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "IText[");
      WriteCard   (mfile, numText, 2);
      WriteString (mfile, "] DO");
      WriteLn (mfile);

      WriteString (mfile, "  frontPen  := ");
      WriteCard   (mfile, text^.frontPen, 2);
      Write       (mfile, ";");
      WriteLn (mfile);

      WriteString (mfile, "  backPen   := ");
      WriteCard   (mfile, text^.backPen, 2);
      Write       (mfile, ";");
      WriteLn (mfile);

      WriteString (mfile, "  drawMode  := ");
      WriteDrawMode (text^.drawMode);
      Write       (mfile, ";");
      WriteLn (mfile);

      WriteString (mfile, "  iText     := ADR ('");
      WriteText   (mfile, StrPtr (text^.iText)^);
      WriteString (mfile, "');");
      WriteLn (mfile);


      IF FontAdapt IN MainConfig.configFlags0 THEN
        WriteString (mfile, "  iTextFont := Font;");
        WriteLn (mfile);

        WriteString (mfile, "  leftEdge  := OffX + ComputeX (");
        WriteCard   (mfile, text^.leftEdge + (IntuiTextLength (text) DIV 2) - INTEGER (bleft), 3);
        WriteString (mfile, ") - (IntuiTextLength (ADR (");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "IText[");
        WriteCard   (mfile, numText, 2);
        WriteString (mfile, "])) DIV 2);");
        WriteLn (mfile);

        WriteString (mfile, "  topEdge   := OffY + ComputeY (");
        WriteCard   (mfile, text^.topEdge + INTEGER (Gui.font.ySize DIV 2) - INTEGER (btop), 3);
        WriteString (mfile, ") - INTEGER (Font^.ySize DIV 2);");
        WriteLn (mfile)

      ELSE
        WriteString (mfile, "  iTextFont := ADR (");
        WriteString (mfile, AttrName);
        WriteString (mfile, ");");
        WriteLn (mfile);

        WriteString (mfile, "  leftEdge  := ");
        WriteCard   (mfile, text^.leftEdge - INTEGER (bleft), 3);
        Write       (mfile, ";");
        WriteLn (mfile);

        WriteString (mfile, "  topEdge   := ");
        WriteCard   (mfile, text^.topEdge - INTEGER (btop), 3);
        Write       (mfile, ";");
        WriteLn (mfile)
        END;


      WriteString (mfile, "  nextText  := ");
      IF text^.nextText # NIL THEN
        WriteString (mfile, "ADR (");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "IText[");
        WriteCard   (mfile, numText + 1, 2);
        WriteString (mfile, "]);")
      ELSE
        WriteString (mfile, "NIL")
        END;
      WriteLn (mfile);

      WriteString (mfile, "  END;");
      WriteLn (mfile);


      text := text^.nextText;
      INC (numText)
      END;


    WriteString (mfile, "END Init");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "ITexts;");
    WriteLn (mfile);
    WriteLn (mfile)
    END
  END WriteITextsInit;


(* WriteITextsProcs *)
BEGIN
WriteITextsInit (pw)
END WriteITextsProcs;



PROCEDURE WriteITextsInits	(    pw			:ProjectWindowPtr);

BEGIN

(* ----------------------------------------------------------------------
 *
 * ACHTUNG: die Initialisierung von XXITexts muss bei jedem Öffnen des
 *  Fensters aufs neue erfolgen. Der Aufruf erfolgt daher in
 *  CreateXXWindow!
 *
 * ----------------------------------------------------------------------
 *)
END  WriteITextsInits;


END GenerateITexts.

