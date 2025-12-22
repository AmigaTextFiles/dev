/****************************************************************/
/* Web unit                                                     */
/* (c) Christophe CALMEJANE (Ze KiLleR) - 1999-01               */
/****************************************************************/
/* TO DO :
 * Purger les cookies expirés
*/

#include "skyutils.h"

#undef malloc
#undef calloc
#undef realloc
#undef strdup
#undef free

#define USER_AGENT "Mozilla/5.0 (compatible; MSIE 5.01; Windows NT)"
#define SW_DEFAULT_HEADER "User-Agent: " USER_AGENT "\x0D" "\x0A" "Connection: Keep-Alive" "\x0D" "\x0A" "Accept-Language: fr-FR, en" "\x0D" "\x0A" "Accept-Charset: iso-8859-1,*,utf-8" "\x0D" "\x0A" "Accept: text/html, text/plain, text/*, image/gif, image/jpg, image/png, */*" "\x0D" "\x0A"
#define SKYWEB_VERSION "SkyWeb 1.15"
#define DEFAULT_PORT 80
#define SOCKET_TIME_OUT 60

#ifdef __unix__
extern int SU_DebugLevel;
#endif

char *SW_GetInput_String;
char *SW_GetImage_String;
char *SW_Proxy_String = NULL;
char *SW_Proxy_User = NULL;
char *SW_Proxy_Password = NULL;
char *SW_UserHeader = NULL;
int   SW_Proxy_Port = 0;
int   SW_SocketTimeout = SOCKET_TIME_OUT;
SU_PList SW_Cookies = NULL; /* SU_PCookie */

int SU_Dump_PageNum = 0;

void DumpPage(const char fname[],const char *buf,const int size)
{
  FILE *fp;
  char FN[50];

  if(fname == NULL)
  {
    sprintf(FN,"Dump%d.html",SU_Dump_PageNum++);
    printf("Dumping to %s\n",FN);
    fp = fopen(FN,"wt");
  }
  else
    fp = fopen(fname,"wb");
  if(fp == NULL)
    return;
  fwrite(buf,size,1,fp);
  fclose(fp);
}

void SU_SetSocketTimeout(const int Timeout)
{
  if(Timeout == 0)
    SW_SocketTimeout = SOCKET_TIME_OUT;
  else
    SW_SocketTimeout = Timeout;
}

void SU_SetProxy(const char Proxy[],const int Port,const char User[], const char Password[])
{
  if(SW_Proxy_String != NULL)
    free(SW_Proxy_String);
  if((Proxy != NULL)&&(strlen(Proxy)>0))
    SW_Proxy_String = strdup(Proxy);
  else
    SW_Proxy_String = NULL;
  SW_Proxy_Port = Port;
  if(SW_Proxy_User != NULL)
    free(SW_Proxy_User);
  if((User != NULL)&&(strlen(User)>0))
    SW_Proxy_User = strdup(User);
  else
    SW_Proxy_User = NULL;
  if(SW_Proxy_Password != NULL)
    free(SW_Proxy_Password);
  if((Password != NULL)&&(strlen(Password)>0))
    SW_Proxy_Password = strdup(Password);
  else
    SW_Proxy_Password = NULL;
}

char *ExtractPath(char *URL,bool proxy)
{
  char *path;
  char l[]=".?/",c;
  int i;

  if(proxy)
  {
    URL = strstr(URL,"://") + 3;
    URL = strchr(URL,'/');
    if(URL == NULL)
    {
      return strdup("/");
    }
  }
  path = strdup(URL);
  if(strcmp(path,"/") == 0)
    return path;
  if(path[strlen(path)-1] == '/')
  {
    path[strlen(path)-1] = 0;
    return path;
  }
  if(SU_strrchrl(path,l,&c) == NULL)
    return path;
  if(c == '/')
    return path;

  i = strlen(path)-1;
  while(path[i] != '/')
  {
    if(i == 0)
    {
      path[0] = '/';
      break;
    }
    i--;
  }
  if(i == 0)
    path[1] = 0;
  else
    path[i] = 0;
  return path;
}

void AfficheCookie(SU_PCookie Cok)
{
  printf("Cookie : %s=%s--\n",Cok->Name,Cok->Value);
  if(Cok->Domain != NULL)
    printf("  Domain = %s--\n",Cok->Domain);
  if(Cok->Path != NULL)
    printf("  Path = %s--\n",Cok->Path);
  if(Cok->Expire != NULL)
    printf("  Expires = %s--\n",Cok->Expire);
  if(Cok->Secured)
    printf("  Secured\n");
}

void SU_FreeCookie(SU_PCookie Cok)
{
  free(Cok->Name);
  free(Cok->Value);
  if(Cok->Domain != NULL)
    free(Cok->Domain);
  if(Cok->Path != NULL)
    free(Cok->Path);
  if(Cok->Expire != NULL)
    free(Cok->Expire);
  free(Cok);
}

int GetPortFromHost(char *Host)
{
  char *p;

  p = strchr(Host,':');
  if(p == NULL)
    return DEFAULT_PORT;
  p[0] = 0;
  p++;
  return atoi(p);
}

void GetHostFromURL(const char *URL,char Host[],int Length,bool proxy,char URL_OUT[],int *PortConnect,const char OtherHost[])
{
  char *ptr,*ptr2;
  int len;
  char buf[URL_BUF_SIZE];
  char ReplaceHost[URL_BUF_SIZE];

  SU_strcpy(ReplaceHost,OtherHost,sizeof(ReplaceHost));
  SU_strcpy(URL_OUT,URL,URL_BUF_SIZE);
  if(strstr(URL,"http") == URL)
  {
    ptr = (char *)URL+7;
    ptr2 = strchr(ptr,'/');
  }
  else if(strstr(URL,"ftp") == URL)
  {
    ptr = (char *)URL+6;
    ptr2 = strchr(ptr,'@');
    if(ptr2 != NULL)
    {
      ptr = ptr2+1;
      ptr2 = strchr(ptr,'/');
    }
  }
  else
  {
    if(ReplaceHost[0] == 0)
      SU_strcpy(Host,URL,Length);
    else
      SU_strcpy(Host,ReplaceHost,Length);
    //Host[Length-1] = 0;
    if(!proxy)
    {
      URL_OUT[0] = '/';
      URL_OUT[1] = 0;
      *PortConnect = GetPortFromHost(Host);
    }
    return;
  }
  if(ptr2 == NULL)
  {
    if(ReplaceHost[0] == 0)
      SU_strcpy(Host,ptr,Length);
    else
      SU_strcpy(Host,ReplaceHost,Length);
    //Host[Length-1] = 0;
    if(!proxy)
    {
      URL_OUT[0] = '/';
      URL_OUT[1] = 0;
      *PortConnect = GetPortFromHost(Host);
    }
    return;
  }
  len = ptr2 - ptr + 1; /* +1 for the \0 */
  if(len > Length)
    len = Length;
  if(ReplaceHost[0] == 0)
  {
    SU_strcpy(Host,ptr,len);
    //Host[len] = 0;
  }
  else
  {
    SU_strcpy(Host,ReplaceHost,Length);
    //Host[Length-1] = 0;
  }
  if(!proxy)
  { /* If not using a proxy, we must remove host from URL_OUT */
    SU_strcpy(buf,ptr2,sizeof(buf));
    SU_strcpy(URL_OUT,buf,URL_BUF_SIZE);
    *PortConnect = GetPortFromHost(Host);
  }
  else
  { /* Using proxy ? */
    if(ReplaceHost[0] != 0)
    { /* Ahh, we must replace host in URL_OUT */
      if(URL[0] == 'h')
        strcpy(URL_OUT,"http://");
      else
        strcpy(URL_OUT,"ftp://");
#ifdef __unix__
      if(SU_DebugLevel >= 4)
        printf("replacing url -> %s - %s\n",ptr2,ReplaceHost);
#endif
      SU_strcpy(buf,ptr2,sizeof(buf));
      SU_strcat(URL_OUT,ReplaceHost,URL_BUF_SIZE);
      SU_strcat(URL_OUT,buf,URL_BUF_SIZE);
#ifdef __unix__
      if(SU_DebugLevel >= 4)
        printf("new url : %s\n",URL_OUT);
#endif
      *PortConnect = GetPortFromHost((char *)ReplaceHost);
    }
  }
}

