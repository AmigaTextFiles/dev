
/*
 * Dieses Kommando kann nur von ARexx aus eine CmdShell
 * _ÖFFNEN_, und nur von einer CmdShell aus diese _SCHLIEßEN_.
 *
 * Mit etwas mehr Aufwand (Buchführung über die Hosts) kann man
 * auch eine andere (flexiblere) Lösung finden.
 *
 * ACHTUNG: Buchführung über offene CmdShells ist zwingend
 * notwendig für den CloseDown! Sonst bleiben nach 'Quit' u.U.
 * noch CmdShells offen!
 *
 */

#include <dos/dostags.h>


extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;


static void runCommandShell( void )
{
	BPTR fh;
	struct RexxHost *rh;
	
	/* diese Funktion wird als eigener Prozeß gestartet */
	
	geta4();
	
	if( rh = SetupARexxHost(NULL, NULL) )
	{
		if( fh = Open( "CON:////CommandShell/AUTO", MODE_NEWFILE ) )
		{
			CommandShell( rh, fh, fh, "> " );
			Close( fh );
		}
		
		CloseDownARexxHost( rh );
	}
}


void rx_cmdshell( struct RexxHost *host, struct rxd_cmdshell **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_cmdshell *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = calloc( sizeof *rd, 1 );
			break;
			
		case RXIF_ACTION:
			/* Insert your code HERE */
			
			if( rd->arg.close ) /* schließen */
			{
				if( host->flags & ARB_HF_CMDSHELL )
				{
					host->flags &= ~ARB_HF_CMDSHELL;
				}
				else
				{
					rd->rc = -10;
					rd->rc2 = (long) "Not a CommandShell";
				}
			}
			else /* öffnen (OPEN ist unnötig) */
			{
				CreateNewProcTags(
					NP_Entry, runCommandShell,
					NP_Name, "CommandShell",
					TAG_DONE );
			}
			
			break;
		
		case RXIF_FREE:
			/* FREE your local data HERE */
			free( rd );
			break;
	}
	return;
}

