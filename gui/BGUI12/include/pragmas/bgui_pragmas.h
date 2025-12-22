/* $VER: bgui_pragmas.h 1.0 (27.4.94) */
#ifndef BGUIBase_PRAGMA_H
#define BGUIBase_PRAGMA_H

#pragma libcall BGUIBase BGUI_GetClassPtr 1e 001
#pragma libcall BGUIBase BGUI_NewObjectA 24 8002
#pragma libcall BGUIBase BGUI_RequestA 2a a9803
#pragma libcall BGUIBase BGUI_Help 30 0a9804
#pragma libcall BGUIBase BGUI_LockWindow 36 801
#pragma libcall BGUIBase BGUI_UnlockWindow 3c 801
#pragma libcall BGUIBase BGUI_DoGadgetMethodA 42 ba9804

#ifdef __SASC
#pragma tagcall BGUIBase BGUI_NewObject 24 8002
#pragma tagcall BGUIBase BGUI_Request 2a a9803
#pragma tagcall BGUIBase BGUI_DoGadgetMethod 42 ba9804
#endif

#endif
