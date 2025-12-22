MODULE GenModula;

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
 *	:Imports.	InOut, NewArgSupport, Memory by Reiner Nix
 *	:History.	this programm is a direct descendend from
 *	:History.	 OG (Oberon Generator) 37.11 by Thomas Igracki, Kai Bolay
 *	:History.	GenModula 1.10 (23.Aug.93)	;M2Amiga 4.0d
 *	:History.	GenModula 1.12 (28.Sep.93)	;M2Amiga 4.2d
 *	:History.	GenModula 1.14 (14.Jan.94)
 *
 * -------------------------------------------------------------------------
 *)



FROM	GadToolsD		IMPORT	genericKind;
FROM	FileOut			IMPORT	Write, WriteString, WriteLn,
					WriteCard, WriteInt;
FROM	GadToolsBox		IMPORT	GadgetFlags, GadgetFlagSet,
					GuiFlags, GuiFlagSet,
					GenCFlags,
					GTConfigFlags, WindowTagFlags,
					ExtNewGadgetPtr, ProjectWindowPtr;
IMPORT	InOut;
FROM	GeneratorIO		IMPORT	dfile, mfile, args,
					Gui, MainConfig, CConfig, Projects,
					WriteFill, SeekBack;
FROM	GenerateITexts		IMPORT	WriteITextsDefs,
					WriteITextsProcs, WriteITextsInits;
FROM	GenerateMenus		IMPORT	WriteMenuConsts, WriteMenuDefs,
					WriteMenuProcs, WriteMenuInits;
FROM	GenerateGadgets		IMPORT	WriteGadgetConsts, WriteGadgetDefs,
					WriteGadgetProcs, WriteGadgetInits;
FROM	GenerateWindows		IMPORT	WriteWindowConsts, WriteWindowDefs,
					WriteWindowProcs, WriteWindowExit;
FROM	GenerateScreen		IMPORT	WriteScreenDefs, WriteScreenProcs,
					WriteScreenInit, WriteScreenExit;
FROM	GenerateGlobal		IMPORT	WriteGlobalDefs, WriteGlobalProcs;



(*
 * --- Generate Projects --------------------------------------------------------
 *)
PROCEDURE WriteProjects;

