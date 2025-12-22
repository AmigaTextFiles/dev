/****************************************************************/
/* Utils unit                                                   */
/* (c) Christophe CALMEJANE (Ze KiLleR) - 1999-01               */
/****************************************************************/
#include "skyutils.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <stdarg.h>

#undef malloc
#undef calloc
#undef realloc
#undef strdup
#undef free

extern char *SW_UserHeader;
char *SU_DebugAppName = NULL;

#ifdef DUMP
int SU_DebugLevel = 5;
#elif DEBUG
int SU_DebugLevel = 4;
#else
int SU_DebugLevel = 0;
#endif

#ifdef _WIN32
FILE *SU_LogFile = NULL;
#endif /* _WIN32 */

FILE *SU_OpenLogFile(const char LogName[])
{
  return fopen(LogName,"at");
}

void SU_CloseLogFile(FILE *fp)
{
  if(fp != NULL)
    fclose(fp);
}

void SU_WriteToLogFile(FILE *fp,const char Text[])
{
  struct tm *TM;
  time_t Tim;

  if(fp != NULL)
  {
    Tim = time(NULL);
    TM = localtime(&Tim);
    fprintf(fp,"[%.4d/%.2d/%.2d-%.2d:%.2d:%.2d] %s\n",TM->tm_year+1900,TM->tm_mon+1,TM->tm_mday,TM->tm_hour,TM->tm_min,TM->tm_sec,Text);
  }
}

/* Skip the username and password, if present here.  The function
   should be called *not* with the complete URL, but with the part
   right after the protocol.

   If no username and password are found, return 0.  */
static int skip_uname (const char *url)
{
  const char *p;
  for (p = url; *p && *p != '/'; p++)
    if (*p == '@')
      break;
  /* If a `@' was found before the first occurrence of `/', skip
     it.  */
  if (*p == '@')
    return p - url + 1;
  else
    return 0;
}

static void parse_uname (const char *url, char *user, char *passwd)
{
  const char *p, *col;

  /* Is there an `@' character?  */
  for (p = url; *p && *p != '/'; p++)
    if (*p == '@')
      break;
  /* If not, return.  */
  if (*p != '@')
    return;

  /* Else find the username and password.  */
  for (p = col = url; *p != '@'; p++)
    {
      if (*p == ':')
        {
          memcpy (user, url, p - url);
          user[p - url] = '\0';
          col = p + 1;
        }
    }
  memcpy (passwd, col, p - col);
  passwd[p - col] = '\0';
}

/* Checks the http_proxy env var */
void SU_CheckProxyEnv(void)
{
  char *proxy_env,*tok;
  char  proxy_server_name[256];
  char  proxy_server_user[256];
  char  proxy_server_password[256];
  int   proxy_server_port=8080;

  proxy_env = getenv("http_proxy");
  if((proxy_env != NULL) && (strlen(proxy_env)>0))
  {
    char *proxy_save;
    char *proxy_val;

    memset(proxy_server_name,0,256);
    memset(proxy_server_user,0,256);
    memset(proxy_server_password,0,256);
    /*
     * Proxy URL is in the form :  [http://][user:password@]server:port[/]
     * Skip the "http://" if it's present
     */
    if(!strncasecmp(proxy_env,"http://",7)) proxy_env+=7;
    proxy_save = strdup(proxy_env);

    /*
     * Allow a username and password to be specified (i.e. just skip
     * them for now).
     */
    proxy_val = proxy_env+skip_uname (proxy_env);
    tok=strtok(proxy_val,":");
    if(tok) strncpy(proxy_server_name,tok,256);
    tok=strtok(NULL,"/");
    if(tok) proxy_server_port=atoi(tok);

    /* Parse the username and password (if existing).  */
    parse_uname (proxy_save, proxy_server_user, proxy_server_password);

    SU_SetProxy(proxy_server_name,proxy_server_port,proxy_server_user,proxy_server_password);
    free(proxy_save);
  }
}

