IMPLEMENTATION MODULE GenerateGadgets;

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

FROM	SYSTEM			IMPORT	ADDRESS,
					ADR, CAST;
FROM	String			IMPORT	Length, FirstPos,
					Copy, Concat;
FROM	Conversions		IMPORT	ValToStr;
FROM	FileMessage		IMPORT	StrPtr;
FROM	ExecD			IMPORT	ListPtr, NodePtr;
FROM	IntuitionD		IMPORT	WaTags, GaTags, StringaTags,
					LayoutaTags, PgaTags,
					ActivationFlags, ActivationFlagSet,
					PropInfoFlags, PropInfoFlagSet;
FROM	GadToolsD		IMPORT	genericKind, buttonKind, checkboxKind,
					integerKind, listviewKind, mxKind, numberKind,
					cycleKind, paletteKind, scrollerKind,
					sliderKind, stringKind, textKind, numKinds,
					GtTags,
					NewGadgetFlags, NewGadgetFlagSet;
FROM	UtilityD		IMPORT	Tag,
					tagEnd,
					TagItem, TagItemPtr;
FROM	UtilityL		IMPORT	GetTagData;
FROM	FileOut			IMPORT	Write, WriteString, WriteLn,
					WriteCard, WriteInt;
FROM	GadToolsBox		IMPORT	maxWindowName,
					maxGadgetLabel, maxFontName,
					GadgetFlags, GadgetFlagSet,
					GuiFlags, GuiFlagSet,
					GenCFlags,
					GTConfigFlags, WindowTagFlags,
					ExtNewGadgetPtr, ProjectWindowPtr,
					TagInArray, CountNodes;
FROM	GeneratorIO		IMPORT	dfile, mfile, args,
					Gui, MainConfig, CConfig, Projects,
					WriteFill, SeekBack, WriteText;


CONST	reservedKind		=10;

TYPE	LabelArray		=ARRAY CARDINAL OF StrPtr;
  	LabelPtr		=POINTER TO LabelArray;




PROCEDURE WritePlaceFlags		(    flags		:NewGadgetFlagSet);

BEGIN
IF flags = NewGadgetFlagSet {} THEN
  WriteString (mfile, "NewGadgetFlagSet {}")

ELSE
  WriteString (mfile, "NewGadgetFlagSet {");

  IF    placetextLeft IN flags THEN
    WriteString (mfile, "placetextLeft, ")
  ELSIF placetextRight IN flags THEN
    WriteString (mfile, "placetextRight, ")
  ELSIF placetextAbove IN flags THEN
    WriteString (mfile, "placetextAbove, ")
  ELSIF placetextBelow IN flags THEN
    WriteString (mfile, "placetextBelow, ")
  ELSIF placetextIn IN flags THEN
    WriteString (mfile, "placetextIn, ")
    END;

  IF ngHighlabel IN flags THEN
    WriteString (mfile, "ngHighlabel, ")
    END;

  SeekBack (mfile, 2);
  WriteString (mfile, "}")
  END
END WritePlaceFlags;



PROCEDURE WriteGadgetConsts		(    pw			:ProjectWindowPtr);


  PROCEDURE WriteGadgetIDs		(    pw			:ProjectWindowPtr);

  VAR	eng			:ExtNewGadgetPtr;
  	id			:CARDINAL;
  	offset			:INTEGER;

  BEGIN
  IF pw^.gadgets.head^.succ # NIL THEN
    offset := Length (pw^.name) + 8;
    id := 1;

    eng := pw^.gadgets.head;
    WHILE eng^.succ # NIL DO
      WriteString (dfile, "\t");
      WriteString (dfile, pw^.name);
      WriteString (dfile, "Gadget");
      WriteString (dfile, eng^.gadgetLabel);
      WriteString (dfile, "ID");
      WriteFill   (dfile, eng^.gadgetLabel, offset);
      WriteString (dfile, "=");
      WriteCard   (dfile, id, 3);
      Write       (dfile, ";");
      WriteLn (dfile);

      eng := eng^.succ;
      INC (id)
      END;

    WriteLn (dfile)
    END
  END WriteGadgetIDs;


(* WriteGadgetConsts *)
BEGIN
WriteGadgetIDs (pw)
END WriteGadgetConsts;



