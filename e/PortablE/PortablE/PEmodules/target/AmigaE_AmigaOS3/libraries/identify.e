/* $VER: identify.h 13.0 (11.09.2001) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/libraries', 'target/utility/tagitem'
{MODULE 'libraries/identify'}

/* ------------------------------------------------------------------------ *
**  Generic library informations
*/
NATIVE {IDENTIFYNAME}    CONST
#define IDENTIFYNAME identifyname
STATIC identifyname    = 'identify.library'

NATIVE {IDENTIFYVERSION} CONST IDENTIFYVERSION = (37)

NATIVE {IDENTIFYBUFLEN}      CONST IDENTIFYBUFLEN      = (50)                /*  default buffer length */

CONST IDTAGS_DUMMY             = ($cd450000)

/* ------------------------------------------------------------------------ *
**  Expansion() tags
*/
NATIVE {IDTAG_ConfigDev}     CONST IDTAG_ConfigDev     = (IDTAGS_DUMMY + $00)    /* (struct ConfigDev *) ConfigDev */
                                                /*  structure to be evaluated */
NATIVE {IDTAG_ManufID}       CONST IDTAG_ManufID       = (IDTAGS_DUMMY + $01)    /* UWORD manufacturer ID if no */
                                                /*  ConfigDev is available */
NATIVE {IDTAG_ProdID}        CONST IDTAG_ProdID        = (IDTAGS_DUMMY + $02)    /* UBYTE product ID if no */
                                                /*  ConfigDev is available */
NATIVE {IDTAG_StrLength}     CONST IDTAG_StrLength     = (IDTAGS_DUMMY + $03)    /* UWORD of maximum buffer length, */
                                                /*  including termination. Default */
                                                /*  is 50. */
NATIVE {IDTAG_ManufStr}      CONST IDTAG_ManufStr      = (IDTAGS_DUMMY + $04)    /* STRPTR of manufacturer name */
                                                /*  puffer, or NULL */
NATIVE {IDTAG_ProdStr}       CONST IDTAG_ProdStr       = (IDTAGS_DUMMY + $05)    /* STRPTR of product name */
                                                /*  puffer, or NULL */
NATIVE {IDTAG_ClassStr}      CONST IDTAG_ClassStr      = (IDTAGS_DUMMY + $06)    /* STRPTR of product class */
                                                /*  puffer, or NULL */
NATIVE {IDTAG_DeadStr}       CONST IDTAG_DeadStr       = (IDTAGS_DUMMY + $07)    /* STRPTR deadend or recoverable alert? */
NATIVE {IDTAG_SubsysStr}     CONST IDTAG_SubsysStr     = (IDTAGS_DUMMY + $08)    /* STRPTR alert subsystem */
NATIVE {IDTAG_GeneralStr}    CONST IDTAG_GeneralStr    = (IDTAGS_DUMMY + $09)    /* STRPTR alert general cause */
NATIVE {IDTAG_SpecStr}       CONST IDTAG_SpecStr       = (IDTAGS_DUMMY + $0a)    /* STRPTR alert specific cause */
NATIVE {IDTAG_FuncNameStr}   CONST IDTAG_FuncNameStr   = (IDTAGS_DUMMY + $0b)    /* STRPTR function name */
NATIVE {IDTAG_Expansion}     CONST IDTAG_Expansion     = (IDTAGS_DUMMY + $0c)    /* (struct ConfigDev **) for a */
                                                /*  complete expansion check. Init */
                                                /*  the variable with NULL. */
NATIVE {IDTAG_Secondary}     CONST IDTAG_Secondary     = (IDTAGS_DUMMY + $0d)    /* BOOL warn for secondary expansion */
                                                /*  boards (defaults to FALSE) */
NATIVE {IDTAG_ClassID}       CONST IDTAG_ClassID       = (IDTAGS_DUMMY + $0e)    /* ULONG * class ID of the provided */
                                                /*  expansion board (see below) [V8] */
NATIVE {IDTAG_Localize}      CONST IDTAG_Localize      = (IDTAGS_DUMMY + $0f)    /* BOOL return localized strings */
                                                /*  (defaults to TRUE) [V8] */
NATIVE {IDTAG_NULL4NA}       CONST IDTAG_NULL4NA       = (IDTAGS_DUMMY + $10)    /* BOOL return NULL for not available */
                                                /*  else return a string (defaults to */
                                                /*  FALSE) [V8] */

