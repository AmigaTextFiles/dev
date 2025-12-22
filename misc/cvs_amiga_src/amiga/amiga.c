/*
 * AmigaOS wrapper routines for GNU CVS, using bsdsocket.library TCP/IP API
 *
 * Originally written and adapted by
 *   Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 *   Jens Langner <Jens.Langner@light-speed.de>
 * Rewritten for PosixLib by
 *   Frank Wille <frank@phoenix.owl.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#pragma amiga-align
#include <exec/libraries.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#ifdef __amigaos4__
#include <dos/anchorpath.h>
#else
#include <dos/dosasl.h>
#endif
#include <proto/dos.h>
#include <proto/exec.h>
#pragma default-align

#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <time.h>
#include <errno.h>

#include "ssh_protocol.h"

#define MAXFD 0x1000      /* used to identify an ssh-protocol-context */

#define WILDNAMEBUF 256   /* expandwild file name buffer */

#define ZERO  ((BPTR)NULL)
#define SAME	(0)
#ifndef EPERM
#define EPERM 1
#endif


/****************************************************************************/

extern void	error(int,int,const char *,...);
extern void *xmalloc(size_t size);
extern char *xstrdup(const char * const str);
extern char *scramble(char *str);
extern char *descramble(char *str);
extern char *get_homedir(void);
extern int  getline(char **lineptr,size_t *n,FILE *stream);

/****************************************************************************/

long __stack = 8192;



void amiga_exit(void)
{
}


void amiga_init(int *argc,char ***argv)
{
#ifndef __amigaos4__
  /* we will need at least AmigaOS V37 */
  if (DOSBase->dl_lib.lib_Version < 37) {
    printf("cvs requires AmigaOS 2.04 (V37)!\n");
    exit(EXIT_FAILURE);
  }
#endif
  atexit(amiga_exit);
}


int amiga_expandwild(int nargs,char **args,char **argv)
{
  struct AnchorPath *ap;
  char *s;
  int i,n;

#ifdef __amigaos4__
  if (!(ap = (struct AnchorPath *)AllocDosObjectTags(DOS_ANCHORPATH,
                                                     ADO_Strlen,WILDNAMEBUF,
                                                     TAG_DONE)))
    return 0;
#else
  if (ap = (struct AnchorPath *)calloc(sizeof(struct AnchorPath)+WILDNAMEBUF,1)) {
    ap->ap_Strlen = WILDNAMEBUF;
    ap->ap_BreakBits = 0;
  }
  else
    return 0;
#endif

  for (i=n=0; i<nargs; i++) {

    if (!MatchFirst((STRPTR)args[i],ap)) {
      do {
        if (argv) {
#ifdef __amigaos4__
          if (s = malloc(strlen(ap->ap_Buffer)+1)) {
            strcpy(s,ap->ap_Buffer);
            argv[n] = s;
          }
          else {
            FreeDosObject(DOS_ANCHORPATH,ap);
            return 0;
          }
#else
          if (s = malloc(strlen(ap->ap_Buf)+1)) {
            strcpy(s,ap->ap_Buf);
            argv[n] = s;
          }
          else {
            free(ap);
            return 0;
          }
#endif
        }
        n++;
      }
      while (!MatchNext(ap));
    }

    else {
      /* no existing file name, just copy original string */
      if (argv)
        argv[n] = strdup(args[i]);
      n++;
    }
  }

#ifdef __amigaos4__
  FreeDosObject(DOS_ANCHORPATH,ap);
#else
  free(ap);
#endif

  return n;
}


