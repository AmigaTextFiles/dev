unit definitions;

interface

uses asl,utility,exec,intuition,amiga,producerlib,
     gadtools,graphics,dos,amigados,workbench;

type
  
  { 
    All :
      x,y,w,h,
      flags,
      id,
      title,
      labelid,
      tags,
      font,
      fontname
  
    mybool_kind
      x,y,w,h    : sizes.
      id         : gadgetid
      flags      : gflg_gadghnone
                   gflg_gadghcomp
                   gflg_gadghbox
                   gflg_gadghimage
                   gflg_gadgimage
                   gflg_selected
                   gflg_disabled
      kind       : mybool_kind
      tags[1].ti_tag : activation flags : gact_toggleselect
                                          gact_immediate
                                          gact_relverify
                                          gact_followmouse
      pointers[1] : pin gadgetrender
      pointers[2] : pin selectrender
      pointers[3] : 
      tags[4].ti_tag  =  drawmode
      tags[1].ti_data =  boolean use intuitext ?
      tags[2].ti_tag  =  intuitext x
      tags[2].ti_data =  intuitext y
      tags[3].ti_tag  =  intuitext frontpen
      tags[3].ti_data =  intuitext backpen
      title containing intuitext string
      typecast intuitext onto tags[5].ti_tag
      
      4.data,15.data used in edit window
    
    generic
      
      tag_done
      ga_disabled
      flags
      activation
      gadgetrender
      selecterender
      mutualexclude
      specialinfo
      
    button gadget tags :
      
      tag_done : nowt;
      ga_disabled : boolean;
      ga_underscore : boolean;
   
      No further information required
    
    text entry tags:
      
      gtst_maxchars : word;
      stringa_justification : word;
      stringa_replacemode : boolean;
      ga_disabled : boolean;
      stringa_exithelp : boolean;
      ga_tabcycle : boolean;
      tag_done
      gt_underscore :
      
      further : ga_immediate - see p388 libraries.
    
    number entry tags:
      
      gtin_maxchars : word;
      stringa_justification : word;
      stringa_replacemode : boolean;
      ga_disabled : boolean;
      stringa_exithelp : boolean;
      ga_tabcycle : boolean;
      tag_done
      gt_underscore
      
      further : ga_immediate - see p388 libraries.
   
    cycle gadget tags:
      
      gtcy_active
      tag_ignore
      gtcy_labels   : pointer to array of string pointers;
      tag_done      :  
      ga_underscore : boolean;
      ga_disabled
     
      further : 
                      
    listview gadget tags:
      
      gtlv_labels : pointer;
      gtlv_top : word;
      gtlv_showselected : boolean;
      gtlv_scrollwidth : word;
      gtlv_selected : word;
      layouta_spacing : word;
      tag_done
      gtlv_readonly : boolean;
      gt_underscore
      
      further : not a lot
    
    checkbox gadget tags
      
      gtcb_checked  : boolean;
      tag_done
      ga_disabled   : boolean;
      ga_underscore : boolean;
      
      further : nothing to add yet
      
    slider gadget tags
      
      gtsl_min : word;
      gtsl_max : word;
      gtsl_level : word;
      gtsl_levelformat : boolean if happens;
      gtsl_maxlevellen : word;
      gtsl_levelplace : word;
      ga_immediate : boolean;
      ga_relverify : boolean;
      pga_freedom : word;
      tag_done
      ga_disabled : boolean;
      ga_immediate : boolean; user
      ga_relverify : boolean; user
      gt_underscore : boolean;
      
      further : quite a lot
      
    scroller gadget tags
      
      gtsc_top    : word;
      gtsc_total  : word;
      gtsc_visible : word;
      gtsc_arrows : integer; tag = ignore if disabled
      ga_immediate : boolean;
      ga_relverify : boolean;
      pga_freedom : word;
      tag_done 
      ga_disabled   : boolean;
      ga_immediate  : boolean; user
      ga_relverify  : boolean; user 
      gt_underscore : boolean; true=under, false=noscore
      
      further : quite a lot
      
    palette gadget tags
      
      gtpa_depth    : word;
      gtpa_color    : word;
      gtpa_coloroffset     : word;
      gtpa_indicatorwidth  : word;
      gtpa_indicatorheight : word;
      tag_done
      ga_disabled   : word;
      gt_underscore : boolean; true=under,false=nounder
  
      further : 
      
    text gadget tags
      
      gttx_text
      gttx_border
      gttx_copytext
      tag_done
      
    number gadget tags
      
      gtnm_number
      gtnm_border
      tag_done
   
    radio gadget tags
      
      gtmx_active
      gtmx_spacing
      gtmx_labels
      tag_done
      gt_underscore
  }
  
  ppointerarray = ^tpointerarray;
  tpointerarray = array[1..10000] of pointer;
  
  pshortintarray = ^tshortintarray;
  tshortintarray = array [0..10000000] of shortint;
  
  pcstring = ^tcstring;
  tcstring = array[1..255] of byte;  
  
  pwordarray = ^twordarray;
  twordarray = array[1..1000] of word;
  
  pwbargarray = ^twbargarray;
  twbargarray = array[0..1000] of twbarg;
  
  ppwbargarray = ^tpwbargarray;
  tpwbargarray = array[0..1000] of pwbarg;
  
  plongarray = ^tlongarray;
  tlongarray = array[0..1000] of long;
  
