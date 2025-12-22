unit routines;

interface

uses utility,layers,gadtools,exec,intuition,dos,objectproduction,producerwininterface,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench,producerlib;

{
function makemyfont(font:ttextattr;fontname:string):string;
}

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
procedure freemymem(mem:pointer);
function allocmymem(size:long;typ:long):pointer;
procedure seterror(s:string);
procedure clearerror;
{
function getlistpos(pl:plist;pn:pnode):long;
function sizeoflist(pl:plist):long;
}
procedure printlisttoscreen(pl:plist);
{
function no0(s:string):string;
}
procedure processimage(pin:pimagenode);
procedure processmenu(pdmn:pdesignermenunode);
{
procedure addline(pl:plist;s:string;comstr:string);
}
procedure addlinefront(pl:plist;s:string;comstr:string);
procedure writelisttofile(pl:plist;fl:bptr);
procedure makeimagemakefunction;
procedure makeimagefreefunction;
procedure processwindow(pdwn:pdesignerwindownode);
procedure processrendwindow(pdwn:pdesignerwindownode);
procedure addprocstripintuimessages;
procedure addprocclosewindowsafely;
procedure processlibs;
procedure doopendiskfonts;
{
function nicestring(s:string):string;
}
{
procedure localestring(stri:string;labl : string;comment:string);
}
procedure setuplocalestuff;
function fmtint(a:long):string;

implementation

function fmtint(a:long):string;
var
  temp:string;
begin
  str(a,temp);
  fmtint:=temp;
end;

procedure doopendiskfonts;
var
  psn : pstringnode;
