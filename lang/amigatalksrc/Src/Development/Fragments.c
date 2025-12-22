   /* If the file has no errors, then we can proceed: */
   if (OpenFile( infile, filename, 0 ) < 0)
      return( -1 );

   instr = GetFileString( infile );
   while (instr != NULL)
      {
      if (strstr( instr, "\"" ) != NULL)
         {
         }

      if (strstr( instr, CurrentClass ) != NULL)
         {
         /* we're in the right class definition section: */
         int   cnt = 0, len = strlen( CurrentClass );
         char *cp  = strstr( instr, CurrentClass );

         for (cnt = 0; cnt < len; cnt++)
            cp++;

         instr = cp;
         SkipWhiteSpace( instr );
         SkipBarVariables( instr );
         SkipWhiteSpace( instr );
         FindEOL( instr );
        
         instr = GetFileString( infile );
         }
      else
         instr = GetFileString( infile ); // Keep looking for the Class.
      }


int   HandleConsole( struct Console *con )
{
   int   rval = HALT;
   int   cont = TRUE;
   char  nil[256], *buff = &nil[0];
      
   while (cont == TRUE)
      {
      ConDumps( con, "\n8-)" );
      buff = ConGets( con );
      if ((0xFF & buff[0]) == 0x9B)     /* CSI code! */
         {
         if (buff[1] == '1' && buff[2] == '~')   /* f2 == EDIT */
            {
            rval = EDIT;
            cont = FALSE;
            break;
            }
         else if (buff[1] == '2' && buff[2] == '~') /* f3 == TRACE */
            {
            rval = TRACE;
            cont = FALSE;
            break;
            }
         else if (buff[1] == '3' && buff[2] == '~') /* f4 == RUN */
            {
            rval = RUN;
            cont = FALSE;
            break;
            }
         else if (buff[1] == '0' && buff[2] == '~') /* f1 == HALT */
            {
            rval = HALT;
            cont = FALSE;
            break;
            }
         }
      else
         strcat( con_buff, buff );
      }
   return rval;
}

struct NewScreen  con_scrn = {
	0, 0, 640, 200, 4, 1, 0,
	HIRES, CUSTOMSCREEN, NULL, 
   (UBYTE *) "AmigaTalk System Console",
	NULL, NULL
};

struct NewWindow  con_wind = {
   0, 0, 640, 200, 0, 1,
   REQCLEAR | REQVERIFY | GADGETUP | GADGETDOWN,
   SMART_REFRESH | ACTIVATE | RMBTRAP,
   NULL, NULL, (UBYTE *) "AmigaTalk Debugging Console",
   NULL, NULL, 20, 20, 640, 200, CUSTOMSCREEN
};

/* ARG_1 == console name string */

LONG  TurnOnConsole( RXMSGPTR rmptr, ENVPTR e, RBLOCKPTR result )  
{
   LONG           rval  = 0L;
   struct Window  *wind = NULL;
   struct Screen  *scrn = NULL;
   
#ifdef DEBUG
   printf( "\nReceived TurnOnConsole Name: %s, Height: %s command!\n", 
            ARG_1, ARG_2 );
#endif

   result->Type    = RBSTRING;
   if ((scrn = (struct Screen *) OpenScreen( &con_scrn )) == NULL)
      {
      strcpy( result->values.CharVal, ARG_1 );
      strcat( result->values.CharVal, " did NOT open a screen!\n" );
      return( 101L );
      }
   con_wind.Screen = scrn;
   con_wind.Height = atoi( ARG_2 );
   if (con_wind.Height < 20)
      con_wind.Height = 20;
   if ((wind = (struct Window *) OpenWindow( &con_wind )) == NULL)
      {
      strcpy( result->values.CharVal, ARG_1 );
      strcat( result->values.CharVal, " did NOT open a window!\n" );
      CloseScreen( scrn );
      return( 102L );
      }
   if ((e->at_Console = AttachConsole( wind, ARG_1 )) == NULL)	
      {
      strcpy( result->values.CharVal, ARG_1 );
      strcat( result->values.CharVal, " did NOT open a console!\n" );
      CloseWindow( wind );
      CloseScreen( scrn );
      return( 103L );
      }
   ConDumps( e->at_Console, "Console is Ready!\n" );
   switch (HandleConsole( e->at_Console ) )
      {
      case RUN:
         strcpy( LineBuffer, con_buff );
         strcpy( result->values.CharVal, con_buff );
         break; 

      case EDIT:
         /* return to AmigaTalk GUI: */
         DetachConsole( e->at_Console );
         CloseWindow( wind );
         CloseScreen( scrn );
         rval = EDIT;
         break;
      case TRACE:
         strcpy( LineBuffer, con_buff );
         strcpy( result->values.CharVal, con_buff );
         break; 

      case HALT:
         /* return to AmigaTalk GUI: */
         DetachConsole( e->at_Console );
         CloseWindow( wind );
         CloseScreen( scrn );
         rval = HALT;
         break;
      default:
#ifdef   DEBUG
         fprintf( stderr, "Reached a default point in TurnOnConsole!\n" );
#endif
         break;
      }
   return( rval );
}


/* ARG_1 == DETACH or DEACTIVATE */

LONG  TurnOffConsole( RXMSGPTR rmptr, ENVPTR e, RBLOCKPTR result ) 
{

#ifdef DEBUG
   printf( "\nReceived TurnOffConsole %s command!\n", ARG_1 );
#endif   
   if (strcmp( ARG_1, "DETACH" ) == 0)
      if (e->at_Console != NULL)
         DetachConsole( e->at_Console );
   else if (strcmp( ARG_1, "DEACTIVATE" ) == 0)
      if (e->at_Console != NULL)
         DetachConsole( e->at_Console );
   e->at_Console = NULL;
   return( 0L );
}

