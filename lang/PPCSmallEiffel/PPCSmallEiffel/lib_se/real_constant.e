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
class REAL_CONSTANT
   --
   -- For Manifest Constant REAL.
   -- 
   
inherit BASE_TYPE_CONSTANT;

creation make

feature 
   
   to_string: STRING;
	 -- Cleanly written view of the constant.
	 -- ANSI C compatible.

feature 

   c_simple: BOOLEAN is true;
   
   is_static: BOOLEAN is false;
      
feature
   
   make(sp: like start_position; ts: like to_string) is
      require      
	 sp /= Void; 
	 ts /= Void
      do
	 start_position := sp; 
	 to_string := ts;
      ensure      
	 start_position = sp; 
	 to_string = ts
      end;
   
   compile_to_c is
      do
	 cpp.put_string(to_string);
      end;
   
   compile_target_to_jvm, compile_to_jvm is
      do
	 code_attribute.opcode_push_as_float(to_string);
      end;
   
   jvm_branch_if_false: INTEGER is
      do
      end;

   jvm_branch_if_true: INTEGER is
      do
      end;
   
   compile_to_jvm_into(dest: TYPE): INTEGER is
      do
	 if dest.is_real then
	    code_attribute.opcode_push_as_float(to_string);
	    Result := 1;
	 elseif dest.is_double then
	    code_attribute.opcode_push_as_double(to_string);
	    Result := 2;
	 else
	    Result := standard_compile_to_jvm_into(dest);
	 end;
      end;

feature -- Following features do not change Current :
   
   result_type: TYPE_REAL is
      once
	 !!Result.make(Void);
      end;

feature {EIFFEL_PARSER}
   
   unary_minus is
      do
	 to_string.add_first('-');
      end;

end -- REAL_CONSTANT

