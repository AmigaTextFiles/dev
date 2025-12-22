/****************************************************************/
/* Skyutils functions - Chained list, socket, string, utils     */
/* (c) Christophe CALMEJANE (Ze KiLleR) - 1999-01               */
/****************************************************************/

#ifndef __SKY_UTILS_H__
#define __SKY_UTILS_H__

#define SKYUTILS_VERSION "1.15"

#ifdef __MACH__
#define __unix__
#endif /* __MACH__ */

#ifdef AMIGA
#define __unix__
#endif /* AMIGA OS */

#ifndef true
typedef unsigned char bool;
#define true 1
#define false 0
#endif /* true */

#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#ifndef _WIN32
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/stat.h>
#include <pwd.h>
#include <grp.h>
#else /* _WIN32 */
#include <winsock.h>
#define strcasecmp stricmp
#define strncasecmp strnicmp
#define snprintf _snprintf
#endif /* _WIN32 */

#ifdef MSG_NOSIGNAL
#define SU_MSG_NOSIGNAL MSG_NOSIGNAL
#else /* MSG_NOSIGNAL */
#define SU_MSG_NOSIGNAL 0
#endif /* MSG_NOSIGNAL */

#ifndef INADDR_NONE
#define INADDR_NONE -1
#endif /* INADDR_NONE */

#ifndef SOCKET_ERROR
#define SOCKET_ERROR -1
#endif /* SOCKET_ERROR */

#define SU_UDP_MAX_LENGTH 64000

/* **************************************** */
/*            Chained list functions        */
/* **************************************** */
struct SU_SList;

typedef struct SU_SList
{
  struct SU_SList *Next;
  void *Data;
} SU_TList, *SU_PList;

SU_PList SU_AddElementTail(SU_PList,void *);
SU_PList SU_AddElementHead(SU_PList,void *);
SU_PList SU_DelElementElem(SU_PList,void *); /* THIS FONCTION DOESN'T FREE THE ELEMENT */
SU_PList SU_DelElementTail(SU_PList); /* THIS FONCTION DOESN'T FREE THE ELEMENT */
SU_PList SU_DelElementHead(SU_PList); /* THIS FONCTION DOESN'T FREE THE ELEMENT */
SU_PList SU_DelElementPos(SU_PList,int); /* THIS FONCTION DOESN'T FREE THE ELEMENT */ /* First element is at pos 0 */
void *SU_GetElementTail(SU_PList);
void *SU_GetElementHead(SU_PList);
void *SU_GetElementPos(SU_PList,int); /* First element is at pos 0 */
void SU_FreeList(SU_PList); /* THIS FONCTION DOESN'T FREE THE ELEMENTS */
void SU_FreeListElem(SU_PList); /* THIS FONCTION DOES FREE THE ELEMENTS */
int SU_ListCount(SU_PList);


/* **************************************** */
/*               Socket functions           */
/* **************************************** */
typedef struct {
  int sock;
  struct sockaddr_in SAddr;
  void *User;
} SU_ServerInfo, *SU_PServerInfo;

typedef struct {
  int sock;
  struct sockaddr_in SAddr;
  void *User;
} SU_ClientSocket, *SU_PClientSocket;

int SU_GetPortByName(char *port,char *proto); /* Returns port number from it's name */
char *SU_GetMachineName(char *RemoteHost);    /* Extracts the machine name from a full host */
char *SU_NameOfPort(char *Host);              /* Returns the host name matching the given ip */
char *SU_AdrsOfPort(char *Host);              /* Returns the ip adrs mathing the given host */

