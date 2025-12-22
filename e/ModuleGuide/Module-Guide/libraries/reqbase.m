@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/reqbase.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

CONST REQVERSION=2,
      PAIRSSIZE=20

@{fg shine}(----)@{fg text} OBJECT gadgetblock
@{fg shine}(   0)@{fg text}   gadget:substructure
@{fg shine}(  44)@{fg text}   border:substructure
@{fg shine}(  60)@{fg text}   pairs:substructure
@{fg shine}(  80)@{fg text}   text:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=100 */

@{fg shine}(----)@{fg text} OBJECT stringblock
@{fg shine}(   0)@{fg text}   gadget:substructure
@{fg shine}(  44)@{fg text}   info:substructure
@{fg shine}(  80)@{fg text}   border:substructure
@{fg shine}(  96)@{fg text}   pairs:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=116 */

@{fg shine}(----)@{fg text} OBJECT propblock
@{fg shine}(   0)@{fg text}   gadget:substructure
@{fg shine}(  44)@{fg text}   info:substructure
@{fg shine}(  66)@{fg text}   image:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=86 */

@{fg shine}(----)@{fg text} OBJECT sliderblock
@{fg shine}(   0)@{fg text}   arrowuplt:substructure
@{fg shine}(  44)@{fg text}   imageuplt:substructure
@{fg shine}(  64)@{fg text}   arrowdnrt:substructure
@{fg shine}( 108)@{fg text}   imagednrt:substructure
@{fg shine}( 128)@{fg text}   prop:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=214 */

@{fg shine}(----)@{fg text} OBJECT twoimageblock
@{fg shine}(   0)@{fg text}   gadget:substructure
@{fg shine}(  44)@{fg text}   image1:substructure
@{fg shine}(  64)@{fg text}   image2:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=84 */

CONST ATTITUDEB=16,
      HORIZSLIDER=0,
      VERTSLIDER=$10000

@{fg shine}(----)@{fg text} OBJECT trstructure
@{fg shine}(   0)@{fg text}   text:LONG
@{fg shine}(   4)@{fg text}   controls:LONG
@{fg shine}(   8)@{fg text}   window:LONG
@{fg shine}(  12)@{fg text}   middletext:LONG
@{fg shine}(  16)@{fg text}   positivetext:LONG
@{fg shine}(  20)@{fg text}   negativetext:LONG
@{fg shine}(  24)@{fg text}   title:LONG
@{fg shine}(  28)@{fg text}   keymask:INT
@{fg shine}(  30)@{fg text}   textcolor:INT
@{fg shine}(  32)@{fg text}   detailcolor:INT
@{fg shine}(  34)@{fg text}   blockcolor:INT
@{fg shine}(  36)@{fg text}   versionnumber:INT
@{fg shine}(  38)@{fg text}   timeout:INT
@{fg shine}(  40)@{fg text}   abortmask:LONG
@{fg shine}(  44)@{fg text}   rfu1:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=46 */

CONST GLNODEFAULTB=0,
      GLNODEFAULTM=1

@{fg shine}(----)@{fg text} OBJECT getlongstruct
@{fg shine}(   0)@{fg text}   titlebar:LONG
@{fg shine}(   4)@{fg text}   defaultval:LONG
@{fg shine}(   8)@{fg text}   minlimit:LONG
@{fg shine}(  12)@{fg text}   maxlimit:LONG
@{fg shine}(  16)@{fg text}   result:LONG
@{fg shine}(  20)@{fg text}   window:LONG
@{fg shine}(  24)@{fg text}   versionnumber:INT
@{fg shine}(  26)@{fg text}   flags:LONG
@{fg shine}(  30)@{fg text}   rfu2:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

@{fg shine}(----)@{fg text} OBJECT getstringstruct
@{fg shine}(   0)@{fg text}   titlebar:LONG
@{fg shine}(   4)@{fg text}   stringbuffer:LONG
@{fg shine}(   8)@{fg text}   window:LONG
@{fg shine}(  12)@{fg text}   stringsize:INT
@{fg shine}(  14)@{fg text}   visiblesize:INT
@{fg shine}(  16)@{fg text}   versionnumber:INT
@{fg shine}(  18)@{fg text}   flags:LONG
@{fg shine}(  22)@{fg text}   rfu1:LONG
@{fg shine}(  26)@{fg text}   rfu2:LONG
@{fg shine}(  30)@{fg text}   rfu3:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

