#ifndef TWICPP_TWIMUI_DATASPACE_H
#define TWICPP_TWIMUI_DATASPACE_H

//
//  $VER: Dataspace.h   2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_SEMAPHORE_H
#include <twiclasses/twimui/semaphore.h>
#endif

///

/// class MUIDataspace

class MUIDataspace : public MUISemaphore
    {
    protected:
        virtual const ULONG ClassNum() const;
    public:
        MUIDataspace(const struct TagItem *t) : MUISemaphore(MUIC_Dataspace) { init(t); };
        MUIDataspace(const Tag, ...);
        MUIDataspace() : MUISemaphore(MUIC_Dataspace) { };
        MUIDataspace(const MUIDataspace &);
        virtual ~MUIDataspace();
        MUIDataspace &operator= (const MUIDataspace &p);
        ULONG Add(APTR p1, LONG p2, ULONG p3) { return(dom(MUIM_Dataspace_Add,(ULONG)p1,(ULONG)p2,p3)); };
        VOID Clear() { dom(MUIM_Dataspace_Clear); };
        APTR Find(ULONG p) { return((APTR)dom(MUIM_Dataspace_Find,(ULONG)p)); };
        LONG Merge(Object *p) { return((LONG)dom(MUIM_Dataspace_Merge,(ULONG)p)); };
        ULONG ReadIFF(struct IFFHandle *p) { return(dom(MUIM_Dataspace_ReadIFF,(ULONG)p)); };
        ULONG Remove(ULONG p) { return(dom(MUIM_Dataspace_Remove,p)); };
        ULONG WriteIFF(struct IFFHandle *p1, ULONG p2, ULONG p3) { return(dom(MUIM_Dataspace_WriteIFF,(ULONG)p1,p2,p3)); };
    };

///

#endif
