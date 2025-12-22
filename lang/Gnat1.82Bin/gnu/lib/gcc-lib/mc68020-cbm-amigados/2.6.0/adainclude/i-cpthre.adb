------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                 I N T E R F A C E S . C . P T H R E A D S                --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.3 $                             --
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

with System;

with Interfaces.C.POSIX_RTE;
--  Used for, Signal,
--            Signal_Set

with Interfaces.C.POSIX_error; use Interfaces.C.POSIX_error;
--  Used for, Return_Code
--            Failure

with Interfaces.C.POSIX_Timers;
--  Used for, timespec

with Unchecked_Conversion;

package body Interfaces.C.Pthreads is

   --  These unchecked conversion functions are used to convert a variable
   --  to an access value referencing that variable.  The expression
   --  Address_to_Pointer(X'Address) evaluates to an access value referencing
   --  X; if X is of type T, this expression returns a value of type
   --  access T.  This is necessary to allow structures to be passed to
   --  C functions, since some compiler interfaces to C only allows scalers,
   --  access values, and values of type System.Address as actual parameters.

   --  ??? it would be better to use the routines in System.Storage_Elements
   --  ??? for conversion between pointers and access values. In any case
   --  ??? I don't see the point of these conversions at all, why not pass
   --  ??? Address values directly to the C routines (I = RBKD)

   Failure : POSIX_Error.Return_Code renames POSIX_Error.Failure;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, POSIX_RTE.sigset_t_ptr);

   type pthread_t_ptr is access pthread_t;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, pthread_t_ptr);

   type pthread_attr_t_ptr is access pthread_attr_t;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, pthread_attr_t_ptr);

   type pthread_mutexattr_t_ptr is access pthread_mutexattr_t;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, pthread_mutexattr_t_ptr);

   type pthread_mutex_t_ptr is access pthread_mutex_t;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, pthread_mutex_t_ptr);

   type pthread_condattr_t_ptr is access pthread_condattr_t;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, pthread_condattr_t_ptr);

   type pthread_cond_t_ptr is access pthread_cond_t;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, pthread_cond_t_ptr);

   type pthread_key_t_ptr is access pthread_key_t;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, pthread_key_t_ptr);

   type Address_Pointer is access System.Address;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, Address_Pointer);

   type timespec_ptr is access POSIX_Timers.timespec;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, timespec_ptr);

   type Int_Ptr is access int;

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, Int_Ptr);

   -----------------------
   -- pthread_attr_init --
   -----------------------

   procedure pthread_attr_init
     (attributes : out pthread_attr_t;
      result     : out Return_Code)
   is
      function pthread_attr_init_base
        (attr : pthread_attr_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_attr_init_base, "pthread_attr_init");

   begin
      result :=
        pthread_attr_init_base (Address_to_Pointer (attributes'Address));
   end pthread_attr_init;

   --------------------------
   -- pthread_attr_destroy --
   --------------------------

   procedure pthread_attr_destroy
     (attributes : in out pthread_attr_t;
      result     : out Return_Code)
   is
      function pthread_attr_destroy_base
        (attr : pthread_attr_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_attr_destroy_base, "pthread_attr_destroy");

   begin
      result :=
        pthread_attr_destroy_base (Address_to_Pointer (attributes'Address));
   end pthread_attr_destroy;

   -------------------------------
   -- pthread_attr_setstacksize --
   -------------------------------

   procedure pthread_attr_setstacksize
     (attr      : in out pthread_attr_t;
      stacksize : size_t;
      result    : out Return_Code)
   is
      function pthread_attr_setstacksize_base
        (attr      : pthread_attr_t_ptr;
         stacksize : size_t)
         return      Return_Code;
      pragma Import
        (C, pthread_attr_setstacksize_base, "pthread_attr_setstacksize");

   begin
      result :=
        pthread_attr_setstacksize_base
          (Address_to_Pointer (attr'Address), stacksize);
   end pthread_attr_setstacksize;

   ---------------------------------
   -- pthread_attr_setdetachstate --
   ---------------------------------

   procedure pthread_attr_setdetachstate
     (attr        : in out pthread_attr_t;
      detachstate : int;
      result      : out Return_Code)
   is
      function pthread_attr_setdetachstate_base
        (attr        : pthread_attr_t_ptr;
         detachstate : Int_Ptr)
         return        Return_Code;
      pragma Import
        (C, pthread_attr_setdetachstate_base, "pthread_attr_setdetachstate");

   begin
      Result :=
        pthread_attr_setdetachstate_base (
          Address_to_Pointer (attr'Address),
          Address_to_Pointer (detachstate'Address));
   end pthread_attr_setdetachstate;

   --------------------
   -- pthread_create --
   --------------------

   procedure pthread_create
     (thread        : out pthread_t;
      attributes    : pthread_attr_t;
      start_routine : System.Address;
      arg           : System.Address;
      result        : out Return_Code)
   is
      function pthread_create_base
        (thread        : pthread_t_ptr;
         attr          : pthread_attr_t_ptr;
         start_routine : System.Address; arg : System.Address)
         return          Return_Code;
      pragma Import (C, pthread_create_base, "pthread_create");

   begin
      result :=
        pthread_create_base (Address_to_Pointer (thread'Address),
          Address_to_Pointer (attributes'Address), start_routine, arg);
   end pthread_create;

   ------------------
   -- pthread_init --
   ------------------

   --  This procedure provides a hook into Pthreads initialization that allows
   --  the addition of initializations specific to the Ada Pthreads interface

   procedure pthread_init is
      procedure pthread_init_base;
      pragma Import (C, pthread_init_base, "pthread_init");

   begin
      pthread_init_base;
   end pthread_init;

   --------------------
   -- pthread_detach --
   --------------------

   procedure pthread_detach
     (thread : in out pthread_t;
      result : out Return_Code)
   is
      function pthread_detach_base
        (thread : pthread_t_ptr)
         return   Return_Code;
      pragma Import (C, pthread_detach_base, "pthread_detach");

   begin
      result := pthread_detach_base (Address_to_Pointer (thread'Address));
   end pthread_detach;

   ----------------------------
   -- pthread_mutexattr_init --
   ----------------------------

   procedure pthread_mutexattr_init
     (attributes : out pthread_mutexattr_t;
      result     : out Return_Code)
   is
      function pthread_mutexattr_init_base
        (attr : pthread_mutexattr_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_mutexattr_init_base, "pthread_mutexattr_init");

   begin
      result :=
        pthread_mutexattr_init_base (Address_to_Pointer (attributes'Address));
   end pthread_mutexattr_init;

   -----------------------------------
   -- pthread_mutexattr_setprotocol --
   -----------------------------------

   procedure pthread_mutexattr_setprotocol
     (attributes : in out pthread_mutexattr_t;
      protocol   : pthread_protocol_t;
      result     : out Return_Code)
   is
      function pthread_mutexattr_setprotocol_base
        (attributes : pthread_mutexattr_t_ptr;
         protocol   : pthread_protocol_t)
         return       Return_Code;
      pragma Import
        (C, pthread_mutexattr_setprotocol_base,
            "pthread_mutexattr_setprotocol");

   begin
      result :=
        pthread_mutexattr_setprotocol_base
          (Address_to_Pointer (attributes'Address), protocol);
   end pthread_mutexattr_setprotocol;

   ---------------------------------------
   -- pthread_mutexattr_setprio_ceiling --
   ---------------------------------------

   procedure pthread_mutexattr_setprio_ceiling
     (attributes   : in out pthread_mutexattr_t;
      prio_ceiling : int;
      result       : out Return_Code)
   is
      function pthread_mutexattr_setprio_ceiling_base
        (attributes   : pthread_mutexattr_t_ptr;
         prio_ceiling : int)
         return         Return_Code;
      pragma Import
        (C, pthread_mutexattr_setprio_ceiling_base,
            "pthread_mutexattr_setprio_ceiling");

   begin
      result :=
        pthread_mutexattr_setprio_ceiling_base (
          Address_to_Pointer (attributes'Address), prio_ceiling);
   end pthread_mutexattr_setprio_ceiling;

   ------------------------
   -- pthread_mutex_init --
   ------------------------

   procedure pthread_mutex_init
     (mutex      : out pthread_mutex_t;
      attributes : pthread_mutexattr_t;
      result     : out Return_Code)
   is
      function pthread_mutex_init_base
        (mutex : pthread_mutex_t_ptr;
         attr  : pthread_mutexattr_t_ptr)
         return  Return_Code;
      pragma Import
        (C, pthread_mutex_init_base, "pthread_mutex_init");

   begin
      result :=
        pthread_mutex_init_base (Address_to_Pointer (mutex'Address),
          Address_to_Pointer (attributes'Address));
   end pthread_mutex_init;

   ---------------------------
   -- pthread_mutex_destroy --
   ---------------------------

   procedure pthread_mutex_destroy
     (mutex  : in out pthread_mutex_t;
      result : out Return_Code)
   is
      function pthread_mutex_destroy_base
        (mutex : pthread_mutex_t_ptr)
         return  Return_Code;
      pragma Import (C, pthread_mutex_destroy_base, "pthread_mutex_destroy");

   begin
      result :=
        pthread_mutex_destroy_base (Address_to_Pointer (mutex'Address));
   end pthread_mutex_destroy;

   ---------------------------
   -- pthread_mutex_trylock --
   ---------------------------

   procedure pthread_mutex_trylock
     (mutex  : in out pthread_mutex_t;
      result : out Return_Code)
   is
      function pthread_mutex_trylock_base
        (mutex : pthread_mutex_t_ptr)
         return  Return_Code;
      pragma Import (C, pthread_mutex_trylock_base, "pthread_mutex_trylock");

   begin
      result :=
        pthread_mutex_trylock_base (Address_to_Pointer (mutex'Address));
   end pthread_mutex_trylock;

   ------------------------
   -- pthread_mutex_lock --
   ------------------------

   procedure pthread_mutex_lock
     (mutex  : in out pthread_mutex_t;
      result : out Return_Code)
   is
      function pthread_mutex_lock_base
        (mutex : pthread_mutex_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_mutex_lock_base, "pthread_mutex_lock");

   begin
      result := pthread_mutex_lock_base (Address_to_Pointer (mutex'Address));
   end pthread_mutex_lock;

   --------------------------
   -- pthread_mutex_unlock --
   --------------------------

   procedure pthread_mutex_unlock
     (mutex  : in out pthread_mutex_t;
      result : out Return_Code)
   is
      function pthread_mutex_unlock_base
        (mutex : pthread_mutex_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_mutex_unlock_base, "pthread_mutex_unlock");

   begin
      result := pthread_mutex_unlock_base (Address_to_Pointer (mutex'Address));
   end pthread_mutex_unlock;

   -----------------------
   -- pthread_cond_init --
   -----------------------

   procedure pthread_cond_init
     (condition  : out pthread_cond_t;
      attributes : pthread_condattr_t;
      result     : out Return_Code)
   is
      function pthread_cond_init_base
        (cond : pthread_cond_t_ptr;
         attr : pthread_condattr_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_cond_init_base, "pthread_cond_init");

   begin
      result :=
        pthread_cond_init_base (Address_to_Pointer (condition'Address),
          Address_to_Pointer (attributes'Address));
   end pthread_cond_init;

   -----------------------
   -- pthread_cond_wait --
   -----------------------

   procedure pthread_cond_wait
     (condition : in out pthread_cond_t;
      mutex     : in out pthread_mutex_t;
      result    : out Return_Code)
   is
      function pthread_cond_wait_base
        (cond  : pthread_cond_t_ptr;
         mutex : pthread_mutex_t_ptr)
         return  Return_Code;
      pragma Import (C, pthread_cond_wait_base, "pthread_cond_wait");

   begin
      result :=
        pthread_cond_wait_base (Address_to_Pointer (condition'Address),
          Address_to_Pointer (mutex'Address));
   end pthread_cond_wait;

   ----------------------------
   -- pthread_cond_timedwait --
   ----------------------------

   procedure pthread_cond_timedwait
     (condition     : in out pthread_cond_t;
      mutex         : in out pthread_mutex_t;
      absolute_time : POSIX_Timers.timespec;
      result        : out Return_Code)
   is
      function pthread_cond_timedwait_base
        (cond    : pthread_cond_t_ptr;
         mutex   : pthread_mutex_t_ptr;
         abstime : timespec_ptr)
         return    Return_Code;
      pragma Import (C, pthread_cond_timedwait_base, "pthread_cond_timedwait");

   begin
      result :=
        pthread_cond_timedwait_base (
          Address_to_Pointer (condition'Address),
          Address_to_Pointer (mutex'Address),
          Address_to_Pointer (absolute_time'Address));
   end pthread_cond_timedwait;

   -------------------------
   -- pthread_cond_signal --
   -------------------------

   procedure pthread_cond_signal
     (condition : in out pthread_cond_t;
      result    : out Return_Code)
   is
      function pthread_cond_signal_base
        (cond : pthread_cond_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_cond_signal_base, "pthread_cond_signal");

   begin
      result :=
        pthread_cond_signal_base (Address_to_Pointer (condition'Address));
   end pthread_cond_signal;

   ----------------------------
   -- pthread_cond_broadcast --
   ----------------------------

   procedure pthread_cond_broadcast
     (condition : in out pthread_cond_t;
      result    : out Return_Code)
   is
      function pthread_cond_broadcast_base
        (cond : pthread_cond_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_cond_broadcast_base, "pthread_cond_broadcast");

   begin
      result :=
        pthread_cond_broadcast_base (Address_to_Pointer (condition'Address));
   end pthread_cond_broadcast;

   --------------------------
   -- pthread_cond_destroy --
   --------------------------

   procedure pthread_cond_destroy
     (condition : in out pthread_cond_t;
      result    : out Return_Code)
   is
      function pthread_cond_destroy_base
        (cond : pthread_condattr_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_cond_destroy_base, "pthread_cond_destroy");

   begin
      result :=
        pthread_cond_destroy_base (Address_to_Pointer (condition'Address));
   end pthread_cond_destroy;

   ---------------------------
   -- pthread_condattr_init --
   ---------------------------

   procedure pthread_condattr_init
     (attributes : out pthread_condattr_t;
      result     : out Return_Code)
   is
      function pthread_condattr_init_base
        (cond : pthread_condattr_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_condattr_init_base, "pthread_condattr_init");

   begin
      result :=
        pthread_condattr_init_base (Address_to_Pointer (attributes'Address));
   end pthread_condattr_init;

   ------------------------------
   -- pthread_condattr_destroy --
   ------------------------------

   procedure pthread_condattr_destroy
     (attributes : in out pthread_condattr_t;
      result     : out Return_Code)
   is
      function pthread_condattr_destroy_base
        (cond : pthread_condattr_t_ptr)
         return Return_Code;
      pragma Import
        (C, pthread_condattr_destroy_base, "pthread_condattr_destroy");

   begin
      result :=
        pthread_condattr_destroy_base
          (Address_to_Pointer (attributes'Address));
   end pthread_condattr_destroy;

   -------------------------
   -- pthread_setspecific --
   -------------------------

   --  Suppress all checks to prevent stack check on entering routine
   --  which routine does this comment belong in???
   --  need pragma Suppress in spec for routine???
   --  Also need documentation of why suppress is needed ???

   procedure pthread_setspecific
     (key    : pthread_key_t;
      value  : System.Address;
      result : out Return_Code)
   is
      function pthread_setspecific_base
        (key   : pthread_key_t;
         value : System.Address)
         return  Return_Code;
      pragma Import (C, pthread_setspecific_base, "pthread_setspecific");

   begin
      result := pthread_setspecific_base (key, value);
   end pthread_setspecific;

   -------------------------
   -- pthread_getspecific --
   -------------------------

   procedure pthread_getspecific
     (key    : pthread_key_t;
      value  : out System.Address;
      result : out Return_Code)
   is
      function pthread_getspecific_base
        (key   : pthread_key_t;
         value : Address_Pointer)
         return  Return_Code;
      pragma Import (C, pthread_getspecific_base, "pthread_getspecific");

   begin
      result :=
        pthread_getspecific_base (key, Address_to_Pointer (value'Address));
   end pthread_getspecific;

   ------------------------
   -- pthread_key_create --
   ------------------------

   procedure pthread_key_create
     (key        : out pthread_key_t;
      destructor : System.Address;
      result     : out Return_Code)
   is
      function pthread_key_create_base
        (key        : pthread_key_t_ptr;
         destructor : System.Address)
         return       Return_Code;
      pragma Import (C, pthread_key_create_base, "pthread_key_create");

   begin
      result :=
        pthread_key_create_base (Address_to_Pointer (key'Address), destructor);
   end pthread_key_create;

   --------------------------
   -- pthread_attr_setprio --
   --------------------------

   procedure pthread_attr_setprio
     (attr     : in out pthread_attr_t;
      priority : Priority_Type;
      result   : out Return_Code)
   is
      function pthread_attr_setprio_base
        (attr     : pthread_attr_t_ptr;
         priority : Priority_Type)
         return     Return_Code;
      pragma Import (C, pthread_attr_setprio_base, "pthread_attr_setprio");

   begin
      result :=
        pthread_attr_setprio_base
          (Address_to_Pointer (attr'Address), priority);
   end pthread_attr_setprio;

   --------------------------
   -- pthread_attr_getprio --
   --------------------------

   procedure pthread_attr_getprio
     (attr     : pthread_attr_t;
      priority : out Priority_Type;
      result   : out Return_Code)
   is
      Temp_Result : Return_Code;

      function pthread_attr_getprio_base
        (attr : pthread_attr_t_ptr)
         return Return_Code;
      pragma Import (C, pthread_attr_getprio_base, "pthread_attr_getprio");

   begin
      Temp_Result :=
        pthread_attr_getprio_base (Address_to_Pointer (attr'Address));

      if Temp_Result /= Failure then
         priority := Priority_Type (Temp_Result);
         result := 0;

      --  For failure case, send out lowest priority (is it OK ???)

      else
         priority := Priority_Type'First;
         result := Failure;
      end if;

   end pthread_attr_getprio;

   --------------------------
   -- pthread_setschedattr --
   --------------------------

   procedure pthread_setschedattr
     (thread     : pthread_t;
      attributes : pthread_attr_t;
      result     : out Return_Code)
   is
      function pthread_setschedattr_base
        (thread : pthread_t;
         attr   : pthread_attr_t_ptr)
         return   Return_Code;
      pragma Import (C, pthread_setschedattr_base, "pthread_setschedattr");

   begin
      result :=
        pthread_setschedattr_base (thread,
          Address_to_Pointer (attributes'Address));
   end pthread_setschedattr;

   --------------------------
   -- pthread_getschedattr --
   --------------------------

   procedure pthread_getschedattr
     (thread      : pthread_t;
      attributes  : out pthread_attr_t;
      result      : out Return_Code)
   is
      function pthread_getschedattr_base
        (thread : pthread_t;
         attr   : pthread_attr_t_ptr)
         return   Return_Code;
      pragma Import (C, pthread_getschedattr_base, "pthread_getschedattr");

   begin
      result :=
        pthread_getschedattr_base (thread,
          Address_to_Pointer (attributes'Address));
   end pthread_getschedattr;

   ------------------
   -- pthread_self --
   ------------------

   function pthread_self return pthread_t is
      function pthread_self_base return pthread_t;
      pragma Import (C, pthread_self_base, "pthread_self");

   begin
      return pthread_self_base;
   end pthread_self;

   -------------
   -- sigwait --
   -------------

   procedure sigwait
     (set         : POSIX_RTE.Signal_Set;
      sig         : out POSIX_RTE.Signal;
      result      : out Return_Code)
   is
      Temp_Result : Return_Code;

      function sigwait_base
        (set : POSIX_RTE.sigset_t_ptr) return Return_Code;
      pragma Import (C, sigwait_base, "sigwait");

   begin
      Temp_Result := sigwait_base (Address_to_Pointer (set'Address));

      if Temp_Result /= Failure then
         sig := POSIX_RTE.Signal (Temp_Result);
      else
         sig := 0;
      end if;

      result := Temp_Result;
   end sigwait;

   ------------------
   -- pthread_kill --
   ------------------

   procedure pthread_kill
     (thread : pthread_t;
      sig    : POSIX_RTE.Signal;
      result : out Return_Code)
   is
      function pthread_kill_base
        (thread : pthread_t;
         sig    : POSIX_RTE.Signal)
         return   Return_Code;
      pragma Import (C, pthread_kill_base, "pthread_kill");

   begin
      result := pthread_kill_base (thread, sig);
   end pthread_kill;

   --------------------------
   -- pthread_cleanup_push --
   --------------------------

   procedure pthread_cleanup_push
     (routine : System.Address;
      arg     : System.Address)
   is
      procedure pthread_cleanup_push_base
        (routine : System.Address;
         arg     : System.Address);
      pragma Import (C, pthread_cleanup_push_base, "pthread_cleanup_push");

   begin
      pthread_cleanup_push_base (routine, arg);
   end pthread_cleanup_push;

   -------------------------
   -- pthread_cleanup_pop --
   -------------------------

   procedure pthread_cleanup_pop (execute : int) is
      procedure pthread_cleanup_pop_base (execute : int);
      pragma Import (C, pthread_cleanup_pop_base, "pthread_cleanup_pop");

   begin
      pthread_cleanup_pop_base (execute);
   end pthread_cleanup_pop;

   -------------------
   -- pthread_yield --
   -------------------

   procedure pthread_yield is
      procedure pthread_yield_base;
      pragma Import (C, pthread_yield_base, "pthread_yield");

   begin
      pthread_yield_base;
   end pthread_yield;

begin
   pthread_init;
end Interfaces.C.Pthreads;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Aug 18 17:41:15 1994;  author: giering
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Thu Aug 18 20:10:12 1994;  author: dewar
--  MInor reformatting
--  ----------------------------
--  revision 1.3
--  date: Wed Aug 31 12:12:05 1994;  author: giering
--  (pthread_attr_destroy): New procedure.
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
