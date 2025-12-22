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
class COMPILE -- The command.

inherit GLOBALS;
   
creation make
   
feature {NONE}

   root: STRING;
	 -- The root to compile.
   
   c_code: BOOLEAN;
	 -- True if C code must be saved.
   
   make_file: STD_FILE_READ is
      once 
	 !!Result.make;
      end;

   tmp_string: STRING is
      once
	 !!Result.make(256);
      end;
   
feature 
   
   make is
      local
	 time_out: INTEGER;
	 str: STRING;
      do
	 if argument_count < 1 then
	    echo.w_put_string("Bad use of command `compile'.%N");
	    more_help(fz_compile);
	    die_with_code(exit_failure_code);
	 end;
	 if windows_system = system_name then
	    tmp_string.clear;
         else
	    tmp_string.copy(small_eiffel_directory);
	    add_directory(tmp_string,fz_bin);
         end;
	 tmp_string.append(us_compile_to_c);
	 tmp_string.append(x_suffix);
	 automat;
	 if root = Void then
	    echo.w_put_string("Error : No <Root-Class> in command line.%N");
	    die_with_code(exit_failure_code);
	 end;
	 str := root.twin;
	 if dos_system = system_name then
	    from
	    until
	       str.count <= 4
	    loop
	       str.remove_last(1);
	    end;
	 end;
	 str.append(make_suffix);
         echo.file_removing(str);
	 echo.call_system(tmp_string);
         from
            time_out := 2000;
         until
            time_out = 0 or else make_file.is_connected
         loop
            make_file.connect_to(str);
            time_out := time_out - 1;
         end;
	 if not make_file.is_connected then
	    echo.w_put_string(fz_01);
	    echo.w_put_string(str);
	    echo.w_put_string("%" not found. %
				%Error(s) during `compile_to_c'.%N");
	    die_with_code(exit_failure_code);
	 end;
	 echo.put_string("C compiling using %"");
	 echo.put_string(str);
	 echo.put_string("%" command file.%N");
	 from  
	    make_file.read_line;
	 until
	    make_file.last_string.count = 0 
	 loop
	    tmp_string.copy(make_file.last_string);
	    echo.call_system(tmp_string);
	    make_file.read_line;
	 end;
	 make_file.disconnect;
	 if c_code then
	    echo.put_string("C code not removed (-c_code).%N");
	 else
	    if windows_system = system_name then
	       tmp_string.clear;
            else
	       tmp_string.copy(small_eiffel_directory);
	       add_directory(tmp_string,fz_bin);
            end;
	    tmp_string.append(fz_clean);
	    tmp_string.append(x_suffix);
	    tmp_string.extend(' ');
            if echo.verbose then
	       tmp_string.append("-verbose ");
	    end;
	    tmp_string.append(root);
	    echo.call_system(tmp_string);
	 end;
	 echo.put_string(fz_02);
      end;
   
feature {NONE}
   
   automat is
      local
	 state, arg: INTEGER;
	 a: STRING;
	 -- state 0  : nothing done.
	 -- state 1  : "-o"/"-cc"/"-cecil" read.
	 -- state 2  : Root class name read.
      do
	 from  
	    arg := 1;
	 until
	    arg > argument_count
	 loop
	    a := argument(arg);
	    if ("-verbose").is_equal(a) then
	       echo.set_verbose;
	    end;
	    if ("-c_code").is_equal(a) then
	       c_code := true;
	    else
	       tmp_string.extend(' ');
	       tmp_string.append(a);
	       inspect 
		  state
	       when 0 then
		  if a.item(1) /= '-' then
		     if a.has_suffix(o_suffix) then
		     elseif a.has_suffix(c_suffix) then
		     elseif a.item(1) = '+' then
		     elseif root = Void then
			root := to_bcn(a);
			root.to_lower;
			state := 2;
		     else
		     end;
		  elseif ("-o").is_equal(a) then
		     state := 1;
		  elseif a.item(1) = '-' and then a.item(2) = 'o' then
		  elseif ("-cc").is_equal(a) then
		     state := 1;
		  elseif ("-cecil").is_equal(a) then
		     state := 1;
		  else
		  end;
	       when 1 then
		  state := 0;
	       when 2 then
		  state := 0;
	       end;
	    end;
	    arg := arg + 1;
	 end;
      end;
   
feature {NONE}

   tmp_file_write: STD_FILE_WRITE is
      once
	 !!Result.make;
      end;

end -- COMPILE -- The command.