int amiga_piped_child(char ** argv,int * to_fd_ptr,int * from_fd_ptr)
{
  int len,total_len,quotes,escape,argc,i,j;
  char * s;
  char * arg;
  char * command;

  BPTR input = ZERO;
  BPTR output = ZERO;
  char in_name[40];
  char out_name[40];
  int result = -1;

  argc = 0;
  total_len = 0;
  for(i = 0 ; argv[i] != NULL ; i++)
  {
    argc++;
    arg = argv[i];
    len = strlen(arg);
    quotes = 0;

    for(j = 0 ; j < len ; j++)
    {
      if(arg[j] == ' ' && quotes == 0)
        quotes = 2;
      else if (arg[j] == '\"')
        total_len++;
    }

    total_len += len + quotes + 1;
  }

  command = malloc(total_len+1);
  if(command == NULL)
  {
    errno = ENOMEM;
    return(-1);
  }

  s = command;

  for(i = 0 ; i < argc ; i++)
  {
    arg = argv[i];
    len = strlen(arg);
    quotes = escape = 0;

    for(j = 0 ; j < len ; j++)
    {
      if(arg[j] == ' ')
        quotes = 1;
      else if (arg[j] == '\"')
        escape = 1;

      if(quotes && escape)
        break;
    }

    if(quotes)
      (*s++) = '\"';

    for(j = 0 ; j < len ; j++)
    {
      if(arg[j] == '\"')
        (*s++) = '*';

      (*s++) = arg[j];
    }

    if(quotes)
      (*s++) = '\"';

    if(i < argc-1)
      (*s++) = ' ';
  }

  (*s) = '\0';

  sprintf(in_name, "PIPE:in_%08x.%08lx", (int)FindTask(NULL), time(NULL));
  sprintf(out_name, "PIPE:out_%08x.%08lx", (int)FindTask(NULL), time(NULL));

  input = Open(in_name,MODE_OLDFILE);
  output = Open(out_name,MODE_NEWFILE);
  if(input != ZERO && output != ZERO)
  {
    LONG res;

    res = SystemTags(command,
      SYS_Input,    input,
      SYS_Output,   output,
      SYS_Asynch,   TRUE,
      SYS_UserShell,  TRUE,
    TAG_END);

    switch(res)
    {
      case 0:
        (*to_fd_ptr) = open(in_name,O_WRONLY,0777);
        if((*to_fd_ptr) == -1)
          break;

        (*from_fd_ptr) = open(out_name,O_RDONLY,0777);
        if((*from_fd_ptr) == -1)
          break;

        result = 0;
        break;

      case -1:
        errno = ENOMEM;
        Close(input);
        Close(output);
        break;

      default:
        errno = EIO;
        break;
    }
  }
  else
  {
    if(input != ZERO)
      Close(input);

    if(output != ZERO)
      Close(output);

    errno = EIO;
  }

  return(result);
}


static int amiga_connect_ssh(char *host_name,char *user_name,char *password,
                             int cipher,int port)
{
  struct ssh_protocol_context *spc;

  spc = ssh_connect(host_name,port,user_name,password,cipher);
  if (spc == NULL) {
    errno = EACCES;
    return -1;
  }

  /* @@@ This is a hack!
     Return socket protocol context pointer instead of descriptor! */
  return (int)spc;
}