/* ------------------------------------------------------------------------ *
**  Hardware description types
*/
NATIVE {IDHW_SYSTEM}         CONST IDHW_SYSTEM         = (0)     /*  System (Amiga,DraCo,...)            [V2] */
NATIVE {IDHW_CPU}            CONST IDHW_CPU            = (1)     /*  CPU (68000,68010,...,68060) */
NATIVE {IDHW_FPU}            CONST IDHW_FPU            = (2)     /*  FPU (---,68881,68882,68040,68060) */
NATIVE {IDHW_MMU}            CONST IDHW_MMU            = (3)     /*  MMU (---,68852,68030,68040,68060) */
NATIVE {IDHW_OSVER}          CONST IDHW_OSVER          = (4)     /*  OS Version (V*.*) */
NATIVE {IDHW_EXECVER}        CONST IDHW_EXECVER        = (5)     /*  Exec Version (V*.*) */
NATIVE {IDHW_WBVER}          CONST IDHW_WBVER          = (6)     /*  Workbench Version (---,V*.*) */
NATIVE {IDHW_ROMSIZE}        CONST IDHW_ROMSIZE        = (7)     /*  OS ROM Size (*KB, *MB) */
NATIVE {IDHW_CHIPSET}        CONST IDHW_CHIPSET        = (8)     /*  Chipset (OCS,ECS,AGA,DraCo) */
NATIVE {IDHW_GFXSYS}         CONST IDHW_GFXSYS         = (9)     /*  Graphic OS (AmigaOS, CyberGraphX, ...) */
NATIVE {IDHW_CHIPRAM}        CONST IDHW_CHIPRAM        = (10)    /*  All Chip RAM (*KB, *MB, *GB) */
NATIVE {IDHW_FASTRAM}        CONST IDHW_FASTRAM        = (11)    /*  All Fast RAM (*KB, *MB, *GB) */
NATIVE {IDHW_RAM}            CONST IDHW_RAM            = (12)    /*  All Total RAM (*KB, *MB, *GB) */
NATIVE {IDHW_SETPATCHVER}    CONST IDHW_SETPATCHVER    = (13)    /*  SetPatch Version (---,V*.*)         [V4] */
NATIVE {IDHW_AUDIOSYS}       CONST IDHW_AUDIOSYS       = (14)    /*  Audio OS (AmigaOS, AHI, ...)        [V5] */
NATIVE {IDHW_OSNR}           CONST IDHW_OSNR           = (15)    /*  AmigaOS (2.04, 3.1, ...) */
NATIVE {IDHW_VMMCHIPRAM}     CONST IDHW_VMMCHIPRAM     = (16)    /*  VMM Chip RAM (*KB, *MB, *GB) */
NATIVE {IDHW_VMMFASTRAM}     CONST IDHW_VMMFASTRAM     = (17)    /*  VMM Fast RAM (*KB, *MB, *GB) */
NATIVE {IDHW_VMMRAM}         CONST IDHW_VMMRAM         = (18)    /*  VMM Total RAM (*KB, *MB, *GB) */
NATIVE {IDHW_PLNCHIPRAM}     CONST IDHW_PLNCHIPRAM     = (19)    /*  Plain Chip RAM (*KB, *MB, *GB) */
NATIVE {IDHW_PLNFASTRAM}     CONST IDHW_PLNFASTRAM     = (20)    /*  Plain Fast RAM (*KB, *MB, *GB) */
NATIVE {IDHW_PLNRAM}         CONST IDHW_PLNRAM         = (21)    /*  Plain Total RAM (*KB, *MB, *GB) */
NATIVE {IDHW_VBR}            CONST IDHW_VBR            = (22)    /*  Vector Base Register                [V6] */
NATIVE {IDHW_LASTALERT}      CONST IDHW_LASTALERT      = (23)    /*  Last Alert code */
NATIVE {IDHW_VBLANKFREQ}     CONST IDHW_VBLANKFREQ     = (24)    /*  VBlank Frequency */
NATIVE {IDHW_POWERFREQ}      CONST IDHW_POWERFREQ      = (25)    /*  Power Frequency */
NATIVE {IDHW_ECLOCK}         CONST IDHW_ECLOCK         = (26)    /*  EClock */
NATIVE {IDHW_SLOWRAM}        CONST IDHW_SLOWRAM        = (27)    /*  Plain Slow RAM (*KB, *MB, *GB) */
NATIVE {IDHW_GARY}           CONST IDHW_GARY           = (28)    /*  Gary (---,Normal,...) */
NATIVE {IDHW_RAMSEY}         CONST IDHW_RAMSEY         = (29)    /*  RAMSEY (---,D,F) */
NATIVE {IDHW_BATTCLOCK}      CONST IDHW_BATTCLOCK      = (30)    /*  Battery Backed Up Clock (---,Found) */
NATIVE {IDHW_CHUNKYPLANAR}   CONST IDHW_CHUNKYPLANAR   = (31)    /*  Chunky To Planar Hardware (---,Found) [V7] */
NATIVE {IDHW_POWERPC}        CONST IDHW_POWERPC        = (32)    /*  PowerPC present? (---,Found) */
NATIVE {IDHW_PPCCLOCK}       CONST IDHW_PPCCLOCK       = (33)    /*  PowerPC clock (unit MHz) */
NATIVE {IDHW_CPUREV}         CONST IDHW_CPUREV         = (34)    /*  CPU revision                          [V8] */
NATIVE {IDHW_CPUCLOCK}       CONST IDHW_CPUCLOCK       = (35)    /*  CPU clock (unit MHz) */
NATIVE {IDHW_FPUCLOCK}       CONST IDHW_FPUCLOCK       = (36)    /*  FPU clock (unit MHz) */
NATIVE {IDHW_RAMACCESS}      CONST IDHW_RAMACCESS      = (37)    /*  Main board RAM access time (unit ns) */
NATIVE {IDHW_RAMWIDTH}       CONST IDHW_RAMWIDTH       = (38)    /*  Main board RAM width (bit) */
NATIVE {IDHW_RAMCAS}         CONST IDHW_RAMCAS         = (39)    /*  Main board RAM CAS mode */
NATIVE {IDHW_RAMBANDWIDTH}   CONST IDHW_RAMBANDWIDTH   = (40)    /*  Main board RAM bandwidth */
NATIVE {IDHW_TCPIP}          CONST IDHW_TCPIP          = (41)    /*  TCP/IP stack                          [V9] */
NATIVE {IDHW_PPCOS}          CONST IDHW_PPCOS          = (42)    /*  PowerPC OS */
NATIVE {IDHW_AGNUS}          CONST IDHW_AGNUS          = (43)    /*  Agnus chip revision */
NATIVE {IDHW_AGNUSMODE}      CONST IDHW_AGNUSMODE      = (44)    /*  Agnus chip mode */
NATIVE {IDHW_DENISE}         CONST IDHW_DENISE         = (45)    /*  Denise chip version                   [V10] */
NATIVE {IDHW_DENISEREV}      CONST IDHW_DENISEREV      = (46)    /*  Denise chip revision */
NATIVE {IDHW_BOINGBAG}       CONST IDHW_BOINGBAG       = (47)    /*  BoingBag number                       [V12] */
NATIVE {IDHW_EMULATED}       CONST IDHW_EMULATED       = (48)    /*  Emulated Amiga                        [V13] */
NATIVE {IDHW_XLVERSION}      CONST IDHW_XLVERSION      = (49)    /*  AmigaXL version */
NATIVE {IDHW_HOSTOS}         CONST IDHW_HOSTOS         = (50)    /*  when emulated: Host OS (see autodocs!) */
NATIVE {IDHW_HOSTVERS}       CONST IDHW_HOSTVERS       = (51)    /*  when emulated: Host Version (see autodocs!) */
NATIVE {IDHW_HOSTMACHINE}    CONST IDHW_HOSTMACHINE    = (52)    /*  when emulated: Host Machine (see autodocs!) */
NATIVE {IDHW_HOSTCPU}        CONST IDHW_HOSTCPU        = (53)    /*  when emulated: Host CPU (see autodocs!) */
NATIVE {IDHW_HOSTSPEED}      CONST IDHW_HOSTSPEED      = (54)    /*  when emulated: Host CPU speed (unit MHz, see autodocs!) */
CONST IDHW_LASTALERTTASK  = (55)    /*  Last Alert task */
NATIVE {IDHW_NUMBEROF}       CONST IDHW_NUMBEROF       = (56)    /*  Number of types, PRIVATE! */

