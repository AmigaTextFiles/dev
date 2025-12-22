#include <stdio.h>
#include <stdlib.h>

#include <exec/types.h>
#include <devices/input.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>

void main(int argc, char** argv)
{
	puts("Set the Mouseport, ©1999 Point Design Software, Jürgen Schober");
	puts("USAGE: SetMousePort [0|1] (Default = 0)");

	BYTE port = 0;

	if (argc > 1) port = atoi(argv[1]);

	MsgPort  *Iport = CreatePort(NULL,NULL);
	if (Iport)
	{
		IOStdReq *IOreq = (IOStdReq*)CreateExtIO(Iport,sizeof(IOStdReq));
		if (IOreq)
		{
			if (!OpenDevice("input.device",NULL,(IORequest*)IOreq,NULL))
			{
				printf("Setting Mouse to Port %d\n",port);
				IOreq->io_Data = &port;
				IOreq->io_Flags = IOF_QUICK;
				IOreq->io_Length = 1;
				IOreq->io_Command = IND_SETMPORT;
				BeginIO((IORequest*)IOreq);

				if (IOreq->io_Error) printf("Failed!\n");

				CloseDevice((IORequest*)IOreq);
			}
			DeleteExtIO((IORequest*)IOreq);
		}
		DeletePort(Iport);
	}
}