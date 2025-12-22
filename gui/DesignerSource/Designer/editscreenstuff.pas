Unit editscreenstuff;

Interface

Uses exec,intuition,gadtools,graphics,amiga,diskfont,drawwindows,iffparse,
     workbench,utility,definitions,asl,designermenus,routines,obsolete,amigados;

Procedure RendWindoweditwindow( pwin:pwindow; vi:pointer);
Function openwindoweditwindow(pdsn:pdesignerscreennode): Boolean;
Procedure CloseWindoweditwindow(pdsn:pdesignerscreennode);
function newscreennode:pdesignerscreennode;
procedure handlescreennode(pdsn:pdesignerscreennode;messcopy : tintuimessage);

procedure handleeditscreennode(pdsn:pdesignerscreennode);
procedure handlenewscreennode;
procedure handledeletescreennode(pdsn:pdesignerscreennode);

const

  FontGad = 0;
  ChooseFontGad = 1;
  TypeGad = 2;
  PubNameGad = 3;
  PubSigGad = 4;
  BehindGad = 5;
  QuietGad = 6;
  ShowTitleGad = 7;
  AutoScrollGad = 8;
  BitMapGad = 9;
  CrtBitGad = 10;
  ColorsListGad = 11;
  DefaultColorsGad = 12;
  FullPaletteGad = 13;
  TitleGad = 14;
  LeftGad = 15;
  TopGad = 16;
  WidthGad = 17;
  HeightGad = 18;
  DepthGad = 19;
  ScrLblGad = 20;
  LocTitleGad = 21;
  PenlistGad = 22;
  PenColorsGad = 23;
  OKGad = 24;
  CancelGad = 25;
  UpdateGad = 26;
  OverScanGad = 27;
  DefPensGad = 28;
  DisplayIDGad = 29;
  ScrReqGad = 30;

Const
  FontGadCycleTexts : array [0..2] of string[13]=
  (
  'SA_Font'#0,
  'SA_SysFont,0'#0,
  'SA_SysFont,1'#0
  );
  TypeGadCycleTexts : array [0..1] of string[7]=
  (
  'Custom'#0,
  'Public'#0
  );
  PenlistGadListViewTexts : array [0..11] of string[17]=
  (
  'DETAILPEN'#0,
  'BLOCKPEN'#0,
  'TEXTPEN'#0,
  'SHINEPEN'#0,
  'SHADOWPEN'#0,
  'FILLPEN'#0,
  'FILLTEXTPEN'#0,
  'BACKGROUNDPEN'#0,
  'HIGHLIGHTTEXTPEN'#0,
  'BARDETAILPEN'#0,
  'BARBLOCKPEN'#0,
  'BARTRIMPEN'#0
  );
  OverScanGadCycleTexts : array [0..3] of string[9]=
  (
  'TEXT'#0,
  'STANDARD'#0,
  'MAX'#0,
  'VIDEO'#0
  );

Var
  FontGadLabels : array[0..3] of pbyte;
  TypeGadLabels : array[0..2] of pbyte;
  PenlistGadList      : tlist;
  PenlistGadListItems : array[0..11] of tnode;
  OverScanGadLabels : array[0..4] of pbyte;

const
  chararray:array[0..15] of char=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

procedure readiffimagecolors( pdsn:pdesignerscreennode ; pb:pbyte );

Implementation

procedure getimagecolors(pdsn:pdesignerscreennode);
const
  pat2 : string[11] = '~(#?.info)'#0;
var
  pargs     : pwbargarray;
  numofargs : word;
  count     : word;
  pin       : pimagenode;
  pcs       : pcstring;
  loop      : word;
  title     : string[66];
  dir       : string;
  dir2      : string;
  ifr       : pFileRequester;
  tags      : array[1..5] of ttagitem;
  pdmn      : pdesignermenunode;
begin
  waiteverything;
  settagitem(@tags[1],asl_hail,long(@strings[125,1]));
  settagitem(@tags[2],asl_pattern,long(@pat2[1]));
  settagitem(@tags[3],asl_dir,long(imagefilerequest^.fr_drawer));
  settagitem(@tags[4],aslfr_window,long(pdsn^.editwindow));
  settagitem(@tags[5],tag_done,0);
  ifr:=pointer(allocaslrequest(asl_filerequest,@tags[1]));
  if ifr<>nil then
    begin
      if aslrequest(ifr,nil) then
        begin
          dir:='';
          loop:=1;
          ctopas(ifr^.fr_drawer^,dir);
          dir:=dir+#0;
          title:='';
          ctopas(ifr^.fr_file^,title);
          title:=title+#0;
          dir2:=dir;
          if addpart(@dir2[1],@title[1],253) then
            begin
              readiffimagecolors(pdsn,@dir2[1]);
            end;
        end;
      freeaslrequest(pointer(ifr));
    end
   else
    telluser(pdsn^.editwindow,'Could not get file requester.');
  inputmode:=1;
  unwaiteverything;
end;

procedure readiffimagecolors( pdsn:pdesignerscreennode ; pb:pbyte );
var
  ok1                : boolean;
  iff                : piffhandle;
  error              : long;
  bitmaphd           : pbmhd;
  sp                 : pstoredproperty;
  newimagenode       : pimagenode;
  readimage          : pshortintarray;
  num                : word;
  dest               : long;
  count              : long;
  num2               : word;
  widthbytes         : word;
  height             : word;
  psource            : pshortint;
  planesize          : long;
  destline,destplane : word;
  pba                : pbytearray;
  loop               : word;
  pin                : pimagenode;
  pdsn2              : pdesignerscreennode;
begin
  ok1:=true;
  newimagenode:=nil;
  sp:=nil;
  iff:=allociff;
  if iff<>nil then
    begin
      iff^.iff_stream:=open(pb,mode_oldfile);
      if iff^.iff_stream<>0 then
        begin
          initiffasdos(iff);
          error:=openiff(iff,ifff_read);
          if error=0 then
            begin
              if (propchunk(iff,id_ilbm,id_cmap)=0) and
                 (stoponexit(iff,id_ilbm,id_form)=0) then
                begin
                  error:=parseiff(iff,iffparse_scan);
                  sp:=findprop(iff,id_ilbm,id_cmap);
                  if (sp<>nil) then
                    begin
                      pdsn2:=pdsn^.editscrnode;
                      
                      count:=(sp^.sp_size div 3);
                      
                      if count > (1 shl pdsn2^.depth) then
                        count:=(1 shl pdsn2^.depth);
                      
                      if pdsn2^.colorarray<>nil then
                        freemymem(pdsn2^.colorarray,pdsn2^.sizecolorarray);
                      
                      pdsn2^.colorarray:=pwordarray2(Allocmymem( 8* ( 1 + count) ,memf_any));
                      pdsn2^.sizecolorarray:= 8*(1 + count);
                      
                      if pdsn2^.colorarray<>nil then
                        begin
                          
                          pba:=pbytearray(sp^.sp_data);
                          
                          for loop:=0 to count-1 do
                            begin
                               
                               pdsn2^.colorarray^[4*loop+0]:=loop;
                               
                               pdsn2^.colorarray^[4*loop+1]:=
                                         ((pba^[3*loop] and 240) shr 4);
                               pdsn2^.colorarray^[4*loop+2]:=
                                         ((pba^[3*loop+1] and 240) shr 4);
                               pdsn2^.colorarray^[4*loop+3]:=
                                         ((pba^[3*loop+2] and 240) shr 4);
                               
                             end;
                          
                          pdsn2^.colorarray^[4*count]:=65535;
                          
                        end
                       else
                        begin
                          telluser(pdsn^.editwindow,memerror);
                        end;
                      
                    end;
                end;
              closeiff(iff);
            end;
          if not amigados.close_(iff^.iff_stream) then
            telluser(pdsn^.editwindow,'Could not close file. ?!?!?');
        end
       else
        telluser(pdsn^.editwindow,'Could not open file.');
      freeiff(iff);
    end
   else
    telluser(pdsn^.editwindow,'Could not allocate IFF handle.');
