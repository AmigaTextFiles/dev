//
//  $VER: Slider.h      1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_SLIDER_H
#define CPP_TWIMUI_SLIDER_H

#ifndef CPP_TWIMUI_NUMERIC_H
#include <classes/twimui/numeric.h>
#endif

#ifndef CPP_TWIMUI_LABEL_H
#include <classes/twimui/label.h>
#endif

class MUISlider : public MUINumeric
	{
	public:
		MUISlider(const struct TagItem *t)
			:   MUINumeric(MUIC_Slider)
			{
			init(t);
			};
		MUISlider(const Tag, ...);
		MUISlider(const LONG min, const LONG max)
			:   MUINumeric(MUIC_Slider)
			{
			init(MUIA_Numeric_Min, min,
				MUIA_Numeric_Max, max,
				TAG_DONE);
			};
		MUISlider(const LONG min, const LONG max, const UBYTE cc)
			:   MUINumeric(MUIC_Slider)
			{
			init(MUIA_Numeric_Min, min,
				MUIA_Numeric_Max, max,
				MUIA_ControlChar, cc,
				TAG_DONE);
			};
		MUISlider()
			:   MUINumeric(MUIC_Slider)
			{ };
		MUISlider(MUISlider &p)
			:   MUINumeric(p)
			{ };
		virtual ~MUISlider();
		MUISlider &operator= (MUISlider &);
		void Horiz(const BOOL p) { set(MUIA_Slider_Horiz,(ULONG)p); };
		BOOL Horiz() const { return((BOOL)get(MUIA_Slider_Horiz,FALSE)); };
	};

class MUILabSlider
	:   public MUILabelHelp,
		public MUISlider
	{
	private:
		MUIKeyLabel2 MUILab;
	public:
		MUILabSlider(const STRPTR lab, const LONG min, const LONG max)
			:   MUILabelHelp(lab),
				MUISlider(min,max,MUILabelHelp::gCC()),
				MUILab(MUILabelHelp::gLab(),MUILabelHelp::gCC())
			{ };
		MUILabSlider(MUILabSlider &p)
			:   MUILabelHelp(p),
				MUISlider(p),
				MUILab(p.MUILab)
			{ };
		virtual ~MUILabSlider();
		MUILabSlider &operator= (MUILabSlider &);
		Object *label() { return(MUILab); };
	};

#endif
