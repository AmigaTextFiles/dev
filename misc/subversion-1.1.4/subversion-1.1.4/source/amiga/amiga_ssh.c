/*
 * $Id$
 *
 * :ts=4
 *
 * Wrapper routines for Amiga SSHv1 client interface to subversion 1.1.4
 * Copyright (c) 2009 by Olaf Barthel <obarthel@gmx.net>
 * All rights reserved
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

#include <arpa/inet.h>
#include <netdb.h>

/****************************************************************************/

#include "amiga_getpass.h"
#include "amiga_ssh.h"

#include "ssh_protocol.h"

/****************************************************************************/

#define SAME (0)

/****************************************************************************/

/* Options for connecting to a server. */
struct ssh_options
{
	int		port;		/* Port number; defaults to ssh/tcp or 22 */
	int		cipher;		/* Cipher; defaults to 3DES */
	char *	password;	/* Password; default is empty */
};

/****************************************************************************/

/* Free all memory allocated for the ssh connection options */
static void
free_ssh_options(struct ssh_options * options)
{
	if(options != NULL)
	{
		if(options->password != NULL)
			free(options->password);

		free(options);
	}
}

/****************************************************************************/

/* Reset the ssh connection options to defaults */
static void
reset_ssh_options(struct ssh_options * options,int port)
{
	if(options->password != NULL)
	{
		free(options->password);
		options->password = NULL;
	}

	options->cipher = SSH_CIPHER_3DES;

	options->port = port;
}

/****************************************************************************/

/* Try to read the server connection options from a file. We try to find those
   options which match a specific combination of host name and user name. */
static struct ssh_options *
read_ssh_options(const char * config_file_name,const char * user_name,const char * host_name,int port)
{
	struct ssh_options * result = NULL;
	struct ssh_options * options;
	size_t line_size = 1024;
	int host_name_match = 0;
	int user_name_match = 0;
	char * line = NULL;
	FILE * file = NULL;
	char * token;
	size_t len;

	options = malloc(sizeof(*options));
	if(options == NULL)
		goto out;

	memset(options,0,sizeof(*options));

	reset_ssh_options(options,port);

	line = malloc(line_size);
	if(line == NULL)
		goto out;

	file = fopen(config_file_name,"r");
	if(file == NULL)
		goto out;

	/* Read the file one line at a time. */
	while(fgets(line,line_size,file) != NULL)
	{
		/* Skip lines that start with a '#' mark. */
		if(line[0] == '#')
			continue;

		/* Strip trailing CRLF and LF, as well as other blank spaces */
		len = strlen(line);

		while(len > 0 && isspace(line[len-1]))
			len--;

		if(len == 0)
			continue;

		line[len] = '\0';

		/* Each line contains a keyword and a value to be used */
		token = strtok(line," \t");
		if(token == NULL)
			continue;

		/* Now figure out which keyword was used */
		if(strcasecmp(token,"host") == SAME || strcasecmp(token,"server") == SAME)
		{
			token = strtok(NULL," \t");

			/* Does the host name match exactly? */
			host_name_match = (token != NULL && strcasecmp(token,host_name) == SAME);
			if(host_name_match)
				reset_ssh_options(options,port);
		}
		else if (strcasecmp(token,"user") == SAME)
		{
			token = strtok(NULL," \t");

			/* The user name must match exactly, and the host name must match, too. */
			user_name_match = (token != NULL && user_name != NULL && strcmp(token,user_name) == SAME && host_name_match);
		}
		else if (strcasecmp(token,"port") == SAME)
		{
			/* If the host name matched, parse the port number. */
			if(host_name_match)
			{
				token = strtok(NULL," \t");
				if(token != NULL)
				{
					int n;

					n = atoi(token);
					if(0 < n && n < 65536)
						options->port = n;
				}
			}
		}
		else if (strcasecmp(token,"cipher") == SAME)
		{
			/* If the host name matched, figure out which cipher should be used */
			if(host_name_match)
			{
				token = strtok(NULL," \t");
				if(token != NULL)
				{
					if(strcasecmp(token,"blowfish") == SAME)
						options->cipher = SSH_CIPHER_BLOWFISH;
					else if (strcasecmp(token,"3des") == SAME || strcasecmp(token,"des") == SAME)
						options->cipher = SSH_CIPHER_3DES;
				}
			}
		}
		else if (strcasecmp(token,"password") == SAME)
		{
			/* If user and host names match, try to keep the password */
			if(user_name_match)
			{
				if(options->password != NULL)
				{
					free(options->password);
					options->password = NULL;
				}

				token = strtok(NULL," \t");
				if(token != NULL)
					options->password = strdup(token);
			}
		}
	}

	result = options;
	options = NULL;

 out:

	free_ssh_options(options);

	if(file != NULL)
		fclose(file);

	if(line != NULL)
		free(line);

	return(result);
}

