OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'utility/tagitem','utility/hooks'

#define  CRMNAME "CrM.library"
CONST    CRMVERSION = 4

-> Result Codes of cmCheckCrunched()
-> and Symbols for the CMCS_Algo Tag
CONST CM_NORMAL      = 1,
      CM_LZH         = 2,
      CMB_SAMPLE     = 4,
      CMF_SAMPLE     = 16,
      CMB_PW         = 5,
      CMF_PW         = $20,
      CMB_OVERLAY    = 8,
      CMF_OVERLAY    = $100,
      CMB_LEDFLASH   = 9,
      CMF_LEDFLASH   = $200

-> Use this mask to get the crunch algorithm without any other flags:
CONST CM_ALGOMASK    = 15

-> Action Codes for cmProcessPW()
CONST CM_ADDPW       = 1,
      CM_REMOVEPW    = 2,
      CM_REMOVEALL   = 3

-> Action Codes for cmCryptData()
CONST CM_ENCRYPT     = 4,
      CM_DECRYPT     = 5

-> Action Codes for cmProcessCrunchStruct()
CONST CM_ALLOCSTRUCT = 6,
      CM_FREESTRUCT  = 7

-> Tags for cmProcessCrunchStruct()
CONST CM_TAGBASE     = $80000000, /* CM_TAGBASE=TAG_USER */
      CMCS_ALGO      = $80000001, /* default: cm_LZH */
      CMCS_OFFSET    = $80000002, /* default: $7ffe */
      CMCS_HUFFSIZE  = $80000003  /* default: 16 */


-> for older Code, _DON'T_ use in new code:
CONST CM_LZHSAMP     = 6, /* CM_LZH OR CM_SAMPLE */
      CM_NORMSAMP    = 5, /* CM_NORMAL OR CM_SAMPLE */
      CM_SAMPLE      = 16
->    DH_ORGINALLEN  = DH_ORIGINALLEN


OBJECT cmcrunchstruct
  src:LONG                    /* Source Start */
  srclen:LONG                 /* Source Len */
  dest:LONG                   /* Destination Start */
  destlen:LONG                /* Destination Len (maximum) */
  datahdr:PTR TO dataheader   /* DataHeader */
  displayhook:PTR TO hook     /* Hook to display ToGo/Gain Counters */
   -> Registers hold these values when the Hook is called:
   -> a0:struct Hook*  a2:struct cmCrunchStruct*  a1:struct cmCurrentStats*
   -> you have to return TRUE/FALSE in d0 to continue/abort crunching!
  displaystep:INT             /* time between 2 calls to the Hook */
->readonly:
  offset:INT                  /* desired Offset */
  huffsize:INT                /* HuffLen in KBytes */
  algo:INT                    /* desired Packalgorithm */
  maxoffset:LONG              /* biggest possible Offset (Buffer allocated) */
  realoffset:LONG             /* currently used Offset */
  minsecdist:LONG             /* MinSecDist for packed Data */
  crunchedlen:LONG            /* Length of crunched Data at dest */
PRIVATE
  hufftabs:LONG
  huffbuf:LONG
  hufflen:LONG
  speedlen:LONG
  speedtab:LONG
  megaspeedtab:LONG
  quitflag:CHAR
  overlayflag:CHAR
  ledflashflag:CHAR
  pad:CHAR
-> CrunchStruct continues here, but LEAVE YOUR HANDS OFF!!!
ENDOBJECT

OBJECT cmcurrentstats
  togo:LONG
  len:LONG
ENDOBJECT

OBJECT dataheader
  id:LONG
  minsecdist:INT
  originallen:LONG
  crunchedlen:LONG
ENDOBJECT
