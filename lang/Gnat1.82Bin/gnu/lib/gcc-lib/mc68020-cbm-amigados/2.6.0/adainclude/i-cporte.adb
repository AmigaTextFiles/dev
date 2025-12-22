------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                I N T E R F A C E S . C . P O S I X _ R T E               --
--                                                                          --
--                                  B o d y                                 --
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

with Interfaces.C.POSIX_Error; use Interfaces.C.Posix_Error;
--  Used for, POSIX_Error,
--            Return_Code

with Unchecked_Conversion;

package body Interfaces.C.POSIX_RTE is

   type sigaction_ptr is access struct_sigaction;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, sigaction_ptr);

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, sigset_t_ptr);

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, jmp_buf_ptr);

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, sigjmp_buf_ptr);

   --  The following are P1003.5 interfaces.  I am not sure that this is a
   --  good idea, but these can't be exactly the same as the C functions
   --  in any case.

   procedure Add_Signal (Set : in out Signal_Set; Sig : in Signal) is
      function sigaddset (Set : sigset_t_ptr; Sig : Signal) return Return_Code;
      pragma Import (C, sigaddset, "sigaddset");

   begin
      if sigaddset (Address_to_Pointer (Set'Address), Sig) /= 0 then
         raise POSIX_Error.POSIX_Error;
      end if;
   end Add_Signal;

   procedure Delete_Signal (Set : in out Signal_Set; Sig : in Signal) is
      function sigdelset (Set : sigset_t_ptr; Sig : Signal) return Return_Code;
      pragma Import (C, sigdelset, "sigdelset");

   begin
      if sigdelset (Address_to_Pointer (Set'Address), Sig) /= 0 then
         raise POSIX_Error.POSIX_Error;
      end if;
   end Delete_Signal;

   procedure Add_All_Signals (Set : in out Signal_Set) is
      function sigfillset (Set : sigset_t_ptr) return Return_Code;
      pragma Import (C, sigfillset, "sigfillset");

   begin
      if sigfillset (Address_to_Pointer (Set'Address)) /= 0 then
         raise POSIX_Error.POSIX_Error;
      end if;
   end Add_All_Signals;

   procedure Delete_All_Signals (Set : in out Signal_Set) is
      function sigemptyset (Set : sigset_t_ptr) return Return_Code;
      pragma Import (C, sigemptyset, "sigemptyset");

   begin
      if sigemptyset (Address_to_Pointer (Set'Address)) /= 0 then
         raise POSIX_Error.POSIX_Error;
      end if;
   end Delete_All_Signals;

   function Is_Member (Set : Signal_Set; Sig : Signal) return Boolean is
      function sigismember
        (Set  : sigset_t_ptr;
         Sig  : Signal)
         return Return_Code;
      pragma Import (C, sigismember, "sigismember");

   begin
      if sigismember (Address_to_Pointer (Set'Address), Sig) = 1 then
         return True;
      else
         return False;
      end if;
   end Is_Member;

   --  End of P1003.5 interfaces.

   ---------------
   -- sigaction --
   ---------------

   procedure sigaction
     (sig    : Signal;
      act    : struct_sigaction;
      oact   : out struct_sigaction;
      Result : out POSIX_Error.Return_Code)
   is
      function sigaction_base
        (sig  : Signal;
         act  : sigaction_ptr;
         oact : sigaction_ptr) return POSIX_Error.Return_Code;
      pragma Import (C, sigaction_base, "sigaction");

   begin
      Result := sigaction_base (sig, Address_to_Pointer (act'Address),
            Address_to_Pointer (oact'Address));
   end sigaction;

   -----------------
   -- sigprocmask --
   -----------------

   --  Install new signal mask and obtain old one

   procedure sigprocmask
     (how    : int;
      set    : Signal_Set;
      oset   : out Signal_Set;
      Result : out POSIX_Error.Return_Code)
   is
      function sigprocmask_base
        (how  : int;
         set  : sigset_t_ptr;
         oset : sigset_t_ptr)
         return POSIX_Error.Return_Code;
      pragma Import (C, sigprocmask_base, "sigprocmask");

   begin
      Result := sigprocmask_base (how, Address_to_Pointer (set'Address),
            Address_to_Pointer (oset'Address));
   end sigprocmask;

   ----------------
   -- sigsuspend --
   ----------------

   --  Suspend waiting for signals in mask and resume after
   --  executing handler or take default action

   procedure sigsuspend
     (mask : Signal_Set;
      Result : out POSIX_Error.Return_Code) is

      function sigsuspend_base
        (mask : sigset_t_ptr)
         return POSIX_Error.Return_Code;
      pragma Import (C, sigsuspend_base, "sigsuspend");

   begin
      Result := sigsuspend_base (Address_to_Pointer (mask'Address));
   end sigsuspend;

   ----------------
   -- sigpending --
   ----------------

   --  Get pending signals on thread and process

   procedure sigpending
     (set    : out Signal_Set;
      Result : out POSIX_Error.Return_Code)
   is
      function sigpending_base
        (set  : sigset_t_ptr)
         return POSIX_Error.Return_Code;
      pragma Import (C, sigpending_base, "sigpending");

   begin
      Result := sigpending_base (Address_to_Pointer (set'Address));
   end sigpending;

   -------------
   -- longjmp --
   -------------

   --  Execute a jump across procedures according to setjmp

   procedure longjmp (env : jmp_buf; val : int) is
      procedure longjmp_base (env : jmp_buf_ptr; val : int);
      pragma Import (C, longjmp_base, "longjmp");

   begin
      longjmp_base (Address_to_Pointer (env'Address), val);
   end longjmp;

   ----------------
   -- siglongjmp --
   ----------------

   --  Execute a jump across procedures according to sigsetjmp

   procedure siglongjmp (env : sigjmp_buf; val : int) is
      procedure siglongjmp_base (env : sigjmp_buf_ptr; val : int);
      pragma Import (C, siglongjmp_base, "siglongjmp");

   begin
      siglongjmp_base (Address_to_Pointer (env'Address), val);
   end siglongjmp;

   ------------
   -- setjmp --
   ------------

   --  Set up a jump across procedures and return here with longjmp

   procedure setjmp (env : jmp_buf; Result : out Return_Code) is
      function setjmp_base (env : jmp_buf_ptr) return Return_Code;
      pragma Import (C, setjmp_base, "setjmp");

   begin
      Result := setjmp_base (Address_to_Pointer (env'Address));
   end setjmp;

   ---------------
   -- sigsetjmp --
   ---------------

   --  Set up a jump across procedures and return here with siglongjmp

   procedure sigsetjmp
     (env      : sigjmp_buf;
      savemask : int;
      Result   : out Return_Code)
   is
      function sigsetjmp_base
        (env      : sigjmp_buf_ptr;
         savemask : int)
         return     Return_Code;
      pragma Import (C, sigsetjmp_base, "sigsetjmp");

   begin
      Result := sigsetjmp_base (Address_to_Pointer (env'Address), savemask);
   end sigsetjmp;

end Interfaces.C.POSIX_RTE;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Aug 18 17:26:23 1994;  author: giering
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Thu Aug 18 20:09:43 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
