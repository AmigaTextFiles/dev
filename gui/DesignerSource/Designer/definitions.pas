unit definitions;

{
  bevel types
  0 : normal
  1 : recessed
  2 : double
  4,5
  
  pdwn codeoptions
    1 : check if already open
    2 :   if already open then movetofront
    3 :   if already open then activate
    5 : only open if able to make gadgets
    4 : return boolean for openwindow
    6 :   fail if unable to open menus
    7 :   fail if already open
    8 : use custom msgport
    9 : calculate border sizes
    10: produce pgadget array
    11: make rendwindow procedure public
    12: slightly comment code
    13: attach menu
    14:   create menustrip if not done
    15:   fail if cannot attach
    16:   Free menu when closing window
}
{
  inputmode    job
  
  0            No special mode
  1            Clear input of user messages
  2            button
               string
               numeric
               cycle
               slider
               listview
               palette
               bevel
  3            Checkbox placing
  4            clone all selected gadets
  5            move to be same as 4
  6            Size a sizeable gadget
  7            Align left/right
  8            Align top/bottom
  17           Text printing
  18           Image printing
  101          move bevel
  102          size bevel
  157          shift select

  mxchoice     selected
  
  0            button gadget
  1            String Gadget
  2            Numeric Gadget
  3            CheckBox Gadget
  4            Radio
  5            Cycle
  6            Slider
  7            Scroller
  8            Listview
  9            Palette
  10           Text
  11           Number
  12           Bevel
  14           My Text
  28           My Image
  30           ''
  31           Play
  32           Generic
}

interface

uses asl,utility,exec,intuition,amiga,amigaguide,
     gadtools,graphics,dos,amigados,workbench,modeid;

