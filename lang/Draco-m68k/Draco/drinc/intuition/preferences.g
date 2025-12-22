uint
ÑFILENAME_SIZEÅ=Å30,
ÑPOINTERSIZEÅ=Å(1Å+Å16Å+Å1)Å*Å2;

ushort
ÑTOPAZ_EIGHTYÅ=Å8,
ÑTOPAZ_SIXTYÅ=Å9;

type
Ñtimeval_tÅ=ÅunknownÅ8,

ÑPreferences_tÅ=ÅstructÅ{
àushortÅpr_FontHeight;
àushortÅpr_PrinterPort;
àuintÅpr_BaudRate;
àtimeval_tÅpr_KeyRptSpeed,Åpr_KeyRptDelay,Åpr_DoubleClick;
à[POINTERSIZE]uintÅpr_PointerMatrix;
àushortÅpr_XOffset,Åpr_YOffset;
àuintÅpr_color17,Åpr_color18,Åpr_color19;
àuintÅpr_PointerTicks;
àuintÅpr_color0,Åpr_color1,Åpr_color2,Åpr_color3;
àushortÅpr_ViewXOffset,Åpr_ViewYOffset;
àuintÅpr_ViewInitX,ÅViewInitY;
àuintÅpr_EnableCLI;
àuintÅpr_PrinterType;
à[FILENAME_SIZE]charÅpr_PrinterFileName;
àuintÅpr_PrintPitch;
àuintÅpr_PrintQuality;
àuintÅpr_PrintSpacing;
àuintÅpr_PrintLeftMargin;
àuintÅpr_PrintRightMargin;
àuintÅpr_PrintImage;
àuintÅpr_PrintAspect;
àintÅpr_PrintThreshold;
àuintÅpr_PaperSize;
àuintÅpr_PaperLength;
àuintÅpr_PaperType;
àushortÅpr_SerRWBits;
àushortÅpr_SerStopBuf;
àushortÅpr_SerParShk;
àushortÅpr_LaceWB;
à[FILENAME_SIZE]charÅpr_WorkName;
à[16]byteÅpr_padding;
Ñ};

ushort
ÑLACEWBä=Å0x01,

ÑPARALLEL_PRINTER=Å0x00,
ÑSERIAL_PRINTERÇ=Å0x01,

ÑBAUD_110à=Å0x00,
ÑBAUD_300à=Å0x01,
ÑBAUD_1200á=Å0x02,
ÑBAUD_2400á=Å0x03,
ÑBAUD_4800á=Å0x04,
ÑBAUD_9600á=Å0x05,
ÑBAUD_19200Ü=Å0x06,
ÑBAUD_MIDIá=Å0x07,

ÑFANFOLDâ=Å0x00,
ÑSINGLEä=Å0x80;

uint
ÑPICAå=Å0x0000,
ÑELITEã=Å0x0400,
ÑFINEå=Å0x0800,

ÑDRAFTã=Å0x0000,
ÑLETTERä=Å0x0100,

ÑSIX_LPIâ=Å0x0000,
ÑEIGHT_LPIá=Å0x0200,

ÑIMAGE_POSITIVEÇ=Å0x0000,
ÑIMAGE_NEGATIVEÇ=Å0x0001,

ÑASPECT_HORIZÑ=Å0x0000,
ÑASPECT_VERTÖ=Å0x0001,

ÑSHADE_BWà=Å0x0000,
ÑSHADE_GREYSCALEÅ=Å0x0001,
ÑSHADE_COLORÖ=Å0x0002,

ÑUS_LETTERá=Å0x0000,
ÑUS_LEGALà=Å0x0010,
ÑN_TRACTORá=Å0x0020,
ÑW_TRACTORá=Å0x0030,
ÑCUSTOMä=Å0x0040,

ÑCUSTOM_NAMEÖ=Å0x0000,
ÑALPHA_P_101Ö=Å0x0001,
ÑBROTHER_15XLÑ=Å0x0002,
ÑCBM_MPS1000Ö=Å0x0003,
ÑDIAB_630à=Å0x0004,
ÑDIAB_ADB_D25Ñ=Å0x0005,
ÑDIAB_C_150Ü=Å0x0006,
ÑEPSONã=Å0x0007,
ÑEPSON_JX_80Ö=Å0x0008,
ÑOKIMATE_20Ü=Å0x0009,
ÑQUME_LP_20Ü=Å0x000A,
ÑHP_LASERJETÖ=Å0x000B,
ÑHP_LASERJET_PLUS=Å0x000C;

ushort
ÑSREAD_BITSÜ=Å0xF0,
ÑSWRITE_BITSÖ=Å0x0F,

ÑSSTOP_BITSÜ=Å0xF0,
ÑSBUFSIZE_BITSÉ=Å0x0F,

ÑSPARITY_BITSÑ=Å0xF0,
ÑSHSHAKE_BITSÑ=Å0x0F,

ÑSPARITY_NONEÑ=Å0,
ÑSPARITY_EVENÑ=Å1,
ÑSPARITY_ODDÖ=Å2,

ÑSHSHAKE_XONÖ=Å0,
ÑSHSHAKE_RTSÖ=Å1,
ÑSHSHAKE_NONEÑ=Å2;

extern
ÑGetDefPrefs(*Preferences_tÅpref;ÅulongÅsize)*Preferences_t,
ÑGetPrefs(*Preferences_tÅpref;ÅulongÅsize)*Preferences_t,
ÑSetPrefs(*Preferences_tÅpref;ÅulongÅsize;ÅulongÅinform)void,
ÑSRBNUM(ushortÅn)ushort,
ÑSWBNUM(ushortÅn)ushort,
ÑSSBNUM(ushortÅn)ushort,
ÑSPARNUM(ushortÅn)ushort,
ÑSHAKNUM(ushortÅn)ushort;
