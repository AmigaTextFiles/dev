/* $Id: path.h,v 1.9 2005/11/10 15:32:20 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/dos/dos'
{#include <dos/path.h>}
NATIVE {DOS_PATH_H} CONST

/* A shell search path list component. Do not allocate this yourself! */
NATIVE {PathNode} OBJECT pathnode
    {pn_Next}	next	:BPTR    /* Pointer to next path node */
    {pn_Lock}	lock	:BPTR    /* Directory lock */
ENDOBJECT

/****************************************************************************/

/* Parameters for use with the AddPathNode() function. Where to add
   the new node? */
NATIVE {ADDCMDPATHNODE_HEAD}  CONST ADDCMDPATHNODE_HEAD  = 0
NATIVE {ADDCMDPATHNODE_TAIL}  CONST ADDCMDPATHNODE_TAIL  = 1

/****************************************************************************/

/* The message passed to the hook invoked by the SearchCmdPathList()
   function. */
NATIVE {SearchCmdPathListMsg} OBJECT searchcmdpathlistmsg
    {splm_Size}	size	:VALUE
    {splm_Lock}	lock	:BPTR
    {splm_Name}	name	:ARRAY OF CHAR /*STRPTR*/
ENDOBJECT