VAR	pw			:ProjectWindowPtr;


  PROCEDURE WriteStart;

  BEGIN
  WriteLn (dfile);
  WriteString (dfile, "(* ");
  WriteString (dfile, pw^.name);
  WriteString (dfile, " *) ");
  WriteLn (dfile);

  WriteLn (mfile);
  WriteString (mfile, "(* ");
  WriteString (mfile, pw^.name);
  WriteString (mfile, " *) ");
  WriteLn (mfile);
  END WriteStart;


  PROCEDURE WriteConst;

  BEGIN
  IF (pw^.gadgets.head^.succ # NIL) OR
     (pw^.menus.head^.succ # NIL) THEN
    WriteString (dfile, "CONST")
    END;
  WriteString (mfile, "CONST")
  END WriteConst;


  PROCEDURE WriteVar;

  BEGIN
  IF (pw^.gadgets.head^.succ # NIL) OR
     (pw^.menus.head^.succ # NIL) THEN
    WriteLn (dfile);
    END;
  WriteLn (mfile);
  WriteLn (mfile);


  WriteString (dfile, "VAR");
  WriteString (mfile, "VAR")
  END WriteVar;


  PROCEDURE WriteProcs;

  BEGIN
  WriteLn (dfile);
  WriteLn (mfile)
  END WriteProcs;



(* WriteProject *)
BEGIN
WriteLn (mfile);

pw := Projects.head;
WHILE pw^.succ # NIL DO
  WriteStart;					(* Comment precedes every project.	*)

  WriteConst;					(* Project constants.			*)
  WriteWindowConsts (pw);
  WriteMenuConsts   (pw);
  WriteGadgetConsts (pw);

  WriteVar;					(* Project declarations.		*)
  WriteWindowDefs   (pw);
  WriteITextsDefs   (pw);
  WriteMenuDefs     (pw);
  WriteGadgetDefs   (pw);

  WriteProcs;
  WriteITextsProcs  (pw);			(* Project procedures.			*)
  WriteMenuProcs    (pw);
  WriteGadgetProcs  (pw);
  WriteWindowProcs  (pw);

  pw := pw^.succ
  END
END WriteProjects;



PROCEDURE WriteProjectsInit;

VAR	pw			:ProjectWindowPtr;

BEGIN
pw := Projects.head;
WHILE pw^.succ # NIL DO
  WriteMenuInits   (pw);
  WriteGadgetInits (pw);
  WriteITextsInits (pw);

  pw := pw^.succ
  END
END WriteProjectsInit;



PROCEDURE WriteProjectsExit;

VAR	pw			:ProjectWindowPtr;

BEGIN
pw := Projects.head;
WHILE pw^.succ # NIL DO
  WriteWindowExit (pw);

  pw := pw^.succ
  END
END WriteProjectsExit;



(*
 * --- Codegenerierung Environment -----------------------------------------------
 *)
PROCEDURE WriteSource;

VAR	GetFilePresent		:BOOLEAN;



  PROCEDURE CheckGetFile	() :BOOLEAN;

  VAR	eng			:ExtNewGadgetPtr;
  	pw			:ProjectWindowPtr;

  BEGIN
  pw := Projects.head;
  WHILE pw^.succ # NIL DO
    eng := pw^.gadgets.head;
    WHILE eng^.succ # NIL DO
      IF (eng^.kind = genericKind) THEN
        RETURN TRUE
        END;

      eng := eng^.succ
      END;
    pw := pw^.succ
    END;

  RETURN FALSE
  END CheckGetFile;



  PROCEDURE InitSource		(    GetFilePresent	:BOOLEAN);


    (*$ CopyDyn := FALSE *)
    PROCEDURE dW		(    text		:ARRAY OF CHAR);

    BEGIN
    WriteString (dfile, text);
    WriteLn (mfile)
    END dW;


    (*$ CopyDyn := FALSE *)
    PROCEDURE mW		(    text		:ARRAY OF CHAR);

    BEGIN
    WriteString (mfile, text);
    WriteLn (mfile)
    END mW;


  (* InitSource *)
  BEGIN
  WriteString (dfile, "DEFINITION MODULE ");
  WriteString (dfile, args.BaseName);
  Write       (dfile, ";");
  WriteLn (dfile);
  WriteLn (dfile);

  dW ( "FROM IntuitionD			IMPORT	GadgetPtr, WindowPtr;			");
  WriteLn (dfile);
  WriteLn (dfile);


  WriteString (mfile, "IMPLEMENTATION MODULE ");
  WriteString (mfile, args.BaseName);
  Write       (mfile, ";");
  WriteLn (mfile);
  WriteLn (mfile);

  mW ( "FROM SYSTEM			IMPORT	LONGSET, ADDRESS,			");
  mW ( "					ADR, TAG;				");
  mW ( "FROM Arts			IMPORT	Assert;					");
  mW ( "FROM FileMessage		IMPORT	StrPtr;					");
  mW ( "FROM ExecD			IMPORT	NodeType,				");
  mW ( "					List, Node;				");
  mW ( "FROM ExecL			IMPORT	Forbid, Permit;				");
  mW ( "FROM GraphicsD			IMPORT	palMonitorID, ntscMonitorID,		");
  mW ( "					superlaceKey, hireslaceKey, loresKey,	");
  mW ( "					superKey, hiresKey,			");
  mW ( "					DrawModes, DrawModeSet,			");
  mW ( "					jam1, jam2,				");
  mW ( "					FontStyles, FontStyleSet,		");
  mW ( "					FontFlags, FontFlagSet,			");
  mW ( "					TextAttr, TextAttrPtr,			");
  mW ( "					TextFontPtr, RastPortPtr;		");
  mW ( "FROM GraphicsL			IMPORT	graphicsBase,				");
  mW ( "					CloseFont,				");
  mW ( "					SetAPen, TextLength,			");
  mW ( "					RectFill;				");
  mW ( "FROM GfxMacros			IMPORT	SetAfPen;				");
  mW ( "FROM DiskFontL			IMPORT	OpenDiskFont;				");
  mW ( "FROM IntuitionD			IMPORT	customScreen,				");
  mW ( "					WaTags,	GaTags, StringaTags, SaTags,	");
  mW ( "					LayoutaTags, PgaTags,			");
  mW ( "					ActivationFlags, ActivationFlagSet,	");
  mW ( "					GadgetFlags, GadgetFlagSet,		");
  mW ( "					PropInfoFlags, PropInfoFlagSet,		");
  mW ( "					MenuItemFlags, MenuItemFlagSet,		");
  mW ( "					WindowFlags, WindowFlagSet,		");
  mW ( "					IDCMPFlags, IDCMPFlagSet,		");
  mW ( "					ColorSpec, IntuiText,			");
  mW ( "					GadgetPtr, ScreenPtr, ObjectPtr,	");
  mW ( "					MenuPtr, WindowPtr;			");
  mW ( "FROM IntuitionL			IMPORT	NewObjectA, DisposeObject,		");
  mW ( "					SetMenuStrip, ClearMenuStrip,		");
  mW ( "					OpenWindowTagList, CloseWindow,		");
  mW ( "					LockPubScreen, UnlockPubScreen,		");
  mW ( "					OpenScreenTagList, CloseScreen,		");
  mW ( "					PrintIText, IntuiTextLength,		");
  mW ( "					AddGList, RemoveGList, RefreshGList;	");
  mW ( "FROM GadToolsD			IMPORT	nmTitle, nmItem, nmSub, nmEnd,		");
  mW ( "					nmBarlabel,				");
  mW ( "					genericKind, buttonKind, checkboxKind,	");
  mW ( "					integerKind, listviewKind, mxKind,	");
  mW ( "					numberKind, cycleKind, paletteKind,	");
  mW ( "					scrollerKind, sliderKind, stringKind,	");
  mW ( "					textKind,				");
  mW ( "					buttonIDCMP, checkboxIDCMP, mxIDCMP,	");
  mW ( "					integerIDCMP, listviewIDCMP, cycleIDCMP,");
  mW ( "					numberIDCMP, scrollerIDCMP, sliderIDCMP,");
  mW ( "					paletteIDCMP, stringIDCMP, textIDCMP,	");
  mW ( "					arrowIDCMP,				");
  mW ( "					GtTags,					");
  mW ( "					NewGadgetFlags, NewGadgetFlagSet,	");
  mW ( "					NewMenu, NewGadget;			");
  mW ( "FROM GadToolsL			IMPORT	CreateContext,				");
  mW ( "					CreateGadgetA, FreeGadgets,		");
  mW ( "					GetVisualInfoA, FreeVisualInfo,		");
  mW ( "					CreateMenusA, LayoutMenusA, FreeMenus,	");
  mW ( "					DrawBevelBoxA, 				");
  mW ( "					GTRefreshWindow, 			");
  mW ( "					GTBeginRefresh, GTEndRefresh;		");
  mW ( "FROM UtilityD			IMPORT	tagEnd,					");
  mW ( "					TagItem,				");
  mW ( "					TagItemPtr;				");

  IF GetFilePresent THEN
    mW ("FROM GetFile			IMPORT	GetFileClass;				");
    END;

  WriteLn (mfile);
  WriteLn (mfile)
  END InitSource;



  PROCEDURE WriteVar;

  BEGIN
  WriteLn (mfile);
  WriteString (mfile, "VAR")
  END WriteVar;



  PROCEDURE WriteInit;

  BEGIN
  WriteLn (mfile);
  WriteLn (mfile);
  WriteString (mfile, "(* ");
  WriteString (mfile, args.BaseName);
  WriteString (mfile, " *)");
  WriteLn (mfile);

  WriteString (mfile, "BEGIN");
  WriteLn (mfile);
  END WriteInit;



  PROCEDURE WriteExit;

  BEGIN
  WriteLn (mfile);
  WriteString (mfile, "CLOSE");
  WriteLn (mfile)
  END WriteExit;



  PROCEDURE ExitSource;

  BEGIN
  WriteLn (dfile);
  WriteLn (dfile);
  WriteString (dfile, "END ");
  WriteString (dfile, args.BaseName);
  Write       (dfile, ".");
  WriteLn (dfile);

  WriteString (mfile, "END ");
  WriteString (mfile, args.BaseName);
  Write       (mfile, ".");
  WriteLn (mfile);
  END ExitSource;



(* WriteSource *)
BEGIN
GetFilePresent := CheckGetFile ();


InitSource (GetFilePresent);

WriteVar;
WriteGlobalDefs (GetFilePresent);
WriteScreenDefs;

WriteGlobalProcs;
WriteScreenProcs (GetFilePresent);

WriteProjects;

WriteInit;
WriteScreenInit;
WriteProjectsInit;

WriteExit;
WriteProjectsExit;
WriteScreenExit;

ExitSource;


InOut.WriteLn;
InOut.WriteString ("GenModula completed successfull."); InOut.WriteLn;
InOut.WriteLn
END WriteSource;



(* GenModula *)
BEGIN
WriteSource
END GenModula.