end;

function numtohexstr(n:long):string;
var
  res : string[8];
  loop : byte;
begin
  for loop:=1 to 8 do
    begin
      res[9-loop]:=chararray[ n mod 16 ];
      n:=n div 16;
    end;
  res[0]:=chr(8);
  numtohexstr:=res;
end;

procedure hexstrtonum(pdsn:pdesignerscreennode);
var
  res  : string[8];
  loop : byte;
  n    : long;
  str  : string;
  ok   : boolean;
begin
  ok:=true;
  str:=pdsn^.editscrnode^.idstr;
  if length(no0(str))<8 then
    str:=copy('00000000',1,8-length(no0(str)))+str;
  n:=0;
  for loop:=1 to 8 do
    begin
      if (str[loop]<='9') and (str[loop]>='1') then
        n:=n+ord(str[loop])-ord('1')+1
       else
        if (upcase(str[loop])<='F') and (upcase(str[loop])>='A') then
          n:=n+ord(upcase(str[loop]))-ord('A')+10
         else
          if str[loop]<>'0' then
            begin
              if ok then
                telluser(pdsn^.editwindow,'Error in hex number for DisplayID.');
              ok:=false;
            end;
      if loop<8 then
        n:=n*16;
    end;
  if ok then
    pdsn^.editscrnode^.idnum:=n;
end;

function opentestscreen(pdsn:pdesignerscreennode):boolean;
const
  scan : array[0..3] of long=(OSCAN_TEXT,OSCAN_STANDARD,OSCAN_MAX,OSCAN_VIDEO);
var
  pdsn2:pdesignerscreennode;
  tags : array[1..25] of ttagitem;
  loop : word;
  pen1 : word;
  upto : word;
  dep  : word;
  oksofar :boolean;
  di          : pdrawinfo;
  disphandle  : displayinfohandle;
  diminfo     : tdimensioninfo;
  gdidres     : long;
begin
  opentestscreen:=true;
  oksofar:=true;
  pen1:=65535;
  if pdsn<>nil then
    begin
      pdsn2:=pdsn^.editscrnode;
      if pdsn2<>nil then
        begin
          if pdsn^.testscreen=nil then
            begin
              settagitem(@tags[1],sa_width,pdsn2^.width);
              settagitem(@tags[2],sa_height,pdsn2^.height);
              if pdsn2^.depth=0 then
                begin
                  
                  disphandle := FindDisplayInfo(pdsn2^.idnum);
                  if disphandle<>nil then
                    begin
                      gdidres := getdisplayinfodata(disphandle,@diminfo,sizeof(diminfo),DTAG_DIMS, 0);
                      if gdidres<>0 then
                        begin
                          dep:=diminfo.MaxDepth;
                          
                        end
                       else 
                        oksofar:=false;
                    end
                   else
                    oksofar:=false;
                  
                  settagitem(@tags[3],sa_depth,dep);
                end
               else
                settagitem(@tags[3],sa_depth,pdsn2^.depth);
              
              settagitem(@tags[4],sa_overscan,scan[pdsn2^.overscan]);
              settagitem(@tags[5],sa_autoscroll,long(pdsn2^.autoscroll));
              if pdsn^.editscrnode^.defpens then
                settagitem(@tags[6],sa_pens,long(@pen1))
               else
                begin
                  settagitem(@tags[6],sa_pens,long(@pdsn2^.penarray))
                end;
              case pdsn2^.fonttype of
                 0: settagitem(@tags[7],sa_font,long(@pdsn2^.font));
                 1: settagitem(@tags[7],sa_sysfont,0);
                 2: settagitem(@tags[7],sa_sysfont,1);
               end;
              settagitem(@tags[8],sa_displayid,pdsn2^.idnum);
              
              settagitem(@tags[9],sa_title,long(@pdsn2^.title[1])); 
              settagitem(@tags[10],sa_fullpalette,long(pdsn2^.fullpalette));
              
              settagitem(@tags[11],sa_left,pdsn2^.left); 
              settagitem(@tags[12],sa_top,pdsn2^.top); 
              
              settagitem(@tags[13],sa_behind,long(pdsn2^.behind )); 
              settagitem(@tags[14],sa_quiet,long(pdsn2^.quiet )); 
              settagitem(@tags[15],sa_showtitle,long(pdsn2^.showtitle )); 
              settagitem(@tags[16],tag_ignore,0);
              if pdsn2^.colorarray<>nil then
                settagitem(@tags[16],sa_colors,long(pdsn2^.colorarray));
                            
              settagitem(@tags[17],tag_ignore,0);
              settagitem(@tags[18],tag_ignore,0);
              settagitem(@tags[19],tag_ignore,0);
              settagitem(@tags[20],tag_ignore,0);
              settagitem(@tags[21],tag_ignore,0);
              
              if pdsn^.editscrnode^.sharedpens then
                settagitem(@tags[17],sa_sharepens,1);
              if not pdsn^.editscrnode^.draggable then
                settagitem(@tags[18],sa_draggable,0);
              if pdsn^.editscrnode^.exclusive then
                settagitem(@tags[19],sa_exclusive,1);
              if pdsn^.editscrnode^.interleaved then
                settagitem(@tags[20],sa_interleaved,1);
              
              if (pdsn^.editscrnode^.likeworkbench) and ( intuitionbase^.libnode.lib_version > 38 ) then
                begin
                  settagitem(@tags[21],sa_likeworkbench,1);
                  
                  settagitem(@tags[11],tag_ignore,0); 
                  settagitem(@tags[12],tag_ignore,0); 
                  settagitem(@tags[1],tag_ignore,0); 
                  settagitem(@tags[2],tag_ignore,0); 
                  settagitem(@tags[3],tag_ignore,0); 
                  settagitem(@tags[8],tag_ignore,0); 
              
                end;
              
              settagitem(@tags[22],tag_end,0); 
              if oksofar then
                pdsn^.testscreen:=openscreentaglist(nil,@tags[1]);
              opentestscreen:= (pdsn^.testscreen<>nil);
            end;
        end;
    end;
end;

procedure CloseTestScreen(pdsn:pdesignerscreennode);
begin
  if pdsn^.testscreen<>nil then
    begin
      
      if long(closescreen(pdsn^.testscreen))=0 then
        telluser(mainwindow,'Cannot close screen, forgetting it.');
      pdsn^.testscreen:=nil;
    end;
end;

procedure setscreeneditgadgets(pdsn:pdesignerscreennode);
var
  dummy : long;
  item  : pmenuitem;
