IMPLEMENTATION MODULE GenerateGlobal;

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

FROM	SYSTEM			IMPORT	ADR;
FROM	GraphicsD		IMPORT	RastPort,
					TextFontPtr;
FROM	GraphicsL		IMPORT	InitRastPort,
					SetFont, TextLength,
					CloseFont;
FROM	DiskFontL		IMPORT	OpenDiskFont;
FROM	GadToolsD		IMPORT	genericKind,
					GtTags;
FROM	FileOut			IMPORT	Write, WriteString, WriteLn,
					WriteCard, WriteInt;
FROM	GadToolsBox		IMPORT	GadgetFlags, GadgetFlagSet,
					GuiFlags, GuiFlagSet,
					GenCFlags,
					GTConfigFlags, WindowTagFlags,
					ExtNewGadgetPtr, ProjectWindowPtr;
FROM	GeneratorIO		IMPORT	dfile, mfile, args,
					Gui, MainConfig, CConfig, Projects,
					WriteFill, SeekBack;

PROCEDURE WriteGlobalDefs	(    GetFilePresent	:BOOLEAN);

BEGIN
IF GetFilePresent THEN
  WriteString (mfile, "\t");
  WriteString (mfile, "GetImage");
  WriteFill   (mfile, "", 8);
  WriteString (mfile, ":ObjectPtr;");
  WriteLn (mfile)
  END
END WriteGlobalDefs;



