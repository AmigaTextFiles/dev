OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'exec/io','exec/libraries','dos/dosextens',
       'exec/ports'

#define UNPACKNAME 'unpack.library'

CONST  UNPACKVERSION  = 40,
       UNPACKREVISION = 55

-> The ui_flag have the following definations:
CONST  UFB_ONEFILE = 0,    /* This Select To Decrunch One File Or All Files In An Archive.*/
       UFB_DELETE  = 1,    /* Delete Files After Scanning. */
       UFB_NOFREE  = 2,    /* Free Memory After Jump (V35+) */
       UFB_BANNER  = 3,    /* Give Banner (V36+) */
       UFB_NOLOAD  = 4,    /* Do Not Load File (V37+) */
       UFB_PROTECT = 5,    /* Change Protection Bits (V38+) */
       UFN_ONEFILE = 1,
       UFN_DELETE  = 2,
       UFN_NOFREE  = 4,
       UFN_BANNER  = 8,
       UFN_NOLOAD  = 16,
       UFN_PROTECT = 32


-> And Now For The ui_crunchtype flag:

CONST  CRU_ARCHIVE   =  1,   /* Archive (Lha, Zoo Etc.) */
       CRU_DATA      =  2,   /* Data File */
       CRU_OBJECT    =  3,   /* Object File */
       CRU_OBJECT2   =  4,   /* 2 Segment Object File */
       CRU_TRACK     =  5,   /* Track File (DMS) (V36+) */
       CRUB_ENCRYP   =  7    /* Encrypted File (If Bit Is Set) */

-> And The Error Flag:

CONST  ERR_OPEN      =  1,    /* Can't Open File */
       ERR_READWRITE =  2,    /* Read/Write Error */
       ERR_MEMORY    =  3,    /* Allocation Error (Out Of Memory) */
       ERR_DETERMINE =  4,    /* Can't Determine File */
       ERR_PASSWORD  =  5,    /* Illegal Password */
       ERR_HUNK      =  6,    /* Hunk Error */
       ERR_EXTERN    =  7,    /* Extern File Error */
       ERR_CORRUPT   =  8,    /* Crunched File Is Corrupt (V35+) */
       ERR_DEVICE    =  9,    /* Illegal Device (V36+) */
       ERR_DEVOPEN   =  10,   /* Couldn't Opn Dev. Or Create Port V36+ */
       ERR_CRC       =  11,   /* CRC Checksum Error (V36+) */
       ERR_CHECKSUM  =  12,   /* Checksum Error (V36+) */
       ERR_OLD       =  13,   /* Decruncher In Lib. Too Old (V36+) */
       ERR_DEVERR    =  14,   /* Error From Device (V36+) */
       ERR_PROTECT   =  15,   /* Couldn't Set Protection Bits (V38+) */
       ERR_OUTPUT    =  16,   /* Output File Error (V39+) */
       ERR_OPENLIBRARY= 17,   /* Couldn't Open Library (V40+) */
       ERR_UNKNOWN   =  18    /* Unknown Error (V40+) */


-> At Last The Cruncher Numbers:

CONST  MAXFILEPACK  = 12,
       CN_LHA       = 1,    /* LHA */
       CN_LHASFX    = 2,    /* LHASFX */
       CN_PAK10     = 3,    /* PAK 1.0 */
       CN_DMS       = 4     /* DMS */

