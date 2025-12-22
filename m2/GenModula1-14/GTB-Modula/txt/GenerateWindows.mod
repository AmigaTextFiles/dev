IMPLEMENTATION MODULE GenerateWindows;

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
 *	:History.	GenModula 1.10 (23.Aug.93)	;M2Amiga V4.0d	
 *	:History.	GenModula 1.12 (10.Sep.93)	;M2Amiga V4.2d
 *	:History.	GenModula 1.14 (14.Jan.94)
 *
 * -------------------------------------------------------------------------
 *)

FROM	SYSTEM			IMPORT	ADR, CAST;
FROM	String			IMPORT	Length, FirstPos,
					Copy, Concat;
FROM	Conversions		IMPORT	ValToStr;
FROM	FileMessage		IMPORT	StrPtr;
FROM	IntuitionD		IMPORT	WaTags,
					IDCMPFlags, IDCMPFlagSet,
					WindowFlags, WindowFlagSet;
FROM	GadToolsD		IMPORT	genericKind, buttonKind, checkboxKind,
					integerKind, listviewKind, mxKind, numberKind,
					cycleKind, paletteKind, scrollerKind,
					sliderKind, stringKind, textKind, numKinds,
					GtTags;
FROM	UtilityD		IMPORT	Tag,
					tagEnd,
					TagItem, TagItemPtr;
FROM	UtilityL		IMPORT	GetTagData;
FROM	FileOut			IMPORT	Write, WriteString, WriteLn,
					WriteCard, WriteInt;
FROM	GadToolsBox		IMPORT	maxFontName,
					GuiFlags, GuiFlagSet,
					GenCFlags, BBoxFlags,
					GTConfigFlags, WindowTagFlags,
					BevelBox,
					BevelBoxPtr, ExtNewGadgetPtr, ProjectWindowPtr,
					TagInArray;
FROM	GeneratorIO		IMPORT	dfile, mfile, args,
					Gui, MainConfig, CConfig, Projects,
					WriteFill, SeekBack, GetAttrName;


CONST	reservedKind		=10;


TYPE	IDCMPArray		=ARRAY [0..numKinds-1],[0..25] OF CHAR;


VAR	IDCMPText		:IDCMPArray;


(*
 * --- Initialisierung für Text -------------------------------------------------
 *)
PROCEDURE InitIDCMPText;

BEGIN
IDCMPText[genericKind]  := "IDCMPFlagSet {gadgetUp}";
IDCMPText[buttonKind]   := "buttonIDCMP";
IDCMPText[checkboxKind] := "checkboxIDCMP";
IDCMPText[integerKind]  := "integerIDCMP";
IDCMPText[listviewKind] := "listviewIDCMP";
IDCMPText[mxKind]       := "mxIDCMP";
IDCMPText[numberKind]   := "numberIDCMP";
IDCMPText[cycleKind]    := "cycleIDCMP";
IDCMPText[paletteKind]  := "paletteIDCMP";
IDCMPText[scrollerKind] := "scrollerIDCMP";
IDCMPText[reservedKind] := " ! RESERVED ! ";
IDCMPText[sliderKind]   := "sliderIDCMP";
IDCMPText[stringKind]   := "stringIDCMP";
IDCMPText[textKind]     := "textIDCMP"
END InitIDCMPText;



(*
 * --- Codegeneration -----------------------------------------------------------
 *)
PROCEDURE WriteWindowConsts		(    pw			:ProjectWindowPtr);

BEGIN
WriteString (mfile, "\t");					(* ProjectLeft			*)
WriteString (mfile, pw^.name);
WriteString (mfile, "Left");
WriteFill   (mfile, pw^.name, 4);
WriteString (mfile, "=");
WriteCard   (mfile, GetTagData (Tag (waLeft), 0, pw^.tags), 3);
Write       (mfile, ";");
WriteLn (mfile);

WriteString (mfile, "\t");					(* ProjectTop			*)
WriteString (mfile, pw^.name);
WriteString (mfile, "Top");
WriteFill   (mfile, pw^.name, 3);
WriteString (mfile, "=");
WriteCard   (mfile, GetTagData (Tag (waTop), 0, pw^.tags), 3);
Write       (mfile, ";");
WriteLn (mfile);

WriteString (mfile, "\t");					(* ProjectWidth =		*)
WriteString (mfile, pw^.name);
WriteString (mfile, "Width");
WriteFill   (mfile, pw^.name, 5);
WriteString (mfile, "=");
IF NOT (FontAdapt IN MainConfig.configFlags0) THEN
  IF InnerWidth IN pw^.tagFlags THEN
    WriteCard (mfile, pw^.innerWidth, 3)

  ELSE
    WriteCard (mfile, GetTagData (Tag (waWidth), 0, pw^.tags), 3)
    END

ELSE
  WriteCard (mfile, pw^.innerWidth, 3)
  END;
Write       (mfile, ";");
WriteLn (mfile);

WriteString (mfile, "\t");					(* ProjectHeight =		*)
WriteString (mfile, pw^.name);
WriteString (mfile, "Height");
WriteFill   (mfile, pw^.name, 6);
WriteString (mfile, "=");
IF NOT (FontAdapt IN MainConfig.configFlags0) THEN
  IF InnerHeight IN pw^.tagFlags THEN
    WriteCard (mfile, pw^.innerHeight, 3)

  ELSE
    WriteInt (mfile, GetTagData (Tag (waHeight), 0, pw^.tags) - pw^.topBorder, 3)
    END

ELSE
  WriteCard (mfile, pw^.innerHeight, 3)
  END;
Write       (mfile, ";");
WriteLn (mfile)
END WriteWindowConsts;



PROCEDURE WriteWindowDefs		(    pw			:ProjectWindowPtr);


BEGIN
WriteString (dfile, "\t");
WriteString (dfile, pw^.name);
WriteString (dfile, "Window");
WriteFill    (dfile, pw^.name, 6);
WriteString (dfile, ":WindowPtr;");
WriteLn (dfile);