/* ------------------------------------------------------------------------ *
**  IDHW_SYSTEM numerical result codes
*/
NATIVE {IDSYS_AMIGA1000}     CONST IDSYS_AMIGA1000     = (0)     /*  Amiga 1000 */
NATIVE {IDSYS_AMIGAOCS}      CONST IDSYS_AMIGAOCS      = (1)     /*  OCS Amiga 500/2000 */
NATIVE {IDSYS_AMIGAECS}      CONST IDSYS_AMIGAECS      = (2)     /*  ECS Amiga 500/2000 */
NATIVE {IDSYS_AMIGA500}      CONST IDSYS_AMIGA500      = (3)     /*  Amiga 500 */
NATIVE {IDSYS_AMIGA2000}     CONST IDSYS_AMIGA2000     = (4)     /*  Amiga 2000 */
NATIVE {IDSYS_AMIGA3000}     CONST IDSYS_AMIGA3000     = (5)     /*  Amiga 3000 */
NATIVE {IDSYS_CDTV}          CONST IDSYS_CDTV          = (6)     /*  CDTV */
NATIVE {IDSYS_AMIGA600}      CONST IDSYS_AMIGA600      = (7)     /*  Amiga 600 */
NATIVE {IDSYS_CD32}          CONST IDSYS_CD32          = (8)     /*  CD32 */
NATIVE {IDSYS_AMIGA1200}     CONST IDSYS_AMIGA1200     = (9)     /*  Amiga 1200 */
NATIVE {IDSYS_AMIGA4000}     CONST IDSYS_AMIGA4000     = (10)    /*  Amiga 4000 */
NATIVE {IDSYS_DRACO}         CONST IDSYS_DRACO         = (11)    /*  DraCo */
NATIVE {IDSYS_UAE}           CONST IDSYS_UAE           = (12)    /*  Ubiquitous Amiga Emulator */
NATIVE {IDSYS_AMIGA4000T}    CONST IDSYS_AMIGA4000T    = (13)    /*  Amiga 4000 Tower */
NATIVE {IDSYS_AMIGAXL}       CONST IDSYS_AMIGAXL       = (14)    /*  AmigaXL */

