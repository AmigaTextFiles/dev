unit screenstuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench,localestuff;

procedure processscreen(pdsn:pdesignerscreennode);


implementation

procedure processscreen(pdsn:pdesignerscreennode);
const
  overscanarray : array[0..3] of long = (oscan_text,oscan_standard,oscan_max,oscan_video);
var
  s:string;
  loop : word;
  pos : word;
begin
  
  
  if sfp(pdsn^.sn_pubscreenname)<>'' then
    begin
      addline(@constlist,'','');
      addline(@constlist,sfp(pdsn^.sn_label)+'PubName:','');
      addline(@constlist,'    dc.b    '''+sfp(pdsn^.sn_pubscreenname)+''',0','');
      addline(@constlist,'    cnop    0,2','');
    end;
    
  
  if not pdsn^.loctitle then
    begin
      addline(@constlist,'','');
      addline(@constlist,sfp(pdsn^.sn_label)+'ScreenName:','');
      addline(@constlist,'    dc.b    '''+sfp(pdsn^.sn_title)+''',0','');
      addline(@constlist,'    cnop    0,2','');
    end;
  
  if pdsn^.defpens then
    begin
      addline(@constlist,'','');
      addline(@constlist,sfp(pdsn^.sn_label)+'defpens:','');
      addline(@constlist,'    dc.w    65535','');
    end
   else
    begin
      s:='';
      pos:=0;
      while(pdsn^.penarray[pos]<>65535) do
        begin
          s:=s+fmtint(pdsn^.penarray[pos])+',';
          inc(pos);
        end;
      s:=s+'65535';
      
      addline(@constlist,sfp(pdsn^.sn_label)+'pens:','');
      addline(@constlist,'    dc.w    '+s,'');
    end;

  pos:=0;
  s:='';
  if pdsn^.colorarray<>nil then
    begin
      addline(@constlist,'','');
      addline(@constlist,sfp(pdsn^.sn_label)+'Colors:','');
      while (pdsn^.colorarray^[pos]<>65535) do
        begin
          s:=fmtint(pdsn^.colorarray^[pos])+',';
          s:=s+fmtint(pdsn^.colorarray^[pos+1])+',';
          s:=s+fmtint(pdsn^.colorarray^[pos+2])+',';
          s:=s+fmtint(pdsn^.colorarray^[pos+3]);
          addline(@constlist,'    dc.w    '+s,'');
          inc(pos,4);
        end;
      addline(@constlist,'    dc.w    65535,0,0,0','');
    end;

  addline(@constlist,'','');
  
  if pdsn^.errorcode then
    begin
      addline(@constlist,'    XDEF    '+sfp(pdsn^.sn_label)+'Error','');
      addline(@externlist,'    XREF    '+sfp(pdsn^.sn_label)+'Error','SA_ErrorCode container');
      addline(@constlist,sfp(pdsn^.sn_label)+'Error:','SA_ErrorCode container');
      addline(@constlist,'    dc.l    0','');
    end;
  
  addline(@constlist,'','');
  
  addline(@constlist,sfp(pdsn^.sn_label)+'Tags:','');
  addline(@constlist,'    dc.l    $80000021,'+fmtint(pdsn^.left),'SA_Left');
  addline(@constlist,'    dc.l    $80000022,'+fmtint(pdsn^.top),'SA_Top');
  addline(@constlist,'    dc.l    $80000023,'+fmtint(pdsn^.width),'SA_Width');
  addline(@constlist,'    dc.l    $80000024,'+fmtint(pdsn^.height),'SA_Height');
  addline(@constlist,'    dc.l    $80000032,'+fmtint(long(pdsn^.idnum)),'SA_DisplayID');
  addline(@constlist,'    dc.l    $80000025','SA_Depth');
  
  addline(@constlist,sfp(pdsn^.sn_label)+'Depth:','SA_Depth');
  if pdsn^.depth=0 then
    addline(@constlist,'    dc.l    1','SA_Depth')
   else
    addline(@constlist,'    dc.l    '+fmtint(pdsn^.depth),'SA_Depth');
  
  addline(@constlist,'    dc.l    $80000034,'+fmtint(overscanarray[pdsn^.overscan]),'SA_OverScan');
  
  case pdsn^.fonttype of
         0: addline(@constlist,'    dc.l    $8000002B,'+makemyfont(pdsn^.font),'SA_Font');
         1: addline(@constlist,'    dc.l    $8000002C,0','SA_SysFont');
         2: addline(@constlist,'    dc.l    $8000002C,1','SA_SysFont');
       end;
  
  addline(@constlist,'    dc.l    $80000037,'+fmtint(long(pdsn^.behind)),'SA_Behind');
  addline(@constlist,'    dc.l    $80000038,'+fmtint(long(pdsn^.quiet)),'SA_Quiet');
  addline(@constlist,'    dc.l    $80000036,'+fmtint(long(pdsn^.showtitle)),'SA_ShowTitle');
  addline(@constlist,'    dc.l    $80000039,'+fmtint(long(pdsn^.autoscroll)),'SA_AutoScroll');
  addline(@constlist,'    dc.l    $8000003B,'+fmtint(long(pdsn^.fullpalette)),'SA_FullPalette');
  
  if pdsn^.interleaved then
    addline(@constlist,'    dc.l    $80000042,1','SA_Interleaved (V39)');
  
  if pdsn^.sharedpens then
    addline(@constlist,'    dc.l    $80000040,1','SA_SharePens (V39)');
  
  if pdsn^.exclusive then
    addline(@constlist,'    dc.l    $8000003F,1','SA_Exclusive (V39)');
  
  if not pdsn^.draggable then
    addline(@constlist,'    dc.l    $8000003E,0','SA_Draggable (V39)');
  
  if pdsn^.errorcode then
    addline(@constlist,'    dc.l    $8000002A,'+sfp(pdsn^.sn_label)+'Error','SA_ErrorCode');
  
  if pdsn^.loctitle then
    begin
      addline(@constlist,sfp(pdsn^.sn_label)+'ScreenTitle:','');
      localestring(sfp(pdsn^.sn_title),sfp(pdsn^.sn_label)+'ScreenName','ScreenTitle : '+sfp(pdsn^.sn_label));
    end;
  
  addline(@constlist,'    dc.l    $80000028,'+sfp(pdsn^.sn_label)+'ScreenName','SA_Title');
  
  if sfp(pdsn^.sn_pubscreenname)<>'' then
    begin
      addline(@constlist,'    dc.l    $8000002F,'+sfp(pdsn^.sn_label)+'PubName','SA_PubName');
    end;
  
  if (pdsn^.screentype=1) or (sfp(pdsn^.sn_pubscreenname)<>'') then
    if pdsn^.dopubsig then
      begin
        addline(@constlist,sfp(pdsn^.sn_label)+'SigBit:','');
        addline(@constlist,'    dc.l    $80000030,0','SA_PubSig');
      end;
  
  if (pdsn^.screentype=1) and (sfp(pdsn^.sn_pubscreenname)='') then
    begin
      addline(@constlist,'    dc.l    $8000002D,publicscreen','SA_Type');
    end;
  
  if pdsn^.defpens then
    begin
      addline(@constlist,'    dc.l    $8000003A,'+sfp(pdsn^.sn_label)+'defpens','SA_Pens');
    end
   else
    begin
      addline(@constlist,'    dc.l    $8000003A,'+sfp(pdsn^.sn_label)+'pens','SA_Pens');
    end;
  
  if (pdsn^.bitmap) and (not pdsn^.likeworkbench) then
    begin
      addline(@constlist,sfp(pdsn^.sn_label)+'BitMap:','');
      addline(@constlist,'    dc.l    $8000002E,0','SA_BitMap');
      inc(loop);
    end;
  
  if (pdsn^.colorarray<>nil) then
    begin
      addline(@constlist,'    dc.l    $80000029,'+sfp(pdsn^.sn_label)+'Colors','SA_Colors');
      inc(loop);
    end;
  
  addline(@constlist,'    dc.l    0,0','TAG_DONE');
  
  addline(@externlist,'    XREF    Open'+sfp(pdsn^.sn_label)+'Screen',' a0 = signal,a1 = bitmap, if either required.');
  
  addline(@procfunclist,'','');
  addline(@procfunclist,'    XDEF    Open'+sfp(pdsn^.sn_label)+'Screen',' d0 = signal,a0 = bitmap, if either required.');
  addline(@procfunclist,'Open'+sfp(pdsn^.sn_label)+'Screen:','');
  
  if pdsn^.depth=0 then
    begin
      addline(@procfunclist,'    link    a5,#-88','');
    end;
  
  addline(@procfunclist,'    movem.l d1-d2/a0-a1/a6,-(sp)','Store Registers');
  
  if (pdsn^.screentype=1) or (sfp(pdsn^.sn_pubscreenname)<>'') then
    if pdsn^.dopubsig then
      begin
        addline(@procfunclist,'    move.l  d0,'+sfp(pdsn^.sn_label)+'SigBit+4','');
      end;
  
  if pdsn^.bitmap and (not pdsn^.likeworkbench) then
    begin
      if not pdsn^.createbitmap then
        begin
          addline(@procfunclist,'    move.l  a0,'+sfp(pdsn^.sn_label)+'BitMap+4','');
        end;
    end;
  
  if pdsn^.depth=0 then
    begin
      addline(@procfunclist,'    move.l  #'+fmtint(pdsn^.idnum)+',d0','DisplayID in d0');
      addline(@procfunclist,'    movea.l _GfxBase,a6 ','');
      addline(@procfunclist,'    jsr     FindDisplayInfo(a6)','');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    beq     '+sfp(pdsn^.sn_label)+'NoDispHandle','');
      addline(@procfunclist,'    movea.l d0,a0','Set up parameters for GetDisplayInfoData');
      addline(@procfunclist,'    movea.l sp,a1','Buffer');
      addline(@procfunclist,'    move.l  #88,d0','Size');
      addline(@procfunclist,'    move.l  #$80001000,d1','tag id');
      addline(@procfunclist,'    move.l  #0,d2','Clear d2');
      addline(@procfunclist,'    jsr     GetDisplayInfoData(a6)','');
      addline(@procfunclist,'    tst.l   d0','');
      addline(@procfunclist,'    beq     '+sfp(pdsn^.sn_label)+'NoDispInfo','');
      addline(@procfunclist,'    move.l  #0,d0','');
      addline(@procfunclist,'    move.w  16(sp),d0','');
      addline(@procfunclist,'    move.l  d0,'+sfp(pdsn^.sn_label)+'Depth','');
      addline(@procfunclist,sfp(pdsn^.sn_label)+'NoDispInfo:','');
      addline(@procfunclist,sfp(pdsn^.sn_label)+'NoDispHandle:','');
    end;
  
  if pdsn^.bitmap  and (not pdsn^.likeworkbench) then
    begin
      if pdsn^.createbitmap then
        begin
          bitmaprequired:=true;
          addline(@procfunclist,'    move.l  '+sfp(pdsn^.sn_label)+'Depth,d0','');
          addline(@procfunclist,'    move.l  #'+fmtint(pdsn^.width)+',d1','');
          addline(@procfunclist,'    move.l  #'+fmtint(pdsn^.height)+',d2','');
          addline(@procfunclist,'    jsr     AllocBitMap','');
          addline(@procfunclist,'    move.l  d0,'+sfp(pdsn^.sn_label)+'BitMap+4','');
          addline(@procfunclist,'    tst.l   d0','');
          addline(@procfunclist,'    beq     '+sfp(pdsn^.sn_label)+'BitMapFailed','');
        end;
    end;
  
  if pdsn^.loctitle then
    begin
      addline(@procfunclist,'    move.l  #'+sfp(pdsn^.sn_label)+'ScreenName,d0','');
      addline(@procfunclist,'    jsr     '+sfp(producernode^.getstring),'');
      addline(@procfunclist,'    move.l  d0,'+sfp(pdsn^.sn_label)+'ScreenTitle+4','');
    end;
  
  if pdsn^.likeworkbench then
    begin
      addline(@procfunclist,'    movea.l  _IntuitionBase,a0','');
      addline(@procfunclist,'    move.w   20(a0),d0','Get library version');
      addline(@procfunclist,'    sub.w    #39,d0','Subtract 39');
      addline(@procfunclist,'    bmi      '+sfp(pdsn^.sn_label)+'NotLike','');
      addline(@procfunclist,'    move.l   #$80000047,'+sfp(pdsn^.sn_label)+'Tags','SA_LikeWorkBench');
      addline(@procfunclist,'    move.l   #1,'+sfp(pdsn^.sn_label)+'Tags+4','SA_LikeWorkBench');
  
      addline(@procfunclist,'    move.l   #1,'+sfp(pdsn^.sn_label)+'Tags+8 ','TAG_IGNORE');
      addline(@procfunclist,'    move.l   #1,'+sfp(pdsn^.sn_label)+'Tags+16','TAG_IGNORE');
      addline(@procfunclist,'    move.l   #1,'+sfp(pdsn^.sn_label)+'Tags+24','TAG_IGNORE');
      addline(@procfunclist,'    move.l   #1,'+sfp(pdsn^.sn_label)+'Tags+32','TAG_IGNORE');
      addline(@procfunclist,'    move.l   #1,'+sfp(pdsn^.sn_label)+'Tags+40','TAG_IGNORE');
  
      addline(@procfunclist,sfp(pdsn^.sn_label)+'NotLike:','');
    end;

  
  addline(@procfunclist,'    movea.l #0,a0','No newscreen');
  addline(@procfunclist,'    lea     '+sfp(pdsn^.sn_label)+'Tags,a1','Tags as only parameters');
  addline(@procfunclist,'    movea.l _IntuitionBase,a6','Prepare for Intuition call');
  addline(@procfunclist,'    jsr     OpenScreenTagList(a6)','Call');
  
  if pdsn^.bitmap  and (not pdsn^.likeworkbench) then
    begin
      if pdsn^.createbitmap then
        begin
          addline(@procfunclist,'    move.l  '+sfp(pdsn^.sn_label)+'BitMap+4,d2','');
          addline(@procfunclist,'    movea.l d0,a0','');
          addline(@procfunclist,'    move.l  d2,342(a0)','Put bitmap in screen userdata field');
        end;
    end;
    
  addline(@procfunclist,'Screen'+sfp(pdsn^.sn_label)+'Done:','');
  addline(@procfunclist,'    movem.l (sp)+,d1-d2/a0-a1/a6','Restore Registers');
  
  if pdsn^.depth=0 then
    begin
      addline(@procfunclist,'    unlk    a5','');
    end;
    
  addline(@procfunclist,'    rts','');
  
  if pdsn^.bitmap and (not pdsn^.likeworkbench)  then
    begin
      if pdsn^.createbitmap then
        begin
          addline(@procfunclist,sfp(pdsn^.sn_label)+'BitMapFailed:','');
          addline(@procfunclist,'    move.l    #0,d0','');
          addline(@procfunclist,'    jmp       Screen'+sfp(pdsn^.sn_label)+'Done','');
        end;
    end;

end;


end.
