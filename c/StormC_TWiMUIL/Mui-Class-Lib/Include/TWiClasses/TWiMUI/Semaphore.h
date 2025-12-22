#ifndef TWICPP_TWIMUI_SEMAPHORE_H
#define TWICPP_TWIMUI_SEMAPHORE_H

//
//  $VER: Semaphore.h   2.0 (10 Feb 1997)
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

#ifndef TWICPP_TWIMUI_NOTIFY_H
#include <twiclasses/twimui/notify.h>
#endif

///

/// class MUISemaphore

class MUISemaphore : public MUINotify
    {
    protected:
        virtual const ULONG ClassNum() const;
        MUISemaphore(const STRPTR cl) : MUINotify(cl) { };
    public:
        MUISemaphore(const struct TagItem *t) : MUINotify(MUIC_Semaphore) { init(t); };
        MUISemaphore(const Tag, ...);
        MUISemaphore() : MUINotify(MUIC_Semaphore) { };
        MUISemaphore(const MUISemaphore &);
        virtual ~MUISemaphore();
        MUISemaphore &operator= (const MUISemaphore &p);
        VOID Attempt() { dom(MUIM_Semaphore_Attempt); };
        VOID AttemptShared() { dom(MUIM_Semaphore_AttemptShared); };
        VOID Obtain() { dom(MUIM_Semaphore_Obtain); };
        VOID ObtainShared() { dom(MUIM_Semaphore_ObtainShared); };
        VOID Release() { dom(MUIM_Semaphore_Release); };
    };

///

#endif
