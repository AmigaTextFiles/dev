unit menus;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,liststuff,producerlib,
     fonts,amigados,graphics,definitions,iffparse,amiga,asl,workbench,localestuff;

procedure processmenu(pdmn:pdesignermenunode);

implementation

{ produces function which is a basis for the handling of IDCMP data for }
{ the menu pdmn }

procedure menuidcmp(pdmn:pdesignermenunode);
var
  pmtn    : pmenutitlenode;
  pmin    : pmenuitemnode;
  pmsi    : pmenusubitemnode;
begin
  addline(@idcmplist,'','');
  addline(@idcmplist,'{ Menu Processing for '+sfp(pdmn^.mn_label)+' }','');
  addline(@idcmplist,'{ Just pass the code field from an IDCMP_MENUPICK message. }','');
  addline(@idcmplist,'','');
  addline(@idcmplist,'Procedure ProcessMenuIDCMP'+sfp(pdmn^.mn_label)+'( MenuNumber : word);','');
  addline(@idcmplist,'Var','');
  addline(@idcmplist,'  ItemNumber : Word;','');
  addline(@idcmplist,'  SubNumber  : Word;','');
  addline(@idcmplist,'  Done    : Boolean;','');
  addline(@idcmplist,'  Item    : pMenuItem;','');
  addline(@idcmplist,'Begin','');
  addline(@idcmplist,'  Done:=False;','');
  addline(@idcmplist,'  while (MenuNumber<>MENUNULL) and (Not Done) do','');
  addline(@idcmplist,'    Begin','');
  addline(@idcmplist,'      Item:=ItemAddress( '+sfp(pdmn^.mn_label)+', MenuNumber);','');
  addline(@idcmplist,'      ItemNumber:=ITEMNUM(MenuNumber);','');
  addline(@idcmplist,'      SubNumber:=SUBNUM(MenuNumber);','');
  addline(@idcmplist,'      MenuNumber:=MENUNUM(MenuNumber);','');
  addline(@idcmplist,'      Case MenuNumber of','');
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while(pmtn^.ln_succ<>nil) do
    begin
      addline(@idcmplist,'        '+sfp(pmtn^.mt_label)+' :','');
      addline(@idcmplist,'          Case ItemNumber of','');
      addline(@idcmplist,'            NOITEM :','');
      addline(@idcmplist,'              Begin','');
      addline(@idcmplist,'','                { No item selected }');
      addline(@idcmplist,'              end;','');
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while (pmin^.ln_succ<>nil) do
        begin
          addline(@idcmplist,'            '+sfp(pmin^.mi_label)+' :','');
          if sizeoflist(@pmin^.tsubitems)>0 then
            begin
              addline(@idcmplist,'              Case  SubNumber of','');
              addline(@idcmplist,'                NOSUB :','');
              addline(@idcmplist,'                  Begin','');
              addline(@idcmplist,'','                    { No subitem selected }');
              addline(@idcmplist,'                  end;','');
              pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
              while (pmsi^.ln_succ<>nil) do
                begin
                  addline(@idcmplist,'                '+sfp(pmsi^.ms_label)+' :','');
                  addline(@idcmplist,'                  Begin','');
                  addline(@idcmplist,'','                    { SubItem Text : '+sfp(pmsi^.ms_text)+' }');
                  addline(@idcmplist,'                  end;','');
                  pmsi:=pmsi^.ln_succ;
                end;
              addline(@idcmplist,'               end;','');
            end
           else
            begin
              addline(@idcmplist,'              Begin','');
              addline(@idcmplist,'','                { Menu Text : '+sfp(pmin^.mi_text)+' }');
              addline(@idcmplist,'              end;','');
            end;
          pmin:=pmin^.ln_succ;
        end;
      addline(@idcmplist,'           end;','');
      pmtn:=pmtn^.ln_succ;
    end;
  addline(@idcmplist,'       end;','');
  addline(@idcmplist,'      MenuNumber:=Item^.NextSelect;','');
  addline(@idcmplist,'    end;','');
  addline(@idcmplist,'end;','');