PROCEDURE WriteGadgetDefs		(    pw			:ProjectWindowPtr);


  PROCEDURE WriteNewGadgetsDef		(    pw			:ProjectWindowPtr);

  VAR	numGadgets		:CARDINAL;
  	eng			:ExtNewGadgetPtr;

  BEGIN
  numGadgets := CountNodes (ADR (pw^.gadgets));

  IF 0 < numGadgets THEN
    WriteString (dfile, "\t");
    WriteString (dfile, pw^.name);
    WriteString (dfile, "GadgetList");
    WriteFill   (dfile, pw^.name, 10);
    WriteString (dfile, ":GadgetPtr;");
    WriteLn (dfile);

    WriteString (dfile, "\t");
    WriteString (dfile, pw^.name);
    WriteString (dfile, "Gadgets");
    WriteFill   (dfile, pw^.name, 7);
    WriteString (dfile, ":ARRAY [1..");
    WriteCard   (dfile, numGadgets, 2);
    WriteString (dfile, "] OF GadgetPtr;");
    WriteLn (dfile);

    WriteString (mfile, "\t");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "NewGadgets");
    WriteFill   (mfile, pw^.name, 10);
    WriteString (mfile, ":ARRAY [1..");
    WriteCard   (mfile, numGadgets, 2);
    WriteString (mfile, "] OF NewGadget;");
    WriteLn (mfile)
    END
  END WriteNewGadgetsDef;



  PROCEDURE WriteGadgetLabelDefs	(    pw			:ProjectWindowPtr);

  VAR	eng			:ExtNewGadgetPtr;
  	labels			:LabelPtr;
  	number			:CARDINAL;
  	offset			:INTEGER;

  BEGIN
  offset := Length (pw^.name) + 12;

  eng := pw^.gadgets.head;
  WHILE eng^.succ # NIL DO
    IF (eng^.kind = cycleKind) OR (eng^.kind = mxKind) THEN
      IF eng^.kind = cycleKind THEN
        labels := LabelPtr (GetTagData (Tag (gtcyLabels), NIL, eng^.tags))
      ELSE
        labels := LabelPtr (GetTagData (Tag (gtmxLabels), NIL, eng^.tags))
        END;

      number := 0;
      WHILE labels^[number] # NIL DO
        INC (number)
        END;

      WriteString (mfile, "\t");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Gadget");
      WriteString (mfile, eng^.gadgetLabel);
      WriteString (mfile, "Labels");
      WriteFill   (mfile, eng^.gadgetLabel, offset);
      WriteString (mfile, ":ARRAY [0..");
      WriteCard   (mfile, number, 2);
      WriteString (mfile, "] OF StrPtr;");
      WriteLn (mfile);
      END;

    eng := eng^.succ
    END
  END WriteGadgetLabelDefs;



  PROCEDURE WriteGadgetListDefs		(    pw			:ProjectWindowPtr);

  VAR	eng			:ExtNewGadgetPtr;
  	list			:ListPtr;
  	number			:CARDINAL;
  	offset			:INTEGER;

  BEGIN
  offset := Length (pw^.name);

  eng := pw^.gadgets.head;
  WHILE eng^.succ # NIL DO
    IF eng^.kind = listviewKind THEN
      list := ListPtr (GetTagData (Tag (gtlvLabels), NIL, eng^.tags));

      IF list # NIL THEN
        WriteString (mfile, "\t");
        WriteString (mfile, pw^.name);
        WriteString (mfile, "Gadget");
        WriteString (mfile, eng^.gadgetLabel);
        WriteString (mfile, "List");
        WriteFill   (mfile, eng^.gadgetLabel, offset+10);
        WriteString (mfile, ":List;");
        WriteLn (mfile);

        IF list^.head^.succ # NIL THEN
          WriteString (mfile, "\t");
          WriteString (mfile, pw^.name);
          WriteString (mfile, "Gadget");
          WriteString (mfile, eng^.gadgetLabel);
          WriteString (mfile, "Nodes");
          WriteFill   (mfile, eng^.gadgetLabel, offset+11);
          WriteString (mfile, ":ARRAY [1..");
          WriteCard   (mfile, CountNodes (list), 2);
          WriteString (mfile, "] OF Node;");
          WriteLn (mfile)
          END
        END
      END;

    eng := eng^.succ
    END
  END WriteGadgetListDefs;



(* WriteGadgetDefs *)
BEGIN
WriteNewGadgetsDef   (pw);
WriteGadgetLabelDefs (pw);
WriteGadgetListDefs  (pw)
END WriteGadgetDefs;



