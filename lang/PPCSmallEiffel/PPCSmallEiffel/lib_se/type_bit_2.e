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
class TYPE_BIT_2
--
-- For declarations of the form :
--        foo : BIT Real_size;
--

inherit TYPE_BIT;
   
creation make
   
feature 
   
   n: SIMPLE_FEATURE_NAME;
   
   nb: INTEGER;
   
feature {ANY}
   
   make(sp: like start_position; name: like n) is
      require
	 sp /= Void;
	 name /= Void
      do
	 tmp_string.copy(fz_bit_foo);
	 tmp_string.append(name.to_string);
	 written_mark := unique_string.item(tmp_string);
	 start_position := sp;
	 n := name;
      end;
   
   is_run_type: BOOLEAN is
      do
	 Result := run_time_mark /= Void;
      end;
   
   to_runnable(ct: TYPE): like Current is
      local
	 rf: RUN_FEATURE;
	 rf1: RUN_FEATURE_1;
	 rf8: RUN_FEATURE_8;
	 ic: INTEGER_CONSTANT;
      do
	 if run_time_mark = Void then
	    rf := n.run_feature(ct);
	    if rf = Void then
	       eh.add_position(n.start_position);
	       fatal_error(fz_not_found);
	    else
	       rf1 ?= rf;
	       rf8 ?= rf;
	       if rf1 /= Void then
		  ic ?= rf1.base_feature.value(1);
		  if ic = Void then
		     eh.add_position(n.start_position);
		     eh.add_position(rf1.start_position);
		     fatal_error(fz_iinaiv);
		  end;
		  nb := ic.value;
		  if nb < 0 then
		     eh.add_position(n.start_position);
		     eh.add_position(rf1.start_position);
		     fatal_error("Must be a positive INTEGER.");
		  end;
	       elseif rf8 /= Void then
		  nb := rf8.integer_value(n.start_position);
	       else
		  eh.add_position(n.start_position);
		  eh.add_position(rf.start_position);
		  fatal_error(fz_iinaiv);
	       end;
	       set_run_time_mark;
	       Result := Current;
	       to_runnable_1_2;
	    end;
	 else
	    !!Result.make(start_position,n);
	    Result := Result.to_runnable(ct);
	 end;
      end;

feature {TYPE}

   short_hook is
      do
	 short_print.a_class_name(base_class_name);
	 short_print.hook_or("tm_blank"," ");
	 n.short;
      end;
   
invariant
   
   n /= Void

end -- TYPE_BIT_2

