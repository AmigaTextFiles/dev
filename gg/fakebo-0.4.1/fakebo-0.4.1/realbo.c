
#include "global.h"
#include "bo.h"
#include "misc.h"


#define ERROR_3   "Error 3:The system cannot find the path specified"


extern byte whatbocommand(byte t);

/* In order to properly confuse the connected client, we
   need some ways of storing what they have done */

struct _List {
	char *Str1;
	char *Str2;
	int *Int1;
	int *Int2;
};

/* The app list they have started, 
   Arg1 is appname
   Port is the port */
#define MAXAPPS 10
struct _List AppList[MAXAPPS];
int AppListCount = 0;

/* The TCP redirections
   Arg1 is the dest IP[:port]
   Port is the local port */
#define MAXREDIRS 10
struct _List RedirList[MAXREDIRS];
int RedirListCount = 0;

/* HTTP Server port */
int HTTPServerPort;


/* FUNCTION: Checks if a filename is valid
   ARGS: the filename
   RETURNS: 1 if valid, 0 if not
 */
int fname_valid(char *fname)
{
	int i, ret;

	ret = 1;
	for (i = 0; i < strlen(fname); i++) {
		if (!isprint((int) fname[i]) || fname[i] == '*' || fname[i] == '?' ||
		    fname[i] == '/' || fname[i] == ';') {
			ret = 0;
		}
	}
	return (ret);
}


/* FUNCTION: Adds the data to the first avail slot in the list 
   ARGS: Pointer to list, elems in list, string data 1 and 2, intdata 1 and 2
   RETURNS: offset added, or -1 if it couldn't be added  
   COMMENTS: any input var that is null is ignored */
int List_Add(struct _List *List, int ListCount, char *Str1, char *Str2, int *Int1, int *Int2)
{
	int x;
	/* Find the first free app slot */
	for (x = 0; x < ListCount; x++) {
		if (List[x].Str1 == NULL) {
			/* Add this app */
			List[x].Str1 = malloc(strlen(Str1));
			if (List[x].Str1 == NULL)
				return (-1);
			strcpy(List[x].Str1, Str1);
			if (Str2) {
				List[x].Str2 = malloc(strlen(Str2));
				if (List[x].Str2 == NULL)
					return (-1);
				strcpy(List[x].Str2, Str2);
			}
			if (Int1) {
				List[x].Int1 = malloc(sizeof(int));
				if (List[x].Int1 == NULL)
					return (-1);
				*List[x].Int1 = *Int1;
			}
			if (Int2) {
				List[x].Int2 = malloc(sizeof(int));
				if (List[x].Int2 == NULL)
					return (-1);
				*List[x].Int2 = *Int2;
			}
			return x;
		}
	}
	return -1;
}
/* FUNCTION: Adds the data to the first avail slot in the list 
   ARGS: Pointer to list, elems in list, string data 1 and 2, intdata 1 and 2
   RETURNS: offset of deleted entry, or -1 if it couldn't be found *
   COMMENTS: any input var that is null is ignored */
int List_Del(struct _List *List, int ListCount, int *Offset, char *Str1, char *Str2, int *Int1, int *Int2)
{
	int x;
	char Match;
	for (x = 0; x < ListCount; x++) {
		Match = 1;
		if (Offset)
			if (*Offset != x)
				Match = 0;
		if (Str1)
			if (strcmp(Str1, List[x].Str1) != 0)
				Match = 0;
		if (Str2)
			if (strcmp(Str2, List[x].Str2) != 0)
				Match = 0;
		if (Int1)
			if (*Int1 != *List[x].Int1)
				Match = 0;
		if (Int2)
			if (*Int2 != *List[x].Int2)
				Match = 0;
		if (Match == 1) {
			/* Clear it out */
			if (List[x].Str1)
				free(List[x].Str1);
			if (List[x].Str2)
				free(List[x].Str2);
			if (List[x].Int1)
				free(List[x].Int1);
			if (List[x].Int2)
				free(List[x].Int2);
			memset(&List[x], 0, sizeof(struct _List));
			return x;
		}
	}
	return -1;
}

/* FUNCTION: Inits the fake server data 
   ARGS: None
   RETURNS: void
   COMMENTS: none */
void RealBOInit(void)
{
	memset(AppList, 0, sizeof(struct _List) * MAXAPPS);
	memset(RedirList, 0, sizeof(struct _List) * MAXREDIRS);
	HTTPServerPort = -1;
}

