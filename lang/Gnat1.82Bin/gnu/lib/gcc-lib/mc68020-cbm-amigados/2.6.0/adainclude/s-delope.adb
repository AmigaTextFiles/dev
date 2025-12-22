-----------------------------------------------------------------------------
--                                                                         --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                         --
--              S y s t e m . D e l a y _ O p e r a t i o n s              --
--                                                                         --
--                                 B o d y                                 --
--                                                                         --
--                            $Revision: 1.4 $                            --
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

with System.Tasking;
--  Used for, Communication_Block
--            Simple_Call

with System.Tasking.Abortion;
--  Used for, Defer_Abortion
--            Undefer_Abortion

with Ada.Calendar.Delays;
--  Used for, Delay_Object
--            Delay_Until_Object

with Ada.Real_Time;
--  Used for, Time
--            Time_Span
--            Delay_Object

with Ada.Real_Time.Delays;
--  Used for, Delay_Until_Object

with System.Tasking.Protected_Objects; use System.Tasking.Protected_Objects;

package body System.Delay_Operations is

   procedure Delay_For (D : Duration) is
      P : Ada.Calendar.Delays.Delay_Object.Params := (Param => D);
      S : boolean;
      B : Tasking.Communication_Block;
      PS  : Boolean;
      C  : Boolean;
   begin
      Tasking.Abortion.Defer_Abortion;
      Lock (Ada.Calendar.Delays.Delay_Object.Object'Access);
      Protected_Entry_Call (
            Object => Ada.Calendar.Delays.Delay_Object.Object'Access,
            E => 1,
            Uninterpreted_Data => P'Address,
            Mode => Tasking.Simple_Call,
            Block => B);
      Ada.Calendar.Delays.Delay_Object.Service_Entries (PS);
      Unlock (Ada.Calendar.Delays.Delay_Object.Object'Access);

      if not PS then
         Wait_For_Completion (C, B);
         if C then
            Ada.Calendar.Delays.Delay_Object.Service_Entries (PS);
            Unlock (Ada.Calendar.Delays.Delay_Object.Object'Access);
         end if;
      end if;
      Tasking.Abortion.Undefer_Abortion;
      Tasking.Protected_Objects.Raise_Pending_Exception (B);
   end Delay_For;

   procedure Delay_Until (T : Calendar.Time) is
      P : Ada.Calendar.Delays.Delay_Until_Object.Params := (Param => T);
      S : boolean;
      B : Tasking.Communication_Block;
      PS : Boolean;
      C : Boolean;
   begin
      Tasking.Abortion.Defer_Abortion;
      Lock (Ada.Calendar.Delays.Delay_Until_Object.Object'Access);
      Protected_Entry_Call (
            Object => Ada.Calendar.Delays.Delay_Until_Object.Object'Access,
            E => 1,
            Uninterpreted_Data => P'Address,
            Mode => Tasking.Simple_Call,
            Block => B);
      Ada.Calendar.Delays.Delay_Until_Object.Service_Entries (PS);
      Unlock (Ada.Calendar.Delays.Delay_Until_Object.Object'Access);

      if not PS then
         Wait_For_Completion (C, B);
         if C then
            Ada.Calendar.Delays.Delay_Until_Object.Service_Entries (PS);
            Unlock (Ada.Calendar.Delays.Delay_Until_Object.Object'Access);
         end if;
      end if;
      Tasking.Abortion.Undefer_Abortion;
      Tasking.Protected_Objects.Raise_Pending_Exception (B);
   end Delay_Until;

   procedure RT_Delay_For (TS : Real_Time.Time_Span) is
      P : Real_Time.Delay_Object.Params  := (Param => TS);
      S : boolean;
      B : Tasking.Communication_Block;
      PS : Boolean;
      C : Boolean;
   begin
      Tasking.Abortion.Defer_Abortion;
      Lock (Real_Time.Delay_Object.Object'Access);
      Protected_Entry_Call (
            Object => Real_Time.Delay_Object.Object'Access,
            E => 1,
            Uninterpreted_Data => P'Address,
            Mode => Tasking.Simple_Call,
            Block => B);
      Real_Time.Delay_Object.Service_Entries (PS);
      Unlock (Real_Time.Delay_Object.Object'Access);

      if not PS then
         Wait_For_Completion (C, B);
         if C then
            Real_Time.Delay_Object.Service_Entries (PS);
            Unlock (Real_Time.Delay_Object.Object'Access);
         end if;
      end if;
      Tasking.Abortion.Undefer_Abortion;
      Tasking.Protected_Objects.Raise_Pending_Exception (B);
   end RT_Delay_For;


   procedure RT_Delay_Until (T : Real_Time.Time) is
      P : Real_Time.Delays.Delay_Until_Object.Params := (Param => T);
      S : boolean;
      B : Tasking.Communication_Block;
      PS : Boolean;
      C : Boolean;
   begin
      Tasking.Abortion.Defer_Abortion;
      Lock (Real_Time.Delays.Delay_Until_Object.Object'Access);
      Protected_Entry_Call (
            Object => Real_Time.Delays.Delay_Until_Object.Object'Access,
            E => 1,
            Uninterpreted_Data => P'Address,
            Mode => Tasking.Simple_Call,
            Block => B);
      Real_Time.Delays.Delay_Until_Object.Service_Entries (PS);
      Unlock (Real_Time.Delays.Delay_Until_Object.Object'Access);

      if not PS then
         Wait_For_Completion (C, B);
         if C then
            Real_Time.Delays.Delay_Until_Object.Service_Entries (PS);
            Unlock (Real_Time.Delays.Delay_Until_Object.Object'Access);
         end if;
      end if;
      Tasking.Abortion.Undefer_Abortion;
      Tasking.Protected_Objects.Raise_Pending_Exception (B);
   end RT_Delay_Until;

end System.Delay_Operations;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Wed Jun  1 12:39:15 1994;  author: giering
--  Minor Reformatting.
--  ----------------------------
--  revision 1.3
--  date: Tue Jun  7 11:23:02 1994;  author: giering
--  Changed name from System.Real_Time to Ada.Real_Time (per LRM 4.0).
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.4
--  date: Fri Aug  5 16:41:39 1994;  author: giering
--  Put "RT_" in front of operations on Real_Time types, to avoid
--   overloading (which Rtsfind does not like).
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
