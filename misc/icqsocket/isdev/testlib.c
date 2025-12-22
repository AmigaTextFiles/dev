/*

Test app for icqsocket.library 0.03

Don't use anything that isn't used in here, although the things
you find in icqsocket.h work, they may not work in the same way
in the future.

If there's anything I've forgotten or that seems strange, please
tell me about it now. It probably will be much harder to fix it
later.

The goal of this library is to squeeze everything but the GUI
into it, so if it lacks some important feature, I'll put it in
there. (just let me know)

Before you get started I suggest you get familiar with the
original ICQ client from Mirabilis (www.mirabilis.com).

Also check out the (unofficial) protocol specs:

http://www.algonet.se/~henisak/icq/icqv5.html


BTW, read the comments carefully, there might be some important
information there.

Good luck.

digitaliz <hki@hem1.passagen.se>

UIN: 11214923

*/

#include "icqsocket.h"
#include "icqsocket_pragmas.h"

#include <dos.h>

#include <clib/exec_protos.h>

#include <stdio.h>

struct ICQSocketBase *ICQSocketBase;

ICQHandle *ih=NULL;

struct Hook icqerror;
struct Hook icqloggedin;
struct Hook icqstatus;
struct Hook icqmsg;
struct Hook icqtimer;
struct Hook messhook;

void __asm __saveds icqstatusfunc(register __a2 ICQStatusUpdate *s)
{
	/* This function is to be called when a user changes his/her */
	/* online status */

	printf("%ld changed status to %08lx\n", s->UIN, s->Status);
	if(s->Type==SUT_ONLINE) {
		printf(" IP:     %08lx\n", s->IP);
		printf(" RealIP: %08lx\n", s->RealIP);
		printf(" Port:   %ld\n", s->Port);
		printf(" TCPVer: %08lx\n", s->TCP);
		printf(" DC:     %02x\n", s->Direct);
		/* Note, this info is also stored in the user database */
		/* for later retrieval. */
	}
}

void __asm __saveds icqmsgfunc(register __a2 ICQMessage *m)
{
	/* This function is called when a new message has been */
	/* added to the message queue, or while connecting to */
	/* the server, if old, unread, messages are left in the */
	/* queue. If so, the last added message is passed to this */
	/* function. */

	/* To fetch queued messages, mark them as 'read', and */
	/* move them to the message log, use the MsgQueue functions. */
	/* see below, in ShowMsgQueue */

	printf("\n\n*** Recieved a message ***\n");
	printf("  UIN: %ld\n", m->UIN);
	printf(" Type: %ld\n", m->Type);
	if(m->Instant) {
		printf(" Time: Instantly delivered\n");
	} else {
		printf(" Time: %ld/%ld %ld kl. %ld:%ld\n", m->Time.Day, m->Time.Month, m->Time.Year, m->Time.Hour, m->Time.Minute);
	}
	printf(" Text: %s\n", m->Msg);
}

void __asm __saveds icqmessfunc(register __a2 ULONG userdata)
{
	printf("A message to %ld has been delivered.");
}

void __asm __saveds icqloggedinfunc(register __a2 ICQLogin *l)
{
	/* This function is called when the login procedure has completed */

	printf("Logged in!\n");

	/* Send a test message */
	//is_Send(ih, &messhook, ISC_TextMessage, 1214923, "Test!");
	/* messhook gets called when the message has been acknowledged */
	/* by the server. You could, for example, keep the send message */
	/* window open until it is called. (the way the Mirabilis client */
	/* does it) By passing the window pointer in the h_Data field */
	/* of the hook struct, you can manage several send-message- */
	/* windows at once. MUI makes this simple via the addmember */
	/* method. */

	/* Change our online status */
	is_Send(ih, NULL, ISC_NewStatus, 0);
	/* You can pass a hook here too, which is called when your new */
	/* status has been acknowledged by the server. */

	/*is_Send(ih, NULL, ISC_RandSearch, GRP_GENERAL);*/
}

void __asm __saveds icqerrorfunc(register __a2 ICQError *e)
{
	/* This is called when an error occurs */

	if(e->SokErr) {
		printf("Socket error: %ld\n", e->SokErr);
	}
	if(e->ICQErr) {
		printf("ICQSocket error: %ld\n", e->ICQErr);
	}
	if(e->Hdr) {
		printf(" Ver: %04x\n", e->Hdr->Version);
		printf(" Cmd: %04x\n", e->Hdr->Command);
		printf(" UIN: %ld\n", e->Hdr->UIN);
		printf(" Seq: %08x\n", e->Hdr->Seq);
		printf(" SID: %08x\n", e->Hdr->SID);
	}
}

void __asm __saveds icqtimerfunc(void)
{
	/* This is called every half second */

	/*printf("timer\n");*/
}

