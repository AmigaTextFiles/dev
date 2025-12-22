------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--              I N T E R F A C E S . C . P O S I X _ E R R O R             --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.2 $                             --
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

--  This package contains those parts of the package POSIX defined in P1003.5
--  (Ada binding to POSIX.1) needed to interface to Pthreads.

with Interfaces.C.POSIX_Constants;
--  Used for, various constants

package Interfaces.C.POSIX_Error is

   type Return_Code is new int;

   Failure : constant Return_Code := -1;

   type Error_Code is new int;

   subtype EC is Error_Code;
   --  Synonym used only in this package

   function Get_Error_Code return Error_Code;
   pragma Import (C, Get_Error_Code, "get_errno");
   --  An interface to the error number of the current thread.  This is updated
   --  by Pthreads at each context switch.

   POSIX_Error : exception;

   --  Error number definitions.  These definitions are derived from
   --  /usr/include/errno.h and /usr/include/sys/errno.h. These are SunOS
   --  errors; they have not yet been checked fsor POSIX complience.

   --  Error number definitions.

   Operation_Not_Permitted            : constant EC := POSIX_Constants.EPERM;
   No_Such_File_Or_Directory          : constant EC := POSIX_Constants.ENOENT;
   No_Such_Process                    : constant EC := POSIX_Constants.ESRCH;
   Interrupted_Operation              : constant EC := POSIX_Constants.EINTR;
   Input_Output_Error                 : constant EC := POSIX_Constants.EIO;
   No_Such_Device_Or_Address          : constant EC := POSIX_Constants.ENXIO;
   Argument_List_Too_Long             : constant EC := POSIX_Constants.E2BIG;
   Exec_Format_Error                  : constant EC := POSIX_Constants.ENOEXEC;
   Bad_File_Descriptor                : constant EC := POSIX_Constants.EBADF;
   No_Child_Process                   : constant EC := POSIX_Constants.ECHILD;
   Resource_Temporarily_Unavailable   : constant EC := POSIX_Constants.EAGAIN;
   Not_Enough_Space                   : constant EC := POSIX_Constants.ENOMEM;
   Permission_Denied                  : constant EC := POSIX_Constants.EACCES;
   Resource_Busy                      : constant EC := POSIX_Constants.EFAULT;
   File_Exists                        : constant EC := POSIX_Constants.ENOTBLK;
   Improper_Link                      : constant EC := POSIX_Constants.EBUSY;
   No_Such_Operation_On_Device        : constant EC := POSIX_Constants.EEXIST;
   Not_A_Directory                    : constant EC := POSIX_Constants.EXDEV;
   Is_A_Directory                     : constant EC := POSIX_Constants.ENODEV;
   Invalid_Argument                   : constant EC := POSIX_Constants.ENOTDIR;
   Too_Many_Open_Files_In_System      : constant EC := POSIX_Constants.EISDIR;
   Too_Many_Open_Files                : constant EC := POSIX_Constants.EINVAL;
   Priority_Ceiling_Violation         : constant EC := POSIX_Constants.EINVAL;
   Inappropriate_IO_Control_Operation : constant EC := POSIX_Constants.ENFILE;
   File_Too_Large                     : constant EC := POSIX_Constants.EMFILE;
   No_Space_Left_On_Device            : constant EC := POSIX_Constants.ENOTTY;
   Invalid_Seek                       : constant EC := POSIX_Constants.ETXTBSY;
   Read_Only_File_System              : constant EC := POSIX_Constants.EFBIG;
   Too_Many_Links                     : constant EC := POSIX_Constants.ENOSPC;
   Broken_Pipe                        : constant EC := POSIX_Constants.ESPIPE;
   Operation_Not_Implemented          : constant EC := POSIX_Constants.ENOSYS;
   Operation_Not_Supported            : constant EC := POSIX_Constants.ENOTSUP;

end Interfaces.C.POSIX_Error;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Aug 18 17:26:01 1994;  author: giering
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Thu Aug 18 20:09:36 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