type
  
  pimagenode = ^timagenode;
  
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
      
      further : attach editable string gadget
                edit list option
    
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
      FrontPen (+72)
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
  
  plocalenode = ^tlocalenode;
  tlocalenode = record 
    ln_succ         : plocalenode;
    ln_pred         : plocalenode;
    ln_type         : byte;
    ln_pri          : byte;
    ln_name         : pbyte;
    maxlength       : word;
    str             : string;
    extra           : boolean;
    comment         : string[70];
    labl            : string[70];
    
   end;
  
  pdesignermenunode = ^tdesignermenunode;
  tdesignermenunode = record
    ln_succ         : pdesignermenunode;
    ln_pred         : pdesignermenunode;
    ln_type         : byte;
    ln_pri          : byte;
    ln_name         : pbyte;
    editwindow      : pwindow;
    glist           : pgadget;
    gads            : array[1..55] of pgadget;
    screenvisinfo   : pointer;
    tmenulist       : tlist;
    idlabel         : string[66];
    titleselected   : long;
    itemselected    : long;
    subitemselected : long;
    testmenu        : pmenu;
    frontpen        : long;
    font            : ttextattr;
    fontname        : string[46];
    defaultfont     : boolean;
    nexttitle       : word;
    inusefontname   : string[46];
    inusetextattr   : ttextattr;
    newlook39       : boolean;
    localmenu       : boolean;
    localgad        : pgadget;
   end;
  
  pmenutitlenode = ^tmenutitlenode;
  tmenutitlenode = record
    ln_succ   : pmenutitlenode;
    ln_pred   : pmenutitlenode;
    ln_type   : byte;
    ln_pri    : byte;
    ln_name   : pbyte;
    idlabel   : string[66];
    text      : string[66];
    disabled  : boolean;
    titemlist : tlist;
    nextitem  : word;
    displaytext : string[66];
   end;
  
  pmenuitemnode = ^tmenuitemnode;
  tmenuitemnode = record
    ln_succ    : pmenuitemnode;
    ln_pred    : pmenuitemnode;
    ln_type    : byte;
    ln_pri     : byte;
    ln_name    : pbyte;
    idlabel    : string[66];
    barlabel   : boolean;
    text       : string[66];
    graphic    : pimagenode;
    commkey    : string[3];
    disabled   : boolean;
    checkit    : boolean;
    menutoggle : boolean;
    checked    : boolean;
    tsubitems  : tlist;
    textprint  : boolean;
    graphprint : boolean;
    exclude    : long;
    graphicname : string[66];
    nextsub     : word;
    displaytext : string[66];
   end;
  
  pmenusubitemnode = ^tmenusubitemnode;
  tmenusubitemnode = record
    ln_succ    : pmenusubitemnode;
    ln_pred    : pmenusubitemnode;
    ln_type    : byte;
    ln_pri     : byte;
    ln_name    : pbyte;
    idlabel    : string[66];
    barlabel   : boolean;
    text       : string[66];
    graphic    : pimagenode;
    commkey    : string[3];
    disabled   : boolean;
    checkit    : boolean;
    menutoggle : boolean;
    checked    : boolean;
    textprint  : boolean;
    graphprint : boolean;
    exclude    : long;
    graphicname : string[66];
    displaytext : string[66];
   end;

  pstringnode = ^tstringnode;
  tstringnode = record
    ln_succ : pstringnode;
    ln_pred : pstringnode;
    ln_type : byte;
    ln_pri  : byte;
    ln_name : pbyte;
    st      : string;
    va      : long;
   end;
  
  pscreenmodeprefs = ^tscreenmodeprefs;
  tscreenmodeprefs = record
    sm_reserved  : array [1..4] of long;
    sm_displayid : long;
    sm_width     : word;
    sm_height    : word;
    sm_depth     : word;
    sm_control   : word;
    changed      : boolean;
    font         : ttextattr;
    fontname     : string[46];
   end;
  
  pscreenmoderequester = ^tscreenmoderequester;
  tscreenmoderequester = record
    sm_displayid     : long;
    sm_displaywidth  : long;
    sm_displayheight : long;
    sm_displaydepth  : word;
   end;
  
  pnumberitem = ^tnumberitem;
  tnumberitem = record
    ln_succ : pnumberitem;
    ln_pred : pnumberitem;
    ln_type : byte;
    ln_pri  : byte;
    ln_name : pbyte;
    title   : string[66];
    num     : long;
    words   : array [1..5] of word;
   end;
  
  pgadeditwindow = ^tgadeditwindow;
  tgadeditwindow = record
    glist     : pgadget;
    pwin      : pwindow;
    gads      : array [0..31] of pgadget;
    data      : long;
    data2     : long;
    data3     : long;
    data4     : long;
    tfontname : string;
    tfont     : ttextattr;
    editlist  : tlist;
    glist2    : pgadget;
    extralist : tlist;
    object1   : pgadget;
    object2   : pgadget;
   end;
  
  ppointerarray = ^tpointerarray;
  tpointerarray = array[1..10000] of pointer;
  
  ptagarray = ^ttagarray;
  ttagarray = array [0..10000] of ttagitem;
  
  pgadgetnode = ^tgadgetnode;
  tgadgetnode = record
    ln_succ     : pgadgetnode;
    ln_pred     : pgadgetnode;
    ln_type     : byte;
    ln_pri      : byte;
    ln_name     : pbyte;
    quicksize   : boolean;
    flags       : long;
    pointers    : array [1..4] of pbyte;
    x,y,w,h     : long;
    id          : long;
    datas       : string[66];
    title       : string[66];
    kind        : long;
    editwindow  : pgadeditwindow;
    tags        : array[1..15] of ttagitem;
    seconds     : long;
    micros      : long;
    high        : boolean;
    labelid     : string[66];
    font        : ttextattr;
    fontname    : string[46];
    infolist    : tlist;
    joined      : boolean;
    pg          : pgadget;
    edithook    : string;
    ob          : pointer;
    contents    : string[85];
    contents2   : long;
    justcreated : boolean;
   end;
  
  pscreenmodenode = ^tscreenmodenode;
  tscreenmodenode = record
    ln_succ     : pscreenmodenode;
    ln_pred     : pscreenmodenode;
    ly_type     : byte;
    ln_pri      : byte;
    ln_name     : pbyte;
    dhandle     : pointer;
    monitorname : string[35];
    modeid      : long;
    tdispinfo   : tdisplayinfo; 
    tdimsinfo   : tdimensioninfo;
    tmoninfo    : tmonitorinfo;
   end;
  
  pwindownode = ^twindownode;
  twindownode = record
    ln_succ       : pwindownode;
    ln_pred       : pwindownode;
    ln_type       : byte;
    ln_pri        : byte;
    ln_name       : pbyte;
    pwin          : pwindow;
    glist         : pgadget;
    gadgets       : array [1..5] of pgadget;
    screenvisinfo : pointer;
    {
    hl            : tlist;
    }
    pscr          : pscreen;
    {
    num           : word;
    top           : word;
    thishelpmenu  : pmenu;
    thishelphandle: pointer;
    }
   end;

  ptextnode = ^ttextnode;
  ttextnode = record
    ln_succ   : ptextnode;
    ln_pred   : ptextnode;
    ln_type   : byte;
    ln_pri    : byte;
    ln_name   : pbyte;
    placed    : boolean;
    title     : string[66];
    frontpen  : byte;
    backpen   : byte;
    drawmode  : byte;
    x,y       : integer;
    pta       : ptextattr;
    itext     : pbyte;
    nexttext  : pbyte;
    ta        : ttextattr;
    fonttitle : string[46];
    screenfont: boolean;
   end;
  
  psmallimagenode = ^tsmallimagenode;
  tsmallimagenode = record
    ln_succ        : psmallimagenode;
    ln_pred        : psmallimagenode;
    ln_type        : byte;
    ln_pri         : byte;
    ln_name        : pbyte;
    placed         : boolean;
    x,y            : long;
    pin            : pimagenode;
    title          : string[66];
    imagename      : string[66];
   end;
  
  pdesignerwindownode = ^tdesignerwindownode;
  tdesignerwindownode = record
    ln_succ        : pdesignerwindownode;
    ln_pred        : pdesignerwindownode;
    ln_type        : byte;
    ln_pri         : byte;
    ln_name        : pbyte;
    
    bevelglist     : pgadget;
    bevelfirstnum  : long;
    bevelfirstgad  : pgadget;
    
    currentglist   : pgadget;
    oldglist       : pgadget;
    
    localeoptions  : array[1..5] of boolean;
    localegads     : array[1..5] of pgadget;
    moretags       : array[1..5] of boolean;
    moretaggads    : array[1..5] of pgadget;
    gadgetlistwindow      : pwindow;
    gadgetlistwindowglist : pgadget;
    gadgetlistwindowgads  : array[0..1] of pgadget;
    gadselected           : long;
    listmenu       : pmenu;
    backoptwin     : boolean;
    codeoptions    : array [1..20] of boolean;
    extracodeoptions : array [1..20] of boolean;
    tagswindow     : pwindow;
    tagsglist      : pgadget;
    tagsgads       : array [1..27] of pgadget;
    textgadsdis    : boolean;
    dripens        : array [0..10] of word;
    imageselected  : psmallimagenode;
    textselected   : ptextnode;
    textlist       : tlist;
    textgadgets    : array[1..14] of pgadget;
    imagelist      : tlist;
    imagegadsdis   : boolean;
    gadgetmenu     : pmenu;
    usecoordswindow: boolean;
    offx           : long;
    offy           : long;
    offsetsdone    : boolean;    
    bigimsel       : pimagenode;
    imagelistwindow: pwindow;
    imagelistglist : pgadget;
    imagegadgets   : array [1..15] of pgadget;
    coordstitle    : string[50];
    mxchoice       : word;
    alignselect    : word;
    editwindow     : pwindow;
    optionswindow  : pwindow;
    optionsglist   : pgadget;
    optionswingads : array[10..43] of pgadget;
    optionsmxgad   : pgadget;
    sizeswindow    : pwindow;
    sizesglist     : pgadget;
    idcmpwindow    : pwindow;
    idcmpglist     : pgadget;
    idcmpgads      : array [1..25] of pgadget;
    optionsgadgetsborderunselected : tborder;
    optionsgadgetsborderselected   : tborder;
    opgadbord3     : tborder;
    opgadbord4     : tborder;
    textlistwindow : pwindow;
    bevelboxlist   : tlist;
    textlistglist  : pgadget;
    glist          : pgadget;                      {}
    nextid         : long;
    useoffsets     : boolean;
    title          : string[66];                   {}
    x,y,w,h        : long;                         {}
    screentitle    : string[66];
    minw,maxw      : word;
    minh,maxh      : word;
    innerw,innerh  : word;
    spreadsize     : long;
    spreadpos      : byte;
    spreadsizegad  : pgadget;
    spreadcyclegad : pgadget;
    labelid        : string[66];
    zoom           : array[1..4] of word;
    biggad         : pgadget;
    mousequeue     : long;
    rptqueue       : long;
    sizegad        : boolean;                      {}
    sizebright     : boolean;                      {}
    sizebbottom    : boolean;                      {}
    dragbar        : boolean;                      {}
    depthgad       : boolean;                      {}
    closegad       : boolean;                      {}
    reportmouse    : boolean;
    nocarerefresh  : boolean;
    borderless     : boolean;
    backdrop       : boolean;
    gimmezz        : boolean;
    activate       : boolean;                      {}
    rmbtrap        : boolean;
    simplerefresh  : boolean;
    smartrefresh   : boolean;                      {}
    autoadjust     : boolean;                      {}
    menuhelp       : boolean;                      {}
    usezoom        : boolean;
    customscreen   : boolean;
    pubscreen      : boolean;
    pubscreenname  : boolean;
    pubscreenfallback : boolean;
    gadgetlist     : tlist;
    flags          : long;
    editscreen     : pscreen;
    screenprefs    : tscreenmodeprefs;
    helpwin        : twindownode;
    fontname       : string[46];
    idcmplist      : array [1..25] of boolean;
    sizesgads      : array [1..14] of pgadget;
    gadbord1       : pimage;
    gadbord2       : pimage;
    gadgetfont     : ttextattr;
    gadgetfontname : string[46];
    codewindow     : pwindow;
    codeglist      : pgadget;
    codegadgets    : array[1..28] of pgadget;
    winparams      : string;
    pdmn           : pdesignermenunode;
    pdmn2          : pdesignermenunode;
    codeselected   : long;
    menutitle      : string[66];
    tmenu          : pmenu;
    smenu          : pmenu;
    imenu          : pmenu;
    cmenu          : pmenu;
    gmenu          : pmenu;
    mmenu          : pmenu;
    wholefont      : ttextattr;
    wholefontname  : string[46];
    BevelWindow           : pWindow;
    BevelWindowglist      : pGadget;
    BevelWindowVisualInfo : Pointer;
    BevelWindowgads       : array [0..8] of pgadget;
    bevelselected         : long;
    inputglist            : pgadget;
    inputgadget           : pgadget;
    inputmodeb            : boolean;
    fontx,fonty           : word;
    magnifywindow         : pwindow;
    magnifywinglist       : pgadget;
    magnifywingads        : array[0..5] of pgadget;
    basexofbox  : word;
    baseyofbox  : word;
    widthofbox  : word;
    heightofbox : word;
    winoffx     : word;
    winoffy     : word;
    magnify     : word;
    magnifymode : word;
    magwidth    : word;
    magheight   : word;
    srcx        : word;
    srcy        : word;
    smallcopy   : pbitmap;
    largecopy   : pbitmap;
    oldmagnify  : word;
    magnifymenu : pmenu;
    mx,my       : integer;
    defpubname   : string[80];
    defpubgadget : pgadget;
    objectmenu   : pmenu;
   end;
  
  pbevelboxnode = ^tbevelboxnode;
  tbevelboxnode = record
    ln_succ  : pbevelboxnode;
    ln_pred  : pbevelboxnode;
    ln_type  : byte;
    ln_pri   : byte;
    ln_name  : pbyte;
    x        : word;
    y        : word;
    w        : word;
    h        : word;
    beveltype: word;
    title    : string[31];
   end;
  
  plibnode = ^tlibnode;
  tlibnode = record
    ln_succ      : plibnode;
    ln_pred      : plibnode;
    ln_type      : byte;
    ln_pri       : byte;
    ln_name      : pbyte;
    open         : boolean;
    opene        : boolean;
    version      : long;
    versione     : long;
    abortonfail  : boolean;
    abortonfaile : boolean;
   end;
   
  phelpnode = ^thelpnode;
  thelpnode = record
    ln_succ     : phelpnode;
    ln_pred     : phelpnode;
    ln_type     : byte;
    ln_pri      : byte;
    ln_name     : pbyte;
    title       : string[75];
   end;
  
  pbmhd = ^tbmhd;
  tbmhd = record
    w,h,x,y              : word;
    nplanes              : byte;
    masking              : byte;
    compressed           : byte;
    reserved             : byte;
    transparentcolour    : word;
    xaspect,yaspect      : word;
    pagewidth,pageheight : word;
   end;
  
  pbytearray = ^tbytearray;
  tbytearray = array [0..10000000] of byte;
  
  pshortintarray = ^tshortintarray;
  tshortintarray = array [0..10000000] of shortint;
  
  pwordarray2 = ^twordarray2;
  twordarray2 = array[0..1000] of word;
  
  timagenode = record
    ln_succ       : pimagenode;
    ln_pred       : pimagenode;
    ln_type       : byte;
    ln_pri        : byte;
    ln_name       : pbyte;
    pmen          : pmenu;
    colourmap     : pwordarray2;
    mapsize       : word;
    oldmap        : pwordarray2;
    pscr          : pscreen;
    botslide      : tgadget;
    botimage      : timage;
    botinfo       : tpropinfo;
    currentgadget : word;
    sideslide     : tgadget;
    sideimage     : timage;
    sideinfo      : tpropinfo;
    displaywindow : pwindow;
    winbitmap     : tbitmap;
    title         : string[66];
    sizeallocated : long;
    LeftEdge      : integer;
	TopEdge       : integer;
	Width         : integer;
	Height        : integer;
	Depth         : integer;
	ImageData     : pbytearray;
	PlanePick     : byte;
	PlaneOnOff    : byte;
	NextImage     : pImage;
    editwindow    : pwindow;
    editwindowglist : pgadget;
    editwindowgads  : array[0..26] of pgadget;
    editwindowvisualinfo : Pointer;
   end;
  
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
  
  pdesignerscreennode = ^tdesignerscreennode;
  tdesignerscreennode = record
    ln_succ    : pdesignerscreennode;
    ln_prev    : pdesignerscreennode;
    ln_type    : byte;
    ln_pri     : byte;
    ln_name    : pbyte;
    oneditscr  : boolean;
    editwindow : pwindow;
    editwindowvisualinfo : pbyte;
    editwindowglist      : pgadget;
    editwindowgads       : array[0..30] of pgadget;
    editwindowDepth      : word;
    labelid              : string;
    testscreen           : pscreen;
    fit                  : boolean;
    editscrnode          : pdesignerscreennode;
    
    left                 : word;
    top                  : word;
    width                : word;
    height               : word;
    depth                : word;
    overscan             : byte;  {text, standard, max , video}
    fonttype             : byte;
    behind               : boolean;
    quiet                : boolean;
    showtitle            : boolean;
    AutoScroll           : boolean;
    bitmap               : boolean;
    createbitmap         : boolean;
    Title                : string;
    loctitle             : boolean;
    idstr                : string[20];
    idnum                : long;
    screentype           : word;
    {
    pens                 : array[0..20] of word;
    }
    pubname              : String;
    dopubsig             : boolean;
    
    defpens              : boolean;
    fullpalette          : boolean;
    font                 : ttextattr;
    fontname             : string[50];
    colorarray           : pwordarray2;
    sizecolorarray       : long;
    
    penarray             : array[0..30] of word;
    penlistpos           : word;
    scrmenu              : pmenu;
    
    errorcode            : boolean;
    sharedpens           : boolean;
    draggable            : boolean;
    exclusive            : boolean;
    interleaved          : boolean;
    likeworkbench        : boolean;
    
   end;
  
  pmytag = ^tmytag;
  tmytag = record
    ln_succ    : pmytag;
    ln_pred    : pmytag;
    tagtype    : byte;
    ln_pri     : byte;
    ln_name    : pbyte;
    title      : string[66];
    value      : long;
    sizebuffer : long;
    data       : pointer;
    dataname   : string[66];
   end;
  
