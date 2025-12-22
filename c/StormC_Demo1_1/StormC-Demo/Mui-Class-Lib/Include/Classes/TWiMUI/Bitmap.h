//
//  $VER: Bitmap.h      1.0 (16 Jun 1996)
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

#ifndef CPP_TWIMUI_BITMAP_H
#define CPP_TWIMUI_BITMAP_H

#ifndef CPP_TWIMUI_AREA_H
#include <classes/twimui/area.h>
#endif

#ifndef GRAPHICS_GFX_H
#include <graphics/gfx.h>
#endif

class MUIBitmap : public MUIArea
	{
	protected:
		MUIBitmap(STRPTR cl) : MUIArea(cl) { };
	public:
		MUIBitmap(const struct TagItem *t) : MUIArea(MUIC_Bitmap) { init(t); };
		MUIBitmap(const Tag, ...);
		MUIBitmap() : MUIArea(MUIC_Bitmap) { };
		MUIBitmap(MUIBitmap &p) : MUIArea(p) { };
		virtual ~MUIBitmap();
		MUIBitmap &operator= (MUIBitmap &);
		void BitmapP(const struct Bitmap *p) { set(MUIA_Bitmap_Bitmap,(ULONG)p); };
		struct Bitmap *BitmapP() const { return((struct Bitmap *)get(MUIA_Bitmap_Bitmap,NULL)); };
		void Height(const LONG p) { set(MUIA_Bitmap_Height,(ULONG)p); };
		LONG Height() const { return((LONG)get(MUIA_Bitmap_Height,0L)); };
		void MappingTable(const UBYTE *p) { set(MUIA_Bitmap_MappingTable,(ULONG)p); };
		UBYTE *MappingTable() const { return((UBYTE *)get(MUIA_Bitmap_MappingTable,0L)); };
		void Precision(const LONG p) { set(MUIA_Bitmap_Precision,(ULONG)p); };
		LONG Precision() const { return((LONG)get(MUIA_Bitmap_Precision,0L)); };
		struct Bitmap *RemappedBitmap() const { return((struct Bitmap *)get(MUIA_Bitmap_Bitmap,NULL)); };
		void SourceColors(const ULONG *p) { set(MUIA_Bitmap_SourceColors,(ULONG)p); };
		ULONG *SourceColors() const { return((ULONG *)get(MUIA_Bitmap_SourceColors,0L)); };
		void Transparent(const LONG p) { set(MUIA_Bitmap_Transparent,(ULONG)p); };
		LONG Transparent() const { return((LONG)get(MUIA_Bitmap_Transparent,0L)); };
		void Width(const LONG p) { set(MUIA_Bitmap_Width,(ULONG)p); };
		LONG Width() const { return((LONG)get(MUIA_Bitmap_Width,0L)); };
	};

#endif