@{fg shine}(----)@{fg text} OBJECT extendedcolorrequesterstruct
@{fg shine}(   0)@{fg text}   defcolor:LONG
@{fg shine}(   4)@{fg text}   window:LONG
@{fg shine}(   8)@{fg text}   rfu1:LONG
@{fg shine}(  12)@{fg text}   rfu2:LONG
@{fg shine}(  16)@{fg text}   rfu3:LONG
@{fg shine}(  20)@{fg text}   rfu4:LONG
@{fg shine}(  24)@{fg text}   rfu5:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

CONST DSIZE=$82,
      FCHARS=30,
      WILDLENGTH=30,
      FRQSHOWINFOB=0,
      FRQEXTSELECTB=1,
      FRQCACHINGB=2,
      FRQGETFONTSB=3,
      FRQINFOGADGETB=4,
      FRQHIDEWILDSB=5,
      FRQABSOLUTEXYB=6,
      FRQCACHEPURGEB=7,
      FRQNOHALFCACHEB=8,
      FRQNOSORTB=9,
      FRQNODRAGB=10,
      FRQSAVINGB=11,
      FRQLOADINGB=12,
      FRQDIRONLYB=13,
      FRQSHOWINFOM=1,
      FRQEXTSELECTM=2,
      FRQCACHINGM=4,
      FRQGETFONTSM=8,
      FRQINFOGADGETM=16,
      FRQHIDEWILDSM=$20,
      FRQABSOLUTEXYM=$40,
      FRQCACHEPURGEM=$80,
      FRQNOHALFCACHEM=$100,
      FRQNOSORTM=$200,
      FRQNODRAGM=$400,
      FRQSAVINGM=$800,
      FRQLOADINGM=$1000,
      FRQDIRONLYM=$2000

@{fg shine}(----)@{fg text} OBJECT esstructure
@{fg shine}(   0)@{fg text}   nextfile:LONG
@{fg shine}(   4)@{fg text}   namelength:INT
@{fg shine}(   6)@{fg text}   pad:INT
@{fg shine}(   8)@{fg text}   node:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT reqfilerequester
@{fg shine}(   0)@{fg text}   versionnumber:INT
@{fg shine}(   2)@{fg text}   title:LONG
@{fg shine}(   6)@{fg text}   dir:LONG
@{fg shine}(  10)@{fg text}   file:LONG
@{fg shine}(  14)@{fg text}   pathname:LONG
@{fg shine}(  18)@{fg text}   window:LONG
@{fg shine}(  22)@{fg text}   maxextendedselect:INT
@{fg shine}(  24)@{fg text}   numlines:INT
@{fg shine}(  26)@{fg text}   numcolumns:INT
@{fg shine}(  28)@{fg text}   devcolumns:INT
@{fg shine}(  30)@{fg text}   flags:LONG
@{fg shine}(  34)@{fg text}   dirnamescolor:INT
@{fg shine}(  36)@{fg text}   filenamescolor:INT
@{fg shine}(  38)@{fg text}   devicenamescolor:INT
@{fg shine}(  40)@{fg text}   fontnamescolor:INT
@{fg shine}(  42)@{fg text}   fontsizescolor:INT
@{fg shine}(  44)@{fg text}   detailcolor:INT
@{fg shine}(  46)@{fg text}   blockcolor:INT
@{fg shine}(  48)@{fg text}   gadgettextcolor:INT
@{fg shine}(  50)@{fg text}   textmessagecolor:INT
@{fg shine}(  52)@{fg text}   stringnamecolor:INT
@{fg shine}(  54)@{fg text}   stringgadgetcolor:INT
@{fg shine}(  56)@{fg text}   boxbordercolor:INT
@{fg shine}(  58)@{fg text}   gadgetboxcolor:INT
@{fg shine}(  60)@{fg text}   rfu_stuff:substructure
@{fg shine}(  96)@{fg text}   dirdatestamp:substructure
@{fg shine}( 108)@{fg text}   windowleftedge:INT
@{fg shine}( 110)@{fg text}   windowtopedge:INT
@{fg shine}( 112)@{fg text}   fontysize:INT
@{fg shine}( 114)@{fg text}   fontstyle:INT
@{fg shine}( 116)@{fg text}   extendedselect:LONG
@{fg shine}( 120)@{fg text}   hide:substructure
@{fg shine}( 152)@{fg text}   show:substructure
@{fg shine}( 184)@{fg text}   filebufferpos:INT
@{fg shine}( 186)@{fg text}   filedisppos:INT
@{fg shine}( 188)@{fg text}   dirbufferpos:INT
@{fg shine}( 190)@{fg text}   dirdisppos:INT
@{fg shine}( 192)@{fg text}   hidebufferpos:INT
@{fg shine}( 194)@{fg text}   hidedisppos:INT
@{fg shine}( 196)@{fg text}   showbufferpos:INT
@{fg shine}( 198)@{fg text}   showdisppos:INT
@{fg shine}( 200)@{fg text}   memory:LONG
@{fg shine}( 204)@{fg text}   memory2:LONG
@{fg shine}( 208)@{fg text}   lock:LONG
@{fg shine}( 212)@{fg text}   privatedirbuffer:substructure
@{fg shine}( 344)@{fg text}   fileinfoblock:LONG
@{fg shine}( 348)@{fg text}   numentries:INT
@{fg shine}( 350)@{fg text}   numhiddenentries:INT
@{fg shine}( 352)@{fg text}   filestartnumber:INT
@{fg shine}( 354)@{fg text}   devicestartnumber:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=356 */

