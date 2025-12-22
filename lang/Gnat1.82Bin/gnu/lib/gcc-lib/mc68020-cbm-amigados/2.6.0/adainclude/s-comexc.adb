-----------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--            S Y S T E M . C O M P I L E R _ E X C E P T I O N S           --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.9 $                             --
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


with System.Error_Reporting;
--  Used for,  Error_Reporting.Unimplemented_Operation
--             Error_Reporting.Assert

with System.Task_Primitives;
--  Used for,  Task_Primitives.Machine_Exceptions;
--             Task_Primitives.Error_Information;

package body System.Compiler_Exceptions is

   procedure Unimplemented renames
      System.Error_Reporting.Unimplemented_Operation;

   ---------------------
   -- Raise_Exception --
   ---------------------

   --  This is a stopgap implementation which can only raise predefined
   --  exceptions.

   procedure Raise_Exception (E : Exception_ID) is
   begin
      case E is
      when Null_Exception =>
         null;
      when Constraint_Error_ID =>
         raise Constraint_Error;
      when Numeric_Error_ID =>
         raise Numeric_Error;
      when Program_Error_ID =>
         raise Program_Error;
      when Storage_Error_ID =>
         raise Storage_Error;
      when Tasking_Error_ID =>
         raise Tasking_Error;
      when others =>
         Unimplemented;
      end case;
   end Raise_Exception;

   ----------------------
   -- Notify_Exception --
   ----------------------


   procedure Notify_Exception
     (Which              : Task_Primitives.Machine_Exceptions;
      Info               :  Task_Primitives.Error_Information;
      Modified_Registers : Pre_Call_State)
   is
   begin
      Unimplemented;
   end Notify_Exception;

   -----------------------
   -- Current_Exception --
   -----------------------

   function Current_Exception return Exception_ID is
   begin
      Unimplemented;
      return Null_Exception;
   end Current_Exception;

   -----------
   -- Image --
   -----------

   function Image
     (E    : Exception_ID)
      return Exception_ID_String
   is
   begin
      Unimplemented;
      return "Not Implemented*";
   end Image;

end System.Compiler_Exceptions;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.7
--  date: Wed May  4 16:37:07 1994;  author: giering
--  Removed with of POSIX_RTE (no longer used).
--  ----------------------------
--  revision 1.8
--  date: Tue May 17 15:22:21 1994;  author: giering
--  Provided a stopgap implementation of Raise_Exception that can raise
--   predefined exceptions.
--  ----------------------------
--  revision 1.9
--  date: Wed May 25 15:08:39 1994;  author: giering
--  Removed with of Tasking (no longer used).
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
