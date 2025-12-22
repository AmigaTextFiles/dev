/*
 * edlist.c - a program to list all editions available to the curently
 *            logged in user.
 *
 */

#include <proto/exec.h>
#include <proto/hotlinks.h>
#include <lattice/stdio.h>
#include <hotlinks/hotlinks.h>

/* standard library base declaraion */
struct HotLinksBase *HotLinksBase;

/* version string */
char 	VERSTAG[]="\0$VER: edlist B7 (2.6.92)";
char *months[12] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
char datebuff[32];

int main()
{
        struct PubBlock *pb;
        char *t1, *t2;
        int test, hlh, len, totlen, toted;
        char hltype[5], accstr[7];
        
        /* try to open the hotlink library 
         * The library will not open if the hotlink resident code is not
         * running.
         */
        if((HotLinksBase=(struct HotLinksBase *)OpenLibrary("hotlinks.library", 0))==0)
        {
                /* in this program not having hotinks available is
                 * a fatal error.
                 */
                printf("ERROR - could not open the hotlinks.library\n");
                exit(20);
        }

        /* register this program with the hotlinks system */
        hlh = HLRegister(1,0,0);
        
        /* get a PubBlock pointer for the program to use */
        pb=AllocPBlock(hlh);
        
        /* check for errors */
        if((pb==(struct PubBlock *)NOMEMORY)||(pb==(struct PubBlock *)NOPRIV))
        {
                printf("ERROR - AllocPBlock call failed: error=%d\n", pb);
                UnRegister(hlh);
                CloseLibrary((struct Library *)HotLinksBase);
                exit(0);
        }
                
        /* init the counters */
        totlen=0;
        toted=0;
        
        /* get the first publication in the list */
        test=FirstPub(pb);
        
        /* loop until it runs out of publications */
        while(test!=NOMOREBLOCKS)
        {
                /*increment the total edition counter*/
                toted++;
                
                /*get the edition length*/
                len = -1;
                if(OpenPub(pb, OPEN_READ)==NOERROR)
                {
                        SeekPub(pb, 4, SEEK_BEGINNING);
                        ReadPub(pb, (char *)&len, 4);
                        ClosePub(pb);
                        len += 8;       /* add in for the FORM xxxx */
                        
                        /*increment the total length counter*/
                        totlen += len;
                }
                
                /* get the edition type - 4 chars */
                strncpy(hltype, (char *)&pb->PRec.Type, 4);
                hltype[4]=0;
                
                /* set up the access code output string */
                strcpy(accstr, "------");
                if(pb->PRec.Access&ACC_AREAD)
                {
                        accstr[0] = 'r';
                }
                if(pb->PRec.Access&ACC_AWRITE)
                {
                        accstr[1] = 'w';
                }
                if(pb->PRec.Access&ACC_GREAD)
                {
                        accstr[2] = 'r';
                }
                if(pb->PRec.Access&ACC_GWRITE)
                {
                        accstr[3] = 'w';
                }
                if(pb->PRec.Access&ACC_OREAD)
                {
                        accstr[4] = 'r';
                }
                if(pb->PRec.Access&ACC_OWRITE)
                {
                        accstr[5] = 'w';
                }
                
                /* get the time of last modification */
                t1 = (char *)&pb->PRec.MDate;
                t2 = (char *)&pb->PRec.MTime;
                
                /* sanity check it */
                if(((t1[2]<13)&&(t1[2]>0))&&((t1[3]>0)&&(t1[3]<32)))
                {
                        sprintf(datebuff, "%s %2.2d %2.2d:%02.2d:%02.2d", months[t1[2]-1], t1[3], t2[0], t2[1], t2[2]);
                }
                else    /* bad date values */
                {
                        strcpy(datebuff, "<Date Corrupt> ");
                }
                
                /* print the string to STDOUT */
                printf("%s %8.8d  %s  %s  %s\n", accstr, len, hltype, datebuff, pb->PRec.Name);
                
                /* get the next one */
                test = NextPub(pb);
        }
        
        /* print the totals */
        printf("Editions: %d     Bytes: %d\n", toted, totlen);
        
        /* free the PubBlock pointer obtained by AllocPBlock() */
        (void)FreePBlock(pb);
        
        /* Unregister this program from the hotlinks system */
        UnRegister(hlh);
        
        /* close the hotlink library and exit */
        CloseLibrary((struct Library *)HotLinksBase);
}
