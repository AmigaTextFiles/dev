/* scanner.h */

#define FOUND		0x8000
#define NUMBER(number)	((number) & 0x7FFF)

#define BITMAP_KIND		0
#define BOOLINFO_KIND		1
#define BORDER_KIND		2
#define GADGET_KIND		3
#define IMAGE_KIND		4
#define INTUIMESSAGE_KIND	5
#define INTUITEXT_KIND		6
#define KEYMAP_KIND		7
#define LAYER_KIND		8
#define MENU_KIND		9
#define MSGPORT_KIND		10
#define PROPINFO_KIND		11
#define RASTPORT_KIND		12
#define REQUESTER_KIND		13
#define SCREEN_KIND		14
#define STRINGINFO_KIND		15
#define TEXTATTR_KIND		16
#define TEXTFONT_KIND		17
#define WINDOW_KIND		18
#define MAXSTRUCTURE		19

#define BitMapNumber(item)	structNumber((APTR)item, BITMAP_KIND)
#define BoolInfoNumber(item)	structNumber((APTR)item, BOOLINFO_KIND)
#define BorderNumber(item)	structNumber((APTR)item, BORDER_KIND)
#define GadgetNumber(item)	structNumber((APTR)item, GADGET_KIND)
#define ImageNumber(item)	structNumber((APTR)item, IMAGE_KIND)
#define IntuiMessageNumber(item) structNumber((APTR)item, INTUIMESSAGE_KIND)
#define IntuiTextNumber(item)	structNumber((APTR)item, INTUITEXT_KIND)
#define KeyMapNumber(item)	structNumber((APTR)item, KEYMAP_KIND)
#define LayerNumber(item)	structNumber((APTR)item, LAYER_KIND)
#define MenuNumber(item)	structNumber((APTR)item, MENU_KIND)
#define MsgPortNumber(item)	structNumber((APTR)item, MSGPORT_KIND)
#define PropInfoNumber(item)	structNumber((APTR)item, PROPINFO_KIND)
#define RastPortNumber(item)	structNumber((APTR)item, RASTPORT_KIND)
#define RequesterNumber(item)	structNumber((APTR)item, REQUESTER_KIND)
#define ScreenNumber(item)	structNumber((APTR)item, SCREEN_KIND)
#define StringInfoNumber(item)	structNumber((APTR)item, STRINGINFO_KIND)
#define TextAttrNumber(item)	structNumber((APTR)item, TEXTATTR_KIND)
#define TextFontNumber(item)	structNumber((APTR)item, TEXTFONT_KIND)
#define WindowNumber(item)	structNumber((APTR)item, WINDOW_KIND)

#define BitMapName(number)	structName(number, BITMAP_KIND)
#define BoolInfoName(number)	structName(number, BOOLINFO_KIND)
#define BorderName(number)	structName(number, BORDER_KIND)
#define GadgetName(number)	structName(number, GADGET_KIND)
#define ImageName(number)	structName(number, IMAGE_KIND)
#define IntuiMessageName(number) structName(number, INTUIMESSAGE_KIND)
#define IntuiTextName(number)	structName(number, INTUITEXT_KIND)
#define KeyMapName(number)	structName(number, KEYMAP_KIND)
#define LayerName(number)	structName(number, LAYER_KIND)
#define MenuName(number)	structName(number, MENU_KIND)
#define MsgPortName(number)	structName(number, MSGPORT_KIND)
#define PropInfoName(number)	structName(number, PROPINFO_KIND)
#define RastPortName(number)	structName(number, RASTPORT_KIND)
#define RequesterName(number)	structName(number, REQUESTER_KIND)
#define ScreenName(number)	structName(number, SCREEN_KIND)
#define StringInfoName(number)	structName(number, STRINGINFO_KIND)
#define TextAttrName(number)	structName(number, TEXTATTR_KIND)
#define TextFontName(number)	structName(number, TEXTFONT_KIND)
#define WindowName(number)	structName(number, WINDOW_KIND)

struct structList
{
  struct structList *next;
  APTR structure;
  WORD number;
};

extern void
EraseStructList(void),
ListBitMaps(void),
ListBoolInfos(void),
ListBorders(void),
ListGadgets(void),
ListImages(void),
ListIntuiMessages(void),
ListIntuiTexts(void),
ListKeyMaps(void),
ListLayers(void),
ListMenus(void),
ListMsgPorts(void),
ListPropInfos(void),
ListRastPorts(void),
ListRequesters(void),
ListScreens(void),
ListStringInfos(void),
ListTextAttrs(void),
ListTextFonts(void),
ListWindows(void),
main(int, BYTE **),
PrintBytes(UBYTE *, UBYTE *, UBYTE *, UBYTE *, WORD, WORD),
PrintWords(UBYTE *, UBYTE *, UBYTE *, UWORD *, UBYTE *, WORD, WORD),
ScanBitMaps(struct BitMap *),
ScanBoolInfos(struct BoolInfo *),
ScanBorders(struct Border *),
ScanGadgets(struct Gadget *),
ScanImages(struct Image *),
ScanIntuiMessages(struct IntuiMessage *),
ScanIntuiTexts(struct IntuiText *),
ScanKeyMaps(struct KeyMap *),
ScanLayers(struct Layer *),
ScanMenus(struct Menu *),
ScanMsgPorts(struct MsgPort *),
ScanPropInfos(struct PropInfo *),
ScanRastPorts(struct RastPort *),
ScanRequesters(struct Requester *),
ScanScreens(struct Screen *),
ScanStringInfos(struct StringInfo *),
ScanTextAttrs(struct TextAttr *),
ScanTextFonts(struct TextFont *),
ScanWindows(struct Window *);

extern UBYTE
*APTRName(UBYTE *),
*MemoryName(APTR),
*structName(WORD, WORD),
*TitleName(UBYTE *);

extern BYTE
Fresh(WORD);

extern WORD
structNumber(APTR, WORD);
