//
//  $VER: Boopsi.h      1.0 (16 Jun 1996)
//
//    c 1996 Thomas Wilhelmi
//
//
// Address : Taunusstrasse 14
//           61138 Niederdorfelden
//           Germany
//
//  E-Mail : willi@twi.rhein-main.de
//
//   Phone : +49 (0)6101 531060
//   Fax   : +49 (0)6101 531061
//
//
//  $HISTORY:
//
//  16 Jun 1996 :   1.0 : first public Release
//

#ifndef CPP_TWIMUI_BOOPSI_H
#define CPP_TWIMUI_BOOPSI_H

#ifndef CPP_TWIMUI_GADGET_H
#include <classes/twimui/gadget.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

class MUIBoopsi : public MUIGadget
	{
	public:
		MUIBoopsi(const struct TagItem *t) : MUIGadget(MUIC_Boopsi) { init(t); };
		MUIBoopsi(const Tag, ...);
		MUIBoopsi() : MUIGadget(MUIC_Boopsi) { };
		MUIBoopsi(MUIBoopsi &p) : MUIGadget(p) { };
		virtual ~MUIBoopsi();
		MUIBoopsi &operator= (MUIBoopsi &);
		void Class(const struct IClass *p) { set(MUIA_Boopsi_Class,(ULONG)p); };
		struct IClass *Class() const { return((struct IClass *)get(MUIA_Boopsi_Class,NULL)); };
		void ClassID(const UBYTE *p) { set(MUIA_Boopsi_ClassID,(ULONG)p); };
		UBYTE *ClassID() const { return((UBYTE *)get(MUIA_Boopsi_ClassID,'\0')); };
		void MaxHeight(const ULONG p) { set(MUIA_Boopsi_MaxHeight,p); };
		ULONG MaxHeight() const { return(get(MUIA_Boopsi_MaxHeight,0UL)); };
		void MaxWidth(const ULONG p) { set(MUIA_Boopsi_MaxWidth,p); };
		ULONG MaxWidth() const { return(get(MUIA_Boopsi_MaxWidth,0UL)); };
		void MinHeight(const ULONG p) { set(MUIA_Boopsi_MinHeight,p); };
		ULONG MinHeight() const { return(get(MUIA_Boopsi_MinHeight,0UL)); };
		void MinWidth(const ULONG p) { set(MUIA_Boopsi_MinWidth,p); };
		ULONG MinWidth() const { return(get(MUIA_Boopsi_MinWidth,0UL)); };
		Object *ObjectP() const { return((Object *)get(MUIA_Boopsi_Object,NULL)); };
		void TagDrawInfo(const ULONG p) { set(MUIA_Boopsi_TagDrawInfo,p); };
		ULONG TagDrawInfo() const { return(get(MUIA_Boopsi_TagDrawInfo,0UL)); };
		void TagScreen(const ULONG p) { set(MUIA_Boopsi_TagScreen,p); };
		ULONG TagScreen() const { return(get(MUIA_Boopsi_TagScreen,0UL)); };
		void TagWindow(const ULONG p) { set(MUIA_Boopsi_TagWindow,p); };
		ULONG TagWindow() const { return(get(MUIA_Boopsi_TagWindow,0UL)); };
	};

#endif