void FreeAnswer(SU_PAnswer Ans)
{
  if(Ans == NULL)
    return;
  if(Ans->Location != NULL)
    free(Ans->Location);
  if(Ans->Data != NULL)
    free(Ans->Data);
}

SU_PAnswer ParseBuffer(SU_PAnswer Ans,char *Buf,int *len,SU_PHTTPActions Act,bool proxy)
{
  char *ptr,*ptr2;//,*ptr3;
  char *tmp,*tok;
  char *saf; /* Used at the end of the while ! DO NOT USE */
  SU_PCookie Cok;
//  int done;
  float f;
  SU_PList Ptr;

  if(Ans == NULL)
  {
    Ans = (SU_PAnswer) malloc(sizeof(SU_TAnswer));
    memset(Ans,0,sizeof(SU_TAnswer));
    Ans->Data_Length = -1;
  }
  if(Ans->Data_Length != -1)
  {
    Ans->Data = (char *) realloc(Ans->Data,Ans->Data_Length+*len);
    memcpy(Ans->Data+Ans->Data_Length,Buf,*len);
    Ans->Data_Length += *len;
    *len = 0;
    return Ans;
  }
  while(len != 0)
  {
    ptr = strstr(Buf,"\r\n");
    if(ptr == NULL) /* Not enough bytes received */
      return Ans;
    if(ptr == Buf) /* Data following */
    {
#ifdef __unix__
      if(SU_DebugLevel >= 3)
      {
        printf("Found Data\n");
        if(Ans->Data_ToReceive != 0)
          printf("Waiting %d bytes\n",Ans->Data_ToReceive);
      }
#endif
      Ans->Data_Length = 0;
      if(*len == 2) /* Not enough data */
        return Ans;
      Ans->Data = (char *) malloc(*len-2);
      memcpy(Ans->Data,Buf+2,*len-2);
      Ans->Data_Length = *len - 2;
      *len = 0;
      return Ans;
    }
    ptr[0] = 0;
    saf = ptr;
    /* Parse header command */
#ifdef __unix__
    if(SU_DebugLevel >= 3)
      printf("Found header : %s\n",Buf);
#endif
    if(SU_nocasestrstr(Buf,"HTTP/") == Buf) /* Found reply code */
    {
      sscanf(Buf,"HTTP/%f %d",&f,&Ans->Code);
    }
    else if(SU_nocasestrstr(Buf,"Content-Length") == Buf)
    {
      Ans->Data_ToReceive = atoi(strchr(Buf,':')+1);
    }
    else if(SU_nocasestrstr(Buf,"Set-Cookie") == Buf) /* Found Set-Cookie */
    {
      Cok = (SU_PCookie) malloc(sizeof(SU_TCookie));
      memset(Cok,0,sizeof(SU_TCookie));
      tmp = SU_TrimLeft(strchr(Buf,':') + 1);
      tmp = strdup(tmp);
      tok = SU_TrimLeft(strtok(tmp,";"));
      /* Get NAME=VALUE */
      ptr2 = strchr(tok,'=');
      ptr2[0] = 0;
      Cok->Name = strdup(tok);
      Cok->Value = strdup(ptr2+1);
      /* Get options */
      tok = SU_TrimLeft(strtok(NULL,";"));
      while(tok != NULL)
      {
        if(strncasecmp(tok,"expires",7) == 0)
        {
          ptr2 = strchr(tok,'=');
          if(ptr2 != NULL)
          {
            Cok->Expire = strdup(ptr2+1);
          }
          else
            printf("Error with Expire value in cookie : %s\n",tok);
        }
        else if(strncasecmp(tok,"path",4) == 0)
        {
          ptr2 = strchr(tok,'=');
          if(ptr2 != NULL)
          {
            Cok->Path = strdup(ptr2+1);
          }
          else
            printf("Error with Path value in cookie : %s\n",tok);
        }
        else if(strncasecmp(tok,"domain",6) == 0)
        {
          ptr2 = strchr(tok,'=');
          if(ptr2 != NULL)
          {
            if(ptr2[1] == '.')
              Cok->Domain = strdup(ptr2+2);
            else
              Cok->Domain = strdup(ptr2+1);
          }
          else
            printf("Error with Domain value in cookie : %s\n",tok);
        }
        else if(strncasecmp(tok,"secure",6) == 0)
        {
          Cok->Secured = true;
        }
#ifdef DEBUG
        else
          printf("Unknown option in Set-Cookie : %s\n",tok);
#endif
        tok = SU_TrimLeft(strtok(NULL,";"));
      }
      free(tmp);
      if(Cok->Domain == NULL)
      {
        Cok->Domain = strdup(Act->Host);
      }
      if(Cok->Path == NULL)
      {
        tmp = ExtractPath(Act->URL,proxy);
        Cok->Path = strdup(tmp);
        free(tmp);
      }
#ifdef __unix__
      if(SU_DebugLevel >= 4)
        AfficheCookie(Cok);
#endif
      /* Check if a cookie with same Name/Domain/Path exists */
      Ptr = SW_Cookies;
      while(Ptr != NULL)
      {
        if((strcmp(((SU_PCookie)Ptr->Data)->Name,Cok->Name) == 0) && (strcmp(((SU_PCookie)Ptr->Data)->Domain,Cok->Domain) == 0))
        {
          if((Cok->Path != NULL) && (((SU_PCookie)Ptr->Data)->Path != NULL))
          {
            if(strcmp(((SU_PCookie)Ptr->Data)->Path,Cok->Path) == 0)
            {
              SU_FreeCookie((SU_PCookie)Ptr->Data);
              Ptr->Data = Cok;
              break;
            }
          }
        }
        Ptr = Ptr->Next;
      }
      if(Ptr == NULL)
        SW_Cookies = SU_AddElementTail(SW_Cookies,Cok);
    }
    else if(SU_nocasestrstr(Buf,"Location") == Buf) /* Found Location */
    {
      ptr2 = SU_TrimLeft(strchr(Buf,':') + 1);
      Ans->Location = strdup(ptr2);
    }
    /* End of parse header command */
    *len -= (saf - Buf) + 2;
    memmove(Buf,saf+2,*len);
  }
  return Ans;
}

