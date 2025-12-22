unit windowstuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,liststuff,objectproduction,producerlib,
     amigados,fonts,graphics,definitions,iffparse,amiga,asl,workbench,localestuff;

procedure processwindow(pdwn:pdesignerwindownode);
procedure processrendwindow(pdwn:pdesignerwindownode);

implementation

procedure processrendwindow(pdwn:pdesignerwindownode);
var
  psin     : psmallimagenode;
  s        : string;
  s2       : string;
  pbbn     : pbevelboxnode;
  ptn      : ptextnode;
  font     : ttextattr;
  fontname : string;
  change   : byte;
  type4    : boolean;
  type5    : boolean;
  n        : byte;
  countup  : word;
begin
  type4:=false;
  type5:=false;
  pbbn:=pbevelboxnode(pdwn^.bevelboxlist.mlh_head);
  while(pbbn^.ln_succ<>nil) do
    begin
      if pbbn^.beveltype=4 then
        type4:=true;
      if pbbn^.beveltype=5 then
        type4:=true;
      pbbn:=pbbn^.ln_succ;
    end;
  if sizeoflist(@pdwn^.bevelboxlist)+sizeoflist(@pdwn^.imagelist)+sizeoflist(@pdwn^.textlist)+
     sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      addline(@procfunclist,'','');
      s:='';
      if no0(pdwn^.winparams)<>'' then
        s:='; '+no0(pdwn^.winparams);
      addline(@procfunclist,'Procedure RendWindow'+nicestring(no0(pdwn^.labelid))+'( pwin:pwindow; vi:pointer '+s+' );','');
      if pdwn^.codeoptions[15] then
        addline(@procfuncdefslist,'Procedure RendWindow'+
             nicestring(no0(pdwn^.labelid))+'( pwin:pwindow; vi:pointer '+s+' );','');
      addline(@procfunclist,'Var','');
      addline(@procfunclist,'  Offx     : word;','');
      addline(@procfunclist,'  Offy     : word;','');
      if pdwn^.codeoptions[17] then
        begin
          addline(@procfunclist,'  scalex   : real;','');
          addline(@procfunclist,'  scaley   : real;','');
        end;
      if sizeoflist(@pdwn^.bevelboxlist)>0 then
        begin
          n:=3;
          if type4 or type5 then inc(n,3);
          str(n,s2);
          addline(@procfunclist,'  tags     : array[1..'+s2+'] of ttagitem;','');
        end;
      addline(@procfunclist,'Begin','');
      addline(@procfunclist,'  If pwin<>nil then','');
      addline(@procfunclist,'    Begin','');
      
      addgadgetimagerenders(pdwn,'        ');
      
      if pdwn^.codeoptions[9] and (not pdwn^.gimmezz) then
        begin
          addline(@procfunclist,'      Offx:=pwin^.borderleft;','');
          addline(@procfunclist,'      Offy:=pwin^.bordertop;','');
        end
       else
        begin
          str(pdwn^.offx,s);
          addline(@procfunclist,'      Offx:='+s+';','');
          str(pdwn^.offy,s);
          addline(@procfunclist,'      Offy:='+s+';','');
        end;
      if pdwn^.codeoptions[17] then
        begin
          str(pdwn^.fontx,s);
          addline(@procfunclist,'      scalex:=pwin^.WScreen^.RastPort.Font^.tf_XSize/'+s+';','');
          str(pdwn^.fonty,s);
          addline(@procfunclist,'      scaley:=pwin^.WScreen^.RastPort.Font^.tf_YSize/'+s+';','');
        end;
      if sizeoflist(@pdwn^.bevelboxlist)>0 then
        begin
          addline(@procfunclist,'      settagitem(@tags[1],GTBB_Recessed,long(True));','');
          addline(@procfunclist,'      settagitem(@tags[2],GT_VisualInfo,long(vi));','');
          addline(@procfunclist,'      settagitem(@tags[3],Tag_Done,0);','');
          if type4 then
            begin
              addline(@procfunclist,'      settagitem(@tags[4],GT_TagBase+77,2);','');
              addline(@procfunclist,'      settagitem(@tags[5],GT_VisualInfo,long(vi));','');
              addline(@procfunclist,'      settagitem(@tags[6],Tag_Done,0);','');
            end;
        end;
      psin:=psmallimagenode(pdwn^.imagelist.mlh_head);
      while(psin^.ln_succ<>nil) do
        begin
          if true then
            begin
              str(psin^.x,s);
              if pdwn^.codeoptions[17] then
                s:='round('+s+'*scalex)';
              s:=s+'+Offx,'#10'        ';
              str(psin^.y,s2);
              if pdwn^.codeoptions[17] then
                s2:='round('+s2+'*scaley)';
              s:=s+s2+'+Offy';
              addline(@procfunclist,'      DrawImage(pwin^.RPort,@'+sfp(psin^.pin^.in_label)+','+s+');','');
            end;
          psin:=psin^.ln_succ;
        end;
      pbbn:=pbevelboxnode(pdwn^.bevelboxlist.mlh_head);
      while(pbbn^.ln_succ<>nil) do
        begin
          case pbbn^.beveltype of
            0,4,5 : 
              begin
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:='round('+s+'*scalex)';
                s:=s+'+Offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+'+Offy,'#10'        ';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scalex)';
                s:=s+s2+',';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                if pbbn^.beveltype=0 then
                  s:=s+s2+',@tags[2]'
                 else
                  begin
                    if pbbn^.beveltype=4 then
                      addline(@procfunclist,'      tags[4].ti_data:=2;','')
                     else
                      addline(@procfunclist,'      tags[4].ti_data:=3;','');
                    s:=s+s2+',@tags[4]'
                  end;
                addline(@procfunclist,'      DrawBevelBoxA(pwin^.RPort,'+s+');','');
              end;
            1 :
              begin
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:='round('+s+'*scalex)';
                s:=s+'+Offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+'+Offy,'#10'        ';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scalex)';
                s:=s+s2+',';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+',@tags[1]';
                addline(@procfunclist,'      DrawBevelBoxA(pwin^.RPort,'+s+');','');
              end;
            2 :
              begin
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:='round('+s+'*scalex)';
                s:=s+'+Offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+'+Offy,'#10'        ';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scalex)';
                s:=s+s2+',';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+',@tags[2]';
                addline(@procfunclist,'      DrawBevelBoxA(pwin^.RPort,'+s+');','');
                str(pbbn^.x+4,s);
                if pdwn^.codeoptions[17] then
                  s:='round('+s+'*scalex)';
                s:=s+'+Offx,';
                str(pbbn^.y+2,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+'+Offy,'#10'        ';
                str(pbbn^.w-8,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scalex)';
                s:=s+s2+',';
                str(pbbn^.h-4,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+',@tags[1]';
                addline(@procfunclist,'      DrawBevelBoxA(pwin^.RPort,'+s+');','');
              end;
            3 :
              begin
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:='round('+s+'*scalex)';
                s:=s+'+Offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+'+Offy,'#10'        ';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scalex)';
                s:=s+s2+',';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+',@tags[1]';
                addline(@procfunclist,'      DrawBevelBoxA(pwin^.RPort,'+s+');','');
                str(pbbn^.x+4,s);
                if pdwn^.codeoptions[17] then
                  s:='round('+s+'*scalex)';
                s:=s+'+Offx,';
                str(pbbn^.y+2,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+'+Offy,'#10'        ';
                str(pbbn^.w-8,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scalex)';
                s:=s+s2+',';
                str(pbbn^.h-4,s2);
                if pdwn^.codeoptions[17] then
                  s2:='round('+s2+'*scaley)';
                s:=s+s2+',@tags[2]';
                addline(@procfunclist,'      DrawBevelBoxA(pwin^.RPort,'+s+');','');
              end;
           end;
          pbbn:=pbbn^.ln_succ;
        end;
      change:=1;
      countup:=0;
      ptn:=ptextnode(pdwn^.textlist.mlh_head);
      while (ptn^.ln_succ<>nil) do
        begin
            begin
              str(ptn^.x,s);
              if pdwn^.codeoptions[17] then
                s:='round('+s+'*scalex)';
              s:=s+'+Offx,';
              str(ptn^.y,s2);
              if pdwn^.codeoptions[17] then
                s2:='round('+s2+'*scaley)';
              s:=s+s2+'+Offy,'#10'        ';
              if not pdwn^.localeoptions[2] then
                s:=s+''''+sfp(ptn^.tn_title)+''','
               else
                begin
                  str(countup,s2);
                  inc(countup);
                  s:=s+sfp(producernode^.getstring)+'('+nicestring(no0(pdwn^.labelid))+'Text'+s2+')'+',';
                  localestring(sfp(ptn^.tn_title),nicestring(no0(pdwn^.labelid))+'Text'+s2,
                        ' Text in Window: '+no0(pdwn^.title)+' Text: '+sfp(ptn^.tn_title));
                end;
              
              str(ptn^.frontpen,s2);
              s:=s+s2+',';
              str(ptn^.backpen,s2);
              s:=s+s2;
              str(ptn^.drawmode,s2);
              if pdwn^.codeoptions[17] and ptn^.screenfont then
                addline(@procfunclist,'      PrintString(pwin,'+s+', pwin^.WScreen^.font,'+s2+');','')
               else
                addline(@procfunclist,'      PrintString(pwin,'+s+', @'
                                      +makemyfont(ptn^.ta)+','+s2+');','');
            end;
          ptn:=ptn^.ln_succ;
        end;
      addline(@procfunclist,'    end;','');
      addline(@procfunclist,'end;','');
    end;
end;

procedure processclosewindow(pdwn:pdesignerwindownode);
var 
  s   : string;
  s2  : string;
begin
  s:=no0(pdwn^.winparams);
  if s <> ''then
    s:='('+s+')';
  addline(@procfunclist,'','');
  addline(@procfunclist,'Procedure CloseWindow'+nicestring(no0(pdwn^.labelid))+s+';','');
  addline(@procfuncdefslist,'Procedure CloseWindow'+nicestring(no0(pdwn^.labelid))+s+';','');
  addline(@procfunclist,'Begin','');
  addline(@procfunclist,'  if '+no0(pdwn^.labelid)+'<>nil then','');
  addline(@procfunclist,'    Begin','');
  if pdwn^.codeoptions[11] then
    begin
      addline(@procfunclist,'      ClearMenuStrip('+no0(pdwn^.labelid)+');','');
      if pdwn^.codeoptions[14] then
        addline(@procfunclist,'      freemenus('+no0(pdwn^.menutitle)+');','');
    end;
  if pdwn^.codeoptions[18] then
    begin
      addline(@procfunclist,'      if nil<>'+no0(pdwn^.labelid)+'AppWin then','');
      addline(@procfunclist,'        if RemoveAppWindow( '+no0(pdwn^.labelid)+'AppWin) then;','');
    end;
  addline(@procfunclist,'      FreeScreenDrawInfo('+no0(pdwn^.labelid)+
                   '^.wscreen,'+no0(pdwn^.labelid)+'DrawInfo);','');     {36}
  if pdwn^.codeoptions[8] then
    addline(@procfunclist,'      Closewindowsafely('+no0(pdwn^.labelid)+');','')
   else
    addline(@procfunclist,'      Closewindow('+no0(pdwn^.labelid)+');','');
  addline(@procfunclist,'      '+no0(pdwn^.labelid)+':=Nil;','');
  str(pdwn^.maxw,s);
  str(pdwn^.maxh,s2);
  s:=s+', '+s2;
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    addline(@procfunclist,'      Freebitmap('+no0(pdwn^.labelid)+'BitMap, '+s+');','');
  addline(@procfunclist,'      FreeVisualInfo('+no0(pdwn^.labelid)+'Visualinfo);','');
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      addline(@procfunclist,'      FreeGadgets('+no0(pdwn^.labelid)+'GList);','');
      addfreeobjects(pdwn,'      ');
    end;
  addline(@procfunclist,'    end;','');
  addline(@procfunclist,'end;','');
end;

procedure addgadgetopenline(pdwn:pdesignerwindownode;pgn:pgadgetnode;s:string;spaces:string);
var
  t : string;
  u : string;
begin
  t:='pgad:=GeneralGadToolsGad( ';
  str(pgn^.kind,u);
  if pgn^.kind=mybool_kind then
    u:='Generic_kind';
  t:=t+u+', ';
  t:=t+'offx+';
  str(pgn^.x,u);
  if pdwn^.codeoptions[17] then
    u:='round('+u+'*scalex)';
  t:=t+u+', ';
  t:=t+'offy+';
  str(pgn^.y,u);
  if pdwn^.codeoptions[17] then
    u:='round('+u+'*scaley)';
  t:=t+u+', '#10+spaces+'	';
  str(pgn^.w,u);
  if (pdwn^.codeoptions[17]) and (pgn^.kind<>Generic_Kind) then
    u:='round('+u+'*scalex)';
  t:=t+u+', ';
  str(pgn^.h,u);
  if (pdwn^.codeoptions[17]) and (pgn^.kind<>Generic_Kind) then
    u:='round('+u+'*scaley)';
  t:=t+u+', ';
  str(pgn^.id,u);
  if pgn^.kind=mybool_kind then
    t:=t+u+', Nil,'
   else
    begin
      if not pdwn^.localeoptions[1] then
        t:=t+u+', @gadgetstrings['+u+',1],'
       else
        begin
          localestring(no0(pgn^.title),no0(pgn^.labelid)+'String','Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid));
          t:=t+u+', '+sfp(producernode^.getstring)+'ptr('+no0(pgn^.labelid)+'String),';
        end;
    end;
  addline(@procfunclist,spaces+t,'');
  
  if pdwn^.codeoptions[17] then
    t:='                         pScr^.Font, '
   else
    if pdwn^.codeoptions[6] then
      t:='                         @'+makemyfont(pdwn^.gadgetfont)+', '
     else
      t:='                         @'+makemyfont(pgn^.font)+', ';
  
  str(pgn^.flags,u);
  t:=t+u+','#10+spaces+'	'+no0(pdwn^.labelid)+'VisualInfo, pGad, Nil, '+s+');'#0;
  addline(@procfunclist,spaces+t,'');
  str(pgn^.id,u);
  if pdwn^.codeoptions[10] then
    addline(@procfunclist,spaces+no0(pdwn^.labelid)+'Gads['+u+']:=pGad;','');
end;

procedure dogadgets(pdwn:pdesignerwindownode;spaces : string);
var
  pgn       : pgadgetnode;
  s         : string;
  loop      : long;
  s2        : string;
  pgn2      : pgadgetnode;
  fontstyle : long;
  fontysize : long;
  pin       : pimagenode;
  fontflags : long;
  fontname  : string;
begin
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      loop:=1;
        case pgn^.kind of
          Palette_kind: begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or paletteidcmp;
                          if pgn^.tags[1].ti_data<>1 then
                            begin
                              str(loop,s);
                              if pgn^.tags[1].ti_data>0 then
                                begin
                                  str(pgn^.tags[1].ti_data,s2);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTPA_Depth, '+s2+');','');
                                end
                               else
                                addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTPA_Depth, '
                                                      +no0(pdwn^.labelid)+'Depth);','');
                              inc(loop);
                            end;
                          if pgn^.tags[2].ti_data<>1 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTPA_Color, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[3].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[3].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTPA_ColorOffset, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[4].ti_tag<>tag_ignore then
                            begin
                              str(loop,s);
                              str(pgn^.tags[4].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTPA_IndicatorWidth, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[5].ti_tag<>tag_ignore then
                            begin
                              str(loop,s);
                              str(pgn^.tags[5].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTPA_IndicatorHeight, '+s2+');','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[7].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Disabled, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[8].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          str(loop,s);
                          if loop>1 then
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          if loop>1 then
                            s:='@tags[1]'
                           else
                            s:='Nil';
                          addgadgetopenline(pdwn,pgn,s,spaces);
                        end;
          ListView_kind:begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or listviewidcmp;
                          if pgn^.tags[10].ti_data=long(true) then
                            begin
                              loop:=sizeoflist(@pgn^.infolist);
                              str(loop-1,s);
                              addline(@procfunclist,spaces+'NewList(@'+no0(pgn^.labelid)+'List);','');
                              addline(@procfunclist,spaces+'For Loop:=0 to '+s+' do','');
                              addline(@procfunclist,spaces+'  Begin','');
                              if pdwn^.localeoptions[1] then
                                addline(@procfunclist,spaces+'    '+no0(pgn^.labelid)+'ListItems[Loop].ln_name:='
                                                    +sfp(producernode^.getstring)+
                                                    'ptr('+no0(pgn^.labelid)+'ListViewTexts[Loop]);','')
                               else
                                addline(@procfunclist,spaces+'    '+no0(pgn^.labelid)+'ListItems[Loop].ln_name:=@'
                                                    +no0(pgn^.labelid)+'ListViewTexts[Loop,1];','');
                              
                              addline(@procfunclist,spaces+'    AddTail( @'+no0(pgn^.labelid)+'List, @'
                                                    +no0(pgn^.labelid)+'ListItems[Loop]);','');
                              addline(@procfunclist,spaces+'  end;','');
                            end;
                          loop:=1;
                          if pgn^.tags[3].ti_tag=GTLV_showselected then
                            begin
                              if pgn^.tags[3].ti_data=0 then
                                s2:='0'
                               else
                                s2:='Long(pgad)';
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTLV_ShowSelected, '+s2+');','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+
                                                   '], GT_TagBase+83, long('+no0(pgn^.edithook)+'));','');
                              inc(loop);
                            end;
                          if pgn^.tags[2].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTLV_Top, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[4].ti_data<>16 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[4].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTLV_ScrollWidth, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[5].ti_data<>~0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[5].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTLV_Selected, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[6].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[6].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], LAYOUTA_Spacing, '+s2+');','');
                              inc(loop);
                            end;
                          if Boolean(pgn^.tags[8].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTLV_ReadOnly, Long(True));','');
                              inc(loop);
                            end;
                          if pgn^.tags[10].ti_data=long(true) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'SetTagItem(@tags['+s+'], GTLV_Labels, Long(@'
                                      +no0(pgn^.labelid)+'List));','');
                              inc(loop);
                            end;
                          str(loop,s);
                          addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          addgadgetopenline(pdwn,pgn,'@tags[1]',spaces);
                          inc(loop);
                        end;
          MX_kind     : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or mxidcmp;
                          loop:=sizeoflist(@pgn^.infolist);
                          str(loop-1,s);
                          addline(@procfunclist,spaces+'For Loop:=0 to '+s+' do','');
                          if pdwn^.localeoptions[1] then
                            addline(@procfunclist,spaces+'  '+no0(pgn^.labelid)+'Labels[Loop]:='
                                                 +sfp(producernode^.getstring)+'ptr('+no0(pgn^.labelid)+'MXTexts[Loop]);','')
                           else
                            addline(@procfunclist,spaces+'  '+no0(pgn^.labelid)+'Labels[Loop]:=@'
                                                 +no0(pgn^.labelid)+'MXTexts[Loop,1];','');
                          str(loop,s);
                          addline(@procfunclist,spaces+no0(pgn^.labelid)+'Labels['+s+']:=Nil;','');
                          loop:=1;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[6].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+69, '+
                                   'Long(True));  { V39 MX scaling }','');
                              inc(loop);
                            end;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTMX_Active, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[2].ti_data<>1 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTMX_Spacing, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[7].ti_data<>placetext_left then
                            begin
                              str(loop,s);
                              str(pgn^.tags[7].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+71, '+s2+');','');
                              inc(loop);
                            end;
                          str(loop,s);
                          addline(@procfunclist,spaces+'SetTagItem(@tags['+s+'], GTMX_Labels, Long(@'
                                  +no0(pgn^.labelid)+'Labels));','');
                          inc(loop);
                          str(loop,s);
                          addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          addgadgetopenline(pdwn,pgn,'@tags[1]',spaces);
                        end;
          cycle_kind  : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or cycleidcmp;
                          loop:=sizeoflist(@pgn^.infolist);
                          str(loop-1,s);
                          addline(@procfunclist,spaces+'For Loop:=0 to '+s+' do','');
                          if pdwn^.localeoptions[1] then
                            addline(@procfunclist,spaces+'  '+no0(pgn^.labelid)+'Labels[Loop]:='
                                                 +sfp(producernode^.getstring)
                                                 +'ptr('+no0(pgn^.labelid)+'CycleTexts[Loop]);','')
                           else
                            addline(@procfunclist,spaces+'  '+no0(pgn^.labelid)+'Labels[Loop]:=@'
                                                 +no0(pgn^.labelid)+'CycleTexts[Loop,1];','');
                          str(loop,s);
                          addline(@procfunclist,spaces+no0(pgn^.labelid)+'Labels['+s+']:=Nil;','');
                          loop:=1;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[6].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Disabled, Long(True));','');
                              inc(loop);
                            end;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTCY_Active, '+s2+');','');
                              inc(loop);
                            end;
                          str(loop,s);
                          addline(@procfunclist,spaces+'SetTagItem(@tags['+s+'], GTCY_Labels, Long(@'
                                  +no0(pgn^.labelid)+'Labels));','');
                          inc(loop);
                          str(loop,s);
                          addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          addgadgetopenline(pdwn,pgn,'@tags[1]',spaces);
                        end;
          button_kind : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or buttonidcmp;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[2].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Disabled, Long(True));','');
                              inc(loop);
                            end;
                          str(loop,s);
                          if loop>1 then
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          if loop>1 then
                            s:='@tags[1]'
                           else
                            s:='Nil';
                          addgadgetopenline(pdwn,pgn,s,spaces);
                        end;
          mybool_kind : begin
                          addgadgetopenline(pdwn,pgn,'Nil',spaces);
                          addline(@procfunclist,spaces+'if pgad<>nil then','');
                          addline(@procfunclist,spaces+'  begin','');
                          spaces:=spaces+'    ';
                          pin:=pimagenode(pgn^.pointers[1]);
                          if pin<>nil then
                            addline(@procfunclist,spaces+'pgad^.gadgetrender:=@'+sfp(pin^.in_label)+';','');
                          pin:=pimagenode(pgn^.pointers[2]);
                          if pin<>nil then
                            addline(@procfunclist,spaces+'pgad^.selectrender:=@'+sfp(pin^.in_label)+';','');
                          s:='';
                          if (pgn^.tags[1].ti_tag and gact_toggleselect)<>0 then
                            s:=s+'GACT_TOGGLESELECT or ';
                          if (pgn^.tags[1].ti_tag and gact_immediate)<>0 then
                            s:=s+'GACT_IMMEDIATE or ';
                          if (pgn^.tags[1].ti_tag and gact_relverify)<>0 then
                            s:=s+'GACT_RELVERIFY or ';
                          if (pgn^.tags[1].ti_tag and gact_followmouse)<>0 then
                            s:=s+'GACT_FOLLOWMOUSE or ';
                          if s<>'' then
                            begin
                              dec(s[0],3);
                              addline(@procfunclist,spaces+'pgad^.activation:='+s+';','');
                            end;
                          pgn^.flags:=pgn^.flags or gflg_gadgimage;
                          str(pgn^.flags,s);
                          addline(@procfunclist,spaces+'pgad^.flags:='+s+';','');
                          addline(@procfunclist,spaces+'pgad^.gadgettype:=pgad^.gadgettype or GTYP_BOOLGADGET;','');
                          if boolean(pgn^.tags[1].ti_data) then
                            begin
                              addline(@varlist,'  '+no0(pgn^.labelid)+'IText : tintuitext;','');
                              addline(@procfunclist,spaces+'with '+no0(pgn^.labelid)+'IText do','');
                              addline(@procfunclist,spaces+'  begin','');
                              str(pgn^.tags[3].ti_tag,s);
                              addline(@procfunclist,spaces+'    FrontPen:='+s+';','');
                              str(pgn^.tags[3].ti_data,s);
                              addline(@procfunclist,spaces+'    BackPen:='+s+';','');
                              str(pgn^.tags[4].ti_tag,s);
                              addline(@procfunclist,spaces+'    DrawMode:='+s+';','');
                              str(pgn^.tags[2].ti_tag,s);
                              addline(@procfunclist,spaces+'    leftedge:='+s+';','');
                              str(pgn^.tags[2].ti_data,s);
                              addline(@procfunclist,spaces+'    topedge:='+s+';','');
                              if pdwn^.codeoptions[17] then
                                s:='pScr^.Font'
                               else
                                if pdwn^.codeoptions[6] then
                                  s:='@'+makemyfont(pdwn^.gadgetfont)
                                 else
                                  s:='@'+makemyfont(pgn^.font);
                              addline(@procfunclist,spaces+'    ITextFont:='+s+';','');
                              str(pgn^.id,s);
                              if pdwn^.localeoptions[1] then
                                begin
                                  localestring(no0(pgn^.title),no0(pgn^.labelid)+'String',
                                            'Window: '+no0(pdwn^.title)+' Boolean Gadget: '+no0(pgn^.labelid));
                                  addline(@procfunclist,spaces+'    IText:='+sfp(producernode^.getstring)+
                                       'ptr('+no0(pgn^.labelid)+'String);','');
                                end
                               else
                                addline(@procfunclist,spaces+'    IText:=@GadgetStrings['+s+',1];','');
                              addline(@procfunclist,spaces+'    NextText:=Nil;','');
                              addline(@procfunclist,spaces+'  end;','');
                              addline(@procfunclist,spaces+'pgad^.gadgettext:=@'+no0(pgn^.labelid)+'IText;','');
                            end;
                          dec(spaces[0],4);
                          addline(@procfunclist,spaces+'  end;','');
                        end;
          number_kind : begin
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTNM_Number, '+s2+');','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[2].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTNM_Border, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              if pgn^.tags[6].ti_data<>1 then
                                begin
                                  str(pgn^.tags[6].ti_data,s2);
                                  str(loop,s);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+72, '+s2+');','');
                                  inc(loop);
                                end;
                              if pgn^.tags[7].ti_data<>0 then
                                begin
                                  str(pgn^.tags[7].ti_data,s2);
                                  str(loop,s);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+73, '+s2+');','');
                                  inc(loop);
                                end;
                              if pgn^.tags[8].ti_data<>1 then
                                begin
                                  str(pgn^.tags[8].ti_data,s2);
                                  str(loop,s);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+74, '+s2+');','');
                                  inc(loop);
                                end;
                              if not boolean(pgn^.tags[9].ti_data) then
                                begin
                                  str(loop,s);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+85, long(False));','');
                                  inc(loop);
                                end;
                              if pgn^.tags[10].ti_data<>0 then
                                begin
                                  str(pgn^.tags[10].ti_data,s2);
                                  str(loop,s);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+76, '+s2+');','');
                                  inc(loop);
                                end;
                              
                              if no0(pgn^.datas)<>''then
                                begin
                                  str(loop,s);
                                  if pdwn^.localeoptions[1] then
                                    addline(@procfunclist,spaces+'Settagitem(@tags['+s+
                                    '], GT_TagBase+75, Long('+sfp(producernode^.getstring)+
                                            'ptr('+no0(pgn^.labelid)+'StringFormat)'+
                                                '));','')
                                   else
                                    addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+75, Long(@'
                                                +no0(pgn^.labelid)+'LevelFormatText[1]));','');
                                  if pdwn^.localeoptions[1] then
                                    localestring(no0(pgn^.datas),no0(pgn^.labelid)+'StringFormat',
                                      'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' String Format');
                                  inc(loop);
                                end;
                              
                            end;
                          str(loop,s);
                          if loop>1 then
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          if loop>1 then
                            s:='@tags[1]'
                           else
                            s:='Nil';
                          addgadgetopenline(pdwn,pgn,s,spaces);
                        end;
           text_kind  : begin
                          str(loop,s);
                          str(pgn^.tags[1].ti_data,s2);
                          if pdwn^.localeoptions[1] then
                            begin
                              localestring(no0(pgn^.datas),no0(pgn^.labelid)+'InitText',
                                  'Window: '+no0(pdwn^.title)+' Text Display Gadget: '+no0(pgn^.title)+' Initial Text');
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTTX_Text, Long('+
                                                sfp(producernode^.getstring)+'ptr('
                                                +no0(pgn^.labelid)+'InitText)));','');
                            end
                           else
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTTX_Text, Long(@'
                                                +no0(pgn^.labelid)+'InitText[1]));','');
                          inc(loop);
                          if boolean(pgn^.tags[2].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['
                                                    +s+'], GTTX_Border, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTTX_CopyText, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              if pgn^.tags[6].ti_data<>1 then
                                begin
                                  str(pgn^.tags[6].ti_data,s2);
                                  str(loop,s);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+72, '+s2+');','');
                                  inc(loop);
                                end;
                              if pgn^.tags[7].ti_data<>0 then
                                begin
                                  str(pgn^.tags[7].ti_data,s2);
                                  str(loop,s);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+73, '+s2+');','');
                                  inc(loop);
                                end;
                              if pgn^.tags[8].ti_data<>1 then
                                begin
                                  str(pgn^.tags[8].ti_data,s2);
                                  str(loop,s);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+74, '+s2+');','');
                                  inc(loop);
                                end;
                              if not boolean(pgn^.tags[9].ti_data) then
                                begin
                                  str(loop,s);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+85, long(False));','');
                                  inc(loop);
                                end;
                            end;
                          str(loop,s);
                          if loop>1 then
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          if loop>1 then
                            s:='@tags[1]'
                           else
                            s:='Nil';
                          addgadgetopenline(pdwn,pgn,s,spaces);
                        end;
           string_kind : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or stringidcmp;
                          
                          if sfp(pointer(gettagdata(gtst_string,0,pgn^.gn_gadgettags)))<>'' then
                            begin
                              str(loop,s);
                              s2:='Long(@'+no0(pgn^.labelid)+'DefaultString[1])';
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTST_String, '+
                                       s2+');','');
                              inc(loop);
                            end;
                          
                          if pgn^.tags[1].ti_data<>64 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTST_MaxChars, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[2].ti_data<>gact_stringleft then
                            begin
                              str(loop,s);
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], STRINGA_Justification, '+s2+');','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], STRINGA_ReplaceMode, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Disabled, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], STRINGA_ExitHelp, Long(True));','');
                              inc(loop);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+
                                           '], GTST_EditHook, long('+no0(pgn^.edithook)+'));','');
                              inc(loop);
                            end;
                          if not boolean(pgn^.tags[6].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_TabCycle, Long(False));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[8].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Immediate, Long(True));','');
                              inc(loop);
                            end;
                          str(loop,s);
                          if loop>1 then
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          if loop>1 then
                            s:='@tags[1]'
                           else
                            s:='Nil';
                          addgadgetopenline(pdwn,pgn,s,spaces);
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@procfunclist,spaces+'if (pGad<>nil) and (gadtoolsbase^.lib_version=37) then','');
                              addline(@procfunclist,spaces+'  pgad^.activation:=pgad^.activation or gact_immediate;','');
                            end;
                        end;
          integer_kind: begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or integeridcmp;
                          
                          if gettagdata(gtin_number,0,pgn^.gn_gadgettags)<>0 then
                            begin
                              str(loop,s);
                              str(gettagdata(gtin_number,0,pgn^.gn_gadgettags),s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTIN_Number, '+
                                       s2+');','');
                              inc(loop);
                            end;
                          
                          if pgn^.tags[1].ti_data<>10 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTIN_MaxChars, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[2].ti_data<>gact_stringleft then
                            begin
                              str(loop,s);
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], STRINGA_Justification, '+s2+');','');
                              inc(loop);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+
                                          '], GTST_EditHook, long('+no0(pgn^.edithook)+'));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], STRINGA_ReplaceMode, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Disabled, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], STRINGA_ExitHelp, Long(True));','');
                              inc(loop);
                            end;
                          if not boolean(pgn^.tags[6].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_TabCycle, Long(False));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[8].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Immediate, Long(True));','');
                              inc(loop);
                            end;
                          str(loop,s);
                          if loop>1 then
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          if loop>1 then
                            s:='@tags[1]'
                           else
                            s:='Nil';
                          addgadgetopenline(pdwn,pgn,s,spaces);
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@procfunclist,spaces+'if (pGad<>nil) and (gadtoolsbase^.lib_version=37) then','');
                              addline(@procfunclist,spaces+'  pgad^.activation:=pgad^.activation or gact_immediate;','');
                            end;
                        end;
          CheckBox_kind:begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or checkboxidcmp;
                          if boolean(pgn^.tags[1].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTCB_Checked, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Disabled, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_TagBase+68, '+
                                   'Long(True));  { V39 CheckBox scaling }','');
                              inc(loop);
                            end;
                          str(loop,s);
                          if loop>1 then
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          if loop>1 then
                            s:='@tags[1]'
                           else
                            s:='Nil';
                          addgadgetopenline(pdwn,pgn,s,spaces);
                        end;
          Slider_kind : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or slideridcmp;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTSL_Min, '+s2+');','');
                              inc(loop);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+
                                            '], GTSL_DispFunc, long('+no0(pgn^.edithook)+'));','');
                              inc(loop);
                            end;
                          if pgn^.tags[2].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTSL_Max, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[3].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[3].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTSL_Level, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[9].ti_data<>lorient_horiz then
                            begin
                              str(loop,s);
                              str(pgn^.tags[9].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], PGA_Freedom, '+s2+');','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              str(loop,s);
                              if pdwn^.localeoptions[1] then
                                begin
                                  localestring(no0(pgn^.datas),no0(pgn^.labelid)+'levelformat',
                                      'Window: '+no0(pdwn^.title)+' Slider Gadget: '+no0(pgn^.title));
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+
                                    '], GTSL_LevelFormat, Long('+sfp(producernode^.getstring)+
                                        'ptr('+no0(pgn^.labelid)+'levelformat)));','');
                                end
                               else
                                addline(@procfunclist,spaces+'Settagitem(@tags['+s+
                                    '], GTSL_LevelFormat, Long(@'+no0(pgn^.labelid)+'levelformat[1]));','');
                              inc(loop);
                              if pgn^.tags[5].ti_data<>0 then
                                begin
                                  str(loop,s);
                                  str(pgn^.tags[5].ti_data,s2);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTSL_MaxLevelLen, '+s2+');','');
                                  inc(loop);
                                end;
                              if pgn^.tags[6].ti_data<>placetext_left then
                                begin
                                  str(loop,s);
                                  str(pgn^.tags[6].ti_data,s2);
                                  addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTSL_LevelPlace, '+s2+');','');
                                  inc(loop);
                                end;
                            end;
                          if boolean(pgn^.tags[12].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Immediate, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[13].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_RelVerify, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[11].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Disabled, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[14].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          str(loop,s);
                          if loop>1 then
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          if loop>1 then
                            s:='@tags[1]'
                           else
                            s:='Nil';
                          addgadgetopenline(pdwn,pgn,s,spaces);
                        end;
          Scroller_kind:begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or scrolleridcmp;
                          if pgn^.tags[7].ti_data<>lorient_horiz then
                            begin
                              str(loop,s);
                              str(pgn^.tags[7].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], PGA_Freedom, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTSC_Top, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[2].ti_data<>0 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTSC_Total, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[3].ti_data<>2 then
                            begin
                              str(loop,s);
                              str(pgn^.tags[3].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTSC_Visible, '+s2+');','');
                              inc(loop);
                            end;
                          if pgn^.tags[4].ti_tag<>tag_ignore then
                            begin
                              pdwn^.idcmpvalues:=pdwn^.idcmpvalues or arrowidcmp;
                              str(loop,s);
                              str(pgn^.tags[4].ti_data,s2);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GTSC_Arrows, '+s2+');','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[10].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Immediate, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[11].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_RelVerify, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GA_Disabled, Long(True));','');
                              inc(loop);
                            end;
                          if boolean(pgn^.tags[12].ti_data) then
                            begin
                              str(loop,s);
                              addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], GT_UnderScore, Ord(''_''));','');
                              inc(loop);
                            end;
                          str(loop,s);
                          if loop>1 then
                            addline(@procfunclist,spaces+'Settagitem(@tags['+s+'], Tag_Done, 0);','');
                          if loop>1 then
                            s:='@tags[1]'
                           else
                            s:='Nil';
                          addgadgetopenline(pdwn,pgn,s,spaces);
                        end;
         end;
      pgn:=pgn^.ln_succ;
    end;
