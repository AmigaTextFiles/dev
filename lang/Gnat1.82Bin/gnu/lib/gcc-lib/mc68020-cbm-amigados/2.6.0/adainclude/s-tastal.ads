------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--        S Y S T E M . T A S K _ S T O R A G E _ A L L O C A T I O N       --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.6 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2, or  (at  your  option)  any --
--  later  version.   GNARL is distributed in the hope that it will be use- --
--  ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
--  MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
--  eral Library Public License for more details.  You should have received --
--  a  copy of the GNU Library General Public License along with GNARL; see --
--  file COPYING. If not, write to the Free Software Foundation,  675  Mass --
--  Ave, Cambridge, MA 02139, USA.                                          --
--                                                                          --
------------------------------------------------------------------------------

with System.Storage_Elements;
--  Used for, Storage_Count

package System.Task_Storage_Allocation is
   --  This interface is described in the document
   --  Gnu Ada Runtime Library Interface (GNARLI).

   procedure Allocate_Block
     (Storage_Address : out System.Address;
      Storage_Size    : Storage_Elements.Storage_Count;
      Alignment       : in Storage_Elements.Storage_Count);

   procedure Deallocate_Block
     (Storage_Address : System.Address);

   function Maximum_Storage
     return Storage_Elements.Storage_Count;

end System.Task_Storage_Allocation;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Thu Apr 28 12:28:53 1994;  author: giering
--  GNARLI document pointer
--  ----------------------------
--  revision 1.5
--  date: Fri Apr 29 09:07:49 1994;  author: giering
--  header comment reformated
--  ----------------------------
--  revision 1.6
--  date: Fri Jun  3 15:25:11 1994;  author: giering
--  Minor Reformatting
--  Checked in from FSU by doh.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