int CreateConnection(char Host[],int Port)
{
  int Sock;
  struct sockaddr_in sin;
  struct hostent *HE;

  Sock = socket(AF_INET,SOCK_STREAM,getprotobyname("tcp")->p_proto);
  if(Sock == -1)
    return -1;
  sin.sin_family = AF_INET;
  sin.sin_port = htons(Port);
  sin.sin_addr.s_addr = inet_addr(Host);
  if( sin.sin_addr.s_addr == INADDR_NONE )
  {
    HE = gethostbyname(Host);
    if( HE == NULL )
    {
      printf("SkyUtils_CreateConnection : Unknown Host : %s\n",Host);
      return -2;
    }
    sin.sin_addr = *(struct in_addr *)(HE->h_addr_list[0]);
  }
  if( connect(Sock,(struct sockaddr *)(&sin),sizeof(sin)) == -1 )
  {
#ifdef __unix__
    close(Sock);
#else
    closesocket(Sock);
#endif
    return -3;
  }
  return Sock;
}

/* Base64 encode a string */
char * http_base64_encode(const char *text)
{

  const char b64_alphabet[65] = {
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      "abcdefghijklmnopqrstuvwxyz"
      "0123456789+/=" };

  /* The tricky thing about this is doing the padding at the end,
   * doing the bit manipulation requires a bit of concentration only */
  char *buffer = NULL;
  char *point = NULL;
  int inlen = 0;
  int outlen = 0;

  /* check our args */
  if (text == NULL)
    return NULL;

  /* Use 'buffer' to store the output. Work out how big it should be...
   * This must be a multiple of 4 bytes */

  inlen = strlen( text );
  /* check our arg...avoid a pesky FPE */
  if (inlen == 0)
    {
      buffer = (char *) malloc(sizeof(char));
      buffer[0] = '\0';
      return buffer;
    }
  outlen = (inlen*4)/3;
  if( (inlen % 3) > 0 ) /* got to pad */
    outlen += 4 - (inlen % 3);

  buffer = (char *) malloc( outlen + 1 ); /* +1 for the \0 */
  memset(buffer, 0, outlen + 1); /* initialize to zero */

  /* now do the main stage of conversion, 3 bytes at a time,
   * leave the trailing bytes (if there are any) for later */

  for( point=buffer; inlen>=3; inlen-=3, text+=3 ) {
    *(point++) = b64_alphabet[ *text>>2 ];
    *(point++) = b64_alphabet[ (*text<<4 & 0x30) | *(text+1)>>4 ];
    *(point++) = b64_alphabet[ (*(text+1)<<2 & 0x3c) | *(text+2)>>6 ];
    *(point++) = b64_alphabet[ *(text+2) & 0x3f ];
  }

  /* Now deal with the trailing bytes */
  if( inlen ) {
    /* We always have one trailing byte */
    *(point++) = b64_alphabet[ *text>>2 ];
    *(point++) = b64_alphabet[ (*text<<4 & 0x30) |
			     (inlen==2?*(text+1)>>4:0) ];
    *(point++) = (inlen==1?'=':b64_alphabet[ *(text+1)<<2 & 0x3c ] );
    *(point++) = '=';
  }

  *point = '\0';

  return buffer;
}

bool SendCommand(int Sock,SU_PHTTPActions Act,bool proxy)
{
  char buf[16000];
  int len,pos;
  long int FLen;
  int res;
  char *Com,*tmp,*tmp2,*tmp3;
  SU_PList Ptr;
  int cook,blen,blen2;
  FILE *fp;
  bool do_it;

  if(Act->Command == ACT_GET)
    Com = "GET";
  else if(Act->Command == ACT_POST)
    Com = "POST";
  else if(Act->Command == ACT_PUT)
    Com = "PUT";
  else if(Act->Command == ACT_DELETE)
    Com = "DELETE";
  else
    Com = "ERROR";
  if(Act->URL_Params == NULL)
    snprintf(buf,sizeof(buf),"%s %s HTTP/1.0%c%cHost: %s%c%c",Com,Act->URL,0x0D,0x0A,Act->Host,0x0D,0x0A);
  else
    snprintf(buf,sizeof(buf),"%s %s?%s HTTP/1.0%c%cHost: %s%c%c",Com,Act->URL,Act->URL_Params,0x0D,0x0A,Act->Host,0x0D,0x0A);
  len = strlen(buf);
  /* Now add header from file, or default one */
  if(SW_UserHeader == NULL)
    snprintf(buf+len,sizeof(buf)-len,"%s",SW_DEFAULT_HEADER);
  else
    snprintf(buf+len,sizeof(buf)-len,"%s",SW_UserHeader);
  len = strlen(buf);

  Ptr = SW_Cookies;
  cook = 0;
  while(Ptr != NULL)
  {
    blen = strlen(((SU_PCookie)Ptr->Data)->Domain)+2;
    tmp = (char *) malloc(blen);
    snprintf(tmp,blen,"*%s",((SU_PCookie)Ptr->Data)->Domain);
    if(SU_strwcmp(Act->Host,tmp))
    {
      do_it = false;
      if(((SU_PCookie)Ptr->Data)->Path == NULL)
        do_it = true;
      else
      {
        blen2 = strlen(((SU_PCookie)Ptr->Data)->Path)+2;
        tmp2 = (char *) malloc(blen2);
        snprintf(tmp2,blen2,"%s*",((SU_PCookie)Ptr->Data)->Path);
        tmp3 = ExtractPath(Act->URL,proxy);
        if(SU_strwcmp(tmp3,tmp2))
          do_it = true;
        free(tmp2);
        free(tmp3);
      }
      if(do_it)
      {
        if(cook == 0)
        {
          snprintf(buf+len,sizeof(buf),"Cookie: %s=%s",((SU_PCookie)Ptr->Data)->Name,((SU_PCookie)Ptr->Data)->Value);
          len = strlen(buf);
          cook = 1;
        }
        else
        {
          snprintf(buf+len,sizeof(buf),"; %s=%s",((SU_PCookie)Ptr->Data)->Name,((SU_PCookie)Ptr->Data)->Value);
          len = strlen(buf);
        }
      }
    }
    free(tmp);
    Ptr = Ptr->Next;
  }
  if(cook != 0)
  {
    buf[len++] = 0x0D;
    buf[len++] = 0x0A;
  }
  if(Act->Referer != NULL)
  {
    snprintf(buf+len,sizeof(buf),"Referer: %s%c%c",Act->Referer,0x0D,0x0A);
    len = strlen(buf);
  }
  /* Manage proxy authorization */
  if(proxy != 0)
  {
    if(SW_Proxy_User != NULL)
    {
       char authtoken[256];
       char *auth64=NULL;

       if(SW_Proxy_Password != NULL)
          snprintf(authtoken,255,"%s:%s",SW_Proxy_User,SW_Proxy_Password);
       else
          snprintf(authtoken,255,"%s:",SW_Proxy_User);
       auth64 = http_base64_encode(authtoken);
       if(auth64 != NULL)
       {
          snprintf(buf+len,sizeof(buf),"Proxy-Authorization: Basic %s%c%c",auth64,0x0D,0x0A);
    	  len = strlen(buf);
          free(auth64);
       }
    }
  }
  if(Act->Command == ACT_POST)
  {
    snprintf(buf+len,sizeof(buf),"Content-type: application/x-www-form-urlencoded%c%cContent-length: %d%c%c%c%c",0x0D,0x0A,Act->Post_Length,0x0D,0x0A,0x0D,0x0A);
    len = strlen(buf);
    memcpy(buf+len,Act->Post_Data,Act->Post_Length);
    len += Act->Post_Length;
    buf[len++] = 0x0D;
    buf[len++] = 0x0A;
    buf[len] = 0;
  }
  else if((Act->Command == ACT_GET) || (Act->Command == ACT_DELETE))
  {
    buf[len++] = 0x0D;
    buf[len++] = 0x0A;
    buf[len] = 0;
  }
  if(Act->Command == ACT_PUT)
  {
    fp = fopen(Act->FileName,"rb");
    if(fp == NULL)
      return false;
    fseek(fp,0,SEEK_END);
    FLen = ftell(fp);
    rewind(fp);
#ifdef __unix__
    if(SU_DebugLevel >= 2)
      printf("Sending file %s of length %ld\n",Act->FileName,FLen);
#endif
    snprintf(buf+len,sizeof(buf),"Content-length: %ld%c%c%c%c",FLen,0x0D,0x0A,0x0D,0x0A);
    len = strlen(buf);
    res = send(Sock,buf,len,SU_MSG_NOSIGNAL);
    while(res >= 0)
    {
      len = (FLen > sizeof(buf))?sizeof(buf):FLen;
      if(fread(buf,len,1,fp) != 1)
        break;
      res = send(Sock,buf,len,SU_MSG_NOSIGNAL);
      FLen -= len;
      if(res <= 0)
        break;
      else if(res != len)
      { /* Not all bytes sent */
        pos = res;
        len -= res;
        while(len > 0)
        {
          res = send(Sock,buf+pos,len,SU_MSG_NOSIGNAL);
          if(res <= 0)
            break;
          pos += res;
          len -= res;
        }
        if(res <= 0)
          break;
      }
      if(FLen == 0)
      {
        fclose(fp);
        len = 0;
        buf[len++] = 0x0D;
        buf[len++] = 0x0A;
        buf[len] = 0;
        send(Sock,buf,len,SU_MSG_NOSIGNAL);
#ifdef __unix__
        if(SU_DebugLevel >= 2)
          printf("Successfully sent file\n");
#endif
        return true;
      }
    }
    if(res == -1)
    {
      if(Act->CB.OnErrorSendingFile != NULL)
        Act->CB.OnErrorSendingFile(errno,Act->User);
#ifdef __unix__
      if(SU_DebugLevel >= 2)
        printf("Error sending file, %ld bytes remaining not sent\n",FLen);
#endif
    }
    fclose(fp);
#ifdef __unix__
    close(Sock);
#else
    closesocket(Sock);
#endif
    return false;
  }
#ifdef __unix__
  if(SU_DebugLevel >= 2)
    printf("sending (%d) : %s\n",len,buf);
#endif
  res = send(Sock,buf,len,0);
  return true;
}

