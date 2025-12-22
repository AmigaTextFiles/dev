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

struct Library *DOSBase, *SysBase, *TimerBase, *MiscBase;
struct MsgPort *timereplyport;
struct timerequest *timereq;
__far struct FileInfoBlock fib;
struct {
	STRPTR from;
	ULONG* force;
	ULONG* smartflash;
	ULONG* configword;
	ULONG verify;
} arg = { 0, 0, 0, 0, 0 };
#define TEMPLATE "FROM/A,FORCE/N,SF=SMARTFLASH/N,CW=CONFIGWORD/N,V=VERIFY/S"
STRPTR inpoint;
static ULONG pvout, psout;
ULONG rc;
__far static UWORD deltabuf[8192];
UBYTE unhex(void);
UBYTE unhexbyte(void);

ULONG picReadCode(void);
ULONG picRecv(ULONG);
ULONG picSetup(void);
void picCmd(ULONG);
void picSend(ULONG, ULONG);
void picWait(ULONG);
void picInc(void);
void picIncNum(ULONG);
void picEnterProgMode(void);
void picUndocmd(void);
void picEraseProg(ULONG);
void picProgOnly(ULONG);
void picCleanup(void);
void picLoadCode(ULONG);
void picLoadConf(ULONG);

enum {
LOADCONF = 0,
UNDOC1,
LOADCODE,
LOADDATA,
READCODE,
READDATA,
INCADDR,
UNDOC2,
BEGINPROG,
ERASECODE,
ERASEDATA = 11,
PROGONLY = 24
};