@{fg shine}(----)@{fg text} OBJECT reqscrollstruct
@{fg shine}(   0)@{fg text}   topentrynumber:LONG
@{fg shine}(   4)@{fg text}   numentries:LONG
@{fg shine}(   8)@{fg text}   linespacing:INT
@{fg shine}(  10)@{fg text}   numlines:LONG
@{fg shine}(  14)@{fg text}   propgadget:LONG
@{fg shine}(  18)@{fg text}   redrawall:LONG
@{fg shine}(  22)@{fg text}   readmore:LONG
@{fg shine}(  26)@{fg text}   scrollanddraw:LONG
@{fg shine}(  30)@{fg text}   versionnumber:INT
@{fg shine}(  32)@{fg text}   rfu1:LONG
@{fg shine}(  36)@{fg text}   rfu2:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

@{fg shine}(----)@{fg text} OBJECT arrows
@{fg shine}(   0)@{fg text}   arrowup:substructure
@{fg shine}(  20)@{fg text}   arrowdown:substructure
@{fg shine}(  40)@{fg text}   arrowleft:substructure
@{fg shine}(  58)@{fg text}   arrowright:substructure
@{fg shine}(  76)@{fg text}   r:substructure
@{fg shine}(  96)@{fg text}   g:substructure
@{fg shine}( 116)@{fg text}   b:substructure
@{fg shine}( 136)@{fg text}   h:substructure
@{fg shine}( 156)@{fg text}   s:substructure
@{fg shine}( 176)@{fg text}   v:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=196 */

@{fg shine}(----)@{fg text} OBJECT reqlib
@{fg shine}(   0)@{fg text}   lib:substructure
@{fg shine}(  34)@{fg text}   syslib:LONG
@{fg shine}(  38)@{fg text}   doslib:LONG
@{fg shine}(  42)@{fg text}   intuilib:LONG
@{fg shine}(  46)@{fg text}   gfxlib:LONG
@{fg shine}(  50)@{fg text}   seglist:LONG
@{fg shine}(  54)@{fg text}   images:LONG
@{fg shine}(  58)@{fg text}   flags:CHAR
@{fg shine}(  59)@{fg text}   pad:CHAR
@{fg shine}(  60)@{fg text}   consoledev:LONG
@{fg shine}(  64)@{fg text}   consolehandle:LONG
@{fg shine}(  68)@{fg text}   rexxsysbase:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=NONE !!! */
@endnode
