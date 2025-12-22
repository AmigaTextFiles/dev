#include "Class.h"

TWiWin::TWiWin()
    :   MUIWindow(),
        BSave("_Save"),
        BUse("_Use"),
        BCan("_Cancel")
    {
    if (!Create(MUIA_Window_Title , "Willi's Demo-Window",
            MUIA_Window_ID        , MakeID('T','D','V','I'),
            MUIA_Window_RootObject, HGroup,
                Child, BSave.object(),
                Child, BUse.object(),
                Child, BCan.object(),
                End,
            TAG_DONE))
        throw MUIErrorX(MUIC_Window,MUI_Error());
      else
        ;
    BSave.CycleChain(1);
    BUse.CycleChain(1);
    BCan.CycleChain(1);
    DefaultObject(BSave);
    };
