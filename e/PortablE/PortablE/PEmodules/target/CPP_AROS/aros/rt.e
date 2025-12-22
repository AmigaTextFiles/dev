OPT NATIVE
/*MODULE 'target/exec/types', 'target/exec', 'target/dos', 'target/intuition'*/
/*{#include <aros/rt.h>}*/

   NATIVE {AROS_RT_H} CONST
    /* Put code which must be defined only once here */

    /* Resources */
NATIVE {RTT_ALLOCMEM}	CONST ->RTT_ALLOCMEM
NATIVE {RTT_ALLOCVEC}	CONST ->RTT_ALLOCVEC
NATIVE {RTT_PORT}	CONST ->RTT_PORT
NATIVE {RTT_LIBRARY}	CONST ->RTT_LIBRARY
NATIVE {RTT_FILE}	CONST ->RTT_FILE
NATIVE {RTT_SCREEN}	CONST ->RTT_SCREEN /* Screen before Window, so the windows are closed before the screen */
NATIVE {RTT_WINDOW}	CONST ->RTT_WINDOW

NATIVE {RTT_MAX}	CONST ->RTT_MAX

NATIVE {RTTB_EXEC}	CONST ->RTTB_EXEC
NATIVE {RTTO_PutMsg}	CONST ->RTTO_PUTMSG
NATIVE {RTTO_GetMsg}	CONST ->RTTO_GETMSG


NATIVE {RTTB_DOS}	CONST ->RTTB_DOS
NATIVE {RTTO_Read}	CONST ->RTTO_READ
NATIVE {RTTO_Write}	CONST ->RTTO_WRITE


NATIVE {RTTB_INTUITION}	CONST ->RTTB_INTUITION
NATIVE {RTTO_OpenScreen}	CONST ->RTTO_OPENSCREEN
NATIVE {RTTO_OpenScreenTags}	CONST ->RTTO_OPENSCREENTAGS
NATIVE {RTTO_OpenScreenTagList}	CONST ->RTTO_OPENSCREENTAGLIST
NATIVE {RTTO_ScreenToFront}	CONST ->RTTO_SCREENTOFRONT
NATIVE {RTTO_ScreenToBack}	CONST ->RTTO_SCREENTOBACK
NATIVE {RTTO_OpenWindow}	CONST ->RTTO_OPENWINDOW
NATIVE {RTTO_OpenWindowTags}	CONST ->RTTO_OPENWINDOWTAGS
NATIVE {RTTO_OpenWindowTagList}	CONST ->RTTO_OPENWINDOWTAGLIST
NATIVE {RTTO_WindowToFront}	CONST ->RTTO_WINDOWTOFRONT
NATIVE {RTTO_WindowToBack}	CONST ->RTTO_WINDOWTOBACK


    NATIVE {RT_IntInitB} PROC
->PROC Rt_IntInitB() IS NATIVE {RT_IntInitB()} ENDNATIVE
    NATIVE {RT_IntInitE} PROC
->PROC Rt_IntInitE() IS NATIVE {RT_IntInitE()} ENDNATIVE
    NATIVE {RT_IntExitB} PROC
->PROC Rt_IntExitB() IS NATIVE {RT_IntExitB()} ENDNATIVE
    NATIVE {RT_IntExitE} PROC
->PROC Rt_IntExitE() IS NATIVE {RT_IntExitE()} ENDNATIVE
    NATIVE {RT_IntAdd} PROC
->PROC Rt_IntAdd(rtt:VALUE, file:PTR TO CHAR, line:VALUE, line2:ULONG, ...) IS NATIVE {RT_IntAdd( (int) } rtt {,} file {, (int) } line {,} line2 {,} ... {)} ENDNATIVE !!IPTR /* Add a resource for tracking */
    NATIVE {RT_IntCheck} PROC
->PROC Rt_IntCheck(rtt:VALUE, file:PTR TO CHAR, line:VALUE, op:VALUE, op2:ULONG, ...) IS NATIVE {RT_IntCheck( (int) } rtt {,} file {, (int) } line {, (int) } op {,} op2 {,} ... {)} ENDNATIVE !!IPTR /* Check a resource before use */
    NATIVE {RT_IntFree} PROC
