------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                               S Y S T E M                                --
--                                                                          --
--                                 S p e c                                  --
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

--  Note: although the values in System are target dependent, the source of
--  the package System itself is target independent in GNAT. This is achieved
--  by using attributes for all values, including the special additional GNAT
--  Standard attributes that are provided for exactly this purpose.

package System is
pragma Pure (System);

   --  Note: In the 5.0 RM, the above pragma is Preelaborate, but Tucker in
   --  a private email message agreed that there should be implementation
   --  permission to make this Pure instead of Preelaborate.

   type Name is (GNAT);
   System_Name : constant Name := GNAT;

   --  System-Dependent Named Numbers

   Min_Int                : constant := Long_Long_Integer'First;
   Max_Int                : constant := Long_Long_Integer'Last;

   Max_Binary_Modulus     : constant := 2 ** Long_Long_Integer'Size;
   Max_Nonbinary_Modulus  : constant := Integer'Last;

   Max_Base_Digits        : constant := Long_Long_Float'Digits;
   Max_Digits             : constant := Long_Long_Float'Digits;

   Max_Mantissa           : constant := Long_Long_Integer'Size - 1;
   Fine_Delta             : constant := 2.0 ** (-Max_Mantissa);

   Tick                   : constant := Standard'Tick;

   --  Storage-related Declarations

   type Address is private;
   Null_Address : constant Address;

   Storage_Unit           : constant := Standard'Storage_Unit;
   Word_Size              : constant := Standard'Word_Size;
   Memory_Size            : constant := 2 ** Standard'Address_Size;

   --  Address comparison

   function "<"  (Left, Right : Address) return Boolean;
   function "<=" (Left, Right : Address) return Boolean;
   function ">"  (Left, Right : Address) return Boolean;
   function ">=" (Left, Right : Address) return Boolean;
   function "="  (Left, Right : Address) return Boolean;

   pragma Import (Intrinsic, "<");
   pragma Import (Intrinsic, "<=");
   pragma Import (Intrinsic, ">");
   pragma Import (Intrinsic, ">=");
   pragma Import (Intrinsic, "=");

   --  Other System-Dependent Declarations

   type Bit_Order is (High_Order_First, Low_Order_First);
   Default_Bit_Order : constant Bit_Order;

   --  Priority-related Declarations (RM D.1)

   subtype Any_Priority is Integer
     range 0 .. Standard'Max_Interrupt_Priority;

   subtype Priority is Any_Priority
     range 0 .. Standard'Max_Priority;

   subtype Interrupt_Priority is Any_Priority
     range Standard'Max_Priority + 1 .. Standard'Max_Interrupt_Priority;

   Default_Priority : constant Priority :=
     (Priority'First + Priority'Last) / 2;

private

   type Address is mod Memory_Size;
   Null_Address : constant Address := 0;

   Default_Bit_Order : constant Bit_Order := Low_Order_First;
   --  To be fixed when the attribute is implemented ???

end System;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.17
--  date: Thu May 19 12:04:29 1994;  author: dewar
--  Add ??? for 1.16 change
--  ----------------------------
--  revision 1.18
--  date: Mon Jun  6 12:04:49 1994;  author: dewar
--  Add pragma Pure
--  ----------------------------
--  revision 1.19
--  date: Fri Jun 24 17:13:05 1994;  author: dewar
--  Add Bit_Order type (but value of constant is not set properly yet)
--  Spec now exactly matches RM 5.0
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