var
  localestringlist      : tlist;
  comment               : boolean;
  lastobject            : pgadgetnode;
  linecount             : long;
  oksofar               : boolean;
  pla                   : plongarray;
  lengthtext2           : integer;
  heighttext2           : integer;
  tempstring92          : string;
  looppos               : word;
  producernode          : pproducernode;
  memused               : long;
  idcmplist             : tlist;
  constlist             : tlist;
  varlist               : tlist;
  typelist              : tlist;
  procfuncdefslist      : tlist;
  procfunclist          : tlist;
  defineslist           : tlist;
  externlist            : tlist;
  fontlist              : tlist;
  opendiskfontlist      : tlist;
  fontexternlist        : tlist;
  mainfilelist          : tlist;
  procsettagitemadded         : boolean;
  procprintstringadded        : boolean;
  procstripintuimessagesadded : boolean;
  procclosewindowsafelyadded  : boolean;
  procgeneralgadtoolsgadadded : boolean;
  includelocale               : boolean;
  procgetstringfromgadadded   : boolean;
  procgetintegerfromgadadded  : boolean;
  proccheckedboxadded         : boolean;
  beveltags                   : boolean;
  sharedwindow                : boolean;

const
  
  DisplayWindowTitle : string[15] = 'C Producer';
  
  myobject_kind = 198;
  
  tagtypelong    =0;
  tagtypeboolean =1;
  tagtypestring  =2;
  tagtypearraybyte =3;
  tagtypearrayword =4;
  tagtypearraylong =5;
  tagtypearraystring =6;
  tagtypestringlist = 7;
  tagtypeuser =8;
  tagtypeVisualInfo =9;
  tagtypeDrawInfo =10;
  tagtypeintuitext = 11;
  tagtypeimage = 12;
  tagtypeimagedata = 13;
  tagtypeleftcoord = 14;
  tagtypetopcoord = 15;
  tagtypewidthcoord = 16;
  tagtypeheightcoord = 17;
  tagtypegadgetid = 18;
  tagtypefont = 19;
  tagtypescreen = 20;
  tagtypeobject = 21;
  tagtypeuser2 = 22;
  
  mainfilestring : string[20] = 'Making Main File'#0;
  
  idcmpnum : array[1..25] of long=
  (
  idcmp_mousebuttons,    {}
  idcmp_mousemove,       {}
  idcmp_deltamove,       {}
  idcmp_gadgetdown,
  idcmp_gadgetup,        {}
  idcmp_closewindow,     {}
  idcmp_menupick,        {}
  idcmp_menuverify,      {}
  idcmp_menuhelp,        {}
  idcmp_reqset,          {}
  idcmp_reqclear,        {}
  idcmp_reqverify,       {}
  idcmp_newsize,         {}
  idcmp_refreshwindow,   {}
  idcmp_sizeverify,      {}
  idcmp_activewindow,    {}
  idcmp_inactivewindow,  {}
  idcmp_vanillakey,     { }
  idcmp_rawkey,          {}
  idcmp_newprefs,        {}
  idcmp_diskinserted,    {}
  idcmp_diskremoved,     {}
  idcmp_intuiticks,      {}
  idcmp_idcmpupdate,     {}
  idcmp_changewindow     {}
  );
  
  loading : string[15] = 'Reading File'#0;
  
  mybool_kind = 227;
  
  librarynames : array[1..25] of string[31]=
  (
  'arp.library'#0,
  'asl.library'#0,
  'commodities.library'#0,
  'diskfont.library'#0,
  'expansion.library'#0,
  'gadtools.library'#0,
  'graphics.library'#0,
  'icon.library'#0,
  'iffparse.library'#0,
  'intuition.library'#0,
  'keymap.library'#0,
  'layers.library'#0,
  'mathffp.library'#0,
  'mathieeedoubbas.library'#0,
  'mathieeedoubtrans.library'#0,
  'mathieeesingbas.library'#0,
  'mathieeesingtrans.library'#0,
  'rexxsyslib.library'#0,
  'reqtools.library'#0,
  'translator.library'#0,
  'utility.library'#0,
  'workbench.library'#0,
  'locale.library'#0,
  'end'
  );
  
