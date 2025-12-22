------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--               S Y S T E M . S E C O N D A R Y _ S T A C K                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.19 $                             --
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

with System.Task_Specific_Data; use System.Task_Specific_Data;

with Unchecked_Conversion;
with Unchecked_Deallocation;

package body System.Secondary_Stack is



   --                                      +------------------+
   --                                      |       Next       |
   --                                      +------------------+
   --                                      |                  | Last (200)
   --                                      |                  |
   --                                      |                  |
   --                                      |                  |
   --                                      |                  |
   --                                      |                  |
   --                                      |                  | First (101)
   --                                      +------------------+
   --                         +----------> |          |       |
   --                         |            +----------+-------+
   --                         |                    |  |
   --                         |                    ^  V
   --                         |                    |  |
   --                         |            +-------+----------+
   --                         |            |       |          |
   --                         |            +------------------+
   --                         |            |                  | Last (100)
   --                         |            |         C        |
   --                         |            |         H        |
   --    +-----------------+  |  +-------->|         U        |
   --    |  Current_Chunk -|--+  |         |         N        |
   --    +-----------------+     |         |         K        |
   --    |       Top      -|-----+         |                  | First (1)
   --    +-----------------+               +------------------+
   --    | Default_Size    |               |       Prev       |
   --    +-----------------+               +------------------+
   --
   --

   type Memory is array (Mark_Id range <>) of Storage_Element;

   type Chunk_Id (First, Last : Mark_Id);
   type Chunk_Ptr is access Chunk_Id;

   type Chunk_Id (First, Last : Mark_Id) is record
      Prev, Next : Chunk_Ptr;
      Mem        : Memory (First .. Last);
   end record;

   type Stack_Id is record
      Top           : Mark_Id;
      Current_Chunk : Chunk_Ptr;
      Default_Size  : Storage_Count;
   end record;

   type Stack_Ptr is access Stack_Id;

   function From_Addr is new Unchecked_Conversion (Address, Stack_Ptr);
   function To_Addr   is new Unchecked_Conversion (Stack_Ptr, System.Address);

   ------------------
   -- Storage_Size --
   ------------------

   function Storage_Size (Pool : Secondary_Stack_Pool) return Storage_Count is
      Stack : constant Stack_Ptr := From_Addr (Get_Sec_Stack_Addr);
      Chunk : Chunk_Ptr := Stack.Current_Chunk;

   begin
      while Chunk.Next /= null loop
         Chunk := Chunk.Next;
      end loop;

      return Storage_Count (Chunk.Last);
   end Storage_Size;

   --------------
   -- Allocate --
   --------------

   procedure Allocate
     (Pool         : in out Secondary_Stack_Pool;
      Address      :    out System.Address;
      Storage_Size : in     Storage_Count;
      Alignment    : in     Storage_Count)
   is
      Stack : constant Stack_Ptr := From_Addr (Get_Sec_Stack_Addr);
      Chunk : Chunk_Ptr := Stack.Current_Chunk;

   begin
      --  The Current_Chunk may not be the good one if a lot of release
      --  operations have taken place. So go down the stack if necessary

      while  Chunk.First > Stack.Top loop
         Chunk := Chunk.Prev;
      end loop;

      --  Find out if the available memory in the current chunk is sufficient.
      --  if not, go to the next one and eventally create the necessary room

      while Chunk.Last - Stack.Top + 1 < Mark_Id (Storage_Size) loop
         if Chunk.Next /= null then
            Chunk := Chunk.Next;

         --  Create new chunk of the default size unless it is not sufficient

         elsif Storage_Size <= Stack.Default_Size then
            Chunk.Next := new Chunk_Id (
              First => Chunk.Last + 1,
              Last => Chunk.Last + Mark_Id (Stack.Default_Size));

            Chunk.Next.Prev := Chunk;

         else
            Chunk.Next := new Chunk_Id (
              First => Chunk.Last + 1,
              Last  => Chunk.Last + Mark_Id (Storage_Size));

            Chunk.Next.Prev := Chunk;
         end if;

         Stack.Top := Chunk.First;
      end loop;

      --  Resulting address is the address pointed by Stack.Top

      Address             := Chunk.Mem (Stack.Top)'Address;
      Stack.Top           := Stack.Top + Mark_Id (Storage_Size);
      Stack.Current_Chunk := Chunk;
   end Allocate;

   ----------------
   -- Deallocate --
   ----------------

   --  Nothing to do, since space is released by an unmark operation

   procedure Deallocate
     (Pool         : in out Secondary_Stack_Pool;
      Address      : in     System.Address;
      Storage_Size : in     Storage_Count;
      Alignment    : in     Storage_Count)
   is
   begin
      null;
   end Deallocate;

   -------------
   -- SS_Init --
   -------------

   procedure SS_Init (Stk : out System.Address; Size : Natural) is
      Stack : Stack_Ptr;

   begin
      Stack               := new Stack_Id;
      Stack.Current_Chunk := new Chunk_Id (1, Mark_Id (Size));
      Stack.Top           := 1;
      Stack.Default_Size  := Storage_Count (Size);

      Stk := To_Addr (Stack);
   end SS_Init;

   -------------
   -- SS_Free --
   -------------

   procedure SS_Free (Stk : System.Address) is
      Stack : Stack_Ptr := From_Addr (Stk);
      Chunk : Chunk_Ptr := Stack.Current_Chunk;

      procedure Free is new Unchecked_Deallocation (Stack_Id, Stack_Ptr);
      procedure Free is new Unchecked_Deallocation (Chunk_Id, Chunk_Ptr);

   begin
      while Chunk.Prev /= null loop
         Chunk := Chunk.Prev;
      end loop;

      while Chunk.Next /= null loop
         Chunk := Chunk.Next;
         Free (Chunk.Prev);
      end loop;

      Free (Chunk);
      Free (Stack);
   end SS_Free;

   -------------
   -- SS_Mark --
   -------------

   function SS_Mark return Mark_Id is
   begin
      return From_Addr (Get_Sec_Stack_Addr).Top;
   end SS_Mark;

   ----------------
   -- SS_Release --
   ----------------

   procedure SS_Release (M : Mark_Id) is
   begin
      From_Addr (Get_Sec_Stack_Addr).Top := M;
   end SS_Release;

   -------------
   -- SS_Info --
   -------------

   procedure SS_Info is
      Stack     : constant Stack_Ptr := From_Addr (Get_Sec_Stack_Addr);
      Nb_Chunks : Integer            := 1;
      Chunk     : Chunk_Ptr          := Stack.Current_Chunk;

   begin
      Put_Line ("Secondary Stack information:");

      while Chunk.Prev /= null loop
         Chunk := Chunk.Prev;
      end loop;

      while Chunk.Next /= null loop
         Nb_Chunks := Nb_Chunks + 1;
         Chunk := Chunk.Next;
      end loop;

      --  Current Chunk information

      Put_Line (
        "  Total size              : "
        & Mark_Id'Image (Chunk.Last)
        & " bytes");
      Put_Line (
        "  Current allocated space : "
        & Mark_Id'Image (Stack.Top - 1)
        & " bytes");

      Put_Line (
        "  Number of Chunks       : "
        & Integer'Image (Nb_Chunks));

      Put_Line (
        "  Default size of Chunks : "
        & Storage_Count'Image (Stack.Default_Size));
   end SS_Info;

end System.Secondary_Stack;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.17
--  date: Wed Jun 29 09:44:34 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.18
--  date: Wed Jun 29 18:04:34 1994;  author: banner
--  reverted back to version 1.15 due to bootstrap path problem.
--  ----------------------------
--  revision 1.19
--  date: Fri Aug 19 20:27:44 1994;  author: comar
--  Revert back to version 1.17 now that bootstrap problem is gone.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
