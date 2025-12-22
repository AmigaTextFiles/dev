/****************************************************************/
/* Win32 registry functions                                     */
/* (c) Christophe CALMEJANE (Ze KiLleR) - 1999-01               */
/****************************************************************/

#include "skyutils.h"
#include <winreg.h>

#undef malloc
#undef calloc
#undef realloc
#undef strdup
#undef free

HKEY SU_RB_OpenKeys(const char Key[],int Access)
{
  HKEY H;
  char *tmp,*p,*q;

  if(Key == NULL)
    return 0;
  tmp = strdup(Key);
  p = strtok(tmp,"\\");
  if(p == NULL)
  {
    free(tmp);
    return 0;
  }
  if(strcmp(p,"HKEY_CLASSES_ROOT") == 0)
    H = HKEY_CLASSES_ROOT;
  else if(strcmp(p,"HKEY_CURRENT_USER") == 0)
    H = HKEY_CURRENT_USER;
  else if(strcmp(p,"HKEY_LOCAL_MACHINE") == 0)
    H = HKEY_LOCAL_MACHINE;
  else if(strcmp(p,"HKEY_USERS") == 0)
    H = HKEY_USERS;
  else
  {
    free(tmp);
    return 0;
  }

  p = strtok(NULL,"\\");
  if(p == NULL)
  {
    free(tmp);
    return 0;
  }
  q = strtok(NULL,"\\");
  while(q != NULL)
  {
    if(RegOpenKeyEx(H,p,0,KEY_READ || Access,&H) != ERROR_SUCCESS)
	{
      free(tmp);
      return 0;
	}
    p = q;
    q = strtok(NULL,"\\");
  }
  free(tmp);
  return H;
}

HKEY SU_RB_CreateKeys(const char Key[])
{
  HKEY H;
  DWORD Ret;
  char *tmp,*p,*q;

  if(Key == NULL)
    return 0;
  tmp = strdup(Key);
  p = strtok(tmp,"\\");
  if(p == NULL)
  {
    free(tmp);
    return 0;
  }
  if(strcmp(p,"HKEY_CLASSES_ROOT") == 0)
    H = HKEY_CLASSES_ROOT;
  else if(strcmp(p,"HKEY_CURRENT_USER") == 0)
    H = HKEY_CURRENT_USER;
  else if(strcmp(p,"HKEY_LOCAL_MACHINE") == 0)
    H = HKEY_LOCAL_MACHINE;
  else if(strcmp(p,"HKEY_USERS") == 0)
    H = HKEY_USERS;
  else
  {
    free(tmp);
    return 0;
  }

  p = strtok(NULL,"\\");
  if(p == NULL)
  {
    free(tmp);
    return 0;
  }
  q = strtok(NULL,"\\");
  while(q != NULL)
  {
    if(RegCreateKeyEx(H,p,0,"",REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL,&H,&Ret) != ERROR_SUCCESS)
	{
      free(tmp);
      return 0;
	}
    p = q;
    q = strtok(NULL,"\\");
  }
  free(tmp);
  return H;
}

void SU_RB_GetStrValue(const char Key[],char *buf,int buf_len,const char Default[])
{
  HKEY Handle;
  char *p;
  DWORD VType;
  DWORD Size;

  SU_strcpy(buf,Default,buf_len);
  Handle = SU_RB_OpenKeys(Key,0);
  if(Handle == 0)
    return;
  p = strrchr(Key,'\\');
  if(p == NULL)
    return;
  p++;
  Size = buf_len;
  RegQueryValueEx(Handle,p,NULL,&VType,buf,&Size);
}

int SU_RB_GetIntValue(const char Key[],int Default)
{
  HKEY Handle;
  char *p;
  int Value;
  DWORD VType;
  DWORD Size;
  long R;

  Handle = SU_RB_OpenKeys(Key,0);
  if(Handle == 0)
    return Default;
  p = strrchr(Key,'\\');
  if(p == NULL)
    return Default;
  p++;
  Size = sizeof(Value);
  R = RegQueryValueEx(Handle,p,NULL,&VType,(BYTE *)&Value,&Size);
  if(R != ERROR_SUCCESS)
    return Default;
  return Value;
}

bool SU_RB_SetStrValue(const char Key[],const char Value[])
{
  HKEY Handle;
  char *p;
  long R;

  Handle = SU_RB_CreateKeys(Key);
  if(Handle == 0)
    return false;
  p = strrchr(Key,'\\');
  if(p == NULL)
    return false;
  p++;
  R = RegSetValueEx(Handle,p,0,REG_SZ,Value,strlen(Value)+1);
  return (R == ERROR_SUCCESS);
}

bool SU_RB_SetIntValue(const char Key[],int Value)
{
  HKEY Handle;
  char *p;
  long R;

  Handle = SU_RB_CreateKeys(Key);
  if(Handle == 0)
    return false;
  p = strrchr(Key,'\\');
  if(p == NULL)
    return false;
  p++;
  R = RegSetValueEx(Handle,p,0,REG_DWORD,(BYTE *)&Value,sizeof(Value));
  return (R == ERROR_SUCCESS);
}

bool SU_RB_DelKey(const char Key[])
{
  HKEY Handle;
  char *p;

  Handle = SU_RB_OpenKeys(Key,KEY_SET_VALUE);
  if(Handle == 0)
    return false;
  p = strrchr(Key,'\\');
  if(p == NULL)
    return false;
  p++;
  RegDeleteKey(Handle,p);
  return true;
}

bool SU_RB_DelValue(const char Key[])
{
  HKEY Handle;
  char *p;

  Handle = SU_RB_OpenKeys(Key,KEY_SET_VALUE);
  if(Handle == 0)
    return false;
  p = strrchr(Key,'\\');
  if(p == NULL)
    return false;
  p++;
  RegDeleteValue(Handle,p);
  return true;
}
