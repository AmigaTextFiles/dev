unit objectproduction;

{  
pgn data fields
  labelid         = label string
  x,y,w,h
  id
  datas           = class name
  tags[1].ti_tag  = class type
  tags[1].ti_data = scale ?
  tags[2].ti_tag  = create now ?
  tags[2].ti_data = gadget ?
  tags[3].ti_tag  = what is it ?
  tags[4].ti_tag  = dispose ?
  infolist        = list of tmytag
}

interface

uses amiga,exec,intuition,definitions,producerlib;

procedure addmyobjectconstdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
function  getenoughtags(pdwn:pdesignerwindownode):string;
function doobjects(pdwn:pdesignerwindownode;pgn:pgadgetnode;pos:long):long;
procedure addgadgetimagerenders(pdwn:pdesignerwindownode);
procedure addfreeobjects(pdwn:pdesignerwindownode);
procedure thosewhichneedscaling(pdwn:pdesignerwindownode);
procedure addcreateobjectcode(pdwn:pdesignerwindownode);

implementation

procedure addcreateobjectcode(pdwn:pdesignerwindownode);
var
  s2 : string;
  pmt : pmytag;
  s,s3 : string;
  pgn : pgadgetnode;
  pgn2: pgadgetnode;
  psn : pstringnode;
  needed : boolean;
  s6,s7 : string;
begin
  
  addline(@constlist,no0(pdwn^.labelid)+'Cla:','Private Class Name Container');
  addline(@constlist,'    dc.l    0','');
  addline(@constlist,no0(pdwn^.labelid)+'PrevGadget:','Previous Gadget Container');
  addline(@constlist,'    dc.l    0','');

  addline(@constlist,no0(pdwn^.labelid)+'QuickTags:','Tags for SetAttrs and SetGadgetAttrs');
  addline(@constlist,'    dc.l    0,0,0','');

  if comment then
    begin
      addline(@procfunclist,'','Code to create objects');
      addline(@procfunclist,'','d3 = current gad       a5 = current gad address');
      addline(@procfunclist,'','a4 = current gad tags  a3 = current gad kind');
      addline(@procfunclist,'','a2 = previous gad');
    end;
  addline(@procfunclist,'    move.l  a2,'+no0(pdwn^.labelid)+'PrevGadget','');
  addline(@procfunclist,'    move.l  #0,d3','Set to initial value');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'NGad,a5','Set to initial value');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'GTags,a4','Set to initial value');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'GTypes,a3','Set to initial value');
  addline(@procfunclist,no0(pdwn^.labelid)+'ObjectLoop:','');

{ skip gadtools gadgets }
  
  addline(@procfunclist,'    move.w  (a3),d0','');
  addline(@procfunclist,'    cmp.w   #198,d0','');
  addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'SkipNotObject','Skip gadget if it is not an object');
  
{ set necessary tags and Cla }
  
  addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'Cla','');
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
          
      if pgn^.kind=myobject_kind then
        begin
          needed:=false;
          addline(@procfunclist,'    cmp.w   #'+fmtint(pgn^.id-pdwn^.nextid)+',d3','');
          addline(@procfunclist,'    bne     '+no0(pgn^.labelid)+'NotThisGad','');
          
          
          if pgn^.tags[1].ti_tag=1 then
            begin
              addline(@constlist,'    XREF    '+no0(pgn^.datas),'');
              addline(@procfunclist,'    move.l  '+no0(pgn^.datas)+','+no0(pdwn^.labelid)+'Cla','');
            end;
          
          pmt:=pmytag(pgn^.infolist.mlh_head);
          while(pmt^.ln_succ<>nil) do
            begin
              if pmt^.tagtype=tagtypeobject then
                begin
                  str(long(pmt^.pos),s6);
                  pgn2:=pgadgetnode(pmt^.data);
                  if pgn2<>nil then
                    if getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<getlistpos(@pdwn^.gadgetlist,pnode(pgn)) then
                      begin
                        needed:=true;
                        addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'Gadgets,a0',
                                                    'Get gadget array address');
                        addline(@procfunclist,'    adda.l  #'+fmtint(4*(pgn2^.id-pdwn^.nextid))+',a0',
                                                    'Get address of position in array');
                        addline(@procfunclist,'    move.l  (a0),a0','');
                        str(pmt^.pos,s3);
                        addline(@procfunclist,'    move.l  a0,'+no0(pgn^.labelid)+'Tag'+s3+'+4','');
                        
                      end;
                end;
              pmt:=pmt^.ln_succ;
            end;
          
          if pgn^.tags[3].ti_tag=0 then
            begin
              needed:=true;
              str(pgn^.prevtagpos,s3);
              pgn2:=pgn^.prevobject;
              if pgn2<>nil then
                begin
                
                  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'Gadgets,a0','Get gadget array address');
                  addline(@procfunclist,'    adda.l  #'+fmtint(4*(pgn2^.id-pdwn^.nextid))+',a0',
                                                      'Get address of position in array');
                  addline(@procfunclist,'    move.l  (a0),a0','');
                  addline(@procfunclist,'    move.l  a0,'+no0(pgn^.labelid)+'Tag'+s3+'+4','');
                end
               else
                begin
                  addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'PrevGadget,'+no0(pgn^.labelid)+'Tag'+s3+'+4','');
                end;
            end;
          
          if needed then
            addline(@procfunclist,no0(pgn^.labelid)+'NotThisGad:','')
           else
            begin
              psn:=pstringnode(remtail(@procfunclist));
              freemymem(psn);
              psn:=pstringnode(remtail(@procfunclist));
              freemymem(psn);
            end;
          
        end;
          
      pgn:=pgn^.ln_succ;
    end;

  
{ perform for this gadget }
  
  addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'Cla,a0','Get Private Class Name in a0');
  addline(@procfunclist,'    movea.l 8(a5),a1','Get Public Class Name in a1');
  addline(@procfunclist,'    movea.l a4,a2','Get Tag array');
  
