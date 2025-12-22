struct MyTag
{
	struct MyTag            * mt_Succ;
	struct MyTag            * mt_Pred;
	char                    * mt_Label;
	long                      mt_Value;
	long                      mt_BufferSize;
	UBYTE                   * mt_Data;
	UWORD                     mt_TagType;
#ifdef INTERNAL
	long                      pos;
	char                      dataname[80];
	char                      title[80];
#endif
};

struct StringNode
{
	struct StringNode       * sn_Succ;
	struct StringNode       * sn_Pred;
	char                    * sn_String;
#ifdef INTERNAL
	char                      sn_st[256];
#endif
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
#ifdef INTERNAL
	struct MinList            gn_InfoList;
	struct TagItem            gn_Tags[15];
	UBYTE                   * gn_pointers[4];
	UBYTE                     gn_Joined;
	UBYTE                     pad1;
	char                      gn_EditHook[256];
	char                      gn_FontName[256];
	char                      gn_datas[256];
	char                      gn_title[256];
	char                      gn_LabelID[256];
	long                      pad2[3];
	struct TagItem            gn_ActualTagList[30];
	ULONG                   * extradata;
	char                      gn_Contents[86];
	long                      gn_Contents2;
#endif
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
#ifdef INTERNAL
	char                      fonttitle[256];
	char                      title[256];
#endif
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
#ifdef INTERNAL
	char                      title[256];
	char                      imagename[256];
#endif
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
#ifdef INTERNAL
	ULONG                     spare[4];
	char                    * wn_DefaultPubScreenName;
	char                    * wn_Title;                    /**/
	char                    * wn_ScreenTitle;              /**/
	UBYTE                     wn_MoreTags[6];
	long                      wn_LeftEdge;           /**/
	long                      wn_TopEdge;            /**/
	long                      wn_Width;              /**/
	long                      wn_Height;             /**/
	long                      wn_MinWidth;           /**/
	long                      wn_MaxWidth;           /**/
	long                      wn_MinHeight;          /**/
	long                      wn_MaxHeight;          /**/
	long                      wn_InnerWidth;         /**/
	long                      wn_InnerHeight;        /**/
	UWORD                     wn_Zoom[4];            /**/
	long                      wn_MouseQueue;         /**/
	long                      wn_RptQueue;           /**/
	UBYTE                     wn_SizeGadget;         /**/
	UBYTE                     wn_SizeBRight;         /**/
	UBYTE                     wn_SizeBBottom;        /**/
	UBYTE                     wn_DragBar;            /**/
	UBYTE                     wn_DepthGad;           /**/
	UBYTE                     wn_CloseGad;           /**/
	UBYTE                     wn_ReportMouse;        /**/
	UBYTE                     wn_NoCareRefresh;      /**/
	UBYTE                     wn_Borderless;         /**/
	UBYTE                     wn_Backdrop;           /**/
	UBYTE                     wn_GimmeZZ;            /**/
	UBYTE                     wn_Activate;           /**/
	UBYTE                     wn_RMBTrap;            /**/
	UBYTE                     wn_SimpleRefresh;      /**/
	UBYTE                     wn_SmartRefresh;       /**/
	UBYTE                     wn_AutoAdjust;         /**/
	UBYTE                     wn_MenuHelp;           /**/
	UBYTE                     wn_UseZoom;            /**/
	UBYTE                     wn_CustomScreen;       /**/
	UBYTE                     wn_PubScreen;          /**/
	UBYTE                     wn_PubScreenName;      /**/
	UBYTE                     wn_PubScreenFallBack;  /**/
	UBYTE                     wn_idcmplist[26];      /**/
	long                      wn_idcmpvalues;        /**/
	struct TextAttr           wn_GadgetFont;
	char                      wn_GadgetFontName[256];
	char                      wn_MenuTitle[256];
	char                      wn_WinParamsstr[256];
	char                      wn_DefPubName[82];
	char                      wn_RendParamsstr[256];
	char                      wn_Titlestr[256];
	char                      wn_ScreenTitlestr[256];
	char                      wn_LabelID[256];
	struct TagItem            wn_ActualTagList[60];
#endif
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
#ifdef INTERNAL
	char                      in_titlestr[80];
#endif
};

struct MenuNode
{
	struct MenuNode         * mn_Succ;
	struct MenuNode         * mn_Pred;
	struct MinList            mn_MenuList;
	char                    * mn_Label;
	struct TagItem          * mn_TagList;
	UBYTE                     mn_LocaleMenu;
#ifdef INTERNAL
	UBYTE                     mn_DefaultFont;
	long                      mn_FrontPen;
	struct TextAttr           mn_Font;
	char                      mn_textstr[80];
	char                      mn_idlabelstr[80];
	char                      mn_fontname[80];
	struct TagItem            mn_ActualTagList[6];
#endif
};

struct MenuTitleNode
{
	struct MenuTitleNode    * mt_Succ;
	struct MenuTitleNode    * mt_Pred;
	struct MinList            mt_ItemList;
	char                    * mt_Text;
	char                    * mt_Label;
	UBYTE                     mt_Disabled;
#ifdef INTERNAL
	UBYTE                     pad1;
	char                      mt_idlabelstr[80];
	char                      mt_textstr[80];
#endif
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
#ifdef INTERNAL	
	char                      mi_graphicname[80];
	char                      mi_idlabel[80];
	char                      mi_textstr[80];
#endif
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
#ifdef INTERNAL
	char                      ms_graphicname[80];
	char                      ms_idlabel[80];
	char                      ms_textstr[80];
#endif
};

struct ScreenNode
{
	struct ScreenNode       * sn_Succ;
	struct ScreenNode       * sn_Pred;
	char                    * sn_Label;
	struct TagItem          * sn_TagList;
	UBYTE                     sn_LocaleTitle;
#ifdef INTERNAL
	
	UBYTE                     sn_Bitmap;
	UBYTE                     sn_CreateBitmap;
	UBYTE                     sn_DoPubSig;
	
	char                    * sn_Title;
	char                    * sn_PubScreenName;
	
	UWORD                     sn_Left;
	UWORD                     sn_Top;
	UWORD                     sn_Width;
	UWORD                     sn_Height;
	UWORD                     sn_Depth;
	UBYTE                     sn_OverScan;
	UBYTE                     sn_FontType;
	UBYTE                     sn_Behind;
	UBYTE                     sn_Quiet;
	UBYTE                     sn_ShowTitle;
	UBYTE                     sn_AutoScroll;
	long                      sn_DisplayID;
	UWORD                     sn_ScreenType;
	UBYTE                     sn_DefaultPens;
	UBYTE                     sn_FullPalette;
	struct TextAttr           sn_Font;
	UWORD                   * sn_ColorArray;
	long                      sn_SizeColorArray;
	UWORD                     sn_PenArray[31];
	UBYTE                     sn_ErrorCode;
	UBYTE                     sn_SharePens;
	UBYTE                     sn_Draggable;
	UBYTE                     sn_Exclusive;
	UBYTE                     sn_Interleaved;
	UBYTE                     sn_LikeWorkbench;
	
	char                      sn_titlestr[256];
	char                      sn_labelid[256];
	char                      sn_pubnamestr[256];
	char                      sn_fontname[52];
	struct TagItem            sn_ActualTagList[60];

#endif
};