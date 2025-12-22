/*
 * Return values :
 *  -1 -> Cannot connect to the host
 *  -2 -> Connection timed out
 *  -3 -> Provider not specified
 *  -4 -> Provider file not found or error in provider script
 *  -5 -> Arguments list requested
 *  -6 -> Missing Provider arguments (or too many)
 *  -7 -> Message is too long
 *  -8 -> Substitution error during execution
 *  -9 -> 404 from server
*/

#ifdef AMIGA
#define _CONSOLE 1
#define __unix__ 1
#endif

#ifndef _CONSOLE
#ifdef __unix__
#include "smssend.h"
#else
#include "mainsend.h"
#include "Unit1.h"
#endif
#else
#include "smssend.h"
#include "smssend.h"
#endif

#ifndef __unix__
#define strcasecmp stricmp
#define strncasecmp strnicmp
#endif

char MsgBufTempo[40000];
char BufTempo[40000];
SMS_PProvider CurrentProviderRunning;
int CurrentRunningPhase;
SU_PList CurrentNoAdd;
#ifdef __unix__
char *CurrentScriptCheckUpdateName;
char CurrentScriptCheckUpdateVersion[10];
bool SMS_Quiet = false;
int DebugLevel = 0;
SU_PList SMS_Alias = NULL;
#else
int Sms_ErrorCode;
#endif

#ifdef __unix__
//---------------------------------------------------------------------------
void CB_OnOkSmsSend(SU_PAnswer Ans,void *User)
{
  if(!SMS_Quiet)
  {
    if(strncmp(Ans->Data,SMSSEND_VERSION,3) > 0)
      printf("A new version of SmsSend is available at http://zekiller.skytech.org/smssend_menu_en.html\n");
    else
      printf("You already have the latest version of SmsSend\n");
  }
}

void CB_OnNotFoundSmsSend(SU_PAnswer Ans,void *User)
{
  if(!SMS_Quiet)
    printf("SmsSend Warning : Page not found\n");
}
//---------------------------------------------------------------------------
void CB_OnOk(SU_PAnswer Ans,void *User)
{
  FILE *fp;
  char *pos,*pos2,saf;
  char buf[1024];
  char FileName[512];

  pos = strstr(Ans->Data,"Version");
  if(pos == NULL)
  {
    if(!SMS_Quiet)
      printf("SmsSend Error : Version tag not found in %s script. Aborting\n",CurrentScriptCheckUpdateName);
    return;
  }
  pos+=8; // Zap "Version "
  pos2 = pos;
  while((pos2[0] != ' ') && (pos2[0] != 0x0A) && (pos2[0] != 0x0D) && (pos2[0] != '\t'))
    pos2++;
  saf = pos2[0];
  pos2[0] = 0;
#ifdef DEBUG
  printf("Your version : %s - Found version : %s\n",CurrentScriptCheckUpdateVersion,pos);
#endif
  if(strcmp(pos,CurrentScriptCheckUpdateVersion) <= 0)
  {
    if(!SMS_Quiet)
      printf("You already have the latest version of %s\n",CurrentScriptCheckUpdateName);
    return;
  }
  pos2[0] = saf;
  if(!SMS_Quiet)
    printf("A new version of %s was found, trying to update...\n",CurrentScriptCheckUpdateName);
  SU_ExtractFileName(CurrentScriptCheckUpdateName,FileName,sizeof(FileName));
  fp = fopen(CurrentScriptCheckUpdateName,"wt");
  if(fp == NULL)
  {
#ifndef _WIN32
    snprintf(buf,sizeof(buf),"%s/.smssend",getenv("HOME"));
    mkdir(buf,0xFFFF);
    snprintf(buf,sizeof(buf),"%s/.smssend/%s",getenv("HOME"),FileName);
    fp = fopen(buf,"wt");
    if(fp == NULL)
#endif
    {
      if(!SMS_Quiet)
        printf("SmsSend Error : Couldn't open %s. Aborting.\n",buf);
      return;
    }
    if(!SMS_Quiet)
      printf("SmsSend Warning : Couldn't open %s, saving new script to %s\n",CurrentScriptCheckUpdateName,buf);
  }
  fwrite(Ans->Data,1,Ans->Data_Length,fp);
  fclose(fp);
  if(!SMS_Quiet)
    printf("Successfully downloaded new version of %s\n",FileName);
}
void CB_OnNotFound(SU_PAnswer Ans,void *User)
{
  if(!SMS_Quiet)
    printf("SmsSend Warning : Page not found\n");
}
//---------------------------------------------------------------------------
void CheckForUpdateSmsSend(void)
{
  int ret;
  SU_PList Exec;
  SU_PHTTPActions Act;

  Exec = NULL;
  Act = (SU_PHTTPActions) malloc(sizeof(SU_THTTPActions));
  memset(Act,0,sizeof(SU_THTTPActions));
  Act->User = (void *)1;
  Act->Command = ACT_GET;
  snprintf(Act->URL,sizeof(Act->URL),"%s%s",SMSSEND_URL_SCRIPTS,"Version.unix");
  Act->CB.OnOk = CB_OnOkSmsSend;
  Act->CB.OnNotFound = CB_OnNotFoundSmsSend;
  Exec = SU_AddElementHead(Exec,Act);
  ret = SU_ExecuteActions(Exec);
  SU_FreeAction(Act);
  SU_FreeList(Exec);
  if(ret != 0)
  {
    if(!SMS_Quiet)
      printf("SmsSend Error : Cannot connect\n");
    return;
  }
}

void CheckForUpdate(const char Name[])
{
  int ret;
  SU_PList Exec;
  SU_PHTTPActions Act;
  FILE *fp;
  char FileName[512];
  char buf[1024];
  char *pos,*pos2;

  fp = fopen(Name,"rt");
  if(fp == NULL)
    return;
  fread(buf,1,sizeof(buf),fp);
  fclose(fp);
  pos = strstr(buf,"Version");
  if(pos == NULL)
    return;
  pos+=8; // Zap "Version "
  pos2 = pos;
  while((pos2[0] != ' ') && (pos2[0] != 0x0A) && (pos2[0] != 0x0D) && (pos2[0] != '\t'))
    pos2++;
  pos2[0] = 0;
  SU_strcpy(CurrentScriptCheckUpdateVersion,pos,sizeof(CurrentScriptCheckUpdateVersion));
  CurrentScriptCheckUpdateName = (char *)Name;

  Exec = NULL;
  Act = (SU_PHTTPActions) malloc(sizeof(SU_THTTPActions));
  memset(Act,0,sizeof(SU_THTTPActions));
  Act->User = (void *)1;
  Act->Command = ACT_GET;
  SU_ExtractFileName(Name,FileName,sizeof(FileName));
  snprintf(Act->URL,sizeof(Act->URL),"%s%s",SMSSEND_URL_SCRIPTS,FileName);
  Act->CB.OnOk = CB_OnOk;
  Act->CB.OnNotFound = CB_OnNotFound;

  Exec = SU_AddElementHead(Exec,Act);
  ret = SU_ExecuteActions(Exec);
  SU_FreeAction(Act);
  SU_FreeList(Exec);
  if(ret != 0)
  {
    if(!SMS_Quiet)
      printf("SmsSend Error : Cannot connect\n");
    return;
  }
}
#endif