end;

{ produces code for the creation of menus }
{ This is complicated by the fact that HSPascal cannot have }
{ pointers to strings in const data, so these have to be added in the function }

procedure processmenu(pdmn:pdesignermenunode);
var
  pmtn    : pmenutitlenode;
  pmin    : pmenuitemnode;
  pmsi    : pmenusubitemnode;
  count   : long;
  psn     : pstringnode;
  s       : string;
  flagss  : string;
  mxs     : string;
  count2  : long;
  pin     : pimagenode;
  s2      : string;
  flags   : long;
  titlecount : word;
  itemcount  : word;
  subcount   : word;
  num        : word;
begin
  
  titlecount:=0;
  if producernode^.codeoptions[3] then
    menuidcmp(pdmn);
  oksofar:=true;
  count:=0;
  count2:=0;
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      str(titlecount,s2);
      addline(@constlist,'  '+sfp(pmtn^.mt_label)+' = '+s2+';','');
      inc(titlecount);
      if length(sfp(pmtn^.mt_text))>count2 then
        count2:=length(sfp(pmtn^.mt_text));
      itemcount:=0;
      inc(count);
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          str(itemcount,s2);
          addline(@constlist,'  '+sfp(pmin^.mi_label)+' = '+s2+';','');
          inc(itemcount);
          if length(sfp(pmin^.mi_text))>count2 then
            count2:=length(sfp(pmin^.mi_text));
          inc(count);
          subcount:=0;
          pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              str(subcount,s2);
              addline(@constlist,'  '+sfp(pmsi^.ms_label)+' = '+s2+';','');
              inc(subcount);
              inc(count);
              if length(sfp(pmsi^.ms_text))>count2 then
                count2:=length(sfp(pmsi^.ms_text));
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  addline(@procfunclist,'','');
  addline(@procfunclist,'Function MakeMenu'+sfp(pdmn^.mn_label)+'(VisualInfo : Pointer):Boolean;','');
  addline(@procfuncdefslist,'Function MakeMenu'+sfp(pdmn^.mn_label)+'(VisualInfo : Pointer):Boolean;','');
  addline(@procfunclist,'Const','');
  str(count2+1,s2);
  str(count+1,s);
  if not pdmn^.localmenu then
    begin
      addline(@procfunclist,'  MenuTexts : array[1..'+s+'] of string['+s2+']=','');
      addline(@procfunclist,'  (','');
    end
   else
    begin
      addline(@procfunclist,'  MenuStrings : array[1..'+s+'] of long =','');
      addline(@procfunclist,'  (','');
    end;
  
  addline(@varlist,'  '+sfp(pdmn^.mn_label)+' : pmenu;','');
  addline(@initlist,'  '+sfp(pdmn^.mn_label)+':=Nil;','');
  count:=0;
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      inc(count);
      if not pdmn^.localmenu then
        addline(@procfunclist,'  '''+sfp(pmtn^.mt_text)+'''#0,','')
       else
        begin
          localestring(sfp(pmtn^.mt_text),sfp(pmtn^.mt_label)+'String'
              ,'Menu: '+sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text));
          addline(@procfunclist,'  '+sfp(pmtn^.mt_label)+'String,','')
        end;
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          inc(count);
          if not pdmn^.localmenu then
            addline(@procfunclist,'  '''+sfp(pmin^.mi_text)+'''#0,','')
           else
            begin
              localestring(sfp(pmin^.mi_text),sfp(pmin^.mi_label)+'String'
                  ,'Menu: '+sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+' Item: '+sfp(pmin^.mi_text));   
              addline(@procfunclist,'  '+sfp(pmin^.mi_label)+'String,','')
            end;
          pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              inc(count);
              if not pdmn^.localmenu then
                addline(@procfunclist,'  '''+sfp(pmsi^.ms_text)+'''#0,','')
               else
                begin
                  localestring(sfp(pmsi^.ms_text),sfp(pmsi^.ms_label)+'String'
                      ,'Menu: '+sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+
                         ' Item: '+sfp(pmin^.mi_text)+' SubItem: '+sfp(pmsi^.ms_text));
                  addline(@procfunclist,'  '+sfp(pmsi^.ms_label)+'String,','')
                end;
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  if not pdmn^.localmenu then
    addline(@procfunclist,'  ''''#0','')
   else
    addline(@procfunclist,'  0','');
  addline(@procfunclist,'  );','');
  
  
  if pdmn^.localmenu then
    addline(@procfunclist,'  MenuCommKeys : array[1..'+s+'] of long=','')
   else
    addline(@procfunclist,'  MenuCommKeys : array[1..'+s+'] of string[2]=','');

  addline(@procfunclist,'  (','');
  count:=0;
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      inc(count);
      if pdmn^.localmenu then
        addline(@procfunclist,'  -1,','')
       else
        addline(@procfunclist,'  ''''#0,','');
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          inc(count);
          
          if pdmn^.localmenu then
            begin
              
              if pmin^.barlabel then
                addline(@procfunclist,'  -1,','')
               else
                begin
                  localestring(char(pmin^.commkey),sfp(pmin^.mi_label)+'CommKey'
                        ,'Menu: '+sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+
                           ' Item: '+sfp(pmin^.mi_text)+' CommKey');
               
                  addline(@procfunclist,'  '+sfp(pmin^.mi_label)+'CommKey,','');
                end;
            end
           else
            if (char(pmin^.commkey)<>#0)and(not pmin^.barlabel) then
              addline(@procfunclist,'  '''+char(pmin^.commkey)+'''#0,','')
             else
              addline(@procfunclist,'  ''''#0,','');
          
          pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              inc(count);
              if pdmn^.localmenu then
                begin
                  
                  if pmsi^.barlabel then
                    addline(@procfunclist,'  -1,','')
                   else
                    begin
                      localestring(char(pmsi^.commkey),sfp(pmsi^.ms_label)+'CommKey'
                        ,'Menu: '+sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+
                           ' Item: '+sfp(pmin^.mi_text)+' SubItem: '+sfp(pmsi^.ms_text)+' CommKey');
                      addline(@procfunclist,'  '+sfp(pmsi^.ms_label)+'CommKey,','');
                    end;
                end
               else
                if (char(pmsi^.commkey)<>#0)and (not pmsi^.barlabel) then
                  addline(@procfunclist,'  '''+char(pmsi^.commkey)+'''#0,','')
                 else
                  addline(@procfunclist,'  ''''#0,','');
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  if pdmn^.localmenu then
    addline(@procfunclist,'  -1','')
   else
    addline(@procfunclist,'  '' ''#0','');
  addline(@procfunclist,'  );','');
  
  addline(@procfunclist,'  NewMenus : array[1..'+s+'] of tnewmenu=','');
  addline(@procfunclist,'  (','');
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      inc(count);
      flags:=0;
      if pmtn^.disabled then
        flags:=Nm_MenuDisabled;
      str(flags,flagss);
      addline(@procfunclist,'  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : '
                            +flagss+'; Nm_MutualExclude : 0),','');
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          inc(count);
          if oksofar then
            begin
              flags:=0;
              if pmin^.disabled then
                flags:=flags or Nm_ItemDisabled;
              if pmin^.Checked then
                flags:=flags or Checked;
              if pmin^.Checkit then
                flags:=flags or Checkit;
              if pmin^.MenuToggle then
                flags:=flags or MenuToggle;
              str(flags,flagss);
              str(pmin^.exclude,mxs);
              if not pmin^.barlabel then
                if pmin^.graphic=nil then
                  addline(@procfunclist,'  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : '
                                         +flagss+'; Nm_MutualExclude : '+mxs+'),','')
                 else
                  addline(@procfunclist,'  ( Nm_Type :  Im_Item; Nm_Label : Nil; Nm_Flags : '
                                         +flagss+'; Nm_MutualExclude : '+mxs+'),','')
               else
                addline(@procfunclist,'  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :'
                                         +flagss+'; Nm_MutualExclude : '+mxs+'),','')
            end;
          pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              inc(count);
              if oksofar then
                begin
                  flags:=0;
                  if pmsi^.disabled then
                    flags:=flags or Nm_ItemDisabled;
                  if pmsi^.Checked then
                    flags:=flags or Checked;
                  if pmsi^.Checkit then
                    flags:=flags or Checkit;
                  if pmsi^.MenuToggle then
                    flags:=flags or MenuToggle;
                  str(flags,flagss);
                  str(pmsi^.exclude,mxs);
                  if not pmsi^.barlabel then
                    if pmsi^.graphic=nil then
                      addline(@procfunclist,'  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : '
                                             +flagss+'; Nm_MutualExclude : '+mxs+'),','')
                     else
                      addline(@procfunclist,'  ( Nm_Type :   Im_Sub; Nm_Label : Nil; Nm_Flags : '
                                             +flagss+'; Nm_MutualExclude : '+mxs+'),','')
                   else
                    addline(@procfunclist,'  ( Nm_Type :   Nm_Sub; Nm_Label : Nil; Nm_Flags : '
                                             +flagss+'; Nm_MutualExclude : '+mxs+'),','')
                end;
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  addline(@procfunclist,'  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)','');
  addline(@procfunclist,'  );','');
  addline(@procfunclist,'Var','');
  addline(@procfunclist,'  Loop     : Word;','');
  addline(@procfunclist,'  pnma     : PNewMenuArray;','');
  addline(@procfunclist,'  Tags     : array [1..3] of TTagItem;','');
  addline(@procfunclist,'Begin','');
  addline(@procfunclist,'  pnma:=PNewMenuArray(@NewMenus[1]);','');
  addline(@procfunclist,'  for loop:=1 to '+s+' do','');
  addline(@procfunclist,'    begin','');
  addline(@procfunclist,'      if pnma^[loop].nm_label=Nil then','');
  if not pdmn^.localmenu then
    addline(@procfunclist,'        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);','')
   else
    addline(@procfunclist,'        pnma^[loop].nm_label:=STRPTR('+sfp(producernode^.GetString)+'ptr(MenuStrings[loop]));','');
  if pdmn^.localmenu then
    begin
      addline(@procfunclist,'      if MenuCommKeys[loop]<>-1 then','');
      addline(@procfunclist,'        begin','');
  
      addline(@procfunclist,'          pnma^[loop].nm_commkey:=STRPTR('+sfp(producernode^.GetString)+
                                     'ptr(MenuCommKeys[loop]));','');
      addline(@procfunclist,'          if pnma^[loop].nm_commkey^=0 then','');
      addline(@procfunclist,'            pnma^[loop].nm_commkey:=nil;','');
      addline(@procfunclist,'        end','');
  
      addline(@procfunclist,'       else','');
      addline(@procfunclist,'        pnma^[loop].nm_commkey:=nil;','');
    end
   else
    begin
      addline(@procfunclist,'      if MenuCommKeys[loop]<>''''#0 then','');
      addline(@procfunclist,'        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])','');
      addline(@procfunclist,'       else','');
      addline(@procfunclist,'        pnma^[loop].nm_commkey:=nil;','');
    end;
  count2:=0;
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          if pmin^.graphic<>nil then
            inc(count2);
          if pmin^.barlabel then
            inc(count2);
          pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              if pmsi^.graphic<>nil then
                inc(count2);
              if pmsi^.barlabel then
                inc(count2);
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  if count2>0 then
    begin
      addline(@procfunclist,'      case loop of','');
      count:=0;
      pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
      while (pmtn^.ln_succ<>nil) do
        begin
          inc(count);
          pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
          while(pmin^.ln_succ<>nil) do
            begin
              inc(count);
              if pmin^.graphic<>nil then
                begin
                  str(count,s);
                  if length(s)=1 then
                    s:=s+' ';
                  pin:=pmin^.graphic;
                  addline(@procfunclist,'        '+s+' : pnma^[loop].nm_label:=strptr(@'+sfp(pin^.in_label)+');','');
                end;
              if pmin^.barlabel then
                begin
                  str(count,s);
                  if length(s)=1 then
                    s:=s+' ';
                  addline(@procfunclist,'        '+s+' : pnma^[loop].nm_label:=strptr(Nm_BarLabel);','');
                end;
              pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
              while (pmsi^.ln_succ<>nil) do
                begin
                  inc(count);
                  if pmsi^.graphic<>nil then
                    begin
                      str(count,s);
                      if length(s)=1 then
                        s:=s+' ';
                      pin:=pmsi^.graphic;
                      addline(@procfunclist,'        '+s+' : pnma^[loop].nm_label:=strptr(@'+sfp(pin^.in_label)+');','');
                    end;
                  if pmsi^.barlabel then
                    begin
                      str(count,s);
                      if length(s)=1 then
                        s:=s+' ';
                      addline(@procfunclist,'        '+s+' : pnma^[loop].nm_label:=strptr(Nm_BarLabel);','');
                    end;
                  pmsi:=pmsi^.ln_succ;
                end;
              pmin:=pmin^.ln_succ;
            end;
          pmtn:=pmtn^.ln_succ;
        end;
      addline(@procfunclist,'       end;','');
    end;
  addline(@procfunclist,'    end;','');
  if oksofar then
    if pdmn^.frontpen<>0 then
      begin
        addline(@procfunclist,'  tags[1].ti_tag:=gtmn_frontpen;','');
        str(pdmn^.frontpen,s);
        addline(@procfunclist,'  tags[1].ti_data:='+s+';','');
        addline(@procfunclist,'  tags[2].ti_tag:=tag_done;','');
        addline(@procfunclist,'  '+sfp(pdmn^.mn_label)+':=createmenusa(@newmenus[1],@tags[1]);','');
      end
     else
      addline(@procfunclist,'  '+sfp(pdmn^.mn_label)+':=createmenusa(@newmenus[1],Nil);','');
  addline(@procfunclist,'  If '+sfp(pdmn^.mn_label)+'<>nil then ','');
  addline(@procfunclist,'    begin','');
  if pdmn^.defaultfont then
    begin
      addline(@procfunclist,'      tags[1].ti_tag:=gt_tagbase+67;','');
      addline(@procfunclist,'      tags[1].ti_data:=long(true);','');
      addline(@procfunclist,'      tags[2].ti_tag:=tag_done;','');
    end
   else
    begin
      addline(@procfunclist,'      tags[1].ti_tag:=gtmn_textattr;','');
      addline(@procfunclist,'      tags[1].ti_data:=long(@'+makemyfont(pdmn^.font)+');','');
      addline(@procfunclist,'      tags[2].ti_tag:=gt_tagbase+67;','');
      addline(@procfunclist,'      tags[2].ti_data:=long(true);','');
      addline(@procfunclist,'      tags[3].ti_tag:=tag_done;','');
    end;
  addline(@procfunclist,'      if layoutmenusa('+sfp(pdmn^.mn_label)+',visualinfo,@tags[1]) then;','');
  addline(@procfunclist,'      makemenu'+sfp(pdmn^.mn_label)+':=True;','');
  addline(@procfunclist,'    end','');
  addline(@procfunclist,'   else','');
  addline(@procfunclist,'    makemenu'+sfp(pdmn^.mn_label)+':=false;','');
  addline(@procfunclist,'end;','');
end;

end.