var
  gradientsliderbase    : plibrary;
  programdirstr         : string;
  upgradedir            : string;
  setamigaguidenum      : word;
  amigaguidescreen      : pscreen;
  amigaguidehandle      : pointer;
  amigaguidesig         : long;
  nag                   : tnewamigaguide;
  edittagswindow        : pwindow;
  filename              : string;
  filedir               : string;
  mainmicro             : long;
  mainseconds           : long;
  registerstring        : string;
  Win0_Gad30Labels      : array[0..3] of pbyte;
  printfile             : string;
  done                  : boolean;
  saved                 : boolean;
  procedureoptions      : array[1..50] of boolean;
  codeoptions           : array[1..20] of boolean;
  pfr                   : pfontrequester;
  minx,miny             : word;
  sgad                  : pgadgetnode;
  presetobjectlist      : tlist;
  maxx,maxy             : word;
  wasdemoversion        : boolean;
  mainappwindow         : pappwindow;
  defaultscreenmode     : tscreenmodeprefs;
  pla                   : plongarray;
  defaultscreenmodeprefs: tscreenmodeprefs;
  frontscreentitle      : string;
  errorstring           : string[100];
  errorstartseconds     : long;
  errorstartmicros      : long;
  cyclepos              : byte;
  lengthtext2           : integer;
  heighttext2           : integer;
  mainselected          : long;
  imagefilerequest      : pfilerequester;
  fontrequest           : pfilerequester;
  loadsaverequest       : pfilerequester;
  image1                : timage;
  image2                : timage;
  image3                : timage;
  image4                : timage;
  getfileimage1         : timage;
  getfileimage2         : timage;
  getfileimage3         : timage;
  getfileimage4         : timage;
  {
  optionsgadgetscoords  : array[1..20] of word;
  }
  updateeditwindow      : boolean;
  inputmode             : word;
  mainwindownode        : twindownode;
  libwindownode         : twindownode;
  edittagswindownode    : twindownode;
  localewindownode      : twindownode;
  defaulthelpwindownode : twindownode;
  mainwindowzoom        : array [1..4] of word;
  teditimagelist        : tlist;
  teditmenulist         : tlist;
  teditwindowlist       : tlist;
  box                   : array [1..4] of long;
  boxold                : array [1..4] of long;                 
  listvieweditlist      : tlist;
  listvieweditnode      : tnode;
  memused               : long;
  magnifywin_Gad0Labels : array[0..4] of pbyte;
  globalincludeextra    : string;
  tlocalelist            : tlist;
  libselected           : word;
  localeWindow           : pWindow;
  myscreen              : pscreen;
  ScreenVisualInfo      : pointer;
  MainWindow            : pwindow;
  MainWindowGlist       : pgadget;
  MainWindowGadgets     : array [1..15] of pgadget;
  abouteasy             : teasystruct; 
  aboutwin              : pwindow;
  abouttext             : string;
  abouttext2            : string;
  libwindowgadgets      : array [1..10] of pgadget;
  libwindow             : pwindow;
  libwindowglist        : pgadget;
  ttopaz80              : tttextattr;
  fontname              : string[13];
  pendtagitem           : ptagitem;
  tendtagitem           : ttagitem;
  MainLabels            : array [1..5] of pbyte;
  pwaitpointer          : pword;
  myprogramport         : pmsgport;        
  tliblist              : tlist;
  demopos               : word;
  keepgoing             : boolean;
  mxstrings             : array [1..21] of pbyte;
  placetextcycle1       : array [1..6]  of pbyte;
  placetextcycle2       : array [1..5]  of pbyte;
  aligncycle            : array [1..5]  of pbyte;
  pgacycle              : array [1..4]  of pbyte;
  pencycle              : array [1..10] of pbyte;
  spreadcycle           : array [1..3]  of pbyte;
  justcycle             : array [1..4]  of pbyte;
  radiofail             : array [1..2]  of pbyte;
  Bevel_RadioLabels     : array [0..6]  of pbyte;
  maincodewindow        : pwindow;
  maincodeglist         : pgadget;
  maincodegadgets       : array [1..18] of pgadget;
  maincodewindownode    : tnode;
  getstring             : string;
  basename              : string;
  version               : long;
  builtinlanguage       : string;
  prefswindownode       : tnode;
  locale37              : boolean;
  prefsglist            : pgadget;
  prefsgadgets          : array[0..21] of pgadget;
  prefswindow           : pwindow;
  compilerlist          : tlist;
  presentcompiler       : long;
  prefsvalues           : array[1..20] of boolean;
  deflangnum            : long;
  defaultcompileredit   : long;
  defcompname           : string[60];
  drawbitty             : word;
  imrun                 : boolean;
  messagedone           : boolean;
  upgradegad            : pgadget;
  teditscreenlist       : tlist;
  tagtypesarray         : array[0..15] of pbyte;