static int amiga_rcmd(char **remote_hostname,int remote_port,char *local_user,
                      char *remote_user,char *command)
{
  struct hostent *remote_hp;
  struct hostent *local_hp;
  struct sockaddr_in remote_isa;
  struct sockaddr_in local_isa;
  char local_hostname[80];
  char ch;
  int s;
  int local_port;
  int rs;

  remote_hp = gethostbyname(*remote_hostname);
  if(remote_hp == NULL)
  {
    fprintf(stderr,"Could not obtain address of remote host '%s' (%d, %s).\n",(*remote_hostname),errno,strerror(errno));
    exit(1);
  }

  /* Copy remote IP address into socket address structure */
  memset(&remote_isa,0,sizeof(remote_isa));
  remote_isa.sin_family = AF_INET;
  remote_isa.sin_port = htons(remote_port);
  memcpy(&remote_isa.sin_addr,remote_hp->h_addr,sizeof(remote_isa.sin_addr));

  gethostname(local_hostname,sizeof(local_hostname));
  local_hp = gethostbyname(local_hostname);
  if(local_hp == NULL)
  {
    fprintf(stderr,"Could not obtain local host address (%d, %s).\n",errno,strerror(errno));
    exit(1);
  }

  /* Copy local IP address into socket address structure */
  memset(&local_isa,0,sizeof(local_isa));
  local_isa.sin_family = AF_INET;
  memcpy(&local_isa.sin_addr,local_hp->h_addr,sizeof(local_isa.sin_addr));

  /* Create the local socket */
  s = socket(AF_INET,SOCK_STREAM,0);
  if(s < 0)
  {
    fprintf(stderr,"Socket creation failed (%d, %s).\n",errno,strerror(errno));
    exit(1);
  }

  /* Bind local socket with a port from IPPORT_RESERVED/2 to IPPORT_RESERVED - 1
   * this requires the OPER privilege under VMS -- to allow communication with
   * a stock rshd under UNIX
   */
  rs = 0;
  for(local_port = IPPORT_RESERVED - 1; local_port >= IPPORT_RESERVED/2; local_port--)
  {
    local_isa.sin_port = htons(local_port);
    rs = bind(s,(struct sockaddr *)&local_isa,sizeof(local_isa));
    if(rs == 0)
      break;
  }

  /* Bind local socket to an unprivileged port.  A normal rshd will drop the
   * connection; you must be running a patched rshd invoked through inetd for
   * this connection method to work
   */

  if(rs != 0)
  {
    for(local_port = IPPORT_USERRESERVED - 1;
        local_port > IPPORT_RESERVED;
        local_port--)
    {
      local_isa.sin_port = htons(local_port);
      rs = bind(s,(struct sockaddr *)&local_isa,sizeof(local_isa));
      if(rs == 0)
        break;
    }
  }

  rs = connect(s,(struct sockaddr *) &remote_isa,sizeof(remote_isa));
  if(rs == -1)
  {
    fprintf(stderr,"Could not connect to %s:%d (%d, %s).\n",(*remote_hostname),remote_port,errno,strerror(errno));
    close(s);
    exit(2);
  }

  /* Now supply authentication information */

  /* Auxiliary port number for error messages, we don't use it */
  send(s,"0\0",2,0);

  /* Who are we */
  send(s,local_user,strlen(local_user) + 1,0);

  /* Who do we want to be */
  send(s,remote_user,strlen(remote_user) + 1,0);

  /* What do we want to run */
  send(s,command,strlen(command) + 1,0);

  /* NUL is sent back to us if information is acceptable */
  if(recv(s,&ch,1,0) != 1)
    return(-1);

  if(ch != '\0')
  {
    errno = EPERM;
    return -1;
  }

  return s;
}


static char *cvs_server;
static char *command;


