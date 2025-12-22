uint
„MAXFONTPATH=256,
„MAXFONTNAME=32;

type
„Node_t=unknown14,
„Library_t=unknown34,
„TextFont_t=unknown52,
„TextAttr_t=unknown8,

„FontContents_t=struct{
ˆ[MAXFONTPATH]charfc_FileName;
ˆuintfc_YSize;
ˆushortfc_Style;
ˆushortfc_Flags;
„},

„FontContentsHeader_t=struct{
ˆuintfch_FileID;
ˆuintfch_NumEntries;
ˆ[1]FontContents_tfch_FC;
„},

„DiskFontHeader_t=struct{
ˆNode_tdfh_DF;
ˆuintdfh_FileID;
ˆuintdfh_Revision;
ˆulongdfh_Segment;
ˆ[MAXFONTNAME]chardfh_Name;
ˆTextFont_tdfh_TF;
„},

„AvailFonts_t=struct{
ˆuintaf_Type;
ˆTextAttr_taf_Attr;
„},

„AvailFontsHeader_t=struct{
ˆuintafh_NumEntries;
ˆ[1]AvailFonts_tafh_AF;
„};

uint
„FCH_ID†=0x0f00,
„DFH_ID†=0x0f80,

„AFB_MEMORY‚=0,
„AFF_MEMORY‚=1,
„AFB_DISK„=1,
„AFF_DISK„=2;

extern
„OpenDiskFontLibrary(ulongversion)*Library_t,
„CloseDiskFontLibrary()void,
„AvailFonts(*bytebuffer;ulongbufBytes,types)ulong,
„OpenDiskFont(*TextAttr_ttextAttr)*TextFont_t;
