@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "gadtoolsbox/prefs.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

CONST GTBCONFIGVERSION=0,
      MAXUSERNAME=$40,
      MAXICONPATH=$80,
      ID_GTCO=$4754434F

@{fg shine}(----)@{fg text} OBJECT gadtoolsconfig
@{fg shine}(   0)@{fg text}   configflags0:LONG
@{fg shine}(   4)@{fg text}   configflags1:LONG
@{fg shine}(   8)@{fg text}   crunchbuffer:INT
@{fg shine}(  10)@{fg text}   crunchtype:INT
@{fg shine}(  12)@{fg text}   username:substructure
@{fg shine}(  76)@{fg text}   iconpath:substructure
@{fg shine}( 204)@{fg text}   reserved:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=220 */

CONST GC0F_COORDINATES=1,
      GC0F_WRITEICON=2,
      GC0F_GZZADJUST=4,
      GC0F_CRUNCH=8,
      GC0F_CLOSEWBENCH=16,
      GC0F_PASSWORD=$20,
      GC0F_OVERWRITE=$40,
      GC0F_ASLFREQ=$80,
      GC0F_FONTADAPT=$100,
      GC0F_USEPUBSCREEN=$200,
      GTBLIBGENVERSION=0,
      MAXLIBNAME=$20,
      MAXBASENAME=$20,
      ID_LIBG=$4C494247

@{fg shine}(----)@{fg text} OBJECT librarygen
@{fg shine}(   0)@{fg text}   libraryname:substructure
@{fg shine}(  32)@{fg text}   librarybase:substructure
@{fg shine}(  64)@{fg text}   flags:INT
@{fg shine}(  66)@{fg text}   minversion:INT
@{fg shine}(  68)@{fg text}   reserved:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=84 */

CONST LGF_GENERATE=1,
      LGF_MODULE=2,
      LGF_FAILREQ=4,
      LGF_DISKLIB=8,
      LGF_INTERNAL=16,
      GTBGENCVERSION=0,
      ID_GENC=$47454E43

@{fg shine}(----)@{fg text} OBJECT genc
@{fg shine}(   0)@{fg text}   gtconfig:substructure
@{fg shine}( 220)@{fg text}   gencflags0:LONG
@{fg shine}( 224)@{fg text}   gencflags1:LONG
@{fg shine}( 228)@{fg text}   reserved:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=244 */

CONST CS0F_STATIC=1,
      CS0F_GENOPENFONT=2,
      CS0F_SYSFONT=4,
      CS0F_PRAGMAS=8,
      CS0F_AZTEC=16,
      CS0F_GENHANDLER=$20,
      CS0F_TEMPLATES=$40,
      GTBGENASMVERSION=0,
      ID_GENA=$47454E41

@{fg shine}(----)@{fg text} OBJECT genasm
@{fg shine}(   0)@{fg text}   gtconfig:substructure
@{fg shine}( 220)@{fg text}   genasmflags0:LONG
@{fg shine}( 224)@{fg text}   genasmflags1:LONG
@{fg shine}( 228)@{fg text}   reserved:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=244 */

CONST AS0F_STATIC=1,
      AS0F_RAW=2,
      AS0F_GENOPENFONT=4,
      AS0F_SYSFONT=8,
      AS0F_AMIGALIB=16
@endnode