{ make gad }
  
  addline(@procfunclist,'    movea.l _IntuitionBase,a6','Prepare for GadTools call');
  addline(@procfunclist,'    jsr     NewObjectA(a6)','Create Gadget');
  addline(@procfunclist,'    movea.l d0,a2','Store result');
  
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'Gadgets,a0','Get gadget array address');
  addline(@procfunclist,'    move.l  d3,d0','Get gadget number');
  addline(@procfunclist,'    mulu    #4,d0','Get offset in array');
  addline(@procfunclist,'    adda.l  d0,a0','Get address of position in array');
  addline(@procfunclist,'    move.l  a2,(a0)','Store address');
  addline(@procfunclist,'    move.l  a2,d0','Put address back');
  
  addline(@procfunclist,'    tst.l   d0','test result');
  if pdwn^.codeoptions[5] then
    addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'BadGadgets','Create failed, fail open window')
   else
    addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'OpenBadGad','Create failed, still open window');
  


{ set other targets }
  
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
          
      if pgn^.kind=myobject_kind then
        begin
          
          addline(@procfunclist,'    cmp.w   #'+fmtint(pgn^.id-pdwn^.nextid)+',d3','');
          addline(@procfunclist,'    bne     '+no0(pgn^.labelid)+'NotThisGad2','');
          needed:=false;
          
           pgn2:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
           
           while (pgn2^.ln_succ<>nil) do
             begin
                    
               if (getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<getlistpos(@pdwn^.gadgetlist,pnode(pgn))) 
                  and (pgn2^.kind=myobject_kind) then
                 begin
                   pmt:=pmytag(pgn2^.infolist.mlh_head);
                   while(pmt^.ln_succ<>nil) do
                     begin
                        
                       if (pmt^.tagtype=tagtypeobject)and(pmt^.data=pointer(pgn)) then
                        begin
                          needed:=true;
                          addline(@procfunclist,'    movem.l d0/a0-a3,-(sp)','');
                          
                          addline(@procfunclist,'    move.l  a2,'+no0(pdwn^.labelid)+'QuickTags+4','');
                          
                          addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'Gadgets,a0','Get gadget array address');
                          addline(@procfunclist,'    adda.l  #'+fmtint(4*(pgn2^.id-pdwn^.nextid))+',a0',
                                                      'Get address of position in array');
                          addline(@procfunclist,'    move.l  (a0),a0','');
          
                          
                          str(pmt^.value,s2);
                          if pmt^.value=-1 then
                            s2:=sfp(pmt^.mt_label);
                          
                          addline(@procfunclist,'    move.l  #'+s2+','+no0(pdwn^.labelid)+'QuickTags','');
                          addline(@procfunclist,'    movea.l _IntuitionBase,a6','');
                          
                          if pgn^.tags[3].ti_tag>0 then
                            begin
                              addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'QuickTags,a1','Set Taglist');
                              addline(@procfunclist,'    jsr     SetAttrs(a6)','');
                            end
                           else
                            begin
                              addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'QuickTags,a3','Set taglist');
                              addline(@procfunclist,'    movea.l #0,a1','');
                              addline(@procfunclist,'    movea.l #0,a2','');
                              addline(@procfunclist,'    jsr     SetGadgetAttrsA(a6)','');
                            end;
                          
                          addline(@procfunclist,'    movem.l (sp)+,d0/a0-a3','');
                        end;
                 
                        pmt:=pmt^.ln_succ;
                     end;
                 end;
              pgn2:=pgn2^.ln_succ;
            end;
          if needed then
            addline(@procfunclist,no0(pgn^.labelid)+'NotThisGad2:','')
           else
            begin
              psn:=pstringnode(remtail(@procfunclist));
              freemymem(psn);
              psn:=pstringnode(remtail(@procfunclist));
              freemymem(psn);
            end;
          
        end;
          
      pgn:=pgn^.ln_succ;
    end;
      

  
{ Prepare for next loop }
  
  addline(@procfunclist,no0(pdwn^.labelid)+'SkipNotObject:','Skip gadget if it is not an object');
  
  addline(@procfunclist,'    add.w   #1,d3','Set for next NewGad');
  addline(@procfunclist,'    adda    #30,a5','Move to next NewGad');
  addline(@procfunclist,'    adda    #2,a3','Move to next Gad kind');
  
  addline(@procfunclist,'    jmp     '+no0(pdwn^.labelid)+'NextTag4','Get next tag array');
  addline(@procfunclist,no0(pdwn^.labelid)+'NextTag3:','Get next tag array');
  addline(@procfunclist,'    adda    #8,a4','Get next tag array');
  addline(@procfunclist,no0(pdwn^.labelid)+'NextTag4:','Get next tag array');
  addline(@procfunclist,'    move.l  (a4),d0','Get next tag array');
  addline(@procfunclist,'    tst.l   d0','Get next tag array');
  addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'NextTag3','Get next tag array');
  addline(@procfunclist,'    adda    #4,a4','Get next tag array');
  
  addline(@procfunclist,'    move.w  d3,d0','Put number of gadget in d0');
  addline(@procfunclist,'    sub.w   #'+fmtint(sizeoflist(@pdwn^.gadgetlist))+',d0','');
  addline(@procfunclist,'    tst.w   d0','See if done');
  addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'ObjectLoop','If not done repeat');  
  
