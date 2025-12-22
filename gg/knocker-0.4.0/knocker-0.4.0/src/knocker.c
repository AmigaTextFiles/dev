/* knocker version 0.4.0
 * Release date: 27 July 2001
 *
 * Project homepage: http://knocker.sourceforge.net
 *
 * Copyright 2001 Gabriele Giorgetti <g.gabriele@europe.com>
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

#include "knocker_core.h"
#include "terminal.h"

#ifndef FALSE
#  define FALSE 0
#endif
#ifndef TRUE
#  define TRUE 1
#endif


/* COMMAND LINE ARGUMENTS DEFINITION  */
/* ********************************** */
  /* host to scan */
#define HOST_SHORT_OPT "-H"
#define HOST_LONG_OPT  "--host"

  /* port number to start with */
#define START_PORT_SHORT_OPT "-SP"
#define START_PORT_LONG_OPT  "--start-port"

  /* port number to scan to */
#define END_PORT_SHORT_OPT "-EP"
#define END_PORT_LONG_OPT  "--end-port"

  /* option to disable colored out put */
#define NO_COLORS_SHORT_OPT "-nc"
#define NO_COLORS_LONG_OPT  "--no-colors"

#define HELP_SHORT_OPT    "-h"
#define HELP_LONG_OPT     "--help"

#define VERSION_SHORT_OPT "-v"
#define VERSION_LONG_OPT  "--version"
/* ********************************** */


#define RELEASE_DATE "27 July 2001"
#define AUTHOR_EMAIL "g.gabriele@europe.com"
#define KNOCKER_HOMEPAGE "http://knocker.sourceforge.net"

char *HOSTNAME_STRING;
char *HOSTIP_STRING;
char *SERVICENAME_STRING;

int START_PORT_NUMBER = 0;
int END_PORT_NUMBER = 0;

int open_ports    = 0;
int scanned_ports = 0;

int OPERATION_CANCELLED = FALSE;
char OPERATION_CANCEL_CHAR = 'c';


/* global mutex for our program. assignment initializes it. */
pthread_mutex_t action_mutex  = PTHREAD_MUTEX_INITIALIZER;
/* global condition variable for our program. assignment initializes it. */
pthread_cond_t  action_cond   = PTHREAD_COND_INITIALIZER;



void* console_knocker_portscan_loop (void *data);
void* check_user_cancel (void* data);
void restore_terminal (void* dummy);

int set_hostname_string (const char *hostname);
void unset_hostname_string (void);
int set_hostip_string (int lenght);
void unset_hostip_string (void);

int parse_args (int argc, char *argv[]);
int check_port_number (int port);
void print_version_info (void);
void print_help_info ( void );
void quit (int state);



int set_hostname_string (const char *hostname)
{
  HOSTNAME_STRING = malloc (strlen (hostname) + 1);

  strcpy (HOSTNAME_STRING, hostname);

  return 0;
}


void unset_hostname_string (void)
{
  if (HOSTNAME_STRING != NULL)
    free (HOSTNAME_STRING);

  HOSTNAME_STRING = NULL;
}

int set_hostip_string (int lenght)
{
  HOSTIP_STRING = malloc (lenght +1);
  
  return 0;
}

void unset_hostip_string (void)
{
  if (HOSTIP_STRING != NULL)
      free (HOSTIP_STRING);
      
  HOSTIP_STRING = NULL;
}
        

int set_servicename_string (int lenght)
{
  SERVICENAME_STRING = malloc (lenght + 1);

  return 0;
}

void unset_servicename_string (void)
{
  if (SERVICENAME_STRING != NULL)
    free (SERVICENAME_STRING);

  SERVICENAME_STRING = NULL;
}

/* check if the given port number is in the allowed
 * portscanner range beetween 0 and KNOCKER_MAX_PORT_NUMBER
 */
int is_port_number_valid ( int port )
{
  if ( port < 0 )
    return FALSE;
  if ( port > KNOCKER_MAX_PORT_NUMBER)
    return FALSE;

  return TRUE;
}



/*
 * function: restore_terminal - restore normal screen mode.
 * algorithm: uses the 'stty' command to restore normal screen mode.
 *            serves as a cleanup function for the user input thread.
 * input: none.
 * output: none.
 */
void restore_terminal (void* dummy)
{
    /* restore_terminal: before 'stty -raw echo' */

    system("stty -raw echo");

   /* restore_terminal: after 'stty -raw echo' */

}


