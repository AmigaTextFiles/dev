/* $Revision Header * Header built automatically - do not edit! *************
 *
 *	(C) Copyright 1990 by ???
 *
 *	Name .....: FancyDemo.c
 *	Created ..: Monday 07-Mar-88 18:55
 *	Revision .: 5
 *
 *	Date            Author          Comment
 *	=========       ========        ====================
 *	24-May-90       Olsen           Added new functions
 *	19-Mar-90       Olsen           Added new functions
 *	07-Jan-90       Olsen           Integrated rexxhost.library functions
 *	16-Mar-88       Bill Hawes      Added result string return
 *	07-Mar-88       Gary Samad      Created this file!
 *
 ****************************************************************************
 *
 *	FancyDemo.c - A fancy rexx host that can send and receive messages.
 *
 *	This is truly Public Domain!!
 *
 * $Revision Header ********************************************************/
 #define REVISION 5

#include <libraries/dosextens.h>
#include "rexxhostbase.h"

#ifdef AZTEC_C
#include <functions.h>
#endif	/* AZTEC_C */

#define YES	1
#define NO	0

#define OK	0
#define NOTOK	1

#define EOS	'\0'

#define NO_REXX_MSG	"Rexx is not active.  Please run 'rexxmast' from another CLI.\n"
#define STARTUP_MSG	"Type commands to rexx.  Type EOF (^\\) to end.\n"
#define CLOSING_MSG	"Ok, we're closing (after all rexx messages have returned).\n"

#define WINDOW_SPEC	"CON:0/10/600/60/Fancy Demo Input Window/c"
#define HOST_PORT_NAME	"FancyDemo"
#define REXX_EXTENSION	"rexx"

#define BUFFLEN	100

	/* Since we don't need RexxSysBase any more, we take
	 * RexxHostBase (interface library).
	 */

struct RexxHostBase	*RexxHostBase;

struct MsgPort		*dos_reply_port;
struct StandardPacket	*dos_message;
struct RexxHost		*rexx_host;
BPTR			 window_file_handle;
long			 outstanding_rexx_commands = 0;

	/******** These are dos functions for getting and displaying user input *******/

struct StandardPacket *
setup_dos_message()
{
	struct StandardPacket *malloc();
	struct StandardPacket *new_packet;

		/* get a packet */

	if(new_packet = malloc(sizeof(struct StandardPacket)))
	{
		/* required AmigaDOS Kludge */

		new_packet -> sp_Msg . mn_Node . ln_Name = (char *)&(new_packet -> sp_Pkt);
		new_packet -> sp_Pkt . dp_Link = &(new_packet -> sp_Msg);
	}

	return(new_packet);
}

void
send_read_packet(dos_message,window_file_handle,dos_reply_port,buff)
struct StandardPacket *dos_message;
BPTR window_file_handle;
struct MsgPort *dos_reply_port;
char *buff;
{
	struct FileHandle *file_handle;

		/* change a BPTR to a REAL pointer */

	file_handle = (struct FileHandle *)(window_file_handle << 2);

		/* setup the packet for reading */

	dos_message -> sp_Pkt . dp_Arg1		= file_handle -> fh_Arg1;
	dos_message -> sp_Pkt . dp_Arg2		= (long)buff;
	dos_message -> sp_Pkt . dp_Arg3		= BUFFLEN;
	dos_message -> sp_Pkt . dp_Type		= ACTION_READ;
	dos_message -> sp_Pkt . dp_Port		= dos_reply_port;
	dos_message -> sp_Msg . mn_ReplyPort	= dos_reply_port;

		/* now send it */

	PutMsg(file_handle -> fh_Type,dos_message);
}

void
close_up_shop(value)
long value;
{
	if(window_file_handle)
		Close(window_file_handle);

	if(dos_reply_port)
		DeletePort(dos_reply_port);

	if(rexx_host)
		rexx_host = DeleteRexxHost(rexx_host);

	if(dos_message)
		free(dos_message);

	if(RexxHostBase)
		CloseLibrary((struct Library *)RexxHostBase);

	exit(value);
}