void ListLog(ICQHandle *ih)
{
	ICQMessage *im;

	printf("--- MESSAGE LOG ---\n");
	if(is_OpenMsgLog(ih)) {
		do {
			im=is_GetLoggedMsg(ih, 0);
			if(im) {
				printf("---\nFrom: %ld\nType: %ld\nText: %s\n", im->UIN, im->Type, im->Msg);
			}
		} while(im);
		is_CloseMsgLog(ih);
	}
	printf("--- END OF MESSAGE LOG ---\n");
}

void ShowMsgQueue(ICQHandle *ih)
{
	ICQMessage *im;

	/* Note! When you get a message from the queue, it's no */
	/* longer there. (it has been removed from the list and is */
	/* only stored in the log) */

	printf("--- QUEUED MESSAGES ---\n");
	if(is_OpenMsgQueue(ih)) {
		do {
			im=is_GetQueuedMsg(ih, 0);
				/* Setting the 0 to a positive integer will  (an UIN) */
				/* filter out all messages coming from other users. */
				/* (and only get messages from the right user) */
			if(im) {
				printf("---\nFrom: %ld\nType: %ld\nText: %s\n", im->UIN, im->Type, im->Msg);
			}
		} while(im);
		is_CloseMsgQueue(ih);
	}
	printf("--- END OF QUEUED MESSAGES ---\n");
}

void ListContacts(ICQHandle *ih)
{
	ICQUser *iu;

	/* List all users in the DB_CONTACTS database. */
	/* Other databases are: */
	/*	DB_UNKNOWN  - users not on the contact list that have */
	/*		      sent messages to you */
	/*	DB_RANDOM   - "random search" users */
	/*	DB_CONTACTS - your contact list */

	/* NOTE 1: Theese things will be automatically saved and loaded */
	/*         from disk in the near future. */
	/* NOTE 2: Also planned is a system to add user specific records */
	/*         to the database entries. (the users) */

	printf("--- CONTACT LIST ---\n");
	if(is_OpenDatabase(ih, DB_CONTACTS)) {
		do {
			iu=is_GetEntry(ih, DB_CONTACTS);
			if(iu) {
				printf("UIN: %ld, Nick: %s\n", iu->UIN, iu->Nick);
			}
		} while(iu);
		is_CloseDatabase(ih, DB_CONTACTS);
	}
	printf("--- END OF CONTACT LIST ---\n");
}

void main(int ac, char *av[])
{

	/* Set up the hook function pointers */
	icqstatus.h_Entry=(HOOKFUNC)icqstatusfunc;
	icqloggedin.h_Entry=(HOOKFUNC)icqloggedinfunc;
	icqerror.h_Entry=(HOOKFUNC)icqerrorfunc;
	icqmsg.h_Entry=(HOOKFUNC)icqmsgfunc;
	icqtimer.h_Entry=(HOOKFUNC)icqtimerfunc;
	messhook.h_Entry=(HOOKFUNC)icqmessfunc;

	ICQSocketBase=(struct ICQSocketBase *)OpenLibrary("icqsocket.library", 1);
	if(ICQSocketBase) {
		is_Debug(Output(), 0);	/* Set up filehandle for debugging */
					/* Pass NULL to disable debugging */

		if((ih=is_InitA(13951811, NULL))) {
			/* Initialise icqsocket for my test-UIN. */
			/* (this loads config and log from S:) */
			/* The NULL is for optional tags. (not implemented) */

			is_InstallHook(ih, IID_ERROR, &icqerror);
			is_InstallHook(ih, IID_LOGIN, &icqloggedin);
			is_InstallHook(ih, IID_STATUS, &icqstatus);
			is_InstallHook(ih, IID_MESSAGE, &icqmsg);
			is_InstallHook(ih, IID_TIMER_EVENT, &icqtimer);

			ListLog(ih);
			ShowMsgQueue(ih);

			is_AddUINQ(ih, 11214923);	/* Adds an UIN quickly to the contact list */
							/* (ie. without looking up the users nickname etc.) */
							/* currently this the only supported method */

			ListContacts(ih);
			

			/* NOTE: The library will maintain list of servers in */
			/* future versions, but ISS_Host will override this. */
			/* For now, however, it is required, or the lib will */
			/* try to connect to localhost. */

			if(is_Connect(ih, ISS_Host, "icq.mirabilis.com",  ISS_Password, "pass", TAG_DONE)==OK) {
				printf("*** Press CTRL-F to quit ***\n");
				while(!(is_NetWait(ih, SIGBREAKF_CTRL_F)&SIGBREAKF_CTRL_F));
				is_Disconnect(ih);
			}

			is_Free(ih);
		}

		is_Debug(NULL, 0);	/* Disable debugging output */

		CloseLibrary((struct Library *)ICQSocketBase);
	}
}
