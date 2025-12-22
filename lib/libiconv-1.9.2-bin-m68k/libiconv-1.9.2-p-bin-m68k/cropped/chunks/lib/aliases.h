/* ANSI-C code produced by gperf version 3.0.2 */
/* Command-line: gperf -m 10 aliases.gperf  */
/* Computed positions: -k'1-2,4-11,$' */

#if !((' ' == 32) && ('!' == 33) && ('"' == 34) && ('#' == 35) \
      && ('%' == 37) && ('&' == 38) && ('\'' == 39) && ('(' == 40) \
      && (')' == 41) && ('*' == 42) && ('+' == 43) && (',' == 44) \
      && ('-' == 45) && ('.' == 46) && ('/' == 47) && ('0' == 48) \
      && ('1' == 49) && ('2' == 50) && ('3' == 51) && ('4' == 52) \
      && ('5' == 53) && ('6' == 54) && ('7' == 55) && ('8' == 56) \
      && ('9' == 57) && (':' == 58) && (';' == 59) && ('<' == 60) \
      && ('=' == 61) && ('>' == 62) && ('?' == 63) && ('A' == 65) \
      && ('B' == 66) && ('C' == 67) && ('D' == 68) && ('E' == 69) \
      && ('F' == 70) && ('G' == 71) && ('H' == 72) && ('I' == 73) \
      && ('J' == 74) && ('K' == 75) && ('L' == 76) && ('M' == 77) \
      && ('N' == 78) && ('O' == 79) && ('P' == 80) && ('Q' == 81) \
      && ('R' == 82) && ('S' == 83) && ('T' == 84) && ('U' == 85) \
      && ('V' == 86) && ('W' == 87) && ('X' == 88) && ('Y' == 89) \
      && ('Z' == 90) && ('[' == 91) && ('\\' == 92) && (']' == 93) \
      && ('^' == 94) && ('_' == 95) && ('a' == 97) && ('b' == 98) \
      && ('c' == 99) && ('d' == 100) && ('e' == 101) && ('f' == 102) \
      && ('g' == 103) && ('h' == 104) && ('i' == 105) && ('j' == 106) \
      && ('k' == 107) && ('l' == 108) && ('m' == 109) && ('n' == 110) \
      && ('o' == 111) && ('p' == 112) && ('q' == 113) && ('r' == 114) \
      && ('s' == 115) && ('t' == 116) && ('u' == 117) && ('v' == 118) \
      && ('w' == 119) && ('x' == 120) && ('y' == 121) && ('z' == 122) \
      && ('{' == 123) && ('|' == 124) && ('}' == 125) && ('~' == 126))
/* The character set is not based on ISO-646.  */
#error "gperf generated tables don't work with this execution character set. Please report a bug to <bug-gnu-gperf@gnu.org>."
#endif

#line 1 "aliases.gperf"
struct alias { int name; unsigned int encoding_index; };

#define TOTAL_KEYWORDS 239
#define MIN_WORD_LENGTH 2
#define MAX_WORD_LENGTH 19
#define MIN_HASH_VALUE 5
#define MAX_HASH_VALUE 597
/* maximum key range = 593, duplicates = 0 */

#ifdef __GNUC__
__inline
#else
#ifdef __cplusplus
inline
#endif
#endif
static unsigned int
aliases_hash (register const char *str, register unsigned int len)
{
  static const unsigned short asso_values[] =
    {
      598, 598, 598, 598, 598, 598, 598, 598, 598, 598,
      598, 598, 598, 598, 598, 598, 598, 598, 598, 598,
      598, 598, 598, 598, 598, 598, 598, 598, 598, 598,
      598, 598, 598, 598, 598, 598, 598, 598, 598, 598,
      598, 598, 598, 598, 598,   0,   8, 598,  24,   2,
       35,  44,   9,  12,   4,  77,  15,   0, 202, 598,
      598, 598, 598, 598, 598,   0, 175,   2,   0,  61,
      598,  21,  37,   0,   3,  52,  96,  51,  34,  84,
       36, 598,   3,   9,  52, 142,   2,  83,   8,  16,
      598, 598, 598, 598, 598,   1, 598, 598, 598, 598,
      598, 598, 598, 598, 598, 598, 598, 598, 598, 598,
      598, 598, 598, 598, 598, 598, 598, 598, 598, 598,
      598, 598, 598, 598, 598, 598, 598, 598
    };
  register int hval = len;

  switch (hval)
    {
      default:
        hval += asso_values[(unsigned char)str[10]];
      /*FALLTHROUGH*/
      case 10:
        hval += asso_values[(unsigned char)str[9]];
      /*FALLTHROUGH*/
      case 9:
        hval += asso_values[(unsigned char)str[8]];
      /*FALLTHROUGH*/
      case 8:
        hval += asso_values[(unsigned char)str[7]];
      /*FALLTHROUGH*/
      case 7:
        hval += asso_values[(unsigned char)str[6]];
      /*FALLTHROUGH*/
      case 6:
        hval += asso_values[(unsigned char)str[5]];
      /*FALLTHROUGH*/
      case 5:
        hval += asso_values[(unsigned char)str[4]];
      /*FALLTHROUGH*/
      case 4:
        hval += asso_values[(unsigned char)str[3]];
      /*FALLTHROUGH*/
      case 3:
      case 2:
        hval += asso_values[(unsigned char)str[1]];
      /*FALLTHROUGH*/
      case 1:
        hval += asso_values[(unsigned char)str[0]];
        break;
    }
  return hval + asso_values[(unsigned char)str[len - 1]];
}

