/* RCS      -- $Header: /u2/dvadura/src/generic/dmake/src/unix/runargv.c,v 1.1 1992/01/24 03:28:50 dvadura Exp $
-- SYNOPSIS -- invoke a sub process.
--
-- DESCRIPTION
--      Use the standard methods of executing a sub process.
--
-- AUTHOR
--      Dennis Vadura, dvadura@watdragon.uwaterloo.ca
--      CS DEPT, University of Waterloo, Waterloo, Ont., Canada
--
-- COPYRIGHT
--      Copyright (c) 1990 by Dennis Vadura.  All rights reserved.
--
--      This program is free software; you can redistribute it and/or
--      modify it under the terms of the GNU General Public License
--      (version 1), as published by the Free Software Foundation, and
--      found in the file 'LICENSE' included with this distribution.
--
--      This program is distributed in the hope that it will be useful,
--      but WITHOUT ANY WARRANTY; without even the implied warrant of
--      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--      GNU General Public License for more details.
--
--      You should have received a copy of the GNU General Public License
--      along with this program;  if not, write to the Free Software
--      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
--
-- LOG
--     $Log: runargv.c,v $
 * Revision 1.1  1992/01/24  03:28:50  dvadura
 * dmake Version 3.8, Initial revision
 *
*/
#include <exec/types.h>
#include <exec/execbase.h>
#ifndef _DCC
#include <libraries/dos.h>
#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <proto/exec.h>
#include <proto/dos.h>
#else
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#endif
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include "extern.h"
#include "sysintf.h"

#define BTOC(bptr, type)  ((type *)((long)(bptr) << 2))
#define CTOB(cptr)  ((BPTR)((unsigned long)(cptr) >> 2))

typedef struct prp {
   char *prp_cmd;
   int   prp_group;
   int   prp_ignore;
   int   prp_last;
   int   prp_shell;
   struct prp *prp_next;
} RCP, *RCPPTR;

typedef struct pr {
   int          pr_valid;
   int          pr_pid;
   CELLPTR      pr_target;
   int          pr_ignore;
   int          pr_last;
   RCPPTR       pr_recipe;
   RCPPTR       pr_recipe_end;
   char        *pr_dir;
} PR;

static PR  *_procs    = NIL(PR);
static int  _proc_cnt = 0;
static int  _abort_flg= FALSE;
static int  _use_i    = -1;
static int  _do_upd   = 0;

static  void    _add_child ANSI((int, CELLPTR, int, int));
static  void    _attach_cmd ANSI((char *, int, int, CELLPTR, int, int));
static  void    _finished_child ANSI((int, int));
static  int     _running ANSI((CELLPTR));

typedef struct CommandLineInterface CLI;
typedef struct Process Process;

typedef struct LockList {
    BPTR    NextPath;
    BPTR    PathLock;
} LockList;

extern struct Library *DOSBase;
extern struct ExecBase *SysBase;
__aligned char CmdName[64];

long
SearchPath(cmd)
char *cmd;
{
    CLI *cli;
    LockList *ll;
    long lock;

    if (lock = Lock(cmd, SHARED_LOCK)) {
      return(lock);
    }

    if (SysBase->ThisTask->tc_Node.ln_Type != NT_PROCESS)
        return(0);
    if ((cli = BTOC(((Process *)SysBase->ThisTask)->pr_CLI, CLI)) == NULL)
        return(0);

    ll = BTOC(cli->cli_CommandDir, LockList);

    while (ll) {
        if (ll->PathLock) {
            long oldLock = CurrentDir(ll->PathLock);

            if (lock = Lock(cmd, SHARED_LOCK)) {
                CurrentDir(oldLock);
                return(lock);
            }
            CurrentDir(oldLock);
        }
        ll = BTOC(ll->NextPath, LockList);
    }
    return(0);
}

long
LoadSegLock(lock, cmd)
long lock;
char *cmd;
{
    long oldLock;
    long seg;

    oldLock = CurrentDir(lock);
    seg = LoadSeg(cmd);
    CurrentDir(oldLock);
    return(seg);
}


