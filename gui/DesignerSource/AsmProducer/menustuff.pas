unit menustuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;


procedure menuidcmp(pdmn:pdesignermenunode);
procedure processmenu(pdmn:pdesignermenunode);


implementation

procedure menuidcmp(pdmn:pdesignermenunode);
var
  pmtn    : pmenutitlenode;
  pmin    : pmenuitemnode;
  pmsi    : pmenusubitemnode;
begin
  
  addline(@idcmplist,'','');
  addline(@idcmplist,sfp(pdmn^.mn_label)+'SubItemNumber:','');
  addline(@idcmplist,'    dc.w    0','');
  addline(@idcmplist,sfp(pdmn^.mn_label)+'ItemNumber:','');
  addline(@idcmplist,'    dc.w    0','');
  addline(@idcmplist,sfp(pdmn^.mn_label)+'Item:','');
  addline(@idcmplist,'    dc.l    0','');

  addline(@idcmplist,'','');
  addline(@idcmplist,'ProcessMenuIDCMP'+sfp(pdmn^.mn_label)+':','MenuNumber in d0, Code field of intuimessage.');
  addline(@idcmplist,'    movem.l d1-d4/a0-a4/a6,-(sp)','');
  
  addline(@idcmplist,sfp(pdmn^.mn_label)+'HandleLoop:','');
 
  addline(@idcmplist,'    move.l  #0,d5','');
  addline(@idcmplist,'    move.w  d0,d5','');
  addline(@idcmplist,'    move.l  d5,d0','');
  addline(@idcmplist,'    movea.l '+sfp(pdmn^.mn_label)+',a0','');
  addline(@idcmplist,'    movea.l _IntuitionBase,a6','');
  addline(@idcmplist,'    jsr     ItemAddress(a6)','');
  addline(@idcmplist,'    move.l  d0,'+sfp(pdmn^.mn_label)+'Item','');
  
  addline(@idcmplist,'    tst.l   d0','');
  addline(@idcmplist,'    beq     '+sfp(pdmn^.mn_label)+'Finished','');
  
  addline(@idcmplist,'    move.l  d5,d0','');
  
  addline(@idcmplist,'    lsr     #5,d0','');
  addline(@idcmplist,'    lsr     #6,d0','');
  addline(@idcmplist,'    and.w   #31,d0','SubItemNumber in d0');
  addline(@idcmplist,'    move.w  d0,'+sfp(pdmn^.mn_label)+'SubItemNumber','');
  
  addline(@idcmplist,'    move.w  d5,d0','');
  addline(@idcmplist,'    lsr     #5,d0','');
  addline(@idcmplist,'    and.w   #63,d0','ItemNumber in d0');
  addline(@idcmplist,'    move.w  d0,'+sfp(pdmn^.mn_label)+'ItemNumber','');
  
  addline(@idcmplist,'    move.w  d5,d0','');
  addline(@idcmplist,'    and.w   #31,d0','MenuNumber in d0');
  
  addline(@idcmplist,'    cmp.w   #31,d0','');
  addline(@idcmplist,'    bne     No'+sfp(pdmn^.mn_label)+'Menu','');
  addline(@idcmplist,'','No Menu selected');
  addline(@idcmplist,'    jmp     '+sfp(pdmn^.mn_label)+'ItemDone','');
  addline(@idcmplist,'No'+sfp(pdmn^.mn_label)+'Menu:','');
  

  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);  
  while(pmtn^.ln_succ<>nil) do
    begin
      addline(@idcmplist,'    cmp.w   #'+sfp(pmtn^.mt_label)+',d0','');
      addline(@idcmplist,'    bne     Not'+sfp(pmtn^.mt_label),'');
      
      addline(@idcmplist,'    move.w  '+sfp(pdmn^.mn_label)+'ItemNumber,d0','');
          
      addline(@idcmplist,'    cmp.w   #63,d0','');
      addline(@idcmplist,'    bne     Not'+sfp(pmtn^.mt_label)+'NoItem','');
      

      addline(@idcmplist,'','No Item selected');
      addline(@idcmplist,'    jmp     '+sfp(pdmn^.mn_label)+'ItemDone','');
      addline(@idcmplist,'Not'+sfp(pmtn^.mt_label)+'NoItem:','');
      
      
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while (pmin^.ln_succ<>nil) do
        begin
          
          addline(@idcmplist,'    cmp.w   #'+sfp(pmin^.mi_label)+',d0','');
          addline(@idcmplist,'    bne     Not'+sfp(pmin^.mi_label),'');
      
          if sizeoflist(@pmin^.tsubitems)>0 then
            begin
              
              addline(@idcmplist,'    move.w  '+sfp(pdmn^.mn_label)+'SubItemNumber,d0','');
              
              addline(@idcmplist,'    cmp.w   #31,d0','');
              addline(@idcmplist,'    bne     Not'+sfp(pmin^.mi_label)+'NoSubItem','');
      

              addline(@idcmplist,'','No SubItem selected');
              addline(@idcmplist,'    jmp     '+sfp(pdmn^.mn_label)+'ItemDone','');
              addline(@idcmplist,'Not'+sfp(pmin^.mi_label)+'NoSubItem:','');
      

              
              pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
              while (pmsi^.ln_succ<>nil) do
                begin
                  
                  addline(@idcmplist,'    cmp.w   #'+sfp(pmsi^.ms_label)+',d0','');
                  addline(@idcmplist,'    bne     Not'+sfp(pmsi^.ms_label),'');
                  
                  addline(@idcmplist,'','SubItem Text : '+sfp(pmsi^.ms_text));
         
                  addline(@idcmplist,'    jmp     '+sfp(pdmn^.mn_label)+'ItemDone','');
                  addline(@idcmplist,'Not'+sfp(pmsi^.ms_label)+':','');
                  
                  pmsi:=pmsi^.ln_succ;
                end;
            end
           else
            begin
              addline(@idcmplist,'','Item Text : '+sfp(pmin^.mi_text));
            end;
          
          addline(@idcmplist,'    jmp     '+sfp(pdmn^.mn_label)+'ItemDone','');
          addline(@idcmplist,'Not'+sfp(pmin^.mi_label)+':','');
          pmin:=pmin^.ln_succ;
        end;
      
      addline(@idcmplist,'    jmp     '+sfp(pdmn^.mn_label)+'ItemDone','');
      addline(@idcmplist,'Not'+sfp(pmtn^.mt_label)+':','');
      addline(@idcmplist,'','');

      pmtn:=pmtn^.ln_succ;
    
    end;
    
  addline(@idcmplist,sfp(pdmn^.mn_label)+'ItemDone:','');
  addline(@idcmplist,'','');
  addline(@idcmplist,'    movea.l '+sfp(pdmn^.mn_label)+'Item,a0','');
  addline(@idcmplist,'    move.w  32(a0),d0','');
  addline(@idcmplist,'    jmp     '+sfp(pdmn^.mn_label)+'HandleLoop','');
  addline(@idcmplist,'','');
  
  addline(@idcmplist,sfp(pdmn^.mn_label)+'Finished:','');
  
  addline(@idcmplist,'    movem.l (sp)+,d1-d4/a0-a4/a6','');
  addline(@idcmplist,'    rts','');
  
