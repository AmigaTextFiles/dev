------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--               S Y S T E M . T A S K I N G . A B O R T I O N              --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.8 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
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
--  Used for,  Task_Primitives.Pre_Call_State

with System.Tasking.Utilities;
--  Used for,  Utilities.ATCB_Ptr

package System.Tasking.Abortion is

   procedure Abort_Tasks (Tasks : Task_List);
   --  Abort_Tasks is called to initiate abortion, however, the actual
   --  abortion is done by abortee by means of Abort_Handler

   procedure Change_Base_Priority (T : Utilities.ATCB_Ptr);
   --  Change the base priority of T.
   --  Has to be called with T.Lock write locked.

   procedure Defer_Abortion;
--    pragma Inline (Defer_Abortion); --  To allow breakpoints to be set. ???

   procedure Undefer_Abortion;
--    pragma Inline (Undefer_Abortion); --  To allow breakpoints to be set.

end System.Tasking.Abortion;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.6
--  date: Wed May 25 15:13:22 1994;  author: giering
--  Clarified comments on commented out inlines.
--  ----------------------------
--  revision 1.7
--  date: Tue May 31 13:39:17 1994;  author: giering
--  RTS Restructuring (Separating out non-compiler-interface definitions)
--  ----------------------------
--  revision 1.8
--  date: Wed Jul 13 10:24:40 1994;  author: giering
--  Dynamic priority support added.
--  Checked in from FSU by mueller.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
