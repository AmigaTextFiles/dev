------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                I N T E R F A C E S . C . P O S I X _ R T E               --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.2 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2,  or (at  your  option)  any --
--  later  version.   GNARL is distributed in the hope that it will be use- --
--  ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
--  MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
--  eral Library Public License for more details.  You should have received --
--  a  copy of the GNU Library General Public License along with GNARL; see --
--  file COPYING. If not, write to the Free Software Foundation,  675  Mass --
--  Ave, Cambridge, MA 02139, USA.                                          --
--                                                                          --
------------------------------------------------------------------------------

--  This package interfaces with the POSIX real-time extensions. It may
--  also implement some of them using UNIX operations. It is not a complete
--  interface, it only includes what is needed to implement the Ada runtime.

with System;

--  temporarily, should really only be for 1 ???
with Interfaces.C.POSIX_Error; use Interfaces.C.POSIX_Error;
--  Used for, Return_Code

with Interfaces.C.POSIX_Constants;
--  Used for, various constants

package Interfaces.C.POSIX_RTE is

   --  The following definitions are from P1003.5,
   --  which the rest of this package is not.

   type Signal is new int;

   type Signal_Set is private;

   procedure Add_Signal
     (Set : in out Signal_Set;
      Sig : in Signal);

   procedure Add_All_Signals (Set : in out Signal_Set);

   procedure Delete_Signal
     (Set : in out Signal_Set;
      Sig : in Signal);

   procedure Delete_All_Signals (Set : in out Signal_Set);

   function Is_Member
     (Set : Signal_Set;
      Sig : Signal)
     return Boolean;
   --  End of P1003.5 definitions.

   type sigval is record
      u0 : int;
   end record;
   --  This is not used at the moment, need to update to reflect
   --  any changes in the Pthreads signal.h in the future

   type struct_siginfo is record
      si_signo : Signal;
      si_code : int;
      si_value : sigval;
   end record;

   type siginfo_ptr is access struct_siginfo;

   type sigset_t_ptr is access Signal_Set;

   SIG_ERR : constant := POSIX_Constants.SIG_ERR;
   SIG_DFL : constant := POSIX_Constants.SIG_DFL;
   SIG_IGN : constant := POSIX_Constants.SIG_IGN;
   --  constants for sa_handler

   type struct_sigaction is record

      sa_handler : System.Address;
      --  address of signal handler

      sa_mask : Signal_Set;
      --  Additional signals to be blocked during
      --  execution of signal-catching function

      sa_flags : int;
      --  Special flags to affect behavior of signal

   end record;

   --  Signal catching function (signal handler) has the following profile :

   --  procedure Signal_Handler
   --    (signo   : Signal;
   --     info    : siginfo_ptr;
   --     context : sigcontext_ptr);

   SA_NOCLDSTOP : constant := POSIX_Constants.SA_NOCLDSTOP;
   --  Don't send a SIGCHLD on child stop

   SA_SIGINFO : constant := POSIX_Constants.SA_SIGINFO;
   --  sa_flags flags for struct_sigaction

   SIG_BLOCK   : constant := POSIX_Constants.SIG_BLOCK;
   SIG_UNBLOCK : constant := POSIX_Constants.SIG_UNBLOCK;
   SIG_SETMASK : constant := POSIX_Constants.SIG_SETMASK;
   --  sigprocmask flags (how)

   type jmp_buf is array
     (1 .. POSIX_Constants.pthread_jmp_buf_size) of int;

   type sigjmp_buf is array
     (1 .. POSIX_Constants.pthread_sigjmp_buf_size) of int;

   type jmp_buf_ptr is access jmp_buf;

   type sigjmp_buf_ptr is access sigjmp_buf;
   --  Environment for long jumps

   procedure sigaction
     (sig    : Signal;
      act    : struct_sigaction;
      oact   : out struct_sigaction;
      Result : out Return_Code);
   pragma Inline (sigaction);
   --  install new sigaction structure and obtain old one

   procedure sigprocmask
     (how    : int;
      set    : Signal_Set;
      oset   : out Signal_Set;
      Result : out Return_Code);
   pragma Inline (sigprocmask);
   --  Install new signal mask and obtain old one

   procedure sigsuspend
     (mask : Signal_Set;
      Result : out Return_Code);
   pragma Inline (sigsuspend);
   --  Suspend waiting for signals in mask and resume after
   --  executing handler or take default action

   procedure sigpending
     (set : out Signal_Set;
      Result : out Return_Code);
   pragma Inline (sigpending);
   --  get pending signals on thread and process

   procedure longjmp (env : jmp_buf; val : int);
   pragma Inline (longjmp);
   --  execute a jump across procedures according to setjmp

   procedure siglongjmp (env : sigjmp_buf; val : int);
   pragma Inline (siglongjmp);
   --  execute a jump across procedures according to sigsetjmp

   procedure setjmp (env : jmp_buf; Result : out Return_Code);
   pragma Inline (setjmp);
   --  set up a jump across procedures and return here with longjmp

   procedure sigsetjmp
     (env      : sigjmp_buf;
      savemask : int;
      Result   : out Return_Code);
   pragma Inline (sigsetjmp);
   --  Set up a jump across procedures and return here with siglongjmp

   --  temporarily, should really only be for 1 ???

   Signal_Kill, SIGKILL        : constant Signal := POSIX_Constants.SIGKILL;
   Signal_Stop, SIGSTOP        : constant Signal := POSIX_Constants.SIGSTOP;
   --  Signals which cannot be masked

   Signal_Illegal_Instruction, SIGILL
                               : constant Signal := POSIX_Constants.SIGILL;
   Signal_Abort, SIGABRT       : constant Signal := POSIX_Constants.SIGABRT;
   SIGEMT                      : constant Signal := POSIX_Constants.SIGEMT;
   Signal_Floating_Point_Error : constant Signal := POSIX_Constants.SIGFPE;
   SIGFPE                      : constant Signal := POSIX_Constants.SIGFPE;
   SIGBUS                      : constant Signal := POSIX_Constants.SIGBUS;
   SIGSEGV                     : constant Signal := POSIX_Constants.SIGSEGV;
   Signal_Pipe_Write           : constant Signal := POSIX_Constants.SIGPIPE;
   SIGPIPE                     : constant Signal := POSIX_Constants.SIGPIPE;
   --  Some synchronous signals (cannot be used for interrupt entries)

   Signal_Alarm, SIGALRM       : constant Signal := POSIX_Constants.SIGALRM;
   --  Alarm signal (cannot be used for interrupt entries)

   Signal_User_1, SIGUSR1      : constant Signal := POSIX_Constants.SIGUSR1;
   Signal_User_2, SIGUSR2      : constant Signal := POSIX_Constants.SIGUSR2;
   --  User-defined signals

   SIGTRAP                    : constant Signal := POSIX_Constants.SIGTRAP;
   --  Not POSIX; this is left unmasked to keep SGI dbx happy.

private
   type Signal_Set is array
      (1 .. POSIX_Constants.posix_sigset_t_size) of Unsigned_8;

end Interfaces.C.POSIX_RTE;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Aug 18 17:26:54 1994;  author: giering
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Thu Aug 18 20:09:50 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
