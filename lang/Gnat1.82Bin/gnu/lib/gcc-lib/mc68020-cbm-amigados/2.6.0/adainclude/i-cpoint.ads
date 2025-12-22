------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                I N T E R F A C E S . C . P O I N T E R S                 --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.3 $                              --
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

generic
   type Index is (<>);
   type Element is private;
   type Element_Array is array (Index range <>) of aliased Element;
   Default_Terminator : Element;

package Interfaces.C.Pointers is
pragma Preelaborate (Pointers);

   type Pointer is access all Element;

   function Value
     (Ref        : in Pointer;
      Terminator : in Element := Default_Terminator)
      return       Element_Array;

   function Value
     (Ref    : in Pointer;
      Length : in ptrdiff_t)
      return   Element_Array;

   Pointer_Error : exception;

   --  C-style Pointer arithmetic

   function "+" (Left : in Pointer;   Right : in ptrdiff_t) return Pointer;
   function "+" (Left : in ptrdiff_t; Right : in Pointer)   return Pointer;
   function "-" (Left : in Pointer;   Right : in ptrdiff_t) return Pointer;
   function "-" (Left : in Pointer;   Right : in Pointer)   return ptrdiff_t;

   procedure Increment (Ref : in out Pointer);
   procedure Decrement (Ref : in out Pointer);

   function Virtual_Length
     (Ref        : in Pointer;
      Terminator : in Element := Default_Terminator)
      return       ptrdiff_t;

   procedure Copy_Terminated_Array
     (Source     : in Pointer;
      Target     : in Pointer;
      Limit      : in ptrdiff_t := ptrdiff_t'Last;
      Terminator : in Element := Default_Terminator);

   procedure Copy_Array
     (Source  : in Pointer;
      Target  : in Pointer;
      Length  : in ptrdiff_t);

private
   pragma Convention (Intrinsic, "+");
   pragma Convention (Intrinsic, "-");

   pragma Inline ("+");
   pragma Inline ("-");
   pragma Inline (Decrement);
   pragma Inline (Increment);

end Interfaces.C.Pointers;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 23:53:30 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 09:35:25 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Fri Aug 12 12:08:03 1994;  author: dewar
--  Add pragma Preelaborate
--  Changes for RM 5.0 (includes changing Natural to ptrdiff_t throughout)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