end;

procedure processwindowidcmp(pdwn:pdesignerwindownode);
const
  idcmpstrings : array[1..25] of string[20]=
  (
  'MOUSEBUTTONS',
  'MOUSEMOVE',
  'DELTAMOVE',
  'GADGETDOWN',
  'GADGETUP',
  'CLOSEWINDOW',
  'MENUPICK',
  'MENUVERIFY',
  'MENUHELP',
  'REQSET',
  'REQCLEAR',
  'REQVERIFY',
  'NEWSIZE',
  'REFRESHWINDOW',
  'SIZEVERIFY',
  'ACTIVEWINDOW',
  'INACTIVEWINDOW',
  'VANILLAKEY',
  'RAWKEY',
  'NEWPREFS',
  'DISKINSERTED',
  'DISKREMOVED',
  'INTUITICKS',
  'IDCMPUPDATE',
  'CHANGEWINDOW'
  );
var
  loop    : word;
  psn     : pstringnode;
  spaces  : string[50];
  pgn     : pgadgetnode;
  countup : long;
  s       : string;
begin
  {assume code,class,iaddress  need var pgsel}
  addline(@idcmplist,'','');
  if comment and (not producernode^.codeoptions[7]) then
    begin
      addline(@idcmplist,'','{ Cut the core out of this procedure and edit it suitably. }');
      addline(@idcmplist,'','');
    end;
  s:='';
  if no0(pdwn^.winparams)<>'' then
    s:='; '+no0(pdwn^.winparams);
  addline(@idcmplist,'Procedure ProcessWindow'+nicestring(no0(pdwn^.labelid))+
          '( Class : long ; Code : word ; IAddress : pbyte '+s+');','');
  addline(@idcmplist,'Var','');
  addline(@idcmplist,'  pgsel : pgadget;','');
  addline(@idcmplist,'Begin','');
  spaces:='  ';
  addline(@idcmplist,spaces+'Case Class of','');
  for loop:=1 to 25 do
    if pdwn^.idcmplist[Loop] then
      begin
        addline(@idcmplist,spaces+'  IDCMP_'+idcmpstrings[loop]+' :','');
        addline(@idcmplist,spaces+'    Begin','');
        case loop of
          1 :
            begin
              addline(@idcmplist,'',spaces+'      { Mouse Button Action }');
              addline(@idcmplist,'',spaces+'      { Code contains selectup/down, middleup/down or menuup/down }');
            end;
          2 :
            begin
              addline(@idcmplist,'',spaces+'      { Mouse Movement }');
              addline(@idcmplist,'',spaces+'      { Message has absolute [Window] mouse coords. }');
            end;
          3 :
            begin
              if comment then
                begin
                  addline(@idcmplist,'',spaces+'      { Mouse Movement }');
                  addline(@idcmplist,'',spaces+'      { Message has relative mouse coords. }');
                end;
            end;
          4 : {gadgetdown}
            begin
              countup:=0;
              addline(@idcmplist,'',spaces+'      { Gadget message, gadget = pgsel. }');
              addline(@idcmplist,spaces+'      pgsel:=pgadget(iaddress);','');
              addline(@idcmplist,spaces+'      Case pgsel^.gadgetid of','');
              pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
              while(pgn^.ln_succ<>nil) do
                begin
                  if 
                     (pgn^.kind = string_kind) or
                     (pgn^.kind = mx_kind) or
                     (pgn^.kind = Slider_kind) or
                     (pgn^.kind = Scroller_kind) or
                     (pgn^.kind = integer_kind) or
                     (pgn^.kind = mybool_kind) then
                    begin
                      inc(countup);
                      addline(@idcmplist,spaces+'        '+no0(pgn^.labelid)+' :','');
                      addline(@idcmplist,spaces+'          Begin','');
                      case pgn^.kind of
                        string_kind :
                          addline(@idcmplist,'',spaces
                              +'            { String entered  , Text of gadget : '+no0(pgn^.title)+' }');
                        integer_kind :
                          addline(@idcmplist,'',spaces
                              +'            { Integer entered , Text of gadget : '+no0(pgn^.title)+' }');
                        MX_kind :
                          addline(@idcmplist,'',spaces
                              +'            { MX changed      , Text of gadget : '+no0(pgn^.title)+' }');
                        Slider_kind :
                          addline(@idcmplist,'',spaces
                              +'            { Slider changed  , Text of gadget : '+no0(pgn^.title)+' }');
                        Scroller_kind :
                          addline(@idcmplist,'',spaces
                              +'            { Scroller changed, Text of gadget : '+no0(pgn^.title)+' }');
                        mybool_kind :
                          addline(@idcmplist,'',spaces
                              +'            { Boolean changed , Text of gadget : '+no0(pgn^.title)+' }');
                       end;
                      addline(@idcmplist,spaces+'          end;','');
                    end;
                  pgn:=pgn^.ln_succ;
                end;
              if countup>0 then
                addline(@idcmplist,spaces+'       end;','')
               else
                begin
                  psn:=pstringnode(remtail(@idcmplist));
                  freemymem(psn);
                end;
            end;
          5 : {gadgetup}
            begin
              countup:=0;
              addline(@idcmplist,'',spaces+'      { Gadget message, gadget = pgsel. }');
              addline(@idcmplist,spaces+'      pgsel:=pgadget(iaddress);','');
              addline(@idcmplist,spaces+'      Case pgsel^.gadgetid of','');
              pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
              while(pgn^.ln_succ<>nil) do
                begin
                  if (pgn^.kind = button_kind) or
                     (pgn^.kind = string_kind) or
                     (pgn^.kind = cycle_kind) or
                     (pgn^.kind = Slider_kind) or
                     (pgn^.kind = Scroller_kind) or
                     (pgn^.kind = checkbox_kind) or
                     (pgn^.kind = integer_kind) or
                     (pgn^.kind = listview_kind) or
                     (pgn^.kind = palette_kind) or 
                     (pgn^.kind = mybool_kind) then
                    begin
                      inc(countup);
                      addline(@idcmplist,spaces+'        '+no0(pgn^.labelid)+' :','');
                      addline(@idcmplist,spaces+'          Begin','');
                      case pgn^.kind of
                        mybool_kind :
                          addline(@idcmplist,'',spaces+
                              '            { Boolean changed , Text of gadget : '+no0(pgn^.title)+' }');
                        button_kind :
                          addline(@idcmplist,'',spaces+
                              '            { Button pressed  , Text of gadget : '+no0(pgn^.title)+' }');
                        string_kind :
                          addline(@idcmplist,'',spaces+
                              '            { String entered  , Text of gadget : '+no0(pgn^.title)+' }');
                        integer_kind :
                          addline(@idcmplist,'',spaces+
                              '            { Integer entered , Text of gadget : '+no0(pgn^.title)+' }');
                        CheckBox_kind :
                          addline(@idcmplist,'',spaces+
                              '            { CheckBox changed, Text of gadget : '+no0(pgn^.title)+' }');
                        cycle_kind :
                          addline(@idcmplist,'',spaces+
                              '            { Cycle changed   , Text of gadget : '+no0(pgn^.title)+' }');
                        Slider_kind :
                          addline(@idcmplist,'',spaces+
                              '            { Slider changed  , Text of gadget : '+no0(pgn^.title)+' }');
                        Scroller_kind :
                          addline(@idcmplist,'',spaces+
                              '            { Scroller changed, Text of gadget : '+no0(pgn^.title)+' }');
                        ListView_kind :
                          addline(@idcmplist,'',spaces+
                              '            { ListView pressed, Text of gadget : '+no0(pgn^.title)+' }');
                        Palette_kind :
                          addline(@idcmplist,'',spaces+
                              '            { Colour Selected , Text of gadget : '+no0(pgn^.title)+' }');
                       end;
                      addline(@idcmplist,spaces+'          end;','');
                    end;
                  pgn:=pgn^.ln_succ;
                end;
              if countup>0 then
                addline(@idcmplist,spaces+'       end;','')
               else
                begin
                  psn:=pstringnode(remtail(@idcmplist));
                  freemymem(psn);
                end;
            end;
          6 :
            addline(@idcmplist,'',spaces+'      { CloseWindow Now }');
          7 :
            Begin
              addline(@idcmplist,'',spaces+'      { Menu Selected }');
              if pdwn^.menutitle<>'' then
                addline(@idcmplist,spaces+'      ProcessMenuIDCMP'+no0(pdwn^.menutitle)+'( Code );','');
            end;
          8 :
            addline(@idcmplist,'',spaces+'      { Intuiton pauses menu until replied. }');
          9 :
            addline(@idcmplist,'',spaces+'      { Copy the menu processing procedure and change suitably }');
          10:
            addline(@idcmplist,'',spaces+'      { A requester has opened in this window. }');
          11:
            addline(@idcmplist,'',spaces+'      { A requester has cleared from this window. }');
          12:
            addline(@idcmplist,'',spaces+'      { Can you take a requester ?, Intuiton waits for a reply. }');
          13:
            addline(@idcmplist,'',spaces+'      { Window re-sized. }');
          14:
            begin
              addline(@idcmplist,spaces+'      GT_BeginRefresh( '+no0(pdwn^.labelid)+');','');
              addline(@idcmplist,'',spaces+'      { Refresh window. }');
              
              s:='';
              if length(no0(pdwn^.rendparams))>0 then
                s:=', '+no0(pdwn^.rendparams);
              
              if sizeoflist(@pdwn^.bevelboxlist)+sizeoflist(@pdwn^.imagelist)+sizeoflist(@pdwn^.textlist)+
                 sizeoflist(@pdwn^.gadgetlist)>0 then
                addline(@idcmplist,spaces+'      RendWindow'+nicestring(no0(pdwn^.labelid))+'( '+no0(pdwn^.labelid)+','
                            +no0(pdwn^.labelid)+'VisualInfo '+s+' );',''); {83}
              
              addline(@idcmplist,spaces+'      GT_EndRefresh( '+no0(pdwn^.labelid)+', True);','');
              
              if sizeoflist(@pdwn^.gadgetlist)>0 then
                begin
                  addline(@idcmplist,spaces+'       { You should probably remove the next two lines if you have } ',''); {82}
                  addline(@idcmplist,spaces+
                    '       { no BOOPSI Images to redraw. They slow redrawing down otherwise.}',''); {82}
                  addline(@idcmplist,spaces+'      GT_RefreshWindow( '+no0(pdwn^.labelid)+', Nil);',''); {82}
                  addline(@idcmplist,spaces+'      RefreshGList('+no0(pdwn^.labelid)+'glist, '+
                        no0(pdwn^.labelid)+',Nil,~0);',''); {82}
                end;
              
            end;
          15:
            addline(@idcmplist,'',spaces+'      { Verify window size. }');
          16:
            addline(@idcmplist,'',spaces+'      { Window activated. }');
          17:
            addline(@idcmplist,'',spaces+'      { Window deactivated. }');
          18:
            begin
              addline(@idcmplist,'',spaces+'      { Processed key press }');
              addline(@idcmplist,'',spaces+'      { gadgets need processing perhaps. }');
            end;
          19:
            addline(@idcmplist,'',spaces+'      { Raw keyboard keypress }');
          20:
            addline(@idcmplist,'',spaces+'      { 1.3 Prefs. }');
          21:
            addline(@idcmplist,'',spaces+'      { Floppy disk inserted. }');
          22:
            addline(@idcmplist,'',spaces+'      { Floppy disk removed. }');
          23:
            addline(@idcmplist,'',spaces+'      { Timing message. }');
          24:
            addline(@idcmplist,'',spaces+'      { Boopsi message }');
          25:
            addline(@idcmplist,'',spaces+'      { Window position or size changed. }');
         end;
        addline(@idcmplist,spaces+'    end;','');
      end;
  addline(@idcmplist,spaces+' end;','');
  addline(@idcmplist,'end;','');
