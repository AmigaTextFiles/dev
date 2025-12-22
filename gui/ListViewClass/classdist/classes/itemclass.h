#ifndef ITEMCLASS_H
#define ITEMCLASS_H TRUE

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#define IM_DIMENSIONS 0x220L
#define IM_ENQUEUE 0x221L
#define IM_INSERT 0x223L
#define IM_REMOVE 0x224L
#define IM_ADDHEAD 0x225L
#define IM_ADDTAIL 0x226L

struct itpEnqueue {
	ULONG MethodID;
	struct Node *itp_Node;
	struct List *itp_List;
};

struct itpInsert {
	ULONG MethodID;
	struct List *itp_List;
	struct Node *itp_Pred;
};

struct itpRemove {
	ULONG MethodID;
};

struct itpAddItem {
	ULONG MethodID;
	struct List *itp_List;
};

struct itDim {
	WORD Width;
	WORD Height;
};

struct itpDimensions {
	ULONG MethodID;
	struct itDim *itp_Dimensions;
	struct DrawInfo *itp_DrInfo;
};

struct itpDraw {
	ULONG MethodID;
	struct RastPort *itp_RPort;
	struct {
		WORD X;
		WORD Y;
	} itp_Offset;
	struct {
		WORD Width;
		WORD Height;
	} itp_Bounds;
	struct DrawInfo *itp_DrInfo;
};

struct itpErase {
	ULONG MethodID;
	struct RastPort *itp_RPort;
	struct {
		WORD X;
		WORD Y;
	} itp_Offset;
	struct {
		WORD Width;
		WORD Height;
	} itp_Bounds;
};

struct Item {
	struct Node it_Link;
	Object *it_SubItem;
	ULONG it_Flags;
	struct DrawInfo *it_Dri;
	ULONG it_ID;
	ULONG it_UserData;
};

#define IA_SubItem (IA_Dummy + 20)
#define IA_ID (IA_Dummy + 21)
#define IA_UserData (IA_Dummy + 22)
#define IA_JULeft (IA_Dummy + 23)
#define IA_JUCenter (IA_Dummy + 24)
#define IA_JURight (IA_Dummy + 25)
#define IA_Selected (IA_Dummy + 26)
#define IA_Name (IA_Dummy + 27)
#define IA_Pri (IA_Dummy + 28)
#define IA_DrawInfo (IA_Dummy + 29)
#define IA_JUTop (IA_Dummy + 30)
#define IA_JUVCenter (IA_Dummy + 31)
#define IA_JUBottom (IA_Dummy + 32)
#define IA_NoBack (IA_Dummy + 33)

/* Flags */
#define IAB_JULEFT 0
#define IAB_JUCENTER 1
#define IAB_JURIGHT 2
#define IAB_JUTOP 3
#define IAB_JUVCENTER 4
#define IAB_JUBOTTOM 5
#define IAB_SELECTED 6
#define IAB_NOBACK 7

#define IAF_JULEFT (1L << IAB_JULEFT)
#define IAF_JUCENTER (1L << IAB_JUCENTER)
#define IAF_JURIGHT (1L << IAB_JURIGHT)
#define IAF_JUTOP (1L << IAB_JUTOP)
#define IAF_JUVCENTER (1L << IAB_JUVCENTER)
#define IAF_JUBOTTOM (1L << IAB_JUBOTTOM)
#define IAF_SELECTED (1L << IAB_SELECTED)
#define IAF_NOBACK (1L << IAB_NOBACK)

/* Cast Macros for the Method Msgs */
#define DIM(o) ((struct itpDimensions *)(o))
#define DRA(o) ((struct itpDraw *)(o))
#define ERA(o) ((struct itpErase *)(o))
#define ENQ(o) ((struct itpEnqueue *)(o))
#define INS(o) ((struct itpInsert *)(o))
#define REM(o) ((struct itpRemove *)(o))
#define ADDI(o) ((struct itpAddItem *)(o))

#define IT(o) ((struct Item *)(o))

/* Used for pens in the item DrawInfo */
#define ITEXTPEN 0x0002
#define ISHINEPEN 0x0003
#define ISHADOWPEN 0x0004
#define IHIGHLIGHTTEXTPEN 0x0008
#define IBACKPEN 0x0007
#define IHIGHLIGHTBACKPEN 0x0009

#define IPENNUM 11

#endif