void RemoveComments(char *Ans,long int len)
{
  char last,*tmp,*pos,*pos2;

  last = Ans[len-1];
  Ans[len-1] = 0;
  tmp = Ans;
  pos = strstr(tmp,"<!--");
  while(pos != NULL)
  {
    pos2 = strstr(pos,"-->");
    pos += 4;
    if(pos2 != NULL)
    {
      memset(pos,' ',pos2-pos);
    }
    tmp = pos;
    pos = strstr(tmp,"<!--");
  }

  Ans[len-1] = last;
}

void CB_Execute_SendingCommand(SU_PHTTPActions Act)
{
  SMS_PRunTime RT;

#ifdef __unix__
  if(DebugLevel >= 1)
    printf("Executing Phase %d\n",CurrentRunningPhase);
#else
  Form1->StatusBar1->SimpleText = (AnsiString)"Executing phase "+IntToStr(CurrentRunningPhase)+"...";
  Sms_ErrorCode = 0;
#endif

  if(CurrentProviderRunning->Cookies != NULL)
  {
    SU_PList Ptr;
    SMS_PCookie C;

    Ptr = CurrentProviderRunning->Cookies;
    C = NULL;
    while(Ptr != NULL)
    {
      C = (SMS_PCookie) Ptr->Data;
      if(C->Phase == CurrentRunningPhase)
      {
#ifdef __unix__
        if(DebugLevel >= 4)
          printf("Phase %d reached. Adding cookie %s\n",CurrentRunningPhase,C->Cookie->Name);
#endif
        SW_Cookies = SU_AddElementHead(SW_Cookies,C->Cookie);
        if(Ptr == CurrentProviderRunning->Cookies)
        {
          CurrentProviderRunning->Cookies = SU_DelElementHead(CurrentProviderRunning->Cookies);
          Ptr = CurrentProviderRunning->Cookies;
        }
        else
          Ptr = SU_DelElementHead(Ptr);
        free(C);
      }
      else
        Ptr = Ptr->Next;
    }
  }
  CurrentRunningPhase++;

  RT = (SMS_PRunTime) malloc(sizeof(SMS_TRunTime));
  memset(RT,0,sizeof(SMS_TRunTime));
  RT->URL = strdup(Act->URL);
  if(Act->URL_Params != NULL)
    RT->Params = strdup(Act->URL_Params);
  RT->Host = strdup(Act->Host);
#ifdef __unix__
  if(DebugLevel >= 4)
    printf("Adding RunTime variables : %s&%s (%s)\n",RT->URL,(RT->Params == NULL)?"":RT->Params,RT->Host);
#endif
  CurrentProviderRunning->RunTime = SU_AddElementTail(CurrentProviderRunning->RunTime,RT);
}

void CB_Execute_Answer(SU_PAnswer Ans,void *User)
{
  SMS_PRunTime RT;

  if(Ans->Data == NULL) /* Is there some data here ? */
    return;
#ifdef __unix__
  if(DebugLevel >= 4)
    printf("Adding RunTime data\n");
#endif
  RT = (SMS_PRunTime)SU_GetElementTail(CurrentProviderRunning->RunTime);
  if(RT == NULL)
  {
    printf("Warning : No runtime struct set.... shouldn't happen !\n");
  }
  else
  {
    RemoveComments(Ans->Data,Ans->Data_Length);
    RT->Data = (char *) malloc(Ans->Data_Length+1);
    memcpy(RT->Data,Ans->Data,Ans->Data_Length);
    RT->Data[Ans->Data_Length] = 0; /* Safer */
  }
}

void CB_Execute_404(SU_PAnswer Ans,void *User)
{
#ifdef __unix__
  if(!SMS_Quiet)
    printf("SmsSend Error : 404 answer from server.... error in the script ?\n");
  exit(-9);
#else
  Form1->StatusBar1->SimpleText = (AnsiString)"Error : 404 answer from server.... error in the script ?";
  Sms_ErrorCode = -9;
  return;
#endif
}

void CB_Execute_200(SU_PAnswer Ans,void *User)
{
  SU_PList Ptr;
  SMS_PSearch S;
  int Group;
  int Found;
  SMS_PActUser AU;

  AU = (SMS_PActUser) User;
  if(AU == NULL)
    return;
  Ptr = AU->Search;
  Found = 0;
  Group = -1;
  while(Ptr != NULL)
  {
    S = (SMS_PSearch)Ptr->Data;
    if(S->Group != Group)
    {
      Group = S->Group;
      Found = 0;
    }
    if(!Found)
    {
      if(S->String == NULL)
      {
        if(S->Error != 0)
        {
#ifdef __unix__
          if(!SMS_Quiet)
            printf("SmsSend Error : %s\n",S->Msg);
          exit(S->Error);
#else
          Form1->StatusBar1->SimpleText = (AnsiString)"Error : " + (AnsiString)S->Msg;
          Sms_ErrorCode = S->Error;
          return;
#endif
        }
        else
        {
#ifdef __unix__
          if(!SMS_Quiet)
#endif
            printf("Result : %s\n",S->Msg);
        }
        Found = 1;
      }
      else
      {
        if(Ans->Data != NULL)
        {
          if(strstr(Ans->Data,S->String) != NULL)
          {
            if(S->Error != 0)
            {
#ifdef __unix__
              if(!SMS_Quiet)
                printf("SmsSend Error : %s\n",S->Msg);
              exit(S->Error);
#else
              Form1->StatusBar1->SimpleText = (AnsiString)"Error : " + (AnsiString)S->Msg;
              Sms_ErrorCode = S->Error;
              return;
#endif
            }
            else
            {
#ifdef __unix__
              if(!SMS_Quiet)
#endif
                printf("Result : %s\n",S->Msg);
            }
            Found = 1;
          }
        }
      }
    }
    Ptr = Ptr->Next;
  }
}

