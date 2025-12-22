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
class E_VOID
   --
   -- Handling of the Eiffel `Void'.
   --

inherit 
   NAME;
   EXPRESSION 
      redefine is_void
      end;
   
creation make, implicit
   
feature 

   start_position: POSITION;

feature
   
   is_static, is_void, is_pre_computable, can_be_dropped: BOOLEAN is true;
   
   use_current: BOOLEAN is false;
   
   isa_dca_inline_argument: INTEGER is -1;

feature {NONE}

   make(sp: like start_position) is
      require
	 sp /= Void
      do
	 start_position := sp;
	 to_string := us_void;
      ensure
	 sp /= Void
      end;
   
   implicit is
      do
	 to_string := us_void;
      end;

feature 

   to_key: STRING is
      do
	 Result := to_string;
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
      do
	 mapping_c_arg(formal_arg_type);
      end;

   frozen mapping_c_target(target_type: TYPE) is
      do
      end;

   frozen mapping_c_arg(formal_arg_type: TYPE) is
      do
	 compile_to_c;
      end;

   short is
      do
	 short_print.hook_or(us_void,us_void);
      end;
   
   short_target is
      do
	 short;
	 short_print.a_dot;
      end;

   compile_to_c is
      do
	 cpp.put_string("NULL");
      end;
   
   compile_to_c_old is
      do 
      end;
      
   compile_to_jvm_old is
      do 
      end;
   
   compile_target_to_jvm, compile_to_jvm is
      do
	 code_attribute.opcode_aconst_null;
      end;
   
   compile_to_jvm_assignment(a: ASSIGNMENT) is
      do
      end;
   
   jvm_branch_if_false: INTEGER is
      do
      end;

   jvm_branch_if_true: INTEGER is
      do
      end;

   compile_to_jvm_into(dest: TYPE): INTEGER is
      do
	 Result := 1;
	 compile_to_jvm;
      end;

   result_type: TYPE_NONE is
      once
	 !!Result.make(Void);
      end;
   
   to_runnable(ct: TYPE): like Current is
      do
	 if current_type = Void then
	    current_type := ct;
	    Result := Current;
	 else
	    Result := twin;
	    Result.set_current_type(ct);
	 end;
      end;
   
   print_as_target is 
      do
	 fatal_error("Internal Error #1 in E_VOID.");
      end;
   
   precedence: INTEGER is
      do
	 Result := atomic_precedence;
      end;
   
feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      do
      end;

end -- E_VOID

