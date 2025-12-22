#include "windows.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <regex.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>

#define HANDLE_TYPE_FILE_DESCRIPTOR 0
#define HANDLE_TYPE_FIND_FILE       1

#define SECS_BETWEEN_EPOCHS 11644473600LL
#define SECS_TO_100NS       10000000

typedef struct _tagFINDFILE
{
  DIR *pDir;
  regex_t reg;
  TCHAR dir[MAX_PATH];
} FINDFILE,*PFINDFILE,*LPFINDFILE;


HANDLE CreateFile(LPCTSTR lpFileName,DWORD dwDesiredAccess,DWORD dwShareMode,LPSECURITY_ATTRIBUTES lpSecurityAttributes,DWORD dwCreationDisposition,DWORD dwFlagsAndAttributes,HANDLE hTemplateFile)
{
  // build up the access mode
  mode_t mode = 0;
  HANDLE handle;
  void* handlePoint;
  int fd;

  if (dwDesiredAccess & (GENERIC_READ  | FILE_GENERIC_READ))
  {
    if (dwDesiredAccess & (GENERIC_WRITE | FILE_GENERIC_WRITE))
      mode = O_RDWR;
    else
      mode = O_RDONLY;
  }
  else if (dwDesiredAccess & (GENERIC_WRITE | FILE_GENERIC_WRITE))
  {
    mode = O_WRONLY;
  }

  switch (dwCreationDisposition)
  {
  case CREATE_ALWAYS:
    mode |= O_CREAT | O_TRUNC;	/* create and truncate */
    break;
  case CREATE_NEW:
    mode |= O_CREAT | O_EXCL;	/* create new, but fail if exist */
    break;
  case OPEN_ALWAYS:		/* opens, otherwise create */
    mode |= O_CREAT;
    break;
  case OPEN_EXISTING:		/* open, but fail if not exist */
    break;
  case TRUNCATE_EXISTING:	/* opens and truncates, fail on exist */
    mode |= O_CREAT | O_TRUNC | O_EXCL;
    break;
  }

  /* now open the file */
  fd = open(lpFileName,mode);
  if (fd < 0)
    return INVALID_HANDLE_VALUE;
  /* allocate new handle */
  handlePoint = malloc(sizeof(struct _tagHANDLE));
  handle = static_cast<HANDLE>(handlePoint);
  if (!handle)
  {
    close(fd);
    return INVALID_HANDLE_VALUE;
  }
  handle->type = HANDLE_TYPE_FILE_DESCRIPTOR;
  handle->iVal = fd;
  return handle;
}

BOOL CloseHandle(HANDLE hHandle)
{
  LPFINDFILE pfFile;

  if (!hHandle)
    return FALSE;
  
  switch (hHandle->type)
  {
  case HANDLE_TYPE_FILE_DESCRIPTOR:
    close(hHandle->iVal);
    break;
  case HANDLE_TYPE_FIND_FILE:
    pfFile = (LPFINDFILE)hHandle->p;
    closedir(pfFile->pDir);
    regfree(&pfFile->reg);
    free(pfFile);
    break;
  default:
    return FALSE;
  }
  /* reset type to protect against multiple calls */
  hHandle->type = -1;
  /* now free it */
  free(hHandle);
  return TRUE;
}

DWORD GetFileSize(HANDLE hFile,LPDWORD lpFileSizeHigh)
{
  struct stat st;
  if (!hFile || 
      hFile->type != HANDLE_TYPE_FILE_DESCRIPTOR ||
      fstat(hFile->iVal,&st))
  {
    return INVALID_FILE_SIZE;
  }
  
  if (lpFileSizeHigh)
  {
    *lpFileSizeHigh = 0;
  }
  return st.st_size;
}

BOOL ReadFile(HANDLE hFile,LPVOID lpBuffer,DWORD nNumberOfBytesToRead,LPDWORD lpNumberOfBytesRead,LPOVERLAPPED lpOverlapped)
{
  ssize_t sz;
  
  if (!hFile || 
      hFile->type != HANDLE_TYPE_FILE_DESCRIPTOR ||
      !lpNumberOfBytesRead || 
      lpOverlapped)
  {
    return FALSE;
  }
  
  sz = read(hFile->iVal,lpBuffer,nNumberOfBytesToRead);
  if (sz == -1)
    return FALSE;
  
  *lpNumberOfBytesRead = sz;
  return TRUE;
}

DWORD SetFilePointer(HANDLE hFile,LONG lDistanceToMove,PLONG lpDistanceToMoveHigh,DWORD dwMoveMethod)
{
  int whence;
  off_t ret;

  if (!hFile || 
      hFile->type != HANDLE_TYPE_FILE_DESCRIPTOR)
  {
    return INVALID_FILE_SET_POINTER;
  }
  
  switch (dwMoveMethod)
  {
  case FILE_BEGIN:
    whence = SEEK_SET;
    break;
  case FILE_CURRENT:
    whence = SEEK_CUR;
    break;
  case FILE_END:
    whence = SEEK_END;
    break;
  default:
    return INVALID_FILE_SET_POINTER;
  }

  ret = lseek(hFile->iVal,lDistanceToMove,whence);
  if (ret == -1)
    return INVALID_FILE_SET_POINTER;

  return ret;
}

static void ConvertRegExp(LPTSTR pRegExp,LPCTSTR pSource)
{
  char *p;
  for (p=pSource;*p;++p)
  {
    switch (*p)
    {
    case '.':
      *(pRegExp++) = '\\';
      *(pRegExp++) = '.';
      break;
    case '*':
      *(pRegExp++) = '.';
      *(pRegExp++) = '*';
      break;
    default:
      *(pRegExp++) = *p;
    }
  }
  *pRegExp = 0;
}