begin
  psn:=pstringnode(opendiskfontlist.lh_head);
  addline(@procfuncdefslist,'extern int OpenDiskFonts( void );','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'int OpenDiskFonts( void )','');
  addline(@procfunclist,'{','');
  addline(@procfunclist,'	int OKSoFar = 0;','');
  while (psn^.ln_succ<>nil) do
    begin
      addline(@procfunclist,'if (NULL == OpenDiskFont( &'+no0(psn^.st)+' ) )','');
      addline(@procfunclist,'	OKSoFar = 1;','');
      psn:=psn^.ln_succ;
    end;
  addline(@procfunclist,'return ( OKSoFar );','');
  addline(@procfunclist,'}','');
end;

function replicate(c:char;n:long):string;
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

procedure processlibs;
const
  titles : array[1..30] of string[40]=
  (
  'ArpBase',
  'AslBase',
  'CxBase',
  'DiskfontBase',
  'ExpansionBase',
  'GadToolsBase',
  'GfxBase',
  'IconBase',
  'IFFParseBase',
  'IntuitionBase',
  'KeymapBase',
  'LayersBase',
  'MathBase',
  'MathIeeeDoubBasBase',
  'MathIeeeDoubTransBase',
  'MathIeeeSingBasBase',
  'MathIeeeSingTransBase',
  'RexxSysBase',
  'ReqToolsBase',
  'TranslatorBase',
  'UtilityBase',
  'WorkbenchBase',
  'LocaleBase'
  );
  
  structtype : array[1..30] of string[40]=
  (
  '(struct ArpBase * )',
  '',
  '',
  '',
  '(struct ExpansionBase * )',
  '',
  '(struct GfxBase * )',
  '',
  '',
  '(struct IntuitionBase * )',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '(struct ReqToolsBase * )',
  '',
  '',
  '',
  '(struct LocaleBase * )'
  );
var
  loop   : word;
  loop2  : word;
  s      : string;
  spaces : string;
  first : boolean;
begin
  first:=true;
  spaces:='';
  addline(@procfunclist,'','');
  addline(@procfunclist,'int OpenLibs( void )','');
  addline(@procfuncdefslist,'extern int OpenLibs( void );','');
  addline(@procfunclist,'{','');
  loop:=1;
  while(librarynames[loop]<>'end') do
    begin
      if (producernode^.openlibs[loop]) and ((loop<13)or(loop>17)) then
        begin
          if first then
            addline(@constlist,'','');
          first:=false;
          if structtype[loop]<>'' then
            s:=copy(structtype[loop],2,length(structtype[loop])-3)
           else
            s:='struct Library *';
          addline(@externlist,'extern '+s+titles[loop]+';','');
          addline(@constlist,s+titles[loop]+' = NULL;','');
          str(producernode^.versionlibs[loop],s);
          if not producernode^.abortonfaillibs[loop] then
            addline(@procfunclist,titles[loop]+' = '+structtype[loop]
                                 +'OpenLibrary((UBYTE *)"'+no0(librarynames[loop])+'", '+s+');','');
        end;
      inc(loop);
    end;
  loop:=1;
  while(librarynames[loop]<>'end') do
    begin
      if (producernode^.openlibs[loop]) and ((loop<13)or(loop>17)) then
        begin
          str(producernode^.versionlibs[loop],s);
          if producernode^.abortonfaillibs[loop] then
            begin
              addline(@procfunclist,spaces+'if ( NULL != ('+titles[loop]+' = '+structtype[loop]
                                    +'OpenLibrary((UBYTE *)"'+no0(librarynames[loop])+'" , '+s+')))','');
              spaces:=spaces+'	';
            end;
        end;
      inc(loop);
    end;
  addline(@procfunclist,spaces+'return( 0L );','');
  if spaces<>'' then
    begin
      addline(@procfunclist,'CloseLibs();','');
      addline(@procfunclist,'return( 1L );','');
    end;
  addline(@procfunclist,'}','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'void CloseLibs( void )','');
  addline(@procfuncdefslist,'extern void CloseLibs( void );','');
  addline(@procfunclist,'{','');
  loop:=1;
  while(librarynames[loop]<>'end') do
    begin
      if (producernode^.openlibs[loop]) then
        begin
          addline(@procfunclist,'if (NULL != '+titles[loop]+' )','');
          if structtype[loop]<>'' then
            s:='( struct Library * )'
           else
            s:='';
          addline(@procfunclist,'	CloseLibrary( '+s+titles[loop]+' );','');
        end;
      inc(loop);
    end;
  addline(@procfunclist,'}','');
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
  if sizeoflist(@pdwn^.bevelboxlist)+loop6+loop+sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      s:='';
      s:='struct Window *Win, void *vi';
      if no0(pdwn^.winparams)<>'' then
        s:=s+', '+no0(pdwn^.winparams);

      visinfo:='vi';
      addline(@procfunclist,'','');
      addline(@procfunclist,'void RendWindow'+nicestring(no0(pdwn^.labelid))+'( '+s+' )','');
      addline(@procfuncdefslist,'extern void RendWindow'+nicestring(no0(pdwn^.labelid))+'( '+s+' );','');
      addline(@procfunclist,'{','');
      
      
      loop:=0;
      ptn:=ptextnode(pdwn^.textlist.mlh_head);
      while (ptn^.ln_succ<>nil) do
        begin
            inc(loop);
          ptn:=ptn^.ln_succ;
        end;
      if (loop>0) then
        addline(@procfunclist,'int loop;','');
      
      
      addline(@procfunclist,'UWORD offx,offy;','');
      
      if pdwn^.codeoptions[17] then
        begin
          addline(@procfunclist,'ULONG scalex,scaley;','');
          str(pdwn^.fontx,s);
          addline(@procfunclist,'scalex = 65535*Win->WScreen->RastPort.Font->tf_XSize/'+s+';','');
          str(pdwn^.fonty,s);
          addline(@procfunclist,'scaley = 65535*Win->WScreen->RastPort.Font->tf_YSize/'+s+';','');
        end;

      if pdwn^.codeoptions[9] and (not pdwn^.gimmezz) then
        begin
          addline(@procfunclist,'offx = Win->BorderLeft;','');
          addline(@procfunclist,'offy = Win->BorderTop;','');
        end
       else
        begin
          str(pdwn^.offx,s);
          addline(@procfunclist,'offx = '+s+';','');
          str(pdwn^.offy,s);
          addline(@procfunclist,'offy = '+s+';','');
        end;


      addline(@procfunclist,'if (Win != NULL) ','');
      addline(@procfunclist,'	{','');
      
      addgadgetimagerenders(pdwn,'	');
      
      psin:=psmallimagenode(pdwn^.imagelist.mlh_head);
      while(psin^.ln_succ<>nil) do
        begin
          if true then
            begin
              str(psin^.x,s);
              if pdwn^.codeoptions[17] then
                s:=s+'*scalex/65535';
              s:=s+'+offx, ';
              str(psin^.y,s2);
              s:=s+s2;
              if pdwn^.codeoptions[17] then
                s:=s+'*scaley/65535';
              s:=s+'+offy';
              addline(@procfunclist,'	DrawImage( Win->RPort, &'+sfp(psin^.pin^.in_label)+', '+s+');','');
            end;
          psin:=psin^.ln_succ;
        end;
      if (not beveltags) and(sizeoflist(@pdwn^.bevelboxlist)>0) then
        begin
          beveltags:=true;
          addline(@constlist,'','');
          addline(@constlist,'ULONG BevelTags[] = ','');
          addline(@constlist,'	{','');
          addline(@constlist,'	(GTBB_Recessed), TRUE,','');
          addline(@constlist,'	(GT_VisualInfo), 0,','');
          if type45 then
            begin
              addline(@constlist,'	(TAG_DONE),0,','');
              addline(@constlist,'	(GT_TagBase+77), 2,','');
              addline(@constlist,'	(GT_VisualInfo), 0,','');
              addline(@constlist,'	(TAG_DONE)','');
            end
           else
            addline(@constlist,'	(TAG_DONE)','');
          addline(@constlist,'	};','');
        end;
      pbbn:=pbevelboxnode(pdwn^.bevelboxlist.mlh_head);
      if sizeoflist(@pdwn^.bevelboxlist)>0 then
        begin
          addline(@procfunclist,'	BevelTags[3] = (ULONG)'+visinfo+';','');
          if type45 then
            addline(@procfunclist,'	BevelTags[9] = (ULONG)'+visinfo+';','');
        end;
      while(pbbn^.ln_succ<>nil) do
        begin
          case pbbn^.beveltype of
            0,4,5 :
              begin
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:=s+'*scalex/65535';
                s:=s+'+offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2+'+offy,';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scalex/65535';
                s:=s+s2+',';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2;
                if pbbn^.beveltype=0 then
                  s:=s+', (struct TagItem *)(&BevelTags[2])'
                 else
                  begin
                    s:=s+', (struct TagItem *)(&BevelTags[6])';
                    if pbbn^.beveltype= 4 then
                      addline(@procfunclist,'	BevelTags[7] = 2;','')
                     else
                      addline(@procfunclist,'	BevelTags[7] = 3;','');
                  end;
                addline(@procfunclist,'	DrawBevelBoxA( Win->RPort, '
                                 +s+');','');
              end;
            1 :
              begin
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:=s+'*scalex/65535';
                s:=s+'+offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2+'+offy,';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scalex/65535';
                s:=s+s2+',';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2;
                s:=s+', (struct TagItem *)(&BevelTags[0])';
                addline(@procfunclist,'	DrawBevelBoxA( Win->RPort, '
                                 +s+');','');
              end;
            2 :
              begin
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:=s+'*scalex/65535';
                s:=s+'+offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2+'+offy,';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scalex/65535';
                s:=s+s2+',';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2;
                s:=s+', (struct TagItem *)(&BevelTags[2])';
                addline(@procfunclist,'	DrawBevelBoxA( Win->RPort, '
                                 +s+');','');
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:=s+'*scalex/65535';
                s:=s+'+4+offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2+'+2+offy,';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scalex/65535';
                s:=s+s2+'-8,';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2+'-4';
                addline(@procfunclist,'	DrawBevelBoxA( Win->RPort,'
                                     +s+', (struct TagItem *)(&BevelTags[0]));','');
              end;
            3 :
              begin
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:=s+'*scalex/65535';
                s:=s+'+offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2+'+offy,';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scalex/65535';
                s:=s+s2+',';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2;
                s:=s+', (struct TagItem *)(&BevelTags[0])';
                addline(@procfunclist,'	DrawBevelBoxA( Win->RPort, '
                                 +s+');','');
                str(pbbn^.x,s);
                if pdwn^.codeoptions[17] then
                  s:=s+'*scalex/65535';
                s:=s+'+4+offx,';
                str(pbbn^.y,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2+'+2+offy,';
                str(pbbn^.w,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scalex/65535';
                s:=s+s2+'-8,';
                str(pbbn^.h,s2);
                if pdwn^.codeoptions[17] then
                  s2:=s2+'*scaley/65535';
                s:=s+s2+'-4';
                addline(@procfunclist,'	DrawBevelBoxA( Win->RPort,'
                                     +s+', (struct TagItem *)(&BevelTags[2]));','');
              end;
           end;
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
          
          
          
          str(sizeoflist(@pdwn^.textlist),s);
          
          addline(@procfunclist,'	for( loop=0; loop<'+s+'; loop++)','');
          if pdwn^.codeoptions[17] then
            addline(@procfunclist,'		{','');
          
          addline(@procfunclist,'		if ('+nicestring(no0(pdwn^.labelid))+'Texts[loop].ITextFont==NULL)','');
          addline(@procfunclist,'			'+nicestring(no0(pdwn^.labelid))+'Texts[loop].ITextFont='+
                                         'Win->WScreen->Font;','');
          if pdwn^.codeoptions[17] then
            begin
              
              addline(@procfunclist,'		if ('+no0(nicestring(pdwn^.labelid))+'FirstScaleTexts==0)','');
              addline(@procfunclist,'			{','');
              addline(@constlist,'UBYTE '+no0(nicestring(pdwn^.labelid))+'FirstScaleTexts = 0;','');
              addline(@procfunclist,'			'+nicestring(no0(pdwn^.labelid))+'Texts[loop].LeftEdge = '
                  +nicestring(no0(pdwn^.labelid))+'Texts[loop].LeftEdge*scalex/65535;','');
              addline(@procfunclist,'			'+nicestring(no0(pdwn^.labelid))+'Texts[loop].TopEdge = '
                  +nicestring(no0(pdwn^.labelid))+'Texts[loop].TopEdge*scaley/65535;','');
              addline(@procfunclist,'			}','');
              
              addline(@procfunclist,'		}','');
              addline(@procfunclist,'	'+no0(nicestring(pdwn^.labelid))+'FirstScaleTexts = 1;','');
         
            end;
          if pdwn^.localeoptions[2] then
            begin
              addline(@procfunclist,'	if ('+nicestring(no0(pdwn^.labelid))+'TextsLocalized == 0)','');
              addline(@procfunclist,'		{','');
              addline(@procfunclist,'		'+nicestring(no0(pdwn^.labelid))+'TextsLocalized = 1;','');
              addline(@procfunclist,'		for( loop=0; loop<'+s+'; loop++)','');
              addline(@procfunclist,'			'+nicestring(no0(pdwn^.labelid))+'Texts[loop].IText = '
                                             +sfp(producernode^.getstring)+'((LONG)'+
                                               nicestring(no0(pdwn^.labelid))+'Texts[loop].IText);','');
              addline(@procfunclist,'		}','');
              
              addline(@constlist,'','');
              addline(@constlist,'UBYTE '+nicestring(no0(pdwn^.labelid))+'TextsLocalized = 0;','');
            end;
          
          
          
          addline(@procfunclist,'	PrintIText( Win'+
                             '->RPort, '+nicestring(no0(pdwn^.labelid))+'Texts, offx, offy);','');
          addline(@constlist,'','');
          addline(@constlist,'struct IntuiText '+nicestring(no0(pdwn^.labelid))+'Texts[] =','');
          addline(@constlist,'	{','');
        end;
      loop6:=0;
      ptn:=ptextnode(pdwn^.textlist.mlh_head);
      while (ptn^.ln_succ<>nil) do
        begin
            begin
              inc(loop6);
              str(ptn^.frontpen,s);
              s:=s+', ';
              str(ptn^.backpen,s2);
              s:=s+s2+', ';
              s2:='';
              if (ptn^.drawmode and INVERSVID)=INVERSVID then
                s2:=' INVERSVID|';
              case (ptn^.drawmode-(ptn^.drawmode and inversvid)) of
                jam1 : s2:=s2+'JAM1';
                jam2 : s2:=s2+'JAM2';
                complement : s2:=s2+'COMPLEMENT';
               end;
              s:=s+s2+', ';
              str(ptn^.x,s2);
              s:=s+s2+', ';
              str(ptn^.y,s2);
              s:=s+s2;
              if ptn^.screenfont then
                s:=s+', NULL'
               else
                s:=s+', &'+makemyfont(ptn^.ta);
              if pdwn^.localeoptions[2] then
                begin
                  str(loop6,s2);
                  localestring(sfp(ptn^.tn_title),nicestring(no0(pdwn^.labelid))+
                  'Texts'+s2,'Window: '+no0(pdwn^.title)+' Text: '+sfp(ptn^.tn_title));
                  s:=s+', (UBYTE *)'+nicestring(no0(pdwn^.labelid))+'Texts'+s2+',';
                end
               else
                s:=s+', (UBYTE *)"'+sfp(ptn^.tn_title)+'",';
              str(loop6,s2);
              if loop6=loop then
                s:=s+' NULL'
               else
                s:=s+' &'+nicestring(no0(pdwn^.labelid))+'Texts['+s2+'],';
              addline(@constlist,'	'+s,'');
            end;
          ptn:=ptn^.ln_succ;
        end;
      if (loop>0) then
        addline(@constlist,'	};','');
      addline(@procfunclist,'	}','');
      addline(@procfunclist,'}','');
    end;
end;

procedure processclosewindow(pdwn:pdesignerwindownode);
var
  s,s2 : string;
begin
  addline(@procfunclist,'','');
  s:='';
  if no0(pdwn^.winparams)<>'' then
    begin
      s:=no0(pdwn^.winparams);
    end
   else
    s:='void';
  
  if not producernode^.codeoptions[10] then
    begin
      addline(@procfunclist,'void CloseWindow'+nicestring(no0(pdwn^.labelid))+'( '+s+' )','');
      addline(@procfuncdefslist,'extern void CloseWindow'+nicestring(no0(pdwn^.labelid))+'( '+s+' );','');
    end
   else
    begin
      addline(@procfunclist,'void Close'+nicestring(no0(pdwn^.labelid))+'Window( '+s+' )','');
      addline(@procfuncdefslist,'extern void Close'+nicestring(no0(pdwn^.labelid))+'Window( '+s+' );','');
    end;
  
  addline(@procfunclist,'{','');
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@procfunclist,'WORD planeNum;','');
      addline(@procfunclist,'WORD depth;','');
    end;
  addline(@procfunclist,'if ('+no0(pdwn^.labelid)+' != NULL)','');
  addline(@procfunclist,'	{','');
  if pdwn^.codeoptions[18] then
    begin
      addline(@procfunclist,'	if (NULL !=  '+no0(pdwn^.labelid)+'AppWin )','');
      addline(@procfunclist,'		RemoveAppWindow( '+no0(pdwn^.labelid)+'AppWin );','');
    end;
  if pdwn^.codeoptions[11] then
    begin
      addline(@procfunclist,'	ClearMenuStrip( '+no0(pdwn^.labelid)+');','');
      if pdwn^.codeoptions[14] then
        begin
          addline(@procfunclist,'	FreeMenus( '+no0(pdwn^.menutitle)+');','');
          addline(@procfunclist,'	'+no0(pdwn^.menutitle)+' = NULL;','');
        end;
    end;
  
  addline(@procfunclist,'	FreeScreenDrawInfo( '+no0(pdwn^.labelid)+'->WScreen, (struct DrawInfo *) '+
                no0(pdwn^.labelid)+'DrawInfo );','');
  addline(@procfunclist,'	'+no0(pdwn^.labelid)+'DrawInfo = NULL;','');
 
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@procfunclist,'	depth = '+no0(pdwn^.labelid)+'->WScreen->BitMap.Depth;','');
    end;
  if pdwn^.codeoptions[8] then
    begin
      addline(@procfunclist,'	CloseWindowSafely( '+no0(pdwn^.labelid)+');','');
      sharedwindow:=true;
    end
   else
    addline(@procfunclist,'	CloseWindow( '+no0(pdwn^.labelid)+');','');
  
  {freesuperbitmap}
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      { free superbitmap }
      addline(@procfunclist,'	for (planeNum = 0; planeNum < depth; planeNum++ )','');
      addline(@procfunclist,'		{','');
      str(pdwn^.maxw,s);
      s:=s+', ';
      str(pdwn^.maxh,s2);
      s:=s+s2;
      addline(@procfunclist,'		if (NULL != '+no0(pdwn^.labelid)+'BitMap->Planes[planeNum])','');
      addline(@procfunclist,'			FreeRaster('+no0(pdwn^.labelid)+'BitMap->Planes[planeNum], '+s+');','');
      addline(@procfunclist,'		}','');
      addline(@procfunclist,'	FreeMem( '+no0(pdwn^.labelid)+'BitMap, sizeof(struct BitMap));','') {87}
    end;

  addline(@procfunclist,'	'+no0(pdwn^.labelid)+' = NULL;','');
  addline(@procfunclist,'	FreeVisualInfo( '+no0(pdwn^.labelid)+'VisualInfo);','');
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@procfunclist,'	FreeGadgets( '+no0(pdwn^.labelid)+'GList);','');
  
  addfreeobjects(pdwn,'	');
  
  addline(@procfunclist,'	}','');
  addline(@procfunclist,'}','');
end;

procedure addmygad(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  s2 : string;
  s  : string;
begin
  str(pgn^.x,s2);
  s:='	'+s2+', ';
  str(pgn^.y,s2);
  s:=s+s2+', ';
  str(pgn^.w,s2);
  s:=s+s2+', ';
  str(pgn^.h,s2);
  s:=s+s2+', ';
  
  if pgn^.kind=myobject_kind then
    begin
      if pgn^.tags[1].ti_tag=0 then
        s:=s+'(UBYTE *)"'+no0(pgn^.datas)+'", '
       else
        s:=s+'NULL, ';
    end
   else
    begin
      if pdwn^.localeoptions[1] then
        begin
          if not (pgn^.kind=mybool_kind) then
            begin
          
              s:=s+'(UBYTE*)'+no0(pgn^.labelid)+'String, ';
              {
              s:=s+'NULL, ';
              }
              localestring(no0(pgn^.title),no0(pgn^.labelid)+
                 'String','Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid));
            end
           else
            s:=s+'(UBYTE *)~0,';
        end
       else
        begin
          if (no0(pgn^.title)='')or(pgn^.kind=mybool_kind) then
            s:=s+'NULL, '
           else
            s:=s+'(UBYTE *)"'+no0(pgn^.title)+'", ';
        end;
  
    end;
  
  if pgn^.kind=mybool_kind then
    s:=s+'NULL, '
   else
    if pdwn^.codeoptions[6] then
      if not pdwn^.codeoptions[17] then
        s:=s+'&'+makemyfont(pdwn^.gadgetfont)+', '
       else
        s:=s+'NULL, '
     else
      s:=s+'&'+makemyfont(pgn^.font)+', ';
  
  str(pgn^.flags,s2);                              { use strings here }
  s:=s+no0(pgn^.labelid)+', '+s2+', NULL, ';
  str(pgn^.tagpos-1,s2);
  if pgn^.tagpos<>0 then
    s:=s+' (APTR)&'+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s2+'],'
   else
    s:=s+' NULL,';
  addline(@constlist,s,'');
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
  spaces:='	';
  loop:=1;
  oldloop:=1;
  gadcount:=0;
  
  addline(@constlist,'','');
  addline(@constlist,'ULONG '+nicestring(no0(pdwn^.labelid))+'GadgetTags[] =','');
  addline(@externlist,'extern ULONG '+nicestring(no0(pdwn^.labelid))+'GadgetTags[];','');
  addline(@constlist,'	{','');
  
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
        case pgn^.kind of
          myobject_kind :
                        begin
                          loop:=doobjects(pdwn,pgn,loop);
                        end;
          Palette_kind: begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or paletteidcmp;
                          if pgn^.tags[1].ti_data<>1 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'(GTPA_Depth), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>1 then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'(GTPA_Color), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[3].ti_data<>0 then
                            begin
                              str(pgn^.tags[3].ti_data,s2);
                              addline(@constlist,spaces+'(GTPA_ColorOffset), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[4].ti_tag<>tag_ignore then
                            begin
                              str(pgn^.tags[4].ti_data,s2);
                              addline(@constlist,spaces+'(GTPA_IndicatorWidth), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[5].ti_tag<>tag_ignore then
                            begin
                              str(pgn^.tags[5].ti_data,s2);
                              addline(@constlist,spaces+'(GTPA_IndicatorHeight), '+s2+',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[7].ti_data) then
                            begin
                              str(loop,s);
                              addline(@constlist,spaces+'(GA_Disabled), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[8].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                        end;
          ListView_kind:begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or listviewidcmp;
                          if pgn^.tags[3].ti_tag=GTLV_showselected then
                            begin
                              addline(@constlist,spaces+'(GTLV_ShowSelected), 0,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>0 then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'(GTLV_Top), '+s2+',','');
                              inc(loop,2);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              addline(@constlist,spaces+'(GT_TagBase+83), '+no0(pgn^.edithook)+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[4].ti_data<>16 then
                            begin
                              str(pgn^.tags[4].ti_data,s2);
                              addline(@constlist,spaces+'(GTLV_ScrollWidth), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[5].ti_data<>~0 then
                            begin
                              str(pgn^.tags[5].ti_data,s2);
                              addline(@constlist,spaces+'(GTLV_Selected), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[6].ti_data<>0 then
                            begin
                              str(pgn^.tags[6].ti_data,s2);
                              addline(@constlist,spaces+'(LAYOUTA_Spacing), '+s2+',','');
                              inc(loop,2);
                            end;
                          if Boolean(pgn^.tags[8].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GTLV_ReadOnly), TRUE,','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[10].ti_data=long(true) then
                            begin
                              str(loop,s);
                              addline(@constlist,spaces+'(GTLV_Labels), (ULONG)&'+no0(pgn^.labelid)+'List,','');
                              inc(loop,2);
                            end;
                        end;
          MX_kind     : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or mxidcmp;
                          if (pgn^.tags[2].ti_data<>1)or(pdwn^.codeoptions[17]) then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'(GTMX_Spacing), '+s2+',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[6].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_TagBase+69), TRUE,  /* MX scaling under V39 */','');
                              inc(loop,2);
                            end;
                          if (pgn^.tags[7].ti_data<>placetext_left) then
                            begin
                              str(pgn^.tags[7].ti_data,s);
                              addline(@constlist,spaces+'(GT_TagBase+71), '+s+', /* placetext in V39 */','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'(GTMX_Active), '+s2+',','');
                              inc(loop,2);
                            end;
                          addline(@constlist,spaces+'(GTMX_Labels), (ULONG)&'+no0(pgn^.labelid)+'Labels[0],','');
                          inc(loop,2);
                        end;
          cycle_kind  : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or cycleidcmp;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[6].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Disabled), TRUE,','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'(GTCY_Active), '+s2+',','');
                              inc(loop,2);
                            end;
                          addline(@constlist,spaces+'(GTCY_Labels), (ULONG)&'+no0(pgn^.labelid)+'Labels[0],','');
                          inc(loop,2);
                        end;
          button_kind : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or buttonidcmp;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[2].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Disabled), TRUE,','');
                              inc(loop,2);
                            end;
                        end;
          number_kind : begin
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'(GTNM_Number), '+s2+',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[2].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GTNM_Border), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              if pgn^.tags[6].ti_data<>1 then
                                begin
                                  str(pgn^.tags[6].ti_data,s);
                                  addline(@constlist,spaces+'(GT_TagBase+72), '+s+',  /* FrontPen in V39 */','');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[7].ti_data<>0 then
                                begin
                                  str(pgn^.tags[7].ti_data,s);
                                  addline(@constlist,spaces+'(GT_TagBase+73), '+s+',  /* BackPen in V39 */','');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[8].ti_data<>1 then
                                begin
                                  str(pgn^.tags[8].ti_data,s);
                                  addline(@constlist,spaces+'(GT_TagBase+74), '+s+',  /* Justification in V39 */','');
                                  inc(loop,2);
                                end;
                              if not boolean(pgn^.tags[9].ti_data) then
                                begin
                                  addline(@constlist,spaces+'(GT_TagBase+85), FALSE,  /* No text clipping */','');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[10].ti_data<>0 then
                                begin
                                  str(pgn^.tags[10].ti_data,s);
                                  addline(@constlist,spaces+'(GT_TagBase+76), '+s+
                                          ',  /* Max Number Length in V39, does this work for you? */','');
                                  inc(loop,2);
                                end;
                              
                              if no0(pgn^.datas)<>'' then
                                begin
                                  
                                  if pdwn^.localeoptions[1] then
                                    addline(@constlist,spaces+'(GT_TagBase+75), 0'+
                                            ',  /* String Formatting */','')
                                   else
                                    addline(@constlist,spaces+'(GT_TagBase+75), (ULONG)"'+
                                            no0(pgn^.datas)+'",  /* String Formatting */','');
                                  
                                  if pdwn^.localeoptions[1] then
                                    localestring(no0(pgn^.datas),no0(pgn^.labelid)+'StringFormat',
                                      'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' String Format');
                                  str(loop,s);
                                  if pdwn^.localeoptions[1] then
                                    addline(@procfunclist,'	'+no0(nicestring(pdwn^.labelid))+'GadgetTags['+s+'] = (ULONG)'
                                         +sfp(producernode^.getstring)
                                          +'('+no0(pgn^.labelid)+'StringFormat);','');
                                  
                                  inc(loop,2);
                                end;
                              
                            end;
                        end;
           text_kind  : begin
                          if no0(pgn^.datas)<>'' then
                            begin
                              if pdwn^.localeoptions[1] then
                                begin
                                  localestring(no0(pgn^.datas),nicestring(no0(pgn^.labelid))+'InitText','Window: '+
                                       no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' Text');
                                  addline(@constlist,spaces+'(GTTX_Text), 0,','');
                                  str(loop,s);
                                  addline(@procfunclist,'	'+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s+'] = (ULONG)'
                                       +sfp(producernode^.getstring)
                                       +'('+no0(nicestring(pgn^.labelid))+'InitText);','');
                                end
                               else
                                addline(@constlist,spaces+'(GTTX_Text), (ULONG)"'+no0(pgn^.datas)+'",','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[2].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GTTX_Border), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GTTX_CopyText), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              if pgn^.tags[6].ti_data<>1 then
                                begin
                                  str(pgn^.tags[6].ti_data,s);
                                  addline(@constlist,spaces+'(GT_TagBase+72), '+s+',  /* FrontPen in V39 */','');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[7].ti_data<>0 then
                                begin
                                  str(pgn^.tags[7].ti_data,s);
                                  addline(@constlist,spaces+'(GT_TagBase+73), '+s+',  /* BackPen in V39 */','');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[8].ti_data<>1 then
                                begin
                                  str(pgn^.tags[8].ti_data,s);
                                  addline(@constlist,spaces+'(GT_TagBase+74), '+s+',  /* Justification in V39 */','');
                                  inc(loop,2);
                                end;
                              if not boolean(pgn^.tags[9].ti_data) then
                                begin
                                  addline(@constlist,spaces+'(GT_TagBase+85), FALSE,  /* No text clipping in V39 */','');
                                  inc(loop,2);
                                end;
                            end;
                        end;
           string_kind : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or stringidcmp;
                          
                          if sfp(pointer(gettagdata(gtst_string,0,pgn^.gn_gadgettags)))<>'' then
                            begin
                              s2:='(ULONG)"'+sfp(pointer(gettagdata(gtst_string,0,pgn^.gn_gadgettags)))+'"';
                              addline(@constlist,spaces+'(GTST_String), '+s2+',','');
                              inc(loop,2);
                            end;
                          
                          if pgn^.tags[1].ti_data<>64 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'(GTST_MaxChars), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>gact_stringleft then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'(STRINGA_Justification), '+s2+',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'(STRINGA_ReplaceMode), TRUE,','');
                              inc(loop,2);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              addline(@constlist,spaces+'(GTST_EditHook), '+no0(pgn^.edithook)+',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Disabled), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'(STRINGA_ExitHelp), TRUE,','');
                              inc(loop,2);
                            end;
                          if not boolean(pgn^.tags[6].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_TabCycle), FALSE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[8].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Immediate), TRUE,','');
                              inc(loop,2);
                            end;
                        end;
          integer_kind: begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or integeridcmp;
                          
                          if gettagdata(gtin_number,0,pgn^.gn_gadgettags)<>0 then
                            begin
                              str(gettagdata(gtin_number,0,pgn^.gn_gadgettags),s2);
                              addline(@constlist,spaces+'(GTIN_Number), '+s2+',','');
                              inc(loop,2);
                            end;
                          
                          if pgn^.tags[1].ti_data<>10 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'(GTIN_MaxChars), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>gact_stringleft then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'(STRINGA_Justification), '+s2+',','');
                              inc(loop,2);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              addline(@constlist,spaces+'(GTST_EditHook), '+no0(pgn^.edithook)+',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'(STRINGA_ReplaceMode), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Disabled), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'(STRINGA_ExitHelp), TRUE,','');
                              inc(loop,2);
                            end;
                          if not boolean(pgn^.tags[6].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_TabCycle), FALSE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[8].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Immediate), TRUE,','');
                              inc(loop,2);
                            end;
                        end;
          CheckBox_kind:begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or checkboxidcmp;
                          if boolean(pgn^.tags[1].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GTCB_Checked), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[3].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Disabled), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[5].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_TagBase+68), TRUE,  /* CheckBox scaling under V39 */','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                        end;
          Slider_kind : begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or slideridcmp;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'(GTSL_Min), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>0 then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'(GTSL_Max), '+s2+',','');
                              inc(loop,2);
                            end;
                          if no0(pgn^.edithook)<>'' then
                            begin
                              addline(@constlist,spaces+'(GTSL_DispFunc), '+no0(pgn^.edithook)+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[3].ti_data<>0 then
                            begin
                              str(pgn^.tags[3].ti_data,s2);
                              addline(@constlist,spaces+'(GTSL_Level), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[9].ti_data<>lorient_horiz then
                            begin
                              str(pgn^.tags[9].ti_data,s2);
                              addline(@constlist,spaces+'(PGA_Freedom), '+s2+',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[4].ti_data) then
                            begin
                              
                              if pdwn^.localeoptions[1] then
                                begin
                                  
                                  addline(@constlist,spaces+'(GTSL_LevelFormat), 0,','');
                                  str(loop,s);
                                  addline(@procfunclist,'	'+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s+'] = (ULONG)'
                                      +sfp(producernode^.getstring)
                                      +'('+nicestring(no0(pgn^.labelid))+'LevelFormat);','');
                                  localestring(no0(pgn^.datas),nicestring(no0(pgn^.labelid))+'LevelFormat','Window: '+
                                       no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' levelformat');
                                 
                                end
                               else
                                addline(@constlist,spaces+'(GTSL_LevelFormat), (ULONG)"'+no0(pgn^.datas)+'",','');
                              inc(loop,2);
                              if pgn^.tags[5].ti_data<>0 then
                                begin
                                  str(pgn^.tags[5].ti_data,s2);
                                  addline(@constlist,spaces+'(GTSL_MaxLevelLen), '+s2+',','');
                                  inc(loop,2);
                                end;
                              if pgn^.tags[6].ti_data<>placetext_left then
                                begin
                                  str(pgn^.tags[6].ti_data,s2);
                                  addline(@constlist,spaces+'(GTSL_LevelPlace), '+s2+',','');
                                  inc(loop,2);
                                end;
                            end;
                          if boolean(pgn^.tags[12].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Immediate), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[13].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_RelVerify), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[11].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Disabled), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[14].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                        end;
          mybool_kind : begin
                          if pdwn^.localeoptions[1] and boolean(pgn^.tags[1].ti_data) then
                            localestring(no0(pgn^.title),no0(pgn^.labelid)+'String','Window: '+no0(pdwn^.title)+' Gadget: '+
                             no0(pgn^.labelid));
                        end;
          Scroller_kind:begin
                          pdwn^.idcmpvalues:=pdwn^.idcmpvalues or scrolleridcmp;
                          if pgn^.tags[7].ti_data<>lorient_horiz then
                            begin
                              str(pgn^.tags[7].ti_data,s2);
                              addline(@constlist,spaces+'(PGA_Freedom), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[1].ti_data<>0 then
                            begin
                              str(pgn^.tags[1].ti_data,s2);
                              addline(@constlist,spaces+'(GTSC_Top), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[2].ti_data<>0 then
                            begin
                              str(pgn^.tags[2].ti_data,s2);
                              addline(@constlist,spaces+'(GTSC_Total), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[3].ti_data<>2 then
                            begin
                              str(pgn^.tags[3].ti_data,s2);
                              addline(@constlist,spaces+'(GTSC_Visible), '+s2+',','');
                              inc(loop,2);
                            end;
                          if pgn^.tags[4].ti_tag<>tag_ignore then
                            begin
                              pdwn^.idcmpvalues:=pdwn^.idcmpvalues or arrowidcmp;
                              str(pgn^.tags[4].ti_data,s2);
                              addline(@constlist,spaces+'(GTSC_Arrows), '+s2+',','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[10].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Immediate), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[11].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_RelVerify), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[9].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GA_Disabled), TRUE,','');
                              inc(loop,2);
                            end;
                          if boolean(pgn^.tags[12].ti_data) then
                            begin
                              addline(@constlist,spaces+'(GT_Underscore), ''_'',','');
                              inc(loop,2);
                            end;
                        end;
         end;
      if loop<>oldloop then
        begin
          addline(@constlist,spaces+'(TAG_END),','');
          inc(loop);
          pgn^.tagpos:=oldloop;
          oldloop:=loop;
        end;
      inc(gadcount);
      pgn:=pgn^.ln_succ;
    end;  
  psn:=pstringnode(constlist.lh_tailpred);
  if no0(psn^.st)<>'	{' then
    addline(@constlist,'	};','')
   else
    begin
      psn:=pstringnode(remtail(@constlist));
      freemymem(psn);
      psn:=pstringnode(remtail(@constlist));
      freemymem(psn);
      psn:=pstringnode(remtail(@constlist));
      freemymem(psn);
      psn:=pstringnode(remtail(@externlist));
      freemymem(psn);
    end;
  addline(@constlist,'','');
  addline(@constlist,'UWORD '+nicestring(no0(pdwn^.labelid))+'GadgetTypes[] =','');
  addline(@externlist,'extern UWORD '+nicestring(no0(pdwn^.labelid))+'GadgetTypes[];','');
  addline(@constlist,'	{','');
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      if not (pgn^.joined and (pgn^.kind=string_kind)) then
        case pgn^.kind of
          Palette_kind: addline(@constlist,spaces+'PALETTE_KIND,','');
          ListView_kind:begin
                          if pgn^.tags[3].ti_data<>0 then
                            addline(@constlist,spaces+'STRING_KIND,','');
                          addline(@constlist,spaces+'LISTVIEW_KIND,','');
                        end;
          mybool_kind  : addline(@constlist,spaces+'GENERIC_KIND,','');
          MX_kind      : addline(@constlist,spaces+'MX_KIND,','');
          cycle_kind   : addline(@constlist,spaces+'CYCLE_KIND,','');
          button_kind  : addline(@constlist,spaces+'BUTTON_KIND,','');
          number_kind  : addline(@constlist,spaces+'NUMBER_KIND,','');
          text_kind    : addline(@constlist,spaces+'TEXT_KIND,','');
          string_kind  : addline(@constlist,spaces+'STRING_KIND,','');
          integer_kind : addline(@constlist,spaces+'INTEGER_KIND,','');
          CheckBox_kind: addline(@constlist,spaces+'CHECKBOX_KIND,','');
          Slider_kind  : addline(@constlist,spaces+'SLIDER_KIND,','');
          Scroller_kind: addline(@constlist,spaces+'SCROLLER_KIND,','');
          myobject_kind: addline(@constlist,spaces+'198,','');
         end;
      pgn:=pgn^.ln_succ;
    end;  
  addline(@constlist,'	};','');
  
  addline(@constlist,'','');
  if producernode^.codeoptions[10] then
    begin
      addline(@constlist,'struct NewGadget '+nicestring(no0(pdwn^.labelid))+'NGad[] =','');
      addline(@externlist,'extern struct NewGadget '+nicestring(no0(pdwn^.labelid))+'NGad[];','');
    end
   else
    begin
      addline(@constlist,'struct NewGadget '+nicestring(no0(pdwn^.labelid))+'NewGadgets[] =','');
      addline(@externlist,'extern struct NewGadget '+nicestring(no0(pdwn^.labelid))+'NewGadgets[];','');
    end;
  addline(@constlist,'	{','');
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
  addline(@constlist,'	};','');
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
  spaces  : string;
  pgn     : pgadgetnode;
  countup : long;
  s : string;
begin
  {assume code,class,iaddress  need var gad}
  addline(@idcmplist,'','');
  if comment then
    begin
      addline(@idcmplist,'','/* Cut the core out of this function and edit it suitably. */');
      addline(@idcmplist,'','');
    end;
  s:='';
  if no0(pdwn^.winparams)<>'' then
    s:=', '+no0(pdwn^.winparams);
  addline(@idcmplist,'void ProcessWindow'+nicestring(no0(pdwn^.labelid))+'( LONG Class, UWORD Code, APTR IAddress '+s+')','');
  addline(@idcmplist,'{','');
  if (pdwn^.idcmplist[4]) or (pdwn^.idcmplist[5]) then
    addline(@idcmplist,'struct Gadget *gad;','');
  spaces:='	';
  addline(@idcmplist,'switch ( Class )','');
  addline(@idcmplist,'	{','');
  for loop:=1 to 25 do
    if pdwn^.idcmplist[Loop] then
      begin
        addline(@idcmplist,spaces+'case IDCMP_'+idcmpstrings[loop]+' :','');
        case loop of
          1 :
            begin
              addline(@idcmplist,'',spaces+'	/* Mouse Button Action */');
              addline(@idcmplist,'',spaces+'	/* Code contains selectup/down, middleup/down or menuup/down */');
            end;
          2 :
            begin
              addline(@idcmplist,'',spaces+'	/* Mouse Movement */');
              addline(@idcmplist,'',spaces+'	/* Message has absolute [Window] mouse coords. */');
            end;
          3 :
            begin
              if comment then
                begin
                  addline(@idcmplist,'',spaces+'	/* Mouse Movement */');
                  addline(@idcmplist,'',spaces+'	/* Message has relative mouse coords. */');
                end;
            end;
          4 : {gadgetdown}
            begin
              countup:=0;
              addline(@idcmplist,'',spaces+'	/* Gadget message, gadget = gad. */');
              addline(@idcmplist,spaces+'	gad = (struct Gadget *)IAddress;','');
              addline(@idcmplist,spaces+'	switch ( gad->GadgetID )','');
              addline(@idcmplist,spaces+'		{','');
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
                      inc(countup);
                      addline(@idcmplist,spaces+'		case '+no0(pgn^.labelid)+' :','');
                      case pgn^.kind of
                        string_kind :
                          addline(@idcmplist,'',spaces
                              +'			/* String entered   , Text of gadget : '+no0(pgn^.title)+' */');
                        integer_kind :
                          addline(@idcmplist,'',spaces
                              +'			/* Integer entered  , Text of gadget : '+no0(pgn^.title)+' */');
                        MX_kind :
                          addline(@idcmplist,'',spaces
                              +'			/* MX changed       , Text of gadget : '+no0(pgn^.title)+' */');
                        Slider_kind :
                          addline(@idcmplist,'',spaces
                              +'			/* Slider changed   , Text of gadget : '+no0(pgn^.title)+' */');
                        Scroller_kind :
                          addline(@idcmplist,'',spaces
                              +'			/* Scroller changed , Text of gadget : '+no0(pgn^.title)+' */');
                        mybool_kind :
                          addline(@idcmplist,'',spaces
                              +'			/* Boolean activated, Text of gadget : '+no0(pgn^.title)+' */');
                       end;
                      addline(@idcmplist,spaces+'			break;','');
                    end;
                  pgn:=pgn^.ln_succ;
                end;
              if countup>0 then
                addline(@idcmplist,spaces+'		}','')
               else
                begin
                  psn:=pstringnode(remtail(@idcmplist));
                  freemymem(psn);
                  psn:=pstringnode(remtail(@idcmplist));
                  freemymem(psn);
                end;
            end;
          5 : {gadgetup}
            begin
              countup:=0;
              addline(@idcmplist,'',spaces+'	/* Gadget message, gadget = gad. */');
              addline(@idcmplist,spaces+'	gad = (struct Gadget *)IAddress;','');
              addline(@idcmplist,spaces+'	switch ( gad->GadgetID ) ','');
              addline(@idcmplist,spaces+'		{','');
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
                      inc(countup);
                      addline(@idcmplist,spaces+'		case '+no0(pgn^.labelid)+' :','');
                      case pgn^.kind of
                        button_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* Button pressed  , Text of gadget : '+no0(pgn^.title)+' */');
                        button_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* Boolean pressed , Text of gadget : '+no0(pgn^.title)+' */');
                        string_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* String entered  , Text of gadget : '+no0(pgn^.title)+' */');
                        integer_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* Integer entered , Text of gadget : '+no0(pgn^.title)+' */');
                        CheckBox_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* CheckBox changed, Text of gadget : '+no0(pgn^.title)+' */');
                        cycle_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* Cycle changed   , Text of gadget : '+no0(pgn^.title)+' */');
                        Slider_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* Slider changed  , Text of gadget : '+no0(pgn^.title)+' */');
                        Scroller_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* Scroller changed, Text of gadget : '+no0(pgn^.title)+' */');
                        ListView_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* ListView pressed, Text of gadget : '+no0(pgn^.title)+' */');
                        Palette_kind :
                          addline(@idcmplist,'',spaces+
                              '			/* Colour Selected , Text of gadget : '+no0(pgn^.title)+' */');
                       end;
                      
                      addline(@idcmplist,spaces+'			break;','');
                    end;
                  pgn:=pgn^.ln_succ;
                end;
              if countup>0 then
                addline(@idcmplist,spaces+'		}','')
               else
                begin
                  psn:=pstringnode(remtail(@idcmplist));
                  freemymem(psn);
                  psn:=pstringnode(remtail(@idcmplist));
                  freemymem(psn);
                end;
            end;
          6 :
            addline(@idcmplist,'',spaces+'	/* CloseWindow Now */');
          7 :
            Begin
              addline(@idcmplist,'',spaces+'	/* Menu Selected */');
              if pdwn^.menutitle<>'' then
                addline(@idcmplist,spaces+'	ProcessMenuIDCMP'+no0(pdwn^.menutitle)+'( Code );','');
            end;
          8 :
            addline(@idcmplist,'',spaces+'	/* Intuiton pauses menu until replied. */');
          9 :
            addline(@idcmplist,'',spaces+'	/* Copy the menu processing procedure and change suitably */');
          10:
            addline(@idcmplist,'',spaces+'	/* A requester has opened in this window. */');
          11:
            addline(@idcmplist,'',spaces+'	/* A requester has cleared from this window. */');
          12:
            addline(@idcmplist,'',spaces+'	/* Can you take a requester ?, Intuiton waits for a reply. */');
          13:
            addline(@idcmplist,'',spaces+'	/* Window re-sized. */');
          14:
            begin
              addline(@idcmplist,spaces+'	GT_BeginRefresh( '+no0(pdwn^.labelid)+');','');
              addline(@idcmplist,'',spaces+'	/* Refresh window. */');
              
              s:='';
              if no0(pdwn^.rendparams)<>'' then
                s:=s+', '+no0(pdwn^.rendparams);
              
              if sizeoflist(@pdwn^.gadgetlist)>0 then
                addline(@idcmplist,spaces+'RendWindow'+nicestring(no0(pdwn^.labelid))+'( '+
                   no0(pdwn^.labelid)+', '+no0(pdwn^.labelid)+'VisualInfo '+s+');','');
              
              addline(@idcmplist,spaces+'	GT_EndRefresh( '+no0(pdwn^.labelid)+', TRUE);','');
              
              if sizeoflist(@pdwn^.gadgetlist)>0 then
                addline(@idcmplist,spaces+'GT_RefreshWindow( '+no0(pdwn^.labelid)+', NULL);',''); {82}
   
              if sizeoflist(@pdwn^.gadgetlist)>0 then
                addline(@idcmplist,spaces+'RefreshGList( '+no0(pdwn^.labelid)+
                     'GList, '+no0(pdwn^.labelid)+', NULL, ~0);',''); {82}
              
            end;
          15:
            addline(@idcmplist,'',spaces+'	/* Verify window size. */');
          16:
            addline(@idcmplist,'',spaces+'	/* Window activated. */');
          17:
            addline(@idcmplist,'',spaces+'	/* Window deactivated. */');
          18:
            begin
              addline(@idcmplist,'',spaces+'	/* Processed key press */');
              addline(@idcmplist,'',spaces+'	/* gadgets need processing perhaps. */');
            end;
          19:
            addline(@idcmplist,'',spaces+'	/* Raw keyboard keypress */');
          20:
            addline(@idcmplist,'',spaces+'	/* 1.3 Prefs. */');
          21:
            addline(@idcmplist,'',spaces+'	/* Floppy disk inserted. */');
          22:
            addline(@idcmplist,'',spaces+'	/* Floppy disk removed. */');
          23:
            addline(@idcmplist,'',spaces+'	/* Timing message. */');
          24:
            addline(@idcmplist,'',spaces+'	/* Boopsi message */');
          25:
            addline(@idcmplist,'',spaces+'	/* Window position or size changed. */');
         end;
        addline(@idcmplist,spaces+'	break;','');
      end;
  addline(@idcmplist,spaces+'}','');
  addline(@idcmplist,'}','');
end;

procedure processwindow(pdwn:pdesignerwindownode);
var
  s        : string;
  count    : long;
  loop     : long;
  pgn      : pgadgetnode;
  spaces   : string;
  s2       : string;
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
  count24:=0;
  if not comment then
    comment:=pdwn^.codeoptions[16];
  pdwn^.idcmpvalues:=0;
  processrendwindow(pdwn);
  addline(@constlist,'','');
  if not pdwn^.codeoptions[19] then
    begin
      addline(@constlist,'struct Window *'+no0(pdwn^.labelid)+' = NULL;','');
      addline(@constlist,'APTR '+no0(pdwn^.labelid)+'VisualInfo;','');
      addline(@constlist,'APTR '+no0(pdwn^.labelid)+'DrawInfo;','');
      if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
        addline(@constlist,'struct BitMap *'+no0(pdwn^.labelid)+'BitMap = NULL;','');
    end;
  if pdwn^.codeoptions[18] and (not pdwn^.codeoptions[19]) then
    begin
      addline(@constlist ,'struct AppWindow *'+no0(pdwn^.labelid)+'AppWin = NULL;','');
      addline(@externlist,'extern struct AppWindow *'+no0(pdwn^.labelid)+'AppWin;','');
    end;
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      if not pdwn^.codeoptions[19] then
        addline(@constlist,'struct Gadget *'+no0(pdwn^.labelid)+'GList;','');
      str(pdwn^.nextid,s3);
      str(sizeoflist(@pdwn^.gadgetlist),s2);
      if not pdwn^.codeoptions[19] then
        begin
          addline(@constlist,'struct Gadget *'+no0(pdwn^.labelid)+'Gadgets['+s2+'];','');
      
          addline(@externlist,'extern struct Gadget *'+no0(pdwn^.labelid)+'Gadgets['+s2+'];','');
          addline(@externlist,'extern struct Gadget *'+no0(pdwn^.labelid)+'GList;','');
        end;
      addline(@defineslist,'#define '+nicestring(no0(pdwn^.labelid))+'FirstID '+s3,'');
    
    end;
  if not pdwn^.codeoptions[19] then
    begin
      addline(@externlist,'extern struct Window *'+no0(pdwn^.labelid)+';','');
      addline(@externlist,'extern APTR '+no0(pdwn^.labelid)+'VisualInfo;','');
      addline(@externlist,'extern APTR '+no0(pdwn^.labelid)+'DrawInfo;','');
      if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
        addline(@externlist,'extern struct BitMap *'+no0(pdwn^.labelid)+'BitMap;','');
    end;
  addline(@procfunclist,'','');
  s:='';
  if pdwn^.codeoptions[8] then                               {1}
    s:=s+'( struct MsgPort *mp';
    
  
  if (pdwn^.customscreen)or(pdwn^.pubscreen) then
    if s='' then
      s:='( struct Screen *Scr'
     else
      s:=s+', struct Screen *Scr';
  
  if (pdwn^.pubscreenname) and (no0(pdwn^.defpubname)='') then
    if s='' then
      s:='( STRPTR ScrName'
     else
      s:=s+', STRPTR ScrName';
  
  if (pdwn^.codeoptions[18]) then
    if s='' then
      s:='( struct MsgPort *awmp, long awid'
     else
      s:=s+', struct MsgPort *awmp, long awid';
  
  if (pdwn^.extracodeoptions[1])and ( not pdwn^.extracodeoptions[2]) then
    if s='' then
      s:='( struct BitMap *bitmap'
     else
      s:=s+', struc BitMap *bitmap';
  
  if no0(pdwn^.winparams)<>'' then
    if s='' then
      s:='( '+no0(pdwn^.winparams)
     else
      s:=s+', '+no0(pdwn^.winparams);
  if s<>'' then s:=s+')'; 
  if s='' then 
    s:='( void )';
  
  if producernode^.codeoptions[10] then
    s:='int Open'+nicestring(no0(pdwn^.labelid))+'Window'+s+''
   else
    s:='int OpenWindow'+nicestring(no0(pdwn^.labelid))+s+'';
  
  
  addline(@procfunclist,s,'');
  addline(@procfuncdefslist,'extern '+s+';','');
  
  addline(@procfunclist,'{',''); 
  
  { put var defns here }
  
  if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
    addline(@procfunclist,'struct Screen *Scr;','');             {10}
  addline(@procfunclist,'UWORD offx, offy;','');
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      addline(@procfunclist,'UWORD loop;','');
      addline(@procfunclist,'struct NewGadget newgad;','');
      addline(@procfunclist,'struct Gadget *Gad;','');
      addline(@procfunclist,'struct Gadget *Gad2;','');
      addline(@procfunclist,'APTR Cla;','');
    end;
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@procfunclist,'WORD allocatedBitMaps;','');
      addline(@procfunclist,'WORD planeNum;','');
    end;
  if pdwn^.codeoptions[17] then
    addline(@procfunclist,'ULONG scalex,scaley;','');
  
  { end of var defns }
  
  addline(@constlist,'UBYTE '+nicestring(no0(pdwn^.labelid))+'FirstRun = 0;',''); 
  addline(@procfunclist,'if ('+nicestring(no0(pdwn^.labelid))+'FirstRun == 0)',''); 
  addline(@procfunclist,'	{','');
  addline(@procfunclist,'	'+nicestring(no0(pdwn^.labelid))+'FirstRun = 1;','');
  
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      case pgn^.kind of
        myobject_kind :
          begin
            addmyobjectconstdata(pdwn,pgn);
            pdwn^.codeoptions[10]:=true;
          end;
        palette_kind :
          begin
            if pgn^.tags[1].ti_data=0 then
              begin
                inc(count24);
              end;
          end;
        mx_kind, cycle_kind :
          begin
            addline(@constlist,'','');
            addline(@constlist,'STRPTR '+no0(pgn^.labelid)+'Labels[] =','');
            addline(@constlist,'{','');
            mycount:=0;
            psn:=pstringnode(pgn^.infolist.mlh_head);
            while (psn^.ln_succ<>nil) do
              begin
                if pdwn^.localeoptions[1] then
                  begin
                    str(mycount,s3);
                    localestring(no0(psn^.st),no0(pgn^.labelid)+
                          'String'+s3,'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                    addline(@constlist,'	(STRPTR)'+
                      no0(pgn^.labelid)+'String'+s3+',','');
                  end
                 else
                  addline(@constlist,'	(STRPTR)"'+no0(psn^.st)+'",','');
                inc(mycount);
                psn:=psn^.ln_succ;
              end;
            addline(@constlist,'	NULL',''); 
            addline(@constlist,'};',''); 
            str(mycount,s);
            if pdwn^.localeoptions[1] then
              begin  
                addline(@procfunclist,'	for ( loop=0; loop<'+s+'; loop++)','');
                addline(@procfunclist,'		'+no0(pgn^.labelid)+'Labels[loop] = '+
                  sfp(producernode^.getstring)+'((LONG)'+no0(pgn^.labelid)+'Labels[loop]);','');
              end;
          
          end;
        mybool_kind :
          if boolean(pgn^.tags[1].ti_data) then
            begin
              addline(@constlist,'','');
              s:='struct IntuiText '+no0(pgn^.labelid)+'IText = { ';
              str(pgn^.tags[3].ti_tag,s2);
              s:=s+s2+', ';
              str(pgn^.tags[3].ti_data,s2);
              s:=s+s2+', ';
              str(pgn^.tags[4].ti_tag,s2);
              s:=s+s2+', ';
              str(pgn^.tags[2].ti_tag,s2);
              s:=s+s2+', ';
              str(pgn^.tags[2].ti_data,s2);
              s:=s+s2+', ';
              if pdwn^.codeoptions[6] then
                if not pdwn^.codeoptions[17] then
                  s:=s+'&'+makemyfont(pdwn^.gadgetfont)+', '
                 else
                  s:=s+'NULL, '
               else
                s:=s+'&'+makemyfont(pgn^.font)+', ';
              if pdwn^.localeoptions[1] then
                s:=s+'NULL, NULL '
               else
                s:=s+'(STRPTR)"'+no0(pgn^.title)+'", NULL ';
              addline(@constlist,' ','');
              addline(@constlist,s+'};','');
            end;
        listview_kind :
          if pgn^.tags[10].ti_data=long(true) then
            begin
              loop:=0;
              addline(@constlist,'','');
              addline(@constlist,'struct Node '+no0(pgn^.labelid)+'ListItems[] =','');
              addline(@constlist,'	{','');
              mycount:=0;
              psn:=pstringnode(pgn^.infolist.mlh_head);
              while (psn^.ln_succ<>nil) do
                begin
                  if sizeoflist(@pgn^.infolist)>1 then
                    if loop=0 then
                      begin
                        str(loop+1,s2);
                        if pdwn^.localeoptions[1] then
                          begin
                            str(mycount,s3);
                            localestring(no0(psn^.st),no0(pgn^.labelid)+'String'+s3,'Window: '+
                                    no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                            s:='	&'+no0(pgn^.labelid)+'ListItems['+s2+'], (struct Node *)&'
                              +no0(pgn^.labelid)+'List.mlh_Head, 0, 0, (char *)'+no0(pgn^.labelid)+'String'+s3+',';
                          end
                         else
                          s:='	&'+no0(pgn^.labelid)+'ListItems['+s2+'], (struct Node *)&'
                              +no0(pgn^.labelid)+'List.mlh_Head, 0, 0, (char *)"'+no0(psn^.st)+'",';
                        addline(@constlist,s,'');
                      end
                     else
                      if loop=sizeoflist(@pgn^.infolist)-1 then
                        begin
                          s:='( struct Node *)&'+no0(pgn^.labelid)+'List.mlh_Tail, ';
                          str(loop-1,s2);
                          if pdwn^.localeoptions[1] then
                            begin
                              str(mycount,s3);
                              localestring(no0(psn^.st),no0(pgn^.labelid)+'String'+
                                s3,'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                              s:=s+'&'+no0(pgn^.labelid)+'ListItems['+s2+'], 0, 0, (char *)'+no0(pgn^.labelid)+'String'+s3;
                            end
                           else
                            s:=s+'&'+no0(pgn^.labelid)+'ListItems['+s2+'], 0, 0, (char *)"'+no0(psn^.st)+'"';
                          addline(@constlist,'	'+s,'');
                        end
                       else
                        begin
                          str(loop+1,s2);
                          s:='&'+no0(pgn^.labelid)+'ListItems['+s2+'], &';
                          str(loop-1,s2);
                          s:=s+no0(pgn^.labelid)+'ListItems['+s2+'], ';
                          if pdwn^.localeoptions[1] then
                            begin
                              str(mycount,s3);
                              localestring(no0(psn^.st),no0(pgn^.labelid)+'String'+s3,'Window: '+
                                no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                              addline(@constlist,'	'+s+'0, 0, (char *)'+no0(pgn^.labelid)+'String'+s3+',','');
                            end
                           else
                            begin
                              addline(@constlist,'	'+s+'0, 0, (char *)"'+no0(psn^.st)+'",','');
                            end;
                        end
                   else
                    begin
                      if pdwn^.localeoptions[1] then
                        begin
                          str(mycount,s3);
                          localestring(no0(psn^.st),no0(pgn^.labelid)+'String'+s3,'Window: '+no0(pdwn^.title)
                                  +' Gadget: '+no0(pgn^.title)+' String');
                          addline(@constlist,'	( struct Node * )&'+no0(pgn^.labelid)+'List.mlh_Tail'+
                                         ', ( struct Node * )&'+no0(pgn^.labelid)+'List.mlh_Head,'+
                                         ' 0, 0, (STRPTR)'+no0(pgn^.labelid)+'String'+s3,'');
                        end
                       else
                        addline(@constlist,'	( struct Node * )&'+no0(pgn^.labelid)+'List.mlh_Tail'+
                                         ', ( struct Node * )&'+no0(pgn^.labelid)+'List.mlh_Head,'+
                                         ' 0, 0, (STRPTR)"'+no0(psn^.st)+'"','');
                    end;
                  inc(loop);
                  inc(mycount);
                  psn:=psn^.ln_succ;
                end;
              addline(@constlist,'	};','');
              addline(@constlist,'','');
              addline(@constlist,'struct MinList '+no0(pgn^.labelid)+'List =','');
              addline(@externlist,'extern struct MinList '+no0(pgn^.labelid)+'List;','');
              addline(@constlist,'	{','');
              str(sizeoflist(@pgn^.infolist)-1,s2);
              addline(@constlist,'	( struct MinNode * )&'+no0(pgn^.labelid)
                                 +'ListItems[0], ( struct MinNode * )NULL , ( struct MinNode * )&'+no0(pgn^.labelid)
                                 +'ListItems['+s2+']','');
              addline(@constlist,'	};','');
              str(mycount,s);
              if pdwn^.localeoptions[1] then
                begin
                  addline(@procfunclist,'	for ( loop=0; loop<'+s+'; loop++)','');
                  addline(@procfunclist,'		'+no0(pgn^.labelid)+'ListItems[loop].ln_Name = (char *)'
                      +sfp(producernode^.getstring)+'((LONG)'+no0(pgn^.labelid)+'ListItems[loop].ln_Name);','');
                end;
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
          addline(@defineslist,'#define '+no0(pgn^.labelid)+' '+s,'');
          inc(loop);
          pgn:=pgn^.ln_succ;
        end;
    
      if producernode^.codeoptions[10] then
        begin
        
        pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
        while(pgn^.ln_succ<>nil) do
          begin
            str(pgn^.id,s);
            addline(@defineslist,'#define GD_'+no0(pgn^.labelid)+' '+s,'');
            pgn:=pgn^.ln_succ;
          end;
        
        pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
        while(pgn^.ln_succ<>nil) do
          begin
            str(pgn^.id-pdwn^.nextid,s);
            addline(@defineslist,'#define GDX_'+no0(pgn^.labelid)+' '+s,'');
            pgn:=pgn^.ln_succ;
          end;

        end;
      
    end;
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    dogadgets(pdwn);  
  
  { end of first run stuff }
  
  addline(@procfunclist,'	}','');
  
  
  if pdwn^.usezoom then                                           {4}
    begin
      s:='UWORD '+no0(pdwn^.labelid)+'ZoomInfo[4] = { ';
      str(pdwn^.zoom[1],s2);
      s:=s+s2+', ';
      str(pdwn^.zoom[2],s2);
      s:=s+s2+', ';
      str(pdwn^.zoom[3],s2);
      s:=s+s2+', ';
      str(pdwn^.zoom[4],s2);
      s:=s+s2+' };'#0;
      addline(@constlist,s,'');
    end;
  
  
  
  spaces:='';
  if pdwn^.codeoptions[1] then
    begin
      addline(@procfunclist,'if ('+no0(pdwn^.labelid)+' == NULL)','');
      addline(@procfunclist,'	{','');
      spaces:=spaces+'	';
    end;
  
  if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
    begin
      if pdwn^.pubscreenname then
        if no0(pdwn^.defpubname)='' then
          s:='ScrName'
         else
          s:='(UBYTE *)"'+no0(pdwn^.defpubname)+'"'
       else
        s:='NULL';
      
      addline(@procfunclist,spaces+'Scr = LockPubScreen('+s+');','');{17}
      if pdwn^.pubscreenfallback and pdwn^.pubscreenname then
        begin
          addline(@procfunclist,spaces+'if (NULL == Scr)','');{17}
          addline(@procfunclist,spaces+'Scr = LockPubScreen(NULL);','');{17}
        end;
      addline(@procfunclist,spaces+'if (NULL != Scr)','');{17}
      addline(@procfunclist,spaces+'	{','');                    {19}
      spaces:=spaces+'	';
    end;
  
  if pdwn^.codeoptions[9] and (not pdwn^.gimmezz) then
    begin
      addline(@procfunclist,spaces+'offx = Scr->WBorLeft;','');
      addline(@procfunclist,spaces+'offy = Scr->WBorTop + Scr->Font->ta_YSize+1;','');
    end
   else
    begin
      str(pdwn^.offx,s);
      addline(@procfunclist,spaces+'offx = '+s+';','');
      str(pdwn^.offy,s);
      addline(@procfunclist,spaces+'offy = '+s+';','');
    end;
  
  if pdwn^.codeoptions[17] then
    begin
      str(pdwn^.fontx,s);
      addline(@procfunclist,spaces+'scalex = 65535*Scr->RastPort.Font->tf_XSize/'+s+';','');
      str(pdwn^.fonty,s);
      addline(@procfunclist,spaces+'scaley = 65535*Scr->RastPort.Font->tf_YSize/'+s+';','');
      if pdwn^.usezoom then
        begin
      str(pdwn^.zoom[3],s);
      addline(@procfunclist,spaces+no0(pdwn^.labelid)+'ZoomInfo[2] = ('+s+' * scalex)/65535;','');
      str(pdwn^.zoom[4],s);
      addline(@procfunclist,spaces+no0(pdwn^.labelid)+'ZoomInfo[3] = ('+s+' * scaley)/65535;','');
        end;
    end;
  
  addline(@procfunclist,spaces+'if (NULL != ( '+no0(pdwn^.labelid)+'VisualInfo = GetVisualInfoA( Scr, NULL)))',''); {23}
  addline(@procfunclist,spaces+'	{','');                 {24}
  spaces:=spaces+'	';
  
  addline(@procfunclist,spaces+'if (NULL != ( '+no0(pdwn^.labelid)+'DrawInfo = GetScreenDrawInfo( Scr)))',''); {23}
  addline(@procfunclist,spaces+'	{','');                 {24}
  spaces:=spaces+'	';
  
  
  {**********************************************}
  
  
  thosewhichneedscaling(pdwn,spaces);
  
  
  { do gadget stuff }
  
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    begin
      addline(@procfunclist,spaces+no0(pdwn^.labelid)+'GList = NULL;','');
      addline(@procfunclist,spaces+'Gad = CreateContext( &'+no0(pdwn^.labelid)+'GList);','');
      
      
      if count24>0 then
        begin
         
          if not pdwn^.codeoptions[19] then
            begin
              addline(@externlist,'extern UWORD '+no0(pdwn^.labelid)+'Depth;','');
              addline(@varlist,'UWORD '+no0(pdwn^.labelid)+'Depth;','');
            end;
          addline(@procfunclist,spaces+''+no0(pdwn^.labelid)+'Depth = Scr->BitMap.Depth;','');
          pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
          while (pgn^.ln_succ<>nil) do
            begin
              
              if (pgn^.kind=palette_kind) and (pgn^.tags[1].ti_data=0) then
                begin
                  str(pgn^.tagpos,s2);
                  addline(@procfunclist,spaces+nicestring(no0(pdwn^.labelid))+
                                        'GadgetTags['+s2+'] = (ULONG)Scr->BitMap.Depth;','');
                end;
              pgn:=pgn^.ln_succ;
            end;
        end;      
      
      str(sizeoflist(@pdwn^.gadgetlist),s2);
      addline(@procfunclist,spaces+'for ( loop=0 ; loop<'+s2+' ; loop++ )','');
      
      addline(@procfunclist,spaces+'	if ('+nicestring(no0(pdwn^.labelid))+'GadgetTypes[loop] != 198)','');
      
      spaces:=spaces+'	';
      
      addline(@procfunclist,spaces+'	{','');
      if producernode^.codeoptions[10] then
        addline(@procfunclist,spaces+'	CopyMem((char * )&'+nicestring(no0(pdwn^.labelid))+
                                   'NGad[loop], ( char * )&newgad, (long)sizeof( struct NewGadget ));','')
       else
        addline(@procfunclist,spaces+'	CopyMem((char * )&'+nicestring(no0(pdwn^.labelid))+
                                   'NewGadgets[loop], ( char * )&newgad, (long)sizeof( struct NewGadget ));','');
      pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
      while(pgn^.ln_succ<>nil) do
        begin
          if (pgn^.kind=listview_kind) and (pgn^.tags[3].ti_data<>0) then
            begin
              addline(@procfunclist,spaces+'	if ( newgad.ng_GadgetID == '+no0(pgn^.labelid)+' )','');
              str(pgn^.tagpos,s2);
              addline(@procfunclist,spaces+'		'+nicestring(no0(pdwn^.labelid))+
                                    'GadgetTags['+s2+'] = (ULONG)Gad;','');
            end;
          pgn:=pgn^.ln_succ;
        end;
      addline(@procfunclist,spaces+'	newgad.ng_VisualInfo = '+no0(pdwn^.labelid)+'VisualInfo;','');
      if pdwn^.codeoptions[17] then
        begin
          addline(@procfunclist,spaces+'	newgad.ng_LeftEdge = newgad.ng_LeftEdge*scalex/65535;','');
          addline(@procfunclist,spaces+'	newgad.ng_TopEdge = newgad.ng_TopEdge*scaley/65535;','');
          addline(@procfunclist,spaces+'	if ('+nicestring(no0(pdwn^.labelid))+'GadgetTypes[loop] != GENERIC_KIND)','');
          addline(@procfunclist,spaces+'		{','');
          addline(@procfunclist,spaces+'		newgad.ng_Width = newgad.ng_Width*scalex/65535;','');
          addline(@procfunclist,spaces+'		newgad.ng_Height = newgad.ng_Height*scaley/65535;','');
          addline(@procfunclist,spaces+'		};','');
          addline(@procfunclist,spaces+'	newgad.ng_TextAttr = Scr->Font;','');
        end;
      addline(@procfunclist,spaces+'	newgad.ng_LeftEdge += offx;','');
      addline(@procfunclist,spaces+'	newgad.ng_TopEdge += offy;','');
      if pdwn^.localeoptions[1] then
        begin
            addline(@procfunclist,spaces+'	if ( newgad.ng_GadgetText != (UBYTE *)~0)','');
            addline(@procfunclist,spaces+'		newgad.ng_GadgetText = '+sfp(producernode^.getstring)
                +'((LONG)newgad.ng_GadgetText);','');
            addline(@procfunclist,spaces+'	else','');
            addline(@procfunclist,spaces+'		newgad.ng_GadgetText = (UBYTE *)0;','');
           
        end;
      str(pdwn^.nextid,s);
      
      if pdwn^.codeoptions[10] then
        s:=no0(pdwn^.labelid)+'Gadgets[ newgad.ng_GadgetID - '+nicestring(no0(pdwn^.labelid))+'FirstID ] = '
       else
        s:='';
      
      addline(@procfunclist,spaces+'	'+no0(pdwn^.labelid)+'Gadgets[ loop ] = NULL;','');
      
      addline(@procfunclist,spaces+'	'+s+'Gad = CreateGadgetA( '+nicestring(no0(pdwn^.labelid))+'GadgetTypes[loop]'+
                            ', Gad, &newgad, (struct TagItem *) newgad.ng_UserData );','');
      count:=0;
      pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
      while(pgn^.ln_succ<>nil) do
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
          addline(@procfunclist,spaces+'	if ( Gad != NULL )','');
          spaces:=spaces+'	';
          addline(@procfunclist,spaces+'	switch (loop+'+nicestring(no0(pdwn^.labelid))+'FirstID)','');
          addline(@procfunclist,spaces+'		{','');
          first:=true;
          pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
          while(pgn^.ln_succ<>nil) do
            begin
               if ((pgn^.kind=string_kind) or (pgn^.kind=integer_kind))
                  and boolean(pgn^.tags[9].ti_data) then
                 begin
                    str(pgn^.id,s2);
                    addline(@procfunclist,spaces+'		case '+no0(pgn^.labelid)+' :','');
                    addline(@procfunclist,spaces+'			if (GadToolsBase->lib_Version==37)','');
                    addline(@procfunclist,spaces+'				Gad->Activation |= GACT_IMMEDIATE;','');
                    addline(@procfunclist,spaces+'			break;','');
                    if first then
                      begin
                        first:=false;
                        if (not producernode^.codeoptions[4]) then
                          begin
                            addline(@externlist,'extern struct Library *GadToolsBase;','');
                          end;
                      end;
                 end;
              if pgn^.kind=mybool_kind then
                begin
                  str(pgn^.id,s2);
                  addline(@procfunclist,spaces+'		case '+no0(pgn^.labelid)+' :','');
                  addline(@procfunclist,spaces+'			Gad->GadgetType |= GTYP_BOOLGADGET;','');
                  pin:=pimagenode(pgn^.pointers[1]);
                  
                  if pdwn^.codeoptions[17] and boolean(pgn^.tags[1].ti_data) then
                    addline(@procfunclist,spaces+'			'+no0(pgn^.labelid)+'IText.ITextFont = Scr->Font;','');
                  
                  if boolean(pgn^.tags[1].ti_data) then
                    begin
                      if pdwn^.localeoptions[1] then
                        addline(@procfunclist,spaces+'			'+no0(pgn^.labelid)+'IText.IText = '+
                              sfp(producernode^.getstring)+
                          '('+no0(pgn^.labelid)+'String);','');
                      addline(@procfunclist,spaces+'			Gad->GadgetText = &'+no0(pgn^.labelid)+'IText;','')
                    end;
                  
                  if pin<>nil then
                    addline(@procfunclist,spaces+'			Gad->GadgetRender = &'+sfp(pin^.in_label)+';','');
                  pin:=pimagenode(pgn^.pointers[2]);
                  if pin<>nil then
                    addline(@procfunclist,spaces+'			Gad->SelectRender = &'+sfp(pin^.in_label)+';','');
                  s:='';
                  if (pgn^.tags[1].ti_tag and gact_toggleselect)<>0 then
                    s:=s+'GACT_TOGGLESELECT|';
                  if (pgn^.tags[1].ti_tag and gact_immediate)<>0 then
                    s:=s+'GACT_IMMEDIATE|';
                  if (pgn^.tags[1].ti_tag and gact_relverify)<>0 then
                    s:=s+'GACT_RELVERIFY|';
                  if (pgn^.tags[1].ti_tag and gact_followmouse)<>0 then
                    s:=s+'GACT_FOLLOWMOUSE|';
                  if s<>'' then
                    begin
                      dec(s[0],1);
                      addline(@procfunclist,spaces+'			Gad->Activation = '+s+';','');
                    end;
                  pgn^.flags:=pgn^.flags or gflg_gadgimage;
                  str(pgn^.flags,s);
                  addline(@procfunclist,spaces+'			Gad->Flags = '+s+';','');
                  addline(@procfunclist,spaces+'			break;','');
                end;
              pgn:=pgn^.ln_succ;
            end;
          addline(@procfunclist,spaces+'		}','');
          dec(spaces[0],1);
        end;
      addline(@procfunclist,spaces+'	}','');
      dec(spaces[0],1);
      {30}
      {31}
      
      addcreateobjectcode(pdwn,spaces);
    
    end;
        
  { window opening bit }
  count:=sizeoflist(@pdwn^.gadgetlist);
  if (count>0) and (pdwn^.codeoptions[5]) then
    begin
      addline(@procfunclist,spaces+'if (Gad != NULL)','');  {32}
      addline(@procfunclist,spaces+'	{','');            {33}
      spaces:=spaces+'	';
    end;
  
  {****    ****    ****}
  
  
  {bitmap creation}
  
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      addline(@procfunclist,spaces+'if ('+no0(pdwn^.labelid)+'BitMap = (struct BitMap *)'+
                       'AllocMem(sizeof(struct BitMap),MEMF_PUBLIC | MEMF_CLEAR))','');  {32}
      addline(@procfunclist,spaces+'	{','');
      spaces:=spaces+'	';
      str(pdwn^.maxw,s);
      s:=s+', ';
      str(pdwn^.maxh,s2);
      s:=s+s2;
      addline(@procfunclist,spaces+'InitBitMap( '+no0(pdwn^.labelid)+'BitMap, Scr->BitMap.Depth, '+s+');','');
      addline(@procfunclist,spaces+'allocatedBitMaps = TRUE;','');
      addline(@procfunclist,spaces+'for (planeNum=0;','');
      addline(@procfunclist,spaces+'	( planeNum < Scr->BitMap.Depth) && (allocatedBitMaps == TRUE);','');
      addline(@procfunclist,spaces+'    planeNum++)','');
      addline(@procfunclist,spaces+'	{','');
       str(pdwn^.maxw,s);
      s:=s+', ';
      str(pdwn^.maxh,s2);
      s:=s+s2;
      addline(@procfunclist,spaces+'	'+no0(pdwn^.labelid)+'BitMap->Planes[planeNum] = AllocRaster( '+s+'); ','');
      addline(@procfunclist,spaces+'	if (NULL == '+no0(pdwn^.labelid)+'BitMap->Planes[planeNum])','');
      addline(@procfunclist,spaces+'		allocatedBitMaps = FALSE;','');
      addline(@procfunclist,spaces+'	else','');
      str(trunc((pdwn^.maxw+15)/16)*2*pdwn^.maxh,s);
      addline(@procfunclist,spaces+'		BltClear( '+no0(pdwn^.labelid)+'BitMap->Planes[planeNum], '+s+',1);','');
      addline(@procfunclist,spaces+'	}','');
      addline(@procfunclist,spaces+'if (allocatedBitMaps == TRUE)','');
      addline(@procfunclist,spaces+'	{','');
      
      spaces:=spaces+'	';
    end;
  
  { do window opening stuff }
  
  str(PDWN^.IDCMPVALUES,s);
  
  s:=spaces+'if (NULL != ('+no0(pdwn^.labelid)+' = OpenWindowTags( NULL, '; {73}
  s3:=spaces+'				';  
  str(pdwn^.x,s2);
  addline(@procfunclist,s+'(WA_Left), '+s2+',','');  {37}
  
  loop:=addwintags(pdwn,spaces);
  
  {* * * * * * * * * * * * * * * * * *}
  
  for loop6:=1 to 25 do
    if pdwn^.idcmplist[loop6] then
      pdwn^.idcmpvalues:=pdwn^.idcmpvalues or idcmpnum[Loop6];
  
  if not pdwn^.codeoptions[8] then
    begin
      str(loop,s);
      str(pdwn^.idcmpvalues,s2);
      addline(@procfunclist,s3+'(WA_IDCMP),'+s2+',',''); {71}
      inc(loop);
    end;
  addline(@procfunclist,s3+'(TAG_END))))',''); {72}
  {open window here}
  addline(@procfunclist,spaces+'	{','');                             {76}
  spaces:=spaces+'	';
  
  {** ** ** ** ** ** ** ** ** **}
  
  {
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    addline(@procfunclist,spaces+'SetRast('+no0(pdwn^.labelid)+'->RPort,0);','');
  }
   
  if pdwn^.codeoptions[8] then
    begin
      str(pdwn^.idcmpvalues,s2);
      addline(@procfunclist,spaces+no0(pdwn^.labelid)+'->UserPort = mp;','');
      addline(@procfunclist,spaces+'ModifyIDCMP( '+no0(pdwn^.labelid)+', '+s2+');','');
    end;
  if pdwn^.codeoptions[18] then
    addline(@procfunclist,spaces+no0(pdwn^.labelid)+
                          'AppWin = AddAppWindowA( awid, 0, '+no0(pdwn^.labelid)+', awmp, NULL);',''); {82}
  
  loop:=sizeoflist(@pdwn^.textlist);
  loop6:=sizeoflist(@pdwn^.imagelist);
  
  s:=no0(pdwn^.labelid)+', '+no0(pdwn^.labelid)+'VisualInfo ';
  
  if no0(pdwn^.rendparams)<>'' then
    s:=s+', '+no0(pdwn^.rendparams);
  
  if sizeoflist(@pdwn^.bevelboxlist)+loop+loop6+sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@procfunclist,spaces+'RendWindow'+nicestring(no0(pdwn^.labelid))+'('+s+');',''); {83}
  
   
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@procfunclist,spaces+'GT_RefreshWindow( '+no0(pdwn^.labelid)+', NULL);',''); {82}
   
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@procfunclist,spaces+'RefreshGList( '+no0(pdwn^.labelid)+'GList, '+no0(pdwn^.labelid)+', NULL, ~0);',''); {82}
  


  
  if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
    begin
      addline(@procfunclist,spaces+'UnlockPubScreen( NULL, Scr);','');    {20}
    end;
  
  {open menu?}
  
  if pdwn^.codeoptions[11] then
    begin
      if pdwn^.codeoptions[12] then
        begin
          addline(@procfunclist,spaces+'if ('+no0(pdwn^.menutitle)+' == NULL)',''); {84}
          addline(@procfunclist,spaces+'	MakeMenu'+no0(pdwn^.menutitle)+
                                '( '+no0(pdwn^.labelid)+'VisualInfo);',''); {85}
        end; 
      addline(@procfunclist,spaces+'if ('+no0(pdwn^.menutitle)+' != NULL)',''); {86}
      if (pdwn^.codeoptions[13]) then
        addline(@procfunclist,spaces+'	{',''); {87}
      addline(@procfunclist,spaces+'	SetMenuStrip( '+no0(pdwn^.labelid)+', '+no0(pdwn^.menutitle)+');',''); {87}
      if (pdwn^.codeoptions[13]) then
        begin
          addline(@procfunclist,spaces+'	return( 0L );',''); {87}
          addline(@procfunclist,spaces+'	}',''); {87}
          if pdwn^.codeoptions[8] then
            addline(@procfunclist,spaces+'CloseWindowSafely( '+no0(pdwn^.labelid)+' );','') {87}
           else
            addline(@procfunclist,spaces+'CloseWindow( '+no0(pdwn^.labelid)+' );',''); {87}
        end
       else
        addline(@procfunclist,spaces+'return( 0L );','') {87}
    end
   else
    addline(@procfunclist,spaces+'return( 0L );','') {87};
  
  {10101}
  
  {** ** ** ** ** ** ** ** ** **}
  {handle open fail}
  
  dec(spaces[0],1);
  addline(@procfunclist,spaces+'	}','');  {77}
  
  {* * * * * * * * * * * * * * * * * *}
  
  {****    ****    ****}
  
  if pdwn^.extracodeoptions[1] and pdwn^.extracodeoptions[2] then
    begin
      dec(spaces[0],1);
      addline(@procfunclist,spaces+'	}','');
      
      { free superbitmap }
      addline(@procfunclist,spaces+'for (planeNum = 0; planeNum < Scr->BitMap.Depth; planeNum++ )','');
      addline(@procfunclist,spaces+'	{','');
      str(pdwn^.maxw,s);
      s:=s+', ';
      str(pdwn^.maxh,s2);
      s:=s+s2;
      addline(@procfunclist,spaces+'	if (NULL != '+no0(pdwn^.labelid)+'BitMap->Planes[planeNum])','');
      addline(@procfunclist,spaces+'		FreeRaster('+no0(pdwn^.labelid)+'BitMap->Planes[planeNum], '+s+');','');
      addline(@procfunclist,spaces+'	}','');
      addline(@procfunclist,spaces+'FreeMem( '+no0(pdwn^.labelid)+'BitMap, sizeof(struct BitMap));','');
      dec(spaces[0],1);
      addline(@procfunclist,spaces+'	}','');
    end;
  
  if (sizeoflist(@pdwn^.gadgetlist)>0) and (pdwn^.codeoptions[5]) then      {if pgad<>nil}
    begin
      dec(spaces[0],1);
      addline(@procfunclist,spaces+'	}','');
    end;
  if (sizeoflist(@pdwn^.gadgetlist)>0) then
    addline(@procfunclist,spaces+'FreeGadgets( '+no0(pdwn^.labelid)+'GList);','');
  
  addline(@procfunclist,spaces+'FreeScreenDrawInfo( Scr, (struct DrawInfo *) '+no0(pdwn^.labelid)+'DrawInfo );','');
  dec(spaces[0],1);
  addline(@procfunclist,spaces+'	}',''); {29}
  

  
  
  addline(@procfunclist,spaces+'FreeVisualInfo( '+no0(pdwn^.labelid)+'VisualInfo );','');
  
  {**************************************************}
  
  dec(spaces[0],1);
  addline(@procfunclist,spaces+'	}',''); {29}
  
  
  if (not pdwn^.customscreen) and (not pdwn^.pubscreen) then
    begin
      dec(spaces[0],1);
      addline(@procfunclist,spaces+'	UnlockPubScreen( NULL, Scr);','');    {20}
      addline(@procfunclist,spaces+'	}','');
    end;
  if pdwn^.codeoptions[1] then
    begin
      if (not pdwn^.codeoptions[2]) and
         (not pdwn^.codeoptions[3]) and
         (pdwn^.codeoptions[7]) then
        addline(@procfunclist,'	}','')
       else
        begin
          addline(@procfunclist,'	}','');         {15}
          addline(@procfunclist,'else','');
          addline(@procfunclist,'	{','');         
          if pdwn^.codeoptions[2] then
            addline(@procfunclist,'	WindowToFront('+no0(pdwn^.labelid)+');','');
          if pdwn^.codeoptions[3] then
            addline(@procfunclist,'	ActivateWindow('+no0(pdwn^.labelid)+');','');
          if (pdwn^.codeoptions[7]) then
            addline(@procfunclist,'	return( 1L );','')
           else
            addline(@procfunclist,'	return( 0L );','');
          addline(@procfunclist,'	}','');
        end;
      {check if already open}
    end;
  addline(@procfunclist,'return( 1L );','');
  addline(@procfunclist,'}','');             {16}
  processclosewindow(pdwn);
  if producernode^.codeoptions[3] then
    processwindowidcmp(pdwn);
  comment:=producernode^.codeoptions[1];
end;

procedure makeimagemakefunction;
var
  pin     : pimagenode;
  oksofar : boolean;
  s       : string;
  s2      : string;
  psn     : pstringnode;
begin
  if not producernode^.codeoptions[5] then
    begin
      addline(@procfunclist,'','');
      addline(@procfunclist,'int MakeImages( void )','');
      addline(@procfuncdefslist,'extern int MakeImages( void );','');
      addline(@procfunclist,'{','');
      addline(@procfunclist,'UWORD failed = 0;','');
    end;
  if producernode^.codeoptions[2] and (not producernode^.codeoptions[5]) then
    begin
      addline(@procfunclist,'if (NULL != (WaitPointer=AllocMem( 72, MEMF_CHIP)))','');
      addline(@procfunclist,'	CopyMem( WaitPointerData, WaitPointer, 72);','');
      addline(@procfunclist,'else','');
      addline(@procfunclist,'	failed = 1;','');
    end;
  if sizeoflist(@producernode^.imagelist)>0 then
    addline(@constlist,'','');
  pin:=pimagenode(producernode^.imagelist.mlh_head);
  while(pin^.ln_succ<>nil) do
    begin
      s:=' 0, 0, ';
      str(pin^.width,s2);
      s:=s+s2+', ';
      str(pin^.height,s2);
      s:=s+s2+', ';
      str(pin^.depth,s2);
      if producernode^.codeoptions[5] then
        s:=s+s2+', &'+sfp(pin^.in_label)+'Data[0], '
       else
        s:=s+s2+', NULL, ';
      str(pin^.planepick,s2);
      s:=s+s2+', ';
      str(pin^.planeonoff,s2);
      s:=s+s2+', NULL';
      addline(@externlist,'extern struct Image '+sfp(pin^.in_label)+';','');
      addline(@constlist,'struct Image '+sfp(pin^.in_label)+' = {'+s+'};','');
      str(pin^.sizeallocated,s2);
      if not producernode^.codeoptions[5] then
        begin
          addline(@procfunclist,'if (NULL != ('+sfp(pin^.in_label)+'.ImageData=(UWORD *)AllocMem( '+s2+', MEMF_CHIP)))','');
          addline(@procfunclist,'	CopyMem( '+sfp(pin^.in_label)+'Data, '+sfp(pin^.in_label)+'.ImageData, '+s2+');','');
          addline(@procfunclist,'else','');
          addline(@procfunclist,'	failed = 1;','');  
        end;
      pin:=pin^.ln_succ;
    end;
  if not producernode^.codeoptions[5] then
    begin
      addline(@procfunclist,'if (failed==0)','');
      addline(@procfunclist,'	return( 0L );','');
      addline(@procfunclist,'else','');
      addline(@procfunclist,'	{','');
      addline(@procfunclist,'	FreeImages();','');
      addline(@procfunclist,'	return( 1L );','');
      addline(@procfunclist,'	}','');
      addline(@procfunclist,'}','');
      makeimagefreefunction;
    end;
end;

procedure makeimagefreefunction;
var
  pin     : pimagenode;
  oksofar : boolean;
  s       : string;
  psn     : pstringnode;
begin
  addline(@procfunclist,'','');
  addline(@procfunclist,'void FreeImages( void )','');
  addline(@procfuncdefslist,'extern void FreeImages( void );','');
  addline(@procfunclist,'{','');
  if producernode^.codeoptions[2] then
    begin
      addline(@procfunclist,'if (WaitPointer != NULL)','');
      addline(@procfunclist,'	FreeMem( WaitPointer, 72);','');
      addline(@procfunclist,'WaitPointer = NULL;','');
    end;
  pin:=pimagenode(producernode^.imagelist.mlh_head);
  while(pin^.ln_succ<>nil) do
    begin
      str(pin^.sizeallocated,s);
      addline(@procfunclist,'if ('+sfp(pin^.in_label)+'.ImageData != NULL)','');
      addline(@procfunclist,'	FreeMem('+sfp(pin^.in_label)+'.ImageData, '+s+');','');
      addline(@procfunclist,sfp(pin^.in_label)+'.ImageData = NULL;','');
      pin:=pin^.ln_succ;
    end;
  addline(@procfunclist,'}','');
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

procedure addlinefront(pl:plist;s:string;comstr:string,'');
var
  psn     : pstringnode;
begin
  if oksofar then
    begin
      if (s<>'')or((s='') and (comstr=''))or((s='') and (comstr<>'') and comment) then
        begin
          if not comment then
            comstr:='';
          psn:=allocmymem(sizeof(tstringnode)-254+length(s)+length(comstr),memf_clear or memf_public);
          if psn<>nil then
            begin
              inc(linecount);
              psn^.st:=s+comstr+#0;
              addhead(pl,pnode(psn));
            end
           else
            oksofar:=false
        end;
    end;
end;

procedure menuidcmp(pdmn:pdesignermenunode);
var
  pmtn    : pmenutitlenode;
  pmin    : pmenuitemnode;
  pmsi    : pmenusubitemnode;
begin
  addline(@idcmplist,'','');
  addline(@idcmplist,'/* Menu Processing for '+sfp(pdmn^.mn_label)+' */','');
  addline(@idcmplist,'/* Just pass the code field from an IDCMP_MENUPICK or IDCMP_MENUHELP message. */','');
  addline(@idcmplist,'','');
  addline(@idcmplist,'void ProcessMenuIDCMP'+sfp(pdmn^.mn_label)+'( UWORD MenuNumber)','');
  addline(@idcmplist,'{','');
  addline(@idcmplist,'UWORD MenuNum;','');
  addline(@idcmplist,'UWORD ItemNumber;','');
  addline(@idcmplist,'UWORD SubNumber;','');
  addline(@idcmplist,'int Done=0;','						/* Set Done to 1 to forget rest of next selects. */');
  addline(@idcmplist,'struct MenuItem *item;','');
  addline(@idcmplist,'while ((MenuNumber != MENUNULL) && (Done == 0))','');
  addline(@idcmplist,'	{','');
  addline(@idcmplist,'	item = ItemAddress( '+sfp(pdmn^.mn_label)+', MenuNumber);','');
  addline(@idcmplist,'	MenuNum = MENUNUM(MenuNumber);','');
  addline(@idcmplist,'	ItemNumber = ITEMNUM(MenuNumber);','');
  addline(@idcmplist,'	SubNumber = SUBNUM(MenuNumber);','');
  addline(@idcmplist,'	switch ( MenuNum )','');
  addline(@idcmplist,'		{','');
  addline(@idcmplist,'		case NOMENU :','');
  addline(@idcmplist,'','			/* No Menu Selected. */');
  addline(@idcmplist,'			break;','');
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while(pmtn^.ln_succ<>nil) do
    begin
      addline(@idcmplist,'		case '+sfp(pmtn^.mt_label)+' :','');
      addline(@idcmplist,'			switch ( ItemNumber )','');
      addline(@idcmplist,'				{','');
      addline(@idcmplist,'				case NOITEM :','');
      addline(@idcmplist,'','					/* No Item selcted. */');
      addline(@idcmplist,'					break;','');
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while (pmin^.ln_succ<>nil) do
        begin
        
          if not pmin^.barlabel then
            begin
        
          addline(@idcmplist,'				case '+sfp(pmin^.mi_label)+' :','');
          if sizeoflist(@pmin^.tsubitems)>0 then
            begin
              addline(@idcmplist,'					switch ( SubNumber )','');
              addline(@idcmplist,'						{','');
              addline(@idcmplist,'						case NOSUB :','');
              addline(@idcmplist,'							/* No SubItem selected. */','');
              addline(@idcmplist,'							break;','');
              
              pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
              while (pmsi^.ln_succ<>nil) do
                begin
                  
                  if not pmsi^.barlabel then
                    begin
                      addline(@idcmplist,'						case '+sfp(pmsi^.ms_label)+' :','');
                      addline(@idcmplist,'							/* SubItem Text : '+sfp(pmsi^.ms_text)+' */','');
                      addline(@idcmplist,'							break;','');
                    end;
                  
                  pmsi:=pmsi^.ln_succ;
                end;
              
              addline(@idcmplist,'						}','');
              addline(@idcmplist,'					break;','');
            end
           else
            begin
              addline(@idcmplist,'					/* Item Text : '+sfp(pmin^.mi_text)+' */','');
              addline(@idcmplist,'					break;','');
            end;
          
            end;
          
          pmin:=pmin^.ln_succ;
        end;
      addline(@idcmplist,'				}','');
      addline(@idcmplist,'			break;','');
      pmtn:=pmtn^.ln_succ;
    end;
  addline(@idcmplist,'		}','');
  addline(@idcmplist,'	MenuNumber = item->NextSelect;','');
  addline(@idcmplist,'	}','');
  addline(@idcmplist,'}','');
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
  gotags     : boolean;
  mycount    : long;
  car        : string;
begin
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
      addline(@defineslist,'#define '+sfp(pmtn^.mt_label)+' '+s2,'');
      inc(titlecount);
      if not pdmn^.localmenu then
        if length(sfp(pmtn^.mt_text))>count2-1 then
          count2:=length(sfp(pmtn^.mt_text))+1;
      itemcount:=0;
      inc(count);
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          str(itemcount,s2);
          addline(@defineslist,'#define '+sfp(pmin^.mi_label)+' '+s2,'');
          inc(itemcount);
          pin:=pmin^.graphic;
          if pmin^.barlabel then
            begin
              if count2<10 then count2:=10;
            end
           else
            if pin=nil then
              begin
                if not pdmn^.localmenu then
                  if length(sfp(pmin^.mi_text))>count2-1 then
                    count2:=length(sfp(pmin^.mi_text))+1;
              end
             else
              if length(sfp(pin^.in_label))+8>count2 then
                count2:=length(sfp(pin^.in_label))+8;
          inc(count);
          subcount:=0;
          pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              str(subcount,s2);
              addline(@defineslist,'#define '+sfp(pmsi^.ms_label)+' '+s2,'');
              inc(subcount);
              inc(count);
              pin:=pmsi^.graphic;
              if pmsi^.barlabel then
                begin
                  if count2<10 then count2:=10;
                end
               else
                if pin=nil then
                  begin
                    if not pdmn^.localmenu then
                      if length(sfp(pmsi^.ms_text))>count2-1 then
                        count2:=length(sfp(pmsi^.ms_text))+1;
                  end
                 else
                  if length(sfp(pin^.in_label))+8>count2 then
                    count2:=length(sfp(pin^.in_label))+8;
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  {count2 is longest string bit }
  addline(@constlist,'','');

  addline(@constlist,'struct Menu *'+sfp(pdmn^.mn_label)+' = NULL;','');
  addline(@externlist,'extern struct Menu *'+sfp(pdmn^.mn_label)+';','');
  
  inc(count2,2);
  str(count+1,s);
  addline(@constlist,'','');
  addline(@constlist,'struct NewMenu '+sfp(pdmn^.mn_label)+'NewMenu[] =','');
  addline(@constlist,'	{','');
  mycount:=0;
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      inc(count);
      inc(mycount);
      flagss:='';
      if pmtn^.disabled then
        flagss:='NM_MENUDISABLED';
      if flagss='' then flagss:='0';
      if pdmn^.localmenu then
        begin
          addline(@constlist,'	NM_TITLE, NULL'
                                 +replicate(' ',count2+4)
                                 +', (STRPTR)~0 , '+flagss+', NULL, (APTR)'+sfp(pmtn^.mt_label)+'String,','');
          localestring(sfp(pmtn^.mt_text),sfp(pmtn^.mt_label)+'String',
                'Menu: '+sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text));
          
        end
       else
        begin
          addline(@constlist,'	NM_TITLE, (STRPTR)"'+sfp(pmtn^.mt_text)+'"'
                                 +replicate(' ',count2-2-length(sfp(pmtn^.mt_text)))
                                 +',  NULL , '+flagss+', NULL, (APTR)~0,','');
        end;
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          inc(count);
          inc(mycount);
          if oksofar then
            begin
              flagss:='';
              if pmin^.disabled then
                flagss:='NM_ITEMDISABLED|';
              if pmin^.Checked then
                flagss:=flagss+'CHECKED|';
              if pmin^.Checkit then
                flagss:=flagss+'CHECKIT|';
              if pmin^.MenuToggle then
                flagss:=flagss+'MENUTOGGLE|';
              if flagss='' then
                flagss:='0'
               else
                dec(flagss[0],1);
              car:='';
              
              if pdmn^.localmenu then
                begin
                  if not pmin^.barlabel then
                    begin
                      localestring(char(pmin^.commkey),sfp(pmin^.mi_label)+'StringCommKey','Menu: '
                                +sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+' Item: '+sfp(pmin^.mi_text)+' CommKey');
                      car:='(STRPTR)'+sfp(pmin^.mi_label)+'StringCommKey';
                    end
                   else
                    car:='(STRPTR)~0';
                end
               else
                begin
                  if (char(pmin^.commkey)=#0)or(pmin^.barlabel) then
                    car:=' NULL '
                   else
                    car:='(STRPTR)"'+char(pmin^.commkey)+'"';
                end;
              
              if pmin^.exclude<>0 then
                str(pmin^.exclude,mxs)
               else
                mxs:='0L';
              if not pmin^.barlabel then
                if pmin^.graphic=nil then
                  begin
                    if pdmn^.localmenu then
                      begin
                        addline(@constlist,'	NM_ITEM , NULL'+
                                        replicate(' ',count2+4)
                                        +', '+car+', '+flagss+', '+mxs+', (APTR)'+sfp(pmin^.mi_label)+'String,','');
                        localestring(sfp(pmin^.mi_text),sfp(pmin^.mi_label)+'String','Menu: '
                            +sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+' Item: '+sfp(pmin^.mi_text));
                      end
                     else
                      begin
                        addline(@constlist,'	NM_ITEM , (STRPTR)"'+sfp(pmin^.mi_text)+'"'+
                                        replicate(' ',count2-2-length(sfp(pmin^.mi_text)))
                                        +', '+car+', '+flagss+', '+mxs+', (APTR)~0,','');
                      end;
                  end
                 else
                  addline(@constlist,'	IM_ITEM , (STRPTR)&'+sfp(pmin^.graphic^.in_label)+
                                        replicate(' ',count2-1-length(sfp(pmin^.graphic^.in_label)))
                                        +', '+car+', '+flagss+', '+mxs+', (APTR)~0,','')
               else
                addline(@constlist,'	NM_ITEM , NM_BARLABEL'+
                                      replicate(' ',count2-3)
                                      +', '+car+' , '+flagss+', '+mxs+', (APTR)~0,','')
            end;
          pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              inc(count);
              inc(mycount);
              if oksofar then
                begin
                  flagss:='';
                  if pmsi^.disabled then
                    flagss:='NM_ITEMDISABLED|';
                  if pmsi^.Checked then
                    flagss:=flagss+'CHECKED|';
                  if pmsi^.Checkit then
                    flagss:=flagss+'CHECKIT|';
                  if pmsi^.MenuToggle then
                    flagss:=flagss+'MENUTOGGLE|';
                  if flagss='' then
                    flagss:='0'
                   else
                    dec(flagss[0],1);
                  
                  if pdmn^.localmenu then
                    begin
                       if not pmsi^.barlabel then
                         begin
                           localestring(char(pmsi^.commkey),sfp(pmsi^.ms_label)+'StringCommKey','Menu: '
                                     +sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+' Item: '+sfp(pmin^.mi_text)+
                                     ' SubItem: '+sfp(pmsi^.ms_text)+' CommKey');
                           car:='(STRPTR)'+sfp(pmsi^.ms_label)+'StringCommKey';
                         end
                        else
                         car:='(STRPTR)~0';
                    end
                   else
                    begin
                      if (char(pmsi^.commkey)=#0)or(pmsi^.barlabel) then
                        car:=' NULL '
                       else
                        car:='(STRPTR)"'+char(pmsi^.commkey)+'"';
                    end;
                  
                  if pmsi^.exclude<>0 then
                    str(pmsi^.exclude,mxs)
                   else
                    mxs:='0L';
                  if not pmsi^.barlabel then
                    if pmsi^.graphic=nil then
                      begin
                        if pdmn^.localmenu then
                          begin
                            addline(@constlist,'	NM_SUB  , NULL'+
                                            replicate(' ',count2+4)
                                            +', '+car+', '+flagss+', '+mxs+', (APTR)'+sfp(pmsi^.ms_label)+'String,','');
                            localestring(sfp(pmsi^.ms_text),sfp(pmsi^.ms_label)+'String','Menu: '
                                +sfp(pdmn^.mn_label)+' Title: '+sfp(pmtn^.mt_text)+
                                    ' Item: '+sfp(pmin^.mi_text)+' SubItem: '+sfp(pmsi^.ms_text));
                          end
                         else
                          begin
                            addline(@constlist,'	NM_SUB  , (STRPTR)"'+sfp(pmsi^.ms_text)+'"'+
                                            replicate(' ',count2-2-length(sfp(pmsi^.ms_text)))
                                            +', '+car+', '+flagss+', '+mxs+', (APTR)~0,','');
                          end;
                       end
                     else
                      addline(@constlist,'	IM_SUB  , (STRPTR)&'+sfp(pmsi^.graphic^.in_label)+
                                            replicate(' ',count2-1-length(sfp(pmsi^.graphic^.in_label)))
                                            +', '+car+', '+flagss+', '+mxs+', (APTR)~0,','')
                   else
                    addline(@constlist,'	NM_SUB  , NM_BARLABEL'+
                                           replicate(' ',count2-3)
                                           +', '+car+', '+flagss+', '+mxs+', (APTR)~0,','')
                end;
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  addline(@constlist,'	NM_END  , NULL'+replicate(' ',count2+4)+',  NULL , 0, 0L, (APTR)~0','');
  addline(@constlist,'	};','');
  
  addline(@procfunclist,'','');
  addline(@procfunclist,'int MakeMenu'+sfp(pdmn^.mn_label)+'( APTR MenuVisualInfo )','');
  addline(@procfuncdefslist,'extern int MakeMenu'+sfp(pdmn^.mn_label)+'( APTR MenuVisualInfo );','');
  
  addline(@procfunclist,'{','');
  if pdmn^.localmenu then
    addline(@procfunclist,'UWORD loop;','');
  gotags:=false;
  s:='';
  if pdmn^.localmenu then
    begin
      addline(@constlist,'','');

      addline(@constlist,'ULONG '+sfp(pdmn^.mn_label)+'FirstRun = 1;','');
    end;

  if pdmn^.frontpen<>0 then
    begin
      gotags:=true;
      addline(@constlist,'','');
      addline(@constlist,'ULONG '+sfp(pdmn^.mn_label)+'Tags[] =','');
      addline(@constlist,'	{','');
      str(pdmn^.frontpen,s);
      addline(@constlist,'	(GTMN_FrontPen), '+s+',','');
      addline(@constlist,'	(TAG_DONE),','');
    end;
  if pdmn^.localmenu then
    begin
      addline(@constlist,'','');
      str(mycount,s);
      addline(@procfunclist,'	if ('+sfp(pdmn^.mn_label)+'FirstRun == 1)','');
      addline(@procfunclist,'		for ( loop=0; loop<'+s+'; loop++)','');
      addline(@procfunclist,'			{','');
      addline(@procfunclist,'			if ('+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_UserData!=(APTR)~0)','');
      addline(@procfunclist,'				'+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_Label = '+
                sfp(producernode^.getString)
                +'((LONG)'+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_UserData);','');
      
      addline(@procfunclist,'			if ('+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_CommKey!=(STRPTR)~0)','');
      addline(@procfunclist,'				{','');
      addline(@procfunclist,'				'+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_CommKey = '+
                sfp(producernode^.getString)
                +'((LONG)'+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_CommKey);','');
      
      addline(@procfunclist,'				if ( *((char *)'+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_CommKey) == 0)','');
      addline(@procfunclist,'				    '+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_CommKey = (STRPTR)0;','');
      addline(@procfunclist,'				}','');
      addline(@procfunclist,'			else','');
      addline(@procfunclist,'				'+sfp(pdmn^.mn_label)+'NewMenu[loop].nm_CommKey = (STRPTR)0;','');
      
                
      addline(@procfunclist,'			'+sfp(pdmn^.mn_label)+'FirstRun = 0;','');
      addline(@procfunclist,'			}','');
    end;
  if gotags then
    s:='(struct TagItem *)(&'+sfp(pdmn^.mn_label)+'Tags[0])'
   else
    s:='NULL';
  addline(@procfunclist,'	if (NULL == ('+sfp(pdmn^.mn_label)+
                        ' = CreateMenusA( '+sfp(pdmn^.mn_label)+'NewMenu, '+s+'))) ','');
  addline(@procfunclist,'		return( 1L );','');
  s:='';
  if not pdmn^.defaultfont then
    begin
      
      s:='GTMN_TextAttr, '+makemyfont(pdmn^.font)+', ';
      if not gotags then
      	begin
      	  addline(@constlist,'','');
          addline(@constlist,'ULONG '+sfp(pdmn^.mn_label)+'Tags[] =','');
          addline(@constlist,'	{','');
          gotags:=true;
          addline(@procfunclist,'	LayoutMenusA( '+sfp(pdmn^.mn_label)+
                 ', MenuVisualInfo, (struct TagItem *)(&'+sfp(pdmn^.mn_label)+'Tags[0]));','');
        end
       else
        addline(@procfunclist,'	LayoutMenusA( '+sfp(pdmn^.mn_label)+
           ', MenuVisualInfo, (struct TagItem *)(&'+sfp(pdmn^.mn_label)+'Tags[3]));','');
      addline(@constlist,'	(GT_TagBase+67), TRUE,','');
      addline(@constlist,'	(GTMN_TextAttr), (ULONG)&'+makemyfont(pdmn^.font)+',','');
      addline(@constlist,'	(TAG_DONE)','');
    end
   else
    begin
      if not gotags then
      	begin
      	  addline(@constlist,'','');
          addline(@constlist,'ULONG '+sfp(pdmn^.mn_label)+'Tags[] =','');
          addline(@constlist,'	{','');
          gotags:=true;
          addline(@procfunclist,'	LayoutMenusA( '+sfp(pdmn^.mn_label)+
                 ', MenuVisualInfo, (struct TagItem *)(&'+sfp(pdmn^.mn_label)+'Tags[0]));','');
        end
       else
        addline(@procfunclist,'	LayoutMenusA( '+sfp(pdmn^.mn_label)+
             ', MenuVisualInfo, (struct TagItem *)(&'+sfp(pdmn^.mn_label)+'Tags[3]));','');
      addline(@constlist,'	(GT_TagBase+67), TRUE,','');
      addline(@constlist,'	(TAG_DONE)','');
    end;
  addline(@procfunclist,'	return( 0L );','');
  addline(@procfunclist,'}','');
  if gotags then
    addline(@constlist,'	};','');
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
      addline(@constlist,'UWORD '+sfp(pin^.in_label)+'Colours[] =','  /* Use LoadRGB4 to use this. */');
      addline(@constlist,'	{','');
      s:='	';
      for loop:=0 to (pin^.mapsize div 2)-1 do
        begin
          str(pin^.colourmap^[loop],s2);
          s:=s+s2;
          if loop=(pin^.mapsize div 2 )-1then
            begin
              addline(@constlist,s,'');
            end
           else
            if length(s)>80 then
              begin
                s:=s+',';
                addline(@constlist,s,'');
                s:='	';
              end
             else
              s:=s+',';
        end;
      addline(@constlist,'	};','');
    end;
  addline(@constlist,'','');
  if  oksofar then
    begin
      {constlist}
      datasize:=trunc((pin^.width+15)/16)*pin^.height*pin^.depth;
      str(datasize,s);
      
      s4:=s;
      
      
      if producernode^.codeoptions[5] then
        addline(@constlist,'UWORD __chip '+sfp(pin^.in_label)+'Data['+s4+'] =','')
       else
        addline(@constlist,'UWORD '+sfp(pin^.in_label)+'Data['+s4+'] =','');
      if oksofar then
        begin
          pwa:=pwordarray(pin^.imagedata);
          currentpos:=1;
          addline(@constlist,'	{','');
            begin
              st:='	';
              repeat
                str(pwa^[currentpos],s);
                if length(st+s)>79 then   {allowing for comma}
                  begin
                    if oksofar then
                      addline(@constlist,st,'');
                    if (linecount div 19)*19=linecount then
                      begin
                        setlinenumber;
                        if oksofar then
                          oksofar:=checkinput;
                      end;
                    st:='	';
                  end;
                if oksofar then
                  begin
                    st:=st+s;
                    if currentpos<>datasize then
                      st:=st+','
                     else
                      begin
                        if oksofar then
                          addline(@constlist,st,'');
                        if (linecount div 19)*19=linecount then
                        begin
                          setlinenumber;
                          if oksofar then
                            oksofar:=checkinput;
                        end;
                      end;
                  end;
                inc(currentpos);
              until (not oksofar) or (currentpos>datasize);
              if oksofar then
                addline(@constlist,'	};','');
            end;
        end;
    end;
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

procedure seterror(s:string);
begin
  writeln(s);
end;

procedure clearerror;
begin
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

procedure freemymem(mem:pointer);
begin
  dec(memused);
  freevec(mem);
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
  procdef:array[1..16] of string[80]=
  (
  '',
  'void StripIntuiMessages( struct MsgPort *mp, struct Window *win)',
  '{',
  'struct IntuiMessage *msg;',
  'struct Node *succ;',
  'msg = (struct IntuiMessage *)mp->mp_MsgList.lh_Head;',
  'while (succ = msg->ExecMessage.mn_Node.ln_Succ)',
  '	{',
  '	if (msg->IDCMPWindow == win)',
  '		{',
  '		Remove((struct Node *)msg);',
  '		ReplyMsg((struct Message *)msg);',
  '		}',
  '	msg = (struct IntuiMessage *)succ;',
  '	}',
  '}'
  );
var
  loop : word;
begin
  if not procstripintuimessagesadded then
    begin
      for loop:=1 to 16 do
        addline(@procfunclist,procdef[loop],'');
      addline(@procfuncdefslist,'extern void StripIntuiMessages( struct MsgPort *mp, struct Window *win);','');
    end;
  procstripintuimessagesadded:=true;
end;

procedure addprocclosewindowsafely;
const
  procdef : array[1..10] of string[60]=
  (
  ''#0,
  'void CloseWindowSafely( struct Window *win)'#0,
  '{'#0,
  '	Forbid();'#0,
  '	StripIntuiMessages( win->UserPort, win);'#0,
  '	win->UserPort = NULL;'#0,
  '	ModifyIDCMP( win, 0L);'#0,
  '	Permit();'#0,
  '	CloseWindow( win);'#0,
  '}'#0
  );
var
  loop : word;
begin
  if not procclosewindowsafelyadded then
    begin
      for loop:=1 to 10 do
        addline(@procfunclist,procdef[loop],'');
      addline(@procfuncdefslist,'extern void CloseWindowSafely( struct Window *win);','');
    end;
  procclosewindowsafelyadded:=true;
end;

procedure makemainfilelist;
var
  loop : byte;
  spaces : string;
  pdwn : pdesignerwindownode;
  pdsn : pdesignerscreennode;
  sparam : string[20];
begin
  pdwn:=pdesignerwindownode(producernode^.windowlist.mlh_head);
  spaces:='';
  addline(@mainfilelist,'','');
  addline(@mainfilelist,'','');
  addline(@mainfilelist,'int main(void)','');
  addline(@mainfilelist,'{','');
  addline(@mainfilelist,'int done=0;','');
  addline(@mainfilelist,'ULONG clas;','');
  addline(@mainfilelist,'UWORD code;','');
  addline(@mainfilelist,'struct Gadget *pgsel;','');
  addline(@mainfilelist,'struct IntuiMessage *imsg;','');
  
  if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) then
    begin
      pdsn:=pdesignerscreennode(producernode^.screenlist.mlh_head);
      addline(@mainfilelist,'struct Screen *Scr=NULL;','');
    end;

 
  if (producernode^.codeoptions[4]) then
    begin
      spaces:=spaces+'	';
      addline(@mainfilelist,'if (OpenLibs()==0)','');
      addline(@mainfilelist,spaces+'{','');
    end;
  if producernode^.localecount>0 then
    addline(@mainfilelist,spaces+'Open'+sfp(producernode^.basename)+'Catalog(NULL,NULL);','');
  if producernode^.codeoptions[6] and (sizeoflist(@opendiskfontlist)>0) then
    begin
      addline(@mainfilelist,spaces+'OpenDiskFonts();','');
    end;
  if (sizeoflist(plist(@producernode^.imagelist))>0) and (not producernode^.codeoptions[5]) then
    begin
      addline(@mainfilelist,spaces+'if (MakeImages()==0)','');
      spaces:=spaces+'	';
      addline(@mainfilelist,spaces+'{','');
    end;
  
  sparam:='';
  if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) then
    begin
      if pdwn^.customscreen then
        sparam:='Scr';
      pdsn:=pdesignerscreennode(producernode^.screenlist.mlh_head);
      addline(@mainfilelist,spaces+'Scr = Open'+sfp(pdsn^.sn_label)+'Screen();','');
      addline(@mainfilelist,spaces+'if (Scr != NULL)','');
      addline(@mainfilelist,spaces+'	{','');
      spaces:=spaces+'	';
    end;
  
  if sizeoflist(plist(@producernode^.windowlist))>0 then
    begin
      
      
      
      if producernode^.codeoptions[10] then
        addline(@mainfilelist,spaces+'if (Open'+nicestring(no0(pdwn^.labelid))+'Window('+sparam+')==0)','')
       else
        addline(@mainfilelist,spaces+'if (OpenWindow'+nicestring(no0(pdwn^.labelid))+'('+sparam+')==0)','');
      
      spaces:=spaces+'	';
      addline(@mainfilelist,spaces+'{','');
      
      addline(@mainfilelist,spaces+'while(done==0)','');
      addline(@mainfilelist,spaces+'	{','');
      addline(@mainfilelist,spaces+'	Wait(1L << '+no0(pdwn^.labelid)+'->UserPort->mp_SigBit);','');
      addline(@mainfilelist,spaces+'	imsg=GT_GetIMsg('+no0(pdwn^.labelid)+'->UserPort);','');
      addline(@mainfilelist,spaces+'	while (imsg != NULL )','');
      addline(@mainfilelist,spaces+'		{','');
      addline(@mainfilelist,spaces+'		clas=imsg->Class;','');
      addline(@mainfilelist,spaces+'		code=imsg->Code;','');
      addline(@mainfilelist,spaces+'		pgsel=(struct Gadget *)imsg->IAddress; '+
             '/* Only reference if it is a gadget message */','');
      addline(@mainfilelist,spaces+'		GT_ReplyIMsg(imsg);','');
      
      if producernode^.codeoptions[3] then
        begin
          addline(@mainfilelist,spaces+'		ProcessWindow'+no0(pdwn^.labelid)+'(clas, code, pgsel);','');
          addline(@mainfilelist,spaces+'		/* The next line is just so you can quit, '+
               'remove when proper method implemented. */','');
          addline(@mainfilelist,spaces+'		if (clas==IDCMP_CLOSEWINDOW)','');
          addline(@mainfilelist,spaces+'			done=1;','');
         end
       else
        begin
          addline(@mainfilelist,spaces+'		if (clas==IDCMP_CLOSEWINDOW)','');
          addline(@mainfilelist,spaces+'			done=1;','');
          addline(@mainfilelist,spaces+'		if (clas==IDCMP_REFRESHWINDOW)','');
          addline(@mainfilelist,spaces+'			{','');
          addline(@mainfilelist,spaces+'			GT_BeginRefresh('+no0(pdwn^.labelid)+');','');
          addline(@mainfilelist,spaces+'			GT_EndRefresh('+no0(pdwn^.labelid)+', TRUE);','');
          addline(@mainfilelist,spaces+'			}','');
        end;
      addline(@mainfilelist,spaces+'		imsg=GT_GetIMsg('+no0(pdwn^.labelid)+'->UserPort);','');
      addline(@mainfilelist,spaces+'		}','');
      addline(@mainfilelist,spaces+'	}','');
      addline(@mainfilelist,spaces+'','');
      if producernode^.codeoptions[10] then
        addline(@mainfilelist,spaces+'Close'+nicestring(no0(pdwn^.labelid))+'Window();','')
       else
        addline(@mainfilelist,spaces+'CloseWindow'+nicestring(no0(pdwn^.labelid))+'();','');
      
      addline(@mainfilelist,spaces+'}','');
      dec(spaces[0],1);
      addline(@mainfilelist,spaces+'else','');
      addline(@mainfilelist,spaces+'	printf("Cannot open window.\n");','');
    end
   else
    addline(@mainfilelist,spaces+'/*  No windows - so not a lot to do here, ho hum. */','');
  
  if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) then
    begin
      pdsn:=pdesignerscreennode(plist(producernode^.screenlist.mlh_head));
      dec(spaces[0]);
      addline(@mainfilelist,spaces+'	CloseScreen(Scr);','');
      addline(@mainfilelist,spaces+'	}','');
      addline(@mainfilelist,spaces+'else','');
      addline(@mainfilelist,spaces+'	printf("Cannot Open Screen.\n");','');
    end;


  
  if (sizeoflist(plist(@producernode^.imagelist))>0) and (not producernode^.codeoptions[5]) then
    begin
      addline(@mainfilelist,spaces+'FreeImages();','');
      addline(@mainfilelist,spaces+'}','');
      dec(spaces[0],1);
      addline(@mainfilelist,spaces+'else','');
      addline(@mainfilelist,spaces+'	printf("Cannot make images.\n");','');
    end;
  if producernode^.localecount>0 then
    addline(@mainfilelist,spaces+'Close'+sfp(producernode^.basename)+'Catalog();','');
  if (producernode^.codeoptions[4]) then
    begin
      addline(@mainfilelist,spaces+'CloseLibs();','');
      addline(@mainfilelist,spaces+'}','');
      dec(spaces[0],1);
      addline(@mainfilelist,'else','');
      addline(@mainfilelist,'	printf("Cannot open libraries.\n");','');
    end;
  addline(@mainfilelist,'}','');
end;

procedure setuplocalestuff;
var
  s: string;
begin
  addline(@procfunclist,'','');
  addline(@procfuncdefslist,'extern STRPTR '+sfp(producernode^.getstring)+'(LONG strnum);','');
  
  addline(@procfunclist,'STRPTR '+sfp(producernode^.getstring)+'(LONG strnum)','');
  addline(@procfunclist,'{','');
  addline(@procfunclist,'	if ('+sfp(producernode^.basename)+'_Catalog == NULL)','');
  addline(@procfunclist,'		return('+sfp(producernode^.basename)+'_Strings[strnum]);','');
  addline(@procfunclist,'	return(GetCatalogStr('+sfp(producernode^.basename)+
              '_Catalog, strnum, '+sfp(producernode^.basename)+'_Strings[strnum]));','');
  addline(@procfunclist,'}','');
  
  addline(@procfunclist,'','');
  
  addline(@procfuncdefslist,'extern void Close'+sfp(producernode^.basename)+'Catalog(void);','');
  addline(@procfunclist,'void Close'+sfp(producernode^.basename)+'Catalog(void)','');
  addline(@procfunclist,'{','');
  addline(@procfunclist,'	if (LocaleBase != NULL)','');
  addline(@procfunclist,'		CloseCatalog('+sfp(producernode^.basename)+'_Catalog);','');
  addline(@procfunclist,'	'+sfp(producernode^.basename)+'_Catalog = NULL;','');
  addline(@procfunclist,'}','');
  
  addline(@procfunclist,'','');
  
  addline(@procfuncdefslist,'extern void Open'+
                sfp(producernode^.basename)+'Catalog(struct Locale *loc, STRPTR language);','');
 
  addline(@procfunclist,'void Open'+sfp(producernode^.basename)+'Catalog(struct Locale *loc, STRPTR language)','');
  addline(@procfunclist,'{','');
  addline(@procfunclist,'	LONG tag, tagarg;','');
  addline(@procfunclist,'	if (language == NULL)','');
  addline(@procfunclist,'		tag=TAG_IGNORE;','');
  addline(@procfunclist,'	else','');
  addline(@procfunclist,'		{','');
  addline(@procfunclist,'		tag = OC_Language;','');
  addline(@procfunclist,'		tagarg = (LONG)language;','');
  addline(@procfunclist,'		}','');
  addline(@procfunclist,'	if (LocaleBase != NULL  &&  '+sfp(producernode^.basename)+'_Catalog == NULL)','');
  addline(@procfunclist,'		'+sfp(producernode^.basename)+'_Catalog = OpenCatalog(loc, (STRPTR) "'+
              sfp(producernode^.basename)+'.catalog",','');
  addline(@procfunclist,'											OC_BuiltInLanguage, '+
            sfp(producernode^.basename)+'_BuiltInLanguage,','');
  addline(@procfunclist,'											tag, tagarg,','');
  addline(@procfunclist,'											OC_Version, '+
              sfp(producernode^.basename)+'_Version,','');
  addline(@procfunclist,'											TAG_DONE);','');
  addline(@procfunclist,'}','');
  
  addline(@constlist,'struct Catalog *'+sfp(producernode^.basename)+'_Catalog = NULL;','');
  addline(@externlist,'extern struct Catalog *'+sfp(producernode^.basename)+'_Catalog;','');
  
  addline(@constlist,'STRPTR '+sfp(producernode^.basename)+'_BuiltInLanguage = (STRPTR)"'+
             sfp(producernode^.builtinlanguage)+'";','');
  str(producernode^.localeversion,s);
  addline(@constlist,'LONG '+sfp(producernode^.basename)+'_Version = '+s+';','');
  includelocale:=true;

end;

end.