SU_PAnswer WaitForAnswer(int Sock,SU_PHTTPActions Act,bool proxy)
{
  int len;
  int BufPos = 0;
  char Buf[32768];
  SU_PAnswer Ans = NULL;
  fd_set rfds;
  struct timeval tv;
  int retval;

  FD_ZERO(&rfds);
  FD_SET(Sock,&rfds);
  tv.tv_sec = SW_SocketTimeout;
  tv.tv_usec = 0;
  retval = select(Sock+1,&rfds,NULL,NULL,&tv);
  if(retval != 1)
    return NULL;
  len = recv(Sock,Buf,sizeof(Buf),0);
  while(len > 0)
  {
    len += BufPos;
    Ans = ParseBuffer(Ans,Buf,&len,Act,proxy);
    BufPos = len;
    if(Ans->Data_ToReceive != 0)
    {
      if(Ans->Data_Length >= Ans->Data_ToReceive)
        break;
    }
    FD_ZERO(&rfds);
    FD_SET(Sock,&rfds);
    tv.tv_sec = SW_SocketTimeout;
    tv.tv_usec = 0;
    retval = select(Sock+1,&rfds,NULL,NULL,&tv);
    if(retval == 0) /* Time out */
    {
      if(Ans->Data_Length == -1)
      {
        FreeAnswer(Ans);
        Ans = NULL;
      }
#ifdef DEBUG
      else
        printf("Connection timed out, but some datas were retrieved\n");
#endif
      break;
    }
    else if(retval < 0)
    {
      if(Ans->Data_Length == -1)
      {
        FreeAnswer(Ans);
        Ans = NULL;
      }
#ifdef DEBUG
      else
        printf("Unexpected network error : %d\n",errno);
#endif
      break;
    }
    len = recv(Sock,Buf+BufPos,sizeof(Buf)-BufPos,0);
  }
#ifdef __unix__
  close(Sock);
#else
  closesocket(Sock);
#endif
#ifdef __unix__
  if(SU_DebugLevel >= 5)
    DumpPage(NULL,Ans->Data,Ans->Data_Length);
#endif
  if((Act->FileName != NULL) && ((Act->Command == ACT_GET) || (Act->Command == ACT_POST)))
    DumpPage(Act->FileName,Ans->Data,Ans->Data_Length);
  return Ans;
}