catalogfile : string[20] = 'Making Catalog'#0;
  
{$I /version.include}

procedure addline(pl:plist;s:string;comstr:string);
function no0(s:string):string;
function makemyfont(font:ttextattr):string;
function sizeoflist(pl:plist):long;
function getlistpos(pl:plist;pn:pnode):long;
procedure localestring(stri:string;labl : string;comment:string);
function nicestring(s:string):string;

implementation

function nicestring(s:string):string;
var
  s2:string;
  loop : word;
begin
  s2:='';
  if s<>'' then
    for loop:= 1 to length(s) do
      begin
        if (s[loop]<>'-') and
           (s[loop]<>'>') and
           (s[loop]<>'^') and
           (s[loop]<>'.')
          then
           s2:=s2+s[loop];
      end;
  nicestring:=s2;
end;

procedure localestring(stri:string;labl : string;comment:string);
var
  s   : string;
begin
  
  if comment[0]>char(70) then
    comment[0]:=char(70);
  if stri[0]>char(70) then
    stri[0]:=char(70);
  
  
      comment:=comment+#0;
      stri:=stri+#0;
      labl:=labl+#0;
      if oksofar then
        oksofar:=boolean(AddLocaleString(producernode,@stri[1],@labl[1],@comment[1]));
end;


function getlistpos(pl:plist;pn:pnode):long;
var
  count : long;
  pn2   : pnode;
begin
  count:=0;
  pn2:=pl^.lh_head;
  while(pn2^.ln_succ<>nil)and(pn2<>pn) do
    begin
      inc(count);
      pn2:=pn2^.ln_succ;
    end;
  getlistpos:=count;
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

procedure addline(pl:plist;s:string;comstr:string);
var
  psn     : pstringnode;
begin
  if oksofar then
    begin
      if (s<>'')or((s='') and (comstr=''))or((s='') and (comstr<>'') and comment) then
        begin
          if not comment then
            comstr:='';
          psn:=allocvec(sizeof(tstringnode)-254+length(s)+length(comstr),memf_clear or memf_public);
          if psn<>nil then
            begin
              inc(memused);
              
              inc(linecount);
              psn^.st:=s+comstr+#0;
              addtail(pl,pnode(psn));
            end
           else
            oksofar:=false;
        end;
    end;
end;

function sizeoflist(pl:plist):long;
var
  pn:pnode;
  count : long;
begin
  count:=0;
  pn:=pl^.lh_head;
  while(pn^.ln_succ<>nil) do
    begin
      inc(count);
      pn:=pn^.ln_succ;
    end;
  sizeoflist:=count;
end;

function okchar(c:char):boolean;
const
   a1:string[36] = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
var
  loop : byte;
begin
  okchar:=false;
  for loop:=1 to 36 do
    if upcase(c)=a1[loop] then
      okchar:=true;
end;

function makemyfont(font:ttextattr):string;
var
  s    : string;
  s2   : string;
  s3   : string;
  loop : word;
  notfound : boolean;
  psn      : pstringnode;
  fontname : string;
begin
  ctopas(font.ta_name^,fontname);
  if sizeoflist(@fontlist)=0 then
    addline(@fontlist,'','');
  s3:=no0(fontname)+'", ';
  s:='';
  loop:=1;
  while(fontname[loop]<>'.')and(loop<length(fontname))and(fontname[loop]<>#0) do
    begin
      if okchar(fontname[loop]) then
        s:=s+fontname[loop];
      inc(loop);
    end;
  str(font.ta_ysize,s2);
  s3:=s3+s2+', ';
  s:=s+s2;
  str(font.ta_style,s2);
  s:=s+s2;
  s3:=s3+s2+', ';
  str(font.ta_flags,s2);
  s:=s+s2;
  s3:=s3+s2;
  makemyfont:=s;
  notfound:=true;
  psn:=pstringnode(fontlist.lh_head);
  while(psn^.ln_succ<>nil) do
    begin
      if no0(psn^.st)='struct TextAttr '+s+' = { (STRPTR)"'+s3+' };' then
        notfound:=false;
      psn:=psn^.ln_succ;
    end;
  if notfound then
    begin
      addline(@fontlist,'struct TextAttr '+s+' = { (STRPTR)"'+s3+' };','');
      addline(@fontexternlist,'extern struct TextAttr '+s+';','');
      addline(@opendiskfontlist,s,'');
    end;
end;


begin
  newlist(@localestringlist);
end.