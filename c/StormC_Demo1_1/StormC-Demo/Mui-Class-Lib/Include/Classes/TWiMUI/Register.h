//
//  $VER: Register.h    1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_REGISTER_H
#define CPP_TWIMUI_REGISTER_H

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

class MUIRegister : public MUIGroup
	{
	public:
		MUIRegister(const struct TagItem *t) : MUIGroup(MUIC_Register) { init(t); };
		MUIRegister(const Tag, ...);
		MUIRegister() : MUIGroup(MUIC_Register) { };
		MUIRegister(MUIRegister &p) : MUIGroup(p) { };
		virtual ~MUIRegister();
		MUIRegister &operator= (MUIRegister &);
		BOOL Frame() const { return((BOOL)get(MUIA_Register_Frame,FALSE)); };
		STRPTR *Titles() const { return((STRPTR *)get(MUIA_Register_Titles,FALSE)); };
	};

#endif
