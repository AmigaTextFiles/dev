type
ÑExpansionRom_tÅ=ÅstructÅ{
àushortÅer_Type;
àushortÅer_Product;
àushortÅer_Flags;
àushortÅer_Reserved03;
àuintÅer_Manufacturer;
àulongÅer_SerialNumber;
àuintÅer_InitDiagVec;
àushortÅer_Reserved0c,Åer_Reserved0d,Åer_Reserved0e,Åer_Reserved0f;
Ñ},

ÑExpansionControl_tÅ=ÅstructÅ{
àushortÅec_Interrupt;
àushortÅec_Reserved11;
àushortÅec_BaseAddress;
àushortÅec_ShutUp;
àushortÅec_Reserved14,Åec_Reserved15,Åec_Reserved16,Åec_Reserved17,
èec_Reserved18,Åec_Reserved19,Åec_Reserved1a,Åec_Reserved1b,
èec_Reserved1c,Åec_Reserved1d,Åec_Reserved1e,Åec_Reserved1f;
Ñ};

ulong
ÑE_SLOTSIZEä=Å0x10000,
ÑE_SLOTMASKä=Å0xffff,
ÑE_SLOTSHIFTâ=Å16,

ÑE_EXPANSIONBASEÖ=Å0xe80000,
ÑE_EXPANSIONSIZEÖ=Å0x080000,
ÑE_EXPANSIONSLOTSÑ=Å8,

ÑE_MEMORYBASEà=Å0x200000,
ÑE_MEMORYSIZEà=Å0x800000,
ÑE_MEMORYSLOTSá=Å128;

ushort
ÑERT_TYPEMASKà=Å0xc0,
ÑERT_TYPEBITâ=Å6,
ÑERT_TYPESIZEà=Å2,
ÑERT_NEWBOARDà=Å0xc0,

ÑERT_MEMMASKâ=Å0x07,
ÑERT_MEMBITä=Å0,
ÑERT_MEMSIZEâ=Å3,

ÑERTB_CHAINEDCONFIGÇ=Å3,
ÑERTB_DIAGVALIDÜ=Å4,
ÑERTB_MEMLISTà=Å5,

ÑERTF_CHAINEDCONFIGÇ=Å1Å<<ÅERTB_CHAINEDCONFIG,
ÑERTF_DIAGVALIDÜ=Å1Å<<ÅERTB_DIAGVALID,
ÑERTF_MEMLISTà=Å1Å<<ÅERTB_MEMLIST,

ÑERFB_MEMSPACEá=Å7,
ÑERFB_NOSHUTUPá=Å6,

ÑERFF_MEMSPACEá=Å1Å<<ÅERFB_MEMSPACE,
ÑERFF_NOSHUTUPá=Å1Å<<ÅERFB_NOSHUTUP,

ÑECIB_INTENAâ=Å1,
ÑECIB_RESETä=Å3,
ÑECIB_INT2PENDá=Å4,
ÑECIB_INT6PENDá=Å5,
ÑECIB_INT7PENDá=Å6,
ÑECIB_INTERRUPTINGÉ=Å7,

ÑECIF_INTENAâ=Å1Å<<ÅECIB_INTENA,
ÑECIF_RESETä=Å1Å<<ÅECIB_RESET,
ÑECIF_INT2PENDá=Å1Å<<ÅECIB_INT2PEND,
ÑECIF_INT6PENDá=Å1Å<<ÅECIB_INT6PEND,
ÑECIF_INT7PENDá=Å1Å<<ÅECIB_INT7PEND,
ÑECIF_INTERRUPTINGÉ=Å1Å<<ÅECIB_INTERRUPTING;

type
ÑDiagArea_tÅ=ÅstructÅ{
àushortÅda_Config;
àushortÅda_Flags;
àuintÅda_Size;
àuintÅda_DiagPoint;
àuintÅda_BootPoint;
àuintÅda_Name;
àuintÅda_Reserved01,Åda_Reserved02;
Ñ};

ushort
ÑDAC_BUSWIDTHà=Å0xC0,
ÑDAC_NIBBLEWIDEÜ=Å0x00,
ÑDAC_BYTEWIDEà=Å0x40,
ÑDAC_WORDWIDEà=Å0x80,

ÑDAC_BOOTTIMEà=Å0x30,
ÑDAC_NEVERã=Å0x00,
ÑDAC_CONFIGTIMEÜ=Å0x10,
ÑDAC_BINDTIMEà=Å0x20;

extern
ÑEC_MEMADDR(ushortÅslot)ulong,
ÑERT_MEMNEEDED(ushortÅt)ulong,
ÑERT_SLOTSNEEDED(ushortÅt)ushort;
