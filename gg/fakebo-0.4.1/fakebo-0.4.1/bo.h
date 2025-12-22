
#ifndef BO_H
#define BO_H

#include "global.h"

#define ARGSIZE 256
#define BUFFSIZE 1024		/* the maximum size of BO packet */
#define MAGICSTRING "*!*QWTY?"	/* signature of BO packet */
#define MAGICSTRINGLEN 8	/* length of signature of BO packet */
#define MAXNUMCOMMANDS 64	/* number of BO commands */
#define MAXSIZECUSTOM 1000	/* maximum size of custom messages (in bytes) */
#define MRAND_MAX_STATE 0xFFFF	/* used for cracking the packets */
#define HEXDUMPSIZE 8

#if SIZEOF_UNSIGNED_INT == 4
#define u32bit unsigned int
#elif SIZEOF_UNSIGNED_LONG == 4
#define u32bit unsigned long
#else
#error "Can't find type of data which is 32 bit long !"
#endif

#ifdef HAVE_PRAGMA_PACK
#pragma pack(1)
#endif

typedef struct {
	byte magic[8] attpack;	/* signature (8 bytes) */
	u32bit len attpack;	/* length of entire packet (32bit int) */
	u32bit id attpack;	/* id of packet (32bit int) */
	byte t attpack;		/* type of operation (2 most of frag, 6 op) */
} boheader;

typedef union {
	boheader hdr;
	char buf[BUFFSIZE];
} bopacket;

#ifdef FAKEBO_COMMANDS

char bocommands[MAXNUMCOMMANDS][50]
=
{"Error type", "Ping Packet", "System Reboot", "System Lock Up"
 ,"List System Passwords", "View Console", "Get System Information"
 ,"Log Pressed Keys", "Send KeyPress Log", "Show A Dialog Box"
 ,"Delete A Value from The Registry"
 ,"Create TCP redirection(proxy)", "Delete TCP redirection"
 ,"List TCP redirections", "Start Application", "End Application"
 ,"Export a share resource", "Cancel share export"
 ,"Show Export List", "Resend Packet", "Enable HTTP Server"
 ,"Disable HTTP Server", "Resolve Host Name", "Compress a File"
 ,"Uncompress a File", "Plug-in execute", "0x1a???", "0x1b???"
 ,"0x1c???", "0x1d???", "0x1e???", "0x1f???"
 ,"Show active processes", "Kill a process", "Start a process"
 ,"Create a key in the registry"
 ,"Set the Value of a key in registry", "Delete a key in registry"
 ,"Enumerate registry keys", "Enumerate registry values"
 ,"Capture a static image", "Capture a video stream"
 ,"Play a sound file", "Show Available Video capture devices"
 ,"Capture the screen to a file", "Start sending a file using TCP"
 ,"Start recieving a file using TCP", "List (running) plug-ins"
 ,"Kill Plugin", "List directory", "0x32???", "0x33???"
 ,"Find a file", "Delete a file", "View file contents"
 ,"Rename a file", "Copy a file", "List all network devices"
 ,"Connect to network resource"
 ,"End connection of a network resource"
 ,"Show NetWork Connections", "Create Directory (folder)"
 ,"Remove directory", "Show Running Applications"};
static char notyetimplemented[] = "Type Of Packet Unknown";
static long holdrand = 1L, resetholdrand = 31337;
char g_password[ARGSIZE];

#endif


#endif