end;

procedure thosewhichneedscaling(pdwn:pdesignerwindownode;spaces:string);
var
  pgn : pgadgetnode;
  pin : pimagenode;
  pmt : pmytag;
  loop : long;
  s,s2:string;
  s4 : string;
  s3 : string;
  pgn2:pgadgetnode;
  s6 : string;
  num : long;
  pit : pintuitext;
begin
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          loop:=0;
          pmt:=pmytag(pgn^.infolist.mlh_head);
          while(pmt^.ln_succ<>nil) do
            begin
              str(loop,s3);
              case pmt^.tagtype of
                tagtypefont :
                  begin
                    if pdwn^.codeoptions[17] then
                      begin
                        addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'Scr,a1','Get screen addr');
                        addline(@procfunclist,'    movea.l 40(a1),a0','Get font addr');
                        addline(@procfunclist,'    move.l  a0,'+no0(pgn^.labelid)+'Tag'+s3+'+4','Copy across');
                      end;
                    
                  end;
                tagtypeobject :
                  begin
                    str(loop,s);
                    if pmt^.data<>nil then
                      begin
                        pgn2:=pgadgetnode(pmt^.data);
                        if getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<getlistpos(@pdwn^.gadgetlist,pnode(pgn)) then
                          begin
                          end
                         else
                          dec(loop);
                      end
                     else
                      dec(loop);
                  end;
                
                tagtypescreen :
                  begin
                    addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'Scr,a0','Get screen addr');
                    addline(@procfunclist,'    move.l  a0,'+no0(pgn^.labelid)+'Tag'+s3+'+4','Copy across');
                  end;
                
                tagtypeuser2 :
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        ctopas(pmt^.data^,s6);
                        addline(@procfunclist,'    XREF    '+s6,'');
                        addline(@procfunclist,'    jsr     '+s6,'Call user function');
                        addline(@procfunclist,'    move.l  d0,'+no0(pgn^.labelid)+'Tag'+s3+'+4','CopyAcross');
                      end;
                  end;
                
                tagtypedrawinfo :
                  begin
                    addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'DrawInfo,a0','Get screen DrawInfo');
                    addline(@procfunclist,'    move.l  a0,'+no0(pgn^.labelid)+'Tag'+s3+'+4','Copy across');
                  end;
                
                tagtypevisualinfo :
                  begin
                    addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'VisualInfo,a0','Get screen VisualInfo');
                    addline(@procfunclist,'    move.l  a0,'+no0(pgn^.labelid)+'Tag'+s3+'+4','Copy across');
                  end;
                
                tagtypeimagedata :
                  begin
                    pin:=pimagenode(pmt^.data);
                    if pin<>nil then
                      begin
                         
                         addline(@procfunclist,'    lea     '+sfp(pin^.in_label)+',a0','Get Image');
                         addline(@procfunclist,'    movea.l 10(a0),a0','Get Image Data');
                         addline(@procfunclist,'    move.l  a0,'+no0(pgn^.labelid)+'Tag'+s3+'+4','Copy across');
                     
                      end;
                  end;
                
                tagtypeleftcoord,tagtypetopcoord,tagtypewidthcoord,tagtypeheightcoord :
                  begin
                    case pmt^.tagtype of
                      tagtypeleftcoord :
                        begin
                          str(pgn^.x,s2);
                          addline(@procfunclist,'    move.l  #'+s2+',d0','Get left coord');
                          if (pdwn^.codeoptions[17]) then
                            addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
                          addline(@procfunclist,'    add.w   '+no0(pdwn^.labelid)+'Offx,d0','');
                        end;
                      tagtypetopcoord :
                        begin
                          str(pgn^.y,s2);
                          addline(@procfunclist,'    move.l  #'+s2+',d0','Get Top Coord');
                          if (pdwn^.codeoptions[17]) then
                            addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
                          addline(@procfunclist,'    add.w   '+no0(pdwn^.labelid)+'Offy,d0','');
                        end;
                      tagtypewidthcoord :
                        begin
                          str(pgn^.w,s2);
                          addline(@procfunclist,'    move.l  #'+s2+',d0','Get width');
                          if (pgn^.tags[1].ti_data<>0)and(pdwn^.codeoptions[17]) then
                            addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
                        end;
                      tagtypeheightcoord :
                        begin
                          str(pgn^.h,s2);
                          addline(@procfunclist,'    move.l  #'+s2+',d0','Get height');
                          if (pgn^.tags[1].ti_data<>0)and(pdwn^.codeoptions[17]) then
                            addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
                        end;
                     end;
                    
                    addline(@procfunclist,'    move.l  d0,'+no0(pgn^.labelid)+'Tag'+s3+'+4','Copy across');
      
                  end;
                
                tagtypeintuitext :
                  begin
                    if (pmt^.sizebuffer>0) and (pdwn^.codeoptions[17]) then
                      begin
                        num:=1;
                        pit:=pintuitext(pmt^.data);
                        while(pit^.nexttext<>nil) do
                          begin
                            inc(num);
                            pit:=pit^.nexttext;
                          end;
                        
                        str(loop,s4);
                        str(num,s3);
                        
                        addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'Scr,a1','Get screen addr');
                        addline(@procfunclist,'    movea.l 40(a1),a0','Get font addr');
                        addline(@procfunclist,'    lea     '+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts,a1','Get itext addr');
                        addline(@procfunclist,'    adda.l  #8,a1','');
                        addline(@procfunclist,'    move.l  #'+fmtint(num)+',d0','');
                        addline(@procfunclist,no0(pgn^.labelid)+'Tag'+s4+'FontLoop:','');
                        
                        addline(@procfunclist,'    move.l  a0,(a1)','');
                        addline(@procfunclist,'    adda.l  #20,a1','');
                        addline(@procfunclist,'    sub.l   #1,d0','');
                        addline(@procfunclist,'    bne     '+no0(pgn^.labelid)+'Tag'+s4+'FontLoop','');
                        
                      end;
                  end;
               
               end;
              inc(loop);
              pmt:=pmt^.ln_succ;
            end;
        end;
      pgn:=pgn^.ln_succ;
    end;

end;  

procedure addfreeobjects(pdwn:pdesignerwindownode);
var
  pgn : pgadgetnode;
  pmt : pmytag;
  num : long;
begin
  addline(@procfunclist,'    movea.l _IntuitionBase,a6','Prepare for intuition call');
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          if pgn^.tags[4].ti_tag<>0 then
            begin
              {
              addline(@procfunclist,spaces+'if ('+no0(pdwn^.labelid)+
                              'Gadgets['+no0(pgn^.labelid)+'])','');
              addline(@procfunclist,spaces+'	DisposeObject( ( APTR ) '+
                        no0(pdwn^.labelid)+'Gadgets['+no0(pgn^.labelid)+'] );','');
              }          
              
              num:=4*(pgn^.id-pdwn^.nextid);
              addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'Gadgets,a1','Free Object : '+no0(pgn^.labelid));
              addline(@procfunclist,'    adda.l  #'+fmtint(num)+',a1','');
              addline(@procfunclist,'    movea.l (a1),a0','');
              addline(@procfunclist,'    move.l  #0,(a1)','');
              addline(@procfunclist,'    move.l  a0,d0','');
              addline(@procfunclist,'    tst.l   d0','');
              addline(@procfunclist,'    beq     No'+no0(pgn^.labelid)+'Object','');
              addline(@procfunclist,'    jsr     DisposeObject(a6)','');
              
              addline(@procfunclist,'No'+no0(pgn^.labelid)+'Object:','');
              
            end;
        end;
      pgn:=pgn^.ln_succ;
    end;