/* ------------------------------------------------------------------------ *
**  IDHW_CPU numerical result codes
*/
NATIVE {IDCPU_68000}         CONST IDCPU_68000         = (0)     /*  68000 */
NATIVE {IDCPU_68010}         CONST IDCPU_68010         = (1)     /*  68010 */
NATIVE {IDCPU_68020}         CONST IDCPU_68020         = (2)     /*  68020 */
NATIVE {IDCPU_68030}         CONST IDCPU_68030         = (3)     /*  68030 */
NATIVE {IDCPU_68EC030}       CONST IDCPU_68EC030       = (4)     /*  68EC030 (without MMU) */
NATIVE {IDCPU_68040}         CONST IDCPU_68040         = (5)     /*  68040 */
NATIVE {IDCPU_68LC040}       CONST IDCPU_68LC040       = (6)     /*  68LC040 (without FPU) */
NATIVE {IDCPU_68060}         CONST IDCPU_68060         = (7)     /*  68060 */
NATIVE {IDCPU_68LC060}       CONST IDCPU_68LC060       = (8)     /*  68LC060 (without FPU) */

/* ------------------------------------------------------------------------ *
**  IDHW_FPU numerical result codes
*/
NATIVE {IDFPU_NONE}          CONST IDFPU_NONE          = (0)     /*  no FPU */
NATIVE {IDFPU_68881}         CONST IDFPU_68881         = (1)     /*  68881 */
NATIVE {IDFPU_68882}         CONST IDFPU_68882         = (2)     /*  68882 */
NATIVE {IDFPU_68040}         CONST IDFPU_68040         = (3)     /*  68040 */
NATIVE {IDFPU_68060}         CONST IDFPU_68060         = (4)     /*  68060 */

/* ------------------------------------------------------------------------ *
**  IDHW_MMU numerical result codes
*/
NATIVE {IDMMU_NONE}          CONST IDMMU_NONE          = (0)     /*  no MMU */
NATIVE {IDMMU_68851}         CONST IDMMU_68851         = (1)     /*  68851 */
NATIVE {IDMMU_68030}         CONST IDMMU_68030         = (2)     /*  68030 */
NATIVE {IDMMU_68040}         CONST IDMMU_68040         = (3)     /*  68040 */
NATIVE {IDMMU_68060}         CONST IDMMU_68060         = (4)     /*  68060 */

