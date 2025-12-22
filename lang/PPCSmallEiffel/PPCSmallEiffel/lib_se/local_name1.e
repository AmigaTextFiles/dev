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
class LOCAL_NAME1
   --
   -- A local name in some declaration list.
   --

inherit LOCAL_NAME;

creation {TMP_NAME} make

creation {LOCAL_NAME1} make_runnable

feature {NONE}

   is_used: BOOLEAN;
	 -- Is the local name really used inside the living
	 -- code ?

feature

   to_runnable(ct: TYPE): like Current is
      local
	 t1, t2: TYPE;
      do
	 t1 := result_type;
	 t2 := t1.to_runnable(ct);
	 if t2 = Void then
	    eh.add_position(t1.start_position);
	    error(start_position,em_bl);
	 end;
	 if current_type = Void then
	    current_type := ct;
	    result_type := t2;
	    Result := Current;
	 else
	    !!Result.make_runnable(Current,ct,t2);
	 end;
      end;

   produce_c: BOOLEAN is
	 -- True if C code must be produced (local is really
	 -- used or it is a user expanded with possibles
	 -- side effects).
      local
	 t: TYPE;
      do
	 if is_used then
	    Result := true;
	 else
	    t := result_type.run_type;
	    if t.is_expanded then
	       Result := not t.is_basic_eiffel_expanded;
	    end;
	 end;
      end;

   c_declare is
	 -- C declaration of the local.
      local
	 t: TYPE;
      do
	 if produce_c then
	    t := result_type.run_type;
	    tmp_string.clear;
	    t.c_type_for_result_in(tmp_string);
	    tmp_string.extend(' ');
	    cpp.put_string(tmp_string);
	    cpp.print_local(to_string);
	    cpp.put_character('=');
	    t.c_initialize;
	    cpp.put_string(fz_00);
	 elseif run_control.debug_check then
	    warning(start_position,"Unused local variable.");
	 end;
      end;

   c_trace is
      -- Add C code for stack trace.
      do
	 if produce_c then
	    cpp.rs_push_local(to_string,result_type.run_type);
	 end;
      end;

feature {LOCAL_NAME2}

   set_is_used is
      do
	 is_used := true;
      end;

end -- LOCAL_NAME1

