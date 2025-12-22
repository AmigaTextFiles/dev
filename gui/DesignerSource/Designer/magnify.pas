unit magnify;

interface

uses asl,utility,routines,exec,intuition,amiga,workbench,layers,icon,diskfont,amigaguide,definitions,
     gadtools,graphics,dos,amigados,iffparse,designermenus,drawwindows,obsolete;

var
  drawmag   : boolean;
  activemag : boolean;
  
procedure startmagnifywindow(pdwn:pdesignerwindownode);
procedure handlemagnifywindow(messcopy : tintuimessage);
procedure drawmagnifybox(pdwn:pdesignerwindownode);
procedure updatemagnifywindow(pdwn:pdesignerwindownode);

implementation

procedure startmagnifywindow(pdwn:pdesignerwindownode);
const
  wintitle : string [15]='Magnify Window'#0;
  Gad0CycleTexts : array [0..1] of string[8]=
  (
  'Key pad'#0,
  'Mouse'#0
  );
  Gad1levelformat : string[11] ='Zoom :%2ld'#0;
  Gadgetstrings : array[0..2] of string[8]=
  (
  '_Mode'#0,
  ''#0,
  'Help...'#0
  );
var
  offx,offy : word;
  tags      : array[1..20] of ttagitem;
  pgad      : pgadget;
  loop      : word;
