/* $Id: startup.h,v 1.11 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/dos/dos'
{#include <workbench/startup.h>}
NATIVE {WORKBENCH_STARTUP_H} CONST

NATIVE {WBStartup} OBJECT wbstartup
    {sm_Message}	message	:mn    /* a standard message structure      */
    {sm_Process}	process	:PTR TO mp    /* the process descriptor for you    */
    {sm_Segment}	segment	:BPTR    /* a descriptor for your code        */
    {sm_NumArgs}	numargs	:VALUE    /* the number of elements in ArgList */
    {sm_ToolWindow}	toolwindow	:ARRAY OF CHAR /* description of window             */
    {sm_ArgList}	arglist	:ARRAY OF wbarg    /* the arguments themselves          */
ENDOBJECT

NATIVE {WBArg} OBJECT wbarg
    {wa_Lock}	lock	:BPTR /* a lock descriptor              */
    {wa_Name}	name	:/*STRPTR*/ ARRAY OF CHAR /* a string relative to that lock */
ENDOBJECT
