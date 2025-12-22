/* $Id: sana2specialstats.h,v 1.10 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/devices/sana2'
{#include <devices/sana2specialstats.h>}
NATIVE {DEVICES_SANA2SPECIALSTATS_H} CONST

/*
** The SANA-II special statistic identifier is an unsigned 32 number.
** The upper 16 bits identify the type of network wire type to which
** the statistic applies and the lower 16 bits identify the particular
** statistic.
**
** If you desire to add a new statistic identifier, contacts CATS.
*/



/*
** defined ethernet special statistics
*/

NATIVE {S2SS_ETHERNET_BADMULTICAST} CONST ->#S2SS_ETHERNET_BADMULTICAST = ((((S2WireType_Ethernet)&$ffff)<<16) OR $0000)
/*
** This count will record the number of times a received packet tripped
** the hardware's multicast filtering mechanism but was not actually in
** the current multicast table.
*/

NATIVE {S2SS_ETHERNET_RETRIES} CONST ->#S2SS_ETHERNET_RETRIES = ((((S2WireType_Ethernet)&$ffff)<<16) OR $0001)
/*
** This count records the total number of retries which have resulted
** from transmissions on this board.
*/


NATIVE {S2SS_ETHERNET_FIFO_UNDERRUNS} CONST ->#S2SS_ETHERNET_FIFO_UNDERRUNS = ((((S2WireType_Ethernet)&$ffff)<<16) OR $0002)
/*
** This count records an error condition which indoicates that the host
** computer did not feed the network interface card at a high enough rate.
*/