begin
  if (pdsn^.editwindow<>nil) and (pdsn^.editscrnode<>nil) then
    begin
      gt_setsinglegadgetattr(pdsn^.editwindowgads[leftgad],pdsn^.editwindow,
                             GTIN_Number,long(pdsn^.editscrnode^.left));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[topgad],pdsn^.editwindow,
                             GTIN_Number,long(pdsn^.editscrnode^.top));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[widthgad],pdsn^.editwindow,
                             GTIN_Number,long(pdsn^.editscrnode^.width));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[heightgad],pdsn^.editwindow,
                             GTIN_Number,long(pdsn^.editscrnode^.height));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[depthgad],pdsn^.editwindow,
                             GTsl_level,long(pdsn^.editscrnode^.depth));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[overscangad],pdsn^.editwindow,
                             GTCY_Active,long(pdsn^.editscrnode^.overscan));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[fontgad],pdsn^.editwindow,
                             GTCY_Active,long(pdsn^.editscrnode^.fonttype));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[behindgad],pdsn^.editwindow,
                             GTCB_checked,long(pdsn^.editscrnode^.behind));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[quietgad],pdsn^.editwindow,
                             GTCB_checked,long(pdsn^.editscrnode^.quiet));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[showtitlegad],pdsn^.editwindow,
                             GTCB_checked,long(pdsn^.editscrnode^.showtitle));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[autoscrollgad],pdsn^.editwindow,
                             GTCB_checked,long(pdsn^.editscrnode^.autoscroll));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[bitmapgad],pdsn^.editwindow,
                             GTCB_checked,long(pdsn^.editscrnode^.bitmap));
      gt_setsinglegadgetattr(pdsn^.editwindowgads[crtbitgad],pdsn^.editwindow,
                             GTCB_checked,long(pdsn^.editscrnode^.createbitmap));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[scrlblgad],pdsn^.editwindow,
                             GTST_String,long(@pdsn^.editscrnode^.labelid[1]));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[titlegad],pdsn^.editwindow,
                             GTST_String,long(@pdsn^.editscrnode^.title[1]));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[loctitlegad],pdsn^.editwindow,
                             GTCB_checked,long(pdsn^.editscrnode^.loctitle));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[colorslistgad],pdsn^.editwindow,
                             GTLV_labels,long(@teditimagelist));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[typegad],pdsn^.editwindow,
                             GTcy_active,long(pdsn^.editscrnode^.screentype));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[pubnamegad],pdsn^.editwindow,
                             GTst_string,long(@pdsn^.editscrnode^.pubname[1]));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[pubsiggad],pdsn^.editwindow,
                             GTcb_checked,long(pdsn^.editscrnode^.dopubsig));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[defpensgad],pdsn^.editwindow,
                             GTcb_checked,long(pdsn^.editscrnode^.defpens));
      
      gt_setsinglegadgetattr(pdsn^.editwindowgads[fullpalettegad],pdsn^.editwindow,
                             GTcb_checked,long(pdsn^.editscrnode^.fullpalette));
      
      pdsn^.editscrnode^.idstr:=numtohexstr(pdsn^.editscrnode^.idnum)+#0;
      gt_setsinglegadgetattr(pdsn^.editwindowgads[displayidgad],pdsn^.editwindow,
                             GTst_string,long(@pdsn^.editscrnode^.idstr[1]));
      
      if pdsn^.scrmenu<>nil then
        begin
          
          item:=itemaddress(pdsn^.scrmenu, fullmenunum (screeneditmenu_menu1,screeneditmenuerrorcode,nosub) );
          if pdsn^.editscrnode^.errorcode then
            item^.flags:=item^.flags or checked;
          
          item:=itemaddress(pdsn^.scrmenu, fullmenunum (screeneditmenu_menu1,screeneditmenusharedpens,nosub) );
          if pdsn^.editscrnode^.sharedpens then
            item^.flags:=item^.flags or checked;
          
          item:=itemaddress(pdsn^.scrmenu, fullmenunum (screeneditmenu_menu1,screeneditmenu_menu1_item2,nosub) );
          if pdsn^.editscrnode^.draggable then
            item^.flags:=item^.flags or checked;
          
          item:=itemaddress(pdsn^.scrmenu, fullmenunum (screeneditmenu_menu1,screeneditmenuexclusive,nosub) );
          if pdsn^.editscrnode^.exclusive then
            item^.flags:=item^.flags or checked;
          
          item:=itemaddress(pdsn^.scrmenu, fullmenunum (screeneditmenu_menu1,screeneditmenuinterleaved,nosub) );
          if pdsn^.editscrnode^.interleaved then
            item^.flags:=item^.flags or checked;
          
          item:=itemaddress(pdsn^.scrmenu, fullmenunum (screeneditmenu_menu1,screeneditmenulikeworkbench,nosub) );
          if pdsn^.editscrnode^.likeworkbench then
            item^.flags:=item^.flags or checked;
          
        end;
    end;
end;
                  

procedure handleeditscreennode(pdsn:pdesignerscreennode);
var
  pdsn2 : pdesignerscreennode;
  ok : boolean;
begin
  waiteverything;
  if pdsn<>nil then
    begin
      
      if pdsn^.editscrnode=nil then
        begin
          pdsn2:=newscreennode;
          if pdsn2<>nil then
            begin
              pdsn^.editscrnode:=pdsn2;
              pdsn2^:=pdsn^;
              pdsn^.editscrnode^.font.ta_name:=@pdsn^.editscrnode^.fontname[1];
              pdsn^.editscrnode^.penlistpos:=0;
              ok:=true;
              if pdsn^.colorarray<>nil then
                begin
                  pdsn^.editscrnode^.colorarray:=allocmymem(pdsn^.editscrnode^.sizecolorarray,memf_any);
                  if pdsn^.editscrnode^.colorarray<>nil then
                    begin
                      copymem(pdsn^.colorarray,pdsn^.editscrnode^.colorarray,pdsn^.sizecolorarray);
                      pdsn^.editscrnode^.sizecolorarray:=pdsn^.sizecolorarray;
                    end
                   else
                    begin
                      ok:=false;
                      freemymem(pdsn^.editscrnode,sizeof(tdesignerscreennode));
                      pdsn^.editscrnode:=nil;
                      telluser(mainwindow,memerror);
                    end;
                end;
               
              
              if ok then
                if not openwindoweditwindow(pdsn) then
                  begin
                    telluser(mainwindow,'Could not open window.');
                    freemymem(pointer(pdsn2),sizeof(tdesignerscreennode));
                  end
                 else
                  begin
                    pdsn^.editscrnode^.penlistpos:=0;
                    setscreeneditgadgets(pdsn);
                  
                  end;
            end
           else
            telluser(mainwindow,memerror);
        end
       else
        begin
          if not openwindoweditwindow(pdsn) then;
        end;
    end;
  unwaiteverything;
end;

procedure handlenewscreennode;
var
  pdsn  : pdesignerscreennode;
  dummy : long;
begin
  waiteverything;
  pdsn:=newscreennode;
  if pdsn<>nil then
    begin
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_labels,~0);
      addtail(@teditscreenlist,pnode(pdsn));
      dummy:=getlistpos(@teditscreenlist,pnode(pdsn));
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_labels,long(@teditscreenlist));
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_selected,dummy);
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_top,dummy);
      mainselected:=dummy;
    end
   else
    telluser(mainwindow,memerror);
  unwaiteverything;
end;

procedure handledeletescreennode(pdsn:pdesignerscreennode);
var
  go : boolean;
begin
  waiteverything;
  if pdsn<>nil then
    begin
      
      closewindoweditwindow(pdsn);
      closetestscreen(pdsn);
      
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_labels,~0);
      remove(pnode(pdsn));
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_labels,long(@teditscreenlist));
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_selected,~0);
      
      mainselected:=~0;
      
      if pdsn^.editscrnode<>nil then
        freemymem( pdsn^.editscrnode,sizeof(tdesignerscreennode));

      if pdsn^.colorarray<>nil then
        freemymem(pdsn^.colorarray,pdsn^.sizecolorarray);
          

      freemymem(pdsn,sizeof(tdesignerscreennode))
      
      
    end;
  unwaiteverything;
end;

function newscreennode:pdesignerscreennode;
var
  pdsn : pdesignerscreennode;
  s2   : string;
  pscr : pscreen;
  di   : pdrawinfo;
  pwa  : pwordarray2;
  pos : word;