/*
 * function: check_user_cancel- read user input while long operation in progress.
 * algorithm: put screen in raw mode (without echo), to allow for unbuffered
 *            input.
 *            perform an endless loop of reading user input. If user
 *            pressed 'c', signal our condition variable and end the thread.
 * input: none.
 * output: none.
 */
void* check_user_cancel (void* data)
{
    int c;

    /* register cleanup handler */
    pthread_cleanup_push(restore_terminal, NULL);

    /* make sure we're in asynchronous cancelation mode so   */
    /* we can be canceled even when blocked on reading data. */
    pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);

    /* put screen in raw data mode */
    system("stty raw -echo");

    /* "endless" loop - read data from the user.            */
    /* terminate the loop if we got a 'e', or are canceled. */
    while ((c = getchar()) != EOF) {
	if (c == OPERATION_CANCEL_CHAR) {

	    /* mark that there was a cancel request by the user */
	    OPERATION_CANCELLED = TRUE;
	    /* signify that we are done */
	    pthread_cond_signal(&action_cond);
	    pthread_exit(NULL);
	}
    }

    /* reset terminal default colors */
    knocker_term_reset_color ();

    /* pop cleanup handler, while executing it, to restore terminal */
    pthread_cleanup_pop(1);

    return NULL;
}




void* console_knocker_portscan_loop (void *data)
{
  if ( (START_PORT_NUMBER == 0 ) && ( END_PORT_NUMBER == 0 ) )
    {
       /* default portscan */
       int port;

       START_PORT_NUMBER = 1;
       END_PORT_NUMBER = KNOCKER_DEFAULT_PORT_RANGE;

       /* Print the following line using colors, if they are enabled */
       /* "Scanning host: %s from port: %d to port: %d\n\n" */
       knocker_term_color_fprintf(stdout, " Scanning host: ", COLOR_WHITE, ATTRIB_RESET);
       knocker_term_color_fprintf(stdout, HOSTNAME_STRING, COLOR_WHITE, ATTRIB_BRIGHT);
       knocker_term_color_fprintf(stdout, " from port: ", COLOR_WHITE, ATTRIB_RESET);
       knocker_term_color_intfprintf(stdout,  START_PORT_NUMBER, COLOR_RED, ATTRIB_BRIGHT);
       knocker_term_color_fprintf(stdout, " to port: ", COLOR_WHITE, ATTRIB_RESET);
       knocker_term_color_intfprintf(stdout,  END_PORT_NUMBER, COLOR_RED, ATTRIB_BRIGHT);
       fprintf(stdout, "\n\n");


           /* make sure we're in asynchronous cancelation mode so   */
    /* we can be canceled even when blocked on scanning ports */
    pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);

       for (port = START_PORT_NUMBER; port < END_PORT_NUMBER; port++)
          {
            if (knocker_portscan_by_hostname (HOSTNAME_STRING, port) == PORT_IS_OPEN)
	      {
	        open_ports++;

		/* Prints the following line with colored output */
                /* "%d/tcp, %s, --> open\n\r", port, SERVICENAME_STRING */
	        knocker_get_service_by_port (SERVICENAME_STRING, port);
                knocker_term_color_intfprintf(stdout, port, COLOR_RED, ATTRIB_BRIGHT);
                knocker_term_color_fprintf(stdout, "/tcp", COLOR_WHITE, ATTRIB_BRIGHT);
                knocker_term_color_fprintf(stdout, ", ", COLOR_WHITE, ATTRIB_RESET);
                knocker_term_color_fprintf(stdout, SERVICENAME_STRING, COLOR_WHITE, ATTRIB_BRIGHT);
                knocker_term_color_fprintf(stdout, ", ", COLOR_WHITE, ATTRIB_RESET);
                knocker_term_color_fprintf(stdout, "---> ", COLOR_BLUE, ATTRIB_BRIGHT);
		knocker_term_color_fprintf(stdout, "open", COLOR_RED, ATTRIB_BRIGHT);
		fprintf(stdout, "\n\r");

		fflush(stdout);
	      }
	    scanned_ports = port - START_PORT_NUMBER;

	  }

    }

  else if ( START_PORT_NUMBER > END_PORT_NUMBER )
    {
       /* reverse scan */
       int port;


       /* Print the following line using colors, if they are enabled */
       /* "Scanning host: %s from port: %d to port: %d\n\n" */
       knocker_term_color_fprintf(stdout, " Scanning host: ", COLOR_WHITE, ATTRIB_RESET);
       knocker_term_color_fprintf(stdout, HOSTNAME_STRING, COLOR_WHITE, ATTRIB_BRIGHT);
       knocker_term_color_fprintf(stdout, " from port: ", COLOR_WHITE, ATTRIB_RESET);
       knocker_term_color_intfprintf(stdout,  START_PORT_NUMBER, COLOR_RED, ATTRIB_BRIGHT);
       knocker_term_color_fprintf(stdout, " to port: ", COLOR_WHITE, ATTRIB_RESET);
       knocker_term_color_intfprintf(stdout,  END_PORT_NUMBER, COLOR_RED, ATTRIB_BRIGHT);
       fprintf(stdout, "\n\n");

           /* make sure we're in asynchronous cancelation mode so   */
    /* we can be canceled even when blocked on scanning ports */
    pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);

       for (port = START_PORT_NUMBER; port > END_PORT_NUMBER; port--)
          {
            if (knocker_portscan_by_hostname (HOSTNAME_STRING, port) == PORT_IS_OPEN)
	      {
	        open_ports++;

		/* Prints the following line with colored output */
                /* "%d/tcp, %s, --> open\n\r", port, SERVICENAME_STRING */
	        knocker_get_service_by_port (SERVICENAME_STRING, port);
                knocker_term_color_intfprintf(stdout, port, COLOR_RED, ATTRIB_BRIGHT);
                knocker_term_color_fprintf(stdout, "/tcp", COLOR_WHITE, ATTRIB_BRIGHT);
                knocker_term_color_fprintf(stdout, ", ", COLOR_WHITE, ATTRIB_RESET);
                knocker_term_color_fprintf(stdout, SERVICENAME_STRING, COLOR_WHITE, ATTRIB_BRIGHT);
                knocker_term_color_fprintf(stdout, ", ", COLOR_WHITE, ATTRIB_RESET);
                knocker_term_color_fprintf(stdout, "---> ", COLOR_BLUE, ATTRIB_BRIGHT);
		knocker_term_color_fprintf(stdout, "open", COLOR_RED, ATTRIB_BRIGHT);
		fprintf(stdout, "\n\r");

	      }
	    scanned_ports = START_PORT_NUMBER - port;

	  }

    }
  else
    {
       /* scan from START_PORT_NUMBER to END_PORT_NUMBER */
       int port;


       /* Print the following line using colors, if they are enabled */
       /* "Scanning host: %s from port: %d to port: %d\n\n" */
       knocker_term_color_fprintf(stdout, " Scanning host: ", COLOR_WHITE, ATTRIB_RESET);
       knocker_term_color_fprintf(stdout, HOSTNAME_STRING, COLOR_WHITE, ATTRIB_BRIGHT);
       knocker_term_color_fprintf(stdout, " from port: ", COLOR_WHITE, ATTRIB_RESET);
       knocker_term_color_intfprintf(stdout,  START_PORT_NUMBER, COLOR_RED, ATTRIB_BRIGHT);
       knocker_term_color_fprintf(stdout, " to port: ", COLOR_WHITE, ATTRIB_RESET);
       knocker_term_color_intfprintf(stdout,  END_PORT_NUMBER, COLOR_RED, ATTRIB_BRIGHT);
       fprintf(stdout, "\n\n");

           /* make sure we're in asynchronous cancelation mode so   */
    /* we can be canceled even when blocked on scanning ports */
    pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);

       for (port = START_PORT_NUMBER; port < END_PORT_NUMBER; port++)
          {
            if (knocker_portscan_by_hostname (HOSTNAME_STRING, port) == PORT_IS_OPEN)
	      {
	        open_ports++;

		/* Prints the following line with colored output */
                /* "%d/tcp, %s, --> open\n\r", port, SERVICENAME_STRING */
	        knocker_get_service_by_port (SERVICENAME_STRING, port);
                knocker_term_color_intfprintf(stdout, port, COLOR_RED, ATTRIB_BRIGHT);
                knocker_term_color_fprintf(stdout, "/tcp", COLOR_WHITE, ATTRIB_BRIGHT);
                knocker_term_color_fprintf(stdout, ", ", COLOR_WHITE, ATTRIB_RESET);
                knocker_term_color_fprintf(stdout, SERVICENAME_STRING, COLOR_WHITE, ATTRIB_BRIGHT);
                knocker_term_color_fprintf(stdout, ", ", COLOR_WHITE, ATTRIB_RESET);
                knocker_term_color_fprintf(stdout, "---> ", COLOR_BLUE, ATTRIB_BRIGHT);
		knocker_term_color_fprintf(stdout, "open", COLOR_RED, ATTRIB_BRIGHT);
		fprintf(stdout, "\n\r");

	      }
	     scanned_ports = port - START_PORT_NUMBER; 

	  }

    }

        /* signify that we are done. */
    pthread_cond_signal(&action_cond);


    return NULL;
}



