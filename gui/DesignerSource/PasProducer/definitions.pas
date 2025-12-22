unit definitions;

interface

uses asl,utility,exec,intuition,amiga,producerlib,
     gadtools,graphics,dos,amigados,workbench;

type
  
  
  { 
  
  
  tag fields inside gadgetnode structures.
  
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
      ga_immediate : boolean;
      further : 
    
    
    number entry tags:
      
      gtin_maxchars : word;
      stringa_justification : word;
      stringa_replacemode : boolean;
      ga_disabled : boolean;
      stringa_exithelp : boolean;
      ga_tabcycle : boolean;
      tag_done
      gt_underscore
      ga_immediate : boolean;
      further : 
   
   
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
      createlist in ti_data
      
    
    checkbox gadget tags
      
      gtcb_checked  : boolean;
      tag_done
      ga_disabled   : boolean;
      ga_underscore : boolean;
      gtcb_scaled   : boolean;
      
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
      ga_immediate : boolean;  use this one
      ga_relverify : boolean;  use this one
      gt_underscore : boolean;
      
      further : 
      
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
      ga_immediate  : boolean; use this one
      ga_relverify  : boolean; use this one
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
      use v39 ? : boolean     [10]
      FrontPen (+72)
      BackPen  (+73)
      Just     (+74)
      clipped  (+85)
      
    number gadget tags
      
      gtnm_number
      gtnm_border
      tag_done
      unused
      use v39 ? : boolean
      FrontPen (gt_tagbase+72)
      BackPen  (+73)
      Just     (+74)
      clipped  (+85)
      maxnumberlen
      
        pgn^.datas contains formating string
   
    radio gadget tags
      
      gtmx_active
      gtmx_spacing
      gtmx_labels
      tag_done
      gt_underscore
      gtmx_scaled

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
  comment               : boolean;
  linecount             : long;
  oksofar               : boolean;
  pla                   : plongarray;
  lengthtext2           : integer;
  heighttext2           : integer;
  memused               : long;
  idcmplist             : tlist;
  initlist              : tlist;
  ProducerNode          : pproducernode;
  constlist             : tlist;
  varlist               : tlist;
  typelist              : tlist;
  procfuncdefslist      : tlist;
  procfunclist          : tlist;
  opendiskfontlist      : tlist;
  mainfilelist          : tlist;
  localestringlist      : tlist;
  localelabellist       : tlist;
  
const
  
  displaywindowtitle : string[20] = 'HSPascal Producer';
  
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
  
  catalogfile : string [20] = 'Making Catalog'#0;
  
  mybool_kind = 227;
  
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
  
  myobject_kind = 198;
  
  mainfilestring : string[15]='Making Main'#0;
  
const
  cc : array[1..10] of string[35] =
(
'',
'function CloseCatalog; xassembler;',
'asm',
'	move.l	a6,-(sp)',
'	move.l	8(sp),a0',
'	move.l	LocaleBase,a6',
'	jsr		-$24(a6)',
'	move.l	d0,$C(sp)',
'	move.l	(sp)+,a6',
'end;'
);

gls : array[1..13] of string[35] =
(
'',
'function GetCatalogStr; xassembler;',
'asm',
'	move.l	a6,-(sp)',
'	lea		8(sp),a6',
'	move.l	(a6)+,a1',
'	move.l	(a6)+,d0',
'	move.l	(a6)+,a0',
'	move.l	LocaleBase,a6',
'	jsr		-$48(a6)',
'	move.l	d0,$14(sp)',
'	move.l	(sp)+,a6',
'end;'
);
 
oca : array[1..13] of string[35] =
(
'',
'function OpenCatalogA; xassembler;',
'asm',
'	movem.l	a2/a6,-(sp)',
'	lea		$C(sp),a6',
'	move.l	(a6)+,a2',
'	move.l	(a6)+,a1',
'	move.l	(a6)+,a0',
'	move.l	LocaleBase,a6',
'	jsr		-$96(a6)',
'	move.l	d0,$18(sp)',
'	movem.l	(sp)+,a2/a6',
'end;'
);

{$I /version.include}
  
implementation
end.