#include "amigaos.h"

#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/usergroup.h>
#include <proto/utility.h>

#include <dos/dos.h>
#include <dos/var.h>
#include <utility/hooks.h>

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define MAX_ENV_SIZE 1024  /* maximum number of environ entries */

/* clib2 specific controls */
int __minimum_os_lib_version = 51;
char * __minimum_os_lib_error = "Requires AmigaOS 4.0";
BOOL __open_locale = FALSE;

char **environ = 0;

static struct UserGroupIFace *IUG = 0;
static struct Library *UGBase = 0;

void ___makeenviron() __attribute__((constructor));
void ___freeenviron() __attribute__((destructor));
void usergroup_init(void) __attribute__((constructor));
void usergroup_term(void) __attribute__((destructor));

#ifdef __NEWLIB__
void __translate_path(const char *in, char *out);

void __translate_path(const char *in, char *out)
{
	int absolute = (in[0] == '/');
	int dot = 0;
	int slashign = 0;

	if (absolute) in++;

	while (*in)
	{
		if (slashign && in[0] == '/')
		{
			slashign = 0;
		}
		else if (absolute && in[0] == '/')
		{
			/* Absolute path, replace first / with : */
			*out++ = ':';
			absolute = 0;
		}
		else if (dot)
		{
			dot = 0;
			/* Previous char was a dot */
			if (in[0] == '.')
			{
				/* Current is also a dot, make it a parent in out */
				*out++ = '/';
			}
			else if (in[0] == '/')
			{
				/* Current dir, ignore the following slash */
				slashign = 1;
			}
			else
			{
				/* A "solitary" dot, output it */
				*out++ = '.';
			}
		}
		else
		{
			if (in[0] == '.')
			{
				dot = 1;
			}
			else
				*out ++ = *in;
		}

		in++;
	}

	*out = '\0';
}
#endif

void usergroup_init(void)
{
  IUG = 0;

  UGBase = IExec->OpenLibrary("usergroup.library", 4);
  if (!UGBase)
    return;

  IUG = (struct UserGroupIFace *)IExec->GetInterface(UGBase, "main", 1, NULL);
}

void usergroup_term(void)
{
  if (IUG)
    IExec->DropInterface((struct Interface *)IUG);

  if (UGBase)
    IExec->CloseLibrary(UGBase);
}

char *getlogin(void)
{
	if (IUG)
		return IUG->getlogin();

	return NULL;
}

uint32
copy_env(struct Hook *hook, APTR userdata, struct ScanVarsMsg *message)
{
  static uint32 env_size = 1;  // environ is null terminated

  if ( strlen(message->sv_GDir) <= 4 )
  {
    if ( env_size == MAX_ENV_SIZE )
    {
      return 0;
    }

    ++env_size;

    char **env = (char **)hook->h_Data;
    uint32 size = strlen(message->sv_Name) + 1 + message->sv_VarLen + 1 + 1;
    char *buffer= (char*)malloc(size);

    snprintf(buffer, size-1, "%s=%s", message->sv_Name, message->sv_Var);

    *env = buffer;
    ++env;
    hook->h_Data = env;
  }

  return 0;
}

void
___makeenviron()
{
  size_t environ_size = MAX_ENV_SIZE * sizeof(char*);
  environ = (char **)malloc(environ_size);
  if ( !environ )
  {
    return;
  }

  memset(environ, 0, environ_size);

  struct Hook hook;
  memset(&hook, 0, sizeof(struct Hook));
  hook.h_Entry = copy_env;
  hook.h_Data = environ;

  IDOS->ScanVars(&hook, GVF_LOCAL_ONLY, 0);
}

void
___freeenviron()
{
  for ( char **i = environ; *i != NULL; ++i )
  {
    free(*i);
    *i = 0;
  }

  free(environ);
  environ = 0;
}

#ifdef __NEWLIB__
void ExitCode(long ret, long data)
{
  exit(ret);
}

int execvp(const char *file, char *const argv[])
{
  unsigned int len = 0;
  int i;
  char *filename;
  char buffer[1000];
  long error;

  __translate_path(file, buffer);

  if (!file || !argv)
    return -1;

  len = strlen(buffer) + 1;

  for (i = 0; argv[i]; i++)
  {
    len += strlen(argv[i]) + 1;
    if (strchr(argv[i], ' '))
      len += 2;
  }

  filename = malloc(len);
  if (!filename)
    return -1;

  strcpy(filename, buffer);
  strcat(filename, " ");

  for (i = 0; argv[i]; i++)
  {
    if (strchr(argv[i], ' '))
    {
      strcat(filename, "\"");
      strcat(filename, argv[i]);
      strcat(filename, "\" ");
    }
    else
    {
      strcat(filename, argv[i]);
      strcat(filename, " ");
    }
  }

  error = IDOS->SystemTags(filename,
    NP_CopyVars, TRUE,
    NP_ExitCode, ExitCode,
    TAG_DONE);

  if (error == 0)
    exit(0);

  return -1;
}

int execv(const char *file, char *const argv[])
{
  return execvp(file, argv);
}
#else /* CLIB2  */
void __execve_exit(int return_code)
{
	return 0;
}