char *CheckMessage(char Msg[],const int LenMax)
{
  int i,len,pos,val;
  char NB[10];

  len = strlen(Msg);
  if(len > LenMax)
  {
#ifdef __unix__
    if(!SMS_Quiet)
      printf("Message too long : %d caracters max (yours is %d long)\n",LenMax,len);
    exit(-7);
#else
    Form1->StatusBar1->SimpleText = "Message too long : "+IntToStr(LenMax)+" caracters max (yours is "+IntToStr(len)+" long)";
    Sms_ErrorCode = -7;
    return NULL;
#endif
  }
  pos = 0;
  for(i=0;i<len;i++)
  {
    if(Msg[i] == 0)
      continue;
    if((Msg[i] == ' ')/* || (Msg[i] == 0x0a) || (Msg[i] == 0x0d)*/)
      MsgBufTempo[pos++] = '+';
    else if(((Msg[i] >='A') && (Msg[i] <='Z')) || ((Msg[i] >='a') && (Msg[i] <='z')) || ((Msg[i] >='0') && (Msg[i] <='9')) || (Msg[i] == '.') || (Msg[i] == '-') || (Msg[i] == '_') || (Msg[i] == '*'))
      MsgBufTempo[pos++] = Msg[i];
    else if(Msg[i] == '\\')
    {
      NB[0] = Msg[i+1];
      NB[1] = Msg[i+2];
      NB[2] = 0;
      sscanf(NB,"%x",&val);
      printf("val:%d\n",val);
      Msg[i+1] = 0;
      Msg[i+2] = val;
    }
    else
    {
      MsgBufTempo[pos++] = '%';
      snprintf(NB,sizeof(NB),"%.2x",Msg[i]);
      MsgBufTempo[pos++] = NB[strlen(NB)-2];
      MsgBufTempo[pos++] = NB[strlen(NB)-1];
    }
  }
  MsgBufTempo[pos] = 0;
  return MsgBufTempo;
}

void FreeRunTime(SMS_PRunTime RT)
{
  if(RT->URL != NULL)
    free(RT->URL);
  if(RT->Params != NULL)
    free(RT->Params);
  if(RT->Host != NULL)
    free(RT->Host);
  if(RT->Data != NULL)
    free(RT->Data);
  free(RT);
}

void FreeRunTimeList(SU_PList RTL)
{
  SU_PList Ptr;

  Ptr = RTL;
  while(Ptr != NULL)
  {
    FreeRunTime((SMS_PRunTime)Ptr->Data);
    Ptr = Ptr->Next;
  }
  SU_FreeList(RTL);
}

void FreeProviderCookies(SU_PList Cookies)
{
  SU_PList Ptr;

  Ptr = Cookies;
  while(Ptr != NULL)
  {
    SU_FreeCookie(((SMS_PCookie)Ptr->Data)->Cookie);
    Ptr = Ptr->Next;
  }
  SU_FreeList(Cookies);
}

void FreeProvider(SMS_PProvider Pv)
{
  int i;
  SU_PList Ptr,Read;
  SMS_PSearch S;
  SMS_PActUser AU;

  if(Pv->Params != NULL)
  {
    for(i=0;i<Pv->NbParams;i++)
    {
      if(Pv->Params[i].Name != NULL)
        free(Pv->Params[i].Name);
      if(Pv->Params[i].Value != NULL)
        free(Pv->Params[i].Value);
      if(Pv->Params[i].Help != NULL)
        free(Pv->Params[i].Help);
      if(Pv->Params[i].Alias != NULL)
        free(Pv->Params[i].Alias);
    }
    free(Pv->Params);
  }
  Read = Pv->Act;
  while(Read != NULL)
  {
    AU = (SMS_PActUser) ((SU_PHTTPActions)Read->Data)->User;
    if(AU != NULL)
    {
      Ptr = AU->Search;
      while(Ptr != NULL)
      {
        S = (SMS_PSearch)Ptr->Data;
        if(S->String != NULL)
          free(S->String);
        free(S->Msg);
        free(S);
        Ptr = Ptr->Next;
      }
      SU_FreeList(AU->Search);
      SU_FreeListElem(AU->NoAdd);
    }
    SU_FreeAction((SU_PHTTPActions)Read->Data);
    Read = Read->Next;
  }
  if(Pv->Act != NULL)
    SU_FreeList(Pv->Act);
  if(Pv->RunTime != NULL)
    FreeRunTimeList(Pv->RunTime);
  if(Pv->Cookies != NULL)
    FreeProviderCookies(Pv->Cookies);
#ifndef __unix__
  if(Pv->Path != NULL)
    free(Pv->Path);
#endif
  free(Pv);
}

