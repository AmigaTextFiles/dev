IMPLEMENTATION MODULE GeneratorIO;

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

FROM	SYSTEM			IMPORT	ADR,
					TAG;
FROM	Arts			IMPORT	Assert;
FROM	String			IMPORT	Length, FirstPos,
					Copy, CopyPart, Concat;
FROM	Conversions		IMPORT	ValToStr;
FROM	FileSystem		IMPORT	File, Response,
					Lookup, Close,
					GetPos, SetPos;
FROM	FileMessage		IMPORT	StrPtr,
					ResponseText;
FROM	FileOut			IMPORT	Write, WriteString, WriteLn,
					WriteCard, WriteInt;
FROM	DosL			IMPORT	FilePart;
FROM	UtilityD		IMPORT	tagEnd,
					TagItem;
FROM	NewArgSupport		IMPORT	SetArgumentInfo, UseArguments,
					ArgBoolean, ArgString;
FROM	NoFrag			IMPORT	MemoryChainPtr,
					GetMemoryChain, FreeMemoryChain;
FROM	GadToolsBox		IMPORT	gtbErrors, rgTags,
					vlfFlagSet,
					GenC,
					LoadGuiA, FreeWindows;
IMPORT	InOut;


CONST	Version			="$VER: GenModula 1.14 (14.Jan.94) by Reiner B. Nix";


VAR	Chain			:MemoryChainPtr;
	ValidBits		:vlfFlagSet;
	ProjectsLoad		:BOOLEAN;


(*
 * --- Hilfprozeduren -----------------------------------------------------------
 *)
PROCEDURE WriteFill		(VAR file		:File;
				     text		:ARRAY OF CHAR;
				     offset		:LONGINT);

CONST	maxTab	=8;
	maxFill	=3 * maxTab;


VAR	i, n			:INTEGER;
	empty			:ARRAY [0..20] OF CHAR;

BEGIN
n := offset + Length (text);
i := 0;
WHILE n < maxFill DO
  empty[i] := "\t";
  INC (i);
  INC (n, maxTab)
  END;
empty[i] := 0C;
WriteString (file, empty)
END WriteFill;


PROCEDURE SeekBack		(VAR file		:File;
				     bytes		:LONGINT);

VAR	actual			:LONGINT;

BEGIN
GetPos (file, actual);
SetPos (file, actual - bytes)
END SeekBack;



PROCEDURE GetAttrName		(VAR attrName		:ARRAY OF CHAR);

VAR	error			:BOOLEAN;
	i			:INTEGER;
	attrSize		:ARRAY [0..5] OF CHAR;

BEGIN
Copy (attrName, Gui.fontName);
i := FirstPos (attrName, 0, ".");
IF i # -1 THEN
  attrName[i] := 0C
  END;
ValToStr (Gui.font.ySize, FALSE, attrSize, 10, 1, " ", error);
Concat (attrName, attrSize)
END GetAttrName;



PROCEDURE WriteText		(VAR file		:File;
				     text		:ARRAY OF CHAR);

BEGIN
WriteString (file, text);
IF text[1] = 0C THEN
  WriteString (file, "\\o")
  END
END WriteText;



(*
 * --- Gui Access ---------------------------------------------------------------
 *)
PROCEDURE OpenGui;

VAR	guiTags		:ARRAY [0..4] OF TagItem;
	error		:gtbErrors;
	errorText	:ARRAY [0..80] OF CHAR;
	shortVersion	:ARRAY [0..80] OF CHAR;
	Config		:GenC;

BEGIN
error := LoadGuiA (Chain,
                   ADR (args.name),
                   TAG (guiTags,
                        rgGUI,		ADR (Gui),
                        rgCConfig,	ADR (Config),
                        rgWindowList,	ADR (Projects),
                        rgValid,	ADR (ValidBits),
                        tagEnd));

IF error = gtbErrorOpen THEN
  Concat (args.name, ".gui");
  error := LoadGuiA (Chain,
                     ADR (args.name),
                     TAG (guiTags,
                          rgGUI,		ADR (Gui),
                          rgCConfig,	ADR (Config),
                          rgWindowList,	ADR (Projects),
                          rgValid,	ADR (ValidBits),
                          tagEnd))
  END;

