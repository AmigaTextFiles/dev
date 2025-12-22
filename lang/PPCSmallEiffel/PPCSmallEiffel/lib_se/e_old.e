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
class E_OLD
   --
   -- To store instruction "old ..." usable in an ensure clause.
   --
   
inherit EXPRESSION;
   
creation make

feature 
   
   expression: EXPRESSION;
	       
feature {NONE}

   id: INTEGER;
	 -- Used both in C or Java byte code to gives a number to the
	 -- the extra local variable.

feature
	       
   make(exp: like expression) is
      require
	 exp /= Void
      do
	 expression := exp;
      ensure
	 expression = exp;
      end;
   
feature

   is_static: BOOLEAN is false;

   is_pre_computable: BOOLEAN is false;

   can_be_dropped: BOOLEAN is false;

   c_simple: BOOLEAN is false;

   isa_dca_inline_argument: INTEGER is 0;
   
   dca_inline_argument(formal_arg_type: TYPE) is
      do
      end;

feature

   result_type: TYPE is
      do
	 Result := expression.result_type;
      end;
   
   afd_check is
      do
	 expression.afd_check;
      end;
   
   to_runnable(ct: TYPE): like Current is
      local
	 exp: like expression;
      do
	 if current_type = Void then
	    current_type := ct;
	    exp := expression.to_runnable(ct);
	    if exp = Void then
	       error(start_position,"Bad old expression.");
	    else
	       expression := exp;
	    end;
	    id_counter.increment;  -- *** NOT INCREMENTAL GCC
	    id := id_counter.value;-- ***********************
	    Result := Current;
	 else
	    !!Result.make(expression);
	    Result := Result.to_runnable(ct);
	 end;
      end;
   
   start_position: POSITION is
      do
	 Result := expression.start_position;
      end;
   
   pretty_print is
      do
	 fmt.put_string("old ");
	 fmt.level_incr;
	 expression.pretty_print;
	 fmt.level_decr;
      end;

   print_as_target is
      do
	 fmt.put_character('(');
	 pretty_print;
	 fmt.put_character(')');
	 fmt.put_character('.');
      end;
   
   bracketed_pretty_print is
      do
	 fmt.put_character('(');
	 pretty_print;
	 fmt.put_character(')');
      end;

   short is
      do
	 short_print.hook_or("old","old ");
	 expression.short;
      end;

   short_target is
      do
	 bracketed_short;
	 short_print.a_dot;
      end;
   
   precedence: INTEGER is
      do
	 Result := 11;
      end;
   
feature 
   
   frozen mapping_c_target(target_type: TYPE) is
      do
	 compile_to_c;
      end;

   frozen mapping_c_arg(formal_arg_type: TYPE) is
      do
	 compile_to_c;
      end;

   compile_to_c_old is 
      local
	 t: TYPE;
      do
	 t := result_type.run_type;
	 tmp_string.clear;
	 t.c_type_for_argument_in(tmp_string);
	 tmp_string.extend(' ');
	 tmp_string.extend('o');
	 id.append_in(tmp_string);
	 tmp_string.extend('=');
	 cpp.put_string(tmp_string);
	 expression.mapping_c_arg(t);
	 cpp.put_string(fz_00);
      end;
   
   compile_to_c is
      do
	 cpp.put_character('o');
	 cpp.put_integer(id);
      end;
   
   compile_to_jvm_old is
      local
	 e: like expression;
	 rt: TYPE;
      do 
	 e := expression;
	 rt := e.result_type.run_type;
	 id := code_attribute.extra_local(rt);
	 e.compile_to_jvm;
	 rt.jvm_write_local(id);
      end;

   compile_to_jvm is
      do
	 expression.result_type.jvm_push_local(id);
      end;
   
   compile_target_to_jvm is
      do
	 standard_compile_target_to_jvm;
      end;
   
   jvm_branch_if_false: INTEGER is
      do
	 Result := jvm_standard_branch_if_false;
      end;

   jvm_branch_if_true: INTEGER is
      do
	 Result := jvm_standard_branch_if_true;
      end;
   
   compile_to_jvm_into(dest: TYPE): INTEGER is
      do
	 Result := standard_compile_to_jvm_into(dest);
      end;

   compile_to_jvm_assignment(a: ASSIGNMENT) is
      do
      end;
   
   use_current: BOOLEAN is
      do
	 Result := expression.use_current;
      end;
   
feature {NONE}

   id_counter: COUNTER is
      once
	 !!Result;
      end;
   
   tmp_string: STRING is
      once
	 !!Result.make(12);
      end;

feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      do
      end;

invariant 
   
   expression /= Void;
   
end -- E_OLD

