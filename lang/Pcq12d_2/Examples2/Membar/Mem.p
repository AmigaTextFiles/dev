Program MemBar;

{ Graphische Speicheranzeige auf der Workbench }
{ PUBLIC DOMAIN - 1995 Andreas Tetzl }
{ EMail: A.Tetzl@saxonia.de }

{ Beenden: CTRL c
           Klick mit linker Maustaste auf Balken, Doppelklick
           mit rechter Maustaste
}


{ /// ------------------------------ "Includes" ------------------------------ }

{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Intuition/Screens.i"}
{$I "Include:Graphics/Graphics.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Utility/Utility.i"}
{$I "Include:DOS/DOS.i"}
{$I "Include:Utils/TagUtils.i"}
{$I "Include:Utils/Break.i"}

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------------- "VAR" --------------------------------- }

const
    StdInName = NIL;
    StdOutName = NIL;

    BACKCOL = 2;
    FULLCOL = 3;
    EMPTYCOL = 0;
    BARWIDTH = 150;

    version = "$VER: MemBar v1.0 (5.7.95)";

VAR Win : WindowPtr;
    Scr : ScreenPtr;
    TagList : Address;
    RP : RastPortPtr;
    mem, oldmem, total, i : Integer;

    s, m : Integer;
    Msg : IntuiMessagePtr;


{ /// ------------------------------------------------------------------------ }

{ /// --------------------------- "PROCEDURE Req" ---------------------------- }

PROCEDURE Req(Txt : String);
const
    es : EasyStruct = (0,0,NIL,NIL,NIL);

VAR i : Integer;

begin
 es.es_StructSize:=SizeOf(EasyStruct);
 es.es_Flags:=0;
 es.es_Title:="Information";
 es.es_TextFormat:=Txt;
 es.es_GadgetFormat:="OK";

 i:=EasyRequestArgs(NIL,adr(es),0,NIL);
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------ "PROCEDURE CleanExit" ------------------------- }

PROCEDURE CleanExit(Why : String; RC : Integer);
BEGIN
 If Win<>NIL then CloseWindow(Win);
 If GfxBase<>NIL then CloseLibrary(GfxBase);
 If UtilityBase<>NIL then CloseLibrary(UtilityBase);
 If Why<>NIL then Req(Why);
 Exit(RC);
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------- "PROCEDURE OpenAll" -------------------------- }

PROCEDURE OpenAll;
BEGIN
 UtilityBase:=OpenLibrary("utility.library",37);
 If UtilityBase=NIL then CleanExit("CANT OPEN UTILITY",10);

 GfxBase:=OpenLibrary("graphics.library",37);
 IF GfxBase=NIL then CleanExit("CANT OPEN GFX",10);

 Scr:=LockPubScreen(NIL);
 If Scr=NIL then CleanExit("CANT FIND WB",10);

 TagList:=CreateTagList(WA_Left,Scr^.Width-BARWIDTH-26,
                        WA_Top,0,
                        WA_Width,BARWIDTH,
                        WA_Height,Scr^.BarHeight,
                        WA_Borderless,TRUE,
                        WA_IDCMP,IDCMP_MENUPICK,
                        TAG_END);
 Win:=OpenWindowTagList(NIL,TagList);
 FreeTagItems(TagList);
 If Win=NIL then CleanExit("Can't open window",10);
 RP:=Win^.RPort;

 SetRast(RP,BACKCOL);
 total:=AvailMem(MEMF_TOTAL);
END;

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------------- "Main" -------------------------------- }

BEGIN
 OpenAll;

 Repeat
   mem:=total-AvailMem(MEMF_CHIP)-AvailMem(MEMF_FAST);

   If Abs(mem-oldmem)>1024 then
    BEGIN
     SetAPen(RP,EMPTYCOL);
     RectFill(RP,1,2,Win^.Width-2,Win^.Height-3);
     SetAPen(RP,FULLCOL);
     RectFill(RP,1,2,(Win^.Width-2)*mem/total,Win^.Height-3);
    END;

   oldmem:=mem;
   Delay(50);

   Msg:=IntuiMessagePtr(GetMsg(Win^.UserPort));
   If Msg<>NIL then
    BEGIN
     If DoubleClick(s,m,Msg^.Seconds,Msg^.Micros) then
      BEGIN
       ReplyMsg(MessagePtr(Msg));
       CleanExit(NIL,0);
      END;
     ReplyMsg(MessagePtr(Msg));
     s:=Msg^.Seconds;
     m:=Msg^.Micros;
    END;

 Until CheckBreak;

 CleanExit(NIL,0);
END.

{ /// ------------------------------------------------------------------------ }