ProjectsLoad := TRUE;
CASE error OF
| gtbErrorNone       : errorText := "Alles klar?";
| gtbErrorNoMem      : errorText := "LoadGui: Speichermangel!";
| gtbErrorOpen       : errorText := "LoadGui: GUI-Datei nicht zu öffnen!";
| gtbErrorRead       : errorText := "LoadGui: Lesefehler!";
| gtbErrorWrite      : errorText := "LoadGui: Schreibfehler!";
| gtbErrorParse      : errorText := "LoadGui: iffparse-Fehler";
| gtbErrorPacker     : errorText := "LoadGui: GUI-Datei nicht zu entpacken!";
| gtbErrorPPLib      : errorText := "LoadGui: powerpacker.library wird benötigt!";
| gtbErrorNotGuiFile : errorText := "LoadGui: keine GUI-Datei!"
  END;

Assert (error = gtbErrorNone, ADR (errorText));

MainConfig := Config.gtConfig;
CConfig    := Config.genCFlags0;

CopyPart (shortVersion, Version, 6, Length (Version)-6);

InOut.WriteLn;
InOut.WriteString (shortVersion); InOut.WriteLn;
InOut.WriteLn;
InOut.WriteString (" - "); InOut.WriteString (args.name); InOut.WriteLn;
END OpenGui;


PROCEDURE OpenFiles;

VAR	ModName, DefName		:ARRAY [0..50] OF CHAR;
	errorText			:StrPtr;

BEGIN
Copy (args.BaseName, StrPtr (FilePart (ADR (args.fileName)))^);

Copy (ModName, args.fileName);
Copy (DefName, args.fileName);
Concat (ModName, ".mod");

IF ArgBoolean ("NODEF", FALSE) THEN
  Concat (DefName, ".nodef")
ELSE
  Concat (DefName, ".def")
  END;

Lookup (dfile, DefName, 5*1024, TRUE);
Lookup (mfile, ModName, 5*1024, TRUE);

ResponseText (mfile.res, errorText);
Assert (mfile.res = done, errorText);

ResponseText (dfile.res, errorText);
Assert (dfile.res = done, errorText);


InOut.WriteString (" + "); InOut.WriteString (DefName); InOut.WriteLn;
InOut.WriteString (" + "); InOut.WriteString (ModName); InOut.WriteLn
END OpenFiles;


PROCEDURE CloseFiles;

BEGIN
Close (mfile);
Close (dfile);
END CloseFiles;


PROCEDURE GenModulaInfo;

VAR	shortVersion	:ARRAY [0..80] OF CHAR;

BEGIN
CopyPart (shortVersion, Version, 6, Length (Version)-6);

InOut.WriteString (shortVersion);						InOut.WriteLn;
InOut.WriteLn;
InOut.WriteString ("NAME        name of input gui file from GadToolsBox");	InOut.WriteLn;
InOut.WriteString ("TO          basename of output files including");		InOut.WriteLn;
InOut.WriteString ("            any supplement path");				InOut.WriteLn;
InOut.WriteString ("RASTER      option to draw background raster");		InOut.WriteLn;
InOut.WriteString ("            around bevelboxes");				InOut.WriteLn;
InOut.WriteString ("UNDERMOUSE  option to force open windows under");		InOut.WriteLn;
InOut.WriteString ("            actual mouse position");			InOut.WriteLn;
InOut.WriteString ("NODEF       option to leave old definition file");		InOut.WriteLn;
InOut.WriteString ("            as is and output to xx.nodef");			InOut.WriteLn;
InOut.WriteLn
END GenModulaInfo;


(* GeneratorIO *)
BEGIN
Chain := NIL;
ProjectsLoad := FALSE;

SetArgumentInfo (GenModulaInfo);
UseArguments ("NAME/A,TO=AS/A,RASTER/S,UNDERMOUSE/S,NODEF/S");
WITH args DO
  ArgString ("NAME", "::", name);
  ArgString ("TO",   "::", fileName);
  raster := ArgBoolean ("RASTER", FALSE);
  mouse  := ArgBoolean ("UNDERMOUSE", FALSE)
  END;

Chain := GetMemoryChain (4096);
Assert (Chain # NIL, ADR ("NoFrag.library: keine Liste erhältlich."));

OpenGui;
OpenFiles;


CLOSE
CloseFiles;

IF ProjectsLoad THEN
  FreeWindows (Chain, ADR (Projects));
  ProjectsLoad := FALSE;
  END;

IF Chain # NIL THEN
  FreeMemoryChain (Chain, TRUE);
  Chain := NIL
  END
END GeneratorIO.
