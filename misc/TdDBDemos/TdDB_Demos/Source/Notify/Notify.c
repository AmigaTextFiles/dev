
/*  This is another small demo, this one shows how notification between
 * tasks work.  */

#include <exec/ports.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <libraries/tddbase.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/tddbase.h>
#include <stdio.h>
#include <stdlib.h>

/* This defines how many messages we will use, more messages means lower
 * risk of missing anything. */
#define MESSAGES	5

struct UpdateMsg *UpdateMsg[MESSAGES];

struct DBHandle *DBase;

/* The name of the database we will use.
 * This is changed by the Change program also included in this archive. */
char DBName[]="PROGDIR:Example.DBS";

/* This function dumps info about a node to shell. */
void ShowNodeInfo(ULONG NodeNr)
{
/* All data is stored in an array of these structures, the structure
 * contains 2 fields, one is an ID value that identifys the field and the
 * otherone is an union that contains an ULONG, STRPTR or APTR. */
struct DataStorage *Data,*List;
struct DBNode *Node;

	if(Node=TDDB_GetNode(DBase, NodeNr, MODEF_READ))
	{
		puts("Field     Dat");

		List=Node->DataList;
		Data=List++;
		while(Data->ds_ID!=NULL)
		{
			printf("0x%08x ", Data->ds_ID);

			/* These Is#? macro's check if a given ID value is of 
			 * a specefic datatype. */
			if(IsString(Data->ds_ID))
				printf("'%s'\n",Data->ds_String);
			else if(IsInt(Data->ds_ID))
				printf("0x%lx (%ld)\n",Data->ds_Nummer,Data->ds_Nummer);
			else if(IsBinary(Data->ds_ID))
				printf("Binary, size: %ld\n", *((ULONG *)Data->ds_Binary));
			else
				printf("Unknown datatype...");

			Data=List++;
		}
		TDDB_FreeNode(DBase, Node);
	}
	else
	{
		printf("Can't get node, Error=%d\n",DBase->Error);
	}
}

void main(void)
{
struct MsgPort *Port;
struct UpdateMsg *Msg;
ULONG Mask,PortMask;
BPTR lock;
int x;

	if(!(DBase=TDDB_OpenBase(DBName)))
	{
		puts("TDDB_OpenBase failed");
		exit(10);
	}

	/* And remeber that it can return a handle even if OpenBase failed. */
	if(DBase->Error)
	{
		/* Check if the file exists, if not create it. */
		if(lock=Lock(DBName, SHARED_LOCK))
		{
			/* The file exist, and therefore it was some other error.
			 * Another way to do what we just have done is to check for
			 * Err_DosErr and IoErr reports ObjectNotFound. */
			UnLock(lock);

			puts("TDDB_OpenBase failed\n");
			TDDB_CloseBase(DBase);
			exit(10);
		}
		else
		{
			/* First, we close the old base to free up its resources. */
			TDDB_CloseBase(DBase);

			/* And then we create the database. This shouldnt usualy be done
			 * from a notifyprogramm like this but it will be a good example.
			 * The arguments are Name, Fileformat, database ID and taglist. */
			DBase=TDDB_CreateBaseA(DBName, FILID_STATIC, DBID_NOID, NULL);

			if(DBase==NULL)
			{
				puts("TDDB_CreateBaseA failed\n");
				exit(10);
			}
			if(DBase->Error)
			{
				puts("TDDB_CreateBaseA failed\n");
				TDDB_CloseBase(DBase);
				exit(10);
			}
		}
	}

	if(!(Port=CreateMsgPort()))
	{
		puts("Can't create msgport.");
		TDDB_CloseBase(DBase);
		exit(10);
	}

	PortMask=1L<<Port->mp_SigBit;

	for(x=0;x!=MESSAGES;x++)
	{
		if(!(UpdateMsg[x]=AllocMem(sizeof(struct UpdateMsg), MEMF_PUBLIC)))
		{
			puts("Cant allocate updatemsg.");
			TDDB_CloseBase(DBase);
			DeleteMsgPort(Port);
			exit(10);
		}

		UpdateMsg[x]->Msg.mn_Node.ln_Type=NT_MESSAGE;
		UpdateMsg[x]->Msg.mn_ReplyPort=Port;
		UpdateMsg[x]->Msg.mn_Length=sizeof(struct UpdateMsg);

		TDDB_InstallMsg(DBase, UpdateMsg[x]);
	};

	puts("Notify is running. press CTRL-C to remove");

	for(;;)
	{
		Mask=Wait(PortMask|SIGBREAKF_CTRL_C);

		if(Mask&SIGBREAKF_CTRL_C)
		{
			for(x=0;x!=MESSAGES;x++)
			{
				TDDB_AbortMsg(DBase, UpdateMsg[x]);
				WaitPort(Port);
				Msg=(struct UpdateMsg *)GetMsg(Port);
				FreeMem(Msg, sizeof(struct UpdateMsg));
			};

			DeleteMsgPort(Port);
			TDDB_CloseBase(DBase);
			exit(0);
		}

		while(Msg=(struct UpdateMsg *)GetMsg(Port))
		{
			switch(Msg->Type)
			{
				case MSG_NEWNODE:
					puts("A new node has been created!");
					TDDB_InstallMsg(DBase, Msg);
					break;

				case MSG_DELNODE:
					printf("Node %ld has been deleted\n",Msg->NodeNr);
					TDDB_InstallMsg(DBase, Msg);
					break;

				case MSG_NODELOCK:
					printf("Node %ld is now locked\n", Msg->NodeNr);
					TDDB_InstallMsg(DBase, Msg);
					break;

				case MSG_NODEUNLOCK:
					printf("Node %ld is now longer locked\n", Msg->NodeNr);
					TDDB_InstallMsg(DBase, Msg);
					break;

				case MSG_CHANGED:
					printf("Node %ld has a (partialy) new contents:\n",Msg->NodeNr);
					ShowNodeInfo(Msg->NodeNr);
					TDDB_InstallMsg(DBase, Msg);
					break;

				case MSG_SWAP:
					printf("Node %ld and %ld has been swaped\n",Msg->NodeNr,Msg->MoreData);
					TDDB_InstallMsg(DBase, Msg);
					ShowNodeInfo(Msg->NodeNr);
					ShowNodeInfo(Msg->MoreData);
					break;

				case MSG_USER:
					printf("Got a msg of type MSG_USER. NodeNr=%ld, More=%ld\n",
													Msg->NodeNr,Msg->MoreData);
					TDDB_InstallMsg(DBase, Msg);
					break;

				case MSG_ABORTED:
					puts("Message has been aborted");
					break;

				deafult:
					printf("Unknown type=%ld, NodeNr=%ld, More=%ld\n",
									Msg->Type, Msg->NodeNr, Msg->MoreData);
					TDDB_InstallMsg(DBase, Msg);
					break;
			}
		}
	}
}