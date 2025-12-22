unit screenstuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,liststuff,producerlib,
     amigados,fonts,graphics,definitions,iffparse,amiga,asl,workbench,localestuff;

procedure processscreen(pdsn:pdesignerscreennode);


implementation

procedure processscreen(pdsn:pdesignerscreennode);
const
  overscanarray : array[0..3] of long = (oscan_text,oscan_standard,oscan_max,oscan_video);
var
  s,s2:string;
  pos : word;
  loop : word;
  params : string[50];
begin
  params:='';
  s:='';
  if (sfp(pdsn^.sn_pubscreenname)<>'') or (pdsn^.screentype=1) then
  if pdsn^.dopubsig then
    begin
      s:='PubSig : long';
      if pdsn^.bitmap and (not pdsn^.createbitmap)  and (not pdsn^.likeworkbench) then
        s:=','+s;
    end;
  
  if pdsn^.bitmap and (not pdsn^.createbitmap)  and (not pdsn^.likeworkbench) then
    params:='( pbm : pbitmap '+s+')'
   else
    if s<>'' then
      params:='('+s+')';
  
  addline(@procfuncdefslist,'Function Open'+sfp(pdsn^.sn_label)+'Screen'+params+':pscreen;','');
  
  addline(@procfunclist,'','');
  addline(@procfunclist,'Function Open'+sfp(pdsn^.sn_label)+'Screen'+params+':pscreen;','');
  addline(@procfunclist,'const','');
  if sfp(pdsn^.sn_pubscreenname)<>'' then
    addline(@procfunclist,'  '+sfp(pdsn^.sn_label)+'PubName : string['+fmtint(1+length(sfp(pdsn^.sn_pubscreenname)))+'] = '''+
         sfp(pdsn^.sn_pubscreenname)+'''#0;','');
  
  if not pdsn^.loctitle then
    begin
      addline(@procfunclist,'  '+sfp(pdsn^.sn_label)+'ScreenName : string['+fmtint(1+length(sfp(pdsn^.sn_title)))+'] = '''+
               sfp(pdsn^.sn_title)+'''#0;','');
    end;
  
  if pdsn^.defpens then
    begin
      addline(@procfunclist,'  defpens : word = 65535;','');
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
      
      addline(@procfunclist,'  pens : array[0..'+fmtint(pos)+'] of word = ('+s+');','');
    end;

  pos:=0;
  s:='';
  if pdsn^.colorarray<>nil then
    begin
      addline(@procfunclist,'  colors : array[0..'+fmtint(pdsn^.sizecolorarray div 2)+'] of word =','');
      addline(@procfunclist,'    (','');
      while (pdsn^.colorarray^[pos]<>65535) do
        begin
          s:=fmtint(pdsn^.colorarray^[pos])+',';
          s:=s+fmtint(pdsn^.colorarray^[pos+1])+',';
          s:=s+fmtint(pdsn^.colorarray^[pos+2])+',';
          s:=s+fmtint(pdsn^.colorarray^[pos+3])+',';
          addline(@procfunclist,'    '+s,'');
          inc(pos,4);
        end;
      addline(@procfunclist,'    65535,0,0,0','');
      addline(@procfunclist,'    );','');
    end;

  addline(@procfunclist,'var','');
  addline(@procfunclist,'  Tags : array[1..25] of ttagitem;','');
  addline(@procfunclist,'  Scr  : pscreen;','');

  
  if pdsn^.bitmap  and (not pdsn^.likeworkbench) then
    begin
      if pdsn^.createbitmap then
        begin
          
          addline(@procfunclist,'  BitMap           : pbitmap;','');
          addline(@procfunclist,'  allocatedbitmaps : boolean;','');
          addline(@procfunclist,'  planenum         : word;','');
        end;
    end;
  
  if pdsn^.depth=0 then
    begin
      addline(@procfunclist,'  DisplayHandle : displayinfohandle;','');
      addline(@procfunclist,'  gidres        : long;','');
      addline(@procfunclist,'  diminfo       : tdimensioninfo;','');
    end;

  
  addline(@procfunclist,'Begin','');
  addline(@procfunclist,'  settagitem(@tags[ 1],sa_left,'+fmtint(pdsn^.left)+');','');
  addline(@procfunclist,'  settagitem(@tags[ 2],sa_top,'+fmtint(pdsn^.top)+');','');
  addline(@procfunclist,'  settagitem(@tags[ 3],sa_width,'+fmtint(pdsn^.width)+');','');
  addline(@procfunclist,'  settagitem(@tags[ 4],sa_height,'+fmtint(pdsn^.height)+');','');
  
  if pdsn^.depth=0 then
    begin
      addline(@procfunclist,'  settagitem(@tags[ 5],sa_depth,2);','');
      addline(@procfunclist,'  DisplayHandle:=FindDisplayInfo('+fmtint(pdsn^.idnum)+');','');
      addline(@procfunclist,'  if DisplayHandle<>nil then','');
      addline(@procfunclist,'    begin','');
      addline(@procfunclist,'      gidres:=GetDisplayInfoData(DisplayHandle,@diminfo,sizeof(diminfo),DTAG_DIMS,0);','');
      addline(@procfunclist,'      if gidres<>0 then','');
      addline(@procfunclist,'        settagitem(@tags[ 5],sa_depth,diminfo.MaxDepth);','');
      addline(@procfunclist,'    end;','');
      addline(@procfunclist,'  settagitem(@tags[ 5],sa_depth,diminfo.MaxDepth);','');
    end
   else
    addline(@procfunclist,'  settagitem(@tags[ 5],sa_depth,'+fmtint(pdsn^.depth)+');','');
  
  
  
  addline(@procfunclist,'  settagitem(@tags[ 6],sa_overscan,'+fmtint(overscanarray[pdsn^.overscan])+');','');
  
  case pdsn^.fonttype of
         0: addline(@procfunclist,'  settagitem(@tags[ 7],sa_font,long(@'+makemyfont(pdsn^.font)+'));','');
         1: addline(@procfunclist,'  settagitem(@tags[ 7],sa_sysfont,0);','');
         2: addline(@procfunclist,'  settagitem(@tags[ 7],sa_sysfont,1);','');
       end;
  
  addline(@procfunclist,'  settagitem(@tags[ 8],sa_behind,long('+fmtint(long(pdsn^.behind))+'));','');
  addline(@procfunclist,'  settagitem(@tags[ 9],sa_quiet,long('+fmtint(long(pdsn^.quiet))+'));','');
  addline(@procfunclist,'  settagitem(@tags[10],sa_showtitle,long('+fmtint(long(pdsn^.showtitle))+'));','');
  addline(@procfunclist,'  settagitem(@tags[11],sa_autoscroll,long('+fmtint(long(pdsn^.autoscroll))+'));','');
  addline(@procfunclist,'  settagitem(@tags[12],sa_fullpalette,long('+fmtint(long(pdsn^.fullpalette))+'));','');
  addline(@procfunclist,'  settagitem(@tags[13],sa_DisplayID,long('+fmtint(long(pdsn^.idnum))+'));','');
  
  loop:=14;
  if pdsn^.loctitle then
    begin
      localestring(sfp(pdsn^.sn_title),sfp(pdsn^.sn_label)+'ScreenName','ScreenTitle : '+sfp(pdsn^.sn_label));
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_title,long('+
           sfp(producernode^.getstring)
           +'ptr('+sfp(pdsn^.sn_label)+'ScreenName)));','');
      inc(loop);
    end
   else
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_title,long(@'+sfp(pdsn^.sn_label)+'ScreenName[1]));','');
      inc(loop);
    end;
  
  if sfp(pdsn^.sn_pubscreenname)<>'' then
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_pubname,long(@'+sfp(pdsn^.sn_label)+'PubName[1]));','');
      inc(loop);
    end;
      
  if (sfp(pdsn^.sn_pubscreenname)<>'') or (pdsn^.screentype=1) then
    if (pdsn^.dopubsig) then
      begin
        addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],SA_PubSig,long(pubsig));','');
        inc(loop);
        {
        addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],SA_PubTask,long(FindTask(nil)));','');
        inc(loop);
        }
      end;
  
  if (pdsn^.screentype=1) and (sfp(pdsn^.sn_pubscreenname)='') then
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_type,publicscreen);','');
      inc(loop);
    end;
  
  if pdsn^.defpens then
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_pens,long(@defpens));','');
      inc(loop);
    end
   else
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_pens,long(@pens));','');
      inc(loop);
    end;
  
  if (pdsn^.colorarray<>nil) then
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_colors,long(@colors));','');
      inc(loop);
    end;
  
  if pdsn^.bitmap and (not pdsn^.likeworkbench) then
    begin
      if pdsn^.createbitmap then
        begin
          
          addline(@procfunclist,'  BitMap:=allocmem(sizeof(tbitmap),MEMF_PUBLIC or MEMF_CLEAR);','');
          addline(@procfunclist,'  if BitMap<>nil then','');  {32}
          addline(@procfunclist,'    begin','');            {33}
          str(pdsn^.width,s);
          str(pdsn^.height,s2);
          s:=s+', '+s2;
          addline(@procfunclist,'      InitBitMap(BitMap, tags[5].ti_data, '+s+');','');            {33}
          addline(@procfunclist,'      allocatedbitmaps:=true;','');            {33}
      
          addline(@procfunclist,'      for planenum:=0 to tags[5].ti_data-1 do','');            {33}
          addline(@procfunclist,'        begin','');            {33}
          addline(@procfunclist,'          if allocatedbitmaps then','');            {33}
          addline(@procfunclist,'            BitMap^.Planes[planenum]:=AllocRaster('+s+');','');
          addline(@procfunclist,'          if BitMap^.Planes[planenum]=Nil then','');
          addline(@procfunclist,'            allocatedbitmaps:=false','');            {33}
          addline(@procfunclist,'           else','');            {33}
          str(trunc((pdsn^.width+15)/16)*2*pdsn^.height,s);
          addline(@procfunclist,'            BltClear(BitMap^.Planes[planenum],'+s+', 1);','');
          addline(@procfunclist,'        end;','');            {33}
          addline(@procfunclist,'    end;','');            {33}
      

          addline(@procfunclist,'  if (bitmap<>nil) and (not allocatedbitmaps) then','');            {33}
          addline(@procfunclist,'    freebitmap(bitmap,'+fmtint(pdsn^.width)+','+fmtint(pdsn^.height)+');','');
          addline(@procfunclist,'','');

          
          
          addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_bitmap,long(BitMap));','');
          inc(loop);
        end
       else
        begin
          addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_bitmap,long(pbm));','');
          inc(loop);
        end;
    end;
  
  if pdsn^.errorcode then
    begin
      addline(@varlist,'	'+sfp(pdsn^.sn_label)+'Error : long;','');
      addline(@procfunclist,'  '+sfp(pdsn^.sn_label)+'Error:=0;','');
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],sa_errorcode,long(@'+sfp(pdsn^.sn_label)+'Error));','');
      inc(loop);
    end;
  
  if not pdsn^.draggable then
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],$8000003E,long(False));','');
      inc(loop);
    end;
  
  if pdsn^.exclusive then
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],$8000003F,long(True));','');
      inc(loop);
    end;
  
  if pdsn^.sharedpens then
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],$80000040,long(True));','');
      inc(loop);
    end;

  if pdsn^.interleaved then
    begin
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],$80000042,long(True));','');
      inc(loop);
    end;

  if pdsn^.likeworkbench then
    begin
      
      
      {
      addline(@procfunclist,'  settagitem(@tags[ 1],sa_left,'+fmtint(pdsn^.left)+');','');
      addline(@procfunclist,'  settagitem(@tags[ 2],sa_top,'+fmtint(pdsn^.top)+');','');
      addline(@procfunclist,'  settagitem(@tags[ 3],sa_width,'+fmtint(pdsn^.width)+');','');
      addline(@procfunclist,'  settagitem(@tags[ 4],sa_height,'+fmtint(pdsn^.height)+');','');
      addline(@procfunclist,'  settagitem(@tags[ 5],sa_depth,'+fmtint(pdsn^.depth)+');','');
      addline(@procfunclist,'  settagitem(@tags[13],sa_DisplayID,long('+fmtint(long(pdsn^.idnum))+'));','');
      }
      addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],tag_ignore,0);','');
      addline(@procfunclist,'  if intuitionbase^.libnode.lib_version > 38 then','');
      addline(@procfunclist,'    begin','');
       
      addline(@procfunclist,'      tags[ 1].ti_tag:=tag_ignore;','');
      addline(@procfunclist,'      tags[ 2].ti_tag:=tag_ignore;','');
      addline(@procfunclist,'      tags[ 3].ti_tag:=tag_ignore;','');
      addline(@procfunclist,'      tags[ 4].ti_tag:=tag_ignore;','');
      addline(@procfunclist,'      tags[ 5].ti_tag:=tag_ignore;','');
      addline(@procfunclist,'      tags[13].ti_tag:=tag_ignore;','');
      
      addline(@procfunclist,'      settagitem(@tags['+fmtint(loop)+'],$80000047,long(True));','');
      inc(loop);
      addline(@procfunclist,'    end;','');
      
    end;
  addline(@procfunclist,'  settagitem(@tags['+fmtint(loop)+'],tag_done,0);','');
  
  if pdsn^.bitmap and (not pdsn^.likeworkbench) then
    begin
      if pdsn^.createbitmap then
        begin
          addline(@procfunclist,'  if BitMap<>nil then','');
          addline(@procfunclist,'    Open'+sfp(pdsn^.sn_label)+'Screen:=openscreentaglist(nil,@tags[1])','');
          addline(@procfunclist,'   else','');
          addline(@procfunclist,'    Open'+sfp(pdsn^.sn_label)+'Screen:=nil;','');
        end
       else
        begin
          addline(@procfunclist,'  if pbm<>nil then','');
          addline(@procfunclist,'    begin','');
          
          addline(@procfunclist,'      Scr:=openscreentaglist(nil,@tags[1]);','');
          addline(@procfunclist,'      if scr<>nil then','');
          addline(@procfunclist,'        Scr^.UserData:=BitMap;','');
          
          addline(@procfunclist,'      Open'+sfp(pdsn^.sn_label)+'Screen:=Scr;','');
          addline(@procfunclist,'    end','');
          
          addline(@procfunclist,'   else','');
          addline(@procfunclist,'    Open'+sfp(pdsn^.sn_label)+'Screen:=nil;','');
        end;
    end
   else
    begin
      addline(@procfunclist,'  Open'+sfp(pdsn^.sn_label)+'Screen:=openscreentaglist(nil,@tags[1]);','');
    end;
  addline(@procfunclist,'end;','');
  
end;


end.