SMS_PProvider LoadProviderFile(const char FileName[])
{
  FILE *fp;
  char Name[1024],Value[1024],Saf[1024],*Str;
  SMS_PProvider Pv;
  int NbParams;
  int Group,i,found,Phase;
  SU_PHTTPActions Act;
  SU_PList SearchPtr,NoAddPtr;
  SU_PCookie Cookie;
  SMS_PSearch S;
  SMS_PCookie C;
  char *tmp;
  SMS_PActUser AU;

  fp = fopen(FileName,"rt");
  if(fp == NULL)
    return NULL;

  Pv = (SMS_PProvider) malloc(sizeof(SMS_TProvider));
  memset(Pv,0,sizeof(SMS_TProvider));
#ifndef __unix__
  Pv->Path = strdup(FileName);
#endif
  NbParams = 0;
  Group = 0;
  SearchPtr = NULL;
  NoAddPtr = NULL;
  Act = NULL;
  S = NULL;

  while(SU_ParseConfig(fp,Name,sizeof(Name),Value,sizeof(Value)))
  {
    if(strcasecmp(Name,"NbParams") == 0)
    {
      Pv->NbParams = atoi(Value);
      Pv->Params = (SMS_TParam *) malloc(Pv->NbParams*sizeof(SMS_TParam));
      memset(Pv->Params,0,Pv->NbParams*sizeof(SMS_TParam));
    }
    else if(Name[0] == '%')
    {
      if(NbParams >= Pv->NbParams)
      {
        printf("SmsSend Error in provider loader : More than NbParams has been found\n");
        FreeProvider(Pv);
        return NULL;
      }
      Pv->Params[NbParams].Name = strdup(Name+1);
      if(Value[0] != 0)
      {
        if(Value[0] == ':')
        {
          Pv->Params[NbParams].Help = strdup(SU_TrimLeft(Value+1));
        }
        strcpy(Saf,Value);
        Str = strtok(Value," ");
        while(Str != NULL)
        {
          if(strcasecmp(Str,"Hidden") == 0)
            Pv->Params[NbParams].Hidden = 1;
          else if(strcasecmp(Str,"Convert") == 0)
            Pv->Params[NbParams].Convert = 1;
          else if(strncasecmp(Str,"Size",4) == 0)
            Pv->Params[NbParams].Size = atoi(Str+5);
          else if(Str[0] == ':')
          {
            Str = strchr(Saf,':');
            Pv->Params[NbParams].Help = strdup(SU_TrimLeft(Str+1));
            break;
          }
          else
            printf("Unknown option in Param values : %s\n",Str);
          Str = strtok(NULL," ");
        }
      }
      NbParams++;
#ifndef __unix__
      if(NbParams > 8)
      {
        Application->MessageBox("This version of SmsSend doesn't support more than 8 parameters... If you really need more than 8, please contact me for an upgrade","SmsSend Error",MB_OK);
        FreeProvider(Pv);
        return NULL;
      }
#endif
    }
    else if(Name[0] == '$')
    {
      if(Value[0] == 0)
        printf("SmsSend Warning in provider loader : Alias value not found for %s\n",Name+1);
      else
      {
        found = 0;
        for(i=0;i<NbParams;i++)
        {
          if(strcasecmp(Pv->Params[i].Name,Name+1) == 0)
          {
#ifdef __unix__
            if(DebugLevel >= 4)
              printf("Adding alias : %s <-> %s\n",Name+1,Value);
#endif
            Pv->Params[i].Alias = strdup(Value);
            found = 1;
          }
        }
        if(found == 0)
          printf("SmsSend Warning in provider loader : Parameter %s not found for alias %s\n",Name+1,Value);
      }
    }
    else if(strcasecmp(Name,"GetURL") == 0)
    {
      if(Act != NULL)
        printf("SmsSend Warning in provider loader : Multiple GetURL/PostURL found in the same bloc : %s %s\n",Name,Value);
      Act = (SU_PHTTPActions) malloc(sizeof(SU_THTTPActions));
      memset(Act,0,sizeof(SU_THTTPActions));
      Act->Command = ACT_GET;
      SU_strcpy(Act->URL,Value,sizeof(Act->URL));
    }
    else if(strcasecmp(Name,"Params") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : Params found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      else
        Act->URL_Params = strdup(Value);
    }
    else if(strcasecmp(Name,"Referer") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : Referer found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      else
        Act->Referer = strdup(Value);
    }
    else if(strcasecmp(Name,"Dump") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : Dump found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      else
        Act->FileName = strdup(Value);
    }
    else if(strcasecmp(Name,"PostURL") == 0)
    {
      if(Act != NULL)
        printf("SmsSend Warning in provider loader : Multiple GetURL/PostURL found in the same bloc : %s %s\n",Name,Value);
      Act = (SU_PHTTPActions) malloc(sizeof(SU_THTTPActions));
      memset(Act,0,sizeof(SU_THTTPActions));
      Act->Command = ACT_POST;
      SU_strcpy(Act->URL,Value,sizeof(Act->URL));
    }
    else if(strcasecmp(Name,"PostData") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : PostData found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      else
      {
        Act->Post_Data = strdup(Value);
        Act->Post_Length = strlen(Act->Post_Data);
      }
    }
    else if(strcasecmp(Name,"Search") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : Search found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      Group++;
      S = (SMS_PSearch) malloc(sizeof(SMS_TSearch));
      memset(S,0,sizeof(SMS_TSearch));
      S->String = strdup(Value);
      S->Group = Group;
    }
    else if(strcasecmp(Name,"ElseSearch") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : ElseSearch found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      S = (SMS_PSearch) malloc(sizeof(SMS_TSearch));
      memset(S,0,sizeof(SMS_TSearch));
      S->String = strdup(Value);
      S->Group = Group;
    }
    else if(strcasecmp(Name,"Else") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : Else found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      S = (SMS_PSearch) malloc(sizeof(SMS_TSearch));
      memset(S,0,sizeof(SMS_TSearch));
      S->Group = Group;
    }
    else if(strcasecmp(Name,"ErrorMsg") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : ErrorMsg found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      if(S == NULL)
        printf("SmsSend Warning in provider loader : ErrorMsg defined without Search option : %s %s\n",Name,Value);
      else
      {
        tmp = strtok(Value," ");
        if(tmp == NULL)
          printf("SmsSend Warning in provider loader : Missing either Exit code or Error String : %s %s\n",Name,Value);
        else
        {
          S->Error = atoi(tmp);
          tmp = strtok(NULL,"\0");
          if(tmp == NULL)
            printf("SmsSend Warning in provider loader : Missing Error String : %s %s\n",Name,Value);
          else
          {
            S->Msg = strdup(tmp);
            SearchPtr = SU_AddElementTail(SearchPtr,S);
          }
        }
        S = NULL; /* Just in case */
      }
    }
    else if(strcasecmp(Name,"PrintMsg") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : PrintMsg found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      if(S == NULL)
        printf("SmsSend Warning in provider loader : PrintMsg defined without Search option : %s %s\n",Name,Value);
      else
      {
        S->Msg = strdup(Value);
        SearchPtr = SU_AddElementTail(SearchPtr,S);
        S = NULL; /* Just in case */
      }
    }
    else if(strcasecmp(Name,"GO") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : GO found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      else
      {
        if((SearchPtr != NULL) || (NoAddPtr != NULL))
        {
          AU = (SMS_PActUser) malloc(sizeof(SMS_TActUser));
          memset(AU,0,sizeof(SMS_TActUser));
          AU->Search = SearchPtr;
          AU->NoAdd = NoAddPtr;
          Act->User = AU;
          SearchPtr = NULL;
          NoAddPtr = NULL;
          Act->CB.OnNotFound = CB_Execute_404;
          Act->CB.OnOk = CB_Execute_200;
        }
        Act->CB.OnSendingCommand = CB_Execute_SendingCommand;
        Act->CB.OnAnswer = CB_Execute_Answer;
        Pv->Act = SU_AddElementTail(Pv->Act,Act);
        Act = NULL; /* Just in case */
      }
    }
    else if(strcasecmp(Name,"NoAdd") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : NoAdd found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      else
        NoAddPtr = SU_AddElementTail(NoAddPtr,strdup(Value));
    }
    else if(strcasecmp(Name,"Sleep") == 0)
    {
      if(Act == NULL)
        printf("SmsSend Warning in provider loader : Sleep found, but no GetURL/PostURL found in this bloc : %s %s\n",Name,Value);
      else
        Act->Sleep = atoi(Value);
    }
    else if(strcasecmp(Name,"SetCookie") == 0)
    {
      Cookie = (SU_PCookie) malloc(sizeof(SU_TCookie));
      memset(Cookie,0,sizeof(SU_TCookie));
      tmp = strtok(Value," ");
      if(tmp == NULL)
      {
        printf("SmsSend Warning in provider loader : Cookie has no phase, ignoring : %s\n",Value);
        SU_FreeCookie(Cookie);
        continue;
      }
      Phase = atoi(tmp);
      if(Phase == 0)
      {
        printf("SmsSend Warning in provider loader : Bad phase number for cookie (or not set) : %s\n",tmp);
        SU_FreeCookie(Cookie);
        continue;
      }
      tmp = strtok(NULL,"-");
      if(tmp == NULL)
      {
        printf("SmsSend Warning in provider loader : Cookie has no domain, ignoring : %s\n",Value);
        SU_FreeCookie(Cookie);
        continue;
      }
      Cookie->Domain = strdup(tmp);
      tmp = strtok(NULL,"-");
      if(tmp == NULL)
      {
        printf("SmsSend Warning in provider loader : Cookie has no path, ignoring : %s\n",Value);
        SU_FreeCookie(Cookie);
        continue;
      }
      Cookie->Path = strdup(tmp);
      tmp = strtok(NULL,"=");
      if(tmp == NULL)
      {
        printf("SmsSend Warning in provider loader : Cookie has no value, ignoring : %s\n",Value);
        SU_FreeCookie(Cookie);
        continue;
      }
      Cookie->Name = strdup(tmp);
      Cookie->Value = strdup(strtok(NULL,"\0"));

      //SW_Cookies = SU_AddElementHead(SW_Cookies,Cookie);
      C = (SMS_PCookie) malloc(sizeof(SMS_TCookie));
      memset(C,0,sizeof(SMS_TCookie));
      C->Phase = Phase;
      C->Cookie = Cookie;
      Pv->Cookies = SU_AddElementTail(Pv->Cookies,C);
#ifdef __unix__
      if(DebugLevel >= 4)
        printf("Adding cookie %s=%s for %s%s at phase %d\n",Cookie->Name,Cookie->Value,Cookie->Domain,Cookie->Path,Phase);
#endif
    }
    else
    {
      printf("SmsSend Warning in provider loader : Unknown option : %s %s\n",Name,Value);
    }
  }

  fclose(fp);

  return Pv;
}