int SU_ExecuteActions(SU_PList Actions)
{
  SU_PList Ptr = Actions;
  SU_PList ActRec;
  SU_PAnswer Ans;
  SU_THTTPActions Act;
  char URL_OUT[URL_BUF_SIZE];
  int  Sock;
  char *ptr;
  int  PortConnect;

  while(Ptr != NULL)
  {
    if(((SU_PHTTPActions)Ptr->Data)->Sleep != 0)
    {
#ifdef __unix__
      if(SU_DebugLevel >= 1)
        printf("Sleeping %d sec before sending command\n",((SU_PHTTPActions)Ptr->Data)->Sleep);
      sleep(((SU_PHTTPActions)Ptr->Data)->Sleep); /* Sleeping */
#else
      Sleep(((SU_PHTTPActions)Ptr->Data)->Sleep*1000); /* Sleeping */
#endif
    }
    switch(((SU_PHTTPActions)Ptr->Data)->Command)
    {
      case ACT_GET :
      case ACT_POST :
      case ACT_PUT :
      case ACT_DELETE :
        GetHostFromURL(((SU_PHTTPActions)Ptr->Data)->URL,((SU_PHTTPActions)Ptr->Data)->Host,sizeof(((SU_PHTTPActions)Ptr->Data)->Host),(SW_Proxy_String != NULL),URL_OUT,&PortConnect,((SU_PHTTPActions)Ptr->Data)->Host);
        if(((SU_PHTTPActions)Ptr->Data)->CB.OnSendingCommand != NULL)
          ((SU_PHTTPActions)Ptr->Data)->CB.OnSendingCommand((SU_PHTTPActions)Ptr->Data);
        SU_strcpy(((SU_PHTTPActions)Ptr->Data)->URL,URL_OUT,sizeof(URL_OUT));
        if(SW_Proxy_String != NULL)
        {
#ifdef __unix__
          if(SU_DebugLevel >= 1)
          {
            if(SW_Proxy_User == NULL)
              printf("Using proxy: %s, port %d\n",SW_Proxy_String,SW_Proxy_Port);
            else
              printf("Using proxy: %s, with user %s [%s], port %d\n",SW_Proxy_String,SW_Proxy_User,SW_Proxy_Password,SW_Proxy_Port);
          }
#endif
          Sock = CreateConnection(SW_Proxy_String,SW_Proxy_Port);
        }
        else
          Sock = CreateConnection(((SU_PHTTPActions)Ptr->Data)->Host,PortConnect);
        if(Sock < 0)
        {
          printf("%s error : cannot connect to the host\n",SKYWEB_VERSION);
          return(-1);
        }
        if(SendCommand(Sock,(SU_PHTTPActions)Ptr->Data,(SW_Proxy_String != NULL)))
        {
          Ans = WaitForAnswer(Sock,((SU_PHTTPActions)Ptr->Data),(SW_Proxy_String != NULL));
          if(Ans == NULL)
          {
            printf("%s error : connection timed out\n",SKYWEB_VERSION);
            return(-2);
          }
          if(((SU_PHTTPActions)Ptr->Data)->CB.OnAnswer != NULL)
            ((SU_PHTTPActions)Ptr->Data)->CB.OnAnswer(Ans,((SU_PHTTPActions)Ptr->Data)->User);
#ifdef __unix__
          if(SU_DebugLevel >= 2)
            printf("Found Code   : %d\n",Ans->Code);
#endif
          switch(Ans->Code)
          {
            case 200 : /* Ok reply */
              if(((SU_PHTTPActions)Ptr->Data)->CB.OnOk != NULL)
                ((SU_PHTTPActions)Ptr->Data)->CB.OnOk(Ans,((SU_PHTTPActions)Ptr->Data)->User);
              break;
            case 201 : /* Created */
              if(((SU_PHTTPActions)Ptr->Data)->CB.OnCreated != NULL)
                ((SU_PHTTPActions)Ptr->Data)->CB.OnCreated(Ans,((SU_PHTTPActions)Ptr->Data)->User);
              break;
            case 202 : /* Modified */
              if(((SU_PHTTPActions)Ptr->Data)->CB.OnModified != NULL)
                ((SU_PHTTPActions)Ptr->Data)->CB.OnModified(Ans,((SU_PHTTPActions)Ptr->Data)->User);
              break;
            case 301 : /* Moved */
            case 302 : /* Moved */
            case 303 : /* Moved */
              if(((SU_PHTTPActions)Ptr->Data)->CB.OnMoved != NULL)
                ((SU_PHTTPActions)Ptr->Data)->CB.OnMoved(Ans,((SU_PHTTPActions)Ptr->Data)->User);
              memset(&Act,0,sizeof(Act));
              Act.User = ((SU_PHTTPActions)Ptr->Data)->User;
              memcpy(&Act.CB,&((SU_PHTTPActions)Ptr->Data)->CB,sizeof(Act.CB));
              Act.Command = ACT_GET;
              if(strstr(Ans->Location,"http://") != Ans->Location) /* Relative path */
              {
                ptr = SU_AddLocationToUrl(((SU_PHTTPActions)Ptr->Data)->URL,((SU_PHTTPActions)Ptr->Data)->Host,Ans->Location);
                free(Ans->Location);
                Ans->Location = ptr;
              }
              /* Let say we use a proxy, so we have less code to execute :o) */
              GetHostFromURL(Ans->Location,((SU_PHTTPActions)Ptr->Data)->Host,sizeof(Act.Host),true,Act.URL,&PortConnect,"");
              SU_strcpy(Act.URL,Ans->Location,sizeof(Act.URL));
              Act.URL_Params = NULL;
              if(((SU_PHTTPActions)Ptr->Data)->Referer != NULL)
                Act.Referer = ((SU_PHTTPActions)Ptr->Data)->Referer;
              else
                Act.Referer = ((SU_PHTTPActions)Ptr->Data)->URL;
              ActRec = SU_AddElementHead(NULL,&Act);
              SU_ExecuteActions(ActRec);
              break;
            case 403 : /* Forbidden */
              if(((SU_PHTTPActions)Ptr->Data)->CB.OnForbidden != NULL)
                ((SU_PHTTPActions)Ptr->Data)->CB.OnForbidden(Ans,((SU_PHTTPActions)Ptr->Data)->User);
              break;
            case 404 : /* Page Not Found */
              if(((SU_PHTTPActions)Ptr->Data)->CB.OnNotFound != NULL)
                ((SU_PHTTPActions)Ptr->Data)->CB.OnNotFound(Ans,((SU_PHTTPActions)Ptr->Data)->User);
              break;
            case 413 : /* Request entity too large */
              if(((SU_PHTTPActions)Ptr->Data)->CB.OnTooBig != NULL)
                ((SU_PHTTPActions)Ptr->Data)->CB.OnTooBig(Ans,((SU_PHTTPActions)Ptr->Data)->User);
              break;
            case 503 : /* Unknown Host */
              if(((SU_PHTTPActions)Ptr->Data)->CB.OnUnknownHost != NULL)
                ((SU_PHTTPActions)Ptr->Data)->CB.OnUnknownHost(Ans,((SU_PHTTPActions)Ptr->Data)->User);
              break;
          }
          FreeAnswer(Ans);
        }
        break;
      default :
        printf("Unknown Action !!\n");
    }
    Ptr = Ptr->Next;
  }
  return 0;
}

void SU_FreeAction(SU_PHTTPActions Act)
{
  if(Act->URL_Params != NULL)
    free(Act->URL_Params);
  if(Act->Post_Data != NULL)
    free(Act->Post_Data);
  if(Act->FileName != NULL)
    free(Act->FileName);
  if(Act->Referer != NULL)
    free(Act->Referer);
  free(Act);
}

SU_PInput SU_GetInput(char *html)
{
  SW_GetInput_String = html;
  return SU_GetNextInput();
}

