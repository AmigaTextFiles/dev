------------------------------------------------------------------------------
--                                                                         --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                         --
--              S Y S T E M . T A S K I N G . A B O R T I O N              --
--                                                                         --
--                                 B o d y                                 --
--                                                                         --
--                            $Revision: 1.10 $                             --
--                                                                         --
--          Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                         --
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
--                                                                         --
------------------------------------------------------------------------------

with System.Tasking.Utilities;
--  Used for, Utilities.ID_To_ATCB,
--            Utilities.ATCB_To_ID,
--            Utilities.ATCB_Ptr,
--            Utilities.Terminated,
--            Utilities.Not_Accepting,
--            Utilities.All_Tasks_L,
--            Utilities.All_Tasks_List
--            Utilities.Abort_To_Level,
--            Utilities.Abort_Dependents

with System.Task_Primitives; use System.Task_Primitives;

package body System.Tasking.Abortion is

   function ID_To_ATCB (ID : Task_ID) return Utilities.ATCB_Ptr
     renames Utilities.ID_To_ATCB;

   function ATCB_To_ID (Ptr : Utilities.ATCB_Ptr) return Task_ID
     renames Utilities.ATCB_To_ID;

   function "=" (L, R : Utilities.Task_Stage) return Boolean
     renames Utilities."=";

   function "=" (L, R : Utilities.ATCB_Ptr) return Boolean
     renames Utilities."=";

   function "=" (L, R : Utilities.Accepting_State) return Boolean
     renames Utilities."=";

   --------------------------
   -- Change_Base_Priority --
   --------------------------

   procedure Change_Base_Priority (T : Utilities.ATCB_Ptr) is

   begin
      --  check for ceiling violations ???
      T.Pending_Priority_Change := False;
      T.Base_Priority := T.New_Base_Priority;
      T.Current_Priority := T.Base_Priority;
      Set_Priority (T.LL_TCB'access, T. Current_Priority);
   end Change_Base_Priority;

   --------------------
   -- Defer_Abortion --
   --------------------

   procedure Defer_Abortion is
      T : Utilities.ATCB_Ptr := ID_To_ATCB (Self);

   begin
      T.Deferral_Level := T.Deferral_Level + 1;
   end Defer_Abortion;

   ----------------------
   -- Undefer_Abortion --
   ----------------------

   --  Precondition : Self does not hold any locks!

   --  Undefer_Abortion is called on any abortion completion point (aka.
   --  synchonization point). It performs the following actions if they
   --  are pending: (1) change the base priority, (2) abort the task.
   --  The priority change has to occur before abortion. Otherwise, it would
   --  take effect no earlier than the next abortion completion point.
   --  This version of Undefer_Abortion redefers abortion if abortion is
   --  in progress.  There has been some discussion of having
   --  the raise statement defer abortion to prevent abortion of
   --  handlers performing required completion.  This would make
   --  the explicit deferral unnecessary. ???

   procedure Undefer_Abortion is
      T : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Error : Boolean;

   begin
      T.Deferral_Level := T.Deferral_Level - 1;

      if T.Deferral_Level = ATC_Level'First and then T.Pending_Action then
         Write_Lock (T.L, Error);
         T.Pending_Action := False;

         if T.Pending_Priority_Change then
            Change_Base_Priority (T);
         end if;

         Unlock (T.L);

         if T.Pending_ATC_Level < T.ATC_Nesting_Level then
            T.Deferral_Level := T.Deferral_Level + 1;
            raise Standard'Abort_Signal;
         end if;
      end if;

   end Undefer_Abortion;

   -----------------
   -- Abort_Tasks --
   -----------------

   --  Called to initiate abortion, however, the actual abortion
   --  is done by abortee by means of Abort_Handler

   procedure Abort_Tasks (Tasks : Task_List) is
      Abortee               : Utilities.ATCB_Ptr;
      Aborter               : Utilities.ATCB_Ptr;
      Activator             : Utilities.ATCB_Ptr;
      TAS_Result            : Boolean;
      Old_Pending_ATC_Level : ATC_Level_Base;

   begin
      Defer_Abortion;

      --  Begin non-abortable section

      Aborter := ID_To_ATCB (Self);

      for J in Tasks'range loop

         Abortee := ID_To_ATCB (Tasks (J));

         if Abortee.Stage = Utilities.Created then
            Utilities.Complete (ATCB_To_ID (Abortee));
            Abortee.Stage := Utilities.Terminated;
            --  Task aborted before activation is safe to complete
            --  Mark This task to be terminated.
         else
            Abortee.Accepting := Utilities.Not_Accepting;
            Utilities.Complete_on_Sync_Point (ATCB_To_ID (Abortee));
            Utilities.Abort_To_Level (ATCB_To_ID (Abortee), 0);
            --  Process abortion of child tasks
            Utilities.Abort_Dependents (ATCB_To_ID (Abortee));
         end if;

      end loop;

      --  End non-abortable section

      Undefer_Abortion;
   end Abort_Tasks;

end System.Tasking.Abortion;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.8
--  date: Tue May 31 13:38:52 1994;  author: giering
--  RTS Restructuring (Separating out non-compiler-interface definitions)
--  ----------------------------
--  revision 1.9
--  date: Mon Jun 13 15:09:15 1994;  author: giering
--  LL_Task creation is defered until the task activation time. Accordingly,
--   Task_Abortion for unactivated task is modified. For Created but
--   unactivated tasks, Abort_Task involves just the task completion.
--  Checked in from FSU by doh.
--  ----------------------------
--  revision 1.10
--  date: Wed Jul 13 10:24:08 1994;  author: giering
--  Dynamic priority support added.
--  Checked in from FSU by mueller.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
