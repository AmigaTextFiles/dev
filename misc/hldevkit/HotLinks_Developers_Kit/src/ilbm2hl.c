/*
 *
 * ilbm2hl.c - Publish a standard IFF ILBM bitmap file to Hotlinks
 *
 */
 
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/hotlinks.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <lattice/stdio.h>
#include <hotlinks/hotlinks.h>

#define FORM (('F'<<24)+('O'<<16)+('R'<<8)+('M')) 
#define ILBM (('I'<<24)+('L'<<16)+('B'<<8)+('M'))
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
char 	VERSTAG[]="\0$VER: ilbm2hl B4 (10.4.91)";



/* forward declarations */
void shutdown();


int main(argc, argv)
int argc;
char *argv[];
{
        char *buff;
        int stilldata, chunksize, error, fi;
        unsigned int chunktype;
        
        if(argc!=2)
        {
                printf("USAGE: ilbm2hl <filename>\n");
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

        /* open the input file */
        if((fi=Open(argv[1], MODE_OLDFILE))==0)
        {
                printf("ERROR - could not open input file for reading\n");
                shutdown();
                exit(0);
        }
        
        /* make sure it is an  FORM ILBM file */
        Read(fi, (char *)&chunktype, 4);   /* read the FORM tag */
        if(chunktype!=FORM)
        {
                printf("ERROR - file is not an IFF FORM file\n");
                Close(fi);
                shutdown();
                exit(0);
        }
        Read(fi, (char *)&chunktype, 4);   /* skip the FORM length */
        Read(fi, (char *)&chunktype, 4);   /* read the FORM type tag (ILBM) */
        if(chunktype!=ILBM)
        {
                printf("ERROR - file is not an IFF ILBM file\n");
                Close(fi);
                shutdown();
                exit(0);
        }
        
        /* return to the start of the file */
        Seek(fi, 0, OFFSET_BEGINNING);
        
        /* set up some defaults */
        pb->PRec.Type = ILBM;
        pb->PRec.Access = ACC_DEFAULT;
        stcgfn(pb->PRec.Name, argv[1]);
        
        /* get a publication using the publication requester provided by the
         * hotlink.library.
         */
        error = PutPub(pb, 0);
        
        /* if the user selected a file and pressed ok then delete the file*/
        if(error!=NOERROR)
        {
                /* check for errors */
                switch(error)
                {
                        case NOPRIV: printf("ERROR: privalge violation\n");
                                     break;
                                     
                        case INVPARAM: printf("ERROR: invaild parameters\n");
                                       break;
                }
                Close(fi);
                shutdown();                
                exit(0);
        }
        
        
        /* open the publication file */
        if((error=OpenPub(pb, OPEN_WRITE))!=NOERROR)
        {
                printf("ERROR - could not open the publication for writing\n");
                Close(fi);
                shutdown();
                exit(0);
        }
        
        
        Read(fi, (char *)&chunktype, 4);   /* read the FORM tag */
        WritePub(pb, (char *)&chunktype, 4); /* write the FORM tag */
        
        Read(fi, (char *)&stilldata, 4);   /* read the FORM size */
        WritePub(pb, (char *)&stilldata, 4); /* write the FORM size */
        
        Read(fi, (char *)&chunktype, 4);   /* read the FORM type (ILBM) */
        WritePub(pb, (char *)&chunktype, 4); /* write the FORM type (ILBM) */
        
        /* process the chunks */
        stilldata -= 4;
        while(stilldata)
        {
                Read(fi, (char *)&chunktype, 4);
                Read(fi, (char *)&chunksize, 4);
                switch(chunktype)
                {
                        case BMHD:
                        case CMAP:
                        case BODY:
                        default:
                                   /* write out the chunk header */
                                   WritePub(pb, (char *)&chunktype, 4);
                                   WritePub(pb, (char *)&chunksize, 4);
                                   
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
                                                Close(fi);
                                                RemovePub(pb);
                                                shutdown();
                                                exit(0);
                                        }
                                        
                                        /* and write it back out */
                                        Read(fi, buff, chunksize);
                                        
                                        /* read the chunk data in */
                                        WritePub(pb, buff, chunksize);
                                        
                                        /* free the memory */
                                        FreeMem(buff, chunksize);
                                   }
                                   break;
                }
                stilldata -= (chunksize+8);
        }
        /* close the input file */
        Close(fi);
        
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