struct stringpool_t
  {
    char stringpool_str5[sizeof("C99")];
    char stringpool_str7[sizeof("JAVA")];
    char stringpool_str10[sizeof("VISCII")];
    char stringpool_str14[sizeof("ASCII")];
    char stringpool_str24[sizeof("ISO-IR-199")];
    char stringpool_str26[sizeof("866")];
    char stringpool_str28[sizeof("ISO-IR-6")];
    char stringpool_str29[sizeof("CSASCII")];
    char stringpool_str30[sizeof("CSVISCII")];
    char stringpool_str31[sizeof("VISCII1.1-1")];
    char stringpool_str35[sizeof("R8")];
    char stringpool_str36[sizeof("ISO-IR-166")];
    char stringpool_str45[sizeof("CP819")];
    char stringpool_str46[sizeof("CSUCS4")];
    char stringpool_str48[sizeof("ISO-IR-109")];
    char stringpool_str49[sizeof("CHAR")];
    char stringpool_str51[sizeof("ISO-IR-144")];
    char stringpool_str52[sizeof("ISO-IR-101")];
    char stringpool_str53[sizeof("ARMSCII-8")];
    char stringpool_str54[sizeof("850")];
    char stringpool_str55[sizeof("CP866")];
    char stringpool_str56[sizeof("MAC")];
    char stringpool_str57[sizeof("862")];
    char stringpool_str58[sizeof("ISO_646.IRV:1991")];
    char stringpool_str60[sizeof("ISO8859-9")];
    char stringpool_str61[sizeof("ISO-8859-9")];
    char stringpool_str62[sizeof("ISO_8859-9")];
    char stringpool_str63[sizeof("ISO-IR-148")];
    char stringpool_str64[sizeof("ISO8859-1")];
    char stringpool_str65[sizeof("ISO-8859-1")];
    char stringpool_str66[sizeof("ISO_8859-1")];
    char stringpool_str67[sizeof("ISO-IR-126")];
    char stringpool_str68[sizeof("ISO8859-6")];
    char stringpool_str69[sizeof("ISO-8859-6")];
    char stringpool_str70[sizeof("ISO_8859-6")];
    char stringpool_str71[sizeof("ISO8859-16")];
    char stringpool_str72[sizeof("ISO-8859-16")];
    char stringpool_str73[sizeof("ISO_8859-16")];
    char stringpool_str74[sizeof("ISO-IR-110")];
    char stringpool_str76[sizeof("ISO_8859-16:2001")];
    char stringpool_str78[sizeof("ISO8859-4")];
    char stringpool_str79[sizeof("ISO-8859-4")];
    char stringpool_str80[sizeof("ISO_8859-4")];
    char stringpool_str81[sizeof("ISO8859-14")];
    char stringpool_str82[sizeof("ISO-8859-14")];
    char stringpool_str83[sizeof("ISO_8859-14")];
    char stringpool_str84[sizeof("ISO8859-5")];
    char stringpool_str85[sizeof("ISO-8859-5")];
    char stringpool_str86[sizeof("ISO_8859-5")];
    char stringpool_str87[sizeof("ISO8859-15")];
    char stringpool_str88[sizeof("ISO-8859-15")];
    char stringpool_str89[sizeof("ISO_8859-15")];
    char stringpool_str90[sizeof("ISO8859-8")];
    char stringpool_str91[sizeof("ISO-8859-8")];
    char stringpool_str92[sizeof("ISO_8859-8")];
    char stringpool_str93[sizeof("ECMA-114")];
    char stringpool_str94[sizeof("ISO_8859-14:1998")];
    char stringpool_str95[sizeof("CP1251")];
    char stringpool_str96[sizeof("ISO-IR-100")];
    char stringpool_str97[sizeof("ISO_8859-15:1998")];
    char stringpool_str98[sizeof("ISO-IR-138")];
    char stringpool_str99[sizeof("CP1256")];
    char stringpool_str100[sizeof("ISO-IR-226")];
    char stringpool_str101[sizeof("ISO-IR-179")];
    char stringpool_str102[sizeof("L1")];
    char stringpool_str103[sizeof("CP850")];
    char stringpool_str105[sizeof("ECMA-118")];
    char stringpool_str106[sizeof("L6")];
    char stringpool_str109[sizeof("CP1254")];
    char stringpool_str110[sizeof("MS-ANSI")];
    char stringpool_str111[sizeof("ISO8859-10")];
    char stringpool_str112[sizeof("ISO-8859-10")];
    char stringpool_str113[sizeof("ISO_8859-10")];
    char stringpool_str115[sizeof("CP1255")];
    char stringpool_str116[sizeof("L4")];
    char stringpool_str117[sizeof("CP862")];
    char stringpool_str121[sizeof("CP1258")];
    char stringpool_str122[sizeof("L5")];
    char stringpool_str123[sizeof("CSKOI8R")];
    char stringpool_str124[sizeof("ANSI_X3.4-1986")];
    char stringpool_str125[sizeof("L10")];
    char stringpool_str126[sizeof("TCVN")];
    char stringpool_str128[sizeof("L8")];
    char stringpool_str129[sizeof("ISO_8859-10:1992")];
    char stringpool_str130[sizeof("ISO8859-2")];
    char stringpool_str131[sizeof("ISO-8859-2")];
    char stringpool_str132[sizeof("ISO_8859-2")];
    char stringpool_str135[sizeof("ANSI_X3.4-1968")];
    char stringpool_str137[sizeof("LATIN-9")];
    char stringpool_str138[sizeof("CP874")];
    char stringpool_str139[sizeof("CP1250")];
    char stringpool_str140[sizeof("LATIN1")];
    char stringpool_str144[sizeof("LATIN6")];
    char stringpool_str145[sizeof("TIS620")];
    char stringpool_str146[sizeof("TIS-620")];
    char stringpool_str147[sizeof("MACTHAI")];
    char stringpool_str148[sizeof("ISO8859-3")];
    char stringpool_str149[sizeof("ISO-8859-3")];
    char stringpool_str150[sizeof("ISO_8859-3")];
    char stringpool_str151[sizeof("ISO8859-13")];
    char stringpool_str152[sizeof("ISO-8859-13")];
    char stringpool_str153[sizeof("ISO_8859-13")];
    char stringpool_str154[sizeof("LATIN4")];
    char stringpool_str157[sizeof("ROMAN8")];
    char stringpool_str160[sizeof("LATIN5")];
    char stringpool_str161[sizeof("CP1252")];
    char stringpool_str162[sizeof("US")];
    char stringpool_str163[sizeof("KOI8-R")];
    char stringpool_str166[sizeof("LATIN8")];
    char stringpool_str167[sizeof("UCS-4")];
    char stringpool_str168[sizeof("L2")];
    char stringpool_str169[sizeof("ISO-IR-203")];
    char stringpool_str170[sizeof("US-ASCII")];
    char stringpool_str171[sizeof("TIS620-0")];
    char stringpool_str173[sizeof("GREEK8")];
    char stringpool_str174[sizeof("GEORGIAN-ACADEMY")];
    char stringpool_str178[sizeof("CP1133")];
    char stringpool_str179[sizeof("CP1253")];
    char stringpool_str186[sizeof("L3")];
    char stringpool_str187[sizeof("LATIN10")];
    char stringpool_str188[sizeof("ARABIC")];
    char stringpool_str190[sizeof("ISO-IR-157")];
    char stringpool_str194[sizeof("GREEK")];
    char stringpool_str195[sizeof("ISO646-US")];
    char stringpool_str198[sizeof("IBM819")];
    char stringpool_str200[sizeof("WCHAR_T")];
    char stringpool_str201[sizeof("CP367")];
    char stringpool_str205[sizeof("GEORGIAN-PS")];
    char stringpool_str206[sizeof("LATIN2")];
    char stringpool_str208[sizeof("IBM866")];
    char stringpool_str209[sizeof("CSUNICODE11")];
    char stringpool_str210[sizeof("UTF-16")];
    char stringpool_str213[sizeof("ISO-IR-127")];
    char stringpool_str214[sizeof("ISO8859-7")];
    char stringpool_str215[sizeof("ISO-8859-7")];
    char stringpool_str216[sizeof("ISO_8859-7")];
    char stringpool_str218[sizeof("ISO-10646-UCS-4")];
    char stringpool_str219[sizeof("UCS-2")];
    char stringpool_str220[sizeof("TIS620.2529-1")];
    char stringpool_str222[sizeof("CYRILLIC")];
    char stringpool_str224[sizeof("LATIN3")];
    char stringpool_str228[sizeof("TCVN5712-1")];
    char stringpool_str229[sizeof("UTF-8")];
    char stringpool_str232[sizeof("ASMO-708")];
    char stringpool_str233[sizeof("MACROMANIA")];
    char stringpool_str234[sizeof("ISO-CELTIC")];
    char stringpool_str242[sizeof("MACARABIC")];
    char stringpool_str244[sizeof("ISO-10646-UCS-2")];
    char stringpool_str245[sizeof("CP1257")];
    char stringpool_str248[sizeof("MS-EE")];
    char stringpool_str252[sizeof("L7")];
    char stringpool_str254[sizeof("MACICELAND")];
    char stringpool_str256[sizeof("IBM850")];
    char stringpool_str258[sizeof("TCVN-5712")];
    char stringpool_str259[sizeof("CSHPROMAN8")];
    char stringpool_str261[sizeof("KOI8-T")];
    char stringpool_str262[sizeof("CSUNICODE")];
    char stringpool_str265[sizeof("MACROMAN")];
    char stringpool_str269[sizeof("ISO_8859-9:1989")];
    char stringpool_str270[sizeof("IBM862")];
    char stringpool_str271[sizeof("MACCROATIAN")];
    char stringpool_str272[sizeof("CSIBM866")];
    char stringpool_str273[sizeof("TIS620.2533-1")];
    char stringpool_str277[sizeof("CSMACINTOSH")];
    char stringpool_str279[sizeof("MACCYRILLIC")];
    char stringpool_str280[sizeof("MS-CYRL")];
    char stringpool_str283[sizeof("ELOT_928")];
    char stringpool_str284[sizeof("HP-ROMAN8")];
    char stringpool_str288[sizeof("CSUNICODE11UTF7")];
    char stringpool_str290[sizeof("LATIN7")];
    char stringpool_str293[sizeof("ISO_8859-4:1988")];
    char stringpool_str295[sizeof("TIS620.2533-0")];
    char stringpool_str296[sizeof("ISO_8859-5:1988")];
    char stringpool_str299[sizeof("ISO_8859-8:1988")];
    char stringpool_str301[sizeof("CSISOLATIN1")];
    char stringpool_str304[sizeof("CSISOLATINARABIC")];
    char stringpool_str305[sizeof("CSISOLATIN6")];
    char stringpool_str308[sizeof("CSISOLATINCYRILLIC")];
    char stringpool_str309[sizeof("MACGREEK")];
    char stringpool_str313[sizeof("MACINTOSH")];
    char stringpool_str314[sizeof("UTF-32")];
    char stringpool_str315[sizeof("CSISOLATIN4")];
    char stringpool_str316[sizeof("CSPC862LATINHEBREW")];
    char stringpool_str318[sizeof("MS-GREEK")];
    char stringpool_str321[sizeof("CSISOLATIN5")];
    char stringpool_str322[sizeof("WINDOWS-1251")];
    char stringpool_str324[sizeof("WINDOWS-1256")];
    char stringpool_str328[sizeof("ISO_8859-3:1988")];
    char stringpool_str329[sizeof("WINDOWS-1254")];
    char stringpool_str330[sizeof("UCS-4-SWAPPED")];
    char stringpool_str332[sizeof("WINDOWS-1255")];
    char stringpool_str334[sizeof("HEBREW")];
    char stringpool_str335[sizeof("WINDOWS-1258")];
    char stringpool_str340[sizeof("UNICODE-1-1")];
    char stringpool_str344[sizeof("WINDOWS-1250")];
    char stringpool_str346[sizeof("MS-HEBR")];
    char stringpool_str348[sizeof("ISO_8859-1:1987")];
    char stringpool_str349[sizeof("NEXTSTEP")];
    char stringpool_str350[sizeof("ISO_8859-6:1987")];
    char stringpool_str353[sizeof("UTF-7")];
    char stringpool_str355[sizeof("WINDOWS-1252")];
    char stringpool_str356[sizeof("UCS-2-SWAPPED")];
    char stringpool_str359[sizeof("IBM-CP1133")];
    char stringpool_str364[sizeof("WINDOWS-1253")];
    char stringpool_str367[sizeof("CSISOLATIN2")];
    char stringpool_str368[sizeof("MS-TURK")];
    char stringpool_str374[sizeof("CSISOLATINGREEK")];
    char stringpool_str378[sizeof("UCS-4LE")];
    char stringpool_str380[sizeof("WINDOWS-874")];
    char stringpool_str381[sizeof("ISO_8859-2:1987")];
    char stringpool_str383[sizeof("IBM367")];
    char stringpool_str385[sizeof("CSISOLATIN3")];
    char stringpool_str393[sizeof("MACTURKISH")];
    char stringpool_str397[sizeof("WINDOWS-1257")];
    char stringpool_str404[sizeof("UCS-2LE")];
    char stringpool_str413[sizeof("UCS-4-INTERNAL")];
    char stringpool_str414[sizeof("MACUKRAINE")];
    char stringpool_str420[sizeof("MS-ARAB")];
    char stringpool_str421[sizeof("UNICODE-1-1-UTF-7")];
    char stringpool_str422[sizeof("CSISOLATINHEBREW")];
    char stringpool_str423[sizeof("ISO_8859-7:1987")];
    char stringpool_str426[sizeof("UTF-16LE")];
    char stringpool_str437[sizeof("MACCENTRALEUROPE")];
    char stringpool_str439[sizeof("UCS-2-INTERNAL")];
    char stringpool_str441[sizeof("KOI8-U")];
    char stringpool_str442[sizeof("JOHAB")];
    char stringpool_str445[sizeof("KOI8-RU")];
    char stringpool_str447[sizeof("MULELAO-1")];
    char stringpool_str457[sizeof("UCS-4BE")];
    char stringpool_str477[sizeof("TCVN5712-1:1993")];
    char stringpool_str483[sizeof("UCS-2BE")];
    char stringpool_str499[sizeof("UTF-32LE")];
    char stringpool_str505[sizeof("UTF-16BE")];
    char stringpool_str520[sizeof("CSPC850MULTILINGUAL")];
    char stringpool_str521[sizeof("WINBALTRIM")];
    char stringpool_str550[sizeof("UNICODEBIG")];
    char stringpool_str563[sizeof("MACHEBREW")];
    char stringpool_str578[sizeof("UTF-32BE")];
    char stringpool_str597[sizeof("UNICODELITTLE")];
  };
