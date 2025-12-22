IMPLEMENTATION MODULE GenerateScreen;

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

FROM	SYSTEM			IMPORT	LONGSET,
					CAST;
FROM	String			IMPORT	Length;
FROM	GraphicsD		IMPORT	palMonitorID, ntscMonitorID,
					superlaceKey, hireslaceKey, loreslaceKey,
					superKey, hiresKey,
					FontStyles, FontStyleSet,
					FontFlags, FontFlagSet;
FROM	IntuitionD		IMPORT	SaTags;
FROM	GadToolsD		IMPORT	GtTags;
FROM	UtilityD		IMPORT	Tag,
					tagEnd,
					TagItem, TagItemPtr;
FROM	FileOut			IMPORT	Write, WriteString, WriteLn,
					WriteCard, WriteInt, WriteHex;
FROM	GadToolsBox		IMPORT	maxColorSpec, maxDriPens, maxFontName,
					GadgetFlags, GadgetFlagSet,
					GuiFlags, GuiFlagSet,
					GenCFlags,
					GTConfigFlags;
FROM	GeneratorIO		IMPORT	dfile, mfile, args,
					Gui, MainConfig, CConfig, Projects,
					WriteText, WriteFill, SeekBack, GetAttrName;



PROCEDURE CheckFont		() :BOOLEAN;

BEGIN
IF FontAdapt IN MainConfig.configFlags0 THEN
  RETURN FALSE

ELSE
  RETURN (gcGenOpenFont IN CConfig) AND
         (romFont IN Gui.font.flags)
  END
END CheckFont;



PROCEDURE WriteScreenDefs;

VAR	colorNumber, penNumber	:CARDINAL;
	attrName		:ARRAY [0..maxFontName] OF CHAR;

BEGIN
WriteString (mfile, "\t");
WriteString (mfile, "Screen");
WriteFill   (mfile, "", 6);
WriteString (mfile, ":ScreenPtr;");
WriteLn (mfile);

WriteString (mfile, "\t");
WriteString (mfile, "VisualInfo");
WriteFill   (mfile, "", 10);
WriteString (mfile, ":ADDRESS;");
WriteLn (mfile);

IF CheckFont () THEN
  WriteString (mfile, "\t");
  WriteString (mfile, "Font");
  WriteFill   (mfile, "", 4);
  WriteString (mfile, ":TextFontPtr;");
  WriteLn (mfile)
  END;

IF FontAdapt IN MainConfig.configFlags0 THEN
  WriteString (mfile,"\t");
  WriteString (mfile, "Font");
  WriteFill   (mfile, "", 4);
  WriteString (mfile, ":TextAttrPtr;");
  WriteLn (mfile);

  WriteString (mfile,"\t");
  WriteString (mfile, "Attr");
  WriteFill   (mfile, "", 4);
  WriteString (mfile, ":TextAttr;");
  WriteLn (mfile);

  WriteString (mfile,"\t");
  WriteString (mfile, "FontX, FontY");
  WriteFill   (mfile, "", 12);
  WriteString (mfile, ":INTEGER;");
  WriteLn (mfile);

  WriteString (mfile,"\t");
  WriteString (mfile, "OffX, OffY");
  WriteFill   (mfile, "", 10);
  WriteString (mfile, ":INTEGER;");
  WriteLn (mfile)

ELSE
  GetAttrName (attrName);

  WriteString (mfile, "\t");
  WriteString (mfile, attrName);
  WriteFill   (mfile, attrName, 0);
  WriteString (mfile, ":TextAttr;");
  WriteLn (mfile)
  END;