CONST  CN_GNUPACK10D  = 12,   /* GNU PACKER 1.0 D */
       CN_GNUPACK12D  = 13,   /* GNU PACKER 1.1/1.2 D */
       CN_GNUPACK12TWO= 14,   /* GNU PACKER 1.1/1.2 TWO SEGMENT */
       CN_GNUPACK10   = 15,   /* GNU PACKER 1.0 */
       CN_GNUPACK12   = 16,   /* GNU PACKER 1.1/1.2 ONE SEGMENT */
       CN_PPDATA      = 17,   /* POWERPACKER DATA */
       CN_PPDATAE     = 18,   /* POWERPACKER DATA/ENCRYPTED */
       CN_PPLOADSEG   = 19,   /* POWERPACKER LOADSEG */
       CN_PPLIB       = 20,   /* POWERPACKER LIBRARY */
       CN_PPLIBE      = 21,   /* POWERPACKER LIBRARY/ENCRYPTED */
       CN_PPLIBOV     = 22,   /* POWERPACKER LIBRARY/OVERLAYED */
       CN_PP2X        = 23,   /* POWERPACKER 2.X */
       CN_PP30        = 24,   /* POWERPACKER 3.0 */
       CN_PP30E       = 25,   /* POWERPACKER 3.0 ENCRYPTED */
       CN_PP30OV      = 26,   /* POWERPACKER 3.0 OVERLAYED */
       CN_PP41        = 27,   /* POWERPACKER 4.0-4.1 */
       CN_PP41E       = 28,   /* POWERPACKER 4.0-4.1 ENCRYPTED */
       CN_PP41OV      = 29,   /* POWERPACKER 4.0-4.1 OVERLAYED */
       CN_TURTLE13    = 30,   /* TURTLE SMASHER 1.3 */
       CN_TSQUEEZE80  = 31,   /* TURBOSQUEEZER 8.0 */
       CN_TSQUEEZE80S = 32,   /* TURBOSQUEEZER 8.0 SMALL */
       CN_TRYIT101    = 33,   /* TRYIT 1.01 */
       CN_TITANIC11   = 34,   /* TITANICS CRUNCHER 1.1 */
       CN_TITANIC12   = 35,   /* TITANICS CRUNCHER 1.2 */
       CN_TIME22      = 36,   /* TIME CRUNCHER 1.7-2.2 */
       CN_TETRA21     = 37,   /* TETRAPACKER 2.1 */
       CN_TETRA21PRO  = 38,   /* TETRAPACKER 2.1 PRO */
       CN_TETRA22     = 39,   /* TETRAPACKER 2.2 */
       CN_TETRA22PRO  = 40,   /* TETRAPACKER 2.2 PRO */
       CN_TETRA102    = 41,   /* TETRACRUNCH 1.02 */
       CN_TETRA11     = 42,   /* TETRACRUNCH 1.1 */
       CN_STONE299D   = 43,   /* STONE CRACKER 2.99D */
       CN_STONE311    = 44,   /* STONE CRACKER 3.11 */
       CN_STONE401A   = 45,   /* STONE CRACKER 4.01 A */
       CN_IMPLODER31  = 46,   /* IMPLODER 1.0-3.1 */
       CN_IMPLODER31P = 47,   /* IMPLODER 1.0-3.1 PROTECTED */
       CN_IMPLODER31L = 48,   /* IMPLODER 1.0-3.1 LIBRARY */
       CN_IMPLODER31LP= 49,   /* IMPLODER 1.0-3.1 LIBRARY/PROTECTED */
       CN_IMPLODER40  = 50,   /* IMPLODER 4.0 */
       CN_IMPLODER40L = 51,   /* IMPLODER 4.0 LIBRARY */
       CN_BLKDEC21    = 52,   /* BLACK & DECKER 2.0-2.1 */
       CN_BYTKIL20    = 53,   /* BYTEKILLER 2.0 */
       CN_BYTKIL30    = 54,   /* BYTEKILLER 3.0 */
       CN_TNMCRUN11   = 55,   /* TNM CRUNCHER 1.1 */
       CN_CRUNMAST10  = 56,   /* CRUNCH MASTER 1.0 */
       CN_CRMANIA14A  = 57,   /* CRUNCH MANIA 1.4-1.9T A */
       CN_CRMANIA14AP = 58,   /* CRUNCH MANIA 1.4-1.8 A/P */
       CN_CRMANIA14D  = 59,   /* CRUNCH MANIA 1.4-1.9T D */
       CN_CRMANIA18R  = 60,   /* CRUNCH MANIA 1.4-1.9T R */
       CN_CRMANIA18RS = 61,   /* CRUNCH MANIA 1.4-1.9T R/S */
       CN_CRMANIA18RL = 62,   /* CRUNCH MANIA 1.8-1.9T R/L */
       CN_CRMANIA18RLH= 63,   /* CRUNCH MANIA 1.8-1.9T R/L/H */
       CN_CRMANIA18RH = 64,   /* CRUNCH MANIA 1.8-1.9T R/H */
       CN_CRMANIA18DH = 65,   /* CRUNCH MANIA 1.8-1.9T D/H */
       CN_CRMANIA18DHS= 66,   /* CRUNCH MANIA 1.8-1.9T D/H/S */
       CN_CRMANIA18DS = 67,   /* CRUNCH MANIA 1.8-1.9T D/S */
       CN_DOUBACTION10= 68,   /* DOUBLE ACTION 1.0 */
       CN_DRAGPACK10  = 69,   /* DRAGPACK 1.0 */
       CN_HOUSE14     = 70,   /* HOUSE 1.4 (RSI-PACKER) */
       CN_HPC         = 71,   /* HIGH PRESSURE CRUNCHER */
       CN_HPCU        = 72,   /* HIGH PRESSURE CRUNCHER U */
       CN_IAM10ICE    = 73,   /* IAM PACKER PRO 1.0 ICE */
       CN_IAM10ICED   = 74,   /* IAM PACKER PRO 1.0 ICE/D */
       CN_IAM10ATM5   = 75,   /* IAM PACKER PRO 1.0 ATM5 */
       CN_IAM10ATM5D  = 76,   /* IAM PACKER PRO 1.0 ATM5/D */
       CN_ISC15P1     = 77,   /* ISC 1.5 PASS 1 */
       CN_ISC15P2     = 78,   /* ISC 1.5 PASS 2 */
       CN_ISC15P3     = 79,   /* ISC 1.5 PASS 3 */
       CN_MASTCRUN31A = 80,   /* MASTER CRUNCHER 3.0-3.1 A */
       CN_MASTCRUN31R = 81,   /* MASTER CRUNCHER 3.0-3.1 R */
       CN_MASTCRUN31D = 82,   /* MASTER CRUNCHER 3.0-3.1 D */
       CN_MEGACRUN10  = 83,   /* MEGACRUNCHER 1.0 */
       CN_MEGACRUN12A = 84,   /* MEGACRUNCHER 1.2 A */
       CN_MEGACRUN12R = 85,   /* MEGACRUNCHER 1.2 R */
       CN_DEFJAM36    = 86,   /* DEFJAM 3.2-3.6 */
       CN_DEFJAM36PRO = 87,   /* DEFJAM 3.2-3.6 PRO */
       CN_PACKIT10    = 88,   /* PACKIT 1.0 */
       CN_PACKIT10D   = 89,   /* PACKIT 1.0 D */
       CN_RELOKIT10   = 90,   /* RELOKIT 1.0 */
       CN_SPIKE15     = 91,   /* SPIKE CRUNCHER 1.1-1.5 */
       CN_SUPERCRUN27 = 92,   /* SUPER CRUNCHER 2.7 */
       CN_SYNCRO46    = 93,   /* SYNCRO PACKER 4.6 */
       CN_SYNCRO46K   = 94,   /* SYNCRO PACKER 4.6 K */
       CN_SYNCRO46R   = 95,   /* SYNCRO PACKER 4.6 R */
       CN_SYNCRO46RK  = 96,   /* SYNCRO PACKER 4.6 R/K */
       CN_STONE400    = 97,   /* STONE CRACKER 4.00 */
       CN_STONE400D   = 98,   /* STONE CRACKER 4.00 D */
       CN_STONE401C   = 99,   /* STONE CRACKER 4.01 C */
       CN_STONE401D   = 100   /* STONE CRACKER 4.01 D */