/****************************************************************************/

/* Open an SSHv1 session given the parameters handed down from make_tunnel() to
   what would otherwise get passed to execve() at some point. Which we don't
   have, so we use the built-in SSHv1 client and muck around with the APR
   wrapper for sockets. */
struct ssh_protocol_context *
amiga_ssh(char ** args)
{
	struct ssh_protocol_context * result = NULL;
	struct ssh_options * options = NULL;
	struct ssh_protocol_context * ssh = NULL;
	size_t command_size;
	char * command = NULL;
	char * connect_to = NULL;
	char * user_name;
	char * host_name;
	char * password = NULL;
	struct servent * se;
	int port;
	int i;

	/* Get the default port number for ssh. */
	se = getservbyname("ssh","tcp");
	if(se != NULL)
		port = /*ntohs*/(se->s_port);
	else
		port = 22;

	/* We make the following assumptions about the parameters passed
	   to this function:

	   * args[0] contains the name of the 'ssh' command
	   * args[1] contains the user name and host name to be used for establishing an SSHv1 connection
	   * The remaining parameters contain the command to be executed on the remote server

	   The list of parameters is terminated with a NULL */

	/* Build the command line. Note that we expect to get away with stringing
	   the individual arguments together. */
	command_size = 0;

	for(i = 2 ; args[i] != NULL ; i++)
		command_size += strlen(args[i])+1;

	command = malloc(command_size+1);
	if(command == NULL)
	{
		fprintf(stderr,"SSH: Not enough memory.\n");
		goto out;
	}

	(*command) = '\0';

	for(i = 2 ; args[i] != NULL ; i++)
	{
		if((*command) == '\0')
		{
			strcpy(command,args[i]);
		}
		else
		{
			strcat(command," ");
			strcat(command,args[i]);
		}
	}

	/* Make a copy of the server parameters. We're going to chop them
	   into a user name and a host name. */
	connect_to = strdup(args[1]);
	if(connect_to == NULL)
	{
		fprintf(stderr,"SSH: Not enough memory.\n");
		goto out;
	}

	host_name = strchr(connect_to,'@');
	if(host_name == NULL)
	{
		fprintf(stderr,"SSH: No user name given for '%s'.\n",connect_to);
		goto out;
	}

	user_name = connect_to;
	(*host_name++) = '\0';

	/* Now try to read the connection options for this session. */
	options = read_ssh_options("subversion:sshconfig",user_name,host_name,port);

	/* If no options were provided, or no password, ask the user for it. */
	if(options == NULL || options->password == NULL)
	{
		char prompt[700];

		snprintf(prompt,sizeof(prompt),"Password for %s@%s: ",user_name,host_name);

		password = amiga_getpass(prompt);
		if(password == NULL)
			goto out;
	}

	/* Now try to open that SSHv1 session */
	ssh = ssh_connect(host_name,options != NULL ? options->port : port,user_name,password != NULL ? password : options->password,options != NULL ? options->cipher : SSH_CIPHER_3DES);
	if(ssh == NULL)
	{
		fprintf(stderr,"SSH: Connection to '%s@%s:%d' failed.\n",user_name,host_name,options != NULL ? options->port : port);
		goto out;
	}

	/* Finally, invoke that command. Which is probably going to be 'svnserve -t'. */
	if(ssh_execute_cmd(ssh,command) == -1)
	{
		fprintf(stderr,"SSH: Could not invoke command '%s'.\n",command);
		goto out;
	}

	result = ssh;
	ssh = NULL;

 out:

	if(ssh != NULL)
		ssh_disconnect(ssh);

	if(command != NULL)
		free(command);

	if(connect_to != NULL)
		free(connect_to);

	free_ssh_options(options);

	return(result);
}