char *GetRunTimeValue(SMS_PProvider Pv,char *Num,int Type)
{
  int val;
  SMS_PRunTime RT;

  val = atoi(Num);
  if(val == 0)
  {
    printf("Warning : RunTime value seems to be invalid (0) : %s\n",Num);
    return NULL;
  }
#ifdef __unix__
  if(DebugLevel >= 4)
    printf("Getting run time value from phase %d\n",val);
#endif
  RT = (SMS_PRunTime)SU_GetElementPos(Pv->RunTime,val-1); /* First Run time is 1, but first SU_PList element is 0 */
  if(RT == NULL)
  {
    printf("Warning : RunTime value not found in SU_PList at pos %d\n",val);
    return NULL;
  }
  switch(Type)
  {
    case RUNTIME_URL : return RT->URL;
    case RUNTIME_PARAMS : return RT->Params;
    case RUNTIME_HOST : return RT->Host;
    case RUNTIME_DATA : return RT->Data;
    default : return NULL;
  }
}

char *TranslateString(char *Strng,SMS_PProvider Pv)
{
  int i,pos,found,do_it,read,j;
  char *p,*str=NULL,*S,*saf,*hst;
  char *data,*q;
  SU_PHTTPActions Act = NULL;
  char buf[20000];
  char fbuf[40000];
  char cmd[1024];
  char *tmpname,*tmpname2;
  SU_PInput In;
  SU_PForm Form;
  SU_PList Ptr,Ptr2,InputGet = NULL;
  FILE *fp_out;

  saf = strdup(Strng);
  S = saf;
  BufTempo[0] = 0;
  pos = 0;
  while(*S != 0)
  {
    if((*S == '\\') && (S[1] == '%'))
    {
      S+=2;
      found = -1;
      p = strchr(S,'%');
      if(p != NULL)
      {
        p[0] = 0;
        p++;
        if(strncasecmp(S,"RTURL-",6) == 0)
        {
          str = GetRunTimeValue(Pv,S+6,RUNTIME_URL);
          if(str != NULL)
            found = 0;
        }
        else if(strncasecmp(S,"RTParams-",9) == 0)
        {
          str = GetRunTimeValue(Pv,S+9,RUNTIME_PARAMS);
          if(str != NULL)
            found = 0;
        }
        else if(strncasecmp(S,"RTHost-",7) == 0)
        {
          str = GetRunTimeValue(Pv,S+7,RUNTIME_HOST);
          if(str != NULL)
            found = 0;
        }
        else if(strncasecmp(S,"RTFollowLink-",13) == 0)
        {
          q = strchr(S+13,'-');
          if(q != NULL)
          {
            q[0] = 0;q++;
            str = GetRunTimeValue(Pv,S+13,RUNTIME_URL);
            data = GetRunTimeValue(Pv,S+13,RUNTIME_DATA);
            if((str != NULL) && (data != NULL))
            {
              Act = SU_RetrieveLink(str,data,q);
              if(Act != NULL)
              {
                found = 0;
                SU_strcpy(buf,Act->URL,sizeof(buf));
                str = buf;
                SU_FreeAction(Act);
              }
            }
          }
        }
        else if(strncasecmp(S,"RTFollowFrame-",14) == 0)
        {
          q = strchr(S+14,'-');
          if(q != NULL)
          {
            q[0] = 0;q++;
            str = GetRunTimeValue(Pv,S+14,RUNTIME_URL);
            data = GetRunTimeValue(Pv,S+14,RUNTIME_DATA);
            if((str != NULL) && (data != NULL))
            {
              Act = SU_RetrieveFrame(str,data,q);
              if(Act != NULL)
              {
                found = 0;
                SU_strcpy(buf,Act->URL,sizeof(buf));
                str = buf;
                SU_FreeAction(Act);
              }
            }
          }
        }
        else if(strncasecmp(S,"RTGetInput-",11) == 0)
        {
          q = strchr(S+11,'-');
          if(q != NULL)
          {
            q[0] = 0;q++;
            data = GetRunTimeValue(Pv,S+11,RUNTIME_DATA);
            if(data != NULL)
            {
              In = SU_GetInput(data);
              while(In != NULL)
              {
                if(strcasecmp(In->Name,q) == 0)
                {
                  InputGet = SU_AddElementHead(InputGet,strdup(In->Name));
                  found = 0;
                  SU_strcpy(buf,In->Value,sizeof(buf));
                  str = buf;
                  SU_FreeInput(In);
                  break;
                }
                SU_FreeInput(In);
                In = SU_GetNextInput();
              }
            }
          }
        }
        else if(strncasecmp(S,"RTGetInput2-",12) == 0)
        {
          q = strchr(S+12,'-');
          if(q != NULL)
          {
            q[0] = 0;q++;
            data = GetRunTimeValue(Pv,S+12,RUNTIME_DATA);
            if(data != NULL)
            {
              i = 1;
              j = atoi(q);
              In = SU_GetInput(data);
              while(In != NULL)
              {
                if(i == j)
                {
                  InputGet = SU_AddElementHead(InputGet,strdup(In->Name));
                  found = 0;
                  snprintf(buf,sizeof(buf),"\"%s\"=\"%s\"",In->Name,In->Value);
                  str = buf;
                  SU_FreeInput(In);
                  break;
                }
                SU_FreeInput(In);
                In = SU_GetNextInput();
                i++;
              }
            }
          }
        }
        else if(strncasecmp(S,"RTFormAction-",13) == 0)
        {
          q = strchr(S+13,'-');
          if(q != NULL)
          {
            q[0] = 0;q++;
            data = GetRunTimeValue(Pv,S+13,RUNTIME_DATA);
            if(data != NULL)
            {
              Form = SU_RetrieveForm(data,atoi(q));
              if(Form != NULL)
              {
                if(strncmp(Form->Action,"http://",7) != 0) /* If Action is relative */
                {
                  str = GetRunTimeValue(Pv,S+13,RUNTIME_URL);
                  hst = GetRunTimeValue(Pv,S+13,RUNTIME_HOST);
                  if((str != NULL) && (hst != NULL))
                  {
                    str = SU_AddLocationToUrl(str,hst,Form->Action);
                    SU_strcpy(fbuf,str,sizeof(fbuf));
                    free(str);
                    found = 0;
                  }
                }
                else
                {
                  SU_strcpy(fbuf,Form->Action,sizeof(fbuf));
                  found = 0;
                }
                str = fbuf;
                SU_FreeForm(Form);
              }
            }
          }
        }
        else if(strncasecmp(S,"RTGetForm-",10) == 0)
        {
          q = strchr(S+10,'-');
          if(q != NULL)
          {
            q[0] = 0;q++;
            data = GetRunTimeValue(Pv,S+10,RUNTIME_DATA);
            if(data != NULL)
            {
              Form = SU_RetrieveForm(data,atoi(q));
              if(Form != NULL)
              {
                Ptr = Form->Inputs;
                fbuf[0] = 0;
                while(Ptr != NULL)
                {
                  In = (SU_PInput)Ptr->Data;
                  do_it = true;
                  Ptr2 = InputGet;
                  while(Ptr2 != NULL)
                  {
                    if(In->Name != NULL)
                    {
                      if(strcasecmp((char *)Ptr2->Data,In->Name) == 0)
                      {
#ifdef __unix__
                        if(DebugLevel >= 4)
                          printf("Not adding %s input, because already added by script\n",In->Name);
#endif
                        do_it = false;
                        break;
                      }
                    }
                    Ptr2 = Ptr2->Next;
                  }
                  if(do_it)
                  {
                    Ptr2 = CurrentNoAdd;
                    while(Ptr2 != NULL)
                    {
                      if(In->Name != NULL)
                      {
                        if(strcasecmp((char *)Ptr2->Data,In->Name) == 0)
                        {
  #ifdef __unix__
                          if(DebugLevel >= 4)
                            printf("Not adding %s input, because set to NoAdd state by script\n",In->Name);
  #endif
                          do_it = false;
                          break;
                        }
                      }
                      Ptr2 = Ptr2->Next;
                    }
                  }
                  if(do_it)
                  {
#ifdef __unix__
                    if(DebugLevel >= 4)
                      printf("Adding %s input from form %d\n",In->Name,atoi(q));
#endif
                    if(fbuf[0] != 0)
                      SU_strcat(fbuf,"&",sizeof(fbuf));
                    if(strcasecmp(In->Type,"image") == 0)
                    {
                      if(In->Name != NULL)
                      {
                        SU_strcat(fbuf,In->Name,sizeof(fbuf));
                        SU_strcat(fbuf,".",sizeof(fbuf));
                      }
                      SU_strcat(fbuf,"x=1",sizeof(fbuf));
                      SU_strcat(fbuf,"&",sizeof(fbuf));
                      if(In->Name != NULL)
                      {
                        SU_strcat(fbuf,In->Name,sizeof(fbuf));
                        SU_strcat(fbuf,".",sizeof(fbuf));
                      }
                      SU_strcat(fbuf,"y=1",sizeof(fbuf));
                    }
                    else
                    {
                      SU_strcat(fbuf,In->Name,sizeof(fbuf));
                      SU_strcat(fbuf,"=",sizeof(fbuf));
                      if(In->Value != NULL)
                        SU_strcat(fbuf,In->Value,sizeof(fbuf));
                    }
                  }
                  Ptr = Ptr->Next;
                }
                SU_FreeForm(Form);
                found = 0;
                str = fbuf;
              }
            }
          }
        }
        else if(strncasecmp(S,"RTExec-",7) == 0)
        {
          q = strchr(S+7,'-');
          if(q != NULL)
          {
            q[0] = 0;q++;
            data = GetRunTimeValue(Pv,S+7,RUNTIME_DATA);
            if(data != NULL)
            {
              tmpname = tmpnam(NULL);
              if(tmpname != NULL)
              {
                fp_out = fopen(tmpname,"wb");
                if(fp_out != NULL)
                {
                  fwrite(data,strlen(data),1,fp_out);
                  fclose(fp_out);
                  tmpname2 = strdup(tmpname);
                  tmpname = tmpnam(NULL);
                  if(tmpname != NULL)
                  {
                    snprintf(cmd,sizeof(cmd),"more %s | %s > %s",tmpname2,q,tmpname);
#ifdef DEBUG
                    printf("Executing command : %s\n",cmd);
#endif
                    system(cmd);
                    fp_out = fopen(tmpname,"rb");
                    if(fp_out != NULL)
                    {
                      read = fread(fbuf,1,sizeof(fbuf)-1,fp_out);
                      fclose(fp_out);
                      fbuf[read] = 0;
                      read--;
                      while((fbuf[read] == 0x0A) || (fbuf[read] == 0x0D))
                      {
                        fbuf[read] = 0;
                        read--;
                      }
#ifdef DEBUG
                      printf("Returned buffer : %s\n",fbuf);
#endif
                      str = fbuf;
                      found = 0;
                    }
                    unlink(tmpname);
                  }
                  unlink(tmpname2);
                  free(tmpname2);
                }
              }
            }
          }
        }
        else if(strncasecmp(S,"RTGetString-",12) == 0)
        {
          q = strchr(S+12,'-');
          if(q != NULL)
          {
            q[0] = 0;q++;
            data = GetRunTimeValue(Pv,S+12,RUNTIME_DATA);
            if(data != NULL)
            {
              str = SU_GetStringFromHtml(data,q);
              if(str != NULL)
              {
                found = 0;
                SU_strcpy(buf,str,sizeof(buf));
#ifdef DEBUG
                printf("String found : %s\n",buf);
#endif
                free(str);
                str = buf;
              }
            }
          }
        }
        else if(strncasecmp(S,"RTSubURL-",9) == 0)
        {
          q = strchr(S+9,'-');
          if(q != NULL)
          {
            q[0] = 0;q++;
            data = GetRunTimeValue(Pv,S+9,RUNTIME_URL);
            if(data != NULL)
            {
              SU_strcpy(buf,data,sizeof(buf));
              data = buf;
              i = atoi(q);
              data = strstr(data,"://");
              if((data != NULL) && (i != 0))
              {
                data = strchr(data+3,'/'); /* Skip host name */
                if(data != NULL)
                {
                  data++; /* Ready to parse */
                  while(i > 0)
                  {
                    i--;
                    q = strchr(data,'/');
                    if(q == NULL)
                    {
                      if(i != 0) /* Not enough '/' */
                        break;
                      if(data[0] == 0) /* Ending '/' */
                        break;
                      found = 0;
                      str = data;
                      break;
                    }
                    if(i == 0)
                    {
                      q[0] = 0;
                      found = 0;
                      str = data;
                      break;
                    }
                    data = q + 1;
                  }
                }
#ifdef DEBUG
                if(found == 0)
                  printf("SubURL found : %s\n",str);
#endif
              }
            }
          }
        }
        else
        {
          for(i=0;i<Pv->NbParams;i++)
          {
            if(strcasecmp(S,Pv->Params[i].Name) == 0)
            {
              found = i;
              if(Pv->Params[i].Alias != NULL)
                InputGet = SU_AddElementHead(InputGet,strdup(Pv->Params[i].Alias));
              else
                InputGet = SU_AddElementHead(InputGet,strdup(Pv->Params[i].Name));
              break;
            }
          }
          if(found == -1)
          {
            SU_FreeListElem(InputGet);
#ifdef __unix__
            printf("SmsSend Error in Execute : Substitution name not found in params : %s\n",S);
            free(saf);
            exit(-8);
          }
#else
            Form1->StatusBar1->SimpleText = (AnsiString)"Error in Execute : Substitution name not found in params : " + (AnsiString)S;
            free(saf);
            Sms_ErrorCode = -8;
            return NULL;
          }
          Sms_ErrorCode = 0;
#endif
          if(Pv->Params[found].Convert || (Pv->Params[found].Size != 0))
            str = CheckMessage(Pv->Params[found].Value,(Pv->Params[found].Size == 0)?512:Pv->Params[found].Size);
          else
            str = Pv->Params[found].Value;
#ifndef __unix__
          if(Sms_ErrorCode != 0)
          {
            SU_FreeListElem(InputGet);
            free(saf);
            return NULL;
          }
#endif
        }
      }
      if(found == -1)
      {
        SU_FreeListElem(InputGet);
#ifdef __unix__
        printf("SmsSend Error in Execute : Substitution name not found in params : %s\n",S);
        free(saf);
        exit(-8);
#else
        Form1->StatusBar1->SimpleText = (AnsiString)"Error in Execute : Substitution name not found in params : " + (AnsiString)S;
        free(saf);
        Sms_ErrorCode = -8;
        return NULL;
#endif
      }
      strcpy(&BufTempo[pos],str);
      pos = strlen(BufTempo);
      S = p;
    }
    else
    {
      BufTempo[pos++] = *S;
      S++;
    }
  }
  BufTempo[pos++] = 0;
  SU_FreeListElem(InputGet);
  free(saf);
  return BufTempo;
}

