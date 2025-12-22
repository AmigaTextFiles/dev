/* $Id: nodes.h 27659 2008-01-05 22:10:30Z neil $ */
OPT NATIVE
MODULE 'target/aros/config', 'target/exec/types'
{#include <exec/nodes.h>}
NATIVE {EXEC_NODES_H} CONST

NATIVE {Node} OBJECT ln
    {ln_Succ}	succ	:PTR TO ln
	{ln_Pred}	pred	:PTR TO ln
    /* AROS: pointer should be 32bit aligned */
    {ln_Name}	name	:ARRAY OF CHAR
    {ln_Type}	type	:UBYTE
    {ln_Pri}	pri	:BYTE
ENDOBJECT

NATIVE {MinNode} OBJECT mln
    {mln_Succ}	succ	:PTR TO mln
	{mln_Pred}	pred	:PTR TO mln
ENDOBJECT


/**************************************
		 Defines
**************************************/
/* Values for ln_Type */
NATIVE {NT_UNKNOWN}	CONST NT_UNKNOWN	= 0	/* Unknown node 			    */
NATIVE {NT_TASK} 	CONST NT_TASK 	= 1	/* Exec task				    */
NATIVE {NT_INTERRUPT}	CONST NT_INTERRUPT	= 2	/* Interrupt				    */
NATIVE {NT_DEVICE}	CONST NT_DEVICE	= 3	/* Device				    */
NATIVE {NT_MSGPORT}	CONST NT_MSGPORT	= 4	/* Message-Port 			    */
NATIVE {NT_MESSAGE}	CONST NT_MESSAGE	= 5	/* Indicates message currently pending	    */
NATIVE {NT_FREEMSG}	CONST NT_FREEMSG	= 6
NATIVE {NT_REPLYMSG}	CONST NT_REPLYMSG	= 7	/* Message has been replied		    */
NATIVE {NT_RESOURCE}	CONST NT_RESOURCE	= 8
NATIVE {NT_LIBRARY}	CONST NT_LIBRARY	= 9
NATIVE {NT_MEMORY}	CONST NT_MEMORY	= 10
NATIVE {NT_SOFTINT}	CONST NT_SOFTINT	= 11	/* Internal flag used by SoftInits	    */
NATIVE {NT_FONT} 	CONST NT_FONT 	= 12
NATIVE {NT_PROCESS}	CONST NT_PROCESS	= 13	/* AmigaDOS Process			    */
NATIVE {NT_SEMAPHORE}	CONST NT_SEMAPHORE	= 14
NATIVE {NT_SIGNALSEM}	CONST NT_SIGNALSEM	= 15	/* signal semaphores			    */
NATIVE {NT_BOOTNODE}	CONST NT_BOOTNODE	= 16
NATIVE {NT_KICKMEM}	CONST NT_KICKMEM	= 17
NATIVE {NT_GRAPHICS}	CONST NT_GRAPHICS	= 18
NATIVE {NT_DEATHMESSAGE} CONST NT_DEATHMESSAGE = 19
NATIVE {NT_HIDD}		CONST NT_HIDD		= 20	/* AROS specific			    */

NATIVE {NT_USER} 	CONST NT_USER 	= 254	/* User node types work down from here	    */
NATIVE {NT_EXTENDED}	CONST NT_EXTENDED	= 255

/***************************************
    Macros
****************************************/

NATIVE {SetNodeName} PROC	->SetNodeName(node,name)   (((struct Node *)(node))->ln_Name = (char *)(name))
NATIVE {GetNodeName} PROC	->GetNodeName(node)        (((struct Node *)(node))->ln_Name)
