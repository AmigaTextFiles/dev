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
class COMPILE_TO_C -- The command.

inherit COMPILE_TO;
   
creation make
   
feature 
   
   make is
      do
	 start_proc := us_make;
	 eiffel_parser.set_drop_comments;
	 if argument_count < 1 then
	    std_error.put_string("Bad use of command `compile_to_c'.%N");
	    print_help("compile_to_c");
	    die_with_code(exit_failure_code);
	 else
	    automat;
	 end;
      end;
   
feature {NONE}
   
   automat is
      local
	 arg: INTEGER;
	 a: STRING;
	 -- state 0  : nothing done.
	 -- state 1  : "-o" read.
	 -- state 2  : Root class name read.
	 -- state 3  : "-cc" read.
	 -- state 4  : "-cecil" read.
	 -- state 8  : end.
	 -- state 9  : error.
      do
	 from  
	    arg := 1;
	 until
	    arg > argument_count or else state > 7
	 loop
	    a := argument(arg);
	    inspect 
	       state
	    when 0 then
	       if a.item(1) /= '-' then
		  if a.has_suffix(o_suffix) then
		     cpp.add_c_object(a);
		  elseif a.has_suffix(c_suffix) then
		     cpp.add_c_object(a);
		  elseif root_class = Void then
		     root_class := a;
		     run_control.set_root_class(a);
		     state := 2;
		  else
		     cpp.add_c_compiler_option(a);
		  end;
	       elseif ("-boost").is_equal(a) then
		  if level /= Void then
		     error_level(a);
		  else
		     run_control.set_boost;
		     level := a;
		  end;
	       elseif ("-no_check").is_equal(a) then
		  if level /= Void then
		     error_level(a);
		  else
		     run_control.set_no_check;
		     level := a;
		  end;
	       elseif ("-require_check").is_equal(a) then
		  if level /= Void then
		     error_level(a);
		  else
		     run_control.set_require_check;
		     level := a;
		  end;
	       elseif ("-ensure_check").is_equal(a) then
		  if level /= Void then
		     error_level(a);
		  else
		     run_control.set_ensure_check;
		     level := a;
		  end;
	       elseif ("-invariant_check").is_equal(a) then
		  if level /= Void then
		     error_level(a);
		  else
		     run_control.set_invariant_check;
		     level := a;
		  end;
	       elseif ("-loop_check").is_equal(a) then
		  if level /= Void then
		     error_level(a);
		  else
		     run_control.set_loop_check;
		     level := a;
		  end;
	       elseif ("-all_check").is_equal(a) then
		  if level /= Void then
		     error_level(a);
		  else
		     run_control.set_all_check;
		     level := a;
		  end;
	       elseif ("-debug_check").is_equal(a) then
		  if level /= Void then
		     error_level(a);
		  else
		     run_control.set_debug_check;
		     level := a;
		  end;
	       elseif ("-case_insensitive").is_equal(a) then
		  eiffel_parser.set_case_insensitive;
	       elseif ("-no_warning").is_equal(a) then
		  eh.set_no_warning;
	       elseif ("-verbose").is_equal(a) then
		  echo.set_verbose;
	       elseif ("-test_gc").is_equal(a) then
		  gc_handler.enable;
	       elseif ("-gc_info").is_equal(a) then
		  gc_handler.set_info_flag;
	       elseif ("-no_strip").is_equal(a) then
		  cpp.set_no_strip;
	       elseif ("-no_split").is_equal(a) then
		  cpp.set_no_split;
	       elseif ("-trace").is_equal(a) then
		  run_control.set_trace;
	       elseif ("-cc").is_equal(a) then
		  state := 3;
	       elseif ("-cecil").is_equal(a) then
		  state := 4;
	       elseif a.has_prefix("-l") then
		  cpp.add_c_library(a);
	       elseif ("-o").is_equal(a) then
		  state := 1;
	       elseif a.item(1) = '-' and then a.item(2) = 'o' then
		  a.remove_first(2);
		  cpp.set_output_name(a);
		  cpp.set_oflag("-o");
	       else
		  cpp.add_c_compiler_option(a);
	       end;
	    when 1 then
	       cpp.set_output_name(a);
	       state := 0;
	    when 2 then
	       if a.item(1) = '-' or else
		  a.has_suffix(c_suffix) or else
		  a.has_suffix(o_suffix) then
		  arg := arg - 1;
	       else
		  start_proc := a;
	       end;
	       state := 0;
	    when 3 then
	       cpp.c_compiler.clear;
	       cpp.c_compiler.append(a);
	       state := 0;
	    when 4 then
	       run_control.set_cecil_path(a);
	       state := 0;
	    end;
	    arg := arg + 1;
	 end;
	 if nb_errors = 0 then
	    if run_control.trace then 
	       if run_control.boost then
		  run_control.set_no_check
	       end;
	    end;
	    small_eiffel.compile_to_c(root_class,start_proc);
	 end;
      end;
   
   command_name: STRING is
      do
	 Result := us_compile_to_c;
      end;

end -- COMPILE_TO_C -- The command.

