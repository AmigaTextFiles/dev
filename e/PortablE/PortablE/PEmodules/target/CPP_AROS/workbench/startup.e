OPT NATIVE
MODULE 'target/exec/ports', 'target/exec/types', 'target/dos/dos'
{#include <workbench/startup.h>}
NATIVE {WORKBENCH_STARTUP_H} CONST

NATIVE {WBStartup} OBJECT wbstartup
    {sm_Message}	message	:mn
    {sm_Process}	process	:PTR TO mp
    {sm_Segment}	segment	:BPTR
    {sm_NumArgs}	numargs	:VALUE
    {sm_ToolWindow}	toolwindow	:ARRAY OF CHAR
    {sm_ArgList}	arglist	:ARRAY OF wbarg
ENDOBJECT

NATIVE {WBArg} OBJECT wbarg
    {wa_Lock}	lock	:BPTR
    {wa_Name}	name	:NATIVE {BYTE*} ARRAY OF CHAR
ENDOBJECT
