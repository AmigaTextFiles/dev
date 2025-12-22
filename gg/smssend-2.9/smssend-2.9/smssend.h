#ifndef __SMSSEND_H__
#define __SMSSEND_H__

#include <skyutils.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
//#include <unistd.h>

#define SMSSEND_VERSION "2.9"
#define SMSSEND_URL_SCRIPTS "http://zekiller.skytech.org/fichiers/smssend/"

#ifdef _WIN32
#define DATADIR "C:\\Program Files\\SkyTech\\"
#define SMSSEND_SHAREPATH DATADIR "SmsSend"
#else
#define DATADIR "/usr/local/share"
#define SMSSEND_SHAREPATH DATADIR "/smssend"
#endif

#define RUNTIME_URL    0
#define RUNTIME_PARAMS 1
#define RUNTIME_HOST   2
#define RUNTIME_DATA   3

typedef struct
{
  SU_PList Search; /* SMS_PSearch */
  SU_PList NoAdd; /* char * */
} SMS_TActUser, *SMS_PActUser;

typedef struct
{
  char *String;
  char *Msg;
  int Group;
  int Error;
} SMS_TSearch, *SMS_PSearch;

typedef struct
{
  char *Name;
  char *Value;
  char *Help;
  char *Alias;
  int Hidden;
  int Size;
  int Convert;
} SMS_TParam, *SMS_PParam;

typedef struct
{
  char *URL;
  char *Params;
  char *Host;
  char *Data;
} SMS_TRunTime, *SMS_PRunTime;

typedef struct
{
  SU_PCookie Cookie;
  int Phase;
} SMS_TCookie, *SMS_PCookie;

typedef struct
{
#ifndef __unix__
  char *Path;
#endif
  int NbParams;
  SMS_TParam *Params;
  SU_PList Act;     /* SU_PHTTPActions */
  SU_PList RunTime; /* SMS_PRunTime */
  SU_PList Cookies; /* SMS_PCookie */
} SMS_TProvider, *SMS_PProvider;

void GetHostFromURL(const char *URL,char Host[],int Length,bool proxy,char URL_OUT[],int *PortConnect,const char OtherHost[]);

#endif