void amiga_start_server(int *tofd,int *fromfd,char *client_user,
                        char *server_user,char *server_host,
                        char *server_cvsroot)
{
  int fd,port;
  char *portenv;
  struct servent *sptr;
  char *shell_name;

  if (!(shell_name = getenv("CVS_RSH")))
    shell_name = "rsh";

  if (!(cvs_server = getenv("CVS_SERVER")))
    cvs_server = "cvs";

  command = xmalloc(strlen(cvs_server) + strlen(server_cvsroot) + 50);
  sprintf(command,"%s server",cvs_server);

  if (portenv = getenv("CVS_RCMD_PORT")) {
    port = atoi(portenv);
  }
  else {
    if (sptr = getservbyname("shell","tcp"))
      port = sptr->s_port;
    else
      port = 514; /* shell/tcp */
  }

  if (strcmp(shell_name,"ssh") == SAME || strcmp(shell_name,"ssh1") == SAME) {
    int cipher = SSH_CIPHER_3DES;
    int port = SSH_PORT;

    char *new_user_name = NULL;
    char *password = NULL;
    char *ssh_passfile;
    char *ssh_config_file;
    char *cvsrootstr;
    BOOL password_found_in_file = FALSE;

    /* Allocate local memory for the larger buffers. */
    cvsrootstr = xmalloc(1024);

    /* Load the defaults for this server, if a configuration file is provided. */
    ssh_config_file = getenv("CVS_SSH_CONFIGFILE");
    if(ssh_config_file != NULL) {
      FILE *fh;

      fh = fopen(ssh_config_file,"r");
      if(fh != NULL) {
        char * current_host_name = NULL;
        int line_length;
        char *linebuf = NULL;
        size_t linebuf_len = 0;
        char * token;
        
        while ((line_length = getline(&linebuf,&linebuf_len,fh)) >= 0) {
          /* Now we remove the finishing line feed. */
          while(line_length > 0 && linebuf[line_length-1] == '\n')
            linebuf[--line_length] = '\0';

          token = strtok(linebuf," \t");
          if (token != NULL) {
            if (strcasecmp(token,"host") == SAME ||
               strcasecmp(token,"server") == SAME) {
              if (current_host_name != NULL) {
                free(current_host_name);
                current_host_name = NULL;
              }

              token = strtok(NULL," \t");
              if(token != NULL)
                current_host_name = strdup(token);
            }
            else if (strcasecmp(token,"port") == SAME) {
              if (current_host_name != NULL &&
                 strcasecmp(server_host,current_host_name) == SAME) {
                token = strtok(NULL," \t");
                if(token != NULL) {
                  int n;

                  n = atoi(token);
                  if(1 <= n && n < 32768)
                    port = n;
                }
              }
            }
            else if (strcasecmp(token,"cipher") == SAME) {
              if (current_host_name != NULL &&
                  strcasecmp(server_host,current_host_name) == SAME) {
                token = strtok(NULL," \t");
                if (token != NULL && strcasecmp(token,"blowfish") == SAME)
                  cipher = SSH_CIPHER_BLOWFISH;
              }
            }
            else if (strcasecmp(token,"user") == SAME) {
              if (current_host_name != NULL &&
                  strcasecmp(server_host,current_host_name) == SAME) {
                if (new_user_name != NULL) {
                  free(new_user_name);
                  new_user_name = NULL;
                }

                token = strtok(NULL," \t");
                if (token != NULL)
                  new_user_name = strdup(token);
              }
            }
          }
        }

        if (linebuf != NULL)
          free(linebuf);

        if (current_host_name != NULL)
          free(current_host_name);

        if (new_user_name != NULL)
          server_user = new_user_name;

        fclose(fh);
      }
    }

    /* Now we check if the special CVS_SSH_PASSFILE variable is enabled.
     * Please note that it is ABSOLUTELY INSECURE to use this PASSFILE option.
     * It was added on user request, but we do not recommend to use it.
     */
    ssh_passfile = getenv("CVS_SSH_PASSFILE");
    if (ssh_passfile != NULL) {
      FILE *fh;

      sprintf(cvsrootstr,":server:%s@%s:%s ",(server_user ? server_user : client_user),server_host,server_cvsroot);

      /* Now we check if an entry exists in the passfile. */
      fh = fopen(ssh_passfile,"r");
      if (fh != NULL) {
        int line_length;
        char *linebuf = NULL;
        size_t linebuf_len = 0;

        while ((line_length = getline(&linebuf,&linebuf_len,fh)) >= 0) {
          /* Now we remove the finishing line feed. */
          while (line_length > 0 && linebuf[line_length-1] == '\n')
            linebuf[--line_length] = '\0';

          if (strncmp(linebuf,cvsrootstr,strlen(cvsrootstr)) == SAME) {
            char *passphrase = linebuf+strlen(cvsrootstr);

            if (passphrase[0] != 'A')
              error(1,0,"corrupt SSH passfile entry.");
            password = descramble(passphrase);
            password_found_in_file = TRUE;
            break;
          }
        }

        fclose(fh);

        if (linebuf != NULL)
          free(linebuf);
      }
    }

    if (password == NULL) {
      char *prompt;

      prompt = xmalloc(400);
      sprintf(prompt,"Password for %s@%s: ",
              (server_user ? server_user : client_user),server_host);
      password = getpass(prompt);
      free(prompt);
    }

    if (password != NULL) {
      char * cipher_name;
      char * port_number;

      cipher_name = getenv("CVS_SSH_CIPHER");
      if (cipher_name != NULL && strcasecmp(cipher_name,"blowfish") == SAME)
        cipher = SSH_CIPHER_BLOWFISH;

      if (port_number = getenv("CVS_SSH_PORT")) {
        int n;

        n = atoi(port_number);
        if (1 <= n && n < 32768)
          port = n;
      }

#ifdef DEBUG
      fprintf(stderr,"amiga_start_server(): connecting to %s:%d\n",
              server_host,port);

      fprintf(stderr,"local_user = %s, remote_user = %s, CVSROOT = %s, cipher = %s\n",
              client_user,(server_user ? server_user : client_user),
              server_cvsroot,(cipher == SSH_CIPHER_3DES) ? "3DES" : "Blowfish");
#endif

      fd = amiga_connect_ssh(server_host,
                             (server_user != NULL) ? server_user : client_user,
                             password,cipher,port);
      if (fd != -1) {
        /* We can now save the password in the passfile
         * unless it already exists.
         */
        if (ssh_passfile!=NULL && !password_found_in_file) {
          FILE *fh;

          /* Check if a entry exists in the passfile. */
          fh = fopen(ssh_passfile,"a");
          if (fh != NULL) {
            if (fprintf(fh,"%s%s\n",cvsrootstr,scramble(password)) < 0)
              error(1,errno,"could not write to '%s'",ssh_passfile);
            fclose(fh);
          }
          else
            error(1,errno,"could not open '%s' for writing",ssh_passfile);
        }

        if (ssh_execute_cmd((struct ssh_protocol_context *)fd,command)==-1) {
          close(fd);
          fd = -1;
        }
      }
      else {
        close(fd);
        fd = -1;
      }
    }
    else
      fd = -1;

    if (new_user_name != NULL)
      free(new_user_name);

    free(cvsrootstr);
  }  /* ssh */

  else {  /* rsh */
#ifdef DEBUG
    fprintf(stderr,"amiga_start_server(): connecting to %s:%d\n",
            server_host,port);
    fprintf(stderr,"local_user = %s, remote_user = %s, CVSROOT = %s\n",
            client_user,(server_user ? server_user : client_user),
            server_cvsroot);
#endif
    fd = amiga_rcmd(&server_host,port,
                    client_user,
                    (server_user ? server_user : client_user),
                    command);
  }

  if (fd < 0)
    error(1,errno,"could not start server via rcmd()");

  (*tofd) = fd;
  (*fromfd) = fd;

  free(command);
}


