unit routines;

interface

uses utility,layers,gadtools,exec,intuition,dos,objectproduction,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench,producerwininterface;

procedure makemainfilelist;
function duplicate(n : word;c:char):string;
procedure freelist(pl:plist);
procedure gt_setsinglegadgetattr(gad:pgadget;win:pwindow;tag1,tag2:long);
function getnthnode(ph:plist;n:word):pnode;
procedure settagitem(pt :ptagitem;t,d:long);
procedure printstring(pwin:pwindow;x,y:word;s:string;n,m:byte;font:pointer);
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
function allocmymem(size:long;typ:long):pointer;
procedure printlisttoscreen(pl:plist);
procedure processimage(pin:pimagenode);
procedure writelisttofile(pl:plist;fl:bptr);
procedure processwindow(pdwn:pdesignerwindownode);
procedure processrendwindow(pdwn:pdesignerwindownode);
procedure addprocstripintuimessages;
procedure addprocclosewindowsafely;
procedure doopendiskfonts;
procedure dobitmapstuff;

implementation

procedure dogadgetloop(pdwn:pdesignerwindownode);
var
  first : boolean;
  pgn   : pgadgetnode;
  pin   : pimagenode;
  mycount : integer;
  count   : integer;
  num : long;
begin
  addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'GList','Zero GList');
  addline(@procfunclist,'    movea.l _GadToolsBase,a6','Prepare for GadTools call');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'GList,a0','Put GList in a0');
  addline(@procfunclist,'    jsr     CreateContext(a6)','Create context for gadtools gadget');
  addline(@procfunclist,'    movea.l d0,a2','Put return value in a2');
  addline(@procfunclist,'    tst.l   d0','See if got NULL return');
  addline(@procfunclist,'    beq     CannotCreate'+no0(pdwn^.labelid)+'Context','');

{ set up palette depths }

  first:=true;
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      if (pgn^.kind=palette_kind) and (pgn^.tags[1].ti_data=0) then
        begin
          if first then
            begin
              addline(@constlist,'','');
              addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'Depth',' Byte field');
              addline(@constlist,'    XDEF    '+no0(pdwn^.labelid)+'Depth','');
              addline(@constlist,no0(pdwn^.labelid)+'Depth:','');
              addline(@constlist,'    dc.b    0,0','');              
              addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+
                    'Scr,a0','Get Screen so can set up palette gadgets depth');
              addline(@procfunclist,'    move.b  189(a0),d0','Get screen depth place in d0');
              addline(@procfunclist,'    move.b  d0,'+no0(pdwn^.labelid)+'Depth','');
              first:=false;
            end;  
          addline(@procfunclist,'    move.b  d0,'+no0(pgn^.labelid)+'Depth+7','Put in tag array');
        end;
      pgn:=pgn^.ln_succ;
    end;

  thosewhichneedscaling(pdwn);

{end set up palette}
  if comment then
    begin
      addline(@procfunclist,'','d3 = current gad       a5 = current gad address');
      addline(@procfunclist,'','a4 = current gad tags  a3 = current gad kind');
      addline(@procfunclist,'','a2 = previous gad');
    end;
  
  addline(@procfunclist,'    move.l  #0,d3','Set to initial value');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'NGad,a5','Set to initial value');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'GTags,a4','Set to initial value');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'GTypes,a3','Set to initial value');
  addline(@procfunclist,no0(pdwn^.labelid)+'GadgetLoop:','');

{ skip objects }

  addline(@procfunclist,'    move.w  (a3),d0','');
  addline(@procfunclist,'    cmp.w   #198,d0','');
  addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'SkipOneGadget','Skip gadget if it is an object');
        
{ perform for this gadget }
      
  addline(@procfunclist,'    movea.l _SysBase,a6','Prepare for Exec call');
  addline(@procfunclist,'    movea.l a5,a0','Source in a0');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'BufNewGad,a1','Dest in a1');
  addline(@procfunclist,'    moveq   #30,d0','Size to copy');
  addline(@procfunclist,'    jsr     CopyMem(a6)','Got copy of NewGad');
{locale}
  
  if pdwn^.localeoptions[1] then
    begin
      addline(@procfunclist,'','');
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'BufNewGad+26,d0','Get String Number');
      addline(@procfunclist,'    cmp.l   #$FFFFFFFF,d0','');
      addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'SkipThisString','');
      addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'Get the localized string');
      addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'BufNewGad+8','Put String Back');
      addline(@procfunclist,no0(pdwn^.labelid)+'SkipThisString:','');
    end;
  addline(@procfunclist,'    move.l  #0,d0','Zero d0');
{VI}  
  
  addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'VisualInfo,'+no0(pdwn^.labelid)+'BufNewGad+22'
                        ,'Visual Info into newgad');
{Scale}
  if pdwn^.codeoptions[17] then
    begin
      addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'BufNewGad,d0','Get Left Edge');
      addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','Scale');
      addline(@procfunclist,'    move.w  d0,'+no0(pdwn^.labelid)+'BufNewGad','Store result');
      addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'BufNewGad+2,d0','Get Top Edge addr');
      addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','Scale');
      addline(@procfunclist,'    move.w  d0,'+no0(pdwn^.labelid)+'BufNewGad+2','Store result');
      addline(@procfunclist,'    move.w  (a3),d0','Check not Generic Kind');
      addline(@procfunclist,'    tst.w   d0','Test result');
      addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'DoNotScaleGeneric','Skip scale gadget size');
      addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'BufNewGad+4,d0','Get Width');
      addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','Scale');
      addline(@procfunclist,'    move.w  d0,'+no0(pdwn^.labelid)+'BufNewGad+4','Store result');
      addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'BufNewGad+6,d0','Get Height');
      addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','Scale');
      addline(@procfunclist,'    move.w  d0,'+no0(pdwn^.labelid)+'BufNewGad+6','Store result');
      addline(@procfunclist,no0(pdwn^.labelid)+'DoNotScaleGeneric:',''); 
{ set font = screen }
      if pdwn^.codeoptions[6] then
        begin
          addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'Scr,a1','Get screen addr');
          addline(@procfunclist,'    movea.l 40(a1),a0','Get font addr');
          addline(@procfunclist,'    move.l  a0,'+no0(pdwn^.labelid)+'BufNewGad+12','Copy across');
        end;
    end;
{offsets}
  addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'Offx,d0','get Offx');
  addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'BufNewGad,d1','get LeftEdge');
  addline(@procfunclist,'    add.w   d1,d0','Add offset');
  addline(@procfunclist,'    move.w  d0,'+no0(pdwn^.labelid)+'BufNewGad','Store new value');
  
  addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'Offy,d0','Get Offy');
  addline(@procfunclist,'    move.w  2+'+no0(pdwn^.labelid)+'BufNewGad,d1','Get TopEdge addr');
  addline(@procfunclist,'    add.w   d1,d0','Add offset');
  addline(@procfunclist,'    move.w  d0,'+no0(pdwn^.labelid)+'BufNewGad+2','Store new value');
{ special case stuff }
    
  { list and string linked }
  
  mycount:=0;
  
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if (pgn^.kind=listview_kind) and (pgn^.tags[3].ti_data<>0) then
        inc(mycount);
      pgn:=pgn^.ln_succ;
    end;   

  if mycount>0 then
    begin
      addline(@procfunclist,'    move.l  d3,d0','Get gad number in d0');
      if pdwn^.nextID<>0 then
        addline(@procfunclist,'    add.l   #'+fmtint(pdwn^.nextID)+',d0','Add Win_FirstID to d0 to get Gadget ID');
  
      pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
      while pgn^.ln_succ<>nil do
        begin
          if (pgn^.kind=listview_kind) and (pgn^.tags[3].ti_data<>0) then
            begin
              addline(@procfunclist,'    cmp.l   #'+fmtint(pgn^.id)+',d0','Compare with a Gadget');
              addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'NotGad'+fmtint(pgn^.id),'If not this gad then skip');
              addline(@procfunclist,'    move.l  a2,'+no0(pgn^.labelid)+'ShowSelected+4',
                  'Copy address of previous string Gad into tag array so listview is linked');
              addline(@procfunclist,no0(pdwn^.labelid)+'NotGad'+fmtint(pgn^.id)+':','');       
            end;
          pgn:=pgn^.ln_succ;
        end;
    end;
  
  addline(@procfunclist,'    move.l  #0,d0','To make next word operations safe');
   
{ make gad }
  addline(@procfunclist,'    movea.l _GadToolsBase,a6','Prepare for GadTools call');
  addline(@procfunclist,'    movea.l a2,a0','Put previous in a0');
  addline(@procfunclist,'    move.w  (a3),d0','');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'BufNewGad,a1','NewGad in a1');
  addline(@procfunclist,'    movea.l a4,a2','');
  addline(@procfunclist,'    jsr     CreateGadgetA(a6)','Create Gadget');
  addline(@procfunclist,'    movea.l d0,a2','Store result');
  addline(@procfunclist,'    tst.l   d0','test result');
  if pdwn^.codeoptions[5] then
    addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'BadGadgets','Create failed, fail open window')
   else
    addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'OpenBadGad','Create failed, still open window');
  
  if pdwn^.codeoptions[10] then
    begin
      addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'Gadgets','');
      addline(@constlist,'','');
      addline(@constlist,'    XDEF    '+no0(pdwn^.labelid)+'Gadgets','');
      addline(@constlist,no0(pdwn^.labelid)+'Gadgets:','');
      addline(@constlist,'    ds.l    '+fmtint(sizeoflist(@pdwn^.gadgetlist)),'');
      
      addline(@procfunclist,'    lea    '+no0(pdwn^.labelid)+'Gadgets,a0','Get gadget array address');
      addline(@procfunclist,'    move.l  d3,d0','Get gadget number');
      addline(@procfunclist,'    mulu    #4,d0','Get offset in array');
      addline(@procfunclist,'    adda.l  d0,a0','Get address of position in array');
      addline(@procfunclist,'    move.l  a2,(a0)','Store address');
   end;

{ more special case stuff}

            
      count:=0;
      
      pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
      while(pgn<>nil) do
        begin
          if pgn^.kind=mybool_kind then
            inc(count);
          if (pgn^.kind=string_kind)and boolean(pgn^.tags[9].ti_data) then
            inc(count);
          if (pgn^.kind=integer_kind)and boolean(pgn^.tags[9].ti_data) then
            inc(count);
          pgn:=pgn^.ln_succ;
        end;
      
      if count>0 then
        begin
          pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
          while(pgn<>nil) do
            begin
               if ((pgn^.kind=string_kind) or (pgn^.kind=integer_kind))
                  and boolean(pgn^.tags[9].ti_data) then
                 begin
                    addline(@procfunclist,'    cmp.w   #'+fmtint(pgn^.id)+',d3','');
                    addline(@procfunclist,'    bne     '+no0(pgn^.labelid)+'SkipThisGad','');

                    {
                    addline(@procfunclist,'case '+no0(pgn^.labelid)+' :','');
                    addline(@procfunclist,'if (GadToolsBase->lib_Version==37)','');
                    addline(@procfunclist,'Gad->Activation |= GACT_IMMEDIATE;','');
                    addline(@procfunclist,'break;','');
                    }
                    addline(@procfunclist,'    move.l  _GadToolsBase,a1','Get lib address');
                    addline(@procfunclist,'    move.w  20(a1),d1','Get lib version');
                    addline(@procfunclist,'    cmp.w   #37,d1','If 37 set GACT_Immediate flag in Gadget->Activation');
                    
                    addline(@procfunclist,'    bne     '+no0(pgn^.labelid)+'SkipThisGad','Not V37');
                    addline(@procfunclist,'    move.w  14(a2),d1','Get Activation');
                    addline(@procfunclist,'    ori.w   #2,d1','Set bit');
                    addline(@procfunclist,'    move.w  d1,14(a2)','Put back');
                    addline(@procfunclist,no0(pgn^.labelid)+'SkipThisGad:','End flag set');


                 end;
              if pgn^.kind=mybool_kind then
                begin
                  addline(@procfunclist,'    cmp.w   #'+fmtint(pgn^.id)+',d3','');
                  addline(@procfunclist,'    bne     '+no0(pgn^.labelid)+'SkipThisGad','');
                  addline(@procfunclist,'    move.w  16(a2),d1','Get GadgetType field');
                  addline(@procfunclist,'    ori.w   #1,d1','Set GTYP_BOOLGADGET');
                  addline(@procfunclist,'    move.w  d1,16(a2)','Put back');
                  
                  {
                  addline(@procfunclist,spaces+'			Gad->GadgetType |= GTYP_BOOLGADGET;','');
                  pin:=pimagenode(pgn^.pointers[1]);
                  }
                  
                  if pdwn^.codeoptions[17] and boolean(pgn^.tags[1].ti_data) then
                    begin
                      {
                      addline(@procfunclist,spaces+'			'+no0(pgn^.labelid)+'IText.ITextFont = Scr->Font;','');
                      }
                      addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'Scr,a1','Get screen addr');
                      addline(@procfunclist,'    movea.l 40(a1),a0','Get font addr');
                      addline(@procfunclist,'    move.l  a0,'+no0(pgn^.labelid)+'IText+8','Copy across');
     
                    end;
                  
                  pin:=pimagenode(pgn^.pointers[1]);
                  
                  if boolean(pgn^.tags[1].ti_data) then
                    begin
                      
                      if pdwn^.localeoptions[1] then
                        begin
                          {
                          addline(@procfunclist,spaces+'			'+no0(pgn^.labelid)+'IText.IText = '+sfp(producernode^.getstring)+
                            '('+no0(pgn^.labelid)+'String);','');
                          }
                          addline(@procfunclist,'    move.l  #'+no0(pgn^.labelid)+'String,d0','Get string ID');
                          addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'Get string');
                          addline(@procfunclist,'    move.l  d0,'+no0(pgn^.labelid)+'IText+12','Put string in IText');
                        end;
                      
                      {
                      addline(@procfunclist,spaces+'			Gad->GadgetText = &'+no0(pgn^.labelid)+'IText;','')
                      }
                      
                      addline(@procfunclist,'    lea     '+no0(pgn^.labelid)+'IText,a0','');
                      addline(@procfunclist,'    move.l  a0,26(a2)','Set gadget text to IntuiText');
                    end;
                  
                  if pin<>nil then
                    begin
                      {
                      addline(@procfunclist,spaces+'			Gad->GadgetRender = &'+no0(pin^.title)+';','');
                      }
                      addline(@procfunclist,'    lea     '+sfp(pin^.in_label)+',a0','');
                      addline(@procfunclist,'    move.l  a0,18(a2)','Set GadgetRender');
                   
                    end;
                  pin:=pimagenode(pgn^.pointers[2]);
                  if pin<>nil then
                    begin
                      {
                      addline(@procfunclist,spaces+'			Gad->SelectRender = &'+no0(pin^.title)+';','');
                      }
                      addline(@procfunclist,'    lea     '+sfp(pin^.in_label)+',a0','');
                      addline(@procfunclist,'    move.l  a0,22(a2)','Set SelectRender');
                    end;
                  num:=0;
                  if (pgn^.tags[1].ti_tag and gact_toggleselect)<>0 then
                    num:=GACT_TOGGLESELECT;
                  if (pgn^.tags[1].ti_tag and gact_immediate)<>0 then
                    num:=num or GACT_IMMEDIATE;
                  if (pgn^.tags[1].ti_tag and gact_relverify)<>0 then
                    num:=num or GACT_RELVERIFY;
                  if (pgn^.tags[1].ti_tag and gact_followmouse)<>0 then
                    num:=num or GACT_FOLLOWMOUSE;
                  if num<>0 then
                    begin
                      {
                      addline(@procfunclist,spaces+'			Gad->Activation = '+s+';','');
                      }
                      addline(@procfunclist,'    move.w  14(a2),d1','Get Activation field');
                      addline(@procfunclist,'    ori.w   #'+fmtint(num)+',d1','Set bits');
                      addline(@procfunclist,'    move.w  d1,14(a2)','Put back');
                  

                    end;
                  pgn^.flags:=pgn^.flags or gflg_gadgimage;
                  {
                  addline(@procfunclist,spaces+'			Gad->Flags = '+s+';','');
                  addline(@procfunclist,spaces+'			break;','');
                  }
                  addline(@procfunclist,'    move.w  #'+fmtint(pgn^.flags)+',12(a2)','Set gadget flags');
                  
                  addline(@procfunclist,no0(pgn^.labelid)+'SkipThisGad:','End flag set');
                end;
              pgn:=pgn^.ln_succ;
            end;
        end;
        
{ end special case stuff }

{ Prepare for next loop }
  
  addline(@procfunclist,no0(pdwn^.labelid)+'SkipOneGadget:','Skip gadget if it is an object');
  
  addline(@procfunclist,'    add.w   #1,d3','Set for next NewGad');
  addline(@procfunclist,'    adda    #30,a5','Move to next NewGad');
  addline(@procfunclist,'    adda    #2,a3','Move to next Gad kind');
  
  addline(@procfunclist,'    jmp     '+no0(pdwn^.labelid)+'NextTag2','Get next tag array');
  addline(@procfunclist,no0(pdwn^.labelid)+'NextTag1:','Get next tag array');
  addline(@procfunclist,'    adda    #8,a4','Get next tag array');
  addline(@procfunclist,no0(pdwn^.labelid)+'NextTag2:','Get next tag array');
  addline(@procfunclist,'    move.l  (a4),d0','Get next tag array');
  addline(@procfunclist,'    tst.l   d0','Get next tag array');
  addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'NextTag1','Get next tag array');
  addline(@procfunclist,'    adda    #4,a4','Get next tag array');
  
  addline(@procfunclist,'    move.w  d3,d0','Put number of gadget in d0');
  addline(@procfunclist,'    sub.w   #'+fmtint(sizeoflist(@pdwn^.gadgetlist))+',d0','');
  addline(@procfunclist,'    tst.w   d0','See if done');
  addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'GadgetLoop','If not done repeat');
      
  addcreateobjectcode(pdwn);
  
end;

procedure doopendiskfonts;
var
  psn : pstringnode;
