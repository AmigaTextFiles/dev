/*

    test for packetsupport.lib

    usage:

	packettest devproc true/false

    sends inhibit to devproc

*/

#include <stdio.h>
#include <string.h>
#include "packetsupport.h"

int main(char **argv,int argc)
{
    if(argc!=3) {
	printf("Usage: packettest devname true/false\n");
	return(20);
    }
    if(!dosinhibit(argv[1],!strcmp(argv[2],"true")?-1:0))
	printf("ACTION_INHIBIT failed\n");
    else printf("ok.\n");
    return(0);
}
