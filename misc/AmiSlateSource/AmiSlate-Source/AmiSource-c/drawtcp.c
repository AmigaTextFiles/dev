#define DICE_C

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/dos.h>			/* contains RETURN_OK, RETURN_WARN #def's */
#include <dos/dosextens.h>
#include <clib/exec_protos.h>
#include <clib/netlib_protos.h>
#include <intuition/intuition.h>

#include <graphics/gfxbase.h>
#include <proto/socket.h>
#include <proto/exec.h>
#include <sys/errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/syslog.h>
#include <netdb.h>
#include <rexx/rxslib.h>
#include <rexx/storage.h>

#include <pragmas/socket_pragmas.h>
#include <inetd.h>

#include "remote.h"
#include "drawtcp.h"
#include "drawlang.h"
#include "StringRequest.h"
#include "drawrexx.h"
#include "drawrexx_aux.h"
#include "tools.h"
#include "amislate.h"

#define QUEUESAFETYMARGIN 50

/* Why does this come out as 18 unless I define it explicitely here?  Weird! */
#define EWOULDBLOCK 35

struct sockaddr_in saSocketAddress, saRSocketAddress;
struct hostent *hp;
struct servent *sp;

extern int XPos, YPos;
extern char targethost[100];
extern ULONG ulIDCMPmask;
extern BOOL BNetConnect;
extern BOOL BPalettesLocked;
extern struct Screen *Scr;
extern struct Window *DrawWindow;
extern struct RexxHost *rexxHost;
extern ULONG timerSignal;

/* These are public to other modules */
LONG lQLength;
LONG lQMaxLength;

/* private vars for this module */
static LONG   sSocket=-1;
static USHORT port;
static UBYTE  *uQ=NULL;
static LONG   lQMaxLen;    
static LONG   lQStart;
static LONG   lQEnd;

static LONG   lQTest;	/* This area of mem is getting overwritten!?  This is here to protect lQEnd */

BOOL SetAsyncMode(BOOL BAsynch)
{
	LONG lNonBlockCode = BAsynch;
	
	if (IoctlSocket(sSocket, FIONBIO, (char *)&lNonBlockCode) < 0) return(FALSE);
	return(TRUE);
}

/* Sends screen info, should be called right after the line connects */
BOOL SendScreenInfo(UWORD height, UWORD width, UBYTE depth, UWORD winheight, UWORD winwidth)
{	
	LONG lNonBlockCode = 1;
	
	if (SocketBase == NULL) return(FALSE);
	
	if (send(sSocket,(UBYTE *) &height,    sizeof(UWORD), 0L) < 0) return(FALSE);
	if (send(sSocket,(UBYTE *) &width,     sizeof(UWORD), 0L) < 0) return(FALSE);
	if (send(sSocket,(UBYTE *) &depth,     sizeof(UBYTE), 0L) < 0) return(FALSE);
	if (send(sSocket,(UBYTE *) &winheight, sizeof(UWORD), 0L) < 0) return(FALSE);
	if (send(sSocket,(UBYTE *) &winwidth,  sizeof(UWORD), 0L) < 0) return(FALSE);
	
	/* make socket non-blocking */
	return(SetAsyncMode(TRUE));
}


/* Receives info on screen size, etc. from remote machine */
/* Info:  Width  = 2 bytes(1 UWORD)  */
/*        Height = 2 bytes(1 UWORD)  */
/*        Depth  = 1 byte            */
BOOL GetRemoteScreenInfo(UWORD *height, UWORD *width, UBYTE *depth, UWORD *winheight, UWORD *winwidth)
{
	LONG lNonBlockCode = 1;
    	
	if (SocketBase == NULL) return(FALSE);
	
	if (recv(sSocket,(UBYTE *) height, sizeof(UWORD), 0L) != sizeof(UWORD)) return(FALSE);
	if (recv(sSocket,(UBYTE *) width,  sizeof(UWORD), 0L) != sizeof(UWORD)) return(FALSE);
	if (recv(sSocket,(UBYTE *) depth,  sizeof(UBYTE), 0L) != sizeof(UBYTE)) return(FALSE);
	if (recv(sSocket,(UBYTE *) winheight, sizeof(UWORD), 0L) != sizeof(UWORD)) return(FALSE);
	if (recv(sSocket,(UBYTE *) winwidth,  sizeof(UWORD), 0L) != sizeof(UWORD)) return(FALSE);

    	/* Now make socket non-blocking */
	return(SetAsyncMode(TRUE));
}


	
/* Tries to copy the name of whoever is at the other end of our
   socket into sBuffer, whose length is nBufLen.  */