begin
  psn:=pstringnode(opendiskfontlist.lh_head);
  
  if producernode^.codeoptions[4] then
    addline(@procfunclist,'    XREF    _DiskFontBase','');
  
  addline(@externlist,'    XREF    OpenDiskFonts','');
  addline(@procfunclist,'    XDEF    OpenDiskFonts','');
  
  addline(@procfunclist,'OpenDiskFonts:','');
  
  addline(@procfunclist,'    movem.l d0/a0/a6,-(sp)','');
      
  while (psn^.ln_succ<>nil) do
    begin
      
      addline(@procfunclist,'    lea     '+no0(psn^.st)+',a0','');
      addline(@procfunclist,'    movea.l _DiskfontBase,a6','');
      addline(@procfunclist,'    jsr     OpenDiskFont(a6)','');
      
      psn:=psn^.ln_succ;
    end;
  addline(@procfunclist,'    movem.l (sp)+,d0/a0/a6','');
  addline(@procfunclist,'    rts','');
      
end;

function replicate(c:char;n:byte) : string;
var 
  s : string;
begin
  s:='';
  while (n>0) do
    begin
      dec(n);
      s:=s+c;
    end;
  replicate:=s;
end;

procedure processrendwindow(pdwn:pdesignerwindownode);
var
  visinfo  : string;
  psin     : psmallimagenode;
  s        : string;
  s2       : string;
  pbbn     : pbevelboxnode;
  ptn      : ptextnode;
  font     : ttextattr;
  fontname : string;
  loop     : long;
  loop6    : long;
  type45   : boolean;
  num      : long;