IF (FontAdapt IN MainConfig.configFlags0) AND
   (gcSysFont IN CConfig) THEN
  WriteString (mfile, "\t");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Font");
  WriteFill   (mfile, pw^.name, 4);
  WriteString (mfile, ":TextFontPtr;");
  WriteLn (mfile)
  END;

IF ((Zoom IN pw^.tagFlags) OR
    (DefaultZoom IN pw^.tagFlags)) AND
   NOT (windowSizing IN pw^.windowFlags) THEN
  WriteString (mfile, "\t");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Zoom");
  WriteFill   (mfile, pw^.name, 4);
  WriteString (mfile, ":ARRAY [1..4] OF INTEGER;");
  WriteLn (mfile)
  END
END WriteWindowDefs;


PROCEDURE WriteWindowProcs		(    pw			:ProjectWindowPtr);


  PROCEDURE WriteWindowCreate		(    pw			:ProjectWindowPtr);

    PROCEDURE WriteOpenWindow		(    pw			:ProjectWindowPtr);

      PROCEDURE WriteIDCMPFlags		(    idcmp		:IDCMPFlagSet;
      					     pw			:ProjectWindowPtr);

        PROCEDURE WriteIDCMPSets	(    pw			:ProjectWindowPtr);

        TYPE	KindSet			=SET OF [0..numKinds-1];

        VAR	eng			:ExtNewGadgetPtr;
        	kindUsed		:KindSet;

        BEGIN
        kindUsed := KindSet {};
        eng := pw^.gadgets.head;
        WHILE eng^.succ # NIL DO
          IF NOT (eng^.kind IN kindUsed) THEN
            WriteString (mfile, IDCMPText[eng^.kind]);
            WriteString (mfile, "+");
            INCL (kindUsed, eng^.kind);

            IF (eng^.kind = scrollerKind) AND
               (TagInArray (Tag (gtscArrows), eng^.tags)) THEN
              WriteString (mfile, "arrowIDCMP+")
              END
            END;
          eng := eng^.succ
          END
        END WriteIDCMPSets;


      (* WriteIDCMPFlags *)
      BEGIN
      IF idcmp = IDCMPFlagSet {} THEN
        WriteString (mfile, "IDCMPFlags {},");
        WriteLn (mfile)

      ELSE
        WriteIDCMPSets (pw);

        WriteString (mfile, "IDCMPFlagSet {");

        IF gadgetUp IN idcmp THEN
          WriteString (mfile, "gadgetUp,")
          END;
        IF gadgetDown IN idcmp THEN
          WriteString (mfile, "gadgetDown,")
          END;
        IF intuiTicks IN idcmp THEN
          WriteString (mfile, "intuiTicks,")
          END;
        IF mouseMove IN idcmp THEN
          WriteString (mfile, "mouseMove,")
          END;
        IF mouseButtons IN idcmp THEN
          WriteString (mfile, "mouseButtons,")
          END;
        IF sizeVerify IN idcmp THEN
          WriteString (mfile, "sizeVerify,")
          END;
        IF newSize IN idcmp THEN
          WriteString (mfile, "newSize,")
          END;
        IF reqSet IN idcmp THEN
          WriteString (mfile, "reqSet,")
          END;
        IF menuPick IN idcmp THEN
          WriteString (mfile, "menuPick,")
          END;
        IF closeWindow IN idcmp THEN
          WriteString (mfile, "closeWindow,")
          END;
        IF rawKey IN idcmp THEN
          WriteString (mfile, "rawKey,")
          END;
        IF reqVerify IN idcmp THEN
          WriteString (mfile, "reqVerify,")
          END;
        IF reqClear IN idcmp THEN
          WriteString (mfile, "reqClear,")
          END;
        IF menuVerify IN idcmp THEN
          WriteString (mfile, "menuVerify,")
          END;
        IF newPrefs IN idcmp THEN
          WriteString (mfile, "newPrefs,")
          END;
        IF diskInserted IN idcmp THEN
          WriteString (mfile, "diskInserted,")
          END;
        IF diskRemoved IN idcmp THEN
          WriteString (mfile, "diskRemoved,")
          END;
        IF activeWindow IN idcmp THEN
          WriteString (mfile, "activeWindow,")
          END;
        IF inactiveWindow IN idcmp THEN
          WriteString (mfile, "inactiveWindow,")
          END;
        IF deltaMove IN idcmp THEN
          WriteString (mfile, "deltaMove,")
          END;
        IF vanillaKey IN idcmp THEN
          WriteString (mfile, "vanillaKey,")
          END;
        IF idcmpUpdate IN idcmp THEN
          WriteString (mfile, "idcmpUpdate,")
          END;
        IF menuHelp IN idcmp THEN
          WriteString (mfile, "menuHelp,")
          END;
        IF changeWindow IN idcmp THEN
          WriteString (mfile, "changeWindow,")
          END;
        IF refreshWindow IN idcmp THEN
          WriteString (mfile, "refreshWindow,")
          END;

        SeekBack (mfile, 1);
        WriteString (mfile, "},");
        END
      END WriteIDCMPFlags;



      PROCEDURE WriteWindowFlags	(    flags		:WindowFlagSet);

      BEGIN
      WriteString (mfile, "WindowFlagSet {");

      IF windowSizing IN flags THEN
        WriteString (mfile, "windowSizing,")
        END;
      IF windowDrag IN flags THEN
        WriteString (mfile, "windowDrag,")
        END;
      IF windowDepth IN flags THEN
        WriteString (mfile, "windowDepth,")
        END;
      IF windowClose IN flags THEN
        WriteString (mfile, "windowClose,")
        END;
      IF sizeBRight IN flags THEN
        WriteString (mfile, "sizeBRight,")
        END;
      IF sizeBBottom IN flags THEN
        WriteString (mfile, "sizeBBottom,")
        END;
      IF simpleRefresh IN flags THEN
        WriteString (mfile, "simpleRefresh,")
        END;
      IF superBitMap IN flags THEN
        WriteString (mfile, "superBitMap,")
        END;
      IF backDrop IN flags THEN
        WriteString (mfile, "backDrop,")
        END;
      IF reportMouse IN flags THEN
        WriteString (mfile, "reportMouse,")
        END;
      IF gimmeZeroZero IN flags THEN
        WriteString (mfile, "gimmeZeroZero,")
        END;
      IF borderless IN flags THEN
        WriteString (mfile, "borderless,")
        END;
      IF activate IN flags THEN
        WriteString (mfile, "activate,")
        END;
      IF rmbTrap IN flags THEN
        WriteString (mfile, "rmbTrap,")
        END;

      SeekBack (mfile, 1);
      WriteString (mfile, "},")
      END WriteWindowFlags;


    (* WriteOpenWindow *)
    BEGIN
    WriteString (mfile, "windowTagPtr := TAG (");
    WriteString (mfile, "windowTags,");
    WriteLn (mfile);


    WriteString (mfile, "\t\t");
    WriteString (mfile, "waIDCMP,");
    WriteFill   (mfile, "", 8);
    WriteIDCMPFlags (pw^.idcmpFlags+IDCMPFlagSet {refreshWindow}, pw);
    WriteLn (mfile);


    WriteString (mfile, "\t\t");
    WriteString (mfile, "waFlags,");
    WriteFill   (mfile, "", 8);
    WriteWindowFlags (pw^.windowFlags);
    WriteLn (mfile);


    WriteString (mfile, "\t\t");
    WriteString (mfile, "waLeft,");
    WriteFill   (mfile, "", 7);
    IF FontAdapt IN MainConfig.configFlags0 THEN
      WriteString (mfile, "wleft,")
    ELSE
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Left,")
      END;
    WriteLn (mfile);


    WriteString (mfile, "\t\t");
    WriteString (mfile, "waTop,");
    WriteFill   (mfile, "", 6);
    IF FontAdapt IN MainConfig.configFlags0 THEN
      WriteString (mfile, "wtop,")
    ELSE
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Top,")
      END;
    WriteLn (mfile);


    IF NOT (FontAdapt IN MainConfig.configFlags0) THEN
      IF InnerWidth IN pw^.tagFlags THEN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "waInnerWidth,");
        WriteFill   (mfile, "", 13)
      ELSE
        WriteString (mfile, "\t\t");
        WriteString (mfile, "waWidth,");
        WriteFill   (mfile, "", 8)
        END;
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Width,");
      WriteLn (mfile);

      IF InnerHeight IN pw^.tagFlags THEN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "waInnerHeight");
        WriteFill   (mfile, "", 14);
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Height,");
      ELSE
        WriteString (mfile, "\t\t");
        WriteString (mfile, "waHeight,");
        WriteFill   (mfile, "", 9);
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Height + offy,");
        END;
      WriteLn (mfile)

    ELSE
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waWidth,");
      WriteFill   (mfile, "", 8);
      WriteString (mfile, "ww + OffX + Screen^.wBorRight,");
      WriteLn (mfile);

      WriteString (mfile, "\t\t");
      WriteString (mfile, "waHeight,");
      WriteFill   (mfile, "", 9);
      WriteString (mfile, "wh + OffY + Screen^.wBorBottom,");
      WriteLn (mfile)
      END;


    IF NOT (backDrop IN pw^.windowFlags) AND
       (0 < Length (pw^.windowTitle)) THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waTitle,");
      WriteFill   (mfile, "", 8);
      WriteString (mfile, "ADR ('");
      WriteString (mfile, pw^.windowTitle);
      WriteString (mfile, "'),");
      WriteLn (mfile)
      END;


    IF 0 < Length (pw^.screenTitle) THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waScreenTitle,");
      WriteFill   (mfile, "", 14);
      WriteString (mfile, "ADR ('");
      WriteString (mfile, pw^.screenTitle);
      WriteString (mfile, "'),");
      WriteLn (mfile)
      END;


    IF Custom IN Gui.flags0 THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waCustomScreen,");
      WriteFill   (mfile, "", 15);
      WriteString (mfile, "Screen,");
      WriteLn (mfile)
    ELSE
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waPubScreen,");
      WriteFill   (mfile, "", 12);
      WriteString (mfile, "Screen,");
      WriteLn (mfile)
      END;


    IF windowSizing IN pw^.windowFlags THEN
      IF TagInArray (Tag (waMinWidth), pw^.tags) THEN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "waMinWidth,");
        WriteFill   (mfile, "", 11);
        WriteCard   (mfile, GetTagData (Tag (waMinWidth), 0, pw^.tags), 3);
        Write       (mfile, ",");
        WriteLn (mfile)
        END;

      IF TagInArray (Tag (waMinHeight), pw^.tags) THEN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "waMinHeight,");
        WriteFill   (mfile, "", 12);
        WriteCard   (mfile, GetTagData (Tag (waMinHeight), 0, pw^.tags), 3);
        Write       (mfile, ",");
        WriteLn (mfile)
        END;

      IF TagInArray (Tag (waMaxWidth), pw^.tags) THEN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "waMaxWidth,");
        WriteFill   (mfile, "", 11);
        WriteCard   (mfile, GetTagData (Tag (waMaxWidth), 0, pw^.tags), 3);
        Write       (mfile, ",");
        WriteLn (mfile)
        END;

      IF TagInArray (Tag (waMaxHeight), pw^.tags) THEN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "waMaxHeight,");
        WriteFill   (mfile, "", 11);
        WriteCard   (mfile, GetTagData (Tag (waMaxHeight), 0, pw^.tags), 3);
        Write       (mfile, ",");
        WriteLn (mfile)
        END

    ELSE
      IF (Zoom IN pw^.tagFlags) OR (DefaultZoom IN pw^.tagFlags) THEN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "waZoom,");
        WriteFill   (mfile, "", 7);
        WriteString (mfile, "ADR (");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Zoom),");
        WriteLn (mfile)
        END
      END;


    IF (pw^.gadgets.head^.succ # NIL) AND
       NOT ((args.raster) AND (pw^.boxes.head^.succ # NIL)) THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waGadgets,");
      WriteFill   (mfile, "", 10);
      WriteString (mfile, pw^.name);
      WriteString (mfile, "GadgetList,");
      WriteLn (mfile)
      END;


    IF MouseQueue IN pw^.tagFlags THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waMouseQueue,");
      WriteFill   (mfile, "", 15);
      WriteCard   (mfile, pw^.mouseQueue, 1);
      WriteString (mfile, ",");
      WriteLn (mfile)
      END;


    IF RptQueue IN pw^.tagFlags THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waRptQueue,");
      WriteFill   (mfile, "", 11);
      WriteCard   (mfile, pw^.rptQueue, 1);
      WriteString (mfile, ",");
      WriteLn (mfile)
      END;


    IF AutoAdjust IN pw^.tagFlags THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waAutoAdjust,");
      WriteFill   (mfile, "", 13);
      WriteString (mfile, "TRUE,");
      WriteLn (mfile)
      END;


    IF FallBack IN pw^.tagFlags THEN
      WriteString (mfile, "\t\t");
      WriteString (mfile, "waPubScreenFallBack,");
      WriteFill   (mfile, "", 19);
      WriteString (mfile, "TRUE,");
      WriteLn (mfile)
      END;


    WriteString (mfile, "\t\t");
    WriteString (mfile, "tagEnd);");
    WriteLn (mfile);
    WriteLn (mfile);

    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window := OpenWindowTagList (NIL, windowTagPtr); ");
    WriteLn (mfile);

    WriteString (mfile, "IF ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window = NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "  RETURN 20");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile);
    WriteLn (mfile)
    END WriteOpenWindow;



    PROCEDURE WriteCreateWinHead	(    pw			:ProjectWindowPtr);

    VAR	attrName			:ARRAY [0..maxFontName] OF CHAR;

    BEGIN
    WriteLn (dfile);
    WriteString (dfile, "PROCEDURE Create");
    WriteString (dfile, pw^.name);
    WriteString (dfile, "Window");
    IF pw^.gadgets.head^.succ = NIL THEN
      WriteString (dfile, " (")
    ELSE
      WriteFill   (dfile, pw^.name, 12);
      WriteString (dfile, "(    createGadgets");
      WriteFill   (dfile, "", 18);
      WriteString (dfile, ":BOOLEAN")
      END;
    WriteString (dfile, ") :CARDINAL;");
    WriteLn (dfile);
    WriteLn (dfile);


    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE Create");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window");
    IF pw^.gadgets.head^.succ = NIL THEN
      WriteString (mfile, " (")
    ELSE
      WriteFill   (mfile, pw^.name, 12);
      WriteString (mfile, "(    createGadgets");
      WriteFill   (mfile, "", 18);
      WriteString (mfile, ":BOOLEAN")
      END;
    WriteString (mfile, ") :CARDINAL;");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "VAR");
    WriteString (mfile, "\t");
    WriteString (mfile, "offx, offy, ret");
    WriteFill   (mfile, "", 14);
    WriteString (mfile, ":CARDINAL;");
    WriteLn (mfile);

    IF FontAdapt IN MainConfig.configFlags0 THEN
      WriteString (mfile, "\t");
      WriteString (mfile, "wleft, wtop, ww, wh");
      WriteFill   (mfile, "", 19);
      WriteString (mfile, ":INTEGER;");
      WriteLn (mfile)

    ELSE
      WriteString (mfile, "\t");
      WriteString (mfile, "menuTagPtr");
      WriteFill   (mfile, "", 10);
      WriteString (mfile, ":TagItemPtr;");
      WriteLn (mfile);

      WriteString (mfile, "\t");
      WriteString (mfile, "menuTags");
      WriteFill   (mfile, "", 8);
      WriteString (mfile, ":ARRAY [0..1] OF TagItem;");
      WriteLn (mfile)
      END;

    WriteString (mfile, "\t");
    WriteString (mfile, "windowTagPtr");
    WriteFill   (mfile, "", 12);
    WriteString (mfile, ":TagItemPtr;");
    WriteLn (mfile);

    WriteString (mfile, "\t");
    WriteString (mfile, "windowTags");
    WriteFill   (mfile, "", 10);
    WriteString (mfile, ":ARRAY [1..20] OF TagItem;");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "BEGIN");
    WriteLn (mfile);

    WriteString (mfile, "Assert (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window = NIL, ADR ('");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window is already open!'));");
    WriteLn (mfile);
    WriteLn (mfile);


    IF FontAdapt IN MainConfig.configFlags0 THEN
      IF NOT (args.mouse) THEN
        WriteString (mfile, "wleft := ");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Left;");
        WriteLn (mfile);

        WriteString (mfile, "wtop  := ");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Top;");
        WriteLn (mfile);
        WriteLn (mfile)
        END;


      WriteString (mfile, "ComputeFont (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Width, ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Height);");
      WriteLn (mfile);

      WriteString (mfile, "ww := ComputeX (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Width);");
      WriteLn (mfile);

      WriteString (mfile, "wh := ComputeY (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Height);");
      WriteLn (mfile);
      WriteLn (mfile);


      IF args.mouse THEN
        WriteString (mfile, "wleft := Screen^.mouseX - (ww DIV 2);");
        WriteLn (mfile);

        WriteString (mfile, "wtop  := Screen^.mouseY - (wh DIV 2);");
        WriteLn (mfile)

      ELSE
        WriteString (mfile, "IF Screen^.width < wleft + ww + OffX + Screen^.wBorRight THEN");
        WriteLn (mfile);
        WriteString (mfile, "  wleft := Screen^.width - ww");
        WriteLn (mfile);
        WriteString (mfile, "  END;");
        WriteLn (mfile);

        WriteString (mfile, "IF Screen^.height < wtop + wh + OffY + Screen^.wBorBottom THEN");
        WriteLn (mfile);
        WriteString (mfile, "  wtop := Screen^.height - wh");
        WriteLn (mfile);
        WriteString (mfile, "  END;");
        WriteLn (mfile)
        END;
      WriteLn (mfile);


      IF gcSysFont IN CConfig THEN
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Font := OpenDiskFont (Font);");
        WriteLn (mfile);

        WriteString (mfile, "IF ");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Font = NIL THEN");
        WriteLn (mfile);

        WriteString (mfile, "  RETURN 5");
        WriteLn (mfile);
        WriteString (mfile, "  END;");
        WriteLn (mfile);
        WriteLn (mfile)
        END

    ELSE
      IF backDrop IN pw^.windowFlags THEN
        WriteString (mfile, "offx := 0;")
      ELSE
        WriteString (mfile, "offx := Screen^.wBorLeft;")
        END;
      WriteLn (mfile);

      WriteString (mfile, "offy := CARDINAL (Screen^.wBorTop) + Screen^.rastPort.txHeight + 1;");
      WriteLn (mfile);
      WriteLn (mfile)
      END;


    IF pw^.windowText # NIL THEN
      WriteString (mfile, "Init");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "ITexts;");
      WriteLn (mfile);
      WriteLn (mfile)
      END;


    IF pw^.gadgets.head^.succ # NIL THEN
      WriteString (mfile, "IF createGadgets THEN");
      WriteLn (mfile);

      WriteString (mfile, "  ret := Create");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Gadgets ();");
      WriteLn (mfile);

      WriteString (mfile, "  IF ret # 0 THEN");
      WriteLn (mfile);

      WriteString (mfile, "    RETURN ret");
      WriteLn (mfile);

      WriteString (mfile, "    END");
      WriteLn (mfile);

      WriteString (mfile, "  END;");
      WriteLn (mfile);
      WriteLn (mfile)
      END;


    IF pw^.menus.head^.succ # NIL THEN
      WriteString (mfile, pw^.name);
      WriteString (mfile, "MenuStrip := CreateMenusA (ADR (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Menu), NIL);");
      WriteLn (mfile);

      WriteString (mfile, "IF ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "MenuStrip = NIL THEN");
      WriteLn (mfile);

      WriteString (mfile, "  RETURN 3");
      WriteLn (mfile);

      WriteString (mfile, "  END;");
      WriteLn (mfile);


      IF FontAdapt IN MainConfig.configFlags0 THEN
        WriteString (mfile, "IF NOT (LayoutMenusA (");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "MenuStrip, VisualInfo, NIL)) THEN");
        WriteLn (mfile);


      ELSE
        GetAttrName (attrName);

        WriteString (mfile, "menuTagPtr := TAG (menuTags,");
        WriteLn (mfile);

        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtmnTextAttr,");
        WriteFill   (mfile, "", 13);
        WriteString (mfile, "ADR (");
        WriteString (mfile, attrName);
        WriteString (mfile, "),");
        WriteLn (mfile);

        WriteString (mfile, "\t\t");
        WriteString (mfile, "tagEnd);");
        WriteLn (mfile);


        WriteString (mfile, "IF NOT (LayoutMenusA (");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "MenuStrip, VisualInfo, menuTagPtr)) THEN");
        WriteLn (mfile)
        END;


      WriteString (mfile, "  RETURN 4");
      WriteLn (mfile);

      WriteString (mfile, "  END;");
      WriteLn (mfile);
      WriteLn (mfile)
      END;



    IF ((Zoom IN pw^.tagFlags) OR
        (DefaultZoom IN pw^.tagFlags)) AND
        NOT (windowSizing IN pw^.windowFlags) THEN
      IF Zoom IN pw^.tagFlags THEN
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Zoom[1] := ");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Left;");
        WriteLn (mfile);

        WriteString (mfile, pw^.name);
        WriteString (mfile, "Zoom[2] := ");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Top;");
        WriteLn (mfile)

      ELSE
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Zoom[1] := 0;");
        WriteLn (mfile);

        WriteString (mfile, pw^.name);
        WriteString (mfile, "Zoom[2] := 0;");
        WriteLn (mfile)
        END;


      WriteString (mfile, pw^.name);
      WriteString (mfile, "Zoom[3] := TextLength (ADR (Screen^.rastPort),");
      WriteLn (mfile);

      WriteString (mfile, "                       ADR ('");
      WriteString (mfile, pw^.windowTitle);
      WriteString (mfile, "'), ");
      WriteInt    (mfile, Length (pw^.windowTitle), 1);
      WriteString (mfile, ") + 80;");
      WriteLn (mfile);

      WriteString (mfile, pw^.name);
      WriteString (mfile, "Zoom[4] := Screen^.wBorTop + INTEGER (Screen^.rastPort.txHeight) + 1;");
      WriteLn (mfile)
      END
    END WriteCreateWinHead;



    PROCEDURE WriteCreateWinTail	(    pw			:ProjectWindowPtr);

    BEGIN
    WriteString (mfile, "Render");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window (TRUE);");
    WriteLn (mfile);


    IF pw^.menus.head^.succ # NIL THEN
      WriteLn (mfile);
      WriteString (mfile, "IF NOT (SetMenuStrip (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Window, ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "MenuStrip)) THEN");
      WriteLn (mfile);

      WriteString (mfile, "  RETURN 5");
      WriteLn (mfile);

      WriteString (mfile, "  END;");
      WriteLn (mfile);
      WriteLn (mfile)
      END;


    WriteLn (mfile);
    WriteString (mfile, "RETURN 0");
    WriteLn (mfile);

    WriteString (mfile, "END Create");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window;");
    WriteLn (mfile);
    WriteLn (mfile)
    END WriteCreateWinTail;


  (* WriteWindowCreate *)
  BEGIN
  WriteCreateWinHead (pw);
  WriteOpenWindow (pw);
  WriteCreateWinTail (pw)
  END WriteWindowCreate;


  PROCEDURE WriteWindowRender		(    pw			:ProjectWindowPtr);

  CONST	outerBox			=bbf15;

  VAR	box				:BevelBoxPtr;
  	bleft, btop			:CARDINAL;



    PROCEDURE calculateOuterBoxes	(    firstbox		:BevelBoxPtr);

    VAR	ibox, jbox			:BevelBoxPtr;


      PROCEDURE isOuterBox		(VAR outBox, inBox	:BevelBox) :BOOLEAN;

      BEGIN
      RETURN (outBox.left <= inBox.left) &
             (outBox.top  <= inBox.top) &
             (inBox.left + CARDINAL (inBox.width) <= outBox.left + CARDINAL (outBox.width)) &
             (inBox.top + CARDINAL (inBox.height) <= outBox.top + CARDINAL (outBox.height))
      END isOuterBox;


    (* calculateOuterBoxes *)
    BEGIN
    ibox := firstbox;
    WHILE ibox^.succ # NIL DO
      INCL (ibox^.flags, outerBox);
      ibox := ibox^.succ
      END;

    ibox := firstbox^.succ;
    WHILE ibox^.succ # NIL DO
      jbox := firstbox;

      WHILE (jbox # ibox) AND (outerBox IN ibox^.flags) DO
        IF outerBox IN jbox^.flags THEN
          IF    isOuterBox (ibox^, jbox^) THEN
            EXCL (jbox^.flags, outerBox)
          ELSIF isOuterBox (jbox^, ibox^) THEN
            EXCL (ibox^.flags, outerBox)
            END
          END;

        jbox := jbox^.succ
        END;
      ibox := ibox^.succ
      END
    END calculateOuterBoxes;


  (* WriteWindowRender *)
  BEGIN
  bleft := pw^.leftBorder;
  btop  := pw^.topBorder;


  WriteLn (mfile);
  WriteString (mfile, "PROCEDURE Render");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window");
  WriteFill   (mfile, pw^.name, 14);
  WriteString (mfile, "(    firstRender");
  WriteFill   (mfile, "", 16);
  WriteString (mfile, ":BOOLEAN);");
  WriteLn (mfile);
  WriteLn (mfile);



  IF (pw^.boxes.head^.succ # NIL) OR
     ((pw^.windowText # NIL) AND NOT (FontAdapt IN MainConfig.configFlags0)) THEN
    WriteString (mfile, "VAR");

    IF NOT (FontAdapt IN MainConfig.configFlags0) THEN
      WriteString (mfile, "\t");
      WriteString (mfile, "offx, offy");
      WriteFill   (mfile, "", 9);
      WriteString (mfile, ":CARDINAL;");
      WriteLn (mfile)
      END;


    IF pw^.boxes.head^.succ # NIL THEN
      WriteString (mfile, "\t");
      WriteString (mfile, "bevelTags");
      WriteFill   (mfile, "", 9);
      WriteString (mfile, ":ARRAY [0..2] OF TagItem;");
      WriteLn (mfile);

      WriteString (mfile, "\t");
      WriteString (mfile, "bevelTagPtr");
      WriteFill   (mfile, "", 11);
      WriteString (mfile, ":TagItemPtr;");
      WriteLn (mfile);
      WriteLn (mfile);

      IF args.raster AND (pw^.gadgets.head^.succ # NIL) THEN
        WriteString (mfile, "\t");
        WriteString (mfile, "dummy");
        WriteFill   (mfile, "", 5);
        WriteString (mfile, ":INTEGER;");
        WriteLn (mfile)
        END
      END;

    WriteLn (mfile)
    END;



  WriteString (mfile, "BEGIN");
  WriteLn (mfile);


  IF NOT (FontAdapt IN MainConfig.configFlags0) AND
     ((pw^.windowText # NIL) OR (pw^.boxes.head^.succ # NIL)) THEN
    IF backDrop IN pw^.windowFlags THEN
      WriteString (mfile, "offx := 0;");
      WriteLn (mfile);

      WriteString (mfile, "offy := CARDINAL (Screen^.wBorTop) + Screen^.rastPort.txHeight + 1;");
      WriteLn (mfile)

    ELSE
      WriteString (mfile, "offx := ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Window^.borderLeft;");
      WriteLn (mfile);

      WriteString (mfile, "offy := ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Window^.borderTop;");
      WriteLn (mfile)
      END;
    WriteLn (mfile)
    END;



  WriteString (mfile, "IF NOT (firstRender) THEN");
  WriteLn (mfile);

  IF (args.raster) AND
     (pw^.boxes.head^.succ # NIL) AND
     (pw^.gadgets.head^.succ # NIL) THEN
    WriteString (mfile, "  dummy := RemoveGList (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window, ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "GadgetList, -1);");
    WriteLn (mfile)
    END;

  WriteString (mfile, "  GTBeginRefresh (");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window);");
  WriteLn (mfile);

  IF (pw^.boxes.head^.succ # NIL) OR
     (pw^.windowText # NIL) THEN
    WriteString (mfile, "  END;");
    WriteLn (mfile)
    END;



  IF pw^.boxes.head^.succ # NIL THEN
    WriteLn (mfile);
    IF args.raster THEN
      calculateOuterBoxes (pw^.boxes.head);

      WriteString (mfile, "DrawRast (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Window);");
      WriteLn (mfile);
      WriteLn (mfile);


      box := pw^.boxes.head;
      WHILE box^.succ # NIL DO
        IF outerBox IN box^.flags THEN
          WriteString (mfile, "FilledBBox (VisualInfo,");
          WriteLn (mfile);

          WriteString (mfile, "            ");
          WriteString (mfile, pw^.name);
          WriteString (mfile, "Window^.rPort,");
          WriteLn (mfile);

          IF FontAdapt IN MainConfig.configFlags0 THEN
            WriteString (mfile, "            OffX + ComputeX (");
            WriteCard   (mfile, box^.left - bleft, 1);
            WriteString (mfile, "), ");
            WriteLn (mfile);

            WriteString (mfile, "            OffY + ComputeY (");
            WriteCard   (mfile, box^.top - btop, 1);
            WriteString (mfile, "), ");
            WriteLn (mfile);

            WriteString (mfile, "            ComputeX (");
            WriteCard   (mfile, box^.width, 1);
            WriteString (mfile, "), ");
            WriteLn (mfile);

            WriteString (mfile, "            ComputeY (");
            WriteCard   (mfile, box^.height, 1);
            WriteString (mfile, "), ");
            WriteLn (mfile);

          ELSE
            WriteString (mfile, "            offx + ");
            WriteCard   (mfile, box^.left - bleft, 1);
            WriteString (mfile, ",");
            WriteLn (mfile);

            WriteString (mfile, "            offy + ");
            WriteCard   (mfile, box^.top - btop, 1);
            WriteString (mfile, ",");
            WriteLn (mfile);

            WriteString (mfile, "            ");
            WriteCard   (mfile, box^.width, 1);
            WriteString (mfile, ",");
            WriteLn (mfile);

            WriteString (mfile, "            ");
            WriteCard   (mfile, box^.height, 1);
            WriteString (mfile, ",");
            WriteLn (mfile)
            END;

          IF recessed IN box^.flags THEN
            WriteString (mfile, "            TRUE);")
          ELSE
            WriteString (mfile, "            FALSE);")
            END;
          WriteLn (mfile)
          END;  (* IF outerBox *)

        box := box^.succ
        END
      END;  (* IF args.raster *)


    box := pw^.boxes.head;
    WHILE box^.succ # NIL DO
      IF NOT (args.raster) OR NOT (outerBox IN box^.flags) THEN

        WriteString (mfile, "bevelTagPtr := TAG (bevelTags,");
        WriteLn (mfile);

        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtVisualInfo,");
        WriteFill   (mfile, "", 11);
        WriteString (mfile, "VisualInfo,");
        WriteLn (mfile);

        IF recessed IN box^.flags THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtbbRecessed,");
          WriteFill   (mfile, "", 13);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END;

        WriteString (mfile, "\t\t");
        WriteString (mfile, "tagEnd);");
        WriteLn (mfile);


        WriteString (mfile, "DrawBevelBoxA (");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Window^.rPort,");
        WriteLn (mfile);

        IF FontAdapt IN MainConfig.configFlags0 THEN
          WriteString (mfile, "               OffX + ComputeX (");
          WriteCard   (mfile, box^.left - bleft, 1);
          WriteString (mfile, "),");
          WriteLn (mfile);

          WriteString (mfile, "               OffY + ComputeY (");
          WriteCard   (mfile, box^.top - btop, 1);
          WriteString (mfile, "),");
          WriteLn (mfile);

          WriteString (mfile, "               ComputeX (");
          WriteCard   (mfile, box^.width, 1);
          WriteString (mfile, "),");
          WriteLn (mfile);

          WriteString (mfile, "               ComputeY (");
          WriteCard   (mfile, box^.height, 1);
          WriteString (mfile, "),");
          WriteLn (mfile);

          WriteString (mfile, "               bevelTagPtr);");
          WriteLn (mfile)

        ELSE
          WriteString (mfile, "               offx + ");
          WriteCard   (mfile, box^.left - bleft, 1);
          WriteString (mfile, ",");
          WriteLn (mfile);

          WriteString (mfile, "               offy + ");
          WriteCard   (mfile, box^.top - btop, 1);
          WriteString (mfile, ",");
          WriteLn (mfile);

          WriteString (mfile, "               ");
          WriteCard   (mfile, box^.width, 1);
          WriteString (mfile, ",");
          WriteLn (mfile);

          WriteString (mfile, "               ");
          WriteCard   (mfile, box^.height, 1);
          WriteString (mfile, ", bevelTagPtr);");
          WriteLn (mfile)
          END
        END;


      IF dropBox IN box^.flags THEN
        WriteString (mfile, "bevelTagPtr := TAG (bevelTags,");
        WriteLn (mfile);

        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtVisualInfo,");
        WriteFill   (mfile, "", 11);
        WriteString (mfile, "VisualInfo,");
        WriteLn (mfile);

        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtbbRecessed,");
        WriteFill   (mfile, "", 13);
        WriteString (mfile, "TRUE,");
        WriteLn (mfile);

        WriteString (mfile, "\t\t");
        WriteString (mfile, "tagEnd);");
        WriteLn (mfile);


        WriteString (mfile, "DrawBevelBoxA (");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Window^.rPort,");
        WriteLn (mfile);

        IF FontAdapt IN MainConfig.configFlags0 THEN
          WriteString (mfile, "               OffX + ComputeX (");
          WriteCard   (mfile, box^.left - bleft + 4, 1);
          WriteString (mfile, "),");
          WriteLn (mfile);

          WriteString (mfile, "               OffY + ComputeY (");
          WriteCard   (mfile, box^.top - btop + 2, 1);
          WriteString (mfile, "),");
          WriteLn (mfile);

          WriteString (mfile, "               ComputeX (");
          WriteCard   (mfile, box^.width - 8, 1);
          WriteString (mfile, "),");
          WriteLn (mfile);

          WriteString (mfile, "               ComputeY (");
          WriteCard   (mfile, box^.height - 4, 1);
          WriteString (mfile, "),");
          WriteLn (mfile)

        ELSE
          WriteString (mfile, "               offx + ");
          WriteCard   (mfile, box^.left - bleft + 4, 1);
          WriteString (mfile, ",");

          WriteString (mfile, "               offy + ");
          WriteCard   (mfile, box^.top - btop + 2, 1);
          WriteString (mfile, ",");
          WriteLn (mfile);

          WriteString (mfile, "               ");
          WriteCard (mfile, box^.width - 8, 1);
          WriteString (mfile, ",");
          WriteLn (mfile);

          WriteString (mfile, "               ");
          WriteCard   (mfile, box^.height - 4, 1);
          WriteString (mfile, ",")
          END;

        WriteString (mfile, "               bevelTagPtr);");
        WriteLn (mfile);
        WriteLn (mfile)
        END;

      box := box^.succ
      END;
    WriteLn (mfile);
    END;



  IF pw^.windowText # NIL THEN
    IF FontAdapt IN MainConfig.configFlags0 THEN
      WriteLn (mfile);
      WriteString (mfile, "PrintIText (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Window^.rPort, ADR (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "IText), 0, 0);");
      WriteLn (mfile)

    ELSE
      WriteLn (mfile);
      WriteString (mfile, "PrintIText (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Window^.rPort, ADR (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "IText), offx, offy);");
      WriteLn (mfile)
      END;
    WriteLn (mfile)
    END;



  IF (pw^.boxes.head^.succ # NIL) OR
     (pw^.windowText # NIL) THEN
    WriteString (mfile, "IF NOT (firstRender) THEN");
    WriteLn (mfile)
    END;

  WriteString (mfile, "  GTEndRefresh (");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window, TRUE)");
  WriteLn (mfile);


  IF (args.raster) AND
     (pw^.boxes.head^.succ # NIL) AND
     (pw^.gadgets.head^.succ # NIL) THEN
    WriteString (mfile, "  END;");
    WriteLn (mfile);

    WriteLn (mfile);
    WriteString (mfile, "dummy := AddGList (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window, ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "GadgetList, -1, -1, NIL);");
    WriteLn (mfile);

    WriteString (mfile, "RefreshGList (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "GadgetList, ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window, NIL, -1);");
    WriteLn (mfile);

    WriteString (mfile, "GTRefreshWindow (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window, NIL);");
    WriteLn (mfile)

  ELSE
    WriteString (mfile, "ELSE");
    WriteLn (mfile);

    WriteString (mfile, "  GTRefreshWindow (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window, NIL);");
    WriteLn (mfile);

    WriteString (mfile, "  END");
    WriteLn (mfile)
    END;


  WriteString (mfile, "END Render");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window;");
  WriteLn (mfile);
  WriteLn (mfile)
  END WriteWindowRender;



  PROCEDURE WriteWindowRefresh		(    pw			:ProjectWindowPtr);

  BEGIN
  WriteLn (dfile);
  WriteString (dfile, "PROCEDURE Refresh");
  WriteString (dfile, pw^.name);
  WriteString (dfile, "Window;");
  WriteLn (dfile);
  WriteLn (dfile);


  WriteLn (mfile);
  WriteString (mfile, "PROCEDURE Refresh");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window;");
  WriteLn (mfile);
  WriteLn (mfile);



  WriteString (mfile, "BEGIN");
  WriteLn (mfile);

  WriteString (mfile, "Render");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window (FALSE);");
  WriteLn (mfile);

  WriteString (mfile, "END Refresh");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window;");
  WriteLn (mfile);
  WriteLn (mfile)
  END WriteWindowRefresh;



  PROCEDURE WriteWindowFree		(    pw			:ProjectWindowPtr);

  BEGIN
  WriteLn (dfile);
  WriteString (dfile, "PROCEDURE Free");
  WriteString (dfile, pw^.name);
  WriteString (dfile, "Window;");
  WriteLn (dfile);
  WriteLn (dfile);


  WriteLn (mfile);
  WriteString (mfile, "PROCEDURE Free");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window;");
  WriteLn (mfile);
  WriteLn (mfile);


  WriteString (mfile, "BEGIN");
  WriteLn (mfile);

  IF pw^.menus.head^.succ # NIL THEN
    WriteString (mfile, "IF ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "MenuStrip # NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "  IF ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window # NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "    ClearMenuStrip (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Window)");
    WriteLn (mfile);

    WriteString (mfile, "    END;");
    WriteLn (mfile);

    WriteString (mfile, "  FreeMenus (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "MenuStrip);");
    WriteLn (mfile);

    WriteString (mfile, "  ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "MenuStrip := NIL;");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile);
    WriteLn (mfile)
    END;


  WriteString (mfile, "IF ");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window # NIL THEN");
  WriteLn (mfile);

  WriteString (mfile, "  CloseWindow (");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window);");
  WriteLn (mfile);

  WriteString (mfile, "  ");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window := NIL;");
  WriteLn (mfile);

  WriteString (mfile, "  END;");
  WriteLn (mfile);


  IF pw^.gadgets.head^.succ # NIL THEN
    WriteLn (mfile);
    WriteString (mfile, "IF ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "GadgetList # NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "  FreeGadgets (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "GadgetList);");
    WriteLn (mfile);

    WriteString (mfile, "  ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "GadgetList := NIL;");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile)
    END;


  IF (FontAdapt IN MainConfig.configFlags0) AND
     (gcSysFont IN CConfig) THEN
    WriteString (mfile, "IF ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Font # NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "  CloseFont (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Font);");
    WriteLn (mfile);

    WriteString (mfile, "  ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Font := NIL;");

    WriteString (mfile, "  END;");
    WriteLn (mfile)
    END;


  WriteString (mfile, "END Free");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Window;");
  WriteLn (mfile);
  WriteLn (mfile)
  END WriteWindowFree;


(* WriteWindowProcs *)
BEGIN
WriteWindowRender  (pw);
WriteWindowRefresh (pw);
WriteWindowCreate  (pw);
WriteWindowFree    (pw)
END WriteWindowProcs;



PROCEDURE WriteWindowExit		(    pw			:ProjectWindowPtr);

BEGIN
WriteString (mfile, "Free");
WriteString (mfile, pw^.name);
WriteString (mfile, "Window;");
WriteLn (mfile)
END WriteWindowExit;



(* GenerateWindows *)
BEGIN
InitIDCMPText
END GenerateWindows.