/* ------------------------------------------------------------------------ *
**  IDHW_OSNR numerical result codes
*/
NATIVE {IDOS_UNKNOWN}        CONST IDOS_UNKNOWN        = (0)     /*  <V36 or >V40 */
NATIVE {IDOS_2_0}            CONST IDOS_2_0            = (1)     /*  OS2.0  (V36) */
NATIVE {IDOS_2_04}           CONST IDOS_2_04           = (2)     /*  OS2.04 (V37) */
NATIVE {IDOS_2_1}            CONST IDOS_2_1            = (3)     /*  OS2.1  (V38) */
NATIVE {IDOS_3_0}            CONST IDOS_3_0            = (4)     /*  OS3.0  (V39) */
NATIVE {IDOS_3_1}            CONST IDOS_3_1            = (5)     /*  OS3.1  (V40) */
NATIVE {IDOS_3_5}            CONST IDOS_3_5            = (6)     /*  OS3.5  (V44) */
NATIVE {IDOS_3_9}            CONST IDOS_3_9            = (7)     /*  OS3.9  (V45) */

/* ------------------------------------------------------------------------ *
**  IDHW_CHIPSET numerical result codes
*/
NATIVE {IDCS_OCS}            CONST IDCS_OCS            = (0)     /*  OCS */
NATIVE {IDCS_ECS}            CONST IDCS_ECS            = (1)     /*  ECS */
NATIVE {IDCS_AGA}            CONST IDCS_AGA            = (2)     /*  AGA */
NATIVE {IDCS_ALTAIS}         CONST IDCS_ALTAIS         = (3)     /*  DraCo Altais */
NATIVE {IDCS_NECS}           CONST IDCS_NECS           = (4)     /* Nearly ECS (no HR-Agnus or HR-Denise) */

/* ------------------------------------------------------------------------ *
**  IDHW_GFXSYS numerical result codes
*/
NATIVE {IDGOS_AMIGAOS}       CONST IDGOS_AMIGAOS       = (0)     /*  Plain AmigaOS */
NATIVE {IDGOS_EGS}           CONST IDGOS_EGS           = (1)     /*  EGS */
NATIVE {IDGOS_RETINA}        CONST IDGOS_RETINA        = (2)     /*  Retina */
NATIVE {IDGOS_GRAFFITI}      CONST IDGOS_GRAFFITI      = (3)     /*  Graffiti */
NATIVE {IDGOS_TIGA}          CONST IDGOS_TIGA          = (4)     /*  TIGA */
NATIVE {IDGOS_PROBENCH}      CONST IDGOS_PROBENCH      = (5)     /*  Merlin ProBench */
NATIVE {IDGOS_PICASSO}       CONST IDGOS_PICASSO       = (6)     /*  Picasso */
NATIVE {IDGOS_CGX}           CONST IDGOS_CGX           = (7)     /*  CyberGraphX */
NATIVE {IDGOS_CGX3}          CONST IDGOS_CGX3          = (8)     /*  CyberGraphX 3D */
NATIVE {IDGOS_PICASSO96}     CONST IDGOS_PICASSO96     = (9)     /*  Picasso96 */
NATIVE {IDGOS_CGX4}          CONST IDGOS_CGX4          = (10)    /*  CyberGraphX V4 */

/* ------------------------------------------------------------------------ *
**  IDHW_AUDIOSYS numerical result codes
*/
NATIVE {IDAOS_AMIGAOS}       CONST IDAOS_AMIGAOS       = (0)     /*  Plain AmigaOS */
NATIVE {IDAOS_MAESTIX}       CONST IDAOS_MAESTIX       = (1)     /*  MaestroPro driver */
NATIVE {IDAOS_TOCCATA}       CONST IDAOS_TOCCATA       = (2)     /*  Toccata driver */
NATIVE {IDAOS_PRELUDE}       CONST IDAOS_PRELUDE       = (3)     /*  Prelude driver */
NATIVE {IDAOS_AHI}           CONST IDAOS_AHI           = (4)     /*  AHI */
NATIVE {IDAOS_MACROAUDIO}    CONST IDAOS_MACROAUDIO    = (5)     /*  MacroAudio */

/* ------------------------------------------------------------------------ *
**  IDHW_GARY numerical result codes
*/
NATIVE {IDGRY_NONE}          CONST IDGRY_NONE          = (0)     /*  No Gary available */
NATIVE {IDGRY_NORMAL}        CONST IDGRY_NORMAL        = (1)     /*  Normal Gary */
NATIVE {IDGRY_ENHANCED}      CONST IDGRY_ENHANCED      = (2)     /*  Enhanced Gary */