void quit (int state)
{

  unset_hostname_string ();
  unset_hostip_string();
  unset_servicename_string();

  /* reset terminal default colors */
  knocker_term_reset_color ();

  if (state == 1)
    exit (EXIT_FAILURE);

  exit (EXIT_SUCCESS);
}


void print_version_info (void)
{
  fprintf (stdout, "%s %s (%s)\n", PACKAGE, VERSION, RELEASE_DATE);
  fprintf (stdout, "\n");
  fprintf (stdout, "Written by Gabriele Giorgetti <%s>\n", AUTHOR_EMAIL);
  fprintf (stdout, "Copyright (C) 2001 Gabriele Giorgetti\n");
  fprintf (stdout, "\n");
  fprintf (stdout, "This software is released under the GNU GPL\n");
  fprintf (stdout, "\n");
  fprintf (stdout, "%s can be found at %s\n", PACKAGE, KNOCKER_HOMEPAGE);
}


void print_help_info (void)
{
  fprintf (stdout, "%s, the net portscanner. Version %s (%s)\n", PACKAGE, VERSION, RELEASE_DATE);
  fprintf (stdout, "\n");
  fprintf (stdout, "Usage: %s %s <HOST> \n", PACKAGE,  HOST_LONG_OPT);
  fprintf (stdout, "   or: %s %s <HOST> %s <PORT> %s <PORT> \n", PACKAGE, HOST_LONG_OPT, START_PORT_LONG_OPT, END_PORT_LONG_OPT );
  fprintf (stdout, "\n");
  fprintf (stdout, "Example: %s %s 192.168.0.1 %s 1 %s 1024\n", PACKAGE, HOST_SHORT_OPT, START_PORT_SHORT_OPT, END_PORT_SHORT_OPT);
  fprintf (stdout, "\n");
  fprintf (stdout, "Required options:\n");
  fprintf (stdout, "      %s,  %s             host name or numeric Internet address\n", HOST_SHORT_OPT, HOST_LONG_OPT);
  fprintf (stdout, "\n");
  fprintf (stdout, "Common options (if SP is specified you must also give EP):\n");
  fprintf (stdout, "      %s, %s       port number to begin the scan from\n", START_PORT_SHORT_OPT, START_PORT_LONG_OPT);
  fprintf (stdout, "      %s, %s         port number to end the scan at\n", END_PORT_SHORT_OPT, END_PORT_LONG_OPT);
  fprintf (stdout, "\n");
  fprintf (stdout, "Extra options:\n");
  fprintf (stdout, "      %s, %s        disable colored output\n", NO_COLORS_SHORT_OPT, NO_COLORS_LONG_OPT);
  fprintf (stdout, "\n");
  fprintf (stdout, "Info options:\n");
  fprintf (stdout, "      %s,  %s             display this help and exit\n", HELP_SHORT_OPT, HELP_LONG_OPT);
  fprintf (stdout, "      %s,  %s          output version information and exit\n", VERSION_SHORT_OPT, VERSION_LONG_OPT);
  fprintf (stdout, "\n");
  fprintf (stdout, "SEE THE MAN PAGE FOR MORE DESCRIPTIONS, AND EXAMPLES\n");
  fprintf (stdout, "Report bugs to <%s>.\n", AUTHOR_EMAIL);
}