begin
  if pdwn^.magnifywindow=nil then
    begin
      
      offx:=pdwn^.editScreen^.WBorLeft;
      offy:=pdwn^.editScreen^.WBorTop+Pdwn^.editScreen^.Font^.ta_YSize+1;
      pdwn^.magnifywinGList:=Nil;
      pGad:=createcontext(@pdwn^.magnifywinGList);
      
      {
      For Loop:=0 to 1 do
        magnifywin_Gad0Labels[Loop]:=@Gad0CycleTexts[Loop,1];
      magnifywin_Gad0Labels[2]:=Nil;
      Settagitem(@tags[1], GT_UnderScore, Ord('_'));
      SetTagItem(@tags[2], GTCY_Labels, Long(@magnifywin_Gad0Labels));
      Settagitem(@tags[3], GTCY_Active, 1);
      Settagitem(@tags[4], Tag_Done, 0);
      pgad:=GeneralGadToolsGad( 7, offx+15, offy+7, 
      	104, 14, 0, @gadgetstrings[0,1],
        @topaz800, 2,
      	pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
      pdwn^.magnifywinGads[0]:=pGad;
      }
      
      pdwn^.magnifymode:=1;
      Settagitem(@tags[1], GTSL_Min, 2);
      Settagitem(@tags[2], GTSL_Max, 10);
      Settagitem(@tags[3], GTSL_Level, 2);
      Settagitem(@tags[4], GTSL_LevelFormat, Long(@Gad1levelformat[1]));
      Settagitem(@tags[5], GTSL_MaxLevelLen, 64);
      Settagitem(@tags[6], GTSL_LevelPlace, 2);
      Settagitem(@tags[7], GA_RelVerify, Long(True));
      Settagitem(@tags[8], GA_Immediate, Long(True));
      Settagitem(@tags[9], GT_UnderScore, Ord('_'));
      Settagitem(@tags[10], Tag_Done, 0);
      pdwn^.magnify:=2;
      pgad:=GeneralGadToolsGad( 11, offx+15, offy+7, 
              	104, 14, 1, @gadgetstrings[1,1],
                @ttopaz80, 2,
             	pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
      pdwn^.magnifywinGads[1]:=pGad;
      
      { help gadget
      pgad:=GeneralGadToolsGad( 1, offx+212, offy+7, 
            	75, 14, 2, @gadgetstrings[2,1],
                @topaz800, 16,
                pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
      pdwn^.magnifywinGads[2]:=pGad;
      }
      
      if pgad<>nil then
        begin
          settagitem(@tags[ 1],WA_Left  ,620);
          settagitem(@tags[ 2],WA_Top   ,100);
          settagitem(@tags[ 3],WA_Width ,224+offx);
          settagitem(@tags[ 4],WA_Height,86+offy);
          settagitem(@tags[ 5],WA_Title ,long(@WinTitle[1]));
          settagitem(@tags[ 6],WA_MinWidth ,223+offx);
          settagitem(@tags[ 7],WA_MinHeight,90+offy);
          settagitem(@tags[ 8],WA_MaxWidth ,1200);
          settagitem(@tags[ 9],WA_MaxHeight,1200);
          settagitem(@tags[10],WA_SizeGadget,long(true));
          settagitem(@tags[11],WA_DragBar,long(true));
          settagitem(@tags[12],WA_DepthGadget,long(true));
          settagitem(@tags[13],WA_CloseGadget,long(true));
          settagitem(@tags[14],WA_Activate,long(true));
          settagitem(@tags[15],WA_SmartRefresh,long(true));
          settagitem(@tags[16],WA_AutoAdjust,long(true));
          settagitem(@tags[17],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[18],wa_gadgets,long(pdwn^.magnifywinglist));
          settagitem(@tags[19],Tag_Done,0);
          pdwn^.magnifywindow:=routines.openwindowtaglistnicely(Nil,@tags[1],580 or
                                                                             idcmp_refreshwindow or
                                                                             slideridcmp or
                                                                             scrolleridcmp or
                                                                             buttonidcmp or
                                                                             idcmp_activewindow or
                                                                             idcmp_inactivewindow or
                                                                             idcmp_menupick or
                                                                             idcmp_newsize or
                                                                             idcmp_changewindow or
                                                                             idcmp_intuiticks or
                                                                             idcmp_gadgetdown);
          if pdwn^.magnifywindow<>nil then
            begin
              pdwn^.magnifywindow^.userdata:=pointer(pdwn);
              gt_refreshwindow(pdwn^.magnifywindow,nil);
              pdwn^.magnifymenu:=nil;
              if makemenumagnifymenu(pdwn^.helpwin.screenvisinfo) then
                begin
                  if setmenustrip(pdwn^.magnifywindow,magnifymenu) then
                    pdwn^.magnifymenu:=magnifymenu
                   else
                    freemenus(magnifymenu);
                end;
              settagitem(@tags[2],GT_VisualInfo,long(pdwn^.helpwin.screenvisinfo));
              settagitem(@tags[3],Tag_Done,0);
              DrawBevelBoxA(pdwn^.magnifywindow^.RPort,7+Offx,3+Offy,
                            190,22,@tags[2]);
              pdwn^.basexofbox:=pdwn^.magnifywindow^.borderleft+7;
              pdwn^.baseyofbox:=pdwn^.magnifywindow^.bordertop+30;
              pdwn^.widthofbox:=pdwn^.magnifywindow^.width-27-pdwn^.basexofbox;
              pdwn^.heightofbox:=pdwn^.magnifywindow^.height-5-pdwn^.baseyofbox;
              pdwn^.srcx:=pdwn^.editwindow^.leftedge;
              pdwn^.srcy:=pdwn^.editwindow^.topedge;
              activemag:=true;
              pdwn^.largecopy:=nil;
              pdwn^.oldmagnify:=2;
              drawmagnifybox(pdwn);
              inputmode:=1;
            end
           else
            Begin
              Freegadgets(pdwn^.magnifywinglist);
              telluser(pdwn^.optionswindow,'Could not open window.');
            end;
        end
       else
        telluser(pdwn^.optionswindow,'Could not create gadgets for magnify window.');
    end
   else
    begin
      WindowToFront(pdwn^.magnifywindow);
      activatewindow(pdwn^.magnifywindow);
    end;
end;

procedure handlemagnifywindow(messcopy : tintuimessage);
var
  pgsel : pgadget;
  class : long;
  code  : word;
  itemnumber : word;
  menunumber : word;
  dummy : long;
  pdwn  : pdesignerwindownode;
  tags  : array[1..10] of ttagitem;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pdwn:=pdesignerwindownode(messcopy.idcmpwindow^.userdata);
  dummy:=69;
  if (class=idcmp_gadgetup)or(class=idcmp_gadgetdown) then
    dummy:=pgsel^.gadgetid;
  if class=idcmp_closewindow then
    dummy:=50;
  if (class=changewindow) then
    drawmag:=false;
  if (class=idcmp_newsize) then
    if pdwn^.magnifywindow<>nil then
      drawmagnifybox(pdwn);
  if class=idcmp_inactivewindow then
    activemag:=false;
  if class=idcmp_activewindow then
    activemag:=true;
  if class=idcmp_menupick then
    begin
      ItemNumber:=ITEMNUM(code);
      MenuNumber:=MENUNUM(code);
      Case MenuNumber of
        MagnifyTitle :
          Case ItemNumber of
            MagnifyMenuHelp  : helpwindow(@pdwn^.helpwin,magnifywindowhelp);
            MagnifyMenuClose : closemagnifywindow(pdwn);
           end;
       end;
    end;
  case dummy of
    0  : pdwn^.magnifymode:=code;
    1  : begin
           if code<>pdwn^.magnify then
             begin
               pdwn^.magnify:=code;
               if pdwn^.magnifywindow<>nil then
                 drawmagnifybox(pdwn);
             end;
         end;
    50 : if inputmode=0 then
           closemagnifywindow(pdwn);
   end;
end;

procedure checksrccoords(pdwn : pdesignerwindownode);
begin
  { window only }
  {
  if pdwn^.srcx-1+pdwn^.magwidth>pdwn^.editwindow^.leftedge+pdwn^.editwindow^.width-1 then
    pdwn^.srcx:=pdwn^.editwindow^.leftedge+pdwn^.editwindow^.width-1-pdwn^.magwidth;
  if pdwn^.srcy-1+pdwn^.magheight>pdwn^.editwindow^.topedge+pdwn^.editwindow^.height-1 then
    pdwn^.srcy:=pdwn^.editwindow^.topedge+pdwn^.editwindow^.height-1-pdwn^.magheight;
  
  if pdwn^.srcx<pdwn^.editwindow^.leftedge then
    pdwn^.srcx:=pdwn^.editwindow^.leftedge;
  if pdwn^.srcy<pdwn^.editwindow^.topedge then
    pdwn^.srcy:=pdwn^.editwindow^.topedge;
  }
  { whole screen }
  
  if pdwn^.srcx>pdwn^.editscreen^.width-pdwn^.magwidth then
    pdwn^.srcx:=pdwn^.editscreen^.width-pdwn^.magwidth;
  if pdwn^.srcy>pdwn^.editscreen^.height-pdwn^.magheight then
    pdwn^.srcy:=pdwn^.editscreen^.height-pdwn^.magheight;
  
end;

procedure drawmagnifybox(pdwn : pdesignerwindownode);
var
  tags : array[1..3] of ttagitem;
  x,y,c : word;
  bsa   : tbitscaleargs;
begin
  if pdwn^.magnifywindow<>nil then
    begin
      if pdwn^.largecopy<>nil then
        freemyfullbitmap(pdwn^.largecopy,pdwn^.magwidth*pdwn^.oldmagnify,
         pdwn^.magheight*pdwn^.oldmagnify,pdwn^.screenprefs.sm_depth);
      pdwn^.largecopy:=nil;

      gt_refreshwindow(pdwn^.magnifywindow,nil);
      setapen(pdwn^.magnifywindow^.rport,0);
      rectfill(pdwn^.magnifywindow^.rport,pdwn^.basexofbox,
                                          pdwn^.baseyofbox,
                                          pdwn^.magnifywindow^.width-19,
                                          pdwn^.magnifywindow^.height-3);
      pdwn^.widthofbox:=pdwn^.magnifywindow^.width-27-pdwn^.basexofbox;
      pdwn^.heightofbox:=pdwn^.magnifywindow^.height-5-pdwn^.baseyofbox;
      settagitem(@tags[1],GTBB_Recessed,long(True));
      settagitem(@tags[2],GT_VisualInfo,long(pdwn^.helpwin.screenvisinfo));
      settagitem(@tags[3],Tag_Done,0);
      DrawBevelBoxA(pdwn^.magnifywindow^.RPort,pdwn^.basexofbox,pdwn^.baseyofbox,
        pdwn^.widthofbox,pdwn^.heightofbox,@tags[1]);
      
      pdwn^.magwidth:=trunc((pdwn^.widthofbox-6)/pdwn^.magnify);
      pdwn^.magheight:=trunc((pdwn^.heightofbox-4)/pdwn^.magnify);
      
      { alloc stuff here }
      pdwn^.oldmagnify:=pdwn^.magnify;
      pdwn^.largecopy:=allocatemyfullbitmap(pdwn^.magwidth*pdwn^.magnify,
          pdwn^.magheight*pdwn^.magnify,pdwn^.screenprefs.sm_depth);
      if pdwn^.largecopy<>nil then
        begin 
          updatemagnifywindow(pdwn);
        end
       else
        begin
          closemagnifywindow(pdwn);
          telluser(pdwn^.optionswindow,memerror);
        end;
    end;
end;

procedure updatemagnifywindow(pdwn:pdesignerwindownode);
var
  bsa     : tbitscaleargs;
  dummy   : long;
  oldmode : long;
  oldpen  : long;
begin
  checksrccoords(pdwn);
  if (pdwn^.magnifywindow<>nil)and(drawmag){and(not activemag)} then
    begin
      waitblit;
      with bsa do
        begin
          bsa_srcx:=pdwn^.srcx;
          bsa_srcy:=pdwn^.srcy;
          bsa_srcwidth:=pdwn^.magwidth;
          bsa_srcheight:=pdwn^.magheight;
          bsa_destx:=0;
          bsa_desty:=0;
          bsa_xsrcfactor:=1;
          bsa_ysrcfactor:=1;
          bsa_xdestfactor:=pdwn^.magnify;
          bsa_ydestfactor:=pdwn^.magnify;
          bsa_srcbitmap:=pdwn^.editwindow^.rport^.bitmap;
          bsa_destbitmap:=pdwn^.largecopy;
          bsa_flags:=0;
        end;
      bitmapscale(@bsa);
      waitblit;
      dummy:=long(bltbitmaprastport(pdwn^.largecopy,0,0,pdwn^.magnifywindow^.rport,
                        pdwn^.basexofbox+3,pdwn^.baseyofbox+2,pdwn^.magwidth*pdwn^.oldmagnify,
                        pdwn^.magheight*pdwn^.oldmagnify,$C0));
      
      waitblit;
      oldmode:=pdwn^.magnifywindow^.rport^.drawmode;
      setdrmd(pdwn^.magnifywindow^.rport,complement);
      oldpen:=pdwn^.magnifywindow^.rport^.fgpen;
      setapen(pdwn^.magnifywindow^.rport,1);
      
      { point }
      
      rectfill(pdwn^.magnifywindow^.rport,
               (pdwn^.mx-pdwn^.srcx)*pdwn^.magnify+pdwn^.basexofbox+3,
               (pdwn^.my-pdwn^.srcy)*pdwn^.magnify+pdwn^.baseyofbox+2,
               (pdwn^.mx-pdwn^.srcx)*pdwn^.magnify+pdwn^.basexofbox+3+pdwn^.magnify-1,
               (pdwn^.my-pdwn^.srcy)*pdwn^.magnify+pdwn^.baseyofbox+2+pdwn^.magnify-1);
      
      {crosshair}
      {
      rectfill(pdwn^.magnifywindow^.rport,
               (pdwn^.mx-pdwn^.srcx)*pdwn^.magnify+pdwn^.basexofbox+3,
               pdwn^.baseyofbox+2,
               (pdwn^.mx-pdwn^.srcx)*pdwn^.magnify+pdwn^.basexofbox+3+pdwn^.magnify-1,
               pdwn^.baseyofbox+2+pdwn^.magnify*pdwn^.magheight-1);
      rectfill(pdwn^.magnifywindow^.rport,
               pdwn^.basexofbox+3,
               (pdwn^.my-pdwn^.srcy)*pdwn^.magnify+pdwn^.baseyofbox+2,
               pdwn^.basexofbox+3+pdwn^.magnify*pdwn^.magwidth-1,
               (pdwn^.my-pdwn^.srcy)*pdwn^.magnify+pdwn^.baseyofbox+2+pdwn^.magnify-1);
      }
      setapen(pdwn^.magnifywindow^.rport,oldpen);
      setdrmd(pdwn^.magnifywindow^.rport,oldmode);
      drawmag:=false;
    end;
end;

end.