/* ------------------------------------------------------------------------ *
**  IDHW_RAMSEY numerical result codes
*/
NATIVE {IDRSY_NONE}          CONST IDRSY_NONE          = (0)     /*  No RamSey available */
NATIVE {IDRSY_REVD}          CONST IDRSY_REVD          = (1)     /*  RamSey Revision D */
NATIVE {IDRSY_REVF}          CONST IDRSY_REVF          = (2)     /*  RamSey Revision F */

/* ------------------------------------------------------------------------ *
** IDHW_POWERPC numerical result codes
*/
NATIVE {IDPPC_NONE}          CONST IDPPC_NONE          = (0)     /*  No PowerPC implemented */
NATIVE {IDPPC_OTHER}         CONST IDPPC_OTHER         = (1)     /*  Another PowerPC */
NATIVE {IDPPC_602}           CONST IDPPC_602           = (2)     /*  602 */
NATIVE {IDPPC_603}           CONST IDPPC_603           = (3)     /*  603 */
NATIVE {IDPPC_603E}          CONST IDPPC_603E          = (4)     /*  603e */
NATIVE {IDPPC_603P}          CONST IDPPC_603P          = (5)     /*  603p */
NATIVE {IDPPC_604}           CONST IDPPC_604           = (6)     /*  604 */
NATIVE {IDPPC_604E}          CONST IDPPC_604E          = (7)     /*  604e */
NATIVE {IDPPC_620}           CONST IDPPC_620           = (8)     /*  620 */

/* ------------------------------------------------------------------------ *
** IDHW_RAMCAS numerical result codes
*/
NATIVE {IDCAS_NONE}          CONST IDCAS_NONE          = (0)     /*  Not available */
NATIVE {IDCAS_NORMAL}        CONST IDCAS_NORMAL        = (1)     /*  Normal access */
NATIVE {IDCAS_DOUBLE}        CONST IDCAS_DOUBLE        = (2)     /*  Double access */

/* ------------------------------------------------------------------------ *
** IDHW_TCPIP numerical result codes
*/
NATIVE {IDTCP_NONE}          CONST IDTCP_NONE          = (0)     /* Not available */
NATIVE {IDTCP_AMITCP}        CONST IDTCP_AMITCP        = (1)     /* AmiTCP */
NATIVE {IDTCP_MIAMI}         CONST IDTCP_MIAMI         = (2)     /* Miami */
NATIVE {IDTCP_TERMITE}       CONST IDTCP_TERMITE       = (3)     /* TermiteTCP */
NATIVE {IDTCP_GENESIS}       CONST IDTCP_GENESIS       = (4)     /* GENESiS */
NATIVE {IDTCP_MIAMIDX}       CONST IDTCP_MIAMIDX       = (5)     /* MiamiDx */

/* ------------------------------------------------------------------------ *
** IDHW_PPCOS numerical result codes
*/
NATIVE {IDPOS_NONE}          CONST IDPOS_NONE          = (0)     /* None */
NATIVE {IDPOS_POWERUP}       CONST IDPOS_POWERUP       = (1)     /* PowerUP (Phase 5) */
NATIVE {IDPOS_WARPOS}        CONST IDPOS_WARPOS        = (2)     /* WarpOS (Haage&Partner) */

/* ------------------------------------------------------------------------ *
** IDHW_AGNUS numerical result codes
*/
NATIVE {IDAG_NONE}           CONST IDAG_NONE           = (0)     /* None */
NATIVE {IDAG_UNKNOWN}        CONST IDAG_UNKNOWN        = (1)     /* Unknown Agnus */
NATIVE {IDAG_8361}           CONST IDAG_8361           = (2)     /* Agnus 8361 */
NATIVE {IDAG_8367}           CONST IDAG_8367           = (3)     /* Agnus 8367 */
NATIVE {IDAG_8370}           CONST IDAG_8370           = (4)     /* Agnus 8370 */
NATIVE {IDAG_8371}           CONST IDAG_8371           = (5)     /* Agnus 8371 */
NATIVE {IDAG_8372_R4}        CONST IDAG_8372_R4        = (6)     /* Agnus 8372 Rev. 1-4 */
NATIVE {IDAG_8372_R5}        CONST IDAG_8372_R5        = (7)     /* Agnus 8372 Rev. 5 */
NATIVE {IDAG_8374_R2}        CONST IDAG_8374_R2        = (8)     /* Alice 8374 Rev. 1-2 */
NATIVE {IDAG_8374_R3}        CONST IDAG_8374_R3        = (9)     /* Alice 8374 Rev. 3-4 */

