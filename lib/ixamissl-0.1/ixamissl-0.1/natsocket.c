/*
 * natsocket.c - native socket support
 * version 0.1 by megacz@usa.com
 *
 * Created mainly for use with AmiSSL in 'ixemul'.
 *
*/



#include <sys/types.h>
#include <sys/time.h>
#include <errno.h>

#define DEVICES_TIMER_H 1

#include <proto/exec.h>
#include <exec/types.h>
#include <exec/execbase.h>
#include <exec/io.h>
#include <exec/tasks.h>
#include <exec/devices.h>
#include <exec/interrupts.h>
#include <proto/dos.h>
#include <dos/dostags.h>
#include <dos/dosextens.h>

#define _INTERNAL_FILE 1
#include <sys/file.h>
#undef _INTERNAL_FILE

#include <user.h>

#define getuser(p) ((struct user *)(((struct Process *)(p))->pr_Task.tc_TrapData))

#include <asiheader.h>



struct ixnet
{
  void  *u_InetBase;
  void  *u_SockBase;
  void  *u_TCPBase;
  void  *u_UserGroupBase;
  int   u_sigurg;
  int   u_sigio;
  int   u_networkprotocol;
  int   sock_id;
  short u_daemon;
  char  *u_progname;
};

struct timeval_b
{
  ULONG tv_secs;
  ULONG tv_micro;
};

struct timerequest
{
  struct IORequest tr_node;
  struct timeval_b tr_time;
};



struct Library *ns_ObtainBSDSocketBase(void)
{
  struct user *ix_u;
  struct ixnet *ix_n;


  ix_u = getuser(SysBase->ThisTask);

  ix_n = ix_u->u_ixnet;

  if (ix_n->u_networkprotocol == 3)
    return (struct Library *)ix_n->u_TCPBase;
  
  return (struct Library *)NULL;
}

int ns_ObtainBSDSocketFD(int sock)
{
  struct file *fp;
  struct user *ix_u;


  ix_u = getuser(SysBase->ThisTask);

  if ((unsigned) sock >= NOFILE)
  {
    errno = EBADF;

    return -1;
  }

  fp = ix_u->u_ofile[sock];

  if (fp == NULL)
  {
    errno = EBADF;

    return -1;
  }

  if (fp->f_type != DTYPE_SOCKET && fp->f_type != DTYPE_USOCKET)
  {
    errno = ENOTSOCK;

    return -1;
  }

  if (fp->f_type == DTYPE_SOCKET && !ix_u->u_ixnetbase)
  {
    errno = EPIPE;

    return -1;
  }

  return (fp->f_so);
}
