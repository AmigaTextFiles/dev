#ifndef TWICPP_TWIMUI_POPLIST_H
#define TWICPP_TWIMUI_POPLIST_H

//
//  $VER: Poplist.h     2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_POPOBJECT_H
#include <twiclasses/twimui/popobject.h>
#endif

///

/// class MUIPoplist

class MUIPoplist : public MUIPopobject
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIPoplist(const struct TagItem *t) : MUIPopobject(MUIC_Poplist) { init(t); };
        MUIPoplist(const Tag, ...);
        MUIPoplist() : MUIPopobject(MUIC_Poplist) { };
        MUIPoplist(const MUIPoplist &);
        virtual ~MUIPoplist();
        MUIPoplist &operator= (const MUIPoplist &);
    };

///

#endif