const
  
  Bevel_Help      = 0;
  Bevel_Update    = 1;
  Bevel_Move      = 2;
  Bevel_Size      = 3;
  Bevel_Delete    = 4;
  Bevel_Copy      = 5;
  Bevel_listview  = 6;
  Bevel_New       = 7;
  Bevel_Radio     = 8;

  Bevel_RadioMXTexts : array [0..5] of string[15]=
  (
  'N_ormal'#0,
  '_Recessed'#0,
  'Dou_ble'#0,
  'Su_nk'#0,
  'String (V39)'#0,
  'DropBox (V39)'#0
  );
  
  IEQUALIFIER_LSHIFT = 1;
  IEQUALIFIER_RSHIFT = 2;

  memerror = 'Not enough free memory for operation.';
  editscreentitle : string[30] = 'Designer Edit Window Screen'#0;
  
  introhelp           = 0;
  mainhelp            = 1;
  maincodehelp        = 2;
  libhelp             = 3;
  windowedithelp      = 4;
  windowcodehelp      = 5;
  windowsizehelp      = 6;
  windowidcmphelp     = 7;
  tagshelp            = 8;
  windowtextlisthelp  = 9;
  windowimagelisthelp = 10;
  bevelhelp           = 11;
  menuhelp            = 12;
  imagehelp           = 13;
  upgradehelp         = 14;
  buttonhelp          = 15;
  stringhelp          = 16;
  integerhelp         = 17;
  checkboxhelp        = 18;
  mxhelp              = 19;
  cyclehelp           = 20;
  sliderhelp          = 21;
  scrollerhelp        = 22;
  listviewhelp        = 23;
  palettehelp         = 24;
  texthelp            = 25;
  numberhelp          = 26;
  boolhelp            = 27;
  magnifywindowhelp   = 28;
  localehelp          = 29;
  prefshelp           = 30;
  screenhelp          = 31;
  objecthelp          = 32;
  sizeofhelp          = 33;
  

