------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                 S Y S T E M . T A S K I N G . Q U E U I N G              --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.4 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2, or (at  your  option)  any  --
--  later  version.   GNARL is distributed in the hope that it will be use- --
--  ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
--  MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
--  eral Library Public License for more details.  You should have received --
--  a  copy of the GNU Library General Public License along with GNARL; see --
--  file COPYING. If not, write to the Free Software Foundation,  675  Mass --
--  Ave, Cambridge, MA 02139, USA.                                          --
--                                                                          --
------------------------------------------------------------------------------

with System.Tasking.Utilities;
--  Used for, Utilities.ATCB_Ptr

package System.Tasking.Queuing is

   procedure Enqueue (E : in out Entry_Queue; Call : Entry_Call_Link);
   --  Enqueue Call at the end of entry_queue E

   procedure Dequeue (E : in out Entry_Queue; Call : Entry_Call_Link);
   --  Dequeue Call from entry_queue E

   function Head (E : in Entry_Queue) return Entry_Call_Link;
   --  Return the head of entry_queue E

   procedure Dequeue_Head
     (E    : in out Entry_Queue;
      Call : out Entry_Call_Link);
   --  Remove and return the head of entry_queue E

   function Onqueue (Call : Entry_Call_Link) return Boolean;
   --  Return True if Call is on any entry_queue at all

   function Count_Waiting (E : in Entry_Queue) return Natural;
   --  Return number of calls on the waiting queue of E

   procedure Select_Task_Entry_Call
     (Acceptor     : Utilities.ATCB_Ptr;
      Open_Accepts : Accept_List_Access;
      Call         : out Entry_Call_Link;
      Selection    : out Select_Index);
   --  Select an entry for rendezvous

   procedure Select_Protected_Entry_Call
     (Object    : Protection_Access;
      Barriers  : Barrier_Vector;
      Call      : out Entry_Call_Link);
   --  Select an entry of a protected object

end System.Tasking.Queuing;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Thu Apr 21 14:45:51 1994;  author: dewar
--  Minor reformatting
--  Remove redundant revision history section
--  Add pragma Elaborate_Body, so that body is required
--  ----------------------------
--  revision 1.3
--  date: Wed Jul 13 10:27:12 1994;  author: giering
--  Dynamic priority support added.
--  Checked in from FSU by mueller.
--  ----------------------------
--  revision 1.4
--  date: Tue Jul 26 12:55:00 1994;  author: giering
--  (Select_Task_Entry_Call): Added Selection out parameter to return
--   the index of the chosen entry in the select list array.
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
