OPT MODULE
OPT PREPROCESS,EXPORT

MODULE 'exec/io','exec/libraries','dos/dosextens','exec/execbase',
       'exec/ports','dos/dosextens','intuition/intuitionbase'

#define UNPACKNAME 'unpack.library'
CONST   UNPACKVERSION  = 42,
        UNPACKREVISION = 71

-> Library Base Structure
OBJECT unpacklibrary
   libnode:lib
   seglist:LONG
   lib_dosbase:PTR TO doslibrary
   lib_intbase:PTR TO intuitionbase
   lib_sysbase:PTR TO execbase
ENDOBJECT

-> Unpack Numbers Structure (V37+)
OBJECT numberstruct
  version:INT              /* Library Version */
  revision:INT             /* Library Revision */
  types:INT
  unpackers:INT
ENDOBJECT

-> Unpacker List Structure (V42+)
OBJECT unpliststruct
  name:PTR TO CHAR
  crunchnum:INT
  typenum:INT
  type:CHAR
  flags:CHAR
  reserved:LONG
ENDOBJECT
CONST ULFB_ENCRYPTED = 0

-> Drive Structure (V36+)
OBJECT drivestruct
  unpackinfo:PTR TO unpackinfo
  iostdreq:PTR TO iostd
  msgport:PTR TO mp
  devname[48]:ARRAY OF CHAR
  drivename[10]:ARRAY OF CHAR
ENDOBJECT

-> Unpack Info Structure
OBJECT unpackinfo
  filename:PTR TO CHAR
  path:PTR TO CHAR
  jump:LONG
  crunchername:PTR TO CHAR
  decrunchadr:LONG
  decrunchlen:LONG
  errornum:INT
  crunchnum:INT
  crunchtype:CHAR
  flag:CHAR
  loadnamepoi:PTR TO CHAR
  crunchlen:LONG
  userdata:LONG          -> v35+
  trackjump:LONG         -> v36+
  trkerrjump:LONG        -> v36+
  offset:LONG            -> v36+
  track:INT              -> v36+
  errormsg:PTR TO CHAR   -> v37+
  crunchadr:LONG         -> v37+
  lhapattern:PTR TO CHAR -> v38+
  usefilenamepointer:CHAR-> v39+
   pad:CHAR
  address:LONG           -> v42+
  jumpadr:LONG           -> v42+
  password:LONG          -> v42+
  private[872]:ARRAY OF CHAR  -> Private Data, Do NOT Touch
ENDOBJECT

-> The flag Have The Following Definitions:
CONST  UFB_ONEFILE = 0,    /* This Select To Decrunch One File Or All Files In An Archive.*/
       UFB_DELETE  = 1,    /* Delete Files After Scanning. */
       UFB_NOFREE  = 2,    /* Free Memory After Jump (V35+) */
       UFB_BANNER  = 3,    /* Give Banner (V36+) */
       UFB_NOLOAD  = 4,    /* Do Not Load File (V37+) */
       UFB_PROTECT = 5,    /* Change Protection Bits (V38+) */
       UFB_NOA4    = 6,    /* A4 -> A2 */
       UFB_CHIPMEM = 7     /* Decrunch To Chip Memory (V42+) */

SET    UFN_ONEFILE,UFN_DELETE,UFN_NOFREE,UFN_BANNER,UFN_NOLOAD,
       UFN_PROTECT,UFN_NOA4,UFN_CHIPMEM

-> And Now For The crunchtype Flag:
CONST  CRU_ARCHIVE   =  1,   /* Archive (Lha, Zoo Etc.) */
       CRU_DATA      =  2,   /* Data File */
       CRU_OBJECT    =  3,   /* Object File */
       CRU_OBJECT2   =  4,   /* 2 Segment Object File */
       CRU_TRACK     =  5,   /* Track File (DMS) (V36+) */
       CRU_ADDRESS   =  6,   /* Address File (V42+) */
       CRUB_ENCRYP   =  7    /* Encrypted File (If Bit Is Set) */

