#define  TagTypeLong            0
#define  TagTypeBoolean         1
#define  TagTypeString          2
#define  TagTypeArrayByte       3
#define  TagTypeArrayWord       4
#define  TagTypeArrayLong       5
#define  TagTypeArrayString     6
#define  TagTypeStringList      7
#define  TagTypeUser            8
#define  TagTypeVisualInfo      9
#define  TagTypeDrawInfo        10
#define  TagTypeIntuiText       11
#define  TagTypeImage           12
#define  TagTypeImageData       13
#define  TagTypeLeftCoord       14
#define  TagTypeTopCoord        15
#define  TagTypeWidth           16
#define  TagTypeHeight          17
#define  TagTypeGadgetID        18
#define  TagTypeFont            19
#define  TagTypeScreen          20
#define  TagTypeGadget          21
#define  TagTypeUser2           22

#define  MYBOOL_KIND            227
#define  MYOBJECT_KIND          198

struct ProducerNode
{
	struct MinList            pn_WindowList;
	struct MinList            pn_MenuList;
	struct MinList            pn_ImageList;
	struct MinList            pn_ScreenList;
	
	struct MinList            pn_LocaleList;
	long                      pn_LocaleCount;
	char                    * pn_BaseName;
	char                    * pn_GetString;
	char                    * pn_BuiltInLanguage;
	long                      pn_LocaleVersion;
	
	UBYTE                     pn_ProcedureOptions[50];
	UBYTE                     pn_CodeOptions[20];
	UBYTE                     pn_OpenLibs[30];
	long                      pn_VersionLibs[30];
	UBYTE                     pn_AbortOnFailLibs[30];
	char                    * pn_Includes;
};

struct MyTag
{
	struct MyTag            * mt_Succ;
	struct MyTag            * mt_Pred;
	char                    * mt_Label;
	long                      mt_Value;
	long                      mt_BufferSize;
	UBYTE                   * mt_Data;
	UWORD                     mt_TagType;
};

struct StringNode
{
	struct StringNode       * sn_Succ;
	struct StringNode       * sn_Pred;
	char                    * sn_String;
};

struct GadgetNode
{
	struct GadgetNode       * gn_Succ;
	struct GadgetNode       * gn_Pred;
	char                    * gn_Label;
	char                    * gn_Title;
	struct TagItem          * gn_TagList;
	long                      gn_Flags;
	long                      gn_LeftEdge;
	long                      gn_TopEdge;
	long                      gn_Width;
	long                      gn_Height;
	long                      gn_GadgetID;
	long                      gn_Kind;
	struct TextAttr           gn_Font;
};

struct TextNode
{
	struct TextNode         * tn_Succ;
	struct TextNode         * tn_Pred;
	char                    * tn_Title;
	long                      tn_LeftEdge;
	long                      tn_TopEdge;
	struct TextAttr           tn_Font;
	UBYTE                     tn_FrontPen;
	UBYTE                     tn_BackPen;
	UBYTE                     tn_DrawMode;
	UBYTE                     tn_ScreenFont;
};

struct BevelBoxNode
{
	struct BevelBoxNode     * bb_Succ;
	struct BevelBoxNode     * bb_Pred;
	long                      bb_LeftEdge;
	long                      bb_TopEdge;
	long                      bb_Width;
	long                      bb_Height;
	UWORD                     bb_BevelType;
};

struct SmallImageNode
{
	struct SmallImageNode   * sin_Succ;
	struct SmallImageNode   * sin_Pred;
	struct ImageNode        * sin_Image;
	long                      sin_LeftEdge;
	long                      sin_TopEdge;
};

struct WindowNode
{
	struct WindowNode       * wn_Succ;
	struct WindowNode       * wn_Pred;
	struct MinList            wn_GadgetList;
	struct MinList            wn_TextList;
	struct MinList            wn_ImageList;
	struct MinList            wn_BevelBoxList;
	char                    * wn_Label;
	char                    * wn_WinParams;
	char                    * wn_RendParams;
	struct TagItem          * wn_TagList;
	struct MenuNode         * wn_Menu;
	UBYTE                     wn_LocaleOptions[6];
	UBYTE                     wn_CodeOptions[20];
	UBYTE                     wn_ExtraCodeOptions[20];
	UWORD                     wn_Offx;
	UWORD                     wn_Offy;
	UWORD                     wn_Fontx;
	UWORD                     wn_Fonty;
	long                      wn_FirstID;
};

struct LocaleNode
{
	struct LocaleNode       * ln_Succ;
   	struct LocaleNode       * ln_Pred;
	char                    * ln_String;
	char                    * ln_Label;
	char                    * ln_Comment;
};

struct ImageNode 
{
	struct ImageNode        * in_Succ;
	struct ImageNode        * in_Pred;
	char                    * in_Label;
	WORD                      in_Width;
	WORD                      in_Height;
	WORD                      in_Depth;
	UBYTE                     in_PlanePick;
	UBYTE                     in_PlaneOnOff;
	UBYTE                   * in_ImageData;
	long                      in_SizeAllocated;
	UBYTE                   * in_ColourMap;
	long                      in_MapSize;
};

struct MenuNode
{
	struct MenuNode         * mn_Succ;
	struct MenuNode         * mn_Pred;
	struct MinList            mn_MenuList;
	char                    * mn_Label;
	struct TagItem          * mn_TagList;
	UBYTE                     mn_LocaleMenu;
};

struct MenuTitleNode
{
	struct MenuTitleNode    * mt_Succ;
	struct MenuTitleNode    * mt_Pred;
	struct MinList            mt_ItemList;
	char                    * mt_Text;
	char                    * mt_Label;
	UBYTE                     mt_Disabled;
};

struct MenuItemNode
{
	struct MenuItemNode     * mi_Succ;
	struct MenuItemNode     * mi_Pred;
	struct MinList            mi_SubItemList;
	char                    * mi_Text;
	char                    * mi_Label;
	struct ImageNode        * mi_Graphic;
	char                      mi_CommKey;
	UBYTE                     mi_Disabled;
	UBYTE                     mi_Checkit;
	UBYTE                     mi_MenuToggle;
	UBYTE                     mi_Checked;
	UBYTE                     mi_Barlabel;
	long                      mi_Exclude;
};

struct MenuSubItemNode
{
	struct MenuSubItemNode  * ms_Succ;
	struct MenuSubItemNode  * ms_Pred;
	char                    * ms_Text;
	char                    * ms_Label;
	struct ImageNode        * ms_Graphic;
	char                      ms_CommKey;
	UBYTE                     ms_Disabled;
	UBYTE                     ms_Checkit;
	UBYTE                     ms_MenuToggle;
	UBYTE                     ms_Checked;
	UBYTE                     ms_Barlabel;
	long                      ms_Exclude;
};

struct ScreenNode
{
	struct ScreenNode       * sn_Succ;
	struct ScreenNode       * sn_Pred;
	char                    * sn_Label;
	struct TagItem          * sn_TagList;
	UBYTE                     sn_LocaleTitle;
};