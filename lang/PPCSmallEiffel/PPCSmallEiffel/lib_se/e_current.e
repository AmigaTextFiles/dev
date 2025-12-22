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
class E_CURRENT
   --   
   -- Handling of the pseudo variable "Current".
   --

inherit 
   NAME 
      redefine pretty_print
      end;
   EXPRESSION 
      redefine pretty_print, is_current
      end;
   
creation make
   
feature 

   is_written: BOOLEAN;
	 -- True when it is a really written Current.

   start_position: POSITION;

feature {NONE}
   
   make(sp: like start_position; written: BOOLEAN) is
      require
	 sp /= Void
      do
	 start_position := sp;
	 is_written := written;
	 to_string := us_current;
      ensure
	 start_position = sp;
	 is_written = written
      end;
   
feature 

   is_current, can_be_dropped, use_current: BOOLEAN is true;
   
   is_static: BOOLEAN is false;
   
   is_pre_computable: BOOLEAN is false;

   isa_dca_inline_argument: INTEGER is 0;

feature 

   to_key: STRING is
      do
	 Result := to_string;
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
      do
      end;

   frozen mapping_c_target(target_type: TYPE) is
      local
	 flag: BOOLEAN;
      do
	 if is_written then
	    flag := cpp.call_invariant_start(target_type);
	 end;
	 cpp.print_current;
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
	       cpp.put_string(fz_cast_t0_star);
	       cpp.print_current;
	    else
	       -- Reference into Expanded :
	       rt.to_expanded;
	       cpp.put_character('(');
	       cpp.print_current;
	       cpp.put_character(')');
	    end;
	 else
	    if formal_arg_type.is_reference then
	       -- Expanded into Reference :
	       rt.to_reference;
	       cpp.put_character('(');
	       cpp.print_current;
	       cpp.put_character(')');
	    else
	       -- Expanded into Expanded :
	       cpp.print_current;
	    end;
	 end;
      end;

   compile_to_c_old is
      do 
      end;
      
   compile_to_jvm_old is
      do 
      end;
   
   compile_to_c is
      do
	 if result_type.is_user_expanded then
	    cpp.put_character('*');
	 end;
	 cpp.print_current;
      end;
   
   compile_to_jvm is
      do
	 result_type.jvm_push_local(0);
      end;
   
   compile_target_to_jvm is
      do
	 if is_written then
	    standard_compile_target_to_jvm;
	 else
	    compile_to_jvm;
	 end;
      end;
   
   compile_to_jvm_assignment(a: ASSIGNMENT) is
      do
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

   result_type: TYPE is
      do
	 Result := current_type;
      end;
   
   to_runnable(ct: TYPE): like Current is
      do
	 if current_type = Void then
	    current_type := ct;
	    Result := Current
	 elseif current_type = ct then
	    Result := Current
	 else
	    !!Result.make(start_position,is_written);
	    Result.set_current_type(ct);
	 end;
      end;
   
   precedence: INTEGER is
      do
	 Result := atomic_precedence;
      end;
   
   pretty_print is
      do
	 fmt.put_string(us_current);
      end;
   
   print_as_target is
      do
	 if is_written or else fmt.print_current then
	    fmt.put_string(us_current);
	    fmt.put_character('.');
	 end;
      end;
   
   short is
      do
	 short_print.hook_or(us_current,us_current);
      end;
   
   short_target is
      do
	 if is_written then
	    short;
	    short_print.a_dot;
	 end;
      end;
feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      do
      end;

invariant

   start_position /= Void;

end -- E_CURRENT