/* ------------------------------------------------------------------------ *
** IDHW_DENISE numerical result codes
*/
NATIVE {IDDN_NONE}           CONST IDDN_NONE           = (0)     /* None */
NATIVE {IDDN_UNKNOWN}        CONST IDDN_UNKNOWN        = (1)     /* Unknown Denise (new model?! :-) */
NATIVE {IDDN_8362}           CONST IDDN_8362           = (2)     /* Denise 8362 */
NATIVE {IDDN_8373}           CONST IDDN_8373           = (3)     /* Denise 8373 */
NATIVE {IDDN_8364}           CONST IDDN_8364           = (4)     /* Lisa 8364 */

/* ------------------------------------------------------------------------ *
** IDHW_AGNUSMODE numerical result codes
*/
NATIVE {IDAM_NONE}           CONST IDAM_NONE           = (0)     /* None */
NATIVE {IDAM_NTSC}           CONST IDAM_NTSC           = (1)     /* NTSC Agnus */
NATIVE {IDAM_PAL}            CONST IDAM_PAL            = (2)     /* PAL Agnus */

/* ------------------------------------------------------------------------ *
** IDTAG_ClassID numerical result codes
*/
NATIVE {IDCID_UNKNOWN}       CONST IDCID_UNKNOWN       = (0)     /*  unknown functionality */
NATIVE {IDCID_MISC}          CONST IDCID_MISC          = (1)     /*  miscellaneous expansion */
NATIVE {IDCID_TURBO}         CONST IDCID_TURBO         = (2)     /*  accelerator */
NATIVE {IDCID_TURBORAM}      CONST IDCID_TURBORAM      = (3)     /*  accelerator RAM */
NATIVE {IDCID_TURBOHD}       CONST IDCID_TURBOHD       = (4)     /*  accelerator + some HD controller */
NATIVE {IDCID_TURBOIDE}      CONST IDCID_TURBOIDE      = (5)     /*  accelerator + AT-IDE controller */
NATIVE {IDCID_TURBOSCSIHD}   CONST IDCID_TURBOSCSIHD   = (6)     /*  accelerator + SCSI host adapter */
NATIVE {IDCID_NET}           CONST IDCID_NET           = (7)     /*  some network */
NATIVE {IDCID_ARCNET}        CONST IDCID_ARCNET        = (8)     /*  ArcNet */
NATIVE {IDCID_ETHERNET}      CONST IDCID_ETHERNET      = (9)     /*  Ethernet */
NATIVE {IDCID_AUDIO}         CONST IDCID_AUDIO         = (10)    /*  audio */
NATIVE {IDCID_VIDEO}         CONST IDCID_VIDEO         = (11)    /*  video (video digitizer etc) */
NATIVE {IDCID_MULTIMEDIA}    CONST IDCID_MULTIMEDIA    = (12)    /*  multimedia (audio, video, etc) */
NATIVE {IDCID_DSP}           CONST IDCID_DSP           = (13)    /*  multi purpose DSP */
NATIVE {IDCID_BUSBRIDGE}     CONST IDCID_BUSBRIDGE     = (14)    /*  ISA bus bridge */
NATIVE {IDCID_BRIDGE}        CONST IDCID_BRIDGE        = (15)    /*  PC bridge */
NATIVE {IDCID_EMULATOR}      CONST IDCID_EMULATOR      = (16)    /*  some Emulator hardware */
NATIVE {IDCID_MACEMU}        CONST IDCID_MACEMU        = (17)    /*  Macintosh emulator hardware */
NATIVE {IDCID_ATARIEMU}      CONST IDCID_ATARIEMU      = (18)    /*  Atari emulator hardware */
NATIVE {IDCID_GFX}           CONST IDCID_GFX           = (19)    /*  graphics (register) */
NATIVE {IDCID_GFXRAM}        CONST IDCID_GFXRAM        = (20)    /*  graphics (video RAM) */
NATIVE {IDCID_HD}            CONST IDCID_HD            = (21)    /*  some HD controller */
NATIVE {IDCID_HDRAM}         CONST IDCID_HDRAM         = (22)    /*  some HD controller + RAM */
NATIVE {IDCID_IDEHD}         CONST IDCID_IDEHD         = (23)    /*  IDE controller */
NATIVE {IDCID_IDEHDRAM}      CONST IDCID_IDEHDRAM      = (24)    /*  IDE controller + RAM */
NATIVE {IDCID_SCSIHD}        CONST IDCID_SCSIHD        = (25)    /*  SCSI host adapter */
NATIVE {IDCID_RAMSCSIHD}     CONST IDCID_RAMSCSIHD     = (26)    /*  SCSI host adapter + RAM */
NATIVE {IDCID_CDROM}         CONST IDCID_CDROM         = (27)    /*  CD-ROM interface */
NATIVE {IDCID_MODEM}         CONST IDCID_MODEM         = (28)    /*  internal modem */
NATIVE {IDCID_ISDN}          CONST IDCID_ISDN          = (29)    /*  internal ISDN terminal adapter */
NATIVE {IDCID_MULTIIO}       CONST IDCID_MULTIIO       = (30)    /*  multi I/O (serial + parallel) */
NATIVE {IDCID_SERIAL}        CONST IDCID_SERIAL        = (31)    /*  multi serial (no parallel) */
NATIVE {IDCID_PARALLEL}      CONST IDCID_PARALLEL      = (32)    /*  multi parallel (no serial) */
NATIVE {IDCID_SCANIF}        CONST IDCID_SCANIF        = (33)    /*  scanner interface */
NATIVE {IDCID_TABLET}        CONST IDCID_TABLET        = (34)    /*  drawing tablet interface */
NATIVE {IDCID_RAM}           CONST IDCID_RAM           = (35)    /*  plain RAM expansion */
NATIVE {IDCID_FLASHROM}      CONST IDCID_FLASHROM      = (36)    /*  Flash ROM */
NATIVE {IDCID_SCSIIDE}       CONST IDCID_SCSIIDE       = (37)    /*  combined SCSI/IDE controller */
NATIVE {IDCID_RAMFPU}        CONST IDCID_RAMFPU        = (38)    /*  RAM expansion + FPU */
NATIVE {IDCID_GUESS}         CONST IDCID_GUESS         = (39)    /*  name was unknown but guessed */
NATIVE {IDCID_KICKSTART}     CONST IDCID_KICKSTART     = (40)    /*  KickStart */
NATIVE {IDCID_RAM32}         CONST IDCID_RAM32         = (41)    /*  32bit RAM expansion */
NATIVE {IDCID_TURBOANDRAM}   CONST IDCID_TURBOANDRAM   = (42)    /*  accelerator + RAM expansion */
NATIVE {IDCID_ACCESS}        CONST IDCID_ACCESS        = (43)    /*  access control */
NATIVE {IDCID_INTERFACE}     CONST IDCID_INTERFACE     = (44)    /*  some interface */
NATIVE {IDCID_MFMHD}         CONST IDCID_MFMHD         = (45)    /*  MFM HD controller */
NATIVE {IDCID_FLOPPY}        CONST IDCID_FLOPPY        = (46)    /*  floppy disk controller */
CONST IDCID_USB           = (47)    /*  USB interface */
    /*  Be prepared to get other numbers as well. In this case you */
    /*  should assume IDCID_MISC. */

/* ------------------------------------------------------------------------ *
**  Error codes
*/
/* Positive error codes are DOS errors! */
NATIVE {IDERR_OKAY}          CONST IDERR_OKAY          = (0)     /* No error */
NATIVE {IDERR_NOLENGTH}      CONST IDERR_NOLENGTH      = (-1)    /* Buffer length is 0 ?? */
NATIVE {IDERR_BADID}         CONST IDERR_BADID         = (-2)    /* Missing or bad board ID */
NATIVE {IDERR_NOMEM}         CONST IDERR_NOMEM         = (-3)    /* Not enough memory */
NATIVE {IDERR_NOFD}          CONST IDERR_NOFD          = (-4)    /* No fitting FD file found */
NATIVE {IDERR_OFFSET}        CONST IDERR_OFFSET        = (-5)    /* Function offset not found */
NATIVE {IDERR_DONE}          CONST IDERR_DONE          = (-6)    /* Done with traversing (not an error) */
NATIVE {IDERR_SECONDARY}     CONST IDERR_SECONDARY     = (-7)    /* Secondary expansion board (not an error) */

/* ------------------------------------------------------------------------ *
**  That's all...
*/