begin
  type45:=false;
  pbbn:=pbevelboxnode(pdwn^.bevelboxlist.mlh_head);
  while(pbbn^.ln_succ<>nil) do
    begin
      if (pbbn^.beveltype=4) or (pbbn^.beveltype=5) then
        type45:=true;
      pbbn:=pbbn^.ln_succ;
    end;
  
  loop:=sizeoflist(@pdwn^.textlist);
  loop6:=sizeoflist(@pdwn^.imagelist);
  if sizeoflist(@pdwn^.imagelist) + 
     sizeoflist(@pdwn^.bevelboxlist)+
     loop+
     sizeoflist(@pdwn^.gadgetlist)>0 then
  
    begin
      visinfo:='vi';
      
      addline(@procfunclist,'','');
      addline(@procfunclist,'    XDEF    Rend'+no0(pdwn^.labelid)+'Window','');
      addline(@externlist,'    XREF    Rend'+no0(pdwn^.labelid)+'Window','No Parameters');
      
      addline(@procfunclist,'Rend'+(no0(pdwn^.labelid))+'Window:','');
      addline(@procfunclist,'    movem.l d0-d4/a0-a4/a6,-(sp)','Store registers');
  
      addgadgetimagerenders(pdwn);
      
      loop:=0;
      ptn:=ptextnode(pdwn^.textlist.mlh_head);
      while (ptn^.ln_succ<>nil) do
        begin
            inc(loop);
          ptn:=ptn^.ln_succ;
        end;
      
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',d0','');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'WindowUnOpened','');
      
      addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+',a0','');
      addline(@procfunclist,'    movea.l 50(a0),a4','');
          
      if loop6>0 then
        addline(@procfunclist,'    movea.l _IntuitionBase,a6','');
      
      psin:=psmallimagenode(pdwn^.imagelist.mlh_head);
      while(psin^.ln_succ<>nil) do
        begin
          if true then
            begin
              
              addline(@procfunclist,'    move.l  #'+fmtint(psin^.y)+',d0','');
              if pdwn^.codeoptions[17] then
                addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
              addline(@procfunclist,'    add.w   '+no0(pdwn^.labelid)+'Offy,d0','');
              addline(@procfunclist,'    move.l  d0,d1','');
              addline(@procfunclist,'    move.l  #'+fmtint(psin^.x)+',d0','');
              if pdwn^.codeoptions[17] then
                addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
              addline(@procfunclist,'    add.w   '+no0(pdwn^.labelid)+'Offx,d0','');
              addline(@procfunclist,'    lea     '+sfp(psin^.pin^.in_label)+',a1','');
              addline(@procfunclist,'    movea.l a4,a0','');
              addline(@procfunclist,'    jsr     DrawImage(a6)','');
              
            end;
          psin:=psin^.ln_succ;
        end;
      if (not beveltags) and(sizeoflist(@pdwn^.bevelboxlist)>0) then
        begin
          beveltags:=true;
          addline(@constlist,'','');
          addline(@constlist,'BevelTags:','');
          addline(@constlist,'    dc.l    $80080033,1','GTBB_Recessed,True');
          addline(@constlist,'    dc.l    $80080034,0','GT_VisualInfo');
          if type45 then
            begin
              addline(@constlist,'    dc.l    0','TAG_DONE');
              addline(@constlist,'    dc.l    $8008004D,2','GTBB_FrameType');
              addline(@constlist,'    dc.l    $80080034,0','GT_VisualInfo');
            end;
          addline(@constlist,'    dc.l    0','TAG_DONE');
        end;
      pbbn:=pbevelboxnode(pdwn^.bevelboxlist.mlh_head);
      if sizeoflist(@pdwn^.bevelboxlist)>0 then
        begin
          addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'VisualInfo,BevelTags+12','');
          if type45 then
            addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'VisualInfo,BevelTags+32','');
          
          addline(@procfunclist,'    move.l  _GadToolsBase,a6','');
        end;
      while(pbbn^.ln_succ<>nil) do
        begin
          
          addline(@procfunclist,'    move.l  #'+fmtint(pbbn^.h)+',d0','Bevel height');
          if pdwn^.codeoptions[17] then
            addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
          addline(@procfunclist,'    move.l  d0,d3','');
          
          addline(@procfunclist,'    move.l  #'+fmtint(pbbn^.w)+',d0','Bevel width');
          if pdwn^.codeoptions[17] then
            addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
          addline(@procfunclist,'    move.l  d0,d2','');
          
          addline(@procfunclist,'    move.l  #'+fmtint(pbbn^.y)+',d0','Bevel top');
          if pdwn^.codeoptions[17] then
            addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
          addline(@procfunclist,'    add.w   '+no0(pdwn^.labelid)+'Offy,d0','');
          addline(@procfunclist,'    move.l  d0,d1','');
          
          addline(@procfunclist,'    move.l  #'+fmtint(pbbn^.x)+',d0','Bevel bottom');
          if pdwn^.codeoptions[17] then
            addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
          addline(@procfunclist,'    add.w   '+no0(pdwn^.labelid)+'Offx,d0','');
          
          addline(@procfunclist,'    move.l  a4,a0','Put RPort in a0');
          
          addline(@procfunclist,'    lea     BevelTags,a1','');
          
          case pbbn^.beveltype of
            0 :  addline(@procfunclist,'    adda.l  #8,a1','');
            4 :  begin
                   addline(@procfunclist,'    adda.l  #20,a1','');
                   addline(@procfunclist,'    move.l  #2,BevelTags+24','');
                 end;
            5 :  begin
                   addline(@procfunclist,'    adda.l  #20,a1','');
                   addline(@procfunclist,'    move.l  #3,BevelTags+24','');
                 end;
            2,3 : 
                 begin
                  if pbbn^.beveltype=2 then
                    addline(@procfunclist,'    adda.l  #8,a1','');
                  addline(@procfunclist,'    jsr     DrawBevelBoxA(a6)','Call DrawBevelBoxA');
                  
                  addline(@procfunclist,'    move.l  #'+fmtint(pbbn^.h-4)+',d0','Bevel height');
                  if pdwn^.codeoptions[17] then
                    addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
                  addline(@procfunclist,'    move.l  d0,d3','');
                  
                  addline(@procfunclist,'    move.l  #'+fmtint(pbbn^.w-8)+',d0','Bevel width');
                  if pdwn^.codeoptions[17] then
                    addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
                  addline(@procfunclist,'    move.l  d0,d2','');
                  
                  addline(@procfunclist,'    move.l  #'+fmtint(pbbn^.y+2)+',d0','Bevel top');
                  if pdwn^.codeoptions[17] then
                    addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
                  addline(@procfunclist,'    add.w   '+no0(pdwn^.labelid)+'Offy,d0','');
                  addline(@procfunclist,'    move.l  d0,d1','');
                  
                  addline(@procfunclist,'    move.l  #'+fmtint(pbbn^.x+4)+',d0','Bevel bottom');
                  if pdwn^.codeoptions[17] then
                    addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
                  addline(@procfunclist,'    add.w   '+no0(pdwn^.labelid)+'Offx,d0','');
                  
                  addline(@procfunclist,'    movea.l a4,a0','Put RPort in a0');
          
                  addline(@procfunclist,'    lea     BevelTags,a1','');
          
                  if pbbn^.beveltype=3 then
                    addline(@procfunclist,'    adda.l  #8,a1','');
                end;
           end;
          
          addline(@procfunclist,'    jsr     DrawBevelBoxA(a6)','Call DrawBevelBoxA');
          
          pbbn:=pbbn^.ln_succ;
        end;
      
      
      loop:=0;
      ptn:=ptextnode(pdwn^.textlist.mlh_head);
      while (ptn^.ln_succ<>nil) do
        begin
            inc(loop);
          ptn:=ptn^.ln_succ;
        end;
      if (loop>0) then
        begin
          
          addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'Texts,a3','');
          addline(@procfunclist,'    move.l  #'+fmtint(loop)+',d3','');
          addline(@procfunclist,no0(pdwn^.labelid)+'RendLoop:','');
          
          
          if pdwn^.localeoptions[2] or pdwn^.codeoptions[17] then
            begin
              addline(@constlist,'','');
              addline(@constlist,'Rend'+no0(pdwn^.labelid)+'FirstRun','');
              addline(@constlist,'    dc.l    1','');

              
              addline(@procfunclist,'    move.l  Rend'+no0(pdwn^.labelid)+'FirstRun,d0','');
              addline(@procfunclist,'    tst.l  d0','');
              addline(@procfunclist,'    beq    Rend'+no0(pdwn^.labelid)+'RunBefore','');
            end;

          
          str(sizeoflist(@pdwn^.textlist),s);
          
          {
          addline(@procfunclist,'		if ('+(no0(pdwn^.labelid))+'Texts[loop].ITextFont==NULL)','');
          addline(@procfunclist,'			'+(no0(pdwn^.labelid))+'Texts[loop].ITextFont='+
                                         'Win->WScreen->Font;','');
          }
          
          addline(@procfunclist,'    move.l  8(a3),d0','');
          addline(@procfunclist,'    tst.l   d0','');
          addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'NotScreenFont','');
          addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Scr,a1','');
          addline(@procfunclist,'    move.l  40(a1),8(a3)','');
          
          addline(@procfunclist,no0(pdwn^.labelid)+'NotScreenFont:','');
          
          
          if pdwn^.localeoptions[2] then
            begin
              {
              addline(@procfunclist,'		for( loop=0; loop<'+s+'; loop++)','');
              addline(@procfunclist,'			'+(no0(pdwn^.labelid))+'Texts[loop].IText = '
                                             +sfp(producernode^.getstring)+'((LONG)'+(no0(pdwn^.labelid))+
                                                'Texts[loop].IText);','');
              }
              addline(@procfunclist,'    move.l  12(a3),d0','');
              addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
              addline(@procfunclist,'    move.l  d0,12(a3)','');
            end;

          
          if pdwn^.codeoptions[17] then
            begin
              
              {
              addline(@procfunclist,'			'+(no0(pdwn^.labelid))+'Texts[loop].LeftEdge = '
                  +(no0(pdwn^.labelid))+'Texts[loop].LeftEdge*scalex/65535;','');
              addline(@procfunclist,'			'+(no0(pdwn^.labelid))+'Texts[loop].TopEdge = '
                  +(no0(pdwn^.labelid))+'Texts[loop].TopEdge*scaley/65535;','');
              }
              addline(@procfunclist,'    move.w  4(a3),d0','');
              addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
              addline(@procfunclist,'    move.w  d0,4(a3)','');
              addline(@procfunclist,'    move.w  6(a3),d0','');
              addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
              addline(@procfunclist,'    move.w  d0,6(a3)','');
          
            end;
          
          if pdwn^.localeoptions[2] or pdwn^.codeoptions[17] then
            begin
              addline(@procfunclist,'Rend'+no0(pdwn^.labelid)+'RunBefore:','');
            end;
            
                        
          
          addline(@procfunclist,'    adda.l  #20,a3','');
          addline(@procfunclist,'    sub.l   #1,d3','');
          addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'RendLoop','');
          
          if pdwn^.localeoptions[2] or pdwn^.codeoptions[17] then
            addline(@procfunclist,'    move.l  #0,Rend'+no0(pdwn^.labelid)+'FirstRun','');
            

          
          addline(@procfunclist,'    movea.l a4,a0','RPort in a0');
          addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'Texts,a1','');
          addline(@procfunclist,'    move.l  #0,d0','');
          addline(@procfunclist,'    move.l  #0,d1','');
          addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'Offx,d0','');
          addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'Offy,d1','');
          addline(@procfunclist,'    movea.l _IntuitionBase,a6','');
          addline(@procfunclist,'    jsr     PrintIText(a6)','');
          
          {
          addline(@procfunclist,'	PrintIText( Win'+
                             '->RPort, '+(no0(pdwn^.labelid))+'Texts, offx, offy);','');
          }
          
          addline(@constlist,'','');
          
          addline(@constlist,(no0(pdwn^.labelid))+'Texts:','');
          
        end;
      loop6:=0;
      ptn:=ptextnode(pdwn^.textlist.mlh_head);
      while (ptn^.ln_succ<>nil) do
        begin
          if true then
            begin
              addline(@constlist,(no0(pdwn^.labelid))+'Text'+fmtint(loop6)+':','');
              addline(@constlist,'    dc.b    '+fmtint(ptn^.frontpen)+','+fmtint(ptn^.backpen),'FrontPen,BackPen');
              num:=0;
              if (ptn^.drawmode and INVERSVID)=INVERSVID then
                num:=INVERSVID;
              case (ptn^.drawmode-(ptn^.drawmode and inversvid)) of
                jam1 : num:=num or JAM1;
                jam2 : num:=num or JAM2;
                complement : num:=num or COMPLEMENT;
               end;
              addline(@constlist,'    dc.b    '+fmtint(num)+',0','DrawMode');
              addline(@constlist,'    dc.w    '+fmtint(ptn^.x)+','+fmtint(ptn^.y),'LeftEdge,TopEdge');
              
              if ptn^.screenfont then
                s:='0'
               else
                s:=makemyfont(ptn^.ta);
              
              addline(@constlist,'    dc.l    '+s,'TextAttr');
              
              addline(@constlist,'    dc.l    '+no0(pdwn^.labelid)+'TextData'+fmtint(loop6),'');
             
              if pdwn^.localeoptions[2] then
                begin
                  localestring(sfp(ptn^.tn_title),no0(pdwn^.labelid)+
                      'TextData'+fmtint(loop6),'Window: '+no0(pdwn^.title)+' Text: '+sfp(ptn^.tn_title));
                end;
              
              inc(loop6);
              
              if loop6=loop then
                s:='0'
               else
                s:=(no0(pdwn^.labelid))+'Text'+fmtint(loop6);
              
              addline(@constlist,'    dc.l    '+s,'');
              
            end;
          ptn:=ptn^.ln_succ;
        end;
      
      loop6:=0;
      if not pdwn^.localeoptions[2] then
        begin
          ptn:=ptextnode(pdwn^.textlist.mlh_head);
          while (ptn^.ln_succ<>nil) do
            begin
              if true then
                begin
                  addline(@constlist,no0(pdwn^.labelid)+'TextData'+fmtint(loop6)+':','');
                  addline(@constlist,'    dc.b    '''+sfp(ptn^.tn_title)+''',0','');
                  inc(loop6);
                end;
              ptn:=ptn^.ln_succ;
            end;
          addline(@constlist,'    cnop    0,2','');
        end;
        
        
      addline(@procfunclist,no0(pdwn^.labelid)+'WindowUnOpened:','');
      addline(@procfunclist,'    movem.l (sp)+,d0-d4/a0-a4/a6','Restore registers');
      addline(@procfunclist,'    rts','');
    end;
end;

procedure processclosewindow(pdwn:pdesignerwindownode);
var
  s,s2 : string;
begin
  addline(@procfunclist,'','');
  
  addline(@externlist,'    XREF    Close'+(no0(pdwn^.labelid))+'Window','');
  addline(@procfunclist,'    XDEF    Close'+(no0(pdwn^.labelid))+'Window','');
  addline(@procfunclist,'Close'+(no0(pdwn^.labelid))+'Window:','');
  addline(@procfunclist,'    movem.l d0-d2/a0-a6,-(sp)','Store Registers');
  
  
  addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',d1','See if window open');
  addline(@procfunclist,'    tst.l   d1','');
  addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'NotOpen','');
   
  addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'DrawInfo,d1','');
  addline(@procfunclist,'    tst.l   d1','');
  addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'NoSDI','');
  addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+',a0','');
  addline(@procfunclist,'    movea.l 46(a0),a0','Get Screen');
  addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'DrawInfo,a1','');
  addline(@procfunclist,'    move.l  _IntuitionBase,a6','');
  addline(@procfunclist,'    jsr     FreeScreenDrawInfo(a6)','');
  addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'DrawInfo','');
  
  addline(@procfunclist,no0(pdwn^.labelid)+'NoSDI:','');
  
  
  if pdwn^.codeoptions[11] then
    begin
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',a0','ClearMenuStrip');
      addline(@procfunclist,'    move.l  _IntuitionBase,a6','');
      addline(@procfunclist,'    jsr     ClearMenuStrip(a6)','');
      
      if pdwn^.codeoptions[14] then
        begin
          addline(@procfunclist,'    move.l  '+no0(pdwn^.menutitle)+',a0','');
          addline(@procfunclist,'    move.l  _GadToolsBase,a6','');
          addline(@procfunclist,'    jsr     FreeMenus(a6)','');
          
          addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.menutitle),'');
  
        end;
    end;

  if pdwn^.codeoptions[18] then
    begin
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'AppWin,d0','');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'NotAppWin','');
      addline(@procfunclist,'    movea.l d0,a0','');
      addline(@procfunclist,'    movea.l _WorkbenchBase,a6','');
      addline(@procfunclist,'    jsr     RemoveAppWindow(a6)','');
      addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'AppWin','');
      addline(@procfunclist,no0(pdwn^.labelid)+'NotAppWin:','');
    end;
  
  
  if pdwn^.codeoptions[8] then
    begin
      
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',a0','');
      addline(@procfunclist,'    jsr     CloseWindowSafely','');
      addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid),'');
      
      sharedwindow:=true;
    end
   else 
    begin
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',a0','');
      addline(@procfunclist,'    move.l  _IntuitionBase,a6','');
      addline(@procfunclist,'    jsr     CloseWindow(a6)','');
      addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid),'');
    end;
  
  addline(@procfunclist,no0(pdwn^.labelid)+'NotOpen:','');
    
  addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'VisualInfo,d1','');
  addline(@procfunclist,'    tst.l   d1','');
  addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'NoCVI','');
  addline(@procfunclist,'    move.l  d1,a0','');
  addline(@procfunclist,'    move.l  _GadToolsBase,a6','');
  addline(@procfunclist,'    jsr     FreeVisualInfo(a6)','');
  addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'VisualInfo','');
  
  addline(@procfunclist,no0(pdwn^.labelid)+'NoCVI:','');
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'GList,d1','');
      addline(@procfunclist,'    tst.l   d1','');
      addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'NoCGList','');
      addline(@procfunclist,'    move.l  d1,a0','');
      addline(@procfunclist,'    move.l  _GadToolsBase,a6','');
      addline(@procfunclist,'    jsr     FreeGadgets(a6)','');
      addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'GList','');
      
      addline(@procfunclist,no0(pdwn^.labelid)+'NoCGList:','');
      
      addfreeobjects(pdwn);
      
    end;
  
  
  
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'BitMap,d1','');
      addline(@procfunclist,'    tst.l   d1','');
      addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'NoBitMap','');
      addline(@procfunclist,'    movea.l d1,a0','');
      addline(@procfunclist,'    jsr     FreeBitMap','');
      addline(@procfunclist,no0(pdwn^.labelid)+'NoBitMap:','');
    end;
  
  addline(@procfunclist,'    movem.l (sp)+,d0-d2/a0-a6','');
  addline(@procfunclist,'    rts','');
  addline(@procfunclist,'','');
  
  {
  addline(@procfunclist,'','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'','');
  }
  
    
  {
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@procfunclist,'	depth = '+no0(pdwn^.labelid)+'->WScreen->BitMap.Depth;','');
    end;
  }
  {
  if pdwn^.codeoptions[8] then
    begin
      addline(@procfunclist,'	CloseWindowSafely( '+no0(pdwn^.labelid)+');','');
      sharedwindow:=true;
    end
   else
    addline(@procfunclist,'	CloseWindow( '+no0(pdwn^.labelid)+');','');
  }
  
  {freesuperbitmap}
  
end;

procedure addmygad(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  s2 : string;
  s  : string;
  s3 : string;
begin
  str(pgn^.x,s2);
  s:=''+s2+',';
  str(pgn^.y,s2);
  s:=s+s2+',';
  str(pgn^.w,s2);
  s:=s+s2+',';
  str(pgn^.h,s2);
  addline(@constlist,'    dc.w    '+s+s2,'');
  s3:='0';
  
  if  pgn^.kind<>myobject_kind then
  begin
  if pdwn^.localeoptions[1] then
    begin
      s:='0';
      if not (pgn^.kind=mybool_kind) then
        begin
          
          s3:=no0(pgn^.labelid)+'String';
          
          localestring(no0(pgn^.title),no0(pgn^.labelid)+'String','Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid));
        
        end
       else
        s3:='$FFFFFFFF';
    end
   else
    begin
      if pgn^.kind=mybool_kind then
        s:='0'
       else
        begin
          s:=no0(pgn^.labelid)+'Text';
        end;
    end;
  end
  else
  begin
    if pgn^.tags[1].ti_tag=0 then
      s:=no0(pgn^.labelid)+'Text'
     else
      s:='0';
  end;
  
  s:=s+',';
  
  if pgn^.kind=mybool_kind then
    s:=s+'0'
   else
    if pdwn^.codeoptions[6] then
      if not pdwn^.codeoptions[17] then
        s:=s+makemyfont(pdwn^.gadgetfont)
       else
        s:=s+'0'
     else
      s:=s+makemyfont(pgn^.font);
  
  addline(@constlist,'    dc.l    '+s,'');
 
  addline(@constlist,'    dc.w    GD_'+no0(pgn^.labelid),'');
  
   
  str(pgn^.flags,s2);
  s:=s2+',0,'+s3;
  addline(@constlist,'    dc.l    '+s,'');
end;

procedure dogadgets(pdwn:pdesignerwindownode);
var
  pgn       : pgadgetnode;
  s         : string;
  loop      : long;
  s2        : string;
  pgn2      : pgadgetnode;
  fontstyle : long;
  fontysize : long;
  fontflags : long;
  fontname  : string;
  spaces    : string;
  oldloop   : long;
  gadcount  : long;
  psn       : pstringnode;
begin
  spaces:='    dc.l    ';
  loop:=1;
  oldloop:=1;
  gadcount:=0;
  
  addline(@constlist,'','');
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@constlist,(no0(pdwn^.labelid))+'GTags:','');
  
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
        case pgn^.kind of
          myobject_kind : begin
                            loop:=doobjects(pdwn,pgn,loop);
                          end;
          Palette_kind: begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or paletteidcmp;
                          if pgn^.tags[1].ti_data<>1 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              if pgn^.tags[1].ti_data=0 then
                                addline(@constlist,no0(pgn^.labelid)+'Depth:','');
                              addline(@constlist,spaces+'$80080010,'+s2,'GTPA_Depth');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>1 then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'$80080011,'+s2,'GTPA_Color');
                              inc(loop,2);
                            end;
                          if pgn^.tags[3].ti_data<>0 then
                            begin
                              str(pgn^.tags[3].ti_data,s2);
                              addline(@constlist,spaces+'$80080012,'+s2,'GTPA_ColorOffset');
                              inc(loop,2);
                            end;
                          if pgn^.tags[4].ti_tag<>tag_ignore then
                            begin
                              str(pgn^.tags[4].ti_data,s2);
                              addline(@constlist,spaces+'$80080013,'+s2,'GTPA_IndicatorWidth');
                              inc(loop,2);
                            end;
                          if pgn^.tags[5].ti_tag<>tag_ignore then
                            begin
                              str(pgn^.tags[5].ti_data,s2);
                              addline(@constlist,spaces+'$80080014,'+s2,'GTPA_IndicatorHeight');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[7].ti_data) then
                            begin
                              str(loop,s);
                              addline(@constlist,spaces+'$8003000E,1','GA_Disabled,True');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[8].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_UnderScore,''_''');
                              inc(loop,2);
                            end;
                        end;
          ListView_kind:begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or listviewidcmp;
                          if pgn^.tags[3].ti_tag=GTLV_showselected then
                            begin
                              if pgn^.tags[3].ti_data<>0 then
                                addline(@constlist,no0(pgn^.labelid)+'ShowSelected:','');
                              addline(@constlist,spaces+'$80080035,0','GTLV_ShowSelected');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_UnderScore,''_''');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>0 then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'$80080005,'+s2,'GTLV_Top');
                              inc(loop,2);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              addline(@constlist,spaces+'$80080053,'+no0(pgn^.edithook),'GTLV_EditHook');
                              inc(loop,2);
                            end;
                          if pgn^.tags[4].ti_data<>16 then
                            begin
                              str(pgn^.tags[4].ti_data,s2);
                              addline(@constlist,spaces+'$80080008,'+s2,'GTLV_ScrollWidth');
                              inc(loop,2);
                            end;
                          if pgn^.tags[5].ti_data<>~0 then
                            begin
                              str(pgn^.tags[5].ti_data,s2);
                              addline(@constlist,spaces+'$80080036,'+s2,'GTLV_Selected');
                              inc(loop,2);
                            end;
                          if pgn^.tags[6].ti_data<>0 then
                            begin
                              str(pgn^.tags[6].ti_data,s2);
                              addline(@constlist,spaces+'$80038002,'+s2,'LAYOUTA_Spacing');
                              inc(loop,2);
                            end;
                          if Boolean(pgn^.tags[8].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080007,1','GTLV_ReadOnly,True');
                              inc(loop,2);
                            end;
                          if pgn^.tags[10].ti_data=long(true) then
                            begin
                              str(loop,s);
                              addline(@constlist,spaces+'$80080006,'+no0(pgn^.labelid)+'List','GTLV_Labels');
                              inc(loop,2);
                            end;
                        end;
          MX_kind     : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or mxidcmp;
                          if (pgn^.tags[2].ti_data<>1)or(pdwn^.codeoptions[17]) then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'$8008003D,'+s2,'GTMX_Spacing');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_UnderScore,''_''');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[6].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080045,1','GTMX_Scale (V39)');
                              inc(loop,2);
                            end;
                          if (pgn^.tags[7].ti_data<>placetext_left) then
                            begin
                              str(pgn^.tags[7].ti_data,s);
                              addline(@constlist,spaces+'$80080047,'+s,'Title Place (V39)');
                              inc(loop,2);
                            end;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'$8008000A,'+s2,'GTMX_Active');
                              inc(loop,2);
                            end;
                          addline(@constlist,spaces+'$80080009,'+no0(pgn^.labelid)+'Labels','GTMX_Labels');
                          inc(loop,2);
                        end;
          cycle_kind  : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or cycleidcmp;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_UnderScore,''_''');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[6].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8003000E,1','GA_Disabled,True');
                              inc(loop,2);
                            end;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'$8008000F,'+s2,'GTCY_Active');
                              inc(loop,2);
                            end;
                          addline(@constlist,spaces+'$8008000E,'+no0(pgn^.labelid)+'Labels','GTCY_Labels');
                          inc(loop,2);
                        end;
          button_kind : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or buttonidcmp;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_Underscore,''_''');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[2].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8003000E,1','GA_Disabled,True');
                              inc(loop,2);
                            end;
                        end;
          number_kind : begin
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'$8008000D,'+s2,'GTNM_Number');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[2].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8008003A,1','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              if pgn^.tags[6].ti_data<>1 then
                                begin
                                  str(pgn^.tags[6].ti_data,s);
                                  addline(@constlist,spaces+'$80080000,'+s,'GTNM_FrontPen');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[7].ti_data<>0 then
                                begin
                                  str(pgn^.tags[7].ti_data,s);
                                  addline(@constlist,spaces+'$80080049,'+s,'GTNM_BackPen');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[8].ti_data<>1 then
                                begin
                                  str(pgn^.tags[8].ti_data,s);
                                  addline(@constlist,spaces+'$8008004A,'+s,'GTNM_Justification');
                                  inc(loop,2);
                                end;
                              if not boolean(pgn^.tags[9].ti_data) then
                                begin
                                  addline(@constlist,spaces+'$80080055,0','GTNM_Clipped,False');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[10].ti_data<>0 then
                                begin
                                  str(pgn^.tags[10].ti_data,s);
                                  addline(@constlist,spaces+'$8008004C,'+s,'GTNM_MaxNumberLen');
                                  inc(loop,2);
                                end;
                              
                              if no0(pgn^.datas)<>'' then
                                begin
                                  
                                  if pdwn^.localeoptions[1] then
                                    begin
                                      addline(@constlist,no0(pgn^.labelid)+'SF:','');
                                      addline(@constlist,spaces+'$8008004B,0','GTNM_Format');
                                    end
                                   else
                                    addline(@constlist,spaces+'$8008004B,'+no0(pgn^.labelid)+'Format','GTNM_Format');
                                  
                                  if pdwn^.localeoptions[1] then
                                    localestring(no0(pgn^.datas),no0(pgn^.labelid)+'StringFormat',
                                      'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' String Format');
                                  str(loop,s);
                                  if pdwn^.localeoptions[1] then
                                    begin
                                      
                                      addline(@procfunclist,'    move.l  #'+no0(pgn^.labelid)+'StringFormat,d0','');
                                      addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
                                      addline(@procfunclist,'    move.l  d0,'+no0(pgn^.labelid)+'SF+4','');
                                     
                                    end;
                                  
                                  inc(loop,2);
                                end;
                              
                            end;
                        end;
           text_kind  : begin
                          if no0(pgn^.datas)<>'' then
                            begin
                              if pdwn^.localeoptions[1] then
                                begin
                                  
                                  localestring(no0(pgn^.datas),(no0(pgn^.labelid))+'InitText','Window: '+
                                       no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' Text');
                                  
                                  addline(@constlist,no0(pgn^.labelid)+'IT:','');
                                     
                                  addline(@constlist,spaces+'$8008000B,0','GTTX_Text');
                                  str(loop,s);
                                  
                                  addline(@procfunclist,'    move.l  #'+no0(pgn^.labelid)+'InitText,d0','');
                                  addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
                                  addline(@procfunclist,'    move.l  d0,'+no0(pgn^.labelid)+'IT+4','');
                                     

                                  
                                end
                               else
                                addline(@constlist,spaces+'$8008000B,'+no0(pgn^.labelid)+'TX','GTTX_Text');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[2].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080039,1','GTTX_Border');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8008000C,1','GTTX_CopyText');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              if pgn^.tags[6].ti_data<>1 then
                                begin
                                  str(pgn^.tags[6].ti_data,s);
                                  addline(@constlist,spaces+'$80080048,'+s,'GTTX_FrontPen (V39)');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[7].ti_data<>0 then
                                begin
                                  str(pgn^.tags[7].ti_data,s);
                                  addline(@constlist,spaces+'$80080049,'+s,'GTTX_BackPen (V39)');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[8].ti_data<>1 then
                                begin
                                  str(pgn^.tags[8].ti_data,s);
                                  addline(@constlist,spaces+'$8008004A,'+s,'GTTX_Justification (V39)');
                                  inc(loop,2);
                                end;
                              if not boolean(pgn^.tags[9].ti_data) then
                                begin
                                  addline(@constlist,spaces+'$80080055,0','GTTX_Clipped,False');
                                  inc(loop,2);
                                end;
                            end;
                        end;
           string_kind : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or stringidcmp;
                          
                          
                          if sfp(pointer(gettagdata(gtst_string,0,pgn^.gn_gadgettags)))<>'' then
                            begin
                              addline(@constlist,spaces+'$8008002D, '+no0(pgn^.labelid)+'DefaultString','GTST_String');
                              inc(loop,2);
                            end;
                          
                          
                          if pgn^.tags[1].ti_data<>64 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'$8008002E,'+s2,'GTST_MaxChars');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>gact_stringleft then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'$80032010,'+s2,'STRINGA_Justification');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8003200D,1','STRINGA_ReplaceMode');
                              inc(loop,2);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              addline(@constlist,spaces+'$80080037,'+no0(pgn^.edithook),'GTST_EditHook');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8003000E,1','GA_Disabled,True');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80032013,1','STRINGA_ExitHelp');
                              inc(loop,2);
                            end;
                          if not boolean(pgn^.tags[6].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80030024,0','GA_TabCycle');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[8].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_UnderScore,''_''');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80030015,1','GA_Immediate');
                              inc(loop,2);
                            end;
                        end;
          integer_kind: begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or integeridcmp;
                          if pgn^.tags[1].ti_data<>10 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'$80080030,'+s2,'GTIN_MaxChars');
                              inc(loop,2);
                            end;
                            
                          
                          if gettagdata(gtin_number,0,pgn^.gn_gadgettags)<>0 then
                            begin
                              str(gettagdata(gtin_number,0,pgn^.gn_gadgettags),s2);
                              addline(@constlist,spaces+'$8008002F,'+s2,'GTIN_Number');
                              inc(loop,2);
                            end;
                          
                          
                          if pgn^.tags[2].ti_data<>gact_stringleft then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'$80032010,'+s2,'STRINGA_Justification');
                              inc(loop,2);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              addline(@constlist,spaces+'$80080037,'+no0(pgn^.edithook),'GTST_EditHook');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8003200D,1','STRINGA_ReplaceMode');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8003000E,1','GA_Disabled,True');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80032013,1','STRINGA_ExitHelp');
                              inc(loop,2);
                            end;
                          if not boolean(pgn^.tags[6].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80030024,0','GA_TabCycle');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[8].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_UnderScore,''_''');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80030015,1','GA_Immediate');
                              inc(loop,2);
                            end;
                        end;
          CheckBox_kind:begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or checkboxidcmp;
                          if boolean(pgn^.tags[1].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080004,1','GTCB_Checked,True');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8003000E,1','GA_Disabled,True');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080044,1','Scale,True');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_UnderScore,''_''');
                              inc(loop,2);
                            end;
                        end;
          Slider_kind : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or slideridcmp;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'$80080026,'+s2,'GTSL_Min');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>0 then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'$80080027,'+s2,'GTSL_Max');
                              inc(loop,2);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              addline(@constlist,spaces+'$8008002C,'+no0(pgn^.edithook),'GTSL_DispFunc');
                              inc(loop,2);
                            end;
                          if pgn^.tags[3].ti_data<>0 then
                            begin
                              str(pgn^.tags[3].ti_data,s2);
                              addline(@constlist,spaces+'$80080028,'+s2,'GTSL_Level');
                              inc(loop,2);
                            end;
                          if pgn^.tags[9].ti_data<>lorient_horiz then
                            begin
                              str(pgn^.tags[9].ti_data,s2);
                              addline(@constlist,spaces+'$80031001,'+s2,'PGA_Freedom');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              
                              if pdwn^.localeoptions[1] then
                                begin
                                  addline(@constlist,no0(pgn^.labelid)+'LF','');
                                  addline(@constlist,spaces+'$8008002A,0','GTSL_LevelFormat');
                                  str(loop,s);
                                  localestring(no0(pgn^.datas),(no0(pgn^.labelid))+'LevelFormat','Window: '+
                                       no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' levelformat');
                                 
                                  
                                  addline(@procfunclist,'    move.l  #'+no0(pgn^.labelid)+'LevelFormat,d0','');
                                  addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
                                  addline(@procfunclist,'    move.l  d0,'+no0(pgn^.labelid)+'LF+4','');
                                  
                                 
                                end
                               else
                                begin
                                  addline(@constlist,spaces+'$8008002A, '+no0(pgn^.labelid)+'LF','GTSL_LevelFormat');
                                end;
                              inc(loop,2);
                              if pgn^.tags[5].ti_data<>0 then
                                begin
                                  str(pgn^.tags[5].ti_data,s2);
                                  addline(@constlist,spaces+'$80080029,'+s2,'GTSL_MaxLevelLen');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[6].ti_data<>placetext_left then
                                begin
                                  str(pgn^.tags[6].ti_data,s2);
                                  addline(@constlist,spaces+'$8008002B,'+s2,'GTSL_LevelPlace');
                                  inc(loop,2);
                                end;
                            end;
                          if boolean(pgn^.tags[12].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80030015,1','GA_Immediate');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[13].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80030016,1','GA_RelVerify');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[11].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8003000E,1','GA_Disabled,True');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[14].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_UnderScore,''_''');
                              inc(loop,2);
                            end;
                        end;
          mybool_kind : begin
                          if pdwn^.localeoptions[1] then
                            localestring(no0(pgn^.title),no0(pgn^.labelid)+'String','Window: '+no0(pdwn^.title)+' Gadget: '+
                             no0(pgn^.labelid));
                        end;
          Scroller_kind:begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or scrolleridcmp;
                          if pgn^.tags[7].ti_data<>lorient_horiz then
                            begin
                              str(pgn^.tags[7].ti_data,s2);
                              addline(@constlist,spaces+'$80031001,'+s2,'PGA_Freedom');
                              inc(loop,2);
                            end;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'$80080015,'+s2,'GTSC_Top');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>0 then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'$80080016,'+s2,'GTSC_Total');
                              inc(loop,2);
                            end;
                          if pgn^.tags[3].ti_data<>2 then
                            begin
                              str(pgn^.tags[3].ti_data,s2);
                              addline(@constlist,spaces+'$80080017,'+s2,'GTSC_Visible');
                              inc(loop,2);
                            end;
                          if pgn^.tags[4].ti_tag<>tag_ignore then
                            begin
                              pdwn^.idcmpvalues:=pdwn^.idcmpvalues or arrowidcmp;
                              str(pgn^.tags[4].ti_data,s2);
                              addline(@constlist,spaces+'$8008003B,'+s2,'GTSC_Arrows');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[10].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80030015,1','GA_Immediate');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[11].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80030016,1','GA_RelVerify');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@constlist,spaces+'$8003000E,1','GA_Disabled,True');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[12].ti_data) then
                            begin
                              addline(@constlist,spaces+'$80080040,''_''','GT_UnderScore,''_''');
                              inc(loop,2);
                            end;
                        end;
         end;
      {
      if loop<>oldloop then
        begin
      }
      addline(@constlist,spaces+'0','TAG_DONE');
      {
          inc(loop);
          pgn^.tagpos:=oldloop;
          oldloop:=loop;
        end;
      }
      inc(gadcount);
      pgn:=pgn^.ln_succ;
    end;  
  
  psn:=pstringnode(constlist.lh_tailpred);
  
  addline(@constlist,'','');
  addline(@constlist,(no0(pdwn^.labelid))+'GTypes:','');
  spaces:='    dc.w    ';
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      if not (pgn^.joined and (pgn^.kind=string_kind)) then
        case pgn^.kind of
          Palette_kind: addline(@constlist,spaces+'8','Palette');
          ListView_kind:begin
                          if pgn^.tags[3].ti_data<>0 then
                            addline(@constlist,spaces+'12','String');
                          addline(@constlist,spaces+'4','ListView');
                        end;
          mybool_kind  : addline(@constlist,spaces+'0','Generic ( Boolean )');
          MX_kind      : addline(@constlist,spaces+'5','MX');
          cycle_kind   : addline(@constlist,spaces+'7','Cycle');
          button_kind  : addline(@constlist,spaces+'1','Button');
          number_kind  : addline(@constlist,spaces+'6','Number');
          text_kind    : addline(@constlist,spaces+'13','Text');
          string_kind  : addline(@constlist,spaces+'12','String');
          integer_kind : addline(@constlist,spaces+'3','Integer');
          CheckBox_kind: addline(@constlist,spaces+'2','CheckBox');
          Slider_kind  : addline(@constlist,spaces+'11','Slider');
          Scroller_kind: addline(@constlist,spaces+'9','Scroller');
          myobject_kind: addline(@constlist,spaces+'198','Object');
         end;
      pgn:=pgn^.ln_succ;
    end;  
  addline(@constlist,'','');
  
  addline(@constlist,(no0(pdwn^.labelid))+'NGad:','');
  
  gadcount:=0;
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      if not (pgn^.joined and (pgn^.kind=string_kind)) then
        begin
          if (pgn^.tags[3].ti_data<>0)and(pgn^.kind=listview_kind) then
            begin
              addmygad(pdwn,pgadgetnode(pgn^.tags[3].ti_data));
              inc(gadcount);
            end;
          addmygad(pdwn,pgn);
          inc(gadcount);
        end;
      pgn:=pgn^.ln_succ;
    end;
  addline(@constlist,'','');
  
  loop:=0;
  if not pdwn^.localeoptions[1] then
    begin
      pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
      while (pgn^.ln_succ<>nil) do
        begin
          if (pgn^.kind<>mybool_kind) and (pgn^.kind<>myobject_kind) then
            begin
              inc(loop);
              addline(@constlist,no0(pgn^.labelid)+'Text:','');
              addline(@constlist,'    dc.b    '''+no0(pgn^.title)+''',0','');
              addline(@constlist,'','');
            end;
          pgn:=pgn^.ln_succ;
        end;
    end;
  
      pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
      while (pgn^.ln_succ<>nil) do
        begin
          if (pgn^.kind=myobject_kind) then
            begin
              if pgn^.tags[1].ti_tag=0 then
                begin
                  inc(loop);
                  addline(@constlist,no0(pgn^.labelid)+'Text:','');
                  addline(@constlist,'    dc.b    '''+no0(pgn^.datas)+''',0','');
                  addline(@constlist,'','');
                end;
            end;
          pgn:=pgn^.ln_succ;
        end;
      if loop>0 then
        begin
          addline(@constlist,'    cnop    0,2','');
          addline(@constlist,'','');
        end;
      
end;

procedure processwindowidcmp(pdwn:pdesignerwindownode);
const
  commentstrings : array[1..25] of string[15]=
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
  idcmpstrings : array[1..25] of string[15]=
  (
  '8',
  '$10',
  '$100000',
  '$20',
  '$40',
  '$200',
  '$100',
  '$2000',
  '$1000000',
  '$80',
  '$1000',
  '$800',
  '2',
  '4',
  '1',
  '$40000',
  '$80000',
  '$200000',
  '$400',
  '$4000',
  '$8000',
  '$10000',
  '$400000',
  '$800000',
  '$2000000'
  );

var
  loop    : word;
  psn     : pstringnode;
  pgn     : pgadgetnode;
  countup : long;
  s : string;
begin
  {assume code,class,iaddress  need var gad}
  addline(@idcmplist,'','');
  if comment then
    begin
      addline(@idcmplist,'','Cut the core out of this function and edit it suitably.');
      addline(@idcmplist,'','');
    end;
  s:='';
  if no0(pdwn^.winparams)<>'' then
    s:=', '+no0(pdwn^.winparams);
  addline(@idcmplist,'ProcessWindow'+no0(pdwn^.labelid)+':',
        'Class in d0,code in d1,iaddress in a0 required, others are up to you.');
  
  addline(@idcmplist,'    movem.l d1-d4/a0-a6,-(sp)','Restore Registers');
  
  
  for loop:=1 to 25 do
    if pdwn^.idcmplist[Loop] then
      begin
        
        addline(@idcmplist,'    cmp.l   #'+idcmpstrings[loop]+',d0','IDCMP_'+commentstrings[loop]);
        addline(@idcmplist,'    bne     Not'+commentstrings[loop],'');
        
        case loop of
          1 :
            begin
              addline(@idcmplist,'','Mouse Button Action');
              addline(@idcmplist,'','Code contains selectup/down, middleup/down or menuup/down');
            end;
          2 :
            begin
              addline(@idcmplist,'','Mouse Movement');
              addline(@idcmplist,'','Message has absolute [Window] mouse coords.');
            end;
          3 :
            begin
              if comment then
                begin
                  addline(@idcmplist,'','Mouse Movement');
                  addline(@idcmplist,'','Message has relative mouse coords.');
                end;
            end;
          4 : {gadgetdown}
            begin
              countup:=0;
              addline(@idcmplist,'',' Gadget message, gadget is in a0');
              addline(@idcmplist,'    move.w  38(a0),d0','Get id in d0');
              pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
              while(pgn^.ln_succ<>nil) do
                begin
              
                  if 
                     (pgn^.kind = string_kind) or
                     (pgn^.kind = mx_kind) or
                     (pgn^.kind = Slider_kind) or
                     (pgn^.kind = Scroller_kind) or
                     (pgn^.kind = mybool_kind) or
                     (pgn^.kind = integer_kind) then
                    begin
                      
                      addline(@idcmplist,'    cmp.w   #GD_'+no0(pgn^.labelid)+',d0','');
                      addline(@idcmplist,'    bne     Not'+no0(pgn^.labelid)+'Down','');
              

                      case pgn^.kind of
                        string_kind :
                          addline(@idcmplist,'',
                              'String entered   , Text of gadget : '+no0(pgn^.title));
                        integer_kind :
                          addline(@idcmplist,'',
                              'Integer entered  , Text of gadget : '+no0(pgn^.title));
                        MX_kind :
                          addline(@idcmplist,'',
                              'MX changed       , Text of gadget : '+no0(pgn^.title));
                        Slider_kind :
                          addline(@idcmplist,'',
                              'Slider changed   , Text of gadget : '+no0(pgn^.title));
                        Scroller_kind :
                          addline(@idcmplist,'',
                              'Scroller changed , Text of gadget : '+no0(pgn^.title));
                        mybool_kind :
                          addline(@idcmplist,'',
                              'Boolean activated, Text of gadget : '+no0(pgn^.title));
                       end;
                      
                      addline(@idcmplist,'    jmp     '+no0(pdwn^.labelid)+'DoneMessage','');
                      addline(@idcmplist,'Not'+no0(pgn^.labelid)+'Down:','');

                    end;
              
                  
                  pgn:=pgn^.ln_succ;
                end;
            end;
          5 : {gadgetup}
            begin
              countup:=0;
              addline(@idcmplist,'',' Gadget message, gadget is in a0');
              addline(@idcmplist,'    move.w  38(a0),d0','Get id in d0');
              
              pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
              while(pgn^.ln_succ<>nil) do
                begin
                  if (pgn^.kind = button_kind) or
                     (pgn^.kind = string_kind) or
                     (pgn^.kind = cycle_kind) or
                     (pgn^.kind = Slider_kind) or
                     (pgn^.kind = Scroller_kind) or
                     (pgn^.kind = checkbox_kind) or
                     (pgn^.kind = mybool_kind) or
                     (pgn^.kind = integer_kind) or
                     (pgn^.kind = listview_kind) or
                     (pgn^.kind = palette_kind) then
                    begin
                      
                      addline(@idcmplist,'    cmp.w   #GD_'+no0(pgn^.labelid)+',d0','');
                      addline(@idcmplist,'    bne     Not'+no0(pgn^.labelid)+'Up','');
              

                      
                      case pgn^.kind of
                        button_kind :
                          addline(@idcmplist,'',
                              'Button pressed  , Text of gadget : '+no0(pgn^.title));
                        button_kind :
                          addline(@idcmplist,'',
                              'Boolean pressed , Text of gadget : '+no0(pgn^.title));
                        string_kind :
                          addline(@idcmplist,'',
                              'String entered  , Text of gadget : '+no0(pgn^.title));
                        integer_kind :
                          addline(@idcmplist,'',
                              'Integer entered , Text of gadget : '+no0(pgn^.title));
                        CheckBox_kind :
                          addline(@idcmplist,'',
                              'CheckBox changed, Text of gadget : '+no0(pgn^.title));
                        cycle_kind :
                          addline(@idcmplist,'',
                              'Cycle changed   , Text of gadget : '+no0(pgn^.title));
                        Slider_kind :
                          addline(@idcmplist,'',
                              'Slider changed  , Text of gadget : '+no0(pgn^.title));
                        Scroller_kind :
                          addline(@idcmplist,'',
                              'Scroller changed, Text of gadget : '+no0(pgn^.title));
                        ListView_kind :
                          addline(@idcmplist,'',
                              'ListView pressed, Text of gadget : '+no0(pgn^.title));
                        Palette_kind :
                          addline(@idcmplist,'',
                              'Colour Selected , Text of gadget : '+no0(pgn^.title));
                       end;
                      
                      addline(@idcmplist,'    jmp     '+no0(pdwn^.labelid)+'DoneMessage','');
                      addline(@idcmplist,'Not'+no0(pgn^.labelid)+'Up:','');
                   
                    end;
                  pgn:=pgn^.ln_succ;
                end;
            end;
          6 :
            addline(@idcmplist,'','CloseWindow');
          7 :
            Begin
              addline(@idcmplist,'','Menu Selected');
              if pdwn^.menutitle<>'' then
                begin
                  addline(@idcmplist,'    move.l  d1,d0',' code into d0');
                  addline(@idcmplist,'    jsr     ProcessMenuIDCMP'+no0(pdwn^.menutitle),'');
                end;
            end;
          8 :
            addline(@idcmplist,'','Intuiton pauses menu until replied.');
          9 :
            addline(@idcmplist,'','Copy the menu processing procedure and change suitably');
          10:
            addline(@idcmplist,'','A requester has opened in this window.');
          11:
            addline(@idcmplist,'','A requester has cleared from this window.');
          12:
            addline(@idcmplist,'','Can you take a requester ?, Intuiton waits for a reply.');
          13:
            addline(@idcmplist,'','Window re-sized.');
          14:
            begin
              
              addline(@idcmplist,'    movea.l '+no0(pdwn^.labelid)+',a0','');
              addline(@idcmplist,'    movea.l _GadToolsBase,a6','');
              addline(@idcmplist,'    jsr     GT_BeginRefresh(a6)','');
              addline(@idcmplist,'','Refrsh Window');
              addline(@idcmplist,'    move.l  #1,d0','');
              addline(@idcmplist,'    movea.l '+no0(pdwn^.labelid)+',a0','');
              addline(@idcmplist,'    jsr     GT_EndRefresh(a6)','');
            end;
          15:
            addline(@idcmplist,'','Verify window size.');
          16:
            addline(@idcmplist,'','Window activated.');
          17:
            addline(@idcmplist,'','Window deactivated.');
          18:
            begin
              addline(@idcmplist,'','Processed key press');
              addline(@idcmplist,'','gadgets need processing perhaps.');
            end;
          19:
            addline(@idcmplist,'','Raw keyboard keypress');
          20:
            addline(@idcmplist,'','1.3 Prefs. ');
          21:
            addline(@idcmplist,'','Floppy disk inserted.');
          22:
            addline(@idcmplist,'','Floppy disk removed. ');
          23:
            addline(@idcmplist,'','Timing message. ');
          24:
            addline(@idcmplist,'','Boopsi message');
          25:
            addline(@idcmplist,'','Window position or size changed.');
         end;
        
        addline(@idcmplist,'    jmp     '+no0(pdwn^.labelid)+'DoneMessage','');
        addline(@idcmplist,'Not'+commentstrings[loop]+':','');
        
      end;
  
  addline(@idcmplist,no0(pdwn^.labelid)+'DoneMessage:','');
  addline(@idcmplist,'    movem.l (sp)+,d1-d4/a0-a6','Restore Registers');
  addline(@idcmplist,'    rts','');
  
end;

procedure dogadgetbits(pdwn:pdesignerwindownode);
var
  pgn : pgadgetnode;
  s   : string;
  psn : pstringnode;
  mycount : integer;
  s2   :string;
  loop : word;
  s3   : string;
  s4   : string;
begin
  mycount:=0;
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      case pgn^.kind of
        myobject_kind :
          begin
            addmyobjectconstdata(pdwn,pgn);
          end;
        text_kind :
          begin
            if not pdwn^.localeoptions[1] then
              begin
                addline(@constlist,no0(pgn^.labelid)+'TX:','Text for Text_Kind gadget');
                addline(@constlist,'    dc.b    '''+no0(pgn^.datas)+''',0','');
                addline(@constlist,'    cnop    0,2','');
              end;
          end;
        number_kind :
          begin
            if not pdwn^.localeoptions[1] then
              begin
                addline(@constlist,no0(pgn^.labelid)+'Format:','Format for Number_Kind gadget');
                addline(@constlist,'    dc.b    '''+no0(pgn^.datas)+''',0','');
                addline(@constlist,'    cnop    0,2','');
              end;
          end;

        slider_kind :
          begin
          if boolean(pgn^.tags[4].ti_data) then
            if not pdwn^.localeoptions[1] then
              begin
                addline(@constlist,no0(pgn^.labelid)+'LF:','');
                addline(@constlist,'    dc.b    '''+no0(pgn^.datas)+''',0','');
                addline(@constlist,'    cnop    0,2','');
              end;
          end;
        
        string_kind :
          begin
          if sfp(pointer(gettagdata(gtst_string,0,pgn^.gn_gadgettags)))<>'' then
              begin
                addline(@constlist,no0(pgn^.labelid)+'DefaultString:','');
                addline(@constlist,'    dc.b    '''+sfp(pointer(gettagdata(gtst_string,0,pgn^.gn_gadgettags)))+''',0','');
                addline(@constlist,'    cnop    0,2','');
              end;
          end;
        
        mx_kind, cycle_kind :
          begin
            addline(@constlist,'','');
            addline(@constlist,no0(pgn^.labelid)+'Labels:','');
            mycount:=0;
            psn:=pstringnode(pgn^.infolist.mlh_head);
            while (psn^.ln_succ<>nil) do
              begin
                str(mycount,s);
                if pdwn^.localeoptions[1] then
                  localestring(no0(psn^.st),no0(pgn^.labelid)+
                               'LabelString'+s,'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                addline(@constlist,'    dc.l    '+no0(pgn^.labelid)+'LabelString'+s,'');
                inc(mycount);
                psn:=psn^.ln_succ;
              end;
            addline(@constlist,'    dc.l    0',''); 
            
            mycount:=0;
            addline(@constlist,'',''); 
            psn:=pstringnode(pgn^.infolist.mlh_head);
            if not pdwn^.localeoptions[1] then
              begin
                while (psn^.ln_succ<>nil) do
                  begin
                    str(mycount,s);
                    
                    addline(@constlist,no0(pgn^.labelid)+'LabelString'+s+':','');
                    addline(@constlist,'    dc.b    '''+no0(psn^.st)+''',0','');
                    inc(mycount);
                    psn:=psn^.ln_succ;
                  end;
                addline(@constlist,'    cnop    0,2','');
              end;
            
            str(mycount,s);
            if pdwn^.localeoptions[1] then
              begin  
                addline(@procfunclist,'    lea     '+no0(pgn^.labelid)+'Labels,a2','');
                addline(@procfunclist,'    move.l  #'+fmtint(sizeoflist(@pgn^.infolist))+',d2','');
                addline(@procfunclist,no0(pgn^.labelid)+'Loop:','');
                addline(@procfunclist,'    tst.l   d2','');
                addline(@procfunclist,'    beq     '+no0(pgn^.labelid)+'EndLoop','');
                
                addline(@procfunclist,'    move.l  (a2),d0','');
                addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
                addline(@procfunclist,'    move.l  d0,(a2)','');
                
                addline(@procfunclist,'    adda.l  #4,a2','');
                addline(@procfunclist,'    sub.l  #1,d2','');
                addline(@procfunclist,'    jmp     '+no0(pgn^.labelid)+'Loop','');
                addline(@procfunclist,no0(pgn^.labelid)+'EndLoop:','');
                
              end;
          
          end;
        mybool_kind :
          if boolean(pgn^.tags[1].ti_data) then
            begin
              addline(@constlist,'','');
              addline(@constlist,no0(pgn^.labelid)+'IText:','');;
              str(pgn^.tags[3].ti_tag,s2);
              s:=s2+',';
              str(pgn^.tags[3].ti_data,s2);
              s:=s+s2;
              
              addline(@constlist,'    dc.b    '+s,'FrontPen,BackPen');
              
              str(pgn^.tags[4].ti_tag,s2);
              addline(@constlist,'    dc.b    '+s2+',0','DrawMode,Pad');
              
              str(pgn^.tags[2].ti_tag,s2);
              s:=s2+',';
              str(pgn^.tags[2].ti_data,s2);
              s:=s+s2;
              addline(@constlist,'    dc.w    '+s,'LeftEdge,TopEdge');
              
              
              if pdwn^.codeoptions[6] then
                if not pdwn^.codeoptions[17] then
                  s:=makemyfont(pdwn^.gadgetfont)
                 else
                  s:='0'
               else
                s:=makemyfont(pgn^.font);
              
              addline(@constlist,'    dc.l    '+s,'TextAttr');
              
              if pdwn^.localeoptions[1] then
                s:='0,0 '
               else
                s:=no0(pgn^.labelid)+'Text,0';
              
              addline(@constlist,'    dc.l    '+s,'IText,NextText');
              
              if not pdwn^.localeoptions[1] then
                begin
                  addline(@constlist,'','');
                  addline(@constlist,no0(pgn^.labelid)+'Text:','');
                  addline(@constlist,'    dc.b    '''+no0(pgn^.title)+''',0','');
                  addline(@constlist,'    cnop    0,2','');
                end;

              
            end;
        listview_kind :
          if pgn^.tags[10].ti_data=long(true) then
            begin
              loop:=0;
              addline(@constlist,'','');
              addline(@constlist,no0(pgn^.labelid)+'ListItems:','');
              mycount:=0;
              psn:=pstringnode(pgn^.infolist.mlh_head);
              while (psn^.ln_succ<>nil) do
                begin
                  
                  str(mycount,s3);
                  if pdwn^.localeoptions[1] then
                    begin
                      localestring(no0(psn^.st),no0(pgn^.labelid)+'String'+s3,'Window: '+
                                 no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                    end;
                  
                  s4:=no0(pgn^.labelid)+'String'+s3;
                  
                  str(loop,s2);
                  addline(@constlist,no0(pgn^.labelid)+'ListItem'+s2+':','');
                  
                  if sizeoflist(@pgn^.infolist)>1 then
                    if loop=0 then
                      begin
                        str(loop+1,s2);
                        s:=no0(pgn^.labelid)+'ListItem'+s2+','
                           +no0(pgn^.labelid)+'ListHead';
                      end
                     else
                      if loop=sizeoflist(@pgn^.infolist)-1 then
                        begin
                          str(loop-1,s2);
                          s:=no0(pgn^.labelid)+'ListTail,'+no0(pgn^.labelid)+'ListItem'+s2;
                        end
                       else
                        begin
                          str(loop+1,s2);
                          s:=no0(pgn^.labelid)+'ListItem'+s2+',';
                          str(loop-1,s2);
                          s:=s+no0(pgn^.labelid)+'ListItem'+s2+'';
                        end
                   else
                    s:=no0(pgn^.labelid)+'ListTail,'+no0(pgn^.labelid)+'ListHead';
                  
                  addline(@constlist,'    dc.l    '+s,'');
                  addline(@constlist,'    dc.b    0,0','');
                  addline(@constlist,'    dc.l    '+s4,'');
                  
                  inc(loop);
                  inc(mycount);
                  psn:=psn^.ln_succ;
                end;
              
              mycount:=0;
              addline(@constlist,'',''); 
              psn:=pstringnode(pgn^.infolist.mlh_head);
              if not pdwn^.localeoptions[1] then
                begin
                  while (psn^.ln_succ<>nil) do
                    begin
                      str(mycount,s);
                      
                      addline(@constlist,no0(pgn^.labelid)+'String'+s+':','');
                      addline(@constlist,'    dc.b    '''+no0(psn^.st)+''',0','');
                      inc(mycount);
                      psn:=psn^.ln_succ;
                    end;
                  addline(@constlist,'    cnop    0,2','');
                end;

              
              addline(@constlist,'','');
              addline(@constlist,no0(pgn^.labelid)+'List:','');
              addline(@constlist,no0(pgn^.labelid)+'ListHead:','');
              str(sizeoflist(@pgn^.infolist)-1,s2);
              addline(@constlist,'    dc.l    '+no0(pgn^.labelid)+'ListItem0','');
              addline(@constlist,no0(pgn^.labelid)+'ListTail:','');
              addline(@constlist,'    dc.l    0,'+no0(pgn^.labelid)+'ListItem'+s2+'','');
              
              
              str(mycount,s);
              
              if pdwn^.localeoptions[1] then
                begin
                  
                  addline(@procfunclist,'    lea     '+no0(pgn^.labelid)+'ListItems,a2','');
                  
                  addline(@procfunclist,'    move.l  #'+fmtint(sizeoflist(@pgn^.infolist))+',d2','');
                  addline(@procfunclist,no0(pgn^.labelid)+'Loop:','');
                  addline(@procfunclist,'    tst.l   d2','');
                  addline(@procfunclist,'    beq     '+no0(pgn^.labelid)+'EndLoop','');
                
                  addline(@procfunclist,'    move.l  10(a2),d0','');
                  addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
                  addline(@procfunclist,'    move.l  d0,10(a2)','');
                
                  addline(@procfunclist,'    adda.l  #14,a2','');
                  addline(@procfunclist,'    sub.l   #1,d2','');
                  addline(@procfunclist,'    jmp     '+no0(pgn^.labelid)+'Loop','');
                  addline(@procfunclist,no0(pgn^.labelid)+'EndLoop:','');

                end;
              
              
            end;
       end;
      pgn:=pgn^.ln_succ;
    end;
  
end;

procedure processwindow(pdwn:pdesignerwindownode);
var
  s        : string;
  count    : long;
  loop     : long;
  pgn      : pgadgetnode;
  spaces   : string;
  s2       : string;
  temp     : string;
  mycount  : word;
  psn      : pstringnode;
  loop2    : byte;
  loop6    : word;
  s3       : string;
  ptn      : ptextnode;
  psin     : psmallimagenode;
  first    : boolean;
  pin      : pimagenode;
  count24  : word;
begin
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    pdwn^.codeoptions[10]:=true;
  
  count24:=0;
  if not comment then
    comment:=pdwn^.codeoptions[16];
  pdwn^.idcmpvalues:=0;
  processrendwindow(pdwn);
  
  if pdwn^.codeoptions[17] then
    begin
      addline(@procfunclist,'','');
      addline(@procfunclist,no0(pdwn^.labelid)+'ScaleX:','Scale value in d0');
      addline(@procfunclist,'    movem.l d1/a0-a1,-(sp)','Store Registers');
      addline(@procfunclist,'    move.l  #0,d1','Zero d1');
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Scr,a0','Put screen in a0');
      addline(@procfunclist,'    move.l  136(a0),a1','Put rastport textfont structure address in a1');
      addline(@procfunclist,'    move.w  24(a1),d1','Put new font x size in d1');
      addline(@procfunclist,'    mulu.w  d1,d0','Multiply d0 by new font x size');
      addline(@procfunclist,'    addq.w  #'+fmtint(pdwn^.fontx div 2)+',d0','Add to d0 so division rounds up');
      addline(@procfunclist,'    divu.w  #'+fmtint(pdwn^.fontx)+',d0','Divide d0 by old size');
      addline(@procfunclist,'    move.l  #0,d1','');
      addline(@procfunclist,'    move.w  d0,d1','');
      addline(@procfunclist,'    move.l  d1,d0','');
      addline(@procfunclist,'    movem.l (sp)+,d1/a0-a1','Restore registers');
      addline(@procfunclist,'    rts','Return');
      
      addline(@procfunclist,'','');
      addline(@procfunclist,no0(pdwn^.labelid)+'ScaleY:','Scale value in d0');
      addline(@procfunclist,'    movem.l d1/a0-a1,-(sp)','Store Registers');
      addline(@procfunclist,'    move.l  #0,d1','Zero d1');
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Scr,a0','');
      addline(@procfunclist,'    move.l  136(a0),a1','Put rastport font structure address in a1');
      addline(@procfunclist,'    move.w  20(a1),d1','Put new font y size in d1');
      addline(@procfunclist,'    mulu.w  d1,d0','Multiply d0 by new font y size');
      addline(@procfunclist,'    addq.w  #'+fmtint(pdwn^.fonty div 2)+',d0','Add to d0 so division rounds up');
      addline(@procfunclist,'    divu.w  #'+fmtint(pdwn^.fonty)+',d0','Divide d0 by old size');
      addline(@procfunclist,'    move.l  #0,d1','');
      addline(@procfunclist,'    move.w  d0,d1','');
      addline(@procfunclist,'    move.l  d1,d0','');
      addline(@procfunclist,'    movem.l (sp)+,d1/a0-a1','Restore registers');
      addline(@procfunclist,'    rts','Return');
    end;
  
  addline(@constlist,'','');
  addline(@constlist,'    XDEF    '+no0(pdwn^.labelid),'');
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@constlist,'    XDEF    '+no0(pdwn^.labelid)+'GList','');
  if pdwn^.codeoptions[18] then
    begin
      addline(@constlist,'    XDEF    '+no0(pdwn^.labelid)+'AppWin','');
    end;
  addline(@constlist,'    XDEF    '+no0(pdwn^.labelid)+'VisualInfo','');
  addline(@constlist,'    XDEF    '+no0(pdwn^.labelid)+'DrawInfo','');
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@constlist,'     XDEF    '+no0(pdwn^.labelid)+'BitMap','');
    end;

  addline(@constlist,'','');
  addline(@constlist,no0(pdwn^.labelid)+':','');
  addline(@constlist,'    dc.l    0','');
      
      
  addline(@constlist,no0(pdwn^.labelid)+'VisualInfo:','');
  addline(@constlist,'    dc.l    0','');
      
  addline(@constlist,no0(pdwn^.labelid)+'DrawInfo:','');
  addline(@constlist,'    dc.l    0','');
  
      
  {
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@constlist,no0(pdwn^.labelid)+'BitMap:','');
      addline(@constlist,'    dc.l    0','');
          
    end;
  }
  
  if pdwn^.codeoptions[8] then
    begin
      addline(@constlist,'','');
      addline(@constlist,no0(pdwn^.labelid)+'MsgPort:','');
      addline(@constlist,'    dc.l    0','');
      
    end;

  
   
 if no0(pdwn^.screentitle)<>'' then
   begin
     if not pdwn^.localeoptions[4] then
       begin
         addline(@constlist,no0(pdwn^.labelid)+'ScreenTitle:','');
         addline(@constlist,'    dc.b    '''+no0(pdwn^.screentitle)+''',0','');
         if pdwn^.localeoptions[3] then
           addline(@constlist,'    cnop    0,2','');
       end
      else
       begin
         localestring(no0(pdwn^.screentitle),(no0(pdwn^.labelid))+
                          'ScreenTitle','Window: '+no0(pdwn^.title)+' Screen Title');
       end
   end;
  
  if not pdwn^.localeoptions[3] then
    begin
      addline(@constlist,no0(pdwn^.labelid)+'WindowTitle:','');
      addline(@constlist,'    dc.b    '''+no0(pdwn^.title)+''',0','');
      addline(@constlist,'    cnop    0,2','');
    end;

  
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      
      {
      addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'Gadgets','');
      }
      addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'GList','');
     
      
      str(pdwn^.nextid,s3);
      
      str(sizeoflist(@pdwn^.gadgetlist),s2);
      
      addline(@defineslist,(no0(pdwn^.labelid))+'FirstID        EQU '+s3,'');
    
    end;
  
  addline(@externlist,'    XREF    '+no0(pdwn^.labelid),'');
  addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'VisualInfo','');
  addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'DrawInfo','');
  
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'BitMap','');
  
  
  {
    MsgPort in a0
    Screen  in a1
    appwin  in a2,a3
    bitmap  in a4
    
  }
  
  
  addline(@procfunclist,'','');
  
  s:='Open'+(no0(pdwn^.labelid))+'Window';
  
  addline(@externlist,'    XREF    '+s,'');
  addline(@procfunclist,'    XDEF    '+s,'');
  addline(@procfunclist,s+':','');
  addline(@procfunclist,'    movem.l d1-d4/a0-a6,-(sp)','');
  
  if pdwn^.extracodeoptions[1] then
    if not pdwn^.extracodeoptions[2] then
      addline(@procfunclist,'    move.l  a4,'+no0(pdwn^.labelid)+'BitMap',
         'Copy bitmap as parameter in a4 into tag array as WA_SuperBitMap.');
  
  if pdwn^.codeoptions[8] then
    begin
      addline(@procfunclist,'    move.l  a0,'+no0(pdwn^.labelid)+'MsgPort','');
    end;
  
  if pdwn^.codeoptions[18] then
    begin
      addline(@constlist ,no0(pdwn^.labelid)+'AppWin:','');
      addline(@constlist ,'    dc.l    0','');
      
      addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'AppWin','');
      
      addline(@constlist ,no0(pdwn^.labelid)+'AppWinID:','');
      addline(@constlist ,'    dc.l    0','');
      
      addline(@procfunclist,'    move.l  a2,'+no0(pdwn^.labelid)+'AppWin','Store AppWindow msg port');
      addline(@procfunclist,'    move.l  a3,'+no0(pdwn^.labelid)+'AppWinID','Store AppWindow ID');
      
    end;
  
  
  
  { put var defns here }
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      addline(@constlist,'','');
      addline(@constlist,no0(pdwn^.labelid)+'BufNewGad:','');
      addline(@constlist,'    dc.w    0,0,0,0','');
      addline(@constlist,'    dc.l    0,0','');
      addline(@constlist,'    dc.w    0','');
      addline(@constlist,'    dc.l    0,0,0','');
    end;
  
  
  { end of var defns }
  
  if pdwn^.codeoptions[1] then
    begin
      
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+
              ',d0','See if window already open, if it is then move it to front etc and exit');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+
               'AlreadyOpen','');
    
    end;

  
  if pdwn^.localeoptions[1] then
    begin
      
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'FirstRun,d1',''); 
      addline(@procfunclist,'    tst.l   d1','');
      addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'RunBefore','');
      addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'FirstRun','');
      
    end;
  
  dogadgetbits(pdwn);
  
  
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      case pgn^.kind of
        palette_kind :
          begin
            if pgn^.tags[1].ti_data=0 then
              inc(count24);
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
            str(pgn^.id,s);
            temp:='';
            if length(no0(pgn^.labelid))<40 then
              temp:=copy('                                        ',1,40-length(no0(pgn^.labelid)));
            addline(@constlist,'GD_'+no0(pgn^.labelid)+temp+'    EQU    '+s,'');
            addline(@externlist,'GD_'+no0(pgn^.labelid)+temp+'    EQU    '+s,'');
            
            addline(@constlist,no0(pgn^.labelid)+temp+'       EQU    '+s,'');
            addline(@externlist,no0(pgn^.labelid)+temp+'       EQU    '+s,'');
            
            pgn:=pgn^.ln_succ;
          end;
        
        addline(@constlist,'','');
        
        
        pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
        while(pgn^.ln_succ<>nil) do
          begin
            str(pgn^.id-pdwn^.nextid,s);
            temp:='';
            if length(no0(pgn^.labelid))<40 then
              temp:=copy('                                        ',1,40-length(no0(pgn^.labelid)));
            
            addline(@externlist,'GDX_'+no0(pgn^.labelid)+temp+'   EQU    '+s,'');
           
            
            addline(@constlist,'GDX_'+no0(pgn^.labelid)+temp+'   EQU    '+s,'');
            
            pgn:=pgn^.ln_succ;
          end;
        
        
      
    end;
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    dogadgets(pdwn);  
  
  
  if pdwn^.localeoptions[1] then
    begin
      psn:=pstringnode(procfunclist.lh_tailpred);
      if no0(psn^.st)='    beq    '+no0(pdwn^.labelid)+'RunBefore' then
        begin
          
          psn:=pstringnode(remtail(@procfunclist));
          freemymem(psn);
          psn:=pstringnode(remtail(@procfunclist));
          freemymem(psn);
          psn:=pstringnode(remtail(@procfunclist));
          freemymem(psn);
          
        end
       else
        begin
          addline(@constlist,no0(pdwn^.labelid)+'FirstRun:','');
          addline(@constlist,'    dc.l    1','');
          addline(@procfunclist,no0(pdwn^.labelid)+'RunBefore:','');
        end;
    end;

  
  
  if pdwn^.usezoom then                                           {4}
    begin
      addline(@constlist,no0(pdwn^.labelid)+'ZoomInfo:','');;
      str(pdwn^.zoom[1],s2);
      s:=s2+',';
      str(pdwn^.zoom[2],s2);
      s:=s+s2;
      addline(@constlist,'    dc.w    '+s,'Initial zoom size');
      
      
      str(pdwn^.zoom[3],s);
      addline(@constlist,no0(pdwn^.labelid)+'ZoomInfo1:','');
      addline(@constlist,'    dc.w    '+s,'Initial zoom size');
      str(pdwn^.zoom[4],s);
      addline(@constlist,no0(pdwn^.labelid)+'ZoomInfo2:','');
      addline(@constlist,'    dc.w    '+s,'Initial zoom size');
      
    end;
  
    
  if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
    begin
      if pdwn^.pubscreenname then
        if no0(pdwn^.defpubname)='' then
          s:='a1'
         else
          begin
            addline(@constlist,'','');
            addline(@constlist,no0(pdwn^.labelid)+'PubScrName:','');
            addline(@constlist,'    dc.b    '''+no0(pdwn^.defpubname)+''',0','Default Public Screen Name');
            addline(@constlist,'    cnop    0,2','');
   
            addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'PubScrName,a1',
                                  'Get Public Screen Name');
            s:='a1'
          end
       else
        s:='#0';
      addline(@procfunclist,'    move.l  '+s+',a0','Sort out screen name pointer');
      addline(@procfunclist,'    move.l  _IntuitionBase,a6','Prepare for intuition call');
      addline(@procfunclist,'    jsr     LockPubScreen(a6)','Lock screen');
      if pdwn^.pubscreenname and pdwn^.pubscreenfallback then 
        begin
          addline(@procfunclist,'    tst.l   d0','PubScreenFallBackBit');
          addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'ScrennOK','');
          addline(@procfunclist,'    move.l  #0,a0','Try for default public screen');
          addline(@procfunclist,'    jsr     LockPubScreen(a6)','Lock screen');
          addline(@procfunclist,no0(pdwn^.labelid)+'ScrennOK:','');
        end;
      addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'Scr','Move screen address into tag');
      addline(@procfunclist,'    beq     No'+no0(pdwn^.labelid)+'Scr','Cannot lock screen');
    end
   else
    addline(@procfunclist,'    move.l  a1,'+no0(pdwn^.labelid)+'Scr','Put screen address in Win_Scr Tag');
  
{ CALCULATE OFFSETS }

  if pdwn^.innerw=0 then
    addline(@procfunclist,'    move.l  #'+fmtint(pdwn^.w)+','+no0(pdwn^.labelid)+'Width','')
   else
    addline(@procfunclist,'    move.l  #'+fmtint(pdwn^.innerw)+','+no0(pdwn^.labelid)+'IW+4','');
 
  if pdwn^.innerh=0 then
    addline(@procfunclist,'    move.l  #'+fmtint(pdwn^.h)+','+no0(pdwn^.labelid)+'Height','')
   else
    addline(@procfunclist,'    move.l  #'+fmtint(pdwn^.innerh)+','+no0(pdwn^.labelid)+'IH+4','');



  if pdwn^.codeoptions[17] then
    begin
      if pdwn^.usezoom then
      begin
      str(pdwn^.zoom[3],s);
      addline(@procfunclist,'    move.w  #'+s+',d0','Scale the Zoom width');
      addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
      addline(@procfunclist,'    move.w  d0,'+no0(pdwn^.labelid)+'ZoomInfo1','');
      str(pdwn^.zoom[4],s);
      addline(@procfunclist,'    move.w  #'+s+',d0','Scale the Zoom height');
      addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
      addline(@procfunclist,'    move.w  d0,'+no0(pdwn^.labelid)+'ZoomInfo2','');
      end;
      
      if pdwn^.innerw=0 then
        begin
          addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Width,d0','');
          addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
          addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'Width','');
        end
       else
        begin
          addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'IW+4,d0','');
          addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleX','');
          addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'IW+4','');
        end;
      
      if pdwn^.innerh=0 then
        begin
          addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Height,d0','');
          addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
          addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'Height','');
        end
       else
        begin
          addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'IH+4,d0','');
          addline(@procfunclist,'    jsr     '+no0(pdwn^.labelid)+'ScaleY','');
          addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'IH+4','');
        end;
      
    end;

  
  if pdwn^.codeoptions[9] and (not pdwn^.gimmezz) then
    begin
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Scr,a0','Copy screen into a0');
      addline(@procfunclist,'    move.b  36(a0),'+no0(pdwn^.labelid)+'Offx+1','Get left border width in Win_Offx');
      addline(@procfunclist,'    move.l  40(a0),a1','Put screen font structure address in a1');
      addline(@procfunclist,'    move.w  4(a1),d1','Put screen font ta_YSize in d1');
      addline(@procfunclist,'    addq.w  #1,d1','Add 1 to d1');
      addline(@procfunclist,'    move.b  35(a0),d0','Put screen window border top in d0');
      addline(@procfunclist,'    ext.w   d0','Turn d0 into word from byte');
      addline(@procfunclist,'    add.w   d1,d0','Get Offy in d0');
      addline(@procfunclist,'    move.w  d0,'+no0(pdwn^.labelid)+'Offy','Store Win_Offy');
      if pdwn^.innerh=0 then
        begin
          addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Height,d1','Get window height');
          addline(@procfunclist,'    add.w   d0,d1','Add offy');
          addline(@procfunclist,'    move.l  d1,'+no0(pdwn^.labelid)+'Height','Store window height');
        end;
      if pdwn^.innerw=0 then
        begin
          addline(@procfunclist,'    move.w  '+no0(pdwn^.labelid)+'Offx,d0','');
          addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Width,d1','Get window width');
          addline(@procfunclist,'    add.w   d0,d1','Add offx');
          addline(@procfunclist,'    move.l  d1,'+no0(pdwn^.labelid)+'Width','Store window width');
        end;
    end;

  
{ IF LacaleOptions[3] THEN get locale string }
  
  if pdwn^.localeoptions[3] then
    begin
      addline(@procfunclist,'    move.l  #'+no0(pdwn^.labelid)+'WindowTitle,d0','');
      addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
      addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'WT','');
      
      localestring(no0(pdwn^.title),(no0(pdwn^.labelid))+'WindowTitle','Window: '+no0(pdwn^.title)+' Title');
    
    end;
    
{ IF LacaleOptions[4] THEN get locale string }
  
  if pdwn^.localeoptions[4] and (no0(pdwn^.screentitle)<>'') then
    begin
      addline(@procfunclist,'    move.l  #'+no0(pdwn^.labelid)+'ScreenTitle,d0','');
      addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
      addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'ST','');
    end;


{ GET VISUALINFO }

  addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Scr,a0','Put Screen in a0');
  addline(@procfunclist,'    move.l  #0,a1','Put NULL in a1');
  addline(@procfunclist,'    move.l  _GadToolsBase,a6','Prepare for GadTools call');
  addline(@procfunclist,'    jsr     GetVisualInfoA(a6)','Get Visual Info');
  addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'VisualInfo','Store Visual Info');
  addline(@procfunclist,'    beq     CannotGet'+no0(pdwn^.labelid)+'VisualInfo','Cannot get VI');
  
{ GET DRAWINFO }

  addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Scr,a0','Put Screen in a0');
  addline(@procfunclist,'    move.l  _IntuitionBase,a6','Prepare for Intuition call');
  addline(@procfunclist,'    jsr     GetScreenDrawInfo(a6)','Get Visual Info');
  addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'DrawInfo','Store DrawInfo');
  addline(@procfunclist,'    beq     CannotGet'+no0(pdwn^.labelid)+'DrawInfo','Cannot get DrawInfo');
  
{ CREATE CONTEXT }  
  
  count:=sizeoflist(@pdwn^.gadgetlist);
  if (count>0) and (not pdwn^.codeoptions[5]) then
    addline(@procfunclist,no0(pdwn^.labelid)+'OpenBadGad:','');  {32}
  
  {****    ****    ****}
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    dogadgetloop(pdwn);

  
  {bitmap creation}
  
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      
      bitmaprequired:=true;
      
      addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'Scr,a1','');
      addline(@procfunclist,'    move.l  #0,d0','');
      addline(@procfunclist,'    move.b  189(a1),d0','Put Screen Depth in d0');
      addline(@procfunclist,'    move.l  #'+fmtint(pdwn^.maxw)+',d1','Width');
      addline(@procfunclist,'    move.l  #'+fmtint(pdwn^.maxh)+',d2','Height');
      addline(@procfunclist,'    jsr     AllocBitMap','');
      
      addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'BitMap','');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    beq     No'+no0(pdwn^.labelid)+'BitMap','');
    
    end;
  
  { do window opening stuff }
  
  str(PDWN^.IDCMPVALUES,s);
  
  
  {
  s:=spaces+'if (NULL != ('+no0(pdwn^.labelid)+' = OpenWindowTags( NULL, ';
  addline(@procfunclist,s,'');
  }
  
{ OPEN WINDOW }
  
  addline(@procfunclist,'    move.l  #0,a0','');
  addline(@procfunclist,'    lea     '+no0(pdwn^.labelid)+'Tags,a1','');
  addline(@procfunclist,'    move.l  _IntuitionBase,a6','');
  addline(@procfunclist,'    jsr     OpenWindowTagList(a6)','');
  
  
 
  addline(@constlist,'    cnop    0,2','');
  
  s3:='    dc.l    ';
  addline(@constlist,'','');
  
  addline(@constlist,'    XDEF    '+no0(pdwn^.labelid)+'Offx','');
  addline(@constlist,'    XDEF    '+no0(pdwn^.labelid)+'Offy','');
      
  addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'Offx','');
  addline(@externlist,'    XREF    '+no0(pdwn^.labelid)+'Offy','');
       
  
  if pdwn^.codeoptions[9] and (not pdwn^.gimmezz) then
    begin
      addline(@constlist,no0(pdwn^.labelid)+'Offx:','Window X offset');
      addline(@constlist,'    dc.w    0','');
      addline(@constlist,no0(pdwn^.labelid)+'Offy:','Window Y Offset');
      addline(@constlist,'    dc.w    0','');
    end
   else
    begin
      addline(@constlist,no0(pdwn^.labelid)+'Offx:','');
      addline(@constlist,'    dc.w    '+fmtint(pdwn^.offx),'Constant Offx');
      addline(@constlist,no0(pdwn^.labelid)+'Offy:','');
      addline(@constlist,'    dc.w    '+fmtint(pdwn^.offy),'Constant Offy');
    end;
  
  addline(@constlist,'','');
  addline(@constlist,no0(pdwn^.labelid)+'Tags:','');
  
  addline(@constlist,s3+'$80000064,'+fmtint(pdwn^.x),'WA_Left');  {37}
  s:=s3;
  addline(@constlist,s3+'$80000065,'+fmtint(pdwn^.y),'WA_Top');  {37}
  if pdwn^.innerw=0 then
    begin
      addline(@constlist,s3+'$80000066',''); {37}
      addline(@constlist,no0(pdwn^.labelid)+'Width:',''); {37}
      str(pdwn^.w,s2);
      addline(@constlist,s3+s2,'') {37}
    end
   else
    begin
      str(pdwn^.innerw,s2);
      addline(@constlist,no0(pdwn^.labelid)+'IW:','');
      addline(@constlist,s3+'$80000076,'+s2,'WA_InnerWidth');
    end;
  
  if pdwn^.innerh=0 then
    begin
      addline(@constlist,s3+'$80000067','');
      addline(@constlist,no0(pdwn^.labelid)+'Height:',''); {37}
      str(pdwn^.h,s2);
      addline(@constlist,s3+s2,'WA_Height');  {41}
    end
   else
    begin
      str(pdwn^.innerh,s2);
      addline(@constlist,no0(pdwn^.labelid)+'IH:','');  {42}
      addline(@constlist,s3+'$80000077,'+s2,'WA_InnerHeight')  {42}
    end;
  
  {
  if no0(pdwn^.title)<>'' then
    begin
  }
  
  addline(@constlist,s3+'$8000006E','WA_Title'); 
  addline(@constlist,no0(pdwn^.labelid)+'WT:','');  {43}
  
  if pdwn^.localeoptions[3] then
    s:='0'
   else
    s:=no0(pdwn^.labelid)+'WindowTitle';

  addline(@constlist,s3+s,'Window Title');  {43}
  
  {
    end;
  }
  
  if no0(pdwn^.screentitle)<>'' then
    begin
      addline(@constlist,s3+'$8000006F','WA_ScreenTitle');  {44}
      addline(@constlist,no0(pdwn^.labelid)+'ST:','');
         
      if pdwn^.localeoptions[4] then
        s:='0'
       else
        s:=no0(pdwn^.labelid)+'ScreenTitle';
      
      addline(@constlist,s3+''+s,'Screen Title');  {44}
      
    end;
  
  addline(@constlist,s3+'$80000072,'+fmtint(pdwn^.minw),'WA_MinWidth'); {45}
  addline(@constlist,s3+'$80000073,'+fmtint(pdwn^.minh),'WA_MinHeight'); {46}
  addline(@constlist,s3+'$80000074,'+fmtint(pdwn^.maxw),'WA_MaxWidth'); {47}
  addline(@constlist,s3+'$80000075,'+fmtint(pdwn^.maxh),'WA_MaxHeight'); {48}
  
  loop:=11;
  if pdwn^.sizegad then
    begin
      addline(@constlist,s3+'$80000081,1','WA_SizeGadget,True'); {49}
      if (pdwn^.sizebright)and(pdwn^.sizebbottom) then
        begin
          addline(@constlist,s3+'$8000008E,1','WA_SizeBRight,True'); {50}
        end;
      if pdwn^.sizebbottom then
        begin
          addline(@constlist,s3+'$8000008F,1','WA_SizeBBottom,True'); {51}
        end;
    end;
  
  if pdwn^.dragbar then 
    addline(@constlist,s3+'$80000082,1','WA_DragBar,True');     {52}
  if pdwn^.Depthgad then
    addline(@constlist,s3+'$80000083,1','WA_DepthGadget,True'); {53}
  if pdwn^.CloseGad then
    addline(@constlist,s3+'$80000084,1','WA_CloseGadget,True'); {54}
  if pdwn^.reportmouse then
    addline(@constlist,s3+'$80000086,1','WA_ReportMouse,True'); {55}
  
  if pdwn^.NoCareRefresh then
    addline(@constlist,s3+'$80000087,1','WA_NoCareRefresh,True'); {56}
  if pdwn^.borderless then
    addline(@constlist,s3+'$80000088,1','WA_BorderLess,True'); {57}
  if pdwn^.backdrop then
    addline(@constlist,s3+'$80000085,1','WA_BackDrop,True'); {58}
  if pdwn^.gimmezz then
      addline(@constlist,s3+'$80000091,1','WA_GimmeZeroZero,True'); {59}
  if pdwn^.Activate then
    addline(@constlist,s3+'$80000089,1','WA_Activate,True'); {60}
  if pdwn^.RMBTrap then
    addline(@constlist,s3+'$8000008A,1','WA_RMBTrap,True'); {61}
  
  if pdwn^.moretags[1] then
    addline(@constlist,s3+'$80000093,1','WA_NewLookMenus,True'); {61}
  if pdwn^.moretags[2] then
    addline(@constlist,s3+'$80000095,1','WA_NotifyDepth,True'); {61}
  if pdwn^.moretags[3] then
    addline(@constlist,s3+'$8000009A,1','WA_TabletMessages,True'); {61}
  
  if pdwn^.SimpleRefresh then
    addline(@constlist,s3+'$8000008C,1','WA_SimpleRefresh,True'); {62}
  if pdwn^.Smartrefresh then
    addline(@constlist,s3+'$8000008D,1','WA_SmartRefresh,True'); {63}
  if pdwn^.autoadjust then
    addline(@constlist,s3+'$80000090,1','WA_AutoAdjust,True'); {64}
  if pdwn^.MenuHelp then
    addline(@constlist,s3+'$80000092,1','WA_MenuHelp,True'); {65}
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      addline(@constlist,s3+'$8000006C','WA_Gadgets'); {66}
      addline(@constlist,no0(pdwn^.labelid)+'GList:',''); {66}
      addline(@constlist,s3+'0','WA_Gadgets'); {66}
    end;
  
  
  if pdwn^.extracodeoptions[1] then
    begin
      addline(@constlist,s3+'$80000071','WA_SuperBitMap Tag');
      addline(@constlist,no0(pdwn^.labelid)+'BitMap:','WA_SuperBitMap Label');
      addline(@constlist,s3+'0','WA_SuperBitMap Data');
    end;
  
  if pdwn^.usezoom then
    addline(@constlist,s3+'$8000007D,'+no0(pdwn^.labelid)+'ZoomInfo','WA_Zoom'); {67}
  if pdwn^.mousequeue<>5 then
    addline(@constlist,s3+'$8000007E,'+fmtint(pdwn^.mousequeue),'WA_MouseQueue'); {68}
  if pdwn^.rptqueue<>3 then
    addline(@constlist,s3+'$80000080,'+fmtint(pdwn^.rptqueue),'WA_RptQueue');
  
  {
  if pdwn^.pubscreenfallback and pdwn^.pubscreenname then
    addline(@constlist,s3+'$8000007A,1','WA_PubScreenFallBack,True');
  }
  
  {************************* here we go }
  
  if (pdwn^.customscreen) then
    begin
      addline(@constlist,s3+'$80000070','WA_CustomScreen Split over two lines so label is at right place');
      addline(@constlist,no0(pdwn^.labelid)+'Scr:',''); {69}
      addline(@constlist,s3+'0',''); {69}
    end
   else
    if (pdwn^.pubscreen) then
      begin
        addline(@constlist,s3+'$80000079','WA_PubScreen Split over two lines so label is at right place'); {69}
        addline(@constlist,no0(pdwn^.labelid)+'Scr:',''); {69}
        addline(@constlist,s3+'0',''); {69}
      end
     else
      if (pdwn^.pubscreenname) then
        begin
          addline(@constlist,s3+'$80000079',
            'WA_PubScreen Split over two lines so label is at right place (used name to get it) '); {69}
          addline(@constlist,no0(pdwn^.labelid)+'Scr:',''); {69}
          addline(@constlist,s3+'0',''); {69}
        end
       else
        begin
          addline(@constlist,s3+'$80000079','WA_PubScreen Split over two lines so label is at right place'); {69}
          addline(@constlist,no0(pdwn^.labelid)+'Scr:','(Using default screen)'); {69}
          addline(@constlist,s3+'0',''); {69}
        end;
    
  {* * * * * * * * * * * * * * * * * *}
  
  for loop6:=1 to 25 do
    if pdwn^.idcmplist[loop6] then
      pdwn^.idcmpvalues:=pdwn^.idcmpvalues or idcmpnum[Loop6];
  
  if not pdwn^.codeoptions[8] then
    begin
      str(loop,s);
      str(pdwn^.idcmpvalues,s2);
      addline(@constlist,s3+'$8000006A,'+s2,'WA_IDCMP'); {71}
      inc(loop);
    end;
  addline(@constlist,s3+'0','TAG_END'); {72}
  addline(@constlist,'','');
  {open window here}
  
{ just called openwindowtaglist}
{TEST d0 }
  
  addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid),'Store result');
  addline(@procfunclist,'    tst.l   d0','');
  addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'CannotOpenWin','Fail and tidy up if cannot open window');
  
  
  
  {** ** ** ** ** ** ** ** ** **}
  
  if pdwn^.codeoptions[8] then
    begin
      
      
      str(pdwn^.idcmpvalues,s2);
      {
      addline(@procfunclist,spaces+no0(pdwn^.labelid)+'->UserPort = mp;','');
      addline(@procfunclist,spaces+'ModifyIDCMP( '+no0(pdwn^.labelid)+', '+s2+');','');
      }
      
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',a0','');
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'MsgPort,a1','');
      addline(@procfunclist,'    move.l  a1,86(a0)','');
      addline(@procfunclist,'    move.l  #'+s2+',d0','');
      addline(@procfunclist,'    move.l  _IntuitionBase,a6','');
      addline(@procfunclist,'    jsr     ModifyIDCMP(a6)','');
      
    end;
  {
  if pdwn^.codeoptions[18] then
    addline(@procfunclist,spaces+no0(pdwn^.labelid)+
                          'AppWin = AddAppWindowA( awid, 0, '+no0(pdwn^.labelid)+', awmp, NULL);','');
  }
  
  loop:=sizeoflist(@pdwn^.textlist);
  loop6:=sizeoflist(@pdwn^.imagelist);
  if sizeoflist(@pdwn^.bevelboxlist)+loop+loop6+sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@procfunclist,'    jsr     Rend'+no0(pdwn^.labelid)+'Window','');
  
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',a1','Refresh Window, put win in a0');
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'GList,a0','Refresh Window, put glist in a0');
      addline(@procfunclist,'    move.l  #0,a2','');
      addline(@procfunclist,'    move.l  #$FFFF,d0','');
      addline(@procfunclist,'    move.l  _IntuitionBase,a6','Prepare for Intuition call');
      addline(@procfunclist,'    jsr     RefreshGList(a6)','Call RefreshGList');
      
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',a0','Refresh Window, put win in a0');
      addline(@procfunclist,'    move.l  #0,a1','Clear a1');
      addline(@procfunclist,'    move.l  _GadToolsBase,a6','Prepare for GadTools call');
      addline(@procfunclist,'    jsr     GT_RefreshWindow(a6)','Call GT_RefreshWindow');
              
    end;
  
  loop:=0;
  ptn:=ptextnode(pdwn^.textlist.mlh_head);
  while (ptn^.ln_succ<>nil) do
    begin
      if true then
        inc(loop);
      ptn:=ptn^.ln_succ;
    end;
  loop6:=0;
  psin:=psmallimagenode(pdwn^.imagelist.mlh_head);
  while (psin^.ln_succ<>nil) do
    begin
      inc(loop6);
      psin:=psin^.ln_succ;
    end;
  
  s:=no0(pdwn^.labelid)+', '+no0(pdwn^.labelid)+'VisualInfo ';
  
  
  {open menu?}
  
  if pdwn^.codeoptions[18] then
    begin
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'AppWin,d0','');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'NoAppMsgPort','');
      addline(@procfunclist,'    movea.l d0,a1','');
      addline(@procfunclist,'    move.l  _WorkbenchBase,a6','');
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'AppWinID,d0','');
      addline(@procfunclist,'    move.l  #0,d1','');
      addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+',a0','');
      addline(@procfunclist,'    movea.l #0,a2','');
      addline(@procfunclist,'    jsr     AddAppWindowA(a6)','');
      addline(@procfunclist,'    move.l  d0,'+no0(pdwn^.labelid)+'AppWin','Check Win_AppWin to see if succesfully created.');
      addline(@procfunclist,no0(pdwn^.labelid)+'NoAppMsgPort:','');
    end;

  
  if pdwn^.codeoptions[11] then
    begin
      if pdwn^.codeoptions[12] then
        begin
          addline(@procfunclist,'    move.l  '+no0(pdwn^.menutitle)+',d0','');
          addline(@procfunclist,'    tst.l   d0','');
          addline(@procfunclist,'    bne     '+no0(pdwn^.labelid)+'MenuAlreadyOpen','');
          addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'VisualInfo,a0','');
          addline(@procfunclist,'    jsr     MakeMenu'+no0(pdwn^.menutitle),'');
          
          addline(@procfunclist,no0(pdwn^.labelid)+'MenuAlreadyOpen:','');
          
        end; 
      
      addline(@procfunclist,'    move.l  '+no0(pdwn^.menutitle)+',d0','');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    beq     '+no0(pdwn^.labelid)+'MenuNotOpen','');
      
      
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',a0','');
      addline(@procfunclist,'    move.l  '+no0(pdwn^.menutitle)+',a1','');
      
      addline(@procfunclist,'    move.l  _IntuitionBase,a6','');
      
      addline(@procfunclist,'    jsr     SetMenuStrip(a6)',''); {87}
      
      addline(@procfunclist,'    move.l  #0,d0','');
      
      if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
        addline(@procfunclist,'    jmp      Unlock'+no0(pdwn^.labelid)+'Screen','')
       else
        addline(@procfunclist,'    jmp      Open'+no0(pdwn^.labelid)+'Done','');
      
      addline(@procfunclist,no0(pdwn^.labelid)+'MenuNotOpen:',''); {86}
      
      if (pdwn^.codeoptions[13]) then
        begin
          
          addline(@procfunclist,'    jsr     Close'+no0(pdwn^.labelid)+'Window',''); {87}
          
          addline(@procfunclist,'    move.l  #32,d0','');
          
          if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
            addline(@procfunclist,'    jmp      Unlock'+no0(pdwn^.labelid)+'Screen','')
           else
            addline(@procfunclist,'    jmp      Open'+no0(pdwn^.labelid)+'Done','');
        end
    end;
  
  {10101}
  
{Open a success, everything fine}

{SET return code of 0}

  addline(@procfunclist,'    move.l  #0,d0','');
  if not pdwn^.customscreen then
    addline(@procfunclist,'    jmp      Unlock'+no0(pdwn^.labelid)+'Screen','')
   else
    addline(@procfunclist,'    jmp      Open'+no0(pdwn^.labelid)+'Done','');
      
  {** ** ** ** ** ** ** ** ** **}
  {handle open fail}
  
  {* * * * * * * * * * * * * * * * * *}
  
  {****    ****    ****}
  
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      
      addline(@procfunclist,'No'+no0(pdwn^.labelid)+'BitMap:','');
      addline(@procfunclist,'    move.l #64,d0','Set return code');
      addline(@procfunclist,'    jmp    Free'+no0(pdwn^.labelid)+'Gadgets','Leave tidily');
      if sizeoflist(@pdwn^.gadgetlist)>0 then
        addline(@procfunclist,'    jmp      Free'+no0(pdwn^.labelid)+'Gadgets','')
       else
        addline(@procfunclist,'    jmp      Free'+no0(pdwn^.labelid)+'VisualInfo','');
  
    end;
  
  {**************************************************}
  
  if pdwn^.codeoptions[1] then
    begin
      addline(@procfunclist,no0(pdwn^.labelid)+'AlreadyOpen:','');
        begin
          if pdwn^.codeoptions[2] or pdwn^.codeoptions[3] then
            begin
              addline(@procfunclist,'    move.l  _IntuitionBase,a6','Prepare for intuition call');
              addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+',a0','Window open so...')
            end;
          if pdwn^.codeoptions[3] then
            addline(@procfunclist,'    jsr     ActivateWindow(a6)','Activate Window');
          if pdwn^.codeoptions[2] then
            addline(@procfunclist,'    jsr     WindowToFront(a6)','Move window to front');
          if (pdwn^.codeoptions[7]) then
            addline(@procfunclist,'    move.l  #1,d0','Return failed because window already open')
           else
            addline(@procfunclist,'    move.l  #0,d0','Return OK because window already open');
        end;
      addline(@procfunclist,'    jmp     Open'+no0(pdwn^.labelid)+'Done','')
    end;
  
  addline(@procfunclist,no0(pdwn^.labelid)+'CannotOpenWin:','');
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'BitMap,a0','');
      addline(@procfunclist,'    jsr     FreeBitMap','Free memory');
    end;
  
  addline(@procfunclist,'    move.l  #1,d0','');
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@procfunclist,'    jmp      Free'+no0(pdwn^.labelid)+'Gadgets','')
   else
    addline(@procfunclist,'    jmp      Free'+no0(pdwn^.labelid)+'DrawInfo','');
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      if pdwn^.codeoptions[5] then
        begin
          addline(@procfunclist,no0(pdwn^.labelid)+'BadGadgets:','');
          addline(@procfunclist,'    move.l   #2,d0','');
        end;
      
      addline(@procfunclist,'Free'+no0(pdwn^.labelid)+'Gadgets:','');
      addline(@procfunclist,'    move.l  d0,d2','');
      addline(@procfunclist,'    move.l  _GadToolsBase,a6','');
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'GList,a0','');
      addline(@procfunclist,'    jsr     FreeGadgets(a6)','');
      addline(@procfunclist,'    move.l  d2,d0','');
      addline(@procfunclist,'    jmp     Free'+no0(pdwn^.labelid)+'DrawInfo','');
      
      addline(@procfunclist,'CannotCreate'+no0(pdwn^.labelid)+'Context:','');
      addline(@procfunclist,'    move.l  #4,d0','');
    end;
 
  
  
  addline(@procfunclist,'Free'+no0(pdwn^.labelid)+'DrawInfo:','');
  addline(@procfunclist,'    move.l  d0,d2','');
  addline(@procfunclist,'    movea.l _IntuitionBase,a6','');
  addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'Scr,a0','');
  addline(@procfunclist,'    movea.l '+no0(pdwn^.labelid)+'DrawInfo,a1','');
  addline(@procfunclist,'    jsr     FreeScreenDrawInfo(a6)','');
  addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'DrawInfo','');
  addline(@procfunclist,'    move.l  d2,d0','');
  addline(@procfunclist,'    jmp     Free'+no0(pdwn^.labelid)+'VisualInfo','');
  
  
  addline(@procfunclist,'CannotGet'+no0(pdwn^.labelid)+'DrawInfo:','');
  addline(@procfunclist,'    move.l  #128,d0','');
  
  addline(@procfunclist,'Free'+no0(pdwn^.labelid)+'VisualInfo:','');
  addline(@procfunclist,'    move.l  d0,d2','');
  addline(@procfunclist,'    move.l  _GadToolsBase,a6','');
  addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'VisualInfo,a0','');
  addline(@procfunclist,'    jsr     FreeVisualInfo(a6)','');
  addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'VisualInfo','');
  addline(@procfunclist,'    move.l  d2,d0','');
  if (not pdwn^.customscreen) then
    addline(@procfunclist,'    jmp     Unlock'+no0(pdwn^.labelid)+'Screen','')
   else
    addline(@procfunclist,'    jmp     Open'+no0(pdwn^.labelid)+'Done','');
  
  
  addline(@procfunclist,'CannotGet'+no0(pdwn^.labelid)+'VisualInfo:','');
  addline(@procfunclist,'    move.l  #8,d0','');
  if ( pdwn^.customscreen ) then
    addline(@procfunclist,'    jmp     Open'+no0(pdwn^.labelid)+'Done','');
      
  
  
  if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
    begin
      addline(@procfunclist,'Unlock'+no0(pdwn^.labelid)+'Screen:','');
      addline(@procfunclist,'    move.l  d0,d2','');
      addline(@procfunclist,'    move.l  _IntuitionBase,a6','');
      addline(@procfunclist,'    move.l  #0,a0','');
      addline(@procfunclist,'    move.l  '+no0(pdwn^.labelid)+'Scr,a1','');
      addline(@procfunclist,'    jsr     UnlockPubScreen(a6)','');
      addline(@procfunclist,'    move.l  #0,'+no0(pdwn^.labelid)+'Scr','');
      addline(@procfunclist,'    move.l  d2,d0','');
      addline(@procfunclist,'    jmp     Open'+no0(pdwn^.labelid)+'Done','');
      
      addline(@procfunclist,'No'+no0(pdwn^.labelid)+'Scr:','Could not lock screen');
      addline(@procfunclist,'    move.l  #16,d0','Set return code of 16');
    end;
  addline(@procfunclist,'Open'+no0(pdwn^.labelid)+'Done:','Finish openwindow');
  addline(@procfunclist,'    movem.l (sp)+,d1-d4/a0-a6','Restore Registers');
  addline(@procfunclist,'    rts','Return');
  
  processclosewindow(pdwn);
  if producernode^.codeoptions[3] then
    processwindowidcmp(pdwn);
  comment:=producernode^.codeoptions[1];
end;

procedure writelisttofile(pl:plist;fl:bptr);
var 
  psn : pstringnode;
begin
  psn:=pstringnode(pl^.lh_head);
  while (psn^.ln_succ<>nil)and(oksofar) do
    begin
      if 0<>fputs(fl,@psn^.st[1]) then
        oksofar:=false;
      if 10=fputc(fl,10) then;
      psn:=psn^.ln_succ;
    end;
end;

procedure processimage(pin:pimagenode);
var
  datasize   : long;
  s          : string;
  currentpos : long;
  pwa        : pwordarray;
  st         : string;
  loop       : word;
  s2         : string;
  s4         : string;
begin
  if pin^.colourmap<>nil then
    begin
      addline(@constlist,'','');
      str(pin^.mapsize div 2,s);
      
      addline(@constlist,'    XDEF    '+sfp(pin^.in_label)+'Colours','');
      addline(@externlist,'    XREF    '+sfp(pin^.in_label)+'Colours','');
    
      addline(@constlist,sfp(pin^.in_label)+'Colours:','Use LoadRGB4 to use this');
      s:='    ';
      for loop:=0 to (pin^.mapsize div 2)-1 do
        begin
          str(pin^.colourmap^[loop],s2);
          s:=s+s2;
          if loop=(pin^.mapsize div 2 )-1then
            begin
              addline(@constlist,'    dc.w'+s,'');
            end
           else
            if length(s)>80 then
              begin
                addline(@constlist,'    dc.w'+s,'');
                s:='    ';
              end
             else
              s:=s+',';
        end;
    end;
  addline(@constlist,'','');
  if  oksofar then
    begin
      {constlist}
      datasize:=trunc((pin^.width+15)/16)*pin^.height*pin^.depth;
      str(datasize,s);
      
      s4:=s;
      
      addline(@constlist,'    XDEF    '+sfp(pin^.in_label)+'Data','');
      addline(@externlist,'    XREF    '+sfp(pin^.in_label)+'Data',''); 
      
      addline(@constlist,sfp(pin^.in_label)+'Data:','');
      if oksofar then
        begin
          pwa:=pwordarray(pin^.imagedata);
          currentpos:=1;
            begin
              st:='    ';
              repeat
                str(pwa^[currentpos],s);
                if length(st+s)>79 then   {allowing for comma}
                  begin
                    dec(st[0]);
                    if oksofar then
                      addline(@constlist,'    dc.w'+st,'');
                    if (linecount div 19)*19=linecount then
                      begin
                        setlinenumber;
                        oksofar:=checkinput;
                      end;
                    st:='    ';
                  end;
                if oksofar then
                  begin
                    st:=st+s;
                    if currentpos<>datasize then
                      st:=st+','
                     else
                      begin
                        if oksofar then
                          addline(@constlist,'    dc.w'+st,'');
                        if (linecount div 19)*19=linecount then
                          begin
                            setlinenumber;
                            oksofar:=checkinput;
                          end;
                      end;
                  end;
                inc(currentpos);
              until (not oksofar) or (currentpos>datasize);
            end;
        end;
    end;
end;

function no0(s:string):string;
var
  str : string;
begin
  str:=s;
  while (str[length(str)]=#0)and(length(str)>0) do
    dec(str[0]);
  no0:=str;
end;

procedure printlisttoscreen(pl:plist);
var
  psn : pstringnode;
begin
  psn:=pstringnode(pl^.lh_head);
  while(psn^.ln_succ<>nil) do
    begin
      writeln(psn^.st);
      psn:=psn^.ln_succ;
    end;
end;

function allocmymem(size:long;typ:long):pointer;
var 
  t : pointer;
begin
  t:=allocvec(size,typ);
  allocmymem:=t;
  if t<>nil then
    inc(memused);
end;

function duplicate(n : word,c:char):string;
var
  s : string;
begin
  s:='';
  while n>0 do
    begin
      dec(n);
      s:=s+c;
    end;
  duplicate:=s;
end;

procedure freelist(pl:plist);
var
  pn : pnode;
begin
  pn:=remhead(pl);
  while (pn<>nil) do
    begin
      freemymem(pn);
      pn:=remhead(pl);
    end;
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

function getnthnode(ph:plist;n:word):pnode;
var
  temp : pnode;
begin
  temp:=pnode(ph^.lh_head);
  while (n>0) and (temp^.ln_succ<>nil) do
    begin
      dec(n);
      temp:=temp^.ln_succ;
    end;
  getnthnode:=temp;
end;

procedure settagitem(pt :ptagitem;t,d:long);
begin
  pt^.ti_tag:=t;
  pt^.ti_data:=d;
end;

procedure printstring(pwin:pwindow;x,y:word;s:string;n,m:byte;font:pointer);
var
  mit : tintuitext;
  str : string;
begin
  str:=s+#0;
  with mit do
    begin
      frontpen:=n;
      backpen:=m;
      leftedge:=x;
      topedge:=y;
      itextfont:=font;
      drawmode:=jam1;
      itext:=@str[1];
      nexttext:=nil;
    end;
  printitext(pwin^.rport,@mit,0,0);
end;

function generalgadtoolsgad(kind         : long;
                            x,y,w,h,id   : word;
                            ptxt         : pbyte;
                            font         : ptextattr;
                            flags        : long;
                            visinfo      : pointer;
                            pprevgad     : pgadget;
                            userdata     : pointer;
                            taGList      : ptagitem
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
  generalgadtoolsgad:=creategadgeta(kind,pprevgad,@newgad,taGList)
end;

procedure addprocstripintuimessages;
const
  procdef:array[1..25] of string[30]=
  (
  '',
  'StripIntuiMessages:',
  '    movem.l d0/a0-a6,-(sp)',
  '    movea.l a0,a2',
  '    movea.l 86(a0),a0',       { get userport from win }
  '    movea.l 20(a0),a0',       { first message }
  'StripLoop:',
  '    movea.l (a0),a3',         {get succ in a1}
  '    move.l  a3,d0',
  '    tst.l   d0',
  '    beq     EndStrip',
  '    cmpa.l  44(a0),a2',
  '    bne     StripSkip',
  '    movea.l a0,a4',
  '    movea.l a0,a1',
  '    movea.l _SysBase,a6',
  '    jsr     Remove(a6)',
  '    movea.l a4,a1',
  '    jsr     ReplyMsg(a6)',
  'StripSkip:',
  '    movea.l a3,a0',
  '    jmp     StripLoop',
  'EndStrip:',
  '    movem.l  (sp)+,d0/a0-a6',
  '    rts'
  );
var
  loop : word;
begin
  if not procstripintuimessagesadded then
    begin
      for loop:=1 to 25 do
        addline(@procfunclist,procdef[loop],'');
    end;
  procstripintuimessagesadded:=true;
end;

procedure addprocclosewindowsafely;
const
  procdef : array[1..20] of string[40]=
  (
  '',
  'CloseWindowSafely:',
  '    movem.l d0/a0/a4/a6,-(sp)',
  '    move.l  a0,a4',
  '    move.l  _SysBase,a6',
  '    jsr     Forbid(a6)',
  '    move.l  a4,a0',
  '    jsr     StripIntuiMessages',
  '    move.l  #0,86(a0)',
  '    move.l  _IntuitionBase,a6',
  '    move.l  #0,d0',
  '    move.l  a4,a0',
  '    jsr     ModifyIDCMP(a6)',
  '    move.l  _SysBase,a6',
  '    jsr     Permit(a6);',
  '    move.l  a4,a0',
  '    move.l  _IntuitionBase,a6',
  '    jsr     CloseWindow(a6)',
  '    movem.l (sp)+,d0/a0/a4/a6',
  '    rts'
  );
var
  loop : word;
begin
  if not procclosewindowsafelyadded then
    begin
      addline(@procfunclist,'    XDEF    CloseWindowSafely','Window in a0');
      for loop:=1 to 20 do
        addline(@procfunclist,procdef[loop],'');
      addline(@externlist,'    XREF    CloseWindowSafely','Window in a0');
    end;
  procclosewindowsafelyadded:=true;
end;

procedure makemainfilelist;
var
  loop : byte;
  pdwn : pdesignerwindownode;
  pdsn : pdesignerscreennode;
begin
  pdwn:=pdesignerwindownode(producernode^.windowlist.mlh_head);
  addline(@mainfilelist,'','');
  
  addline(@mainfilelist,'GT_ReplyIMsg             EQU    -78','');
  addline(@mainfilelist,'GT_GetIMsg               EQU    -72','');
  addline(@mainfilelist,'WaitPort                 EQU    -384','');
  addline(@mainfilelist,'ItemAddress              EQU    -144','');
  addline(@mainfilelist,'GT_BeginRefresh          EQU    -90','');
  addline(@mainfilelist,'GT_EndRefresh            EQU    -96','');
  addline(@mainfilelist,'CloseScreen              EQU    -66','');
    
  addline(@mainfilelist,'','');
      
  if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) then
    begin
      
      addline(@mainfilelist,'Scr:','To store screen in once opened');
      addline(@mainfilelist,'    dc.l    0','');
      addline(@mainfilelist,'','');
  
    end;
  
  
  addline(@mainfilelist,'start','');
  addline(@mainfilelist,'','');
  
  if (producernode^.codeoptions[4]) then
    begin
      addline(@mainfilelist,'    jsr     OpenLibs','Open libraries');
      addline(@mainfilelist,'    tst.l   d0','Test result');
      addline(@mainfilelist,'    bne     NoLibs','If cannot open the exit');
    end;
  
  if producernode^.localecount>0 then
    begin
      addline(@mainfilelist,'    movea.l #0,a0','Must Zero a0,a1');
      addline(@mainfilelist,'    movea.l #0,a1','Unless you want to choose the language');
      addline(@mainfilelist,'    jsr     Open'+sfp(producernode^.basename)+'Catalog','Open locale catalog');
    end;
  
  if producernode^.codeoptions[6] then
    begin
      addline(@mainfilelist,'    jsr     OpenDiskFonts','Open the diskfonts needed');
    end;
  
  if (sizeoflist(plist(@producernode^.imagelist))>0) then
    begin
      addline(@mainfilelist,'    jsr     MakeImages','Try to allocate images');
      addline(@mainfilelist,'    tst.l   d0','See if allocated immages');
      addline(@mainfilelist,'    bne     NoImages','If failed then exit');
    end;
  
  if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) then
    begin
      pdsn:=pdesignerscreennode(producernode^.screenlist.mlh_head);
      addline(@mainfilelist,'    jsr     Open'+sfp(pdsn^.sn_label)+'Screen','Open the screen');
      addline(@mainfilelist,'    tst.l   d0','Test if open');
      addline(@mainfilelist,'    beq     NoScreen','Fail if unopened');
      addline(@mainfilelist,'    move.l  d0,Scr','Store result');
    end;
  
  
  if sizeoflist(plist(@producernode^.windowlist))>0 then
    begin
      
      if pdwn^.codeoptions[8] then
        begin
          addline(@mainfilelist,'    movea.l #0,a0','Put message port in here');
        end;

      if pdwn^.pubscreen or pdwn^.customscreen or (pdwn^.pubscreenname and (no0(pdwn^.defpubname)='')) then
        begin
          if pdwn^.customscreen and (producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) ) then
            addline(@mainfilelist,'    movea.l Scr,a1','Put opened screen in here')
           else
            addline(@mainfilelist,'    movea.l #0,a1','Put Screen in here');
        end;
      
      if pdwn^.codeoptions[18] then
        begin
          addline(@mainfilelist,'    movea.l #0,a2','Put Parameters for appwindow in a2,a3');
          addline(@mainfilelist,'    movea.l #0,a3','a2=msgport,a3=id');
        end;
      
      if pdwn^.extracodeoptions[1] and (not pdwn^.extracodeoptions[2]) then
        addline(@mainfilelist,'    movea.l #0,a4','Put BitMap in a4 for SuperBitMap Window');
      
      addline(@mainfilelist,'    jsr     Open'+(no0(pdwn^.labelid))+'Window','Open window');
      addline(@mainfilelist,'    tst.l   d0','Test window');
      addline(@mainfilelist,'    bne     NoWindow','If window not open then fail');
      addline(@mainfilelist,'WaitHere:','');
      addline(@mainfilelist,'    move.l  '+no0(pdwn^.labelid)+',a1','Get win address');
      addline(@mainfilelist,'    move.l  86(a1),a2','Get message port');
      addline(@mainfilelist,'    move.l  a2,a0','');
      addline(@mainfilelist,'    move.l  _SysBase,a6','Prepare for system call');
      addline(@mainfilelist,'    jsr     WaitPort(a6)','Wait for message at port');
      
      addline(@mainfilelist,'GetMessage:','');
      
      addline(@mainfilelist,'    move.l  '+no0(pdwn^.labelid)+',a1','Get win address');
      addline(@mainfilelist,'    move.l  86(a1),a2','Get message port');
      addline(@mainfilelist,'    move.l  a2,a0','');
      addline(@mainfilelist,'    move.l  _GadToolsBase,a6','Prepare for GadTools call');
      
      addline(@mainfilelist,'    jsr     GT_GetIMsg(a6)','Get message');
      addline(@mainfilelist,'    tst.l   d0','See if message arrived');
      addline(@mainfilelist,'    beq     WaitHere','If no message then wait for next');
      addline(@mainfilelist,'    move.l  d0,a1','Put intuimessage in a1');
      if producernode^.codeoptions[3] then
        begin
          addline(@mainfilelist,'    move.l  20(a1),d2','Get class');
          addline(@mainfilelist,'    move.w  24(a1),d3','Get code');
          addline(@mainfilelist,'    move.l  28(a1),a4','Get IAddress');
        end;
      addline(@mainfilelist,'    move.l  20(a1),d4','Get class in d4');
      addline(@mainfilelist,'    ','');
      addline(@mainfilelist,'    move.l  _GadToolsBase,a6','Prepare for GadTools call');
      addline(@mainfilelist,'    jsr     GT_ReplyIMsg(a6)','Reply message');
      addline(@mainfilelist,'','');
      
      addline(@mainfilelist,'    cmpi.l  #$200,d4','Quit if window closed');
      addline(@mainfilelist,'    beq     Done','Remove when proper method implemented');

      if producernode^.codeoptions[3] then
        begin
          addline(@mainfilelist,'    move.l  d2,d0','Get class');
          addline(@mainfilelist,'    move.w  d3,d1','Get code');
          addline(@mainfilelist,'    move.l  a4,a0','Get IAddress');
          addline(@mainfilelist,'    jsr     ProcessWindow'+no0(pdwn^.labelid),'Call process routine');
        end;
      
      addline(@mainfilelist,'    jmp     GetMessage','Get next message');
      addline(@mainfilelist,'Done:','');
      addline(@mainfilelist,'    move.l  '+no0(pdwn^.labelid)+',d0','Put window in d0');
      addline(@mainfilelist,'    tst.l   d0','See if window open');
      addline(@mainfilelist,'    beq     NoWindow','If it is not open then skip close');
      addline(@mainfilelist,'    jsr     Close'+(no0(pdwn^.labelid))+'Window','Close Window');
      
      addline(@mainfilelist,'NoWindow:','Window cannot be opened');
    end
   else
    addline(@mainfilelist,'; No windows - so not a lot to do here, ho hum.','');
  
  if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) then
    begin
      pdsn:=pdesignerscreennode(producernode^.screenlist.mlh_head);
      addline(@mainfilelist,'    movea.l Scr,a0','Put Screen in a0');
      
      addline(@mainfilelist,'    movea.l _IntuitionBase,a6','Prepare for Intuition call');
      addline(@mainfilelist,'    jsr     CloseScreen(a6)','Close Screen');
      addline(@mainfilelist,'NoScreen:','');
    end;
  
  if (sizeoflist(plist(@producernode^.imagelist))>0) then
    begin
      addline(@mainfilelist,'    jsr     FreeImages','Free allocated images');
      addline(@mainfilelist,'NoImages:','Could not allocate images');
    end;
  
  if producernode^.localecount>0 then
    addline(@mainfilelist,'    jsr     Close'+sfp(producernode^.basename)+'Catalog','Close locale catalog');
  
  if (producernode^.codeoptions[4]) then
    begin
      addline(@mainfilelist,'    jsr     CloseLibs','Close libraries');
      addline(@mainfilelist,'NoLibs:','Could not open libraries');
    end;
  addline(@mainfilelist,'    rts','Return');
  addline(@mainfilelist,'','');
end;

procedure dobitmapstuff;
begin
  addline(@procfunclist,'','');
  addline(@procfunclist,'BitStore:','');
  addline(@procfunclist,'    dc.l    0','');
  addline(@procfunclist,'','');
  
  addline(@externlist,'    XREF    AllocBitMap','d0=depth,d1=width,d2=height');
  addline(@procfunclist,'    XDEF    AllocBitMap','d0=depth,d1=width,d2=height');
  
  addline(@procfunclist,'AllocBitMap:','d0=depth,d1=width,d2=height');
  addline(@procfunclist,'    movem.l d1-d6/a0-a4/a6,-(sp)','Store Registers');
  addline(@procfunclist,'    move.l  d0,d4','');
  addline(@procfunclist,'    move.l  d1,d5','');
  addline(@procfunclist,'    move.l  d2,d6','');
  
  addline(@procfunclist,'    move.l  #40,d0','Allocate BitMap structure');
  addline(@procfunclist,'    movea.l _SysBase,a6','');
  addline(@procfunclist,'    move.l  #'+fmtint(memf_clear or memf_any)+',d1','Type of memory in d1');
  addline(@procfunclist,'    jsr     AllocVec(a6)','');
  addline(@procfunclist,'    tst.l   d0','');
  addline(@procfunclist,'    beq     NoBitMap','');
  addline(@procfunclist,'    move.l  d0,BitStore','');
  addline(@procfunclist,'    movea.l d0,a0','');
  addline(@procfunclist,'    movea.l _IntuitionBase,a6','');
  addline(@procfunclist,'    move.b  d4,d0','Put Screen Depth in d0');
  addline(@procfunclist,'    move.l  d5,d1','Width');
  addline(@procfunclist,'    move.l  d6,d2','Height');
  addline(@procfunclist,'    movea.l _GfxBase,a6','');
  addline(@procfunclist,'    jsr     InitBitMap(a6)','');
      
  addline(@procfunclist,'    movea.l BitStore,a4','BitMap in a1');
  addline(@procfunclist,'    adda.l  #8,a4','BitMap in a1');
  addline(@procfunclist,'AllocBitMapLoop:','');
  addline(@procfunclist,'    tst.l   d4','');
  addline(@procfunclist,'    beq     AllocBitMapDone','');
  addline(@procfunclist,'    move.l  d5,d0','');
  addline(@procfunclist,'    move.l  d6,d1','');
  addline(@procfunclist,'    movea.l _GfxBase,a6','');
  addline(@procfunclist,'    jsr     AllocRaster(a6)','');
  addline(@procfunclist,'    move.l  d0,(a4)','');
  addline(@procfunclist,'    tst.l   d0','');
  addline(@procfunclist,'    beq     AllocRasterBad','');
  
  addline(@procfunclist,'    move.l  d6,d0','rows in d1');
  addline(@procfunclist,'    asl.l   #8,d0','rows in upper 16 bits of d1');
  addline(@procfunclist,'    asl.l   #8,d0','');
  addline(@procfunclist,'    movea.l BitStore,a0','');
  addline(@procfunclist,'    move.w  (a0),d1','');
  addline(@procfunclist,'    add.w   d1,d0','width in bytes in lower 16 bits of d1');
  addline(@procfunclist,'    move.l  #3,d1','flags for BltClear');
  addline(@procfunclist,'    movea.l (a4),a1','Raster in a0');
  addline(@procfunclist,'    jsr     BltClear(a6)','');
  
  
  addline(@procfunclist,'    adda.l  #4,a4','');
  addline(@procfunclist,'    sub.l   #1,d4','');
  addline(@procfunclist,'    jmp     AllocBitMapLoop','');
  addline(@procfunclist,'AllocBitMapDone:','');
  addline(@procfunclist,'    move.l  BitStore,d0','');
  addline(@procfunclist,'    movem.l (sp)+,d1-d6/a0-a4/a6','Restore Registers');
  addline(@procfunclist,'    rts','');
  addline(@procfunclist,'NoBitMap:','');
  addline(@procfunclist,'    move.l  #0,d0','');
  addline(@procfunclist,'    move.l  d0,BitStore','');
  addline(@procfunclist,'    jmp     AllocBitMapDone','');
  addline(@procfunclist,'AllocRasterBad:','');
  addline(@procfunclist,'    movea.l BitStore,a0','');
  addline(@procfunclist,'    jsr     FreeBitMap','');
  addline(@procfunclist,'    jmp     NoBitMap','');
  
  addline(@procfunclist,'','');
  addline(@externlist,'    XREF    FreeBitMap','a0=bitmap');
  addline(@procfunclist,'    XDEF    FreeBitMap','a0=bitmap');
  
  addline(@procfunclist,'FreeBitMap:','a0=bitmap');
  addline(@procfunclist,'    movem.l d0-d6/a0-a4/a6,-(sp)','Store Registers');
  addline(@procfunclist,'    movea.l a0,a3','');
  addline(@procfunclist,'    move.l  #0,d3','');
  addline(@procfunclist,'    move.b  5(a3),d3','');
  addline(@procfunclist,'    movea.l a3,a2','');
  addline(@procfunclist,'    adda.l  #8,a2','');
  
  addline(@procfunclist,'FreeBitMapLoop:','');
  addline(@procfunclist,'    tst.l   d3','');
  addline(@procfunclist,'    beq     FreeRastersDone','');
  addline(@procfunclist,'    move.l  #0,d0','');
  addline(@procfunclist,'    move.l  #0,d1','');
  addline(@procfunclist,'    move.w  (a3),d0','');
  addline(@procfunclist,'    mulu    #8,d0','');
  addline(@procfunclist,'    move.w  2(a3),d1','');
  addline(@procfunclist,'    movea.l _GfxBase,a6','');
  addline(@procfunclist,'    movea.l (a2),a0','');
  addline(@procfunclist,'    jsr     FreeRaster(a6)','');
  addline(@procfunclist,'    adda.l  #4,a2','');
  addline(@procfunclist,'    sub.l   #1,d3','');
  addline(@procfunclist,'    jmp     FreeBitMapLoop','');
  addline(@procfunclist,'FreeRastersDone:','');
  addline(@procfunclist,'    movea.l a3,a1','');
  addline(@procfunclist,'    movea.l _SysBase,a6','');
  addline(@procfunclist,'    jsr     FreeVec(a6)','');
  addline(@procfunclist,'    movem.l (sp)+,d0-d6/a0-a4/a6','Restore Registers');
  addline(@procfunclist,'    rts','');
  addline(@procfunclist,'','');
  
  
end;

end.