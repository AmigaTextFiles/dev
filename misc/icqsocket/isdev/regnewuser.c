/*

RegNewUser - Registers a new UIN.

*/

#include "icqsocket.h"
#include "icqsocket_pragmas.h"

#include <dos.h>

#include <clib/exec_protos.h>

#include <stdio.h>

struct ICQSocketBase *ICQSocketBase;

ICQHandle *ih=NULL;

struct Hook icqerror;
struct Hook icquin;
struct Hook icqloggedin;
struct Hook ackuserinfo;

BOOL stop=FALSE;	// Set to TRUE when we're done
char newpass[64];	// The Mirabilis' client is limited to 9 chars,
			// but why should we care about that?
ULONG ournewUIN=0;

char server[64];

char nick[64], first[64], last[64], email[64];

void __asm __saveds icquinfunc(register __a2 ULONG newuin)
{
	/* This function is called when the registration is completed */
	
	printf("New UIN : %ld\n", newuin);
	printf("Password: %s\n", newpass);

	ournewUIN=newuin;

	stop=TRUE;	/* That's all we need, bye! */
}

void __asm __saveds ackuserinfofunc()
{
	/* This function is called when the user info has been ack'ed */
	printf("New user info set.\n");
	stop=TRUE;
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

	printf("The error is fatal, shutting down...\n");
	stop=TRUE;
}

void __asm __saveds icqloggedinfunc(register __a2 ICQLogin *l)
{
	/* This function is called when the login procedure has completed */
	/* and this is where we send the user information for the new */
	/* account. */

	printf("Logged in with the new account!\n");

	/* Send the user info, and make sure we are notified when it is */
	/* recieved by the server. */

	is_Send(ih, &ackuserinfo, ISC_NewUserInfo, nick, first, last, email);
}

void main(int ac, char *av[])
{
	/* Set up the hook function pointers */
	icquin.h_Entry=(HOOKFUNC)icquinfunc;
	icqerror.h_Entry=(HOOKFUNC)icqerrorfunc;
	icqloggedin.h_Entry=(HOOKFUNC)icqloggedinfunc;
	ackuserinfo.h_Entry=(HOOKFUNC)ackuserinfofunc;

	ICQSocketBase=(struct ICQSocketBase *)OpenLibrary("icqsocket.library", 1);
	if(ICQSocketBase) {

		if(ac==2) {	/* An argument (any argument, but only one) will */
				/* turn on the debugging */
			is_Debug(Output(), 0);	/* Set up filehandle for debugging */
						/* Pass NULL to disable debugging */
		}

		printf("Which server do you wish to connect to? Default is icq.mirabilis.com.\n");

		printf("Server     >> "); gets(server);

		if(server[0]=='\0') strcpy(server, "icq.mirabilis.com");

		printf("Using server: \"%s\"\n", server);

		printf("Now I need some basic info to set up your new account:\n\n");

		printf("Password   >> "); gets(newpass);	/* max 9 chars */
		printf("Nickname   >> "); gets(nick);		/* max 20 chars */
		printf("First name >> "); gets(first);
		printf("Last name  >> "); gets(last);
		printf("EMail      >> "); gets(email);

		if((ih=is_InitA(0, NULL))) {
			/* Initialise icqsocket for any UIN. */
			/* UIN == 0 will not result in creating log/cfg files */
			/* and is recommended when registering new UINs. */

			is_InstallHook(ih, IID_ERROR, &icqerror);
			is_InstallHook(ih, IID_NEW_UIN, &icquin);

			if(is_RegNewUser(ih,
				ISS_Host,	server,
				ISS_Password,	newpass,
				TAG_DONE)==OK) {

				printf("*** Waiting for server to respond - Press CTRL-F to abort ***\n");
				while(!(is_NetWait(ih, SIGBREAKF_CTRL_F)&SIGBREAKF_CTRL_F) && !stop);
				is_RegNewUserCleanUp(ih);
			} else {
				printf("Can't create socket or connect, is TCP/IP running?\n");
			}

			is_Free(ih);
		} else {
			printf("Error! Could not create ICQSocket Handle\n");
		}

		stop=FALSE;

		/* Now, if the registration was successfull, you must log in */
		/* using the new UIN and password to complete the registration. */

		if(ournewUIN!=0) {
			if((ih=is_InitA(ournewUIN, NULL))) {

				is_InstallHook(ih, IID_ERROR, &icqerror);
				is_InstallHook(ih, IID_LOGIN, &icqloggedin);

				printf("Setting user info...\n");

				if(is_Connect(ih, ISS_Host, server,  ISS_Password, newpass, TAG_DONE)==OK) {
					printf("*** Waiting for server to respond - Press CTRL-F to abort ***\n");
					while(!(is_NetWait(ih, SIGBREAKF_CTRL_F)&SIGBREAKF_CTRL_F) && !stop);
					is_Disconnect(ih);
				}

				is_Free(ih);
			} else {
				printf("Error! Could not create ICQSocket Handle\n");
			}
		}

		is_Debug(NULL, 0);	// Disable debugging, in case we turned it on...

		CloseLibrary((struct Library *)ICQSocketBase);
	} else {
		printf("Error! ICQSocket.library could not be opened!\n");
	}
}
