------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                I N T E R F A C E S . C . P O I N T E R S                 --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.1 $                              --
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

with Interfaces.C.Strings; use Interfaces.C.Strings;
with System;               use System;

with Unchecked_Conversion;

package body Interfaces.C.Pointers is

   type Addr is mod Memory_Size;

   function To_Pointer is new Unchecked_Conversion (Addr,      Pointer);
   function To_Addr    is new Unchecked_Conversion (Pointer,   Addr);
   function To_Addr    is new Unchecked_Conversion (ptrdiff_t, Addr);
   function To_Ptrdiff is new Unchecked_Conversion (Addr,      ptrdiff_t);

   Elmt_Size : ptrdiff_t :=
                 ((Element_Array'Component_Size + Storage_Unit - 1) /
                    Storage_Unit);

   ---------
   -- "+" --
   ---------

   function "+" (Left : in Pointer;   Right : in ptrdiff_t) return Pointer is
   begin
      return To_Pointer (To_Addr (Left) + To_Addr (Right));
   end "+";

   function "+" (Left : in ptrdiff_t; Right : in Pointer) return Pointer is
   begin
      return To_Pointer (To_Addr (Left) + To_Addr (Right));
   end "+";

   ---------
   -- "-" --
   ---------

   function "-" (Left : in Pointer; Right : in ptrdiff_t) return Pointer is
   begin
      return To_Pointer (To_Addr (Left) - To_Addr (Right));
   end "-";


   function "-" (Left : in Pointer; Right : in Pointer) return ptrdiff_t is
   begin
      return To_Ptrdiff (To_Addr (Left) - To_Addr (Right));
   end "-";

   ----------------
   -- Copy_Array --
   ----------------

   procedure Copy_Array
     (Source  : in Pointer;
      Target  : in Pointer;
      Length  : in ptrdiff_t)
   is
      S : Pointer := Target;
      T : Pointer := Source;

   begin
      if S = null or else T = null then
         raise Dereference_Error;

      else
         for J in 1 .. Length loop
            T.all := S.all;
            Increment (T);
            Increment (S);
         end loop;
      end if;
   end Copy_Array;

   ---------------------------
   -- Copy_Terminated_Array --
   ---------------------------

   procedure Copy_Terminated_Array
     (Source     : in Pointer;
      Target     : in Pointer;
      Limit      : in ptrdiff_t := ptrdiff_t'Last;
      Terminator : in Element := Default_Terminator)
   is
      S : Pointer   := Source;
      T : Pointer   := Target;
      L : ptrdiff_t := Limit;

   begin
      if S = null or else T = null then
         raise Dereference_Error;

      else
         while S.all /= Terminator and then L > 0 loop
            T.all := S.all;
            Increment (T);
            Increment (S);
            L := L - 1;
         end loop;
      end if;
   end Copy_Terminated_Array;

   ---------------
   -- Decrement --
   ---------------

   procedure Decrement (Ref : in out Pointer) is
   begin
      Ref := Ref - Elmt_Size;
   end Decrement;

   ---------------
   -- Increment --
   ---------------

   procedure Increment (Ref : in out Pointer) is
   begin
      Ref := Ref + Elmt_Size;
   end Increment;

   -----------
   -- Value --
   -----------

   function Value
     (Ref        : in Pointer;
      Terminator : in Element := Default_Terminator)
      return       Element_Array
   is
      P : Pointer;
      L : constant Index'Base := Index'First;
      H : Index'Base;

   begin
      if Ref = null then
         raise Dereference_Error;

      else
         if Ref.all = Terminator then
            H := Index'Base'Pred (Index'First);

         else
            H := L;
            P := Ref;

            loop
               Increment (P);
               exit when P.all = Terminator;
               H := Index'Base'Succ (H);
            end loop;
         end if;

         declare
            subtype A is Element_Array (L .. H);

            type PA is access A;
            function To_PA is new Unchecked_Conversion (Pointer, PA);

         begin
            return To_PA (Ref).all;
         end;
      end if;
   end Value;

   function Value
     (Ref    : in Pointer;
      Length : in ptrdiff_t)
      return   Element_Array
   is
      P : Pointer;
      L : Index'Base;
      H : Index'Base;

   begin
      if Ref = null then
         raise Dereference_Error;

      else
         L := Index'First;
         H := Index'Val (Index'Pos (Index'First) - 1 + Length);

         declare
            subtype A is Element_Array (L .. H);

            type PA is access A;
            function To_PA is new Unchecked_Conversion (Pointer, PA);

         begin
            return To_PA (Ref).all;
         end;
      end if;
   end Value;

   --------------------
   -- Virtual_Length --
   --------------------

   function Virtual_Length
     (Ref        : in Pointer;
      Terminator : in Element := Default_Terminator)
      return       ptrdiff_t
   is
      P : Pointer;
      C : ptrdiff_t;

   begin
      if Ref = null then
         raise Dereference_Error;

      else
         C := 0;
         P := Ref;

         while P.all /= Terminator loop
            C := C + 1;
            Increment (P);
         end loop;

         return C;
      end if;
   end Virtual_Length;

end Interfaces.C.Pointers;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Aug 12 12:04:09 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
