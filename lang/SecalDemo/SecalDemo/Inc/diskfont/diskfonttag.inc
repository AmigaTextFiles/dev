include "inc/exec/types.inc";
include "inc/utility/tagitem.inc";

def OT_Level0 = TAG_USER;
def OT_Level1 = (TAG_USER|$1000);
def OT_Level2 = (TAG_USER|$2000);
def OT_Level3 = (TAG_USER|$3000);
def OT_Indirect = $8000;

def OT_DeviceDPI = (OT_Level0|$01);
def OT_DotSize = (OT_Level0|$02);
def OT_PointHeight = (OT_Level0|$08);
def OT_SetFactor = (OT_Level0|$09);
def OT_ShearSin = (OT_Level0|$0a);
def OT_ShearCos = (OT_Level0|$0b);
def OT_RotateSin = (OT_Level0|$0c);
def OT_RotateCos = (OT_Level0|$0d);
def OT_EmboldenX = (OT_Level0|$0e);
def OT_EmboldenY = (OT_Level0|$0f);
def OT_PointSize = (OT_Level0|$10);
def OT_GlyphCode = (OT_Level0|$11);
def OT_GlyphCode2 = (OT_Level0|$12);
def OT_GlyphWidth = (OT_Level0|$13);
def OT_OTagPath = (OT_Level0|OT_Indirect|$14);
def OT_OTagList = (OT_Level0|OT_Indirect|$15);
def OT_GlyphMap = (OT_Level0|OT_Indirect|$20);
def OT_WidthList = (OT_Level0|OT_Indirect|$21);
def OT_TextKernPair = (OT_Level0|OT_Indirect|$22);
def OT_DesignKernPair = (OT_Level0|OT_Indirect|$23);
def OT_UnderLined = (OT_Level0|$24);

def OTUL_None = 0;
def OTUL_Solid = 1;
def OTUL_Broken = 2;
def OTUL_DoubleSolid = 3;
def OUTL_DoubleBroken = 4;

def OT_StrikeThrough = (OT_Level0|$25);

def OTSUFFIX = ".otag";

def OT_FileIdent = (OT_Level1|$01);
def OT_Engine = (OT_Level1|OT_Indirect|$02);

def OTE_Bullet = "bullet";

def OT_Family = (OT_Level1|OT_Indirect|$03);
def OT_BName = (OT_Level2|OT_Indirect|$05);
def OT_IName = (OT_Level2|OT_Indirect|$06);
def OT_BIName = (OT_Level2|OT_Indirect|$07);
def OT_SymbolSet = (OT_Level1|$10);
def OT_YSizeFactor = (OT_Level1|$11);
def OT_SpaceWidth = (OT_Level2|$12);
def OT_IsFixed = (OT_Level2|$13);
def OT_SerifFlag = (OT_Level1|$14);
def OT_StemWeight = (OT_Level1|$15);

def OTS_UltraThin = 8;
def OTS_ExtraThin = 24;
def OTS_Thin = 40;
def OTS_ExtraLight = 56;
def OTS_Light = 72;
def OTS_DemiLight = 88;
def OTS_SemiLight = 104;
def OTS_Book = 120;
def OTS_Medium = 136;
def OTS_SemiBold = 152;
def OTS_DemiBold = 168;
def OTS_Bold = 184;
def OTS_ExtraBold = 200;
def OTS_Black = 216;
def OTS_ExtraBlack = 232;
def OTS_UltraBlack = 248;

def OT_SlantStyle = (OT_Level1|$16);

def OTS_Upright = 0;
def OTS_Italic = 1;
def OTS_LeftItalic = 2;

def OT_HorizStyle = (OT_Level1|$17);

def OTH_UltraCompressed = 16;
def OTH_ExtraCompressed = 48;
def OTH_Compressed = 80;
def OTH_Condensed = 112;
def OTH_Normal = 144;
def OTH_SemiExpanded = 176;
def OTH_Expanded = 208;
def OTH_ExtraExpanded = 240;

def OT_SpaceFactor = (OT_Level2|$18);
def OT_InhibitAlgoStyle = (OT_Level2|$19);
def OT_AvailSizes = (OT_Level1|OT_Indirect|$20);
def OT_MAXAVAILSIZES = 20;
def OT_SpecCount = (OT_Level1|$100);
def OT_Spec = (OT_Level1|$100);
def OT_Spec1 = (OT_Level1|$101);

