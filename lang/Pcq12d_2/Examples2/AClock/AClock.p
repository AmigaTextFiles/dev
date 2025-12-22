Program AClock;

{                          AClock V1.2

      AClock ist Freeware, es darf kopiert werden solange damit kein
      Geld verdient wird.
      Wenn Teile des Programms in eigene Programme übernommen werden
      muß mein Name und meine Adresse dabeistehen.

         Andreas Tetzl
         Liebethaler Str.18
         O-8300 Pirna-Copitz
         
         ( Neue PLZ ab Juli 93: 01796 )
}

{$I "Include:Intuition/Intuition.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Graphics/Graphics.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Exec/Tasks.i"}
{$I "Include:Utils/DateTools.i"}
{$I "Include:Utils/IOUtils.i"}
{$I "Include:Utils/BuildMenu.i"}
{$I "Include:Libraries/DOS.i"}

VAR win : WindowPtr;
    Str, Fast, Chip, h, Min, Sec : String;
    i, Len : Integer;
    DD : DateDescription;
    DS : DateStampRec;
    Msg, MsgSend, MsgReceive  : MessagePtr;
    OldPort, NewPort, ReplyPort : MsgPortPtr;
    TopazFont : TextFontPtr;
    

Const StdInName  : String = ("CON:0/0/100/30/AClock");
      StdOutName : String = StdInName;

      nw : NewWindow=(190,00,400,10,1,1,CLOSEWINDOW_f,
				 WINDOWCLOSE+WINDOWDEPTH+WINDOWDRAG,
				 NIL,NIL,NIL,NIL,NIL,240,100,240,100,WBENCHSCREEN_F);

      MyTextAttr : TextAttr = ("topaz.font",8,FS_NORMAL,FPF_ROMFONT);

Procedure CleanUp(RC : Integer);
Begin
  If Win<>NIL then Begin
    DetachMenu;
    CloseWindow(Win);
  end;
  If Gfxbase<>NIL then Closelibrary(GfxBase);
  FreeString(Str);
  FreeString(Fast);
  FreeString(Chip);
  If NewPort<>NIL then RemPort(NewPort);
  Dispose(NewPort);
  If RC<>0 then DisplayBeep(NIL);
  Exit(RC);
End;

Begin
  { *** Läuft Programm schon ? *** }
  OldPort:=FindPort("AClock Port");
  If OldPort<>NIL then Begin
    { *** Ja, dann Nachricht an Programm schicken das es beenden soll. *** }
    New(ReplyPort);
    ReplyPort^.mp_Node.ln_Pri:=0;
    ReplyPort^.mp_Node.ln_Name:="AClock ReplyPort";
    ReplyPort^.mp_SigTask:=Findtask(NIL);
    AddPort(ReplyPort);
    New(MsgSend);
    MsgSend^.mn_Length:=SizeOf(MessagePtr);
    MsgSend^.mn_Node.ln_Type:=NTMessage;
    MsgSend^.mn_ReplyPort:=ReplyPort;
    PutMsg(OldPort,MsgSend);
    Msg:=WaitPort(ReplyPort);
    RemPort(ReplyPort);
    DisPose(MsgSend);
    Dispose(ReplyPort);
  end else Begin
    { *** Messageport öffnen *** }
    New(NewPort);
    NewPort^.mp_Node.ln_Pri:=0;
    NewPort^.mp_Node.ln_Name:="AClock Port";
    NewPort^.mp_SigTask:=FindTask(NIL);
    AddPort(NewPort);

    { *** Speicher für Strings *** }
    Str:=AllocString(40);
    Fast:=AllocString(20);
    Chip:=AllocString(20);
    { *** Window öffnen *** }
    Win:=OpenWindow(Adr(nw));
    If Win=NIL then Cleanup(10);
    { *** Menu anhängen *** }
    InitializeMenu(Win);
    NewMenu("Info                                ");
      NewItem("AClock V1.2  © 1993 by Andreas Tetzl.",'\0');
      NewItem("This Program is Freeware.            ",'\0');
      NewItem("Made for PURITY.                     ",'\0');
    AttachMenu;
    { *** GraphicsLib öffnen *** }
    GfxBase:=OpenLibrary("graphics.library",0);
    If GfxBase=NIL then Cleanup(10);
    { *** Topaz.Font einstellen *** }
    TopazFont:=OpenFont(adr(MyTextAttr));
    If TopazFont=NIL then Cleanup(10);
    SetFont(Win^.RPort,TopazFont);
    SetAPen(Win^.RPort,2);
    SetBPen(Win^.RPort,1);
    Repeat
      { *** Freies Chipmem ausgeben *** }
      i:=IntToStr(Chip,AvailMem(MEMF_CHIP));
      Len:=StrLen(Chip);
      StrCpy(Str,"CHIP:");
      StrCat(Str,Chip);
      Move(Win^.RPort,31,7);
      GText(Win^.RPort,Str,StrLen(Str));

      { *** Freies Fastmem ausgeben ***}
      i:=IntToStr(Fast,AvailMem(MEMF_FAST));
      Len:=StrLen(Fast);
      StrCpy(Str,"FAST:");
      StrCat(Str,Fast);
      Move(Win^.RPort,135,7);
      GText(Win^.RPort,Str,StrLen(Str));

      { *** Zeit ausgeben *** }
      DateStamp(DS);
      StampDesc(DS,DD);
      Strcpy(Str,"TIME:");
      If DD.Hour<10 then StrCat(Str,"0");
      i:=IntToStr(h,DD.Hour);
      If StrLen(h)>2 then StrnCpy(h,h,2);   { <- Bei mir hatte DD.Hour manchmal
                                                 3 oder 4 Stellen, und die Depth-
                                                 Gadgets wurden übermalt. Genauso
                                                 ist das mit DD.Minute u. DD.Second.
                                                 Deshalb habe ich das eingebaut.}
      StrCat(Str,h);
      StrCat(Str,":");
      If DD.Minute<10 then StrCat(Str,"0");
      i:=IntToStr(min,DD.Minute);
      If StrLen(min) > 2 then StrnCpy(min,min,2);
      StrCat(Str,min);
      StrCat(Str,":");
      If DD.Second<10 then StrCat(Str,"0");
      i:=IntToStr(sec,DD.Second);
      If StrLen(Sec) > 2 then StrnCpy(Sec,Sec,2);
      StrCat(Str,sec);
      Move(Win^.RPort,239,7);
      GText(Win^.RPort,Str,StrLen(Str));
      Delay(50);
      { *** Programm nochmal gestartet ? *** }
      MsgReceive:=GetMsg(NewPort);
      If MsgReceive<>NIL then begin
        { *** Dann ENDE *** }
        ReplyMsg(MsgReceive);
        Cleanup(0);
      end;
      { *** CloseGadget gedrückt ? *** }
      Msg:=GetMsg(Win^.UserPort);
  Until Msg<>NIL;
  { *** ENDE *** }
  ReplyMsg(Msg);
  Cleanup(0);
  end;
end.
