------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                   A D A . R E A L _ T I M E . D E L A Y S                --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.7 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2, or  (at  your  option)  any --
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
--  Used for, Priority

with System.Compiler_Exceptions;
--  Used for, Current_Exceptions

with System.Task_Timer_Service;
--  Used for, Objects
--            Service_Entries

with System.Tasking.Protected_Objects;

with System.Tasking;

with Unchecked_Conversion;

package body Ada.Real_Time.Delays is

   use System.Tasking.Protected_Objects;

   use Tasking;

   package Timer renames System.Task_Timer_Service.Timer;

   function To_Access is new
     Unchecked_Conversion (System.Address, Protection_Access);

   package body Delay_Until_Object is

      procedure Service_Entries (Pending_Serviced : out Boolean) is

         P : System.Address;

         subtype PO_Entry_Index is Protected_Entry_Index
           range Null_Protected_Entry .. 1;

         Barriers : Tasking.Barrier_Vector (1 .. 1)  := (others => true);
         --  No barriers. always true barrier

         E : PO_Entry_Index;

         PS : Boolean;

         Cumulative_PS : Boolean := False;

      begin
         loop
            --  Get the next queued entry or the pending call
            --  (if no barriers are true)

            Tasking.Protected_Objects.Next_Entry_Call
              (To_Access (Object'Address), Barriers, P, E);

            begin
               case E is

                  --  No pending call to serve

                  when Null_Protected_Entry =>
                     exit;

                  --  Call to be served

                  when 1 =>

                     --  Lock the object before requeueing
                     Tasking.Protected_Objects.Lock
                       (To_Access (Timer.Object'Address));

                     --  Requeue on the timer for the service. Parameter is
                     --  passed along as Object.Call_In_Progress.Param

                     Requeue_Protected_Entry (
                       Object => To_Access (Object'Address),
                       New_Object => To_Access (Timer.Object'Address),
                       E => 3,
                       With_Abort => True);
                     Timer.Service_Entries (PS);
                     Tasking.Protected_Objects.Unlock
                       (To_Access (Timer.Object'Address));

               end case;

            exception
               when others =>
                  Tasking.Protected_Objects.Exceptional_Complete_Entry_Body (
                    Object => To_Access (Object'Address),
                    Ex => Compiler_Exceptions.Current_Exception,
                    Pending_Serviced => PS);
            end;

            Cumulative_PS := Cumulative_PS or PS;
         end loop;

         Pending_Serviced := Cumulative_PS;
      end Service_Entries;

   --  Initialization for package body of Delay_Until_Object.  Any task
   --  might call this, so give it the highest possible ceiling priority.

   begin
      Initialize_Protection
        (To_Access (Object'Address), System.Priority'Last);

   end Delay_Until_Object;

end Ada.Real_Time.Delays;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Wed Jun  1 12:42:29 1994;  author: giering
--  Minor Reformatting.
--  ----------------------------
--  revision 1.6
--  date: Tue Jun  7 11:26:00 1994;  author: giering
--  Changed name from System.Real_Time to Ada.Real_Time (per LRM 4.0).
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.7
--  date: Fri Aug  5 16:41:11 1994;  author: giering
--  (Delay_Until_Object):  Gave Delay_Until_Object the highest possible
--   ceinling priority.
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