PROCEDURE WriteGlobalProcs;


  PROCEDURE WriteComputes;

  CONST	sampleText	="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  	maxSample	=62;

  VAR	xsize, ysize		:CARDINAL;
  	font			:TextFontPtr;
  	rastPort		:RastPort;

  BEGIN
  IF FontAdapt IN MainConfig.configFlags0 THEN
    font := OpenDiskFont (ADR (Gui.font));

    IF font = NIL THEN
      xsize := Gui.font.ySize
    ELSE
      InitRastPort (rastPort);
      SetFont (ADR (rastPort), font);

      xsize := TextLength (ADR (rastPort), ADR (sampleText), maxSample) DIV maxSample;

      CloseFont (font);
      END;

    ysize := Gui.font.ySize;



    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE ComputeX");
    WriteFill   (mfile, "", 10);
    WriteString (mfile, "(    value");
    WriteFill   (mfile, "", 9);
    WriteString (mfile, ":INTEGER) :INTEGER;");
    WriteLn (mfile);
    WriteLn (mfile);

    WriteString (mfile, "BEGIN");
    WriteLn (mfile);

    WriteString (mfile, "RETURN ((FontX * value) + ");
    WriteCard   (mfile, xsize DIV 2, 1);
    WriteString (mfile, ") DIV ");
    WriteCard   (mfile, xsize, 1);
    WriteLn (mfile);

    WriteString (mfile, "END ComputeX;");
    WriteLn (mfile);
    WriteLn (mfile);



    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE ComputeY");
    WriteFill   (mfile, "", 10);
    WriteString (mfile, "(    value");
    WriteFill   (mfile, "", 9);
    WriteString (mfile, ":INTEGER) :INTEGER;");
    WriteLn (mfile);
    WriteLn (mfile);

    WriteString (mfile, "BEGIN");
    WriteLn (mfile);

    WriteString (mfile, "RETURN ((FontY * value) + ");
    WriteCard   (mfile, ysize DIV 2, 1);
    WriteString (mfile, ") DIV ");
    WriteCard   (mfile, ysize, 1);
    WriteLn (mfile);

    WriteString (mfile, "END ComputeY;");
    WriteLn (mfile);
    WriteLn (mfile);



    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE ComputeFont");
    WriteFill   (mfile, "", 10);
    WriteString (mfile, "(    width, height");
    WriteFill   (mfile, "", 18);
    WriteString (mfile, ":CARDINAL);");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "BEGIN");
    WriteLn (mfile);

    WriteString (mfile, "Font := ADR (Attr);");
    WriteLn (mfile);
    WriteLn (mfile);


    IF gcSysFont IN CConfig THEN
      WriteString (mfile, "Forbid ();");
      WriteLn (mfile);

      WriteString (mfile, "Font^.name  := graphicsBase^.defaultFont^.message.node.name;");
      WriteLn (mfile);

      WriteString (mfile, "Font^.ySize := graphicsBase^.defaultFont^.ySize;");
      WriteLn (mfile);

      WriteString (mfile, "FontX := graphicsBase^.defaultFont^.xSize;");
      WriteLn (mfile);

      WriteString (mfile, "Permit ();");
      WriteLn (mfile);

      WriteString (mfile, "FontY := Font^.ySize;");
      WriteLn (mfile)

    ELSE
      WriteString (mfile, "Font^.name  := Screen^.rastPort.font^.message.node.name;");
      WriteLn (mfile);

      WriteString (mfile, "Font^.ySize := Screen^.rastPort.font^.ySize;");
      WriteLn (mfile);

      WriteString (mfile, "FontX := Screen^.rastPort.font^.xSize;");
      WriteLn (mfile);

      WriteString (mfile, "FontY := Font^.ySize;");
      WriteLn (mfile)
      END;
    WriteLn (mfile);


    WriteString (mfile, "OffX := Screen^.wBorLeft;");
    WriteLn (mfile);

    WriteString (mfile, "OffY := INTEGER (Screen^.rastPort.txHeight) + Screen^.wBorTop + 1;");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "IF (width # 0) AND (height # 0) AND");
    WriteLn (mfile);
    WriteString (mfile, "   ((Screen^.width < ComputeX (width) + OffX + Screen^.wBorRight) AND");
    WriteLn (mfile);
    WriteString (mfile, "    (Screen^.height < ComputeY (height) + OffY + Screen^.wBorBottom)) THEN");
    WriteLn (mfile);
    WriteString (mfile, "  Font^.name  := ADR ('topaz.font');");
    WriteLn (mfile);
    WriteString (mfile, "  Font^.ySize := 8;");
    WriteLn (mfile);
    WriteString (mfile, "  FontX := 8;");
    WriteLn (mfile);
    WriteString (mfile, "  FontY := 8");
    WriteLn (mfile);
    WriteString (mfile, "  END");
    WriteLn (mfile);


    WriteString (mfile, "END ComputeFont;");
    WriteLn (mfile);
    WriteLn (mfile)
    END
  END WriteComputes;



  PROCEDURE WriteDrawRast;

  BEGIN
  IF args.raster THEN
    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE DrawRast");
    WriteFill   (mfile, "", 10);
    WriteString (mfile, "(    window");
    WriteFill   (mfile, "", 11);
    WriteString (mfile, ":WindowPtr);");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "VAR");

    WriteString (mfile, "\t");
    WriteString (mfile, "backPattern");
    WriteFill   (mfile, "", 11);
    WriteString (mfile, ":LONGCARD;");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "BEGIN");
    WriteLn (mfile);

    WriteString (mfile, "backPattern := 0AAAA5555H;");
    WriteLn (mfile);
    WriteLn (mfile);

    WriteString (mfile, "WITH window^ DO");
    WriteLn (mfile);

    WriteString (mfile, "  SetAPen (rPort, 2);");
    WriteLn (mfile);

    WriteString (mfile, "  SetAfPen (rPort, ADR (backPattern), 1);");
    WriteLn (mfile);

    WriteString (mfile, "  RectFill (rPort,");
    WriteLn (mfile);

    WriteString (mfile, "            borderLeft, borderTop,");
    WriteLn (mfile);

    WriteString (mfile, "            width-borderRight-1, height-borderBottom-1);");
    WriteLn (mfile);

    WriteString (mfile, "  SetAfPen (rPort, NIL, 0)");
    WriteLn (mfile);

    WriteString (mfile, "  END");
    WriteLn (mfile);


    WriteString (mfile, "END DrawRast;");
    WriteLn (mfile);
    WriteLn (mfile)
    END
  END WriteDrawRast;



  PROCEDURE WriteFilledBBox;

  BEGIN
  IF args.raster THEN
    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE FilledBBox");
    WriteFill   (mfile, "", 12);
    WriteString (mfile, "(    vi");
    WriteFill   (mfile, "", 2);
    WriteString (mfile, ":ADDRESS;");
    WriteLn (mfile);

    WriteFill   (mfile, "", -8);
    WriteString (mfile, "     rp");
    WriteFill   (mfile, "", 2);
    WriteString (mfile, ":RastPortPtr;");
    WriteLn (mfile);

    WriteFill   (mfile, "", -8);
    WriteString (mfile, "     l, t, w, h");
    WriteFill   (mfile, "", 10);
    WriteString (mfile, ":INTEGER;");
    WriteLn (mfile);

    WriteFill   (mfile, "", -8);
    WriteString (mfile, "     recessed");
    WriteFill   (mfile, "", 8);
    WriteString (mfile, ":BOOLEAN);");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "VAR");

    WriteString (mfile, "\t");
    WriteString (mfile, "bevelTagPtr");
    WriteFill   (mfile, "", 11);
    WriteString (mfile, ":TagItemPtr;");
    WriteLn (mfile);

    WriteString (mfile, "\t");
    WriteString (mfile, "bevelTags");
    WriteFill   (mfile, "", 9);
    WriteString (mfile, ":ARRAY [0..2] OF TagItem;");
    WriteLn (mfile);
    WriteLn (mfile);


    WriteString (mfile, "BEGIN");
    WriteLn (mfile);

    WriteString (mfile, "IF recessed THEN");
    WriteLn (mfile);

    WriteString (mfile, "  bevelTagPtr := TAG (bevelTags,");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "gtVisualInfo,");
    WriteFill   (mfile, "", 13);
    WriteString (mfile, "vi,");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "gtbbRecessed,");
    WriteFill   (mfile, "", 13);
    WriteString (mfile, "TRUE,");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "tagEnd);");
    WriteLn (mfile);

    WriteString (mfile, "ELSE");
    WriteLn (mfile);

    WriteString (mfile, "  bevelTagPtr := TAG (bevelTags,");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "gtVisualInfo,");
    WriteFill   (mfile, "", 11);
    WriteString (mfile, "vi,");
    WriteLn (mfile);

    WriteString (mfile, "\t\t");
    WriteString (mfile, "tagEnd);");
    WriteLn (mfile);

    WriteString (mfile, "  END;");
    WriteLn (mfile);


    WriteString (mfile, "DrawBevelBoxA (rp, l,t, w,h, bevelTagPtr); ");
    WriteLn (mfile);

    WriteString (mfile, "SetAPen (rp, 0);");
    WriteLn (mfile);

    WriteString (mfile, "RectFill (rp, l+2,t+1, l+w-3,t+h-2);");
    WriteLn (mfile);

    WriteString (mfile, "SetAPen (rp, 1);");
    WriteLn (mfile);


    WriteString (mfile, "END FilledBBox;");
    WriteLn (mfile);
    WriteLn (mfile)
    END
  END WriteFilledBBox;


(* WriteGlobalProcs *)
BEGIN
WriteLn (mfile);
WriteComputes;
WriteDrawRast;
WriteFilledBBox
END WriteGlobalProcs;



END GenerateGlobal.

