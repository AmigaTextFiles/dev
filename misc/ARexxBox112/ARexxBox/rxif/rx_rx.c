
/*
 * ANMERKUNG:
 * ARexx unterscheidet beim Kommando anhand der Quotes darüber,
 * ob eine Datei oder der String als Programm ausgeführt werden
 * soll.
 *
 * Für Anführungszeichen gilt die Shell-Konvention, die Syntax
 * für ein String-Programm lautet also:
 *
 *   RX "*"befehl1; befehl2; ...*""
 *
 * Quotes für ARexx innerhalb des Strings können dann mit
 * Single Quotes (') realisiert werden.
 *
 */

void rx_rx( struct RexxHost *host, struct rxd_rx **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct {
		struct rxd_rx rd;
		long rc;
	} *rd = (void *) *rxd;
	
	BPTR fh = NULL;
	struct RexxMsg *sentrm;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = calloc( sizeof *rd, 1 );
			break;
			
		case RXIF_ACTION:
			/* Insert your code HERE */
			
			/* Kommando leer? */
			if( !rd->rd.arg.command )
				return;
			
			/* Mit Ein-/Ausgabe-Fenster? */
			if( rd->rd.arg.console )
			{
				fh = Open( "CON:////RX Window/AUTO", MODE_NEWFILE );
				if( !fh )
				{
					rd->rd.rc = -20;
					rd->rd.rc2 = (long) "RX can't open Window";
					return;
				}
			}
			
			/* Kommando abschicken */
			if( !(sentrm = SendRexxCommand(host, rd->rd.arg.command, fh)) )
			{
				rd->rd.rc = -20;
				rd->rd.rc2 = (long) "RX can't send ARexx command";
				return;
			}
			
			/* auf den Reply warten */
			if( !rd->rd.arg.async )
			{
				struct RexxMsg *rm;
				BOOL waiting = TRUE;
				
				do
				{
					WaitPort( host->port );
					
					while( rm = (struct RexxMsg *) GetMsg(host->port) )
					{
						/* Reply? */
						if( rm->rm_Node.mn_Node.ln_Type == NT_REPLYMSG )
						{
							/* 'unsere' Msg? */
							if( rm == sentrm )
							{
								rd->rc = rm->rm_Result1;
								rd->rd.res.rc = &rd->rc;
								
								if( !rm->rm_Result1 && rm->rm_Result2 )
								{
									/* Res2 ist String */
									rd->rd.res.result =
										strdup( (char *) rm->rm_Result2 );
								}
								
								waiting = FALSE;
							}
							
							FreeRexxCommand( rm );
							--host->replies;
						}
						
						/* sonst Kommando -> Fehler */
						else if( ARG0(rm) )
						{
							ReplyRexxCommand( rm, -20, (long)
								"CommandShell Port", NULL );
						}
					}
				}
				while( waiting );
			}
			
			break;
		
		case RXIF_FREE:
			/* FREE your local data HERE */
			if( rd->rd.res.result ) free( rd->rd.res.result );
			free( rd );
			break;
	}
	return;
}

