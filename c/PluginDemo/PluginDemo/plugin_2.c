/* Programmheader

	Name:		plugin_2.c
	Main:		plugin demo
	Versionstring:	$VER: plugin_2.c 1.0 (10.06.2003)
	Author:		SDI
	Distribution:	PD
	Description:	plugin to show double plugin

 1.0   10.06.03 : first version
*/

#include "plugin.h"

#define MASTER_VERSION 1 /* Version of master system it requires to work. */
#define P2_VERSION     1 /* Version of this plugin */
#define P2_REVISION    0 
#define P2_Plugin      FirstPlugin /* the link for extheader */

const UBYTE version[] = 
"$VER: plugin_hello 1.0 (10.06.2003) (PD) by Dirk Stöcker <stoecker@epost.de>";

STRPTR HelloD_Func1(void)
{
  return "Hello DoublePlugin";
}

STRPTR HelloA_Func2(STRPTR txt)
{
  return "Ignoring the text";
}

STRPTR HelloD_Func2(STRPTR txt)
{
  return txt;
}

const struct Plugin P3_Plugin = {
  0,
  PLUGIN_VERSION,
  MASTER_VERSION,
  P2_VERSION,
  P2_REVISION,
  0,
  0,

  "Plugin to say much more than Hello",
  HelloD_Func1,
  HelloD_Func2
};

const struct Plugin P2_Plugin = {
  (struct Plugin *) &P3_Plugin,
  PLUGIN_VERSION,
  MASTER_VERSION,
  P2_VERSION,
  P2_REVISION,
  0,
  0,

  "Plugin to say more than Hello",
  HelloD_Func1,
  HelloA_Func2,
};

