@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/midi.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

CONST MIDIVERSION=7,
      RIM_MAXCOUNT=3

@{fg shine}(----)@{fg text} OBJECT rimatch
@{fg shine}(   0)@{fg text}   flags:CHAR
@{fg shine}(   1)@{fg text}   match:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

CONST RIMF_COUNTBITS=3,
      RIMF_EXTID=$40,
      RIMF_EXCLUDE=$80

@{fg shine}(----)@{fg text} OBJECT mrouteinfo
@{fg shine}(   0)@{fg text}   msgflags:INT
@{fg shine}(   2)@{fg text}   chanflags:INT
@{fg shine}(   4)@{fg text}   chanoffset:CHAR
@{fg shine}(   5)@{fg text}   noteoffset:CHAR
@{fg shine}(   6)@{fg text}   sysexmatch:substructure
@{fg shine}(  10)@{fg text}   ctrlmatch:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=14 */

CONST MMF_CHAN=$FF,
      MMF_NOTEOFF=1,
      MMF_NOTEON=2,
      MMF_POLYPRESS=4,
      MMF_CTRL=8,
      MMF_PROG=16,
      MMF_CHANPRESS=$20,
      MMF_PITCHBEND=$40,
      MMF_MODE=$80,
      MMF_SYSCOM=$100,
      MMF_SYSRT=$200,
      MMF_SYSEX=$400,
      MMF_ALL=$7FF

@{fg shine}(----)@{fg text} OBJECT mrouteptr
@{fg shine}(   0)@{fg text}   mln:substructure
@{fg shine}(   8)@{fg text}   route:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT mroute
@{fg shine}(   0)@{fg text}   source:LONG
@{fg shine}(   4)@{fg text}   dest:LONG
@{fg shine}(   8)@{fg text}   srouteptr:substructure
@{fg shine}(  20)@{fg text}   drouteptr:substructure
@{fg shine}(  32)@{fg text}   routeinfo:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=46 */

@{fg shine}(----)@{fg text} OBJECT msource
@{fg shine}(   0)@{fg text}   ln:substructure
@{fg shine}(  14)@{fg text}   image:LONG
@{fg shine}(  18)@{fg text}   rplist:substructure
@{fg shine}(  30)@{fg text}   userdata:LONG
@{fg shine}(  34)@{fg text}   routemsgflags:INT
@{fg shine}(  36)@{fg text}   routechanflags:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=38 */

CONST NT_MSOURCE=$20,
      NT_RESMSOURCE=$21

@{fg shine}(----)@{fg text} OBJECT mdest
@{fg shine}(   0)@{fg text}   ln:substructure
@{fg shine}(  14)@{fg text}   image:LONG
@{fg shine}(  18)@{fg text}   rplist:substructure
@{fg shine}(  30)@{fg text}   destport:LONG
@{fg shine}(  34)@{fg text}   userdata:LONG
@{fg shine}(  38)@{fg text}   defaultrouteinfo:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

CONST NT_MDEST=$22,
      NT_RESMDEST=$23

@{fg shine}(----)@{fg text} OBJECT midipacket
@{fg shine}(   0)@{fg text}   mn:substructure
@{fg shine}(  20)@{fg text}   type:INT
@{fg shine}(  22)@{fg text}   length:INT
@{fg shine}(  24)@{fg text}   reserved:substructure
@{fg shine}(  28)@{fg text}   midimsg:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

@{fg shine}(----)@{fg text} OBJECT mlistsignal
@{fg shine}(   0)@{fg text}   mln:substructure
@{fg shine}(   8)@{fg text}   sigtask:LONG
@{fg shine}(  12)@{fg text}   sigbit:CHAR
@{fg shine}(  13)@{fg text}   flags:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=14 */