end;

function doobjects( pdwn:pdesignerwindownode ; pgn : pgadgetnode ; pos:long ):long;
var
  loop  : long;
  pmt,pmt2  : pmytag;
  s    : string;
  s2   : string;
  s3   : string;
  pin  : pimagenode;
  num : long;
  pgn2 : pgadgetnode;
  pl : plist;
  pn : pnode;
  s4 : string;
  loop2 : long;
  pit : pintuitext;
begin
  pgn^.prevobject:=nil;
  if pgn^.tags[3].ti_tag=0 then
    begin
      pgn^.prevobject:=lastobject;
      lastobject:=pgn;
    end;
  
  pgn^.tags[10].ti_tag:=pos;
  loop:=0;
          
          pmt:=pmytag(pgn^.infolist.mlh_head);
          while(pmt^.ln_succ<>nil) do
            begin
              str(loop,s);
              s2:='    dc.l    ';
              str(pmt^.value,s);
              if pmt^.value=-1 then
                s2:=s2+sfp(pmt^.mt_label)+', '
               else
                s2:=s2+s+', ';
              
              
              case pmt^.tagtype of
                
                tagtypeintuitext :
                  begin
                    if (pmt^.sizebuffer>0) then
                      begin
                        num:=1;
                        pit:=pintuitext(pmt^.data);
                        while(pit^.nexttext<>nil) do
                          begin
                            inc(num);
                            pit:=pit^.nexttext;
                          end;
                        
                        str(loop,s4);
                        str(num,s3);
                        
                        if pdwn^.localeoptions[1] then
                          begin
                            
                            addline(@procfunclist,'    lea     '+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts,a3','Get itext addr');
                            addline(@procfunclist,'    adda.l  #12,a3','');
                            addline(@procfunclist,'    move.l  #'+fmtint(num)+',d3','');
                            addline(@procfunclist,no0(pgn^.labelid)+'Tag'+s4+'TextLoop:','');
                            addline(@procfunclist,'    move.l  (a3),d0','');
                            
                            addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
                            
                            addline(@procfunclist,'    move.l  d0,(a3)','');
                            addline(@procfunclist,'    adda.l  #20,a3','');
                            addline(@procfunclist,'    sub.l   #1,d3','');
                            addline(@procfunclist,'    bne     '+no0(pgn^.labelid)+'Tag'+s4+'TextLoop','');
                            
                          end;
                        
                        s2:=s2+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts';
                        
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypestringlist : 
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        str(loop,s3);
                        s3:=no0(pgn^.labelid)+'Tag'+s3;
                        s2:=s2+s3+'List';
                        
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypeuser :
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        ctopas(pmt^.data^,s);
                        s2:=s2+s;
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypearraystring :
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        str(loop,s3);
                        
                        s2:=s2+no0(pgn^.labelid)+'Tag'+s3+'DataArray';
                        
                        {
                        if pdwn^.localeoptions[1] then
                          begin  
                            str(loop,s4);
                            pla:=plongarray(pmt^.data);
                            num:=0;
                            while(pla^[num]<>0) do
                              inc(num);
                            str(num,s3);
                          end;
                        }
                        
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypeobject :
                  begin
                    str(loop,s);
                    if pmt^.data<>nil then
                      begin
                        pgn2:=pgadgetnode(pmt^.data);
                        if getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<getlistpos(@pdwn^.gadgetlist,pnode(pgn)) then
                          begin
                            s2:=s2+'0';
                            pmt^.pos:=loop;
                            str(loop,s4);
                            addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+':','');
                          end
                         else
                          s2:='bad';
                      end
                     else
                      s2:='bad';
                  end;
                
                tagtypestring :
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        str(loop,s4);
                        ctopas(pmt^.data^,s);
                        if pdwn^.localeoptions[1] then
                          addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+':','');
                        if not pdwn^.localeoptions[1] then
                          s2:=s2+no0(pgn^.labelid)+'Tag'+s4+'DataString'
                         else
                          begin
                            localestring(s,no0(pgn^.labelid)+'Tag'+s4+'DataString',
                                         'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' Tag '+s4);
                            s2:=s2+'0';
                          end;
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypearraybyte,tagtypearraylong,tagtypearrayword :
                  begin
                    str(loop,s);
                    if pmt^.sizebuffer>0 then
                      s2:=s2+no0(pgn^.labelid)+'Tag'+s+'Data'
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypelong :
                  begin
                    str(long(pmt^.data),s);
                    s2:=s2+s;
                  end;
                
                tagtypeboolean :
                  begin
                    if long(pmt^.data)=0 then
                      s2:=s2+'0'
                     else
                      s2:=s2+'1';
                  end;

                tagtypeimage : 
                  begin
                    pin:=pimagenode(pmt^.data);
                    if pin<>nil then
                      s2:=s2+sfp(pin^.in_label)
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypeimagedata : 
                  begin
                    str(loop,s4);
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+':','');
                    s2:=s2+'0';
                  end;
                
                tagtypeheightcoord,tagtypewidthcoord,tagtypetopcoord,tagtypeleftcoord :
                  begin
                    s2:=s2+'0';
                    str(loop,s4);
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+':','');
                  end;
            
                tagtypefont :
                  begin
                    if pdwn^.codeoptions[17] then
                      begin
                        str(loop,s4);
                        addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+':','');
                        s:='0'
                      end
                     else
                      if pdwn^.codeoptions[6] then
                        s:=makemyfont(pdwn^.gadgetfont)
                       else
                        s:=makemyfont(pgn^.font);
                    s2:=s2+s;
                  end;
                
                tagtypegadgetid : 
                  begin
                    str(pgn^.id,s3);
                    s2:=s2+s3;
                  end;
                
                tagtypedrawinfo,tagtypevisualinfo,tagtypescreen,tagtypeuser2 : 
                  begin
                    str(loop,s4);
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+':','');
                    s2:=s2+'0';
                  end;


               end;
              if s2<>'bad' then
                begin
                  addline(@constlist,s2,no0(pgn^.labelid)+' Tag : '+sfp(pmt^.mt_label));
                end
               else
                begin
                  dec(loop);
                end;
              inc(loop);
              pmt:=pmt^.ln_succ;
            end;
          
          if pgn^.tags[3].ti_tag=0 then
            begin
              pgn^.prevtagpos:=loop;
              str(ga_previous,s);
              str(loop,s4);
              addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+':','');
              addline(@constlist,'    dc.l    '+s+',0','');
              inc(loop);
              
            end;
          
  doobjects:=pos+loop*2;
