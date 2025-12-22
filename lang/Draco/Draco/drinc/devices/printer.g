/*ÅrequiresÅpreviousÅinclusionÅofÅinclude:exec/io.gÅ*/
uint
ÑPRD_RAWWRITEà=ÅCMD_NONSTD+0,
ÑPRD_PRTCOMMANDÜ=ÅCMD_NONSTD+1,
ÑPRD_DUMPRPORTá=ÅCMD_NONSTD+2;

byte
ÑaRISà=Å0,
ÑaRINà=Å1,
ÑaINDà=Å2,
ÑaNELà=Å3,
ÑaRIâ=Å4,

ÑaSGR0á=Å5,
ÑaSGR3á=Å6,
ÑaSGR23Ü=Å7,
ÑaSGR4á=Å8,
ÑaSGR24Ü=Å9,
ÑaSGR1á=Å10,
ÑaSGR22Ü=Å11,
ÑaSFCà=Å12,
ÑaSBCà=Å13,

ÑaSHORP0Ö=Å14,
ÑaSHORP2Ö=Å15,
ÑaSHORP1Ö=Å16,
ÑaSHORP4Ö=Å17,
ÑaSHORP3Ö=Å18,
ÑaSHORP6Ö=Å19,
ÑaSHORP5Ö=Å20,

ÑaDEN6á=Å21,
ÑaDEN5á=Å22,
ÑaDEN4á=Å23,
ÑaDEN3á=Å24,
ÑaDEN2á=Å25,
ÑaDEN1á=Å26,

ÑaSUS2á=Å27,
ÑaSUS1á=Å28,
ÑaSUS4á=Å29,
ÑaSUS3á=Å30,
ÑaSUS0á=Å31,
ÑaPLUà=Å32,
ÑaPLDà=Å33,

ÑaFNT0á=Å34,
ÑaFNT1á=Å35,
ÑaFNT2á=Å36,
ÑaFNT3á=Å37,
ÑaFNT4á=Å38,
ÑaFNT5á=Å39,
ÑaFNT6á=Å40,
ÑaFNT7á=Å41,
ÑaFNT8á=Å42,
ÑaFNT9á=Å43,
ÑaFNT10Ü=Å44,

ÑaPROP2Ü=Å45,
ÑaPROP1Ü=Å46,
ÑaPROP0Ü=Å47,
ÑaTSSà=Å48,
ÑaJFY5á=Å49,
ÑaJFY7á=Å50,
ÑaJFY6á=Å51,
ÑaJFY0á=Å52,
ÑaJFY3á=Å53,
ÑaJFY1á=Å54,

ÑaVERP0Ü=Å55,
ÑaVERP1Ü=Å56,
ÑaSLPPá=Å57,
ÑaPERFá=Å58,
ÑaPERF0Ü=Å59,

ÑaLMSà=Å60,
ÑaRMSà=Å61,
ÑaTMSà=Å62,
ÑaBMSà=Å63,
ÑaSTBMá=Å64,
ÑaSLRMá=Å65,
ÑaCAMà=Å66,

ÑaHTSà=Å67,
ÑaVTSà=Å68,
ÑaTBC0á=Å69,
ÑaTBC3á=Å70,
ÑaTBC1á=Å71,
ÑaTBC4á=Å72,
ÑaTBCALLÖ=Å73,
ÑaTBSALLÖ=Å74,
ÑaEXTENDÖ=Å75;

type
ÑIOPrtCmdReq_tÅ=ÅstructÅ{
àMessage_tÅiop_Message;
à*Device_tÅiop_Device;
à*Unit_tÅiop_Unit;
àuintÅiop_Command;
àushortÅiop_Flags;
àshortÅiop_Error;
àuintÅiop_PrtCommand;
àushortÅiop_Parm0,Åiop_Parm1,Åiop_Parm2,Åiop_Parm3;
Ñ},

ÑIODRPReq_tÅ=ÅstructÅ{
àMessage_tÅiodrp_Message;
à*Device_tÅiodrp_Device;
à*Unit_tÅiodrp_Unit;
àuintÅiodrp_Command;
àushortÅiodrp_Flags;
àshortÅiodrp_Error;
à*RastPort_tÅiodrp_RastPort;
à*ColorMap_tÅiodrp_ColorMap;
àulongÅiodrp_Modes;
àuintÅiodrp_SrcX,Åiodrp_SrcY,Åiodrp_SrcWidth,Åiodrp_SrcHeight;
àulongÅiodrp_DestCols,Åiodrp_DestRows;
àuintÅiodrp_Special;
Ñ};

uint
ÑSPECIAL_MILCOLSÖ=Å0x001,
ÑSPECIAL_MILROWSÖ=Å0x002,
ÑSPECIAL_FULLCOLSÑ=Å0x004,
ÑSPECIAL_FULLROWSÑ=Å0x008,
ÑSPECIAL_FRACCOLSÑ=Å0x010,
ÑSPECIAL_FRACROWSÑ=Å0x020,
ÑSPECIAL_ASPECTÜ=Å0x080,
ÑSPECIAL_DENSITYMASKÅ=Å0xF00,
ÑSPECIAL_DENSITY1Ñ=Å0x100,
ÑSPECIAL_DENSITY2Ñ=Å0x200,
ÑSPECIAL_DENSITY3Ñ=Å0x300,
ÑSPECIAL_DENSITY4Ñ=Å0x400,
ÑSPECIAL_CENTERÜ=Å0x040;

int
ÑPDERR_CANCELê=Å1,
ÑPDERR_NOTGRAPHICSã=Å2,
ÑPDERR_INVERTHAMç=Å3,
ÑPDERR_BADDIMENSIONä=Å4,
ÑPDERR_DIMENSIONOVFLOWá=Å5,
ÑPDERR_INTERNALMEMORYà=Å6,
ÑPDERR_BUFFERMEMORYä=Å7;
