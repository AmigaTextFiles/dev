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

#include <clib/alib_protos.h>
#include <proto/utility.h>
#include "Class.h"

TWiList::TWiList()
    :   MUIList(ReadListFrame,
            MUIA_List_CompareHook, compare(),
            MUIA_List_ConstructHook, construct(),
            MUIA_List_DestructHook, destruct(),
            MUIA_List_DisplayHook, display(),
            TAG_DONE)
    {
    };

LONG TWiList::CompareHookFunc(struct Hook *h, APTR e2, APTR e1)
    {
    return(Stricmp(((ListCont *)e1)->getStr(),((ListCont *)e2)->getStr()));
    };

APTR TWiList::ConstructHookFunc(struct Hook *h, APTR p, APTR e)
    {
    return(new ListCont((STRPTR)e));
    };

void TWiList::DestructHookFunc(struct Hook *h, APTR p, APTR e)
    {
    delete (ListCont *)e;
    };

void TWiList::DisplayHookFunc(struct Hook *h, STRPTR *a, APTR e)
    {
    *a = ((ListCont *)e)->getStr();
    };

TWiWin::TWiWin()
    :   MUIWindow(),
        Liste(),
        lv(MUIA_Listview_Input, TRUE,
            MUIA_Listview_MultiSelect, MUIV_Listview_MultiSelect_None,
            MUIA_Listview_List, Liste.object(),
            MUIA_CycleChain, 1,
            TAG_DONE),
        BSave("_Save"),
        BUse("_Use"),
        BCancel("_Cancel"),
        MsgSave(0L,"Demo-Message","_Ok","Es wurde 'Save' gedrückt",0UL),
        MsgUse(0L,"Demo-Message","_Ok","Es wurde 'Use' gedrückt",0UL),
        MsgCan(0L,"Demo-Message","_Ok","Es wurde 'Cancel' gedrückt",0UL)
    {
    Liste.InsertSingle("3. String",MUIV_List_Insert_Sorted);
    Liste.InsertSingle("2. String",MUIV_List_Insert_Sorted);
    Liste.InsertSingle("4. String",MUIV_List_Insert_Sorted);
    Liste.InsertSingle("1. String",MUIV_List_Insert_Sorted);
    Liste.InsertSingle("5. String",MUIV_List_Insert_Sorted);
    Create(
        MUIA_Window_Title, "TWiDVI Ver 1.0",
        MUIA_Window_ID,    MakeID('T','D','V','I'),
        WindowContents,    VGroup,
            Child, lv.object(),
            Child, HGroup,
                MUIA_Group_SameSize, TRUE,
                Child, (Object *)BSave,
                Child, (Object *)BUse,
                Child, (Object *)BCancel,
                End,
            End,
        TAG_DONE);
    BSave.CycleChain(1);
    BUse.CycleChain(1);
    BCancel.CycleChain(1);
    DefaultObject(lv);
    BSave.Notify(MUIA_Pressed,   FALSE, *this, 1, MUIM_Demo_Save);
    BUse.Notify(MUIA_Pressed,    FALSE, *this, 1, MUIM_Demo_Use);
    BCancel.Notify(MUIA_Pressed, FALSE, *this, 1, MUIM_Demo_Cancel);
    };

TWiWin::~TWiWin()
    {
    }

void TWiWin::save()
    {
    MsgSave.show(*AppClass(),*this);
    };

void TWiWin::use()
    {
    MsgUse.show(*AppClass(),*this);
    };

void TWiWin::cancel()
    {
    MsgCan.show(*AppClass(),*this);
    };

ULONG TWiWin::UserDispatch(struct IClass *cl, Object *obj, Msg msg)
    {
    ULONG rc = 0UL;
    switch(msg->MethodID)
        {
        case MUIM_Demo_Save:
            save();
            break;
        case MUIM_Demo_Use:
            use();
            break;
        case MUIM_Demo_Cancel:
            cancel();
            break;
        default:
            rc = DoSuperMethodA(cl,obj,msg);
            break;
        }
    return(rc);
    };
