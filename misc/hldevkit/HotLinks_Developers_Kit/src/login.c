/*
 * login.c - a program that will log in a user to the hotlinks system
 *
 */
 
#include <proto/exec.h>
#include <proto/hotlinks.h>
#include <lattice/stdio.h>
#include <hotlinks/hotlinks.h>

/* the hotlink library base pointer */
struct HotLinksBase *HotLinksBase;

/* version string */
char 	VERSTAG[]="\0$VER: Login B2 (10.2.91)";

int main(argc, argv)
int argc;
char *argv[];
{
        struct PubBlock *pb;
        int hlh,error;
        
        /* check for help sign */
        if((argv[1][0]=='?')||(argc>3))
        {
                printf("USAGE: login <name> <password>\n");
                exit(0);
        }
        
        /* try to open the hotlink library.
         * If the hotlink resident code is not running the library will
         * not be able to be opened.
         */
        if((HotLinksBase=(struct HotLinksBase *)OpenLibrary("hotlinks.library", 0))==0)
        {
                printf("ERROR - could not open the hotlinks.library\n");
                exit(20);
        }
        
        /* register this program with the hotlink system */
        hlh = HLRegister(1,0,0);
        
        /* if only one argument use the login box */
        if(argc==1)
        {
                /* cause hotlinks to request a login - if no one is logged in */
                pb = AllocPBlock(hlh);
                if(((int)pb!=INVPARAM)&&((int)pb!=NOPRIV)&&((int)pb!=NOMEMORY))
                {
                        FreePBlock(pb);
                }
        }
        else
        {
                // name with no password
                if(argc==2)
                {       
                        error = SetUser(hlh, argv[1], 0);
                }
                else //name and password
                {
                        error = SetUser(hlh, argv[1], argv[2]);
                }
                
                if(error!=NOERROR)
                {
                        printf("ERROR: %d\n", error);
                }
        }
        
        /* Unregister this program from the hotlink system */
        UnRegister(hlh);
        
        /* close the library */
        CloseLibrary((struct Library *)HotLinksBase);
}
