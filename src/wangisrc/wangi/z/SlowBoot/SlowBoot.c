/*************************************************************************
 *
 * SlowBoot
 *
 * Copyright ©1995-96 Lee Kindness cs2lk@scms.rgu.ac.uk
 *
 * Read SlowBoot.guide (from the main archive) for distribution details.
 *
 * SlowBoot.c
 */

#include "gst.c"
#include "SlowBoot_rev.h"

const STRPTR vtag = VERSTAG;
STRPTR defcmd = "Execute <>CON:///-1/AmigaDOS/AUTO/NOCLOSE/SMART s:startup-sequence";

void NewAssign(STRPTR name, STRPTR to, BPTR def);
void NewAssignLate(STRPTR name, STRPTR to, BPTR def);


/*************************************************************************
 * NewAssign() -- Reassign an assign
 */

void NewAssign(STRPTR name, STRPTR to, BPTR def)
{
	/* Remove old assign */
	if( AssignLock(name, NULL) )
	{
		BPTR lock;
		
		/* Lock new destination */
		if( lock = Lock(to, ACCESS_READ) )
		{
			/* Add Assign */
			if( !AssignLock(name, lock) )
				UnLock(lock);
		} else
		{
			/* Assign to default location */
			lock = DupLock(def);
			if( !AssignLock(name, lock) )
				UnLock(lock);
		}
	}
}


/*************************************************************************
 * NewAssignLate() -- Reassign a late (defered) assign
 */

void NewAssignLate(STRPTR name, STRPTR to, BPTR def)
{
	/* Remove old assign */
	if( AssignLock(name, NULL) )
	{
		/* Add Assign */
		if( !AssignLate(name, to) )
		{
			BPTR lock;
			/* Assign to default location */
			lock = DupLock(def);
			if( !AssignLock(name, lock) )
				UnLock(lock);
		}
	}
}


/*************************************************************************
 * main()
 */

#define OPT_DEVICE 0
#define OPT_WAIT 1
#define OPT_NOREASSIGN 2
#define OPT_CMD 3
#define OPT_MAX 4
#define TEMPLATE "DEVICE/A,WAIT/N/K,NOREASSIGN/S,CMD=COMMAND/K"

void main( void )
{
	struct Process *myproc;
	
	/* Check Library versions */
	if( (((struct Library *)SysBase)->lib_Version < 36) ||
	    (((struct Library *)DOSBase)->lib_Version < 36) )
		return;
	
	/* Find our process */
	if( myproc = (struct Process *)FindTask(NULL) )
	{
		APTR oldwinp;
		struct RDArgs *rdargs;
		LONG args[OPT_MAX] = {0, 0, 0, 0};
		LONG delay;
		#define dev (STRPTR)args[OPT_DEVICE]
		#define cmd (STRPTR)args[OPT_CMD]
		args[OPT_CMD] = (LONG)defcmd;
		
		/* Store away original contents */
		oldwinp = myproc->pr_WindowPtr;
		
		/* We don't want any requesters */
		myproc->pr_WindowPtr = (APTR)-1L;
		
		/* Get options */
		if (rdargs = ReadArgs(TEMPLATE, (LONG *)&args, NULL))
		{
			BPTR lock;
			
			if( args[OPT_WAIT] )
				delay = (*((LONG *)args[OPT_WAIT])) * 50;
			else
				delay = 50;
			
			/* Test for dev... Has it spun up? */
			if( lock = Lock(dev, ACCESS_READ) )
			{
				if( !args[OPT_NOREASSIGN] )
				{
					BPTR dupsys;
					BOOL ok;
				
					/* The device has spun up correctly, reassign assigns */
					Forbid();
					ok = FALSE;
					if( AssignLock("SYS", NULL) )
					{
						dupsys = DupLock(lock);
						if( AssignLock("SYS", dupsys) )
							ok = TRUE;
					}
					Permit();
				
					if( ok )
					{
						BPTR olddir;
						BPTR con;
					
						NewAssign("C", "SYS:C", lock);
						NewAssign("S", "SYS:S", lock);
						NewAssign("LIBS", "SYS:LIBS", lock);
						NewAssign("DEVS", "SYS:DEVS", lock);
						NewAssign("FONTS", "SYS:FONTS", lock);
						NewAssign("L", "SYS:L", lock);
						NewAssignLate("ENVARC", "SYS:Prefs/Env-Archive", lock);
					
						/* Change cd to SYS: */
						olddir = CurrentDir(lock);
					
						/* Open NIL: */
						if( con = Open("NIL:", MODE_OLDFILE) )
						{
							/* Execute startup-sequence */
							if( SystemTags(cmd, SYS_Input,  con,
							                    SYS_Output, 0,
							                    SYS_Asynch, TRUE,
							                    TAG_END ) == -1 )
								Close(con);
						}					
						/* Change back to old dir */
						CurrentDir(olddir);
					}
				}
				UnLock(lock);
			} else
			{
				/* Drive has not spun-up, lets wait a while */
				if( delay > 0 )
					Delay(delay);
				
				/* And then reboot */
				Disable();
				ColdReboot();
				Enable();
				/* .
				 * .
				 * .
				 * This NEVER returns...
				 *
				 */
			}
			FreeArgs(rdargs);	
		}
		/* Restore old pointer */
		myproc->pr_WindowPtr = oldwinp;
	}
}
	