#ifdef __unix__
void ExecuteProvider(SMS_PProvider Pv)
#else
int ExecuteProvider(SMS_PProvider Pv)
#endif
{
  SU_PList Exec,Read;
  SU_PHTTPActions Act;
  int ret;
  char *tmp;

  CurrentProviderRunning = Pv;
  CurrentRunningPhase = 1;
  if(Pv->RunTime != NULL)
  {
    FreeRunTimeList(Pv->RunTime);
    Pv->RunTime = NULL;
  }
  Read = Pv->Act;
  while(Read != NULL)
  {
    Act = (SU_PHTTPActions) malloc(sizeof(SU_THTTPActions));
    memcpy(Act,Read->Data,sizeof(SU_THTTPActions));
    if(Act->User != NULL) /* SMS_PActUser struct not null */
      CurrentNoAdd = ((SMS_PActUser)Act->User)->NoAdd;
    else
      CurrentNoAdd = NULL;
    if(((SU_PHTTPActions)Read->Data)->FileName != NULL)
      Act->FileName = strdup(((SU_PHTTPActions)Read->Data)->FileName);
    if(Act->Referer != NULL)
    {
#ifdef __unix__
      Act->Referer = strdup(TranslateString(Act->Referer,Pv));
#else
      tmp = TranslateString(Act->Referer,Pv);
      if(tmp == NULL)
        return Sms_ErrorCode;
      Act->Referer = strdup(tmp);
#endif
    }
    Exec = NULL;
    tmp = TranslateString(Act->URL,Pv);
#ifndef __unix__
    if(tmp == NULL)
      return Sms_ErrorCode;
#endif
    SU_strcpy(Act->URL,tmp,sizeof(Act->URL));
    if(Act->URL_Params != NULL)
    {
#ifdef __unix__
      Act->URL_Params = strdup(TranslateString(Act->URL_Params,Pv));
#else
      tmp = TranslateString(Act->URL_Params,Pv);
      if(tmp == NULL)
        return Sms_ErrorCode;
      Act->URL_Params = strdup(tmp);
#endif
    }
    if(Act->Post_Data != NULL)
    {
#ifdef __unix__
      Act->Post_Data = strdup(TranslateString(Act->Post_Data,Pv));
#else
      tmp = TranslateString(Act->Post_Data,Pv);
      if(tmp == NULL)
        return Sms_ErrorCode;
      Act->Post_Data = strdup(tmp);
#endif
      Act->Post_Length = strlen(Act->Post_Data);
    }

    Exec = SU_AddElementHead(Exec,Act);
#ifndef __unix__
    Sms_ErrorCode = 0;
#endif
    ret = SU_ExecuteActions(Exec);
    SU_FreeAction(Act);
    SU_FreeList(Exec);
#ifdef __unix__
    if(ret != 0)
      exit(ret);
#else
    if(ret != 0)
      return ret;
    if(Sms_ErrorCode != 0)
      return Sms_ErrorCode;
#endif
    Read = Read->Next;
  }
#ifndef __unix__
  return 0;
#endif
}