/* Remove arguments for skyutils, and returns number of remaining arguments for smssend */
int SU_GetSkyutilsParams(int argc,char *argv[])
{
  int i = 1,nb;
  char *pos;
  int Port = 0;
  int Timeout = 0;
  int Lv = 0;
  char *ProxyName = NULL;
  char *UserName = NULL;
  char *Password = NULL;
  bool proxy = false;

  nb = argc;
  while(i < argc)
  {
    if(strcmp(argv[i],"--") == 0) /* SkyUtils arguments */
    {
      nb = i;
      i++;
      while(i < argc)
      {
        if(strcmp(argv[i],"--") == 0) /* No more SkyUtils arguments */
          break;
        else if(strncmp(argv[i],"-d",2) == 0) /* Debug level */
        {
          Lv = atoi(argv[i] + 2);
          SU_SetDebugLevel(argv[0],Lv);
        }
        else if(strncmp(argv[i],"-t",2) == 0) /* Socket timeout */
        {
          Timeout = atoi(argv[i] + 2);
          SU_SetSocketTimeout(Timeout);
        }
        else if(strncmp(argv[i],"-h",2) == 0) /* User's header file */
        {
          SW_UserHeader = SU_LoadUserHeaderFile(argv[i] + 2);
        }
        else if(strncmp(argv[i],"-p",2) == 0) /* Proxy name:port */
        {
          pos = strchr(argv[i],':');
          if(pos == NULL)
            printf("SkyUtils warning : Error parsing proxy argument for skyutils, disabling proxy\n");
          else
          {
            Port = atoi(pos+1);
            pos[0] = 0;
            ProxyName = argv[i] + 2;
          }
        }
        else if(strncmp(argv[i],"-u",2) == 0) /* Proxy user:pass */
        {
          pos = strchr(argv[i],':');
          if(pos == NULL)
            printf("SkyUtils warning : Error parsing proxy username argument for skyutils, disabling proxy\n");
          else
          {
            Password = pos + 1;
            pos[0] = 0;
            UserName = argv[i] + 2;
          }
        }
        i++;
      }
      break;
    }
    i++;
  }
  if((ProxyName == NULL) && (UserName != NULL))
  {
    printf("SkyUtils warning : Username for proxy specified, but no proxy given, disabling proxy\n");
  }
  else if(ProxyName != NULL)
  {
    SU_SetProxy(ProxyName,Port,UserName,Password);
    proxy = true;
  }
  if(!proxy)
    SU_CheckProxyEnv();
  return nb;
}

char *SU_LoadUserHeaderFile(const char FName[])
{
  FILE *fp;
  char *buf;
  char S[1024];
  int len;

  fp = fopen(FName,"rt");
  if(fp == NULL)
  {
    printf("SkyUtils warning : Cannot load user's header file %s\n",FName);
    return NULL;
  }
  buf = NULL;
  len = 1; /* For the \0 */
  while(SU_ReadLine(fp,S,sizeof(S)))
  {
    if(S[0] == 0)
      continue;
    len += strlen(S) + 2; /* +2 for \n */
    if(buf == NULL)
    {
      buf = (char *) malloc(len);
      SU_strcpy(buf,S,len);
    }
    else
    {
      buf = (char *) realloc(buf,len);
      SU_strcat(buf,S,len);
    }
    SU_strcat(buf,"\x0D" "\x0A",len);
  }
  fclose(fp);
  return buf;
}

char *SU_GetOptionsString(void)
{
  return "-pproxy:port -uusername:password -tTimeout -dDebugLevel -hHeaderFile";
}

