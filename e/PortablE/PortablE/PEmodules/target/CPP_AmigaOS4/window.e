/* $VER: window.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/window.h>
}
{
struct Library * WindowBase = NULL;
struct WindowIFace *IWindow = NULL;
}
NATIVE {CLIB_WINDOW_PROTOS_H} CONST
NATIVE {PROTO_WINDOW_H} CONST
NATIVE {PRAGMA_WINDOW_H} CONST
NATIVE {INLINE4_WINDOW_H} CONST
NATIVE {WINDOW_INTERFACE_DEF_H} CONST

NATIVE {WindowBase} DEF windowbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IWindow}    DEF

PROC new()
	InitLibrary('window.class', NATIVE {(struct Interface **) &IWindow} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {WINDOW_GetClass} PROC
PROC Window_GetClass() IS NATIVE {IWindow->WINDOW_GetClass()} ENDNATIVE !!PTR TO iclass
->NATIVE {NewWindowPrefs} PROC
PROC NewWindowPrefs() IS NATIVE {IWindow->NewWindowPrefs()} ENDNATIVE
->NATIVE {WindowPrivate1} PROC
PROC WindowPrivate1() IS NATIVE {IWindow->WindowPrivate1()} ENDNATIVE !!ULONG
->NATIVE {UpdateWindowPrefs} PROC
PROC UpdateWindowPrefs(screen:PTR TO screen) IS NATIVE {IWindow->UpdateWindowPrefs(} screen {)} ENDNATIVE