PROCEDURE WriteGadgetProcs		(    pw			:ProjectWindowPtr);


  PROCEDURE WriteGadgetInit		(    pw			:ProjectWindowPtr);

  VAR	eng			:ExtNewGadgetPtr;
  	numGadget		:CARDINAL;



    PROCEDURE WriteGadgetLabelInit	(    eng		:ExtNewGadgetPtr;
    					     projectName	:ARRAY OF CHAR);

    VAR	labels			:LabelPtr;
    	number			:CARDINAL;

    BEGIN
    IF eng^.kind = cycleKind THEN
      labels := LabelPtr (GetTagData (Tag (gtcyLabels), NIL, eng^.tags))
    ELSE
      labels := LabelPtr (GetTagData (Tag (gtmxLabels), NIL, eng^.tags))
      END;

    WriteString (mfile, "dummy := TAG (");
    WriteString (mfile, projectName);
    WriteString (mfile, "Gadget");
    WriteString (mfile, eng^.gadgetLabel);
    WriteString (mfile, "Labels,");
    WriteLn (mfile);

    number := 0;
    WHILE labels^[number] # NIL DO
      WriteString (mfile, "              ADR ('");
      WriteText   (mfile, labels^[number]^);
      WriteString (mfile, "'),");
      WriteLn (mfile);

      INC (number)
      END;

    WriteString (mfile, "              NIL);");
    WriteLn (mfile);
    WriteLn (mfile)
    END WriteGadgetLabelInit;



    PROCEDURE WriteGadgetListInit	(    eng		:ExtNewGadgetPtr;
    					     projectName	:ARRAY OF CHAR);

    VAR	varListName		:ARRAY [0..maxWindowName+maxGadgetLabel+10] OF CHAR;
    	varNodeName		:ARRAY [0..maxWindowName+maxGadgetLabel+11] OF CHAR;
    	list			:ListPtr;
    	node			:NodePtr;
    	i, nodeNumber		:CARDINAL;


    BEGIN
    Copy   (varListName, projectName);
    Concat (varListName, "Gadget");
    Concat (varListName, eng^.gadgetLabel);
    Concat (varListName, "List");

    Copy   (varNodeName, projectName);
    Concat (varNodeName, "Gadget");
    Concat (varNodeName, eng^.gadgetLabel);
    Concat (varNodeName, "Nodes");


    list := ListPtr (GetTagData (Tag (gtlvLabels), NIL, eng^.tags));

    WriteString (mfile, "WITH ");
    WriteString (mfile, varListName);
    WriteString (mfile, " DO");
    WriteLn (mfile);

    node := list^.head;
    IF node^.succ = NIL THEN
      WriteString (mfile, "  head     := ADR (");
      WriteString (mfile, varListName);
      WriteString (mfile, ".tail);");
      WriteLn (mfile);

      WriteString (mfile, "  tail     := NIL;");
      WriteLn (mfile);

      WriteString (mfile, "  tailPred := ADR (");
      WriteString (mfile, varListName);
      WriteString (mfile, ".head);");
      WriteLn (mfile);

    ELSE
      nodeNumber := CountNodes (list);

      WriteString (mfile, "  head     := ADR (");
      WriteString (mfile, varNodeName);
      WriteString (mfile, "[ 1]);");
      WriteLn (mfile);

      WriteString (mfile, "  tail     := NIL;");
      WriteLn (mfile);

      WriteString (mfile, "  tailPred := ADR (");
      WriteString (mfile, varNodeName);
      Write       (mfile, "[");
      WriteCard   (mfile, nodeNumber, 2);
      WriteString (mfile, "]);");
      WriteLn (mfile);
      END;

    WriteString (mfile, "  type     := unknown");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile);
    WriteLn (mfile);


    FOR i := 1 TO nodeNumber DO
      WriteString (mfile, "WITH ");
      WriteString (mfile, varNodeName);
      Write       (mfile, "[");
      WriteCard   (mfile, i, 2);
      WriteString (mfile, "] DO");
      WriteLn (mfile);

      WriteString (mfile, "  succ := ADR (");
      IF i = nodeNumber THEN
        WriteString (mfile, varListName);
        WriteString (mfile, ".tail);")
      ELSE
        WriteString (mfile, varNodeName);
        Write       (mfile, "[");
        WriteCard   (mfile, i+1, 2);
        WriteString (mfile, "]);")
        END;
      WriteLn (mfile);

      WriteString (mfile, "  pred := ADR (");
      IF i = 1 THEN
        WriteString (mfile, varListName);
        WriteString (mfile, ".head);")
      ELSE
        WriteString (mfile, varNodeName);
        Write       (mfile, "[");
        WriteCard   (mfile, i-1, 2);
        WriteString (mfile, "]);")
        END;
      WriteLn (mfile);

      WriteString (mfile, "  type := unknown;");
      WriteLn (mfile);

      WriteString (mfile, "  pri  := 0;");
      WriteLn (mfile);

      WriteString (mfile, "  name := ADR ('");
      WriteText   (mfile, StrPtr (node^.name)^);
      WriteString (mfile, "');");
      WriteLn (mfile);

      WriteString (mfile, "  END;");
      WriteLn (mfile);

      node := node^.succ
      END;
    WriteLn (mfile)
    END WriteGadgetListInit;



    PROCEDURE WriteNewGadgetInit	(    eng		:ExtNewGadgetPtr;
    					     pw			:ProjectWindowPtr;
    					     numGadget		:CARDINAL);

    BEGIN
    WriteString (mfile, "WITH ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "NewGadgets[");
    WriteCard   (mfile, numGadget, 2);
    WriteString (mfile, "] DO");
    WriteLn (mfile);


    WriteString (mfile, "  leftEdge   := ");
    WriteInt    (mfile, eng^.newGadget.leftEdge - INTEGER (pw^.leftBorder), 3);
    Write       (mfile, ";");
    WriteLn (mfile);

    WriteString (mfile, "  topEdge    := ");
    WriteInt    (mfile, eng^.newGadget.topEdge - INTEGER (pw^.topBorder), 3);
    Write       (mfile, ";");
    WriteLn (mfile);

    WriteString (mfile, "  width      := ");
    WriteInt    (mfile, eng^.newGadget.width, 3);
    Write       (mfile, ";");
    WriteLn (mfile);

    WriteString (mfile, "  height     := ");
    WriteInt    (mfile, eng^.newGadget.height, 3);
    Write       (mfile, ";");
    WriteLn (mfile);

    WriteString (mfile, "  gadgetText := ");
    IF 0 < Length (eng^.gadgetText) THEN
      WriteString (mfile, "ADR ('");
      WriteText   (mfile, eng^.gadgetText);
      WriteString (mfile, "');")
    ELSE
      WriteString (mfile, "NIL;");
      END;
    WriteLn (mfile);

    WriteString (mfile, "  textAttr   := NIL;");
    WriteLn (mfile);

    WriteString (mfile, "  gadgetID   := ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Gadget");
    WriteString (mfile, eng^.gadgetLabel);
    WriteString (mfile, "ID;");
    WriteLn (mfile);

    WriteString (mfile, "  flags      := ");
    WritePlaceFlags (eng^.newGadget.flags);
    Write       (mfile, ";");
    WriteLn (mfile);

    WriteString (mfile, "  visualInfo := NIL;");
    WriteLn (mfile);

    WriteString (mfile, "  userData   := NIL;");
    WriteLn (mfile);


    WriteString (mfile, "  END;");
    WriteLn (mfile)
    END WriteNewGadgetInit;



  (* WriteGadgetInit *)
  BEGIN
  eng := pw^.gadgets.head;
  IF eng^.succ # NIL THEN
    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE Init");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Gadgets;");
    WriteLn (mfile);
    WriteLn (mfile);

    WriteString (mfile, "VAR");
    Write       (mfile, "\t");

    WriteString (mfile, "dummy");
    WriteFill   (mfile, "", 5);
    WriteString (mfile, ":ADDRESS;");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "BEGIN");
    WriteLn (mfile);

    numGadget := 1;
    WHILE eng^.succ # NIL DO
      WriteString (mfile, "(* ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Gadget");
      WriteString (mfile, eng^.gadgetLabel);
      WriteString (mfile, " *)");
      WriteLn (mfile);

      CASE eng^.kind OF
      | cycleKind:
        IF LabelPtr(GetTagData (Tag (gtcyLabels), NIL, eng^.tags)) # NIL THEN
          WriteGadgetLabelInit (eng, pw^.name)
          END;

      | mxKind:
        IF LabelPtr (GetTagData (Tag (gtmxLabels), NIL, eng^.tags)) # NIL THEN
          WriteGadgetLabelInit (eng, pw^.name)
          END;

      | listviewKind:
        IF LabelPtr (GetTagData (Tag (gtlvLabels), NIL, eng^.tags)) # NIL THEN
          WriteGadgetListInit (eng, pw^.name)
          END;

      ELSE
        END;

      WriteNewGadgetInit (eng, pw, numGadget);

      eng := eng^.succ;
      INC (numGadget);

      IF eng^.succ # NIL THEN
        WriteLn (mfile);
        WriteLn (mfile)
        END
      END;

    WriteString (mfile, "END Init");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Gadgets;");
    WriteLn (mfile);
    WriteLn (mfile)
    END
  END WriteGadgetInit;



  PROCEDURE WriteGadgetCreate		(    pw			:ProjectWindowPtr);


    PROCEDURE WriteCreateGadBody	(    pw			:ProjectWindowPtr);

    VAR	ok		:BOOLEAN;
    	i		:INTEGER;
    	numGadget,
  	btop, bleft	:CARDINAL;
    	eng		:ExtNewGadgetPtr;
    	fontName	:ARRAY [0..maxFontName] OF CHAR;
    	fontSize	:ARRAY [0..5] OF CHAR;



      PROCEDURE WriteGadgetTags		(    eng		:ExtNewGadgetPtr;
      					     projectName	:ARRAY OF CHAR);

      VAR	activation	:ActivationFlagSet;
	      	i		:CARDINAL;
	      	list		:ListPtr;



        PROCEDURE WriteCheckboxTags;

        BEGIN
        IF TagInArray (Tag (gtcbChecked), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtcbChecked,");
          WriteFill   (mfile, "", 12);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END
        END WriteCheckboxTags;


        PROCEDURE WriteCycleTags;

        BEGIN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtcyLabels,");
        WriteFill   (mfile, "", 11);
        WriteString (mfile, "ADR (");
        WriteString (mfile, projectName);
        WriteString (mfile, "Gadget");
        WriteString (mfile, eng^.gadgetLabel);
        WriteString (mfile, "Labels),");
        WriteLn (mfile);

        IF TagInArray (Tag (gtcyActive), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtcyActive,");
          WriteFill   (mfile, "", 11);
          WriteCard   (mfile, GetTagData (Tag (gtcyActive), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END
        END WriteCycleTags;


        PROCEDURE WriteIntegerTags;

        BEGIN
        IF TagInArray (Tag (gaTabCycle), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gaTabCycle,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "FALSE,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (stringaExitHelp), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "stringaExitHelp,");
          WriteFill   (mfile, "", 16);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END;

        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtinNumber,");
        WriteFill   (mfile, "", 11);
        WriteInt    (mfile, GetTagData (Tag (gtinNumber), 0, eng^.tags), 2);
        Write       (mfile, ",");
        WriteLn (mfile);

        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtinMaxChars,");
        WriteFill   (mfile, "", 13);
        WriteCard   (mfile, GetTagData (Tag (gtinMaxChars), 0, eng^.tags), 2);
        Write       (mfile, ",");
        WriteLn (mfile);

        i := GetTagData (Tag (stringaJustification), 0, eng^.tags);
        activation := CAST (ActivationFlagSet, i);
        IF activation # ActivationFlagSet {} THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "stringaJustification,");
          WriteFill   (mfile, "", 21);
          IF stringCenter IN activation THEN
            WriteString (mfile, "ActivationFlagSet {stringCenter},")
          ELSE
            WriteString (mfile, "ActivationFlagSet {stringRight},")
            END;
          WriteLn (mfile)
          END
        END WriteIntegerTags;


        PROCEDURE WriteListviewTags;


        BEGIN
        list := ListPtr (GetTagData (Tag (gtlvLabels), NIL, eng^.tags));
        IF (list # NIL) AND (list^.head^.succ # NIL) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtlvLabels,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "ADR (");
          WriteString (mfile, projectName);
          WriteString (mfile, "Gadget");
          WriteString (mfile, eng^.gadgetLabel);
          WriteString (mfile, "List),");
          WriteLn (mfile)
          END;

        IF NeedLock IN eng^.flags THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtlvShowSelected,");
          WriteFill   (mfile, "", 17);
          WriteString (mfile, "gad,");			(* the previous gadget MUST be the	*)
          WriteLn (mfile)				(* string gadget which should attached!	*)
        ELSIF TagInArray (Tag (gtlvShowSelected), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtlvShowSelected,");
          WriteFill   (mfile, "", 17);
          WriteString (mfile, "NIL,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtlvScrollWidth), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtlvScrollWidth,");
          WriteFill   (mfile, "", 17);
          WriteInt    (mfile, GetTagData (Tag (gtlvScrollWidth), 0, eng^.tags), 3);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtlvReadOnly), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtlvReadOnly,");
          WriteFill   (mfile, "", 13);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (layoutaSpacing), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "layoutaSpacing,");
          WriteFill   (mfile, "", 15);
          WriteInt    (mfile, GetTagData (Tag (layoutaSpacing), 0, eng^.tags), 3);
          Write       (mfile, ",");
          WriteLn (mfile)
          END
        END WriteListviewTags;


        PROCEDURE WriteMxTags;

        BEGIN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtmxLabels,");
        WriteFill   (mfile, "", 11);
        WriteString (mfile, "ADR (");
        WriteString (mfile, projectName);
        WriteString (mfile, "Gadget");
        WriteString (mfile, eng^.gadgetLabel);
        WriteString (mfile, "Labels),");
        WriteLn (mfile);

        IF TagInArray (Tag (gtmxSpacing), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtmxSpacing,");
          WriteFill   (mfile, "", 12);
          WriteInt    (mfile, GetTagData (Tag (gtmxSpacing), 0, eng^.tags), 3);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtmxActive), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtmxActive,");
          WriteFill   (mfile, "", 11);
          WriteCard   (mfile, GetTagData (Tag (gtmxActive), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END
        END WriteMxTags;


        PROCEDURE WritePaletteTags;

        BEGIN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtpaDepth,");
        WriteFill   (mfile, "", 10);
        WriteCard   (mfile, GetTagData (Tag (gtpaDepth), 1, eng^.tags), 2);
        Write       (mfile, ",");
        WriteLn (mfile);

        IF TagInArray (Tag (gtpaIndicatorWidth), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtpaIndicatorWidth,");
          WriteFill   (mfile, "", 19);
          WriteCard   (mfile, GetTagData (Tag (gtpaIndicatorWidth), 5, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtpaIndicatorHeight), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtpaIndicatorHeight,");
          WriteFill   (mfile, "", 20);
          WriteCard   (mfile, GetTagData (Tag (gtpaIndicatorHeight), 5, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtpaColor), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtpaColor,");
          WriteFill   (mfile, "", 10);
          WriteCard   (mfile, GetTagData (Tag (gtpaColor), 1, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtpaColorOffset), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtpaColorOffset,");
          WriteFill   (mfile, "", 16);
          WriteCard   (mfile, GetTagData (Tag (gtpaColorOffset), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END
        END WritePaletteTags;


        PROCEDURE WriteScrollerTags;

        BEGIN
        IF TagInArray (Tag (gtscTop), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtscTop,");
          WriteFill   (mfile, "", 8);
          WriteCard   (mfile, GetTagData (Tag (gtscTop), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtscTotal), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtscTotal,");
          WriteFill   (mfile, "", 10);
          WriteCard   (mfile, GetTagData (Tag (gtscTotal), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtscVisible), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtscVisible,");
          WriteFill   (mfile, "", 12);
          WriteCard   (mfile, GetTagData (Tag (gtscVisible), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtscArrows), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtscArrows,");
          WriteFill   (mfile, "", 11);
          WriteCard   (mfile, GetTagData (Tag (gtscArrows), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (pgaFreedom), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "pgaFreedom,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "freeVert,");
          WriteLn (mfile)
        ELSE
          WriteString (mfile, "\t\t");
          WriteString (mfile, "pgaFreedom,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "freeHoriz,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gaImmediate), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gaImmediate,");
          WriteFill   (mfile, "", 12);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gaRelVerify), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gaRelVerify,");
          WriteFill   (mfile, "", 12);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END
        END WriteScrollerTags;


        PROCEDURE WriteSliderTags;

        BEGIN
        IF TagInArray (Tag (gtslMin), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtslMin,");
          WriteFill   (mfile, "", 8);
          WriteCard   (mfile, GetTagData (Tag (gtslMin), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtslMax), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtslMax,");
          WriteFill   (mfile, "", 8);
          WriteCard   (mfile, GetTagData (Tag (gtslMax), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtslLevel), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtslLevel,");
          WriteFill   (mfile, "", 11);
          WriteCard   (mfile, GetTagData (Tag (gtslLevel), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtslLevelFormat), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtslLevelFormat,");
          WriteFill   (mfile, "", 17);
          WriteString (mfile, "ADR ('");
          WriteString (mfile, StrPtr (GetTagData (Tag (gtslLevelFormat), NIL, eng^.tags))^);
          WriteString (mfile, "'),");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtslMaxLevelLen), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtslMaxLevelLen,");
          WriteFill   (mfile, "", 17);
          WriteCard   (mfile, GetTagData (Tag (gtslMaxLevelLen), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtslLevelPlace), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtslLevelPlace,");
          WriteFill   (mfile, "", 15);
          WritePlaceFlags (CAST (NewGadgetFlagSet, GetTagData (Tag (gtslLevelPlace), 0, eng^.tags)));
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (pgaFreedom), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "pgaFreedom,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "freeVert,");
          WriteLn (mfile)
        ELSE
          WriteString (mfile, "\t\t");
          WriteString (mfile, "pgaFreedom,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "freeHoriz,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gaImmediate), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gaImmediate,");
          WriteFill   (mfile, "", 12);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gaRelVerify), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gaRelVerify,");
          WriteFill   (mfile, "", 12);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END
        END WriteSliderTags;


        PROCEDURE WriteStringTags;

        BEGIN
        IF TagInArray (Tag (gaTabCycle), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gaTabCycle,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "FALSE,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (stringaExitHelp), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "stringaExitHelp,");
          WriteFill   (mfile, "", 16);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtstString), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtstString,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "ADR ('");
          WriteText   (mfile, StrPtr (GetTagData (Tag (gtstString), NIL, eng^.tags))^);
          WriteString (mfile, "'),");
          WriteLn (mfile)
          END;


        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtstMaxChars,");
        WriteFill   (mfile, "", 13);
        WriteCard   (mfile, GetTagData (Tag (gtstMaxChars), 0, eng^.tags), 2);
        Write       (mfile, ",");
        WriteLn (mfile);

        i := GetTagData (Tag (stringaJustification), 0, eng^.tags);
        activation := CAST (ActivationFlagSet, i);
        IF activation # ActivationFlagSet {} THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "stringaJustification,");
          WriteFill   (mfile, "", 21);
          IF stringCenter IN activation THEN
            WriteString (mfile, "ActivationFlagSet {stringCenter},")
          ELSE
            WriteString (mfile, "ActivationFlagSet {stringRight},")
            END;
          WriteLn (mfile)
          END
        END WriteStringTags;


        PROCEDURE WriteNumberTags;

        BEGIN
        IF TagInArray (Tag (gtnmNumber), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtnmNumber,");
          WriteFill   (mfile, "", 11);
          WriteCard   (mfile, GetTagData (Tag (gtnmNumber), 0, eng^.tags), 2);
          Write       (mfile, ",");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gtnmBorder), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gtnmBorder,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END
        END WriteNumberTags;


        PROCEDURE WriteTextTags;

        BEGIN
        IF TagInArray (Tag (gttxText), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gttxText,");
          WriteFill   (mfile, "", 9);
          WriteString (mfile, "ADR ('");
          WriteText   (mfile, StrPtr (GetTagData (Tag (gttxText), NIL, eng^.tags))^);
          WriteString (mfile, "'),");
          WriteLn (mfile)
          END;


        IF TagInArray (Tag (gttxBorder), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gttxBorder,");
          WriteFill   (mfile, "", 11);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END;

        IF TagInArray (Tag (gttxCopyText), eng^.tags) THEN
          WriteString (mfile, "\t\t");
          WriteString (mfile, "gttxCopyText,");
          WriteFill   (mfile, "", 13);
          WriteString (mfile, "TRUE,");
          WriteLn (mfile)
          END
        END WriteTextTags;



      (* WriteGadgetTags *)
      BEGIN
      WriteString (mfile, "gadgetTagPtr := TAG (");
      WriteString (mfile, "gadgetTags,");
      WriteLn (mfile);

      CASE eng^.kind OF
      | checkboxKind:	WriteCheckboxTags
      | cycleKind:	WriteCycleTags
      | integerKind:	WriteIntegerTags
      | listviewKind:	WriteListviewTags
      | mxKind:		WriteMxTags
      | paletteKind:	WritePaletteTags
      | scrollerKind:	WriteScrollerTags
      | sliderKind:	WriteSliderTags
      | stringKind:	WriteStringTags
      | numberKind:	WriteNumberTags
      | textKind:	WriteTextTags
      ELSE
        END;

      IF (eng^.kind # genericKind) AND
         (TagInArray (Tag (gtUnderscore), eng^.tags)) THEN
        WriteString (mfile, "\t\t");
        WriteString (mfile, "gtUnderscore,");
        WriteFill   (mfile, "", 13);
        WriteString (mfile, "ORD ('_'),");
        WriteLn (mfile)
        END;

      WriteString (mfile, "\t\t");
      WriteString (mfile, "tagEnd);");
      WriteLn (mfile)
      END WriteGadgetTags;



    (* WriteCreateGadBody *)
    BEGIN
    btop := pw^.topBorder;
    bleft:= pw^.leftBorder;


    IF NOT (FontAdapt IN MainConfig.configFlags0) THEN
      Copy (fontName, Gui.fontName);
      i := FirstPos (fontName, 0, ".");
      IF i # -1 THEN
        fontName[i] := 0C
        END;
      ValToStr (Gui.font.ySize, FALSE, fontSize, 10, 1, " ", ok);
      Concat (fontName, fontSize);
      END;


    numGadget := 1;
    eng := pw^.gadgets.head;
    WHILE eng^.succ # NIL DO
      WriteLn (mfile);
      WriteString (mfile, "(* ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Gadget");
      WriteString (mfile, eng^.gadgetLabel);
      WriteString (mfile, " *)");
      WriteLn (mfile);


      WriteString (mfile, "ng := ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "NewGadgets[");
      WriteCard   (mfile, numGadget, 2);
      WriteString (mfile, "];");
      WriteLn (mfile);
      WriteLn (mfile);


      WriteString (mfile, "WITH ng DO");
      WriteLn (mfile);

      WriteString (mfile, "  visualInfo := VisualInfo;");
      WriteLn (mfile);

      IF FontAdapt IN MainConfig.configFlags0 THEN
        WriteString (mfile, "  textAttr   := Font;");
        WriteLn (mfile);

        WriteString (mfile, "  leftEdge   := OffX + ComputeX (leftEdge);");
        WriteLn (mfile);

        WriteString (mfile, "  topEdge    := OffY + ComputeY (topEdge);");
        WriteLn (mfile);

        IF eng^.kind # genericKind THEN
          WriteString (mfile, "  width      := ComputeX (width);");
          WriteLn (mfile);

          WriteString (mfile, "  height     := ComputeY (height);");
          WriteLn (mfile)
          END

      ELSE
        WriteString (mfile, "  textAttr   := ADR (");
        WriteString (mfile, fontName);
        WriteString (mfile, ");");
        WriteLn (mfile);

        WriteString (mfile, "  INC (leftEdge, offx);");
        WriteLn (mfile);

        WriteString (mfile, "  INC (topEdge,  offy);");
        WriteLn (mfile)
        END;

      WriteString (mfile, "  END;");
      WriteLn (mfile);
      WriteLn (mfile);


      WriteGadgetTags (eng, pw^.name);
      WriteLn (mfile);


      WriteString (mfile, "gad := CreateGadgetA (");
      CASE eng^.kind OF
      | genericKind:  WriteString (mfile, "genericKind")
      | buttonKind:   WriteString (mfile, "buttonKind")
      | checkboxKind: WriteString (mfile, "checkboxKind")
      | integerKind:  WriteString (mfile, "integerKind")
      | listviewKind: WriteString (mfile, "listviewKind")
      | mxKind:       WriteString (mfile, "mxKind")
      | numberKind:   WriteString (mfile, "numberKind")
      | cycleKind:    WriteString (mfile, "cycleKind")
      | paletteKind:  WriteString (mfile, "paletteKind")
      | scrollerKind: WriteString (mfile, "scrollerKind")
      | reservedKind: WriteString (mfile, "reservedKind")
      | sliderKind:   WriteString (mfile, "sliderKind")
      | stringKind:   WriteString (mfile, "stringKind")
      | textKind:     WriteString (mfile, "textKind")
        END;
      WriteString (mfile, ", gad^, ng, gadgetTagPtr);");
      WriteLn (mfile);


      WriteString (mfile, "IF gad = NIL THEN");
      WriteLn (mfile);

      WriteString (mfile, "  RETURN 2");
      WriteLn (mfile);

      WriteString (mfile, "  END;");
      WriteLn (mfile);
      WriteLn (mfile);

      WriteString (mfile, pw^.name);
      WriteString (mfile, "Gadgets[");
      WriteCard   (mfile, numGadget, 2);
      WriteString (mfile, "] := gad;");
      WriteLn (mfile);
      WriteLn (mfile);


      IF eng^.kind = genericKind THEN
        WriteString (mfile, "WITH gad^ DO");
        WriteLn (mfile);

        WriteString (mfile, "  flags := flags + GadgetFlagSet {gadgImage,gadgHImage};");
        WriteLn (mfile);

        WriteString (mfile, "  INCL (activation, relVerify);");
        WriteLn (mfile);

        WriteString (mfile, "  gadgetRender := GetImage;");
        WriteLn (mfile);

        WriteString (mfile, "  selectRender := GetImage");
        WriteLn (mfile);

        WriteString (mfile, "  END;");
        WriteLn (mfile)
        END;


      eng := eng^.succ;
      INC (numGadget)
      END
    END WriteCreateGadBody;



    PROCEDURE WriteCreateGadHead		(    pw			:ProjectWindowPtr);

    BEGIN
    WriteLn (dfile);
    WriteString (dfile, "PROCEDURE Create");
    WriteString (dfile, pw^.name);
    WriteString (dfile, "Gadgets () :CARDINAL;");
    WriteLn (dfile);
    WriteLn (dfile);

    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE Create");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Gadgets () :CARDINAL;");
    WriteLn (mfile);
    WriteLn (mfile);


    IF NOT (FontAdapt IN MainConfig.configFlags0) THEN
      WriteString (mfile, "CONST");


      WriteString (mfile, "\t");
      WriteString (mfile, "offx");
      WriteFill   (mfile, "", 4);
      WriteString (mfile, "= ");
      WriteCard   (mfile, pw^.leftBorder, 3);
      WriteString (mfile, ";");
      WriteLn (mfile);

      WriteString (mfile, "\t");
      WriteString (mfile, "offy");
      WriteFill   (mfile, "", 4);
      WriteString (mfile, "= ");
      WriteCard   (mfile, pw^.topBorder, 3);
      WriteString (mfile, ";");
      WriteLn (mfile);
      WriteLn (mfile)
      END;



    WriteString (mfile, "VAR");
    WriteString (mfile, "\t");
    WriteString (mfile, "ng");
    WriteFill   (mfile, "", 2);
    WriteString (mfile, ":NewGadget;");
    WriteLn (mfile);

    WriteString (mfile, "\t");
    WriteString (mfile, "gad");
    WriteFill   (mfile, "", 3);
    WriteString (mfile, ":GadgetPtr;");
    WriteLn (mfile);

    WriteString (mfile, "\t");
    WriteString (mfile, "gadgetTags");
    WriteFill   (mfile, "", 10);
    WriteString (mfile, ":ARRAY [1..30] OF TagItem;");
    WriteLn (mfile);

    WriteString (mfile, "\t");
    WriteString (mfile, "gadgetTagPtr");
    WriteFill   (mfile, "", 12);
    WriteString (mfile, ":TagItemPtr;");
    WriteLn (mfile);

    WriteString (mfile, "\t");
    WriteString (mfile, "ret");
    WriteFill   (mfile, "", 3);
    WriteString (mfile, ":CARDINAL;");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "BEGIN");
    WriteLn (mfile);

    WriteString (mfile, "Assert (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "GadgetList = NIL, ADR ('");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Gadgets are already created!'));");
    WriteLn (mfile);
    WriteLn (mfile);



    IF FontAdapt IN MainConfig.configFlags0 THEN
      WriteString (mfile, "ComputeFont (");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Width, ");
      WriteString (mfile, pw^.name);
      WriteString (mfile, "Height);");
      WriteLn (mfile)
      END;


    WriteString (mfile, "gad := CreateContext (");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "GadgetList);");
    WriteLn (mfile);

    WriteString (mfile, "IF gad = NIL THEN");
    WriteLn (mfile);

    WriteString (mfile, "  RETURN 1");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile);
    WriteLn (mfile)
    END WriteCreateGadHead;



    PROCEDURE WriteCreateGadTail		(    pw			:ProjectWindowPtr);

    BEGIN
    WriteLn (mfile);
    WriteString (mfile, "RETURN 0");
    WriteLn (mfile);

    WriteString (mfile, "END Create");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Gadgets;");
    WriteLn (mfile);
    WriteLn (mfile)
    END WriteCreateGadTail;



  (* WriteGadgetCreate *)
  BEGIN
  IF pw^.gadgets.head^.succ # NIL THEN
    WriteCreateGadHead (pw);
    WriteCreateGadBody (pw);
    WriteCreateGadTail (pw)
    END
  END WriteGadgetCreate;


(* WriteGadgetProcs *)
BEGIN
WriteGadgetInit   (pw);
WriteGadgetCreate (pw)
END WriteGadgetProcs;



PROCEDURE WriteGadgetInits	(    pw			:ProjectWindowPtr);

BEGIN
IF pw^.gadgets.head^.succ # NIL THEN
  WriteString (mfile, "Init");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Gadgets;");
  WriteLn (mfile)
  END
END WriteGadgetInits;



END GenerateGadgets.
