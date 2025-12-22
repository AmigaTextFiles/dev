/*
 *
 * hl2ilbm.c - Output a HotLink'ed bitmap file to a standard IFF ILBM file
 *
 */
 
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/hotlinks.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <lattice/stdio.h>
#include <hotlinks/hotlinks.h>

#define BMHD (('B'<<24)+('M'<<16)+('H'<<8)+('D')) 
#define CMAP (('C'<<24)+('M'<<16)+('A'<<8)+('P'))
#define BODY (('B'<<24)+('O'<<16)+('D'<<8)+('Y'))


/* hotlink library base pointer */
struct HotLinksBase *HotLinksBase = 0;

/* hotlinks publication block pointer */
struct PubBlock *pb = 0;

/* hotlinks handle */
int hlh = 0;

/* version string */
char 	VERSTAG[]="\0$VER: hl2ilbm B3 (10.2.91)";



/* forward declarations */
int __asm filterproc(register __a0 struct PubBlock *);
void shutdown();


int main(argc, argv)
int argc;
char *argv[];
{
        char *buff;
        int stilldata, chunksize, error, fo;
        unsigned int chunktype;
        
        if(argc!=2)
        {
                printf("USAGE: hl2ilbm <filename>\n");
                exit(0);
        }
        
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
        
        /* open the output file */
        if((fo=Open(argv[1], MODE_NEWFILE))==0)
        {
                printf("ERROR - could not open output file for writing\n");
                ClosePub(pb);
                shutdown();
                exit(0);
        }
        
        ReadPub(pb, (char *)&chunktype, 4); /* get the FORM tag */
        Write(fo, (char *)&chunktype, 4);   /* write the FORM tag */
        
        ReadPub(pb, (char *)&stilldata, 4); /* get the FORM size */
        Write(fo, (char *)&stilldata, 4);   /* write the FORM size */
        
        ReadPub(pb, (char *)&chunktype, 4); /* get the FORM type (ILBM) */
        Write(fo, (char *)&chunktype, 4);   /* write the FORM type (ILBM) */
        
        /* process the chunks */
        stilldata -= 4;
        while(stilldata)
        {
                ReadPub(pb, (char *)&chunktype, 4);
                ReadPub(pb, (char *)&chunksize, 4);
                switch(chunktype)
                {
                        case BMHD:
                        case CMAP:
                        case BODY:
                        default:
                                   /* write out the chunk header */
                                   Write(fo, (char *)&chunktype, 4);
                                   Write(fo, (char *)&chunksize, 4);
                                   
                                   /* adjust the length if it is an odd length */
                                   if(chunksize&0x00000001)
                                   {
                                        chunksize++;
                                   }
                                   
                                   /* does the chunk have any data in it? */
                                   if(chunksize)
                                   {
                                        /* allocate memory to hold the chunk */
                                        if((buff=AllocMem(chunksize, 0))==0)
                                        {
                                                printf("ERROR - out of memory\n");
                                                ClosePub(pb);
                                                Close(fo);
                                                DeleteFile(argv[1]);
                                                shutdown();
                                                exit(0);
                                        }
                                        
                                        /* read the chunk data in */
                                        ReadPub(pb, buff, chunksize);
                                        
                                        /* and write it back out */
                                        Write(fo, buff, chunksize);
                                        
                                        /* free the memory */
                                        FreeMem(buff, chunksize);
                                   }
                                   break;
                }
                stilldata -= (chunksize+8);
        }
 
        /* close the output file */
        Close(fo);
        
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
        if(pb->PRec.Type==ILBM)
        {
                return(ACCEPT);
        }
        else
        {
                return(NOACCEPT);
        }
}
