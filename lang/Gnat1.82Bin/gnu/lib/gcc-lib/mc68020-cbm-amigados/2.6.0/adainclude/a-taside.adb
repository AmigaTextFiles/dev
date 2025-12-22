------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--              A D A . T A S K _ I D E N T I F I C A T I O N               --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.5 $                              --
--                                                                          --
--           Copyright (c) 1992,1993,1994 NYU, All Rights Reserved          --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT;  see file COPYING.  If not, write --
-- to the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. --
--                                                                          --
------------------------------------------------------------------------------

with System.Tasking.Abortion;
with System.Tasking.Stages;
with System.Tasking.Rendezvous;

package body Ada.Task_Identification is

   ---------
   -- "=" --
   ---------

   function  "=" (Left, Right : Task_Id) return Boolean is
   begin
      return System.Tasking."=" (Convert_Ids (Left), Convert_Ids (Right));
   end "=";

   -----------------
   -- Abort_Task --
   ----------------

   procedure Abort_Task (T : in out Task_Id) is
   begin
      System.Tasking.Abortion.Abort_Tasks
        (System.Tasking.Task_List'(1 => Convert_Ids (T)));
   end Abort_Task;

   ------------------
   -- Current_Task --
   ------------------

   function Current_Task return Task_Id is
   begin
      return Convert_Ids (System.Tasking.Self);
   end Current_Task;

   -----------
   -- Image --
   -----------

   function Image (T : Task_Id) return String is
   begin
      return "???";  --  ???
   end Image;

   -----------------
   -- Is_Callable --
   -----------------

   function Is_Callable (T : Task_Id) return Boolean is
   begin
      return System.Tasking.Rendezvous.Callable (Convert_Ids (T));
   end Is_Callable;

   -------------------
   -- Is_Terminated --
   -------------------

   function Is_Terminated (T : Task_Id) return Boolean is
   begin
      return
        System.Tasking.Stages.Terminated (Convert_Ids (T));
   end Is_Terminated;

end Ada.Task_Identification;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Mon May  2 10:50:11 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.4
--  date: Thu May 12 13:26:45 1994;  author: dewar
--  Updated for new tasking structure
--  ----------------------------
--  revision 1.5
--  date: Wed Jun  1 16:53:39 1994;  author: dewar
--  Change Task_Id to address type (gets by problems with GNAT when Task_Id
--   was declared as being derived from the System.Tasking.Task_ID).
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