-> And The error Flag:
CONST  UERR_OPEN        = 1,    /* Can't Open File */
       UERR_READWRITE   = 2,    /* Read/Write Error */
       UERR_MEMORY      = 3,    /* Allocation Error (Out Of Memory) */
       UERR_DETERMINE   = 4,    /* Can't Determine File */
       UERR_PASSWORD    = 5,    /* Illegal Password */
       UERR_HUNK        = 6,    /* Hunk Error */
       UERR_EXTERN      = 7,    /* Extern File Error */
       UERR_CORRUPT     = 8,    /* Crunched File Is Corrupt (V35+) */
       UERR_DEVICE      = 9,    /* Illegal Device (V36+) */
       UERR_DEVOPEN     = 10,   /* Couldn't Opn Dev. Or Create Port V36+ */
       UERR_CRC         = 11,   /* CRC Checksum Error (V36+) */
       UERR_CHECKSUM    = 12,   /* Checksum Error (V36+) */
       UERR_OLD         = 13,   /* Decruncher In Lib. Too Old (V36+) */
       UERR_DEVERR      = 14,   /* Error From Device (V36+) */
       UERR_PROTECT     = 15,   /* Couldn't Set Protection Bits (V38+) */
       UERR_OUTPUT      = 16,   /* Output File Error (V39+) */
       UERR_OPENLIBRARY = 17,   /* Couldn't Open Library (V40+) */
       UERR_UNKNOWN     = 18,   /* Unknown Error (V40+) */
       UERR_UNPACK      = 19,   /* Can't Unpack (V42+) */
       UERR_PASSWORDREQ = 20,   /* Password Required (V42+) */
       UERR_DIRECTORY   = 21    /* Can't Make Directory (V42+) */