CONST MLSF_SOURCE=1,
      MLSF_DEST=2,
      MS_NOTEOFF=$80,
      MS_NOTEON=$90,
      MS_POLYPRESS=$A0,
      MS_CTRL=$B0,
      MS_MODE=$B0,
      MS_PROG=$C0,
      MS_CHANPRESS=$D0,
      MS_PITCHBEND=$E0,
      MS_SYSEX=$F0,
      MS_QTRFRAME=$F1,
      MS_SONGPOS=$F2,
      MS_SONGSELECT=$F3,
      MS_TUNEREQ=$F6,
      MS_EOX=$F7,
      MS_CLOCK=$F8,
      MS_START=$FA,
      MS_CONTINUE=$FB,
      MS_STOP=$FC,
      MS_ACTVSENSE=$FE,
      MS_RESET=$FF,
      MIDDLEC=$3C,
      DEFAULTVELOCITY=$40,
      PITCHBENDCENTER=$2000,
      MCLKSPERQTR=24,
      MCLKSPERSP=6,
      MCCENTER=$40,
      MC_MODWHEEL=1,
      MC_BREATH=2,
      MC_FOOT=4,
      MC_PORTATIME=5,
      MC_DATAENTRY=6,
      MC_VOLUME=7,
      MC_BALANCE=8,
      MC_PAN=10,
      MC_EXPRESSION=11,
      MC_GENERAL1=16,
      MC_GENERAL2=17,
      MC_GENERAL3=18,
      MC_GENERAL4=19,
      MC_SUSTAIN=$40,
      MC_PORTA=$41,
      MC_SUSTENUTO=$42,
      MC_SOFTPEDAL=$43,
      MC_HOLD2=$45,
      MC_GENERAL5=$50,
      MC_GENERAL6=$51,
      MC_GENERAL7=$52,
      MC_GENERAL8=$53,
      MC_EXTDEPTH=$5B,
      MC_TREMOLODEPTH=$5C,
      MC_CHORUSDEPTH=$5D,
      MC_CELESTEDEPTH=$5E,
      MC_PHASERDEPTH=$5F,
      MC_DATAINCR=$60,
      MC_DATADECR=$61,
      MC_NRPNL=$62,
      MC_NRPNH=$63,
      MC_RPNL=$64,
      MC_RPNH=$65,
      MM_MAX=$78,
      MM_MIN=$79,
      MM_RESETCTRL=$79,
      MM_LOCAL=$7A,
      MM_ALLOFF=$7B,
      MM_OMNIOFF=$7C,
      MM_OMNION=$7D,
      MM_MONO=$7E,
      MM_POLY=$7F,
      MRP_PBSENS=0,
      MRP_FINETUNE=1,
      MRP_COURSETUNE=2,
      MTCQ_FRAMEL=0,
      MTCQ_FRAMEH=16,
      MTCQ_SECL=$20,
      MTCQ_SECH=$30,
      MTCQ_MINL=$40,
      MTCQ_MINH=$50,
      MTCQ_HOURL=$60,
      MTCQ_HOURH=$70,
      MTCQ_TYPEMASK=$70,
      MTCQ_DATAMASK=15,
      MTCH_TYPEMASK=$60,
      MTCH_HOURMASK=31,
      MTCT_24FPS=0,
      MTCT_25FPS=$20,
      MTCT_30FPS_DROP=$40,
      MTCT_30FPS_NONDROP=$60,
      MID_XAMERICA=0,
      MID_SEQUENTIAL=1,
      MID_IDP=2,
      MID_OCTAVEPLATEAU=3,
      MID_MOOG=4,
      MID_PASSPORT=5,
      MID_LEXICON=6,
      MID_KURZWEIL=7,
      MID_FENDER=8,
      MID_AKG=10,
      MID_VOYCE=11,
      MID_WAVEFRAME=12,
      MID_ADA=13,
      MID_GARFIELD=14,
      MID_ENSONIQ=15,
      MID_OBERHEIM=16,
      MID_APPLE=17,
      MID_GREYMATTER=18,
      MID_PALMTREE=20,
      MID_JLCOOPER=21,
      MID_LOWREY=22,
      MID_ADAMSSMITH=23,
      MID_EMU=24,
      MID_HARMONY=25,
      MID_ART=26,
      MID_BALDWIN=27,
      MID_EVENTIDE=28,
      MID_INVENTRONICS=29,
      MID_CLARITY=31,
      MIDX_DIGITALMUSIC=7,
      MIDX_IOTA=8,
      MIDX_IVL=11,
      MIDX_SOUTHERNMUSIC=12,
      MIDX_LAKEBUTLER=13,
      MIDX_DOD=16,
      MIDX_PERFECTFRET=20,
      MIDX_OPCODE=22,
      MIDX_SPATIALSOUND=24,
      MIDX_KMX=25,
      MIDX_AXXES=$20,
      MID_PASSAC=$20,
      MID_SIEL=$21,
      MID_SYNTHAXE=$22,
      MID_HOHNER=$24,
      MID_TWISTER=$25,
      MID_SOLTON=$26,
      MID_JELLINGHAUS=$27,
      MID_SOUTHWORTH=$28,
      MID_PPG=$29,
      MID_JEN=$2A,
      MID_SSL=$2B,
      MID_AUDIOVERITRIEB=$2C,
      MID_ELKA=$2F,
      MID_DYNACORD=$30,
      MID_KAWAI=$40,
      MID_ROLAND=$41,
      MID_KORG=$42,
      MID_YAMAHA=$43,
      MID_CASIO=$44,
      MID_MORIDAIRA=$45,
      MID_KAMIYA=$46,
      MID_AKAI=$47,
      MID_JAPANVICTOR=$48,
      MID_MEISOSHA=$49,
      MID_HOSHINOGAKKI=$4A,
      MID_FUJITSU=$4B,
      MID_SONY=$4C,
      MID_NISSHINONPA=$4D,
      MID_SYSTEMPRODUCT=$4F,
      MID_NC=$7D,
      MID_NRT=$7E,
      MID_RT=$7F
@endnode