#ifdef __unix__
bool SU_Daemonize(void)
{
  pid_t pid, sid;
  int fd;

  /* Fork to let the parent exit */
  pid = vfork();

  if(pid == -1 )
  {
    perror("Daemonize error : Couldn't fork");
    return false;
  }

  /* Now father exits */
  if(pid != 0)
    exit(0);

  /* Son is trying to become a session and group leader, by running in a new session */
  sid = setsid();

  if(sid == -1)
  {
    perror("Daemonize error : Couldn't setsid");
    return false;
  }

  /* We are now a group leader and a session leader, with no controlling terminal.
     We gonna fork again, and the parent will exit.
     So the son, as a non-session group leader won't be able to acquire a controlling terminal anymore. */
  pid = vfork ();

  if(pid == -1)
  {
    perror("Daemonize error : Couldn't fork");
    return false;
  }

  if(pid != 0 )
    exit(0);

  /* Son will now change it's working dir to /, in order to ensure that our daemon doesn't keep any
     directory in use (it would allow admin to unmount filesystem) */
  if(chdir("/") == -1)
  {
    perror("Daemonize error : Couldn't chdir('/')");
    return false;
  }

  /* Set the umask to 0 in order to be sure we create the files with right permissions */
  umask(0);

  /* Now close fd 0, 1 and 2 and opens 0 as /dev/null */
  fd=0;
  close(0);
  fd = open("/dev/null",O_RDONLY);
  if(fd == -1)
  {
    perror("Daemonize error : Couldn't open /dev/null");
    return false;
  }
  else if(fd != 0 )
  {
    perror("Daemonize warning : Trying to open /dev/null for stdin but returned file descriptor is not 0.");
    close(fd);
  }

  close(1);
  close(2);

  /* We now are a daemon stdin, stderr are closed */
  return true;
}

bool SU_SetUserGroup(const char User[],const char Group[])
{
  struct passwd *pw;
  struct group *gr;

  if(Group != NULL)
  {
    gr = getgrnam(Group);
    if(gr == NULL)
    {
      fprintf(stderr,"SkyUtils_SetUserGroup error : Group %s not found in /etc/passwd\n",Group);
      return false;
    }
    if(setgid(gr->gr_gid) != 0)
    {
      fprintf(stderr,"SkyUtils_SetUserGroup error : Cannot setgid to group %s : %s\n",Group,strerror(errno));
      return false;
    }
  }

  if(User != NULL)
  {
    pw = getpwnam(User);
    if(pw == NULL)
    {
      fprintf(stderr,"SkyUtils_SetUserGroup error : User %s not found in /etc/passwd\n",User);
      return false;
    }
    if(setuid(pw->pw_uid) != 0)
    {
      fprintf(stderr,"SkyUtils_SetUserGroup error : Cannot setuid to user %s : %s\n",User,strerror(errno));
      return false;
    }
  }

  return true;
}
#endif /* __unix__ */

void SU_PrintSyslog(int Level,char *Txt, ...)
{
  va_list argptr;
  char Str[4096];

  va_start(argptr,Txt);
#ifdef _WIN32
  _vsnprintf(Str,sizeof(Str),Txt,argptr);
#else /* _WIN32 */
  vsnprintf(Str,sizeof(Str),Txt,argptr);
#endif /* _WIN32 */
  va_end(argptr);
  SU_SYSLOG_FN(Level,Str);
}

#undef SU_PrintDebug
void SU_PrintDebug(int Level,char *Txt, ...)
{
  va_list argptr;
  char Str[4096];

  if(Level <= SU_DebugLevel)
  {
    va_start(argptr,Txt);
#ifdef _WIN32
    _vsnprintf(Str,sizeof(Str),Txt,argptr);
#else /* _WIN32 */
    vsnprintf(Str,sizeof(Str),Txt,argptr);
#endif /* _WIN32 */
    va_end(argptr);
    printf("%s(%d) : %s",SU_DebugAppName,Level,Str);
  }
}

void SU_SetDebugLevel(const char AppName[],const int Level)
{
  if(SU_DebugAppName != NULL)
    free(SU_DebugAppName);
  if(AppName == NULL)
    SU_DebugAppName = "SkyUtils";
  else
    SU_DebugAppName = strdup(AppName);
  SU_DebugLevel = Level;
}

int SU_GetDebugLevel(void)
{
  return SU_DebugLevel;
}


void SU_Dummy113(void) {}
void SU_Dummy114(void) {}
void SU_Dummy115(void) {}
