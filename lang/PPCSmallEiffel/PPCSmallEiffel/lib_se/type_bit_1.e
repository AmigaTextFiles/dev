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
class TYPE_BIT_1
--
-- For declarations of the form :
--        foo : BIT 32;
--

inherit TYPE_BIT;
   
creation make
   
feature 
   
   n: INTEGER_CONSTANT;
   
feature  
   
   make(sp: like start_position; vn: like n) is
      require
	 sp /= Void;
	 vn.value > 0
      do
	 start_position := sp;
	 n := vn;
	 set_run_time_mark;
	 written_mark := run_time_mark;
      ensure
	 start_position = sp;
	 n = vn
      end;
   
   is_run_type: BOOLEAN is true;
   
   nb: INTEGER is
      do
	 Result := n.value;
      end;
   
   to_runnable(rt: TYPE): like Current is
      do
	 Result := Current;
	 to_runnable_1_2;
      end;
   
feature {TYPE}

   short_hook is
      do
	 short_print.a_class_name(base_class_name);
	 short_print.hook_or("tm_blank"," ");
	 short_print.a_integer(n.value);
      end;
   
invariant
   
   n /= Void

end -- TYPE_BIT_1