__saveds main()
{
	SysBase = *((struct Library **)4L);
	rc = 20;
	if(DOSBase = OpenLibrary("dos.library",36))
	{
		if(timereplyport = CreateMsgPort()) // ReplyPort for time requests
		{
			if(timereq = (struct timerequest *)CreateIORequest(timereplyport,sizeof(struct timerequest)))
			{
				if(!OpenDevice(TIMERNAME,UNIT_MICROHZ,(struct IORequest *)timereq,0))
				{
					struct RDArgs *rda;
					Printf("%s  © Russian Digital Computing\n",6+"$VER: picprog 1.4 "__AMIGADATE__);
					if(rda = ReadArgs(TEMPLATE,(LONG *)&arg,NULL))
					{
						BPTR infile;
						if(infile = Open(arg.from,MODE_OLDFILE))
						{
							STRPTR indata;
							ExamineFH(infile,&fib);
							if(inpoint = indata = AllocVec(fib.fib_Size+1000,MEMF_CLEAR))
							{
								*(indata+fib.fib_Size+998) = 0x0A;
								if(-1!=Read(infile,indata,fib.fib_Size))
								{
									ULONG end = 0, erc = 0, nl = 0;
									ULONG line = 0, actualen = 0, lastaddr = 0;
									while(TRUE)
									{
										line++;
										if(':'==*inpoint)
										{
											STRPTR checkpoint = ++inpoint;
											UBYTE len = unhex();
											UBYTE hiaddr = unhex();
											UBYTE loaddr = unhex();
											UBYTE type = unhex();
											UBYTE sum = len + loaddr + hiaddr + type;
											ULONG checklen = (len+5)<<1;
											while(checklen--)
											{
												UBYTE tb = *checkpoint++;
												if((tb<'0')||
													(tb>'f')||
													((tb>'9')&&(tb<'A'))||
													((tb>'F')&&(tb<'a')))
												{
													erc = 3;
													goto hexend;
												}
											}
											switch(type)
											{
												case 0: //data
												{
													ULONG fulladdr = (hiaddr<<8) + loaddr;
													if(lastaddr!=fulladdr)
													{
														nl=1;
													}
													lastaddr = fulladdr+len;
													if(lastaddr>actualen)
													{
														actualen=lastaddr;
													}
													while(len--) sum += unhex();
													if((UBYTE)(sum+unhex()))
													{
														erc = 1;
														goto hexend;
													}
													break;
												}
												case 1: //EOF
												{
													if(loaddr|hiaddr|len) //it is not a typo
													{
														erc = 3;
														goto hexend;
													}
													if((UBYTE)(sum+unhex()))
													{
														erc = 1;
													}
													end = 1;
													goto hexend;
												}
												case 2: //segment address
												case 3: //segment start address
												case 4: //linear address
												case 5: //linear start address
												{
													erc = 3;
													goto hexend;
												}
												default:
												{
													erc = 2;
													goto hexend;
												}
											}
										}
										while((0x0A!=*inpoint)&&(0x0D!=*inpoint))
										{
											inpoint++;
										}
										if((0x0D==*inpoint)&&(0x0A==inpoint[1]))
										{
											inpoint++;
										}
										if((inpoint++)>(indata+fib.fib_Size))
										{
											break;
										}
									}
									hexend:
									if(erc)
									{
										static STRPTR errtxt[] = {
											"Checksum error at",
											"Unknown record type at",
											"Invalid",
											"Unsupported record type (useless for PIC16 object files) at" };
										Printf("%s line %ld\n",errtxt[erc-1],line);
										if(!actualen)
										{
											Printf("Possibly n%s","ot an !ntel Hex file\n");
										}
									}
									else
									{
										if(actualen)
										{
											if(end)
											{
												STRPTR outdata = inpoint = indata;
												ULONG outmem = 0;
												if(nl)
												{
													//Printf("Warning: non-linear file\n");
													if(outdata = AllocVec(actualen,MEMF_ANY))
													{
														ULONG count = actualen;
														STRPTR fillpoint = outdata;
														while(count--)
														{
															*fillpoint++ = 0xff;
														}
														outmem = 1;
													}
													else
													{
														Printf("Can't allocate memory for output file\n");
													}
												}
												if(outdata)
												{
													UWORD *wordbuf = (UWORD*)outdata;
													ULONG wc = actualen>>1, wordcount, word;
													ULONG wordswritten = 0;
													if(wc>8192)
													{
														wc=8192;
													}
													while(':'==*inpoint++)
													{
														UBYTE len = unhex();
														UBYTE hiaddr = unhex();
														UBYTE loaddr = unhex();
														UBYTE type = unhex();
														if(!type)
														{
															STRPTR outpoint = outdata + (hiaddr<<8) + loaddr;
															while(len--) *outpoint++ = unhex();
														}
														inpoint += 2;
														while('!'>*inpoint) inpoint++;
													}

													// PIC16Fxxx PROGRAMMING START

													if(picSetup())
													{
														picEnterProgMode();
														if(arg.force)
														{
															picLoadConf(*arg.force); //0x3ffa для 16f84, 0x3f3a для 16f876
															picIncNum(7);
															picUndocmd();
															picEraseProg(10);
															picUndocmd();
															picEnterProgMode();
														}
														word = 0;
														wordcount = wc;
														if(arg.smartflash)
														{
															ULONG words = 0, wordiff = 0;
															if(arg.force)
															{
																words++;
																wordiff++;
															}
															else
															{
																while(wordcount--)
																{
																	UWORD val = (*wordbuf>>8)|(*wordbuf<<8);
																	if(!(0xC000 & val))
																	{
																		if(val != (deltabuf[word] = picReadCode()))
																		{
																			wordiff++;
																		}
																		words++;
																	}
																	picInc();
																	wordbuf++;
																	word++;
																}
															}
															if(wordiff)
															{
																picEnterProgMode();
																word = 0;
																wordcount = wc;
																wordbuf = (UWORD*)outdata;
																if((wordiff<<1)>words)
																{
																	picLoadCode(0xffff);
																	picCmd(ERASECODE);
																	picEraseProg(10);
																	picEnterProgMode();
																	while(wordcount--)
																	{
																		UWORD val = (*wordbuf>>8)|(*wordbuf<<8);
																		if(!(0xC000 & val))
																		{
																			ULONG tempdat;
																			picLoadCode(val);
																			picProgOnly(*arg.smartflash);
																			tempdat = picReadCode();
																			if(val != tempdat)
																			{
																				Printf("Error writing location %ld\n",word);
																				Printf("must be %lx but read %lx\n",val,tempdat);
																				goto picerr;
																			}
																			wordswritten++;
																		}
																		picInc();
																		wordbuf++;
																		word++;
																	}
																}
																else
																{
																	while(wordcount--)
																	{
																		UWORD val = (*wordbuf>>8)|(*wordbuf<<8);
																		if(!(0xC000 & val))
																		{
																			if(val != deltabuf[word])
																			{
																				ULONG tempdat;
																				picLoadCode(val);
																				picEraseProg((*arg.smartflash)<<1);
																				tempdat = picReadCode();
																				if(val != tempdat)
																				{
																					Printf("Error writing location %ld\n",word);
																					Printf("must be %lx but read %lx\n",val,tempdat);
																					goto picerr;
																				}
																				wordswritten++;
																			}
																		}
																		picInc();
																		wordbuf++;
																		word++;
																	}
																}
															}
														}
														else
														{
															while(wordcount--)
															{
																UWORD val = (*wordbuf>>8)|(*wordbuf<<8);
																ULONG tempdat;
																if(!(0xC000 & val))
																{
																	tempdat = picReadCode();
																	if(val != tempdat)
																	{
																		picLoadCode(val);
																		picEraseProg(10);
																		tempdat = picReadCode();
																		if(val != tempdat)
																		{
																			Printf("Error writing location %ld\n",word);
																			Printf("must be %lx but read %lx\n",val,tempdat);
																			goto picerr;
																		}
																		wordswritten++;
																	}
																}
																picInc();
																wordbuf++;
																word++;
															}
														}
														if(arg.verify)
														{
															wordbuf = (UWORD*)outdata;
															picEnterProgMode();
															word = 0;
															wordcount = wc;
															while(wordcount--)
															{
																UWORD val = (*wordbuf>>8)|(*wordbuf<<8);
																ULONG tempdat;
																if(!(0xC000 & val))
																{
																	if(val != (tempdat=picReadCode()))
																	{
																		Printf("Verify error at location %ld\n",word);
																		Printf("must be %lx but read %lx\n",val,tempdat);
																		goto picerr;
																	}
																}
																picInc();
																wordbuf++;
																word++;
															}
														}
														if(arg.configword)
														{
															picLoadConf(*arg.configword);
															picIncNum(7);
															if((*arg.configword) != picReadCode())
															{
																picLoadCode(*arg.configword);
																picEraseProg(10);
																if((*arg.configword) != picReadCode())
																{
																	Printf("Error writing configuration word\n");
																	goto picerr;
																}
																wordswritten++;
															}
														}
														rc = 0;
														if(wordswritten)
														{
															Printf("Programming finished, %ld location%s done\n",wordswritten,wordswritten>1?"s":1+"s");
														}
														else
														{
															Printf("No differencies - nothing to do!\n");
														}
														picerr:
														picCleanup();
													}

													// PIC16Fxxx PROGRAMMING END

													if(outmem)
													{
														FreeVec(outdata);
													}
												}
											}
											else
											{
												Printf("EOF record not found\n");
											}
										}
										else
										{
											if(end)
											{
												Printf("File does not contain any data\n");
											}
											else
											{
												Printf("N%s","ot an !ntel Hex file\n");
											}
										}
									}
								}
								FreeVec(indata);
							}
							else
							{
								Printf("Can't allocate memory for input file\n");
							}
							Close(infile);
						}
						else
						{
							Printf("Can't open source file\n");
						}
						FreeArgs(rda);
					}
					else
					{
						Printf("Error in arguments\n");
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
		CloseLibrary(DOSBase);
	}
	return(rc);
}

UBYTE unhex(void)
{
	return((UBYTE)((unhexbyte()<<4)+unhexbyte()));
}

UBYTE unhexbyte(void)
{
	if(*inpoint<='9')
	{
		return((UBYTE)((*inpoint++)-'0'));
	}
	return((UBYTE)(((*inpoint++)|32)-'a'+10));
}



/**************************/
/*                        */
/*   HARDWARE INTERFACE   */
/*                        */
/**************************/

#define PORTVALUE *((STRPTR)0xbfe101)
#define PORTSTATE *((STRPTR)0xbfe301)
#define BSET(val,bit) val|=(1<<bit)
#define BCLR(val,bit) val&=(~(1<<bit))
#define BTST(val,bit) val & (1<<bit)

ULONG picSetup(void)
{
	if(MiscBase = OpenResource(MISCNAME))
	{
		STRPTR owner;
		if(owner = AllocMiscResource(MR_PARALLELPORT,"PIC programmer"))
		{
			Printf("Can't allocate parallel port - it is owned by %s\n",owner);
			return(0);
		}
		else return(1);
	}
	else
	{
		Printf("Can't open %s\n",MISCNAME);
		return(0);
	}
}

void picCleanup(void)
{
	psout = 4+8+16;
	PORTSTATE = psout;
	pvout = 4;
	PORTVALUE = pvout;
	pvout = 8+16;
	PORTVALUE = pvout;
	FreeMiscResource(MR_PARALLELPORT);
}

void picCmd(ULONG cmd)
{
	picSend(cmd,6);
}

void picInc(void)
{
	picSend(INCADDR,6);
}

void picIncNum(ULONG num)
{
	while(num--)
	{
		picInc();
	}
}

void picUndocmd(void)
{
	picCmd(UNDOC1);
	picCmd(UNDOC2);
}

void picEraseProg(ULONG time)
{
	picCmd(BEGINPROG);
	picWait(time);
}

void picProgOnly(ULONG time)
{
	picCmd(PROGONLY);
	picWait(time);
}

void picWait(ULONG time)
{
	timereq->tr_node.io_Command = TR_ADDREQUEST;
	timereq->tr_time.tv_secs = 0;
	timereq->tr_time.tv_micro = time*1000;
	DoIO((struct IORequest *)timereq);
}

ULONG picReadCode(void)
{
	picCmd(READCODE);
	return(0x3fff&(picRecv(16)>>1));
}

void picLoadCode(ULONG data)
{
	picCmd(LOADCODE);
	picSend(data<<1,16);
}

void picLoadConf(ULONG data)
{
	picCmd(LOADCONF);
	picSend(data<<1,16);
}

void picSend(ULONG val, ULONG bits)
{
	BSET(psout,0);
	PORTSTATE = psout;
	while(bits--)
	{
		BSET(pvout,1);
		if(BTST(val,0))
		{
			BSET(pvout,0);
		}
		else
		{
			BCLR(pvout,0);
		}
		PORTVALUE = pvout;
		BCLR(pvout,1);
		PORTVALUE = pvout;
		val >>= 1;
	}
}

ULONG picRecv(ULONG bits)
{
	ULONG val = 0;
	BCLR(psout,0);
	PORTSTATE = psout;
	while(bits--)
	{
		BSET(pvout,1);
		PORTVALUE = pvout;
		BCLR(pvout,1);
		PORTVALUE = pvout;
		val >>= 1;
		if(BTST(PORTVALUE,0))
		{
			BSET(val,15);
		}
	}
	return(val);
}

void picEnterProgMode(void)
{
	psout = 1+2+4+8+16;
	PORTSTATE = psout;
	pvout = 0;
	PORTVALUE = pvout;
	BSET(pvout,2);
	PORTVALUE = pvout;
	BCLR(pvout,2);
	PORTVALUE = pvout;
}
