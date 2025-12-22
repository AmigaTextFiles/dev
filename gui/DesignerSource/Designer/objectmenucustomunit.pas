{*********************************************}
{*                                           *}
{*       Designer (C) Ian OConnor 1994       *}
{*                                           *}
{*       Designer Produced Pascal Unit       *}
{*                                           *}
{*********************************************}

Unit objectmenucustomunit;

Interface

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility,definitions,routines;

Function MakeMenuObjectMenu(VisualInfo : Pointer):Boolean;

Type

  PNewMenuArray = ^TNewMenuArray;
  TNewMenuArray = array [1..10000] of tnewmenu;

const

  ObjectMenu1 = 0;
  ObjectMenu1_Item1 = 0;
  ObjectMenu1_Item2 = 1;
  ObjectMenu1_Item3 = 2;
  ObjectMenu1_Item4 = 3;
  ObjectMenu1_Item5 = 4;
  ObjectMenu1_Item6 = 5;
  ObjectMenu3 = 1;
  useaspreset = 0;
  saveaspreset = 1;
  ObjectMenu2 = 2;
  ObjectMenuicclass = 0;
  ObjectMenumodelclass = 0;
  ObjectMenuimageclass = 1;
  ObjectMenuimageclasssubitem = 0;
  ObjectMenuframeiclass = 1;
  ObjectMenusysiclass = 2;
  ObjectMenufillrectclass = 3;
  ObjectMenuitexticlass = 4;
  ObjectMenugadgetclass = 2;
  ObjectMenupropgclass = 0;
  ObjectMenustrgclass = 1;
  ObjectMenubuttongclass = 2;
  ObjectMenufrbuttongclass = 3;
  ObjectMenugroupgclass = 4;
  ObjectMenugradientslider = 3;
  ObjectMenucolorwheel = 4;
  ObjectMenucustom = 5;
  ObjectMenuproprightborder = 0;
  ObjectMenupropbottomborder = 1;
  ObjectMenu4 = 3;
Var
  ObjectMenu : pmenu;

Implementation

Function MakeMenuObjectMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..32] of string[17]=
  (
  'Object Options'#0,
  'Font...'#0,
  'New Item 1'#0,
  'Help...'#0,
  'New Item 3'#0,
  'OK...'#0,
  'Cancel...'#0,
  'Presets'#0,
  'Use As Preset'#0,
  'Save As Preset'#0,
  'Standard'#0,
  'icclass'#0,
  'modelclass'#0,
  'imageclass'#0,
  'imageclass'#0,
  'frameiclass'#0,
  'sysiclass'#0,
  'fillrectclass'#0,
  'itexticlass'#0,
  'gadgetclass'#0,
  'propgclass'#0,
  'strgclass'#0,
  'buttongclass'#0,
  'frbuttonclass'#0,
  'groupgclass'#0,
  'gradientslider'#0,
  'colorwheel'#0,
  'Custom'#0,
  'PropRightBorder'#0,
  'PropBottomBorder'#0,
  'User'#0,
  ''#0
  );
  MenuCommKeys : array[1..32] of string[2]=
  (
  ''#0,
  'F'#0,
  ''#0,
  'H'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ''#0,
  'U'#0,
  'S'#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ' '#0
  );
  NewMenus : array[1..32] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
  buffer   : PNewMenuArray;
  pgn : pgadgetnode;
Begin
  
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 32 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        5  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
    
  buffer:=AllocVec(  sizeof(NewMenus) + sizeoflist(@PresetObjectList)*sizeof(tnewmenu),memf_clear );
  if buffer<>nil then
    begin
      copymem( @NewMenus[1], buffer, (round(sizeof(NewMenus)/sizeof(tnewmenu))-1)*sizeof(tnewmenu) );
      for loop:=32 to 31+sizeoflist(@PresetobjectList) do
        begin
          pgn:=pgadgetnode(getnthnode(@presetobjectlist, loop-32));
          buffer^[loop].Nm_Type:=nm_item;
          buffer^[loop].nm_label:=@pgn^.labelid[1];
        end;
      buffer^[32+sizeoflist(@PresetobjectList)].Nm_Type:=nm_end;        
    end;
  
  objectmenu:=nil;
  
  if buffer<>nil then
    begin
      ObjectMenu:=createmenusa(pointer(buffer),Nil);
      FreeVec(buffer);
    end;
  
  If ObjectMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(ObjectMenu,visualinfo,@tags[1]) then;
      makemenuObjectMenu:=True;
    end
   else
    makemenuObjectMenu:=false;
end;

end.