//
//  $VER: Rectangle.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_RECTANGLE_H
#define CPP_TWIMUI_RECTANGLE_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

class MUIRectangle : public MUIArea
	{
	public:
		MUIRectangle(const struct TagItem *t) : MUIArea(MUIC_Rectangle) { init(t); };
		MUIRectangle(const Tag, ...);
		MUIRectangle() : MUIArea(MUIC_Rectangle) { };
		MUIRectangle(MUIRectangle &p) : MUIArea(p) { };
		virtual ~MUIRectangle();
		MUIRectangle &operator= (MUIRectangle &);
		STRPTR BarTitle() const { return((STRPTR)get(MUIA_Rectangle_BarTitle,NULL)); };
		BOOL HBar() const { return((BOOL)get(MUIA_Rectangle_HBar,FALSE)); };
		BOOL VBar() const { return((BOOL)get(MUIA_Rectangle_VBar,FALSE)); };
	};

class MUIHBar : public MUIRectangle
	{
	public:
		MUIHBar(const ULONG size)
			:   MUIRectangle(
					MUIA_Rectangle_HBar, TRUE,
					MUIA_FixHeight     , size,
					TAG_DONE)
			{ };
		MUIHBar(MUIHBar &p) : MUIRectangle(p) { };
		virtual ~MUIHBar();
		MUIHBar &operator= (MUIHBar &);
	};

class MUIVBar : public MUIRectangle
	{
	public:
		MUIVBar(const ULONG size)
			:   MUIRectangle(
					MUIA_Rectangle_VBar, TRUE,
					MUIA_FixWidth      , size,
					TAG_DONE)
			{ };
		MUIVBar(MUIVBar &p) : MUIRectangle(p) { };
		virtual ~MUIVBar();
		MUIVBar &operator= (MUIVBar &);
	};

#endif
