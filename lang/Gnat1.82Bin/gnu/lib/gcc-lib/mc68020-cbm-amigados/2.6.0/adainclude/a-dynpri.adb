------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                 A D A . D Y N A M I C _ P R I O R I T I E S              --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.2 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2,  or  (at  your  option) any --
--  later  version.   GNARL is distributed in the hope that it will be use- --
--  ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
--  MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
--  eral Library Public License for more details.  You should have received --
--  a  copy of the GNU Library General Public License along with GNARL; see --
--  file COPYING. If not, write to the Free Software Foundation,  675  Mass --
--  Ave, Cambridge, MA 02139, USA.                                          --
--                                                                          --
------------------------------------------------------------------------------

with System.Tasking; use System.Tasking;

with System.Tasking.Utilities;
--  Used for, Utilities.ATCB_Ptr,
--            Utilities.ATCB_To_ID

with System.Tasking.Stages;
--  Used for, System.Tasking.Stages.Terminated

with System.Task_Primitives; use System.Task_Primitives;

with Unchecked_Conversion;

package body Ada.Dynamic_Priorities is

   function ID_To_ATCB (ID : Task_ID) return Utilities.ATCB_Ptr
     renames Tasking.Utilities.ID_To_ATCB;

   function Convert_Ids is new
     Unchecked_Conversion
       (Task_Identification.Task_Id, System.Tasking.Task_ID);

   ------------------
   -- Set_Priority --
   ------------------

   --  Change base priority of a task dynamically

   procedure Set_Priority
     (Priority : System.Any_Priority;
      T        : Ada.Task_Identification.Task_ID)
   is
      Target : constant Utilities.ATCB_Ptr := ID_To_ATCB (Convert_Ids (T));
      Source : constant Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Error  : Boolean;

   begin
      if Task_Identification.Is_Terminated (T) then
         raise Tasking_Error;
      end if;

      if T = Ada.Task_Identification.Null_Task_Id then
         raise Program_Error;
      end if;

      Task_Primitives.Write_Lock (Target.L, Error);

      if Source = Target then
         Target.Current_Priority := Priority;
         Target.Base_Priority := Priority;
         System.Task_Primitives.Set_Priority (Target.LL_TCB'access, Priority);

      else

         Target.New_Base_Priority := Priority;
         Target.Pending_Priority_Change := True;
         Target.Pending_Action := True;

         if Target.Suspended_Abortably then
            Cond_Signal (Target.Cond);
            Cond_Signal (Target.Rend_Cond);

            --  Ugly; think about ways to have tasks suspend on one
            --  condition variable. ???

         end if;

         --  check for ceiling violations ???
      end if;

      Task_Primitives.Unlock (Target.L);

   end Set_Priority;

   ------------------
   -- Get_Priority --
   ------------------

   --  Inquire base priority of a task

   function Get_Priority
     (T    : Ada.Task_Identification.Task_ID)
      return System.Any_Priority is

   begin
      if Task_Identification.Is_Terminated (T) then
         raise Tasking_Error;
      end if;

      if T = Ada.Task_Identification.Null_Task_Id then
         raise Program_Error;
      end if;

      return ID_To_ATCB (Convert_Ids (T)).Base_Priority;
   end Get_Priority;

end Ada.Dynamic_Priorities;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Wed Jul 13 10:10:22 1994;  author: giering
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Fri Jul 22 00:37:50 1994;  author: dewar
--  Clean up revision history mess
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
