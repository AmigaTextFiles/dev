#include <exec/memory.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/misc_protos.h>
#include <clib/timer_protos.h>
#include <pragmas/exec_sysbase_pragmas.h>
#include <pragmas/timer_pragmas.h>
#include <pragmas/misc_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <resources/misc.h>
#include <dos/dos.h>

#define PORTVALUE *((STRPTR)0xbfe101)
#define PORTSTATE *((STRPTR)0xbfe301)
#define BSET(val,bit) val|=(1<<bit)
#define BCLR(val,bit) val&=(~(1<<bit))
#define BTST(val,bit) (val&(1<<bit))

struct Library *DOSBase, *SysBase, *MiscBase;
static UBYTE pvout, psout;
struct MsgPort *timereplyport;
struct timerequest *timereq;

void pwait(void);

__saveds main()
{
	SysBase = *((struct Library **)4L);
	if(DOSBase = OpenLibrary("dos.library",36))
	{
		if(MiscBase = OpenResource(MISCNAME))
		{
			if(timereplyport = CreateMsgPort())
			{
				if(timereq = (struct timerequest *)CreateIORequest(timereplyport,sizeof(struct timerequest)))
				{
					if(!OpenDevice(TIMERNAME,UNIT_MICROHZ,(struct IORequest *)timereq,0))
					{
						STRPTR owner;
						if(!(owner = AllocMiscResource(MR_PARALLELPORT,"PIC debug info receiver")))
						{
							UBYTE fflag = 0;
							Printf("%s 1.5  © 2000 Russian Digital Computing\nCTRL/C - quit, CTRL/D - reset PIC\n","PIC debug info receiver");
							pvout = 1+2+8+16;
							PORTVALUE = pvout;
							psout = 2+4+8+16;
							PORTSTATE = psout;
							while(1)
							{
								if(BTST(PORTVALUE,0))
								{
									if(fflag)
									{
										Flush(Output());
										fflag = 0;
									}
									else
									{
										Delay(2);
									}
								}
								else
								{
									UBYTE inbyte;
									UBYTE cnt = 9;
									while(cnt--)
									{
										inbyte <<= 1;
										inbyte |= BTST(PORTVALUE,0);
										BCLR(pvout,1);
										pwait();
										BSET(pvout,1);
										pwait();
									}
									Printf("%02lx ",(ULONG)inbyte);
									fflag = 1;
								}
								if(CheckSignal(SIGBREAKF_CTRL_C))
								{
									Printf("\n");
									break;
								}
								if(CheckSignal(SIGBREAKF_CTRL_D))
								{
									BSET(pvout,2);
									PORTVALUE = pvout;
									BCLR(pvout,2);
									PORTVALUE = pvout;
								}
							}
							FreeMiscResource(MR_PARALLELPORT);
						}
						else
						{
							Printf("Can't allocate parallel port - it is owned by %s\n",owner);
						}
						CloseDevice((struct IORequest *)timereq);
					}
					else
					{
						Printf("Can't open %s\n",TIMERNAME);
					}
					DeleteIORequest((struct IORequest *)timereq);
				}
				else
				{
					Printf("Can't create IORequest\n");
				}
				DeleteMsgPort(timereplyport);
			}
			else
			{
				Printf("Can't create msgport\n");
			}
		}
		else
		{
			Printf("Can't open %s\n",MISCNAME);
			return(0);
		}
		CloseLibrary(DOSBase);
	}
	return(0);
}

void pwait()
{
	timereq->tr_node.io_Command = TR_ADDREQUEST;
	timereq->tr_time.tv_secs = 0;
	timereq->tr_time.tv_micro = 10;
	DoIO((struct IORequest *)timereq);
	PORTVALUE = pvout;
}
