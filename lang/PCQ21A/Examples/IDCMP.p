Program IDCMP;

{
    This program demonstrates the sort of information you can
expect from Intuition.  All it does is open a window with a bunch
of IDCMP flags set, then describes them as they come in.

    It also creates some simple gadgets so you can experiment with
them as well.  Note that virtually all the work in this program is
in defining the typed constants that represent the window and the
gadgets.  Also note that I could have included the gadgets automatically
in the window by setting the FirstGadget field in the NewWindow
structure, but I wanted to show the AddGadget/RefreshGadget use.

    The colors used in the borders and other stuff is designed to
look right under 2.0, which means it will look bizarre under 1.3.
}

{
    Have just changed the const names from 1.3 to 2.0+
    The code is still 1.3.
    11 May 1998.
    nils.sjoholm@mailbox.swipnet.se
}


{$I "Include:Exec/Ports.i"}
{$I "Include:Intuition/Intuition.i"}

var
    W : WindowPtr;
    IM : IntuiMessagePtr;
    Quit : Boolean;
    S : StringInfoPtr;
    P : PropInfoPtr;

Const
    IText1  : IntuiText = (1,0,JAM2,20,5,Nil,"Gadget",Nil);

    Pairs1  : Array [1..3,1..2] of Short = (    (  0,19),
                        (  0, 0),
                        ( 99, 0));

    Pairs2  : Array [1..3,1..2] of Short = (    ( 99, 1),
                        ( 99,19),
                        (  1,19));

    Pairs3  : Array [1..3,1..2] of Short = (( -1, 20),
                        ( -1, -1),
                        (100, -1));

    Pairs4  : Array [1..3,1..2] of Short = ((100, -1),
                        (100, 20),
                        ( -1, 20));

    { Normal shadow borders }

    Border2 : Border = (0,0,1,0,JAM2,3,@Pairs2,Nil);
    Border1 : Border = (0,0,2,0,JAM2,3,@Pairs1,@Border2);

    { Reversed, selected borders }

    Border4 : Border = (0,0,2,0,JAM2,3,@Pairs2,Nil);
    Border3 : Border = (0,0,1,0,JAM2,3,@Pairs1,@Border4);

    Gadget1 : Gadget = (Nil, 10, 20, 100, 20,
            GFLG_GADGHIMAGE,
            GACT_RELVERIFY + GACT_IMMEDIATE + GACT_TOGGLESELECT,
            GTYP_BOOLGADGET,
            @Border1,
            @Border3,
            @IText1,
            0,
            Nil,
            0,
            Nil);

    StrBorder4 : Border = (-5,-5,1,0,JAM2,3,@Pairs4,Nil);
    StrBorder3 : Border = (-5,-5,2,0,JAM2,3,@Pairs3,@StrBorder4);
    StrBorder2 : Border = (-5,-5,2,0,JAM2,3,@Pairs2,@StrBorder3);
    StrBorder1 : Border = (-5,-5,1,0,JAM2,3,@Pairs1,@StrBorder2);

    StringInfo1 : StringInfo = (
            "Initial\0              ",
            "\0                     ",
            0,
            20,
            0,
            0,
            0,
            0,
            0,
            0,
            Nil,
            0,
            Nil);

    Gadget2 : Gadget = (Nil, 15, 55, 90, 10,
            GFLG_GADGHNONE,
            GACT_RELVERIFY + GACT_IMMEDIATE,
            GTYP_STRGADGET,
            @StrBorder1,
            Nil,
            Nil,
            0,
            @StringInfo1,
            1,
            Nil);


    PropInfo1 : PropInfo = (AUTOKNOB + FREEHORIZ,
            0,0, { Pot values }
            $FFFF div 5,
            0,
            0,0,
            0,0,
            0,0);

    PropBorder1 : Border = (-1,-1,1,0,JAM2,3,@Pairs1,Nil);

    Gadget3 : Gadget = (Nil, 10, 78, 100, 14,
            GFLG_GADGHNONE,
            GACT_RELVERIFY + GACT_IMMEDIATE,
            GTYP_PROPGADGET,
            @PropBorder1,
            Nil,
            Nil,
            0,
            @PropInfo1,
            2,
            Nil);

    MyWindow : NewWindow = (50,30,400,150,-1,-1,
            IDCMP_NEWSIZE + IDCMP_MOUSEBUTTONS + IDCMP_MENUPICK +
            IDCMP_CLOSEWINDOW + IDCMP_DISKINSERTED +
            IDCMP_DISKREMOVED + IDCMP_ACTIVEWINDOW +
            IDCMP_INACTIVEWINDOW + IDCMP_VANILLAKEY +
            IDCMP_GADGETUP + IDCMP_GADGETDOWN,
            WFLG_SIZEGADGET + WFLG_DRAGBAR + WFLG_DEPTHGADGET +
            WFLG_CLOSEGADGET,
            Nil, { Could add all gadgets automatically here }
            Nil,
            "IDCMP Test Window",
            Nil,
            Nil,
            138,
            100,
            -1,-1,
            WBENCHSCREEN_f);

