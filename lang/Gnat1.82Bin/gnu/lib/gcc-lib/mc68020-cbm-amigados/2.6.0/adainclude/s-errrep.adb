------------------------------------------------------------------------------
--                                                                          --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS                --
--                                                                          --
--               S Y S T E M . E R R O R _ R E P O R T I N G                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.4 $                              --
--                                                                          --
--          Copyright (c) 1991,1992,1993, FSU, All Rights Reserved          --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2, or (at  your  option)  any  --
--  later  version.   GNARL is distributed in the hope that it will be use- --
--  ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
--  MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
--  eral Library Public License for more details.  You should have received --
--  a  copy of the GNU Library General Public License along with GNARL; see --
--  file COPYING. If not, write to the Free Software Foundation,  675  Mass --
--  Ave, Cambridge, MA 02139, USA.                                          --
--                                                                          --
------------------------------------------------------------------------------

with System.Task_Primitives;
--  Used for, LL_Assert

package body System.Error_Reporting is

   Assertions_Checked : constant Boolean := True;

   -------------
   --  Assert --
   -------------

   procedure Assert (B : Boolean; M : String) is
   begin
      if Assertions_Checked then
         Task_Primitives.LL_Assert (B, M);
      end if;
   end Assert;

   -----------------------------
   -- Unimplemented_Operation --
   -----------------------------

   procedure Unimplemented_Operation is
      Unimplemented_Error : exception;

   begin
      raise Unimplemented_Error;
   end Unimplemented_Operation;

end System.Error_Reporting;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sat Mar 26 10:19:55 1994;  author: giering
--  Checked out and back in to strip extra revision history.
--  ----------------------------
--  revision 1.3
--  date: Thu Apr 21 14:42:08 1994;  author: dewar
--  (Assert): Move pragma Inline to spec where it does some good
--  Minor reformatting
--  ----------------------------
--  revision 1.4
--  date: Fri Jun  3 15:22:59 1994;  author: giering
--  Minor Reformatting
--  Checked in from FSU by doh.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