void
main()
{
	long packet_out = NO;		/* whether a READ is outstanding */
	char buff[BUFFLEN+1];		/* used for reading user input */
	struct RexxMsg *rexxmessage;	/* incoming rexx messages */
	long close_down = NO;		/* set when the user hits EOF */
	STRPTR Arg;			/* Temporary string pointer */
	UBYTE ArgBuff[40];		/* Temporary argument buffer */
	LONG ArgCount;			/* Argument counter. */

		/* Try to open the rexxhost.library. */

	if(!(RexxHostBase = (struct RexxHostBase *)OpenLibrary(REXXHOSTNAME,REXXHOSTMINIMUM)))
	{
		printf("couldn't open rexxhost library.\n");
		close_up_shop(10);
	}

		/* open a window to talk to the user through */

	if(!(window_file_handle = Open(WINDOW_SPEC,MODE_OLDFILE)))
	{
		printf("sorry, couldn't open a CON: window\n");
		close_up_shop(10);
	}

		/* set up a port for dos replies */

	if(!(dos_reply_port = (struct MsgPort *)CreatePort(NULL,0)))
	{
		printf("sorry, couldn't set up a dos_reply_port\n");
		close_up_shop(10);
	}

		/* set up a public port for rexx to talk to us later */

	if(!(rexx_host = CreateRexxHost((STRPTR)HOST_PORT_NAME)))
	{
		printf("sorry, couldn't set up our public rexx port\n");
		close_up_shop(10);
	}

		/* set up a dos packet for the asynchronous read from the window */

	if(!(dos_message = setup_dos_message()))
	{
		printf("sorry, not enough memory for a dos packet\n");
		close_up_shop(10);
	}

	Write(window_file_handle,STARTUP_MSG,sizeof(STARTUP_MSG));

		/* loop until quit and no messages outstanding */

	while(!close_down || outstanding_rexx_commands)
	{
			/* if the packet (for user input) has not been sent out, send it */

		if(!packet_out && !close_down)
		{
			/* send a packet to dos asking for user keyboard input */

			send_read_packet(dos_message,window_file_handle,dos_reply_port,buff);
			packet_out = YES;
		}
       
			/* now wait for something to come from the user or from rexx */

		Wait((1 << dos_reply_port -> mp_SigBit) | HOSTMASK(rexx_host));

			/* got something!! */

			/* is it a command from the user? */

		if(GetMsg(dos_reply_port))
		{
				/* not out any more */

			packet_out = NO;

				/* if EOF (either the close gadget was hit or ^\) */

			if(dos_message -> sp_Pkt . dp_Res1 == 0)
			{
				close_down = YES;
				Write(window_file_handle,CLOSING_MSG,sizeof(CLOSING_MSG));
			}
			else
			{
					/* NULL terminate the string (thanks again DOS!) */

				buff[dos_message -> sp_Pkt . dp_Res1 - 1] = EOS;

					/* send the command directly to rexx */

				if(!SendRexxCommand(rexx_host,(STRPTR)buff,NULL,NULL))
					Write(window_file_handle,NO_REXX_MSG,sizeof(NO_REXX_MSG));
				else
					outstanding_rexx_commands++;
			}
		}

			/* did we get something from rexx? */

		while(rexxmessage = GetRexxMsg(rexx_host,FALSE))
		{
				/* Getting a string pointer means
				 * that we've received a command.
				 */

			if(Arg = GetRexxCommand(rexxmessage))
			{
				LONG CharCount = 0; /* Need counter, function reentrant. */

				printf("Got \"%s\" from Rexx.\n",Arg);

					/* Now split the command string into arguments. */

				ArgCount = 0;

				while(GetToken(Arg,&CharCount,ArgBuff,40))
					printf("Argument %ld = \"%s\"\n",ArgCount++,ArgBuff);

				if(!RexxStrCmp((STRPTR)Arg,(STRPTR)"bad"))
					ReplyRexxCommand(rexxmessage,10,0,(STRPTR)"A Test");
				else
					ReplyRexxCommand(rexxmessage,0,0,(STRPTR)"A Test");
			}
			else
			{
					/* Now, spill the args... */

				printf("The command \"%s\" has terminated with code %ld, %ld.\n",
					GetRexxArg(rexxmessage),GetRexxResult1(rexxmessage),GetRexxResult2(rexxmessage));

				FreeRexxCommand(rexxmessage);
				outstanding_rexx_commands--;
			}
		}
	}

		/* clean up */

	close_up_shop(0);
}
