Program ToggleDemo;

{*****************************************************}
{*                                                   *}
{*   This demo shows how to use Boolean type gadgets *}
{*  to create mutually exclusive gadgets.            *}
{*   When a Gadget is pressed it must de-select the  *}
{*  other Gadgets and select itself.                 *}
{*                                                   *}
{*****************************************************}

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility,toggledemowin;

const
  FirstGad  : string = 'First Option'#0;
  SecondGad : string = 'Second Option'#0;
  ThirdGad  : string = 'Third Option'#0;
var
  done      : boolean;
  class     : long;
  code      : word;
  pimsg     : pintuimessage;
  dummy     : long;
  pgsel     : pgadget;
  gadnumber : word;
begin
  if openlibs then
    begin
      if makeimages then
        begin
          if openwindowmainwindow then
            begin
              done:=false;
              repeat
                dummy:=wait(bitmask(mainwindow^.userport^.mp_sigbit));
                pimsg:=gt_getimsg(mainwindow^.userport);
                while(pimsg<>nil) do
                  begin
                    class:=pimsg^.class;
                    code:=pimsg^.code;
                    pgsel:=pgadget(pimsg^.iaddress);  { do not reference unless gadgetup or gadgetdown }
                    gt_replyimsg(pimsg);
                    gadnumber:=99;
                    case class of
                      idcmp_closewindow : 
                        done:=true;
                      idcmp_vanillakey :
                        case upcase(chr(code)) of
                          'F' : gadnumber:=FirstGadget;
                          'S' : gadnumber:=SecondGadget;
                          'T' : gadnumber:=ThirdGadget;
                         end;
                      idcmp_gadgetdown :
                        gadnumber:=pgsel^.gadgetid;
                     end;
                    case gadnumber of
                      FirstGadget :
                        begin
                          {* Remove gadgets from window *}
                          dummy:=RemoveGList(mainwindow,mainwindowglist,~0);
                          {* Change Gadget Flags *}
                          mainwindowgads[FirstGadget]^.Flags:=mainwindowgads[FirstGadget]^.Flags or GFLG_Selected;
                          mainwindowgads[SecondGadget]^.Flags:=mainwindowgads[SecondGadget]^.Flags and ~GFLG_Selected;
                          mainwindowgads[ThirdGadget]^.Flags:=mainwindowgads[ThirdGadget]^.Flags and ~GFLG_Selected;
                          {* Put Gadgets Back in window *}
                          dummy:=AddGList(mainwindow,mainwindowglist,dummy,~0,nil);
                          {* Refresh Gadgets *}
                          RefreshGList(MainWindowGList,MainWindow,nil,~0);
                          gt_setsinglegadgetattr(mainwindowgads[DisplayGadget],mainwindow,
                                                 GTTX_Text,long(@FirstGad[1]));
                        end;
                      SecondGadget :
                        begin
                          dummy:=RemoveGList(mainwindow,mainwindowglist,~0);
                          mainwindowgads[FirstGadget]^.Flags:=mainwindowgads[FirstGadget]^.Flags and ~GFLG_Selected;
                          mainwindowgads[SecondGadget]^.Flags:=mainwindowgads[SecondGadget]^.Flags or GFLG_Selected;
                          mainwindowgads[ThirdGadget]^.Flags:=mainwindowgads[ThirdGadget]^.Flags and ~GFLG_Selected;
                          dummy:=AddGList(mainwindow,mainwindowglist,dummy,~0,nil);
                          RefreshGList(mainwindowglist,mainwindow,nil,~0);
                          gt_setsinglegadgetattr(mainwindowgads[DisplayGadget],mainwindow,
                                                 GTTX_Text,long(@SecondGad[1]));
                        end;
                      ThirdGadget :
                        begin
                          dummy:=RemoveGList(mainwindow,mainwindowglist,~0);
                          mainwindowgads[FirstGadget]^.Flags:=mainwindowgads[FirstGadget]^.Flags and ~GFLG_Selected;
                          mainwindowgads[SecondGadget]^.Flags:=mainwindowgads[SecondGadget]^.Flags and ~GFLG_Selected;
                          mainwindowgads[ThirdGadget]^.Flags:=mainwindowgads[ThirdGadget]^.Flags or GFLG_Selected;
                          dummy:=AddGList(mainwindow,mainwindowglist,dummy,~0,nil);
                          RefreshGList(mainwindowglist,mainwindow,nil,~0);
                          gt_setsinglegadgetattr(mainwindowgads[DisplayGadget],mainwindow,
                                                 GTTX_Text,long(@ThirdGad[1]));
                        end;
                     end;
                    pimsg:=gt_getimsg(mainwindow^.userport);
                  end;
              until done;
              closewindowmainwindow;
            end
           else
            writeln('Could not open window.');
          Freeimages;
        end
       else
        writeln('Unable to make images.');
      closelibs;
    end
   else
    writeln('Could not open libraries.');
end.