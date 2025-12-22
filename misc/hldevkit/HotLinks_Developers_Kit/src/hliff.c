/*
 *
 * hliff.c - Check the IFF format of a HotLink'ed file (dump the chunk types)
 *
 */
 
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/hotlinks.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <lattice/stdio.h>
#include <hotlinks/hotlinks.h>
#include <lattice/stdio.h>

#define FORM (('F'<<24)+('O'<<16)+('R'<<8)+('M')) 

/* hotlink library base pointer */
struct HotLinksBase *HotLinksBase = 0;

/* hotlinks publication block pointer */
struct PubBlock *pb = 0;

/* hotlinks handle */
int hlh = 0;

/* level counter */
int level;

/* error flag: 0=OK, 1=error occured */
int errorflag;

/* version string */
char 	VERSTAG[]="\0$VER: hliff B3 (10.2.91)";


/* forward declarations */
int __asm filterproc(register __a0 struct PubBlock *);
void shutdown(), processform(), printchunktype(), showlevel();


int main()
{
        int chunksize, error;
        unsigned int chunktype;
        
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
                shutdown();
                exit(0);
        }
                
        /* get a publication using the publication requester provided by the
         * hotlink.library.
         */
        error = GetPub(pb, &filterproc);
        
        /* check for errors */
        if(error!=NOERROR)
        {
                /* check for errors */
                switch(error)
                {
                        case NOPRIV: printf("ERROR: privalge violation\n");
                                     break;
                                     
                        case INVPARAM: printf("ERROR: invaild parameters\n");
                                       break;
                                       
                        case IOERROR: /* user canceled requester */
                                      break;
                }
                shutdown();
                exit(0);
        }
        
        /* open the publication */
        if((error=OpenPub(pb, OPEN_READ))!=NOERROR)
        {
                printf("ERROR - could not open the publication for reading\n");
                shutdown();                
                exit(0);
        }
        
        level = 0;
        errorflag = 0;
        ReadPub(pb, (char *)&chunktype, 4); /* get the FORM tag */
        ReadPub(pb, (char *)&chunksize, 4); /* get the FORM size */
        processform(pb, chunktype, chunksize);
        
        /* close the publication */
        ClosePub(pb);
        
        shutdown();
}


void shutdown()
{
        if(pb)
        {
                /* free the publication block pointer */
                FreePBlock(pb);
        }
        if(hlh)
        {
                /* unregister this program from hotlinks */
                UnRegister(hlh);
        }
        if(HotLinksBase)
        {
                /* close the library */
                CloseLibrary((struct Library *)HotLinksBase);
        }
}

/* this is the filter procedure that gets called by GetPub.
 * the PubBlock pointer is passed in register a0,
 * the return value is passed back in d0 and must be either ACCEPT or NOACCEPT.
 */
int __asm filterproc(register __a0 struct PubBlock *pb)
{
        /* accept all file types */
        return(ACCEPT);
}

void processform(pb, form, stilldata)
struct PubBlock *pb;
int form, stilldata;
{        
        int chunktype, chunksize;
        
        showlevel();
        printchunktype(form);
        printf(" %d ", stilldata);
        
        ReadPub(pb, (char *)&chunktype, 4); /* get the FORM type (ILBM) */
        printchunktype(chunktype);
        printf("\n");
        
        /* increment the level counter */
        level++;
        
        /* process the chunks */
        stilldata -= 4;
        while(stilldata>0)
        {
                showlevel();
                ReadPub(pb, (char *)&chunktype, 4);
                printchunktype(chunktype);
                
                ReadPub(pb, (char *)&chunksize, 4);
                if(chunksize>stilldata)
                {
                        printf("\nERROR in HL IFF chunk size\n");
                        errorflag = 1;
                        return;
                }
                else if(chunktype==FORM)
                {
                        processform(pb, chunktype, chunksize);
                        if(errorflag)
                        {
                                return;
                        }
                }
                else
                {
                        printf(" %d\n", chunksize);
                }
                                   
                /* adjust the length if it is an odd length */
                if(chunksize&0x00000001)
                {
                        chunksize++;
                }
                
                /* seek past the chunk data */
                SeekPub(pb, chunksize, SEEK_CURRENT);
                
                /* adjust data counter and continue */
                stilldata -= (chunksize+8);
        }
        
        /* decrement level counter and return */
        level--;
}

void showlevel()
{
        int x;
        
        for(x=0; x<level; x++)
        {
                printf(".");
        }
}

void printchunktype(type)
int type;
{
        char c1,c2,c3,c4;
        
        c4 = type&0x0000007F;
        type>>=8;
        c3 = type&0x0000007F;
        type>>=8;
        c2 = type&0x0000007F;
        type>>=8;
        c1 = type&0x0000007F;
        
        printf("%c%c%c%c", c1, c2, c3, c4);
}