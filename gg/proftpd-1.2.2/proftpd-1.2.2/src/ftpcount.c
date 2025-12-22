/*
 * ProFTPD - FTP server daemon
 * Copyright (c) 1997, 1998 Public Flood Software
 * Copyright (C) 1999, 2000 MacGyver aka Habeeb J. Dihu <macgyver@tos.net>
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 *
 * As a special exemption, Public Flood Software/MacGyver aka Habeeb J. Dihu
 * and other respective copyright holders give permission to link this program
 * with OpenSSL, and distribute the resulting executable, without including
 * the source code for OpenSSL in the source distribution.
 */

/* Shows a count of "who" is online via proftpd.  Uses the /var/run/proftpd*
 * log files.
 *
 * $Id: ftpcount.c,v 1.12 2001/06/18 17:12:45 flood Exp $
 */

#include "conf.h"

#ifdef HAVE_GETOPT_H
# include <getopt.h>
#endif

#define MAX_CLASSES 100
struct Class
{
   char *Class;
   unsigned long Count;
};

static char *config_filename = CONFIG_FILE_PATH;

#ifdef BUILDAS_FTPWHO
static char *percent_complete(unsigned long size, unsigned long done)
{
  static char sbuf[32];

  memset(sbuf, '\0', sizeof(sbuf));
  if(done == 0) {
    sstrncpy(sbuf, "0", sizeof(sbuf));
  } else if(size == 0) {
    sstrncpy(sbuf, "Inf", sizeof(sbuf));
  } else if(done >= size) {
    sstrncpy(sbuf, "100", sizeof(sbuf));
  } else {
    snprintf(sbuf, sizeof(sbuf), "%.0f",
	     ((double)done / (double)size) * 100.0);
    sbuf[sizeof(sbuf) - 1] = '\0';
  }
  
  return sbuf;
}

static char *idle_time(time_t *i)
{
  time_t now;
  long l;
  static char sbuf[7];

  memset(sbuf, '\0', sizeof(sbuf));
  if(!i || !*i)
    return "-";
  else {
    time(&now);
    l = now - *i;

    if(l < 3600) 
      snprintf(sbuf, sizeof(sbuf), "%ldm%lds",(l / 60),(l % 60));
    else
      snprintf(sbuf, sizeof(sbuf), "%ldh%ldm",(l / 3600),
      ((l - (l / 3600) * 3600) / 60));
  }

  return sbuf;
}
#endif /* BUILDAS_FTPWHO */

/* scan_config_file() is a kludge for 1.2 which does a very simplistic attempt
 * at determining what the "ScoreboardPath" directive is set to.  It will be
 * replaced in 1.3 with the abstracted configure system (hopefully).
 * jss 3/9/2001
 */
static void scan_config_file(void)
{
  FILE *fp;
  char buf[1024] = "";
  char *cp,*path = NULL;
  
  if(!config_filename || (fp = fopen(config_filename,"r")) == NULL)
    return;

  while(!path && fgets(buf, sizeof(buf) - 1, fp)) {
    int i = strlen(buf);

    if(i && buf[i - 1] == '\n')
      buf[i-1] = '\0';

    for(cp = buf; *cp && isspace(*cp); cp++) ;
    if(*cp == '#' || !*cp)
      continue;

    i = strlen("ScoreboardPath");
    if(strncasecmp(cp,"ScoreboardPath",i) != 0)
      continue;

    /* Found it! */
    cp += i;

    /* strip whitespace */
    while(*cp && isspace(*cp)) cp++;
    
    path = cp;

    /* If the scoreboard path argument is quoted, dequote */
    if(*cp == '"') {
      char *src = cp;
      
      cp++;
      path++;

      while(*++src) {
        switch(*src) {
        case '\\': 
          if(*++src)
            *cp++ = *src;
          break;
        case '"':
          src++;
          break;
        default:
          *cp++ = *src;
        }
      }

      *cp = '\0';
    }
  }

  fclose(fp);

  /* If we got something out of all this, go ahead and set it. */
  if(path)
    log_run_setpath(path);
}

struct option_help {
  char *long_opt,*short_opt,*desc;
} opts_help[] = {
  { "--help","-h", NULL },
  { "--verbose","-v","display add'l information for each connection" },
  { "--path","-p","specify full path to scoreboard directory" },
  { "--config","-c","specify full path to proftpd configuration file" },
  { NULL }
};

