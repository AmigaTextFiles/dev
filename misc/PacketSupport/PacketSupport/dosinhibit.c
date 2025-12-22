/*

    Packetsupport.lib
    -----------------

    DOS-Packet support .lib for Lettuce C V5.04

    no © 1990 by Oliver Wagner,
		 Landsberge 5,
		 4322 Sprockhövel,
		 West Germany

    Use at your own risk, for everything you want!

    long dosinhibit(devicename, inhibit)
	-> send packet Inhibit to device proc with
	   name "devicename"

*/

#include <proto/dos.h>
#include "packetsupport.h"

long dosinhibit(char *devname,long flag)
{
    return(sendpacket(DeviceProc(devname),ACTION_INHIBIT,flag));
}
