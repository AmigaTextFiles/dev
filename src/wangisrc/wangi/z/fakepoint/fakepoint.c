/* 

PKTShovel V1.1 freely distributable from the Plot Hatching Factory. 

Written my Mat 'Fingers' Bettinson and 10 jugs of coffee. 

Set the script flag on this file and copy into rexx: make sure your path is
also set up to rexx: too... Then you just have to type PKTshovel rather than
the rx etc... 

The systemname specifies a system in the config file. The config file
specifies the paths and addresses to be shoveled etc. 

This program handles file attaches and everything else in the flowfile.
Recognises what has to be deleted and not deleted. Datestamps packets as
they are moved in 8 digit hex form. netmail with .PKT and Echo mail with the
day and session stamp ie TH2, WE0 etc... 

Flowfiles and packets are deleted after copying. No checking is performed as
there is no reason why a copy should fail. It's down to your config. The
script works as I've tested it. Don't be paranoid now! :-) 

The Quiet switch turns off the copying and deleting output to the stdio.

The after-session script is configured in the config file again... It is
simply executed so you MUST set the script flag or it WILL NOT WORK. I
didn't execute it as it may be a DOS or Arexx script so I left it up to you.

Usage: [Rx] PKTShovel <systemname> [QUIET]

*/

#include "gst.c"

#define DEF_PATH   "MAIL:Fake"
#define DEF_SYSTEM ""
#define DEF_GUI    TRUE
#define MXSL       80

struct NodeSystem
{
	char *ns_Node;
	List  ns_AKAs;
	char *ns_PointInbound;
	char *ns_PointOutbound;
	char *ns_BossInbound;
	char *ns_BossOutbound;
	char *ns_Aftersession;
};

struct IntuitionBase *IntuitionBase = NULL;
struct Library *IconBase = NULL;
extern struct ExecBase *SysBase;

int OpenLibs(void);
void CloseLibs(void);
struct NodeSystem *ReadNS(STRPTR);
void FreeNS(struct NodeSystem*);

/* main */
int main(int argc, char **argv)
{
	int  ret              = RETURN_OK;
	char cfg_Path[MXSL]   = DEF_PATH;
	char cfg_System[MXSL] = DEF_SYSTEM;
	BOOL cfg_Gui          = DEF_GUI;
	
	/* Open all libraries */
	if( OpenLibs() )
	{	
		/* Get tooltypes */
		if (argc ? FALSE : TRUE)
		{
			/* Workbench */
			BPTR oldcd;
			struct DiskObject *dobj;
			struct WBStartup *wbs;
			#define PROGNAME wbs->sm_ArgList->wa_Name
			#define PDIRLOCK wbs->sm_ArgList->wa_Lock
			
			wbs = (struct WBStartup *)argv;
			oldcd = CurrentDir(PDIRLOCK);
			if( dobj = GetDiskObject(PROGNAME) )
			{
				STRPTR s;
				if( s = FindToolType(dobj->do_ToolTypes, "NOGUI") )
					cfg_Gui = FALSE;
				if( s = FindToolType(dobj->do_ToolTypes, "CONFIGPATH") )
				{
					strncpy(cfg_Path, s, MXSL);
					cfg_Path[MXSL-1] = NULL;
				}
				if( s = FindToolType(dobj->do_ToolTypes, "SYSTEM") )
				{
					strncpy(cfg_System, s, MXSL);
					cfg_System[MXSL-1] = NULL;
				}
				FreeDiskObject(dobj);
			}
			CurrentDir(oldcd);
		} else
		{
			/* Shell */
			struct RDArgs *rdargs;
			#define OPT_SYSTEM     0
			#define OPT_NOGUI      1
			#define OPT_CONFIGPATH 2
			#define TEMPLATE "SYSTEM,NOGUI/S,CONFIGPATH/K"
			STRPTR args[3] = {0, 0, 0};
			
			if( rdargs = ReadArgs(TEMPLATE, (LONG *)&args, NULL) )
			{
				if( args[OPT_SYSTEM] )
				{
					strncpy(cfg_System, args[OPT_SYSTEM], MXSL);
					cfg_System[MXSL-1] = NULL;
				}
				if( args[OPT_NOGUI] )
					cfg_Gui = FALSE;
				if( args[OPT_CONFIGPATH] )
				{
					strncpy(cfg_Path, args[OPT_CONFIGPATH], MXSL);
					cfg_Path[MXSL-1] = NULL;
				}
				FreeArgs(rdargs);	
			}
		}
		Printf("Config path - \"%s\"\n", cfg_Path);
		if( *cfg_System )
		{
			/* Act as a mailer */
			BPTR oldcd, cd;
			
			Printf("Mailer mode - \"%s\"\n", cfg_System);
			if( cfg_Gui )
				Printf("GUI active\n");
			else
				Printf("No GUI\n");
			
			if( cd = Lock(cfg_Path, ACCESS_READ) )
			{
				oldcd = CurrentDir(cd);
				CurrentDir(oldcd);
				UnLock(cd);
			} else
				Printf("\"%s\" - invalid directory\n", cfg_Path);
		} else
		{
			/* Preference editor mode */
			Printf("Prefs mode\n");
		}
		CloseLibs();
	}
	return( ret );
}


