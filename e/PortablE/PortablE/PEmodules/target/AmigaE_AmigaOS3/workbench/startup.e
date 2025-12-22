/* $VER: startup.h 36.3 (11.7.1990) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/dos/dos'
{MODULE 'workbench/startup'}

NATIVE {WORKBENCH_STARTUP_I} CONST

NATIVE {wbstartup} OBJECT wbstartup
    {message}	message	:mn	/* a standard message structure */
    {process}	process	:PTR TO mp	/* the process descriptor for you */
    {segment}	segment	:BPTR	/* a descriptor for your code */
    {numargs}	numargs	:VALUE	/* the number of elements in ArgList */
    {toolwindow}	toolwindow	:ARRAY OF CHAR	/* description of window */
    {arglist}	arglist	:ARRAY OF wbarg	/* the arguments themselves */
ENDOBJECT

NATIVE {wbarg} OBJECT wbarg
    {lock}	lock	:BPTR	/* a lock descriptor */
    {name}	name	:ARRAY OF CHAR	/* a string relative to that lock */
ENDOBJECT