void GetDrawPeerName(char *sBuffer, int nBufLen)
{
	struct sockaddr_in saTempAdd;
	LONG lLength = sizeof(struct sockaddr_in), lError;
	struct hostent *hePeer;
	
    	if (SocketBase == NULL) 
    	{
		*sBuffer = '\0';	/* Can't do much w/o AmiTCP running */
		return();
	}
	
	lError = getpeername(sSocket, &saTempAdd, &lLength);
	if (lError < 0) 
	{
		sprintf(sBuffer,"gpn err %i",errno);
		MakeReq(NULL,sBuffer,NULL);
		strncpy(sBuffer,"<Unknown>",nBufLen);	/* Return failure */
		return;
	}	
	hePeer = gethostbyaddr((caddr_t)&saTempAdd.sin_addr, sizeof(saTempAdd.sin_addr), AF_INET);
	sprintf(sBuffer,"%s",hePeer->h_name);
	return;
}	
	

	
BOOL AcceptDrawSocket(struct DaemonMessage *dm)
{ 	
	/* This function is called when we were started by inetd.  It hooks
	   us up with the calling program! */
	if (dm == NULL) return(FALSE);	
        if (SocketBase == NULL) return(FALSE);

  	SetErrnoPtr(&errno, sizeof(errno));

	sSocket = ObtainSocket((LONG)dm->dm_Id,(LONG) dm->dm_Family,(LONG) dm->dm_Type, 0L);

	if (sSocket < 0) return(FALSE);	
	
	BNetConnect = TRUE;
	return(TRUE); 	
}





