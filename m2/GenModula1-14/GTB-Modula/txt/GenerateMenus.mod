IMPLEMENTATION MODULE GenerateMenus;

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

FROM	SYSTEM			IMPORT	LONGSET;
FROM	String			IMPORT	Length;
FROM	FileOut			IMPORT	Write, WriteString, WriteLn,
					WriteCard, WriteInt;
FROM	IntuitionD		IMPORT	MenuItemFlags, MenuItemFlagSet;
FROM	GadToolsD		IMPORT	nmTitle, nmItem, nmSub, nmEnd,
					nmBarlabel;
FROM	GadToolsBox		IMPORT	ExtNewMenu,
					ExtNewMenuPtr, ProjectWindowPtr;
FROM	GeneratorIO		IMPORT	dfile, mfile, args,
					Gui, MainConfig, CConfig, Projects,
					WriteFill, SeekBack;


PROCEDURE WriteMenuConsts	(    pw			:ProjectWindowPtr);

VAR	i			:CARDINAL;
	menu, item, sub		:ExtNewMenuPtr;


  PROCEDURE WriteNewMenuConsts	(    menu		:ExtNewMenu;
  				     projectName	:ARRAY OF CHAR;
  				     number		:CARDINAL);

  BEGIN
  IF menu.menuLabel[0] # 0C THEN
    Write       (dfile, "\t");
    WriteString (dfile, projectName);
    WriteString (dfile, "Menu");
    WriteString (dfile, menu.menuLabel);
    WriteString (dfile, "ID");
    WriteFill   (dfile, menu.menuLabel, Length (projectName)+6);
    WriteString (dfile, "=");
    WriteCard   (dfile, number, 3);
    Write       (dfile, ";");
    WriteLn (dfile)
    END
  END WriteNewMenuConsts;


(* WriteMenuConsts *)
BEGIN
menu := pw^.menus.head;

IF menu^.succ # NIL THEN
  i := 0;
  menu := pw^.menus.head;
  WHILE menu^.succ # NIL DO
    INC (i);
    WriteNewMenuConsts (menu^, pw^.name, i);

    item := menu^.items^.head;
    WHILE item^.succ # NIL DO
      INC (i);
      WriteNewMenuConsts (item^, pw^.name, i);

      sub := item^.items^.head;
      WHILE sub^.succ # NIL DO
        INC (i);
        WriteNewMenuConsts (sub^, pw^.name, i);

        sub := sub^.succ
        END;

      item := item^.succ;
      END;

    menu := menu^.succ
    END;

  WriteLn (dfile);
  END
END WriteMenuConsts;


PROCEDURE WriteMenuDefs		(    pw			:ProjectWindowPtr);

VAR	recordNumber		:CARDINAL;
	menu, item, sub		:ExtNewMenuPtr;

BEGIN
menu := pw^.menus.head;
IF menu^.succ # NIL THEN
  recordNumber := 0;

  WHILE menu^.succ # NIL DO
    INC (recordNumber);

    item := menu^.items^.head;
    WHILE item^.succ # NIL DO
      INC (recordNumber);

      sub := item^.items^.head;
      WHILE sub^.succ # NIL DO
        INC (recordNumber);

        sub := sub^.succ
        END;

      item := item^.succ;
      END;

    menu := menu^.succ
    END;


  WriteString (mfile, "\t");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "MenuStrip");
  WriteFill   (mfile, pw^.name, 9);
  WriteString (mfile, ":MenuPtr;");
  WriteLn (mfile);

  WriteString (mfile, "\t");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Menu");
  WriteFill   (mfile, pw^.name, 4);
  WriteString (mfile, ":ARRAY [1..");
  WriteCard   (mfile, recordNumber+1, 1);
  WriteString (mfile, "] OF NewMenu;");
  WriteLn (mfile)
  END
END WriteMenuDefs;