PUBLIC int
runargv(target, ignore, group, last, shell, cmd)
CELLPTR target;
int     ignore;
int     group;
int     last;
int     shell;
char    *cmd;
{
   extern  int  errno;
   extern  char *sys_errlist[];
   char         **argv;
   char  *cmdline;
   int   romShell;
   int status;

   if( _running(target) /*&& Max_proc != 1*/ ) {
      /* The command will be executed when the previous recipe
       * line completes. */
      _attach_cmd( cmd, group, ignore, target, last, shell );
      return(1);
   }

   while( _proc_cnt == Max_proc )
      if( Wait_for_child(FALSE, -1) == -1 )  Fatal( "Lost a child" );

   argv = Pack_argv( group, shell, cmd );
   if (NULL == argv) {
     Error("Not enough memory to spawn %s", cmd);
     Handle_result(-1, ignore, FALSE, target);
     return(-1);
   }

   cmdline = NULL;
   {
     int cmdlen, doQuote;
     int i, j;
     char *fp, *tp;

     romShell = !strcmp(argv[0], "AmigaOS");
     doQuote = !romShell && !group && (shell || (*_strpbrk(cmd, Shell_metas) != '\0'));
     cmdlen = doQuote ? 2 : 0;
     for (i = romShell ? 1 : 0; argv[i] != NULL; i++)
       if ((j = strlen(argv[i])) > 0)
         cmdlen += j+1;

     cmdline = (char *)malloc(cmdlen+1);
     if (NULL == cmdline) {
       Error("Not enough memory to spawn %s", cmd);
       Handle_result(-1, ignore, FALSE, target);
       return(-1);
     }

     tp = cmdline;
     for (i = romShell ? 1 : 0; argv[i] != NULL; i++)
       {
         if (doQuote && (1 == i))
           *tp++ = '\"';
         fp = argv[i];
         while (*fp != '\0' && iswhite(*fp))
           fp++;
         while (*fp != '\0')
           *tp++ = *fp++;
         if (argv[i+1] != NULL)
           *tp++ = ' ';
       }

     if (doQuote)
       *tp++ = '\"';

     *tp++ = '\n'; /* DOS depends on this */
     *tp = '\0';
   }

  if (romShell)
     {
       _add_child((int)&status, target, ignore, last);

       if (DOSBase->lib_Version >= 36) {
         struct TagItem TI[] = {
           SYS_Input , Input(),
           SYS_Output, Output(),
           SYS_UserShell, 1,
           TAG_DONE, 0
         };
         status = System(cmdline, TI);
       }
       else {
         status = Execute(cmdline, NULL, Output());
         if (status == 0)
           status = -1;
         else if (status == -1)
           status = 0;
       }

       _finished_child((int)&status, status);
       if (status < 0)
         {
           Error("Could not system() '%s'", argv);
           Handle_result(-1, ignore, FALSE, target);
           return(-1);
         }
     }
   else
     {
       if (SysBase->LibNode.lib_Version >= 36) {
           long seg;
           long lock = NULL;
           int i;

           Process *proc = (struct Process *)FindTask(NULL);
           CLI *cli = BTOC(proc->pr_CLI, CLI);
           long oldCommandName;
           long ssize;

           if (cli)
             ssize = cli->cli_DefaultStack * 4;
           else
             ssize = 8192;

           for (i = 0; cmdline[i] && cmdline[i] != ' '; ++i)
               ;
           memmove(CmdName + 1, cmdline, i);
           CmdName[0] = i;
           CmdName[i+1] = 0;

           if (cli) {
               oldCommandName = (long)cli->cli_CommandName;
               cli->cli_CommandName = CTOB(CmdName);
           }

           status = -1;
           _add_child((int)&status, target, ignore, last);

           if ( seg = (long)FindSegment(CmdName + 1, 0L, 0) ) {
             status = RunCommand(((long *)seg)[2], ssize, cmdline+i+1, strlen(cmdline+i+1));
           }
           else if ((lock = SearchPath(CmdName + 1)) && (seg = LoadSegLock(lock, ""))) {
             status = RunCommand(seg, ssize, cmdline+i+1, strlen(cmdline+i+1));
             UnLoadSeg(seg);
           }

           if (lock)
               UnLock(lock);
           if (cli)
               cli->cli_CommandName = (BSTR)oldCommandName;

           _finished_child((int)&status, status);

           if (status < 0)
             {
               Error("Could not find '%s'", CmdName+1);
               Handle_result(-1, ignore, FALSE, target);
               return(-1);
             }

       }
       else {
         _add_child((int)&status, target, ignore, last);
         status = Execute(cmdline, NULL, Output());
         _finished_child((int)&status, 0);
         if (status != -1) {
           Error("Could not Execute() %s", argv);
           Handle_result(-1, ignore, FALSE, target);
           return(-1);
         }
       }
     } /* else run non-system command */

   return(1);
}