begin
  pdsn:=allocmymem(sizeof(tdesignerscreennode),memf_any or memf_clear);
  if pdsn<>nil then
    begin
      pdsn^.ln_type:=screennodetype;
      pdsn^.ln_name:=@pdsn^.labelid[1];
      str(sizeoflist(@teditscreenlist),s2);
      pdsn^.labelid:='NewScreen'+s2+#0;
      pdsn^.fit:=true;
      pdsn^.width:=defaultscreenmode.sm_width;
      pdsn^.height:=defaultscreenmode.sm_height;
      pdsn^.depth:=defaultscreenmode.sm_depth;
      pdsn^.fonttype:=2;
      pdsn^.showtitle:=true;
      pdsn^.autoscroll:=true;
      pdsn^.title:='New Screen'#0;
      pdsn^.loctitle:=prefsvalues[15];
      pdsn^.screentype:=0;
      pdsn^.pubname:=''#0;
      pdsn^.dopubsig:=false;
      pdsn^.defpens:=true;
      pdsn^.fullpalette:=true;
      pdsn^.idnum:=defaultscreenmode.sm_displayid;
      {
      pdsn^.font:=defaultscreenmode.font;
      }
      pdsn^.font.ta_name:=@pdsn^.fontname[1];
      pdsn^.font.ta_ysize:=8;
      {
      pdsn^.fontname:=defaultscreenmode.fontname;
      }
      pdsn^.fontname:='topaz.font'#0;
      
      pdsn^.draggable:=true;
      pdsn^.errorcode:=true;
      pdsn^.sharedpens:=false;
      pdsn^.exclusive:=false;
      pdsn^.interleaved:=false;
      pdsn^.likeworkbench:=false;
      
      pscr:=lockpubscreen(nil);
      if pscr<>nil then
        begin
          di:=getscreendrawinfo(pscr);
          if di<>nil then
            begin
              pos:=0;
              pwa:=pwordarray2(di^.dri_pens);
              while (pwa^[pos]<>65535)and (pos<12) do
                begin
                  pdsn^.penarray[pos]:=pwa^[pos];
                  inc(pos);
                end;
              pdsn^.penarray[pos]:=65535;
              freescreendrawinfo(pscr,di);
            end;
          unlockpubscreen(nil,pscr);
        end;
    end;
  newscreennode:=pdsn;
end;

procedure readgadgets(pdsn:pdesignerscreennode);
var
  loop,num : long;
begin
  pdsn^.editscrnode^.labelid:=getstringfromgad(pdsn^.editwindowgads[scrlblgad]);
  pdsn^.editscrnode^.pubname:=getstringfromgad(pdsn^.editwindowgads[pubnamegad]);
  pdsn^.editscrnode^.left:=getintegerfromgad(pdsn^.editwindowgads[leftgad]);
  pdsn^.editscrnode^.top:=getintegerfromgad(pdsn^.editwindowgads[topgad]);
  pdsn^.editscrnode^.width:=getintegerfromgad(pdsn^.editwindowgads[widthgad]);
  pdsn^.editscrnode^.height:=getintegerfromgad(pdsn^.editwindowgads[heightgad]);
  
  {
  pdsn^.editscrnode^.depth:=getintegerfromgad(pdsn^.editwindowgads[depthgad]);
  }
  num:= (1 shl pdsn^.editscrnode^.depth) ;
  loop:=0;
  if pdsn^.colorarray<>nil then
    while (pdsn^.colorarray^[loop]<>65535) do
      begin
        if pdsn^.colorarray^[loop]=num then
          pdsn^.colorarray^[loop]:=65535
         else
          inc(loop,4);
      end;
  
  pdsn^.editscrnode^.behind:=checkedbox(pdsn^.editwindowgads[behindgad]);
  pdsn^.editscrnode^.quiet:=checkedbox(pdsn^.editwindowgads[quietgad]);
  pdsn^.editscrnode^.showtitle:=checkedbox(pdsn^.editwindowgads[showtitlegad]);
  pdsn^.editscrnode^.autoscroll:=checkedbox(pdsn^.editwindowgads[autoscrollgad]);
  pdsn^.editscrnode^.bitmap:=checkedbox(pdsn^.editwindowgads[bitmapgad]);
  pdsn^.editscrnode^.createbitmap:=checkedbox(pdsn^.editwindowgads[crtbitgad]);
  
  pdsn^.editscrnode^.title:=getstringfromgad(pdsn^.editwindowgads[titlegad]);
  pdsn^.editscrnode^.loctitle:=checkedbox(pdsn^.editwindowgads[loctitlegad]);
  pdsn^.editscrnode^.idstr:=getstringfromgad(pdsn^.editwindowgads[displayidgad]);
  hexstrtonum(pdsn);
  
  pdsn^.editscrnode^.idstr:=numtohexstr(pdsn^.editscrnode^.idnum)+#0;
  gt_setsinglegadgetattr(pdsn^.editwindowgads[displayidgad],pdsn^.editwindow,
                         GTst_string,long(@pdsn^.editscrnode^.idstr[1]));
      
  
  pdsn^.editscrnode^.dopubsig:=checkedbox(pdsn^.editwindowgads[pubsiggad]);
  pdsn^.editscrnode^.defpens:=checkedbox(pdsn^.editwindowgads[defpensgad]);
  pdsn^.editscrnode^.fullpalette:=checkedbox(pdsn^.editwindowgads[fullpalettegad]);
  
end;

procedure screenreq(pdsn:pdesignerscreennode);
var
  asl_tb : long;
  aslreq : pscreenmoderequester;
  tags   : array[1..10] of ttagitem;
begin
  asl_tb:=tag_user+$80000;
if aslbase^.lib_version>37 then
begin
  
  
  settagitem(@tags[ 1],2+asl_tb,long(pdsn^.editwindow));
  settagitem(@tags[ 2],42+asl_tb,long(true));
  
  {
  settagitem(@tags[ 3],109+asl_tb,long(false));
  settagitem(@tags[ 4],110+asl_tb,long(false));
  settagitem(@tags[ 5],111+asl_tb,long(false));
  settagitem(@tags[ 6],112+asl_tb,long(false));
  settagitem(@tags[ 7],113+asl_tb,long(false));
  }
  
  settagitem(@tags[ 3],asl_tb+100,pdsn^.editscrnode^.idnum);
  settagitem(@tags[ 4],asl_tb+118,200);
  settagitem(@tags[ 5],tag_done,0);
  settagitem(@tags[ 6],0,0);
  settagitem(@tags[ 7],0,0);
  
  aslreq:=pscreenmoderequester(allocaslrequest(2,@tags[1]));
  if aslreq<>nil then
    begin
      if aslrequest(pointer(aslreq),nil) then
        begin
          pdsn^.editscrnode^.idnum:=aslreq^.sm_displayid;
          pdsn^.editscrnode^.idstr:=numtohexstr(pdsn^.editscrnode^.idnum)+#0;
          gt_setsinglegadgetattr(pdsn^.editwindowgads[displayidgad],pdsn^.editwindow,
                                 GTst_string,long(@pdsn^.editscrnode^.idstr[1]));
        end;
      freeaslrequest(pointer(aslreq));
    end
   else
    begin
      telluser(mainwindow,'Unable to open screen requester.');
    end;
  
end
else
telluser(pdsn^.editwindow,'Sorry, V38+ only.');

end;

procedure handlescreennode(pdsn:pdesignerscreennode;messcopy : tintuimessage);
var
  pgsel     : pgadget;
  class     : long;
  code      : word;
  dummy     : long;
  MenuNumber : word;
  st         : string;
  ItemNumber : Word;
  SubNumber  : Word;
  upto       : word;
  Item    : pMenuItem;
  pin     : pimagenode;
  dummy3  : long;
  psn     : pstringnode;
  menudone: boolean;
  tags    : array[1..10] of ttagitem;
  pdsn2 : pdesignerscreennode;
  loop : long;