end;

procedure processwindow(pdwn:pdesignerwindownode);
var
  s        : string;
  count    : long;
  loop     : long;
  pgn      : pgadgetnode;
  spaces   : string;
  s2       : string;
  psn      : pstringnode;
  loop2    : byte;
  loop6    : word;
  cow      : long;
  s3       : string[10];
  count24  : word;
begin
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        pdwn^.codeoptions[10]:=true;
      pgn:=pgn^.ln_succ;
    end;
  
  if not comment then
    comment:=pdwn^.codeoptions[16];
  pdwn^.idcmpvalues:=0;
  processrendwindow(pdwn);
  if not pdwn^.codeoptions[19] then
    begin
      addline(@varlist,'  '+no0(pdwn^.labelid)+'           : pWindow;','');
      if sizeoflist(@pdwn^.gadgetlist)>0 then
        addline(@varlist,'  '+no0(pdwn^.labelid)+'glist      : pGadget;','');
      addline(@varlist,'  '+no0(pdwn^.labelid)+'VisualInfo : Pointer;','');
      addline(@varlist,'  '+no0(pdwn^.labelid)+'DrawInfo   : pdrawinfo;','');
      addline(@initlist,'  '+no0(pdwn^.labelid)+':=Nil;','');
      if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
        addline(@varlist,'  '+no0(pdwn^.labelid)+'BitMap     : pbitmap;','');
    end;
  addline(@procfunclist,'','');
  s:='';
  if pdwn^.codeoptions[8] then                               {1}
    s:=s+'( Pmport : pMsgPort';
  if (pdwn^.customscreen)or(pdwn^.pubscreen) then
    if s='' then
      s:='( pScr : pScreen'
     else
      s:=s+'; pScr : pScreen';
  if (pdwn^.pubscreenname) and (no0(pdwn^.defpubname)='') then
    if s='' then
      s:='( pScrName : STRPTR'
     else
      s:=s+'; pScrName : STRPTR';
  if (pdwn^.extracodeoptions[1])and(not pdwn^.extracodeoptions[2]) then
    if s='' then
      s:='( pbm : pbitmap'
     else
      s:=s+'; pbm : pbitmap';
  if (pdwn^.codeoptions[18]) then
    if s='' then
      s:='( pawp : pMsgPort ;awid : long'
     else
      s:=s+'; pawp : pMsgPort; awid : long';
  if no0(pdwn^.winparams)<>'' then
    s:=s+'; '+no0(pdwn^.winparams);
  if s<>'' then s:=s+')'; 
  if pdwn^.codeoptions[4] then
    s:='Function openwindow'+nicestring(no0(pdwn^.labelid))+s+': Boolean;'
   else
    s:='Procedure openwindow'+nicestring(no0(pdwn^.labelid))+s+';';
  count24:=0;
  addline(@procfunclist,s,'');
  addline(@procfuncdefslist,s,'');
  addline(@procfunclist,'Const','');                          {2}
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      case pgn^.kind of
        
         string_kind :
          begin
            s2:=sfp(pointer(gettagdata(gtst_string,0,pgn^.gn_gadgettags)));
            if s2<>'' then
              begin
                str(length(s2)+1,s);
                addline(@procfunclist,'  '+no0(pgn^.labelid)+'DefaultString : string['+s+'] ='''+s2+'''#0;','');
              end;
          end;

        
        myobject_kind :
          addmyobjectconstdata(pdwn,pgn);
        palette_kind :
          begin
            if pgn^.tags[1].ti_data=0 then
              inc(count24);
          end;
        slider_kind : 
          begin
            str(length(pgn^.datas),s);
            if boolean(pgn^.tags[4].ti_data) and (not pdwn^.localeoptions[1]) then
              addline(@procfunclist,'  '+no0(pgn^.labelid)+'levelformat : string['+s+'] ='''+no0(pgn^.datas)+'''#0;','');
          end;
        text_kind :
          begin
            str(length(pgn^.datas),s);
            if not pdwn^.localeoptions[1] then
              addline(@procfunclist,'  '+no0(pgn^.labelid)+'InitText : string['+s+'] ='''+no0(pgn^.datas)+'''#0;','');
          end;
        number_kind :
          if (no0(pgn^.datas)<>'')and(boolean(pgn^.tags[5].ti_data)) then
            begin
              str(length(pgn^.datas),s);
              addline(@procfunclist,'  '+no0(pgn^.labelid)+'LevelFormatText : string['+s+'] ='''+no0(pgn^.datas)+'''#0;','');
            end;
        cycle_kind :
          begin
            loop:=sizeoflist(@pgn^.infolist);
            str(loop,s);
            addline(@varlist,'  '+no0(pgn^.labelid)+'Labels : array[0..'+s+'] of pbyte;','');
            str(loop-1,s);
            loop2:=0;
            psn:=pstringnode(pgn^.infolist.mlh_head);
            while (psn^.ln_succ<>nil) do
              begin
                if length(psn^.st)>loop2 then
                  loop2:=length(psn^.st);
                psn:=psn^.ln_succ;
              end;
            str(loop2,s2);
            if pdwn^.localeoptions[1] then
              addline(@procfunclist,'  '+no0(pgn^.labelid)+'CycleTexts : array [0..'+s+'] of long=','')
             else
              addline(@procfunclist,'  '+no0(pgn^.labelid)+'CycleTexts : array [0..'+s+'] of string['+s2+']=','');
            addline(@procfunclist,'  (','');
            cow:=0;
            psn:=pstringnode(pgn^.infolist.mlh_head);
            while (psn^.ln_succ<>nil) do
              begin
                if pdwn^.localeoptions[1] then
                  begin
                    str(cow,s);
                    inc(cow);
                    localestring(no0(psn^.st),no0(pgn^.labelid)+'String'+s,
                           ' Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title));
                    s:='  '+no0(pgn^.labelid)+'String'+s;
                    if psn^.ln_succ^.ln_succ<>nil then
                      s:=s+',';
                  end
                 else
                  begin
                    s:='  '''+no0(psn^.st)+'''#0';
                    if psn^.ln_succ^.ln_succ<>nil then
                      s:=s+',';
                    s:=s+#0;
                  end;
                addline(@procfunclist,s,'');
                psn:=psn^.ln_succ;
              end;
            addline(@procfunclist,'  );',''); 
          end;
        mx_kind :
          begin
            loop:=sizeoflist(@pgn^.infolist);
            str(loop,s);
            addline(@varlist,'  '+no0(pgn^.labelid)+'Labels : array[0..'+s+'] of pbyte;','');
            str(loop-1,s);
            loop2:=0;
            psn:=pstringnode(pgn^.infolist.mlh_head);
            while (psn^.ln_succ<>nil) do
              begin
                if length(psn^.st)>loop2 then
                  loop2:=length(psn^.st);
                psn:=psn^.ln_succ;
              end;
            str(loop2,s2);
            if pdwn^.localeoptions[1] then
              addline(@procfunclist,'  '+no0(pgn^.labelid)+'MXTexts : array [0..'+s+'] of long=','')
             else
              addline(@procfunclist,'  '+no0(pgn^.labelid)+'MXTexts : array [0..'+s+'] of string['+s2+']=','');
            addline(@procfunclist,'  (','');
            cow:=0;
            psn:=pstringnode(pgn^.infolist.mlh_head);
            while (psn^.ln_succ<>nil) do
              begin
                if pdwn^.localeoptions[1] then
                  begin
                    str(cow,s);
                    inc(cow);
                    localestring(no0(psn^.st),no0(pgn^.labelid)+'String'+s
                        ,' Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid));
                    s:='  '+no0(pgn^.labelid)+'String'+s;
                    if psn^.ln_succ^.ln_succ<>nil then
                      s:=s+',';
                  end
                 else
                  begin
                    s:='  '''+no0(psn^.st)+'''#0';
                    if psn^.ln_succ^.ln_succ<>nil then
                      s:=s+',';
                    s:=s+#0;
                  end;
                addline(@procfunclist,s,'');
                psn:=psn^.ln_succ;
              end;
            addline(@procfunclist,'  );',''); 
          end;
        listview_kind :
          if pgn^.tags[10].ti_data=long(true) then
            begin
              loop:=sizeoflist(@pgn^.infolist);
              str(loop-1,s);
              addline(@varlist,'  '+no0(pgn^.labelid)+'List      : tlist;','');
              addline(@varlist,'  '+no0(pgn^.labelid)+'ListItems : array[0..'+s+'] of tnode;','');
              loop2:=0;
              psn:=pstringnode(pgn^.infolist.mlh_head);
              while (psn^.ln_succ<>nil) do
                begin
                  if length(psn^.st)>loop2 then
                    loop2:=length(psn^.st);
                  psn:=psn^.ln_succ;
                end;
              str(loop2,s2);
              if pdwn^.localeoptions[1] then
                addline(@procfunclist,'  '+no0(pgn^.labelid)+'ListViewTexts : array [0..'+s+'] of long=','')
               else
                addline(@procfunclist,'  '+no0(pgn^.labelid)+'ListViewTexts : array [0..'+s+'] of string['+s2+']=','');
              addline(@procfunclist,'  (','');
              cow:=0;
              psn:=pstringnode(pgn^.infolist.mlh_head);
              while (psn^.ln_succ<>nil) do
                begin
                  if pdwn^.localeoptions[1] then
                    begin
                      str(cow,s);
                      inc(cow);
                      localestring(no0(psn^.st),no0(pgn^.labelid)+'String'+s
                          ,' Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title));
                      s:='  '+no0(pgn^.labelid)+'String'+s;
                      if psn^.ln_succ^.ln_succ<>nil then
                        s:=s+',';
                    end
                   else
                    begin
                      s:='  '''+no0(psn^.st)+'''#0';
                      if psn^.ln_succ^.ln_succ<>nil then
                        s:=s+',';
                      s:=s+#0;
                    end;
                  addline(@procfunclist,s,'');
                  psn:=psn^.ln_succ;
                end;
              addline(@procfunclist,'  );','');
            end;
       end;
      pgn:=pgn^.ln_succ;
    end;
  count:=sizeoflist(@pdwn^.gadgetlist);
  if count>0 then                                            {3}
    begin
      {gadget strings}
      {renumber gadgets}
      loop:=0;
      loop2:=0;
      pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
      while(pgn^.ln_succ<>nil) do
        begin
          if length(no0(pgn^.title))>loop2 then
            loop2:=length(no0(pgn^.title));
          str(pgn^.id,s);
          addline(@constlist,'  '+no0(pgn^.labelid)+' = '+s+';','');
          inc(loop);
          pgn:=pgn^.ln_succ;
        end;
      {create strings}
      str(loop2+1,s2);
      str(loop-1+pdwn^.nextid,s);
      str(pdwn^.nextid,s3);
      if not pdwn^.localeoptions[1] then
        addline(@procfunclist,'  Gadgetstrings : array['+s3+'..'+s+'] of string['+s2+']=','');
      
      if pdwn^.codeoptions[10] then
        if not pdwn^.codeoptions[19] then
          addline(@varlist,'  '+no0(pdwn^.labelid)+'gads  : array ['+s3+'..'+s+'] of pgadget;','');
      
      if not pdwn^.localeoptions[1] then
        begin
          addline(@procfunclist,'  (','');  
          pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
          while(pgn^.ln_succ<>nil) do
            begin  
              if pgn^.ln_succ^.ln_succ<>nil then
                addline(@procfunclist,'  '''+no0(pgn^.title)+'''#0,','')
               else
                addline(@procfunclist,'  '''+no0(pgn^.title)+'''#0','');
              pgn:=pgn^.ln_succ;
            end;
          addline(@procfunclist,'  );','');
        end;
    end;
  if (no0(pdwn^.defpubname)<>'') then
    begin
      addline(@procfunclist,'  PubScrName : string['+fmtint(length(no0(pdwn^.defpubname))+1)+
                            '] = '''+no0(pdwn^.defpubname)+'''#0;','');
    end;
  if pdwn^.usezoom then                                           {4}
    begin
      s:='  ZoomInfo : array [1..4] of word = (';
      str(pdwn^.zoom[1],s2);
      s:=s+s2+',';
      str(pdwn^.zoom[2],s2);
      s:=s+s2+',';
      str(pdwn^.zoom[3],s2);
      s:=s+s2+',';
      str(pdwn^.zoom[4],s2);
      s:=s+s2+');'#0;
      addline(@procfunclist,s,'');
    end;
  str(length(no0(pdwn^.title))+1,s);
  if not pdwn^.localeoptions[3] then
    addline(@procfunclist,'  wintitle : string ['+s+']='''+no0(pdwn^.title)+'''#0;','');           {5}
  if (no0(pdwn^.screentitle)<>'') and (not pdwn^.localeoptions[4]) then
    begin
      str(length(no0(pdwn^.screentitle))+1,s);
      addline(@procfunclist,'  screentitle : string ['+s+']='''+no0(pdwn^.screentitle)+'''#0;','');  {6}
    end;
  psn:=pstringnode(remtail(@procfunclist));
  if no0(psn^.st)='Const' then
    freemymem(psn)
   else
    addtail(@procfunclist,pnode(psn));
  
  addline(@procfunclist,'Var','');                                 {7}
  addline(@procfunclist,'  Dummy : Boolean;','');                  {7}
  addline(@procfunclist,'  Loop  : Word;','');                     {7}
  addline(@procfunclist,'  offx  : Word;','');
  addline(@procfunclist,'  offy  : Word;','');
  if pdwn^.codeoptions[17] then
    addline(@procfunclist,'  ZoomStore : pword;','');
  s:=getenoughtags(pdwn);
  addline(@procfunclist,'  tags  : array[1..'+s+'] of ttagitem;',''); {8}
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@procfunclist,'  allocatedBitMaps  : Boolean;','');
      addline(@procfunclist,'  planeNum          : Word;','');
    end;
  if pdwn^.codeoptions[17] then
    begin
      addline(@procfunclist,'  scalex: real;','');
      addline(@procfunclist,'  scaley: real;','');
    end;
  if count24>0 then
    begin
      {
      addline(@procfunclist,'  pdi  : pdrawinfo;','');                 
      }
      if not pdwn^.codeoptions[19] then
        addline(@varlist,'  '+no0(pdwn^.labelid)+'Depth : Word;','');
    end;
  if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
    addline(@procfunclist,'  pScr  : PScreen;','');                 {10}
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      addline(@procfunclist,'  pgad  : pgadget;','');
      addline(@procfunclist,'  pgad2 : pgadget;','');
      addline(@procfunclist,'  res   : long;','');
      addline(@procfunclist,'  pit   : pintuitext;','');
      addline(@procfunclist,'  objectname : string;','');
    end;
  addline(@procfunclist,'begin','');                               {11}
  spaces:='  ';
  if pdwn^.codeoptions[4] then
    addline(@procfunclist,'  openwindow'+nicestring(no0(pdwn^.labelid))+':=true;','');{12}
  if pdwn^.codeoptions[1] then
    begin
      addline(@procfunclist,'  if '+no0(pdwn^.labelid)+'=nil then','');
      addline(@procfunclist,'    begin','');
      spaces:=spaces+'    ';
    end;
  if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
    begin
      if pdwn^.pubscreenname then
        if (no0(pdwn^.defpubname)='') then
          s:='PScrName'
         else
          s:='@PubScrName[1]'
       else
        s:='Nil';
      addline(@procfunclist,spaces+'pScr:=lockPubScreen('+s+');','');{17}
      if pdwn^.pubscreenname and pdwn^.pubscreenfallback then
        begin
          addline(@procfunclist,spaces+'If pScr=Nil then','');          {18}
          addline(@procfunclist,spaces+'  pScr:=lockPubScreen(nil);','');{17}
      
        end;
      addline(@procfunclist,spaces+'If pScr<>Nil then','');          {18}
      addline(@procfunclist,spaces+'  Begin','');                    {19}
     
      spaces:=spaces+'    ';
    end;
  if pdwn^.codeoptions[9] and (not pdwn^.gimmezz) then
    begin
      addline(@procfunclist,spaces+'offx:=PScr^.WBorLeft;','');
      addline(@procfunclist,spaces+'offy:=PScr^.WBorTop+PScr^.Font^.ta_YSize+1;','');
    end
   else
    begin
      str(pdwn^.offx,s);
      addline(@procfunclist,spaces+'offx:='+s+';','');
      str(pdwn^.offy,s);
      addline(@procfunclist,spaces+'offy:='+s+';','');
    end;
  if pdwn^.codeoptions[17] then
    begin
      str(pdwn^.fontx,s);
      addline(@procfunclist,spaces+'scalex:=PScr^.Rastport.Font^.tf_Xsize/'+s+';','');
      str(pdwn^.fonty,s);
      addline(@procfunclist,spaces+'scaley:=PScr^.RastPort.Font^.tf_ysize/'+s+';','');
      if pdwn^.usezoom then
        begin
      addline(@procfunclist,spaces+'ZoomStore  := @zoominfo[3];','');
      str(pdwn^.zoom[3],s);
      addline(@procfunclist,spaces+'zoomstore^ := round('+s+' *scalex);','');
      addline(@procfunclist,spaces+'ZoomStore  := @zoominfo[4];','');
      str(pdwn^.zoom[4],s);
      addline(@procfunclist,spaces+'zoomstore^ := round('+s+' *scaley);','');
      
        end;
      
    end;
  
  addline(@procfunclist,spaces+no0(pdwn^.labelid)+'VisualInfo:=getvisualinfoa( PScr, Nil);',''); {23}
  addline(@procfunclist,spaces+'if '+no0(pdwn^.labelid)+'VisualInfo<>nil then','');                 {24}
  addline(@procfunclist,spaces+'  Begin','');                                                       {25}
  spaces:=spaces+'    ';
  
  addline(@procfunclist,spaces+no0(pdwn^.labelid)+'DrawInfo:=getscreendrawinfo( PScr );',''); {23}
  addline(@procfunclist,spaces+'if '+no0(pdwn^.labelid)+'DrawInfo<>nil then','');                 {24}
  addline(@procfunclist,spaces+'  Begin','');                                                       {25}
  spaces:=spaces+'    ';
  
  {**********************************************}
  
  { do gadget stuff }
  
  if count>0 then
    begin
      addline(@procfunclist,spaces+no0(pdwn^.labelid)+'GList:=Nil;','');
      addline(@procfunclist,spaces+'pGad:=createcontext(@'+no0(pdwn^.labelid)+'GList);','');
      
      
      str(pdwn^.nextid+sizeoflist(@pdwn^.gadgetlist)-1,s2);
      str(pdwn^.nextid,s3);
      addline(@procfunclist,spaces+'for res:='+s3+' to '+s2+' do','');
      addline(@procfunclist,spaces+'  '+no0(pdwn^.labelid)+'Gads[res]:=nil;','');
      
      if count24>0 then
        begin
          addline(@procfunclist,spaces+no0(pdwn^.labelid)+'Depth:=pscr^.bitmap.depth;','');
        end;
      {30}
      {31}
      dogadgets(pdwn,spaces);
      doobjects(pdwn,spaces);
    end;  
  
  
  
  { window opening bit }
  
  if (count>0) and (pdwn^.codeoptions[5]) then
    begin
      addline(@procfunclist,spaces+'if pgad<>nil then','');  {32}
      addline(@procfunclist,spaces+'  begin','');            {33}
      spaces:=spaces+'    ';
    end;
  
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@procfunclist,spaces+''+no0(pdwn^.labelid)+'BitMap:=allocmem(sizeof(tbitmap),MEMF_PUBLIC or MEMF_CLEAR);','');
      addline(@procfunclist,spaces+'if '+no0(pdwn^.labelid)+'BitMap<>nil then','');  {32}
      addline(@procfunclist,spaces+'  begin','');            {33}
      spaces:=spaces+'    ';
      str(pdwn^.maxw,s);
      str(pdwn^.maxh,s2);
      s:=s+', '+s2;
      addline(@procfunclist,spaces+'InitBitMap('+no0(pdwn^.labelid)+'BitMap, pscr^.bitmap.depth, '+s+');','');            {33}
      addline(@procfunclist,spaces+'allocatedbitmaps:=true;','');            {33}
      
      addline(@procfunclist,spaces+'for planenum:=0 to pscr^.bitmap.depth-1 do','');            {33}
      addline(@procfunclist,spaces+'  begin','');            {33}
      addline(@procfunclist,spaces+'    if allocatedbitmaps then','');            {33}
      addline(@procfunclist,spaces+'      '+no0(pdwn^.labelid)+'BitMap^.Planes[planenum]:=AllocRaster('+s+');','');
      addline(@procfunclist,spaces+'    if '+no0(pdwn^.labelid)+'BitMap^.Planes[planenum]=Nil then','');
      addline(@procfunclist,spaces+'      allocatedbitmaps:=false','');            {33}
      addline(@procfunclist,spaces+'     else','');            {33}
      str(trunc((pdwn^.maxw+15)/16)*2*pdwn^.maxh,s);
      addline(@procfunclist,spaces+'      BltClear('+no0(pdwn^.labelid)+'BitMap^.Planes[planenum],'+s+', 1);','');
      addline(@procfunclist,spaces+'  end;','');            {33}
      
      addline(@procfunclist,spaces+'if allocatedbitmaps then','');            {33}
      addline(@procfunclist,spaces+'  begin','');            {33}
      spaces:=spaces+'    ';
    
    end;

  
  
  {****    ****    ****}
  
  { do window opening stuff }
  str(pdwn^.x,s2);
  addline(@procfunclist,spaces+'settagitem(@tags[ 1],WA_Left  ,'+s2+');','');  {37}
  str(pdwn^.y,s2);
  addline(@procfunclist,spaces+'settagitem(@tags[ 2],WA_Top   ,'+s2+');','');  {38}
  if pdwn^.innerw=0 then
    begin
      str(pdwn^.w,s2);
       if pdwn^.codeoptions[17] then
        s2:='round('+s2+'*scalex)';
      s2:=s2+'+offx';
      addline(@procfunclist,spaces+'settagitem(@tags[ 3],WA_Width ,'+s2+');','');  {39}
    end
   else
    begin
      str(pdwn^.innerw,s2);
      if pdwn^.codeoptions[17] then
        s2:='round('+s2+'*scalex)';
      addline(@procfunclist,spaces+'settagitem(@tags[ 3],WA_InnerWidth,'+s2+');','');  {40}
    end;
  if pdwn^.innerh=0 then
    begin
      str(pdwn^.h,s2);
      if pdwn^.codeoptions[17] then
        s2:='round('+s2+'*scaley)';
      s2:=s2+'+offy';
      addline(@procfunclist,spaces+'settagitem(@tags[ 4],WA_Height,'+s2+');','');  {41}
    end
   else
    begin
      str(pdwn^.innerh,s2);
      if pdwn^.codeoptions[17] then
        s2:='round('+s2+'*scaley)';
      addline(@procfunclist,spaces+'settagitem(@tags[ 4],WA_InnerHeight,'+s2+');','');  {42}
    end;
  
  if no0(pdwn^.title)<>'' then
    begin
  if pdwn^.localeoptions[3] then
    begin
      localestring(no0(pdwn^.title),nicestring(no0(pdwn^.labelid))+'WindowTitle'
              ,' Window title: '+no0(pdwn^.title));
      addline(@procfunclist,spaces+'settagitem(@tags[ 5],WA_Title ,long('+sfp(producernode^.GetString)+'ptr('
                   +nicestring(no0(pdwn^.labelid))+'WindowTitle)));','');  {43}
    end
   else
    addline(@procfunclist,spaces+'settagitem(@tags[ 5],WA_Title ,long(@WinTitle[1]));','');  {43}
    end;
    
  str(pdwn^.minw,s2);
  addline(@procfunclist,spaces+'settagitem(@tags[ 6],WA_MinWidth ,'+s2+');',''); {45}
  str(pdwn^.minh,s2);
  addline(@procfunclist,spaces+'settagitem(@tags[ 7],WA_MinHeight,'+s2+');',''); {46}
  str(pdwn^.maxw,s2);
  addline(@procfunclist,spaces+'settagitem(@tags[ 8],WA_MaxWidth ,'+s2+');',''); {47}
  str(pdwn^.maxh,s2);
  addline(@procfunclist,spaces+'settagitem(@tags[ 9],WA_MaxHeight,'+s2+');',''); {48}
  loop:=10;
  if no0(pdwn^.screentitle)<>''then
    begin
      str(loop,s);
      if not pdwn^.localeoptions[4] then
        addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_ScreenTitle,long(@screentitle[1]));','')
       else
        begin
          localestring(no0(pdwn^.screentitle),nicestring(no0(pdwn^.labelid))+'ScreenTitle',
                'Screen Title of: '+no0(pdwn^.title));
          addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_ScreenTitle,long('+sfp(producernode^.Getstring)+'ptr('
                   +nicestring(no0(pdwn^.labelid))+'ScreenTitle)));','')
        end;
      
      inc(loop);
    end;
  if pdwn^.sizegad then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_SizeGadget,long(true));',''); {49}
      inc(loop);
      if (pdwn^.sizebright)and(pdwn^.sizebbottom) then
        begin
          str(loop,s);
          addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_SizeBRight,long(true));',''); {50}
          inc(loop);
        end;
      if pdwn^.sizebbottom then
        begin
          str(loop,s);
          addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_SizeBBottom,long(true));',''); {51}
          inc(loop);
        end;
    end;
  if pdwn^.dragbar then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_DragBar,long(true));','');     {52}
      inc(loop);
    end;
  if pdwn^.Depthgad then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_DepthGadget,long(true));',''); {53}
      inc(loop);
    end;
  if pdwn^.CloseGad then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_CloseGadget,long(true));',''); {54}
      inc(loop);
    end;
  
  if pdwn^.moretags[1] then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_Dummy + $30,long(true));',''); {54}
      inc(loop);
    end;
  if pdwn^.moretags[2] then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_Dummy + $32,long(true));',''); {54}
      inc(loop);
    end;
  if pdwn^.moretags[3] then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_Dummy + $37,long(true));',''); {54}
      inc(loop);
    end;

  
  if pdwn^.reportmouse then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_ReportMouse,long(true));',''); {55}
      inc(loop);
    end;
  if pdwn^.NoCareRefresh then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_NoCareRefresh,long(true));',''); {56}
      inc(loop);
    end;
  if pdwn^.borderless then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_BorderLess,long(true));',''); {57}
      inc(loop);
    end;
  if pdwn^.backdrop then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_BackDrop,long(true));',''); {58}
      inc(loop);
    end;
  if pdwn^.gimmezz then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_GimmeZeroZero,long(true));',''); {59}
      inc(loop);
    end;
  if pdwn^.Activate then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_Activate,long(true));',''); {60}
      inc(loop);
    end;
  if pdwn^.RMBTrap then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_RMBTrap,long(true));',''); {61}
      inc(loop);
    end;
  if pdwn^.SimpleRefresh then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_SimpleRefresh,long(true));',''); {62}
      inc(loop);
    end;
  if pdwn^.Smartrefresh then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_SmartRefresh,long(true));',''); {63}
      inc(loop);
    end;
  if pdwn^.autoadjust then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_AutoAdjust,long(true));',''); {64}
      inc(loop);
    end;
  if pdwn^.MenuHelp then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_MenuHelp,long(true));',''); {65}
      inc(loop);
    end;
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_Gadgets,long('+no0(pdwn^.labelid)+'glist));',''); {66}
      inc(loop);
    end;  
  if pdwn^.usezoom then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_Zoom,long(@ZoomInfo[1]));',''); {67}
      inc(loop);
    end;
  if pdwn^.mousequeue<>5 then
    begin
      str(loop,s);
      str(pdwn^.mousequeue,s2);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_MouseQueue,'+s2+');',''); {68}
      inc(loop);
    end;
  if pdwn^.rptqueue<>3 then
    begin
      str(loop,s);
      str(pdwn^.rptqueue,s2);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_RptQueue  ,'+s2+');',''); {69}
      inc(loop);
    end;
  {
  if pdwn^.pubscreenfallback and pdwn^.pubscreenname then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_PubScreenFallBack,long(True));','');
      inc(loop);
    end;
  }
  
  
  
  if (pdwn^.customscreen) then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_CustomScreen,long(pScr));',''); {70}
      inc(loop);
    end;
    
  if (pdwn^.pubscreen) then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_PubScreen,long(pScr));',''); {70}
      inc(loop);
    end;
  
  if (pdwn^.pubscreenname) then
    begin
      str(loop,s);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_PubScreen,long(pScr));',''); {70}
      inc(loop);
    end;

  
  {******************************************** here we go }
  
  
  {* * * * * * * * * * * * * * * * * *}
  
  
  
  
  
  
  for loop6:=1 to 25 do
    if pdwn^.idcmplist[loop6] then
      pdwn^.idcmpvalues:=pdwn^.idcmpvalues or idcmpnum[Loop6];
  
  if pdwn^.extracodeoptions[1] then
    begin
      str(loop,s);
      str(pdwn^.innerh,s2);
      if pdwn^.extracodeoptions[2] then
        addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_SuperBitMap,long('+no0(pdwn^.labelid)+'BitMap));','')
       else
        addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_SuperBitMap,long(pbm));','');
      inc(loop);
    end;
  
  if not pdwn^.codeoptions[8] then
    begin
      str(loop,s);
      str(pdwn^.idcmpvalues,s2);
      addline(@procfunclist,spaces+'settagitem(@tags['+s+'],WA_IDCMP,'+s2+');',''); {71}
      inc(loop);
    end;
  str(loop,s);
  addline(@procfunclist,spaces+'settagitem(@tags['+s+'],Tag_Done,0);',''); {72}
  inc(loop);
  {open window here}
  if pdwn^.codeoptions[8] then
    begin
      str(PDWN^.IDCMPVALUES,s);
      addline(@procfunclist,spaces+no0(pdwn^.labelid)+':=openwindowtaglistnicely(Nil,@tags[1],'+s+', pMport);',''); {73}
    end
   else
    begin
      addline(@procfunclist,spaces+no0(pdwn^.labelid)+':=openwindowtaglist(Nil,@tags[1]);',''); {74}
    end;
  addline(@procfunclist,spaces+'if '+no0(pdwn^.labelid)+'<>nil then',''); {75}
  addline(@procfunclist,spaces+'  begin','');                             {76}
  spaces:=spaces+'    ';
  
  {** ** ** ** ** ** ** ** ** **}
  
  if pdwn^.codeoptions[18] then
    begin
      addline(@procfunclist,spaces+no0(pdwn^.labelid)+
                           'AppWin:=AddAppWindowA( awid, 0, '+no0(pdwn^.labelid)+
                            ', pawp, nil);',''); {82}
      if not pdwn^.codeoptions[19] then
        begin
          addline(@varlist,'  '+no0(pdwn^.labelid)+'AppWin : pAppWindow;',''); {82}
          addline(@initlist,'  '+no0(pdwn^.labelid)+'AppWin:=Nil;',''); {82}
        end;
    end;
  
  s:='';
  if length(no0(pdwn^.rendparams))>0 then
    s:=', '+no0(pdwn^.rendparams);
  
  if sizeoflist(@pdwn^.bevelboxlist)+sizeoflist(@pdwn^.imagelist)+sizeoflist(@pdwn^.textlist)+
     sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@procfunclist,spaces+'RendWindow'+nicestring(no0(pdwn^.labelid))+'( '+no0(pdwn^.labelid)+','
                                +no0(pdwn^.labelid)+'VisualInfo'+s+' );',''); {83}
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      
      addline(@procfunclist,spaces+'GT_RefreshWindow( '+no0(pdwn^.labelid)+', Nil);',''); {82}
      addline(@procfunclist,spaces+'RefreshGList('+no0(pdwn^.labelid)+'glist, '+no0(pdwn^.labelid)+',Nil,~0);',''); {82}
      
    end;
  
  {open menu?}
  
  if pdwn^.codeoptions[11] then
    begin
      if pdwn^.codeoptions[12] then
        begin
          addline(@procfunclist,spaces+'if '+no0(pdwn^.menutitle)+'=nil then',''); {84}
          addline(@procfunclist,spaces+'  if makemenu'+no0(pdwn^.menutitle)+
                                '('+no0(pdwn^.labelid)+'VisualInfo) then;',''); {85}
        end; 
      addline(@procfunclist,spaces+'if '+no0(pdwn^.menutitle)+'<>nil then',''); {86}
      addline(@procfunclist,spaces+'  dummy:=setmenustrip('+no0(pdwn^.labelid)+','+no0(pdwn^.menutitle)+')',''); {87}
    end;
  
  {10101}
  
  if pdwn^.codeoptions[11] then
    begin
      addline(@procfunclist,spaces+' else','');
      addline(@procfunclist,spaces+'  Begin','');
      if (pdwn^.codeoptions[13])and(pdwn^.codeoptions[4]) then
        begin
          addline(@procfunclist,spaces+'  openwindow'+nicestring(no0(pdwn^.labelid))+':=false;','');
        end;
      if (pdwn^.codeoptions[13]) then
        begin
          if pdwn^.codeoptions[8] then
            addline(@procfunclist,spaces+'    CloseWindowSafely('+no0(pdwn^.labelid)+');','')
           else
            addline(@procfunclist,spaces+'    CloseWindow('+no0(pdwn^.labelid)+');','');
          addline(@procfunclist,spaces+'    FreeScreenDrawInfo(pscr,'+no0(pdwn^.labelid)+'DrawInfo);','');     {36}
          addline(@procfunclist,spaces+'    FreeVisualInfo('+no0(pdwn^.labelid)+'VisualInfo);',''); {79}
          if sizeoflist(@pdwn^.gadgetlist)>0 then
            begin
              addline(@procfunclist,spaces+'    FreeGadgets('+no0(pdwn^.labelid)+'GList);',''); {80}
              addfreeobjects(pdwn,spaces);
            end;
          str(pdwn^.maxw,s);
          str(pdwn^.maxh,s2);
          s:=s+', '+s2;
          if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
            addline(@procfunclist,spaces+'    freebitmap('+no0(pdwn^.labelid)+'BitMap, '+s+');','');
        end;
      addline(@procfunclist,spaces+'  end;','');
      
    end;
  
  {** ** ** ** ** ** ** ** ** **}
  {handle open fail}
  
  dec(spaces[0],4);
  addline(@procfunclist,spaces+'  end','');  {77}
  addline(@procfunclist,spaces+' else','');  {78}
  addline(@procfunclist,spaces+'  Begin',''); 
  if (pdwn^.codeoptions[4]) then 
    addline(@procfunclist,spaces+'    OpenWindow'+nicestring(no0(pdwn^.labelid))+':=false;',''); {81}
  
  addline(@procfunclist,spaces+'    FreeScreenDrawInfo(pscr,'+no0(pdwn^.labelid)+'DrawInfo);','');     {36}
  addline(@procfunclist,spaces+'    FreeVisualInfo('+no0(pdwn^.labelid)+'VisualInfo);',''); {79}
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@procfunclist,spaces+'    FreeGadgets('+no0(pdwn^.labelid)+'GList);',''); {80}
  str(pdwn^.maxw,s);
  str(pdwn^.maxh,s2);
  s:=s+', '+s2;
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    addline(@procfunclist,spaces+'    freebitmap('+no0(pdwn^.labelid)+'BitMap, '+s+');','');
    
  addline(@procfunclist,spaces+'  end;','');
  
  {* * * * * * * * * * * * * * * * * *}
  
  {****    ****    ****}
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      dec(spaces[0],4);
      addline(@procfunclist,spaces+'  end','');
      addline(@procfunclist,spaces+' else','');
      str(pdwn^.maxw,s);
      str(pdwn^.maxh,s2);
      s:=s+', '+s2;
      
      addline(@procfunclist,spaces+'  begin','');
      addline(@procfunclist,spaces+'    freebitmap('+no0(pdwn^.labelid)+'BitMap, '+s+');','');
      if (pdwn^.codeoptions[4]) then 
        addline(@procfunclist,spaces+'    OpenWindow'+nicestring(no0(pdwn^.labelid))+':=false;',''); {81}
      addline(@procfunclist,spaces+'    FreeScreenDrawInfo(pscr,'+no0(pdwn^.labelid)+'DrawInfo);','');     {36}
      addline(@procfunclist,spaces+'    FreeVisualInfo('+no0(pdwn^.labelid)+'VisualInfo);',''); {79}
      if sizeoflist(@pdwn^.gadgetlist)>0 then
        begin
          addline(@procfunclist,spaces+'    FreeGadgets('+no0(pdwn^.labelid)+'GList);',''); {80}
          addfreeobjects(pdwn,spaces);
        end;
      addline(@procfunclist,spaces+'  end;','');
    
    
      dec(spaces[0],4);
      addline(@procfunclist,spaces+'  end','');
      addline(@procfunclist,spaces+' else','');
      addline(@procfunclist,spaces+'  begin','');
      if (pdwn^.codeoptions[4]) then 
        addline(@procfunclist,spaces+'    OpenWindow'+nicestring(no0(pdwn^.labelid))+':=false;',''); {81}
      addline(@procfunclist,spaces+'    FreeScreenDrawInfo(pscr,'+no0(pdwn^.labelid)+'DrawInfo);','');     {36}
      addline(@procfunclist,spaces+'    FreeVisualInfo('+no0(pdwn^.labelid)+'VisualInfo);',''); {79}
      if sizeoflist(@pdwn^.gadgetlist)>0 then
        begin
          addline(@procfunclist,spaces+'    FreeGadgets('+no0(pdwn^.labelid)+'GList);',''); {80}
          addfreeobjects(pdwn,spaces);
        end;
      addline(@procfunclist,spaces+'  end;','');
    
    end;
    
    
  if (count>0) and (pdwn^.codeoptions[5]) then      {if pgad<>nil}
    begin
      dec(spaces[0],4);
      addline(@procfunclist,spaces+'  end','');
      addline(@procfunclist,spaces+' else','');
      if (pdwn^.codeoptions[4]) then
        begin
          addline(@procfunclist,spaces+'  Begin','');
          addline(@procfunclist,spaces+'    OpenWindow'+nicestring(no0(pdwn^.labelid))+':=false;','');
          
          addline(@procfunclist,spaces+'    FreeScreenDrawInfo(pscr,'+no0(pdwn^.labelid)+'DrawInfo);','');     {36}
          addline(@procfunclist,spaces+'    FreeVisualInfo('+no0(pdwn^.labelid)+'Visualinfo);','');  {36}
          addline(@procfunclist,spaces+'  End;','');
        end
       else
        begin
          addline(@procfunclist,spaces+'  FreeScreenDrawInfo(pscr,'+no0(pdwn^.labelid)+'DrawInfo);','');     {36}
          addline(@procfunclist,spaces+'  FreeVisualInfo('+no0(pdwn^.labelid)+'Visualinfo);','');     {36}
        end;
    end;
  
  {**************************************************}
  
  dec(spaces[0],4);
  if pdwn^.codeoptions[4] then
    begin
      addline(@procfunclist,spaces+'  end','');                                      {26}
      addline(@procfunclist,spaces+' else','');                                      {27}
      addline(@procfunclist,spaces+'  begin','');                                      {27}
      addline(@procfunclist,spaces+'    FreeVisualInfo('+no0(pdwn^.labelid)+'Visualinfo);','');     {36}
      addline(@procfunclist,spaces+'    openwindow'+nicestring(no0(pdwn^.labelid))+':=false;',''); {28}
      addline(@procfunclist,spaces+'  end;','');                                      {27}
    end
   else
    addline(@procfunclist,spaces+'  end;',''); {29}
  
  dec(spaces[0],4);
  if pdwn^.codeoptions[4] then
    begin
      addline(@procfunclist,spaces+'  end','');                                      {26}
      addline(@procfunclist,spaces+' else','');                                      {27}
      addline(@procfunclist,spaces+'  openwindow'+nicestring(no0(pdwn^.labelid))+':=false;',''); {28}
    end
   else
    addline(@procfunclist,spaces+'  end;',''); {29}
  
  if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
    begin
      dec(spaces[0],4);
      addline(@procfunclist,spaces+'    UnLockPubScreen( Nil, PScr);','');    {20}
      if pdwn^.codeoptions[4] then
        begin
          addline(@procfunclist,spaces+'  end','');
          addline(@procfunclist,spaces+' else','');
          addline(@procfunclist,spaces+'  openwindow'+nicestring(no0(pdwn^.labelid))+':=false;','');
        end
       else
        addline(@procfunclist,spaces+'  end;',''); {22}
    end;
  if pdwn^.codeoptions[1] then
    begin
      if (not (pdwn^.codeoptions[7])and(pdwn^.codeoptions[4])) and
         (not pdwn^.codeoptions[2]) and
         (not pdwn^.codeoptions[3]) then
        addline(@procfunclist,'    end;','')          {14}
       else
        begin
          addline(@procfunclist,'    end','');         {15}
          addline(@procfunclist,'   else','');
          addline(@procfunclist,'    begin','');         
          if pdwn^.codeoptions[2] then
            addline(@procfunclist,'      WindowToFront('+no0(pdwn^.labelid)+');','');
          if pdwn^.codeoptions[3] then
            begin
              if not producernode^.codeoptions[13] then
                addline(@procfunclist,'      if 0=activatewindow('+no0(pdwn^.labelid)+') then;','')
               else
                addline(@procfunclist,'      activatewindow('+no0(pdwn^.labelid)+');','');
            end;
          if (pdwn^.codeoptions[7])and(pdwn^.codeoptions[4]) then
            addline(@procfunclist,'      OpenWindow'+nicestring(no0(pdwn^.labelid))+':=false;','');
          addline(@procfunclist,'    end;','');
        end;
      {check if already open}
    end;
  addline(@procfunclist,'end;','');             {16}
  processclosewindow(pdwn);
  if producernode^.codeoptions[3] then
    processwindowidcmp(pdwn);
  comment:=producernode^.codeoptions[1];
end;



end.