SU_PInput SU_GetNextInput(void)
{
  char *p,*q,*r,*s,*tmp,buf[500];
  char c,toto[3],res;
  int len;
  SU_PInput In;

  p = SU_nocasestrstr(SW_GetInput_String,"<input");
  if(p == NULL)
    return NULL;
  s = p;
  In = (SU_PInput) malloc(sizeof(SU_TInput));
  memset(In,0,sizeof(SU_TInput));
  p+=7;
  r = strchr(p,'>');
  /* Now parse input tags */
  toto[0] = '=';
  toto[1] = ' ';
  toto[2] = 0;
  while(p[0] != '>')
  {
    while(*p == ' ')
      p++;
    q = SU_strchrl(p,toto,&res);
    if(q == NULL)
      break;
    if(q > r) /* Attention ici, si on veux plus tard recup les non Name=Value */
      break;
    len = q-p;
    if(len >= sizeof(buf))
      len = sizeof(buf) - 1;
    memcpy(buf,p,len);
    buf[len] = 0;
    /* buf contient la partie Name de Name=Value */
    p = SU_TrimLeft(q + 1);
    if(res == ' ')
    {
      if(p[0] != '=')
        continue;
      else
        p = SU_TrimLeft(p+1);
    }
    while((len > 0) && (buf[len-1] == ' '))
    {
      len--;
      buf[len] = 0; /* Remove trailing spaces */
    }
    if((strchr(buf,' ') == NULL) && (res != '>')) /* Si on a bien a faire a un Name=Value */
    {
      if(p[0] == '"') /* Si la partie Value est une chaine */
      {
        c = '"';
        p++;
      }
      else if(p[0] == '\'') /* Si la partie Value est une chaine */
      {
        c = '\'';
        p++;
      }
      else
        c = ' ';
      q = strchr(p,c);
      if(q == NULL)
        break;
      if(q > r)
      {
        if((c == '"') || (c == '\'')) /* '>' must be inside the string */
          r = strchr(r+1,'>');
        else
          q = r;
      }
      len = q-p;
      if(len <= 0)
        continue;
      tmp = (char *) malloc(len+1);
      memcpy(tmp,p,len);
      tmp[len] = 0;
      p = q;
      if((c == '"') || (c == '\'')) /* Si la partie Value est une chaine */
        p++;
      if(SU_nocasestrstr(buf,"type") == buf)
        In->Type = tmp;
      else if(SU_nocasestrstr(buf,"name") == buf)
        In->Name = tmp;
      else if(SU_nocasestrstr(buf,"value") == buf)
        In->Value = tmp;
      else
        free(tmp);
    }
  }
  SW_GetInput_String = SU_nocasestrstr(s,"<input"); /* input en fait */
  SW_GetInput_String+=6;
  if(In->Name == NULL)
  {
    SU_FreeInput(In);
    return SU_GetNextInput();
  }
  return In;
}

void SU_FreeInput(SU_PInput In)
{
  if(In->Type != NULL)
    free(In->Type);
  if(In->Name != NULL)
    free(In->Name);
  if(In->Value != NULL)
    free(In->Value);
  free(In);
}

SU_PImage SU_GetImage(char *html)
{
  SW_GetImage_String = html;
  return SU_GetNextImage();
}

SU_PImage SU_GetNextImage(void)
{
  char *p,*q,*tmp;
  int len;
  char c;
  SU_PImage Im;

  p = SU_nocasestrstr(SW_GetImage_String,"img src");
  if(p == NULL)
    return NULL;
  Im = (SU_PImage) malloc(sizeof(SU_TImage));
  memset(Im,0,sizeof(SU_TImage));
  p+=7;
  while(*p == ' ')
    p++;
  p++; /* zap le '=' */
  while(*p == ' ')
    p++; /* zap les espaces apres le '=' */
  if(*p == '"')
  {
    c = '"';
    p++; /* zap le '"' si c'est une chaine */
  }
  else if(*p == '\'')
  {
    c = '\'';
    p++; /* zap le '\'' si c'est une chaine */
  }
  else
    c = ' ';
  q = strchr(p,c);
  len = q-p;
  tmp = (char *) malloc(len+1);
  memcpy(tmp,p,len);
  tmp[len] = 0;
  p = q;
  if((c == '"') || (c == '\'')) /* Si la partie Value est une chaine */
    p++;
  Im->Src = tmp;
  while(p[0] != '>')
  {
    /* Faudrait boucler ici pour recup le Name eventuellement */
    p++;
  }

  SW_GetImage_String = p;
  return Im;
}

void SU_FreeImage(SU_PImage Im)
{
  if(Im->Src != NULL)
    free(Im->Src);
  if(Im->Name != NULL)
    free(Im->Name);
  free(Im);
}

SU_PHTTPActions SU_RetrieveLink(const char URL[],const char Ans[],const char link[])
{
  char *p,*q,c,*tmp,*tmp2,*rp,*rs;
  SU_PHTTPActions Act;
  int i;
  bool found;

#ifdef __unix__
  p = strstr(Ans,link);
#else
  p = strstr((char *)Ans,link);
#endif
  if(p == NULL)
    return NULL;
  while(strncasecmp(p,"href",4) != 0)
    p--;
  p+=4;
  p = SU_TrimLeft(p); /* Remove spaces */
  p++; /* Zap '=' */
  p = SU_TrimLeft(p); /* Remove spaces */
  if(p[0] == '"')
  {
    c = '"';
    p++; /* Zap '"' */
  }
  else if(p[0] == '\'')
  {
    c = '\'';
    p++; /* Zap '\'' */
  }
  else
    c = ' ';
  q = strchr(p,c);
  tmp = (char *) malloc(q-p+1);
  SU_strcpy(tmp,p,q-p+1);

  Act = (SU_PHTTPActions) malloc(sizeof(SU_THTTPActions));
  memset(Act,0,sizeof(SU_THTTPActions));
  Act->Command = ACT_GET;
  /* URL in tmp, but may be relative */
  if(strncasecmp(tmp,"http",4) == 0) /* Absolute */
    strncpy(Act->URL,tmp,sizeof(Act->URL));
  else
  {
    if(tmp[0] == '/') /* Root of the host */
    {
#ifdef __unix__
      tmp2 = strchr(URL+7,'/');
#else
      tmp2 = strchr((char *)URL+7,'/');
#endif
      if(tmp2 == NULL) /* Already at the root of the site */
      {
        SU_strcpy(Act->URL,URL,sizeof(Act->URL));
        SU_strcat(Act->URL,tmp,sizeof(Act->URL));
      }
      else
      {
        if((tmp2-URL+1) >= sizeof(Act->URL))
          printf("SkyWeb Warning : URL replacement in SU_RetrieveLink is bigger than sizeof(URL). Result should be unpredictable\n");
        else
          SU_strcpy(Act->URL,URL,tmp2-URL+1); /* Copy the root part of URL */
        SU_strcat(Act->URL,tmp,sizeof(Act->URL));
      }
    }
    else
    {
      tmp2 = tmp;
      strncpy(Act->URL,URL,sizeof(Act->URL));
      /* If / at the end of URL, remove it */
      if(Act->URL[strlen(Act->URL)-1] == '/')
        Act->URL[strlen(Act->URL)-1] = 0;
      /* If end of URL if a file, remove it */
      rp = strrchr(Act->URL,'.');
      rs = strrchr(Act->URL,'/');
      if(rp > rs)
        rs[0] = 0;
      /* For each ../ remove it from URL */
      while(strncasecmp(tmp2,"../",3) == 0)
      {
        tmp2+=3;
        i = strlen(Act->URL) - 1;
        found = false;
        while(i >= 0)
        {
          if(Act->URL[i] == '/')
          {
            found = true;
            Act->URL[i] = 0;
            break;
          }
          i--;
        }
        if(!found)
        {
          free(tmp);
          free(Act);
          return NULL;
        }
      }
      /* If no / at the end of URL, add it */
      if(Act->URL[strlen(Act->URL)-1] != '/')
        SU_strcat(Act->URL,"/",sizeof(Act->URL));
      /* Cat URL and dest */
      SU_strcat(Act->URL,tmp2,sizeof(Act->URL));
    }
  }
  free(tmp);
  return Act;
}

