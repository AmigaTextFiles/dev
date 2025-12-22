#ifndef TWICPP_TWIMUI_BITMAP_H
#define TWICPP_TWIMUI_BITMAP_H

//
//  $VER: Bitmap.h      2.0 (10 Feb 1997)
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
//  02 Sep 1996 :   1.2 : Neu:
//                        - ClassNum() für Exception-Handling.
//                        Änderungen:
//                        - Parameter des Copy-Konstruktor als 'const'-Parameter definiert
//

/// Includes

#ifndef TWICPP_TWIMUI_AREA_H
#include <twiclasses/twimui/area.h>
#endif

#ifndef GRAPHICS_GFX_H
#include <graphics/gfx.h>
#endif

///

/// class MUIBitmap

class MUIBitmap : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
        MUIBitmap(STRPTR cl) : MUIArea(cl) { };
    public:
        MUIBitmap(const struct TagItem *t) : MUIArea(MUIC_Bitmap) { init(t); };
        MUIBitmap(const Tag, ...);
        MUIBitmap() : MUIArea(MUIC_Bitmap) { };
        MUIBitmap(const MUIBitmap &);
        virtual ~MUIBitmap();
        MUIBitmap &operator= (const MUIBitmap &);
        VOID BitmapP(const struct Bitmap *p) { set(MUIA_Bitmap_Bitmap,(ULONG)p); };
        struct Bitmap *BitmapP() const { return((struct Bitmap *)get(MUIA_Bitmap_Bitmap,NULL)); };
        VOID Height(const LONG p) { set(MUIA_Bitmap_Height,(ULONG)p); };
        LONG Height() const { return((LONG)get(MUIA_Bitmap_Height,0L)); };
        VOID MappingTable(const UBYTE *p) { set(MUIA_Bitmap_MappingTable,(ULONG)p); };
        UBYTE *MappingTable() const { return((UBYTE *)get(MUIA_Bitmap_MappingTable,0L)); };
        VOID Precision(const LONG p) { set(MUIA_Bitmap_Precision,(ULONG)p); };
        LONG Precision() const { return((LONG)get(MUIA_Bitmap_Precision,0L)); };
        struct Bitmap *RemappedBitmap() const { return((struct Bitmap *)get(MUIA_Bitmap_Bitmap,NULL)); };
        VOID SourceColors(const ULONG *p) { set(MUIA_Bitmap_SourceColors,(ULONG)p); };
        ULONG *SourceColors() const { return((ULONG *)get(MUIA_Bitmap_SourceColors,0L)); };
        VOID Transparent(const LONG p) { set(MUIA_Bitmap_Transparent,(ULONG)p); };
        LONG Transparent() const { return((LONG)get(MUIA_Bitmap_Transparent,0L)); };
        VOID Width(const LONG p) { set(MUIA_Bitmap_Width,(ULONG)p); };
        LONG Width() const { return((LONG)get(MUIA_Bitmap_Width,0L)); };
    };

///

#endif
