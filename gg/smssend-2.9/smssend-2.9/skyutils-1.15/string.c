/****************************************************************/
/* String unit                                                  */
/* (c) Christophe CALMEJANE (Ze KiLleR) - 1999-01               */
/****************************************************************/
#include "skyutils.h"
#include <ctype.h>
#include <string.h>

#undef malloc
#undef calloc
#undef realloc
#undef strdup
#undef free

char *SU_CurrentParseString;
char SU_ZeroString[]="";

char *SU_strcat(char *dest,const char *src,int len)
{
  int pos=strlen(dest);

  if(src == NULL)
    return dest;
  if(pos >= (len-1))
    return dest;
  do
  {
    dest[pos] = src[0];
    pos++;
    src++;
    if(src[0] == 0)
      break;
  } while(pos < (len-1));
  dest[pos] = 0;
  return dest;
}

char *SU_strcpy(char *dest,const char *src,int len)
{
  int pos=0;

  if(src != NULL)
  {
    while(pos < (len-1))
    {
      dest[pos] = src[pos];
      pos++;
      if(src[pos] == 0)
        break;
    }
  }
  dest[pos] = 0;
  return dest;
}

char *SU_nocasestrstr(char *text, char *tofind)  /* like strstr(), but nocase */
{
   char *ret = text, *find = tofind;

   while(1)
   {
      if(*find == 0) return ret;
      if(*text == 0) return 0;
      if(toupper(*find) != toupper(*text))
      {
        ret = text+1;
        find = tofind;
        if(toupper(*find) == toupper(*text))
        find++;
      } else
        find++;
      text++;
   }
}

bool SU_strwcmp(const char *s,const char *wild) /* True if wild equals s (wild may use '*') */
{
  char *pos,*pos2;
  int len;
  char tmp[512];

  while((s[0] != 0) && (wild[0] != 0))
  {
    if(wild[0] == '*') /* Start wild mode */
    {
      if(wild[1] == 0) /* End of wild string */
        return true;
      wild++;
#ifdef __unix__
      pos = strchr(wild,'*');
#else
      pos = strchr((char *)wild,'*');
#endif
      if(pos != NULL)
      {
        len = pos-wild+1; /* +1 for the \0 */
        if(len > sizeof(tmp))
          len = sizeof(tmp);
        SU_strcpy(tmp,wild,len);
//        tmp[len] = 0;
      }
      else
        SU_strcpy(tmp,wild,sizeof(tmp));
#ifdef __unix__
      pos2 = strstr(s,tmp);
#else
      pos2 = strstr((char *)s,tmp);
#endif
      len = strlen(tmp);
      if(pos2 == NULL)
        return false;
      s = pos2 + len;
      wild += len;
      if(pos == NULL) /* In last part, check for length */
        return (s[0] == 0);
    }
    else
    {
      if(s[0] == wild[0])
      {
        s++;
        wild++;
      }
      else
        return false;
    }
  }
  if((s[0] == 0) && (wild[0] == 0))
    return true;
  if((s[0] == 0) && (wild[0] == '*'))
  {
    if(wild[1] == 0)
      return true;
  }
  return false;
}

bool SU_nocasestrwcmp(const char *s,const char *wild) /* Same as strwcmp but without case */
{
  char *pos,*pos2;
  int len;
  char tmp[512];

  while((s[0] != 0) && (wild[0] != 0))
  {
    if(wild[0] == '*') /* Start wild mode */
    {
      if(wild[1] == 0) /* End of wild string */
        return true;
      wild++;
#ifdef __unix__
      pos = strchr(wild,'*');
#else
      pos = strchr((char *)wild,'*');
#endif
      if(pos != NULL)
      {
        len = pos-wild+1; /* +1 for the \0 */
        if(len > sizeof(tmp))
          len = sizeof(tmp);
        SU_strcpy(tmp,wild,len);
        //tmp[len] = 0;
      }
      else
        SU_strcpy(tmp,wild,sizeof(tmp));
      pos2 = SU_nocasestrstr((char *)s,tmp);
      len = strlen(tmp);
      if(pos2 == NULL)
        return false;
      s = pos2 + len;
      wild += len;
      if(pos == NULL) /* In last part, check for length */
        return (s[0] == 0);
    }
    else
    {
      if(toupper(s[0]) == toupper(wild[0]))
      {
        s++;
        wild++;
      }
      else
        return false;
    }
  }
  if((s[0] == 0) && (wild[0] == 0))
    return true;
  if((s[0] == 0) && (wild[0] == '*'))
  {
    if(wild[1] == 0)
      return true;
  }
  return false;
}