/* 01 - Ping */
void RealBO_01(char *msg, char *Arg1, char *Arg2)
{
	sprintf(msg, "  !PONG!%s!%s!", bofakever, machinename);
}

/* 02 - System Reboot */
void RealBO_02(char *msg, char *Arg1, char *Arg2)
{
	sprintf(msg, "OK, Rebooting system...");
}

/* 03 - System Lock Up */
void RealBO_03(char *msg, char *Arg1, char *Arg2)
{
	sprintf(msg, "OK, Locking system...");
}

/* 04 - List System Passwords */
void RealBO_04(char *msg, char *Arg1, char *Arg2)
{
	msg += sprintf(msg, "Password cached by system:\n");
	msg += sprintf(msg, "index:00(06) len:21(22/79)\n");
	msg += sprintf(msg, "Resource: 'Administrator' Password: 'AdmIn321'\n");
	msg += sprintf(msg, "index:01(06) len:32(22/79)\n");
	msg += sprintf(msg, "Resource: '*Rna\\Microsoft\\billjohnnyboy' Password: '7dsFo4ve'\n");
	msg += sprintf(msg, "End of cached passwords.\n");
	msg += sprintf(msg, "Unable to read value 'ScreenSave_Data'");
}

/* 05 - View Console */
void RealBO_06(char *msg, char *Arg1, char *Arg2)
{
	msg += sprintf(msg, "System info for machine '%s'\n", machinename);
	msg += sprintf(msg, "Curent user: 'Administrator'\n");
	msg += sprintf(msg, "Processor: I686\n");
	msg += sprintf(msg, "Win32 on Windows 95 v4.0 build 1111 -  B\n");
	msg += sprintf(msg, "Memory: 59M in use: 20%%  Page file: 0M free: 0M\n");
	msg += sprintf(msg, "C:\\ - Fixed Sec/Clust: 64 Byts/Sec: 512,  Bytes free: 347265528/10933795840\n");
	msg += sprintf(msg, "D:\\ - CD-ROM\n");
	msg += sprintf(msg, "E:\\ - Removeable Optical Media\n");
	msg += sprintf(msg, "Q:\\ - Remote\n");
	msg += sprintf(msg, "R:\\ - Remote\n");
	msg += sprintf(msg, "End of system info");
}

/* 07 - Log Pressed Keys */
void RealBO_07(char *msg, char *Arg1, char *Arg2)
{
	sprintf(msg, "Logging keys");
}


/* 08 - Send KeyPress Log */
void RealBO_08(char *msg, char *Arg1, char *Arg2)
{
	sprintf(msg, "Logging ended");
}

/*
   09 - Show A Dialog Box
 */
void RealBO_09(char *msg, char *Arg1, char *Arg2)
{
	sprintf(msg, "Dialog box displayed.");
}


/*
   0A - Delete A Value from The Registry */

/* 0B - Create TCP redirection(proxy) */
void RealBO_0B(char *msg, char *Arg1, char *Arg2)
{
	int port, x;

	x = sscanf(Arg1, "%d", &port);
	if (!Arg1 || !Arg2) {
		sprintf(msg, "Must supply a port and dest IP");
		return;
	}
	if (Arg1[0] == 0 || Arg2[0] == 0 || x == 0 || x < 0)
		sprintf(msg, "Must supply a port and dest IP");
	else {
		x = List_Add(&RedirList[0], MAXREDIRS, Arg2, NULL, &port, NULL);
		if (x == -1)
			sprintf(msg, "Too many redirs");
		else {
			sprintf(msg, "Redir %d is directing port %d to %s", x, port, Arg2);
			RedirListCount++;
		}
	}
}


/* 0C - Delete TCP redirection */
void RealBO_0C(char *msg, char *Arg1, char *Arg2)
{
	int x = 0;
	if (!sscanf(Arg1, "%d", &x))
		msg += sprintf(msg, "Must spefify a redir ID");
	else if (x >= MAXREDIRS || x < 0 || !RedirList[x].Str1)
		msg += sprintf(msg, "Redir %d not enabled", x);
	else {
		List_Del(&RedirList[0], MAXREDIRS, &x, NULL, NULL, NULL, NULL);
		msg += sprintf(msg, "Redir %d disabled", x);
		RedirListCount--;
	}
}


