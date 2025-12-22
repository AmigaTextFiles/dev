-----------------------------------------------------------------------------
--                                                                         --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                         --
--         I N T E R F A C E S . C . P O S I X _ C O N S T A N T S         --
--                                                                         --
--                                 S p e c                                 --
--                                                                         --
--                            $Revision: 1.1 $                            --
--                                                                         --
--          Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                         --
-- GNARL is free software; you can redistribute it and/or modify it  under --
-- terms  of  the  GNU  Library General Public License as published by the --
-- Free Software Foundation; either version 2, or  (at  your  option)  any --
-- later  version.   GNARL is distributed in the hope that it will be use- --
-- ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
-- MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
-- eral Library Public License for more details.  You should have received --
-- a  copy of the GNU Library General Public License along with GNARL; see --
-- file COPYING. If not, write to the Free Software Foundation,  675  Mass --
-- Ave, Cambridge, MA 02139, USA.                                          --
--                                                                         --
-----------------------------------------------------------------------------

package Interfaces.C.POSIX_Constants is

   pthread_t_size           : constant Integer := 4;
   pthread_attr_t_size      : constant Integer := 28;
   pthread_mutexattr_t_size : constant Integer := 12;
   pthread_mutex_t_size     : constant Integer := 32;
   pthread_condattr_t_size  : constant Integer := 4;
   pthread_cond_t_size      : constant Integer := 20;
   pthread_key_t_size       : constant Integer := 4;
   pthread_jmp_buf_size     : constant Integer := 16;
   pthread_sigjmp_buf_size  : constant Integer := 16;
   posix_sigset_t_size      : constant Integer := 4;

   SIG_BLOCK       : constant := 1;
   SIG_UNBLOCK     : constant := 2;
   SIG_SETMASK     : constant := 4;
   SA_NOCLDSTOP    : constant := 8;
   SA_SIGINFO      : constant := 0;
   SIG_ERR         : constant := -1;
   SIG_DFL         : constant := 0;
   SIG_IGN         : constant := 1;
   SIGKILL         : constant := 9;
   SIGSTOP         : constant := 17;
   SIGILL          : constant := 4;
   SIGABRT         : constant := 6;
   SIGEMT          : constant := 7;
   SIGFPE          : constant := 8;
   SIGBUS          : constant := 10;
   SIGSEGV         : constant := 11;
   SIGPIPE         : constant := 13;
   SIGALRM         : constant := 14;
   SIGUSR1         : constant := 30;
   SIGUSR2         : constant := 31;
   SIGTRAP         : constant := 5;
   EPERM           : constant := 1;
   ENOENT          : constant := 2;
   ESRCH           : constant := 3;
   EINTR           : constant := 4;
   EIO             : constant := 5;
   ENXIO           : constant := 6;
   E2BIG           : constant := 7;
   ENOEXEC         : constant := 8;
   EBADF           : constant := 9;
   ECHILD          : constant := 10;
   EAGAIN          : constant := 11;
   ENOMEM          : constant := 12;
   EACCES          : constant := 13;
   EFAULT          : constant := 14;
   ENOTBLK         : constant := 15;
   EBUSY           : constant := 16;
   EEXIST          : constant := 17;
   EXDEV           : constant := 18;
   ENODEV          : constant := 19;
   ENOTDIR         : constant := 20;
   EISDIR          : constant := 21;
   EINVAL          : constant := 22;
   ENFILE          : constant := 23;
   EMFILE          : constant := 24;
   ENOTTY          : constant := 25;
   ETXTBSY         : constant := 26;
   EFBIG           : constant := 27;
   ENOSPC          : constant := 28;
   ESPIPE          : constant := 29;
   EROFS           : constant := 30;
   EMLINK          : constant := 31;
   EPIPE           : constant := 32;
   ENOSYS          : constant := 90;
   ENOTSUP         : constant := 91;
   NO_PRIO_INHERIT : constant := 0;
   PRIO_INHERIT    : constant := 1;
   PRIO_PROTECT    : constant := 2;

   Add_Prio : constant Integer := 2;

end Interfaces.C.POSIX_Constants;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Aug 18 18:39:18 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
