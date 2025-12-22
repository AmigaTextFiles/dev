------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--            S Y S T E M . T A S K I N G _ S O F T _ L I N K S             --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.4 $                              --
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

--  This package contains a set of subprogram access variables that access
--  some basic tasking primitives that are called from non-tasking code (e.g.
--  the defer/undefer abort that surrounds a finalization action). To avoid
--  dragging in the tasking all the time, we use a system of soft links where
--  the links are initialized to dummy non-tasking versions, and then if the
--  tasking is initialized, they are reset to the real tasking versions.

package System.Tasking_Soft_Links is

   --  First we have the access subprogram types used to establish the links.
   --  The approach is to establish variables containing access subprogram
   --  values which by default point to dummy no tasking versions of routines.

   --  Note: the reason that Get_Address_Call has a dummy parameter is that
   --  there is a bug in GNAT with access to subprograms with no params ???

   type No_Param_Proc    is access procedure;
   type Get_Address_Call is access function (Dummy : Boolean) return Address;

   --  Declarations for the no tasking versions of the required routines

   procedure Abort_Defer_NT;
   --  Defer task abortion (non-tasking case, does nothing)

   procedure Abort_Undefer_NT;
   --  Undefer task abortion (non-tasking case, does nothing)

   procedure Task_Lock_NT;
   --  Lock out other tasks (non-tasking case, does nothing)

   procedure Task_Unlock_NT;
   --  Release lock set by Task_Lock (non-tasking case, does nothing)

   function Get_TSD_Address_NT (Dummy : Boolean) return Address;
   --  Obtain pointer to TSD (non-tasking case, gets special global TSD that
   --  is allocated and initialized by the System.Task_Specific_Data package)

   Abort_Defer : No_Param_Proc := Abort_Defer_NT'Access;
   --  Defer task abortion (task/non-task case as appropriate)

   Abort_Undefer : No_Param_Proc := Abort_Undefer_NT'Access;
   --  Undefer task abortion (task/non-task case as appropriate)

   Get_TSD_Address : Get_Address_Call := Get_TSD_Address_NT'Access;
   --  Get pointer to task specific data  (task/non-task case as appropriate)

   Lock_Task : No_Param_Proc := Task_Lock_NT'Access;
   --  Locks out other tasks. Preceding a section of code by Task_Lock and
   --  following it by Task_Unlock creates a critical region. This is used
   --  for ensuring that a region of non-tasking code (such as code used to
   --  allocate memory) is tasking safe. Note that it is valid for calls to
   --  Task_Lock/Task_Unlock to be nested, and this must work properly, i.e.
   --  only the corresponding outer level Task_Unlock will actually unlock.

   Unlock_Task : No_Param_Proc := Task_Unlock_NT'Access;
   --  Releases lock previously set by call to Lock_Task. In the nested case,
   --  all nested locks must be released before other tasks competing for the
   --  tasking lock are released.

end System.Tasking_Soft_Links;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Thu Apr 28 02:38:47 1994;  author: dewar
--  (Get/Set_Sec_Stack_Addr): New subprograms
--  Add Dummy param to Get_Address_Call, to avoid GNAT bug
--  ----------------------------
--  revision 1.3
--  date: Thu Apr 28 14:50:40 1994;  author: dewar
--  Replace the six Get/Set routines by a single Get_TSD_Address function
--  ----------------------------
--  revision 1.4
--  date: Mon May  2 10:51:12 1994;  author: dewar
--  (Task_Lock, Task_Unlock): New subprograms
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