begin
  code:=messcopy.code;
  MenuNumber:=code;
  class:=messcopy.class;
  menudone:=false;
  pgsel:=pgadget(messcopy.iaddress);
  dummy3:=0;
  
  dummy:=~0;
  
        
  case class of
    idcmp_menupick :
      begin
        
        while (menunumber<>menunull) do
        begin
        
        Item:=ItemAddress( pdsn^.ScrMenu, MenuNumber);
        ItemNumber:=ITEMNUM(MenuNumber);
        SubNumber:=SUBNUM(MenuNumber);
        MenuNumber:=MENUNUM(MenuNumber);
        Case MenuNumber of
          screeneditmenu_menu1:
            case itemnumber of
              screeneditmenuerrorcode:
                begin
                  pdsn^.editscrnode^.errorcode:=(item^.flags and checked)<>0;
                end;
              screeneditmenusharedpens:
                begin
                  pdsn^.editscrnode^.sharedpens:=(item^.flags and checked)<>0;
                end;
              screeneditmenu_menu1_item2:  { draggable }
                begin
                  pdsn^.editscrnode^.draggable:=(item^.flags and checked)<>0;
                end;
              screeneditmenuexclusive:
                begin
                  pdsn^.editscrnode^.exclusive:=(item^.flags and checked)<>0;
                end;
              screeneditmenuinterleaved:
                begin
                  pdsn^.editscrnode^.interleaved:=(item^.flags and checked)<>0;
                end;
              screeneditmenulikeworkbench:
                begin
                  pdsn^.editscrnode^.likeworkbench:=(item^.flags and checked)<>0;
                end;
             end;
          Screeneditmenutitle :
            case itemnumber of
              Screeneditmenu_update :
                Begin
                  dummy:=updategad;
                end;
              screeneditmenu_help :
                Begin
                  dummy:=69;
                end;
              Screeneditmenu_ok :
                Begin
                  dummy:=okgad;
                end;
              Screeneditmenu_cancel :
                Begin
                  dummy:=cancelgad;
                end;
              screeneditmenutitle_item7:
                begin
                  getimagecolors(pdsn);
                end;
             end;
         end;

        menunumber:=item^.nextselect;
        end;
        
      end;
    idcmp_gadgetup :
      begin
        dummy:=pgsel^.gadgetid;
      end;
    idcmp_closewindow :
      if inputmode=0 then
        begin
          waiteverything;
          closewindoweditwindow(pdsn);
          closetestscreen(pdsn);
          if pdsn^.editscrnode^.colorarray<>nil then
            freemymem(pdsn^.editscrnode^.colorarray,pdsn^.editscrnode^.sizecolorarray);
          freemymem(pdsn^.editscrnode,sizeof(tdesignerscreennode));
          pdsn^.editscrnode:=nil;
          unwaiteverything;
          inputmode:=1;
        end;
   end;
  
        case dummy of
          choosefontgad :
              if inputmode=0 then
                begin
                  waiteverything;
                  settagitem(@tags[1],asl_window,long(pdsn^.editwindow));
                  settagitem(@tags[2],asl_fontname,long(@pdsn^.editscrnode^.fontname[1]));
                  settagitem(@tags[3],asl_fontheight,long(pdsn^.editscrnode^.font.ta_ysize));
                  settagitem(@tags[4],asl_fontstyles,long(pdsn^.editscrnode^.font.ta_style));
                  settagitem(@tags[5],asl_fontflags,long(pdsn^.editscrnode^.font.ta_flags));
                  settagitem(@tags[6],tag_done,0);
                  if (aslrequest(fontrequest,@tags[1])) then
                    begin
                      pfr:=pfontrequester(fontrequest);
                      pdsn^.editscrnode^.font.ta_ysize:=pfr^.fo_attr.ta_ysize;
                      pdsn^.editscrnode^.font.ta_style:=pfr^.fo_attr.ta_style;
                      pdsn^.editscrnode^.font.ta_flags:=pfr^.fo_attr.ta_flags;
                      ctopas(pfr^.fo_attr.ta_name^,st);
                      if length(st)>44 then
                        st:=copy(st,1,44);
                      pdsn^.editscrnode^.fontname:=st+#0;
                    end;
                  unwaiteverything;
                  inputmode:=1;
                end;
          displayidgad:
              begin
                if inputmode=0 then
                  begin
                    pdsn^.editscrnode^.idstr:=getstringfromgad(pdsn^.editwindowgads[displayidgad]);
                    hexstrtonum(pdsn);
                    
                    pdsn^.editscrnode^.idstr:=numtohexstr(pdsn^.editscrnode^.idnum)+#0;
                    gt_setsinglegadgetattr(pdsn^.editwindowgads[displayidgad],pdsn^.editwindow,
                                           GTst_string,long(@pdsn^.editscrnode^.idstr[1]));
                    
                  end;
              end;
          colorslistgad:
            if inputmode=0 then
              begin
                waiteverything;
                pin:=pimagenode(getnthnode(@teditimagelist,code));
                if pin<>nil then
                  begin
                    if pin^.colourmap<>nil then
                      begin
                        
                        pdsn2:=pdsn^.editscrnode;
                        
                        if pdsn2^.colorarray<>nil then
                          freemymem(pdsn2^.colorarray,pdsn2^.sizecolorarray);
                        
                        upto:=(1 shl pdsn2^.depth)-1;
                        
                        if upto>(1 shl pin^.depth)-1 then
                          upto:=(1 shl pin^.depth)-1;
                        
                        pdsn2^.colorarray:=pwordarray2(Allocmymem( 8*(2 + upto) ,memf_any));
                        pdsn2^.sizecolorarray:= 8*(2 + upto);
                    
                        if pdsn2^.colorarray<>nil then
                          begin
                            
                            for loop:=0 to upto do
                              begin
                                pdsn2^.colorarray^[4*loop+0]:=loop;
                            
                                pdsn2^.colorarray^[4*loop+1]:=
                                         (pin^.colourmap^[loop] and 3840) shr 8;
                                pdsn2^.colorarray^[4*loop+2]:=
                                         (pin^.colourmap^[loop] and 240) shr 4;
                                pdsn2^.colorarray^[4*loop+3]:=
                                         (pin^.colourmap^[loop] and 15);
                              end;
                        
                            pdsn2^.colorarray^[4*(upto+1)]:=$FFFF;
                            pdsn2^.colorarray^[4*(upto+1)+1]:=0;
                            pdsn2^.colorarray^[4*(upto+1)+2]:=0;
                            pdsn2^.colorarray^[4*(upto+1)+3]:=0;
                        
                          end
                         else
                          telluser(pdsn^.editwindow,memerror);
                        
                      end;
                  end;
                unwaiteverything;
                inputmode:=1;
              end;
          defaultcolorsgad:
              if inputmode=0 then
                begin
                  waiteverything;
                  if pdsn^.editscrnode^.colorarray<>nil then
                    freemymem(pdsn^.editscrnode^.colorarray,pdsn^.editscrnode^.sizecolorarray);
                  pdsn^.editscrnode^.colorarray:=nil;
                  unwaiteverything;
                  inputmode:=1;
                end;
          scrreqgad:
              begin
                waiteverything;
                if inputmode=0 then
                  screenreq(pdsn);
                unwaiteverything;
                inputmode:=1;
              end;
          overscangad:
              pdsn^.editscrnode^.overscan:=code;
          typegad:
              pdsn^.editscrnode^.screentype:=code;
          fontgad:
              pdsn^.editscrnode^.fonttype:=code;
          updategad:
            if inputmode=0 then
              begin
                waiteverything;
                readgadgets(pdsn);
                
                if pdsn^.oneditscr or prefsvalues[18] then
                  closewindoweditwindow(pdsn);
                   
                if pdsn^.testscreen<>nil then
                  closetestscreen(pdsn);
                
                if opentestscreen(pdsn) then
                  begin
                    if prefsvalues[18] then
                      begin
                        if openwindoweditwindow(pdsn) then
                          begin
                            setscreeneditgadgets(pdsn);
                            pdsn^.editscrnode^.penlistpos:=0;
                          end
                         else
                          begin
                            closetestscreen(pdsn);
                            if openwindoweditwindow(pdsn) then
                              begin
                                setscreeneditgadgets(pdsn);
                                pdsn^.editscrnode^.penlistpos:=0;
                              end
                             else
                              begin
                                telluser(mainwindow,'Cannot open window.');
                                if pdsn^.editscrnode^.colorarray<>nil then
                                  freemymem(pdsn^.editscrnode^.colorarray,pdsn^.editscrnode^.sizecolorarray);
                                if pdsn^.editscrnode<>nil then
                                  freemymem(pdsn^.editscrnode,sizeof(tdesignerscreennode));
                                pdsn^.editscrnode:=nil;
                              end;
                          end;
                      end;
                  end
                 else
                  begin
                    telluser(mainwindow,'Cannot open screen.');
                    if openwindoweditwindow(pdsn) then
                      begin
                        setscreeneditgadgets(pdsn);
                        pdsn^.editscrnode^.penlistpos:=0;
                      end
                     else
                      begin
                        telluser(mainwindow,'Cannot open edit window.');
                        if pdsn^.editscrnode^.colorarray<>nil then
                          freemymem(pdsn^.editscrnode^.colorarray,pdsn^.editscrnode^.sizecolorarray);
                        if pdsn^.editscrnode<>nil then
                          freemymem(pdsn^.editscrnode,sizeof(tdesignerscreennode));
                        pdsn^.editscrnode:=nil;
                      end;
                  end;
                
                unwaiteverything;
              end;
          cancelgad:
            if inputmode=0 then
              begin
                waiteverything;
                closewindoweditwindow(pdsn);
                closetestscreen(pdsn);
                if pdsn^.editscrnode^.colorarray<>nil then
                  freemymem(pdsn^.editscrnode^.colorarray,pdsn^.editscrnode^.sizecolorarray);
                freemymem(pdsn^.editscrnode,sizeof(tdesignerscreennode));
                pdsn^.editscrnode:=nil;
                unwaiteverything;
                inputmode:=1;
              end;
          okgad:
            if inputmode=0 then
              begin
                waiteverything;
                
                readgadgets(pdsn);
                
                closewindoweditwindow(pdsn);
                closetestscreen(pdsn);
                
                { copy stuff }
                pdsn^.left:=pdsn^.editscrnode^.left;
                pdsn^.top:=pdsn^.editscrnode^.top;
                pdsn^.width:=pdsn^.editscrnode^.width;
                pdsn^.height:=pdsn^.editscrnode^.height;
                pdsn^.depth:=pdsn^.editscrnode^.depth;
                pdsn^.overscan:=pdsn^.editscrnode^.overscan;
                pdsn^.fonttype:=pdsn^.editscrnode^.fonttype;
                pdsn^.behind:=pdsn^.editscrnode^.behind;
                pdsn^.quiet:=pdsn^.editscrnode^.quiet;
                pdsn^.showtitle:=pdsn^.editscrnode^.showtitle;
                pdsn^.autoscroll:=pdsn^.editscrnode^.autoscroll;
                pdsn^.bitmap:=pdsn^.editscrnode^.bitmap;
                pdsn^.createbitmap:=pdsn^.editscrnode^.createbitmap;
                pdsn^.title:=pdsn^.editscrnode^.title;
                pdsn^.loctitle:=pdsn^.editscrnode^.loctitle;
                pdsn^.idstr:=pdsn^.editscrnode^.idstr;
                pdsn^.idnum:=pdsn^.editscrnode^.idnum;
                pdsn^.screentype:=pdsn^.editscrnode^.screentype;
                pdsn^.dopubsig:=pdsn^.editscrnode^.dopubsig;
                pdsn^.defpens:=pdsn^.editscrnode^.defpens;
                pdsn^.fullpalette:=pdsn^.editscrnode^.fullpalette;
                pdsn^.labelid:=pdsn^.editscrnode^.labelid;
                pdsn^.pubname:=pdsn^.editscrnode^.pubname;
                pdsn^.font:=pdsn^.editscrnode^.font;
                pdsn^.fontname:=pdsn^.editscrnode^.fontname;
                pdsn^.font.ta_name:=@pdsn^.fontname[1];
                pdsn^.penarray:=pdsn^.editscrnode^.penarray;
                if pdsn^.colorarray<>nil then
                    freemymem(pdsn^.colorarray,pdsn^.sizecolorarray);
                pdsn^.colorarray:=pdsn^.editscrnode^.colorarray;
                pdsn^.sizecolorarray:=pdsn^.editscrnode^.sizecolorarray;
                
                pdsn^.errorcode:=pdsn^.editscrnode^.errorcode;
                pdsn^.sharedpens:=pdsn^.editscrnode^.sharedpens;
                pdsn^.draggable:=pdsn^.editscrnode^.draggable;
                pdsn^.exclusive:=pdsn^.editscrnode^.exclusive;
                pdsn^.interleaved:=pdsn^.editscrnode^.interleaved;
                pdsn^.likeworkbench:=pdsn^.editscrnode^.likeworkbench;
                
                freemymem(pdsn^.editscrnode,sizeof(tdesignerscreennode));
                pdsn^.editscrnode:=nil;
                
                unwaiteverything;
                inputmode:=1;
              end;
            penlistgad:
              begin
                pdsn^.editscrnode^.penlistpos:=code;
                gt_setsinglegadgetattr(pdsn^.editwindowgads[pencolorsgad],pdsn^.editwindow,
                                       GTpa_color,pdsn^.editscrnode^.penarray[pdsn^.editscrnode^.penlistpos]);
              end;
            pencolorsgad:
              begin
                pdsn^.editscrnode^.penarray[pdsn^.editscrnode^.penlistpos]:=code;
              end;
            69:
              if inputmode=0 then
                helpwindow(@defaulthelpwindownode,screenhelp);
          depthgad:
            begin
              pdsn^.editscrnode^.depth:=code;
            end;   
         end;

  