var  
  helpcontext           : array[0..sizeofhelp] of pbyte;

const
  
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
  
  tagtypeselect = 99;
  
  numoftagtypes=22;
  
  tagtypeborder = 33;
  
  TagTypeListGadListViewTexts : array [0..numoftagtypes] of string[16]=
  (
  'LONG'#0,
  'BOOLEAN'#0,
  'STRING'#0,
  'Array of BYTE'#0,
  'Array of WORD'#0,
  'Array of LONG'#0,
  'Array of STRPTR'#0,
  'List of Strings'#0,
  'User Structure'#0,
  'VisualInfo'#0,
  'DrawInfo'#0,
  'IntuiText'#0,
  'Image'#0,
  'Image Data'#0,
  'Left Coord'#0,
  'Top Coord'#0,
  'Width Coord'#0,
  'Height Coord'#0,
  'Gadget ID'#0,
  'Gadget Font'#0,
  'Screen'#0,
  'Object'#0,
  'User Type 2'#0
  );

  
  helptextpos : array[0..32] of string[14]=
  (
  'intro'#0,
  'mainwindow'#0,
  'maincode'#0,
  'lib'#0,
  'windowedit'#0,
  'windowcode'#0,
  'windowsize'#0,
  'windowidcmp'#0,
  'tags'#0,
  'textlist'#0,
  'imagelist'#0,   {10}
  'bevel'#0,
  'menu'#0,
  'image'#0,
  'upgrading'#0,
  'Button'#0,
  'String'#0,
  'Integer'#0,
  'CheckBox'#0,
  'MX'#0,
  'Cycle'#0,      {20}
  'Slider'#0,
  'Scroller'#0,
  'Listview'#0,
  'Palette'#0,
  'text'#0,
  'number'#0,
  'bool'#0,
  'magnify'#0,
  'locale'#0,
  'prefs'#0,     {30}
  'screen'#0,
  'object'#0
  );

  optgadgwidth  : byte = 82;
  optgadgheight : byte = 12;

  screenmodesavailable : array[1..26] of long=
  (
  
  LORES_KEY,
  HIRES_KEY,
  SUPER_KEY,
  LORESLACE_KEY,
  HIRESLACE_KEY,
  SUPERLACE_KEY,
  
  LORES_KEY,
  HIRES_KEY,
  SUPER_KEY,
  LORESLACE_KEY,
  HIRESLACE_KEY,
  SUPERLACE_KEY,
  
  LORES_KEY,
  HIRES_KEY,
  SUPER_KEY,
  LORESLACE_KEY,
  HIRESLACE_KEY,
  SUPERLACE_KEY,
  
  VGAEXTRALORES_KEY,
  VGALORES_KEY,
  VGAPRODUCT_KEY,
  VGAEXTRALORESLACE_KEY,
  VGALORESLACE_KEY,
  VGAPRODUCTLACE_KEY,
  
  A2024TENHERTZ_KEY,
  A2024FIFTEENHERTZ_KEY
  
  );
  
  monname : array[1..14] of string[17] =
  (
  'LORES',
  'HIRES',
  'SUPER',
  'LORESLACE',
  'HIRESLACE',
  'SUPERLACE',
  'VGAEXTRALORES',
  'VGALORES',
  'VGAPRODUCT',
  'VGAEXTRALORESLACE',
  'VGALORESLACE',
  'VGAPRODUCTLACE',
  'A2024TENHERTZ',
  'A2024FIFTEENHERTZ'
  );
  
  id_ilbm = $494c424d;
  id_body = $424f4459;
  id_bmhd = $424d4844;
  id_cmap = $434d4150;
  id_camg = $43414d47;
  id_pref = $50524546;
  id_scrm = $5343524d;
  
  mybool_kind = 227;
  myobject_kind = 198;
  
  mainwindownodetype     = 0;
  libwindownodetype      = 1;
  helpwindownodetype     = 2;
  designerwindownodetype = 3;
  imagenodetype          = 4;
  menunodetype           = 5;
  maincodewindownodetype = 6;
  prefswindownodetype    = 7;
  localewindownodetype   = 8;
  screennodetype         = 9;
  edittagswindownodetype     = 10;
  
  defaultidcmpvalues : array[1..25] of boolean=
    (
    false,false,false,false,true,true,false,false,false,
    false,false,false,false,true,false,false,false,false,
    false,false,false,false,false,false,false
    );
  
  crypt2 : string[40]=#103#56#93#235#56#6#77#88#99#10'Morning'#0#190#200'Ian OConnor'#0#33#'1993'#0#39#40;
  
  numofprefsoptions : byte = 19;
  
  Ian : string[11] = 'Ian OConnor';
  
  strings : array[1..207] of string[18]=
  (
  'Choose Screen'#0,
  'Windows'#0'Down'#0,
  'Menus'#0'ExitHelp'#0,
  '_Justification'#0,
  'About'#0'ReplaceMode'#0,
  '_Procedures'#0,
  '_Code'#0'_String'#0,
  '_Open'#0'Join'#0,
  '_Save'#0'Split'#0,
  '_Generate'#0'Items'#0,
  '_New'#0'_MaxChars'#0,
  '_Delete'#0'SubItems'#0,
  '_Edit...'#0'_About'#0,
  '_Help...'#0'TabCycle'#0,
  'The Designer'#0,
  '_OK'#0'BarLbl'#0,            {16}
  '_Cancel'#0,
  'O_pen'#0'Screens'#0,
  '_Abort On Fail'#0,
  '_Version'#0,
  'Help Window'#0,
  '_Libraries'#0,               {22}
  'Scr_een...'#0,
  'Texts'#0,
  'Boxes'#0,
  '_Tags...'#0'Spacing'#0,
  'Si_zes...'#0,
  '_IDCMP...'#0,
  'C_ode...'#0,
  'Help...'#0' Default'#0,      {30}
  'New'#0,
  'Edit...'#0,
  'Delete'#0,
  'Move'#0'Active'#0,
  'Help'#0'_Help...'#0,
  '_Font...'#0'Error'#0,        {36}
  'Texts'#0,
  'Max Width'#0,                {38}
  'Max Height'#0,
  'Min Width'#0,
  'Min Height'#0,
  'Left Edge'#0,
  'Top Edge'#0,
  '_Width'#0,
  '_Height'#0,                  {45}
  'MOUSEBUTTONS'#0,
  'MOUSEMOVE'#0'Del'#0,
  'DELTAMOVE'#0,
  'GADGETDOWN'#0,
  'GADGETUP'#0'Up'#0,
  'CLOSEWINDOW'#0,
  'MENUPICK'#0,
  'MENUVERIFY'#0,
  'MENUHELP'#0,
  'REQSET'#0'Menus'#0,           {55}
  'REQCLEAR'#0,
  'REQVERIFY'#0,
  'NEWSIZE'#0'Title'#0,
  'REFRESHWINDOW'#0,
  'SIZEVERIFY'#0,
  'ACTIVEWINDOW'#0,
  'INACTIVEWINDOW'#0,
  'VANILLAKEY'#0,
  'RAWKEY'#0,
  'NEWPREFS'#0,                 {65}
  'DISKINSERTED'#0,
  'DISKREMOVED'#0,
  'INTUITICKS'#0,
  'IDCMPUPDATE'#0,
  'CHANGEWINDOW'#0,             {70}
  'IDCMP Window'#0,
  'Dimensions'#0,
  'Test'#0'_Prefs'#0,
  'Cycle'#0,
  'Gadget'#0,
  '_Disabled'#0,                 {76}
  '_UnderScore'#0,
  '_Text'#0,
  '_Place'#0,                {79}
  'In'#0'StringCenter'#0,
  'Above'#0'_Use'#0,
  'Below'#0,
  'Left'#0'StringRight'#0,
  'Right'#0'StringLeft'#0,
  'Button Gadget'#0,       {85}
  'No List '#0,
  'ReadOnly'#0,
  'ShowSelected'#0,
  'ScrollWidth'#0,
  'Spacing'#0,                  {90}
  'ListView Gadget'#0,
  'Checked'#0,
  'Cycle Gadget'#0,
  'CheckBox Gadget'#0,
  'Edit...'#0,                  {95}
  '_Delete'#0,
  '_Clone'#0,
  '_Size'#0,
  '_Move'#0,
  'Left'#0,                     {100}
  'Right'#0,
  'Top'#0,
  'Bottom'#0,
  '_Align :'#0,
  'Image'#0'Arrows'#0,
  'Boolean'#0,
  'Play'#0,                     {107}
  'Mi_n Level'#0,
  'Ma_x Level'#0,
  'Immediate'#0,
  'RelVerify'#0,
  'Disabled'#0,
  'LORIENT_HORIZ'#0,
  'LORIENT_VERT'#0,
  'BOTH'#0,                     {115}
  'Free_dom'#0,
  '_Level'#0,
  'Visible'#0,
  'Total'#0,
  'Top'#0,
  'Scroller Gadget'#0,
  'Slider Gadget'#0,       {122}
  ''#0,
  'Images'#0,
  'Select Images'#0,
  'Designer'#0,
  'Choose...'#0,                {127}
  'Choose Image'#0,
  '_View...'#0,
  'Scale (V39)'#0,
  'Use V39 Options'#0,
  'FrontPen'#0,                 {132}
  'BackPen'#0'Clip'#0,
  'Scr Font'#0,
  '_Text (V39)'#0,
  'Place (V39)'#0,
  'Clip Gadget'#0,
  'JAM1'#0,
  'COMPLEMENT'#0,
  'JAM2'#0,
  'INVERSVID'#0,
  'Text'#0,                     {142}
  'DETAILPEN'#0,
  'BLOCKPEN'#0,
  'TEXTPEN'#0,
  'SHINEPEN'#0,
  'SHADOWPEN'#0,
  'FILLPEN'#0,
  'FILLTEXTPEN'#0,
  'BACKGROUNDPEN'#0,
  'HIGHLIGHTTEXTPEN'#0,         {151}
  'Choose Font'#0,
  '    '#0'_Update'#0,
  'Update'#0'_Test'#0,
  'Images'#0'None'#0,           {155}
  'Tags For Window'#0,
  'SizeGadget'#0,
  'SizeBRight'#0,
  'SizeBBottom'#0,
  'DragBar'#0,
  'DepthGadget'#0,
  'CloseGadget'#0,
  'ReportMouse'#0,
  'NoCareRefresh'#0,
  'Borderless'#0,
  'BackDrop'#0,
  'GimmeZeroZero'#0,
  'Activate'#0,
  'RMBTrap'#0'Display'#0,
  'SimpleRefresh'#0,
  'SmartRefresh'#0,
  'AutoAdjust'#0,
  'MenuHelp'#0'CheckIt'#0,
  'WindowTitle'#0,              {174}
  'ScreenTitle'#0,
  'WindowLabel'#0,
  'CustomScreen'#0,
  'PubScreen'#0,
  'PubScreenName'#0,
  'PubScreenFallBack'#0,
  'MouseQueue'#0,
  'RptQueue'#0'Graphic'#0,
  'Zoom'#0'Color Offset'#0,     {183}
  '_Undo'#0'Color'#0,
  '    _Depth'#0,
  'Choose Filename'#0,
  'High Label'#0,
  ' Edit  '#0'CommKey'#0,       {188}
  '_LabelID'#0'CopyText'#0,
  'String Gadget'#0,
  'Integer Gadget'#0,
  'Level Format'#0,             {192}
  'Level Place'#0,
  'Display Level'#0,
  'Max Level Len'#0,
  'Palette Gadget'#0,
  'Indicator Left'#0,           {197}
  'Indicator Top'#0,
  '_Indicator Size'#0,
  'Text Gadget'#0,
  'Number Gadget'#0,
  'MX Gadget'#0,             {202}
  'Create List'#0,
  'Boolean Gadget'#0,
  'Toggle'#0,
  'Max Num Len'#0,
  'Number Format'#0
  );
  
  crypt1        : string[41]=#12#34#52#98#134#123#69#1#45#235'Store'#0'Terminal'#0#45#27#28#29#65#45#123#253#204'TUFF'#0#40;
  
  {$ifndef DEMO}
  registerstore : string[41]='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'#0#0#0;
  {$else}
  registerstore : string[41]='CHECKBOX LISTVIEW SLIDER BOOLEAN BUTTO'#0#0#0;
  {$endif}
  safety:string[17] ='GHGHGHG';
  
  windowoptions : array[1..17] of string[10]=
  (
  'Button'#0,
  'String'#0,
  'Integer'#0,
  'CheckBox'#0,
  'MX'#0,
  'Cycle'#0,
  'Slider'#0,
  'Scroller'#0,
  'ListView'#0,
  'Palette'#0,
  'Text'#0,
  'Number'#0,
  'Bevel'#0,
  'None'#0,
  'S_pread :'#0,
  'X'#0,
  'Y'#0
  );
  
  librarynames : array[0..25] of string[27]=
  (
  ' arp.library'#0,
  ' asl.library'#0,
  ' commodities.library'#0,
  ' diskfont.library'#0,
  ' expansion.library'#0,
  ' gadtools.library'#0,
  ' graphics.library'#0,
  ' icon.library'#0,
  ' iffparse.library'#0,
  ' intuition.library'#0,
  ' keymap.library'#0,
  ' layers.library'#0,
  ' mathffp.library'#0,
  ' mathieeedoubbas.library'#0,
  ' mathieeedoubtrans.library'#0,
  ' mathieeesingbas.library'#0,
  ' mathieeesingtrans.library'#0,
  ' rexxsyslib.library'#0,
  ' reqtools.library'#0,
  ' translator.library'#0,
  ' utility.library'#0,
  ' workbench.library'#0,
  ' locale.library'#0,
  'end'
  );
  
  libraryversions : array[0..26] of byte=
  (39,37,37,36,0,37,37,37,37,37,37,37,0,0,0,0,0,36,0,0,37,37,38);
  
  defaultlibopen : array[0..25] of boolean=
    (
    false,false,false,true,false,true,true,false,false,true,
    false,false,false,false,false,false,false,false,false,
    false,false,false,true,false,false,false
    );

  waitpointer : array[1..36] of word=
  (
  $0000,$0000,$0400,$07c0,
  $0000,$07c0,$0100,$0380,
  $0000,$07e0,$07c0,$1ff8,
  $1ff0,$3fec,$3ff8,$7fde,
  $3ff8,$7fbe,$7ffc,$ff7f,
  $7ffc,$ffff,$7ffc,$ffff,
  $3ff8,$7ffe,$3ff8,$7ffe,
  $1ff0,$3ffc,$07c0,$1ff8,
  $0000,$07e0,$0000,$0000
  );
  
  defaultprefs : array [1..20] of boolean =
  (
  true,true,true,true,true,
  true,true,true,false,false,
  true,false,true,true,true,
  false,true,true,false,false
  );
  
  imagedata1 : array [1..144] of word=
  (
  0,0,0,0,4,0,0,0,0,0,3,0,0,0,0,0,0,49152,0,0,0,0,0,49152,0,
  0,0,0,0,49152,0,0,0,0,0,49152,
  0,0,0,0,0,49152,0,0,0,0,0,49152,0,0,0,0,0,49152,0,0,0,0,0,
  49152,0,0,0,0,3,0,2047,65535,65535,65535,65532,0,
  4095,65535,65535,65535,65528,0,12288,0,0,0,0,0,49152,0,0,
  0,0,0,49152,0,0,0,0,0,49152,0,0,0,0,0,49152,0,0,0,0,0,
  49152,0,0,0,0,0,49152,0,0,0,0,0,49152,0,0,0,0,0,49152,0,
  0,0,0,0,12288,0,0,0,0,0,2048,0,0,0,0,0
  );
  imagedata2 : array [1..144] of word=
  (
  4095,65535,65535,65535,65528,0,16383,65535,65535,65535,65532,0,65535,65535,65535,65535,65535,
  0,65535,65535,65535,65535,65535,0,65535,65535,65535,65535,65535,0,65535,65535,65535,65535,65535,0,
  65535,65535,65535,65535,65535,0,65535,65535,65535,65535,65535,0,65535,65535,65535,65535,65535,0,
  65535,65535,65535,65535,65535,0,16383,65535,65535,65535,65532,0,2048,0,0,0,0,0,
  0,0,0,0,4,0,4095,65535,65535,65535,65535,0,16383,65535,65535,65535,65535,49152,16383,65535,65535,
  65535,65535,49152,16383,65535,65535,65535,65535,49152,16383,65535,65535,65535,65535,49152,
  16383,65535,65535,65535,65535,49152,16383,65535,65535,65535,65535,49152,16383,65535,65535,65535,
  65535,49152,16383,65535,65535,65535,65535,49152,4095,65535,65535,65535,65535,0,2047,65535,65535,65535,65532,0
  );  
  imagedata3 : array [1..72] of word=
  (
   4095,65535,65535,65535,65534,0,12288,0,0,0,1,32768,16384,0,0,0,0,16384,16384,
  0,0,0,0,16384,16384,0,0,0,0,16384,16384,0,0,0,0,16384,16384,0,0,0,0,16384,
  16384,0,0,0,0,16384,16384,0,0,0,0,16384,16384,0,0,0,0,16384,12288,0,0,0,1,
  32768,4095,65535,65535,65535,65534,0
  );
  imagedata4 : array [1..72] of word=
  (
  8191,65535,65535,65535,65532,0,32767,65535,65535,65535,65535,0,65535,65535,
  65535,65535,65535,32768,65535,65535,65535,65535,65535,32768,65535,65535,65535,
  65535,65535,32768,65535,65535,65535,65535,65535,32768,65535,65535,65535,65535,
  65535,32768,65535,65535,65535,65535,65535,32768,65535,65535,65535,65535,65535,
  32768,65535,65535,65535,65535,65535,32768,32767,65535,65535,65535,65535,0,
  8191,65535,65535,65535,65532,0
  );

  getfiledata1 : array[1..56] of word=
  (
  0,4096,0,12288,60,12288,66,12288,3969,12288,4033,12288,3135,12288,3073,12288,
  3073,12288,3073,12288,4095,12288,0,12288,0,12288,32767,61440,65535,57344,49152,0,49152,0,49152,
  0,49152,0,49152,0,49152,0,49152,0,49152,0,49152,0,49152,0,49152,0,49152,0,32768
  );
  
  getfiledata2 : array[1..56] of word=
  (
  65535,57344,65535,49152,65535,49152,65535,49152,65535,49152,65535,49152,
  65535,49152,65535,49152,65535,49152,65535,49152,65535,49152,65535,49152,
  65535,49152,32768,0,0,4096,16383,61440,16323,61440,16317,
  61440,12414,61440,12350,61440,13248,61440,13310,61440,13310,61440,13310,
  61440,12288,61440,16383,61440,16383,61440,32767,61440
  );
 
  getfiledata3 : array[1..28] of word=
  (
  65535,61440,49152,12288,49212,12288,49218,12288,53121,12288,53185,12288,52287,12288,
  52225,12288,52225,12288,52225,12288,53247,12288,49152,12288,49152,12288,65535,61440
  );
  
  getfiledata4 : array [1..28] of word=
  (
  65535,61440,65535,61440,65475,61440,65469,61440,61566,61440,61502,61440,62400,61440,
  62462,61440,62462,61440,62462,61440,61440,61440,65535,61440,65535,61440,65535,61440
  );