IF Custom IN Gui.flags0 THEN
  IF Gui.colors[0].colorIndex # -1 THEN
    colorNumber := 0;
    WHILE (colorNumber < maxColorSpec) AND
          (Gui.colors[colorNumber].colorIndex # -1) DO
      INC (colorNumber)
      END;

    WriteString (mfile, "\t");
    WriteString (mfile, "ScreenColors");
    WriteFill   (mfile, "", 12);
    WriteString (mfile, ":ARRAY [0..");
    WriteCard   (mfile, colorNumber, 2);
    WriteString (mfile, "] OF ColorSpec;");
    WriteLn (mfile)
    END;


  penNumber := 0;
  WHILE (penNumber < maxDriPens) AND
        (Gui.driPens[penNumber] # MAX (CARDINAL)) DO
    INC (penNumber)
    END;

  WriteString (mfile, "\t");
  WriteString (mfile, "DriPens");
  WriteFill   (mfile, "", 7);
  WriteString (mfile, ":ARRAY [0..");
  WriteCard   (mfile, penNumber, 2);
  WriteString (mfile, "] OF CARDINAL;");
  WriteLn (mfile)
  END
END WriteScreenDefs;



PROCEDURE WriteScreenProcs	(    GetFilePresent	:BOOLEAN);

VAR	attrName		:ARRAY [0..maxFontName] OF CHAR;


  PROCEDURE WriteTextAttrInit	(    attrName		:ARRAY OF CHAR);

  VAR	fontStyleNames		:ARRAY FontStyles,[0..20] OF CHAR;
  	fontFlagNames		:ARRAY FontFlags ,[0..20] OF CHAR;
  	s			:FontStyles;
  	f			:FontFlags;

  BEGIN
  IF NOT (FontAdapt IN MainConfig.configFlags0) THEN
    fontStyleNames[underlined] := "underlined,";
    fontStyleNames[bold      ] := "bold,";
    fontStyleNames[italic    ] := "italic,";
    fontStyleNames[extended  ] := "extended,";
    fontStyleNames[fs4       ] := "fs4,";
    fontStyleNames[fs5       ] := "fs5,";
    fontStyleNames[colorFont ] := "colorFont,";
    fontStyleNames[tagged    ] := "tagged,";

    fontFlagNames[romFont     ] := "romFont,";
    fontFlagNames[diskFont    ] := "diskFont,";
    fontFlagNames[revPath     ] := "revPath,";
    fontFlagNames[tallDot     ] := "tallDot,";
    fontFlagNames[wideDot     ] := "wideDot,";
    fontFlagNames[proportional] := "proportional,";
    fontFlagNames[designed    ] := "designed,";
    fontFlagNames[removed     ] := "removed,";


    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE Init");
    WriteString (mfile, args.BaseName);
    WriteString (mfile, "TextAttr;");
    WriteLn (mfile);
    WriteLn (mfile);

    WriteString (mfile, "BEGIN");
    WriteLn (mfile);

    WriteString (mfile, "WITH ");
    WriteString (mfile, attrName);
    WriteString (mfile, " DO");
    WriteLn (mfile);

    WriteString (mfile, "  name  := ADR ('");
    WriteString (mfile, Gui.fontName);
    WriteString (mfile, "');");
    WriteLn (mfile);

    WriteString (mfile, "  ySize := ");
    WriteCard   (mfile, Gui.font.ySize, 1);
    Write       (mfile, ";");
    WriteLn (mfile);

    IF Gui.font.style = FontStyleSet {} THEN
      WriteString (mfile, "  style := FontStyleSet {};");
      WriteLn (mfile)
    ELSE
      WriteString (mfile, "  style := FontStyleSet {");
      FOR s := MIN (FontStyles) TO MAX (FontStyles) DO
        IF s IN Gui.font.style THEN
          WriteString (mfile, fontStyleNames[s])
          END
        END;

      SeekBack (mfile, 1);
      WriteString (mfile, "};");
      WriteLn (mfile)
      END;

    IF Gui.font.flags = FontFlagSet {} THEN
      WriteString (mfile, "  flags := FontFlagSet {}");
      WriteLn (mfile)
    ELSE
      WriteString (mfile, "  flags := FontFlagSet {");
      FOR f := MIN (FontFlags) TO MAX (FontFlags) DO
        IF f IN Gui.font.flags THEN
          WriteString (mfile, fontFlagNames[f])
          END
        END;

      SeekBack (mfile, 1);
      WriteString (mfile, "}");
      WriteLn (mfile)
      END;

    WriteString (mfile, "  END");
    WriteLn (mfile);

    WriteString (mfile, "END Init");
    WriteString (mfile, args.BaseName);
    WriteString (mfile, "TextAttr;");
    WriteLn (mfile);
    WriteLn (mfile)
    END
  END WriteTextAttrInit;



  PROCEDURE WriteScreenColorInit;

  VAR	i			:CARDINAL;

  BEGIN
  IF Custom IN Gui.flags0 THEN
    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE Init");
    WriteString (mfile, args.BaseName);
    WriteString (mfile, "ScreenColors;");
    WriteLn (mfile);
    WriteLn (mfile);

    WriteString (mfile, "BEGIN");
    WriteLn (mfile);


    IF Gui.colors[0].colorIndex # -1 THEN
      i := 0;
      WHILE (i < maxColorSpec) AND
            (Gui.colors[i].colorIndex # -1) DO
        WriteString (mfile, "ScreenColors[");
        WriteCard   (mfile, i, 2);
        WriteString (mfile, "].colorIndex := ");
        WriteInt    (mfile, Gui.colors[i].colorIndex, 2);
        WriteString (mfile, ";  ");

        WriteString (mfile, "ScreenColors[");
        WriteCard   (mfile, i, 2);
        WriteString (mfile, "].red := 0");
        WriteHex    (mfile, Gui.colors[i].red, 4);
        WriteString (mfile, "H;  ");

        WriteString (mfile, "ScreenColors[");
        WriteCard   (mfile, i, 2);
        WriteString (mfile, "].green := 0");
        WriteHex    (mfile, Gui.colors[i].green, 4);
        WriteString (mfile, "H;  ");

        WriteString (mfile, "ScreenColors[");
        WriteCard   (mfile, i, 2);
        WriteString (mfile, "].blue := 0");
        WriteHex    (mfile, Gui.colors[i].blue, 4);
        WriteString (mfile, "H;");
        WriteLn (mfile);

        INC (i)
        END;

      WriteString (mfile, "ScreenColors[");
      WriteCard   (mfile, i, 2);
      WriteString (mfile, "].colorIndex := -1;");

      WriteString (mfile, "ScreenColors[");
      WriteCard   (mfile, i, 2);
      WriteString (mfile, "].red := 0070H;  ");

      WriteString (mfile, "ScreenColors[");
      WriteCard   (mfile, i, 2);
      WriteString (mfile, "].green := 0700H;  ");

      WriteString (mfile, "ScreenColors[");
      WriteCard   (mfile, i, 2);
      WriteString (mfile, "].blue := 0007H;");
      WriteLn (mfile);
      WriteLn (mfile)
      END;


    i := 0;
    WHILE (i < maxDriPens) AND
          (Gui.driPens[i] # MAX (CARDINAL)) DO
      WriteString (mfile, "DriPens[");
      WriteCard   (mfile, i, 2);
      WriteString (mfile, "] :=");
      WriteInt    (mfile, Gui.driPens[i], 2);
      Write       (mfile, ";");
      WriteLn (mfile);

      INC (i)
      END;

    WriteString (mfile, "DriPens[");
    WriteCard   (mfile, i, 2);
    WriteString (mfile, "] := MAX (CARDINAL);");
    WriteLn (mfile);


    WriteString (mfile, "END Init");
    WriteString (mfile, args.BaseName);
    WriteString (mfile, "ScreenColors;");
    WriteLn (mfile);
    WriteLn (mfile)
    END
  END WriteScreenColorInit;



  PROCEDURE WriteScreenCreate	(    attrName		:ARRAY OF CHAR);


    PROCEDURE WriteIDFlags	(    flags		:LONGSET);

    CONST	palMonitorSet	=CAST (LONGSET, palMonitorID);
		ntscMonitorSet	=CAST (LONGSET, ntscMonitorID);

		superlaceKeySet	=CAST (LONGSET, superlaceKey);
		hireslaceKeySet	=CAST (LONGSET, hireslaceKey);
		loreslaceKeySet	=CAST (LONGSET, loreslaceKey);
		superKeySet	=CAST (LONGSET, superKey);
		hiresKeySet	=CAST (LONGSET, hiresKey);

    BEGIN
    IF    (palMonitorSet * flags) # LONGSET {} THEN
      WriteString (mfile, "palMonitorID+")
    ELSIF (ntscMonitorSet * flags) # LONGSET {} THEN
      WriteString (mfile, "ntscMonitorID+")
      END;

    IF    superlaceKeySet <= flags THEN
      WriteString (mfile, "superlaceKey+")
    ELSIF superKeySet     <= flags THEN
      WriteString (mfile, "superKey+")
    ELSIF hireslaceKeySet <= flags THEN
      WriteString (mfile, "hireslaceKey+")
    ELSIF hiresKeySet     <= flags THEN
      WriteString (mfile, "hiresKey+")
    ELSIF loreslaceKeySet <= flags THEN
      WriteString (mfile, "loreslaceKey+")
      END;

    SeekBack (mfile, 1)
    END WriteIDFlags;


  (* WriteScreenCreate *)
  BEGIN
  WriteLn (dfile);
  WriteString (dfile, "PROCEDURE Create");
  WriteString (dfile, args.BaseName);
  WriteString (dfile, "Screen");
  IF Public IN Gui.flags0 THEN
    WriteFill   (dfile, args.BaseName, 20);
    WriteString (dfile, "(    pubScreenName");
    WriteFill   (dfile, "", 17);
    WriteString (dfile, ":ARRAY OF CHAR")
  ELSE
    WriteString (dfile, " (")
    END;
  WriteString (dfile, ") :CARDINAL;");
  WriteLn (dfile);
  WriteLn (dfile);


  WriteLn (mfile);
  WriteString (mfile, "PROCEDURE Create");
  WriteString (mfile, args.BaseName);
  WriteString (mfile, "Screen");
  IF Public IN Gui.flags0 THEN
    WriteFill   (mfile, args.BaseName, 20);
    WriteString (mfile, "(    pubScreenName");
    WriteFill   (mfile, "", 17);
    WriteString (mfile, ":ARRAY OF CHAR")
  ELSE
    WriteString (mfile, " (")
    END;
  WriteString (mfile, ") :CARDINAL;");
  WriteLn (mfile);
  WriteLn (mfile);



  IF (Custom IN Gui.flags0) OR GetFilePresent THEN
    WriteString (mfile, "VAR")
    END;

  IF Custom IN Gui.flags0 THEN
    WriteString (mfile, "\t");
    WriteString (mfile, "screenTagPtr");
    WriteFill   (mfile, "", 12);
    WriteString (mfile, ":TagItemPtr;");
    WriteLn (mfile);

    WriteString (mfile, "\t");
    WriteString (mfile, "screenTags");
    WriteFill   (mfile, "", 10);
    WriteString (mfile, ":ARRAY SaTags OF TagItem;");
    WriteLn (mfile);
    WriteLn (mfile)
    END;

  IF GetFilePresent THEN
    WriteString (mfile, "\t");
    WriteString (mfile, "objectTagPtr");
    WriteFill   (mfile, "", 12);
    WriteString (mfile, ":TagItemPtr;");
    WriteLn (mfile);

    WriteString (mfile, "\t");
    WriteString (mfile, "objectTags");
    WriteFill   (mfile, "", 10);
    WriteString (mfile, ":ARRAY [0..1] OF TagItem;");
    WriteLn (mfile);
    WriteLn (mfile)
    END;



  WriteString (mfile, "BEGIN");
  WriteLn (mfile);

  WriteString (mfile, "Assert (");
  WriteString (mfile, "Screen = NIL, ADR ('");
  WriteString (mfile, args.BaseName);
  WriteString (mfile, "Screen is already open!'));");
  WriteLn (mfile);
  WriteLn (mfile);


  IF CheckFont () THEN
    WriteString (mfile, "Font := OpenDiskFont (ADR (");
    WriteString (mfile, attrName);
    WriteString (mfile, "));");
    WriteLn (mfile);

    WriteString (mfile, "IF Font = NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "  RETURN 3");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile);
    WriteLn (mfile)
    END;


  IF Workbench IN Gui.flags0 THEN
    WriteString (mfile, "Screen := LockPubScreen (ADR ('Workbench'));");
    WriteLn (mfile)

  ELSIF Public IN Gui.flags0 THEN
    WriteString (mfile, "IF pubScreenName[0] = 0C THEN");
    WriteLn (mfile);

    WriteString (mfile, "  Screen := LockPubScreen (NIL)");
    WriteLn (mfile);

    WriteString (mfile, "ELSE");
    WriteLn (mfile);

    WriteString (mfile, "  Screen := LockPubScreen (ADR (pubScreenName))");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile)

  ELSIF Custom IN Gui.flags0 THEN
    WriteString (mfile, "screenTagPtr := TAG (screenTags,");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "saLeft,");
    WriteFill   (mfile, "", 7);
    WriteCard   (mfile, Gui.left, 3);
    Write       (mfile, ",");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "saTop,");
    WriteFill   (mfile, "", 6);
    WriteCard   (mfile, Gui.top, 3);
    Write       (mfile, ",");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "saHeight,");
    WriteFill   (mfile, "", 9);
    WriteCard   (mfile, Gui.height, 3);
    Write       (mfile, ",");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "saWidth,");
    WriteFill   (mfile, "", 8);
    WriteCard   (mfile, Gui.width, 3);
    Write       (mfile, ",");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "saDepth,");
    WriteFill   (mfile, "", 8);
    WriteCard   (mfile, Gui.depth, 3);
    Write       (mfile, ",");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "saType,");
    WriteFill   (mfile, "", 7);
    WriteString (mfile, "customScreen,");
    WriteLn (mfile);

    IF Gui.colors[0].colorIndex # -1 THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "saColors,");
      WriteFill   (mfile, "", 8);
      WriteString (mfile, "ADR (ScreenColors),");
      WriteLn (mfile)
      END;

    IF NOT (FontAdapt IN MainConfig.configFlags0) THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "saFont,");
      WriteFill   (mfile, "", 7);
      WriteString (mfile, "ADR (");
      WriteString (mfile, attrName);
      WriteString (mfile, "),");
      WriteLn (mfile)
      END;

    WriteString (mfile, "\t\t");
    WriteString (mfile, "saDisplayID,");
    WriteFill   (mfile, "", 10);
    WriteIDFlags (Gui.displayID);
    Write       (mfile, ",");
    WriteLn (mfile);

    IF AutoScroll IN Gui.flags0 THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "saAutoScroll,");
      WriteFill   (mfile, "", 13);
      WriteString (mfile, "TRUE,");
      WriteLn (mfile);

      (*
      WriteString (mfile, "\t\t");
      WriteString (mfile, "saOverScan,");
      WriteFill   (mfile, "" 13);
      WriteString (mfile, "oScanText,");
      WriteLn (mfile);
      *)
      END;

    WriteString (mfile, "\t\t");
    WriteString (mfile, "saPens,");
    WriteFill   (mfile, "", 7);
    WriteString (mfile, "ADR (DriPens),");
    WriteLn (mfile);

    IF 0 < Length (Gui.screenTitle) THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "saPens,");
      WriteFill   (mfile, "", 7);
      WriteString (mfile, "ADR ('");
      WriteText   (mfile, Gui.screenTitle);
      WriteString (mfile, "'),");
      WriteLn (mfile)
      END;

    WriteString (mfile, "\t\t");
    WriteString (mfile, "tagEnd);");
    WriteLn (mfile);


    WriteString (mfile, "Screen := OpenScreenTagList(NIL, screenTagPtr);");
    WriteLn (mfile)
    END;

  WriteString (mfile, "IF Screen = NIL THEN");
  WriteLn (mfile);

  WriteString (mfile, "  RETURN 1");
  WriteLn (mfile);

  WriteString (mfile, "  END;");
  WriteLn (mfile);
  WriteLn (mfile);


  IF FontAdapt IN MainConfig.configFlags0 THEN
    WriteString (mfile, "ComputeFont (0, 0);");
    WriteLn (mfile)
    END;


  WriteString (mfile, "VisualInfo := GetVisualInfoA (Screen, NIL);");
  WriteLn (mfile);

  WriteString (mfile, "IF VisualInfo = NIL THEN");
  WriteLn (mfile);

  WriteString (mfile, "  RETURN 2");
  WriteLn (mfile);

  WriteString (mfile, "  END;");
  WriteLn (mfile);
  WriteLn (mfile);


  IF GetFilePresent THEN
    WriteString (mfile, "objectTagPtr := TAG (objectTags,");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "gtVisualInfo,");
    WriteFill   (mfile, "", 13);
    WriteString (mfile, "VisualInfo,");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "tagEnd);");
    WriteLn (mfile);


    WriteString (mfile, "GetImage := NewObjectA (GetFileClass, NIL, objectTagPtr);");
    WriteLn (mfile);

    WriteString (mfile, "IF GetImage = NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "  RETURN 4");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile);
    WriteLn (mfile)
    END;


  WriteString (mfile, "RETURN 0");
  WriteLn (mfile);


  WriteString (mfile, "END Create");
  WriteString (mfile, args.BaseName);
  WriteString (mfile, "Screen;");
  WriteLn (mfile);
  WriteLn (mfile)
  END WriteScreenCreate;



  PROCEDURE WriteScreenFree;

  BEGIN
  WriteLn (dfile);
  WriteString (dfile, "PROCEDURE Free");
  WriteString (dfile, args.BaseName);
  WriteString (dfile, "Screen;");
  WriteLn (dfile);
  WriteLn (dfile);


  WriteLn (mfile);
  WriteString (mfile, "PROCEDURE Free");
  WriteString (mfile, args.BaseName);
  WriteString (mfile, "Screen;");
  WriteLn (mfile);
  WriteLn (mfile);


  WriteString (mfile, "BEGIN");
  WriteLn (mfile);

  IF GetFilePresent THEN
    WriteString (mfile, "IF GetImage # NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "  DisposeObject (GetImage);");
    WriteLn (mfile);

    WriteString (mfile, "  GetImage := NIL;");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile);
    WriteLn (mfile)
    END;


  WriteString (mfile, "IF VisualInfo # NIL THEN");
  WriteLn (mfile);

  WriteString (mfile, "  FreeVisualInfo (VisualInfo);");
  WriteLn (mfile);

  WriteString (mfile, "  VisualInfo := NIL");
  WriteLn (mfile);

  WriteString (mfile, "  END;");
  WriteLn (mfile);
  WriteLn (mfile);


  WriteString (mfile, "IF Screen # NIL THEN");
  WriteLn (mfile);

  IF Custom IN Gui.flags0 THEN
    WriteString (mfile, "  CloseScreen (Screen);")
  ELSE
    WriteString (mfile, "  UnlockPubScreen (NIL, Screen);")
    END;
  WriteLn (mfile);

  WriteString (mfile, "  Screen := NIL");
  WriteLn (mfile);

  WriteString (mfile, "  END;");
  WriteLn (mfile);



  IF CheckFont () THEN
    WriteLn (mfile);
    WriteString (mfile, "IF Font # NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "  CloseFont (Font);");
    WriteLn (mfile);

    WriteString (mfile, "  Font := NIL;");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile)
    END;

  WriteString (mfile, "END Free");
  WriteString (mfile, args.BaseName);
  WriteString (mfile, "Screen;");
  WriteLn (mfile);
  WriteLn (mfile)
  END WriteScreenFree;



(* WriteScreenProcs *)
BEGIN
GetAttrName (attrName);

WriteTextAttrInit (attrName);
WriteScreenColorInit;

WriteScreenCreate (attrName);
WriteScreenFree
END WriteScreenProcs;



PROCEDURE WriteScreenInit;

BEGIN
IF NOT (FontAdapt IN MainConfig.configFlags0) THEN
  WriteString (mfile, "Init");
  WriteString (mfile, args.BaseName);
  WriteString (mfile, "TextAttr;");
  WriteLn (mfile)
  END;

IF Custom IN Gui.flags0 THEN
  WriteString (mfile, "Init");
  WriteString (mfile, args.BaseName);
  WriteString (mfile, "ScreenColors;");
  WriteLn (mfile)
  END
END WriteScreenInit;



PROCEDURE WriteScreenExit;

BEGIN
WriteString (mfile, "Free");
WriteString (mfile, args.BaseName);
WriteString (mfile, "Screen;");
WriteLn (mfile)
END WriteScreenExit;




END GenerateScreen.