int __execve_environ_init(char * const envp[])
{
    if (envp == NULL)
        return 0;

    while (*envp != NULL)
    {
        int len;
        char *var;
        char *val;

        if ((len = strlen(*envp)))
        {
            size_t size = len + 1;
            if ((var = malloc(size)))
            {
                memcpy(var, *envp, size);

                val = strchr(var,'=');
                if(val)
                {
                    *val++='\0';
                    if (*val)
                    {
                        IDOS->SetVar(var,val,strlen(val)+1,GVF_LOCAL_ONLY);
                    }
                }
                free(var);
                var = NULL;
            }
        }
        envp++;
    }
    return 0;
}
#endif

#ifdef __NEWLIB__

uid_t getuid(void)
{
	if (IUG)
		return IUG->getuid();

	return 65535;
}

uid_t geteuid(void)
{
	if (IUG)
		return IUG->geteuid();

	return 65535;
}

gid_t getgid(void)
{
	if (IUG)
		return IUG->getgid();

	return 65535;
}

gid_t getegid(void)
{
	if (IUG)
		return IUG->getegid();

	return 65535;
}

struct group *getgrnam(const char *name)
{
	if (IUG)
		return IUG->getgrnam((char *)name);

	return NULL;
}

struct group *getgrgid(gid_t gid)
{
	if (IUG)
		return IUG->getgrgid(gid);

	return NULL;
}

struct passwd *getpwuid(uid_t uid)
{
	if (IUG)
		return IUG->getpwuid(uid);

	return NULL;
}

struct passwd *getpwnam(const char *name)
{
	if (IUG)
		return IUG->getpwnam((char *)name);

	return NULL;
}

void setpwent(void)
{
	if (IUG)
		IUG->setpwent();
}

void endpwent(void)
{
	if (IUG)
		IUG->endpwent();
}

void setgrent(void)
{
	if (IUG)
		IUG->setgrent();
}

int setgroups(size_t size, const gid_t *list)
{
	if (IUG)
		return IUG->setgroups(size, list);

	return -1;
}

int setgid(gid_t gid)
{
	if (IUG)
		return IUG->setgid(gid);

	return -1;
}

int setuid(uid_t uid)
{
	if (IUG)
		return IUG->setuid(uid);

	return -1;
}

static char __crypt[10] = "";

char * crypt(const char *key, const char *salt)
{
	if (IUG)
		return IUG->crypt((UBYTE *)key, (UBYTE *)salt);

	return __crypt;
}

int symlink(const char *oldpath, const char *newpath)
{
	if (!oldpath || !newpath)
		return -1;

	if (DOSFALSE == IDOS->MakeLink((STRPTR)newpath, (STRPTR)oldpath, LINK_SOFT))
		return -1;

	return 0;
}

int fsync(int fd)
{
	fflush(fd);
}

int statfs (const char *path, struct statfs *buf)
{
	char buffer[1000];
	BPTR lock;
	struct InfoData ifd;
	char *type;

	if (!path || !buf)
		return -1;

	__translate_path(path, buffer);

	lock = IDOS->Lock((STRPTR)buffer, SHARED_LOCK);
	if (!lock)
		return -1;

	if (DOSFALSE == IDOS->Info(lock, &ifd))
	{
		IDOS->UnLock(lock);
		return -1;
	}

    buf->f_bsize = ifd.id_BytesPerBlock > 0 ? ifd.id_BytesPerBlock : 512;
    buf->f_blocks = ifd.id_NumBlocks > 0 ? ifd.id_NumBlocks : 1;
    buf->f_bfree = buf->f_blocks - ifd.id_NumBlocks > 0 ? ifd.id_NumBlocksUsed : 1;
    buf->f_bavail = buf->f_bfree;
    buf->f_ffree = 0x7fffffff;
	buf->f_fsid = ifd.id_DiskType;
	buf->f_files = 1;

	switch (ifd.id_DiskType)
	{
		case ID_NO_DISK_PRESENT:
			type = "No Disk present";
			break;
		case ID_UNREADABLE_DISK:
			type = "Unreadable disk";
			break;
		case ID_BUSY_DISK:
			type = "Dismounted";
			break;
		case ID_DOS_DISK:
			type = "Old file system (OFS, DOS\\0)";
			break;
		case ID_FFS_DISK:
			type = "Old FastFileSystem (FFS, DOS\\1)";
			break;
		case ID_INTER_DOS_DISK:
			type = "Old International file system (OFS, DOS\\2)";
			break;
		case ID_INTER_FFS_DISK:
			type = "International FastFileSystem (FFS, DOS\\3)";
			break;
		case ID_FASTDIR_DOS_DISK:
			type = "Old file system with Dircache (OFS, DOS\\4)";
			break;
		case ID_FASTDIR_FFS_DISK:
			type = "FastFileSystem with Dircache (FFS, DOS\\5)";
			break;
		case ID_LONGNAME_DOS_DISK:
			type = "Old file system with long filenames (OFS, DOS\\6)";
			break;
		case ID_LONGNAME_FFS_DISK:
			type = "FastFileSystem with long filenames (FFS, DOS\\7)";
			break;
		case 0x53465300:
			type = "SmartFileSystem (SFS, SFS\0)";
			break;
		case ID_NOT_REALLY_DOS:
			type = "Not a dosk disk";
			break;
		default:
			type = "Unknown file system";
			break;
	}

	strcpy(buf->f_fstypename, type);

	IDOS->UnLock(lock);

	return 0;
}

void __mempcpy(void *a, void *b, size_t len)
{
	memcpy(a, b, len);
}

int kill(int a, int b)
{
	return 0;
}

char *ttyname(int fd)
{
	return "CONSOLE:";
}

#endif