SU_PServerInfo SU_CreateServer(int port,int type,bool ReUseAdrs); /* Returns NULL on error */
int SU_ServerListen(SU_PServerInfo SI); /* SOCKET_ERROR on Error */
SU_PClientSocket SU_ServerAcceptConnection(SU_PServerInfo SI); /* Returns NULL on error */
void SU_ServerDisconnect(SU_PServerInfo SI);
SU_PClientSocket SU_ClientConnect(char *adrs,char *port,int type); /* Returns NULL on error */
int SU_ClientSend(SU_PClientSocket CS,char *msg); /* SOCKET_ERROR on Error */
int SU_ClientSendBuf(SU_PClientSocket CS,char *buf,int len); /* SOCKET_ERROR on Error */
int SU_UDPSendBroadcast(SU_PServerInfo SI,char *Text,int len,char *port); /* SOCKET_ERROR on Error */
int SU_UDPSendToAddr(SU_PServerInfo SI,char *Text,int len,char *Addr,char *port); /* SOCKET_ERROR on Error */
int SU_UDPSendToSin(SU_PServerInfo SI,char *Text,int len,struct sockaddr_in); /* SOCKET_ERROR on Error */
int SU_UDPReceiveFrom(SU_PServerInfo SI,char *Text,int len,char **ip,int Blocking); /* SOCKET_ERROR on Error */
int SU_UDPReceiveFromSin(SU_PServerInfo SI,char *Text,int len,struct sockaddr_in *,int Blocking); /* SOCKET_ERROR on Error */
int SU_SetSocketOptions(int sock,int Level,int Opt); /* SOCKET_ERROR on Error */
#ifdef _WIN32
bool SU_WSInit(int Major,int Minor); /* Inits WinSocks (MUST BE CALL BEFORE ANY OTHER FUNCTION) */
void SU_WSUninit(void); /* Uninits WinSocks (MUST BE CALL BEFORE EXITING) */
#endif /* _WIN32 */


/* **************************************** */
/*               String functions           */
/* **************************************** */
char *SU_strcat(char *dest,const char *src,int len); /* like strncat, but always NULL terminate dest */
char *SU_strcpy(char *dest,const char *src,int len); /* like strncpy, but doesn't pad with 0, and always NULL terminate dest */
char *SU_nocasestrstr(char *text, char *tofind);  /* like strstr(), but nocase */
bool SU_strwcmp(const char *s,const char *wild); /* True if wild equals s (wild may use '*') */
bool SU_nocasestrwcmp(const char *s,const char *wild); /* Same as strwcmp but without case */
bool SU_ReadLine(FILE *fp,char S[],int len); /* Returns false on EOF */
bool SU_ParseConfig(FILE *fp,char Name[],int nsize,char Value[],int vsize); /* Returns false on EOF */
char *SU_TrimLeft(const char *S);
void SU_TrimRight(char *S);
char *SU_strparse(char *s,char delim); /* Like strtok, but if 2 consecutive delim are found, an empty string is returned (s[0] = 0) */
void SU_ExtractFileName(const char Path[],char FileName[],const int len); /* Extracts file name (with suffix) from path */
char *SU_strchrl(const char *s,const char *l,char *found); /* Searchs the first occurence of one char of l[i] in s, and returns it in found */
char *SU_strrchrl(const char *s,const char *l,char *found); /* Same as SU_strchrl but starting from the end of the string */
unsigned char SU_toupper(unsigned char c);
unsigned char SU_tolower(unsigned char c);
bool SU_strcasecmp(const char *s,const char *p);


/* **************************************** */
/*               Utils functions            */
/* **************************************** */
FILE *SU_OpenLogFile(const char LogName[]);
void SU_CloseLogFile(FILE *fp);
void SU_WriteToLogFile(FILE *fp,const char Text[]);
/* Checks the http_proxy env var */
void SU_CheckProxyEnv(void);
/* Remove arguments for skyutils, and returns number of remaining arguments for main */
/* This function automatically calls SU_CheckProxyEnv if no proxy found in params */
int SU_GetSkyutilsParams(int argc,char *argv[]);
char *SU_LoadUserHeaderFile(const char FName[]);
char *SU_GetOptionsString(void);
#ifdef __unix__
bool SU_Daemonize(void);
bool SU_SetUserGroup(const char User[],const char Group[]); /* If User and/or Group is != NULL, setuid and setgid are used */
#endif /* __unix__ */
void SU_SetDebugLevel(const char AppName[],const int Level);
int SU_GetDebugLevel(void);
void SU_PrintSyslog(int Level,char *Txt, ...);
void SU_PrintDebug(int Level,char *Txt, ...);
#ifndef DEBUG
#ifdef __unix__
#define SU_PrintDebug(x,...) //
#define SU_SYSLOG_FN(x,y) syslog(x,y)
#else /* __unix__ */
#define SU_PrintDebug //
extern FILE *SU_LogFile;
#define SU_SYSLOG_FN(x,y) SU_WriteToLogFile(SU_LogFile,y)
#endif /* __unix__ */
#else /* DEBUG */
#define SU_SYSLOG_FN(x,y) printf(y)
#endif /* DEBUG */

