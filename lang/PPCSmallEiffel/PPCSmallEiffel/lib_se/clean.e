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
class CLEAN -- The command.

inherit GLOBALS;
   
creation make
   
feature 
   
   make is
      local
	 arg: INTEGER;
	 str: STRING;
	 
      do
	 if argument_count < 1 then
	    std_error.put_string("Bad use of command `clean'.%N");
	    print_help("clean");
	    die_with_code(exit_failure_code);
	 end;
	 from  
	    arg := 1;
	 until
	    arg > argument_count
	 loop
	    str := argument(arg);
	    if ("-verbose").is_equal(str) then
	       echo.set_verbose;
	    else
	       if str.has_suffix(eiffel_suffix) then
		  str.remove_suffix(eiffel_suffix);
	       elseif str.has_suffix(make_suffix) then
		  str.remove_suffix(make_suffix);
	       end;
	       if dos_system = system_name then
		  from
		  until
		     str.count <= 4
		  loop
		     str.remove_last(1);
		  end;
	       end;
	       c_files_removing(str);
	       str.to_upper;
	       c_files_removing(str);
	       str.to_lower;
	       c_files_removing(str);
	    end;
	    arg := arg + 1;
	 end;
      end;


   
feature {NONE}

   tmp_string: STRING is
      once
	 !!Result.make(256);
      end;

   c_files_removing(root: STRING) is
      local
	 i: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    i = 0
	 loop
	    tmp_string.copy(root);
	    i.append_in(tmp_string);
	    tmp_string.append(c_suffix);
	    if file_exists(tmp_string) then
	       echo.file_removing(tmp_string);
	       tmp_string.extend('~');
               echo.file_removing(tmp_string);
	       tmp_string.remove_last(1);
	       tmp_string.remove_suffix(c_suffix);
	       tmp_string.append(o_suffix);
	       echo.file_removing(tmp_string);
	       i := i + 1;
	    else
	       i := 0;
	    end;
	 end;
	 tmp_string.copy(root);
	 tmp_string.append(h_suffix);
	 echo.file_removing(tmp_string);
	 tmp_string.copy(root);
	 tmp_string.append(c_suffix);
	 echo.file_removing(tmp_string);
	 tmp_string.copy(root);
	 tmp_string.append(make_suffix);
	 echo.file_removing(tmp_string);
      end;

end -- CLEAN -- The command.