#ifdef __unix__
void LoadAliases(const char FileName[])
{
  FILE *fp;
  char S[1024];

  if(SMS_Alias != NULL)
  {
    SU_FreeListElem(SMS_Alias);
    SMS_Alias = NULL;
  }
  fp = fopen(FileName,"rt");
  if(fp == NULL)
    return;
  while(SU_ReadLine(fp,S,sizeof(S)))
  {
    if((S[0] == '#') || (S[0] == 0))
      continue;
    if(DebugLevel >= 1)
      printf("Loading Alias : %s\n",S);
    SMS_Alias = SU_AddElementHead(SMS_Alias,strdup(S));
  }
  fclose(fp);
}

void FreeAliases(void)
{
  if(SMS_Alias != NULL)
  {
    SU_FreeListElem(SMS_Alias);
    SMS_Alias = NULL;
  }
}

char *SearchAlias(const char Name[])
{
  SU_PList Ptr;
  bool found;
  char *p;
  char *tmp;
  char *ret;

  if(Name[0] != '@')
    return (char *)Name;
  ret = (char *)Name+1;
  found = false;
  Ptr = SMS_Alias;
  while(Ptr != NULL)
  {
    tmp = strdup((char *)Ptr->Data);
    p = strchr(tmp,' ');
    if(p == NULL)
      printf("Warning in SearchAlias : Invalid alias : %s\n",tmp);
    else
    {
      p[0] = 0;
      p = SU_TrimLeft(p+1);
      if(strcasecmp(Name+1,tmp) == 0) /* Found alias */
      {
        ret = ((char *)Ptr->Data) + (p-tmp);
        if(DebugLevel >= 1)
          printf("Found alias for %s, replacing with %s\n",Name+1,ret);
        found = true;
      }
    }
    free(tmp);
    if(found)
      break;
    Ptr = Ptr->Next;
  }
  return ret;
}

