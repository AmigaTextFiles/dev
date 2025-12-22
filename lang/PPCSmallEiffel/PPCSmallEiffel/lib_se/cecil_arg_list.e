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
class CECIL_ARG_LIST
--
-- Pseudo effective argument list to handle cecil EFFECTIVE_ARG_LIST.
-- 
   
inherit 
   EFFECTIVE_ARG_LIST
      rename make as super_make
      end;
   
creation make, super_make

feature 

   make(rf: RUN_FEATURE) is
      require
	 rf.arg_count > 0
      local
	 i: INTEGER;
	 fal: FORMAL_ARG_LIST;
      do
	 from
	    fal := rf.arguments;
	    !!list.make(1,fal.count);
	    i := fal.count;
	 until
	    i = 0
	 loop
	    list.put(fal.name(i),i);
	    i := i - 1;
	 end;
	 current_type := rf.current_type;
      end;

end -- CECIL_ARG_LIST