struct option opts[] = {
  { "help",    0, NULL, 'h' },
  { "verbose", 0, NULL, 'v' },
  { "path",    1, NULL, 'p' },
  { "config",  1, NULL, 'c' },
  { NULL,      0, NULL, 0   }
};

void show_usage(const char *progname, int exit_code)
{
  struct option_help *h;

  printf("usage: %s [options]\n",progname);
  for(h = opts_help; h->long_opt; h++) {
    printf("  %s,%s\n",h->long_opt,h->short_opt);
    if(!h->desc)
      printf("    display %s usage\n",progname);
    else
      printf("    %s\n",h->desc);
  }

  exit(exit_code);
}

int main(int argc, char **argv)
{
  logrun_t *l;
  pid_t oldpid = 0,mpid;
  int c = 0,tot = 0,i;
  int verbose = 0;
  struct Class Classes[MAX_CLASSES];  
  char *cp,*progname = *argv;
  const char *cmdopts = "hp:v";
   
  memset(Classes,0,MAX_CLASSES*sizeof(struct Class));
   
  if((cp = rindex(progname,'/')) != NULL)
    progname = cp+1;

  opterr = 0;
  while((c = 
#ifdef HAVE_GETOPT_LONG
	 getopt_long(argc, argv, cmdopts, opts, NULL)
#else /* HAVE_GETOPT_LONG */
	 getopt(argc, argv, cmdopts)
#endif /* HAVE_GETOPT_LONG */
	 ) != -1) {
    switch(c) {
    case 'h':
      show_usage(progname,0);
    case 'v':
      verbose++; break;
    case 'p':
      log_run_setpath(optarg);
      break;
    case 'c':
      config_filename = strdup(optarg);
      break;
    case '?':
      fprintf(stderr,"unknown option: %c\n",(char)optopt);
      show_usage(progname,1);
    }
  }

  /* First attempt to check the supplied/default scoreboard path.  If this is
   * incorrect, try the config file kludge.
   * jss 3/9/2001
   */
  if(log_run_checkpath() < 0) {
    scan_config_file();
    
    if(log_run_checkpath() < 0) {
      fprintf(stderr,"%s: %s\n",log_run_getpath(),strerror(errno));
      fprintf(stderr,"(Perhaps you need to specify the scoreboard path with --path, or change\n");
      fprintf(stderr," the compile-time default directory?)\n");
      exit(1);
    }
  }
  
  c = 0;
  while((l = log_read_run(&mpid)) != NULL) {
    if(errno)
      break;

    if(!c++ || oldpid != mpid) {
      if(tot)
        printf("   -  %d user%s\n\n", tot, tot > 1 ? "s" : "");
      if(!mpid)
        printf("inetd FTP connections:\n");
      else
        printf("Master proftpd process %d:\n",(int)mpid);
      oldpid = mpid; tot = 0;
    }

#ifdef BUILDAS_FTPWHO
    /* We're really running as ftpwho.
     */
    if(l->transfer_size)
      printf("%5d %-6s (%s%%) %s\n", (int) l->pid, idle_time(&l->idle_since),
	     percent_complete(l->transfer_size, l->transfer_complete),
	     l->op);
    else
      printf("%5d %-6s %s\n", (int) l->pid, idle_time(&l->idle_since), l->op);
    
    if(verbose) {
      if(l->address[0])
	printf("             (host: %s)\n",l->address);
      if(l->cwd[0])
	printf("              (cwd: %s)\n",l->cwd);
    }
#endif

    for(i = 0; i != MAX_CLASSES; i++) {
      if(Classes[i].Class == 0) {
	Classes[i].Class = strdup(l->class);
	Classes[i].Count++;
        break;
      }
       
      if(strcasecmp(Classes[i].Class,l->class) == 0) {
	Classes[i].Count++; 
	break;
      }
    }
     
    tot++;
  }
  if(tot)
  {
    for(i = 0; i != MAX_CLASSES; i++) {
      if(Classes[i].Class == 0)
         break;
       printf("Service class %-20s - %3lu user%s\n",Classes[i].Class,Classes[i].Count,Classes[i].Count > 1 ? "s" : "");
    }
/* Probably pointless now, wu-ftp does not show a total      
       printf("Total         %-20s - %3lu user%s\n", "", tot, tot > 1 ? "s" : ""); */
  }
   
  return 0;
}
