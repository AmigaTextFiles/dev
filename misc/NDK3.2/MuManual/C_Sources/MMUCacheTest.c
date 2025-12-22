/*********************************************************
 ** MMUCacheTest                                        **
 ** test whether the pre/postDMA functions work         **
 ** correctly                                           **
 ** Version 0.25 14th Mar 1998                          **
 ** THOR-Software, Thomas Richter                       **
 *********************************************************/

/// Includes
#include <exec/types.h>
#include <exec/ports.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <exec/execbase.h>
#include <mmu/mmubase.h>

#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/filehandler.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/mmu.h>

#include <string.h>
#include <stdio.h>
///
/// Defines
#define REVISION 10
#define STRINGVERSION "0.25"
#define STRINGDATE "14.3.99"
#define NUMARGS 1L

#define BUFSIZE (128L*1024L)
#define MAJIK1 ('Test')
#define MAJIK2 (0xaa55ff00)
#define MAJIK3 (0x11223344)
#define MAJIK4 ('THOR')
#define RETRIES 64
///
/// Statics
struct MMUBase *MMUBase;
extern struct DosLibrary *DOSBase;
extern struct ExecBase *SysBase;
struct MsgPort *ioport;
struct IOStdReq *io;
///
/// Prototypes
void FlushLibs(void);
int RunTests(char *devicename);
int main(int argc,char **argv);
int AccessDevice(void);
ULONG CheckSum(ULONG *buf,ULONG size);
///

char version[]="$VER: MMUCacheTest " STRINGVERSION " (" STRINGDATE ") © THOR";

