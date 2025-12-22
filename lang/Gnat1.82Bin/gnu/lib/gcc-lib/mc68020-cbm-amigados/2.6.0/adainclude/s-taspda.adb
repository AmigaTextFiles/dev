-----------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--            S Y S T E M . T A S K _ S P E C I F I C _ D A T A             --
--                                                                          --
--                                 B o d y                                  --
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

with System.Secondary_Stack;
with Unchecked_Conversion;
with Unchecked_Deallocation;

with System.Tasking_Soft_Links; use System.Tasking_Soft_Links;

pragma Elaborate (System.Secondary_Stack);
--  This pragma elaborate is required to ensure that the body of package
--  System.Secondary_Stack has been elaborated, so that procedure SS_Init
--  can be called from the elaboration routine of our package body. Note
--  that replacing this by Elaborate_All does not work, since we have
--  carefully arranged that SS_Init does not call us indirectly, but
--  other subprograms in Secondary_Stack do call routines in this package,
--  so an elaboration circularity would result.

package body System.Task_Specific_Data is

   type TSD is record
      Jmpbuf_Address : Address := Null_Address;
      GNAT_Exception : Address := Null_Address;
      Sec_Stack_Addr : Address := Null_Address;
   end record;

   --  ??? changed the next access type into a general access type to avoid a
   --  lurking visibility problem.

   type TSD_Ptr is access all TSD;

   function From_Address is new
     Unchecked_Conversion (Address, TSD_Ptr);

   function To_Address is new
     Unchecked_Conversion (TSD_Ptr, Address);

   ------------------------
   -- Get_Jmpbuf_Address --
   ------------------------

   function Get_Jmpbuf_Address return  Address is
   begin
      return From_Address (Get_TSD_Address (True)).Jmpbuf_Address;
   end Get_Jmpbuf_Address;

   ------------------------
   -- Set_Jmpbuf_Address --
   ------------------------

   procedure Set_Jmpbuf_Address (Addr : Address) is
   begin
      From_Address (Get_TSD_Address (True)).Jmpbuf_Address := Addr;
   end Set_Jmpbuf_Address;

   ------------------------
   -- Get_GNAT_Exception --
   ------------------------

   function Get_GNAT_Exception return  Address is
   begin
      return From_Address (Get_TSD_Address (True)).GNAT_Exception;
   end Get_GNAT_Exception;

   ------------------------
   -- Set_GNAT_Exception --
   ------------------------

   procedure Set_GNAT_Exception (Addr : Address) is
   begin
      From_Address (Get_TSD_Address (True)).GNAT_Exception := Addr;
   end Set_GNAT_Exception;

   ------------------------
   -- Get_Sec_Stack_Addr --
   ------------------------

   function Get_Sec_Stack_Addr return  Address is
   begin
      return From_Address (Get_TSD_Address (True)).Sec_Stack_Addr;
   end Get_Sec_Stack_Addr;

   ------------------------
   -- Set_Sec_Stack_Addr --
   ------------------------

   procedure Set_Sec_Stack_Addr (Addr : Address) is
   begin
      From_Address (Get_TSD_Address (True)).Sec_Stack_Addr := Addr;
   end Set_Sec_Stack_Addr;

   ----------------
   -- Create_TSD --
   ----------------

   function Create_TSD return Address is
      New_TSD : constant TSD_Ptr := new TSD;

   begin
      System.Secondary_Stack.SS_Init (New_TSD.Sec_Stack_Addr, 10*1024);
      --  Allocate 10K secondary stack

      return To_Address (New_TSD);
   end Create_TSD;

   -----------------
   -- Destroy_TSD --
   -----------------

   procedure Destroy_TSD (TSD_Addr : Address) is
      Old_TSD : TSD_Ptr := From_Address (TSD_Addr);

      procedure Free is new
        Unchecked_Deallocation (TSD, TSD_Ptr);

   begin
      System.Secondary_Stack.SS_Free (Old_TSD.Sec_Stack_Addr);
      Free (Old_TSD);
   end Destroy_TSD;

begin
   --  Intialize the TSD for the non-tasking case

   Non_Tasking_TSD := Create_TSD;

end System.Task_Specific_Data;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Thu Apr 28 19:52:24 1994;  author: comar
--  (Destroy_TSD): call SS_Free
--  ----------------------------
--  revision 1.3
--  date: Fri Apr 29 11:25:14 1994;  author: dewar
--  Add documentation for pragma Elaborate (which was added in rev 1.2)
--  ----------------------------
--  revision 1.4
--  date: Sun Jun 26 14:56:21 1994;  author: comar
--  Change TSD_Ptr into an general access type to avoid momentarly a lurking
--   bug in the visibility mechanism
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