PUBLIC int
Wait_for_child( abort_flg, pid )
int abort_flg;
int pid;
{
   return(0);
}


PUBLIC void
Clean_up_processes()
{
}


static void
_add_child( pid, target, ignore, last )
int     pid;
CELLPTR target;
int     ignore;
int     last;
{
   register int i;
   register PR *pp;

   if( _procs == NIL(PR) ) {
      TALLOC( _procs, Max_proc, PR );
   }

   if( (i = _use_i) == -1 )
      for( i=0; i<Max_proc; i++ )
         if( !_procs[i].pr_valid )
            break;

   pp = _procs+i;

   pp->pr_valid  = 1;
   pp->pr_pid    = pid;
   pp->pr_target = target;
   pp->pr_ignore = ignore;
   pp->pr_last   = last;
   pp->pr_dir    = _strdup(Get_current_dir());

   Current_target = NIL(CELL);

   _proc_cnt++;

   if( Wait_for_completion ) Wait_for_child( FALSE, pid );
}


static void
_finished_child(pid, status)
int     pid;
int     status;
{
   register int i;
   char     *dir;

   for( i=0; i<Max_proc; i++ )
      if( _procs[i].pr_valid && _procs[i].pr_pid == pid )
         break;

   /* Some children we didn't make esp true if using /bin/sh to execute a
    * a pipe and feed the output as a makefile into dmake. */
   if( i == Max_proc ) return;
   _procs[i].pr_valid = 0;
   _proc_cnt--;
   dir = _strdup(Get_current_dir());
   Set_dir( _procs[i].pr_dir );

   if( _procs[i].pr_recipe != NIL(RCP) && !_abort_flg ) {
      RCPPTR rp = _procs[i].pr_recipe;


      Current_target = _procs[i].pr_target;
      Handle_result( status, _procs[i].pr_ignore, FALSE, _procs[i].pr_target );
      Current_target = NIL(CELL);

      _procs[i].pr_recipe = rp->prp_next;

      _use_i = i;
      runargv( _procs[i].pr_target, rp->prp_ignore, rp->prp_group,
               rp->prp_last, rp->prp_shell, rp->prp_cmd );
      _use_i = -1;

      FREE( rp->prp_cmd );
      FREE( rp );

      if( _proc_cnt == Max_proc ) Wait_for_child( FALSE, -1 );
   }
   else {
      Unlink_temp_files( _procs[i].pr_target );
      Handle_result(status,_procs[i].pr_ignore,_abort_flg,_procs[i].pr_target);

      if( _procs[i].pr_last ) {
         FREE(_procs[i].pr_dir );

         if( !Doing_bang ) Update_time_stamp( _procs[i].pr_target );
      }
   }

   Set_dir(dir);
   FREE(dir);
}


static int
_running( cp )
CELLPTR cp;
{
  return FALSE;
}


static void
_attach_cmd( cmd, group, ignore, cp, last, shell )
char    *cmd;
int     group;
int     ignore;
CELLPTR cp;
int     last;
int     shell;
{
   register int i;
   RCPPTR rp;

   for( i=0; i<Max_proc; i++ )
      if( _procs[i].pr_valid &&
          _procs[i].pr_target == cp  )
         break;

   TALLOC( rp, 1, RCP );
   rp->prp_cmd   = _strdup(cmd);
   rp->prp_group = group;
   rp->prp_ignore= ignore;
   rp->prp_last  = last;
   rp->prp_shell = shell;

   if( _procs[i].pr_recipe == NIL(RCP) )
      _procs[i].pr_recipe = _procs[i].pr_recipe_end = rp;
   else {
      _procs[i].pr_recipe_end->prp_next = rp;
      _procs[i].pr_recipe_end = rp;
   }
}

