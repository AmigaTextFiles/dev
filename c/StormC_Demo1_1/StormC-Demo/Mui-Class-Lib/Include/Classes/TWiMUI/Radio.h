//
//  $VER: Radio.h       1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_RADIO_H
#define CPP_TWIMUI_RADIO_H

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

class MUIRadio : public MUIGroup
	{
	public:
		MUIRadio(const struct TagItem *t)
			:   MUIGroup(MUIC_Radio)
			{
			init(t);
			};
		MUIRadio(const Tag, ...);
		MUIRadio(const STRPTR *entries)
			:   MUIGroup(MUIC_Radio)
			{
			init(MUIA_Radio_Entries, entries,
				MUIA_Background, MUII_GroupBack,
				TAG_DONE);
			};
		MUIRadio(const STRPTR *entries, const UBYTE cc)
			:   MUIGroup(MUIC_Radio)
			{
			init(MUIA_Radio_Entries, entries,
				MUIA_Background, MUII_GroupBack,
				MUIA_ControlChar, cc,
				TAG_DONE);
			};
		MUIRadio() : MUIGroup(MUIC_Radio) { };
		MUIRadio(MUIRadio &p) : MUIGroup(p) { };
		virtual ~MUIRadio();
		MUIRadio &operator= (MUIRadio &);
		void Active(const LONG p) { set(MUIA_Radio_Active,(ULONG)p); };
		LONG Active() const { return((LONG)get(MUIA_Radio_Active,0L)); };
	};

class MUILabRadio
	:   public MUILabelHelp,
		public MUIRadio
	{
	public:
		MUILabRadio(const STRPTR lab, const STRPTR *entries)
			:   MUILabelHelp(lab),
				MUIRadio(MUIA_Radio_Entries, entries,
					MUIA_Frame, MUIV_Frame_Group,
					MUIA_FrameTitle, MUILabelHelp::gLab(),
					MUIA_Background, MUII_GroupBack,
					MUIA_ControlChar, MUILabelHelp::gCC(),
					TAG_DONE)
			{ };
		virtual ~MUILabRadio();
		MUILabRadio &operator= (MUILabRadio &);
	};

#endif
