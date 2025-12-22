//
//  $VER: Bodychunk.h   1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_BODYCHUNK_H
#define CPP_TWIMUI_BODYCHUNK_H

#ifndef CPP_TWIMUI_BITMAP_H
#include <classes/twimui/bitmap.h>
#endif

class MUIBodychunk : public MUIBitmap
	{
	public:
		MUIBodychunk(const struct TagItem *t) : MUIBitmap(MUIC_Bodychunk) { init(t); };
		MUIBodychunk(const Tag, ...);
		MUIBodychunk() : MUIBitmap(MUIC_Bodychunk) { };
		MUIBodychunk(MUIBodychunk &p) : MUIBitmap(p) { };
		virtual ~MUIBodychunk();
		MUIBodychunk &operator= (MUIBodychunk &);
		void Body(const UBYTE *p) { set(MUIA_Bodychunk_Body,(ULONG)p); };
		UBYTE *Body() const { return((UBYTE *)get(MUIA_Bodychunk_Body,0L)); };
		void Compression(const UBYTE p) { set(MUIA_Bodychunk_Compression,(ULONG)p); };
		UBYTE Compression() const { return((UBYTE)get(MUIA_Bodychunk_Compression,0L)); };
		void Depth(const LONG p) { set(MUIA_Bodychunk_Depth,(ULONG)p); };
		LONG Depth() const { return((LONG)get(MUIA_Bodychunk_Depth,0L)); };
		void Masking(const UBYTE p) { set(MUIA_Bodychunk_Masking,(ULONG)p); };
		UBYTE Masking() const { return((UBYTE)get(MUIA_Bodychunk_Masking,0L)); };
	};

#endif
