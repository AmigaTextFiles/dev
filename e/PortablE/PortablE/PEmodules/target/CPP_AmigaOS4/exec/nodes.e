/* $Id: nodes.h,v 1.13 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <exec/nodes.h>}
NATIVE {EXEC_NODES_H} CONST

/*
 *  List Node Structure.  Each member in a list starts with a Node
 */

NATIVE {Node} OBJECT ln
    {ln_Succ}	succ	:PTR TO ln /* Pointer to next (successor) */
    {ln_Pred}	pred	:PTR TO ln /* Pointer to previous (predecessor) */
    {ln_Type}	type	:UBYTE
    {ln_Pri}	pri	:BYTE  /* Priority, for sorting */
    {ln_Name}	name	:ARRAY OF CHAR /*STRPTR*/ /* ID string, null terminated */
ENDOBJECT /* Note: word aligned */

/* minimal node -- no type checking possible */
NATIVE {MinNode} OBJECT mln
    {mln_Succ}	succ	:PTR TO mln
    {mln_Pred}	pred	:PTR TO mln
ENDOBJECT

/*
** Note: Newly initialized IORequests, and software interrupt structures
** used with Cause(), should have type NT_UNKNOWN.  The OS will assign a type
** when they are first used.
*/

/*----- Node Types for LN_TYPE -----*/
NATIVE {enNodeTypes} DEF
NATIVE {NT_UNKNOWN}      CONST NT_UNKNOWN      = 0
NATIVE {NT_TASK}         CONST NT_TASK         = 1 /* Exec task */
NATIVE {NT_INTERRUPT}    CONST NT_INTERRUPT    = 2
NATIVE {NT_DEVICE}       CONST NT_DEVICE       = 3
NATIVE {NT_MSGPORT}      CONST NT_MSGPORT      = 4
NATIVE {NT_MESSAGE}      CONST NT_MESSAGE      = 5 /* Indicates message currently pending */
NATIVE {NT_FREEMSG}      CONST NT_FREEMSG      = 6
NATIVE {NT_REPLYMSG}     CONST NT_REPLYMSG     = 7 /* Message has been replied */
NATIVE {NT_RESOURCE}     CONST NT_RESOURCE     = 8
NATIVE {NT_LIBRARY}      CONST NT_LIBRARY      = 9
NATIVE {NT_MEMORY}       CONST NT_MEMORY       = 10
NATIVE {NT_SOFTINT}      CONST NT_SOFTINT      = 11 /* Internal flag used by SoftInits */
NATIVE {NT_FONT}         CONST NT_FONT         = 12
NATIVE {NT_PROCESS}      CONST NT_PROCESS      = 13 /* AmigaDOS Process */
NATIVE {NT_SEMAPHORE}    CONST NT_SEMAPHORE    = 14
NATIVE {NT_SIGNALSEM}    CONST NT_SIGNALSEM    = 15 /* signal semaphores */
NATIVE {NT_BOOTNODE}     CONST NT_BOOTNODE     = 16
NATIVE {NT_KICKMEM}      CONST NT_KICKMEM      = 17
NATIVE {NT_GRAPHICS}     CONST NT_GRAPHICS     = 18
NATIVE {NT_DEATHMESSAGE} CONST NT_DEATHMESSAGE = 19

NATIVE {NT_EXTINTERRUPT} CONST NT_EXTINTERRUPT = 20 /* Native interrupt */
NATIVE {NT_EXTSOFTINT}   CONST NT_EXTSOFTINT   = 21 /* Native soft interrupt */
NATIVE {NT_VMAREA}       CONST NT_VMAREA       = 22 /* Internal use only */
NATIVE {NT_VMAREA_PROXY} CONST NT_VMAREA_PROXY = 23 /* Internal use only */
NATIVE {NT_CLASS}        CONST NT_CLASS        = 24 /* Class */
NATIVE {NT_INTERFACE}    CONST NT_INTERFACE    = 25 /* Interface */    

NATIVE {NT_USER}         CONST NT_USER         = 254 /* User node types work down from here */
NATIVE {NT_EXTENDED}     CONST NT_EXTENDED     = 255
