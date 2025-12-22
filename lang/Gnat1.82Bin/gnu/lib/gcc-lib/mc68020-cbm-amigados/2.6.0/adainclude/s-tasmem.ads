------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                    S Y S T E M . T A S K _ M E M O R Y                   --
--                                                                          --
--                                  S p e c                                 --
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

with System.Storage_Elements;
--  Used for, Storage_Count

package System.Task_Memory is

   procedure Low_Level_Free (A : System.Address);
   --  Free a previously allocated block, guaranteed to be tasking safe

   function Low_Level_New
     (Size : Storage_Elements.Storage_Count)
      return System.Address;
   --  Allocate a block, guaranteed to be tasking safe. The block always has
   --  the maximum possible required alignment for any possible data type.

   function Unsafe_Low_Level_New
     (Size : Storage_Elements.Storage_Count)
      return System.Address;
   --  Allocate a block, not guaranteed to be tasking safe. The block always
   --  has the maximum possible required alignment for any possible data type.

end System.Task_Memory;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sat Mar 26 10:21:26 1994;  author: giering
--  Checked out and back in to strip extra revision history.
--  ----------------------------
--  revision 1.3
--  date: Thu Apr 21 14:45:23 1994;  author: dewar
--  Minor reformatting
--  Document that the New calls assume maximum alignment
--  ----------------------------
--  revision 1.4
--  date: Fri Jun  3 15:24:01 1994;  author: giering
--  Minor Reformatting
--  Checked in from FSU by doh.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