end;

procedure addmyobjectconstdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  pmt :pmytag;
  s : string;
  s2 : string;
  s3 : string;
  s4 : string;
  loop : long;
  l1,l2,l3 : long;
  pla : plongarray;
  pwa : pwordarray2;
  pba : pbytearray;
  s6 : string;
  num : long;
  pin : pimagenode;
  pgn2 : pgadgetnode;
  len : word;
  pb : pbyte;
  loop2 : word;
  pl:plist;
  pn:pnode;
  cow : long;
  pit : pintuitext;
  s5  : string;
  coun : long;
  mycount : word;
begin
  loop:=0;
  if pgn^.kind=myobject_kind then
    begin
      pmt:=pmytag(pgn^.infolist.mlh_head);
      while(pmt^.ln_succ<>nil) do
        begin
          case pmt^.tagtype of
            
            tagtypeintuitext :
              begin
                if pmt^.sizebuffer>0 then
                  begin
                    
                    pit:=pintuitext(pmt^.data);
                    
                    str(loop,s4);
                    addline(@constlist,'','');
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts:','');
                    
                    cow:=0;
                    while (pit<>nil) do
                      begin
                        
                        str(cow,s3);
                        addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'IntuiText'+s3+':','');
                    
                        
                        inc(cow);
                        str(pit^.FrontPen,s);
                        str(pit^.backpen,s3);
                        s:=s+', '+s3;
                        str(pit^.drawmode,s3);
                        s:=s+', '+s3;
                        addline(@constlist,'    dc.b    '+s+', 0','FrontPen, BackPen, DrawMode, Pad');
                        
                        
                        str(pit^.leftedge,s);
                        str(pit^.topedge,s3);
                        s:=s+', '+s3;
                        addline(@constlist,'    dc.w    '+s,'LeftEdge, TopEdge');
                        
                        
                        if pdwn^.codeoptions[17] then
                          s3:='0'
                         else
                          if pdwn^.codeoptions[6] then
                            s3:=makemyfont(pdwn^.gadgetfont)
                           else
                            s3:=makemyfont(pgn^.font);
                        
                        addline(@constlist,'    dc.l    '+s3,'ITextFont');
                        
                        str(cow-1,s3);
                        
                        if pdwn^.localeoptions[1] then
                          begin
                            ctopas(pit^.itext^,s5);
                            localestring(no0(s5),no0(pgn^.labelid)+'Tag'+s4+'String'+s3,'Window: '+
                                         no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                          end;
                      
                        addline(@constlist,'    dc.l    '+no0(pgn^.labelid)+'Tag'+s4+'String'+s3,'');
                        
                        str(cow,s3);
                        if pit^.nexttext<>nil then
                          s:=no0(pgn^.labelid)+'Tag'+s4+'IntuiText'+s3
                         else
                          s:='0';
                        addline(@constlist,'    dc.l    '+s,'');
                        
                        pit:=pit^.nexttext;
                      end;
                  
                    pit:=pintuitext(pmt^.data);
                    
                    if not pdwn^.localeoptions[1] then
                      addline(@constlist,'','');
                    
                    
                    cow:=0;
                    while (pit<>nil) do
                      begin
                        inc(cow);
                        if not pdwn^.localeoptions[1] then
                          begin
                            ctopas(pit^.itext^,s5);
                            str(cow-1,s3);
                            
                            addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'String'+s3+':','');
                            addline(@constlist,'    dc.b    '''+no0(s5)+''',0','');
                            
                          end;
                            
                        pit:=pit^.nexttext;
                      end;
                    
                    if not pdwn^.localeoptions[1] then
                      addline(@constlist,'    cnop    0,2','');
                  
                  end;
              end;
            
            tagtypestringlist :
              begin
                if pmt^.sizebuffer>0 then
                  begin
                    
                    str(loop,s4);
                    pl:=plist(pmt^.data);
                    
                    loop2:=0;
                    addline(@constlist,'','');
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'ListItems:','');
                    mycount:=0;
                    pn:=pnode(pl^.lh_head);
                    while (pn^.ln_succ<>nil) do
                      begin
                  
                        str(mycount,s3);
                          if pdwn^.localeoptions[1] then
                            begin
                              str(pn^.ln_name^,s6);
                              localestring(no0(s6),no0(pgn^.labelid)+'Tag'+s4+'String'+s3,'Window: '+
                                   no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                            end;
                  
                        s5:=no0(pgn^.labelid)+'Tag'+s4+'String'+s3;
                  
                        str(loop2,s2);
                        addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'ListItem'+s2+':','');
                  
                        if sizeoflist(pl)>1 then
                          if loop2=0 then
                            begin
                              str(loop2+1,s2);
                              s:=no0(pgn^.labelid)+'Tag'+s4+'ListItem'+s2+','
                                 +no0(pgn^.labelid)+'Tag'+s4+'ListHead';
                            end
                           else
                            if loop2=sizeoflist(pl)-1 then
                              begin
                                str(loop2-1,s2);
                                s:=no0(pgn^.labelid)+'Tag'+s4+'ListTail,'+no0(pgn^.labelid)+'Tag'+s4+'ListItem'+s2;
                              end
                             else
                              begin
                                str(loop2+1,s2);
                                s:=no0(pgn^.labelid)+'Tag'+s4+'ListItem'+s2+',';
                                str(loop2-1,s2);
                                s:=s+no0(pgn^.labelid)+'Tag'+s4+'ListItem'+s2+'';
                              end
                         else
                          s:=no0(pgn^.labelid)+'Tag'+s4+'ListTail,'+no0(pgn^.labelid)+'Tag'+s4+'ListHead';
                  
                        addline(@constlist,'    dc.l    '+s,'');
                        addline(@constlist,'    dc.b    0,0','');
                        addline(@constlist,'    dc.l    '+s5,'');
                  
                       inc(loop2);
                       inc(mycount);
                       pn:=pn^.ln_succ;
                     end;
              
                    mycount:=0;
                    addline(@constlist,'',''); 
                    pn:=pnode(pl^.lh_head);
                    if not pdwn^.localeoptions[1] then
                      begin
                        while (pn^.ln_succ<>nil) do
                          begin
                            str(mycount,s);
                      
                            addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'String'+s+':','');
                            ctopas(pn^.ln_name^,s5);
                            addline(@constlist,'    dc.b    '''+s5+''',0','');
                            inc(mycount);
                            pn:=pn^.ln_succ;
                          end;
                        addline(@constlist,'    cnop    0,2','');
                      end;

              
                    addline(@constlist,'','');
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'List:','');
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'ListHead:','');
                    str(sizeoflist(pl)-1,s2);
                    addline(@constlist,'    dc.l    '+no0(pgn^.labelid)+'Tag'+s4+'ListItem0','');
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'ListTail:','');
                    addline(@constlist,'    dc.l    0,'+no0(pgn^.labelid)+'Tag'+s4+'ListItem'+s2+'','');
                    
                    str(mycount,s);
              
                    if pdwn^.localeoptions[1] then
                      begin
                  
                        addline(@procfunclist,'    lea     '+no0(pgn^.labelid)+'Tag'+s4+'ListItems,a2','');
                   
                        addline(@procfunclist,'    move.l  #'+fmtint(sizeoflist(pl))+',d2','');
                        addline(@procfunclist,no0(pgn^.labelid)+'Tag'+s4+'Loop:','');
                        addline(@procfunclist,'    tst.l   d2','');
                        addline(@procfunclist,'    beq     '+no0(pgn^.labelid)+'Tag'+s4+'EndLoop','');
                
                        addline(@procfunclist,'    move.l  10(a2),d0','');
                        addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
                        addline(@procfunclist,'    move.l  d0,10(a2)','');
                
                        addline(@procfunclist,'    adda.l  #14,a2','');
                        addline(@procfunclist,'    sub.l   #1,d2','');
                        addline(@procfunclist,'    jmp     '+no0(pgn^.labelid)+'Tag'+s4+'Loop','');
                        addline(@procfunclist,no0(pgn^.labelid)+'Tag'+s4+'EndLoop:','');

                      end;
                    
                  end;
              end;
            
            tagtypearraystring :
              begin
                if pmt^.sizebuffer>0 then
                  begin
                    addline(@constlist,'','');
                    str(loop,s4);
                    
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'DataArray:','');
                        
                    mycount:=0;
                    pla:=plongarray(pmt^.data);
                    coun:=0;
                    while (pla^[coun]<>0) do
                      begin
                        pb:=pbyte(pla^[coun]);
                        ctopas(pb^,s5);
                        str(mycount,s3);
                        if pdwn^.localeoptions[1] then
                          begin
                            localestring(no0(s5),no0(pgn^.labelid)+
                                 'Tag'+s4+'String'+s3,'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                          end;
                        addline(@constlist,'    dc.l    '+no0(pgn^.labelid)+'Tag'+s4+'String'+s3,'');
                        inc(mycount);
                        inc(coun);
                      end;
                    addline(@constlist,'    dc.l    0',''); 
                    
                    if not pdwn^.localeoptions[1] then
                    
                    begin
                    
                    addline(@constlist,'','');
                    mycount:=0;
                    coun:=0;
                    while (pla^[coun]<>0) do
                      begin
                        pb:=pbyte(pla^[coun]);
                        ctopas(pb^,s5);
                        str(mycount,s3);
                        addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'String'+s3+':','');
                        addline(@constlist,'    dc.b    '''+no0(s5)+''',0','');
                        inc(mycount);
                        inc(coun);
                      end;
                    addline(@constlist,'    cnop    0,2',''); 
                    
                    
                    
                    end
                    else
                     begin
                       addline(@procfunclist,'    lea     '+no0(pgn^.labelid)+'Tag'+s4+'DataArray,a2','');
                       addline(@procfunclist,'    move.l  #'+fmtint(mycount)+',d2','');
                       addline(@procfunclist,no0(pgn^.labelid)+'Tag'+s4+'Loop:','');
                       addline(@procfunclist,'    tst.l   d2','');
                       addline(@procfunclist,'    beq     '+no0(pgn^.labelid)+'Tag'+s4+'EndLoop','');
                
                       addline(@procfunclist,'    move.l  (a2),d0','');
                       addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
                       addline(@procfunclist,'    move.l  d0,(a2)','');
                
                       addline(@procfunclist,'    adda.l  #4,a2','');
                       addline(@procfunclist,'    sub.l  #1,d2','');
                       addline(@procfunclist,'    jmp     '+no0(pgn^.labelid)+'Tag'+s4+'Loop','');
                       addline(@procfunclist,no0(pgn^.labelid)+'Tag'+s4+'EndLoop:','');

                     end;
                    
                  end;
              end;
            
            tagtypeobject :
              begin
                str(loop,s);
                if pmt^.data<>nil then
                  begin
                    pgn2:=pgadgetnode(pmt^.data);
                    if getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<getlistpos(@pdwn^.gadgetlist,pnode(pgn)) then
                      begin
                      end
                     else
                      dec(loop);
                  end
                 else
                  dec(loop);
                
              end;
            
            tagtypestring :
              begin
                if (pmt^.sizebuffer>0) then
                  begin
                    str(loop,s4);
                    ctopas(pmt^.data^,s5);
                    if not pdwn^.localeoptions[1] then
                      begin
                        addline(@constlist,'','');
                        addline(@constlist,no0(pgn^.labelid)+'Tag'+s4+'DataString:','');
                        addline(@constlist,'    dc.b    '''+s5+''',0','');
                        addline(@constlist,'    cnop    0,2','');
                      end
                     else
                      begin
                       addline(@procfunclist,'    lea     '+no0(pgn^.labelid)+'Tag'+s4+',a2','');
                       addline(@procfunclist,'    move.l  #'+no0(pgn^.labelid)+'Tag'+s4+'DataString,d0','');
                       addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
                       addline(@procfunclist,'    move.l  d0,4(a2)','');
                     end;
                  end;
              end;
            
            tagtypearraybyte,tagtypearraylong,tagtypearrayword :
              begin
                if pmt^.tagtype=tagtypearraylong then
                  s4:='    dc.l    '
                 else
                  if pmt^.tagtype=tagtypearrayword then
                    s4:='    dc.w    '
                   else
                    if pmt^.tagtype=tagtypearraybyte then
                      s4:='    dc.b    ';
                
                str(loop,s);
                if pmt^.sizebuffer>0 then
                  begin
                    if pmt^.tagtype=tagtypearraylong then
                      num:=pmt^.sizebuffer div 4
                     else
                      if pmt^.tagtype=tagtypearrayword then
                        num:=pmt^.sizebuffer div 2
                       else
                        if pmt^.tagtype=tagtypearraybyte then
                          num:=pmt^.sizebuffer;
                    
                    str(num-1,s3);
                    addline(@constlist,'','');
                    addline(@constlist,no0(pgn^.labelid)+'Tag'+s+'Data:','');
                    
                    l2:=0;
                    
                    pla:=plongarray(pmt^.data);
                    pwa:=pwordarray2(pmt^.data);
                    pba:=pbytearray(pmt^.data);
                    
                    for l1:=0 to ((num - 1) div 8) do
                      begin
                        s2:='';
                        for l3:=0 to 7 do
                          begin
                            if l2<num then
                              begin
                                if pmt^.tagtype=tagtypearraylong then
                                  str(pla^[l2],s3)
                                 else
                                  if pmt^.tagtype=tagtypearrayword then
                                    str(pwa^[l2],s3)
                                   else
                                    if pmt^.tagtype=tagtypearraybyte then
                                      str(pba^[l2],s3);
                                if (l3<7)and(l2<num-1) then
                                  s2:=s2+s3+','
                                 else
                                  s2:=s2+s3;
                              end;
                            inc(l2);
                          end;
                        addline(@constlist,s4+s2,'');
                      end;
                  end;
              end;

           end;
          inc(loop);
          pmt:=pmt^.ln_succ;
        end;
    end;

end;


procedure addgadgetimagerenders(pdwn:pdesignerwindownode;spaces:string);
var
  pgn : pgadgetnode;
  pmt : pmytag;
  num : long;
begin
  addline(@procfunclist,'    move.l  _IntuitionBase,a6','');
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          if pgn^.tags[3].ti_tag=1 then
            begin
              {
              addline(@procfunclist,spaces+'if ('+no0(pdwn^.labelid)+'Gadgets['+no0(pgn^.labelid)+
                               ' - '+no0(pdwn^.labelid)+'FirstID])','');
              addline(@procfunclist,spaces+'  DrawImageState('+no0(pdwn^.labelid)+'->RPort'+
                                    ', (APTR)'+no0(pdwn^.labelid)+'Gadgets['+no0(pgn^.labelid)+
                                    ' - '+no0(pdwn^.labelid)+'FirstID],'+
                                    ' 0, 0, 0, '+no0(pdwn^.labelid)+'DrawInfo);','');
              }
              
              num:=4*(pgn^.id-pdwn^.nextid);
              addline(@procfunclist,'    lea.l   '+no0(pdwn^.labelid)+'Gadgets,a0','');
              addline(@procfunclist,'    adda.l  #'+fmtint(num)+',a0','');
              addline(@procfunclist,'    movea.l (a0),a1','');
              addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+',a0','');
              addline(@procfunclist,'    movea.l 50(a0),a0','');
              addline(@procfunclist,'    move.l  #0,d0','');
              addline(@procfunclist,'    move.l  #0,d1','');
              addline(@procfunclist,'    move.l  #0,d2','');
              addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'DrawInfo,a2','');
              addline(@procfunclist,'    jsr     DrawImageState(a6)','');
              
            end;
        end;
      pgn:=pgn^.ln_succ;
    end;
end;

function getenoughtags(pdwn):string;
var
  pmt : pmytag;
  pgn : pgadgetnode;
  num : long;
  s : string[20];
begin
  num:=40;
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          if sizeoflist(@pgn^.infolist.mlh_head)+2>num then
            num:=sizeoflist(@pgn^.infolist.mlh_head)+2;
        end;
      pgn:=pgn^.ln_succ;
    end;
  str(num,s);
  getenoughtags:=s;
end;

end.