//
//  $VER: Cycle.h       1.0 (16 Jun 1996)
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


#ifndef CPP_TWIMUI_CYCLE_H
#define CPP_TWIMUI_CYCLE_H

#ifndef CPP_TWIMUI_LABEL_H
#include <classes/twimui/label.h>
#endif

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

class MUICycle : public MUIGroup
	{
	public:
		MUICycle(const struct TagItem *t)
			:   MUIGroup(MUIC_Cycle)
			{
			init(t);
			};
		MUICycle(const Tag, ...);
		MUICycle(const STRPTR *entries)
			:   MUIGroup(MUIC_Cycle)
			{
			init(MUIA_Cycle_Entries, entries,
				TAG_DONE);
			};
		MUICycle(const STRPTR *entries, const UBYTE cc)
			:   MUIGroup(MUIC_Cycle)
			{
			init(MUIA_Cycle_Entries, entries,
				MUIA_ControlChar, cc,
				TAG_DONE);
			};
		MUICycle() : MUIGroup(MUIC_Cycle) { };
		MUICycle(MUICycle &p) : MUIGroup(p) { };
		virtual ~MUICycle();
		MUICycle &operator= (MUICycle &);
		void Active(const LONG p) { set(MUIA_Cycle_Active,(ULONG)p); };
		void ActiveNext() { set(MUIA_Cycle_Active,MUIV_Cycle_Active_Next); };
		void ActivePrev() { set(MUIA_Cycle_Active,MUIV_Cycle_Active_Prev); };
		LONG Active() const { return((LONG)get(MUIA_Cycle_Active,0L)); };
	};

class MUILabCycle
	:   public MUILabelHelp,
		public MUICycle
	{
	private:
		MUIKeyLabel2 MUILab;
	public:
		MUILabCycle(const STRPTR lab, const STRPTR *entries)
			:   MUILabelHelp(lab),
				MUICycle(entries,MUILabelHelp::gCC()),
				MUILab(MUILabelHelp::gLab(),MUILabelHelp::gCC())
			{ };
		MUILabCycle(MUILabCycle &p)
			:   MUILabelHelp(p),
				MUICycle(p),
				MUILab(p.MUILab)
			{ };
		virtual ~MUILabCycle();
		MUILabCycle &operator= (MUILabCycle &);
		Object *label() { return(MUILab); };
	};

#endif
