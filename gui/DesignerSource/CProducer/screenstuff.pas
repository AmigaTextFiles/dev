unit screenstuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;

procedure processscreen(pdsn:pdesignerscreennode);


implementation

procedure processscreen(pdsn:pdesignerscreennode);
const
  overscanarray : array[0..3] of long = (oscan_text,oscan_standard,oscan_max,oscan_video);
var
  s,s2:string;
  bitmappos : word;
  pos : word;
  loop : word;
  startpos : long;
begin
  
  
  if pdsn^.defpens then
    begin
      addline(@constlist,'','');
      addline(@constlist,'UWORD    '+sfp(pdsn^.sn_label)+'defpens = {65535};','');
    end
   else
    begin
      s:='';
      pos:=0;
      while(pdsn^.penarray[pos]<>65535) do
        begin
          s:=s+fmtint(pdsn^.penarray[pos])+', ';
          inc(pos);
        end;
      s:=s+'65535';
      
      addline(@constlist,'UWORD  '+sfp(pdsn^.sn_label)+'pens[] = { '+s+' };','');
    end;

  pos:=0;
  s:='';
  if pdsn^.colorarray<>nil then
    begin
      addline(@constlist,'','');
      addline(@constlist,'UWORD   '+sfp(pdsn^.sn_label)+'Colors[] =','');
      addline(@constlist,'    {','');
      
      while (pdsn^.colorarray^[pos]<>65535) do
        begin
          s:=fmtint(pdsn^.colorarray^[pos])+',';
          s:=s+fmtint(pdsn^.colorarray^[pos+1])+',';
          s:=s+fmtint(pdsn^.colorarray^[pos+2])+',';
          s:=s+fmtint(pdsn^.colorarray^[pos+3])+',';
          addline(@constlist,'    '+s,'');
          inc(pos,4);
        end;
      addline(@constlist,'    65535,0,0,0','');
      addline(@constlist,'    };','');
    end;

  if pdsn^.errorcode then
    begin
      addline(@constlist,'','');
      addline(@constlist,'ULONG  '+sfp(pdsn^.sn_label)+'Error=0;','');
      addline(@externlist,'extern ULONG  '+sfp(pdsn^.sn_label)+'Error;','');
    end;




  addline(@constlist,'','');
  addline(@constlist,'ULONG   '+sfp(pdsn^.sn_label)+'Tags[] = ','');
  addline(@constlist,'    {','');
  
  if pdsn^.loctitle then
    begin
      localestring(sfp(pdsn^.sn_title),sfp(pdsn^.sn_label)+'ScreenName','ScreenTitle : '+sfp(pdsn^.sn_label));
      addline(@constlist,'    (SA_Title),0,','');
    end
   else
    addline(@constlist,'    (SA_Title),(ULONG)"'+sfp(pdsn^.sn_title)+'",','');
  
  bitmappos:=3;
  
  if sfp(pdsn^.sn_pubscreenname)<>'' then
    begin
      inc(bitmappos,2);
      addline(@constlist,'    (SA_PubName),(ULONG)"'+sfp(pdsn^.sn_pubscreenname)+'",','');
    end;
  
  if (pdsn^.screentype=1) or (sfp(pdsn^.sn_pubscreenname)<>'') then
    if pdsn^.dopubsig then
      begin
        inc(bitmappos,2);
        addline(@constlist,'    (SA_PubSig),0,','');
      end;
  
  if pdsn^.bitmap and (not pdsn^.likeworkbench) then
    begin
      addline(@constlist,'    (SA_BitMap),0,','');
    end
   else
    dec(bitmappos,2);
  
  startpos:=bitmappos+1;
  
  if pdsn^.depth=0 then
    addline(@constlist,'    (SA_Depth)   ,1,','')
   else
    addline(@constlist,'    (SA_Depth)   ,'+fmtint(pdsn^.depth)+',','');
  
  addline(@constlist,'    (SA_Left)    ,'+fmtint(pdsn^.left)+',','');
  addline(@constlist,'    (SA_Top)     ,'+fmtint(pdsn^.top)+',','');
  addline(@constlist,'    (SA_Width)   ,'+fmtint(pdsn^.width)+',','');
  addline(@constlist,'    (SA_Height)  ,'+fmtint(pdsn^.height)+',','');
  addline(@constlist,'    (SA_DisplayID),'+fmtint(long(pdsn^.idnum))+',','');
  addline(@constlist,'    (SA_Overscan),'+fmtint(overscanarray[pdsn^.overscan])+',','');
  
  case pdsn^.fonttype of
         0: addline(@constlist,'    (SA_Font),(ULONG)&'+makemyfont(pdsn^.font)+',','');
         1: addline(@constlist,'    (SA_SysFont),0,','');
         2: addline(@constlist,'    (SA_SysFont),1,','');
       end;
  
  addline(@constlist,'    (SA_Behind),'+fmtint(long(pdsn^.behind))+',','');
  addline(@constlist,'    (SA_Quiet),'+fmtint(long(pdsn^.quiet))+',','');
  addline(@constlist,'    (SA_ShowTitle),'+fmtint(long(pdsn^.showtitle))+',','');
  addline(@constlist,'    (SA_AutoScroll),'+fmtint(long(pdsn^.autoscroll))+',','');
  addline(@constlist,'    (SA_FullPalette),'+fmtint(long(pdsn^.fullpalette))+',','');
  
  if pdsn^.interleaved then
    addline(@constlist,'    (0x80000042),(ULONG)TRUE,','');
  if pdsn^.sharedpens then
    addline(@constlist,'    (0x80000040),(ULONG)TRUE,','');
  if pdsn^.exclusive then
    addline(@constlist,'    (0x8000003F),(ULONG)TRUE,','');
  if not pdsn^.draggable then
    addline(@constlist,'    (0x8000003E),(ULONG)FALSE,','');
  if pdsn^.errorcode then
    addline(@constlist,'    (SA_ErrorCode),(ULONG)(&'+sfp(pdsn^.sn_label)+'Error),','');
  
  if (pdsn^.screentype=1) and (sfp(pdsn^.sn_pubscreenname)='') then
    begin
      addline(@constlist,'    (SA_Type),PUBLICSCREEN,','');
    end;
  
  if pdsn^.defpens then
    begin
      addline(@constlist,'    (SA_Pens),(ULONG)&'+sfp(pdsn^.sn_label)+'defpens,','');
    end
   else
    begin
      addline(@constlist,'    (SA_Pens),(ULONG)'+sfp(pdsn^.sn_label)+'pens,','');
    end;
  
  if (pdsn^.colorarray<>nil) then
    begin
      addline(@constlist,'    (SA_Colors),(ULONG)'+sfp(pdsn^.sn_label)+'Colors,','');
      inc(loop);
    end;
  
  addline(@constlist,'    (TAG_DONE)','');
  addline(@constlist,'    };','');
  
  s:='void';
  
  if (pdsn^.screentype=1) or (sfp(pdsn^.sn_pubscreenname)<>'') then
    if (pdsn^.dopubsig) then
      s:='UBYTE pubsig ';
  
  if (not pdsn^.createbitmap) and pdsn^.bitmap and ( not pdsn^.likeworkbench) then
    begin
      if s='void' then
        s:='struct BitMap *bitmap'
       else
        s:=s+', struct BitMap *bitmap';
    end;

  
  addline(@procfunclist,'','');
  addline(@procfuncdefslist,'struct Screen *Open'+sfp(pdsn^.sn_label)+'Screen('+s+');','');
  
  addline(@procfunclist,'struct Screen *Open'+sfp(pdsn^.sn_label)+'Screen('+s+')','');
  addline(@procfunclist,'{','');
   
  if pdsn^.depth=0 then
    begin
      addline(@procfunclist,'struct             DimensionInfo diminfo;','');
      addline(@procfunclist,'ULONG              gidres;','');
      addline(@procfunclist,'DisplayInfoHandle  DisplayHandle;','');
    end;
  
  if pdsn^.createbitmap and pdsn^.bitmap and ( not pdsn^.likeworkbench) then
    begin
      
      addline(@procfunclist,'struct BitMap *bitmap = NULL;','');
      addline(@procfunclist,'UWORD planeNum;','');
      addline(@procfunclist,'BOOL allocatedBitMaps;','');
      addline(@procfunclist,'struct Screen *scr;','');
      
    end;
  
  if pdsn^.depth=0 then
    begin
      addline(@procfunclist,'DisplayHandle = FindDisplayInfo('+fmtint(pdsn^.idnum)+');','');
      addline(@procfunclist,'if (DisplayHandle != NULL)','');
      addline(@procfunclist,'    {','');
      addline(@procfunclist,'    gidres = GetDisplayInfoData(DisplayHandle,&diminfo,sizeof(diminfo),DTAG_DIMS,0);','');
      addline(@procfunclist,'    if (gidres != 0 )','');
      addline(@procfunclist,'        '+sfp(pdsn^.sn_label)+'Tags['+fmtint(bitmappos+2)+'] = diminfo.MaxDepth;','');
      addline(@procfunclist,'    }','');
      
    end;
  
  if pdsn^.createbitmap and pdsn^.bitmap and ( not pdsn^.likeworkbench) then
    begin
   
      addline(@procfunclist,'if ( bitmap = (struct BitMap *)'+
                       'AllocMem(sizeof(struct BitMap),MEMF_PUBLIC | MEMF_CLEAR))','');  {32}
      addline(@procfunclist,'    {','');
      str(pdsn^.width,s);
      s:=s+', ';
      str(pdsn^.height,s2);
      s:=s+s2;
      addline(@procfunclist,'    InitBitMap( bitmap, '+sfp(pdsn^.sn_label)+'Tags['+fmtint(bitmappos+2)+'], '+s+');','');
      addline(@procfunclist,'    allocatedBitMaps = TRUE;','');
      addline(@procfunclist,'    for (planeNum=0;','');
      addline(@procfunclist,'        (planeNum < '+sfp(pdsn^.sn_label)+'Tags['+fmtint(bitmappos+2)+
                             ']) && (allocatedBitMaps == TRUE);','');
      addline(@procfunclist,'        planeNum++)','');
      addline(@procfunclist,'        {','');
       str(pdsn^.width,s);
      s:=s+', ';
      str(pdsn^.height,s2);
      s:=s+s2;
      addline(@procfunclist,'        bitmap->Planes[planeNum] = AllocRaster( '+s+'); ','');
      addline(@procfunclist,'        if (NULL == bitmap->Planes[planeNum])','');
      addline(@procfunclist,'            allocatedBitMaps = FALSE;','');
      addline(@procfunclist,'        else','');
      str(trunc((pdsn^.width+15)/16)*2*pdsn^.height,s);
      addline(@procfunclist,'            BltClear( bitmap->Planes[planeNum], '+s+',1);','');
      addline(@procfunclist,'        };','');
      addline(@procfunclist,'    if ( allocatedBitMaps == FALSE )','');
      addline(@procfunclist,'    	{','');
      addline(@procfunclist,'		for (planeNum = 0; planeNum < '+sfp(pdsn^.sn_label)+
                              'Tags['+fmtint(bitmappos+2)+']; planeNum++ )','');
      addline(@procfunclist,'			{','');
      str(pdsn^.width,s);
      s:=s+', ';
      str(pdsn^.height,s2);
      s:=s+s2;
      addline(@procfunclist,'			if (NULL != bitmap->Planes[planeNum])','');
      addline(@procfunclist,'				FreeRaster( bitmap->Planes[planeNum], '+s+');','');
      addline(@procfunclist,'			};','');
      addline(@procfunclist,'		FreeMem( bitmap, sizeof(struct BitMap));','');      
      addline(@procfunclist,'	    return NULL;','');
      addline(@procfunclist,'    	};','');
      addline(@procfunclist,'    }','');
      addline(@procfunclist,'else','');
      addline(@procfunclist,'    {','');
      
      addline(@procfunclist,'    return NULL;','');
      addline(@procfunclist,'    };','');
      addline(@procfunclist,sfp(pdsn^.sn_label)+'Tags['+fmtint(bitmappos)+'] = (ULONG)bitmap;','');
      
    end;
  
  if (not pdsn^.createbitmap) and pdsn^.bitmap and ( not pdsn^.likeworkbench) then
    begin
      addline(@procfunclist,sfp(pdsn^.sn_label)+'Tags['+fmtint(bitmappos)+'] = (ULONG)bitmap;','');
    end;
  
  if pdsn^.loctitle then
    begin
      addline(@procfunclist,sfp(pdsn^.sn_label)+'Tags[1] = (ULONG)'+
                sfp(producernode^.getstring)+'('+sfp(pdsn^.sn_label)+'ScreenName);','');
    end;
  
  if pdsn^.likeworkbench then
    begin
      
      addline(@procfunclist,'if (((struct Library *)IntuitionBase)->lib_Version > 38)','');
      addline(@procfunclist,'	{','');
      
      addline(@procfunclist,'	'+sfp(pdsn^.sn_label)+'Tags['+fmtint(startpos   )+'] = 0x80000047;','');
      addline(@procfunclist,'	'+sfp(pdsn^.sn_label)+'Tags['+fmtint(startpos+1 )+'] = 1;','');
      addline(@procfunclist,'	'+sfp(pdsn^.sn_label)+'Tags['+fmtint(startpos+2 )+'] = TAG_IGNORE;','');
      addline(@procfunclist,'	'+sfp(pdsn^.sn_label)+'Tags['+fmtint(startpos+4 )+'] = TAG_IGNORE;','');
      addline(@procfunclist,'	'+sfp(pdsn^.sn_label)+'Tags['+fmtint(startpos+6 )+'] = TAG_IGNORE;','');
      addline(@procfunclist,'	'+sfp(pdsn^.sn_label)+'Tags['+fmtint(startpos+8 )+'] = TAG_IGNORE;','');
      addline(@procfunclist,'	'+sfp(pdsn^.sn_label)+'Tags['+fmtint(startpos+10)+'] = TAG_IGNORE;','');
      addline(@procfunclist,'	}','');
    end;
  
  if (pdsn^.screentype=1) or (sfp(pdsn^.sn_pubscreenname)<>'') then
    if pdsn^.dopubsig then
      addline(@procfunclist,sfp(pdsn^.sn_label)+'Tags[5] = (ULONG)pubsig;','');
  
  if pdsn^.errorcode then
    begin
      addline(@procfunclist,sfp(pdsn^.sn_label)+'Error = 0;','');
    end;

 
  if pdsn^.createbitmap and pdsn^.bitmap and ( not pdsn^.likeworkbench)  then
    begin
      addline(@procfunclist,'scr = OpenScreenTagList(NULL,(struct TagItem *)'+sfp(pdsn^.sn_label)+'Tags);','');
      
      addline(@procfunclist,'if (scr != NULL)','');
  
      addline(@procfunclist,'	scr->UserData = (UBYTE *)bitmap;','');
      addline(@procfunclist,'return scr;','');
    end  
   else
    begin
      addline(@procfunclist,'return OpenScreenTagList(NULL,(struct TagItem *)'+sfp(pdsn^.sn_label)+'Tags);','');
    end;
    
  addline(@procfunclist,'}','');
  
end;


end.
