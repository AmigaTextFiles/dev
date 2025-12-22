/*
 * logout.c - a program that will log out the current user
 *
 */
 
#include <proto/exec.h>
#include <proto/hotlinks.h>
#include <lattice/stdio.h>
#include <hotlinks/hotlinks.h>

/* the hotlink library base pointer */
struct HotLinksBase *HotLinksBase;

/* version string */
char 	VERSTAG[]="\0$VER: Logout B4 (10.2.91)";



int main()
{
        int hlh;
        
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
        
        /* set the user to NULL - unset the current user */
        SetUser(hlh, 0, 0);
        
        /* Unregister this program from the hotlink system */
        UnRegister(hlh);
        
        /* close the library */
        CloseLibrary((struct Library *)HotLinksBase);
}