/* Code added by Pierre Bacquet (pbacquet@delta.fr) */
SU_PHTTPActions SU_RetrieveFrame(const char URL[],const char Ans[],const char framename[])
{
  char *p,*q,c,*tmp,*tmp2,*rp,*rs;
  SU_PHTTPActions Act;
  int i;
  bool found;
  char pattern[1024];

  snprintf(pattern,sizeof(pattern),"FRAME NAME=%s", framename);

  p = SU_nocasestrstr((char *)Ans,pattern);
  if(p == NULL)
    return NULL;
  while(strncasecmp(p,"src",3) != 0)
    p++;
  p+=3;
  p = SU_TrimLeft(p); /* Remove spaces */
  p++; /* Zap '=' */
  p = SU_TrimLeft(p); /* Remove spaces */
  if(p[0] == '"')
  {
    c = '"';
    p++; /* Zap '"' */
  }
  else if(p[0] == '\'')
  {
    c = '\'';
    p++; /* Zap '\'' */
  }
  else
    c = ' ';
  q = strchr(p,c);
  tmp = (char *) malloc(q-p+1);
  SU_strcpy(tmp,p,q-p+1);

  Act = (SU_PHTTPActions) malloc(sizeof(SU_THTTPActions));
  memset(Act,0,sizeof(SU_THTTPActions));
  Act->Command = ACT_GET;
  /* URL in tmp, but may be relative */
  if(strncasecmp(tmp,"http",4) == 0) /* Absolute */
    strncpy(Act->URL,tmp,sizeof(Act->URL));
  else
  {
    if(tmp[0] == '/') /* Root of the host */
    {
#ifdef __unix__
      tmp2 = strchr(URL+7,'/');
#else
      tmp2 = strchr((char *)URL+7,'/');
#endif
      if(tmp2 == NULL) /* Already at the root of the site */
      {
        SU_strcpy(Act->URL,URL,sizeof(Act->URL));
        SU_strcat(Act->URL,tmp,sizeof(Act->URL));
      }
      else
      {
        if((tmp2-URL+1) >= sizeof(Act->URL))
          printf("SkyWeb Warning : URL replacement in SU_RetrieveFrame is bigger than sizeof(URL). Result should be unpredictable\n");
        else
          SU_strcpy(Act->URL,URL,tmp2-URL+1); /* Copy the root part of URL */
        SU_strcat(Act->URL,tmp,sizeof(Act->URL));
      }
    }
    else
    {
      tmp2 = tmp;
      strncpy(Act->URL,URL,sizeof(Act->URL));
      /* If / at the end of URL, remove it */
      if(Act->URL[strlen(Act->URL)-1] == '/')
        Act->URL[strlen(Act->URL)-1] = 0;
      /* If end of URL if a file, remove it */
      rp = strrchr(Act->URL,'.');
      rs = strrchr(Act->URL,'/');
      if(rp > rs)
        rs[0] = 0;
      /* For each ../ remove it from URL */
      while(strncasecmp(tmp2,"../",3) == 0)
      {
        tmp2+=3;
        i = strlen(Act->URL) - 1;
        found = false;
        while(i >= 0)
        {
          if(Act->URL[i] == '/')
          {
            found = true;
            Act->URL[i] = 0;
            break;
          }
          i--;
        }
        if(!found)
        {
          free(tmp);
          free(Act);
          return NULL;
        }
      }
      /* If no / at the end of URL, add it */
      if(Act->URL[strlen(Act->URL)-1] != '/')
        SU_strcat(Act->URL,"/",sizeof(Act->URL));
      /* Cat URL and dest */
      SU_strcat(Act->URL,tmp2,sizeof(Act->URL));
    }
  }
  free(tmp);
  return Act;
}

