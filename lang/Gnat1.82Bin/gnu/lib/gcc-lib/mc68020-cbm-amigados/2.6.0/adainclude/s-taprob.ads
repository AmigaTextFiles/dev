------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--      S Y S T E M . T A S K I N G . P R O T E C T E D _ O B J E C T S     --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.8 $                             --
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

with System.Compiler_Exceptions;
--  Used for, Exception_ID

package System.Tasking.Protected_Objects is
   --  This interface is described in the document
   --  Gnu Ada Runtime Library Interface (GNARLI).

   procedure Initialize_Protection
     (Object           : Protection_Access;
      Ceiling_Priority : Integer);

   procedure Finalize_Protection
     (Object : Protection_Access);

   procedure Lock
     (Object : Protection_Access);

   procedure Lock_Read_Only
     (Object : Protection_Access);

   procedure Unlock
     (Object : Protection_Access);

   procedure Protected_Entry_Call
     (Object    : Protection_Access;
      E         : Protected_Entry_Index;
      Uninterpreted_Data : System.Address;
      Mode      : Call_Modes;
      Block     : out Communication_Block);

   procedure Wait_For_Completion
     (Call_Cancelled : out Boolean;
      Block          : in out Communication_Block);

   procedure Wait_Until_Abortable (Block : in out Communication_Block);

   procedure Cancel_Protected_Entry_Call
     (Call_Cancelled : out Boolean;
      Block          : in out Communication_Block);

   procedure Next_Entry_Call
     (Object    : Protection_Access;
      Barriers  : Barrier_Vector;
      Uninterpreted_Data : out System.Address;
      E         : out Protected_Entry_Index);

   procedure Complete_Entry_Body
     (Object           : Protection_Access;
      Pending_Serviced : out Boolean);

   procedure Exceptional_Complete_Entry_Body
     (Object           : Protection_Access;
      Pending_Serviced : out Boolean;
      Ex               : Compiler_Exceptions.Exception_ID);

   procedure Requeue_Protected_Entry
     (Object     : Protection_Access;
      New_Object : Protection_Access;
      E          : Protected_Entry_Index;
      With_Abort : Boolean);

   procedure Requeue_Task_To_Protected_Entry
     (New_Object : Protection_Access;
      E          : Protected_Entry_Index;
      With_Abort : Boolean);

   function Protected_Count
     (Object : Protection;
      E      : Protected_Entry_Index)
      return   Natural;

   procedure Broadcast_Program_Error
     (Object : Protection_Access);

   procedure Raise_Pending_Exception
     (Block : Communication_Block);

end System.Tasking.Protected_Objects;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.6
--  date: Tue May 10 16:57:10 1994;  author: giering
--  Changed name of Parameter to Uninterpreted_Data (per GNARLI) for
--     Protected_Entry_Call and Next_Entry_Call.
--  ----------------------------
--  revision 1.7
--  date: Wed May 25 15:11:18 1994;  author: giering
--  Changed references to Exception_ID and related definitions, since they
--   have been moved to System.Compiler_Exceptions.
--  ----------------------------
--  revision 1.8
--  date: Tue May 31 13:38:23 1994;  author: giering
--  RTS Restructuring (Separating out non-compiler-interface definitions)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
