------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--    S Y S T E M . F I N A L I Z A T I O N _ I M P L E M E N T A T I O N   --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.8 $                              --
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

with Ada.Finalization; use Ada.Finalization;

package body System.Finalization_Implementation is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Object : in out Root_Controlled) is
   begin
      null;
   end Initialize;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Object : in out Root_Controlled) is
   begin
      null;
   end Finalize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Object : in out Root_Limited_Controlled) is
   begin
      null;
   end Initialize;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Object : in out Root_Limited_Controlled) is
   begin
      null;
   end Finalize;


   --------------------------
   -- Attach_To_Final_List --
   --------------------------

   procedure Attach_To_Final_List (
     L   : in out Finalizable_Ptr;
     Obj : in out Finalizable) is

   begin
      if L /= null then
         Obj.Next := L;
         Finalizable (L.all).Previous := Empty_Root (Obj)'access;
      else
         Obj.Next := null;
      end if;

      Obj.Previous := null;
      L := Empty_Root (Obj)'access;
   end Attach_To_Final_List;

   -------------------
   -- Finalize_List --
   -------------------

   procedure Finalize_List (L : Finalizable_Ptr) is
      P     : Finalizable_Ptr := L;
      Q     : Finalizable_Ptr;
      Error : Boolean := False;

   begin
      --  ??? pragma Abort_Defer;
      while P /= null loop
         Q := Finalizable (P.all).Next;
         begin
            Finalize (Root'Class (P.all));
         exception
            when others => Error := True;
         end;
         P := Q;
      end loop;

      if Error then
         raise Program_Error;
      end if;
   end Finalize_List;

   procedure Finalize_Global_List is
   begin
      Finalize_List (Global_Final_List);
   end Finalize_Global_List;

   ------------------
   -- Finalize_One --
   ------------------

   procedure Finalize_One (
     From   : in out Finalizable_Ptr;
     Obj    : in out  Finalizable) is

   begin
      --  ??? pragma Abort_Defer;
      if Obj.Previous = null then

         --  It must be the first of the list
         From := Obj.Next;
      else

         Finalizable (Obj.Previous.all).Next := Obj.Next;
      end if;

      if Obj.Next /= null then
         Finalizable (Obj.Next.all).Previous := Obj.Previous;
      end if;

      Finalize (Root'Class (Obj));

   exception
      when others => raise Program_Error;
   end Finalize_One;

end System.Finalization_Implementation;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.6
--  date: Tue Feb 22 19:29:07 1994;  author: comar
--  add comments. remove temporarly pragma Abort_Defer which doesn't seem to
--  work.
--  ----------------------------
--  revision 1.7
--  date: Wed Apr 27 19:33:05 1994;  author: comar
--  (Finalize_One): Ensure that final list pointers are always reset to null.
--  ----------------------------
--  revision 1.8
--  date: Fri Aug 19 20:27:32 1994;  author: comar
--  Add procedure Finalize_Global_List.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
