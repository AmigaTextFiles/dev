//
//  $VER: Floattext.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_FLOATTEXT_H
#define CPP_TWIMUI_FLOATTEXT_H

#ifndef CPP_TWIMUI_LIST_H
#include <classes/twimui/list.h>
#endif

class MUIFloattext : public MUIList
	{
	public:
		MUIFloattext(const struct TagItem *t) : MUIList(MUIC_Floattext) { init(t); };
		MUIFloattext(const Tag, ...);
		MUIFloattext() : MUIList(MUIC_Floattext) { };
		MUIFloattext(MUIFloattext &p) : MUIList(p) { };
		virtual ~MUIFloattext();
		MUIFloattext &operator= (MUIFloattext &);
		void Justify(const BOOL p) { set(MUIA_Floattext_Justify,(ULONG)p); };
		BOOL Justify() const { return((BOOL)get(MUIA_Floattext_Justify,FALSE)); };
		void SkipChars(const STRPTR p) { set(MUIA_Floattext_SkipChars,(ULONG)p); };
		void TabSize(const LONG p) { set(MUIA_Floattext_TabSize,(ULONG)p); };
		void Text(const STRPTR p) { set(MUIA_Floattext_Text,(ULONG)p); };
		STRPTR Text() const { return((STRPTR)get(MUIA_Floattext_Text,NULL)); };
	};

#endif