/* **************************************** */
/*              Memory functions            */
/* **************************************** */
#ifndef SU_MALLOC_ALIGN_SIZE
#define SU_MALLOC_ALIGN_SIZE 16
#else /* SU_MALLOC_ALIGN_SIZE */
#if SU_MALLOC_ALIGN_SIZE < 1
#error "SU_MALLOC_ALIGN_SIZE must be strictly greater than 1"
#endif /* SU_MALLOC_ALIGN_SIZE < 1 */
#endif /* SU_MALLOC_ALIGN_SIZE */
#define SU_MALLOC_KEY 0x5c
void *SU_malloc(long int size); /* Allocates a bloc of memory aligned on SU_MALLOC_ALIGN_SIZE */
void SU_free(void *memblock);   /* Frees a bloc previously allocated using SU_malloc */
#ifdef SU_MALLOC_TRACE
#undef calloc
#undef strdup
#define malloc(x) SU_malloc_trace(x,__FILE__,__LINE__)
#define calloc(x,y) SU_calloc_trace(x,y,__FILE__,__LINE__)
#define realloc(x,y) SU_realloc_trace(x,y,__FILE__,__LINE__)
#define strdup(x) SU_strdup_trace(x,__FILE__,__LINE__)
#define free(x) SU_free_trace(x,__FILE__,__LINE__)
#define trace_print SU_alloc_trace_print(true)
#define trace_print_count SU_alloc_trace_print(false)
#endif /* SU_MALLOC_TRACE */
void *SU_malloc_trace(long int size,char *file,int line);
void *SU_calloc_trace(long int nbelem,long int size,char *file,int line);
void *SU_realloc_trace(void *memblock,long int size,char *file,int line);
char *SU_strdup_trace(const char *in,char *file,int line);
void SU_free_trace(void *memblock,char *file,int line);
void SU_alloc_trace_print(bool detail);
/* SU_MALLOC_TRACE environment variable :
 *   0 or not defined : SU_free_trace does free trace of associated malloc
 *   1 : SU_free_trace keep trace of associated malloc, and display more debug information if block already freed
*/

/* **************************************** */
/*                 web functions            */
/* **************************************** */
#define ACT_GET    1
#define ACT_POST   2
#define ACT_PUT    3
#define ACT_DELETE 4

#define URL_BUF_SIZE 2048

typedef struct
{
  int Code;
  char *Location;

  char *Data;      /* NULL if no data */
  int Data_Length; /* -1 if no data */
  int Data_ToReceive;
} SU_TAnswer, *SU_PAnswer;

struct SU_SHTTPActions;

typedef struct
{
  void (*OnSendingCommand)(struct SU_SHTTPActions *); /* User's CallBack just before sending request */
  void (*OnAnswer)(SU_PAnswer,void *); /* User's CallBack just after answer received */
  void (*OnOk)(SU_PAnswer,void *); /* User's CallBack for a 200 reply */
  void (*OnCreated)(SU_PAnswer,void *); /* User's CallBack for a 201 reply */
  void (*OnModified)(SU_PAnswer,void *); /* User's CallBack for a 202 reply */
  void (*OnMoved)(SU_PAnswer,void *); /* User's CallBack for a 302 reply */
  void (*OnForbidden)(SU_PAnswer,void *); /* User's CallBack for a 403 reply */
  void (*OnNotFound)(SU_PAnswer,void *); /* User's CallBack for a 404 reply */
  void (*OnTooBig)(SU_PAnswer,void *); /* User's CallBack for a 413 reply */
  void (*OnUnknownHost)(SU_PAnswer,void *); /* User's CallBack for a 503 reply */
  void (*OnErrorSendingFile)(int,void *); /* User's CallBack for an error sending file (errno code passed) */
} SU_THTTP_CB, *SU_PHTTP_CB;