PROCEDURE WriteMenuProcs	(    pw			:ProjectWindowPtr);


  PROCEDURE WriteMenuInit	(    pw			:ProjectWindowPtr);

  VAR	i			:CARDINAL;
  	menu, item, sub		:ExtNewMenuPtr;


    PROCEDURE WriteNewMenuInit	(    menu		:ExtNewMenu;
    				     projectName	:ARRAY OF CHAR;
    				     number		:CARDINAL);

    VAR	i			:CARDINAL;

    BEGIN
    WriteString (mfile, "WITH ");
    WriteString (mfile, projectName);
    WriteString (mfile, "Menu[");
    WriteCard   (mfile, number, 3);
    WriteString (mfile, "] DO");
    WriteLn (mfile);

    WriteString (mfile, "  type          := ");
    CASE menu.newMenu.type OF
    | nmTitle: WriteString (mfile, "nmTitle;"); WriteLn (mfile);
    | nmItem:  WriteString (mfile, "nmItem;");  WriteLn (mfile);
    | nmSub:   WriteString (mfile, "nmSub;");   WriteLn (mfile);
      END;

    WriteString (mfile, "  label         := ");
    IF menu.newMenu.label = nmBarlabel THEN
      WriteString (mfile, "nmBarlabel;");
      WriteLn (mfile)
    ELSE
      WriteString (mfile, "ADR ('");
      WriteString (mfile, menu.menuTitle);
      WriteString (mfile, "');");
      WriteLn (mfile)
      END;

    WriteString (mfile, "  commKey       := ");
    IF menu.newMenu.commKey = NIL THEN
      WriteString (mfile, "NIL;");
      WriteLn (mfile)
    ELSE
      WriteString (mfile, "ADR ('");
      WriteString (mfile, menu.commKey);
      WriteString (mfile, "\\000');");
      WriteLn (mfile)
      END;

    WriteString (mfile, "  itemFlags     := MenuItemFlagSet {");
    WITH menu.newMenu DO
      IF checkIt IN itemFlags THEN
        WriteString (mfile, "checkIt,")
        END;
      IF menuToggle IN itemFlags THEN
        WriteString (mfile, "menuToggle,")
        END;
      IF itemEnabled IN itemFlags THEN
        WriteString (mfile, "itemEnabled,")
        END;
      IF checked IN itemFlags THEN
        WriteString (mfile, "checked,")
        END;
      IF itemFlags # MenuItemFlagSet {} THEN
        SeekBack (mfile, 1)
        END
      END;
    WriteString (mfile, "};");
    WriteLn (mfile);

    WriteString (mfile, "  mutualExclude := LONGSET {");
    FOR i := 0 TO 31 DO
      IF i IN menu.newMenu.mutualExclude THEN
        WriteCard (mfile, i, 1);
        Write (mfile, ",")
        END
      END;
    IF menu.newMenu.mutualExclude # LONGSET {} THEN
      SeekBack (mfile, 1)
      END;
    WriteString (mfile, "};");
    WriteLn (mfile);

    IF menu.menuLabel[0] = 0C THEN
      WriteString (mfile, "  userData      := NIL");
      WriteLn (mfile)
    ELSE
      WriteString (mfile, "  userData      := ");
      WriteString (mfile, projectName);
      WriteString (mfile, "Menu");
      WriteString (mfile, menu.menuLabel);
      WriteString (mfile, "ID");
      WriteLn (mfile)
      END;

    WriteString (mfile, "  END;");
    WriteLn (mfile)
    END WriteNewMenuInit;


  (* WriteMenuInit *)
  BEGIN
  menu := pw^.menus.head;
  IF menu^.succ # NIL THEN
    WriteLn (mfile);
    WriteString (mfile, "PROCEDURE Init");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Menu;");
    WriteLn (mfile);
    WriteLn (mfile);

    WriteString (mfile, "BEGIN");
    WriteLn (mfile);


    i := 0;
    menu := pw^.menus.head;
    WHILE menu^.succ # NIL DO
      INC (i);
      WriteNewMenuInit (menu^, pw^.name, i);

      item := menu^.items^.head;
      WHILE item^.succ # NIL DO
        INC (i);
        WriteNewMenuInit (item^, pw^.name, i);

        sub := item^.items^.head;
        WHILE sub^.succ # NIL DO
          INC (i);
          WriteNewMenuInit (sub^, pw^.name, i);

          sub := sub^.succ
          END;

        item := item^.succ;
        END;

      menu := menu^.succ
      END;

    WriteString (mfile, "WITH ");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Menu[");
    WriteCard   (mfile, i+1, 3);
    WriteString (mfile, "] DO");
    WriteLn (mfile);

    WriteString (mfile, "  type          := nmEnd;");              WriteLn (mfile);
    WriteString (mfile, "  label         := NIL;");                WriteLn (mfile);
    WriteString (mfile, "  commKey       := NIL;");                WriteLn (mfile);
    WriteString (mfile, "  itemFlags     := MenuItemFlagSet {};"); WriteLn (mfile);
    WriteString (mfile, "  mutualExclude := LONGSET {};");         WriteLn (mfile);
    WriteString (mfile, "  userData      := NIL");                 WriteLn (mfile);
    WriteString (mfile, "  END");                                  WriteLn (mfile);


    WriteString (mfile, "END Init");
    WriteString (mfile, pw^.name);
    WriteString (mfile, "Menu;");
    WriteLn (mfile);
    WriteLn (mfile)
    END
  END WriteMenuInit;


(* WriteMenuProcs *)
BEGIN
WriteMenuInit (pw)
END WriteMenuProcs;



PROCEDURE WriteMenuInits	(    pw			:ProjectWindowPtr);


BEGIN
IF pw^.menus.head^.succ # NIL THEN
  WriteString (mfile, "Init");
  WriteString (mfile, pw^.name);
  WriteString (mfile, "Menu;");
  WriteLn (mfile)
  END
END WriteMenuInits;


END GenerateMenus.
