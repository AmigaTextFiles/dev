{*********************************************}
{*                                           *}
{*       Designer (C) Ian OConnor 1994       *}
{*                                           *}
{*       Designer Produced Pascal Unit       *}
{*                                           *}
{*********************************************}

Unit objectmenu;

Interface

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility;

Function MakeMenuObjectMenu(VisualInfo : Pointer):Boolean;
Procedure Settagitem( pt : ptagitem ; tag : long ; data : long);
procedure printstring(pwin:pwindow;x,y:word;s:string;f,b:byte;font:ptextattr;dm:byte);
procedure stripintuimessages(mp:pmsgport;win:pwindow);
procedure closewindowsafely(win : pwindow);
function generalgadtoolsgad(kind         : long;
                            x,y,w,h,id   : word;
                            ptxt         : pbyte;
                            font         : ptextattr;
                            flags        : long;
                            visinfo      : pointer;
                            pprevgad     : pgadget;
                            userdata     : pointer;
                            taglist      : ptagitem
                           ):pgadget;
function getstringfromgad(pgad:pgadget):string;
function getintegerfromgad(pgad:pgadget):long;
function GadSelected(pgad:pgadget):Boolean;
procedure gt_setsinglegadgetattr(gad:pgadget;win:pwindow;tag1,tag2:long);
function openwindowtaglistnicely( pnewwin : pnewwindow;pt:ptagitem;tidcmp:long;pmport:pmsgport):pwindow;
procedure freebitmap(pbm : pbitmap;w,h:word);

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
  LocaleBase : plibrary;

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
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
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
  ObjectMenu:=createmenusa(@newmenus[1],Nil);
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

Procedure Settagitem( pt : ptagitem ; tag : long ; data : long);
Begin
  pt^.ti_tag:=tag;
  pt^.ti_data:=data;
end;

procedure printstring(pwin:pwindow;x,y:word;s:string;f,b:byte;font:ptextattr;dm:byte);
var
  mit : tintuitext;
  str : string;
begin
  str:=s+#0;
  with mit do
    begin
      frontpen:=f;
      backpen:=b;
      leftedge:=x;
      topedge:=y;
      itextfont:=font;
      drawmode:=dm;
      itext:=@str[1];
      nexttext:=nil;
    end;
  printitext(pwin^.rport,@mit,0,0);
end;

procedure stripintuimessages(mp:pmsgport;win:pwindow);
  var
  msg  : pintuimessage;
  succ : pnode;
begin
  msg:=pintuimessage(mp^.mp_msglist.lh_head);
  succ:=msg^.execmessage.mn_node.ln_succ;
  while (succ<>nil) do
    begin
      if (msg^.idcmpwindow=win) then
        begin
          remove(pnode(msg));
          replymsg(pmessage(msg));
        end;
      msg:=pintuimessage(succ);
      succ:=msg^.execmessage.mn_node.ln_succ;
    end;
end;

procedure closewindowsafely(win : pwindow);
begin
  forbid;
  stripintuimessages(win^.userport,win);
  win^.userport:=nil;
  if modifyidcmp(win,0) then ;
  permit;
  closewindow(win);
end;

function generalgadtoolsgad(kind         : long;
                            x,y,w,h,id   : word;
                            ptxt         : pbyte;
                            font         : ptextattr;
                            flags        : long;
                            visinfo      : pointer;
                            pprevgad     : pgadget;
                            userdata     : pointer;
                            taglist      : ptagitem
                           ):pgadget;
var
  newgad : tnewgadget;
begin
  with newgad do
    begin
      ng_textattr:=font;
      ng_leftedge:=x;
      ng_topedge:=y;
      ng_width:=w;
      ng_height:=h;
      ng_gadgettext:=ptxt;
      ng_gadgetid:=id;
      ng_flags:=flags;
      ng_visualinfo:=visinfo;
    end;
  generalgadtoolsgad:=creategadgeta(kind,pprevgad,@newgad,taglist)
end;

function getstringfromgad(pgad:pgadget):string;
var
  psi   : pstringinfo;
  strin : string;
begin
  psi:=pstringinfo(pgad^.specialinfo);
  ctopas(psi^.buffer^,strin);
  getstringfromgad:=strin+#0;
end;

function getintegerfromgad(pgad:pgadget):long;
var
  psi   : pstringinfo;
begin
  psi:=pstringinfo(pgad^.specialinfo);
  getintegerfromgad:=psi^.longint_;
end;

function GadSelected(pgad:pgadget):Boolean;
begin
  GadSelected:=((pgad^.flags and gflg_selected)<>0);
end;

procedure gt_setsinglegadgetattr(gad:pgadget;win:pwindow;tag1,tag2:long);
var
  t : array [1..3] of long;
begin
  t[1]:=tag1;
  t[2]:=tag2;
  t[3]:=tag_done;
  gt_setgadgetattrsa(gad,win,nil,@t[1]);
end;

function openwindowtaglistnicely( pnewwin : pnewwindow;pt:ptagitem;tidcmp:long;pmport:pmsgport):pwindow;
var
  temp : pwindow;
begin
  temp:=openwindowtaglist(pnewwin,pt);
  if temp<>nil then temp^.userport:=pmport;
  if temp<>nil then if modifyidcmp(temp,tidcmp) then;
  openwindowtaglistnicely:=temp;
end;

procedure freebitmap(pbm : pbitmap;w,h:word);
var
  loop : word;
begin
  for loop:= 0 to 7 do
    if pbm^.planes[loop]<>nil then
      freeraster(pbm^.planes[loop],w,h);
  freemem(pbm,sizeof(tbitmap));
end;

Begin
  ObjectMenu:=Nil;
End.
