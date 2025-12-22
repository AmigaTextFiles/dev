uint
ÑHSIZEBITSÉ=Å6,
ÑVSIZEBITSÉ=Å16Å-ÅHSIZEBITS,
ÑHSIZEMASKÉ=Å0x3f,
ÑVSIZEMASKÉ=Å0x3ff,

ÑMAXBYTESPERROWÜ=Å128,

ÑABCâ=Å0x80,
ÑABNCà=Å0x40,
ÑANBCà=Å0x20,
ÑANBNCá=Å0x10,
ÑNABCà=Å0x08,
ÑNABNCá=Å0x04,
ÑNANBCá=Å0x02,
ÑNANBNCÜ=Å0x01,

ÑA_OR_BÜ=ÅABCÅ|ÅANBCÅ|ÅNABCÇ|ÇABNCÅ|ÅANBNCÅ|ÅNABNC,
ÑA_OR_CÜ=ÅABCÅ|ÅNABCÅ|ÅABNCÇ|ÇANBCÅ|ÅNANBCÅ|ÅANBNC,
ÑA_XOR_CÖ=ÅNABCÅ|ÅABNCÇ|ÇNANBCÅ|ÅANBNC,
ÑA_TO_DÜ=ÅABCÅ|ÅANBCÅ|ÅABNCÅ|ÅANBNC,

ÑBC0B_DESTÉ=Å8,
ÑBC0B_SRCCÉ=Å9,
ÑBC0B_SRCBÉ=Å10,
ÑBC0B_SRCAÉ=Å11,
ÑBC0F_DESTÉ=Å0x100,
ÑBC0F_SRCCÉ=Å0x200,
ÑBC0F_SRCBÉ=Å0x400,
ÑBC0F_SRCAÉ=Å0x800,

ÑBC1F_DESCÉ=Å2,

ÑDESTà=Å0x100,
ÑSRCCà=Å0x200,
ÑSRCBà=Å0x400,
ÑSRCAà=Å0x800,

ÑASHIFTSHIFTÅ=Å12,
ÑBSHIFTSHIFTÅ=Å12,

ÑLINEMODEÑ=Å0x1,
ÑFILL_ORÖ=Å0x8,
ÑFILL_XORÑ=Å0x10,
ÑFILL_CARRYIN=Å0x4,
ÑONEDOTÜ=Å0x2,
ÑOVFLAGÜ=Å0x20,
ÑSIGNFLAGÑ=Å0x40,
ÑBLITREVERSEÅ=Å0x2,

ÑSUDâ=Å0x10,
ÑSULâ=Å0x8,
ÑAULâ=Å0x4,

ÑOCTANT8Ö=Å24,
ÑOCTANT7Ö=Å4,
ÑOCTANT6Ö=Å12,
ÑOCTANT5Ö=Å28,
ÑOCTANT4Ö=Å20,
ÑOCTANT3Ö=Å8,
ÑOCTANT2Ö=Å0,
ÑOCTANT1Ö=Å16;

type
Ñbltnode_tÅ=ÅstructÅ{
à*bltnode_tÅbn_n;
àproc()ulongÅbn_function;
àushortÅbn_stat;
àuintÅbn_blitsize;
àuintÅbn_beamsync;
àproc()ulongÅbn_cleanup;
Ñ};

ushort
ÑCLEANUPÅ=Å0x40,
ÑCLEANMEÅ=ÅCLEANUP;