int parse_args (int argc, char *argv[])
{
  int i;

  if (argv[1] == NULL)
    {
      fprintf (stderr, "%s: no arguments given\n", PACKAGE);
      fprintf (stderr, "Try `%s %s' for more information.\n", PACKAGE,
	       HELP_LONG_OPT);
      quit (1);
    }

  for (i = 1; i <= argc - 1; i++)
    {
      if((!strcmp (argv[i], VERSION_SHORT_OPT))
         || (!strcmp (argv[i], VERSION_LONG_OPT)))
	{
	  print_version_info ();
	  quit (0);
	}
      else if((!strcmp (argv[i], HELP_SHORT_OPT))
         || (!strcmp (argv[i], HELP_LONG_OPT)))
        {
	  print_help_info();
	  quit(0);
	}
      else if((!strcmp (argv[i], NO_COLORS_SHORT_OPT))
         || (!strcmp (argv[i], NO_COLORS_LONG_OPT)))
        {
	   /* Disable colored output */
	   /* the variable KNOCKER_TERM_NO_COLORS is found in terminal.h */
	   KNOCKER_TERM_NO_COLORS = TRUE;
	}
      else if ((!strcmp (argv[i], HOST_SHORT_OPT))
	       || (!strcmp (argv[i], HOST_LONG_OPT)))
	{
	  if (++i == argc)
	    {
	      fprintf (stderr, "%s: error, no host to scan given\n", PACKAGE);
	      fprintf (stderr, "Try `%s %s' for more information.\n", PACKAGE,
		       HELP_LONG_OPT);
	      quit (1);
	    }

	  set_hostname_string (argv[i]);
	}

      else if ((!strcmp (argv[i], START_PORT_SHORT_OPT))
	       || (!strcmp (argv[i], START_PORT_LONG_OPT)))
	{
	  if (++i == argc)
	    {
	      fprintf (stderr,
		       "%s: error, no port number, where to start the scan from, given\n",
		       PACKAGE);
	      fprintf (stderr, "Try `%s %s' for more information.\n", PACKAGE,
		       HELP_LONG_OPT);
	      quit (1);
	    }

	  START_PORT_NUMBER = atoi (argv[i]);

	  if (is_port_number_valid(START_PORT_NUMBER) != TRUE)
	    {
	      fprintf (stderr,"%s: error, invalid start port number `%d' given\n", PACKAGE, START_PORT_NUMBER);
              quit(1);
	    }
	}
      else if ((!strcmp (argv[i], END_PORT_SHORT_OPT))
	       || (!strcmp (argv[i], END_PORT_LONG_OPT)))
	{
	  if (++i == argc)
	    {
	      fprintf (stderr,
		       "%s: error, no port number, where to scan to, given\n",
		       PACKAGE);
	      fprintf (stderr, "Try `%s %s' for more information.\n", PACKAGE,
		       HELP_LONG_OPT);
	      quit (1);
	    }

	  END_PORT_NUMBER = atoi (argv[i]);

	  if (is_port_number_valid(END_PORT_NUMBER) != TRUE)
	    {
	      fprintf (stderr,"%s: error, invalid end port number `%d' given\n", PACKAGE, END_PORT_NUMBER);
              quit(1);
	    }
	}
       else
        {
           fprintf (stderr, "%s: invalid arguments given\n", PACKAGE);
           fprintf (stderr, "Try `%s %s' for more information.\n", PACKAGE,
	       HELP_LONG_OPT);
           quit (1);
	}


    }				/* end of for loop */

  return 0;
}