end;

Procedure RendWindoweditwindow( pwin:pwindow; vi:pointer);
Var
  Offx     : word;
  Offy     : word;
  tags     : array[1..3] of ttagitem;
Begin
  If pwin<>nil then
    Begin
      Offx:=pwin^.borderleft;
      Offy:=pwin^.bordertop;
      settagitem(@tags[1],GTBB_Recessed,long(True));
      settagitem(@tags[2],GT_VisualInfo,long(vi));
      settagitem(@tags[3],Tag_Done,0);
      DrawBevelBoxA(pwin^.RPort,4+Offx,2+Offy,
        254,44,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,4+Offx,47+Offy,
        255,87,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,4+Offx,135+Offy,
        255,32,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,261+Offx,2+Offy,
        158,75,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,261+Offx,78+Offy,
        158,71,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,422+Offx,2+Offy,
        208,43,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,422+Offx,46+Offy,
        208,121,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,4+Offx,168+Offy,
        626,17,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,261+Offx,150+Offy,
        158,17,@tags[2]);
    end;
end;

Function openwindoweditwindow(pdsn:pdesignerscreennode): Boolean;
const
  Gadgetstrings : array[0..30] of string[15]=
  (
  'Font'#0,
  'Choose Font...'#0,
  'Type'#0,
  'PubName'#0,
  'Do SA_PubSig'#0,
  'SA_Behind'#0,
  'SA_Quiet'#0,
  'SA_ShowTitle'#0,
  'SA_AutoScroll'#0,
  'SA_BitMap'#0,
  'Create BitMap'#0,
  'SA_Colors'#0,
  'Default'#0,
  'SA_FullPalette'#0,
  'SA_Title'#0,
  'SA_Left'#0,
  'SA_Top'#0,
  'SA_Width'#0,
  'SA_Height'#0,
  '   SA_Depth'#0,
  'ScreenLabel'#0,
  'Localize Title'#0,
  'SA_Pens'#0,
  ''#0,
  'OK'#0,
  'Cancel'#0,
  'Update'#0,
  'SA_OverScan'#0,
  'Default Pens'#0,
  'ID'#0,
  'Screen Req'#0
  );
  lform : string[10] = '%ld '#0;
  ZoomInfo : array [1..4] of word = (200,0,200,25);
  wintitle : string [12]='Edit Screen'#0;
  otherstring : string[6]='Open'#0;
  helpstr : string[8]='Help'#0;
