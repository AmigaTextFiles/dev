MODULE Test;

IMPORT
  y * := SYSTEM,

  (* Interfaces *)
  d * := Dos,
  e * := Exec,
  rx * := Rexx,
  u * := Utility,

  (* XModules *)
  er * := EasyRexx;

  (* Private *)
  (* none *)

TYPE
  Table =  ARRAY 8 OF er.ARexxCommandTable;

CONST
  cmdClear  = 1;
  cmdOpen   = 2;
  cmdSaveAs = 3;
  cmdHelp   = 4;
  cmdText   = 5;
  cmdRow    = 6;
  cmdQuit   = 7;

  commandTable = Table(
  (* id         cmd               argument template                   userdata *)
  cmdClear,     y.ADR("CLEAR"),   y.ADR("FORCE/S"),                   NIL,
  cmdOpen,      y.ADR("OPEN"),    y.ADR("PROJECT/S,TEXT/S,NAME/F"),   NIL,
  cmdSaveAs,    y.ADR("SAVEAS"),  y.ADR("NAME/K"),                    NIL,
  cmdHelp,      y.ADR("HELP"),    y.ADR("AMIGAGUIDE/S,TOPIC/F"),      NIL,
  cmdText,      y.ADR("TEXT"),    y.ADR("TEXT/A/F"),                  NIL,
  cmdRow,       y.ADR("ROW"),     y.ADR("ROWNUMBER/A/N"),             NIL,
  cmdQuit,      y.ADR("QUIT"),    NIL,                                NIL,
  0,            NIL,              NIL,                                NIL
  );

TYPE
  ArgsClear = STRUCT (as :d.ArgsStruct)
    force     :d.ArgBool;
  END;
  ArgsOpen = STRUCT (as :d.ArgsStruct)
    project   :d.ArgBool;
    text      :d.ArgBool;
    name      :d.ArgString;
  END;
  ArgsSaveAs = STRUCT (as :d.ArgsStruct)
    name     :d.ArgString;
  END;
  ArgsHelp = STRUCT (as :d.ArgsStruct)
    amigaguide  :d.ArgBool;
    topic   :d.ArgString;
  END;
  ArgsText = STRUCT (as :d.ArgsStruct)
    text    :d.ArgString;
  END;
  ArgsRow = STRUCT (as :d.ArgsStruct)
    rownumber :d.ArgLong;
  END;


VAR
  context:    er.ARexxContextPtr;
  signal :    LONGSET;
  done   :    BOOLEAN;

PROCEDURE HandleRexx(c :er.ARexxContextPtr): BOOLEAN;

BEGIN
  IF er.GetARexxMsg(c) THEN
    d.PrintF("Received: ");
    CASE c.id OF
      cmdClear:
        d.PrintF("CLEAR");
        IF c.argv(ArgsClear).force=d.DOSTRUE THEN d.PrintF(" FORCE") END;
      |cmdOpen:
        d.PrintF("OPEN");
        IF c.argv(ArgsOpen).text=d.DOSTRUE THEN
          d.PrintF(" TEXT");
        ELSE
          d.PrintF(" PROJECT");
        END;
        IF c.argv(ArgsOpen).name#NIL THEN d.PrintF(" '%s'", c.argv(ArgsOpen).name) END;
      |cmdSaveAs:
        d.PrintF("SAVEAS '%s'",c.argv(ArgsSaveAs).name);
      |cmdHelp:
        d.PrintF("HELP");
        IF c.argv(ArgsHelp).amigaguide=d.DOSTRUE THEN d.PrintF(" AMIGAGUIDE") END;
        IF c.argv(ArgsHelp).topic#NIL THEN d.PrintF(" '%s'", c.argv(ArgsHelp).topic) END;
      |cmdText:
        d.PrintF("TEXT '%s'", c.argv(ArgsText).text);
      |cmdRow:
        d.PrintF("ROW %ld", c.argv(ArgsRow).rownumber^[0]);
      |cmdQuit:
        d.PrintF("QUIT");
        done := TRUE;
      ELSE
        d.PrintF("unknown command...\neasyrexx.library has a bug, not my fault... :(\n");
    END;
    er.ReplyARexxMsg(c, er.returnCode, rx.ok,
                        u.end);
    d.PrintF("\n");
    RETURN done;
  END;
  RETURN FALSE;
END HandleRexx;


BEGIN
  context := er.AllocARexxContext(er.portName,      y.ADR("EASYREXX_TEST"),
                                  er.commandTable,  y.ADR(commandTable),
                                  u.done);
  IF context#NIL THEN
    done := FALSE;
    d.PrintF("Welcome to a small EasyRexx demonstration\n"
             "   Oberon Version by StElb\n"
             "-----------------------------------------\n"
             "Open another shell and start the small\n"
             "AREXX script: rx test\n"
             "or doubleclick on the test.rexx icon.\n");
    WHILE ~done DO
      signal := e.Wait(LONGSET{er.SignalBit(context),d.ctrlC});
      IF er.SignalBit(context) IN signal THEN done := HandleRexx(context) END;
      IF d.ctrlC IN signal THEN
        d.PrintF("^C\n");
        done := TRUE;
      END;
    END;
    er.FreeARexxContext(context);
  END;
END Test.
