
void rx_help( struct RexxHost *host, struct rxd_help **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_help *rd = *rxd;
	struct rxs_command *rxc;

	/*
	 * Dieser HELP-Befehl unterstützt (noch) nicht das PROMPT-Keyword
	 * da das nur im Rahmen eines GUIs Sinn hat
	 */

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your code HERE */
			
			if( rd->arg.prompt )
			{
				rd->rc = -10;
				rd->rc2 = (long) "Prompt option not yet implemented";
				return;
			}
			
			if( rd->arg.command )
			{
				rxc = FindRXCommand( rd->arg.command );
				if( !rxc )
				{
					rd->rc = -10;
					rd->rc2 = (long) "Unknown Command";
					return;
				}
				
				if( rd->res.commanddesc = AllocVec(strlen(rxc->command)
					+ (rxc->args    ? strlen(rxc->args)    : 0)
					+ (rxc->results ? strlen(rxc->results) : 0) + 20,
					MEMF_ANY) )
				{
					sprintf( rd->res.commanddesc,
						"%s%c%s%s%s%s%s",
						rxc->command, 
						(rxc->results || rxc->args) ? ' ' : '\0',
						rxc->results ? "VAR/K,STEM/K" : "",
						(rxc->results && rxc->args) ? "," : "",
						rxc->args ? rxc->args : "",
						rxc->results ? " => " : "",
						rxc->results ? rxc->results : "" );
				}
				else
				{
					rd->rc = 10;
					rd->rc2 = ERROR_NO_FREE_STORE;
					return;
				}
			}
			else
			{
				char **s;
				
				if( !(s = AllocVec(sizeof(char *) * command_cnt+1, MEMF_CLEAR)) )
				{
					rd->rc = 10;
					rd->rc2 = ERROR_NO_FREE_STORE;
					return;
				}
				rd->res.commandlist = s;
				
				rxc = rxs_commandlist;
				while( rxc->command )
				{
					*s = rxc->command;
					s++;
					rxc++;
				}
			}
			
			break;
		
		case RXIF_FREE:
			/* FREE your local data HERE */
			
			if( rd->res.commanddesc )
				FreeVec( rd->res.commanddesc );
			if( rd->res.commandlist )
				FreeVec( rd->res.commandlist );
			
			FreeVec( rd );
			break;
	}
	return;
}

