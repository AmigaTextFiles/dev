#include <exec/memory.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <pragmas/exec_sysbase_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <dos/dos.h>

struct Library *DOSBase, *SysBase;
__far struct FileInfoBlock fib;
struct {
	STRPTR from;
	STRPTR to;
	ULONG *fill;
} arg = { 0 };
#define TEMPLATE "FROM/A,TO/A,FILL/N"
STRPTR inpoint;
ULONG rc;
UBYTE unhex(void);
UBYTE unhexbyte(void);

__saveds main()
{
	SysBase = *((struct Library **)4L);
	rc = 20;
	if(DOSBase = OpenLibrary("dos.library",36))
	{
		struct RDArgs *rda;
		Printf("%s © Russian Digital Computing\n",6+"$VER: unhex 1.0 "__AMIGADATE__);
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
						ULONG end = 0, erc = 0, nl = 0, segment = 0;
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
										ULONG fulladdr = segment + (hiaddr<<8) + loaddr;
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
									case 4: //linear address
									{
										UBYTE hisegm = unhex();
										UBYTE losegm = unhex();
										if(loaddr|hiaddr|(len-2))
										{
											erc = 3;
											goto hexend;
										}
										segment = (hisegm<<12) + (losegm<<4);
										if(4==type)
										{
											segment <<= 12;
										}
										if((UBYTE)(sum+hisegm+losegm+unhex()))
										{
											erc = 1;
											goto hexend;
										}
										break;
									}
									case 3: //segment start address
									case 5: //linear start address
									{
										if(loaddr|hiaddr|(len-4))
										{
											erc = 3;
											goto hexend;
										}
										while(len--) sum += unhex();
										if((UBYTE)(sum+unhex()))
										{
											erc = 1;
											goto hexend;
										}
										break;
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
								"Invalid" };
							Printf("%s line %ld\n",errtxt[erc-1],line);
							if(!actualen)
							{
								Printf("Possibly n%s","ot an Intel Hex file\n");
							}
						}
						else
						{
							if(actualen)
							{
								if(end)
								{
									STRPTR outdata = inpoint = indata;
									ULONG outmem = 0, segment = 0;
									BPTR outfile;
									if(nl)
									{
										Printf("Warning: non-linear file\n");
										if(outdata = AllocVec(actualen,MEMF_CLEAR))
										{
											if(arg.fill)
											{
												ULONG count = actualen;
												STRPTR fillpoint = outdata;
												UBYTE filler = *arg.fill;
												while(count--)
												{
													*fillpoint++ = filler;
												}
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
										while(':'==*inpoint++)
										{
											UBYTE len = unhex();
											UBYTE hiaddr = unhex();
											UBYTE loaddr = unhex();
											UBYTE type = unhex();
											switch(type)
											{
												case 0:
												{
													STRPTR outpoint = outdata + segment + (hiaddr<<8) + loaddr;
													while(len--) *outpoint++ = unhex();
													break;
												}
												case 2:
												{
													segment = unhex()<<12;
													segment += unhex()<<4;
													break;
												}
											}
											inpoint += 2;
											while('!'>*inpoint) inpoint++;
										}
										if(outfile = Open(arg.to,MODE_NEWFILE))
										{
											if(actualen==Write(outfile,outdata,actualen))
											{
												Close(outfile);
												Printf("Done!\n");
												rc = 0;
											}
											else
											{
												Printf("Write file error\n");
											}
										}
										else
										{
											Printf("Can't open outfile\n");
										}
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
									Printf("N%s","ot an Intel Hex file\n");
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
		}
		else
		{
			Printf("Error in arguments\n");
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