typedef struct SU_SHTTPActions
{ /* Info to set BEFORE any call to ExecuteActions */
  int  Command; /* ACT_xxx */
  char URL[URL_BUF_SIZE];
  char *URL_Params; /* ACT_GET & ACT_POST */
  char *Post_Data;  /* ACT_POST */
  int  Post_Length; /* ACT_POST */
  char *FileName;   /* ACT_PUT */ /* URL must contain the URL+New file name */ /* If defined for GET or POST, dump result to this file */
  char *Referer;
  void *User;       /* User's info Passed to Callbacks */
  int  Sleep;       /* Time to wait before sending command (sec) */
  SU_THTTP_CB CB;   /* Callbacks structure */

  /* Info used internally */
  char Host[100];
} SU_THTTPActions, *SU_PHTTPActions;

typedef struct
{
  char *Name;
  char *Value;
  char *Domain;
  char *Path;
  char *Expire;
  bool Secured;
} SU_TCookie, *SU_PCookie;

typedef struct
{
  char *Type;
  char *Name;
  char *Value;
} SU_TInput, *SU_PInput;

typedef struct
{
  char *Src;
  char *Name;
} SU_TImage, *SU_PImage;

typedef struct
{
  char *Method;
  char *Name;
  char *Action;
  SU_PList Inputs;
} SU_TForm, *SU_PForm;

/* Sets proxy server,port, user and password values to be used by ExecuteActions (use NULL for proxy to remove use of the proxy) */
void SU_SetProxy(const char Proxy[],const int Port,const char User[], const char Password[]);
/* Sets the socket connection timeout (use 0 to reset default value) */
void SU_SetSocketTimeout(const int Timeout);
/* Returns 0 if ok, -1 if cannot connect to the host, -2 if a timeout occured */
int SU_ExecuteActions(SU_PList Actions);
void SU_FreeAction(SU_PHTTPActions Act);

SU_PInput SU_GetInput(char *html);
SU_PInput SU_GetNextInput(void);
void SU_FreeInput(SU_PInput In);

SU_PImage SU_GetImage(char *html);
SU_PImage SU_GetNextImage(void);
void SU_FreeImage(SU_PImage Im);

void SU_FreeForm(SU_PForm Form);

/* Retrieves the url (into a SU_PHTTPActions struct) of the 'link' from the 'Ans' page associated with the 'URL' request */
SU_PHTTPActions SU_RetrieveLink(const char URL[],const char Ans[],const char link[]);
/* Retrieve link from a frameset */
SU_PHTTPActions SU_RetrieveFrame(const char URL[],const char Ans[],const char framename[]);
/* Retrieve document.forms[num] */
SU_PForm SU_RetrieveForm(const char Ans[],const int num);

char *SU_AddLocationToUrl(const char *URL,const char *Host,const char *Location);

/* Skips white spaces before the string, then extracts it */
char *SU_GetStringFromHtml(const char Ans[],const char TextBefore[]);

void SU_FreeCookie(SU_PCookie Cok);
extern SU_PList SW_Cookies; /* SU_PCookie */

/* **************************************** */
/*          win32 registry functions        */
/* **************************************** */
#ifdef _WIN32
void SU_RB_GetStrValue(const char Key[],char *buf,int buf_len,const char Default[]);
int SU_RB_GetIntValue(const char Key[],int Default);
bool SU_RB_SetStrValue(const char Key[],const char Value[]);
bool SU_RB_SetIntValue(const char Key[],int Value);
bool SU_RB_DelKey(const char Key[]);
bool SU_RB_DelValue(const char Key[]);
#endif /* _WIN32 */

/* Dummy functions used by configure, to check correct version of skyutils */
/* Remove old ones if compatibility has been broken */
void SU_Dummy113(void);
void SU_Dummy114(void);
void SU_Dummy115(void);

#endif /* __SKY_UTILS_H__ */

