/* $Id: plugins.h,v 1.10 2005/11/10 15:39:41 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/intuition/intuition'
MODULE 'target/exec/nodes', 'target/utility/tagitem', 'target/graphics/rastport', 'target/intuition/screens', 'target/graphics/gfx', 'target/exec/types'
{#include <intuition/plugins.h>}
NATIVE {INTUITION_PLUGINS_H} CONST

/**************************************/
/*** The Intuition plugin interface ***/
/**************************************/

/* The main structure exported by a GUI plugin library (common part) */

NATIVE {GUIPlugin} OBJECT guiplugin
   {Node}	ln	:ln         /* Reserved, don't use             */
   {Version}	version	:ULONG      /* Version of the plugin           */
   {Type}	type	:ULONG         /* Type of plugin                  */
   {Attrs}	attrs	:ULONG        /* Type-specific attributes        */
   {Flags}	flags	:ULONG        /* Additional information          */
   {AttrList}	attrlist	:ARRAY OF tagitem     /* Optional list of GUI attributes */
   {Reserved}	reserved[4]	:ARRAY OF ULONG  /* For future expansion            */

   /* Plugin-specific fields follow here */
ENDOBJECT

/* Plugin attributes (flags) */

NATIVE {PA_INTERNAL} CONST PA_INTERNAL = $10000000  /* Plugin is implemented
                                   internally by Intuition */


/*********************************************************/
/*** Rendering hooks: common structure and definitions ***/
/*********************************************************/

/* Possible return values from a rendering hook */

NATIVE {RCB_OK}      CONST RCB_OK      = 0  /* Hook understands this message type    */
NATIVE {RCB_UNKNOWN} CONST RCB_UNKNOWN = 1  /* Hook does not understand this message */

/* Structure of messages for rendering hooks: */
/* the object is context-specific.            */

NATIVE {RenderMsg} OBJECT rendermsg
    {rm_MethodID}	methodid	:ULONG   /* Type of rendering to perform */
    {rm_RastPort}	rastport	:PTR TO rastport   /* Where to render to           */
    {rm_DrawInfo}	drawinfo	:PTR TO drawinfo   /* Context information          */
    {rm_Bounds}	bounds	:rectangle     /* Limits of where to render    */
    {rm_State}	state	:ULONG      /* How to render                */
    {rm_IAddress}	iaddress	:APTR   /* Subsystem-specific data      */
    {rm_Flags}	flags	:ULONG      /* Subsystem-specific flags     */
    {rm_TagList}	taglist	:ARRAY OF tagitem    /* Additional information       */
ENDOBJECT
