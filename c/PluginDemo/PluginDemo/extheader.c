/* Objectheader

	Name:		extheader.c
	Main:		plugin demo
	Version:	$VER: extheader.c 1.1 (30.11.2003)
	Description:	C header for demo plugins
	Author:		SDI
	Distribution:	PD

 1.0   10.06.03 : first version
 1.1   30.11.03 : fixed for GCC
*/

#include "plugin.h"

/* To make this a extern Object module it is necessary to force this
structure to be the really first stuff in the file. */

extern UBYTE version[];
extern struct Plugin FirstPlugin;

#ifdef __VBCC__
static
#endif
const struct PluginHead Head =
{
  PLUGINHEAD_SECURITY,  /* ULONG 	       ph_Security */
  PLUGINHEAD_ID,        /* ULONG 	       ph_ID */
  0,                    /* BPTR                ph_SegList */
  0,                    /* struct PluginHead * ph_Next */
  PLUGINHEAD_VERSION,   /* UWORD 	       ph_Version */
  0,                    /* UWORD 	       ph_Reserved */
  version,              /* STRPTR	       ph_VersString */
  &FirstPlugin          /* struct Plugin *     ph_FirstPlugin */
};

