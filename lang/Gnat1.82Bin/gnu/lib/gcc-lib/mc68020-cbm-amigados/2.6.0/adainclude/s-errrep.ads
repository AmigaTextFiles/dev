------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--               S Y S T E M . E R R O R _ R E P O R T I N G                --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.4 $                             --
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

package System.Error_Reporting is

   procedure Assert (B : Boolean; M : String);
   pragma Inline (Assert);
   --  This procedure is called for sanity checks.
   --  If the Boolean is False, the String error message is printed.

   procedure Unimplemented_Operation;
   --  This procedure is called for unimplemented operations.

end System.Error_Reporting;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sat Mar 26 10:19:59 1994;  author: giering
--  Checked out and back in to strip extra revision history.
--  ----------------------------
--  revision 1.3
--  date: Thu Apr 21 14:42:16 1994;  author: dewar
--  Move pragma Inline for Assert here (from body, where it did no good!)
--  Minor reformatting
--  ----------------------------
--  revision 1.4
--  date: Thu Apr 28 12:37:51 1994;  author: giering
--  interface commented
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
