#ifndef TWICPP_TWIMUI_BODYCHUNK_H
#define TWICPP_TWIMUI_BODYCHUNK_H

//
//  $VER: Bodychunk.h   2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_BITMAP_H
#include <twiclasses/twimui/bitmap.h>
#endif

///

/// class MUIBodychunk

class MUIBodychunk : public MUIBitmap
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIBodychunk(const struct TagItem *t) : MUIBitmap(MUIC_Bodychunk) { init(t); };
        MUIBodychunk(const Tag, ...);
        MUIBodychunk() : MUIBitmap(MUIC_Bodychunk) { };
        MUIBodychunk(const MUIBodychunk &);
        virtual ~MUIBodychunk();
        MUIBodychunk &operator= (const MUIBodychunk &);
        VOID Body(const UBYTE *p) { set(MUIA_Bodychunk_Body,(ULONG)p); };
        UBYTE *Body() const { return((UBYTE *)get(MUIA_Bodychunk_Body,0L)); };
        VOID Compression(const UBYTE p) { set(MUIA_Bodychunk_Compression,(ULONG)p); };
        UBYTE Compression() const { return((UBYTE)get(MUIA_Bodychunk_Compression,0L)); };
        VOID Depth(const LONG p) { set(MUIA_Bodychunk_Depth,(ULONG)p); };
        LONG Depth() const { return((LONG)get(MUIA_Bodychunk_Depth,0L)); };
        VOID Masking(const UBYTE p) { set(MUIA_Bodychunk_Masking,(ULONG)p); };
        UBYTE Masking() const { return((UBYTE)get(MUIA_Bodychunk_Masking,0L)); };
    };

///

#endif
