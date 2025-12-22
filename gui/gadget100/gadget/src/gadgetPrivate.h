#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <clib/macros.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/resident.h>
#include <exec/libraries.h>
#include <utility/tagitem.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <intuition/sghooks.h>
#include <intuition/cghooks.h>
#include <graphics/text.h>
#include <pragma/intuition_lib.h>
#include <pragma/graphics_lib.h>
#include <pragma/utility_lib.h>
#include <pragma/exec_lib.h>


#define ALLOCMEM(size)	AllocMem(size, NULL)
#define FREEMEM(ptr, size)	FreeMem(ptr, size)

#define ALLOCCHIPMEM(size) AllocMem(size, MEMF_CHIP)
#define FREECHIPMEM(ptr, size) FreeMem(ptr, size)

#define TOUPPER(x) toupper((unsigned)(x))

#define GETTAGDATA(tag, default, tagList) GetTagData13(tag, default, tagList)
#define FINDTAGITEM(tag, tagList) FindTagItem13(tag, tagList)
#define PACKBOOLTAGS(flags, tagList, boolTags) PackBoolTags13(flags, tagList, boolTags)
#define NEXTTAGITEM(tagList) NextTagItem13(tagList)

#define ISKICK20	(((struct Library *)IntuitionBase)->lib_Version >= 36)

#define UNDERSCORE '_'
#define RETURN 13
#define ESC 27
#define CODE_ARROWUP 0x4c
#define CODE_ARROWDOWN 0x4d
#define CODE_ARROWLEFT 0x4f
#define CODE_ARROWRIGHT 0x4e
#define SHIFT (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT)
#define COMMAND (IEQUALIFIER_LCOMMAND | IEQUALIFIER_RCOMMAND)
#define BORDER (GACT_LEFTBORDER | GACT_RIGHTBORDER | GACT_TOPBORDER | GACT_BOTTOMBORDER)

#define CHILD_GADGET (1<<7)
#define COMPOSED_GADGET (1<<6)
#define BEVELBORDER 1
#define CHECKMARK_GADGET 2
#define RADIOBUTTON_GADGET 3
#define STRING_GADGET 4
#define INT_GADGET 5
#define ARROW_GADGET 6
#define PROP_GADGET 7
#define TEXTBUTTON_GADGET 8
#define BOOL_GADGET 9
#define SCROLLBAR_GADGET (COMPOSED_GADGET | 10)
#define TEXT_GADGET 11
#define LISTVIEW_GADGET (COMPOSED_GADGET | 12)
#define CYCLE_GADGET 13
#define BORDER_GADGET 14
#define GETFILE_GADGET 15
#define PALETTE_GADGET (COMPOSED_GADGET | 16)
#define MX_GADGET (COMPOSED_GADGET | 17)

#define GADGET_TYPE(gad) (((gad)->GadgetID>>8) & ~(CHILD_GADGET))
#define ISCHILD_GADGET(gad)	(((gad)->GadgetID>>8) & CHILD_GADGET)

#define NEWSTRLEN(x) ((x)? (strlen(x) - (strchr((x), UNDERSCORE)!=NULL)) : 0)

#define GACO_Color gad_TagBase+19

struct GadgetBase
{
	struct Library	gad_Lib;
	unsigned long	gad_SegList;			/* seg list of mylib itself*/
};

struct GadgetExtend
{
	struct Gadget gad;
	ULONG (*setattrs)(struct Gadget *, struct Window *, struct Requester *, struct TagItem *tagList);
	ULONG (*getattr)(ULONG tag, struct Gadget *gad, ULONG *storage);
	void (*free)(struct Gadget *gad);
};

struct ComposedGadget
{
	struct GadgetExtend gx;
	USHORT num;
};
/* struct Gadget *gad[num]; */


void myInit(void);
long myOpen(void);
long myClose(void);
long myExpunge(void);
struct Gadget *gadAllocBevelBorder(ULONG tag1, ...);
struct Gadget *gadAllocBevelBorderA(struct TagItem *tagList);
struct Gadget *gadAllocTextGadget(ULONG tag1, ...);
struct Gadget *gadAllocTextGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocBoolGadget(ULONG tag1, ...);
struct Gadget *gadAllocBoolGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocTextButtonGadget(ULONG tag1, ...);
struct Gadget *gadAllocTextButtonGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocCycleGadget(ULONG tag1, ...);
struct Gadget *gadAllocCycleGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocCheckMarkGadget(ULONG tag1, ...);
struct Gadget *gadAllocCheckMarkGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocArrowGadget(ULONG tag1, ...);
struct Gadget *gadAllocArrowGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocGetFileGadget(ULONG tag1, ...);
struct Gadget *gadAllocGetFileGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocStringGadget(ULONG tag1, ...);
struct Gadget *gadAllocStringGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocIntGadget(ULONG tag1, ...);
struct Gadget *gadAllocIntGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocScrollbarGadget(ULONG tag1, ...);
struct Gadget *gadAllocScrollbarGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocListviewGadget(ULONG tag1, ...);
struct Gadget *gadAllocListviewGadgetA(struct TagItem *tagList);
struct Gadget *gadAllocPaletteGadget(ULONG tag1, ...);
struct Gadget *gadAllocPaletteGadgetA(struct TagItem *tagList);