void PrintProviderHelp(const char ProviderName[],SMS_PProvider Pv)
{
  int i;

  printf("SmsSend version %s - Copyright(c) Ze KiLleR / SkyTech - 2000'01\n",SMSSEND_VERSION);
  printf("Arguments for provider %s :\n",ProviderName);
  for(i=0;i<Pv->NbParams;i++)
  {
    printf("  %s",Pv->Params[i].Name);
    if(Pv->Params[i].Size != 0)
      printf(" (Max size %d)",Pv->Params[i].Size);
    if(Pv->Params[i].Convert)
      printf(" (Non alphanum converted, except + - _ *)");
    if(Pv->Params[i].Help != NULL)
      printf(" /* %s */\n",Pv->Params[i].Help);
    else
      printf("\n");
  }
}

void PrintHelp(char *Msg,bool version)
{
  printf("SmsSend version %s - Copyright(c) Ze KiLleR / SkyTech - 2000'01\n",SMSSEND_VERSION);
  if(version)
    return;
  printf("Usage : smssend [options] <provider> [arguments] -- [SkyUtils options]\n");
  printf("        Options : -q -v -h -update\n");
  printf("        SkyUtils Options :\n");
  printf("           %s\n",SU_GetOptionsString());
  printf("        * Use -help as the first provider option to get required\n          fields for this provider\n");
  printf("        * Use -update as the first provider option to search for\n          a new version of this script\n");
  if(Msg != NULL)
    printf("\n%s\n",Msg);
}

char *ReadParamFromStdin()
{
  char Buf[1024],c;
  int i=0;

  while(i != (sizeof(Buf)-1))
  {
    c = getchar();
    if(c == '\n')
      break;
    Buf[i++] = c;
  }
  Buf[i] = 0;
  return strdup(SearchAlias(Buf));
}

int main(int argc,char *argv[])
{
  SMS_PProvider Pv;
  int i,pvPos;
  char PvName[512],AName[512];
  char Cmd[1024];
#ifdef _WIN32
  float fl; // This float is needed to force VC to link the math lib.. VC bug ;(

  fl = 2.2;
  if(Cmd[0] == 66)
    printf("%f\n",fl);
  if(!SU_WSInit(2,2))
  {
    printf("SmsSend error : Couldn't find a usable WinSock dll\n");
    return -1;
  }
#endif

  argc = SU_GetSkyutilsParams(argc,argv);
  if(argc == 1)
  {
    PrintHelp("Provider not specified.",false);
    return -3;
  }
  DebugLevel = SU_GetDebugLevel();
  /* Parse options */
  i = 1;
  while(i < argc)
  {
    if(argv[i][0] == '-')
    {
      if(strcasecmp(argv[i],"-update") == 0)
      {
        if(!SMS_Quiet)
        {
          printf("SmsSend version %s - Copyright(c) Ze KiLleR / SkyTech - 2000'01\n",SMSSEND_VERSION);
          printf("Trying to update SmsSend...\n");
        }
        CheckForUpdateSmsSend();
        return 0;
      }
      else if(strcasecmp(argv[i],"--help") == 0)
      {
        PrintHelp(NULL,false);
        return 0;
      }
      else if(strcasecmp(argv[i],"-h") == 0)
      {
        PrintHelp(NULL,false);
        return 0;
      }
      else if(strcasecmp(argv[i],"--version") == 0)
      {
        PrintHelp(NULL,true);
        return 0;
      }
      else if(strcasecmp(argv[i],"-v") == 0)
      {
        PrintHelp(NULL,true);
        return 0;
      }
      else if(strcasecmp(argv[i],"-q") == 0)
        SMS_Quiet = true;
      else
      {
        snprintf(Cmd,sizeof(Cmd),"Unknown option : %s",argv[i]);
        PrintHelp(Cmd,false);
        return -3;
      }
    }
    else
      break;
    i++;
  }
  if(i >= argc)
  {
    PrintHelp("Provider not specified.",false);
    return -3;
  }
  if(strstr(argv[i],".sms") == NULL)
    snprintf(PvName,sizeof(PvName),"%s.sms",argv[i]);
  else
    strcpy(PvName,argv[i]);
  /* First try to load local .sms script */
  Pv = LoadProviderFile(PvName);
  if(Pv == NULL)
  {
#ifndef _WIN32
    /* Then try to load user script */
    if(strstr(argv[i],".sms") == NULL)
      snprintf(PvName,sizeof(PvName),"%s/.smssend/%s.sms",getenv("HOME"),argv[i]);
    else
      snprintf(PvName,sizeof(PvName),"%s/.smssend/%s",getenv("HOME"),argv[i]);
    Pv = LoadProviderFile(PvName);
    if(Pv == NULL)
#endif
    {
      /* Then try to load global shared scripts */
      if(strstr(argv[i],".sms") == NULL)
        snprintf(PvName,sizeof(PvName),"%s/%s.sms",SMSSEND_SHAREPATH,argv[i]);
      else
        snprintf(PvName,sizeof(PvName),"%s/%s",SMSSEND_SHAREPATH,argv[i]);
      Pv = LoadProviderFile(PvName);
      if(Pv == NULL)
      {
        snprintf(Cmd,sizeof(Cmd),"Cannot load provider file (not found in ./ , ~/.smssend or %s/) : %s%s\n",SMSSEND_SHAREPATH,argv[i],(strstr(argv[i],".sms") != NULL)?"":".sms");
        PrintHelp(Cmd,false);
        return -4;
      }
    }
  }
  pvPos = i;
  i++;
  if(i >= argc)
  {
    PrintProviderHelp(argv[pvPos],Pv);
    return -6;
  }
  if(strcasecmp(argv[i],"-help") == 0)
  {
    PrintProviderHelp(argv[pvPos],Pv);
    return -5;
  }
  else if(strcasecmp(argv[i],"-update") == 0)
  {
    if(!SMS_Quiet)
    {
      printf("SmsSend version %s - Copyright(c) Ze KiLleR / SkyTech - 2000'01\n",SMSSEND_VERSION);
      printf("Trying to update %s script...\n",argv[pvPos]);
    }
    CheckForUpdate(PvName);
    return 0;
  }
  if(argc < (Pv->NbParams+pvPos+1))
  {
    PrintHelp("Not enough arguments for this provider. Try -help as first provider argument.",false);
    return -6;
  }
  else if(argc > (Pv->NbParams+pvPos+1))
  {
    PrintHelp("Too many arguments for this provider. Try -help as first provider argument.",false);
    return -6;
  }
#ifdef _WIN32
  snprintf(AName,sizeof(AName),"%s\\aliases",SMSSEND_SHAREPATH);
#else
  snprintf(AName,sizeof(AName),"%s/.smssend/aliases",getenv("HOME"));
#endif
  LoadAliases(AName);
  for(i=0;i<Pv->NbParams;i++)
  {
    if(strcmp(argv[i+pvPos+1],"-") == 0)
    {
      if(!SMS_Quiet)
        printf("Enter parameter %s :\n",Pv->Params[i].Name);
      Pv->Params[i].Value = ReadParamFromStdin();
    }
    else
      Pv->Params[i].Value = strdup(SearchAlias(argv[i+pvPos+1]));
  }

  ExecuteProvider(Pv);
  FreeProvider(Pv);
  FreeAliases();

  return 0;
}
#endif