Function OpenNewWindow : Boolean;
begin
    W := OpenWindow(@MyWindow);
    OpenNewWindow := W <> Nil;
end;

begin
    if OpenNewWindow then begin

    { Set the string gadget size to the font size }

    Gadget2.Height := W^.IFont^.tf_YSize;

    { Actually add the gadgets }

    if AddGadget(W, @Gadget1, -1) = 0 then;
    if AddGadget(W, @Gadget2, -1) = 0 then;
    if AddGadget(W, @Gadget3, -1) = 0 then;

    { Display them }

    RefreshGadgets(W^.FirstGadget, W, Nil);

    { Receive messages, and report on them }

    repeat
        IM := IntuiMessagePtr(WaitPort(W^.UserPort));
        IM := IntuiMessagePtr(GetMsg(W^.UserPort));
        Writeln;
        with IM^ do begin
        case Class of
          IDCMP_SIZEVERIFY    : Writeln('Size Verify');
          IDCMP_NEWSIZE       : Writeln('New Window Size');
          IDCMP_REFRESHWINDOW : Writeln('Refresh Window');
          IDCMP_MOUSEBUTTONS  : Writeln('Mouse Button');
          IDCMP_MOUSEMOVE     : Writeln('Mouse Move');
          IDCMP_GADGETDOWN    : Writeln('Gadget Down');
          IDCMP_GADGETUP      : Writeln('Gadget Up');
          IDCMP_REQSET        : Writeln('Request Set');
          IDCMP_MENUPICK      : Writeln('Menu Pick');
          IDCMP_CLOSEWINDOW   : Writeln('Close Window');
          IDCMP_RAWKEY        : Writeln('Raw Key');
          IDCMP_REQVERIFY     : Writeln('Request Verify');
          IDCMP_REQCLEAR      : Writeln('Requests Cleared');
          IDCMP_MENUVERIFY    : Writeln('Menu Verify');
          IDCMP_NEWPREFS      : Writeln('New Preferences');
          IDCMP_DISKINSERTED  : Writeln('Disk Inserted');
          IDCMP_DISKREMOVED   : Writeln('Disk Removed');
          IDCMP_WBENCHMESSAGE : Writeln('WorkBench Message');
          IDCMP_ACTIVEWINDOW  : Writeln('Window Activated');
          IDCMP_INACTIVEWINDOW: Writeln('Window Deactivated');
          IDCMP_DELTAMOVE     : Writeln('Delta Move');
          IDCMP_VANILLAKEY    : Writeln('Vanilla Key');
          IDCMP_INTUITICKS    : Writeln('IntuiTicks');
        end;
        case Class of
          IDCMP_MOUSEBUTTONS  : if Code = SELECTUP then
                      Writeln('Left Button Released')
                  else
                      Writeln('Left Button Pressed');
          IDCMP_MENUPICK      : Writeln('Menu Choice: ', Code);
          IDCMP_RAWKEY        : Writeln('Raw Key Code: ', Code);
          IDCMP_VANILLAKEY    : begin
                      Write('Key Pressed: ');
                      if (Code > 32) and (Code < 127) then
                      Write(Chr(Code),',');
                      Writeln('Chr(', Code, ')');
                  end;
        else
            Writeln('Code: ', Code);
        end;
        Writeln('Qualifier: ', Qualifier);
        Writeln('Mouse Position: (', MouseX, ',', MouseY, ')');
        Writeln('Seconds: ', Seconds);
        Writeln('Micros:  ', Micros);

    { For gadgets, give more information }

        if (Class = IDCMP_GADGETUP) or (Class = IDCMP_GADGETDOWN) then begin
            case GadgetPtr(IAddress)^.GadgetID of
              0 : if (GadgetPtr(IAddress)^.Flags and SELECTED) <> 0
                then begin
                  Writeln('Gadget is selected');
                  OffGadget(@Gadget2,W,Nil);
                  OffGadget(@Gadget3,W,Nil);
              end else begin
                  Writeln('Gadget is not selected');
                  OnGadget(@Gadget2,W,Nil);
                  OnGadget(@Gadget3,W,Nil);
              end;
              1 : begin
                  S := GadgetPtr(IAddress)^.SpecialInfo;
                  Writeln('String Buffer "', S^.Buffer, '"');
              end;
              2 : begin
                  P := GadgetPtr(IAddress)^.SpecialInfo;
                  Writeln('Selected part: ',
                (P^.HorizPot and $FFFF) / 655.35:3:0, '%');
              end;
            end;
        end;
        Quit := Class = IDCMP_CLOSEWINDOW;
        end;
        ReplyMsg(MessagePtr(IM));
    until Quit;
    CloseWindow(W);
    end else
    Writeln('Could not open the window');
end.
