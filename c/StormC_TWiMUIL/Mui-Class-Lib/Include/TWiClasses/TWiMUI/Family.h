#ifndef TWICPP_TWIMUI_FAMILY_H
#define TWICPP_TWIMUI_FAMILY_H

//
//  $VER: Family.h      2.0 (10 Feb 1997)
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

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

///

/// class MUIFamily

class MUIFamily : public MUINotify
    {
    protected:
        virtual const ULONG ClassNum() const;
    protected:
        MUIFamily(const STRPTR cl) : MUINotify(cl) { };
        MUIFamily(const MUIFamily &);
        virtual ~MUIFamily();
        MUIFamily &operator= (const MUIFamily &);
    public:
        struct MinList *List() const { return((struct MinList *)get(MUIA_Family_List,NULL)); };
        VOID AddHead(Object *p) { dom(MUIM_Family_AddHead,(ULONG)p); };
        VOID AddTail(Object *p) { dom(MUIM_Family_AddTail,(ULONG)p); };
        VOID Insert(Object *p1, Object *p2) { dom(MUIM_Family_Insert,(ULONG)p1,(ULONG)p2); };
        VOID Remove(Object *p) { dom(MUIM_Family_Remove,(ULONG)p); };
        VOID Sort(Object **p) { dom(MUIM_Family_Sort,(ULONG)p); };
        VOID Transfer(Object *p) { dom(MUIM_Family_Transfer,(ULONG)p); };
    };

///

#endif
