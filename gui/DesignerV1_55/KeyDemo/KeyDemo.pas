Program KeyDemo;

{************************************************}
{*                                              *}
{*             (C) Ian OConnor 1994             *}
{*                                              *}
{*    This program demonstrates implementing    *}
{*    GadTools Gadgets keyboard shortcuts as    *}
{*    documented.                               *}
{*                                              *}
{************************************************}

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility,keydemowin;
const
  winname : string = 'CON:5/20/400/50/Key Demo Output'#0;
var
  done               : boolean;
  class              : long;
  code               : word;
  pimsg              : pintuimessage;
  dummy              : long;
  pgsel              : pgadget;
  gadnumber          : long;
  dummybool          : boolean;
  PresentMXSelected  : byte;
  PresentCycleActive : integer;
  PresentColor       : integer;
  SliderPos          : integer;
  ScrollerTop        : integer;

begin
  
  {* Change output window slightly.  *}
  {* Only affects workbench running. *}
  
  WBWindowName:=@winname[1];
  writeln('Key Demo begins...');
  
  if openlibs then
    begin
      if openwindowmainwindow then
        begin
          
          PresentMXSelected:=0;
          PresentCycleActive:=0;
          PresentColor:=0;
          SliderPos:=0;
          ScrollerTop:=0;
          
          done:=false;
          repeat
            dummy:=wait(bitmask(mainwindow^.userport^.mp_sigbit));
            pimsg:=gt_getimsg(mainwindow^.userport);
            while(pimsg<>nil) do
              begin
                class:=pimsg^.class;
                code:=pimsg^.code;
                pgsel:=pgadget(pimsg^.iaddress);  {* do not reference unless gadgetup or gadgetdown *}
                gt_replyimsg(pimsg);
                
                {*  Gadget Handling *}
                
                gadnumber:=99;
                case class of
                  idcmp_closewindow : 
                    gadnumber:=QuitButton;
                  idcmp_vanillakey :
                    case upcase(chr(code)) of
                      'B' : 
                        gadnumber:=ButtonGadget;
                      'Q' : 
                        gadnumber:=QuitButton;
                      'S' : 
                        dummybool:=ActivateGadget( mainwindowgads[StringGadget], mainwindow, nil);
                      'I' : 
                        dummybool:=ActivateGadget( mainwindowgads[IntegerGadget], mainwindow, nil);
                      'C' : 
                        begin
                          GT_SetSingleGadgetattr(mainwindowgads[CheckBoxGadget], mainwindow,
                                                 GTCB_Checked,long(not gadselected(mainwindowgads[CheckBoxGadget])));
                          gadnumber:=CheckBoxGadget;
                        end;
                      '0'..'3' :
                        begin
                          presentmxselected:=code-ord('0');
                          GT_SetSingleGadgetattr(mainwindowgads[MXGadget], mainwindow,
                                                 GTMX_Active, presentmxselected);
                          gadnumber:=mxgadget;
                        end;
                      'Y' :
                        begin
                          if chr(code)='Y' then dec(PresentCycleActive);
                          if chr(code)='y' then inc(PresentCycleActive);
                          if PresentCycleActive>3 then
                            PresentCycleActive:=0;
                          if PresentCycleActive<0 then
                            PresentCycleActive:=3;
                          GT_SetSingleGadgetattr(mainwindowgads[cycleGadget], mainwindow,
                                                 GTCY_Active, PresentCycleActive);
                          gadnumber:=cyclegadget;
                        end;
                      'P' :
                        begin
                          if chr(code)='P' then dec(PresentColor);
                          if chr(code)='p' then inc(PresentColor);
                          if PresentColor>(1 shl mainwindowdepth)-1 then
                            PresentColor:=0;
                          if PresentColor<0 then
                            PresentColor:=(1 shl mainwindowdepth)-1;
                          GT_SetSingleGadgetattr(mainwindowgads[PaletteGadget], mainwindow,
                                                 GTPA_Color, PresentColor);
                          gadnumber:=palettegadget;
                        end;
                      'L' :
                        begin
                          if chr(code)='L' then dec(SliderPos);
                          if chr(code)='l' then inc(SliderPos);
                          if SliderPos>15 then
                            SliderPos:=15;
                          if SliderPos<0 then
                            SliderPos:=0;
                          GT_SetSingleGadgetattr(mainwindowgads[SliderGadget], mainwindow,
                                                 GTSL_Level, SliderPos);
                          gadnumber:=slidergadget;
                        end;
                      'R' :
                        begin
                          if chr(code)='R' then dec(ScrollerTop);
                          if chr(code)='r' then inc(ScrollerTop);
                          if ScrollerTop>8 then
                            ScrollerTop:=8;
                          if ScrollerTop<0 then
                            ScrollerTop:=0;
                          GT_SetSingleGadgetattr(mainwindowgads[ScrollerGadget], mainwindow,
                                                 GTSc_Top, ScrollerTop);
                          gadnumber:=scrollergadget;
                        end;
                     end;
                  idcmp_gadgetup :
                    begin
                      gadnumber:=pgsel^.gadgetid;
                      case pgsel^.gadgetid of
                        StringGadget : 
                          writeln('String entered : ',getstringfromgad(mainwindowgads[StringGadget]));
                        IntegerGadget:
                          writeln('Integer entered : ',getintegerfromgad(mainwindowgads[IntegerGadget]));
                        CycleGadget :
                          PresentCycleActive:=code;
                        PaletteGadget :
                          PresentColor:=code;
                        SliderGadget :
                          SliderPos:=code;
                        ScrollerGadget :
                          ScrollerTop:=code;
                       end;
                    end;
                  idcmp_gadgetdown :
                    begin
                      gadnumber:=pgsel^.gadgetid;
                      case pgsel^.gadgetid of
                        mxgadget :
                          presentmxselected:=code;
                        ScrollerGadget :
                          ScrollerTop:=code;
                       end;
                    end;

                 end;
                
                {* These are the same for both gadgetup and vanillakey  *}
                {* so to save code do only once.                        *}
                {* Not much saving in these case but can get important. *}
                
                case gadnumber of
                  ButtonGadget : 
                    writeln('Button Activated.');
                  QuitButton : 
                    begin
                      done:=true;
                      writeln('Bye...');
                    end;
                  CycleGadget :
                    writeln('Cycle Active : ',PresentCycleActive);
                  PaletteGadget :
                    writeln('Palette Color : ',PresentColor);
                  CheckBoxGadget :
                    writeln('CheckBox checked ? : ',gadselected(mainwindowgads[CheckBoxGadget]));
                  MXGadget :
                    writeln('MX Selected : ',presentmxselected);
                  SliderGadget :
                    Writeln('Slider Position : ',SliderPos);
                  ScrollerGadget :
                    Writeln('Scroller Top : ',ScrollerTop);
                 end;
                pimsg:=gt_getimsg(mainwindow^.userport);
              end;
          until done;
          
          closewindowmainwindow;
        end
       else
        writeln('Error : Could not open window.');
      closelibs;
    end
   else
    writeln('Error : Could not open libraries.');
end.

