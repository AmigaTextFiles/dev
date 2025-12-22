def ACPU_BusErr = $80000002;
def ACPU_AddressErr = $80000003;
def ACPU_InstErr = $80000004;
def ACPU_DivZero = $80000005;
def ACPU_CHK = $80000006;
def ACPU_TRAPV = $80000007;
def ACPU_PrivErr = $80000008;
def ACPU_Trace = $80000009;
def ACPU_LineA = $8000000a;
def ACPU_LineF = $8000000b;
def ACPU_Format = $8000000e;
def ACPU_Spurious = $80000018;
def ACPU_AutoVec1 = $80000019;
def ACPU_AutoVec2 = $8000001a;
def ACPU_AutoVec3 = $8000001b;
def ACPU_AutoVec4 = $8000001c;
def ACPU_AutoVec5 = $8000001d;
def ACPU_AutoVec6 = $8000001e;
def ACPU_AutoVec7 = $8000001f;

def AT_DeadEnd = $80000000;
def AT_Recovery = $00000000;

def AG_NoMemory = $00010000;
def AG_MakeLib = $00020000;
def AG_OpenLib = $00030000;
def AG_OpenDev = $00040000;
def AG_OpenRes = $00050000;
def AG_IOError = $00060000;
def AG_NoSignal = $00070000;
def AG_BadParm = $00080000;
def AG_CloseLib = $00090000;
def AG_CloseDev = $000a0000;
def AG_ProcCreate = $000b0000;

def AO_ExecLib = $00008001;
def AO_GraphicsLib = $00008002;
def AO_LayersLib = $00008003;
def AO_Intuition = $00008004;
def AO_MathLib = $00008005;
def AO_DOSLib = $00008007;
def AO_RAMLib = $00008008;
def AO_IconLib = $00008009;
def AO_ExpansionLib = $0000800a;
def AO_DiskfontLib = $0000800b;
def AO_UtilityLib = $0000800c;
def AO_KeyMapLib = $0000800d;

def AO_AudioDev = $00008010;
def AO_ConsoleDev = $00008011;
def AO_GamePortDev = $00008012;
def AO_KeyboardDev = $00008013;
def AO_TrackDiskDev = $00008014;
def AO_TimerDev = $00008015;

def AO_CIARsrc = $00008020;
def AO_DiskRsrc = $00008021;
def AO_MiscRsrc = $00008022;

def AO_BootStrap = $00008030;
def AO_Workbench = $00008031;
def AO_DiskCopy = $00008032;
def AO_GadTools = $00008033;
def AO_Unknown = $00008035;

def AN_ExecLib = $01000000;
def AN_ExcptVect = $01000001;
def AN_BaseChkSum = $01000002;
def AN_LibChkSum = $01000003;

def AN_MemCorrupt = $81000005;
def AN_IntrMem = $81000006;
def AN_InitAPtr = $01000007;
def AN_SemCorrupt = $01000008;
def AN_FreeTwice = $01000009;
def AN_BogusExcpt = $8100000a;
def AN_IOUsedTwice = $0100000b;
def AN_MemoryInsane = $0100000c;
def AN_IOAfterClose = $0100000d;
def AN_StackProbe = $0100000e;
def AN_BadFreeAddr = $0100000f;
def AN_BadSemaphore = $01000010;

def AN_GraphicsLib = $02000000;
def AN_GfxNoMem = $82010000;
def AN_GfxNoMemMspc = $82010001;
def AN_LongFrame = $82010006;
def AN_ShortFrame = $82010007;
def AN_TextTmpRas = $02010009;
def AN_BltBitMap = $8201000a;
def AN_RegionMemory = $8201000b;
def AN_MakeVPort = $82010030;
def AN_GfxNewError = $0200000c;
def AN_GfxFreeError = $0200000d;

def AN_GfxNoLCM = $82011234;

def AN_ObsoleteFont = $02000401;

def AN_LayersLib = $03000000;
def AN_LayersNoMem = $83010000;

def AN_Intuition = $04000000;
def AN_GadgetType = $84000001;
def AN_BadGadget = $04000001;
def AN_CreatePort = $84010002;
def AN_ItemAlloc = $04010003;
def AN_SubAlloc = $04010004;
def AN_PlaneAlloc = $84010005;
def AN_ItemBoxTop = $84000006;
def AN_OpenScreen = $84010007;
def AN_OpenScrnRast = $84010008;
def AN_SysScrnType = $84000009;
def AN_AddSWGadget = $8401000a;
def AN_OpenWindow = $8401000b;
def AN_BadState = $8400000c;
def AN_BadMessage = $8400000d;
def AN_WeirdEcho = $8400000e;
def AN_NoConsole = $8400000f;
def AN_NoISem = $04000010;
def AN_ISemOrder = $04000011;

def AN_MathLib = $05000000;

def AN_DOSLib = $07000000;
def AN_StartMem = $07010001;
def AN_EndTask = $07000002;
def AN_QPktFail = $07000003;
def AN_AsyncPkt = $07000004;
def AN_FreeVec = $07000005;
def AN_DiskBlkSeq = $07000006;
def AN_BitMap = $07000007;
def AN_KeyFree = $07000008;
def AN_BadChkSum = $07000009;
def AN_DiskError = $0700000a;
def AN_KeyRange = $0700000b;
def AN_BadOverlay = $0700000c;
def AN_BadInitFunc = $0700000d;
def AN_FileReclosed = $0700000e;

def AN_RAMLib = $08000000;
def AN_BadSegList = $08000001;

def AN_IconLib = $09000000;

def AN_ExpansionLib = $0a000000;
def AN_BadExpansionFree = $0a000001;

def AN_DiskfontLib = $0b000000;

def AN_AudioDev = $10000000;

def AN_ConsoleDev = $11000000;
def AN_NoWindow = $11000001;

def AN_GamePortDev = $12000000;

def AN_KeyboardDev = $13000000;

def AN_TrackDiskDev = $14000000;
def AN_TDCalibSeek = $14000001;
def AN_TDDelay = $14000002;

def AN_TimerDev = $15000000;
def AN_TMBadReq = $15000001;
def AN_TMBadSupply = $15000002;

def AN_CIARsrc = $20000000;

def AN_DiskRsrc = $21000000;
def AN_DRHasDisk = $21000001;
def AN_DRIntNoAct = $21000002;

def AN_MiscRsrc = $22000000;

def AN_BootStrap = $30000000;
def AN_BootError = $30000001;

def AN_Workbench = $31000000;
def AN_NoFonts = $b1000001;
def AN_WBBadStartupMsg1 = $31000001;
def AN_WBBadStartupMsg2 = $31000002;
def AN_WBBadIOMsg = $31000003;
def AN_WBReLayoutToolMenu = $b1010009;

def AN_DiskCopy = $32000000;

def AN_GadTools = $33000000;

def AN_UtilityLib = $34000000;

def AN_Unknown = $35000000;