end;

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
  mycount    : long;
  car        : string;
  idcount    : integer;
  sid        : string;
  temp       : string[60];
  s5         : string;
  cnopneeded : boolean;
begin
  idcount:=0;
  cnopneeded :=false;
  titlecount:=0;
  if producernode^.codeoptions[3] then
    menuidcmp(pdmn);
  oksofar:=true;
  count:=0;
  count2:=3;
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      str(titlecount,s2);
      str(idcount,sid);
      inc(idcount);
      temp:='';
      if length(sfp(pmtn^.mt_label))<40 then
        temp:=copy('                                        ',1,40-length(sfp(pmtn^.mt_label)));
      addline(@defineslist,sfp(pmtn^.mt_label)+temp+'    EQU    '+s2,'');
      
      inc(titlecount);
      itemcount:=0;
      inc(count);
      
      if not pdmn^.localmenu then
        begin
          addline(@constlist,'','');
          addline(@constlist,sfp(pdmn^.mn_label)+'Name'+sid+':','');
          addline(@constlist,'    dc.b    '''+sfp(pmtn^.mt_text)+''',0','');
          cnopneeded:=true;
        end;

      
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          str(itemcount,s2);
          str(idcount,sid);
          inc(idcount);
          temp:='';
          if length(sfp(pmin^.mi_label))<40 then
            temp:=copy('                                        ',1,40-length(sfp(pmin^.mi_label)));
          addline(@defineslist,sfp(pmin^.mi_label)+temp+'    EQU    '+s2,'');
          
          if not pdmn^.localmenu then
            begin
              addline(@constlist,'','');
              addline(@constlist,sfp(pdmn^.mn_label)+'Name'+sid+':','');
              addline(@constlist,'    dc.b    '''+sfp(pmin^.mi_text)+''',0','');
              cnopneeded:=true;
            end;
              
          if not (char(pmin^.commkey)=#0) then
            begin
              if pdmn^.localmenu then
                localestring(char(pmin^.commkey),sfp(pdmn^.mn_label)+'Comm'+sid,'Menu : '+sfp(pdmn^.mn_label)+
                           ' Title : '+sfp(pmtn^.mt_text)+' Item : '+sfp(pmin^.mi_text)+' Commkey')
               else
                begin
                  addline(@constlist,'','');
                  addline(@constlist,sfp(pdmn^.mn_label)+'Comm'+sid+':','');
                  addline(@constlist,'    dc.b    '''+char(pmin^.commkey)+''',0','');
                end;
            end;
          
          inc(itemcount);
          
          inc(count);
          subcount:=0;
          pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              str(idcount,sid);
              inc(idcount);
              str(subcount,s2);
              
              temp:='';
              if length(sfp(pmsi^.ms_label))<40 then
                temp:=copy('                                        ',1,40-length(sfp(pmsi^.ms_label)));
              addline(@defineslist,sfp(pmsi^.ms_label)+temp+'    EQU    '+s2,'');
              
              if not pdmn^.localmenu then
                begin
                  addline(@constlist,'','');
                  addline(@constlist,sfp(pdmn^.mn_label)+'Name'+sid+':','');
                  addline(@constlist,'    dc.b    '''+sfp(pmsi^.ms_text)+''',0','');
                  cnopneeded:=true;
                end;
              if not (char(pmsi^.commkey)=#0) then
                begin
                  if pdmn^.localmenu then
                    localestring(char(pmsi^.commkey),sfp(pdmn^.mn_label)+'Comm'+sid,'Menu : '+sfp(pdmn^.mn_label)+' Title : '+
                                  sfp(pmtn^.mt_text)+' Item : '+sfp(pmin^.mi_text)+' SubItem : '+sfp(pmsi^.ms_text)+'Commkey')
                   else
                    begin
                      addline(@constlist,'','');
                      addline(@constlist,sfp(pdmn^.mn_label)+'Comm'+sid+':','');
                      addline(@constlist,'    dc.b    '''+char(pmsi^.commkey)+''',0','');
                    end;
                end;

              
              inc(subcount);
              inc(count);
              
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  
  {count2 is longest string bit }
  
  if cnopneeded then
    begin
      addline(@constlist,'','');
      addline(@constlist,'    cnop    0,2','');
    end;
  
  idcount:=0;
  
  inc(count2,2);
  str(count+1,s);
  addline(@constlist,'','');
  
  addline(@constlist,'    XDEF    '+sfp(pdmn^.mn_label)+'NewMenu0','');
  addline(@constlist,'','');
  addline(@externlist,'    XREF    '+sfp(pdmn^.mn_label)+'NewMenu0','');
  
  mycount:=0;
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      inc(count);
      inc(mycount);
      flags:=0;
      
      str(idcount,sid);
      inc(idcount);
      addline(@constlist,sfp(pdmn^.mn_label)+'NewMenu'+sid+':','');
      
      if pmtn^.disabled then
        flags:=NM_MENUDISABLED;
      addline(@constlist,'    dc.b    1,0','Menu Title ');
      if pdmn^.localmenu then
        addline(@constlist,'    dc.l    0','Title String')
       else
        addline(@constlist,'    dc.l    '+sfp(pdmn^.mn_label)+'Name'+sid,'Title String');
      
      s5:='0';
      if pdmn^.localmenu then
        s5:='$FFFFFFFF';
      
      addline(@constlist,'    dc.l    0','CommKey (Not Used)');
      str(flags,flagss);
      addline(@constlist,'    dc.w    '+flagss,'Title Flags');
      if pdmn^.localmenu  then
        begin
          addline(@constlist,'    dc.l    0, '+sfp(pdmn^.mn_label)+'String'+sid,'Title Locale String ID');
          localestring(sfp(pmtn^.mt_text),sfp(pdmn^.mn_label)+'String'+sid,
                'Menu: '+sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text));
        end
       else
        addline(@constlist,'    dc.l    0,0','MX, User Field');
      addline(@constlist,'','');
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          inc(count);
          inc(mycount);
          if oksofar then
            begin
              str(idcount,sid);
              inc(idcount);
              
              addline(@constlist,sfp(pdmn^.mn_label)+'NewMenu'+sid+':','');
              
              flags:=0;
              if pmin^.disabled then
                flags:=NM_ITEMDISABLED;
              if pmin^.Checked then
                flags:=flags or CHECKED;
              if pmin^.Checkit then
                flags:=flags or CHECKIT;
              if pmin^.MenuToggle then
                flags:=flags or MENUTOGGLE;
              str(flags,flagss);
              
              if char(pmin^.commkey)=#0 then
                if pdmn^.localmenu then
                  car:='$FFFFFFFF'
                 else
                  car:='0'
               else
                car:=sfp(pdmn^.mn_label)+'Comm'+sid;
              
              if pmin^.exclude<>0 then
                str(pmin^.exclude,mxs)
               else
                mxs:='0';
              
              if pmin^.graphic=nil then
                addline(@constlist,'    dc.b    2,0','Menu Item')
               else
                addline(@constlist,'    dc.b    $82,0','Menu Item (Image)');
              
              s:='0';
              if pdmn^.localmenu then
                s5:='$FFFFFFFF';
              
              if pmin^.barlabel then
                addline(@constlist,'    dc.l    $FFFFFFFF,'+s5,'Item BarLabel')
               else
                begin
                  if pmin^.graphic=nil then
                    if not pdmn^.localmenu then
                      addline(@constlist,'    dc.l    '+sfp(pdmn^.mn_label)+'Name'+sid,'Item String')
                     else
                      addline(@constlist,'    dc.l    0','Item String')
                   else
                    begin
                      s:=sfp(pmin^.graphic^.in_label);
                      addline(@constlist,'    dc.l    '+s,'Item Image');
                    end;
                  addline(@constlist,'    dc.l    '+car,'Item Commkey');
                end;
              
              addline(@constlist,'    dc.w    '+flagss,'Item Flags');
              addline(@constlist,'    dc.l    '+mxs,'Item Mutual Exclude');
              
              if pmin^.barlabel or (not pdmn^.localmenu) or (pmin^.graphic <>nil) then
                addline(@constlist,'    dc.l    0','User Field')
               else
                begin
                  localestring(sfp(pmin^.mi_text),sfp(pdmn^.mn_label)+'String'+sid,'Menu: '
                               +sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+' Item: '+sfp(pmin^.mi_text));
                  addline(@constlist,'    dc.l    '+sfp(pdmn^.mn_label)+'String'+sid,'Item Locale String ID');
                end;
            end;
          
          addline(@constlist,'','');
          
          pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              inc(count);
              inc(mycount);
              str(idcount,sid);
              inc(idcount);
              if oksofar then
                begin
                  flags:=0;
                  if pmsi^.disabled then
                    flags:=flags or NM_ITEMDISABLED;
                  if pmsi^.Checked then
                    flags:=flags or CHECKED;
                  if pmsi^.Checkit then
                    flags:=flags or CHECKIT;
                  if pmsi^.MenuToggle then
                    flags:=flags or MENUTOGGLE;
                  str(flags,flagss);
                  
                  if char(pmsi^.commkey)=#0 then
                    if pdmn^.localmenu then
                      car:='$FFFFFFFF'
                     else
                      car:='0'
                   else
                    car:=sfp(pdmn^.mn_label)+'Comm'+sid;
                  
                  if pmsi^.exclude<>0 then
                    str(pmsi^.exclude,mxs)
                   else
                    mxs:='0';
                  
                  addline(@constlist,sfp(pdmn^.mn_label)+'NewMenu'+sid+':','');
                  
                  if pmsi^.graphic=nil then
                    addline(@constlist,'    dc.b    3,0','Menu SubItem')
                   else
                    addline(@constlist,'    dc.b    $83,0','Menu SubItem (Image)');
              
                  if pdmn^.localmenu then
                    s5:='$FFFFFFFF'
                   else
                    s5:='0';
                  
                  if pmsi^.barlabel then
                    addline(@constlist,'    dc.l    $FFFFFFFF,'+s5,'SubItem BarLabel')
                   else
                    begin
                      if pmsi^.graphic=nil then
                        if not pdmn^.localmenu then
                          addline(@constlist,'    dc.l    '+sfp(pdmn^.mn_label)+'Name'+sid,'SubItem String')
                         else
                          addline(@constlist,'    dc.l    0','SubItem String')
                       else
                        begin
                          s:=sfp(pmsi^.graphic^.in_label);
                          addline(@constlist,'    dc.l    '+s,'SubItem Image');
                        end;
                      addline(@constlist,'    dc.l    '+car,'SubItem Commkey');
                    end;
              
                  addline(@constlist,'    dc.w    '+flagss,'SubItem Flags');
                  addline(@constlist,'    dc.l    '+mxs,'SubItem Mutual Exclude');
              
                  if pmsi^.barlabel or (not pdmn^.localmenu) or (pmsi^.graphic<>nil) then
                    addline(@constlist,'    dc.l    0','User Field')
                   else
                    begin
                      localestring(sfp(pmsi^.ms_text),sfp(pdmn^.mn_label)+'String'+sid,'Menu: '
                                   +sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+' Item: '+
                                    sfp(pmin^.mi_text)+' Sub Item : '+sfp(pmsi^.ms_text));
                      addline(@constlist,'    dc.l    '+sfp(pdmn^.mn_label)+'String'+sid,'SubItem Locale String ID');
                    end;
                  
                  addline(@constlist,'','');                
                end;
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  addline(@constlist,'    dc.b    0,0','End new menu array');
  addline(@constlist,'    dc.l    0,0','');
  addline(@constlist,'    dc.w    0','');
  addline(@constlist,'    dc.l    0,0','');
  
  addline(@procfunclist,'','');
  addline(@procfuncdefslist,'    XREF    MakeMenu'+sfp(pdmn^.mn_label),'Parameter of visual info in a0');
  addline(@procfunclist,'    XDEF    MakeMenu'+sfp(pdmn^.mn_label),'');
  addline(@procfunclist,'MakeMenu'+sfp(pdmn^.mn_label)+':','Parameter of visual info in a0');
  addline(@procfunclist,'    movem.l d1-d4/a0-a4/a6,-(sp)','Store registers');
  
  addline(@constlist,'','');
  addline(@externlist,'    XREF    '+sfp(pdmn^.mn_label),'');
  addline(@constlist,'    XDEF    '+sfp(pdmn^.mn_label),'');
  addline(@constlist,sfp(pdmn^.mn_label)+':','Menu Pointer');
  addline(@constlist,'    dc.l    0','');
  
  addline(@constlist,'','');
  addline(@constlist,sfp(pdmn^.mn_label)+'VI:','Menu Visual Info');
  addline(@constlist,'    dc.l    1','');
  
  addline(@procfunclist,'    move.l  a0,'+sfp(pdmn^.mn_label)+'VI','Store VisualInfo');
  
  s:='';
  
  if pdmn^.frontpen<>0 then
    begin
      addline(@constlist,'','');
      addline(@constlist,sfp(pdmn^.mn_label)+'CT:','Tags for create menu');
      str(pdmn^.frontpen,s);
      addline(@constlist,'    dc.l    $80080032,'+s+',0',' GTMN_FrontPen, colour, Tag_Done');
    end;
  
  addline(@constlist,'','');
  addline(@constlist,sfp(pdmn^.mn_label)+'LT:','Tags for layout menu');
  if not pdmn^.defaultfont then
    addline(@constlist,'    dc.l    $80080031,'+makemyfont(pdmn^.font),' GTMN_TextAttr,font');
  addline(@constlist,'    dc.l    $80080043,1',' V39 newmenu');  
  addline(@constlist,'    dc.l    0',' Tag_Done');
  
  
  if pdmn^.localmenu then
    begin
      
      addline(@constlist,'    XDEF    '+sfp(pdmn^.mn_label)+'FirstRun','');
      addline(@constlist,sfp(pdmn^.mn_label)+'FirstRun:','');
      addline(@constlist,'    dc.l    1','');
      
      addline(@procfunclist,'    move.l  '+sfp(pdmn^.mn_label)+'FirstRun,d0','');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    beq     '+sfp(pdmn^.mn_label)+'RunBefore','');
      addline(@procfunclist,'    move.l  #0,'+sfp(pdmn^.mn_label)+'FirstRun','');
      
      addline(@procfunclist,'    move.l  #0,d1','');
      addline(@procfunclist,'    lea     '+sfp(pdmn^.mn_label)+'NewMenu0,a2','');
      addline(@procfunclist,sfp(pdmn^.mn_label)+'LocaleLoop:','');
      
      addline(@procfunclist,'    move.l  6(a2),d0','');
      addline(@procfunclist,'    cmp.l   #$FFFFFFFF,d0','');
      addline(@procfunclist,'    beq     '+sfp(pdmn^.mn_label)+'CommRoutine1','');
      addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
      addline(@procfunclist,'    move.l  d0,6(a2)','');
      addline(@procfunclist,'    jmp     '+sfp(pdmn^.mn_label)+'CommRoutine2','');
      addline(@procfunclist,sfp(pdmn^.mn_label)+'CommRoutine1:','');
      addline(@procfunclist,'    move.l  #0,6(a2)','');
      addline(@procfunclist,sfp(pdmn^.mn_label)+'CommRoutine2:','');
      
      addline(@procfunclist,'    move.l  2(a2),d0','');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    bne     '+sfp(pdmn^.mn_label)+'SkipThisOne','');
      addline(@procfunclist,'    move.l  16(a2),d0','');
      addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
      addline(@procfunclist,'    move.l  d0,2(a2)','');
      addline(@procfunclist,sfp(pdmn^.mn_label)+'SkipThisOne','');
      addline(@procfunclist,'    adda.l  #20,a2','');
      addline(@procfunclist,'    addq.l  #1,d1','');
      addline(@procfunclist,'    cmp.l   #'+fmtint(mycount)+',d1','');
      addline(@procfunclist,'    bne     '+sfp(pdmn^.mn_label)+'LocaleLoop','');
      
      addline(@procfunclist,sfp(pdmn^.mn_label)+'RunBefore:','');
      
      {
      str(mycount,s);
      addline(@procfunclist,'	for ( loop=0; loop<'+s+'; loop++)','');
      addline(@procfunclist,'		if ('+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_UserData!=(APTR)~0)','');
      addline(@procfunclist,'			'+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_Label = '+
                sfp(producernode^.getstring)+'((LONG)'+sfp(pdmn^.mn_label)+
                'NewMenu[loop].nm_UserData);','');
      }
      
    end;
  
  
  addline(@procfunclist,'    lea     '+sfp(pdmn^.mn_label)+'NewMenu0,a0','New Menu array into a0');
  if pdmn^.frontpen<>0 then
    addline(@procfunclist,'    lea     '+sfp(pdmn^.mn_label)+'CT,a1','Tags for createmenu into a1')
   else
    addline(@procfunclist,'    move.l  #0,a1','Tags for createmenu into a1');
    
  addline(@procfunclist,'    move.l  _GadToolsBase,a6','Prepare for GadTools call');
  addline(@procfunclist,'    jsr     CreateMenusA(a6)','Call create menu');
  addline(@procfunclist,'    move.l  d0,'+sfp(pdmn^.mn_label),'Copy result into menu pointer');
  addline(@procfunclist,'    tst.l   d0','See if bad result');
  addline(@procfunclist,'    beq     '+sfp(pdmn^.mn_label)+'CError','Return error');
  
  addline(@procfunclist,'    move.l  '+sfp(pdmn^.mn_label)+',a0','Menu into a0');
  addline(@procfunclist,'    move.l  '+sfp(pdmn^.mn_label)+'VI,a1','VisualInfo into a1');
  addline(@procfunclist,'    lea     '+sfp(pdmn^.mn_label)+'LT,a2','TagList into a2');
  
  addline(@procfunclist,'    move.l  _GadToolsBase,a6','Prepare for GadTools call');
  addline(@procfunclist,'    jsr     LayoutMenusA(a6)','Call create menu');
  addline(@procfunclist,'    tst.l   d0','See if bad result');
  addline(@procfunclist,'    beq     '+sfp(pdmn^.mn_label)+'LError','Return error');
  
  addline(@procfunclist,'    moveq   #0,d0','Set return value of 0');
  addline(@procfunclist,'    jmp     '+sfp(pdmn^.mn_label)+'Done','Exit succesfully');
  addline(@procfunclist,sfp(pdmn^.mn_label)+'CError:','In case of a create error');
  addline(@procfunclist,'    moveq   #1,d0','Set return value of 1');
  addline(@procfunclist,'    jmp     '+sfp(pdmn^.mn_label)+'Done','Go to end');
  addline(@procfunclist,sfp(pdmn^.mn_label)+'LError:','In case of a layout error');
  addline(@procfunclist,'    moveq   #2,d0','Set return value of 2');
  addline(@procfunclist,'    jmp     '+sfp(pdmn^.mn_label)+'Done','Go to end');
  addline(@procfunclist,'    move.l  '+sfp(pdmn^.mn_label)+',a0','Menu into a0');
  addline(@procfunclist,'    move.l  _GadToolsBase,a6','Prepare for GadTools call');
  addline(@procfunclist,'    jsr     FreeMenus(a6)','Free allocated menu');
  addline(@procfunclist,'    move.l  #0,'+sfp(pdmn^.mn_label),'');
  addline(@procfunclist,sfp(pdmn^.mn_label)+'Done:','Tidy up');
  addline(@procfunclist,'    movem.l (sp)+,d1-d4/a0-a4/a6','Restore registers');
  addline(@procfunclist,'    rts','');
  addline(@procfunclist,'','');
end;



end.