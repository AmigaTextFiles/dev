--          This file is part of SmallEiffel The GNU Eiffel Compiler.
--          Copyright (C) 1994-98 LORIA - UHP - CRIN - INRIA - FRANCE
--            Dominique COLNET and Suzanne COLLIN - colnet@loria.fr 
--                       http://www.loria.fr/SmallEiffel
-- SmallEiffel is  free  software;  you can  redistribute it and/or modify it 
-- under the terms of the GNU General Public License as published by the Free
-- Software  Foundation;  either  version  2, or (at your option)  any  later 
-- version. SmallEiffel is distributed in the hope that it will be useful,but
-- WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-- or  FITNESS FOR A PARTICULAR PURPOSE.   See the GNU General Public License 
-- for  more  details.  You  should  have  received a copy of the GNU General 
-- Public  License  along  with  SmallEiffel;  see the file COPYING.  If not,
-- write to the  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
-- Boston, MA 02111-1307, USA.
--
deferred class COMPILE_TO
   -- Common root of COMPILE_TO_C and COMPILE_TO_JVM.

inherit GLOBALS;

feature {NONE}

   state: INTEGER;
   
   level: STRING;
	 -- Not Void when a level of compilation is selected.

   root_class: STRING;
   
   start_proc: STRING;
   

   error_level(level2: STRING) is
      do
	 state := 9;
	 eh.append(command_name);
	 eh.append(": level is already set to ");
	 eh.append(level);
	 eh.append(". Bad flag ");
	 eh.append(level2);
	 eh.append(fz_dot);
	 eh.print_as_error;
      end;

   command_name: STRING is
      deferred
      ensure
	 Result /= Void
      end;

end -- COMPILE_TO

