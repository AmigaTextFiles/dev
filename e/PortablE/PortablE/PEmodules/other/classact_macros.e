/* ClassAct wrapper using ReAction */
OPT PREPROCESS
PUBLIC MODULE 'target/reaction/reaction_macros'

#define CA_OpenWindow(win/*:PTR TO /*Object*/ ULONG*/) RA_OpenWindow(win)

#define CA_CloseWindow(win/*:PTR TO /*Object*/ ULONG*/) RA_CloseWindow(win)

#define CA_HandleInput(win/*:PTR TO /*Object*/ ULONG*/, code) RA_HandleInput(win, code)

#define CA_Iconify(win/*:PTR TO /*Object*/ ULONG*/) RA_Iconify(win)

#define CA_Uniconify(win/*:PTR TO /*Object*/ ULONG*/) RA_Uniconify(win)

#define CA_HandleRexx(obj) RA_HandleRexx(obj)

->#define CA_FlushRexx(obj) RA_FlushRexx(obj)

#define CA_SetUpHook(apphook, func, data) RA_SetUpHook(apphook, func, data)


#define StringGad(text,id,maxchars) String(text,id,maxchars)
->PortablE needs recompiling to allow this: #undefine String
