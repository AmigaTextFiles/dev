#ifndef ITEMLISTCLASS_H
#define ITEMLISTCLASS_H

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#include <classes/itemclass.h>

#define IM_ADDMEMBERADJUST 0x300L
#define IM_REMMEMBERADJUST 0x301L

struct gpMember {
	ULONG MethodID;
	Object *gpm_Object;
	struct DrawInfo *gpm_Dri;
};

#define ILGA_Dummy (TAG_USER + 0x50000)
#define ILGA_Top (ILGA_Dummy + 1)
#define ILGA_ItemHeight (ILGA_Dummy + 2)
#define ILGA_Visible (ILGA_Dummy + 3)
#define ILGA_Total (ILGA_Dummy + 4)
#define ILGA_Selected (ILGA_Dummy + 5)
#define ILGA_SelectedItem (ILGA_Dummy + 7)
#define ILGA_NumSelectable (ILGA_Dummy + 8)
#define ILGA_Drag (ILGA_Dummy + 9)
#define ILGA_FirstItem (ILGA_Dummy + 10)
#define ILGA_NoCareShift (ILGA_Dummy + 11)
#define ILGA_DontHold (ILGA_Dummy + 12)
#define ILGA_Lock (ILGA_Dummy + 13)
#define ILGA_ItemDrawInfo (ILGA_Dummy + 14)

#define NS_NONE 0
#define NS_ONE 1
#define NS_ALL 2

#endif