CONST  CN_MAXPACKER12 = 113,    /* MAXPACKER 1.2 */
       CN_PMC         = 114,    /* PMC CRUNCHER */
       CN_STONE271    = 115,    /* STONE CRACKER 2.6A-2.71 */
       CN_STONE271K   = 116,    /* STONE CRACKER 2.6A-2.71 K */
       CN_STONE310    = 117,    /* STONE CRACKER 3.10 */
       CN_STONE402    = 118,    /* STONE CRACKER 4.02A */
       CN_STONE402A   = 119,    /* STONE CRACKER 4.02A A */
       CN_STONE402D   = 120,    /* STONE CRACKER 4.02A D */
       CN_STONE402L   = 121,    /* STONE CRACKER 4.02A L */
       CN_TURTLE200   = 122,    /* TURTLE SMASHER 2.00 */
       CN_TURTLE200D  = 123,    /* TURTLE SMASHER 2.00 D */
       CN_ANC         = 124,    /* ANC-CRUNCHER */
       CN_DISIMP10    = 125,    /* DISCOVERY FILE IMPLODER 1.0 */
       CN_HQC20       = 126     /* HQC CRUNCHER 2.0 */

CONST  CN_STONE292    = 130,    /* STONE CRACKER 2.92 */
       CN_STONE299    = 131,    /* STONE CRACKER 2.99 */
       CN_PCOMPRESS29 = 132,    /* P-COMPRESS 2.9 */
       CN_CRMANIA19AP = 133,    /* CRUNCH MANIA 1.9T A/P */
       CN_CRMANIA19AH = 134,    /* CRUNCH MANIA 1.9T A/H */
       CN_CRMANIA19AHP= 135,    /* CRUNCH MANIA 1.9T A/H/P */
       CN_TSQUEEZE61  = 136,            /* TURBOSQUEEZER 6.1 */
       CN_FLASHSPEED10= 137,    /* FLASHSPEED 1.0 */
       CN_BYTKILPRO10 = 138,    /* BYTEKILLER 1.0 PRO */
       CN_BYTKILPRO10K= 139,    /* BYTEKILLER 1.0 PRO K */
       CN_STONE401BA  = 140,    /* STONE CRACKER 4.01ß A */
       CN_TRASHELI10  = 141,    /* TRASH ELIMINATOR 1.0 */
       CN_ULTIMATE11B = 142,    /* ULTIMATE PACKER 1.1B */
       CN_TFA154      = 143,    /* TFA CRUNCHER 1.54 */
       CN_SEXEC11     = 144,    /* S-EXEC 1.1 */
       CN_STONE4102   = 145,    /* STONE CRACKER 4.10.2 */
       CN_STONE4102A  = 146,    /* STONE CRACKER 4.10.2 A */
       CN_STONE4102AP = 147,    /* STONE CRACKER 4.10.2 A/PLAIN */
       CN_STONE4102APR= 148,    /* STONE CRACKER 4.10.2 A/PRO */
       CN_STONE4102D  = 149,    /* STONE CRACKER 4.10.2 D */
       CN_STONE4102L  = 150,    /* STONE CRACKER 4.10.2 L */
       CN_DRAGPACK252 = 151,    /* DRAGPACK 2.52 */
       CN_DRAGPACK252D= 152,    /* DRAGPACK 2.52 D */
       CN_STONE300    = 153,    /* STONE CRACKER 3.00 */
       CN_STONE300D   = 154,    /* STONE CRACKER 3.00 D */
       CN_STONE300K   = 155     /* STONE CRACKER 3.00 K */