static BOOL ConvertToRegExp(LPTSTR pRegExp,LPTSTR pDir,LPCTSTR pFindString)
{
  TCHAR copy[MAX_PATH];
  char *last;

  /* do a fast check */
  if (strcmp(pFindString,"*.*") == 0) {
    strcpy(pDir,".");
    strcpy(pRegExp,".*");
    return TRUE;
  }
  
  strcpy(copy,pFindString);
  /* convert all \\ to / */
  for (last=copy;*last;++last)
  {
    if (*last == '\\')
      *last = '/';
  }

  last = strrchr(copy,'/');
  if (last)
  {
    *last = 0;
    strcpy(pDir,copy);
    ConvertRegExp(pRegExp,last+1);
  }
  else
  {
    strcpy(pDir,".");
    ConvertRegExp(pRegExp,copy);
  }
  return TRUE;
}

HANDLE FindFirstFile(LPCTSTR lpFileName,LPWIN32_FIND_DATA lpFindFileData)
{
  TCHAR regexp[MAX_PATH];
  TCHAR dir[MAX_PATH];
  LPFINDFILE pfFile;
  HANDLE hFind;
  void* handlePoint;

  printf("FindFirstFile %s\n",lpFileName);
  
  if (!ConvertToRegExp(regexp,dir,lpFileName))
    return NULL;
  /* allocate memory now */
  handlePoint = malloc(sizeof(struct _tagHANDLE));
  hFind = static_cast<HANDLE>(handlePoint);
  
  handlePoint = malloc(sizeof(FINDFILE));
  pfFile = static_cast<LPFINDFILE>(handlePoint);
  
  memset(pfFile,0,sizeof(FINDFILE));

  hFind->type = HANDLE_TYPE_FIND_FILE;
  hFind->p = pfFile;
  
  if (!(pfFile->pDir = opendir(dir)) ||
      regcomp(&pfFile->reg,regexp,REG_ICASE | REG_NOSUB))
  {
    goto fff_error;
  }

  strcpy(pfFile->dir,dir);
  if (!FindNextFile(hFind,lpFindFileData))
    goto fff_error;

  return hFind;
 fff_error:
  if (hFind) free(hFind);
  if (pfFile) 
  {
    if (pfFile->pDir) closedir(pfFile->pDir);
    if (pfFile->reg.buffer) regfree(&pfFile->reg);
    free(pfFile);
  }
  return NULL;
}

/*++
  Function:
  FILEUnixTimeToFileTime
  
  Convert a time_t value to a win32 FILETIME structure, as described in
  MSDN documentation. time_t is the number of seconds elapsed since 
  00:00 01 January 1970 UTC (Unix epoch), while FILETIME represents a 
  64-bit number of 100-nanosecond intervals that have passed since 00:00 
  01 January 1601 UTC (win32 epoch).
  --*/
static FILETIME UnixTimeToFileTime( time_t sec, long nsec )
{
  int64_t Result;
  FILETIME Ret;
  
  Result = ((int64_t)sec + SECS_BETWEEN_EPOCHS) * SECS_TO_100NS + (nsec / 100);
  
  Ret.dwLowDateTime = (DWORD)Result;
  Ret.dwHighDateTime = (DWORD)(Result >> 32);
  return Ret;
}

BOOL FindNextFile(HANDLE hFindFile,LPWIN32_FIND_DATA lpFindFileData)
{
  void* handlePoint;
  LPFINDFILE pfFile;
  struct dirent *pdir;
  struct stat st;
  TCHAR fullPath[MAX_PATH];

  if (!hFindFile || 
      hFindFile->type != HANDLE_TYPE_FIND_FILE)
    return FALSE;

handlePoint = hFindFile->p;
  pfFile = static_cast<LPFINDFILE>(handlePoint);
  while ((pdir = readdir(pfFile->pDir)))
  {
    /* see if the name matches */
    if (regexec(&pfFile->reg,pdir->d_name,0,NULL,0) == 0)
    {
      /* found one */
      strcpy(fullPath,pfFile->dir);
      strcat(fullPath,"/");
      strcat(fullPath,pdir->d_name);
      if (stat(fullPath,&st) == 0)
      {
	/* copy into the find data */
	if (S_ISREG(st.st_mode))
	  lpFindFileData->dwFileAttributes = FILE_ATTRIBUTE_DIRECTORY;
	else 
	  lpFindFileData->dwFileAttributes = FILE_ATTRIBUTE_NORMAL;
	
	lpFindFileData->ftCreationTime = UnixTimeToFileTime(st.st_ctime,0);
	lpFindFileData->ftLastAccessTime = UnixTimeToFileTime(st.st_atime,0);
	lpFindFileData->ftLastWriteTime = UnixTimeToFileTime(st.st_mtime,0);
	lpFindFileData->nFileSizeLow = st.st_size;
	lpFindFileData->nFileSizeHigh = 0;
	lpFindFileData->dwReserved0 = lpFindFileData->dwReserved1 = 0;
	strcpy(lpFindFileData->cFileName,pdir->d_name);
	*lpFindFileData->cAlternateFileName = 0;
	return TRUE;
      }
    }
  }
  return FALSE;
}

BOOL FindClose(HANDLE hFindFile)
{
  return CloseHandle(hFindFile);
}