/* Retrieve document.forms[num] */
SU_PForm SU_RetrieveForm(const char Ans[],const int num)
{
  char *p,*q,*r,*saf,*parse,*tmp,c,buf[500];
  int i,len;
  SU_PInput In;
  SU_PForm Form;
  SU_PList Ptr;
  char toto[3],res;

  p = SU_nocasestrstr((char *)Ans,"<form");
  if(p == NULL)
    return NULL;
  for(i=0;i<num;i++)
  {
    p = SU_nocasestrstr(p,"/form");
    if(p == NULL)
      return NULL;
    p = SU_nocasestrstr(p,"<form");
    if(p == NULL)
      return NULL;
  }
  q = SU_nocasestrstr(p,"/form");
  if(q == NULL)
    return NULL;
  saf = (char *) malloc(q-p+1);
  toto[1] = '>';
  toto[2] = 0;
  SU_strcpy(saf,p,q-p+1);
  /* Got the full form in saf */
  parse = saf;
  Form = (SU_PForm) malloc(sizeof(SU_TForm));
  memset(Form,0,sizeof(SU_TForm));
  Ptr = NULL;
  p = SU_TrimLeft(parse+5);
  /* Now parse form tag */
  while(p[0] != '>')
  {
    if(strncasecmp(p,"method",6) == 0)
    {
      p = SU_TrimLeft(p+6);
      p++; /* Zap '=' */
      p = SU_TrimLeft(p);
      if(p[0] == '"')
      {
        c = '"';
        p++; /* Zap '"' */
      }
      else if(p[0] == '\'')
      {
        c = '\'';
        p++; /* Zap '\'' */
      }
      else
        c = ' ';
      toto[0] = c;
      q = SU_strchrl(p,toto,&res);
      if(q == NULL)
        break;
      tmp = (char *) malloc(q-p+1);
      SU_strcpy(tmp,p,q-p+1);
      Form->Method = tmp;
      p = q;
      if((c == '"') || (c == '\''))
        p++; /* Zap '"' */
    }
    else if(strncasecmp(p,"name",4) == 0)
    {
      p = SU_TrimLeft(p+4);
      p++; /* Zap '=' */
      p = SU_TrimLeft(p);
      if(p[0] == '"')
      {
        c = '"';
        p++; /* Zap '"' */
      }
      else if(p[0] == '\'')
      {
        c = '\'';
        p++; /* Zap '\'' */
      }
      else
        c = ' ';
      toto[0] = c;
      q = SU_strchrl(p,toto,&res);
      if(q == NULL)
        break;
      tmp = (char *) malloc(q-p+1);
      SU_strcpy(tmp,p,q-p+1);
      Form->Name = tmp;
      p = q;
      if((c == '"') || (c == '\''))
        p++; /* Zap '"' */
    }
    else if(strncasecmp(p,"action",6) == 0)
    {
      p = SU_TrimLeft(p+6);
      p++; /* Zap '=' */
      p = SU_TrimLeft(p);
      if(p[0] == '"')
      {
        c = '"';
        p++; /* Zap '"' */
      }
      else if(p[0] == '\'')
      {
        c = '\'';
        p++; /* Zap '\'' */
      }
      else
        c = ' ';
      toto[0] = c;
      q = SU_strchrl(p,toto,&res);
      if(q == NULL)
        break;
      tmp = (char *) malloc(q-p+1);
      SU_strcpy(tmp,p,q-p+1);
      Form->Action = tmp;
      p = q;
      if((c == '"') || (c == '\''))
        p++; /* Zap '"' */
    }
    else
    {
      q = strchr(p,' ');
      r = strchr(p,'>');
      if((q == NULL) || (r == NULL))
        break;
      if(r < q)
        break;
      else
        p = q;
    }
    p = SU_TrimLeft(p);
  }
#ifdef __unix__
  if(SU_DebugLevel >= 3)
    printf("Infos for forms[%d] : Method=%s - Name=%s - Action=%s\n",num,(Form->Method == NULL)?"(null)":Form->Method,(Form->Name == NULL)?"(null)":Form->Name,(Form->Action == NULL)?"(null)":Form->Action);
#endif

  p = SU_nocasestrstr(parse,"<input");
  while(p != NULL)
  {
    In = (SU_PInput) malloc(sizeof(SU_TInput));
    memset(In,0,sizeof(SU_TInput));
    p = SU_TrimLeft(p+6);
    /* Now parse input tags */
    r = strchr(p,'>');
    toto[0] = '=';
    toto[1] = ' ';
    while(p[0] != '>')
    {
      q = SU_strchrl(p,toto,&res);
      if(q == NULL)
        break;
      if(q > r) /* Attention ici, si on veux plus tard recup les non Name=Value */
        break;
      len = q-p;
      if(len >= sizeof(buf))
        len = sizeof(buf) - 1;
      memcpy(buf,p,len);
      buf[len] = 0;
      /* buf contient la partie Name de Name=Value */
      p = SU_TrimLeft(q + 1);
      if(res == ' ')
      {
        if(p[0] != '=')
          continue;
        else
          p = SU_TrimLeft(p+1);
      }
      while((len > 0) && (buf[len-1] == ' '))
      {
        len--;
        buf[len] = 0; /* Remove trailing spaces */
      }
      if((strchr(buf,' ') == NULL) && (res != '>')) /* Si on a bien a faire a un Name=Value */
      {
        if(p[0] == '"') /* Si la partie Value est une chaine */
        {
          c = '"';
          p++;
        }
        else if(p[0] == '\'') /* Si la partie Value est une chaine */
        {
          c = '\'';
          p++;
        }
        else
          c = ' ';
        q = strchr(p,c);
        if(q == NULL)
          q = r;
        if(q > r)
        {
          if((c == '"') || (c == '\'')) /* '>' must be inside the string */
            r = strchr(r+1,'>');
          else
            q = r;
        }
        len = q-p;
        if(len <= 0)
          continue;
        tmp = (char *) malloc(len+1);
        memcpy(tmp,p,len);
        tmp[len] = 0;
        p = q;
        if((c == '"') || (c == '\'')) /* Si la partie Value est une chaine */
          p++;
        if(SU_nocasestrstr(buf,"type") == buf)
          In->Type = tmp;
        else if(SU_nocasestrstr(buf,"name") == buf)
          In->Name = tmp;
        else if(SU_nocasestrstr(buf,"value") == buf)
          In->Value = tmp;
        else
          free(tmp);
      }
      p = SU_TrimLeft(p);
    }
    if(In->Type == NULL)
      In->Type = strdup("text");
    if(In->Name != NULL)
    {
#ifdef __unix__
      if(SU_DebugLevel >= 3)
        printf("Adding INPUT to form[%d] : Type=%s - Name=%s - Value=%s\n",num,(In->Type == NULL)?"(null)":In->Type,(In->Name == NULL)?"(null)":In->Name,(In->Value == NULL)?"(null)":In->Value);
#endif
      Ptr = SU_AddElementHead(Ptr,In);
    }
    else
      SU_FreeInput(In);
    parse = p+1; /* Set parse to the end of INPUT (after the '>') */
    p = SU_nocasestrstr(parse,"<input");
  }
  free(saf);
  Form->Inputs = Ptr;
  return Form;
}

void SU_FreeForm(SU_PForm Form)
{
  SU_PList Ptr;

  Ptr = Form->Inputs;
  while(Ptr != NULL)
  {
    SU_FreeInput((SU_PInput)Ptr->Data);
    Ptr = Ptr->Next;
  }
  SU_FreeList(Form->Inputs);
  if(Form->Method != NULL)
    free(Form->Method);
  if(Form->Name != NULL)
    free(Form->Name);
  if(Form->Action != NULL)
    free(Form->Action);
}

char *SU_AddLocationToUrl(const char *URL,const char *Host,const char *Location)
{
  char *ptr = NULL;
  int len,i;

  if(strncasecmp(Location,"http://",7) != 0) /* Relative path */
  {
    len = strlen(Host)+strlen(URL)+strlen(Location)+strlen("http://")+1;
    ptr = (char *) malloc(len);
    if(Location[0] == '/')
    { /* Relative path, but absolute on the site */
      snprintf(ptr,len,"http://%s",Host);
      /* Remove trailing / if exists */
      if(ptr[strlen(ptr)-1] == '/' )
        ptr[strlen(ptr)-1] = 0;
    }
    else
    { /* Relative path from current directory */
//      if(SW_Proxy_String != NULL)
      if(strncasecmp(URL,"http://",7) == 0) /* If using proxy, or if URL is already absolute */
        SU_strcpy(ptr,URL,len);
      else
        snprintf(ptr,len,"http://%s%s",Host,URL);
      if(strcmp(ptr+strlen("http://"),Host) == 0) /* If requested the root of the site */
        SU_strcat(ptr,"/",len);
      else
      {
        i = strlen(ptr) - 1;
        while(i>=0)
        {
          if(ptr[i] == '/')
          {
            ptr[i+1] = 0;
            break;
          }
          i--;
        }
      }
    }
    SU_strcat(ptr,Location,len);
  }
  else
    ptr = strdup(Location);
  return ptr;
}

/* Skips white spaces before the string, then extracts it */
char *SU_GetStringFromHtml(const char Ans[],const char TextBefore[])
{
  char *p,*q,*tmp;
  char c;
  int len;

  p = strstr(Ans,TextBefore);
  if(p == NULL)
    return NULL;
  p += strlen(TextBefore);
  while(p[0] == ' ') /* Remove spaces */
    p++;

  if(p[0] == '"') /* If we have a string */
  {
    c = '"';
    p++;
  }
  else if(p[0] == '\'') /* If we have a string */
  {
    c = '\'';
    p++;
  }
  else
    c = ' ';
  q = strchr(p,c);
  if(q == NULL)
    return NULL;
  len = q-p;
  tmp = (char *) malloc(len+1);
  memcpy(tmp,p,len);
  tmp[len] = 0;
  return tmp;
}