CONST  CN_PP2XMAST    = 157,    /* POWERPACKER 2.X MASTER */
       CN_XPK         = 158,    /* XPK PACKED */
       CN_XPKE        = 159     /* XPK ENCRYPTED */

-> THIS LABEL WILL BE DELETED LATER ON
CONST  CN_COMCRA11    = CN_TNMCRUN11  /* COMPRESSOR CRACKINGS INC. V1.1 */


OBJECT librarystruct
  libnode:lib
  lib_seglist,lib_dosbase,lib_intbase
ENDOBJECT

OBJECT numberstruct
  version:INT
  revision:INT
  types:INT
  unpackers:INT
ENDOBJECT

OBJECT drivestruct
  unpackinfo:LONG
  iostdreq:PTR TO iostd
  msgport:PTR TO mp
  devname[48]:ARRAY OF CHAR
  drivename[10]:ARRAY OF CHAR
ENDOBJECT

OBJECT unpackinfo
  filename:LONG
  path:LONG
  jump:LONG
  crunchername:LONG
  decrunchadr:LONG
  decrunchlen:LONG
  errornum:INT
  crunchnum:INT
  crunchtype:CHAR
  flag:CHAR
  loadnamepoi:LONG
  crunchlen:LONG
  userdata:LONG      -> v35+
  trackjump:LONG     -> v36+
  trkerrjump:LONG    -> v36+
  offset:LONG        -> v36+
  track:INT          -> v36+
  errormsg:LONG      -> v37+
  crunchadr:LONG     -> v37+
  lhapattern:LONG    -> v38+
  usefilenamepointer:CHAR   -> v39+  (????  was BOOL8)
PRIVATE
  pad:CHAR
  crunchlentemp:LONG
  filehandler:LONG
  lock:LONG
  oldlock:LONG
  infoaddr:LONG
  unpackpoi:LONG
  temp:LONG
  data[16]:ARRAY OF CHAR         -> V35+
  loadname[128]:ARRAY OF CHAR
  executestring[256]:ARRAY OF CHAR
ENDOBJECT
