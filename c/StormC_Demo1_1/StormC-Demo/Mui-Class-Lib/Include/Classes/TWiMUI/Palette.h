//
//  $VER: Palette.h     1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_PALETTE_H
#define CPP_TWIMUI_PALETTE_H

#ifndef CPP_TWIMUI_GROUP_H
#include <classes/twimui/group.h>
#endif

class MUIPalette : public MUIGroup
	{
	public:
		MUIPalette(const struct TagItem *t) : MUIGroup(MUIC_Palette) { init(t); };
		MUIPalette(const Tag, ...);
		MUIPalette() : MUIGroup(MUIC_Palette) { };
		MUIPalette(MUIPalette &p) : MUIGroup(p) { };
		virtual ~MUIPalette();
		MUIPalette &operator= (MUIPalette &);
		struct MUI_Palette_Entry *Entries() const { return((MUI_Palette_Entry *)get(MUIA_Palette_Entries,NULL)); };
		void Groupable(const BOOL p) { set(MUIA_Palette_Groupable,(ULONG)p); };
		BOOL Groupable() const { return((BOOL)get(MUIA_Palette_Groupable,TRUE)); };
		void Names(const STRPTR *p) { set(MUIA_Palette_Names,(ULONG)p); };
		STRPTR *Names() const { return((STRPTR *)get(MUIA_Palette_Names,NULL)); };
	};

#endif