int CloseDrawSocket(void)
{
	static const LONG lType = REXX_REPLY_DISCONNECT;
	
        if (SocketBase == NULL) return(FALSE);
	
	/* Out Palette is no longer locked */
	BPalettesLocked = FALSE;
	
	/* Flush the output queue */
	FlushQueue();
		
	/* Tell our peer we're outta here */
	if (BNetConnect == TRUE)
	{
		OutputAction(FROM_IDCMP, COMMAND, COMMAND_QUIT, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);

		/* Tell ARexx client we've disconnected */
		if (PState.uwRexxWaitMask & REXX_REPLY_DISCONNECT)
		{
			((struct rxd_waitevent *) *(&RexxState.array))->res.type = &lType; 
			SetStandardRexxReturns();
		}
	}
	
	if (sSocket >= 0) 
	{
		shutdown(sSocket, 2);		/* dispose of all pending data */
		CloseSocket(sSocket);
	}
	BNetConnect = FALSE;	

	SetWindowTitle("Connection closed.");			
	SetMenuValues();
	return(TRUE);
}



 
int ConnectDrawSocket(BOOL BShowRequester)
{
    int nSuccess;
	char sBuffer[100], *sTemp = sBuffer;   
	
	if (SocketBase == NULL) return(FALSE);
	
	strncpy(sBuffer,targethost,sizeof(sBuffer));	
	if ((BShowRequester == TRUE) && (GetUserString(sBuffer,"AmiSlate Connect","Enter Name of Remote Amiga",sizeof(sBuffer)) == FALSE))
	{
		SetWindowTitle("Connect cancelled.");
		return(FALSE);
	}
	
	/* If the user tries to put in a user account name, ignore it. */
	if (strchr(sBuffer,'@') != NULL)
		sTemp = strchr(sBuffer,'@')+1;

	strncpy(targethost, sTemp, sizeof(targethost));
	LowerCase(targethost);

	sprintf(sBuffer,"Connecting to %s",targethost);
	SetWindowTitle(sBuffer);
			
    	SetErrnoPtr(&errno, sizeof(errno));
	
	sp = getservbyname("AmiSlate","tcp");
	if (sp == NULL) sp = getservbyname("Amislate","tcp");	/* Try almost all lowercase then! */	
	if (sp == NULL) sp = getservbyname("amislate","tcp");	/* Try all lowercase then! */	
	if (sp == NULL)
	{
		MakeReq(NULL,"Couldn't find Service entry in inetd.conf!","Better Add it");
		SetWindowTitle("Connection Failed/Refused");
		return(FALSE);
	}
	port = sp->s_port;
				
	hp = gethostbyname(targethost);
	if (hp == NULL)
	{
		SetWindowTitle("Connection Failed/Refused");
		return(FALSE);
	}
	
	bzero(&saSocketAddress, sizeof(saSocketAddress));
    	bcopy(hp->h_addr, (char *)&saSocketAddress.sin_addr, hp->h_length);
	saSocketAddress.sin_family = hp->h_addrtype;
	saSocketAddress.sin_port   = htons(port);	
	
	sSocket = socket(hp->h_addrtype,SOCK_STREAM,0);
	if (sSocket < 0)
	{
		Printf("Couldn't get a socket, errno=[%i] s=[%i]\n",errno,sSocket);
		SetWindowTitle("Connection Failed/Refused");
		return(FALSE);
	}
	nSuccess = connect(sSocket, (struct sockaddr *) &saSocketAddress, sizeof(saSocketAddress));
	if (nSuccess < 0)
	{
		MakeReq(NULL,"Unable to connect to remote machine",NULL);
		CloseSocket(sSocket);
		SetWindowTitle("Connection Failed/Refused");
		return(FALSE);
	}
		
	/* Send info on our screen! */
	if (SendScreenInfo((UWORD) Scr->Height, (UWORD) Scr->Width, (UBYTE)Scr->RastPort.BitMap->Depth, 
					   (UWORD) DrawWindow->Height, (UWORD) DrawWindow->Width) == FALSE)
	{
		CloseSocket(sSocket);
		SetWindowTitle("Connection Failed/Refused");		
		Printf("SendScreenInfo failed!\n");
		return(FALSE);
	}

	BNetConnect = TRUE;
	
	/* Get info about his screen */
	OutputAction(FROM_IDCMP, COMMAND, COMMAND_SYNCH, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
	SetMenuValues();
	return(TRUE);
}


/* This function sends the given string over the link */
BOOL SendString(char *sString, int nLen)
{
	if (SocketBase == NULL) return(FALSE);
	
	/* If there is still stuff in the queue to be sent, add this to the queue 
	   and try to send some of that stuff instead */
	if (lQLength > 0)
	{
		AddToQueue(sString,nLen);
		return(ReduceQueue());
	}
	else if (send(sSocket,sString,nLen,0L) == -1)
	{
		/* Queue the bytes! */
		return(AddToQueue(sString,nLen));
	}
	return(TRUE);
}



/* Allocates the Queue with size lQMaxLen -- returns TRUE if
   successful, else FALSE */
BOOL AllocQueue(LONG lQMaxChars)
{
	if (uQ != NULL) return(FALSE);
	
	uQ = AllocMem(lQMaxChars, MEMF_PUBLIC|MEMF_ANY);
	if (uQ == NULL) return(FALSE);

	lQMaxLength  = lQMaxChars; /* (Max length, in bytes)		*/	
	FlushQueue();
	return(TRUE);
}


void FlushQueue(void)
{
	/* Set defaults for an empty Queue */
	lQLength     = 0L;  	   /* (Current length, in bytes) */
	lQStart      = 0L;          /* (array index, in bytes)		*/
	lQEnd        = 0L;          /* (array index, in bytes)		*/
	return;
}


BOOL FreeQueue(void)
{
	if (uQ == NULL) return(FALSE);
	FreeMem(uQ, lQMaxLength);
	uQ = NULL;
	return(TRUE);
}



/* Puts the string at the end of the queue for later transmission */
BOOL AddToQueue(char *sString, LONG lLen)
{
	UBYTE * puTemp, * puEnd;
	LONG lCount;

	if ((lQLength + lLen) > lQMaxLength) return(FALSE);  /* can't do it; buffer full */

	puTemp = &uQ[lQEnd];	  						/* start at first free spot in array */	
	puEnd  = uQ;	
	puEnd += ((UBYTE *) lQMaxLength);      /* first location after end of array */

	for (lCount=0; lCount < lLen; lCount++)
	{
		*puTemp = sString[lCount];
		puTemp++;
		if (puTemp >= puEnd) puTemp = uQ;		
	}

	lQEnd = (LONG)puTemp-(LONG)uQ;		/* translated back into array index */	
	lQLength += lLen;

	if (lQLength > (lQMaxLength-QUEUESAFETYMARGIN)) 
	{
		/* Queue almost full--Set AmiTCP to wait next time, until
		   we have reduced it some. */
		SetWindowTitle("Output buffer full:  Synchronous mode activated.");
		SetAsyncMode(FALSE);
	}	   
	return(TRUE);
}
	
	
	
	
/* Tries to send out Queue--returns TRUE if some of Queue sent, FALSE if
	   none was sent */	
BOOL ReduceQueue(void)
{
	int nSuccess, nLen;
	const LONG lMaxPacketSize = 20;	/* Max # of bytes to try to send at once */
	BOOL BInAsync = FALSE;
	
	if (lQLength == 0) return(FALSE);
	if (lQLength > (lQMaxLength-QUEUESAFETYMARGIN))	BInAsync = TRUE;
	
	/* Start at beginning of list */
	nLen = lMaxPacketSize; 			/* default */
	if ((lQStart + nLen) > lQMaxLength)
	{
		/* would go off end of array; shorten packet! */
		nLen = lQMaxLength - lQStart;
	}
	
	/* Don't want to send more than we have! */
	if (nLen > lQLength) nLen = lQLength;
	
	nSuccess = send(sSocket,&uQ[lQStart],nLen,0L);
	if (nSuccess == -1) return(FALSE);
	
	/* bytes sent--update beginning of Queue */
	lQStart += nLen;
	if (lQStart > lQMaxLength) Printf("555:Warning!\n");
	if (lQStart >= lQMaxLength) lQStart = 0;
	lQLength -= nLen;
	if (lQLength < 0) MakeReq("AmiSlate Error","Queue length is negative!","I'll tell Jeremy");
	
	/* If we were able to reduce the queue, go back to asynchronous mode */
	if (BInAsync == TRUE) 
	{
		SetAsyncMode(TRUE);
		SetWindowTitle("Resuming asynchronous transmission.");
	}
	return(TRUE);
}




/* This function sends the given char over the link */
BOOL SendChar(char cChar)
{
	char sShortString[] = "\0\0";
	
	sShortString[0] = cChar;
	
	if (send(sSocket,sShortString,1,0L) != 1) return(FALSE);
	
	return(TRUE);
}
		

/* Returns Bytes read on success (can be 0), or -errno on error */
int Receive(char *sBuffer, int nBufLength)
{
	int nBytesReceived;
	
	if (SocketBase == NULL) return(FALSE);
	
	/* Clean out buffer, sorta */
	*sBuffer = '\0';

	nBytesReceived = recv(sSocket,sBuffer,nBufLength, 0L);
		
	if (nBytesReceived == -1) 
	{
		if (errno == EWOULDBLOCK) return(0);
		return(-abs(errno));
	}
	else
	return(nBytesReceived);
}


UBYTE DrawWait(void)
{
	static struct fd_set fsReadSet, fsWriteSet;
	ULONG signals, tmask = ulIDCMPmask;
	UBYTE bRet = 0;
	
	FD_ZERO(&fsReadSet);  			/* Initialize socket read set */
	FD_SET(sSocket, &fsReadSet);		/* Set it to our port--stop waiting when there's something to read */
	FD_ZERO(&fsWriteSet);			/* Initialize socket write set */
	FD_SET(sSocket, &fsWriteSet);		/* Set it to same */

	/* Only break the WaitSelect() on a socket_write_ready if there are things
	   in the Queue that are ready to go! */
	if (BNetConnect == FALSE)
	{
		signals = Wait(tmask);		/* wait for IDCMP, CTRL-C, Timer */
		if (signals & SIGBREAKF_CTRL_C) CleanExit(0);	/* go bye bye on ctrl-c */
		if (signals & 1L<<(DrawWindow->UserPort->mp_SigBit)) bRet |= IDCMP_READY;
		if ((rexxHost != NULL)&&(signals & 1L<<rexxHost->port->mp_SigBit)) bRet |= AREXX_READY;
		if (signals & timerSignal) RexxTimeOut();			
	}
	else
	{	/* wait for IDCMP, CTRL-C, Timer, Connection stuff */
		if (lQLength > 0) WaitSelect(1, &fsReadSet, &fsWriteSet, NULL, NULL, &tmask);		
  		             else WaitSelect(1, &fsReadSet, NULL,        NULL, NULL, &tmask);
		if (FD_ISSET(sSocket, &fsReadSet))  bRet |= READ_READY;
		if (FD_ISSET(sSocket, &fsWriteSet)) bRet |= WRITE_READY;
		if (tmask & SIGBREAKF_CTRL_C) CleanExit(0);	/* go bye bye on ctrl-c */
		if (tmask & (1L<<(DrawWindow->UserPort->mp_SigBit))) bRet |= IDCMP_READY;
		if ((rexxHost != NULL)&&(tmask & (1L<<(rexxHost->port->mp_SigBit)))) bRet |= AREXX_READY;
		if (tmask & timerSignal) RexxTimeOut();
	}	
	return(bRet);
}



void RexxTimeOut(void)
{
	static const lType = REXX_REPLY_TIMEOUT;
	static LONG ltimeX, ltimeY;
	int ndownX, ndownY;
	
	if (PState.uwRexxWaitMask & REXX_REPLY_TIMEOUT)
	{
	    ndownX = XPos;
	    ndownY = YPos;
	    FixPos(&ndownX, &ndownY);
	    UnFixCoords(&ndownX, &ndownY);	/* translates coordinates back into 0,0 offset */
	    
	    ltimeX = ndownX;
	    ltimeY = ndownY;
	    
   	    ((struct rxd_waitevent *) *(&RexxState.array))->res.x = &ltimeX;
   	    ((struct rxd_waitevent *) *(&RexxState.array))->res.y = &ltimeY;	    
   	    ((struct rxd_waitevent *) *(&RexxState.array))->res.type = &lType;
	    SetStandardRexxReturns();
	}
	return;
}