/// main
int main(int argc,char **argv)
{
char *devicename;
int len;
int rc=0;

        FlushLibs();
        printf( "MMUCacheTest " STRINGVERSION " (" STRINGDATE ") © THOR.\n"
                "Internal use only, no commercial use.\n");

        if ((argc<2) || (argc>3) || (!strcmp(argv[1],"?"))) {
                printf("\nThis program reads from your HD to check whether the\n"
                       "cache control functions of the mmu.library work\n"
                       "correctly. It does not write to the HD at all and won't\n"
                       "harm your data.\n\n"
                       "Usage: %s device_name: [nommu]\n\n",argv[0]);
        } else {
                if (argc==2) {
                        MMUBase=(struct MMUBase *)OpenLibrary(MMU_NAME,0);
                } else  MMUBase=0;

                devicename=argv[1];
                len=strlen(devicename);
                if (devicename[len-1]!=':') {
                        printf("The device name must be given with a colon at the\n"
                               "end, e.g. DH0:\n\n");
                        rc=5;
                } else {
                        devicename[len-1]=0;
                        rc=RunTests(devicename);
                }

                if (MMUBase)    CloseLibrary((struct Library *)MMUBase);
        }

        return rc;
}
///
/// RunTests
int RunTests(char *devicename)
{
struct DosList *dl;
struct DosEnvec *env;
struct FileSysStartupMsg *fstart;
char *devname;
int len;
ULONG unit,flags;
char device[256];
BOOL locked=TRUE;
int rc=10;

        if (dl=LockDosList(LDF_DEVICES|LDF_READ)) {
                if (dl=FindDosEntry(dl,devicename,LDF_DEVICES|LDF_READ)) {
                        fstart=BADDR(dl->dol_misc.dol_handler.dol_Startup);
                        if (TypeOfMem(fstart)) {
                                if (fstart->fssm_Unit<0x400) {
                                        env=BADDR(fstart->fssm_Environ);
                                        if (TypeOfMem(env)) {
                                                unit=fstart->fssm_Unit;
                                                flags=fstart->fssm_Flags;
                                                devname=BADDR(fstart->fssm_Device);
                                                if (TypeOfMem(devname)) {
                                                        len=devname[0];
                                                        memcpy(device,devname+1,len);
                                                        device[len]=0;

                                                        UnLockDosList(LDF_DEVICES|LDF_READ);
                                                        locked=FALSE;

                                                        if (ioport=CreateMsgPort()) {
                                                                if (io=(struct IOStdReq *)CreateIORequest(ioport,sizeof(struct IOStdReq))) {
                                                                        if (!OpenDevice(device,unit,(struct IORequest *)io,flags)) {
                                                                                rc=AccessDevice();
                                                                                CloseDevice((struct IORequest *)io);
                                                                        } else  printf("Failed to open the %s.\n",device);
                                                                        DeleteIORequest((struct IORequest *)io);
                                                                } else printf("Failed to allocate the IORequest.\n");
                                                                DeleteMsgPort(ioport);
                                                        } else printf("Failed to create the IO message port.\n");
                                                } else rc=5;
                                        } else rc=5;
                                } else rc=5;
                        } else rc=5;

                        if (rc==5) {
                                printf("The selected device is not a direct block I/O device.\n"
                                       "Please specify a FAST DMA device for testiing.\n");
                        }
                } else printf("Sorry, %s: is either not mounted or not a device.\n"
                              "Please DO NOT specify volumes or assigns.\n",devicename);

                if (locked)
                        UnLockDosList(LDF_DEVICES|LDF_READ);

        }

        return rc;
}
///
/// AccessDevice
int AccessDevice(void)
{
ULONG *buffer;
UBYTE *mem;
int i;
int error;
ULONG sum;
ULONG discount;
ULONG accesscount;
volatile ULONG check,*ptr,*ptr2; /* make sure these are really read */
long pri;
ULONG mask;

        /* Allocate memory aligned to cache line boundaries */

        mem=AllocMem(BUFSIZE+16*3,MEMF_PUBLIC);
        if (!mem) {
                printf("Out of memory, sorry!\n");
                return 20;
        }
        buffer=(ULONG *)(((ULONG)(mem+15)) & 0xfffffff0);

        if (MMUBase) {
                printf("mmu.library loaded.\n");
        } else  printf("mmu.library not utilized.\n");

        /* Fill in some magic stuff */
        ptr=buffer;
        ptr2=buffer+8+BUFSIZE;  /* to the end of the buffer */
        buffer[0]=MAJIK1;
        buffer[1]=MAJIK2;
        buffer[2]=MAJIK3;
        buffer[3]=MAJIK4;
        CacheClearU();
        /* Make sure the stuff is really in memory */

        printf("Initial read, calculate checksum.\n");
        io->io_Command=CMD_READ;
        io->io_Length=BUFSIZE;
        io->io_Offset=0;             /* well, whereever... this doesn't really matter... */
        io->io_Data=buffer;
        error=DoIO((struct IORequest *)io);
        if (error) {
                printf("Can't read from the device, failure code %ld.\n",error);
                goto error;             /* bah! */
        }
        sum=CheckSum(buffer,BUFSIZE>>2);

        printf("\nRunning the initial device test.\n"
               "This test checks whether the connected device works reliable.\n"
               "It does NOT check the MMU code which is not needed for this\n"
               "initial run.\n"
               "This test SHOULD NOT fail. In case it does, your device or\n"
               "host adapter is broken, but not the MMU logic.\n\n"
               "In case you're running any disk cache program, e.g. DynamiCache,\n"
               "you should disable it for this test. The test won't test anything\n"
               "if any kind of disk cache is active!\n\n");

        for(i=0;i<RETRIES;i++) {
                /* For general entertainment, read data from somewhere else.
                   This should hopefully disable caching of the device. */
                io->io_Command=CMD_READ;
                io->io_Length=BUFSIZE;
                io->io_Offset=800L*1024L;       /* well, whereever... this doesn't really matter... */
                io->io_Data=buffer;
                error=DoIO((struct IORequest *)io);
                if (error) {
                        printf("Can't read from the device, failure code %ld.\n",error);
                        goto error;             /* bah! */
                }

                buffer[0]=MAJIK1;
                buffer[1]=MAJIK2;
                buffer[2]=MAJIK3;
                buffer[3]=MAJIK4;
                CacheClearU();
                /* Make sure the stuff is really in memory */
                io->io_Command=CMD_READ;
                io->io_Length=BUFSIZE;
                io->io_Offset=0;
                io->io_Data=buffer;
                error=DoIO((struct IORequest *)io);
                if (error) {
                        printf("Can't read from the device, failure code %ld.\n",error);
                        goto error;             /* bah! */
                }
                if (sum!=CheckSum(buffer,BUFSIZE>>2)) {
                        printf("FATAL ERROR: Device read does not work reliable!\n"
                               "Test failed. Looks like your hardware is broken, sorry.\n");
                        goto error;
                }
        }
        printf("The initial test passed.\n");

        accesscount=0;
        discount=0;

        printf("\nRunning the real test. If this test fails, something is wrong\n"
               "with the CachePreDMA/CachePostDMA logic. In this case, please\n"
               "sent me an EMail so I can fix it.\n");

        for(i=0;i<RETRIES;i++) {
                /* For general entertainment, read data from somewhere else.
                   This should hopefully disable caching of the device. */
                io->io_Command=CMD_READ;
                io->io_Length=BUFSIZE;
                io->io_Offset=800L*1024L;       /* well, whereever... this doesn't really matter... */
                io->io_Data=buffer;
                error=DoIO((struct IORequest *)io);
                if (error) {
                        printf("Can't read from the device, failure code %ld.\n",error);
                        goto error;             /* bah! */
                }

                /* start at a non-aligned address */
                io->io_Command=CMD_READ;
                io->io_Length=BUFSIZE;
                io->io_Offset=0;
                io->io_Data=buffer+8;

                mask=(1<<i)-1;

                pri=SetTaskPri(FindTask(NULL),1);

                CacheClearU();
                /* Push some stuff into the cache */
                buffer[0]=MAJIK1;
                buffer[1]=MAJIK2;
                buffer[2]=MAJIK3;
                buffer[3]=MAJIK4;

                /* Now start the IO, asynchronously */
                SendIO((struct IORequest *)io);
                while (((UBYTE)(SysBase->IDNestCnt))!=0xff || ((UBYTE)(SysBase->TDNestCnt))!=0xff) {
                        Delay(2L);
                        discount++;
                }

                /* access the memory while the IO is active */
                while(!CheckIO((struct IORequest *)io)) {
                        check=*ptr;
                        check=*ptr2;
                        accesscount++;
                        if ((accesscount & mask)==0) {
                                (*ptr)++;
                                (*ptr2)++;
                        }
                }

                SetTaskPri(FindTask(NULL),pri);

                error=WaitIO((struct IORequest *)io);
                if (error) {
                        printf("Can't read from the device, failure code %ld.\n",error);
                        goto error;             /* bah! */
                }
                if (sum!=CheckSum(buffer+8,BUFSIZE>>2)) {
                        printf("The MMU cache test failed. There seems to be a bug in\n"
                               "the CachePre/PostDMA functions. Please let me know!\n\n");
                        goto error;
                }
        }
        printf("The MMU cache test passed.\n"
               "Task switching was disabled %ld times, run %lu RAM accesses.\n",discount,accesscount);
        Delay(100L);

        FreeMem(mem,BUFSIZE+16*3);
        return 0;

error:
        FreeMem(mem,BUFSIZE+16*3);
        return 10;
}
///
/// CheckSum
/* Calculate a hopefully somewhat useable checksum for the buffer. Size
   is in long words */
ULONG CheckSum(ULONG *buf,ULONG size)
{
ULONG sum=0;

        while(size) {
                sum += *buf;
                sum ^= size;
                if (sum & 0x01) {
                        sum >>= 1;
                        sum |= 0x80000000;
                } else  sum >>= 1;

                buf++;
                size--;
        }

        return sum;
}
///
/// FlushLibs
void FlushLibs(void)
{
void *mem;

        if (mem=AllocMem(0x7ffffff0,MEMF_PUBLIC))
                FreeMem(mem,0x7ffffff0);
}
///

