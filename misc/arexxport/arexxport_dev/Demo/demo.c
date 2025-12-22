/*
** Demo arexx test file
** Link with arexxport.lib
*/

#include <stdio.h>
#include <exec/types.h>
#include <exec/lists.h>
#include <dos/dos.h>
#include <rexx/storage.h>
#include <rexx/rxslib.h>
#include <rexx/arexxport.h>

#include <clib/arexxport_protos.h>
#include <clib/exec_protos.h>

struct Library *ArexxPortBase = NULL;

void a_Load( struct ArexxMsg *amsg );
void a_Saveas( struct ArexxMsg *amsg );
void a_Quit( struct ArexxMsg *amsg );

/* Function Table */
 struct ArexxFunction comtable[] = {
    {"load", &a_Load, "FILE"},
    {"saveas", &a_Saveas, "FILE,OVERWRITE/S,VAR"},
    {"quit", &a_Quit, "FORCE/S"},
    {"fault", &ReturnArexxError, "VAR"},
    {NULL, NULL, NULL}
};

void main() {

    if(!(ArexxPortBase = OpenLibrary("arexxport.library", 37 ))) {
        printf("Unable to open lib.\n");
        return;
    }

    printf("Lib open\n");

    /* Open a port */
    struct ArexxPort *port1, *port2, *port3;
    port1 = OpenArexxPort("TEST_PORT",
                    ARLT_COMMANDS, comtable,
                    ARLT_CONSOLE, "con:0/0/640/50",
                    ARLT_LASTERROR, NULL,
                    TAG_END);

    /* Open two more and chain them */
    port2 = OpenArexxPort("TEST_PORT", ARLT_CHAIN, port1, TAG_END);
    port3 = OpenArexxPort("TEST_PORT", ARLT_CHAIN, port1, TAG_END);

    if( port1 && port2 && port3 ) {
        printf("Ports Open - Control D to exit.\n");
        /* Launch a Macro  */
        printf("Return from launch %lx\n", LaunchArexx( port1, "test.rexx", TRUE, 4 ) );
        BOOL done = FALSE;

        while( ! done ) {

            ULONG signal = Wait( (1L<<(AREXX_SIGBIT(port1))) | SIGBREAKF_CTRL_D );

            if(signal & SIGBREAKF_CTRL_D) {
                if( ArexxMacroPending( port1 ) ) {
                    puts( "Cannot quit - all macros haven't returned yet" );
                } else {
                    done = TRUE;
                }
            } else {

                /* Deal with arexx messages */
                struct ArexxMsg *amsg;
                while( amsg = CheckArexxPort( port1 ) ) {

                    if(amsg->Type == AREXX_COMMAND) {
                        void (*target)( struct ArexxMsg *msg ) = (void *)amsg->User_Data;
                        target( amsg );
                    }
                    else if(amsg->Type == AREXX_MESSAGE) {
                        printf("Message Received. Macro UserData = %u\n", amsg->User_Data);
                        if( amsg->arg[0] )  printf(" Arg[0] = %s\n", amsg->arg[0] );
                        if( amsg->arg[1] )  printf(" Arg[1] = %s\n", amsg->arg[1] );
                        if( amsg->arg[2] )  printf(" Arg[2] = %s\n", amsg->arg[2] );
                    }
                    ReplyArexxPort( amsg );
                }
            }
        }
    }

    /* Shut Ports */
    if( port1 )     CloseArexxPort( port1 );
    if( port2 )     CloseArexxPort( port2 );
    if( port3 )     CloseArexxPort( port3 );

    printf("Ports Closed\n");
    CloseLibrary( ArexxPortBase );

    printf("All done\n");
}

void a_Load( struct ArexxMsg *amsg ) {
    printf("Load command Received at port %s\n", amsg->port->PortName );
    if( amsg->arg[0] )     printf("File = %s" , amsg->arg[0] );
    puts("");
}

void a_Saveas( struct ArexxMsg *amsg ) {
    printf("Saveas command Received at port %s\n", amsg->port->PortName );
    if( amsg->arg[0] )     printf("File = %s" , amsg->arg[0] );
    if( amsg->arg[1] )     printf(" 'Overwrite'" );
    puts("");
    puts("Returning 'hello world'" );
    SetArexxReturnVar( amsg, 0, "Hello World", (STRPTR)amsg->arg[2] );
}

void a_Quit( struct ArexxMsg *amsg ) {
    printf( "Quit command Received at port %s\n", amsg->port->PortName );
    if( amsg->arg[0] )     printf("Force" );
    puts("");
}