/* 0D - List TCP redirections */
void RealBO_0D(char *msg, char *Arg1, char *Arg2)
{
	int x = 0;
	msg += sprintf(msg, "Redirected ports:\n");
	for (x = 0; x < MAXREDIRS; x++) {
		if (RedirList[x].Str1)
			msg += sprintf(msg, "%d:port %d:TCP->%s\n", x, *RedirList[x].Int1, RedirList[x].Str1);
	}
	msg += sprintf(msg, "%d redirs displayed", RedirListCount);
}


/* 0E - Start Application */
void RealBO_0E(char *msg, char *Arg1, char *Arg2)
{
	int port, x;
	if (!Arg1 || !Arg2) {
		sprintf(msg, "Must supply a port and dest IP");
		return;
	}
	x = sscanf(Arg2, "%d", &port);
	if (Arg1[0] == 0 || Arg2[0] == 0 || x == 0)
		sprintf(msg, "Must supply app name and port");
	else {
		x = List_Add(&AppList[0], MAXAPPS, Arg1, NULL, &port, NULL);
		if (x == -1)
			sprintf(msg, "Too Many apps running");
		else {
			sprintf(msg, "App %d:'%s' spawned on port %d", x, Arg1, port);
			AppListCount++;
		}
	}
}


/* 0F - End Application */
void RealBO_0F(char *msg, char *Arg1, char *Arg2)
{
	int x = 0;
	if (!sscanf(Arg1, "%d", &x))
		msg += sprintf(msg, "Must spefify an app ID");
	else if (x >= MAXAPPS || x < 0 || !AppList[x].Str1)
		msg += sprintf(msg, "App (null) not running");
	else {
		List_Del(&AppList[0], MAXAPPS, &x, NULL, NULL, NULL, NULL);
		msg += sprintf(msg, "App %d deactivated", x);
		AppListCount--;
	}
}


/*
   10 - Export a share resource
   11 - Cancel share export
   12 - Show Export List
   13 - Resend Packet
 */


/* 14 - Enable HTTP Server */
void RealBO_14(char *msg, char *Arg1, char *Arg)
{
	int x;
	if (HTTPServerPort != -1) {
		msg += sprintf(msg, "HTTP server already active on port %d", HTTPServerPort);
		return;
	}
	if (!sscanf(Arg1, "%d", &x))
		msg += sprintf(msg, "Must supply port");
	else {
		HTTPServerPort = x;
		msg += sprintf(msg, "HTTP server listening on port %d", x);
	}
}


/* 15 - Disable HTTP Server */
void RealBO_15(char *msg, char *Arg1, char *Arg2)
{
	if (HTTPServerPort == -1)
		msg += sprintf(msg, "Server not active");
	else
		msg += sprintf(msg, "Server disabled");
}


/* 16 - Resolve Host Name */
void RealBO_16(char *msg, char *Arg1, char *Arg2)
{
	if (!Arg1) {
		sprintf(msg, "Must supply host name");
		return;
	}
	if (Arg1[0] == 0)
		msg += sprintf(msg, "Must supply host name");
	else
		msg += sprintf(msg, "%d.%d.%d.%d", rand() % 255, rand() % 255, rand() % 255, rand() % 255);
}


/*17 - Compress a File
   18 - Uncompress a File */


/* 19 - Plug-in execute */
void RealBO_19(char *msg, char *Arg1, char *Arg2)
{
	msg += sprintf(msg, "Error 1157:One of the library file needed to run this application cannot be found loading dll");
}


/*
   1A - 0x1a???
   1B - 0x1b???
   1C - 0x1c???
   1D - 0x1d???
   1E - 0x1e???
   1F - 0x1f???
   20 - Show active processes
   21 - Kill a process
   22 - Start a process
   23 - Create a key in the registry
   24 - Set the Value of a key in registry
   25 - Delete a key in registry
   26 - Enumerate registry keys
   27 - Enumerate registry values
   28 - Capture a static image
   29 - Capture a video stream
   2A - Play a sound file
   2B - Show Available Video capture devices
   2C - Capture the screen to a file
   2D - Start sending a file using TCP
   2E - Start recieving a file using TCP */


/* 2F - List (running) plug-ins */
void RealBO_2F(char *msg, char *Arg1, char *Arg2)
{
	msg += sprintf(msg, "Plugins:\n");
	msg += sprintf(msg, "End of plugins");
}


/* 30 - Kill Plugin */
void RealBO_30(char *msg, char *Arg1, char *Arg2)
{
	int x;
	if (!sscanf(Arg1, "%d", &x))
		msg += sprintf(msg, "Must spefify a plugin ID");
	else
		msg += sprintf(msg, "Plugin %d not active", x);
}