Var
  Dummy : Boolean;
  needed: boolean;
  pos   : word;
  di    : pdrawinfo;
  pscr2 : pscreen;
  Loop  : Word;
  offx  : Word;
  offy  : Word;
  tags  : array[1..40] of ttagitem;
  pdi   : pDrawInfo;
  pScr  : PScreen;
  pwa   : pwordarray2;
  pgad  : pgadget;
  openonscreen : boolean;
  number:word;
begin
  pdsn^.oneditscr:=false;
  openonscreen:=false;
  openwindoweditwindow:=true;
  if pdsn^.editwindow=nil then
    begin
      pscr:=nil;
      if (pdsn^.testscreen<>nil) and prefsvalues[18] then
        begin
          openonscreen:=true;
          pscr:=pdsn^.testscreen;
          offx:=PScr^.WBorLeft;
          offy:=PScr^.WBorTop+PScr^.Font^.ta_YSize+1;
          if (offy+180>pscr^.height) or (627+offx>pscr^.width) then
            begin
              pscr:=nil;
              if pdsn^.fit then
                telluser(mainwindow,'Screen to small for edit window.');
              pdsn^.fit:=false;
              openonscreen:=false;
            end
           else
            pdsn^.fit:=true;
        end;
      if pscr=nil then
        pScr:=lockPubScreen(Nil);
      If pScr<>Nil then
        Begin
          offx:=PScr^.WBorLeft;
          offy:=PScr^.WBorTop+PScr^.Font^.ta_YSize+1;
          pdsn^.editwindowvisualinfo:=getvisualinfoa( PScr, Nil);
          if pdsn^.editwindowvisualinfo<>nil then
            Begin
              
              pdsn^.penlistpos:=0;
              
              pdsn^.editwindowGList:=Nil;
              pGad:=createcontext(@pdsn^.editwindowGList);
              pdsn^.editwindowDepth:=pscr^.bitmap.depth;
              For Loop:=0 to 2 do
                FontGadLabels[Loop]:=@FontGadCycleTexts[Loop,1];
              FontGadLabels[3]:=Nil;
              SetTagItem(@tags[1], GTCY_Labels, Long(@FontGadLabels));
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 7, offx+8, offy+137, 
              	150, 13, 0, @gadgetstrings[0,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              pdsn^.editwindowgads[0]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+8, offy+151, 
              	150, 13, 1, @gadgetstrings[1,1],
                                       @ttopaz80, 16,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[1]:=pGad;
              For Loop:=0 to 1 do
                TypeGadLabels[Loop]:=@TypeGadCycleTexts[Loop,1];
              TypeGadLabels[2]:=Nil;
              SetTagItem(@tags[1], GTCY_Labels, Long(@TypeGadLabels));
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 7, offx+427, offy+4, 
              	136, 13, 2, @gadgetstrings[2,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              pdsn^.editwindowgads[2]:=pGad;
              pgad:=GeneralGadToolsGad( 12, offx+427, offy+18, 
              	136, 13, 3, @gadgetstrings[3,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[3]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+427, offy+32, 
              	26, 11, 4, @gadgetstrings[4,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[4]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+265, offy+4, 
              	26, 11, 5, @gadgetstrings[5,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[5]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+265, offy+16, 
              	26, 11, 6, @gadgetstrings[6,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[6]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+265, offy+28, 
              	26, 11, 7, @gadgetstrings[7,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[7]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+265, offy+40, 
              	26, 11, 8, @gadgetstrings[8,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[8]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+265, offy+52, 
              	26, 11, 9, @gadgetstrings[9,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[9]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+265, offy+64, 
              	26, 11, 10, @gadgetstrings[10,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[10]:=pGad;
              Settagitem(@tags[1], GTLV_ShowSelected, 0);
              Settagitem(@tags[2], GTLV_Selected, 0);
              Settagitem(@tags[3], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 4, offx+265, offy+93, 
              	150, 40, 11, @gadgetstrings[11,1],
                                       @ttopaz80, 4,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[2]);
              pdsn^.editwindowgads[11]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+265, offy+134, 
              	150, 13, 12, @gadgetstrings[12,1],
                                       @ttopaz80, 16,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[12]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+426, offy+151, 
              	26, 11, 13, @gadgetstrings[13,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[13]:=pGad;
              pgad:=GeneralGadToolsGad( 12, offx+8, offy+18, 
              	150, 13, 14, @gadgetstrings[14,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[14]:=pGad;
              Settagitem(@tags[1], STRINGA_Justification, 512);
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 3, offx+8, offy+49, 
              	150, 13, 15, @gadgetstrings[15,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              pdsn^.editwindowgads[15]:=pGad;
              Settagitem(@tags[1], STRINGA_Justification, 512);
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 3, offx+8, offy+63, 
              	150, 13, 16, @gadgetstrings[16,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              pdsn^.editwindowgads[16]:=pGad;
              Settagitem(@tags[1], STRINGA_Justification, 512);
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 3, offx+8, offy+77, 
              	150, 13, 17, @gadgetstrings[17,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              pdsn^.editwindowgads[17]:=pGad;
              Settagitem(@tags[1], STRINGA_Justification, 512);
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 3, offx+8, offy+91, 
              	150, 13, 18, @gadgetstrings[18,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              pdsn^.editwindowgads[18]:=pGad;
              
              Settagitem(@tags[1], pga_freedom , lorient_horiz );
              Settagitem(@tags[2], gtsl_max, 8);
              Settagitem(@tags[3], gtsl_levelformat, long(@lform[1]));
              Settagitem(@tags[4], gtsl_levelplace, placetext_right);
              Settagitem(@tags[5], ga_relverify, long(true));
              Settagitem(@tags[6], gtsl_maxlevellen, 2);
              Settagitem(@tags[7], Tag_Done, 0);
             
              pgad:=GeneralGadToolsGad( slider_kind, offx+8, offy+105, 
              	126, 13, 19, @gadgetstrings[19,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              
              pdsn^.editwindowgads[19]:=pGad;
              pgad:=GeneralGadToolsGad( 12, offx+8, offy+4, 
              	150, 13, 20, @gadgetstrings[20,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[20]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+9, offy+33, 
              	26, 11, 21, @gadgetstrings[21,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[21]:=pGad;
              NewList(@PenlistGadList);
              
              
              needed:=false;
              pscr2:=lockpubscreen(nil);
              if pscr2<>nil then
                begin
                  di:=getscreendrawinfo(pscr2);
                  if di<>nil then
                    begin
                      pos:=0;
                      pwa:=pwordarray2(di^.dri_pens);
                      while (pwa^[pos]<>65535)and (pos<12) do
                        begin
                          
                          if pdsn^.editscrnode^.penarray[pos]=65535 then
                            needed:=true;
                          
                          if needed then
                            pdsn^.editscrnode^.penarray[pos]:=pwa^[pos];
                          
                          inc(pos);
                        end;
                      pdsn^.editscrnode^.penarray[pos]:=65535;
                      
                      freescreendrawinfo(pscr2,di);
                    end;
                  unlockpubscreen(nil,pscr2);
                end;


              
              For Loop:=0 to pos-1 do
                Begin
                  PenlistGadListItems[Loop].ln_name:=@PenlistGadListViewTexts[Loop,1];
                  AddTail( @PenlistGadList, @PenlistGadListItems[Loop]);
                end;
                
              Settagitem(@tags[1], GTLV_ShowSelected, 0);
              Settagitem(@tags[2], GTLV_Selected, 0);
              SetTagItem(@tags[3], GTLV_Labels, Long(@PenlistGadList));
              Settagitem(@tags[4], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 4, offx+426, offy+62, 
              	200, 50, 22, @gadgetstrings[22,1],
                                       @ttopaz80, 4,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              
              pdsn^.editwindowgads[22]:=pGad;
              
              Settagitem(@tags[1], GTPA_Depth, pdsn^.editwindowDepth);
              Settagitem(@tags[2], GTPA_IndicatorWidth, 20);
              Settagitem(@tags[3], GTPA_color, pdsn^.editscrnode^.penarray[0]);
              Settagitem(@tags[4], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 8, offx+426, offy+112, 
              	200, 26, 23, @gadgetstrings[23,1],
                                       @ttopaz80, 1,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              pdsn^.editwindowgads[23]:=pGad;
              
              pgad:=GeneralGadToolsGad( 1, offx+10, offy+170, 
              	100, 13, 24, @gadgetstrings[24,1],
                                       @ttopaz80, 16,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[24]:=pGad;
              
              pgad:=GeneralGadToolsGad( 1, offx+523, offy+170, 
              	100, 13, 25, @gadgetstrings[25,1],
                                       @ttopaz80, 16,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[25]:=pGad;
              
              pgad:=GeneralGadToolsGad( 1, offx+138, offy+170, 
              	100, 13, 69, @helpstr[1],
                                       @ttopaz80, 16,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              
              if pdsn^.testscreen<>nil then
                pgad:=GeneralGadToolsGad( 1, offx+266, offy+170, 
              	  100, 13, 26, @gadgetstrings[26,1],
                                         @ttopaz80, 16,
                	pdsn^.editwindowvisualinfo, pGad, Nil, Nil)
               else
                pgad:=GeneralGadToolsGad( 1, offx+266, offy+170, 
              	  100, 13, 26, @otherstring[1],
                                         @ttopaz80, 16,
                	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              
              pdsn^.editwindowgads[26]:=pGad;
              
              For Loop:=0 to 3 do
                OverScanGadLabels[Loop]:=@OverScanGadCycleTexts[Loop,1];
              OverScanGadLabels[4]:=Nil;
              SetTagItem(@tags[1], GTCY_Labels, Long(@OverScanGadLabels));
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 7, offx+8, offy+119, 
              	150, 13, 27, @gadgetstrings[27,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              pdsn^.editwindowgads[27]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+426, offy+139, 
              	26, 11, 28, @gadgetstrings[28,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowgads[28]:=pGad;
              Settagitem(@tags[1], GTST_MaxChars, 8);
              Settagitem(@tags[2], STRINGA_Justification, 512);
              Settagitem(@tags[3], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 12, offx+265, offy+152, 
              	120, 13, 29, @gadgetstrings[29,1],
                                       @ttopaz80, 2,
              	pdsn^.editwindowvisualinfo, pGad, Nil, @tags[1]);
              pdsn^.editwindowgads[29]:=pGad;
              
              pgad:=GeneralGadToolsGad( 1, offx+394, offy+170, 
              	100, 13, 30, @gadgetstrings[30,1],
                                       @ttopaz80, 16,
              	pdsn^.editwindowvisualinfo, pGad, Nil, Nil);
              pdsn^.editwindowGads[30]:=pGad;
              
              if pgad<>nil then
                begin
                  settagitem(@tags[ 1],WA_Left  ,50);
                  settagitem(@tags[ 2],WA_Top   ,37);
                  settagitem(@tags[ 3],WA_Width ,637+offx);
                  settagitem(@tags[ 4],WA_Height,188+offy);
                  settagitem(@tags[ 5],WA_Title ,long(@WinTitle[1]));
                  settagitem(@tags[ 6],WA_MinWidth ,150);
                  settagitem(@tags[ 7],WA_MinHeight,25);
                  settagitem(@tags[ 8],WA_MaxWidth ,1200);
                  settagitem(@tags[ 9],WA_MaxHeight,1200);
                  settagitem(@tags[10],WA_DragBar,long(true));
                  settagitem(@tags[11],WA_DepthGadget,long(true));
                  settagitem(@tags[12],WA_CloseGadget,long(true));
                  settagitem(@tags[13],WA_Dummy + $30,long(true));
                  settagitem(@tags[14],WA_Activate,long(true));
                  settagitem(@tags[15],WA_SmartRefresh,long(true));
                  settagitem(@tags[16],WA_AutoAdjust,long(true));
                  settagitem(@tags[17],WA_Gadgets,long(pdsn^.editwindowglist));
                  settagitem(@tags[18],Tag_Done,0);
                  if openonscreen then
                    begin
                      pdsn^.oneditscr:=true;
                      settagitem(@tags[18],WA_Customscreen,long(pdsn^.testscreen));
                    end;
                  settagitem(@tags[19],Tag_Done,0);
                  pdsn^.editwindow:=openwindowtaglistnicely(Nil,@tags[1],4194940 or idcmp_menupick);
                  if pdsn^.editwindow<>nil then
                    begin
                      GT_RefreshWindow( pdsn^.editwindow, Nil);
                      RendWindoweditwindow( pdsn^.editwindow,pdsn^.editwindowVisualInfo );
                      pdsn^.editwindow^.userdata:=pointer(pdsn);
                      if makemenuscreeneditmenu(pdsn^.editwindowvisualinfo) then
                        begin
                          pdsn^.scrmenu:=screeneditmenu;
                          if setmenustrip(pdsn^.editwindow,pdsn^.scrmenu) then;
                        end
                       else
                        telluser(pdsn^.editwindow,'Cannot make menu.');
                    end
                   else
                    Begin
                      OpenWindoweditwindow:=false;
                      FreeVisualInfo(pdsn^.editwindowVisualInfo);
                      FreeGadgets(pdsn^.editwindowGList);
                    end;
                end
               else
                Begin
                  OpenWindoweditwindow:=false;
                  FreeVisualInfo(pdsn^.editwindowVisualinfo);
                End;
            end
           else
            openwindoweditwindow:=false;
          UnLockPubScreen( Nil, PScr);
        end
       else
        openwindoweditwindow:=false;
    end
   else
    begin
      WindowToFront(pdsn^.editwindow);
      activatewindow(pdsn^.editwindow);
    end;
end;

Procedure CloseWindoweditwindow(pdsn:pdesignerscreennode);
Begin
  if pdsn^.editwindow<>nil then
    Begin
      if pdsn^.scrmenu<>nil then
        begin
          clearmenustrip(pdsn^.editwindow);
          freemenus(pdsn^.scrmenu);
          pdsn^.scrmenu:=nil;
        end;
      Closewindowsafely(pdsn^.editwindow);
      pdsn^.editwindow:=Nil;
      FreeVisualInfo(pdsn^.editwindowVisualinfo);
      FreeGadgets(pdsn^.editwindowGList);
    end;
end;

End.
