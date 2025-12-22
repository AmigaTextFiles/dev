#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/dir.h>

#ifdef AIX
  #define USE_DIRENT
#endif
#ifdef NEXT
  #define USE_DIRECT
#endif
#ifdef LINUX
  #define USE_DIRECT
#endif

#ifdef USE_DIRENT
  #define DIRTYPE	struct dirent
#else
  #define DIRTYPE	struct direct
#endif


#define DIRSEP	'/'

extern char * EXFUN(malloc,(unsigned));

static DIR*
DEFUN(to_dir, (T), TERM T)
{
  return (DIR*)T;
}


static TERM
DEFUN(to_term, (D), DIR* D)
{
   return (TERM)D;
}



static char*
DEFUN(getName, (NAME), TERM NAME)
{
  unsigned len = (unsigned)Stringlength_0(copy__RUNTIME_string(NAME));
  char*	   name = (char*) malloc(len+1);
  if (name != 0) {
    STRING_TERM_to_CHAR_ARRAY(NAME, len, name);
  }
  return name;
}


void
DEFUN(xx_SysFilesgetdir_0, (SYSI, DIRNAME, OK, RES, SYSO),
      TERM	SYSI		AND
      TERM	DIRNAME		AND
      TERM*	OK		AND
      TERM*	RES		AND
      TERM*	SYSO)
{
   char* dirname = getName(DIRNAME);
   *SYSO = SYSI;

   if (dirname == 0) {
     *OK = false;
     *RES = MKxx2(0, (TERM)0, DIRNAME);
   } else {
     DIR* dir;

     dir = opendir(dirname);
     free (dirname);
     *RES = MKxx2(0, to_term(dir), DIRNAME);
     if (dir == 0) {
	*OK = false;
     } else {
        *OK = true;
     }
   }
}


void
DEFUN(xx_SysFileshd_0, (DIRI, OK, NAME, LEN, TYPE, DIRO),
      TERM	DIRI		AND
      TERM*	OK		AND
      TERM*	NAME		AND
      TERM*	LEN		AND
      TERM*	TYPE		AND
      TERM*	DIRO)
{
  DIR* dir;
  *DIRO = DIRI;
  dir = to_dir(DIRI->ARGS[0]);
  if (dir == 0) {
    *OK = false;
    *NAME = MT;
    *LEN  = (TERM)0;
    *TYPE = co__SysFilesunknown_0;
  } else {
    DIRTYPE* entry;
    entry = readdir(dir);
    if (entry == 0) {
       *OK = false;
       *NAME = MT;
       *LEN  = (TERM)0;
       *TYPE = co__SysFilesunknown_0;
    } else {
      struct stat statbuf;
      char* dirname = getName(DIRI->ARGS[1]);
      char* filename = entry->d_name;
#ifdef USE_DIRENT
      int namelen = entry->d_namlen;
#else
      int namelen = strlen(filename);
#endif
      char* fullname = (char*)malloc(strlen(dirname)+1+namelen+1);
      strcpy(fullname, dirname);
      free(dirname);
      if (fullname[strlen(fullname)] != DIRSEP) {
        fullname[strlen(fullname)+1] = 0;
        fullname[strlen(fullname)] = DIRSEP;
      }
      strncat(fullname, filename, namelen);
      if (-1 == stat(fullname, &statbuf)) {
        *OK = false;
        *NAME = MT;
        *LEN  = (TERM)0;
        *TYPE = co__SysFilesunknown_0;
      } else {
        unsigned int  type = (unsigned int)statbuf.st_mode;
        *OK = true;
        *NAME = _RUNTIME_mk0STRING(filename);
        *LEN = (TERM)statbuf.st_size;

        if (type & S_IFDIR)
           *TYPE = co__SysFilesdir_0;
	else if (type & S_IFREG)
           *TYPE = co__SysFilesfile_0;
        else if (type & S_IFCHR)
           *TYPE = co__SysFileschardev_0;
        else if (type & S_IFBLK)
           *TYPE = co__SysFilesblockdev_0;
        else if (type & S_IFLNK)
           *TYPE = co__SysFilessymlink_0;
        else if (type & S_IFSOCK)
           *TYPE = co__SysFilessocket_0;
        else
           *TYPE = co__SysFilesunknown_0;
      }
      free(fullname);
    }
  }
}


XCOPY(xcopy_SysFiles_directory) 
{ 
   return CP(A); 
}

XFREE(xfree_SysFiles_directory)
{
   if(DZ_REF(A) && ((DIR*)A->ARGS[0] != 0)) {
     closedir((DIR*)A->ARGS[0]);
     free__RUNTIME_string(A->ARGS[1]);
     MDEALLOC(2,A);
   }
}


XEQ(x_X61_X61_SysFiles_directory)
{
   if (A1==A2) { /* the one and only case */
       xfree_SysFiles_directory(S,A1);
       xfree_SysFiles_directory(S,A2);
       return true;
   } else {
       xfree_SysFiles_directory(S,A1);
       xfree_SysFiles_directory(S,A2);
       return false;
   }
}

XREAD(xread_SysFiles_directory)
{
   *SYSO = SYSI;
   *OK = false;
   *RES = A;
}

XWRITE(xwrite_SysFiles_directory)
{
   S_OUT("directory(");
   write__RUNTIME_string(copy__RUNTIME_string(A->ARGS[1]),SYSI,OK,SYSO);
   C_OUT(')');
}


void
DEFUN(xx_SysFilesexistfile_0,(FN,sysi,res,syso),
      TERM FN   AND
      TERM sysi AND
      TERM *res AND
      TERM *syso)
{ FILE *fopen(),*fp;
#ifdef NEED_STD_DECL
  extern void EXFUN(free,(char *));
#endif
  char *FNC;
  unsigned LEN=(unsigned)Stringlength_0(CP(FN));
  *syso= sysi;
  FNC = malloc(LEN+1);
  if(FNC==NULL) {
    *res = false;
  } else {
    STRING_TERM_to_CHAR_ARRAY(FN,LEN,FNC);
    if ((fp=fopen(FNC,"r")) == NULL)
      *res = false;
    else {
      fclose(fp);
      *res = true;
    }
    free(FNC);
  }
  free__RUNTIME_string(FN);
}


void
DEFUN(xx_SysFilesdeletefile_0,(FN,sysi,res,syso),
      TERM FN   AND
      TERM sysi AND
      TERM *res AND
      TERM *syso)
{
#ifdef NEED_STD_DECL
  extern int EXFUN(unlink,(char *));
  extern void EXFUN(free,(char *));
#endif  
  char *FNC;
  unsigned LEN=(unsigned)Stringlength_0(CP(FN));
  *syso= sysi;
  FNC = malloc(LEN+1);
  if(FNC==NULL) {
    *res = false;
  } else {
    STRING_TERM_to_CHAR_ARRAY(FN,LEN,FNC);
    if (unlink(FNC) == 0)
      *res = true;
    else 
      *res = false;
    free(FNC);
  }
  free__RUNTIME_string(FN);
}


XINITIALIZE(SysFiles_Xinitialize,__XINIT_SysFiles)
