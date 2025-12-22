/*
 * chgpwd.c - a program that will change a users password from the CLI
 *
 */
 
#include <proto/exec.h>
#include <proto/hotlinks.h>
#include <lattice/stdio.h>
#include <hotlinks/hotlinks.h>

/* the hotlink.library base pointer */
struct HotLinksBase *HotLinksBase;

/* version string */
char 	VERSTAG[]="\0$VER: chgpwd B5 (10.2.91)";


int main(argc, argv)
int argc;
char *argv[];
{
        int error, hlh;
        
        /* check for valid number of arguments */
        if((argc!=0)&&(argc!=1)&&(argc!=4))
        {
                printf("USAGE: chgpwd [user name] [old password] [new password]\n");
                exit(0);
        }
        
        /* try to open the hotlink.library.
         * The hotlink.library will not open unless the hotlink resident code
         * is running.
         */
        if((HotLinksBase=(struct HotLinksBase *)OpenLibrary("hotlinks.library", 0))==0)
        {
                printf("ERROR - could not open the hotlinks.library\n");
                exit(20);
        }
        
        /* register this program with the hotlink system */
        hlh = HLRegister(1,0,0);
        
        /* if no arguments are given use the standard requester */
        if(argc<2)
        {
                error = NewPassword(hlh);
        }
        /* otherwise use the arguments themselves */
        else
        {
                /* make the call to change the users password */
                error = ChgPassword(hlh, argv[1], argv[2], argv[3]);
        }
        
        /* check for errors */
        switch(error)
        {
                case INVPARAM: printf("ERROR - user not found\n");
                               break;
                              
                case NOPRIV: printf("ERROR - you do not have clearance to use this function\n");
                             break;
                             
                case NOMEMORY: printf("ERROR - out of memory\n");
                               break;
        }
        
        /* Unregister this program from the hotlinks system */
        UnRegister(hlh);
        
        /* close the library */
        CloseLibrary((struct Library *)HotLinksBase);
}
