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
class E_RESULT
--
-- Handling of the pseudo variable `Result'.
--

inherit 
   NAME;
   EXPRESSION
      redefine is_writable, is_result
      end;
   
creation make
   
feature 
   
   start_position: POSITION;
   
   result_type: TYPE;
   
   make(sp: like start_position) is
      require
	 sp /= Void;
      do
	 to_string := us_result;
	 start_position := sp;
      end;
   
   is_result, is_writable, can_be_dropped: BOOLEAN is true;
   
   is_static: BOOLEAN is false;

   is_pre_computable: BOOLEAN is false;

   isa_dca_inline_argument: INTEGER is 0;
	 -- *** A FAIRE ***

   to_key: STRING is
      do
	 Result := to_string;
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
	 -- *** FAIRE ***
      do
      end;

   print_as_target is
      do
	 fmt.put_string(us_result);
	 fmt.put_character('.');
      end;
   
   short is
      do
	 short_print.hook_or(us_result,us_result);
      end;

   short_target is
      do
	 short;
	 short_print.a_dot;
      end;

   to_runnable(ct: TYPE): E_RESULT is
      do
	 if current_type = Void then
	    current_type := ct;
	    result_type := small_eiffel.top_rf.result_type;
	    Result := Current;
	 else
	    !!Result.make(start_position);
	    Result := Result.to_runnable(ct);
	 end;
      end;
   
   use_current: BOOLEAN is false;
      
   frozen mapping_c_target(target_type: TYPE) is
      local
	 flag: BOOLEAN;
	 rt: like result_type;
      do
	 flag := cpp.call_invariant_start(target_type);
	 rt := result_type.run_type;
	 if rt.is_reference then
	    if target_type.is_reference then
	       -- Reference into Reference :
	       cpp.put_character('(');
	       cpp.put_character('(');
	       cpp.put_character('T');
	       cpp.put_integer(target_type.id);
	       cpp.put_character('*');
	       cpp.put_character(')');
	       compile_to_c;
	       cpp.put_character(')');
	    else
	       -- Reference into Expanded :
	       rt.to_expanded;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    end;
	 else
	    if target_type.is_reference then
	       -- Expanded into Reference :
	       rt.to_reference;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    else
	       -- Expanded into Expanded :
	       if rt.need_c_struct then
		  cpp.put_character('&');
	       end;
	       compile_to_c;
	    end;
	 end;
	 if flag then
	    cpp.call_invariant_end;
	 end;
      end;

   frozen mapping_c_arg(formal_arg_type: TYPE) is
      local
	 rt: like result_type;
      do
	 rt := result_type.run_type;
	 if rt.is_reference then
	    if formal_arg_type.is_reference then
	       -- Reference into Reference :
	       compile_to_c;
	    else
	       -- Reference into Expanded :
	       rt.to_expanded;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    end;
	 else
	    if formal_arg_type.is_reference then
	       -- Expanded into Reference :
	       rt.to_reference;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    else
	       -- Expanded into Expanded :
	       if rt.need_c_struct then
		  cpp.put_character('&');
	       end;
	       compile_to_c;
	    end;
	 end;
      end;

   compile_to_c is
      do
	 cpp.put_character('R');
      end;

   compile_to_c_old is
      do 
      end;
      
   compile_to_jvm_old is
      do 
      end;
   
   compile_to_jvm is
      local
	 jvm_offset: INTEGER;
      do
	 jvm_offset := jvm.result_offset;
	 result_type.run_type.jvm_push_local(jvm_offset);
      end;
   
   compile_target_to_jvm is
      do
	 standard_compile_target_to_jvm;
      end;
   
   compile_to_jvm_assignment(a: ASSIGNMENT) is
      local
	 space, jvm_offset: INTEGER;
      do
	 jvm_offset := jvm.result_offset;
	 space := a.right_side.compile_to_jvm_into(result_type.run_type);
	 result_type.run_type.jvm_write_local(jvm_offset)
      end;
   
   jvm_branch_if_false: INTEGER is
      do
	 compile_to_jvm;
	 Result := code_attribute.opcode_ifeq;
      end;

   jvm_branch_if_true: INTEGER is
      do
	 compile_to_jvm;
	 Result := code_attribute.opcode_ifne;
      end;

   compile_to_jvm_into(dest: TYPE): INTEGER is
      do
	 Result := standard_compile_to_jvm_into(dest);
      end;

   precedence: INTEGER is
      do
	 Result := atomic_precedence;
      end;

feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      local
	 jvm_offset: INTEGER;
      do
	 jvm_offset := jvm.result_offset;
	 result_type.run_type.jvm_write_local(jvm_offset)
      end;

invariant
   
   start_position /= Void
   
end -- E_RESULT

