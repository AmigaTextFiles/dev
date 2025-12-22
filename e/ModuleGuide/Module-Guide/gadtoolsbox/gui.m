@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "gadtoolsbox/gui.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT extnewgadget
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   prev:LONG
@{fg shine}(   8)@{fg text}   tags:LONG
@{fg shine}(  12)@{fg text}   reserved0:substructure
@{fg shine}(  16)@{fg text}   newgadget:substructure
@{fg shine}(  46)@{fg text}   gadgetlabel:substructure
@{fg shine}(  80)@{fg text}   gadgettext:substructure
@{fg shine}( 160)@{fg text}   flags:LONG
@{fg shine}( 164)@{fg text}   kind:INT
@{fg shine}( 166)@{fg text}   reserved1:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=304 */

@{fg shine}(----)@{fg text} OBJECT extgadgetlist
@{fg shine}(   0)@{fg text}   first:LONG
@{fg shine}(   4)@{fg text}   endmark:LONG
@{fg shine}(   8)@{fg text}   last:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT extnewmenu
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   prev:LONG
@{fg shine}(   8)@{fg text}   reserved0:substructure
@{fg shine}(  14)@{fg text}   newmenu:substructure
@{fg shine}(  34)@{fg text}   menutitle:substructure
@{fg shine}( 114)@{fg text}   menulabel:substructure
@{fg shine}( 148)@{fg text}   reserved1:substructure
@{fg shine}( 152)@{fg text}   items:LONG
@{fg shine}( 156)@{fg text}   reserved2:substructure
@{fg shine}( 158)@{fg text}   commkey:substructure
@{fg shine}( 160)@{fg text}   reserved3:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=162 */

@{fg shine}(----)@{fg text} OBJECT extmenulist
@{fg shine}(   0)@{fg text}   first:LONG
@{fg shine}(   4)@{fg text}   endmark:LONG
@{fg shine}(   8)@{fg text}   last:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT bevelbox
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   prev:LONG
@{fg shine}(   8)@{fg text}   reserved0:substructure
@{fg shine}(  12)@{fg text}   left:INT
@{fg shine}(  14)@{fg text}   top:INT
@{fg shine}(  16)@{fg text}   width:INT
@{fg shine}(  18)@{fg text}   height:INT
@{fg shine}(  20)@{fg text}   reserved1:substructure
@{fg shine}(  52)@{fg text}   flags:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=54 */

@{fg shine}(----)@{fg text} OBJECT bevellist
@{fg shine}(   0)@{fg text}   first:LONG
@{fg shine}(   4)@{fg text}   endmark:LONG
@{fg shine}(   8)@{fg text}   last:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT projectwindow
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   prev:LONG
@{fg shine}(   8)@{fg text}   reserved0:substructure
@{fg shine}(  14)@{fg text}   name:substructure
@{fg shine}(  48)@{fg text}   countidfrom:INT
@{fg shine}(  50)@{fg text}   tags:LONG
@{fg shine}(  54)@{fg text}   leftborder:INT
@{fg shine}(  56)@{fg text}   topborder:INT
@{fg shine}(  58)@{fg text}   windowtitle:substructure
@{fg shine}( 138)@{fg text}   screentitle:substructure
@{fg shine}( 218)@{fg text}   reserved2:substructure
@{fg shine}( 410)@{fg text}   idcmp:LONG
@{fg shine}( 414)@{fg text}   windowflags:LONG
@{fg shine}( 418)@{fg text}   windowtext:LONG
@{fg shine}( 422)@{fg text}   gadgets:substructure
@{fg shine}( 434)@{fg text}   menus:substructure
@{fg shine}( 446)@{fg text}   boxes:substructure
@{fg shine}( 458)@{fg text}   tagflags:LONG
@{fg shine}( 462)@{fg text}   innerwidth:INT
@{fg shine}( 464)@{fg text}   innerheight:INT
@{fg shine}( 466)@{fg text}   showtitle:INT
@{fg shine}( 468)@{fg text}   reserved3:substructure
@{fg shine}( 474)@{fg text}   mousequeue:INT
@{fg shine}( 476)@{fg text}   rptqueue:INT
@{fg shine}( 478)@{fg text}   flags:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=480 */

@{fg shine}(----)@{fg text} OBJECT windowlist
@{fg shine}(   0)@{fg text}   first:LONG
@{fg shine}(   4)@{fg text}   endmark:LONG
@{fg shine}(   8)@{fg text}   last:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST RG_TAGBASE=$80000200,
      RG_GUI=$80000201,
      RG_CONFIG=$80000202,
      RG_CCONFIG=$80000203,
      RG_ASMCONFIG=$80000204,
      RG_LIBGEN=$80000205,
      RG_WINDOWLIST=$80000206,
      RG_VALID=$80000207,
      RG_PASSWORDENTRY=$80000208,
      VLF_GUI=1,
      VLF_CONFIG=2,
      VLF_CCONFIG=4,
      VLF_ASMCONFIG=8,
      VLF_LIBGEN=16,
      VLF_WINDOWLIST=$20,
      ERROR_NOMEM=1,
      ERROR_OPEN=2,
      ERROR_READ=3,
      ERROR_WRITE=4,
      ERROR_PARSE=5,
      ERROR_PACKER=6,
      ERROR_PPLIB=7,
      ERROR_NOTGUIFILE=8
@endnode
