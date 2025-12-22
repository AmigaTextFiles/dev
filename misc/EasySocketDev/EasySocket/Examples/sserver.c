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
struct IClass *mysocketclass;
APTR SocketApp=NULL;
APTR	ServerObj;

LONG mNew(struct IClass *cl,Object *obj,Msg msg)
{
	ULONG host;

	if(!(obj = (Object *)DoSuperMethodA(cl,obj,msg)))
			return(0);

	GetAttr(ESA_Socket_HostName,obj,&host);

	printf("Got connection from host %s\n",host);
	return((ULONG)obj);
}

LONG mError(struct IClass *cl,Object *obj,struct ESP_Error *msg)
{
	printf("Socket error: %ld - Class error: %lx\n",msg->primaryError, msg->classError);
	return(0);
}

LONG mRead(struct IClass *cl,Object *obj,struct ESP_Read *msg)
{
	printf("New data...\n");
	printf("Got this message: ");
	printf(msg->buf);

	return(0);
}

LONG SocketDispatcher(REG(a0) struct IClass *cl,REG(a2) APTR obj,REG(a1) Msg msg)
{
	switch (msg->MethodID)
	{
		case ESM_Socket_Read			: return(mRead(cl,obj,(APTR)msg));
		case ESM_Socket_Error		: return(mError(cl,obj,(APTR)msg));
		case OM_NEW						: return(mNew(cl,obj,(APTR)msg));
	}

	return(DoSuperMethodA(cl,obj,msg));
}

/* MAIN LOOP */

int main (void)
{
	ULONG sigs = 0,socksigs;

	if (EasySocketBase = (struct Library *)OpenLibrary ("EasySocket.library",0))
	{
		if (MyInit())
	{

	SocketApp = SocketAppObject, ESA_Application_Child,
			ServerObj = ServerObject,
			 ESA_Server_SocketClassPtr, mysocketclass,
			 ESA_Socket_HostPort, 22,
			End,
	   End;

	if (SocketApp)
	{
		DoMethod(ServerObj,ESM_Socket_Open);

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
	if (mysocketclass = (struct IClass *)ES_MakeClass(&SocketDispatcher,0,0,ESV_MakeClass_Socket))
			return TRUE;
	return FALSE;
}

void MyDeInit (void)
{
	DisposeObject(SocketApp);
	FreeClass(mysocketclass);
	CloseLibrary(EasySocketBase);
}