->PROC Rt_IntFree(rtt:VALUE, file:PTR TO CHAR, line:VALUE, line2:ULONG, ...) IS NATIVE {RT_IntFree( (int) } rtt {,} file {, (int) } line {,} line2 {,} ... {)} ENDNATIVE !!IPTR /* Stop tracking of a resource */
    NATIVE {RT_IntEnter} PROC
->PROC Rt_IntEnter(functionname:PTR TO CHAR, filename:PTR TO CHAR, line:VALUE) IS NATIVE {RT_IntEnter(} functionname {,} filename {, (int) } line {)} ENDNATIVE
    NATIVE {RT_IntTrack} PROC
->PROC Rt_IntTrack(rtt:VALUE, file:PTR TO CHAR, line:VALUE, res:APTR, res2:ULONG, ...) IS NATIVE {RT_IntTrack( (int) } rtt {,} file {, (int) } line {,} res {,} res2 {,} ... {)} ENDNATIVE
    NATIVE {RT_Leave} PROC
->PROC Rt_Leave() IS NATIVE {RT_Leave()} ENDNATIVE

 	   NATIVE {RT_Add} CONST	->RT_Add(rtt, args...)       RT_IntAdd (rtt, __FILE__, __LINE__, ##args)
 	   NATIVE {RT_Check} CONST	->RT_Check(rtt, op, args...) RT_IntCheck (rtt, __FILE__, __LINE__, op, ##args)
 	   NATIVE {RT_Free} CONST	->RT_Free(rtt, args...)      RT_IntFree (rtt, __FILE__, __LINE__, ##args)
 	   NATIVE {RT_Enter} CONST	->RT_Enter(fn)               RT_IntEnter (fn,__FILE__, __LINE__)
 	   NATIVE {RT_Track} CONST	->RT_Track(rtt, res...)      RT_IntTrack (rtt, __FILE__, __LINE__, ##res)

/* Add a resource for tracking which must not be freed. */

	    NATIVE {RT_InitExec} PROC
->PROC Rt_InitExec() IS NATIVE {RT_InitExec()} ENDNATIVE
	    NATIVE {RT_ExitExec} PROC
->PROC Rt_ExitExec() IS NATIVE {RT_ExitExec()} ENDNATIVE

 	   NATIVE {RT_INITEXEC}		    CONST ->RT_INITEXEC		    = RT_InitExec(),
 	   NATIVE {RT_EXITEXEC}		    CONST ->RT_EXITEXEC		    = RT_ExitExec(),


	    NATIVE {RT_InitDos} PROC
->PROC Rt_InitDos() IS NATIVE {RT_InitDos()} ENDNATIVE
	    NATIVE {RT_ExitDos} PROC
->PROC Rt_ExitDos() IS NATIVE {RT_ExitDos()} ENDNATIVE

 	   NATIVE {RT_INITDOS}		    CONST ->RT_INITDOS		    = RT_InitDos(),
 	   NATIVE {RT_EXITDOS}		    CONST ->RT_EXITDOS		    = RT_ExitDos(),


	    NATIVE {RT_InitIntuition} PROC
->PROC Rt_InitIntuition() IS NATIVE {RT_InitIntuition()} ENDNATIVE
	    NATIVE {RT_ExitIntuition} PROC
->PROC Rt_ExitIntuition() IS NATIVE {RT_ExitIntuition()} ENDNATIVE

 	   NATIVE {RT_INITINTUITION}	    CONST ->RT_INITINTUITION	    = RT_InitIntuition(),
 	   NATIVE {RT_EXITINTUITION}	    CONST ->RT_EXITINTUITION	    = RT_ExitIntuition(),


   NATIVE {RT_Init} CONST	->RT_Init() RT_IntInitB(), RT_INITEXEC RT_INITDOS RT_INITINTUITION RT_IntInitE()

   NATIVE {RT_Exit} CONST	->RT_Exit() RT_IntExitB(), RT_EXITINTUITION RT_EXITDOS RT_EXITEXEC RT_IntExitE(
