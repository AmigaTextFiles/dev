#include <stdlib.h>
#include <stdio.h>

#include <dos/dos.h>
#include <intuition/classusr.h>

#include <Sources:EasySocket/EasySocket.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>

#include <clib/alib_protos.h>
#include <clib/easysocket_protos.h>

#define REG(x) register __##x

BOOL	MyInit (void);
void	MyDeInit (void);

struct Library *EasySocketBase;
struct IClass *myclientclass=0;
APTR	SocketApp=0;
APTR	ClientObj;

LONG mConnected(struct IClass *cl,Object *obj,struct ESP_Connected *msg)
{
	printf("Got connection to server.\n");
	DoMethod(obj,ESM_Socket_Write,"Hello World\n",-1,0);
	return (0);
}

LONG mError(struct IClass *cl,Object *obj,struct ESP_Error *msg)
{
	printf("Socket error: %ld - Class error: %lx\n",msg->primaryError,msg->classError);
	return (0);
}

LONG MyDispatcher (REG(a0) struct IClass *cl,REG(a2) APTR obj,REG(a1) Msg msg)
{
	switch (msg->MethodID)
	{
		case ESM_Socket_EventConnected:	return(mConnected(cl,obj,(APTR)msg));
		case ESM_Socket_Error			:	return(mError(cl,obj,(APTR)msg));
	}

	return(DoSuperMethodA(cl,obj,msg));
}

/*	MAIN LOOP	*/

int main (void)
{
	ULONG sigs = 0,socksigs;

	if (EasySocketBase = (struct Library *)OpenLibrary ("EasySocket.library",0))
	{
		if (MyInit())

	{
	SocketApp = SocketAppObject, ESA_Application_Child,
			ClientObj = NewObject(myclientclass, NULL,
				ESA_Socket_HostName, "localhost",
				ESA_Socket_HostPort, 22,
			End,
		  End;

	if (SocketApp)
	{
		DoMethod(ClientObj,ESM_Socket_Open);

		while(!(sigs & SIGBREAKF_CTRL_C))
		{
			socksigs = DoMethod(SocketApp,ESM_Application_GetSocketEvent, sigs);
			sigs = Wait(socksigs | SIGBREAKF_CTRL_C);
		}

	}
	}
	}

	MyDeInit();

	return 0;
}

BOOL MyInit (void)
{
	if (myclientclass = (struct IClass *)ES_MakeClass(&MyDispatcher,0,0,ESV_MakeClass_Socket))
		return TRUE;
	return FALSE;
}

void MyDeInit (void)
{
	DisposeObject(SocketApp);
	FreeClass(myclientclass);
	CloseLibrary(EasySocketBase);
}
