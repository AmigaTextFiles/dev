------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                 S Y S T E M . T A S K I N G . Q U E U I N G              --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.5 $                             --
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

with System.Task_Primitives; use System.Task_Primitives;

package body System.Tasking.Queuing is

   --  Entry Queues implemented as doubly linked list, priority ordered

   -------------
   -- Enqueue --
   -------------

   --  Enqueue call priority ordered, FIFO at same priority level

   procedure Enqueue (E : in out Entry_Queue; Call : Entry_Call_Link) is
      Temp : Entry_Call_Link := E.Head;
   begin
      if Temp = null then
         Call.Prev := Call;
         Call.Next := Call;
         E.Head := Call;
         E.Tail := Call;
      else
         loop  --  find the entry that the new guy should precede
            exit when Call.Prio > Temp.Prio;
            Temp := Temp.Next;
            if Temp = E.Head then
               Temp := null;
               exit;
            end if;
         end loop;

         if Temp = null then -- insert at tail
            Call.Prev := E.Tail;
            Call.Next := E.Head;
            E.Tail := Call;
         else
            Call.Prev := Temp.Prev;
            Call.Next := Temp;

            if Temp = E.Head then -- insert at head
               E.Head := Call;
            end if;
         end if;

         Call.Prev.Next := Call;
         Call.Next.Prev := Call;

      end if;
   end Enqueue;

   -------------
   -- Dequeue --
   -------------

   --  Dequeue call from entry_queue E

   procedure Dequeue (E : in out Entry_Queue; Call : Entry_Call_Link) is
      Prev : Entry_Call_Link;

   begin
      --  If empty queue, simply return

      if E.Head = null then
         return;
      end if;

      Call.Prev.Next := Call.Next;
      Call.Next.Prev := Call.Prev;

      if E.Head = Call then
         if E.Tail = Call then
            E.Head := null; --  case of one element
            E.Tail := null;
         else
            E.Head := Call.Next;
         end if;
      elsif E.Tail = Call then
         E.Tail := Call.Prev;
      end if;

      --  Successfully dequeued

      Call.Prev := null;
      Call.Next := null;

   end Dequeue;

   ----------
   -- Head --
   ----------

   --  Return the head of entry_queue E

   function Head (E : in Entry_Queue) return Entry_Call_Link is
   begin
      return E.Head;
   end Head;

   ------------------
   -- Dequeue_Head --
   ------------------

   --  Remove and return the head of entry_queue E

   procedure Dequeue_Head
     (E    : in out Entry_Queue;
      Call : out Entry_Call_Link)
   is
      Temp : Entry_Call_Link;

   begin
      --  If empty queue, return null pointer

      if E.Head = null then
         Call := null;
         return;
      end if;

      Temp := E.Head;

      if E.Head = E.Tail then
         E.Head := null; --  case of one element
         E.Tail := null;
      else
         E.Head := Temp.Next;
         Temp.Prev.Next := Temp.Next;
         Temp.Next.Prev := Temp.Prev;
      end if;

      --  Successfully dequeued

      Temp.Prev := null;
      Temp.Next := null;
      Call := Temp;
   end Dequeue_Head;

   -------------
   -- Onqueue --
   -------------

   --  Return True if Call is on any entry_queue at all

   function Onqueue (Call : Entry_Call_Link) return Boolean is
   begin
      --  Utilize the fact that every queue is circular, so if Call
      --  is on any queue at all, Call.Next must NOT be null.

      return Call.Next /= null;
   end Onqueue;

   -------------------
   -- Count_Waiting --
   -------------------

   --  Return number of calls on the waiting queue of E

   function Count_Waiting (E : in Entry_Queue) return Natural is
      Count : Natural;
      Temp : Entry_Call_Link;

   begin
      Count := 0;

      if E.Head /= null then
         Temp := E.Head;

         loop
            Count := Count + 1;
            exit when E.Tail = Temp;
            Temp := Temp.Next;
         end loop;
      end if;

      return Count;
   end Count_Waiting;

   ----------------------------
   -- Select_Task_Entry_Call --
   ----------------------------

   --  Select an entry for rendezvous

   procedure Select_Task_Entry_Call
     (Acceptor     : Utilities.ATCB_Ptr;
      Open_Accepts : Accept_List_Access;
      Call         : out Entry_Call_Link;
      Selection    : out Select_Index)
   is
      Entry_Call  : Entry_Call_Link;
      Temp_Call   : Entry_Call_Link;
      Entry_Index : Task_Entry_Index;
      Temp_Entry  : Task_Entry_Index;
      TAS_Result  : Boolean;
   begin
      loop
         Entry_Call := null;

         for J in Open_Accepts'range loop
            Temp_Entry := Open_Accepts (J).S;
            if Temp_Entry /= Null_Task_Entry then
               Temp_Call := Head (Acceptor.Entry_Queues (Temp_Entry));
               if Temp_Call /= null and then
                 (Entry_Call = null or else
                  Entry_Call.Prio < Temp_Call.Prio)
               then
                  Entry_Call := Head (Acceptor.Entry_Queues (Temp_Entry));
                  Entry_Index := Temp_Entry;
                  Selection := J;
               end if;
            end if;
         end loop;

         if Entry_Call = null then
            Selection := No_Rendezvous;
            exit;
         end if;

         --  Guard is open
         Dequeue_Head (Acceptor.Entry_Queues (Entry_Index), Entry_Call);
         Test_And_Set (Entry_Call.Call_Claimed'Address, TAS_Result);
         exit when TAS_Result;
         --  TAS_Result = False only when the call is already canceled
         --  in that case, we go on to the next call on the queue
      end loop;

      Call := Entry_Call;

   end Select_Task_Entry_Call;

   ---------------------------------
   -- Select_Protected_Entry_Call --
   ---------------------------------

   --  Select an entry of a protected object

   procedure Select_Protected_Entry_Call
     (Object    : Protection_Access;
      Barriers  : Barrier_Vector;
      Call      : out Entry_Call_Link)
   is
      Entry_Call  : Entry_Call_Link;
      Temp_Call   : Entry_Call_Link;
      Entry_Index : Protected_Entry_Index;
      TAS_Result  : Boolean;
   begin
      loop
         Entry_Call := null;

         for J in Barriers'range loop
            if Barriers (J) then
               Temp_Call := Head (Object.Entry_Queues (J));
               if Temp_Call /= null and then
                  (Entry_Call = null or else
                   Entry_Call.Prio < Temp_Call.Prio)
               then
                  Entry_Call := Temp_Call;
                  Entry_Index := J;
               end if;
            end if;
         end loop;

         exit when Entry_Call = null;

         --  Barrier is open
         Dequeue_Head (Object.Entry_Queues (Entry_Index), Entry_Call);
         if Entry_Call.Abortable then
            Test_And_Set (Entry_Call.Call_Claimed'Address, TAS_Result);
            exit when TAS_Result;
         --  If call is not abortable, it has already been claimed for us
         else
            exit;
         end if;

      end loop;

      Call := Entry_Call;

   end Select_Protected_Entry_Call;

end System.Tasking.Queuing;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Wed Jul 13 10:26:46 1994;  author: giering
--  Dynamic priority support added.
--  Checked in from FSU by mueller.
--  ----------------------------
--  revision 1.4
--  date: Wed Jul 13 10:39:08 1994;  author: giering
--  comments added for style
--  Checked in from FSU by mueller.
--  ----------------------------
--  revision 1.5
--  date: Tue Jul 26 12:55:36 1994;  author: giering
--  (Select_Task_Entry_Call): Added Selection out parameter to return
--   the index of the chosen entry in the select list array.
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
