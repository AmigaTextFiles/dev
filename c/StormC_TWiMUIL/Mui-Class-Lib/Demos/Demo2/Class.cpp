#include <clib/alib_protos.h>
#include "Class.h"

TWiWin::TWiWin()
    :   MUIWindow(),
        BSave("_Save"),
        BUse("_Use"),
        BCancel("_Cancel"),
        MsgSave(0L,"Demo-Message","_Ok","Es wurde 'Save' gedrückt",0UL),
        MsgUse(0L,"Demo-Message","_Ok","Es wurde 'Use' gedrückt",0UL),
        MsgCan(0L,"Demo-Message","_Ok","Es wurde 'Cancel' gedrückt",0UL)
    {
    Create(
        MUIA_Window_Title, "TWiDVI Ver 1.0",
        MUIA_Window_ID,    MakeID('T','D','V','I'),
        WindowContents,    HGroup,
            MUIA_Group_SameSize, TRUE,
            Child, (Object *)BSave,
            Child, (Object *)BUse,
            Child, (Object *)BCancel,
            End,
        TAG_DONE);
    BSave.CycleChain(1);
    BUse.CycleChain(1);
    BCancel.CycleChain(1);
    DefaultObject(BSave);
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
