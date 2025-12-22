#ifndef TWICPP_TWIMUI_RECTANGLE_H
#define TWICPP_TWIMUI_RECTANGLE_H

//
//  $VER: Rectangle.h   2.0 (10 Feb 1997)
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

/// class MUIRectangle

class MUIRectangle : public MUIArea
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIRectangle(const struct TagItem *t) : MUIArea(MUIC_Rectangle) { init(t); };
        MUIRectangle(const Tag, ...);
        MUIRectangle() : MUIArea(MUIC_Rectangle) { };
        MUIRectangle(const MUIRectangle &);
        virtual ~MUIRectangle();
        MUIRectangle &operator= (const MUIRectangle &);
        STRPTR BarTitle() const { return((STRPTR)get(MUIA_Rectangle_BarTitle,NULL)); };
        BOOL HBar() const { return((BOOL)get(MUIA_Rectangle_HBar,FALSE)); };
        BOOL VBar() const { return((BOOL)get(MUIA_Rectangle_VBar,FALSE)); };
    };

///
/// class MUIHBar

class MUIHBar : public MUIRectangle
    {
    public:
        MUIHBar(const ULONG size)
            :   MUIRectangle(
                    MUIA_Rectangle_HBar, TRUE,
                    MUIA_FixHeight     , size,
                    TAG_DONE)
            { };
        MUIHBar(const MUIHBar &p) : MUIRectangle((MUIRectangle &)p) { };
        virtual ~MUIHBar();
        MUIHBar &operator= (const MUIHBar &);
    };

///
/// class MUIVBar

class MUIVBar : public MUIRectangle
    {
    public:
        MUIVBar(const ULONG size)
            :   MUIRectangle(
                    MUIA_Rectangle_VBar, TRUE,
                    MUIA_FixWidth      , size,
                    TAG_DONE)
            { };
        MUIVBar(const MUIVBar &p) : MUIRectangle((MUIRectangle &)p) { };
        virtual ~MUIVBar();
        MUIVBar &operator= (const MUIVBar &);
    };

///

#endif
