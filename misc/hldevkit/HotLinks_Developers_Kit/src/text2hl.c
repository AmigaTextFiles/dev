/*
 *
 * text2hl.c - Publish a standard ASCII file to Hotlinks
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

/* hotlink library base pointer */
struct HotLinksBase *HotLinksBase = 0;

/* hotlinks publication block pointer */
struct PubBlock *pb = 0;

/* hotlinks handle */
int hlh = 0;

/* version string */
char 	VERSTAG[]="\0$VER: text2hl B6 (12.20.91)";



/* forward declarations */
int writetext();
void shutdown();


int main(argc, argv)
int argc;
char *argv[];
{
        struct FileInfoBlock fib;
        char *buff;
        int chunksize, error, fi, filesize, lock, newlen;
        unsigned int chunktype;
        
        if(argc!=2)
        {
                printf("USAGE: text2hl <filename>\n");
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

        /* get the file size */
        lock = Lock(argv[1], ACCESS_READ);
        if(lock==0)
        {
                printf("ERROR - could not obtain lock on input file\n");
                shutdown();
                exit(0);
        }
        if((Examine(lock, &fib))==0)
        {
                printf("ERROR - could not examine input file\n");
                UnLock(lock);
                shutdown();
                exit(0);
        }
        filesize = fib.fib_Size;
        UnLock(lock);
        
        /* open the input file */
        if((fi=Open(argv[1], MODE_OLDFILE))==0)
        {
                printf("ERROR - could not open input file for reading\n");
                shutdown();
                exit(0);
        }
        
        /* set up some defaults */
        pb->PRec.Type = DTXT;
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
        
        
        chunktype = FORM;
        WritePub(pb, (char *)&chunktype, 4); /* write the FORM tag */
        chunksize = filesize+12;
        WritePub(pb, (char *)&chunksize, 4); /* write the FORM size */
        chunktype = DTXT;
        WritePub(pb, (char *)&chunktype, 4); /* write the FORM type (DTXT) */

        WritePub(pb, (char *)&chunktype, 4); /* write out the chunk header (DTXT) */
        chunksize = filesize;
        WritePub(pb, (char *)&chunksize, 4);

        /* allocate memory to hold the chunk */
        if((buff=AllocMem(filesize, 0))==0)
        {
                printf("ERROR - out of memory\n");
                ClosePub(pb);
                Close(fi);
                RemovePub(pb);
                shutdown();
                exit(0);
        }

        /* read the chunk data in */
        Read(fi, buff, filesize);
        
        newlen = writetext(pb, buff, filesize);
        
        /* pad the file out to an even byte */
        if(filesize&0x00000001)
        {
                *buff = 0;
                WritePub(pb, buff, 1);
        }
        
        /* free the memory used */
        FreeMem(buff, filesize);
                
        /* close the input file */
        Close(fi);
        
        /* adjust the chunk lengths for the commands written out */
        SeekPub(pb, 4, SEEK_BEGINNING);
        chunksize = newlen+12;
        WritePub(pb, (char *)&chunksize, 4);
        SeekPub(pb, 8, SEEK_CURRENT);
        chunksize = newlen;
        WritePub(pb, (char *)&chunksize, 4);
        SeekPub(pb, 0, SEEK_END);
        
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

int writetext(pb, buff, len)
struct PubBLock *pb;
char *buff;
int len;
{
        int flen;
        char command, cflag, clen;
        
        flen = 0;
        while(len)
        {
                switch(*buff)
                {
                        /* write out the TEXT_TAB command */
                        case 0x09: command = TEXT_TAB;
                                   cflag = TEXT_FLAGS_TAB;
                                   clen = 0;
                                   WritePub(pb, &clen, 1);
                                   WritePub(pb, &command, 1);
                                   WritePub(pb, &cflag, 1);
                                   WritePub(pb, &clen, 1);
                                   flen+=4;
                                   break;
                                   
                        /* write out the TEXT_NEWLINE command */
                        case 0x0a: command = TEXT_NEWLINE;
                                   cflag = TEXT_FLAGS_NEWLINE;
                                   clen = 0;
                                   WritePub(pb, &clen, 1);
                                   WritePub(pb, &command, 1);
                                   WritePub(pb, &cflag, 1);
                                   WritePub(pb, &clen, 1);
                                   flen+=4;
                                   break;
                                   
                        /* write out the text itself */
                        default: WritePub(pb, buff, 1);
                                 flen++;
                                 break;
                }
                len--;
                buff++;
        }
        return(flen);
}
