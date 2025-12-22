unit imagestuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;

procedure makeimagemakefunction;
procedure makeimagefreefunction;

implementation

procedure makeimagemakefunction;
var
  pin     : pimagenode;
  oksofar : boolean;
  s       : string;
  s2      : string;
  psn     : pstringnode;
begin
  addline(@procfunclist,'','');
  
  addline(@procfunclist,'','');
  addline(@procfunclist,'    XDEF    MakeImages','No parameters, returns 0 if successful, 1 otherwise');
  addline(@externlist,'    XREF    MakeImages','No parameters, returns 0 if successful, 1 otherwise');
  addline(@procfunclist,'MakeImages:','');
  addline(@procfunclist,'    movem.l d1-d4/a0-a4/a6,-(sp)','Store registers');
  
  addline(@procfunclist,'    move.l  _SysBase,a6','Prepare for Exec call');
    
  if producernode^.codeoptions[2] then
    begin
      
      addline(@procfunclist,'    moveq   #72,d0','Size to be allocated for waitpointer in d0');
      addline(@procfunclist,'    moveq   #2,d1','MEMF_ANY in d1');
      addline(@procfunclist,'    jsr     AllocVec(a6)','Try to get Chip Ram');
      addline(@procfunclist,'    move.l  d0,WaitPointer','Copy result');
      addline(@procfunclist,'    beq     MakeImagesError','Make Images failed');
      addline(@procfunclist,'    lea     WaitPointerData,a0','Prepare for copymem, put souce in a0');
      addline(@procfunclist,'    move.l  WaitPointer,a1','put dest in a1');
      addline(@procfunclist,'    moveq   #72,d0','Put size in d0');
      addline(@procfunclist,'    jsr     CopyMem(a6)','Copy data to chip ram');
      addline(@procfunclist,'    ','');

    end;
  if sizeoflist(plist(@producernode^.imagelist))>0 then
    addline(@constlist,'','');
  pin:=pimagenode(producernode^.imagelist.mlh_head);
  while(pin^.ln_succ<>nil) do
    begin
      addline(@externlist,'    XREF    '+sfp(pin^.in_label),'');
      addline(@constlist,'','');
      addline(@constlist,'    XDEF    '+sfp(pin^.in_label),'');
      addline(@constlist,sfp(pin^.in_label)+':','');
    


      addline(@constlist,'    dc.w    0,0','LeftEdge,TopEdge');
      str(pin^.width,s2);
      s:=s2+',';
      str(pin^.height,s2);
      s:=s+s2;
      addline(@constlist,'    dc.w    '+s,'Width,Height');
      str(pin^.depth,s);
      addline(@constlist,'    dc.w    '+s,'Depth');
      addline(@constlist,sfp(pin^.in_label)+'IData:','');
      addline(@constlist,'    dc.l    0','Image data');
      
      str(pin^.planepick,s2);
      s:=s2+',';
      str(pin^.planeonoff,s2);
      s:=s+s2;
      addline(@constlist,'    dc.b    '+s,'PlanePick,PlaneOnOff');
      addline(@constlist,'    dc.l    0','Next Image');
      
      str(pin^.sizeallocated,s);
      
      addline(@procfunclist,'    move.l  #'+s+',d0','Size to be allocated for image data in d0');
      addline(@procfunclist,'    moveq   #2,d1','memf_any in d1');
      addline(@procfunclist,'    jsr     AllocVec(a6)','Try to get Chip Ram');
      addline(@procfunclist,'    move.l  d0,'+sfp(pin^.in_label)+'IData','Copy result');
      addline(@procfunclist,'    beq     MakeImagesError','Make Images failed');
      addline(@procfunclist,'    lea     '+sfp(pin^.in_label)+'Data,a0','Prepare for copymem, load source into a0');
      addline(@procfunclist,'    move.l  '+sfp(pin^.in_label)+'IData,a1','Load destination into a1');
      addline(@procfunclist,'    move.l  #'+s+',d0','Load size into d0');
      addline(@procfunclist,'    jsr     CopyMem(a6)','Copy Data to chip');
      addline(@procfunclist,'    ','');

      pin:=pin^.ln_succ;
    end;
  
  addline(@procfunclist,'    moveq   #0,d0','Return 0 for successful');
  addline(@procfunclist,'    jmp     MakeImagesDone','Go To end of MakeImages');
  addline(@procfunclist,'','');
  addline(@procfunclist,'MakeImagesError:','');
  addline(@procfunclist,'    jsr     FreeImages','Free allocated resources');
  addline(@procfunclist,'    moveq   #1,d0','Set error code');
  addline(@procfunclist,'','');
  addline(@procfunclist,'MakeImagesDone:','');
  addline(@procfunclist,'    movem.l (sp)+,d1-d4/a0-a4/a6','Restore registers');
  addline(@procfunclist,'    rts','Return');
  makeimagefreefunction;
end;

procedure makeimagefreefunction;
var
  pin     : pimagenode;
  oksofar : boolean;
  s       : string;
  psn     : pstringnode;
begin
  addline(@procfunclist,'','');
  addline(@externlist,'    XREF    FreeImages','No parameters, no return');
  addline(@procfunclist,'    XDEF    FreeImages','');
  addline(@procfunclist,'FreeImages:','');
  addline(@procfunclist,'    movem.l d0-d4/a0-a4/a6,-(sp)','');
  
  addline(@procfunclist,'    move.l  _SysBase,a6','');
   addline(@procfunclist,'','');
  if producernode^.codeoptions[2] then
    begin
      addline(@procfunclist,'    move.l  WaitPointer,a1','Block to free in a1');
      addline(@procfunclist,'    jsr     FreeVec(a6)','Free it, NULL is OK');
      addline(@procfunclist,'','');
    end;
  pin:=pimagenode(producernode^.imagelist.mlh_head);
  while(pin^.ln_succ<>nil) do
    begin
      addline(@procfunclist,'    move.l  '+sfp(pin^.in_label)+'IData,a1','Block to free in a1');
      addline(@procfunclist,'    jsr     FreeVec(a6)','Free it, NULL is OK');
      addline(@procfunclist,'','');
      pin:=pin^.ln_succ;
    end;
  
  addline(@procfunclist,'    movem.l (sp)+,d0-d4/a0-a4/a6','');
  addline(@procfunclist,'    rts','');
end;

end.