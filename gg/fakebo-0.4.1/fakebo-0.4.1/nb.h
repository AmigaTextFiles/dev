

#ifndef NB_H
#define NB_H

/* NetBus support */
#define NETBUSMAXCLIENTS			50	/* Maximum NetBus Connections */
#define NETBUSMAXCOM				24	/* Maximum of known NetBus Commands */
#define BUFLEN					1024	/* Length of buffer */

#define NETBUSANSWER				"Msg;"	/* Command for writing servers messages to client */

/* NetBus Support */
static char netbuscommands[NETBUSMAXCOM][2][40] =
{
	{"GetInfo;", "Info requested"},
	{"Listen;0", "Listen for Keystrokes: OFF Requested"},
	{"Listen;1", "Listen for Keystrokes: ON Requested"},
	{"Eject;0", "Close the CD ROM Requested"},
	{"Eject;1", "Open the CD ROM Requested"},
	{"SendKeys;0", "Send Text Requested"},
	{"SwapButton;0", "Restore Mouse Buttons Requested"},
	{"SwapButton;1", "Swap the Mouse Buttons Requested"},
	{"Message;", "Display Message Request"},
	{"ServerPwd;", "Password Change Request"},
	{"RemoveServer;05", "Close Server"},
	{"RemoveServer;15", "Remove Server"},
	{"Password;0", "Password Access"},
	{"Password;1", "Password Security Hole Access"},
	{"PlaySound;", "Play sound file"},
	{"SetMousePos;", "Set Mouse Position"},
	{"StartApp;", "Start Application"},
	{"KeyClick;", "Key Click"},
	{"DisableKeys;", "Disable Keys"},
	{"GetApps;", "List Active Applications"},
	{"FocusApp;", "Focus Application"},
	{"KillApp;", "Kill Application"},
	{"ShowImage;", "Show Image"},
	{"URL;", "Go to URL"}
};

static char unknownnetbuscommand[40] = "Unknown NetBus Command (Garbage?)";
static int netbusclients = 0;
static int netbuskfd[NETBUSMAXCLIENTS];
static struct sockaddr_in netbusaddr;
static int netbuslfd = -1;

#endif