-> At Last The Cruncher Numbers:
CONST  MAXFILEPACK     = 12
CONST  CN_LHA          = 1,    /* Lha */
       CN_LHASFX       = 2,    /* LhaSFX */
       CN_PAK10        = 3,    /* Pak 1.0 */
       CN_DMS          = 4,    /* Dms */
       CN_LZX          = 5,    /* Lzx */
       CN_PCOMPRESS    = 6,    /* P-Compress */
       CN_DMSE         = 7,    /* Dms Encrypted */
       CN_GNUPACK10D   = 12,   /* Gnu Packer 1.0 Data */
       CN_GNUPACK12D   = 13,   /* Gnu Packer 1.1/1.2 Data */
       CN_GNUPACK12TWO = 14,   /* Gnu Packer 1.1/1.2 Two Segment */
       CN_GNUPACK10    = 15,   /* Gnu Packer 1.0 */
       CN_GNUPACK12    = 16,   /* Gnu Packer 1.1/1.2 One Segment */
       CN_PPDATA       = 17,   /* PowerPacker Data */
       CN_PPDATAE      = 18,   /* PowerPacker Data/Encrypted */
       CN_PPLOADSEG    = 19,   /* PowerPacker LoadSeg */
       CN_PP40LIB      = 20,   /* PowerPacker 4.0 Library */
       CN_PP40LIBE     = 21,   /* PowerPacker 4.0 Library/Encrypted */
       CN_PP40LIBOV    = 22,   /* PowerPacker 4.0 Library/Overlayed */
       CN_PP2X         = 23,   /* PowerPacker 2.x Normal */
       CN_PP30         = 24,   /* PowerPacker 3.0 */
       CN_PP30E        = 25,   /* PowerPacker 3.0 Encrypted */
       CN_PP30OV       = 26,   /* PowerPacker 3.0 Overlayed */
       CN_PP40         = 27,   /* PowerPacker 4.0 */
       CN_PP40E        = 28,   /* PowerPacker 4.0 Encrypted */
       CN_PP40Ov       = 29,   /* PowerPacker 4.0 Overlayed */
       CN_TURTLE141    = 30,   /* Turtle Smasher 1.3-1.41 */
       CN_TSQUEEZE80   = 31,   /* TurboSqueezer 8.0 */
       CN_TSQUEEZE80S  = 32,   /* TurboSqueezer 8.0 Small */
       CN_TRYIT101     = 33,   /* TryIt 1.01 */
       CN_TITANIC11    = 34,   /* Titanics Cruncher 1.1 */
       CN_TITANIC12    = 35,   /* Titanics Cruncher 1.2 */
       CN_TIME22       = 36,   /* Time Cruncher 1.7-2.2 */
       CN_TETRA21      = 37,   /* TetraPack 2.1 */
       CN_TETRA21PRO   = 38,   /* TetraPack 2.1 Pro */
       CN_TETRA22      = 39,   /* TetraPack 2.2 */
       CN_TETRA22PRO   = 40,   /* TetraPack 2.2 Pro */
       CN_TETRA102     = 41,   /* TetraCrunch 1.02 */
       CN_TETRA11      = 42,   /* TetraCrunch 1.1 */
       CN_STONE299D    = 43,   /* Stone Cracker 2.99c-2.99d */
       CN_STONE311     = 44,   /* Stone Cracker 3.11 */
       CN_STONE401A    = 45,   /* Stone Cracker 4.01 Address */
       CN_IMPLODER31   = 46,   /* Imploder 1.0-3.1 */
       CN_IMPLODER31P  = 47,   /* Imploder 1.0-3.1 Protected */
       CN_IMPLODER31L  = 48,   /* Imploder 1.0-3.1 Library */
       CN_IMPLODER31LP = 49,   /* Imploder 1.0-3.1 Library/Protected */
       CN_IMPLODER40   = 50,   /* Imploder 4.0 */
       CN_IMPLODER40L  = 51,   /* Imploder 4.0 Library */
       CN_BYTKIL13     = 52,   /* ByteKiller 1.2-1.3 */
       CN_BYTKIL20     = 53,   /* ByteKiller 2.0 */
       CN_BYTKIL30     = 54,   /* ByteKiller 3.0 */
       CN_TNMCRUN11    = 55,   /* TNM Cruncher 1.1 */
       CN_CRUNMAST10   = 56,   /* Crunch Master 1.0 */
       CN_CRMANIA191A  = 57,   /* Crunch-Mania 1.4-1.91 Address */
       CN_CRMANIA18AP  = 58,   /* Crunch-Mania 1.4-1.8 Address/Pro */
       CN_CRMANIA191D  = 59,   /* Crunch-Mania 1.4-1.91 Data */
       CN_CRMANIA191   = 60,   /* Crunch-Mania 1.4-1.91 */
       CN_CRMANIA191S  = 61,   /* Crunch-Mania 1.4-1.91 Simple */
       CN_CRMANIA191L  = 62,   /* Crunch-Mania 1.8-1.91 Library */
       CN_CRMANIA191LH = 63,   /* Crunch-Mania 1.8-1.91 Library/Huffman */
       CN_CRMANIA191H  = 64,   /* Crunch-Mania 1.8-1.91 Huffman */
       CN_CRMANIA191DH = 65,   /* Crunch-Mania 1.8-1.91 Data/Huffman */
       CN_CRMANIA191DHS= 66,   /* Crunch-Mania 1.8-1.91 Data/Huff/Sample */
       CN_CRMANIA191DS = 67,   /* Crunch-Mania 1.8-1.91 Data/Sample */
       CN_DOUBACTION10 = 68,   /* Double Action 1.0 */
       CN_DRAGPACK10   = 69,   /* DragPack 1.0 */
       CN_HOUSE14      = 70,   /* House 1.4 (RSI-Packer) */
       CN_HPC          = 71,   /* High Pressure Cruncher */
       CN_HPCU         = 72,   /* High Pressure Cruncher Unlinked */
       CN_IAM10ICE     = 73,   /* IAM Packer 1.0 Ice */
       CN_IAM10ICED    = 74,   /* IAM Packer 1.0 Ice/Data */
       CN_IAM10ATM5    = 75,   /* IAM Packer 1.0 Atm5 */
       CN_IAM10ATM5D   = 76,   /* IAM Packer 1.0 Atm5/Data */
       CN_ISC15P1      = 77,   /* ISC 1.5 Pass 1 */
       CN_ISC15P2      = 78,   /* ISC 1.5 Pass 2 */
       CN_ISC15P3      = 79,   /* ISC 1.5 Pass 3 */
       CN_MASTCRUN31A  = 80,   /* Master Cruncher 3.0-3.1 Address */
       CN_MASTCRUN31   = 81,   /* Master Cruncher 3.0-3.1 */
       CN_MEGACRUN10   = 83,   /* Megacruncher 1.0 */
       CN_MEGACRUN12A  = 84,   /* Megacruncher 1.2 Address */
       CN_MEGACRUN12   = 85,   /* Megacruncher 1.2 */
       CN_DEFJAM36     = 86,   /* Defjam 3.2-3.6 */
       CN_DEFJAM36PRO  = 87,   /* Defjam 3.2-3.6 Pro */
       CN_PACKIT10     = 88,   /* PackIt 1.0 */
       CN_PACKIT10D    = 89,   /* PackIt 1.0 Data */
       CN_RELOKIT10    = 90,   /* Relokit 1.0 */
       CN_SPIKE        = 91,   /* Spike Cruncher */
       CN_SUPERCRUN27  = 92,   /* Super Cruncher 2.7 */
       CN_SYNCRO46     = 93,   /* Syncro Packer 4.6 */
       CN_SYNCRO46P    = 94,   /* Syncro Packer 4.6 Pro */
       CN_SYNCRO46R    = 95,   /* Syncro Packer 4.6 Raw */
       CN_SYNCRO46RP   = 96,   /* Syncro Packer 4.6 Raw/Pro */
       CN_STONE400     = 97,   /* Stone Cracker 4.00 */
       CN_STONE400D    = 98,   /* Stone Cracker 4.00 Data */
       CN_STONE401     = 99,   /* Stone Cracker 4.01 */
       CN_STONE401D    = 100,  /* Stone Cracker 4.01 Data */
       CN_MAXPACKER12  = 113,  /* MaxPacker 1.2 */
       CN_PMC          = 114,  /* PMC */
       CN_STONE271     = 115,  /* Stone Cracker 2.70-2.71 */
       CN_STONE271K    = 116,  /* Stone Cracker 2.70-2.71 Kill */
       CN_STONE310     = 117,  /* Stone Cracker 3.10 */
       CN_STONE402     = 118,  /* Stone Cracker 4.02a */
       CN_STONE402A    = 119,  /* Stone Cracker 4.02a Address */
       CN_STONE402D    = 120,  /* Stone Cracker 4.02a Data */
       CN_STONE402L    = 121,  /* Stone Cracker 4.02a Library */
       CN_TURTLE200    = 122,  /* Turtle Smasher 2.00 */
       CN_TURTLE200D   = 123,  /* Turtle Smasher 2.00 Data */
       CN_ANC          = 124,  /* ANC-Cruncher */
       CN_DISIMP10     = 125,  /* Discovery File Imploder 1.0 */
       CN_HQC20        = 126,  /* HQC Cruncher 2.0 */
       CN_STONE292     = 130,  /* Stone Cracker 2.92 */
       CN_STONE299     = 131,  /* Stone Cracker 2.99 */
       CN_PCOMPRESSD   = 132,  /* P-Compress Data */
       CN_CRMANIA191AP = 133,  /* Crunch-Mania 1.9t-1.91 Address/Pro */
       CN_CRMANIA191AH = 134,  /* Crunch-Mania 1.9t-1.91 Address/Huffman */
       CN_CRMANIA19APH = 135,  /* Crunch-Mania 1.9t Address/Pro/Huff */
       CN_TSQUEEZE61   = 136,  /* TurboSqueezer 6.1 */
       CN_FLASHSPEED10 = 137,  /* FlashSpeed 1.0 */
       CN_BYTKILPRO10  = 138,  /* ByteKiller 1.0 Pro */
       CN_BYTKILPRO10K = 139,  /* ByteKiller 1.0 Pro K */
       CN_STONE401BA   = 140,  /* Stone Cracker 4.01ß Address */
       CN_TRASHELI10   = 141,  /* Trash Eliminator 1.0 */
       CN_ULTIMATE11   = 142,  /* Ultimate Packer 1.1 */
       CN_TFA154       = 143,  /* TFA Cruncher 1.54 */
       CN_SEXEC11      = 144,  /* S-Exec 1.1 */
       CN_STONE4103    = 145,  /* Stone Cracker 4.10.2-4.10.3 */
       CN_STONE4103A   = 146,  /* Stone Cracker 4.10.2-4.10.3 Address */
       CN_STONE4103APL = 147,  /* Stone Cracker 4.10.2-4.10.3 Adr/Plain */
       CN_STONE4103AP  = 148,  /* Stone Cracker 4.10.2-4.10.3 Adr/Pro */
       CN_STONE4103D   = 149,  /* Stone Cracker 4.10.2-4.10.3 Data */
       CN_STONE4102L   = 150,  /* Stone Cracker 4.10.2 Library */
       CN_DRAGPACK252  = 151,  /* DragPack 2.52 */
       CN_DRAGPACK252D = 152,  /* DragPack 2.52 Data */
       CN_STONE300     = 153,  /* Stone Cracker 3.00 */
       CN_STONE300D    = 154,  /* Stone Cracker 3.00 Data */
       CN_STONE300K    = 155,  /* Stone Cracker 3.00 Kill */
       CN_PP23MASTER   = 157,  /* PowerPacker 2.3 Master */
       CN_XPK          = 158,  /* XPK */
       CN_XPKE         = 159,  /* XPK Encrypted */
       CN_CRMANIA191DE = 160,  /* Crunch-Mania 1.9t-1.91 Data/Encrypted */
       CN_CRMANIA191DSE= 161,  /* Crunch-Mania 1.9t-1.91 Data/Samp/Encr */
       CN_CRMANIA191DHE= 162,  /* Crunch-Mania 1.9t-1.91 Data/Huff/Encr */
       CN_CRMANIA191DHSE=163,  /* Crunch-Mania 1.9t-1.91 Dat/Huf/Sam/Enc */
       CN_CRMANIA191APH= 164,  /* Crunch-Mania 1.91 Address/Pro/Huff */
       CN_CRMATIC10D   = 165,  /* Crunch-o-Matic 1.0 Data */
       CN_CRMATIC10E   = 166,  /* Crunch-o-Matic 1.0 Execute */
       CN_CRMATIC10M   = 167,  /* Crunch-o-Matic 1.0 Module */
       CN_CRMATIC10P   = 168,  /* Crunch-o-Matic 1.0 Picture */
       CN_CRMATIC10T   = 169,  /* Crunch-o-Matic 1.0 Text */
       CN_STONE4103L   = 170,  /* Stone Cracker 4.10.3 Library */
       CN_CHRYSEIS09   = 171,  /* Chryseis Cruncher 0.9 */
       CN_TUC116D      = 172,  /* TUC Cruncher 1.16d */
       CN_TUC116DD     = 173,  /* TUC Cruncher 1.16d Data */
       CN_SOUNDTRKPACK = 174,  /* ST-Packer */
       CN_PHD          = 175,  /* PHD Compressor */
       CN_LIGHTPACK15  = 176,  /* LightPack 1.5 */
       CN_PPRNC1       = 177,  /* ProPack (RNC) Mode 1 */
       CN_PPRNC1V      = 178,  /* ProPack (RNC) Validate Mode 1 */
       CN_PPRNC1K      = 179,  /* ProPack (RNC) Key Mode 1 */
       CN_PPRNC1VK     = 180,  /* ProPack (RNC) Validate Key Mode 1 */
       CN_PPRNC168000  = 181,  /* ProPack (RNC) 68000 Mode 1 */
       CN_PPRNC168000V = 182,  /* ProPack (RNC) 68000 Validate Mode 1 */
       CN_PPRNC168000K = 183,  /* ProPack (RNC) 68000 Key Mode 1 */
       CN_PPRNC168000VK= 184,  /* ProPack (RNC) 68000 Valid. Key Mode 1 */
       CN_PPRNC1D      = 185,  /* ProPack (RNC) Data Mode 1 */
       CN_PPRNC1DK     = 186,  /* ProPack (RNC) Data Key Mode 1 */
       CN_PPRNC2       = 187,  /* ProPack (RNC) Mode 2 */
       CN_PPRNC2V      = 188,  /* ProPack (RNC) Validate Mode 2 */
       CN_PPRNC2K      = 189,  /* ProPack (RNC) Key Mode 2 */
       CN_PPRNC2VK     = 190,  /* ProPack (RNC) Validate Key Mode 2 */
       CN_PPRNC268000  = 191,  /* ProPack (RNC) 68000 Mode 2 */
       CN_PPRNC268000V = 192,  /* ProPack (RNC) 68000 Validate Mode 2 */
       CN_PPRNC268000K = 193,  /* ProPack (RNC) 68000 Key Mode 2 */
       CN_PPRNC268000VK= 194,  /* ProPack (RNC) 68000 Valid. Key Mode 2 */
       CN_PPRNC2D      = 195,  /* ProPack (RNC) Data Mode 2 */
       CN_PPRNC2DK     = 196,  /* ProPack (RNC) Data Key Mode 2 */
       CN_IMPLODER31O  = 197,  /* Imploder 1.0-3.1 Overlayed */
       CN_IMPLODER31OP = 198,  /* Imploder 1.0-3.1 Overlayed Protected */
       CN_IMPLODER40O  = 199,  /* Imploder 4.0 Overlayed */
       CN_PP30MASTER   = 200,  /* PowerPacker 3.0 Master */
       CN_PP30MASTERE  = 201,  /* PowerPacker 3.0 Master Encrypted */
       CN_PP30MASTEROV = 202   /* PowerPacker 3.0 Master Overlayed */
