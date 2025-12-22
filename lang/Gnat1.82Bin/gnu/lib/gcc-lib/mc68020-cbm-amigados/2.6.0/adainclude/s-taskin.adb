------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                        S Y S T E M . T A S K I N G                       --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.4 $                             --
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

--  This package body has to be eliminated once the offset calulation for
--  ATCB is done statically. Also, the temporary placement of queuing
--  primitives has to move back to Tasking.Queuing. (compiler error) ???

with System.Task_Primitives;
--  Used for,  Task_Primitives.TCB_Ptr,
--             Task_Primitives.Self

with System.Storage_Elements;
--  Used for,  Storage_Elements.Storage_Offset,
--             Storage_Elements."-"
--             Storage_Elements.Storage_Count

with System.Tasking.Utilities;
--  Used for,  Utilities.Ada_Task_Control_Block;

with Unchecked_Conversion;

package body System.Tasking is

   function "-"
     (A    : System.Address;
      B    : System.Address)
      return Storage_Elements.Storage_Offset
   renames Storage_Elements."-";

   function "-"
     (A    : System.Address;
      I    : Storage_Elements.Storage_Offset)
      return System.Address
   renames Storage_Elements."-";

   function Get_LL_TCB_Offset return Storage_Elements.Storage_Count;

   LL_TCB_Offset : Storage_Elements.Storage_Count := Get_LL_TCB_Offset;

   function Address_To_Task_ID is new
     Unchecked_Conversion (System.Address, Task_ID);

   function TCB_Ptr_To_Address is new
     Unchecked_Conversion (Task_Primitives.TCB_Ptr, System.Address);

   -----------------------
   -- Get_LL_TCB_Offset --
   -----------------------

   function Get_LL_TCB_Offset return Storage_Elements.Storage_Count is
      ATCB_Record : Utilities.Ada_Task_Control_Block (0);

   begin
      return ATCB_Record.LL_TCB'Address - ATCB_Record'Address;
   end Get_LL_TCB_Offset;

   ----------
   -- Self --
   ----------

   --  This is an INLINE_ONLY version of Self for use in the RTS.

   function Self return Task_ID is
      S : Task_Primitives.TCB_Ptr := Task_Primitives.Self;

   begin
      return Address_To_Task_ID (TCB_Ptr_To_Address (S) - LL_TCB_Offset);
   end Self;

end System.Tasking;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Thu Apr 21 14:44:59 1994;  author: dewar
--  Minor reformatting
--  Remove junk extra revision history
--  ----------------------------
--  revision 1.3
--  date: Tue May 31 13:40:16 1994;  author: giering
--  RTS Restructuring (Separating out non-compiler-interface definitions)
--  ----------------------------
--  revision 1.4
--  date: Wed Jul 13 10:25:16 1994;  author: giering
--  Dynamic priority support added.
--  Checked in from FSU by mueller.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