static const struct stringpool_t stringpool_contents =
  {
    "C99",
    "JAVA",
    "VISCII",
    "ASCII",
    "ISO-IR-199",
    "866",
    "ISO-IR-6",
    "CSASCII",
    "CSVISCII",
    "VISCII1.1-1",
    "R8",
    "ISO-IR-166",
    "CP819",
    "CSUCS4",
    "ISO-IR-109",
    "CHAR",
    "ISO-IR-144",
    "ISO-IR-101",
    "ARMSCII-8",
    "850",
    "CP866",
    "MAC",
    "862",
    "ISO_646.IRV:1991",
    "ISO8859-9",
    "ISO-8859-9",
    "ISO_8859-9",
    "ISO-IR-148",
    "ISO8859-1",
    "ISO-8859-1",
    "ISO_8859-1",
    "ISO-IR-126",
    "ISO8859-6",
    "ISO-8859-6",
    "ISO_8859-6",
    "ISO8859-16",
    "ISO-8859-16",
    "ISO_8859-16",
    "ISO-IR-110",
    "ISO_8859-16:2001",
    "ISO8859-4",
    "ISO-8859-4",
    "ISO_8859-4",
    "ISO8859-14",
    "ISO-8859-14",
    "ISO_8859-14",
    "ISO8859-5",
    "ISO-8859-5",
    "ISO_8859-5",
    "ISO8859-15",
    "ISO-8859-15",
    "ISO_8859-15",
    "ISO8859-8",
    "ISO-8859-8",
    "ISO_8859-8",
    "ECMA-114",
    "ISO_8859-14:1998",
    "CP1251",
    "ISO-IR-100",
    "ISO_8859-15:1998",
    "ISO-IR-138",
    "CP1256",
    "ISO-IR-226",
    "ISO-IR-179",
    "L1",
    "CP850",
    "ECMA-118",
    "L6",
    "CP1254",
    "MS-ANSI",
    "ISO8859-10",
    "ISO-8859-10",
    "ISO_8859-10",
    "CP1255",
    "L4",
    "CP862",
    "CP1258",
    "L5",
    "CSKOI8R",
    "ANSI_X3.4-1986",
    "L10",
    "TCVN",
    "L8",
    "ISO_8859-10:1992",
    "ISO8859-2",
    "ISO-8859-2",
    "ISO_8859-2",
    "ANSI_X3.4-1968",
    "LATIN-9",
    "CP874",
    "CP1250",
    "LATIN1",
    "LATIN6",
    "TIS620",
    "TIS-620",
    "MACTHAI",
    "ISO8859-3",
    "ISO-8859-3",
    "ISO_8859-3",
    "ISO8859-13",
    "ISO-8859-13",
    "ISO_8859-13",
    "LATIN4",
    "ROMAN8",
    "LATIN5",
    "CP1252",
    "US",
    "KOI8-R",
    "LATIN8",
    "UCS-4",
    "L2",
    "ISO-IR-203",
    "US-ASCII",
    "TIS620-0",
    "GREEK8",
    "GEORGIAN-ACADEMY",
    "CP1133",
    "CP1253",
    "L3",
    "LATIN10",
    "ARABIC",
    "ISO-IR-157",
    "GREEK",
    "ISO646-US",
    "IBM819",
    "WCHAR_T",
    "CP367",
    "GEORGIAN-PS",
    "LATIN2",
    "IBM866",
    "CSUNICODE11",
    "UTF-16",
    "ISO-IR-127",
    "ISO8859-7",
    "ISO-8859-7",
    "ISO_8859-7",
    "ISO-10646-UCS-4",
    "UCS-2",
    "TIS620.2529-1",
    "CYRILLIC",
    "LATIN3",
    "TCVN5712-1",
    "UTF-8",
    "ASMO-708",
    "MACROMANIA",
    "ISO-CELTIC",
    "MACARABIC",
    "ISO-10646-UCS-2",
    "CP1257",
    "MS-EE",
    "L7",
    "MACICELAND",
    "IBM850",
    "TCVN-5712",
    "CSHPROMAN8",
    "KOI8-T",
    "CSUNICODE",
    "MACROMAN",
    "ISO_8859-9:1989",
    "IBM862",
    "MACCROATIAN",
    "CSIBM866",
    "TIS620.2533-1",
    "CSMACINTOSH",
    "MACCYRILLIC",
    "MS-CYRL",
    "ELOT_928",
    "HP-ROMAN8",
    "CSUNICODE11UTF7",
    "LATIN7",
    "ISO_8859-4:1988",
    "TIS620.2533-0",
    "ISO_8859-5:1988",
    "ISO_8859-8:1988",
    "CSISOLATIN1",
    "CSISOLATINARABIC",
    "CSISOLATIN6",
    "CSISOLATINCYRILLIC",
    "MACGREEK",
    "MACINTOSH",
    "UTF-32",
    "CSISOLATIN4",
    "CSPC862LATINHEBREW",
    "MS-GREEK",
    "CSISOLATIN5",
    "WINDOWS-1251",
    "WINDOWS-1256",
    "ISO_8859-3:1988",
    "WINDOWS-1254",
    "UCS-4-SWAPPED",
    "WINDOWS-1255",
    "HEBREW",
    "WINDOWS-1258",
    "UNICODE-1-1",
    "WINDOWS-1250",
    "MS-HEBR",
    "ISO_8859-1:1987",
    "NEXTSTEP",
    "ISO_8859-6:1987",
    "UTF-7",
    "WINDOWS-1252",
    "UCS-2-SWAPPED",
    "IBM-CP1133",
    "WINDOWS-1253",
    "CSISOLATIN2",
    "MS-TURK",
    "CSISOLATINGREEK",
    "UCS-4LE",
    "WINDOWS-874",
    "ISO_8859-2:1987",
    "IBM367",
    "CSISOLATIN3",
    "MACTURKISH",
    "WINDOWS-1257",
    "UCS-2LE",
    "UCS-4-INTERNAL",
    "MACUKRAINE",
    "MS-ARAB",
    "UNICODE-1-1-UTF-7",
    "CSISOLATINHEBREW",
    "ISO_8859-7:1987",
    "UTF-16LE",
    "MACCENTRALEUROPE",
    "UCS-2-INTERNAL",
    "KOI8-U",
    "JOHAB",
    "KOI8-RU",
    "MULELAO-1",
    "UCS-4BE",
    "TCVN5712-1:1993",
    "UCS-2BE",
    "UTF-32LE",
    "UTF-16BE",
    "CSPC850MULTILINGUAL",
    "WINBALTRIM",
    "UNICODEBIG",
    "MACHEBREW",
    "UTF-32BE",
    "UNICODELITTLE"
  };
