/*
 * This program prints the hostname of your computer.
 *
 * The hostname is the internet address assigned to your
 * computer while you are connected to your service provider.
 *
 * This is a good demonstration of how programs can be written to
 * conditionally take advantage of both TCP stacks.
 *
 */

#include <proto/tsocket.h>
#include <pragmas/tsocket_pragmas.h>

#include <exec/libraries.h>
#include <proto/exec.h>
#include <stdio.h>



struct Library *TSocketBase;




int main()
{
    char hostname[256];    


    if ( !(TSocketBase = OpenLibrary("tsocket.library", 0)) )
    {
        printf("TermiteTCP is not running.\n");
        return 10;
    }

    printf("\nUsing: %s\n", TSocketBase->lib_IdString);


    gethostname(hostname, sizeof(hostname));
    printf("host name is \"%s\"\n\n", hostname);

    if ( hostname[0] == NULL )
        printf("(TCP stack is probably not connected to service provider.)\n\n");


    CloseLibrary(TSocketBase);


    return 0;
}