int OpenLibs(void)
{
	return( (SysBase->LibNode.lib_Version >= 37) &&
	        (DOSBase->dl_lib.lib_Version >= 37) &&
	        (IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 37)) &&
	        (IconBase = OpenLibrary("icon.library", 37)) );
}

void CloseLibs(void)
{
	if( IconBase )
		CloseLibrary(IconBase);
	if( IntuitionBase )
		CloseLibrary((struct Library *)IntuitionBase);
}


struct NodeSystem *ReadNS(STRPTR fname)
{
	BPTR f;
	struct NodeSystem *ns = NULL;

	if( f = Open(fname, MODE_READ) )
	{
	}
	return( ns );
}

/*


ARG System quiet
Call TIME('R')

If system = "" then DO
 call fuckwit
 EXIT
 END

If ~ EXISTS(Config) then DO
 say 'And WHERE, pray tell, is the CONFIG? Hmmmm?!'
 EXIT
 END

If strip(quiet) = 'QUIET' then do
 Quiet = 0
 nil = '>NIL: '
 end
Else Do
 Quiet = 1
 nil = ''
 end

If quiet = 1 then DO
 say ''
 say '*** Welcome to Packet Shovel 1.1 by Mat Bettinson. ***'
 say ''
 END

call Readconfig

n = 1

Do i = 1 to numshove
 NetMtemp = Flowsrce.i||Flowaddr.i
 If exists(NetMtemp'.DUT') then DO
  NetmailFile = netMtemp'.DUT'
  call CopyNetMail
  END
 If exists(NetMtemp'.HUT') then DO
  NetmailFile = netMtemp'.HUT'
  call CopyNetMail
  END
 If exists(NetMtemp'.CUT') then DO
  NetmailFile = netMtemp'.CUT'
  call CopyNetMail
  END
 If exists(NetMtemp'.OUT') then DO
  NetmailFile = netMtemp'.OUT'
  call CopyNetMail
  END

 FlowDest = Flowdest.i

 If exists(NetMtemp'.FLO') then DO
  Flowfile = NetMtemp'.FLO'
  Call FlowfileExtract
  END
 If exists(NetMtemp'.HLO') then DO
  Flowfile = NetMtemp'.HLO'
  Call FlowfileExtract
  END
 If exists(NetMtemp'.CLO') then DO
  Flowfile = NetMtemp'.CLO'
  Call FlowfileExtract
  END
 END

address COMMAND
DosCOM

say ''
say 'Packet Shovel 1.1 finished.'
say ''
EXIT

(* Input: Flowfile and FlowDest. *) 

FlowfileExtract:

Call Open(Flow,Flowfile,'R')

Do until EOF(flow)
 Flowline = READLN(Flow)
 If Length(flowline) < 3 then break
 Flowline = translate(flowline,'^','#')
 If left(flowline,1) = '^' then DO
  flowline = Delstr(strip(flowline),1,1)
  Delete = 'YES'
  END
 ELSE delete = 'NO'
 Address COMMAND
 testfile = flowline
 Call getfiletype
 If testfile = 'PKT' then DO
  mailtype = 2
  FileEXT = right(flowline,4)
  call datestamp
  Address COMMAND
  EXEdir'Copy 'flowline' to 'Flowdest||stamp
  If quiet = 1 then say 'Copying 'flowline' to 'flowdest' as 'stamp 
  END
 If testfile = 'BIN' then DO
  Address COMMAND
  EXEdir'Copy 'flowline' to 'Flowdest
  If quiet = 1 then say 'Copying 'flowline' to 'flowdest
  END
 If delete = 'YES' then DO
  Address COMMAND
  EXEdir'Delete 'niL||flowline
  END
 END
eh = Close(flow)
address COMMAND
EXEdir'delete 'NIL||flowfile
RETURN

(* Routine that scans the config file and parses the commands one by one
  and executes instructions relevant to that command. System copies are 
  logged in an array and the total number of network addresses to be 
  copied is returned in numshove which is used as the upper limit for the 
  do (for next loop) loop which runs through checking for Netmail 
  packets and flow files... 
*)

ReadConfig:

Call Open(CFG,Config,"R")

Do UNTIL EOF(CFG)
 Do UNTIL EOF(CFG)
  raw = ReadLN(CFG)
  Parse UPPER VAR raw command readsys
  If command = 'SYSTEM' then break
  END
  readsys = strip(readsys)
  IF readsys = system then break
 END

If readsys ~= system then DO
 Say 'System not FOUND!!!'
 EXIT
 END

Numshove = 0

Flowsrce = 0
Flowdest = 0
FlowAddr = 0

DO UNTIL EOF(CFG)
 CFGLine = READLN(CFG)
 Parse UPPER VAR CFGline Command Data1 Data2 Data3
 SELECT
  WHEN Command = 'MOVE' then DO
   Numshove = numshove + 1
   Flowsrce.Numshove = strip(Data1)
   Flowdest.Numshove = strip(Data2)
   FlowAddr.Numshove = translate(strip(Data3),'..',':/')
   END
  WHEN Command = 'DOSCOM' then DO
   DOSCom = Data1||data2||data3
   END
  WHEN Command = 'SYSTEM' then DO
   fini = 1
   END
  OTHERWISE nop
  END
 If fini = 1 then break
 END

Call Close('CFG')

RETURN

(* Input Testfile. Output testfile = 'PKT' or 'BIN' *)

getfiletype:

temp = translate(testfile,' ',':/')
temp = word(temp,words(temp))
temp = delstr(temp,length(temp)-2,2)
temp = compress(temp,'.')
If datatype(temp) = 'NUM' then DO
  testfile = 'PKT'
  END
ELSE testfile = 'BIN'
RETURN

(* stamp returns 8 digit hex number with .PKT. N is used to make unique.
   mailtype = 1 = netmail .PKT extension. 0 = echomail .TH3 etc... stripped
   off filename to be really flash. :-) 
 *)

datestamp:
n = n + 1 
S = d2x((TIME('E') * 100) + n)
D = d2x(time('S'))
Z = d2x(date('I'))
stamp = right(Z||D||S,8)
ExtTod = '.'UPPER(Left(Date('W'),2))'0'
If mailtype = 1 then stamp = stamp'.PKT'
ELSE stamp = stamp||ExtTod
RETURN

(* Copies Netmailfile to flowdest renaming to datestamp.PKT *)

CopyNetmail:
mailtype = 1
call datestamp
Address COMMAND
EXEdir'Copy 'Netmailfile' TO 'Flowdest.i||stamp
If Quiet = 1 then DO
  say 'Copying 'Netmailfile' to 'Flowdest.i' as 'stamp
  END
EXEdir'Delete 'NIL||Netmailfile
RETURN

fuckwit:
say 
say 'PKTShovel 1.1 from the Plot Hatching Factory.'
say "Written my Mat 'Fingers' Bettinson 10-nov-94"
say 
say 'USAGE: [RX] UnpackPKT <SYSTEM> [quiet]'
say
say 'Note: SYSTEM details in 'Config
say
return
*/

