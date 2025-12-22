/* Programmheader

	Name:		plugin_hello.c
	Main:		plugin demo
	Versionstring:	$VER: plugin_hello.c 1.0 (10.06.2003)
	Author:		SDI
	Distribution:	PD
	Description:	plugin to return a hello text

 1.0   10.06.03 : first version
*/

#include "plugin.h"

#define MASTER_VERSION 1 /* Version of master system it requires to work. */
#define HELLO_VERSION  1 /* Version of this plugin */
#define HELLO_REVISION 0 
#define Hello_Plugin   FirstPlugin /* the link for extheader */

const UBYTE version[] = 
"$VER: plugin_hello 1.0 (10.06.2003) (PD) by Dirk Stöcker <stoecker@epost.de>";

STRPTR Hello_Func1(void)
{
  return "Hello";
}

const struct Plugin Hello_Plugin = {
  0,
  PLUGIN_VERSION,
  MASTER_VERSION,
  HELLO_VERSION,
  HELLO_REVISION,
  0,
  0,

  "Plugin to say Hello",
  Hello_Func1,
  0 /* no func of type 2 */
};