#define stringpool ((const char *) &stringpool_contents)

static const struct alias aliases[] =
  {
    {-1}, {-1}, {-1}, {-1}, {-1},
#line 51 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str5, ei_c99},
    {-1},
#line 52 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str7, ei_java},
    {-1}, {-1},
#line 241 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str10, ei_viscii},
    {-1}, {-1}, {-1},
#line 13 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str14, ei_ascii},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 145 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str24, ei_iso8859_14},
    {-1},
#line 203 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str26, ei_cp866},
    {-1},
#line 16 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str28, ei_ascii},
#line 22 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str29, ei_ascii},
#line 243 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str30, ei_viscii},
#line 242 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str31, ei_viscii},
    {-1}, {-1}, {-1},
#line 222 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str35, ei_hp_roman8},
#line 238 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str36, ei_tis620},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 57 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str45, ei_iso8859_1},
#line 35 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str46, ei_ucs4},
    {-1},
#line 74 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str48, ei_iso8859_3},
#line 249 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str49, ei_local_char},
    {-1},
#line 90 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str51, ei_iso8859_5},
#line 66 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str52, ei_iso8859_2},
#line 225 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str53, ei_armscii_8},
#line 195 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str54, ei_cp850},
#line 201 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str55, ei_cp866},
#line 207 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str56, ei_mac_roman},
#line 199 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str57, ei_cp862},
#line 15 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str58, ei_ascii},
    {-1},
#line 127 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str60, ei_iso8859_9},
#line 120 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str61, ei_iso8859_9},
#line 121 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str62, ei_iso8859_9},
#line 123 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str63, ei_iso8859_9},
#line 62 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str64, ei_iso8859_1},
#line 53 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str65, ei_iso8859_1},
#line 54 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str66, ei_iso8859_1},
#line 106 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str67, ei_iso8859_7},
#line 102 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str68, ei_iso8859_6},
#line 94 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str69, ei_iso8859_6},
#line 95 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str70, ei_iso8859_6},
#line 162 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str71, ei_iso8859_16},
#line 156 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str72, ei_iso8859_16},
#line 157 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str73, ei_iso8859_16},
#line 82 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str74, ei_iso8859_4},
    {-1},
#line 158 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str76, ei_iso8859_16},
    {-1},
#line 86 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str78, ei_iso8859_4},
#line 79 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str79, ei_iso8859_4},
#line 80 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str80, ei_iso8859_4},
#line 149 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str81, ei_iso8859_14},
#line 142 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str82, ei_iso8859_14},
#line 143 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str83, ei_iso8859_14},
#line 93 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str84, ei_iso8859_5},
#line 87 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str85, ei_iso8859_5},
#line 88 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str86, ei_iso8859_5},
#line 155 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str87, ei_iso8859_15},
#line 150 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str88, ei_iso8859_15},
#line 151 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str89, ei_iso8859_15},
#line 119 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str90, ei_iso8859_8},
#line 113 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str91, ei_iso8859_8},
#line 114 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str92, ei_iso8859_8},
#line 98 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str93, ei_iso8859_6},
#line 144 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str94, ei_iso8859_14},
#line 170 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str95, ei_cp1251},
#line 56 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str96, ei_iso8859_1},
#line 152 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str97, ei_iso8859_15},
#line 116 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str98, ei_iso8859_8},
#line 185 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str99, ei_cp1256},
#line 159 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str100, ei_iso8859_16},
#line 138 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str101, ei_iso8859_13},
#line 60 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str102, ei_iso8859_1},
#line 193 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str103, ei_cp850},
    {-1},
#line 107 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str105, ei_iso8859_7},
#line 133 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str106, ei_iso8859_10},
    {-1}, {-1},
#line 179 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str109, ei_cp1254},
#line 175 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str110, ei_cp1252},
#line 135 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str111, ei_iso8859_10},
#line 128 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str112, ei_iso8859_10},
#line 129 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str113, ei_iso8859_10},
    {-1},
#line 182 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str115, ei_cp1255},
#line 84 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str116, ei_iso8859_4},
#line 197 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str117, ei_cp862},
    {-1}, {-1}, {-1},
#line 191 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str121, ei_cp1258},
#line 125 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str122, ei_iso8859_9},
#line 164 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str123, ei_koi8_r},
#line 18 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str124, ei_ascii},
#line 161 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str125, ei_iso8859_16},
#line 244 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str126, ei_tcvn},
    {-1},
#line 147 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str128, ei_iso8859_14},
#line 130 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str129, ei_iso8859_10},
#line 70 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str130, ei_iso8859_2},
#line 63 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str131, ei_iso8859_2},
#line 64 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str132, ei_iso8859_2},
    {-1}, {-1},
#line 17 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str135, ei_ascii},
    {-1},
#line 154 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str137, ei_iso8859_15},
#line 239 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str138, ei_cp874},
#line 167 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str139, ei_cp1250},
#line 59 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str140, ei_iso8859_1},
    {-1}, {-1}, {-1},
#line 132 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str144, ei_iso8859_10},
#line 233 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str145, ei_tis620},
#line 232 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str146, ei_tis620},
#line 219 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str147, ei_mac_thai},
#line 78 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str148, ei_iso8859_3},
#line 71 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str149, ei_iso8859_3},
#line 72 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str150, ei_iso8859_3},
#line 141 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str151, ei_iso8859_13},
#line 136 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str152, ei_iso8859_13},
#line 137 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str153, ei_iso8859_13},
#line 83 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str154, ei_iso8859_4},
    {-1}, {-1},
#line 221 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str157, ei_hp_roman8},
    {-1}, {-1},
#line 124 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str160, ei_iso8859_9},
#line 173 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str161, ei_cp1252},
#line 21 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str162, ei_ascii},
#line 163 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str163, ei_koi8_r},
    {-1}, {-1},
#line 146 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str166, ei_iso8859_14},
#line 33 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str167, ei_ucs4},
#line 68 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str168, ei_iso8859_2},
#line 153 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str169, ei_iso8859_15},
#line 12 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str170, ei_ascii},
#line 234 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str171, ei_tis620},
    {-1},
#line 109 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str173, ei_iso8859_7},
#line 226 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str174, ei_georgian_academy},
    {-1}, {-1}, {-1},
#line 230 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str178, ei_cp1133},
#line 176 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str179, ei_cp1253},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 76 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str186, ei_iso8859_3},
#line 160 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str187, ei_iso8859_16},
#line 100 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str188, ei_iso8859_6},
    {-1},
#line 131 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str190, ei_iso8859_10},
    {-1}, {-1}, {-1},
#line 110 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str194, ei_iso8859_7},
#line 14 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str195, ei_ascii},
    {-1}, {-1},
#line 58 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str198, ei_iso8859_1},
    {-1},
#line 250 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str200, ei_local_wchar_t},
#line 19 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str201, ei_ascii},
    {-1}, {-1}, {-1},
#line 227 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str205, ei_georgian_ps},
#line 67 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str206, ei_iso8859_2},
    {-1},
#line 202 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str208, ei_cp866},
#line 30 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str209, ei_ucs2be},
#line 38 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str210, ei_utf16},
    {-1}, {-1},
#line 97 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str213, ei_iso8859_6},
#line 112 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str214, ei_iso8859_7},
#line 103 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str215, ei_iso8859_7},
#line 104 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str216, ei_iso8859_7},
    {-1},
#line 34 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str218, ei_ucs4},
#line 24 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str219, ei_ucs2},
#line 235 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str220, ei_tis620},
    {-1},
#line 91 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str222, ei_iso8859_5},
    {-1},
#line 75 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str224, ei_iso8859_3},
    {-1}, {-1}, {-1},
#line 246 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str228, ei_tcvn},
#line 23 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str229, ei_utf8},
    {-1}, {-1},
#line 99 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str232, ei_iso8859_6},
#line 212 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str233, ei_mac_romania},
#line 148 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str234, ei_iso8859_14},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 218 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str242, ei_mac_arabic},
    {-1},
#line 25 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str244, ei_ucs2},
#line 188 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str245, ei_cp1257},
    {-1}, {-1},
#line 169 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str248, ei_cp1250},
    {-1}, {-1}, {-1},
#line 140 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str252, ei_iso8859_13},
    {-1},
#line 210 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str254, ei_mac_iceland},
    {-1},
#line 194 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str256, ei_cp850},
    {-1},
#line 245 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str258, ei_tcvn},
#line 223 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str259, ei_hp_roman8},
    {-1},
#line 228 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str261, ei_koi8_t},
#line 26 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str262, ei_ucs2},
    {-1}, {-1},
#line 205 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str265, ei_mac_roman},
    {-1}, {-1}, {-1},
#line 122 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str269, ei_iso8859_9},
#line 198 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str270, ei_cp862},
#line 211 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str271, ei_mac_croatian},
#line 204 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str272, ei_cp866},
#line 237 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str273, ei_tis620},
    {-1}, {-1}, {-1},
#line 208 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str277, ei_mac_roman},
    {-1},
#line 213 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str279, ei_mac_cyrillic},
#line 172 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str280, ei_cp1251},
    {-1}, {-1},
#line 108 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str283, ei_iso8859_7},
#line 220 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str284, ei_hp_roman8},
    {-1}, {-1}, {-1},
#line 46 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str288, ei_utf7},
    {-1},
#line 139 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str290, ei_iso8859_13},
    {-1}, {-1},
#line 81 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str293, ei_iso8859_4},
    {-1},
#line 236 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str295, ei_tis620},
#line 89 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str296, ei_iso8859_5},
    {-1}, {-1},
#line 115 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str299, ei_iso8859_8},
    {-1},
#line 61 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str301, ei_iso8859_1},
    {-1}, {-1},
#line 101 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str304, ei_iso8859_6},
#line 134 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str305, ei_iso8859_10},
    {-1}, {-1},
#line 92 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str308, ei_iso8859_5},
#line 215 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str309, ei_mac_greek},
    {-1}, {-1}, {-1},
#line 206 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str313, ei_mac_roman},
#line 41 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str314, ei_utf32},
#line 85 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str315, ei_iso8859_4},
#line 200 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str316, ei_cp862},
    {-1},
#line 178 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str318, ei_cp1253},
    {-1}, {-1},
#line 126 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str321, ei_iso8859_9},
#line 171 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str322, ei_cp1251},
    {-1},
#line 186 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str324, ei_cp1256},
    {-1}, {-1}, {-1},
#line 73 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str328, ei_iso8859_3},
#line 180 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str329, ei_cp1254},
#line 50 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str330, ei_ucs4swapped},
    {-1},
#line 183 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str332, ei_cp1255},
    {-1},
#line 117 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str334, ei_iso8859_8},
#line 192 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str335, ei_cp1258},
    {-1}, {-1}, {-1}, {-1},
#line 29 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str340, ei_ucs2be},
    {-1}, {-1}, {-1},
#line 168 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str344, ei_cp1250},
    {-1},
#line 184 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str346, ei_cp1255},
    {-1},
#line 55 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str348, ei_iso8859_1},
#line 224 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str349, ei_nextstep},
#line 96 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str350, ei_iso8859_6},
    {-1}, {-1},
#line 44 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str353, ei_utf7},
    {-1},
#line 174 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str355, ei_cp1252},
#line 48 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str356, ei_ucs2swapped},
    {-1}, {-1},
#line 231 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str359, ei_cp1133},
    {-1}, {-1}, {-1}, {-1},
#line 177 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str364, ei_cp1253},
    {-1}, {-1},
#line 69 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str367, ei_iso8859_2},
#line 181 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str368, ei_cp1254},
    {-1}, {-1}, {-1}, {-1}, {-1},
#line 111 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str374, ei_iso8859_7},
    {-1}, {-1}, {-1},
#line 37 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str378, ei_ucs4le},
    {-1},
#line 240 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str380, ei_cp874},
#line 65 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str381, ei_iso8859_2},
    {-1},
#line 20 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str383, ei_ascii},
    {-1},
#line 77 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str385, ei_iso8859_3},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 216 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str393, ei_mac_turkish},
    {-1}, {-1}, {-1},
#line 189 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str397, ei_cp1257},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 31 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str404, ei_ucs2le},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 49 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str413, ei_ucs4internal},
#line 214 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str414, ei_mac_ukraine},
    {-1}, {-1}, {-1}, {-1}, {-1},
#line 187 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str420, ei_cp1256},
#line 45 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str421, ei_utf7},
#line 118 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str422, ei_iso8859_8},
#line 105 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str423, ei_iso8859_7},
    {-1}, {-1},
#line 40 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str426, ei_utf16le},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1},
#line 209 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str437, ei_mac_centraleurope},
    {-1},
#line 47 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str439, ei_ucs2internal},
    {-1},
#line 165 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str441, ei_koi8_u},
#line 248 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str442, ei_johab},
    {-1}, {-1},
#line 166 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str445, ei_koi8_ru},
    {-1},
#line 229 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str447, ei_mulelao},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 36 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str457, ei_ucs4be},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1},
#line 247 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str477, ei_tcvn},
    {-1}, {-1}, {-1}, {-1}, {-1},
#line 27 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str483, ei_ucs2be},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 43 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str499, ei_utf32le},
    {-1}, {-1}, {-1}, {-1}, {-1},
#line 39 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str505, ei_utf16be},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1}, {-1}, {-1}, {-1}, {-1},
#line 196 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str520, ei_cp850},
#line 190 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str521, ei_cp1257},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1},
#line 28 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str550, ei_ucs2be},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1}, {-1}, {-1},
#line 217 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str563, ei_mac_hebrew},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1}, {-1}, {-1}, {-1}, {-1},
#line 42 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str578, ei_utf32be},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
#line 32 "aliases.gperf"
    {(int)(long)&((struct stringpool_t *)0)->stringpool_str597, ei_ucs2le}
  };

#ifdef __GNUC__
__inline
#endif
const struct alias *
aliases_lookup (register const char *str, register unsigned int len)
{
  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
    {
      register int key = aliases_hash (str, len);

      if (key <= MAX_HASH_VALUE && key >= 0)
        {
          register int o = aliases[key].name;
          if (o >= 0)
            {
              register const char *s = o + stringpool;

              if (*str == *s && !strcmp (str + 1, s + 1))
                return &aliases[key];
            }
        }
    }
  return 0;
}