bool SU_ReadLine(FILE *fp,char S[],int len)
{
  int i;
  char c;

  i = 0;
  S[0] = 0;
  if(fread(&c,1,1,fp) != 1)
    return 0;
  while((c == 0x0A) || (c == 0x0D))
  {
    if(fread(&c,1,1,fp) != 1)
      return 0;
  }
  while((c != 0x0A) && (c != 0x0D))
  {
    if(i >= (len-1))
      break;
    S[i++] = c;
    if(fread(&c,1,1,fp) != 1)
      break;
  }
  S[i] = 0;
  return 1;
}

/* Parses a config file with lines like "Name Value" */
/* Rreturns false on EOF */
bool SU_ParseConfig(FILE *fp,char Name[],int nsize,char Value[],int vsize)
{
  char S[4096];
  char *p,*q;

  while(SU_ReadLine(fp,S,sizeof(S)))
  {
    if((S[0] == '#') || (S[0] == 0))
      continue;
    q = S;
    while((q[0] == ' ') || (q[0] == '\t'))
      q++;
    if((q[0] == '#') || (q[0] == 0))
      continue;
    Value[0] = 0;
    p = strchr(q,' ');
    if(p != NULL)
      p[0] = 0;
    SU_strcpy(Name,q,nsize);
    if(p == NULL)
      return true;
    p++;
    while((p[0] == ' ') || (p[0] == '\t'))
      p++;
    SU_strcpy(Value,p,vsize);
    return true;
  }
  return false;
}


char *SU_TrimLeft(const char *S)
{
  int i;

  if(S == NULL)
    return NULL;
  i = 0;
  while(S[i] == ' ')
  {
    i++;
  }
  return (char *)(S+i);
}

void SU_TrimRight(char *S)
{
  int i;

  if(S == NULL)
    return;
  i = strlen(S)-1;
  while(S[i] == ' ')
  {
    S[i] = 0;
    i--;
  }
}

char *SU_strparse(char *s,char delim)
{
  char *p,*ret;

  if(s != NULL)
    SU_CurrentParseString = s;
  if(SU_CurrentParseString == NULL)
    return NULL;
  if(SU_CurrentParseString[0] == delim)
  {
    SU_CurrentParseString++;
    return SU_ZeroString;
  }
  p = strchr(SU_CurrentParseString,delim);
  ret = SU_CurrentParseString;
  SU_CurrentParseString = p;
  if(p != NULL)
  {
    p[0] = 0;
    SU_CurrentParseString++;
  }
  return ret;
}

 /* Extracts file name (with suffix) from path */
void SU_ExtractFileName(const char Path[],char FileName[],const int len)
{
  char *pos;

#ifdef __unix__
  pos = strrchr(Path,'/');
#else
  pos = strrchr((char *)Path,'/');
#endif
  if(pos == NULL)
    SU_strcpy(FileName,Path,len);
  else
    SU_strcpy(FileName,pos+1,len);
}

char *SU_strchrl(const char *s,const char *l,char *found)
{
  long int len,i;

  len = strlen(l);
  while(s[0] != 0)
  {
    for(i=0;i<len;i++)
    {
      if(s[0] == l[i])
      {
        *found = s[0];
        return (char *)s;
      }
    }
    s++;
  }
  return NULL;
}

char *SU_strrchrl(const char *s,const char *l,char *found)
{
  long int len,i,j;

  len = strlen(l);
  for(j=strlen(s)-1;j>=0;j--)
  {
    for(i=0;i<len;i++)
    {
      if(s[j] == l[i])
      {
        *found = s[j];
        return (char *)(s+j);
      }
    }
  }
  return NULL;
}

unsigned char SU_toupper(unsigned char c)
{
  if((c >= 'a') && (c <= 'z'))
    return (c-32);
  if((c >= 224) && (c <= 255))
    return (c-32);
  return c;
}

unsigned char SU_tolower(unsigned char c)
{
  if((c >= 'A') && (c <= 'Z'))
    return (c+32);
  if((c >= 192) && (c <= 223))
    return (c+32);
  return c;
}

bool SU_strcasecmp(const char *s,const char *p)
{
  while((*s != 0) && (*p != 0))
  {
    if(SU_toupper(*s) != SU_toupper(*p))
      return false;
    s++;p++;
  }
  return ((*s == 0) && (*p == 0));
}