int main (int argc, char *argv[])
{

  pthread_t thread_scan_loop;
  pthread_t thread_user_cancel;

  /* Colors are enabled by default  */
  /* variable defined in terminal.h */
  KNOCKER_TERM_NO_COLORS = FALSE;

  parse_args (argc, argv);

  set_servicename_string (20);
  set_hostip_string(40);

  fprintf (stdout, "\n");

   /* print the following line using colors, if they are enabled */
  /*"Resolving host: %s ---" */
  knocker_term_color_fprintf(stdout, "Resolving host: ", COLOR_WHITE, ATTRIB_RESET);
  knocker_term_color_fprintf(stdout, HOSTNAME_STRING, COLOR_WHITE, ATTRIB_BRIGHT);
  knocker_term_color_fprintf(stdout, " ---", COLOR_BLUE, ATTRIB_BRIGHT);


  if (knocker_get_ip_by_hostname (HOSTIP_STRING, HOSTNAME_STRING) != 0)
    {

       knocker_term_color_fprintf(stdout, "|", COLOR_RED, ATTRIB_BRIGHT);
       knocker_term_color_fprintf(stdout, " couldn't resolve the hostname !", COLOR_WHITE, ATTRIB_BRIGHT);
       fprintf(stdout, "\n");
       knocker_term_color_fprintf(stdout, "Knocker portscan aborted.", COLOR_WHITE, ATTRIB_RESET);
       fprintf(stdout, "\n\n");

       quit(1);
    }


  knocker_term_color_fprintf(stdout, "---> ", COLOR_BLUE, ATTRIB_BRIGHT);
  knocker_term_color_fprintf(stdout, HOSTIP_STRING, COLOR_RED, ATTRIB_BRIGHT);
  fprintf(stdout, "\n");


  unset_hostip_string();


    /* spawn the portscan loop thread */
    pthread_create(&thread_scan_loop,
		   NULL,
		   console_knocker_portscan_loop,
		   (void*)NULL);
    /* spawn the user input for cancel check thread */
    pthread_create(&thread_user_cancel,
		   NULL,
		   check_user_cancel,
		   (void*)NULL);


  /* prints knocker portscan in progress (press 'c' to cancel the operation)... */
  knocker_term_color_fprintf(stdout, "knocker portscan ", COLOR_WHITE, ATTRIB_RESET);
  knocker_term_color_fprintf(stdout, "in progress ", COLOR_WHITE, ATTRIB_BRIGHT);
  knocker_term_color_fprintf(stdout, "(press '", COLOR_WHITE, ATTRIB_RESET);
  knocker_term_color_fprintf(stdout, "c", COLOR_RED, ATTRIB_BRIGHT);
  knocker_term_color_fprintf(stdout, "' to cancel the operation)...", COLOR_WHITE, ATTRIB_RESET);
  fprintf(stdout, "\n\n");

  fflush(stdout);


    /* lock the mutex, and wait on the condition variable, */
    /* till one of the threads finishes up and signals it. */
    pthread_mutex_lock(&action_mutex);
    pthread_cond_wait(&action_cond, &action_mutex);
    pthread_mutex_unlock(&action_mutex);


    /* check if we were signaled due to user operation        */
    /* cancelling, or because the portscan thread was finished. */
    if (OPERATION_CANCELLED == TRUE) {
	/* we join it to make sure it restores normal */
	/* screen mode before we print out.           */
        pthread_join(thread_user_cancel, NULL);
	knocker_term_color_fprintf(stdout, "\n---|", COLOR_RED, ATTRIB_BRIGHT);
        knocker_term_color_fprintf(stdout, " Operation cancelled ", COLOR_WHITE, ATTRIB_BRIGHT);
        knocker_term_color_fprintf(stdout, "|---\n", COLOR_RED, ATTRIB_BRIGHT);
	fflush(stdout);
        /* cancel the portscan thread */
        pthread_cancel(thread_scan_loop);
    }
        else {
        /* cancel and join the user-input thread.     */
	/* we join it to make sure it restores normal */
	/* screen mode before we print out.           */
        pthread_cancel(thread_user_cancel);
        pthread_join(thread_user_cancel, NULL);

    }

  fprintf (stdout, "\n");
  fprintf (stdout, "%s port scan on host ", PACKAGE);
  knocker_term_color_fprintf(stdout, HOSTNAME_STRING, COLOR_WHITE, ATTRIB_BRIGHT);
  fprintf (stdout, " completed.\n");

  fprintf (stdout, "Total scanned ports: ");
  knocker_term_color_intfprintf(stdout, scanned_ports, COLOR_RED, ATTRIB_BRIGHT);
  knocker_term_color_fprintf(stdout, " (", COLOR_WHITE, ATTRIB_BRIGHT);
  knocker_term_color_intfprintf(stdout, START_PORT_NUMBER, COLOR_RED, ATTRIB_BRIGHT);
  knocker_term_color_fprintf(stdout, " - ", COLOR_WHITE, ATTRIB_BRIGHT);
  knocker_term_color_intfprintf(stdout, END_PORT_NUMBER, COLOR_RED, ATTRIB_BRIGHT);
  knocker_term_color_fprintf(stdout, ")\n", COLOR_WHITE, ATTRIB_BRIGHT);

  fprintf (stdout, "Total open ports found: ");
  knocker_term_color_intfprintf(stdout, open_ports, COLOR_RED, ATTRIB_BRIGHT);
  fprintf (stdout, "\n\n");

  quit (0);			/* exit the program */

  return 0;			/* not reached, avoids compilation warning */
}