int amiga_close(int fd)
{
  if (fd >= MAXFD) {
    ssh_disconnect((struct ssh_protocol_context *)fd);
    return 0;
  }
  return close(fd);
}


int amiga_recv(int fd,void *buff,int nbytes,int flags)
{
  if (fd >= MAXFD)
    return ssh_read((struct ssh_protocol_context *)fd,buff,nbytes);

  return recv(fd,buff,nbytes,flags);
}


int amiga_send(int fd,void *buff,int nbytes,int flags)
{
  if (fd >= MAXFD)
    return ssh_write((struct ssh_protocol_context *)fd,buff,nbytes);

  return send(fd,buff,nbytes,flags);
}


int amiga_shutdown(int fd,int how)
{
  if (fd >= MAXFD) {
    struct ssh_protocol_context *spc = (struct ssh_protocol_context *)fd;

    fd = spc->spc_Socket;
  }
  return shutdown(fd,how);
}


int amiga_dup(int fd)
{
  if (fd >= MAXFD) {
    struct ssh_protocol_context *spc = (struct ssh_protocol_context *)fd;
    struct ssh_protocol_context *newspc;

    newspc = malloc(sizeof(*spc));
    if (newspc == NULL) {
      errno = ENOMEM;
      return -1;
    }
    memcpy(newspc,spc,sizeof(*spc));
    if (newspc->spc_Socket = dup(spc->spc_Socket))
      return (int)newspc;
    return -1;
  }

  return dup(fd);
}


void amiga_shutdown_server_input(int fd)
{
  if (amiga_shutdown(fd, 2)<0 && errno!=ENOTSOCK)
    error(1,0,"could not shutdown() input server connection");
  if (amiga_close(fd) < 0)
    error(1,0,"could not close() server connection");
}


void amiga_shutdown_server_output(int fd)
{
  if (amiga_shutdown(fd, 1)<0 && errno!=ENOTSOCK)
    error(1,0,"could not shutdown() output server connection");
}
