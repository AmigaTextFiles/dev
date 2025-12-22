/*
 * deled.c - a program to delete a hotlink publication
 *
 */
 
#include <proto/exec.h>
#include <proto/hotlinks.h>
#include <lattice/stdio.h>
#include <hotlinks/hotlinks.h>

/* hotlink library base pointer */
struct HotLinksBase *HotLinksBase;

/* version string */
char 	VERSTAG[]="\0$VER: deled B5 (1.3.92)";



int main()
{
        struct PubBlock *pb;
        int error, hlh;
        
        /* try to open the hotlink.library.
         * The library will not open unless hotlinks is running.
         */
        if((HotLinksBase=(struct HotLinksBase *)OpenLibrary("hotlinks.library", 0))==0)
        {
                printf("ERROR - could not open the hotlinks.library\n");
                exit(20);
        }

        /* register this program with the hotlinks system */
        hlh = HLRegister(1,0,0);
        
        /* get a PubBlock pointer */
        pb=AllocPBlock(hlh);
        
        /* check for errors */
        if((pb==(struct PubBlock *)NOMEMORY)||(pb==(struct PubBlock *)NOPRIV))
        {
                printf("ERROR - AllocPBlock call failed: error=%d\n", pb);
                UnRegister(hlh);
                CloseLibrary((struct Library *)HotLinksBase);
                exit(0);
        }
                
        /* get a publication using the publication requester provided by the
         * hotlink.library.
         */
         
        error = GetPub(pb, 0);
        
        /* if the user selected a file and pressed ok then delete the file*/
        if(error==NOERROR)
        {
                /* delete the edition */
                error=RemovePub(pb);
                
                /* check for errors */
                switch(error)
                {
                        case NOPRIV: printf("ERROR: privalge violation\n");
                                     break;
                                     
                        case INVPARAM: printf("ERROR: invaild parameters\n");
                                       break;
                                       
                        case IOERROR: printf("ERROR: I/O error, publication not removed\n");
                                      break;
                }
        }
        
        /* free the PubBlock pointer obtained by AllocPBlock */
        (void)FreePBlock(pb);
        
        /* Unregister this program form the hotlink system */
        UnRegister(hlh);
        
        /* close the libray and exit */
        CloseLibrary((struct Library *)HotLinksBase);
}
