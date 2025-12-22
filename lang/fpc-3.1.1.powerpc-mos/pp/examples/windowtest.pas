program WindowTest;

{$mode objfpc}{$H+}
{$PACKRECORDS 2}
uses
  Classes, SysUtils, exec, utility, intuition, gadtools, aGraphics;
Const

     { der Name des Fensters }
     WinTitle        :   String  =   'Test Window';

     { der Name des Public-Screens, auf dem das Fenster sich öffnen soll }
     PubScreenName   :   String  =   'Workbench';

type
  TagList = Array [0..31] Of TTagItem;

function Tags(const t:array of const):pTagItem;
begin
  Tags := @t[0];
end;

var w: pWindow;
    tag: pTagItem;
    ttags:   TagList;
    Closed: Boolean;
    Msg: pIntuiMessage;
    NewGadget: tnewgadget;
    gad: pgadget;
    GList: pGadget;
    vi: Pointer;
    scr: pScreen;
    p:PLongWord;
    i: Integer;
begin
  InitIntuitionLibrary;
  InitGraphicsLibrary;
  InitGADTOOLSLibrary;
  GList := NIL;

  scr := LockPubScreen(NIL);
  vi := GetVisualInfoA(scr, NIL);
  gad := CreateContext(@GList);
  writeln('glist: ', Cardinal(glist), '  gad: ', cardinal(gad));

  //
  ttags[0].ti_Tag:=WA_Left;
  ttags[0].ti_Data:=100;
  ttags[1].ti_Tag:=WA_Top;
  ttags[1].ti_Data:=100;
  ttags[2].ti_Tag:=WA_Width;
  ttags[2].ti_Data:=100;
  ttags[3].ti_Tag:=WA_Height;
  ttags[3].ti_Data:=50;
  ttags[4].ti_Tag := GA_Immediate;
  ttags[4].ti_Data := Integer(TRUE);
  ttags[5].ti_Tag := TAG_DONE;
  //
  tag := @ttags[0];
  NewGadget.ng_TextAttr := scr^.Font;
  NewGadget.ng_LeftEdge := 100;
  NewGadget.ng_TopEdge := 100;
  NewGadget.ng_Width := 120;                   // Breite
  NewGadget.ng_Height := 50;                   // Höhe
  NewGadget.ng_GadgetText := 'Test1';
  NewGadget.ng_VisualInfo := vi;
  gad := CreateGadgetA(BUTTON_KIND, gad, @newgadget, NIL);
  writeln('glist: ', Cardinal(glist), '  gad: ', cardinal(gad));
  //
  ttags[0].ti_Tag:=WA_Width;
  ttags[0].ti_Data:=400;
  ttags[1].ti_Tag:=WA_Height;
  ttags[1].ti_Data:=300;
  ttags[2].ti_Tag:=WA_IDCMP;
  ttags[2].ti_Data:=BUTTONIDCMP or IDCMP_CLOSEWINDOW or IDCMP_NEWSIZE or IDCMP_VANILLAKEY;
  ttags[3].ti_Tag:=WA_Title;
  ttags[3].ti_Data:=Integer(WinTitle);
  ttags[4].ti_Tag:=WA_PubScreenName;
  ttags[4].ti_Data := Integer(PubScreenName);
  ttags[5].ti_Tag := WA_DepthGadget;
  ttags[5].ti_Data := Integer(TRUE);
  ttags[6].ti_Tag := WA_SmartRefresh;
  ttags[6].ti_Data := Integer(TRUE);
  ttags[7].ti_Tag := WA_CloseGadget;
  ttags[7].ti_Data := Integer(TRUE);
  ttags[8].ti_Tag := WA_DragBar;
  ttags[8].ti_Data := Integer(TRUE);
  ttags[9].ti_Tag := WA_RMBTrap;
  ttags[9].ti_Data := Integer(TRUE);
  ttags[10].ti_Tag := WA_Activate;
  ttags[10].ti_Data := Integer(TRUE);
  ttags[11].ti_Tag := WA_SizeGadget;
  ttags[11].ti_Data := Integer(TRUE);
  ttags[12].ti_Tag := WA_MinWidth;
  ttags[12].ti_Data := 100;
  ttags[13].ti_Tag := WA_MinHeight;
  ttags[13].ti_Data := 100;
  ttags[14].ti_Tag := WA_Gadgets;
  ttags[14].ti_Data := Integer(glist);
  ttags[15].ti_Tag := WA_ScreenTitle;
  ttags[15].ti_Data := Integer(PChar('Test'));
  ttags[16].ti_Tag:=TAG_DONE;
  tag := @ttags[0];
  w := OpenWindowTagList(NIL,tag);
  writeln('open ok');
  //readln();
  writeln('Left ', w^.LeftEdge);
  writeln('Top ', w^.TopEdge);
  writeln('Width ', w^.Width);
  writeln('Height ',w^.Height);
  writeln('minwidth ', w^.MinWidth);
  writeln('maxwidth ', w^.MaxWidth);
  writeln('minheight ', w^.Minheight);
  writeln('maxheight ', w^.Maxheight);
  writeln('IDCMPFlags $', IntToHex(w^.IDCMPFlags, 8), ' should be $', intToHex(ttags[2].ti_Data, 8));
  p := @(w^.IDCMPFlags);
  Dec(p, 4);
  for i := 0 to 8 do
  begin
    writeln(i,', $', IntToHex(p^, 8));
    Inc(p);
  end;
  writeln('Title ', w^.Title);


  writeln('Orig ScreenTitle: ', IntToHex(LongWord(ttags[15].ti_data), 8));

  writeln('in file ScreenTitle: ', IntToHex(LongWord(w^.ScreenTitle), 8));
  //
  if Assigned(w) then
  begin
    GT_RefreshWindow(PWindow(w), NIL);
    Closed := False;
    repeat
      WaitPort(w^.UserPort);
      writeln('wait port ok ', assigned(w^.Userport));
      //readln();
      Msg := PIntuiMessage(GetMsg(w^.UserPort));
      writeln('getmsg ok');
      //readln();
      if Assigned(Msg) then
      begin
        case Msg^.IClass of
          IDCMP_CLOSEWINDOW: Closed:=True;
          IDCMP_NEWSIZE: writeln('newsize: ', w^.Width,' x ',w^.Height );
          IDCMP_VANILLAKEY: writeln('key pressed: ',chr(Msg^.Code));
          BUTTONIDCMP: writeln('Button clicked');
          else
            writeln('uknown message ',inttostr(Msg^.IClass));
        end;
        ReplyMsg(PMessage(Msg));
      end;
    until Closed;
    FreeGadgets(gad);
    FreeVisualInfo(vi);
    CloseWindow(PWindow(w));
  end;
end.

