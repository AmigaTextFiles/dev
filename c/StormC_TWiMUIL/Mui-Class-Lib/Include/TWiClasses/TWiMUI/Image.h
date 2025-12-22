#ifndef TWICPP_TWIMUI_IMAGE_H
#define TWICPP_TWIMUI_IMAGE_H

//
//  $VER: Image.h       2.0 (10 Feb 1997)
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

///

/// class MUIImage

class MUIImage : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIImage(const struct TagItem *t) : MUIArea(MUIC_Image) { init(t); };
        MUIImage(const Tag, ...);
        MUIImage() : MUIArea(MUIC_Image) { };
        MUIImage(const MUIImage &);
        virtual ~MUIImage();
        MUIImage &operator= (const MUIImage &);
        VOID State(const LONG p) { set(MUIA_Image_State,(ULONG)p); };
    };

///

#endif
