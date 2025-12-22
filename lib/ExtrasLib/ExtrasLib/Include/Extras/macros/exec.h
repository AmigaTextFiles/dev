#ifndef EXTRAS_MACROS_EXEC_H
#define EXTRAS_MACROS_EXEC_H

#include<dos/dos.h>

#define PROCESSLIST PROCESS_LIST
#define PROCESS_LIST(LIST,NODE) for(NODE=(APTR)((struct List *)LIST)->lh_Head;((struct Node *)NODE)->ln_Succ;NODE=(APTR)((struct Node *)NODE)->ln_Succ)

#define GET_EXECBASE (*((struct ExecBase **) 4))

#define CTRL_C SIGBREAKF_CTRL_C
#define CTRL_D SIGBREAKF_CTRL_D
#define CTRL_E SIGBREAKF_CTRL_E
#define CTRL_F SIGBREAKF_CTRL_F

#define CTRL_CD (CTRL_C | CTRL_D)

#define BREAK_C()  (SetSignal(0,SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C)
#define BREAK_D()  (SetSignal(0,SIGBREAKF_CTRL_D) & SIGBREAKF_CTRL_D)
#define BREAK_E()  (SetSignal(0,SIGBREAKF_CTRL_E) & SIGBREAKF_CTRL_E)
#define BREAK_F()  (SetSignal(0,SIGBREAKF_CTRL_F) & SIGBREAKF_CTRL_F)

#define BREAK(x) (SetSignal(0,x) & x)

#define BROKE_C()  (SetSignal(0,0) & SIGBREAKF_CTRL_C)
#define BROKE_D()  (SetSignal(0,0) & SIGBREAKF_CTRL_D)
#define BROKE_E()  (SetSignal(0,0) & SIGBREAKF_CTRL_E)
#define BROKE_F()  (SetSignal(0,0) & SIGBREAKF_CTRL_F)

#define BROKE(x) (SetSignal(0,0) & x)

#endif /* EXTRAS_MACROS_EXEC_H */