{$I /version.include}

function sfp(p : pbyte):string;
procedure fixmytagdatapointers(pmt:pmytag);

implementation

procedure fixmytagdatapointers(pmt:pmytag);
var
  pla : plongarray;
  pba : pbytearray;
  loop,loop2 : long;
  fs,os : pointer;
  pl : plist;
  pn : pnode;
  prevpit,pit : pintuitext;
begin
  if pmt<>nil then
    if pmt^.sizebuffer>0 then
      begin
        case pmt^.tagtype of
          tagtypearraystring :
            begin
              pla:=plongarray(pmt^.data);
              os:=pointer(pla^[0]);
              loop:=0;
              while(pla^[loop]<>0) do
                inc(loop);
              fs:=pointer(@pla^[loop+1]);
              loop:=0;
              while(pla^[loop]<>0) do
                begin
                  pla^[loop]:=pla^[loop]-long(os)+long(fs);
                  inc(loop);
                end;
            end;
          tagtypestringlist :
            begin
              pl:=plist(pmt^.data);
              newlist(pl);
              pba:=pbytearray(pmt^.data);
              loop:=sizeof(tlist);
              while (loop<pmt^.sizebuffer) do
                begin
                  pn:=pnode(@pba^[loop]);
                  addtail(pl,pn);
                  pn^.ln_name:=@pba^[loop+sizeof(tnode)];
                  inc(loop,sizeof(tnode));
                  while(pba^[loop]<>0) do
                    inc(loop);
                  inc(loop);
                  loop:=((loop+1) div 2)*2;
                end;
            end;
          tagtypeintuitext :
            begin
              prevpit:=nil;
              pba:=pbytearray(pmt^.data);
              loop:=0;
              while (loop<pmt^.sizebuffer) do
                begin
                  pit:=pintuitext(@pba^[loop]);
                  if prevpit<>nil then
                    prevpit^.nexttext:=pit;
                  prevpit:=pit;
                  pit^.itext:=@pba^[loop+sizeof(tintuitext)];
                  pit^.itextfont:=nil;
                  pit^.nexttext:=nil;
                  inc(loop,sizeof(tintuitext));
                  while(pba^[loop]<>0) do
                    inc(loop);
                  inc(loop);
                  loop:=((loop+1) div 2)*2;
                end;
            end;

         end;
      end;
end;


function sfp(p : pbyte):string;
var
  temp : string;
begin
  temp:='';
  if p<>nil then
    ctopas(p^,temp);
  sfp:=temp;
end;

begin
  locale37:=false;
  basename:='base'#0;
  version:=0;
  getstring:='GetString'#0;
  builtinlanguage:='english'#0;
  globalincludeextra:=#0;
  imrun:=true;
  for minx:=1 to 20 do
    codeoptions[minx]:=false;
  amigaguidehandle:=nil;
  amigaguidesig:=0;
  for minx:=0 to sizeofhelp-1 do
    helpcontext[minx]:=@helptextpos[minx,1];
  helpcontext[sizeofhelp]:=nil;
  upgradedir:=''#0;
  newlist(@teditscreenlist);
  newlist(@presetobjectlist);
end.