/*31 - List directory
   32 - 0x32???
   33 - 0x33???
   34 - Find a file
   35 - Delete a file */


/* 36 - View file contents */
void RealBO_36(char *msg, char *Arg1, char *Arg2)
{
	if (fname_valid(Arg1)) {
		msg += sprintf(msg, "Contents of %s (%d bytes):\n", Arg1, rand() / 1000);
		msg += sprintf(msg, "!ERROR\n");
		msg += sprintf(msg, " - End of file -");
	} else
		sprintf(msg, "%s creating directory %s", ERROR_3, Arg1);
}


/* 37 - Rename a file */
void RealBO_37(char *msg, char *Arg1, char *Arg2)
{
	/* Well... as much as I've figured, the server ALWAYS returns an error,
	 * even if it renames the file.
	 */
	sprintf(msg, "%s copying file %s to %s", ERROR_3, Arg1, Arg2);
}


/* 38 Copy a file */
void RealBO_38(char *msg, char *Arg1, char *Arg2)
{
	if (fname_valid(Arg1))
		sprintf(msg, "File '%s' successfully coppied to '%s'", Arg1, Arg2);
	else
		sprintf(msg, "%s copying file %s to %s", ERROR_3, Arg1, Arg2);
}


/*
   39 - List all network devices
   3A - Connect to network resource
   3B - End connection of a network resource
   3C - Show NetWork Connections
   3D - Create Directory (folder)
   3E - Remove directory
 */


/* 3F - Show Running Applications */
void RealBO_3F(char *msg, char *Arg1, char *Arg2)
{
	int x = 0;
	msg += sprintf(msg, "Active apps:\n");
	for (x = 0; x < MAXAPPS; x++) {
		if (AppList[x].Str1)
			msg += sprintf(msg, "%d:'%s' on port %d\n", x, AppList[x].Str1, *AppList[x].Int1);
	}
	msg += sprintf(msg, "%d apps listed", AppListCount);
}


void (*RealBO_Function[MAXNUMCOMMANDS]) (char *msg, char *Arg1, char *Arg2) = {
	NULL, &RealBO_01, &RealBO_02, &RealBO_03,
	    &RealBO_04, NULL, &RealBO_06, &RealBO_07,
	    &RealBO_08, &RealBO_09, NULL, &RealBO_0B,
	    &RealBO_0C, &RealBO_0D, &RealBO_0E, &RealBO_0F,
	    NULL, NULL, NULL, NULL,
	    &RealBO_14, &RealBO_15, &RealBO_16, NULL,
	    NULL, &RealBO_19, NULL, NULL,
	    NULL, NULL, NULL, NULL,
	    NULL, NULL, NULL, NULL,
	    NULL, NULL, NULL, NULL,
	    NULL, NULL, NULL, NULL,
	    NULL, NULL, NULL, &RealBO_2F,
	    &RealBO_30, NULL, NULL, NULL,
	    NULL, NULL, &RealBO_36, &RealBO_37, &RealBO_38,
	    NULL, NULL, NULL, NULL,
	    NULL, NULL, &RealBO_3F
};

/* Returns 1 if we were able to formulate a response, 0 otherwise */
int RealFakeBO(char *msg, bopacket * bo)
{
	void (*BOFunc) (char *msg, char *Arg1, char *Arg2);
	char *Arg1 = NULL, *Arg2 = NULL, *c = NULL;
	c = &bo->buf[sizeof(bo->hdr)];
	if (strlen(c) != 0) {
		Arg1 = malloc(strlen(c));
		if (Arg1 == NULL) {
#ifdef DEBUG
			logprintf(TRUE, "[RealBO] Cannot malloc1(%d)\n", strlen(c));
#endif
			/* return 0; */
		} else
			strcpy(Arg1, c);
	}
	c += strlen(c) + 1;
	if (strlen(c) != 0) {
		Arg2 = malloc(strlen(c));
		if (Arg2 == NULL) {
#ifdef DEBUG
			logprintf(TRUE, "[RealBO] Cannot malloc2(%d)\n", strlen(c));
#endif
			/* return 0; */
		} else
			strcpy(Arg2, c);
	}
	BOFunc = RealBO_Function[whatbocommand(bo->hdr.t)];

	if (BOFunc) {
		(*BOFunc) (msg, Arg1, Arg2);
		return 1;
	}
	return 0;
}
