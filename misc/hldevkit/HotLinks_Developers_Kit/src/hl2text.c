/*
 *
 * hl2text.c - Output a HotLink'ed text file to an ASCII file
 *
 */
 
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/hotlinks.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <lattice/stdio.h>
#include <hotlinks/hotlinks.h>


/* hotlink library base pointer */
struct HotLinksBase *HotLinksBase = 0;

/* hotlinks publication block pointer */
struct PubBlock *pb = 0;

/* hotlinks handle */
int hlh = 0;

/* version string */
char 	VERSTAG[]="\0$VER: hl2text B5 (12.20.91)";


/* forward declarations */
int __asm filterproc(register __a0 struct PubBlock *);
int getcompnum();
void shutdown(), processtext(), processcommand();


int main(argc, argv)
int argc;
char *argv[];
{
        int stilldata, chunksize, error, fo;
        unsigned int chunktype;
        
        if(argc!=2)
        {
                printf("USAGE: hl2text <filename>\n");
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
        ReadPub(pb, (char *)&stilldata, 4); /* get the FORM size */
        ReadPub(pb, (char *)&chunktype, 4); /* get the FORM type (DTXT) */
        
        /* process the chunks */
        stilldata -= 4;
        while(stilldata>0)
        {
                ReadPub(pb, (char *)&chunktype, 4);
                ReadPub(pb, (char *)&chunksize, 4);
                switch(chunktype)
                {
                        case DTXT: /* process the DTXT chunk data */
                                   processtext(pb, fo, chunksize);
                                   
                                   /* adjust the chunklength for an odd length */
                                   if(chunksize&0x00000001)
                                   {
                                        chunksize++;
                                   }
                                   break;
                                   
                        case DTAG: /* process the DTAG chunk */
                                     
                        default: /* adjust the length if it is an odd length */
                                 if(chunksize&0x00000001)
                                 {
                                        chunksize++;
                                 }
                                   
                                 /* does the chunk have any data in it? */
                                 if(chunksize)
                                 {
                                        /* skip the chunk data */
                                        SeekPub(pb, chunksize, SEEK_CURRENT);
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
        if(pb->PRec.Type==DTXT)
        {
                return(ACCEPT);
        }
        else
        {
                return(NOACCEPT);
        }
}

/* process the DTXT chunk from the HotLink'ed file */
void processtext(pb, fo, size)
struct PubBlock *pb;
int fo, size;
{
        int clen, cflag, command;
        unsigned char input;
        
        while(size>0)
        {
                ReadPub(pb, &input, 1);
                size--;
                
                /* is it a command (signaled by a leading 0) */
                if(input==0)
                {
                        size -= getcompnum(pb, &command);
                        size -= getcompnum(pb, &cflag);
                        size -= getcompnum(pb, &clen);
                        processcommand(command, cflag, clen, pb, fo);
                        size -= clen;
                }
                else
                {
                        /* else it must be text so write it out */
                        Write(fo, &input, 1);
                }
        }
}

int getcompnum(pb, clen)
struct PubBlock *pb;
int *clen;
{
        int clen2, count;
        unsigned char len;
        
        /* init clen to 0 */
        clen2 = 0;
        count = 0;
        
        /* read in the first command length byte */
        ReadPub(pb, &len, 1);
        count++;
        
        /* check for "compressed" numeric form (indicated by the high bit being set) */
        while(len&0x80)
        {
                /* mask off the upper bit (indicator bit) */
                len&=0x7f;
                
                /* shift the current command length up by seven bits */
                clen2<<=7;
                
                /* add in the new length byte */
                clen2+=len;
                
                /* get the next len byte */
                ReadPub(pb, &len, 1);
                count++;
        }
        clen2+=len;
        *clen=clen2;
        return(count);
}

void processcommand(com, flag, len, pb, fo)
int com, flag, len;
struct PubBlock *pb;
int fo;
{
        /*
        int x;
        char input;
        */
        char output;
        
        switch(com)
        {
                case TEXT_TAB: output = 9;
                               Write(fo, &output, 1);
                               break;
                
                case TEXT_NEWLINE: output = 10;
                                   Write(fo, &output, 1);
                                   break;
                
                case TEXT_TAG: /*
                               output = 10;
                               Write(fo, &output, 1);
                               Write(fo, "TEXT_TAG: ", 10);
                               for(x=0; x<len; x++)
                               {
                                   ReadPub(pb, &input, 1);
                                   Write(fo, &input, 1);
                               }
                               output = 10;
                               Write(fo, &output, 1);
                               break;
                               */
                               
                case TEXT_FONT: /*
                                output = 10;
                                Write(fo, &output, 1);
                                Write(fo, "TEXT_FONT: ", 11);
                                for(x=0; x<len; x++)
                                {
                                    ReadPub(pb, &input, 1);
                                    Write(fo, &input, 1);
                                }
                                output = 10;
                                Write(fo, &output, 1);
                                break;
                                */
                                
                case TEXT_ATTRB: /*
                                 output = 10;
                                 Write(fo, &output, 1);
                                 Write(fo, "TEXT_ATTRB: ", 12);
                                 for(x=0; x<len; x++)
                                 {
                                     ReadPub(pb, &input, 1);
                                     switch(input)
                                     {
                                        case ATTRB_NORMAL: Write(fo, "Normal ", 7);
                                                           break;
                                                           
                                        case ATTRB_BOLD: Write(fo, "Bold ", 5);
                                                         break;
                                                         
                                        case ATTRB_LIGHT: Write(fo, "Light ", 6);
                                                          break;
                                                          
                                        case ATTRB_ITALIC: Write(fo, "Italic ", 7);
                                                           break;
                                                           
                                        case ATTRB_SHADOW: Write(fo, "Shadow ", 7);
                                                           break;
                                                           
                                        case ATTRB_OUTLINE: Write(fo, "OutLine ", 8);
                                                            break;
                                                            
                                        case ATTRB_UNDERLINE: Write(fo, "Underline ", 10);
                                                              break;
                                                              
                                        case ATTRB_WEIGHT: Write(fo, "Weight=", 7);
                                                           ReadPub(pb, &input, 1);
                                                           Write(fo, &input, 1);
                                                           output=' ';
                                                           Write(fo, &output, 1);
                                                           break;
                                     }
                                 }
                                 output = 10;
                                 Write(fo, &output, 1);
                                 break;
                                 */
                
                case TEXT_JUSTIFY: /*
                                   output = 10;
                                   Write(fo, &output, 1);
                                   Write(fo, "TEXT_JUSTIFY: ", 14);
                                   for(x=0; x<len; x++)
                                   {
                                       ReadPub(pb, &input, 1);
                                       switch(input)
                                       {
                                           case JUSTIFY_LEFT: Write(fo, "Left ", 5);
                                                              break;
                                                              
                                           case JUSTIFY_CENTER: Write(fo, "Center ", 7);
                                                                break;
                                                                
                                           case JUSTIFY_RIGHT: Write(fo, "Right ", 6);
                                                               break;
                                                               
                                           case JUSTIFY_CHAR: Write(fo, "Char ", 5);
                                                              break;
                                                              
                                           case JUSTIFY_WORD: Write(fo, "Word ", 5);
                                                              break;
                                                              
                                           case JUSTIFY_AUTO: Write(fo, "Auto ", 5);
                                                              break;
                                       }
                                   }
                                   output = 10;
                                   Write(fo, &output, 1);
                                   break;
                                   */
                case TEXT_EOC:
                case TEXT_EOP:
                case TEXT_BCCB:
                case TEXT_ECCB:
                case TEXT_BCPB:
                case TEXT_ECPB:
                case TEXT_PAGENUM:
                case TEXT_MARK:
                case TEXT_BRANGE:
                case TEXT_ERANGE:
                case TEXT_FOOTNOTE:
                case TEXT_RULER:
                case TEXT_BAKERN:
                case TEXT_EAKERN:
                case TEXT_BAHYPHEN:
                case TEXT_EAHYPHEN:
                case TEXT_TRACKRANGE:
                case TEXT_DROPCAP:
                case TEXT_POINT:
                case TEXT_PARAGRAPH:
                case TEXT_INDENT:
                case TEXT_LEADING:
                case TEXT_PARALEAD:
                case TEXT_TRACKING:
                case TEXT_BASELINE:
                case TEXT_MKERN:
                case TEXT_AKERN:
                case TEXT_MHYPHEN:
                case TEXT_AHYPHEN:
                
                default: SeekPub(pb, len, SEEK_CURRENT);
                         break;
        }
}
