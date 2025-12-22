------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                S Y S T E M . C O M P I L E R _ O P T I O N S             --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.1 $                             --
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

package System.Compiler_Options is

   function Main_Priority return Priority;
   pragma Import (C, Main_Priority, "__main_priority");

end System.Compiler_Options;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Sun May 29 23:39:12 1994;  author: porter
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
